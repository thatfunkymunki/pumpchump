require 'cinch'
require 'uri'
require 'net/http'
require 'json'

class PumpChump
  include Cinch::Plugin
  match "where", method: :where
  match /animal (.+)/, method: :animal
  match /adjective (.+)/, method: :adjective
  match /noun (.+)/, method: :noun
  match /dbdump/, method: :dbdump

  def animal(m, animal)
    uri=URI.parse('http://localhost:5000/animal')
    response = Net::HTTP.post_form(uri, {"animal" => animal})
    m.reply "animal" unless response.body !~ /success/
  end
  def adjective(m, adjective)
    uri=URI.parse('http://localhost:5000/adjective')
    response = Net::HTTP.post_form(uri, {"adjective" => adjective}) 
    m.reply "adjective" unless response.body() !~ /success/ 
  end
  def noun(m, noun)
    uri=URI.parse('http://localhost:5000/noun')
    response = Net::HTTP.post_form(uri, {"noun" => noun}) 
    m.reply "noun" unless response.body !~ /success/
  end
  def dbdump(m)
    uri=URI.parse('http://localhost:5000/db.json')
    response = Net::HTTP.get(uri)
    m.reply JSON.parse(response).to_s
  end


  def where(m)
    m.reply "I'm in the parking lot"
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = "pumpchump"
    c.server = "irc.supernets.org"
    c.channels = ["#testtest"]
    c.plugins.plugins = [PumpChump]
  end
end
bot.start


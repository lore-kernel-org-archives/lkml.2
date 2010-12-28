Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0L1PJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 10:09:34 -0500
Received: from 31.mail-out.ovh.net ([213.186.62.10]:34700 "HELO
	31.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752625Ab0L1PJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 10:09:31 -0500
Message-ID: <4D19FDA5.6040601@example.com>
Date: Tue, 28 Dec 2010 16:09:25 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 27
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>	<4D18A480.2060309@example.com>	<AANLkTi=WhSP1ceHBW95n1e-gHwwnt36h3czFGuKsEny6@mail.gmail.com>	<4D18A972.1020205@example.com>	<AANLkTikCeqCLmDJAnf9uT6wW+OLkRop-FJ9MDrMM_oX7@mail.gmail.com>	<4D18AD30.9070707@example.com>	<4D18B4A2.1030107@example.com> <AANLkTim1Cj1rbgnFr6C7==UP+jiriJ55Kcu9wmgd+DKh@mail.gmail.com> <4D19F3C1.8010208@example.com>
In-Reply-To: <4D19F3C1.8010208@example.com>
Content-Type: multipart/mixed;
 boundary="------------080202010402000604020706"
X-Ovh-Tracer-Id: 18277296138287739250
X-Ovh-Remote: 83.24.91.46 (dnj46.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080202010402000604020706
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit

On 28.12.2010 15:27, Piotr Hosowicz wrote:
> On 27.12.2010 17:16, Sedat Dilek wrote:
>> 2010/12/27 Piotr Hosowicz<piotr@hosowicz.com>:
>>> On 27.12.2010 16:13, Piotr Hosowicz wrote:
>>>>
>>>> On 27.12.2010 16:08, Sedat Dilek wrote:
>>>>>
>>>>> 2010/12/27 Piotr Hosowicz<piotr@hosowicz.com>:
>>>>>>
>>>>>> On 27.12.2010 15:48, Sedat Dilek wrote:
>>>>>>>
>>>>>>> 2010/12/27 Piotr Hosowicz<piotr@hosowicz.com>:
>>>>>>>>
>>>>>>>> On 27.12.2010 07:04, Stephen Rothwell wrote:
>>>>>>>>
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> I noticed that after first reboot with this kernel that my MP3
>>>>>>>> collection
>>>>>>>> in
>>>>>>>> mocp layed on Ext4 fs opens painfully slow. It is not my mistake,
>>>>>>>> because
>>>>>>>> I
>>>>>>>> always do it the same way, new kernel, then music on. The problem
>>>>>>>> is not
>>>>>>>> present in rc7-git4. I could measure it in some way (timing ls -la
>>>>>>>> in tht
>>>>>>>> dir?) if somebody needs it.
>>>>>>>>
>>>>>>>> Regards,
>>>>>>>>
>>>>>>>> Piotr Hosowicz
>>>>>>>>
>>>>>>>
>>>>>>> You tried mblk_io_submit mount-option for that partition?
>>>>>>
>>>>>> No, I do not use it, I do not even know what it is. My options are:
>>>>>>
>>>>>> /dev/sda2 on / type ext4 (rw,errors=remount-ro)
>>>>>>
>>>>>
>>>>> Have a closer look at "ext4: Turn off multiple page-io submission by
>>>>> default"
>>>>
>>>> I tried to Google for mblk_io_submit but I didn't find anything
>>>> helpful.
>>>> Could you tell me how should I add this option in fstab and what
>>>> will be
>>>> its effect?
>>>
>>> As far as I understand that option regards writing, not reading. The
>>> symptoms I described occured while reading only.
>>>
>>
>> That's the only performance issue I am aware of in ext4 in recent time.
>> Why don't you try it and present some numbers in transfer ratio
>> (write, read)?
>
> Ok, I'll try to measure it in shell. Now I am building newest non-next
> kernel and the trial script is:
>
> #!/bin/bash
>
> uname -a
> mount
> cd /data/music
> time ls -d *
> cd -
>
> This is basically what mocp does when it enters my music directory,
> apart from displaying the results in ncurses based UI. Then I'll reboot
> with next kernel and run it again. Will it do?

Sorry for the desinformation, now I see that there must be some othe 
things that mocp does because when I measured it I see that my initial 
observaions were false. The script is attached, plain is the newest 
ordinary kernel 2.6.37-rc7-git5, _1 file is the first run, _2 is the 
second run. Similarily the next_ files, after mounting / with the option 
in question. They show no big difference between the kernels.

Regards,

Piotr Hosowicz

-- 
Babcia rox! :
alek:   przyszli do mnie jehowi dzisiaj, otworzy³a babcia
pate_q: i co?
alek:   po 30 minutach rozmowy chcieli przej¶æ na chrze¶cijañstwo
NP: Peter Green Splinter Group - Heart Of Stone
NB: 2.6.37-rc7-git5

--------------080202010402000604020706
Content-Type: text/plain;
 name="next_1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="next_1.txt"

Linux aapi205 2.6.37-rc7-next-20101227 #1 SMP PREEMPT Mon Dec 27 14:51:27 CET 2010 x86_64 GNU/Linux
/dev/sda2 on / type ext4 (rw,mblk_io_submit,errors=remount-ro)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
/dev/sda1 on /boot type ext3 (rw)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,noexec,nosuid,nodev)
12 Stones
ACDC
Acid Drinkers
Adrian Belew
Aerosmith
Alexis Corner
Alice in Chains
Allman Brothers Band
Anathema
Anita Lipnicka
Anthrax
Arena
Audioslave
Aynsley Lister
Ayreon
Bad Company
Beck
Beck, Bogert & Appice
Billie Holiday
Biohazard
Blackmore's Night
Blackout
Black Label Society
Black Sabbath
Black Stone Cherry
Blind Faith
Blues Saraceno
Bobby McFerrin
Bob Dylan
Bon Jovi
Breakout
Brecker Brothers
Bruce, Baker & Moore
Buckethead
Buddy Guy
Budgie
Buena Vista Social Club
Cactus
Callisto
Carmine Appice
Chevelle
Chickenfoot
Chick Corea
Choralne
Chyla
Cinderella
Clawfinger
Coroner
Cream
Creedence Clearwater Revival
Czeslaw Niemen
Damageplan
Dave Matthews Band
Dave Navarro
Dave Weckl
David Gilmour
Debussy
Debussy Faure Ravel
Deep Purple
Def Leppard
Diana Krall
DiMeola, McLaughlin, Delucia
Dire Straits
Dream Theater
Dzem
Eddie Daniels
Edward Stachura
Enya
Eric Clapton
Eric Johnson
Eric Sardinas
Eva Cassidy
Faith No More
Fishbone
Frank Gambale
Frank Zappa
G3
Gary Moore
Genesis
Godflesh
Gordian Knot
Gordon Haskell
Granda Banda
Grzegorz Turnau
Guano Apes
Guns and Roses
Hey
Hipshack
Holdys.com
Ian Anderson
Ian Gillan
Iron Butterfly
Jacek Skubikowski
Jack Bruce
Janes Addiction
Jan Borysewicz
Jan Garbarek
Jefferson Airplane
Jeff Beck
Jethro Tull
Jimi Hendrix
Jimmy Page
Jimmy Page & Robert Plant
Joe Bonamassa
Joe Satriani
Joe Zawinul
John Cage
John Coltrane
John Lee Hooker
John Mayall
John Petrucci
John Scofield
John Scofield & Pat Metheny
John Wetton
J. B. Lenoir
Kazik
Kenny Kirkland
King's X
King Crimson
Korn
Krzak
Kyuss
Lao Che
LA Guitar Quartet
Lebowski
Led Zeppelin
Lenny Kravitz
Leszek Cichonski
Les Claypool
Limp Bizkit
Linkin Park
lista-dla-paczora.txt
lista-dla-rafala.txt
Living Colour
Lost Tribe
Louis Armstrong
Lynyrd Skynyrd
Mad Season
Makefile
Mark Knopfler
Matilde Santing
McDonald And Giles
Megadeth
Metallica
Michael Nyman
_moje-mp3-zbackupowac
Mother Love Bone
Motorhead
Mr Big
Muddy Waters
_music-do-obrobienia
_music-zgrane-z-cd
Norah Jones
Normalsi
_nowe_od_marcina
ONA
Ozzy Osbourne
Paco De Lucia
Pantera
Patrick O'Hearn
Pat Metheny
Pat Travers
Pearl Jam
Peter Green Splinter Group
Pink Floyd
Piotr Hosowicz
Popa Chubby
Porcupine Tree
Primus
Puddle Of Mudd
Rage Against the Machine
Rainbow
Red Hot Chilli Peppers
Red Sparowes
Riverside
Robben Ford
Robert Cray
Robert Fripp
Robert Plant
Roger Waters
Rollins Band
Rory Gallagher
Rush
SBB
Screaming Trees
Sepultura
Shotgun Messiah
Simon and Garfunkel
Skid Row
Slash
Slash's Snakepit
Slayer
_smietnik
Soundgarden
Spiritual Beggars
Spyro Gyra
Stanislaw Sojka
Stare Dobre Malzenstwo
Steve Hackett
Steve Vai
Stevie Ray Vaughan
Sylvan
Sztywny Pal Azji
Temple Of The Dog
Testament
The Beatles
The Cult
The The
The Who
Thursday Group
Tom Waits
Tool
Toto
Traffic
Transatlantic
Trey Gunn
TSA
Ugly Kid Joe
_uptbo
uptbo-refresh.sh
Urszula
Vanilla Fudge
Van Halen
Velvet Revolver
Weather Report
wma-to-ogg.sh
Wolna Grupa Bukowina
Yellow Jackets
Yes
Zakk Wylde
ZZ Top
/home/phz/workspace/ext4-test

--------------080202010402000604020706
Content-Type: text/plain;
 name="next_2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="next_2.txt"

Linux aapi205 2.6.37-rc7-next-20101227 #1 SMP PREEMPT Mon Dec 27 14:51:27 CET 2010 x86_64 GNU/Linux
/dev/sda2 on / type ext4 (rw,mblk_io_submit,errors=remount-ro)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
/dev/sda1 on /boot type ext3 (rw)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,noexec,nosuid,nodev)
12 Stones
ACDC
Acid Drinkers
Adrian Belew
Aerosmith
Alexis Corner
Alice in Chains
Allman Brothers Band
Anathema
Anita Lipnicka
Anthrax
Arena
Audioslave
Aynsley Lister
Ayreon
Bad Company
Beck
Beck, Bogert & Appice
Billie Holiday
Biohazard
Blackmore's Night
Blackout
Black Label Society
Black Sabbath
Black Stone Cherry
Blind Faith
Blues Saraceno
Bobby McFerrin
Bob Dylan
Bon Jovi
Breakout
Brecker Brothers
Bruce, Baker & Moore
Buckethead
Buddy Guy
Budgie
Buena Vista Social Club
Cactus
Callisto
Carmine Appice
Chevelle
Chickenfoot
Chick Corea
Choralne
Chyla
Cinderella
Clawfinger
Coroner
Cream
Creedence Clearwater Revival
Czeslaw Niemen
Damageplan
Dave Matthews Band
Dave Navarro
Dave Weckl
David Gilmour
Debussy
Debussy Faure Ravel
Deep Purple
Def Leppard
Diana Krall
DiMeola, McLaughlin, Delucia
Dire Straits
Dream Theater
Dzem
Eddie Daniels
Edward Stachura
Enya
Eric Clapton
Eric Johnson
Eric Sardinas
Eva Cassidy
Faith No More
Fishbone
Frank Gambale
Frank Zappa
G3
Gary Moore
Genesis
Godflesh
Gordian Knot
Gordon Haskell
Granda Banda
Grzegorz Turnau
Guano Apes
Guns and Roses
Hey
Hipshack
Holdys.com
Ian Anderson
Ian Gillan
Iron Butterfly
Jacek Skubikowski
Jack Bruce
Janes Addiction
Jan Borysewicz
Jan Garbarek
Jefferson Airplane
Jeff Beck
Jethro Tull
Jimi Hendrix
Jimmy Page
Jimmy Page & Robert Plant
Joe Bonamassa
Joe Satriani
Joe Zawinul
John Cage
John Coltrane
John Lee Hooker
John Mayall
John Petrucci
John Scofield
John Scofield & Pat Metheny
John Wetton
J. B. Lenoir
Kazik
Kenny Kirkland
King's X
King Crimson
Korn
Krzak
Kyuss
Lao Che
LA Guitar Quartet
Lebowski
Led Zeppelin
Lenny Kravitz
Leszek Cichonski
Les Claypool
Limp Bizkit
Linkin Park
lista-dla-paczora.txt
lista-dla-rafala.txt
Living Colour
Lost Tribe
Louis Armstrong
Lynyrd Skynyrd
Mad Season
Makefile
Mark Knopfler
Matilde Santing
McDonald And Giles
Megadeth
Metallica
Michael Nyman
_moje-mp3-zbackupowac
Mother Love Bone
Motorhead
Mr Big
Muddy Waters
_music-do-obrobienia
_music-zgrane-z-cd
Norah Jones
Normalsi
_nowe_od_marcina
ONA
Ozzy Osbourne
Paco De Lucia
Pantera
Patrick O'Hearn
Pat Metheny
Pat Travers
Pearl Jam
Peter Green Splinter Group
Pink Floyd
Piotr Hosowicz
Popa Chubby
Porcupine Tree
Primus
Puddle Of Mudd
Rage Against the Machine
Rainbow
Red Hot Chilli Peppers
Red Sparowes
Riverside
Robben Ford
Robert Cray
Robert Fripp
Robert Plant
Roger Waters
Rollins Band
Rory Gallagher
Rush
SBB
Screaming Trees
Sepultura
Shotgun Messiah
Simon and Garfunkel
Skid Row
Slash
Slash's Snakepit
Slayer
_smietnik
Soundgarden
Spiritual Beggars
Spyro Gyra
Stanislaw Sojka
Stare Dobre Malzenstwo
Steve Hackett
Steve Vai
Stevie Ray Vaughan
Sylvan
Sztywny Pal Azji
Temple Of The Dog
Testament
The Beatles
The Cult
The The
The Who
Thursday Group
Tom Waits
Tool
Toto
Traffic
Transatlantic
Trey Gunn
TSA
Ugly Kid Joe
_uptbo
uptbo-refresh.sh
Urszula
Vanilla Fudge
Van Halen
Velvet Revolver
Weather Report
wma-to-ogg.sh
Wolna Grupa Bukowina
Yellow Jackets
Yes
Zakk Wylde
ZZ Top
/home/phz/workspace/ext4-test

--------------080202010402000604020706
Content-Type: text/plain;
 name="plain_1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="plain_1.txt"

Linux aapi205 2.6.37-rc7-git5 #1 SMP PREEMPT Tue Dec 28 15:09:12 CET 2010 x86_64 GNU/Linux
/dev/sda2 on / type ext4 (rw,errors=remount-ro)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
/dev/sda1 on /boot type ext3 (rw)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,noexec,nosuid,nodev)
12 Stones
ACDC
Acid Drinkers
Adrian Belew
Aerosmith
Alexis Corner
Alice in Chains
Allman Brothers Band
Anathema
Anita Lipnicka
Anthrax
Arena
Audioslave
Aynsley Lister
Ayreon
Bad Company
Beck
Beck, Bogert & Appice
Billie Holiday
Biohazard
Blackmore's Night
Blackout
Black Label Society
Black Sabbath
Black Stone Cherry
Blind Faith
Blues Saraceno
Bobby McFerrin
Bob Dylan
Bon Jovi
Breakout
Brecker Brothers
Bruce, Baker & Moore
Buckethead
Buddy Guy
Budgie
Buena Vista Social Club
Cactus
Callisto
Carmine Appice
Chevelle
Chickenfoot
Chick Corea
Choralne
Chyla
Cinderella
Clawfinger
Coroner
Cream
Creedence Clearwater Revival
Czeslaw Niemen
Damageplan
Dave Matthews Band
Dave Navarro
Dave Weckl
David Gilmour
Debussy
Debussy Faure Ravel
Deep Purple
Def Leppard
Diana Krall
DiMeola, McLaughlin, Delucia
Dire Straits
Dream Theater
Dzem
Eddie Daniels
Edward Stachura
Enya
Eric Clapton
Eric Johnson
Eric Sardinas
Eva Cassidy
Faith No More
Fishbone
Frank Gambale
Frank Zappa
G3
Gary Moore
Genesis
Godflesh
Gordian Knot
Gordon Haskell
Granda Banda
Grzegorz Turnau
Guano Apes
Guns and Roses
Hey
Hipshack
Holdys.com
Ian Anderson
Ian Gillan
Iron Butterfly
Jacek Skubikowski
Jack Bruce
Janes Addiction
Jan Borysewicz
Jan Garbarek
Jefferson Airplane
Jeff Beck
Jethro Tull
Jimi Hendrix
Jimmy Page
Jimmy Page & Robert Plant
Joe Bonamassa
Joe Satriani
Joe Zawinul
John Cage
John Coltrane
John Lee Hooker
John Mayall
John Petrucci
John Scofield
John Scofield & Pat Metheny
John Wetton
J. B. Lenoir
Kazik
Kenny Kirkland
King's X
King Crimson
Korn
Krzak
Kyuss
Lao Che
LA Guitar Quartet
Lebowski
Led Zeppelin
Lenny Kravitz
Leszek Cichonski
Les Claypool
Limp Bizkit
Linkin Park
lista-dla-paczora.txt
lista-dla-rafala.txt
Living Colour
Lost Tribe
Louis Armstrong
Lynyrd Skynyrd
Mad Season
Makefile
Mark Knopfler
Matilde Santing
McDonald And Giles
Megadeth
Metallica
Michael Nyman
_moje-mp3-zbackupowac
Mother Love Bone
Motorhead
Mr Big
Muddy Waters
_music-do-obrobienia
_music-zgrane-z-cd
Norah Jones
Normalsi
_nowe_od_marcina
ONA
Ozzy Osbourne
Paco De Lucia
Pantera
Patrick O'Hearn
Pat Metheny
Pat Travers
Pearl Jam
Peter Green Splinter Group
Pink Floyd
Piotr Hosowicz
Popa Chubby
Porcupine Tree
Primus
Puddle Of Mudd
Rage Against the Machine
Rainbow
Red Hot Chilli Peppers
Red Sparowes
Riverside
Robben Ford
Robert Cray
Robert Fripp
Robert Plant
Roger Waters
Rollins Band
Rory Gallagher
Rush
SBB
Screaming Trees
Sepultura
Shotgun Messiah
Simon and Garfunkel
Skid Row
Slash
Slash's Snakepit
Slayer
_smietnik
Soundgarden
Spiritual Beggars
Spyro Gyra
Stanislaw Sojka
Stare Dobre Malzenstwo
Steve Hackett
Steve Vai
Stevie Ray Vaughan
Sylvan
Sztywny Pal Azji
Temple Of The Dog
Testament
The Beatles
The Cult
The The
The Who
Thursday Group
Tom Waits
Tool
Toto
Traffic
Transatlantic
Trey Gunn
TSA
Ugly Kid Joe
_uptbo
uptbo-refresh.sh
Urszula
Vanilla Fudge
Van Halen
Velvet Revolver
Weather Report
wma-to-ogg.sh
Wolna Grupa Bukowina
Yellow Jackets
Yes
Zakk Wylde
ZZ Top
/home/phz/workspace/ext4-test

--------------080202010402000604020706
Content-Type: text/plain;
 name="plain_2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="plain_2.txt"

Linux aapi205 2.6.37-rc7-git5 #1 SMP PREEMPT Tue Dec 28 15:09:12 CET 2010 x86_64 GNU/Linux
/dev/sda2 on / type ext4 (rw,errors=remount-ro)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
/dev/sda1 on /boot type ext3 (rw)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,noexec,nosuid,nodev)
12 Stones
ACDC
Acid Drinkers
Adrian Belew
Aerosmith
Alexis Corner
Alice in Chains
Allman Brothers Band
Anathema
Anita Lipnicka
Anthrax
Arena
Audioslave
Aynsley Lister
Ayreon
Bad Company
Beck
Beck, Bogert & Appice
Billie Holiday
Biohazard
Blackmore's Night
Blackout
Black Label Society
Black Sabbath
Black Stone Cherry
Blind Faith
Blues Saraceno
Bobby McFerrin
Bob Dylan
Bon Jovi
Breakout
Brecker Brothers
Bruce, Baker & Moore
Buckethead
Buddy Guy
Budgie
Buena Vista Social Club
Cactus
Callisto
Carmine Appice
Chevelle
Chickenfoot
Chick Corea
Choralne
Chyla
Cinderella
Clawfinger
Coroner
Cream
Creedence Clearwater Revival
Czeslaw Niemen
Damageplan
Dave Matthews Band
Dave Navarro
Dave Weckl
David Gilmour
Debussy
Debussy Faure Ravel
Deep Purple
Def Leppard
Diana Krall
DiMeola, McLaughlin, Delucia
Dire Straits
Dream Theater
Dzem
Eddie Daniels
Edward Stachura
Enya
Eric Clapton
Eric Johnson
Eric Sardinas
Eva Cassidy
Faith No More
Fishbone
Frank Gambale
Frank Zappa
G3
Gary Moore
Genesis
Godflesh
Gordian Knot
Gordon Haskell
Granda Banda
Grzegorz Turnau
Guano Apes
Guns and Roses
Hey
Hipshack
Holdys.com
Ian Anderson
Ian Gillan
Iron Butterfly
Jacek Skubikowski
Jack Bruce
Janes Addiction
Jan Borysewicz
Jan Garbarek
Jefferson Airplane
Jeff Beck
Jethro Tull
Jimi Hendrix
Jimmy Page
Jimmy Page & Robert Plant
Joe Bonamassa
Joe Satriani
Joe Zawinul
John Cage
John Coltrane
John Lee Hooker
John Mayall
John Petrucci
John Scofield
John Scofield & Pat Metheny
John Wetton
J. B. Lenoir
Kazik
Kenny Kirkland
King's X
King Crimson
Korn
Krzak
Kyuss
Lao Che
LA Guitar Quartet
Lebowski
Led Zeppelin
Lenny Kravitz
Leszek Cichonski
Les Claypool
Limp Bizkit
Linkin Park
lista-dla-paczora.txt
lista-dla-rafala.txt
Living Colour
Lost Tribe
Louis Armstrong
Lynyrd Skynyrd
Mad Season
Makefile
Mark Knopfler
Matilde Santing
McDonald And Giles
Megadeth
Metallica
Michael Nyman
_moje-mp3-zbackupowac
Mother Love Bone
Motorhead
Mr Big
Muddy Waters
_music-do-obrobienia
_music-zgrane-z-cd
Norah Jones
Normalsi
_nowe_od_marcina
ONA
Ozzy Osbourne
Paco De Lucia
Pantera
Patrick O'Hearn
Pat Metheny
Pat Travers
Pearl Jam
Peter Green Splinter Group
Pink Floyd
Piotr Hosowicz
Popa Chubby
Porcupine Tree
Primus
Puddle Of Mudd
Rage Against the Machine
Rainbow
Red Hot Chilli Peppers
Red Sparowes
Riverside
Robben Ford
Robert Cray
Robert Fripp
Robert Plant
Roger Waters
Rollins Band
Rory Gallagher
Rush
SBB
Screaming Trees
Sepultura
Shotgun Messiah
Simon and Garfunkel
Skid Row
Slash
Slash's Snakepit
Slayer
_smietnik
Soundgarden
Spiritual Beggars
Spyro Gyra
Stanislaw Sojka
Stare Dobre Malzenstwo
Steve Hackett
Steve Vai
Stevie Ray Vaughan
Sylvan
Sztywny Pal Azji
Temple Of The Dog
Testament
The Beatles
The Cult
The The
The Who
Thursday Group
Tom Waits
Tool
Toto
Traffic
Transatlantic
Trey Gunn
TSA
Ugly Kid Joe
_uptbo
uptbo-refresh.sh
Urszula
Vanilla Fudge
Van Halen
Velvet Revolver
Weather Report
wma-to-ogg.sh
Wolna Grupa Bukowina
Yellow Jackets
Yes
Zakk Wylde
ZZ Top
/home/phz/workspace/ext4-test

--------------080202010402000604020706
Content-Type: application/x-sh;
 name="test.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test.sh"

#!/bin/bash

# mblk_io_submit option !

uname -a
mount
cd /data/music
time ls -d *
cd -

--------------080202010402000604020706--

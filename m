Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1GSHh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 03:37:59 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13025 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1GSHh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 03:37:58 -0400
Date: Tue, 19 Jul 2011 09:37:55 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-media@vger.kernel.org
cc: Michael Krufky <mkrufky@linuxtv.org>, Mike Isely <isely@pobox.com>,
        Aurelien Alleaume <slts@free.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Hauppauge model 73219 rev D1F5 tuner doesn't detect signal, older
 rev D1E9 works
Message-ID: <alpine.LNX.2.00.1107151455140.28453@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have a bunch of Hauppauge HVR-1900 model 73219's, some are revision D1E9 
and work perfectly, but with the newer revision D1F5's the tuner fails to 
detect a signal and consequently just gives me blank output on 
/dev/video0. Other input sources, like composite or s-video, work just 
fine on the new revision, it's just the tuner that does not work.

I'm 100% certain that there is a live signal since I can use the same 
source successfully with a D1E9 and then move it to a D1F5 and see it 
fail. I've also tried both with a real TV signal and with a signal 
generator (so I could be 100% certain what signal was generated and at 
what frequency etc).
I'm also fairly certain that it's not just a case of a random broken 
D1F5 since I have several and they all behave identically (and the driver 
doesn't complain about broken hardware).

Here's what I get in dmesg when plugging one of the newer, non-working, 
devices into my laptop (running 2.6.39.3 by the way):

[43171.480193] pvrusb2: Device being rendered inoperable
[43173.195741] usb 1-1.1: new high speed USB device number 21 using ehci_hcd
[43173.289999] pvrusb2: Hardware description: WinTV HVR-1900 Model 73xxx
[43173.321796] pvrusb2: Binding ir_rx_z8f0811_haup to i2c address 0x71.
[43173.321817] pvrusb2: Binding ir_tx_z8f0811_haup to i2c address 0x70.
[43173.325212] cx25840 18-0044: cx25843-24 found @ 0x88 (pvrusb2_a)
[43173.335618] pvrusb2: Attached sub-driver cx25840
[43173.339439] tuner 18-0042: Tuner -1 found with type(s) Radio TV.
[43173.339448] pvrusb2: Attached sub-driver tuner
[43175.538224] cx25840 18-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
[43175.641103] tveeprom 18-00a2: Hauppauge model 73219, rev D1F5, serial# 6569758
[43175.641109] tveeprom 18-00a2: MAC address is 00:0d:fe:64:3f:1e
[43175.641114] tveeprom 18-00a2: tuner model is NXP 18271C2 (idx 155, type 54)
[43175.641119] tveeprom 18-00a2: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[43175.641124] tveeprom 18-00a2: audio processor is CX25843 (idx 37)
[43175.641128] tveeprom 18-00a2: decoder processor is CX25843 (idx 30)
[43175.641132] tveeprom 18-00a2: has radio, has IR receiver, has IR transmitter
[43175.641142] pvrusb2: Supported video standard(s) reported available in hardware: PAL-B/B1/D/D1/G/H/I/K;SECAM-B/D/G/H/K/K
[43175.641152] pvrusb2: Mapping standards mask=0x3ff00ff (PAL-B/B1/D/D1/G/H/I/K;SECAM-B/D/G/H/K/K1/L/LC;ATSC-8VSB/16VSB)
[43175.641156] pvrusb2: Setting up 20 unique standard(s)
[43175.641161] pvrusb2: Set up standard idx=0 name=PAL-B/G
[43175.641165] pvrusb2: Set up standard idx=1 name=PAL-D/K
[43175.641169] pvrusb2: Set up standard idx=2 name=SECAM-B/G
[43175.641172] pvrusb2: Set up standard idx=3 name=SECAM-D/K
[43175.641176] pvrusb2: Set up standard idx=4 name=PAL-B
[43175.641179] pvrusb2: Set up standard idx=5 name=PAL-B1
[43175.641182] pvrusb2: Set up standard idx=6 name=PAL-G
[43175.641185] pvrusb2: Set up standard idx=7 name=PAL-H
[43175.641189] pvrusb2: Set up standard idx=8 name=PAL-I
[43175.641192] pvrusb2: Set up standard idx=9 name=PAL-D
[43175.641195] pvrusb2: Set up standard idx=10 name=PAL-D1
[43175.641198] pvrusb2: Set up standard idx=11 name=PAL-K
[43175.641202] pvrusb2: Set up standard idx=12 name=SECAM-B
[43175.641205] pvrusb2: Set up standard idx=13 name=SECAM-D
[43175.641208] pvrusb2: Set up standard idx=14 name=SECAM-G
[43175.641212] pvrusb2: Set up standard idx=15 name=SECAM-H
[43175.641215] pvrusb2: Set up standard idx=16 name=SECAM-K
[43175.641218] pvrusb2: Set up standard idx=17 name=SECAM-K1
[43175.641221] pvrusb2: Set up standard idx=18 name=SECAM-L
[43175.641225] pvrusb2: Set up standard idx=19 name=SECAM-LC
[43175.641228] pvrusb2: Initial video standard auto-selected to PAL-B/G
[43175.641240] pvrusb2: Device initialization completed successfully.
[43175.641361] pvrusb2: registered device video1 [mpeg]
[43175.641365] DVB: registering new adapter (pvrusb2-dvb)
[43177.891568] cx25840 18-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
[43178.010913] tda829x 18-0042: setting tuner address to 60
[43178.034089] tda18271 18-0060: creating new instance
[43178.070613] TDA18271HD/C2 detected @ 18-0060
[43179.945888] tda18271: performing RF tracking filter calibration
[43192.930384] tda18271: RF tracking filter calibration complete
[43192.973646] tda829x 18-0042: type set to tda8295+18271
[43196.561274] cx25840 18-0044: 0x0000 is not a valid video input!
[43196.593146] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[43196.594644] tda829x 18-0042: type set to tda8295
[43196.630097] tda18271 18-0060: attaching existing instance
[43205.439659] cx25840 18-0044: loaded v4l-cx25840.fw firmware (16382 bytes)

The only differences between this output and a working device is the 
revision number and the fact that the tuner is a TDA18271HD/C2 whereas 
with the older (working) devices it's a TDA18271HD/C1.

Here's what I do to test problem:
[root@dragon ~]# echo television > /sys/class/pvrusb2/sn-6569758/ctl_input/cur_val 
[root@dragon ~]# echo 140250000 > /sys/class/pvrusb2/sn-6569758/ctl_frequency/cur_val 
[root@dragon ~]# cat /sys/class/pvrusb2/sn-6569758/ctl_signal_present/cur_val 
0
[root@dragon ~]# 

If I now do 'cat /dev/video0 > test.mpg' I get a perfectly valid MPEG 
stream, but a rather boring one - just a black display and no audio.

With the old D1E9 revision I get

[root@dragon ~]# cat /sys/class/pvrusb2/sn-6569758/ctl_signal_present/cur_val
65535
[root@dragon ~]#

and 'cat /dev/video0 > test.mpg' gives me the stream I'd expect (as in 
actual contents, not just a black screen).

Any ideas on how to fix this?

I can test any patches you may come up with and if there's any further 
information you need from me in order to get an idea about what the 
problem is, then just ask.

Please CC me on replies since I'm not subscribed to the linux-media list.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


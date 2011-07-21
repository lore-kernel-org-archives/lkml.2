Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1GUMbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:31:25 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21554 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1GUMbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:31:24 -0400
Date: Thu, 21 Jul 2011 14:31:22 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Michael Krufky <mkrufky@kernellabs.com>
cc: linux-media@vger.kernel.org, Mike Isely <isely@pobox.com>,
        Aurelien Alleaume <slts@free.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: Hauppauge model 73219 rev D1F5 tuner doesn't detect signal,
 older rev D1E9 works
In-Reply-To: <alpine.LNX.2.00.1107211403290.30225@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1107211428020.30225@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107151455140.28453@swampdragon.chaosbits.net> <CAOcJUbz9ZeUHOzkgVfktwJ4vH9+HOP3=EfVP2xbaYhB49Gcbug@mail.gmail.com> <alpine.LNX.2.00.1107211403290.30225@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011, Jesper Juhl wrote:

> On Tue, 19 Jul 2011, Michael Krufky wrote:
> 
> > On Tue, Jul 19, 2011 at 3:37 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> > > Hi
> > >
> > > I have a bunch of Hauppauge HVR-1900 model 73219's, some are revision D1E9
> > > and work perfectly, but with the newer revision D1F5's the tuner fails to
> > > detect a signal and consequently just gives me blank output on
> > > /dev/video0. Other input sources, like composite or s-video, work just
> > > fine on the new revision, it's just the tuner that does not work.
> > >
> ...
> > >
> > > If I now do 'cat /dev/video0 > test.mpg' I get a perfectly valid MPEG
> > > stream, but a rather boring one - just a black display and no audio.
> > >
> > > With the old D1E9 revision I get
> > >
> > > [root@dragon ~]# cat /sys/class/pvrusb2/sn-6569758/ctl_signal_present/cur_val
> > > 65535
> > > [root@dragon ~]#
> > >
> > > and 'cat /dev/video0 > test.mpg' gives me the stream I'd expect (as in
> > > actual contents, not just a black screen).
> > >
> > > Any ideas on how to fix this?
> > >
> > > I can test any patches you may come up with and if there's any further
> > > information you need from me in order to get an idea about what the
> > > problem is, then just ask.
> > >
> > > Please CC me on replies since I'm not subscribed to the linux-media list.
> > >
> 
> Ok, so things did change a bit :-)
> 
> I still get a 0 when I cat ctl_signal_present/cur_val , but I no longer 
> get just a black stream from the bideo device now I get static and very 
> badly tuned "images".  See for example: 
> http://personal.chaosbits.net/hauppauge-pvr-1900-test.mpg which is the 
> result of 
>   cat /dev/video1 > /tmp/hauppauge-pvr-1900-test.mpg & seq 147250280 147250310 | while read i; do echo $i > /sys/class/pvrusb2/sn-6569758/ctl_frequency/cur_val; sleep 2; done ; killall cat
> 
>   (warning - large file - ~65MB)
> 
> Definately an improvement.
> 
> 

Forgot to include dmesg output with the patch applied:

[ 6409.476538] usb 2-1.1: new high speed USB device number 3 using ehci_hcd
[ 6409.564990] pvrusb2: Hardware description: WinTV HVR-1900 Model 73xxx
[ 6410.884764] pvrusb2: Device microcontroller firmware (re)loaded; it should now reset and reconnect.
[ 6411.082496] usb 2-1.1: USB disconnect, device number 3
[ 6411.082642] pvrusb2: Device being rendered inoperable
[ 6412.803437] usb 2-1.1: new high speed USB device number 4 using ehci_hcd
[ 6412.897974] pvrusb2: Hardware description: WinTV HVR-1900 Model 73xxx
[ 6412.929980] pvrusb2: Binding ir_rx_z8f0811_haup to i2c address 0x71.
[ 6412.930004] pvrusb2: Binding ir_tx_z8f0811_haup to i2c address 0x70.
[ 6412.933293] cx25840 18-0044: cx25843-24 found @ 0x88 (pvrusb2_a)
[ 6412.944105] pvrusb2: Attached sub-driver cx25840
[ 6412.947852] tuner 18-0042: Tuner -1 found with type(s) Radio TV.
[ 6412.947856] pvrusb2: Attached sub-driver tuner
[ 6415.150802] cx25840 18-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
[ 6415.253458] tveeprom 18-00a2: Hauppauge model 73219, rev D1F5, serial# 6569758
[ 6415.253463] tveeprom 18-00a2: MAC address is 00:0d:fe:64:3f:1e
[ 6415.253467] tveeprom 18-00a2: tuner model is NXP 18271C2 (idx 155, type 54)
[ 6415.253471] tveeprom 18-00a2: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[ 6415.253475] tveeprom 18-00a2: audio processor is CX25843 (idx 37)
[ 6415.253478] tveeprom 18-00a2: decoder processor is CX25843 (idx 30)
[ 6415.253481] tveeprom 18-00a2: has radio, has IR receiver, has IR transmitter
[ 6415.253593] pvrusb2: Supported video standard(s) reported available in hardware: PAL-B/B1/D/D1/G/H/I/K;SECAM-B/D/G/H/K/K
[ 6415.253604] pvrusb2: Mapping standards mask=0x3ff00ff (PAL-B/B1/D/D1/G/H/I/K;SECAM-B/D/G/H/K/K1/L/LC;ATSC-8VSB/16VSB)
[ 6415.253612] pvrusb2: Setting up 20 unique standard(s)
[ 6415.253615] pvrusb2: Set up standard idx=0 name=PAL-B/G
[ 6415.253617] pvrusb2: Set up standard idx=1 name=PAL-D/K
[ 6415.253620] pvrusb2: Set up standard idx=2 name=SECAM-B/G
[ 6415.253622] pvrusb2: Set up standard idx=3 name=SECAM-D/K
[ 6415.253625] pvrusb2: Set up standard idx=4 name=PAL-B
[ 6415.253627] pvrusb2: Set up standard idx=5 name=PAL-B1
[ 6415.253629] pvrusb2: Set up standard idx=6 name=PAL-G
[ 6415.253631] pvrusb2: Set up standard idx=7 name=PAL-H
[ 6415.253633] pvrusb2: Set up standard idx=8 name=PAL-I
[ 6415.253635] pvrusb2: Set up standard idx=9 name=PAL-D
[ 6415.253638] pvrusb2: Set up standard idx=10 name=PAL-D1
[ 6415.253640] pvrusb2: Set up standard idx=11 name=PAL-K
[ 6415.253642] pvrusb2: Set up standard idx=12 name=SECAM-B
[ 6415.253644] pvrusb2: Set up standard idx=13 name=SECAM-D
[ 6415.253647] pvrusb2: Set up standard idx=14 name=SECAM-G
[ 6415.253649] pvrusb2: Set up standard idx=15 name=SECAM-H
[ 6415.253651] pvrusb2: Set up standard idx=16 name=SECAM-K
[ 6415.253653] pvrusb2: Set up standard idx=17 name=SECAM-K1
[ 6415.253655] pvrusb2: Set up standard idx=18 name=SECAM-L
[ 6415.253658] pvrusb2: Set up standard idx=19 name=SECAM-LC
[ 6415.253660] pvrusb2: Initial video standard auto-selected to PAL-B/G
[ 6415.253668] pvrusb2: Device initialization completed successfully.
[ 6415.253826] pvrusb2: registered device video1 [mpeg]
[ 6415.253830] DVB: registering new adapter (pvrusb2-dvb)
[ 6417.510870] cx25840 18-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
[ 6417.627793] tda829x 18-0042: setting tuner address to 60
[ 6417.651036] tda18271 18-0060: creating new instance
[ 6417.687778] TDA18271HD/C2 detected @ 18-0060
[ 6419.571379] tda18271: performing RF tracking filter calibration
[ 6432.586119] tda18271: RF tracking filter calibration complete
[ 6432.629500] tda829x 18-0042: type set to tda8295+18271
[ 6437.466724] cx25840 18-0044: 0x0000 is not a valid video input!
[ 6437.498898] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[ 6437.500315] tda829x 18-0042: type set to tda8295
[ 6437.535451] tda18271 18-0060: attaching existing instance
[ 6454.052596] cx25840 18-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
[ 7318.909006] pvrusb2: ***WARNING*** device's encoder appears to be stuck (status=0x00000003)
[ 7318.909012] pvrusb2: Encoder command: 0x81
[ 7318.909015] pvrusb2: Giving up on command.  This is normally recovered via a firmware reload and re-initialization; concern is only warranted if this happens repeatedly and rapidly.
[ 8413.977059] pvrusb2: ***WARNING*** device's encoder appears to be stuck (status=0x00000003)
[ 8413.977065] pvrusb2: Encoder command: 0x81
[ 8413.977068] pvrusb2: Giving up on command.  This is normally recovered via a firmware reload and re-initialization; concern is only warranted if this happens repeatedly and rapidly.
[ 8792.114989] usb 2-1.1: USB disconnect, device number 4
[ 8792.115138] pvrusb2: Device being rendered inoperable
[ 8792.115371] pvrusb2: unregistered device video1 [mpeg]
[ 8792.115461] pvrusb2: unregistering DVB devices
[ 8792.115926] tda18271 18-0060: destroying instance

I guess I should also mention that I applied the patch to a up-to-date 
mainline kernel from git:

$ uname -a
Linux dragon 3.0.0-rc7-JJ-00176-gcf6ace1-dirty #4 SMP PREEMPT Thu Jul 21 11:06:43 CEST 2011 x86_64 Intel(R) Core(TM) i5 CPU M 560 @ 2.67GHz GenuineIntel GNU/Linux


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab1GSUJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:09:01 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35196 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1GSUI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:08:59 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1107151455140.28453@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107151455140.28453@swampdragon.chaosbits.net>
Date: Tue, 19 Jul 2011 16:08:58 -0400
X-Google-Sender-Auth: 4Ln0CMhJeBm5gY5wgdbuc6G5obs
Message-ID: <CAOcJUbz9ZeUHOzkgVfktwJ4vH9+HOP3=EfVP2xbaYhB49Gcbug@mail.gmail.com>
Subject: Re: Hauppauge model 73219 rev D1F5 tuner doesn't detect signal, older
 rev D1E9 works
From: Michael Krufky <mkrufky@kernellabs.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-media@vger.kernel.org, Mike Isely <isely@pobox.com>,
        Aurelien Alleaume <slts@free.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@kernellabs.com>,
        Michael Krufky <mkrufky@linuxtv.org>
Content-Type: multipart/mixed; boundary=005045013e15a6cada04a871af18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--005045013e15a6cada04a871af18
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 19, 2011 at 3:37 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> Hi
>
> I have a bunch of Hauppauge HVR-1900 model 73219's, some are revision D1E=
9
> and work perfectly, but with the newer revision D1F5's the tuner fails to
> detect a signal and consequently just gives me blank output on
> /dev/video0. Other input sources, like composite or s-video, work just
> fine on the new revision, it's just the tuner that does not work.
>
> I'm 100% certain that there is a live signal since I can use the same
> source successfully with a D1E9 and then move it to a D1F5 and see it
> fail. I've also tried both with a real TV signal and with a signal
> generator (so I could be 100% certain what signal was generated and at
> what frequency etc).
> I'm also fairly certain that it's not just a case of a random broken
> D1F5 since I have several and they all behave identically (and the driver
> doesn't complain about broken hardware).
>
> Here's what I get in dmesg when plugging one of the newer, non-working,
> devices into my laptop (running 2.6.39.3 by the way):
>
> [43171.480193] pvrusb2: Device being rendered inoperable
> [43173.195741] usb 1-1.1: new high speed USB device number 21 using ehci_=
hcd
> [43173.289999] pvrusb2: Hardware description: WinTV HVR-1900 Model 73xxx
> [43173.321796] pvrusb2: Binding ir_rx_z8f0811_haup to i2c address 0x71.
> [43173.321817] pvrusb2: Binding ir_tx_z8f0811_haup to i2c address 0x70.
> [43173.325212] cx25840 18-0044: cx25843-24 found @ 0x88 (pvrusb2_a)
> [43173.335618] pvrusb2: Attached sub-driver cx25840
> [43173.339439] tuner 18-0042: Tuner -1 found with type(s) Radio TV.
> [43173.339448] pvrusb2: Attached sub-driver tuner
> [43175.538224] cx25840 18-0044: loaded v4l-cx25840.fw firmware (16382 byt=
es)
> [43175.641103] tveeprom 18-00a2: Hauppauge model 73219, rev D1F5, serial#=
 6569758
> [43175.641109] tveeprom 18-00a2: MAC address is 00:0d:fe:64:3f:1e
> [43175.641114] tveeprom 18-00a2: tuner model is NXP 18271C2 (idx 155, typ=
e 54)
> [43175.641119] tveeprom 18-00a2: TV standards PAL(B/G) PAL(I) SECAM(L/L')=
 PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
> [43175.641124] tveeprom 18-00a2: audio processor is CX25843 (idx 37)
> [43175.641128] tveeprom 18-00a2: decoder processor is CX25843 (idx 30)
> [43175.641132] tveeprom 18-00a2: has radio, has IR receiver, has IR trans=
mitter
> [43175.641142] pvrusb2: Supported video standard(s) reported available in=
 hardware: PAL-B/B1/D/D1/G/H/I/K;SECAM-B/D/G/H/K/K
> [43175.641152] pvrusb2: Mapping standards mask=3D0x3ff00ff (PAL-B/B1/D/D1=
/G/H/I/K;SECAM-B/D/G/H/K/K1/L/LC;ATSC-8VSB/16VSB)
> [43175.641156] pvrusb2: Setting up 20 unique standard(s)
> [43175.641161] pvrusb2: Set up standard idx=3D0 name=3DPAL-B/G
> [43175.641165] pvrusb2: Set up standard idx=3D1 name=3DPAL-D/K
> [43175.641169] pvrusb2: Set up standard idx=3D2 name=3DSECAM-B/G
> [43175.641172] pvrusb2: Set up standard idx=3D3 name=3DSECAM-D/K
> [43175.641176] pvrusb2: Set up standard idx=3D4 name=3DPAL-B
> [43175.641179] pvrusb2: Set up standard idx=3D5 name=3DPAL-B1
> [43175.641182] pvrusb2: Set up standard idx=3D6 name=3DPAL-G
> [43175.641185] pvrusb2: Set up standard idx=3D7 name=3DPAL-H
> [43175.641189] pvrusb2: Set up standard idx=3D8 name=3DPAL-I
> [43175.641192] pvrusb2: Set up standard idx=3D9 name=3DPAL-D
> [43175.641195] pvrusb2: Set up standard idx=3D10 name=3DPAL-D1
> [43175.641198] pvrusb2: Set up standard idx=3D11 name=3DPAL-K
> [43175.641202] pvrusb2: Set up standard idx=3D12 name=3DSECAM-B
> [43175.641205] pvrusb2: Set up standard idx=3D13 name=3DSECAM-D
> [43175.641208] pvrusb2: Set up standard idx=3D14 name=3DSECAM-G
> [43175.641212] pvrusb2: Set up standard idx=3D15 name=3DSECAM-H
> [43175.641215] pvrusb2: Set up standard idx=3D16 name=3DSECAM-K
> [43175.641218] pvrusb2: Set up standard idx=3D17 name=3DSECAM-K1
> [43175.641221] pvrusb2: Set up standard idx=3D18 name=3DSECAM-L
> [43175.641225] pvrusb2: Set up standard idx=3D19 name=3DSECAM-LC
> [43175.641228] pvrusb2: Initial video standard auto-selected to PAL-B/G
> [43175.641240] pvrusb2: Device initialization completed successfully.
> [43175.641361] pvrusb2: registered device video1 [mpeg]
> [43175.641365] DVB: registering new adapter (pvrusb2-dvb)
> [43177.891568] cx25840 18-0044: loaded v4l-cx25840.fw firmware (16382 byt=
es)
> [43178.010913] tda829x 18-0042: setting tuner address to 60
> [43178.034089] tda18271 18-0060: creating new instance
> [43178.070613] TDA18271HD/C2 detected @ 18-0060
> [43179.945888] tda18271: performing RF tracking filter calibration
> [43192.930384] tda18271: RF tracking filter calibration complete
> [43192.973646] tda829x 18-0042: type set to tda8295+18271
> [43196.561274] cx25840 18-0044: 0x0000 is not a valid video input!
> [43196.593146] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-=
T)...
> [43196.594644] tda829x 18-0042: type set to tda8295
> [43196.630097] tda18271 18-0060: attaching existing instance
> [43205.439659] cx25840 18-0044: loaded v4l-cx25840.fw firmware (16382 byt=
es)
>
> The only differences between this output and a working device is the
> revision number and the fact that the tuner is a TDA18271HD/C2 whereas
> with the older (working) devices it's a TDA18271HD/C1.
>
> Here's what I do to test problem:
> [root@dragon ~]# echo television > /sys/class/pvrusb2/sn-6569758/ctl_inpu=
t/cur_val
> [root@dragon ~]# echo 140250000 > /sys/class/pvrusb2/sn-6569758/ctl_frequ=
ency/cur_val
> [root@dragon ~]# cat /sys/class/pvrusb2/sn-6569758/ctl_signal_present/cur=
_val
> 0
> [root@dragon ~]#
>
> If I now do 'cat /dev/video0 > test.mpg' I get a perfectly valid MPEG
> stream, but a rather boring one - just a black display and no audio.
>
> With the old D1E9 revision I get
>
> [root@dragon ~]# cat /sys/class/pvrusb2/sn-6569758/ctl_signal_present/cur=
_val
> 65535
> [root@dragon ~]#
>
> and 'cat /dev/video0 > test.mpg' gives me the stream I'd expect (as in
> actual contents, not just a black screen).
>
> Any ideas on how to fix this?
>
> I can test any patches you may come up with and if there's any further
> information you need from me in order to get an idea about what the
> problem is, then just ask.
>
> Please CC me on replies since I'm not subscribed to the linux-media list.
>
> --
> Jesper Juhl <jj@chaosbits.net> =A0 =A0 =A0 http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
>

I have a suspicion as per the cause of this problem...  Would you care
to try a patch to see if it fixes the problem?  (note:  this should
not be merged, as it is not an actual fix -- simply an test to show us
how to arrive at the appropriate fix)

--005045013e15a6cada04a871af18
Content-Type: application/octet-stream; name="73xxxD1F9.patch"
Content-Disposition: attachment; filename="73xxxD1F9.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqbapnpk0

LS0tCiBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3B2cnVzYjIvcHZydXNiMi1kZXZhdHRyLmMg
fCAgIDMzICsrKysrKysrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMzMgaW5zZXJ0aW9u
cygrKQoKLS0tIHY0bC1kdmIub3JpZy9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3B2cnVzYjIv
cHZydXNiMi1kZXZhdHRyLmMKKysrIHY0bC1kdmIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9w
dnJ1c2IyL3B2cnVzYjItZGV2YXR0ci5jCkBAIC0yOTMsMTEgKzI5Myw0NCBAQAogCS5kaXNhYmxl
X2dhdGVfYWNjZXNzID0gMSwKIH07CiAKK3N0YXRpYyBzdHJ1Y3QgdGRhMTgyNzFfc3RkX21hcCB0
ZGExODI3MWMxX3N0ZF9tYXAgPSB7CisgICAgICAgIC5mbV9yYWRpbyA9IHsgLmlmX2ZyZXEgPSAx
MjUwLCAuZm1fcmZuID0gMSwgLmFnY19tb2RlID0gMywgLnN0ZCA9IDAsCisgICAgICAgICAgICAg
ICAgICAgICAgLmlmX2x2bCA9IDAsIC5yZmFnY190b3AgPSAweDJjLCB9LCAvKiBFUDNbNDowXSAw
eDE4ICovCisgICAgICAgIC5hdHZfYiAgICA9IHsgLmlmX2ZyZXEgPSA2NzUwLCAuZm1fcmZuID0g
MCwgLmFnY19tb2RlID0gMSwgLnN0ZCA9IDYsCisgICAgICAgICAgICAgICAgICAgICAgLmlmX2x2
bCA9IDAsIC5yZmFnY190b3AgPSAweDJjLCB9LCAvKiBFUDNbNDowXSAweDBlICovCisgICAgICAg
IC5hdHZfZGsgICA9IHsgLmlmX2ZyZXEgPSA3NzUwLCAuZm1fcmZuID0gMCwgLmFnY19tb2RlID0g
MSwgLnN0ZCA9IDcsCisgICAgICAgICAgICAgICAgICAgICAgLmlmX2x2bCA9IDAsIC5yZmFnY190
b3AgPSAweDJjLCB9LCAvKiBFUDNbNDowXSAweDBmICovCisgICAgICAgIC5hdHZfZ2ggICA9IHsg
LmlmX2ZyZXEgPSA3NzUwLCAuZm1fcmZuID0gMCwgLmFnY19tb2RlID0gMSwgLnN0ZCA9IDcsCisg
ICAgICAgICAgICAgICAgICAgICAgLmlmX2x2bCA9IDAsIC5yZmFnY190b3AgPSAweDJjLCB9LCAv
KiBFUDNbNDowXSAweDBmICovCisgICAgICAgIC5hdHZfaSAgICA9IHsgLmlmX2ZyZXEgPSA3NzUw
LCAuZm1fcmZuID0gMCwgLmFnY19tb2RlID0gMSwgLnN0ZCA9IDcsCisgICAgICAgICAgICAgICAg
ICAgICAgLmlmX2x2bCA9IDAsIC5yZmFnY190b3AgPSAweDJjLCB9LCAvKiBFUDNbNDowXSAweDBm
ICovCisgICAgICAgIC5hdHZfbCAgICA9IHsgLmlmX2ZyZXEgPSA3NzUwLCAuZm1fcmZuID0gMCwg
LmFnY19tb2RlID0gMSwgLnN0ZCA9IDcsCisgICAgICAgICAgICAgICAgICAgICAgLmlmX2x2bCA9
IDAsIC5yZmFnY190b3AgPSAweDJjLCB9LCAvKiBFUDNbNDowXSAweDBmICovCisgICAgICAgIC5h
dHZfbGMgICA9IHsgLmlmX2ZyZXEgPSAxMjUwLCAuZm1fcmZuID0gMCwgLmFnY19tb2RlID0gMSwg
LnN0ZCA9IDcsCisgICAgICAgICAgICAgICAgICAgICAgLmlmX2x2bCA9IDAsIC5yZmFnY190b3Ag
PSAweDJjLCB9LCAvKiBFUDNbNDowXSAweDBmICovCisgICAgICAgIC5hdHZfbW4gICA9IHsgLmlm
X2ZyZXEgPSA1NzUwLCAuZm1fcmZuID0gMCwgLmFnY19tb2RlID0gMSwgLnN0ZCA9IDUsCisgICAg
ICAgICAgICAgICAgICAgICAgLmlmX2x2bCA9IDAsIC5yZmFnY190b3AgPSAweDJjLCB9LCAvKiBF
UDNbNDowXSAweDBkICovCisgICAgICAgIC5hdHNjXzYgICA9IHsgLmlmX2ZyZXEgPSAzMjUwLCAu
Zm1fcmZuID0gMCwgLmFnY19tb2RlID0gMywgLnN0ZCA9IDQsCisgICAgICAgICAgICAgICAgICAg
ICAgLmlmX2x2bCA9IDEsIC5yZmFnY190b3AgPSAweDM3LCB9LCAvKiBFUDNbNDowXSAweDFjICov
CisgICAgICAgIC5kdmJ0XzYgICA9IHsgLmlmX2ZyZXEgPSAzMzAwLCAuZm1fcmZuID0gMCwgLmFn
Y19tb2RlID0gMywgLnN0ZCA9IDQsCisgICAgICAgICAgICAgICAgICAgICAgLmlmX2x2bCA9IDEs
IC5yZmFnY190b3AgPSAweDM3LCB9LCAvKiBFUDNbNDowXSAweDFjICovCisgICAgICAgIC5kdmJ0
XzcgICA9IHsgLmlmX2ZyZXEgPSAzODAwLCAuZm1fcmZuID0gMCwgLmFnY19tb2RlID0gMywgLnN0
ZCA9IDUsCisgICAgICAgICAgICAgICAgICAgICAgLmlmX2x2bCA9IDEsIC5yZmFnY190b3AgPSAw
eDM3LCB9LCAvKiBFUDNbNDowXSAweDFkICovCisgICAgICAgIC5kdmJ0XzggICA9IHsgLmlmX2Zy
ZXEgPSA0MzAwLCAuZm1fcmZuID0gMCwgLmFnY19tb2RlID0gMywgLnN0ZCA9IDYsCisgICAgICAg
ICAgICAgICAgICAgICAgLmlmX2x2bCA9IDEsIC5yZmFnY190b3AgPSAweDM3LCB9LCAvKiBFUDNb
NDowXSAweDFlICovCisgICAgICAgIC5xYW1fNiAgICA9IHsgLmlmX2ZyZXEgPSA0MDAwLCAuZm1f
cmZuID0gMCwgLmFnY19tb2RlID0gMywgLnN0ZCA9IDUsCisgICAgICAgICAgICAgICAgICAgICAg
LmlmX2x2bCA9IDEsIC5yZmFnY190b3AgPSAweDM3LCB9LCAvKiBFUDNbNDowXSAweDFkICovCisg
ICAgICAgIC5xYW1fOCAgICA9IHsgLmlmX2ZyZXEgPSA1MDAwLCAuZm1fcmZuID0gMCwgLmFnY19t
b2RlID0gMywgLnN0ZCA9IDcsCisgICAgICAgICAgICAgICAgICAgICAgLmlmX2x2bCA9IDEsIC5y
ZmFnY190b3AgPSAweDM3LCB9LCAvKiBFUDNbNDowXSAweDFmICovCit9OworCisKIHN0YXRpYyBz
dHJ1Y3QgdGRhODI5eF9jb25maWcgdGRhODI5eF9ub19wcm9iZSA9IHsKIAkucHJvYmVfdHVuZXIg
PSBUREE4MjlYX0RPTlRfUFJPQkUsCiB9OwogCiBzdGF0aWMgc3RydWN0IHRkYTE4MjcxX2NvbmZp
ZyBoYXVwcGF1Z2VfdGRhMTgyNzFfZHZiX2NvbmZpZyA9IHsKKwkuc3RkX21hcCA9ICZ0ZGExODI3
MWMxX3N0ZF9tYXAsCiAJLmdhdGUgICAgPSBUREExODI3MV9HQVRFX0FOQUxPRywKIAkub3V0cHV0
X29wdCA9IFREQTE4MjcxX09VVFBVVF9MVF9PRkYsCiB9Owo=
--005045013e15a6cada04a871af18--

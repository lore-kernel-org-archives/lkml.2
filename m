Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab1ETNMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:12:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49941 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1ETNMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=thhP05PV0IQInnkHYlgO/0bNlFmRREdcEfclVAe0TJoTFHo4nGB4rmi384GVqu+tCU
         WWKuxLqUNNAzGXSQSM9DsqSP6pbmc6i0+MxudBMNi60BB+Vy+wx45LgDZIPXiBcCPFxy
         XGDzGtnkzITZmVR7Sdf4j7NHhWQP8PwL8q9c0=
MIME-Version: 1.0
In-Reply-To: <87mxihd6kh.fsf@macbook.be.48ers.dk>
References: <1305725244-5327-1-git-send-email-benjamin.tissoires@enac.fr>
	<87boyyo0gr.fsf@macbook.be.48ers.dk>
	<BANLkTikPXHswWQqQHqd8fegotqoZPLErsQ@mail.gmail.com>
	<87mxihd6kh.fsf@macbook.be.48ers.dk>
Date: Fri, 20 May 2011 15:12:50 +0200
X-Google-Sender-Auth: rrxwToddL-W2YKp5UNxl7J1c8e0
Message-ID: <BANLkTi=nyaVBhKB6bKLCqtykjMAaKfEt9A@mail.gmail.com>
Subject: Re: [PATCH] hid-multitouch: Add support for Lumio panels
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I'll see with the device maker if your device should work in
multitouch. Your new evtest does not report enough multitouch things,
which is weird.

Cheers,
Benjamin

On Fri, May 20, 2011 at 12:12, Peter Korsgaard <jacmet@sunsite.dk> wrote:
>>>>>> "Benjamin" == Benjamin Tissoires <benjamin.tissoires@enac.fr> writes:
>
> Hi,
>
>  Benjamin> your device presents Contact ID, Tip Switch, In Range and
>  Benjamin> Confidence.  I would say that Win 7 would treat it as a
>  Benjamin> multitouch screen, so this might work with
>  Benjamin> hid-multitouch. Please note that's the first time I see a
>  Benjamin> report descriptor with only one touch reported for a
>  Benjamin> multitouch screen.
>
>  Benjamin> For the configuration, the device may emulate a mouse by
>  Benjamin> default, and hid-multitouch is able to switch to the
>  Benjamin> multitouch mode. You will loose the right click, but it can
>  Benjamin> be enabled in gnome at least (accessibility settings).
>
>  Benjamin> Can you just replace in hid-ids.h:
>  Benjamin> - #define USB_DEVICE_ID_CRYSTALTOUCH  0x0006
>  Benjamin> + #define USB_DEVICE_ID_CRYSTALTOUCH  0x0005
>
>  Benjamin> and see if it's working?  If you prefer, I can make a new
>  Benjamin> patch, but I'll need to know which kernel you are running
>  Benjamin> (tree and branch). A 2.6.39 and above would be great.
>
> I'm on 2.6.39. The patch doesn't apply cleanly, but I've fixed it up
> manually (http://peter.korsgaard.com/lumio-2.6.29.patch).
>
> hid-multitouch does get loaded, and everything looks OK:
>
> usb 2-1.1: new full speed USB device number 4 using uhci_hcd
> hid-multitouch 0003:202E:0005.0008: hiddev0: USB HID v1.10 Device [LUMIO Inc LUMIO CrystalTouch ver 1.1C] on usb-0000:00:1d.0-1.1/input0
> input: LUMIO Inc LUMIO CrystalTouch ver 1.1C as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.1/input/input18
> hid-multitouch 0003:202E:0005.0009: input: USB HID v1.11 Keyboard [LUMIO Inc LUMIO CrystalTouch ver 1.1C] on usb-0000:00:1d.0-1.1/input1
> input: LUMIO Inc LUMIO CrystalTouch ver 1.1C as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.2/input/input19
> hid-multitouch 0003:202E:0005.000A: input: USB HID v1.11 Mouse [LUMIO Inc LUMIO CrystalTouch ver 1.1C] on usb-0000:00:1d.0-1.1/input2
> input: LUMIO Inc LUMIO CrystalTouch ver 1.1C as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.3/input/input20
> hid-multitouch 0003:202E:0005.000B: input: USB HID v1.11 Device [LUMIO Inc LUMIO CrystalTouch ver 1.1C] on usb-0000:00:1d.0-1.1/input3
>
> Evdev output is also different, but it doesn't seem to ever generate any
> events when I touch the screen.
>
> Before I had:
>
> I: Bus=0003 Vendor=202e Product=0005 Version=0111
> N: Name="LUMIO Inc LUMIO CrystalTouch ver 1.1C"
> P: Phys=usb-0000:00:1d.0-1.1/input1
> S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.1/input/input28
> U: Uniq=
> H: Handlers=mac-button-emul sysrq kbd event16
> B: PROP=0
> B: EV=100013
> B: KEY=e080ffdf01cfffff fffffffffffffffe
> B: MSC=10
>
> I: Bus=0003 Vendor=202e Product=0005 Version=0111
> N: Name="LUMIO Inc LUMIO CrystalTouch ver 1.1C"
> P: Phys=usb-0000:00:1d.0-1.1/input2
> S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.2/input/input29
> U: Uniq=
> H: Handlers=mac-button-emul event17
> B: PROP=0
> B: EV=1f
> B: KEY=70000 0 0 0 0
> B: REL=200
> B: ABS=3
> B: MSC=10
>
> I: Bus=0003 Vendor=202e Product=0005 Version=0111
> N: Name="LUMIO Inc LUMIO CrystalTouch ver 1.1C"
> P: Phys=usb-0000:00:1d.0-1.1/input3
> S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.3/input/input30
> U: Uniq=
> H: Handlers=mac-button-emul event18
> B: PROP=0
> B: EV=1b
> B: KEY=420 1 0 0 0 0
> B: ABS=10000000003
> B: MSC=10
>
> With event16 + event18 never generating any events, and event17 giving:
>
> Input driver version is 1.0.1
> Input device ID: bus 0x3 vendor 0x202e product 0x5 version 0x111
> Input device name: "LUMIO Inc LUMIO CrystalTouch ver 1.1C"
> Supported events:
>  Event type 0 (Sync)
>  Event type 1 (Key)
>    Event code 272 (LeftBtn)
>    Event code 273 (RightBtn)
>    Event code 274 (MiddleBtn)
>  Event type 2 (Relative)
>    Event code 9 (Misc)
>  Event type 3 (Absolute)
>    Event code 0 (X)
>      Value    650
>      Min        0
>      Max     4095
>    Event code 1 (Y)
>      Value   3221
>      Min        0
>      Max     4095
>  Event type 4 (Misc)
>    Event code 4 (ScanCode)
> Testing ... (interrupt to exit)
> Event: time 1305882024.934011, type 4 (Misc), code 4 (ScanCode), value 90001
> Event: time 1305882024.934017, type 1 (Key), code 272 (LeftBtn), value 1
> Event: time 1305882024.934029, type 3 (Absolute), code 0 (X), value 270
> Event: time 1305882024.934034, type 3 (Absolute), code 1 (Y), value 1513
> Event: time 1305882024.934039, type 2 (Relative), code 9 (Misc), value 1
> Event: time 1305882024.934043, -------------- Report Sync ------------
> Event: time 1305882024.943019, type 2 (Relative), code 9 (Misc), value 1
> Event: time 1305882024.943025, -------------- Report Sync ------------
> Event: time 1305882024.951998, type 3 (Absolute), code 0 (X), value 275
> Event: time 1305882024.952006, type 3 (Absolute), code 1 (Y), value 1519
> Event: time 1305882024.952010, type 2 (Relative), code 9 (Misc), value 1
> Event: time 1305882024.952014, -------------- Report Sync ------------
>
>
> Now with hid-multitouch I have:
>
> I: Bus=0003 Vendor=202e Product=0005 Version=0111
> N: Name="LUMIO Inc LUMIO CrystalTouch ver 1.1C"
> P: Phys=usb-0000:00:1d.0-1.1/input1
> S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.1/input/input18
> U: Uniq=
> H: Handlers=mac-button-emul event16
> B: PROP=0
> B: EV=100003
> B: KEY=0
>
> I: Bus=0003 Vendor=202e Product=0005 Version=0111
> N: Name="LUMIO Inc LUMIO CrystalTouch ver 1.1C"
> P: Phys=usb-0000:00:1d.0-1.1/input2
> S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.2/input/input19
> U: Uniq=
> H: Handlers=mac-button-emul event17
> B: PROP=0
> B: EV=b
> B: KEY=0
> B: ABS=60000000000003
>
> I: Bus=0003 Vendor=202e Product=0005 Version=0111
> N: Name="LUMIO Inc LUMIO CrystalTouch ver 1.1C"
> P: Phys=usb-0000:00:1d.0-1.1/input3
> S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.3/input/input20
> U: Uniq=
> H: Handlers=mac-button-emul event18
> B: PROP=0
> B: EV=b
> B: KEY=400 0 0 0 0 0
> B: ABS=60000000000003
>
> And event17:
>
> Input driver version is 1.0.1
> Input device ID: bus 0x3 vendor 0x202e product 0x5 version 0x111
> Input device name: "LUMIO Inc LUMIO CrystalTouch ver 1.1C"
> Supported events:
>  Event type 0 (Sync)
>  Event type 1 (Key)
>  Event type 3 (Absolute)
>    Event code 0 (X)
>      Value      0
>      Min        0
>      Max     4095
>    Event code 1 (Y)
>      Value      0
>      Min        0
>      Max     4095
>    Event code 53 (?)
>      Value      0
>      Min        0
>      Max     4095
>    Event code 54 (?)
>      Value      0
>      Min        0
>      Max     4095
> Testing ... (interrupt to exit)
> Event: time 1305886175.641112, -------------- Report Sync ------------
>
> And then nothing. Any idea about how to progress?
>
> --
> Bye, Peter Korsgaard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

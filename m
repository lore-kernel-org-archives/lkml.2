Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab1GNVBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:01:11 -0400
Received: from lucidpixels.com ([72.73.18.11]:55314 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab1GNVBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:01:10 -0400
Date: Thu, 14 Jul 2011 17:01:08 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.39.2: alsa question: usb sound/card shows up as mixer1/audio1?
Message-ID: <alpine.DEB.2.02.1107141656480.10111@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is this a simple udev issue or something else?
I bought two of these but they are actually different devices, on one host 
it works ok, on the other, I get this:

p34:~# dmesg|grep -i audio
[   15.499078] usb 2-2.4: Product: C-Media USB Audio Device
[   15.500235] input: C-Media USB Audio Device    as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.3/input/input5
[   15.500416] generic-usb 0003:0D8C:0008.0003: input,hidraw2: USB HID 
v1.00 Device [C-Media USB Audio Device   ] on usb-0000:00:1d.7-2.4/input3
[   15.534185] usbcore: registered new interface driver snd-usb-audio
p34:~# ls /dev/mixer*
/dev/mixer1
p34:~# ls /dev/audio*
/dev/audio1
p34:~#

$ cat /proc/asound/cards
  1 [Device         ]: USB-Audio - C-Media USB Audio Device
                       C-Media USB Audio Device at usb-0000:00:1d.7-2.4, 
full speed

On the working host:
$ cat /proc/asound/cards
  0 [Device         ]: USB-Audio - USB PnP Sound Device
                       C-Media Electronics Inc. USB PnP Sound Device at 
usb-0000:00:1d.7-2.4, full spe

--

$ aumix

aumix:  error opening mixer: No such file or directory

--

Any clue why one is mapped to [1] and the other [0], where the one that is 
[0] works properly and the [1] does not?

Justin.


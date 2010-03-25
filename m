Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0CYOr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:47:26 -0400
Received: from lucidpixels.com ([75.144.35.66]:53145 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab0CYOrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:47:24 -0400
Date: Thu, 25 Mar 2010 10:47:23 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       xorg@lists.freedesktop.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <Pine.LNX.4.44L0.1003251010090.1808-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.00.1003251023400.22668@p34.internal.lan>
References: <Pine.LNX.4.44L0.1003251010090.1808-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Mar 2010, Alan Stern wrote:

> Please don't call it an "oops".  It's not; it's just an informational
> message.
Ok.

> It does look like there's a problem with one of the USB host
> controllers.  Does the dmesg log show anything when the mouse and
It must be the chipset because it did affect the other person's host too.

> keyboard stop working (as opposed to 120 seconds later)?
Hi, I did not see anything else in the kernel log when it stopped.

Here is the kernel log:
[    4.853144] Adding 4008176k swap on /dev/sda1.  Priority:-1 extents:1 across:4008176k 
[    4.885030] usb 2-5: New USB device found, idVendor=413c, idProduct=2005
[    4.885092] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.885145] usb 2-5: Product: DELL USB Keyboard
[    4.885197] usb 2-5: Manufacturer: DELL
[    4.911127] usbcore: registered new interface driver hiddev
[    4.917473] input: DELL DELL USB Keyboard as /devices/pci0000:00/0000:00:0b.0/usb2/2-5/2-5:1.0/input/input7
[    4.917592] generic-usb 0003:413C:2005.0001: input,hidraw0: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:0b.0-5/input0
[    4.917674] usbcore: registered new interface driver usbhid
[    4.917727] usbhid: USB HID core driver
[    5.105278] usb 2-6: new low speed USB device using ohci_hcd and address 3
[    5.251029] usb 2-6: New USB device found, idVendor=046d, idProduct=c018
[    5.251091] usb 2-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.251144] usb 2-6: Product: USB Optical Mouse
[    5.251193] usb 2-6: Manufacturer: Logitech
[    5.261426] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:0b.0/usb2/2-6/2-6:1.0/input/input8
[    5.261555] generic-usb 0003:046D:C018.0002: input,hidraw1: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:0b.0-6/input0
[    5.911624] tg3 0000:02:00.0: irq 28 for MSI/MSI-X
[    9.144766] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[    9.144829] tg3: eth0: Flow control is off for TX and off for RX.

At this point its still hung.
>
> What does /sys/kernel/debug/usb/devices contain?  (You'll probably have
> to look at it _before_ the problem occurs.)
Rebooting and will paste this.  Ok, rebooted, here is the output:

# cat /sys/kernel/debug/usb/devices

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 8
B:  Alloc= 26/900 us ( 3%), #Int=  2, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.33 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:0b.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=413c ProdID=2005 Rev= 1.05
S:  Manufacturer=DELL
S:  Product=DELL USB Keyboard
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms

T:  Bus=02 Lev=01 Prnt=01 Port=05 Cnt=02 Dev#=  3 Spd=1.5 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=046d ProdID=c018 Rev=43.01
S:  Manufacturer=Logitech
S:  Product=USB Optical Mouse
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   5 Ivl=10ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 8
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 2.06
S:  Manufacturer=Linux 2.6.33 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:0b.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

>
> Suppose you don't run X at all.  Do the mouse and keyboard eventually
> stop working even then?
I have not tried that, the reason I use the host locally is for X.


Justin.


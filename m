Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1AVOTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 09:19:30 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:35036 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1AVOT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:19:29 -0500
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Subject: USB3: ERROR no room on ep ring
Date: Sat, 22 Jan 2011 15:19:26 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1-gentoo; KDE/4.5.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101221519.26538.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1+MOQ+xepzO1qLKHlD8fEujGZI92VHnPXjJ1xsF
	VBpGlWnKkHQJrX5+PEr5DHLtLqYfIsae8t4wLHMohqB3OROww0
	oiXbdxJ6E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This computer has some usb2 ports and two usb3 ports.
Its a NEC usb3-chip and is detected correctly.
But when I plug in my headset its not working as expected (although usb3 
should be downwards compatible to usb2 and usb1).

In dmesg I read the following:
usb 1-3: new full speed USB device using xhci_hcd and address 3
xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
usb 1-3: New USB device found, idVendor=1395, idProduct=0020
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-3: Product: Sennheiser USB headset
usb 1-3: Manufacturer: Sennheiser Communication
usb 1-3: ep 0x83 - rounding interval to 128 microframes, ep desc says 
240 microframes
xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
3:1:1: cannot get freq at ep 0x4
xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
3:1:2: cannot get freq at ep 0x4
xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
3:2:1: cannot get freq at ep 0x84
xhci_hcd 0000:04:00.0: ERROR no room on ep ring
=> 54 more times
generic-usb: probe of 0003:1395:0020.0007 failed with error -12

The rounding from 240 to 128 looks pretty strange, but I am not very 
common with that ;)

For comparison the output when I connect the very same headset on an 
usb2 port:
usb 3-9: new full speed USB device using ohci_hcd and address 9
usb 3-9: New USB device found, idVendor=1395, idProduct=0020
usb 3-9: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-9: Product: Sennheiser USB headset
usb 3-9: Manufacturer: Sennheiser Communication
9:1:1: cannot get freq at ep 0x4
9:1:2: cannot get freq at ep 0x4
9:2:1: cannot get freq at ep 0x84
input: Sennheiser Communication Sennheiser USB headset as 
/devices/pci0000:00/0000:00:02.0/usb3/3-9/3-9:1.3/input/input7
generic-usb 0003:1395:0020.0008: input: USB HID v1.11 Device [Sennheiser 
Communication Sennheiser USB headset] on usb-0000:00:02.0-9/input3

This output is from a 2.6.38-rc1.

I knew from ehci that [uo]hci must be loaded before, so ehci claims the 
hardware and can pass usb1x device to the [uo]hci driver. It seems xhci 
is doing everything on its own? Or is just something broken?

Is this a known problem that is worked on?
Anything more I can contribute?


Thanks,
Markus

PS: Please CC me.

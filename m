Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab2F0BwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:52:08 -0400
Received: from gherkin.frus.com ([192.158.254.49]:39477 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab2F0Bve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:51:34 -0400
X-Greylist: delayed 1261 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2012 21:51:34 EDT
Date: Tue, 26 Jun 2012 20:30:31 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: no USB keyboard in 3.5-rc1 and later
Message-ID: <20120627013031.GA2681@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's hoping it's something simple.  Attached USB devices fail to
initialize/work for kernel version 3.5-rc1 and later (up through
3.5-rc4).  From what I can tell from the dmesg output (attached),
there used to be an "input" or "generic-usb" message that appeared
for each device following detection -- showing the sysfs path to the
device.

For the dmesg output excerpted below, I've left out the USB hub
detection/initialization messages.  The system *does* have a USB 3.0 hub
with nothing currently attached to it, just in case the presence of 3.0
hardware is an issue.

The relevant 3.4 boot time messages look like this:

(...)
usb 1-1.1: new low-speed USB device number 3 using ehci_hcd
usb 1-1.1: New USB device found, idVendor=413c, idProduct=2107
usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.1: Product: Dell USB Entry Keyboard
usb 1-1.1: Manufacturer: DELL
input: DELL Dell USB Entry Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input3
generic-usb 0003:413C:2107.0001: input,hidraw0: USB HID v1.10 Keyboard [DELL Dell USB Entry Keyboard] on usb-0000:00:1a.0-1.1/input0
usb 1-1.2: new low-speed USB device number 4 using ehci_hcd
usb 1-1.2: New USB device found, idVendor=045e, idProduct=0039
usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.2: Product: Microsoft IntelliMouse<C2><AE> Optical
usb 1-1.2: Manufacturer: Microsoft
input: Microsoft Microsoft IntelliMouse<C2><AE> Optical as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input4
generic-usb 0003:045E:0039.0002: input,hidraw1: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse<C2><AE> Optical] on usb-0000:00:1a.0-1.2/input0
uhci_hcd: USB Universal Host Controller Interface driver
usb 1-1.6: new low-speed USB device number 5 using ehci_hcd
usb 1-1.6: New USB device found, idVendor=051d, idProduct=0002
usb 1-1.6: New USB device strings: Mfr=3, Product=1, SerialNumber=2
usb 1-1.6: Product: Back-UPS NS 1250 FW:7.g1 .D USB FW:g1 
usb 1-1.6: Manufacturer: American Power Conversion
usb 1-1.6: SerialNumber: JB0643005571  
generic-usb 0003:051D:0002.0003: hiddev0,hidraw2: USB HID v1.10 Device [American Power Conversion Back-UPS NS 1250 FW:7.g1 .D USB FW:g1 ] on usb-0000:00:1a.0-1.6/input0


The 3.5-rc4 messages look like this:

(...)
usb 1-1.1: new low-speed USB device number 3 using ehci_hcd
usb 1-1.1: New USB device found, idVendor=413c, idProduct=2107
usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.1: Product: Dell USB Entry Keyboard
usb 1-1.1: Manufacturer: DELL
usb 1-1.2: new low-speed USB device number 4 using ehci_hcd
usb 1-1.2: New USB device found, idVendor=045e, idProduct=0039
usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.2: Product: Microsoft IntelliMouse<C2><AE> Optical
usb 1-1.2: Manufacturer: Microsoft
uhci_hcd: USB Universal Host Controller Interface driver
usb 1-1.6: new low-speed USB device number 5 using ehci_hcd
usb 1-1.6: New USB device found, idVendor=051d, idProduct=0002
usb 1-1.6: New USB device strings: Mfr=3, Product=1, SerialNumber=2
usb 1-1.6: Product: Back-UPS NS 1250 FW:7.g1 .D USB FW:g1 
usb 1-1.6: Manufacturer: American Power Conversion
usb 1-1.6: SerialNumber: JB0643005571  

Thanks in advance for any assistance in figuring out what's going on
here.

--Bob

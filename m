Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab2GOS2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 14:28:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51096 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750871Ab2GOS2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 14:28:07 -0400
Date: Sun, 15 Jul 2012 14:28:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: linux-usb@vger.kernel.org, Jan Ceuleers <jan.ceuleers@computer.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.4: disabling irq
In-Reply-To: <5002E7FC.5070307@xs4all.nl>
Message-ID: <Pine.LNX.4.44L0.1207151423440.29236-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2012, Udo van den Heuvel wrote:

> On 2012-07-15 17:35, Alan Stern wrote:
> > echo 0000:00:13.1 >/sys/bus/pci/drivers/ohci_hcd/unbind
> 
> Afterwards I did:
> 
> > echo 0000:00:13.1 >/sys/bus/pci/drivers/ohci_hcd/bind

Um, I think you missed the point.  The whole idea of the test is to see 
what happens while the controller is unbound from the driver.  Binding 
it again defeats the purpose.

> And I saw:
> 
> Jul 15 17:50:30 surfplank2 kernel: ohci_hcd 0000:00:13.1: remove, state 1
> Jul 15 17:50:30 surfplank2 kernel: usb usb4: USB disconnect, device number 1
> Jul 15 17:50:30 surfplank2 kernel: usb 4-3: USB disconnect, device number 2
> Jul 15 17:50:30 surfplank2 kernel: ohci_hcd 0000:00:13.1: USB bus 4
> deregistered
> Jul 15 17:50:37 surfplank2 kernel: ohci_hcd 0000:00:13.1: OHCI Host
> Controller
> Jul 15 17:50:37 surfplank2 kernel: ohci_hcd 0000:00:13.1: new USB bus
> registered, assigned bus number 4
> Jul 15 17:50:37 surfplank2 kernel: ohci_hcd 0000:00:13.1: irq 18, io mem
> 0xfe02a000
> Jul 15 17:50:37 surfplank2 kernel: usb usb4: New USB device found,
> idVendor=1d6b, idProduct=0001
> Jul 15 17:50:37 surfplank2 kernel: usb usb4: New USB device strings:
> Mfr=3, Product=2, SerialNumber=1
> Jul 15 17:50:37 surfplank2 kernel: usb usb4: Product: OHCI Host Controller
> Jul 15 17:50:37 surfplank2 kernel: usb usb4: Manufacturer: Linux 3.4.4
> ohci_hcd
> Jul 15 17:50:37 surfplank2 kernel: usb usb4: SerialNumber: 0000:00:13.1
> Jul 15 17:50:37 surfplank2 kernel: hub 4-0:1.0: USB hub found
> Jul 15 17:50:37 surfplank2 kernel: hub 4-0:1.0: 3 ports detected
> Jul 15 17:50:37 surfplank2 kernel: usb 4-3: new full-speed USB device
> number 2 using ohci_hcd
> Jul 15 17:50:38 surfplank2 kernel: usb 4-3: New USB device found,
> idVendor=0471, idProduct=0311
> Jul 15 17:50:38 surfplank2 kernel: usb 4-3: New USB device strings:
> Mfr=0, Product=0, SerialNumber=1
> Jul 15 17:50:38 surfplank2 kernel: usb 4-3: SerialNumber: 01690000A5000000
> Jul 15 17:50:38 surfplank2 mtp-probe: checking bus 4, device 2:
> "/sys/devices/pci0000:00/0000:00:13.1/usb4/4-3"
> Jul 15 17:50:38 surfplank2 mtp-probe: bus: 4, device: 2 was not an MTP
> device
> Jul 15 17:50:38 surfplank2 kernel: pwc: Philips PCVC740K (ToUCam
> Pro)/PCVC840 (ToUCam II) USB webcam detected.
> Jul 15 17:50:39 surfplank2 kernel: pwc: Registered as video0.
> Jul 15 17:50:39 surfplank2 kernel: input: PWC snapshot button as
> /devices/pci0000:00/0000:00:13.0/usb3/3-2/input/input8
> Jul 15 17:50:39 surfplank2 kernel: pwc: Philips PCVC740K (ToUCam
> Pro)/PCVC840 (ToUCam II) USB webcam detected.
> Jul 15 17:50:39 surfplank2 kernel: pwc: Registered as video1.
> Jul 15 17:50:39 surfplank2 kernel: input: PWC snapshot button as
> /devices/pci0000:00/0000:00:13.1/usb4/4-3/input/input9
> Jul 15 17:50:39 surfplank2 kernel: usbcore: registered new interface
> driver Philips webcam
> Jul 15 17:50:39 surfplank2 colord[3375]: (colord:3375): Cd-WARNING **:
> CdMain: failed to emit DeviceAdded: failed to register object: An object
> is already exported for the interface
> org.freedesktop.ColorManager.Device at
> /org/freedesktop/ColorManager/devices/sysfs_0471_0311
> 
> So I have two webcams on this controller, each on a different port.

How do you reach that conclusion?  The log above shows only one webcam
on bus 4: device 2, attached to port 3.  There is another webcam, yes, 
but it's on bus 3, not bus 4.

> The final line is an issue that cam with Fedora 17, nobody could foresee
> that one could need a colord *and* have two identical webcams too. (I do
> not need colord but have two webcams to be clear)
> 
> After doing this I could modprobe pwc and start mrtg without problem.
> 
> So now I can wait for the next occurrence.

You should unbind the controller and leave it unbound.  _Then_ wait for 
the next occurrence.

Alan Stern


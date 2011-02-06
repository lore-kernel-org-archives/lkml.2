Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab1BFE1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 23:27:40 -0500
Received: from mail001.aei.ca ([206.123.6.130]:57227 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab1BFE1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 23:27:38 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] usb problems in .38-rc3+
Date: Sat, 5 Feb 2011 23:27:27 -0500
User-Agent: KMail/1.13.6 (Linux/2.6.37-crc+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.1102051515330.4210-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102051515330.4210-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102052327.28342.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 February 2011 15:16:19 Alan Stern wrote:
> On Sat, 5 Feb 2011, Ed Tomlinson wrote:
> 
> > Hi,
> > 
> > My bluetooth usb dongle has stopped working in .38-rc3+
> > 
> > Bus 002 Device 008: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
> > 
> > and in dmesg
> > 
> > [108495.369056] usb 5-1: new full speed USB device using ohci_hcd and address 3
> > [108495.573077] usb 5-1: New USB device found, idVendor=0a12, idProduct=0001
> > [108495.580099] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > [108652.971977] usb 5-1: USB disconnect, address 3
> > [108652.972718] btusb_bulk_complete: hci0 urb ffff8800684e99c0 failed to resubmit (19)
> > [108652.973725] btusb_bulk_complete: hci0 urb ffff8800684e9c00 failed to resubmit (19)
> > [108652.974707] btusb_intr_complete: hci0 urb ffff8800684e9840 failed to resubmit (19)
> > [108653.001690] btusb_send_frame: hci0 urb ffff8800bb42a240 submission failed
> > [108657.007541] usb 2-4.7: new full speed USB device using ehci_hcd and address 8
> > [108657.147736] usb 2-4.7: New USB device found, idVendor=0a12, idProduct=0001
> > [108657.154954] usb 2-4.7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > 
> > Its been working for years here.
> > 
> > Any ideas on what to try or additional info to gather?
> 
> Does it still work with earlier kernels or on other computers?

Alan,

yes its working fine with .37 so the hw is ok.  It looks to be a change in .38 that triggered the failure.

Ed

.37 dmesg follows:

[   10.515289] usb 2-4.7: new full speed USB device using ehci_hcd and address 5
[   10.648949] usb 2-4.7: New USB device found, idVendor=0a12, idProduct=0001
[   10.648952] usb 2-4.7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   10.832380] Bluetooth: Core ver 2.15
[   10.832418] NET: Registered protocol family 31
[   10.832421] Bluetooth: HCI device and connection manager initialized
[   10.832425] Bluetooth: HCI socket layer initialized
[   10.871896] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   10.872246] usbcore: registered new interface driver btusb
[   11.816907] input: ov519 as /devices/pci0000:00/0000:00:12.1/usb4/4-1/input/input6
[   11.817153] gspca: video0 created
[   11.817382] usbcore: registered new interface driver usbserial_generic
[   11.817385] usbserial: USB Serial Driver core
[   11.818128] usbcore: registered new interface driver ov519
[   11.820102] USB Serial support registered for pl2303
[   11.820200] pl2303 5-3:1.0: PL-2303 hack: descriptors matched but endpoints did not
[   11.820234] pl2303 5-3:1.1: pl2303 converter detected
[   11.841717] usb 5-3: pl2303 converter now attached to ttyUSB0
[   11.841742] usbcore: registered new interface driver pl2303
[   11.841745] pl2303: Prolific PL2303 USB to serial adaptor driver
[   28.477896] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[   28.477900] cdrom: Uniform CD-ROM driver Revision: 3.20
[   28.478226] sr 6:0:0:0: Attached scsi CD-ROM sr0
[   30.195117] powernow-k8: Found 1 AMD Phenom(tm) II X4 940 Processor (4 cpu cores) (version 2.20.00)
[   30.195167] powernow-k8:    0 : pstate 0 (3000 MHz)
[   30.195169] powernow-k8:    1 : pstate 1 (2300 MHz)
[   30.195172] powernow-k8:    2 : pstate 2 (1800 MHz)
[   30.195174] powernow-k8:    3 : pstate 3 (800 MHz)
[   30.899098] EXT4-fs (sdb3): re-mounted. Opts: (null)
[   31.194619] EXT4-fs (sdc3): mounted filesystem with ordered data mode. Opts: (null)
[   33.673078] Bluetooth: L2CAP ver 2.15
[   33.673090] Bluetooth: L2CAP socket layer initialized
[   33.727139] Bluetooth: RFCOMM TTY layer initialized
[   33.727168] Bluetooth: RFCOMM socket layer initialized
[   33.727177] Bluetooth: RFCOMM ver 1.11
[   33.814213] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   33.814223] Bluetooth: BNEP filters: protocol multicast
[   33.861898] Bluetooth: SCO (Voice Link) ver 0.6
[   33.861907] Bluetooth: SCO socket layer initialized
[   35.600125] sky2 0000:02:00.0: eth0: enabling interface
[   36.103536] Adding 5986300k swap on /dev/sdc2.  Priority:-1 extents:1 across:5986300k 
[   36.116190] Adding 1020120k swap on /dev/sda2.  Priority:-2 extents:1 across:1020120k 
[   37.355836] NET: Registered protocol family 10
[   37.357093] lo: Disabled Privacy Extensions
[   37.357355] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   38.198205] sky2 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   38.203688] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   47.727778] IPv6 over IPv4 tunneling driver
[   47.728551] sit0: Disabled Privacy Extensions
[   47.761803] tun: Universal TUN/TAP device driver, 1.6
[   47.761813] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   48.434301] eth0: no IPv6 routers present
[   48.960936] sixxs: Disabled Privacy Extensions
[   79.568088] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   79.593964] input: Apple Wireless Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-4/2-4.7/2-4.7:1.0/bluetooth/hci0/hci0:41/input7
[   79.595105] magicmouse 0005:05AC:030D.0004: input,hidraw3: BLUETOOTH HID v0.84 Mouse [Apple Wireless Mouse] on 00:0A:3A:55:07:5A





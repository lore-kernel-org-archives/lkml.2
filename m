Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab1DNMjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 08:39:35 -0400
Received: from lordvan.com ([213.239.219.131]:54980 "EHLO mail.lordvan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab1DNMje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 08:39:34 -0400
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Apr 2011 08:39:33 EDT
Subject: Transcend USB 3.0 TS-PDU3 & WD Essential USB 3.0 ext. HDD problem
From: Thomas Raschbacher <lordvan@lordvan.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 14:31:00 +0200
Message-ID: <1302784260.5879.9.camel@Desktop64X3.internal.raschbacher-schlosserei.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I got myself this yesterday:

Transcend USB 3.0 Card TS-PDU3
Western Digital MyBook Essential 2TiB USB 3.0

with 2.6.36 kernel it did detect the hdd on the USB 3.0 card, but gave
lots of syslog messages - and it didn't really work properly cuz of that
i think.
so I upgraded to 2.6.38-r1(gentoo patches), but now it does not detect
the HDD at all any more when I plug it into the USB 3.0 card (it does
work on the onboard USB 2.0 port now)
-- something about can't setup bus .. - it wouldn't work on the USB2.0
port either then ..
so today i decided to unplug the HDD completely and then boot the pc.  it
does seem like the USB3.0 is detected properly, but now it says
something about not being able to allocate port 4 and does *not* detect
the HDD properly
-> plugged it in into USB 2.0 port for now to format it and copy stuff,
as I needed the space.

I can of course try to help debug the Problem - preferably without
endangering Data on the disc)

output of grep xhci /var/log/messages:
gentoo-2.6.36 kernel 
Apr 13 23:28:28 Desktop64X3 kernel: [    6.335780] xhci_hcd
0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Apr 13 23:28:28 Desktop64X3 kernel: [    6.335827] xhci_hcd
0000:02:00.0: setting latency timer to 64
Apr 13 23:28:28 Desktop64X3 kernel: [    6.335834] xhci_hcd
0000:02:00.0: xHCI Host Controller
Apr 13 23:28:28 Desktop64X3 kernel: [    6.335938] xhci_hcd
0000:02:00.0: new USB bus registered, assigned bus number 3
Apr 13 23:28:28 Desktop64X3 kernel: [    6.336067] xhci_hcd
0000:02:00.0: supports USB remote wakeup
Apr 13 23:28:28 Desktop64X3 kernel: [    6.336082] xhci_hcd
0000:02:00.0: irq 19, io mem 0xfbdfe000
Apr 13 23:28:28 Desktop64X3 kernel: [    6.336142] xhci_hcd
0000:02:00.0: irq 40 for MSI/MSI-X
Apr 13 23:28:28 Desktop64X3 kernel: [    6.336149] xhci_hcd
0000:02:00.0: irq 41 for MSI/MSI-X
Apr 13 23:28:28 Desktop64X3 kernel: [    6.336156] xhci_hcd
0000:02:00.0: irq 42 for MSI/MSI-X
Apr 13 23:28:28 Desktop64X3 kernel: [    6.336162] xhci_hcd
0000:02:00.0: irq 43 for MSI/MSI-X
Apr 13 23:28:28 Desktop64X3 kernel: [    6.340034] usb usb3:
Manufacturer: Linux 2.6.36-gentooATH64 xhci_hcd
Apr 13 23:28:28 Desktop64X3 kernel: [    6.340146] xHCI
xhci_add_endpoint called for root hub
Apr 13 23:28:28 Desktop64X3 kernel: [    6.340151] xHCI
xhci_check_bandwidth called for root hub
Apr 13 21:32:10 Desktop64X3 kernel: [  236.980567] hub 3-0:1.0: state 7
ports 4 chg 0000 evt 0004
Apr 13 21:32:10 Desktop64X3 kernel: [  236.980595] hub 3-0:1.0: port 2,
status 8103, change 0001, 5.0 Gb/s
Apr 13 21:32:10 Desktop64X3 kernel: [  237.084067] hub 3-0:1.0:
debounce: port 2: total 100ms stable 100ms status 0x8103
Apr 13 21:32:10 Desktop64X3 kernel: [  237.084324] usb 3-2: new
SuperSpeed USB device using xhci_hcd and address 2
Apr 13 21:32:10 Desktop64X3 kernel: [  237.096473] usb 3-2: skipped 1
descriptor after endpoint
Apr 13 21:32:10 Desktop64X3 kernel: [  237.096481] usb 3-2: skipped 1
descriptor after endpoint
Apr 13 21:32:10 Desktop64X3 kernel: [  237.096705] xhci_hcd
0000:02:00.0: WARN: short transfer on control ep
Apr 13 21:32:10 Desktop64X3 kernel: [  237.096838] usb 3-2: default
language 0x0409
Apr 13 21:32:10 Desktop64X3 kernel: [  237.097079] xhci_hcd
0000:02:00.0: WARN: short transfer on control ep
Apr 13 21:32:10 Desktop64X3 kernel: [  237.097453] xhci_hcd
0000:02:00.0: WARN: short transfer on control ep
Apr 13 21:32:10 Desktop64X3 kernel: [  237.097952] xhci_hcd
0000:02:00.0: WARN: short transfer on control ep
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098110] usb 3-2: udev 2,
busnum 3, minor = 257
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098119] usb 3-2: New USB
device found, idVendor=1058, idProduct=1130
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098128] usb 3-2: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098134] usb 3-2: Product: My
Book 1130
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098139] usb 3-2:
Manufacturer: Western Digital
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098144] usb 3-2:
SerialNumber: 5743415A4134353638303436
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098307] usb 3-2:
usb_probe_device
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098316] usb 3-2:
configuration #1 chosen from 1 choice
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098676] usb 3-2: Successful
Endpoint Configure command
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098837] usb 3-2: adding
3-2:1.0 (config #1, interface 0)
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098887] libusual 3-2:1.0:
usb_probe_interface
Apr 13 21:32:10 Desktop64X3 kernel: [  237.098892] libusual 3-2:1.0:
usb_probe_interface - got id
Apr 13 21:32:10 Desktop64X3 kernel: [  237.099041]
drivers/usb/core/inode.c: creating file '002'
Apr 13 21:32:10 Desktop64X3 mtp-probe: checking bus 3, device 2:
"/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/usb3/3-2"
Apr 13 21:32:10 Desktop64X3 mtp-probe: bus: 3, device: 2 was not an MTP
device
Apr 13 21:32:10 Desktop64X3 kernel: [  237.141831] Initializing USB Mass
Storage driver...
Apr 13 21:32:10 Desktop64X3 kernel: [  237.141979] usb-storage 3-2:1.0:
usb_probe_interface
Apr 13 21:32:10 Desktop64X3 kernel: [  237.141994] usb-storage 3-2:1.0:
usb_probe_interface - got id
Apr 13 21:32:10 Desktop64X3 kernel: [  237.142637] scsi8 : usb-storage
3-2:1.0
Apr 13 21:32:10 Desktop64X3 kernel: [  237.143167] usbcore: registered
new interface driver usb-storage
Apr 13 21:32:10 Desktop64X3 kernel: [  237.143173] USB Mass Storage
support registered.
Apr 13 21:32:12 Desktop64X3 kernel: [  239.036690] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.036711] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.036731] usb 3-2: ep 0x84 -
urb len = 36, sglist used, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.036939] usb 3-2: ep 0x84 -
asked for 36 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.036956] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.036979] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037568] scsi 8:0:0:0:
Direct-Access     WD       My Book 1130     1012 PQ: 0 ANSI: 6
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037764] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037778] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037786] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037818] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037840] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037859] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037867] sd 8:0:0:0: Attached
scsi generic sg2 type 0
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037874] usb 3-2: ep 0x84 -
urb len = 8, sglist used, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037900] usb 3-2: ep 0x84 -
asked for 8 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037906] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037941] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037955] sd 8:0:0:0: [sdb]
3906963456 512-byte logical blocks: (2.00 TB/1.81 TiB)
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037962] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037982] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.037988] usb 3-2: ep 0x84 -
urb len = 192, sglist used, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038025] usb 3-2: ep 0x84 -
asked for 192 bytes, 120 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038429] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038439] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038454] sd 8:0:0:0: [sdb]
Write Protect is off
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038456] sd 8:0:0:0: [sdb]
Mode Sense: 47 00 10 08
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038458] sd 8:0:0:0: [sdb]
Assuming drive cache: write through
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038558] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038569] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038575] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038609] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038623] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038650] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038656] usb 3-2: ep 0x84 -
urb len = 8, sglist used, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038691] usb 3-2: ep 0x84 -
asked for 8 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038697] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038732] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038758] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038773] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038779] usb 3-2: ep 0x84 -
urb len = 192, sglist used, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038814] usb 3-2: ep 0x84 -
asked for 192 bytes, 120 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038820] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038855] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038868] sd 8:0:0:0: [sdb]
Assuming drive cache: write through
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038891] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038902] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.038908] usb 3-2: ep 0x84 -
urb len = 4096, sglist used, num_trbs = 1
Apr 13 21:32:12 Desktop64X3 kernel: [  239.113209] usb 3-2: ep 0x84 -
asked for 4096 bytes, 0 bytes untransferred
Apr 13 21:32:12 Desktop64X3 kernel: [  239.113244] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.686587] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.686675]  sdb: sdb1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.687009] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.687031] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.687042] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.687071] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.687119] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.687135] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.687151] usb 3-2: ep 0x84 -
urb len = 8, sglist used, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.687176] usb 3-2: ep 0x84 -
asked for 8 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.689314] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.689333] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.689403] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.689419] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.689436] usb 3-2: ep 0x84 -
urb len = 192, sglist used, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.689463] usb 3-2: ep 0x84 -
asked for 192 bytes, 120 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.689480] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.689505] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.689532] sd 8:0:0:0: [sdb]
Assuming drive cache: write through
Apr 13 21:32:13 Desktop64X3 kernel: [  239.689539] sd 8:0:0:0: [sdb]
Attached SCSI disk
Apr 13 21:32:13 Desktop64X3 kernel: [  239.694071] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.694085] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.694093] usb 3-2: ep 0x84 -
urb len = 4096, sglist used, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.711619] usb 3-2: ep 0x84 -
asked for 4096 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.711659] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.711678] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.711806] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.711824] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.711841] usb 3-2: ep 0x84 -
urb len = 4096, sglist used, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712507] usb 3-2: ep 0x84 -
asked for 4096 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712528] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712544] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712654] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712672] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712687] usb 3-2: ep 0x84 -
urb len = 4096, sglist used, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712769] usb 3-2: ep 0x84 -
asked for 4096 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712783] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712809] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712881] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712899] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.712913] usb 3-2: ep 0x84 -
urb len = 4096, sglist used, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.713002] usb 3-2: ep 0x84 -
asked for 4096 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.713024] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.713041] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.713147] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.713170] usb 3-2: ep 0x3 -
asked for 31 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.713193] usb 3-2: ep 0x84 -
urb len = 512, sglist used, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.713280] usb 3-2: ep 0x84 -
asked for 512 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.713303] usb 3-2: ep 0x84 -
urb len = 0xd (13), addr = 0x4e17000, num_trbs = 1
Apr 13 21:32:13 Desktop64X3 kernel: [  239.713321] usb 3-2: ep 0x84 -
asked for 13 bytes, 0 bytes untransferred
Apr 13 21:32:13 Desktop64X3 kernel: [  239.713359] usb 3-2: ep 0x3 - urb
len = 0x1f (31), addr = 0x4e17000, num_trbs = 1
... lots of repeats of this 


Apr 14 00:36:04 Desktop64X3 kernel: [    6.356066] xhci_hcd
0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Apr 14 00:36:04 Desktop64X3 kernel: [    6.356090] xhci_hcd
0000:02:00.0: setting latency timer to 64
Apr 14 00:36:04 Desktop64X3 kernel: [    6.356093] xhci_hcd
0000:02:00.0: xHCI Host Controller
Apr 14 00:36:04 Desktop64X3 kernel: [    6.356150] xhci_hcd
0000:02:00.0: new USB bus registered, assigned bus number 1
Apr 14 00:36:04 Desktop64X3 kernel: [    6.360125] xhci_hcd
0000:02:00.0: supports USB remote wakeup
Apr 14 00:36:04 Desktop64X3 kernel: [    6.360131] xhci_hcd
0000:02:00.0: irq 19, io mem 0xfbcfe000
Apr 14 00:36:04 Desktop64X3 kernel: [    6.360170] xhci_hcd
0000:02:00.0: irq 44 for MSI/MSI-X
Apr 14 00:36:04 Desktop64X3 kernel: [    6.360172] xhci_hcd
0000:02:00.0: irq 45 for MSI/MSI-X
Apr 14 00:36:04 Desktop64X3 kernel: [    6.360174] xhci_hcd
0000:02:00.0: irq 46 for MSI/MSI-X
Apr 14 00:36:04 Desktop64X3 kernel: [    6.360176] xhci_hcd
0000:02:00.0: irq 47 for MSI/MSI-X

-- did upgrade to 2.6.38 yesterday (gentoo -r1 patches)
Apr 14 00:36:04 Desktop64X3 kernel: [    6.363596] usb usb1:
Manufacturer: Linux 2.6.38-gentoo-r1ATH64 xhci_hcd
Apr 14 00:36:04 Desktop64X3 kernel: [    6.363647] xHCI
xhci_add_endpoint called for root hub
Apr 14 00:36:04 Desktop64X3 kernel: [    6.363648] xHCI
xhci_check_bandwidth called for root hub
Apr 14 00:36:04 Desktop64X3 kernel: [    6.666133] usb 1-4: new high
speed USB device using xhci_hcd and address 2
Apr 14 00:36:04 Desktop64X3 kernel: [   12.070054] xhci_hcd
0000:02:00.0: Timeout while waiting for a slot
Apr 14 00:36:04 Desktop64X3 kernel: [   17.271050] xhci_hcd
0000:02:00.0: Timeout while waiting for a slot
Apr 14 00:36:04 Desktop64X3 kernel: [   18.633134] Modules linked in:
vfat fat snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_hda_codec_hdmi
snd_hda_codec_via snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_timer ohci_hcd ehci_hcd sg zr36060 snd snd_page_alloc atl1e xhci_hcd
adv7175 asus_atk0110 saa7110 zr36067 firewire_ohci i2c_algo_bit
firewire_core videocodec v4l2_common videodev v4l2_compat_ioctl32
crc_itu_t 8139too wmi pcspkr k10temp hwmon
Apr 14 00:36:09 Desktop64X3 kernel: [   23.301059] xhci_hcd
0000:02:00.0: Timeout while waiting for a slot
Apr 13 22:43:52 Desktop64X3 kernel: [  481.383963] xhci_hcd
0000:02:00.0: remove, state 1
Apr 13 22:43:52 Desktop64X3 kernel: [  481.383976] xhci_hcd
0000:02:00.0: roothub graceful disconnect
Apr 13 22:43:52 Desktop64X3 kernel: [  481.384095] xhci_hcd
0000:02:00.0: shutdown urb ffff88012a6c3540 ep1in-intr
Apr 13 22:43:52 Desktop64X3 kernel: [  481.389027] xhci_hcd
0000:02:00.0: Host controller not halted, aborting reset.
Apr 13 22:43:52 Desktop64X3 kernel: [  481.392425] xhci_hcd
0000:02:00.0: USB bus 1 deregistered
Apr 13 22:43:52 Desktop64X3 kernel: [  481.392563] xhci_hcd
0000:02:00.0: PCI INT A disabled
Apr 13 22:43:56 Desktop64X3 kernel: [  485.829249] xhci_hcd
0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Apr 13 22:43:56 Desktop64X3 kernel: [  485.829285] xhci_hcd
0000:02:00.0: setting latency timer to 64
Apr 13 22:43:56 Desktop64X3 kernel: [  485.829288] xhci_hcd
0000:02:00.0: xHCI Host Controller
Apr 13 22:43:56 Desktop64X3 kernel: [  485.829356] xhci_hcd
0000:02:00.0: new USB bus registered, assigned bus number 1
Apr 13 22:43:56 Desktop64X3 kernel: [  485.838267] xhci_hcd
0000:02:00.0: can't setup
Apr 13 22:43:56 Desktop64X3 kernel: [  485.838278] xhci_hcd
0000:02:00.0: USB bus 1 deregistered
Apr 13 22:43:56 Desktop64X3 kernel: [  485.838439] xhci_hcd
0000:02:00.0: PCI INT A disabled
Apr 13 22:43:56 Desktop64X3 kernel: [  485.838445] xhci_hcd
0000:02:00.0: init 0000:02:00.0 fail, -110
Apr 13 22:43:56 Desktop64X3 kernel: [  485.838495] xhci_hcd: probe of
0000:02:00.0 failed with error -110
Apr 13 22:48:09 Desktop64X3 kernel: [  739.038625] xhci_hcd
0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Apr 13 22:48:09 Desktop64X3 kernel: [  739.038690] xhci_hcd
0000:02:00.0: setting latency timer to 64
Apr 13 22:48:09 Desktop64X3 kernel: [  739.038698] xhci_hcd
0000:02:00.0: xHCI Host Controller
Apr 13 22:48:09 Desktop64X3 kernel: [  739.038843] xhci_hcd
0000:02:00.0: new USB bus registered, assigned bus number 1
Apr 13 22:48:09 Desktop64X3 kernel: [  739.055199] xhci_hcd
0000:02:00.0: can't setup
Apr 13 22:48:09 Desktop64X3 kernel: [  739.055210] xhci_hcd
0000:02:00.0: USB bus 1 deregistered
Apr 13 22:48:09 Desktop64X3 kernel: [  739.055394] xhci_hcd
0000:02:00.0: PCI INT A disabled
Apr 13 22:48:09 Desktop64X3 kernel: [  739.055400] xhci_hcd
0000:02:00.0: init 0000:02:00.0 fail, -110
Apr 13 22:48:09 Desktop64X3 kernel: [  739.055431] xhci_hcd: probe of
0000:02:00.0 failed with error -110
Apr 14 11:09:10 Desktop64X3 kernel: [    6.340267] xhci_hcd
0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Apr 14 11:09:10 Desktop64X3 kernel: [    6.340295] xhci_hcd
0000:02:00.0: setting latency timer to 64
Apr 14 11:09:10 Desktop64X3 kernel: [    6.340298] xhci_hcd
0000:02:00.0: xHCI Host Controller
Apr 14 11:09:10 Desktop64X3 kernel: [    6.340356] xhci_hcd
0000:02:00.0: new USB bus registered, assigned bus number 1
Apr 14 11:09:10 Desktop64X3 kernel: [    6.344154] xhci_hcd
0000:02:00.0: supports USB remote wakeup
Apr 14 11:09:10 Desktop64X3 kernel: [    6.344177] xhci_hcd
0000:02:00.0: irq 19, io mem 0xfbdfe000
Apr 14 11:09:10 Desktop64X3 kernel: [    6.344224] xhci_hcd
0000:02:00.0: irq 43 for MSI/MSI-X
Apr 14 11:09:10 Desktop64X3 kernel: [    6.344228] xhci_hcd
0000:02:00.0: irq 44 for MSI/MSI-X
Apr 14 11:09:10 Desktop64X3 kernel: [    6.344232] xhci_hcd
0000:02:00.0: irq 45 for MSI/MSI-X
Apr 14 11:09:10 Desktop64X3 kernel: [    6.344235] xhci_hcd
0000:02:00.0: irq 46 for MSI/MSI-X
Apr 14 11:09:10 Desktop64X3 kernel: [    6.347632] usb usb1:
Manufacturer: Linux 2.6.38-gentoo-r1ATH64 xhci_hcd
Apr 14 11:09:10 Desktop64X3 kernel: [    6.347713] xHCI
xhci_add_endpoint called for root hub
Apr 14 11:09:10 Desktop64X3 kernel: [    6.347715] xHCI
xhci_check_bandwidth called for root hub
Apr 14 11:09:10 Desktop64X3 kernel: [   20.285230] Modules linked in:
vfat fat snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss joydev snd_hda_codec_hdmi
snd_hda_codec_via fglrx(P) snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
zr36060 adv7175 asus_atk0110 ohci_hcd snd_timer firewire_ohci
firewire_core k10temp hwmon sg saa7110 snd ehci_hcd zr36067 i2c_algo_bit
videocodec v4l2_common videodev xhci_hcd 8139too v4l2_compat_ioctl32
snd_page_alloc crc_itu_t pcspkr wmi
Apr 14 12:26:39 Desktop64X3 kernel: [11864.300142] usb 1-4: new high
speed USB device using xhci_hcd and address 2
Apr 14 12:26:45 Desktop64X3 kernel: [11869.705061] xhci_hcd
0000:02:00.0: Timeout while waiting for a slot
Apr 14 12:26:50 Desktop64X3 kernel: [11874.906053] xhci_hcd
0000:02:00.0: Timeout while waiting for a slot



Apr 14 10:25:54 Desktop64X3 rtkit-daemon[5373]: Sucessfully made thread
5413 of process 5413 (/usr/bin/pulseaudio) owned by '1000' high priority
at nice level -11.
Apr 14 10:25:54 Desktop64X3 rtkit-daemon[5373]: Supervising 4 threads of
2 processes of 1 users.
Apr 14 12:25:54 Desktop64X3 pulseaudio[5413]: pid.c: Daemon already
running.
Apr 14 10:25:55 Desktop64X3 rtkit-daemon[5373]: Sucessfully made thread
5435 of process 5435 (/usr/bin/pulseaudio) owned by '1000' high priority
at nice level -11.
Apr 14 10:25:55 Desktop64X3 rtkit-daemon[5373]: Supervising 4 threads of
2 processes of 1 users.
Apr 14 12:25:55 Desktop64X3 pulseaudio[5435]: pid.c: Daemon already
running.
Apr 14 12:26:05 Desktop64X3 dbus-daemon: [system] Rejected send message,
2 matched rules; type="method_call", sender=":1.41" (uid=1000 pid=5379
comm="nautilus) interface="org.freedesktop.DBus.Properties"
member="GetAll" error name="(unset)" requested_reply=0
destination=":1.1" (uid=0 pid=2003 comm="/usr/sbin/console-kit-daemon))
Apr 14 12:26:26 Desktop64X3 su[5611]: Successful su for root by lordvan
Apr 14 12:26:26 Desktop64X3 su[5611]: + /dev/pts/2 lordvan:root
Apr 14 12:26:26 Desktop64X3 su[5611]: pam_unix(su:session): session
opened for user root by lordvan(uid=1000)
Apr 14 12:26:38 Desktop64X3 kernel: [11863.165829] hub 1-0:1.0: state 7
ports 4 chg 0000 evt 0010
Apr 14 12:26:38 Desktop64X3 kernel: [11863.165853] hub 1-0:1.0: port 4,
status 0100, change 0001, 12 Mb/s
Apr 14 12:26:38 Desktop64X3 kernel: [11863.269055] hub 1-0:1.0:
debounce: port 4: total 100ms stable 100ms status 0x100
Apr 14 12:26:39 Desktop64X3 kernel: [11863.964420] hub 1-0:1.0: state 7
ports 4 chg 0000 evt 0010
Apr 14 12:26:39 Desktop64X3 kernel: [11863.964444] hub 1-0:1.0: port 4,
status 0101, change 0001, 12 Mb/s
Apr 14 12:26:39 Desktop64X3 kernel: [11864.198064] hub 1-0:1.0:
debounce: port 4: total 225ms stable 100ms status 0x101
Apr 14 12:26:39 Desktop64X3 kernel: [11864.300142] usb 1-4: new high
speed USB device using xhci_hcd and address 2
Apr 14 12:26:39 Desktop64X3 kernel: [11864.504875] usb 1-4: Device not
responding to set address.
Apr 14 12:26:45 Desktop64X3 kernel: [11869.705061] xhci_hcd
0000:02:00.0: Timeout while waiting for a slot
Apr 14 12:26:45 Desktop64X3 kernel: [11869.906068] usb 1-4: device not
accepting address 2, error -62
Apr 14 12:26:50 Desktop64X3 kernel: [11874.906053] xhci_hcd
0000:02:00.0: Timeout while waiting for a slot
Apr 14 12:26:50 Desktop64X3 kernel: [11874.906065] hub 1-0:1.0: couldn't
allocate port 4 usb_device
Apr 14 12:26:50 Desktop64X3 kernel: [11874.906086] hub 1-0:1.0: state 7
ports 4 chg 0000 evt 0010
Apr 14 12:26:50 Desktop64X3 kernel: [11874.906102] hub 1-0:1.0: port 4,
status 0100, change 0001, 12 Mb/s
Apr 14 12:26:50 Desktop64X3 kernel: [11875.010061] hub 1-0:1.0:
debounce: port 4: total 100ms stable 100ms status 0x100
Apr 14 12:27:14 Desktop64X3 su[5637]: Successful su for root by lordvan
Apr 14 12:27:14 Desktop64X3 su[5637]: + /dev/pts/3 lordvan:root
Apr 14 12:27:14 Desktop64X3 su[5637]: pam_unix(su:session): session
opened for user root by lordvan(uid=1000)
Apr 14 12:27:18 Desktop64X3 kernel: [11902.893271] Initializing USB Mass
Storage driver...
Apr 14 12:27:18 Desktop64X3 kernel: [11902.893964] usbcore: registered
new interface driver usb-storage
Apr 14 12:27:18 Desktop64X3 kernel: [11902.893971] USB Mass Storage
support registered.
Apr 14 12:27:51 Desktop64X3 kernel: [11936.542718] hub 2-0:1.0: state 7
ports 6 chg 0000 evt 0010
Apr 14 12:27:51 Desktop64X3 kernel: [11936.542743] ehci_hcd
0000:00:12.2: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC
CONNECT
Apr 14 12:27:51 Desktop64X3 kernel: [11936.542762] hub 2-0:1.0: port 4,
status 0501, change 0001, 480 Mb/s
Apr 14 12:27:51 Desktop64X3 kernel: [11936.646079] ehci_hcd
0000:00:12.2: GetStatus port:4 status 001002 0  ACK POWER sig=se0 CSC
Apr 14 12:27:51 Desktop64X3 kernel: [11936.672049] ehci_hcd
0000:00:12.2: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC
CONNECT
Apr 14 12:27:52 Desktop64X3 kernel: [11936.776077] hub 2-0:1.0:
debounce: port 4: total 225ms stable 100ms status 0x501
Apr 14 12:27:52 Desktop64X3 kernel: [11936.827081] ehci_hcd
0000:00:12.2: port 4 high speed
Apr 14 12:27:52 Desktop64X3 kernel: [11936.827097] ehci_hcd
0000:00:12.2: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE
CONNECT
Apr 14 12:27:52 Desktop64X3 kernel: [11936.878052] usb 2-4: new high
speed USB device using ehci_hcd and address 4
Apr 14 12:27:52 Desktop64X3 kernel: [11937.221099] ehci_hcd
0000:00:12.2: port 4 high speed
Apr 14 12:27:52 Desktop64X3 kernel: [11937.221115] ehci_hcd
0000:00:12.2: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE
CONNECT
Apr 14 12:27:52 Desktop64X3 kernel: [11937.579798] usb 2-4: default
language 0x0409
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581050] usb 2-4: udev 4,
busnum 2, minor = 131
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581059] usb 2-4: New USB
device found, idVendor=1058, idProduct=1130
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581067] usb 2-4: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581073] usb 2-4: Product: My
Book 1130
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581078] usb 2-4:
Manufacturer: Western Digital
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581083] usb 2-4:
SerialNumber: 5743415A4134353638303436
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581255] usb 2-4:
usb_probe_device
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581263] usb 2-4:
configuration #1 chosen from 1 choice
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581428] usb 2-4: adding
2-4:1.0 (config #1, interface 0)
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581520] libusual 2-4:1.0:
usb_probe_interface
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581535] libusual 2-4:1.0:
usb_probe_interface - got id
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581563] usb-storage 2-4:1.0:
usb_probe_interface
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581577] usb-storage 2-4:1.0:
usb_probe_interface - got id
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581749] scsi8 : usb-storage
2-4:1.0
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581878]
drivers/usb/core/inode.c: creating file '004'
Apr 14 12:27:52 Desktop64X3 kernel: [11937.581899] hub 2-0:1.0: state 7
ports 6 chg 0000 evt 0010
Apr 14 12:27:52 Desktop64X3 mtp-probe: checking bus 2, device 4:
"/sys/devices/pci0000:00/0000:00:12.2/usb2/2-4"
Apr 14 12:27:52 Desktop64X3 mtp-probe: bus: 2, device: 4 was not an MTP
device
Apr 14 12:27:54 Desktop64X3 kernel: [11939.663886] scsi 8:0:0:0:
Direct-Access     WD       My Book 1130     1012 PQ: 0 ANSI: 6
Apr 14 12:27:54 Desktop64X3 kernel: [11939.664114] sd 8:0:0:0: Attached
scsi generic sg2 type 0
Apr 14 12:28:06 Desktop64X3 kernel: [11950.954389] sd 8:0:0:0: [sdb]
3906963456 512-byte logical blocks: (2.00 TB/1.81 TiB)
Apr 14 12:28:06 Desktop64X3 kernel: [11950.955041] sd 8:0:0:0: [sdb]
Write Protect is off
Apr 14 12:28:06 Desktop64X3 kernel: [11950.955051] sd 8:0:0:0: [sdb]
Mode Sense: 47 00 10 08
Apr 14 12:28:06 Desktop64X3 kernel: [11950.955996] sd 8:0:0:0: [sdb] No
Caching mode page present
Apr 14 12:28:06 Desktop64X3 kernel: [11950.956023] sd 8:0:0:0: [sdb]
Assuming drive cache: write through
Apr 14 12:28:06 Desktop64X3 kernel: [11950.958991] sd 8:0:0:0: [sdb] No
Caching mode page present
Apr 14 12:28:06 Desktop64X3 kernel: [11950.958999] sd 8:0:0:0: [sdb]
Assuming drive cache: write through
Apr 14 12:28:06 Desktop64X3 kernel: [11950.976381]  sdb: sdb1
Apr 14 12:28:06 Desktop64X3 kernel: [11950.979485] sd 8:0:0:0: [sdb] No
Caching mode page present
Apr 14 12:28:06 Desktop64X3 kernel: [11950.979488] sd 8:0:0:0: [sdb]
Assuming drive cache: write through
Apr 14 12:28:06 Desktop64X3 kernel: [11950.979490] sd 8:0:0:0: [sdb]
Attached SCSI disk

Regards,
  Thomas R



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929Ab2EVO5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:57:17 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:35025 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2EVO5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:57:15 -0400
Message-ID: <4FBBA946.2080900@telenet.be>
Date: Tue, 22 May 2012 16:57:10 +0200
From: david kennedy <david.kennedy@telenet.be>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bug: USB Stalled endpoint.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug report.

Bug Summary:
On attachment of a camera device via a high speed USB port, device 
recognized but fails to complete connection feedback, perhaps due to 
reported 'Stalled endpoint".

System: SuSE 11.4
Kernel: 2.6.37.6-0.11-desktop
Gnome: 2.32.1
Memory: 7.8 GiB
CPU: Intel i7 870 2.93 GHz.
Disk Management and hardware:
Encrypted LVM on one 2TiB WD2002FAEX

USB:
NEC xHCI Host Controller
Driver: usbcore Linux <kernel release as above> xhci_hcd xHCI Host 
Controller
Revision: 2.06


Method:
Attach a Sony Cyber-shot camera device via an USB port, but receive no 
visual indication of the connection having been made. (Nautilus defaults 
set to open a folder on connection of a (Photo) device.) Remains true if 
the device is disconnected an reconnected several times. Remains true 
after a system restart with the device connected via a usb port.

Diagnostic information:
Dump of relevant section of /var/log/messages
showing disconnects at May 22: 15:59:49 and 16:00:50
and respective reconnects at May 22: 15:59:51 and 16:00:54.

May 22 15:56:52 lnxws kernel: [ 1825.551598] sd 15:0:0:2: [sdd] Assuming 
drive cache: write through
May 22 15:56:52 lnxws kernel: [ 1825.551605] sd 15:0:0:2: [sdd] Attached 
SCSI removable disk
May 22 15:59:49 lnxws kernel: [ 2003.081136] usb 10-4: USB disconnect, 
address 3
May 22 15:59:51 lnxws kernel: [ 2004.801647] usb 10-4: new high speed 
USB device using xhci_hcd and address 8
May 22 15:59:51 lnxws kernel: [ 2004.814142] usb 10-4: New USB device 
found, idVendor=04b4, idProduct=6560
May 22 15:59:51 lnxws kernel: [ 2004.814148] usb 10-4: New USB device 
strings: Mfr=0, Product=0, SerialNumber=0
May 22 15:59:51 lnxws kernel: [ 2004.814292] usb 10-4: ep 0x81 - 
rounding interval to 2048 microframes
May 22 15:59:51 lnxws kernel: [ 2004.814900] hub 10-4:1.0: USB hub found
May 22 15:59:51 lnxws kernel: [ 2004.815201] xhci_hcd 0000:03:00.0: 
WARN: short transfer on control ep
May 22 15:59:51 lnxws kernel: [ 2004.815344] hub 10-4:1.0: 4 ports detected
May 22 15:59:51 lnxws kernel: [ 2004.815353] usb 10-4: ep 0x81 - 
rounding interval to 2048 microframes
May 22 16:00:50 lnxws kernel: [ 2063.299208] usb 10-3.1: USB disconnect, 
address 7
May 22 16:00:53 lnxws kernel: [ 2067.036852] xhci_hcd 0000:03:00.0: 
WARN: transfer error on endpoint
May 22 16:00:53 lnxws kernel: [ 2067.138711] usb 10-4: reset high speed 
USB device using xhci_hcd and address 8
May 22 16:00:53 lnxws kernel: [ 2067.150545] xhci_hcd 0000:03:00.0: xHCI 
xhci_drop_endpoint called with disabled ep ffff8802028abf80
May 22 16:00:53 lnxws kernel: [ 2067.150555] usb 10-4: ep 0x81 - 
rounding interval to 2048 microframes
May 22 16:00:53 lnxws kernel: [ 2067.151074] usb 10-4: ep 0x81 - 
rounding interval to 2048 microframes
May 22 16:00:54 lnxws kernel: [ 2067.443311] usb 10-3.1: new high speed 
USB device using xhci_hcd and address 9
May 22 16:00:54 lnxws kernel: [ 2067.456831] xhci_hcd 0000:03:00.0: 
WARN: short transfer on control ep
May 22 16:00:54 lnxws kernel: [ 2067.457132] xhci_hcd 0000:03:00.0: 
WARN: short transfer on control ep
May 22 16:00:54 lnxws kernel: [ 2067.457540] xhci_hcd 0000:03:00.0: 
WARN: short transfer on control ep
May 22 16:00:54 lnxws kernel: [ 2067.457877] xhci_hcd 0000:03:00.0: 
WARN: short transfer on control ep
May 22 16:00:54 lnxws kernel: [ 2067.458019] usb 10-3.1: New USB device 
found, idVendor=054c, idProduct=0440
May 22 16:00:54 lnxws kernel: [ 2067.458026] usb 10-3.1: New USB device 
strings: Mfr=1, Product=2, SerialNumber=3
May 22 16:00:54 lnxws kernel: [ 2067.458031] usb 10-3.1: Product: DSC-HX5V
May 22 16:00:54 lnxws kernel: [ 2067.458034] usb 10-3.1: Manufacturer: Sony
May 22 16:00:54 lnxws kernel: [ 2067.458038] usb 10-3.1: SerialNumber: 
D5DAE072B2DC
May 22 16:00:54 lnxws kernel: [ 2067.459458] scsi16 : usb-storage 10-3.1:1.0
May 22 16:00:55 lnxws kernel: [ 2068.458944] scsi 16:0:0:0: 
Direct-Access     Sony     DSC              1.00 PQ: 0 ANSI: 0
May 22 16:00:55 lnxws kernel: [ 2068.459246] sd 16:0:0:0: Attached scsi 
generic sg2 type 0
May 22 16:00:55 lnxws kernel: [ 2068.459573] sd 16:0:0:0: [sdb] 15654912 
512-byte logical blocks: (8.01 GB/7.46 GiB)
May 22 16:00:55 lnxws kernel: [ 2068.459822] scsi 16:0:0:1: 
Direct-Access     Sony     DSC              1.00 PQ: 0 ANSI: 0
May 22 16:00:55 lnxws kernel: [ 2068.460130] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:00:55 lnxws kernel: [ 2068.460186] sd 16:0:0:1: Attached scsi 
generic sg3 type 0
May 22 16:00:55 lnxws kernel: [ 2068.461233] sd 16:0:0:0: [sdb] Write 
Protect is off
May 22 16:00:55 lnxws kernel: [ 2068.461239] sd 16:0:0:0: [sdb] Mode 
Sense: 03 00 00 00
May 22 16:00:55 lnxws kernel: [ 2068.461243] sd 16:0:0:0: [sdb] Assuming 
drive cache: write through
May 22 16:00:55 lnxws kernel: [ 2068.462027] scsi 16:0:0:2: 
Direct-Access     Sony     DSC              1.00 PQ: 0 ANSI: 0
May 22 16:00:55 lnxws kernel: [ 2068.462074] sd 16:0:0:1: [sdc] 92160 
512-byte logical blocks: (47.1 MB/45.0 MiB)
May 22 16:00:55 lnxws kernel: [ 2068.462410] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:00:55 lnxws kernel: [ 2068.462883] sd 16:0:0:1: [sdc] Write 
Protect is on
May 22 16:00:55 lnxws kernel: [ 2068.462889] sd 16:0:0:1: [sdc] Mode 
Sense: 03 00 80 00
May 22 16:00:55 lnxws kernel: [ 2068.462934] sd 16:0:0:1: [sdc] Assuming 
drive cache: write through
May 22 16:00:55 lnxws kernel: [ 2068.463394] sd 16:0:0:2: Attached scsi 
generic sg4 type 0
May 22 16:00:55 lnxws kernel: [ 2068.464232] sd 16:0:0:2: [sdd] 28672 
512-byte logical blocks: (14.6 MB/14.0 MiB)
May 22 16:00:55 lnxws kernel: [ 2068.465050] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:00:55 lnxws kernel: [ 2068.465489] sd 16:0:0:2: [sdd] Write 
Protect is off
May 22 16:00:55 lnxws kernel: [ 2068.465495] sd 16:0:0:2: [sdd] Mode 
Sense: 03 00 00 00
May 22 16:00:55 lnxws kernel: [ 2068.465499] sd 16:0:0:2: [sdd] Assuming 
drive cache: write through
May 22 16:00:55 lnxws kernel: [ 2068.465673] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:00:55 lnxws kernel: [ 2068.466105] sd 16:0:0:0: [sdb] Assuming 
drive cache: write through
May 22 16:00:55 lnxws kernel: [ 2068.468339]  sdb: sdb1
May 22 16:00:55 lnxws kernel: [ 2068.469028] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:00:55 lnxws kernel: [ 2068.469456] sd 16:0:0:1: [sdc] Assuming 
drive cache: write through
May 22 16:00:55 lnxws kernel: [ 2068.470502]  sdc: sdc1
May 22 16:00:55 lnxws kernel: [ 2068.470676] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:00:55 lnxws kernel: [ 2068.471103] sd 16:0:0:2: [sdd] Assuming 
drive cache: write through
May 22 16:00:55 lnxws kernel: [ 2068.471299] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:00:55 lnxws kernel: [ 2068.471699] sd 16:0:0:0: [sdb] Assuming 
drive cache: write through
May 22 16:00:55 lnxws kernel: [ 2068.471701] sd 16:0:0:0: [sdb] Attached 
SCSI removable disk
May 22 16:00:55 lnxws kernel: [ 2068.472599]  sdd: sdd1
May 22 16:00:55 lnxws kernel: [ 2068.473273] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:00:55 lnxws kernel: [ 2068.473746] sd 16:0:0:1: [sdc] Assuming 
drive cache: write through
May 22 16:00:55 lnxws kernel: [ 2068.473748] sd 16:0:0:1: [sdc] Attached 
SCSI removable disk
May 22 16:00:55 lnxws kernel: [ 2068.474272] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:00:55 lnxws kernel: [ 2068.474750] sd 16:0:0:2: [sdd] Assuming 
drive cache: write through
May 22 16:00:55 lnxws kernel: [ 2068.474752] sd 16:0:0:2: [sdd] Attached 
SCSI removable disk
May 22 16:10:10 lnxws avahi-daemon[1605]: Withdrawing address record for 
192.168.1.102 on eth0.
May 22 16:10:10 lnxws avahi-daemon[1605]: Leaving mDNS multicast group 
on interface eth0.IPv4 with address 192.168.1.102.
May 22 16:10:10 lnxws avahi-daemon[1605]: Interface eth0.IPv4 no longer 
relevant for mDNS.
May 22 16:10:35 lnxws gnomesu-pam-backend: The gnome keyring socket is 
not owned with the same credentials as the user login: 
/tmp/keyring-OgFggc/control
May 22 16:10:35 lnxws gnomesu-pam-backend: gkr-pam: couldn't unlock the 
login keyring.
May 22 16:10:50 lnxws kernel: [ 2663.004706] st: Version 20100829, fixed 
bufsize 32768, s/g segs 256
May 22 16:10:50 lnxws kernel: [ 2663.034362] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:10:50 lnxws kernel: [ 2663.036379] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:10:50 lnxws kernel: [ 2663.038302] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:10:50 lnxws kernel: [ 2663.404685] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:10:50 lnxws kernel: [ 2663.407234] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:10:50 lnxws kernel: [ 2663.409596] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:10:51 lnxws kernel: [ 2663.748314] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:10:51 lnxws kernel: [ 2663.750784] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:10:51 lnxws kernel: [ 2663.753003] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:01 lnxws kernel: [ 2674.526014] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:01 lnxws kernel: [ 2674.528042] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:01 lnxws kernel: [ 2674.529813] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:02 lnxws kernel: [ 2675.595865] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:02 lnxws kernel: [ 2675.597889] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:02 lnxws kernel: [ 2675.599673] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:03 lnxws kernel: [ 2675.831881] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:03 lnxws kernel: [ 2675.833907] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:03 lnxws kernel: [ 2675.835574] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:05 lnxws kernel: [ 2678.372497] parport_pc 00:08: disabled
May 22 16:11:05 lnxws kernel: [ 2678.388092] parport 0x378 (WARNING): 
CTR: wrote 0x0c, read 0xff
May 22 16:11:05 lnxws kernel: [ 2678.388095] parport 0x378 (WARNING): 
DATA: wrote 0xaa, read 0xff
May 22 16:11:05 lnxws kernel: [ 2678.388096] parport 0x378: You gave 
this address, but there is probably no parallel port there!
May 22 16:11:05 lnxws kernel: [ 2678.388108] parport0: PC-style at 0x378 
[PCSPP,TRISTATE]
May 22 16:11:05 lnxws kernel: [ 2678.517816] parport_pc 00:08: activated
May 22 16:11:05 lnxws kernel: [ 2678.517818] parport_pc 00:08: reported 
by Plug and Play ACPI
May 22 16:11:05 lnxws kernel: [ 2678.517861] parport0: PC-style at 
0x378, irq 7 [PCSPP,TRISTATE]
May 22 16:11:05 lnxws kernel: [ 2678.619143] lp0: using parport0 
(interrupt-driven).
May 22 16:11:05 lnxws udev-configure-printer: add /module/lp
May 22 16:11:05 lnxws udev-configure-printer: Failed to get parent
May 22 16:11:05 lnxws udev-configure-printer: add 
/devices/pnp0/00:08/printer/lp0
May 22 16:11:05 lnxws udev-configure-printer: Failed to get parent
May 22 16:11:06 lnxws kernel: [ 2679.448684] parport_pc 00:08: disabled
May 22 16:11:06 lnxws kernel: [ 2679.458406] parport 0x378 (WARNING): 
CTR: wrote 0x0c, read 0xff
May 22 16:11:06 lnxws kernel: [ 2679.458410] parport 0x378 (WARNING): 
DATA: wrote 0xaa, read 0xff
May 22 16:11:06 lnxws kernel: [ 2679.458412] parport 0x378: You gave 
this address, but there is probably no parallel port there!
May 22 16:11:06 lnxws kernel: [ 2679.458424] parport0: PC-style at 0x378 
[PCSPP,TRISTATE]
May 22 16:11:06 lnxws kernel: [ 2679.613037] ppa: Version 2.07 (for 
Linux 2.4.x)
May 22 16:11:10 lnxws kernel: [ 2682.872337] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:10 lnxws kernel: [ 2682.874644] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:10 lnxws kernel: [ 2682.876747] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:10 lnxws kernel: [ 2683.245511] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:10 lnxws kernel: [ 2683.247291] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:10 lnxws kernel: [ 2683.249210] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:10 lnxws kernel: [ 2683.524078] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:10 lnxws kernel: [ 2683.525674] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:10 lnxws kernel: [ 2683.527284] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:11 lnxws kernel: [ 2683.903224] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:11 lnxws kernel: [ 2683.904949] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint
May 22 16:11:11 lnxws kernel: [ 2683.906539] xhci_hcd 0000:03:00.0: 
WARN: Stalled endpoint

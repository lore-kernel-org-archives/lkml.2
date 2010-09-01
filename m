Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab0IAVuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 17:50:21 -0400
Received: from r2d2.schaumburger.info ([188.241.112.189]:47064 "EHLO
	r2d2.schaumburger.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0IAVuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:50:19 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Sep 2010 17:50:18 EDT
Message-ID: <4C7EC930.2070701@schaumburger.info>
Date: Wed, 01 Sep 2010 23:44:16 +0200
From: Steffen Schaumburg <steffen@schaumburger.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100831 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at fs/jbd2/journal.c:311
Content-Type: multipart/mixed;
 boundary="------------070806070106050707070900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070806070106050707070900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

 Hello,
First of all thanks for this great software :)
Now unfortunately I'm having problems with kernels 2.6.35-gentoo-r1 and
2.6.35-gentoo-r5. If I should try a vanilla kernel please tell me :)
I searched the LKML archive but couldn't find anything relevant.

The problem is twofold (the 2nd one is what I'm writing about, but the
first one may be relevant to the second one):
1. At 50004-50005 seconds after boot I got an error indicating that my
"ata3.00"/sdc is having physical problems:
[50004.996331] ata3.00: exception Emask 0x0 SAct 0xfd SErr 0x0 action 0x0
[50004.996335] ata3.00: irq_stat 0x40000008
[50004.996338] ata3.00: failed command: READ FPDMA QUEUED
[50004.996344] ata3.00: cmd 60/08:18:25:2c:63/00:00:54:00:00/40 tag 3
ncq 4096 in
[50004.996345]          res 41/40:04:29:2c:63/00:00:54:00:00/40 Emask
0x409 (media error) <F>
[50004.996348] ata3.00: status: { DRDY ERR }
[50004.996350] ata3.00: error: { UNC }
[50005.009325] ata3.00: configured for UDMA/133
[50005.009343] ata3: EH complete

2. At 163096 seconds after boot I get this message in the log: "kernel
BUG at fs/jbd2/journal.c:311!" (see attached full dmesg - most of it is
relevant anyways, and I didn't want to miss vital information, so I
attached the whole thing - I hope that was the right thing to do)

Is this really a kernel bug, or is it just that I have a dying drive?
Normally I would assume the latter, but since there's been so many hours
between the two error messages I'm not so sure.

I have gotten the error message in both the -r1 and -r5 kernel, but I
cannot reproduce the problem with any particular steps. When the error
happens then various processes (usually firefox and thunderbird first)
go into D state and are unkillable. Both times I proceeded to quit as
many applications as I could, umounted whatever partitions I could, and
remounted the remainder as read-only.
I have 4 SATA drives (1*1TB, 3*1.5TB) on my AMD/ATI 780series chipset
controller, running MDRAID (on /boot and /) and LVM-on-MDRAID for
everything else.

I would be most grateful for any advice! I am subscribed to LKML so you
don't need to CC me.

Thanks, Steffen

--------------070806070106050707070900
Content-Type: text/plain;
 name="dmesg2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg2.txt"

80] ata6: SATA link down (SStatus 0 SControl 300)
[    2.976512] ata4.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
[    2.976611] ata4.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.976628] ata3.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
[    2.976631] ata3.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.977034] ata5.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
[    2.979335] ata5.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.983342] ata3.00: configured for UDMA/133
[    2.985802] ata4.00: configured for UDMA/133
[    2.988231] ata5.00: configured for UDMA/133
[    3.370051] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.373673] ata1.00: ATA-8: Hitachi HDT721010SLA360, ST6OA31B, max UDMA/133
[    3.376289] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.380252] ata1.00: configured for UDMA/133
[    3.400185] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDT72101 ST6O PQ: 0 ANSI: 5
[    3.403307] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.403433] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
[    3.403583] sd 2:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    3.403657] sd 2:0:0:0: [sdb] Write Protect is off
[    3.403659] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.403682] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.403728] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
[    3.403819]  sdb:
[    3.403910] sd 3:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    3.403967] sd 3:0:0:0: [sdc] Write Protect is off
[    3.403970] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    3.403993] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.404030] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
[    3.404122]  sdc:
[    3.404182] sd 4:0:0:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    3.404240] sd 4:0:0:0: [sdd] Write Protect is off
[    3.404242] sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    3.404265] sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.404378]  sdd: sdc1 sdc2 sdc3 sdc4 sdc5 sdc6
[    3.457344] sd 0:0:0:0: [sda] Write Protect is off
[    3.457621] sd 3:0:0:0: [sdc] Attached SCSI disk
[    3.458894]  sdb1 sdb2 sdb3 sdb4 sdb5 sdb6
[    3.468109] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.468183] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.468541] sd 2:0:0:0: [sdb] Attached SCSI disk
[    3.475753]  sda: sdd1 sdd2 sdd3 sdd4 sdd5 sdd6
[    3.492946] sd 4:0:0:0: [sdd] Attached SCSI disk
[    3.508321]  sda1 sda2 sda3 sda4 sda5
[    3.512698] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.538549] registered taskstats version 1
[    3.542602] md: Waiting for all devices to be available before autodetect
[    3.546523] md: If you don't use raid, use raid=noautodetect
[    3.550666] md: Autodetecting RAID arrays.
[    3.603295] md: invalid raid superblock magic on sdb2
[    3.607320] md: sdb2 does not have a valid v0.90 superblock, not importing!
[    3.639212] md: invalid raid superblock magic on sdb4
[    3.643224] md: sdb4 does not have a valid v0.90 superblock, not importing!
[    3.707524] md: Scanned 8 and added 6 devices.
[    3.711607] md: autorun ...
[    3.715668] md: considering sda4 ...
[    3.719745] md:  adding sda4 ...
[    3.723841] md: sda2 has different UUID to sda4
[    3.727980] md:  adding sdd4 ...
[    3.732060] md: sdd2 has different UUID to sda4
[    3.732064] md:  adding sdc4 ...
[    3.732067] md: sdc2 has different UUID to sda4
[    3.744464] md: created md1
[    3.748473] md: bind<sdc4>
[    3.752518] md: bind<sdd4>
[    3.756481] md: bind<sda4>
[    3.760438] md: running: <sda4><sdd4><sdc4>
[    3.764541] md/raid:md1: device sda4 operational as raid disk 0
[    3.768514] md/raid:md1: device sdd4 operational as raid disk 1
[    3.772434] md/raid:md1: device sdc4 operational as raid disk 2
[    3.776500] md/raid:md1: allocated 3222kB
[    3.780389] md/raid:md1: raid level 5 active with 3 out of 3 devices, algorithm 2
[    3.784242] RAID conf printout:
[    3.784244]  --- level:5 rd:3 wd:3
[    3.784245]  disk 0, o:1, dev:sda4
[    3.784247]  disk 1, o:1, dev:sdd4
[    3.784248]  disk 2, o:1, dev:sdc4
[    3.784277] md1: detected capacity change from 0 to 10741612544
[    3.788212] md: considering sda2 ...
[    3.792034] md:  adding sda2 ...
[    3.795865] md:  adding sdd2 ...
[    3.799694] md:  adding sdc2 ...
[    3.803482] md: created md0
[    3.807183] md: bind<sdc2>
[    3.810866] md: bind<sdd2>
[    3.814474] md: bind<sda2>
[    3.818003] md: running: <sda2><sdd2><sdc2>
[    3.821682] md/raid1:md0: active with 3 out of 3 mirrors
[    3.825191] md0: detected capacity change from 0 to 205520896
[    3.828788] md: ... autorun DONE.
[    3.832296] md1: detected capacity change from 0 to 10741612544
[    3.835785]  md1: unknown partition table
[    3.847616] EXT3-fs (md1): error: couldn't mount because of unsupported optional features (240)
[    3.851266] EXT2-fs (md1): error: couldn't mount because of unsupported optional features (240)
[    3.871313] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
[    3.874748] VFS: Mounted root (ext4 filesystem) readonly on device 9:1.
[    3.878164] Freeing unused kernel memory: 396k freed
[    5.334227] udev: starting version 161
[    5.413072] ACPI: acpi_idle registered with cpuidle
[    5.419343] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    5.419375] ACPI: Power Button [PWRB]
[    5.419422] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    5.419437] ACPI: Power Button [PWRF]
[    5.423314] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.423350] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    5.435001] scsi6 : pata_atiixp
[    5.436049] scsi7 : pata_atiixp
[    5.437342] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    5.437345] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    5.441673] ACPI: WMI: Mapper loaded
[    5.450900] ATL1E 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.450912] ATL1E 0000:02:00.0: setting latency timer to 64
[    5.452732] usbcore: registered new interface driver usbfs
[    5.452745] usbcore: registered new interface driver hub
[    5.453824] usbcore: registered new device driver usb
[    5.483632]  md0: unknown partition table
[    5.496511] FDC 0 is a post-1991 82077
[    5.523851] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.523881] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.523936] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    5.523943] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 1
[    5.523980] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfbcfd000
[    5.557301] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.557304] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    5.596558] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    5.596561] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.596564] usb usb1: Product: OHCI Host Controller
[    5.596566] usb usb1: Manufacturer: Linux 2.6.35-gentoo-r5 ohci_hcd
[    5.596568] usb usb1: SerialNumber: 0000:00:12.0
[    5.596658] hub 1-0:1.0: USB hub found
[    5.596665] hub 1-0:1.0: 3 ports detected
[    5.596748] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.596790] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    5.596795] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 2
[    5.596813] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfbcfe000
[    5.603157] ata7.00: ATAPI: DVD-RW IDE1008, VER 0256, max UDMA/66
[    5.641671] ata7.00: configured for UDMA/66
[    5.642746] scsi 6:0:0:0: CD-ROM            DVDRW    IDE1008          0256 PQ: 0 ANSI: 5
[    5.666579] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.666583] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.666585] usb usb2: Product: OHCI Host Controller
[    5.666586] usb usb2: Manufacturer: Linux 2.6.35-gentoo-r5 ohci_hcd
[    5.666588] usb usb2: SerialNumber: 0000:00:12.1
[    5.666675] hub 2-0:1.0: USB hub found
[    5.666681] hub 2-0:1.0: 3 ports detected
[    5.666753] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.666788] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    5.666793] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 3
[    5.666811] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfbcfb000
[    5.736559] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.736563] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.736565] usb usb3: Product: OHCI Host Controller
[    5.736567] usb usb3: Manufacturer: Linux 2.6.35-gentoo-r5 ohci_hcd
[    5.736568] usb usb3: SerialNumber: 0000:00:13.0
[    5.736651] hub 3-0:1.0: USB hub found
[    5.736657] hub 3-0:1.0: 3 ports detected
[    5.736730] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.736766] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    5.736771] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 4
[    5.736790] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfbcfc000
[    5.776694] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    5.776703] Uniform CD-ROM driver Revision: 3.20
[    5.776819] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    5.781361] udev: renamed network interface eth0 to eth2
[    5.806608] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.806612] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.806614] usb usb4: Product: OHCI Host Controller
[    5.806616] usb usb4: Manufacturer: Linux 2.6.35-gentoo-r5 ohci_hcd
[    5.806618] usb usb4: SerialNumber: 0000:00:13.1
[    5.806706] hub 4-0:1.0: USB hub found
[    5.806713] hub 4-0:1.0: 3 ports detected
[    5.806785] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.806828] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    5.806833] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 5
[    5.806852] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfbcfa000
[    5.876569] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.876573] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.876575] usb usb5: Product: OHCI Host Controller
[    5.876577] usb usb5: Manufacturer: Linux 2.6.35-gentoo-r5 ohci_hcd
[    5.876578] usb usb5: SerialNumber: 0000:00:14.5
[    5.876671] hub 5-0:1.0: USB hub found
[    5.876678] hub 5-0:1.0: 2 ports detected
[    5.876785] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.876828] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    5.876838] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 6
[    5.876871] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    5.876884] ehci_hcd 0000:00:12.2: debug port 1
[    5.876909] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfbcff800
[    5.900023] md: bind<sda5>
[    5.942543] usb 1-2: new low speed USB device using ohci_hcd and address 2
[    5.945406] rtc_cmos 00:03: RTC can wake from S4
[    5.945475] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.945505] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    5.961280] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    5.961309] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    5.961312] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.961315] usb usb6: Product: EHCI Host Controller
[    5.961316] usb usb6: Manufacturer: Linux 2.6.35-gentoo-r5 ehci_hcd
[    5.961318] usb usb6: SerialNumber: 0000:00:12.2
[    5.961405] hub 6-0:1.0: USB hub found
[    5.961409] hub 6-0:1.0: 6 ports detected
[    5.961491] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.961530] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    5.961536] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 7
[    5.961557] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    5.961569] ehci_hcd 0000:00:13.2: debug port 1
[    5.961591] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfbcff400
[    5.989746] md: bind<sdb5>
[    6.022554] hub 1-0:1.0: unable to enumerate USB device on port 2
[    6.028769] md: bind<sdd6>
[    6.040046] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    6.040072] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    6.040074] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.040076] usb usb7: Product: EHCI Host Controller
[    6.040078] usb usb7: Manufacturer: Linux 2.6.35-gentoo-r5 ehci_hcd
[    6.040080] usb usb7: SerialNumber: 0000:00:13.2
[    6.040172] hub 7-0:1.0: USB hub found
[    6.040177] hub 7-0:1.0: 6 ports detected
[    6.046478] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.062456] md: bind<sdb6>
[    6.093924] md: bind<sdd5>
[    6.114766] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.114823] HDA Intel 0000:01:05.1: setting latency timer to 64
[    6.116091] md: bind<sdc6>
[    6.117763] md/raid:md3: device sdc6 operational as raid disk 1
[    6.117766] md/raid:md3: device sdb6 operational as raid disk 2
[    6.117769] md/raid:md3: device sdd6 operational as raid disk 0
[    6.118002] md/raid:md3: allocated 3222kB
[    6.118026] md/raid:md3: raid level 5 active with 3 out of 3 devices, algorithm 2
[    6.118028] RAID conf printout:
[    6.118029]  --- level:5 rd:3 wd:3
[    6.118031]  disk 0, o:1, dev:sdd6
[    6.118032]  disk 1, o:1, dev:sdc6
[    6.118034]  disk 2, o:1, dev:sdb6
[    6.118063] md3: detected capacity change from 0 to 1000193777664
[    6.118862] md: bind<sdc5>
[    6.119101] md3: detected capacity change from 0 to 1000193777664
[    6.119113]  md3:
[    6.120730] md/raid:md2: device sdc5 operational as raid disk 2
[    6.120734] md/raid:md2: device sdd5 operational as raid disk 1
[    6.120736] md/raid:md2: device sdb5 operational as raid disk 3
[    6.120737] md/raid:md2: device sda5 operational as raid disk 0
[    6.120974] md/raid:md2: allocated 4272kB
[    6.121010] md/raid:md2: raid level 5 active with 4 out of 4 devices, algorithm 2
[    6.121012] RAID conf printout:
[    6.121013]  --- level:5 rd:4 wd:4
[    6.121015]  disk 0, o:1, dev:sda5
[    6.121016]  disk 1, o:1, dev:sdd5
[    6.121017]  disk 2, o:1, dev:sdc5
[    6.121019]  disk 3, o:1, dev:sdb5
[    6.121049] md2: detected capacity change from 0 to 2977385938944
[    6.122211] md2: detected capacity change from 0 to 2977385938944
[    6.122221]  md2: unknown partition table
[    6.153813]  unknown partition table
[    6.532539] usb 1-2: new low speed USB device using ohci_hcd and address 3
[    6.715710] usb 1-2: New USB device found, idVendor=046d, idProduct=c517
[    6.715714] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.715717] usb 1-2: Product: USB Receiver
[    6.715718] usb 1-2: Manufacturer: Logitech
[    6.774301] usbcore: registered new interface driver usbhid
[    6.774304] usbhid: USB HID core driver
[    6.780919] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb1/1-2/1-2:1.0/input/input2
[    6.780957] logitech 0003:046D:C517.0001: input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:12.0-2/input0
[    6.788716] logitech 0003:046D:C517.0002: fixing up Logitech keyboard report descriptor
[    6.789233] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb1/1-2/1-2:1.1/input/input3
[    6.789283] logitech 0003:046D:C517.0002: input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-2/input1
[    8.378627] fuse init (API version 7.14)
[    8.425231] loop: module loaded
[    8.473673] usbcore: registered new interface driver libusual
[    8.487557] Initializing USB Mass Storage driver...
[    8.487601] usbcore: registered new interface driver usb-storage
[    8.487603] USB Mass Storage support registered.
[    8.532510] ip_tables: (C) 2000-2006 Netfilter Core Team
[    8.575589] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    8.575712] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    8.575714] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[    8.575715] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    8.839643] kvm: Nested Virtualization enabled
[    8.839648] kvm: Nested Paging enabled
[    8.907740] tun: Universal TUN/TAP device driver, 1.6
[    8.907743] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    8.935349] PPP generic driver version 2.4.2
[    8.969975] PPP Deflate Compression module registered
[   23.120190] EXT4-fs (md1): re-mounted. Opts: data=ordered
[   23.369958] EXT4-fs (dm-10): mounted filesystem with ordered data mode. Opts: data=ordered
[   23.670823] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: data=ordered
[   23.730603] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: data=ordered
[   23.833076] EXT4-fs (dm-14): mounted filesystem with ordered data mode. Opts: data=ordered
[   23.910240] EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: data=ordered
[   23.935319] EXT4-fs (dm-13): mounted filesystem with ordered data mode. Opts: data=ordered
[   24.027384] EXT4-fs (dm-11): mounted filesystem with ordered data mode. Opts: data=ordered
[   24.123952] EXT4-fs (dm-7): mounted filesystem with ordered data mode. Opts: data=ordered
[   24.170259] EXT4-fs (dm-6): mounted filesystem with ordered data mode. Opts: data=ordered
[   24.202734] EXT4-fs (dm-12): mounted filesystem with ordered data mode. Opts: data=ordered
[   24.255901] EXT4-fs (dm-9): mounted filesystem with ordered data mode. Opts: data=ordered
[   24.434302] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: data=ordered
[   24.695662] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: data=ordered
[   24.884064] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: data=ordered
[   24.963100] EXT4-fs (dm-15): mounted filesystem with ordered data mode. Opts: data=ordered
[   25.013343] EXT4-fs (dm-16): mounted filesystem with ordered data mode. Opts: data=ordered
[   25.082792] EXT4-fs (dm-17): mounted filesystem with ordered data mode. Opts: data=ordered
[   25.164003] EXT4-fs (dm-18): mounted filesystem with ordered data mode. Opts: data=ordered
[   25.199584] EXT4-fs (dm-19): mounted filesystem with ordered data mode. Opts: data=ordered
[   25.238329] EXT4-fs (dm-20): mounted filesystem with ordered data mode. Opts: data=ordered
[   25.279022] EXT4-fs (dm-21): mounted filesystem with ordered data mode. Opts: data=ordered
[   25.425688] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: data=ordered
[   25.454177] EXT4-fs (dm-22): mounted filesystem with ordered data mode. Opts: data=ordered
[   27.431371] Adding 2104508k swap on /dev/sda3.  Priority:1 extents:1 across:2104508k 
[   27.446348] Adding 2104508k swap on /dev/sdc3.  Priority:1 extents:1 across:2104508k 
[   28.613827] ATL1E 0000:02:00.0: irq 41 for MSI/MSI-X
[   28.613960] ATL1E 0000:02:00.0: eth2: NIC Link is Up <1000 Mbps Full Duplex>
[   28.940807] NET: Registered protocol family 17
[   35.609968] Bridge firewalling registered
[27552.545208] conftest[4654]: segfault at 0 ip (null) sp 00007fffae09ddd8 error 14 in conftest[400000+1000]
[38936.201200] test_18576[18969]: segfault at 0 ip 00000000004006a9 sp 00007fff3075a760 error 4 in test_18576[400000+1000]
[49877.904994] UDF-fs: No anchor found
[49877.904999] UDF-fs: Rescanning with blocksize 2048
[49877.905718] UDF-fs: Partition marked readonly; forcing readonly mount
[49877.905740] UDF-fs INFO UDF: Mounting volume 'Civ IV Complete', timestamp 2009/04/03 18:22 (1078)
[50004.996331] ata3.00: exception Emask 0x0 SAct 0xfd SErr 0x0 action 0x0
[50004.996335] ata3.00: irq_stat 0x40000008
[50004.996338] ata3.00: failed command: READ FPDMA QUEUED
[50004.996344] ata3.00: cmd 60/08:18:25:2c:63/00:00:54:00:00/40 tag 3 ncq 4096 in
[50004.996345]          res 41/40:04:29:2c:63/00:00:54:00:00/40 Emask 0x409 (media error) <F>
[50004.996348] ata3.00: status: { DRDY ERR }
[50004.996350] ata3.00: error: { UNC }
[50005.009325] ata3.00: configured for UDMA/133
[50005.009343] ata3: EH complete
[113869.395312] udev: starting version 161
[138475.131312] usb 6-3: new high speed USB device using ehci_hcd and address 3
[138475.297691] usb 6-3: New USB device found, idVendor=04e8, idProduct=6603
[138475.297696] usb 6-3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[138475.297698] usb 6-3: Product: Samsung Android USB Device
[138475.297700] usb 6-3: Manufacturer: Qualcomm Incorporated
[138475.297702] usb 6-3: SerialNumber: I7500kVA5dEymM0
[138475.299089] scsi8 : usb-storage 6-3:2.0
[138476.293332] scsi 8:0:0:0: Direct-Access     Samsung  SAMSUNG Android  Mass PQ: 0 ANSI: 2
[138476.295319] scsi 8:0:0:1: Direct-Access     Samsung  SAMSUNG Android  Mass PQ: 0 ANSI: 2
[138476.310319] sd 8:0:0:0: [sde] Attached SCSI removable disk
[138476.313328] sd 8:0:0:1: [sdf] Attached SCSI removable disk
[138827.560364] usb 6-3: USB disconnect, address 3
[162174.135240] ATL1E 0000:02:00.0: eth2: NIC Link is Down
[162180.018199] ATL1E 0000:02:00.0: eth2: NIC Link is Up <1000 Mbps Full Duplex>
[162189.513522] ATL1E 0000:02:00.0: eth2: NIC Link is Down
[162227.020069] ATL1E 0000:02:00.0: eth2: NIC Link is Up <1000 Mbps Full Duplex>
[162489.468752] ATL1E 0000:02:00.0: eth2: NIC Link is Down
[162491.667593] ATL1E 0000:02:00.0: eth2: NIC Link is Up <1000 Mbps Full Duplex>
[162500.617439] ATL1E 0000:02:00.0: eth2: NIC Link is Down
[162538.006740] ATL1E 0000:02:00.0: eth2: NIC Link is Up <1000 Mbps Full Duplex>
[163096.021322] ------------[ cut here ]------------
[163096.021327] kernel BUG at fs/jbd2/journal.c:311!
[163096.021329] invalid opcode: 0000 [#1] SMP 
[163096.021332] last sysfs file: /sys/devices/pci0000:00/0000:00:12.2/usb6/6-3/6-3:2.0/host8/target8:0:0/8:0:0:1/block/sdf/queue/logical_block_size
[163096.021335] CPU 1 
[163096.021336] Modules linked in: udf crc_itu_t ipt_addrtype xt_DSCP xt_string xt_NFQUEUE xt_mark xt_hashlimit xt_connmark bridge stp llc af_packet snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ppp_deflate zlib_deflate zlib_inflate ppp_synctty ppp_async ppp_generic slhc crc_ccitt tun kvm_amd kvm ipt_REDIRECT xt_multiport xt_mac xt_iprange nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE ipt_REJECT iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables usb_storage usb_libusual cifs loop vfat fat fuse nls_iso8859_1 nls_cp437 nls_utf8 hid_logitech usbhid hid snd_hda_codec_atihdmi snd_hda_codec_via snd_hda_intel snd_hda_codec rtc_cmos snd_pcm sr_mod rtc_core snd_timer cdrom k10temp ehci_hcd asus_atk0110 ohci_hcd rtc_lib psmouse floppy snd soundcore atl1e hwmon usbcore wmi thermal pata_atiixp button processor snd_page_alloc nls_base
[163096.021381] 
[163096.021384] Pid: 2783, comm: jbd2/dm-8-8 Not tainted 2.6.35-gentoo-r5 #1 M4A78 PRO/System Product Name
[163096.021387] RIP: 0010:[<ffffffff811a39b2>]  [<ffffffff811a39b2>] jbd2_journal_write_metadata_buffer+0x402/0x410
[163096.021395] RSP: 0018:ffff88011db77cb0  EFLAGS: 00010246
[163096.021396] RAX: 0000000000020000 RBX: ffff88011d9f05e0 RCX: 0000000000109b0e
[163096.021398] RDX: ffff88011db77e28 RSI: ffff88011d9f05e0 RDI: ffff88011fe43480
[163096.021400] RBP: ffff88011fe434a0 R08: 0000000000000000 R09: 0000000000000001
[163096.021402] R10: ffffea0000e22eb8 R11: 0000000000000000 R12: ffff88011c5b6000
[163096.021404] R13: ffff88011d9f05e0 R14: ffff88011c5b6024 R15: ffff8801172c5208
[163096.021407] FS:  00007f6ce23f18c0(0000) GS:ffff880001880000(0000) knlGS:0000000055717d00
[163096.021409] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[163096.021410] CR2: 00007f64a0351000 CR3: 00000000c9496000 CR4: 00000000000006e0
[163096.021412] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[163096.021414] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[163096.021416] Process jbd2/dm-8-8 (pid: 2783, threadinfo ffff88011db76000, task ffff88011d9f4730)
[163096.021418] Stack:
[163096.021419]  0000000000000020 0000000000000206 ffff88011fbaa460 0000000000109b0e
[163096.021422] <0> 0000000000001000 ffff8800a74449b0 ffff88011fbaa380 ffff88011fe43480
[163096.021425] <0> ffff8801172c5208 ffff88011c5b6000 ffff88011db77e28 0000000000109b0e
[163096.021429] Call Trace:
[163096.021433]  [<ffffffff8119e493>] ? jbd2_journal_commit_transaction+0x4e3/0x1170
[163096.021437]  [<ffffffff81044453>] ? lock_timer_base+0x33/0x70
[163096.021440]  [<ffffffff810447c4>] ? try_to_del_timer_sync+0x64/0x90
[163096.021443]  [<ffffffff811a2afc>] ? kjournald2+0xac/0x200
[163096.021446]  [<ffffffff8104fae0>] ? autoremove_wake_function+0x0/0x30
[163096.021449]  [<ffffffff811a2a50>] ? kjournald2+0x0/0x200
[163096.021451]  [<ffffffff8104f65e>] ? kthread+0x8e/0xa0
[163096.021455]  [<ffffffff81003094>] ? kernel_thread_helper+0x4/0x10
[163096.021457]  [<ffffffff8104f5d0>] ? kthread+0x0/0xa0
[163096.021460]  [<ffffffff81003090>] ? kernel_thread_helper+0x0/0x10
[163096.021461] Code: ff ff 48 8b 55 00 f7 c2 00 00 40 00 0f 84 b4 fd ff ff f3 90 eb ec 48 8b 45 00 a9 00 00 40 00 0f 84 79 fc ff ff f3 90 66 90 eb eb <0f> 0b eb fe 90 90 90 90 90 90 90 90 90 90 53 48 89 fb 48 8b bf 
[163096.021483] RIP  [<ffffffff811a39b2>] jbd2_journal_write_metadata_buffer+0x402/0x410
[163096.021487]  RSP <ffff88011db77cb0>
[163096.021489] ---[ end trace 9d6952cd0aaab4ad ]---
[165174.801426] ATL1E 0000:02:00.0: eth2: NIC Link is Down
[165177.013875] ATL1E 0000:02:00.0: eth2: NIC Link is Up <1000 Mbps Full Duplex>
[165186.389684] ATL1E 0000:02:00.0: eth2: NIC Link is Down
[165222.076000] ATL1E 0000:02:00.0: eth2: NIC Link is Up <1000 Mbps Full Duplex>
[166310.542221] ATL1E 0000:02:00.0: eth2: NIC Link is Down
[166312.662071] ATL1E 0000:02:00.0: eth2: NIC Link is Up <1000 Mbps Full Duplex>
[166321.678845] ATL1E 0000:02:00.0: eth2: NIC Link is Down
[166364.632330] ATL1E 0000:02:00.0: eth2: NIC Link is Up <1000 Mbps Full Duplex>
[166947.280039] usb 6-3: new high speed USB device using ehci_hcd and address 4
[166947.447646] usb 6-3: New USB device found, idVendor=04e8, idProduct=6603
[166947.447651] usb 6-3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[166947.447653] usb 6-3: Product: Samsung Android USB Device
[166947.447655] usb 6-3: Manufacturer: Qualcomm Incorporated
[166947.447657] usb 6-3: SerialNumber: I7500kVA5dEymM0
[166947.449047] scsi9 : usb-storage 6-3:2.0
[166948.448880] scsi 9:0:0:0: Direct-Access     Samsung  SAMSUNG Android  Mass PQ: 0 ANSI: 2
[166948.450872] scsi 9:0:0:1: Direct-Access     Samsung  SAMSUNG Android  Mass PQ: 0 ANSI: 2
[166948.491030] sd 9:0:0:0: [sde] Attached SCSI removable disk
[166948.495904] sd 9:0:0:1: [sdf] Attached SCSI removable disk
[167573.135829] BUG: unable to handle kernel paging request at 0000000100ffa2f8
[167573.135836] IP: [<ffffffff8119c0c4>] __jbd2_journal_file_buffer+0x104/0x200
[167573.135844] PGD 11fe24067 PUD 0 
[167573.135847] Oops: 0002 [#2] SMP 
[167573.135849] last sysfs file: /sys/devices/pci0000:00/0000:00:12.2/usb6/6-3/6-3:2.0/host9/target9:0:0/9:0:0:1/block/sdf/queue/logical_block_size
[167573.135853] CPU 2 
[167573.135854] Modules linked in: udf crc_itu_t ipt_addrtype xt_DSCP xt_string xt_NFQUEUE xt_mark xt_hashlimit xt_connmark bridge stp llc af_packet snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ppp_deflate zlib_deflate zlib_inflate ppp_synctty ppp_async ppp_generic slhc crc_ccitt tun kvm_amd kvm ipt_REDIRECT xt_multiport xt_mac xt_iprange nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE ipt_REJECT iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables usb_storage usb_libusual cifs loop vfat fat fuse nls_iso8859_1 nls_cp437 nls_utf8 hid_logitech usbhid hid snd_hda_codec_atihdmi snd_hda_codec_via snd_hda_intel snd_hda_codec rtc_cmos snd_pcm sr_mod rtc_core snd_timer cdrom k10temp ehci_hcd asus_atk0110 ohci_hcd rtc_lib psmouse floppy snd soundcore atl1e hwmon usbcore wmi thermal pata_atiixp button processor snd_page_alloc nls_base
[167573.135901] 
[167573.135904] Pid: 3976, comm: firefox Tainted: G      D     2.6.35-gentoo-r5 #1 M4A78 PRO/System Product Name
[167573.135907] RIP: 0010:[<ffffffff8119c0c4>]  [<ffffffff8119c0c4>] __jbd2_journal_file_buffer+0x104/0x200
[167573.135911] RSP: 0018:ffff88011a5a7b98  EFLAGS: 00010282
[167573.135913] RAX: ffff880062e68ae0 RBX: ffff88011f969128 RCX: ffff88011f969128
[167573.135915] RDX: 0000000100ffa2c0 RSI: ffff88011f969128 RDI: ffff88011f969128
[167573.135917] RBP: ffff88011d9f07c0 R08: ffff88011d932724 R09: 0000000000000000
[167573.135919] R10: ffff88011d932400 R11: 0000000000001000 R12: ffff8800a3548af0
[167573.135921] R13: 0000000000000001 R14: 0000000000000001 R15: ffff88010f3eb4e0
[167573.135924] FS:  00007f46dfcce720(0000) GS:ffff880001900000(0000) knlGS:00000000094cd830
[167573.135926] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[167573.135928] CR2: 0000000100ffa2f8 CR3: 0000000119a66000 CR4: 00000000000006e0
[167573.135930] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[167573.135932] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[167573.135934] Process firefox (pid: 3976, threadinfo ffff88011a5a6000, task ffff88011a1ab910)
[167573.135936] Stack:
[167573.135937]  ffff88011f969128 ffff88010f3eb4e0 ffff88011c5b6800 ffff8800a3548af2
[167573.135940] <0> 0000000000001499 ffffffff8119c4b5 ffff880108d9d6d8 ffff88010f3eb4e0
[167573.135944] <0> ffffffff8146e137 ffff8800a3548af0 0000000000000000 ffffffff81186d43
[167573.135947] Call Trace:
[167573.135951]  [<ffffffff8119c4b5>] ? jbd2_journal_dirty_metadata+0xd5/0x120
[167573.135955]  [<ffffffff81186d43>] ? __ext4_handle_dirty_metadata+0x73/0x100
[167573.135958]  [<ffffffff8117a1d9>] ? ext4_group_desc_csum+0x69/0xa0
[167573.135961]  [<ffffffff8116a14c>] ? ext4_new_inode+0x6cc/0xf80
[167573.135964]  [<ffffffff8117ede8>] ? ext4_journal_start_sb+0xf8/0x130
[167573.135967]  [<ffffffff810c8f47>] ? __d_lookup+0x97/0x120
[167573.135971]  [<ffffffff8117679c>] ? ext4_create+0xbc/0x150
[167573.135975]  [<ffffffff810c0533>] ? vfs_create+0xb3/0x100
[167573.135977]  [<ffffffff810c113f>] ? do_last+0x5df/0x6c0
[167573.135980]  [<ffffffff810c3141>] ? do_filp_open+0x1f1/0x630
[167573.135984]  [<ffffffff810b3e0a>] ? do_sys_open+0x6a/0x140
[167573.135987]  [<ffffffff8100236b>] ? system_call_fastpath+0x16/0x1b
[167573.135989] Code: 24 c5 d8 02 47 81 90 48 8d 55 20 0f 1f 40 00 48 8b 02 48 85 c0 0f 84 84 00 00 00 48 8b 50 40 48 89 43 38 48 89 53 40 48 89 58 40 <48> 89 5a 38 45 85 f6 44 89 6b 0c 74 07 f0 41 80 4c 24 02 20 48 
[167573.136010] RIP  [<ffffffff8119c0c4>] __jbd2_journal_file_buffer+0x104/0x200
[167573.136014]  RSP <ffff88011a5a7b98>
[167573.136015] CR2: 0000000100ffa2f8
[167573.136017] ---[ end trace 9d6952cd0aaab4ae ]---

--------------070806070106050707070900--

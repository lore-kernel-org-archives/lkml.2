Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1KWLM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:12:57 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:35792 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab1KWLMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:12:53 -0500
Date: Wed, 23 Nov 2011 13:12:51 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: 3.2.0-rc2+git: possible recursive locking detected in process memory
 freeing
Message-ID: <alpine.SOC.1.00.1111231311490.15939@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is 3.2.0-rc2-00143-ga767835 kernel on Sun Fire V100 (64-bit sparc). 
It gives the locking warning on bootup but seems to work fine otherwise 
(apt-get dist-upgrade saw no problems). It did not happen on a very 
similar Netra X1 but the kernel conf might have been different there 
(have not verified).

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.0.18 2002/05/23 18:22'
[    0.000000] PROMLIB: Root node compatible: sun4u
[    0.000000] Linux version 3.2.0-rc2-00143-ga767835 (mroos@janku) (gcc version 4.6.1 (Debian 4.6.1-16) ) #8 Sun Nov 20 16:13:26 EET 2011
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 00:03:ba:11:b3:71
[    0.000000] Kernel: Using 4 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /pci@1f,0/isa@7/serial@0,3f8
[    0.000000] PROM: Built device tree with 46446 bytes of memory.
[    0.000000] Top of RAM: 0x6fec6000, Total RAM: 0x3fe34000
[    0.000000] Memory hole size: 768MB
[    0.000000] [0000010000000000-fffff80000400000] page_structs=131072 node=0 entry=0/8192
[    0.000000] [0000010000000000-fffff80000800000] page_structs=131072 node=0 entry=1/8192
[    0.000000] [0000010000800000-fffff80000c00000] page_structs=131072 node=0 entry=2/8192
[    0.000000] [0000010000800000-fffff80001000000] page_structs=131072 node=0 entry=3/8192
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x00000000 -> 0x00037f63
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00008000
[    0.000000]     0: 0x00010000 -> 0x00018000
[    0.000000]     0: 0x00020000 -> 0x00028000
[    0.000000]     0: 0x00030000 -> 0x000377ff
[    0.000000]     0: 0x00037800 -> 0x00037f00
[    0.000000]     0: 0x00037f40 -> 0x00037f58
[    0.000000]     0: 0x00037f60 -> 0x00037f63
[    0.000000] On node 0 totalpages: 130842
[    0.000000]   Normal zone: 1791 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 129051 pages, LIFO batch:15
[    0.000000] Booting Linux...
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
[    0.000000] CPU CAPS: [vis]
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129051
[    0.000000] Kernel command line: ro root=/dev/sda2 debug ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 524288 bytes)
[    0.000000] Memory: 1015056k available (3120k kernel code, 1504k data, 176k init) [fffff80000000000,000000006fec6000]
[    0.000000] NR_IRQS:255
[    0.000000] clocksource: mult[b400012e] shift[24]
[    0.000000] clockevent: mult[16c16bf] shift[32]
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[   60.911816] Calibrating delay using timer specific routine.. 11.14 BogoMIPS (lpj=55711)
[   60.911876] pid_max: default: 32768 minimum: 301
[   60.912333] Security Framework initialized
[   60.912591] Mount-cache hash table entries: 512
[   60.919688] NET: Registered protocol family 16
[   60.921424] kworker/u:0 used greatest stack depth: 11088 bytes left
[   60.963278] /pci@1f,0: PCI IO[1fe02000000] MEM[1ff00000000]
[   60.963527] /pci@1f,0: SABRE PCI Bus Module ver[0:0]
[   60.963566] PCI: Scanning PBM /pci@1f,0
[   60.965601] pci 0000:00:03.0: quirk: [io  0x1fe02002000-0x1fe0200203f] claimed by ali7101 ACPI
[   60.965678] pci 0000:00:03.0: quirk: [io  0x1fe02004000-0x1fe0200401f] claimed by ali7101 SMB
[   60.966007] pci 0000:00:0c.0: PME# supported from D3hot D3cold
[   60.966130] pci 0000:00:0c.0: PME# disabled
[   60.966410] pci 0000:00:05.0: PME# supported from D3hot D3cold
[   60.966481] pci 0000:00:05.0: PME# disabled
[   61.002223] kworker/u:0 used greatest stack depth: 9880 bytes left
[   61.010192] bio: create slab <bio-0> at 0
[   61.013565] vgaarb: loaded
[   61.015963] SCSI subsystem initialized
[   61.018057] libata version 3.00 loaded.
[   61.022702] /pci@1f,0/isa@7/rtc@0,70: RTC regs at 0x1fe02000070
[   61.026955] Switching to clocksource hbtick
[   61.080668] NET: Registered protocol family 2
[   61.081707] IP route cache hash table entries: 8192 (order: 3, 65536 bytes)
[   61.085257] TCP established hash table entries: 32768 (order: 6, 524288 bytes)
[   61.088250] TCP bind hash table entries: 32768 (order: 8, 2097152 bytes)
[   61.107564] TCP: Hash tables configured (established 32768 bind 32768)
[   61.107822] TCP reno registered
[   61.107931] UDP hash table entries: 512 (order: 3, 81920 bytes)
[   61.108643] UDP-Lite hash table entries: 512 (order: 3, 81920 bytes)
[   61.110216] NET: Registered protocol family 1
[   61.110409] pci 0000:00:07.0: Activating ISA DMA hang workarounds
[   61.110592] PCI: CLS 0 bytes, default 64
[   61.111152] power: Control reg at 1fe02002000
[   61.123876] Initializing RT-Tester: OK
[   61.146577] VFS: Disk quotas dquot_6.5.2
[   61.146972] Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
[   61.148213] msgmni has been set to 1982
[   61.151523] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[   61.151702] io scheduler noop registered
[   61.151860] io scheduler cfq registered (default)
[   61.151912] start plist test
[   61.159891] end plist test
[   61.162200] f0076e0c: ttyS0 at MMIO 0x1fe020003f8 (irq = 7) is a 16550A
[   61.162324] Console: ttyS0 (SU)
[   68.139793] console [ttyS0] enabled
[   68.187400] f0078af8: ttyS1 at MMIO 0x1fe020002e8 (irq = 7) is a 16550A
[   68.278484] PCI: Enabling device: (0000:00:0d.0), cmd 5
[   68.355521] scsi0 : pata_ali
[   68.395684] scsi1 : pata_ali
[   68.435146] ata1: PATA max UDMA/66 cmd 0x1fe02010200 ctl 0x1fe02010218 bmdma 0x1fe02010220 irq 12
[   68.551934] ata2: PATA max UDMA/66 cmd 0x1fe02010210 ctl 0x1fe02010208 bmdma 0x1fe02010228 irq 12
[   68.671027] Linux Tulip driver version 1.1.15-NAPI (Feb 27, 2007)
[   68.754092] tulip0: Old style EEPROM with no media selection information
[   68.842594] tulip0:  MII transceiver #1 config 1000 status 782d advertising 01e1
[   68.958048] net eth0: Davicom DM9102/DM9102A rev 49 at MMIO 0x1ff00000000, EEPROM not present, 00:03:ba:11:b3:71, IRQ 9
[   69.102849] tulip1: Old style EEPROM with no media selection information
[   69.191308] tulip1:  MII transceiver #1 config 1000 status 7809 advertising 01e1
[   69.295285] net eth1: Davicom DM9102/DM9102A rev 49 at MMIO 0x1ff00002000, EEPROM not present, 00:03:ba:11:b3:72, IRQ 10
[   69.440717] mousedev: PS/2 mouse device common for all mice
[   69.515284] ata2.00: ATA-6: ST3120026A, 3.06, max UDMA/100
[   69.587480] ata2.00: 234441648 sectors, multi 0: LBA48 
[   69.656232] ata2.01: ATAPI: CD-224E, 1.7A, max UDMA/33
[   69.723750] ata2.01: WARNING: ATAPI DMA disabled for reliability issues.  It can be enabled
[   69.833603] ata2.01: WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.
[   69.944556] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[   70.028181] rtc0: no alarms, 114 bytes nvram
[   70.093172] TCP cubic registered
[   70.135563] NET: Registered protocol family 17
[   70.193979] Registering the dns_resolver key type
[   70.256335] registered taskstats version 1
[   70.311567] console [netcon0] enabled
[   70.359657] netconsole: network logging started
[   70.419252] rtc_cmos rtc_cmos: setting system clock to 2011-11-20 16:14:42 UTC (1321805682)
[   70.547569] ata2.00: configured for UDMA/66
[   70.637265] ata2.01: configured for UDMA/33
[   70.696476] scsi 1:0:0:0: Direct-Access     ATA      ST3120026A       3.06 PQ: 0 ANSI: 5
[   70.808486] sd 1:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[   70.911169] scsi 1:0:1:0: CD-ROM            TEAC     CD-224E          1.7A PQ: 0 ANSI: 5
[   71.019119] sd 1:0:0:0: [sda] Write Protect is off
[   71.082130] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   71.152004] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   71.280606]  sda: sda1 sda2 sda3 sda4 sda5
[   71.342577] sd 1:0:0:0: [sda] Attached SCSI disk
[   71.422526] kjournald starting.  Commit interval 5 seconds
[   71.495120] EXT3-fs (sda2): mounted filesystem with writeback data mode
[   71.582363] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
[   72.349321] modprobe used greatest stack depth: 8312 bytes left
[   73.278722] mount used greatest stack depth: 6744 bytes left
[   73.837778] grep used greatest stack depth: 256 bytes left
[   75.642847] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
[   75.715209] alim7101_wdt: Detected old alim7101 revision 'a1d'.  If this is a cobalt board, set the 'use_gpio' module parameter.
[   76.698570] usbcore: registered new interface driver usbfs
[   76.771373] usbcore: registered new interface driver hub
[   77.104584] usbcore: registered new device driver usb
[   77.175930] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   77.257441] cdrom: Uniform CD-ROM driver Revision: 3.20
[   77.328391] sr 1:0:1:0: Attached scsi CD-ROM sr0
[   77.586350] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   77.667708] ohci_hcd: block sizes: ed 80 td 96
[   77.726349] PCI: Enabling device: (0000:00:0a.0), cmd 2
[   77.795104] ohci_hcd 0000:00:0a.0: OHCI Host Controller
[   77.864871] drivers/usb/core/inode.c: creating file 'devices'
[   77.940634] drivers/usb/core/inode.c: creating file '001'
[   78.011833] ohci_hcd 0000:00:0a.0: new USB bus registered, assigned bus number 1
[   78.109414] ohci_hcd 0000:00:0a.0: created debug files
[   78.177115] ohci_hcd 0000:00:0a.0: irq 11, io mem 0x1ff01000000
[   78.297674] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   78.367937] sr 1:0:1:0: Attached scsi generic sg1 type 5
[   78.443796] ohci_hcd 0000:00:0a.0: OHCI controller state
[   78.513697] ohci_hcd 0000:00:0a.0: OHCI 1.0, NO legacy support registers
[   78.602049] ohci_hcd 0000:00:0a.0: control 0x083 HCFS=operational CBSR=3
[   78.690196] ohci_hcd 0000:00:0a.0: cmdstatus 0x00000 SOC=0
[   78.762295] ohci_hcd 0000:00:0a.0: intrstatus 0x00000044 RHSC SF
[   78.841276] ohci_hcd 0000:00:0a.0: intrenable 0x8000000a MIE RD WDH
[   78.923665] ohci_hcd 0000:00:0a.0: hcca frame #01e5
[   78.987774] ohci_hcd 0000:00:0a.0: roothub.a 02000202 POTPGT=2 NPS NDP=2(2)
[   79.079327] ohci_hcd 0000:00:0a.0: roothub.b 00000000 PPCM=0000 DR=0000
[   79.166286] ohci_hcd 0000:00:0a.0: roothub.status 00008000 DRWE
[   79.244113] ohci_hcd 0000:00:0a.0: roothub.portstatus [0] 0x00000100 PPS
[   79.332238] ohci_hcd 0000:00:0a.0: roothub.portstatus [1] 0x00000100 PPS
[   79.420833] usb usb1: default language 0x0409
[   79.478220] usb usb1: udev 1, busnum 1, minor = 0
[   79.540049] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   79.629293] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   79.724279] usb usb1: Product: OHCI Host Controller
[   79.788380] usb usb1: Manufacturer: Linux 3.2.0-rc2-00143-ga767835 ohci_hcd
[   79.879949] usb usb1: SerialNumber: 0000:00:0a.0
[   79.941735] usb usb1: usb_probe_device
[   79.991011] usb usb1: configuration #1 chosen from 1 choice
[   80.064630] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   80.140959] hub 1-0:1.0: usb_probe_interface
[   80.197062] hub 1-0:1.0: usb_probe_interface - got id
[   80.263428] hub 1-0:1.0: USB hub found
[   80.312820] hub 1-0:1.0: 2 ports detected
[   80.365467] hub 1-0:1.0: standalone hub
[   80.415855] hub 1-0:1.0: no power switching (usb 1.0)
[   80.482251] hub 1-0:1.0: global over-current protection
[   80.550957] hub 1-0:1.0: power on to power good time: 4ms
[   80.622141] hub 1-0:1.0: local power source is good
[   80.686231] hub 1-0:1.0: no over-current condition exists
[   80.757197] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   80.848807] drivers/usb/core/inode.c: creating file '001'
[   80.920564] sched: RT throttling activated
[   80.977527] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   81.222063] ps used greatest stack depth: 32 bytes left
[   83.288743] Adding 3012176k swap on /dev/sda4.  Priority:-1 extents:1 across:3012176k 
[   83.745932] EXT3-fs (sda2): using internal journal
[   84.117412] loop: module loaded
[   87.331906] kjournald starting.  Commit interval 5 seconds
[   87.435995] EXT3-fs (sda1): using internal journal
[   87.499060] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   87.610890] kjournald starting.  Commit interval 5 seconds
[   87.684105] EXT3-fs (sda5): using internal journal
[   87.747164] EXT3-fs (sda5): mounted filesystem with writeback data mode
[   89.062115] awk used greatest stack depth: 8 bytes left
[   90.606568] 
[   90.626091] =============================================
[   90.697052] [ INFO: possible recursive locking detected ]
[   90.768027] 3.2.0-rc2-00143-ga767835 #8
[   90.818411] ---------------------------------------------
[   90.889387] 000resolvconf/921 is trying to acquire lock:
[   90.959210]  (&(&parent->list_lock)->rlock){..-...}, at: [<000000000070a8ec>] cache_flusharray+0x14/0xc8
[   91.083911] 
[   91.083917] but task is already holding lock:
[   91.160578]  (&(&parent->list_lock)->rlock){..-...}, at: [<000000000070a8ec>] cache_flusharray+0x14/0xc8
[   91.285283] 
[   91.285289] other info that might help us debug this:
[   91.371092]  Possible unsafe locking scenario:
[   91.371102] 
[   91.448908]        CPU0
[   91.480915]        ----
[   91.512918]   lock(&(&parent->list_lock)->rlock);
[   91.574632]   lock(&(&parent->list_lock)->rlock);
[   91.636353] 
[   91.636359]  *** DEADLOCK ***
[   91.636367] 
[   91.714182]  May be due to missing lock nesting notation
[   91.714193] 
[   91.803440] 1 lock held by 000resolvconf/921:
[   91.860594]  #0:  (&(&parent->list_lock)->rlock){..-...}, at: [<000000000070a8ec>] cache_flusharray+0x14/0xc8
[   91.990909] 
[   91.990916] stack backtrace:
[   92.048140] Call Trace:
[   92.080167]  [0000000000487c0c] __lock_acquire+0xfec/0x1d00
[   92.153419]  [0000000000488e2c] lock_acquire+0x4c/0x80
[   92.220959]  [000000000070f51c] _raw_spin_lock+0x1c/0x40
[   92.290780]  [000000000070a8ec] cache_flusharray+0x14/0xc8
[   92.362897]  [00000000004ccaa8] kmem_cache_free+0x88/0xa0
[   92.433859]  [00000000004ccb04] slab_destroy+0x44/0x80
[   92.501397]  [00000000004ccc8c] free_block+0x14c/0x180
[   92.568937]  [000000000070a958] cache_flusharray+0x80/0xc8
[   92.641048]  [00000000004ccaa8] kmem_cache_free+0x88/0xa0
[   92.712021]  [00000000004b80d0] free_pgd_range+0x1f0/0x320
[   92.784126]  [00000000004b828c] free_pgtables+0x8c/0xc0
[   92.852813]  [00000000004bf2cc] exit_mmap+0xac/0x140
[   92.918065]  [000000000045464c] mmput+0x2c/0x100
[   92.978745]  [0000000000458958] exit_mm+0xf8/0x160
[   93.041710]  [000000000045a790] do_exit+0xf0/0x7c0
[   93.104679]  [000000000045b088] do_group_exit+0x28/0xc0
[   94.611557] fuse init (API version 7.17)
[   97.623092] NET: Registered protocol family 10
[  108.627060] eth0: no IPv6 routers present


-- 
Meelis Roos (mroos@linux.ee)

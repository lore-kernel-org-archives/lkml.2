Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab2AaSca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 13:32:30 -0500
Received: from mail.candelatech.com ([208.74.158.172]:44553 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab2AaSc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 13:32:28 -0500
Message-ID: <4F2833B5.5050608@candelatech.com>
Date: Tue, 31 Jan 2012 10:32:21 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: FlorianSchandinat@gmx.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Bisected boot hang introduced in 3.0 (2e336b326, "add VIA slapping
 capability")
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an embedded VIA system (FWA-7304) that fails to boot on
3.0 and higher kernels (tried top-of-tree yesterday, it fails as well).

I bisected it to the commit below.

OS is Fedora 11, 32-bit.

Boot log is farther down, and I'll be happy to provide any additional
info and test patches.

b692a63af8b63a7a7e84702a713d0072e336b326 is the first bad commit
commit b692a63af8b63a7a7e84702a713d0072e336b326
Author: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Date:   Thu Mar 24 14:25:51 2011 +0000

     viafb: add VIA slapping capability

     This patch introduces dummy functions to execute when we don't know
     what we should do (due to missing documentation). They do nothing
     but print a nice message in the log explaining the situation.
     To trigger this message initial power management support is
     activated which might save a bit energy by disabling PLL and clock
     if no device is configured to use them.

     Note: The message is only shown for the oldest IGPs CLE266 and K400
           as for the other platforms there are reasonable assumptions
           how it does (hopefully) work.

     Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

:040000 040000 084da8a293c5ec042019a13a9056b0d2b3ed2700 7f46afbbfe30021f7a0c10436ce40453fec990c1 M	drivers



Linux version 2.6.38-rc7c3+ (greearb@build-32) (gcc version 4.4.5 20101112 (Red Hat 4.4.5-2) (GCC) ) #12 2
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003eef0000 (usable)
  BIOS-e820: 000000003eef0000 - 000000003ef00000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI 2.3 present.
last_pfn = 0x3eef0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Warning only 895MB will be used.
Use a HIGHMEM enabled kernel.
found SMP MP-table at [c00f3520] f3520
init_memory_mapping: 0000000000000000-0000000037fa1000
RAMDISK: 37d1d000 - 37ff0000
Allocated new RAMDISK: 37a4a000 - 37d1c935
Move RAMDISK from 0000000037d1d000 - 0000000037fef934 to 37a4a000 - 37d1c934
ACPI Error: A valid RSDP was not found (20110112/tbxfroot-219)
895MB LOWMEM available.
   mapped low ram: 0 - 37fa1000
   low ram: 0 - 37fa1000
Zone PFN ranges:
   DMA      0x00000010 -> 0x00001000
   Normal   0x00001000 -> 0x00037fa1
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
     0: 0x00000010 -> 0x0000009f
     0: 0x00000100 -> 0x00037fa1
Using APIC driver default
Intel MultiProcessor Specification v1.4
     Virtual Wire compatibility mode.
MPTABLE: OEM ID: OEM00000
MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
Processors: 1
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 3ef00000 (gap: 3ef00000:bfd00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227376
Kernel command line: ro root=UUID=6a8d9850-61a3-4e10-9171-86e7dfa6b4a5 libata.dma=3 force_tsc_stable=1 co0
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
allocated 4585300 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Memory: 890296k/917124k available (3389k kernel code, 26376k reserved, 1807k data, 416k init, 0k highmem)
virtual kernel memory layout:
     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
     vmalloc : 0xf87a1000 - 0xfffa1000   ( 120 MB)
     lowmem  : 0xc0000000 - 0xf7fa1000   ( 895 MB)
       .init : 0xc0914000 - 0xc097c000   ( 416 kB)
       .data : 0xc074f461 - 0xc0913180   (1807 kB)
       .text : 0xc0400000 - 0xc074f461   (3389 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:2304 nr_irqs:256 16
Console: colour VGA+ 80x25
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
  memory used by lock dependency info: 3567 kB
  per task-struct memory footprint: 1152 bytes
Fast TSC calibration using PIT
Detected 997.347 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 1994.69 BogoMIPS (lpj=997347)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
Mount-cache hash table entries: 512
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: Centaur VIA Esther processor 1000MHz stepping 09
Performance Events:
NMI watchdog disabled (cpu0): hardware events not enabled
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ExtINT not setup in hardware but reported by MP table
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
print_constraints: dummy:
Time: 18:27:04  Date: 01/31/12
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xf9f30, last bus=1
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:01.0: PCI bridge to [bus 01-01]
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
pci 0000:00:11.0: VIA IRQ router [1106:3227]
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: PnP ACPI: disabled
pci 0000:00:10.1: BAR 4: assigned [io  0x1000-0x101f]
pci 0000:00:10.1: BAR 4: set to [io  0x1000-0x101f] (PCI address [0x1000-0x101f])
pci 0000:00:10.2: BAR 4: assigned [io  0x1020-0x103f]
pci 0000:00:10.2: BAR 4: set to [io  0x1020-0x103f] (PCI address [0x1020-0x103f])
pci 0000:00:10.3: BAR 4: assigned [io  0x1040-0x105f]
pci 0000:00:10.3: BAR 4: set to [io  0x1040-0x105f] (PCI address [0x1040-0x105f])
pci 0000:01:00.0: BAR 6: assigned [mem 0xf5000000-0xf500ffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem 0xf4000000-0xf5ffffff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 3, 40960 bytes)
UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
NET: Registered protocol family 1
pci 0000:00:01.0: disabling DAC on VIA PCI bridge
pci 0000:00:10.4: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:00:11.0: Bypassing VIA 8237 APIC De-Assert Message
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 2892k freed
platform rtc_cmos: registered platform RTC device (no PNP device found)
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
audit: initializing netlink socket (disabled)
type=2000 audit(1328034425.744:1): initialized
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1744
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
�serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart: Detected VIA VT3314 chipset
agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xe8000000
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:10.4: PCI->APIC IRQ transform: INT C -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: irq 21, io mem 0xf6014000
Switching to clocksource tsc
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.38-rc7c3+ ehci_hcd
usb usb1: SerialNumber: 0000:00:10.4
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:10.0: PCI->APIC IRQ transform: INT A -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 21, io base 0x0000ea00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.38-rc7c3+ uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.1: enabling device (0000 -> 0001)
uhci_hcd 0000:00:10.1: PCI->APIC IRQ transform: INT A -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 21, io base 0x00001000
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.38-rc7c3+ uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.2: BAR 4: set to [io  0x1020-0x103f] (PCI address [0x1020-0x103f])
uhci_hcd 0000:00:10.2: enabling device (0000 -> 0001)
uhci_hcd 0000:00:10.2: PCI->APIC IRQ transform: INT B -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 21, io base 0x00001020
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.38-rc7c3+ uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.3: enabling device (0000 -> 0001)
uhci_hcd 0000:00:10.3: PCI->APIC IRQ transform: INT B -> IRQ 21
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:10.3: irq 21, io base 0x00001040
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.38-rc7c3+ uhci_hcd
usb usb5: SerialNumber: 0000:00:10.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (13956 buckets, 55824 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Registering the dns_resolver key type
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
registered taskstats version 1
   Magic number: 12:135:495
Freeing unused kernel memory: 416k freed
Write protecting the kernel text: 3392k
Write protecting the kernel read-only data: 1548k
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
nash-hotplug (33): /proc/33/oom_adj is deprecated, please use /proc/33/oom_score_adj instead.
Ginput: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input1
pata_via 0000:00:0f.1: PCI->APIC IRQ transform: INT A -> IRQ 20
scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xe900 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xe908 irq 15
ata1.01: CFA: TRANSCEND, 20081024, max UDMA/66
ata1.01: 3980592 sectors, multi 0: LBA
ata1.01: limited to UDMA/33 due to 40-wire cable
ata1.01: configured for PIO4
scsi 0:0:1:0: Direct-Access     ATA      TRANSCEND        2008 PQ: 0 ANSI: 5
sd 0:0:1:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: [sda] 3980592 512-byte logical blocks: (2.03 GB/1.89 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  sda: sda1
sd 0:0:1:0: [sda] Attached SCSI disk
Clocksource tsc unstable (delta = 80771220 ns)
Switching to clocksource jiffies
EXT3-fs: barriers not enabled
EXT3-fs (sda1): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
SELinux:  Disabled at runtime.
type=1404 audit(1328034428.344:2): selinux=0 auid=4294967295 ses=4294967295
                 Welcome to Fedora
                 Press 'I' to enter interactive startup.
Starting udev: G


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


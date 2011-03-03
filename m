Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab1CCWOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:14:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab1CCWOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:14:03 -0500
Date: Thu, 3 Mar 2011 17:13:53 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110303221353.GA10366@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
kernel, when I try an fsync heavy workload to a request-based mpath
device (the kernel ultimately goes down in flames, I've yet to look at
the crashdump I took)

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.38-rc6-snitm+ (root@rhel6) (gcc version 4.4.5 20110116 (Red Hat 4.4.5-5) (GCC) ) #2 SMP Thu Mar 3 16:32:23 EST 2011
Command line: ro root=UUID=e0236db2-5a38-4d48-8bf5-55675671dee6 console=ttyS0 rhgb quiet SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us rd_plytheme=charge crashkernel=auto
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fffd000 (usable)
 BIOS-e820: 000000007fffd000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Bochs Bochs, BIOS Bochs 01/01/2007
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x7fffd max_arch_pfn = 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 00E0000000 mask FFE0000000 uncachable
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
found SMP MP-table at [ffff8800000f7fd0] f7fd0
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-000000007fffd000
 0000000000 - 007fe00000 page 2M
 007fe00000 - 007fffd000 page 4k
kernel direct mapping tables up to 7fffd000 @ 1fffc000-20000000
RAMDISK: 37b50000 - 37ff0000
crashkernel: memory value expected
ACPI: RSDP 00000000000f7f80 00014 (v00 BOCHS )
ACPI: RSDT 000000007fffde10 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
ACPI: FACP 000000007ffffe40 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
ACPI: DSDT 000000007fffdfd0 01E22 (v01   BXPC   BXDSDT 00000001 INTL 20090123)
ACPI: FACS 000000007ffffe00 00040
ACPI: SSDT 000000007fffdf80 00044 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
ACPI: APIC 000000007fffde90 0007A (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
ACPI: HPET 000000007fffde50 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000007fffd000
Initmem setup node 0 0000000000000000-000000007fffd000
  NODE_DATA [000000007ffe9000 - 000000007fffcfff]
kvm-clock: Using msrs 12 and 11
kvm-clock: cpu 0, msr 0:1875141, boot clock
 [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff88007d600000-ffff88007f1fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007fffd
On node 0 totalpages: 524172
  DMA zone: 56 pages used for memmap
  DMA zone: 2 pages reserved
  DMA zone: 3925 pages, LIFO batch:0
  DMA32 zone: 7112 pages used for memmap
  DMA32 zone: 513077 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0xb008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ5 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ10 used by override.
ACPI: IRQ11 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at 80000000 (gap: 80000000:7ffbc000)
Booting paravirtualized kernel on KVM
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 474 pages/cpu @ffff88007f200000 s1912768 r8192 d20544 u2097152
pcpu-alloc: s1912768 r8192 d20544 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 [0] 1 
kvm-clock: cpu 0, msr 0:7f3d2141, primary cpu clock
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 517002
Policy zone: DMA32
Kernel command line: ro root=UUID=e0236db2-5a38-4d48-8bf5-55675671dee6 console=ttyS0 rhgb quiet SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us rd_plytheme=charge crashkernel=auto
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Memory: 2037496k/2097140k available (3571k kernel code, 452k absent, 59192k reserved, 3219k data, 3504k init)
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:4352 nr_irqs:512 16
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
 memory used by lock dependency info: 6367 kB
 per task-struct memory footprint: 2688 bytes
ODEBUG: 11 of 11 active objects replaced
ODEBUG: selftest passed
hpet clockevent registered
Detected 1995.090 MHz processor.
Calibrating delay loop (skipped) preset value.. 3990.18 BogoMIPS (lpj=1995090)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
mce: CPU supports 10 MCE banks
ACPI: Core revision 20110112
ftrace: allocating 16994 entries in 67 pages
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel QEMU Virtual CPU version 0.12.5 stepping 03
Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.
lockdep: fixing up alternatives.
Booting Node   0, Processors  #1 Ok.
kvm-clock: cpu 1, msr 0:7f5d2141, secondary cpu clock
Brought up 2 CPUs
Total of 2 processors activated (7980.36 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
mtrr: your CPUs had inconsistent variable MTRR settings
mtrr: your CPUs had inconsistent MTRRdefType settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
pci 0000:00:00.0: [8086:1237] type 0 class 0x000600
pci 0000:00:01.0: [8086:7000] type 0 class 0x000601
pci 0000:00:01.1: [8086:7010] type 0 class 0x000101
pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
pci 0000:00:01.2: [8086:7020] type 0 class 0x000c03
pci 0000:00:01.2: reg 20: [io  0xc020-0xc03f]
pci 0000:00:01.3: [8086:7113] type 0 class 0x000680
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
pci 0000:00:02.0: [1013:00b8] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
pci 0000:00:03.0: [1af4:1002] type 0 class 0x000500
pci 0000:00:03.0: reg 10: [io  0xc040-0xc05f]
pci 0000:00:04.0: [1af4:1001] type 0 class 0x000100
pci 0000:00:04.0: reg 10: [io  0xc080-0xc0bf]
pci 0000:00:05.0: [1af4:1001] type 0 class 0x000100
pci 0000:00:05.0: reg 10: [io  0xc0c0-0xc0ff]
pci 0000:00:06.0: [1af4:1000] type 0 class 0x000200
pci 0000:00:06.0: reg 10: [io  0xc100-0xc11f]
pci 0000:00:06.0: reg 14: [mem 0xf2001000-0xf2001fff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009f400 - 000000000009ffff 
reserve RAM buffer: 000000007fffd000 - 000000007fffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 100.000000 MHz counter
Switching to clocksource kvm-clock
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0xe0000000-0xfebfffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: [io  0x0070-0x0071]
pnp 00:01: [irq 8]
pnp 00:01: [io  0x0072-0x0077]
pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:02: [io  0x0060]
pnp 00:02: [io  0x0064]
pnp 00:02: [irq 1]
pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:03: [irq 12]
pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp 00:04: [io  0x03f2-0x03f5]
pnp 00:04: [io  0x03f7]
pnp 00:04: [irq 6]
pnp 00:04: [dma 2]
pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:05: [mem 0xfed00000-0xfed003ff]
pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
pnp: PnP ACPI: found 6 devices
ACPI: ACPI bus type pnp unregistered
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 1024 (order: 5, 196608 bytes)
UDP-Lite hash table entries: 1024 (order: 5, 196608 bytes)
NET: Registered protocol family 1
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
pci 0000:00:02.0: Boot video device
PCI: CLS 0 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 4736k freed
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
audit: initializing netlink socket (disabled)
type=2000 audit(1299188678.444:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 3988
SELinux:  Registering netfilter hooks
cryptomgr_test used greatest stack depth: 6496 bytes left
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp: Slot [1] registered
acpiphp: Slot [2] registered
acpiphp: Slot [3] registered
acpiphp: Slot [4] registered
acpiphp: Slot [5] registered
acpiphp: Slot [6] registered
acpiphp: Slot [7] registered
acpiphp: Slot [8] registered
acpiphp: Slot [9] registered
acpiphp: Slot [10] registered
acpiphp: Slot [11] registered
acpiphp: Slot [12] registered
acpiphp: Slot [13] registered
acpiphp: Slot [14] registered
acpiphp: Slot [15] registered
acpiphp: Slot [16] registered
acpiphp: Slot [17] registered
acpiphp: Slot [18] registered
acpiphp: Slot [19] registered
acpiphp: Slot [20] registered
acpiphp: Slot [21] registered
acpiphp: Slot [22] registered
acpiphp: Slot [23] registered
acpiphp: Slot [24] registered
acpiphp: Slot [25] registered
acpiphp: Slot [26] registered
acpiphp: Slot [27] registered
acpiphp: Slot [28] registered
acpiphp: Slot [29] registered
acpiphp: Slot [30] registered
acpiphp: Slot [31] registered
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
brd: module loaded
loop: module loaded
ata_piix 0000:00:01.1: version 2.13
ata_piix 0000:00:01.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
rtc_cmos 00:01: setting system clock to 2011-03-03 21:44:38 UTC (1299188678)
Freeing unused kernel memory: 3504k freed
Write protecting the kernel read-only data: 6144k
Freeing unused kernel memory: 508k freed
Freeing unused kernel memory: 164k freed
mknod used greatest stack depth: 5296 bytes left
modprobe used greatest stack depth: 5080 bytes left
mknod used greatest stack depth: 4792 bytes left
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
dracut: dracut-004-35.el6
udev: starting version 147
udevd (70): /proc/70/oom_adj is deprecated, please use /proc/70/oom_score_adj instead.
dracut: Starting plymouth daemon
Refined TSC clocksource calibration: 1994.951 MHz.
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
virtio-pci 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, high) -> IRQ 11
virtio-pci 0000:00:03.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
virtio-pci 0000:00:04.0: PCI INT A -> Link[LNKD] -> GSI 10 (level, high) -> IRQ 10
virtio-pci 0000:00:04.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
virtio-pci 0000:00:05.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, high) -> IRQ 10
virtio-pci 0000:00:05.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
virtio-pci 0000:00:06.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, high) -> IRQ 11
virtio-pci 0000:00:06.0: setting latency timer to 64
modprobe used greatest stack depth: 4768 bytes left
 vda: vda1 vda2 vda3
 vdb: unknown partition table
modprobe used greatest stack depth: 4672 bytes left
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (vda3): mounted filesystem with ordered data mode
dracut: Remounting /dev/disk/by-uuid/e0236db2-5a38-4d48-8bf5-55675671dee6 with -o barrier=1,ro
kjournald starting.  Commit interval 5 seconds
EXT3-fs (vda3): mounted filesystem with ordered data mode
dracut: Mounted root filesystem /dev/vda3
dracut: Loading SELinux policy
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1299188681.051:2): selinux=0 auid=4294967295 ses=4294967295
load_policy used greatest stack depth: 3664 bytes left
dracut: /sbin/load_policy: Can't load policy: No such file or directory
dracut: Switching root
readahead: starting
udev: starting version 147
ip used greatest stack depth: 3592 bytes left
piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
virtio-pci 0000:00:06.0: irq 40 for MSI/MSI-X
virtio-pci 0000:00:06.0: irq 41 for MSI/MSI-X
virtio-pci 0000:00:06.0: irq 42 for MSI/MSI-X
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.2.0 loaded
EXT3-fs (vda3): using internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs (vda1): using internal journal
EXT3-fs (vda1): mounted filesystem with ordered data mode
Adding 524284k swap on /dev/vda2.  Priority:-1 extents:1 across:524284k 
Loading iSCSI transport class v2.0-870.
iscsi: registered transport (tcp)
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
scsi2 : iSCSI Initiator over TCP/IP
scsi3 : iSCSI Initiator over TCP/IP
scsi4 : iSCSI Initiator over TCP/IP
scsi5 : iSCSI Initiator over TCP/IP
scsi 2:0:0:0: Direct-Access     NETAPP   LUN              8010 PQ: 0 ANSI: 5
sd 2:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: Direct-Access     NETAPP   LUN              8010 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     NETAPP   LUN              8010 PQ: 0 ANSI: 5
scsi 5:0:0:0: Direct-Access     NETAPP   LUN              8010 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 20971520 512-byte logical blocks: (10.7 GB/10.0 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: bd 00 00 08
sd 5:0:0:0: Attached scsi generic sg1 type 0
sd 3:0:0:0: Attached scsi generic sg2 type 0
sd 4:0:0:0: Attached scsi generic sg3 type 0
sd 5:0:0:0: [sdb] 20971520 512-byte logical blocks: (10.7 GB/10.0 GiB)
sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdc] 20971520 512-byte logical blocks: (10.7 GB/10.0 GiB)
sd 4:0:0:0: [sdd] 20971520 512-byte logical blocks: (10.7 GB/10.0 GiB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: bd 00 00 08
sd 5:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: bd 00 00 08
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: bd 00 00 08
sd 3:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
 sdb: sdb1 sdb2
sd 2:0:0:0: [sda] Attached SCSI disk
 sdc: sdc1 sdc2
 sdd: sdd1 sdd2
sd 5:0:0:0: [sdb] Attached SCSI disk
sd 3:0:0:0: [sdc] Attached SCSI disk
sd 4:0:0:0: [sdd] Attached SCSI disk
sd 2:0:0:0: alua: supports implicit TPGS
sd 2:0:0:0: alua: port group 1100 rel port 83ea
sd 2:0:0:0: alua: port group 1100 state A supports TolUsNA
sd 5:0:0:0: alua: supports implicit TPGS
sd 5:0:0:0: alua: port group 1100 rel port 83e9
sd 5:0:0:0: alua: port group 1100 state A supports TolUsNA
sd 3:0:0:0: alua: supports implicit TPGS
sd 3:0:0:0: alua: port group 1100 rel port 83e8
sd 3:0:0:0: alua: port group 1100 state A supports TolUsNA
sd 4:0:0:0: alua: supports implicit TPGS
sd 4:0:0:0: alua: port group 1100 rel port 83eb
sd 4:0:0:0: alua: port group 1100 state A supports TolUsNA
alua: device handler registered
device-mapper: multipath round-robin: version 1.0.0 loaded
sd 5:0:0:0: alua: port group 1100 state A supports TolUsNA
sd 5:0:0:0: alua: port group 1100 state A supports TolUsNA
sd 5:0:0:0: alua: port group 1100 state A supports TolUsNA
sd 5:0:0:0: alua: port group 1100 state A supports TolUsNA
 sdb:
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
scp used greatest stack depth: 3360 bytes left
vi used greatest stack depth: 3184 bytes left

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.38-rc6-snitm+ #2
-------------------------------------------------------
ffsb/3110 is trying to acquire lock:
 (&(&q->__queue_lock)->rlock){..-...}, at: [<ffffffff811b4c4d>] flush_plug_list+0xbc/0x135

but task is already holding lock:
 (&rq->lock){-.-.-.}, at: [<ffffffff8137132f>] schedule+0x16a/0x725

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&rq->lock){-.-.-.}:
       [<ffffffff810731eb>] lock_acquire+0xe3/0x110
       [<ffffffff81373773>] _raw_spin_lock+0x36/0x69
       [<ffffffff810348f0>] task_rq_lock+0x51/0x83
       [<ffffffff810402f2>] try_to_wake_up+0x34/0x220
       [<ffffffff810404f0>] default_wake_function+0x12/0x14
       [<ffffffff81030136>] __wake_up_common+0x4e/0x84
       [<ffffffff810345a1>] complete+0x3f/0x52
       [<ffffffff811b9e58>] blk_end_sync_rq+0x34/0x38
       [<ffffffff811b6279>] blk_finish_request+0x1f5/0x224
       [<ffffffff811b62e8>] __blk_end_request_all+0x40/0x49
       [<ffffffffa00165c3>] blk_done+0x92/0xe7 [virtio_blk]
       [<ffffffffa0007382>] vring_interrupt+0x68/0x71 [virtio_ring]
       [<ffffffffa000e416>] vp_vring_interrupt+0x5b/0x97 [virtio_pci]
       [<ffffffffa000e497>] vp_interrupt+0x45/0x4a [virtio_pci]
       [<ffffffff81097a80>] handle_IRQ_event+0x57/0x127
       [<ffffffff81099bfe>] handle_fasteoi_irq+0x96/0xd9
       [<ffffffff8100511b>] handle_irq+0x88/0x91
       [<ffffffff8137ab8d>] do_IRQ+0x4d/0xb4
       [<ffffffff81374453>] ret_from_intr+0x0/0x1a
       [<ffffffff811d4cfe>] __debug_object_init+0x33a/0x377
       [<ffffffff811d4d52>] debug_object_init_on_stack+0x17/0x19
       [<ffffffff8105195c>] init_timer_on_stack_key+0x26/0x3e
       [<ffffffff81371d33>] schedule_timeout+0xa7/0xfe
       [<ffffffff81371b14>] wait_for_common+0xd7/0x135
       [<ffffffff81371c0b>] wait_for_completion_timeout+0x13/0x15
       [<ffffffff811b9fdc>] blk_execute_rq+0xe9/0x12d
       [<ffffffffa001609b>] virtblk_serial_show+0x9b/0xdb [virtio_blk]
       [<ffffffff81266104>] dev_attr_show+0x27/0x4e
       [<ffffffff81159471>] sysfs_read_file+0xbd/0x16b
       [<ffffffff811001ac>] vfs_read+0xae/0x10a
       [<ffffffff811002d1>] sys_read+0x4d/0x77
       [<ffffffff81002b82>] system_call_fastpath+0x16/0x1b

-> #1 (key#28){-.-...}:
       [<ffffffff810731eb>] lock_acquire+0xe3/0x110
       [<ffffffff813738f7>] _raw_spin_lock_irqsave+0x4e/0x88
       [<ffffffff81034583>] complete+0x21/0x52
       [<ffffffff811b9e58>] blk_end_sync_rq+0x34/0x38
       [<ffffffff811b6279>] blk_finish_request+0x1f5/0x224
       [<ffffffff811b6588>] blk_end_bidi_request+0x42/0x5d
       [<ffffffff811b65df>] blk_end_request+0x10/0x12
       [<ffffffff8127c17b>] scsi_io_completion+0x1b0/0x424
       [<ffffffff81275512>] scsi_finish_command+0xe9/0xf2
       [<ffffffff8127c503>] scsi_softirq_done+0xff/0x108
       [<ffffffff811bab18>] blk_done_softirq+0x84/0x98
       [<ffffffff8104a117>] __do_softirq+0xe2/0x1d3
       [<ffffffff81003b1c>] call_softirq+0x1c/0x28
       [<ffffffff8100503b>] do_softirq+0x4b/0xa3
       [<ffffffff81049e71>] irq_exit+0x4a/0x8c
       [<ffffffff8137abdd>] do_IRQ+0x9d/0xb4
       [<ffffffff81374453>] ret_from_intr+0x0/0x1a
       [<ffffffff8137377b>] _raw_spin_lock+0x3e/0x69
       [<ffffffff810e9bdc>] __page_lock_anon_vma+0x65/0x9d
       [<ffffffff810e9c35>] try_to_unmap_anon+0x21/0xdb
       [<ffffffff810e9d1a>] try_to_munlock+0x2b/0x39
       [<ffffffff810e3ca6>] munlock_vma_page+0x45/0x7f
       [<ffffffff810e1e63>] do_wp_page+0x536/0x580
       [<ffffffff810e28b9>] handle_pte_fault+0x6af/0x6e8
       [<ffffffff810e29cc>] handle_mm_fault+0xda/0xed
       [<ffffffff81377768>] do_page_fault+0x3b4/0x3d6
       [<ffffffff81374725>] page_fault+0x25/0x30

-> #0 (&(&q->__queue_lock)->rlock){..-...}:
       [<ffffffff81072e14>] __lock_acquire+0xa32/0xd26
       [<ffffffff810731eb>] lock_acquire+0xe3/0x110
       [<ffffffff81373773>] _raw_spin_lock+0x36/0x69
       [<ffffffff811b4c4d>] flush_plug_list+0xbc/0x135
       [<ffffffff811b4ce0>] __blk_flush_plug+0x1a/0x3a
       [<ffffffff81371471>] schedule+0x2ac/0x725
       [<ffffffffa00fef16>] start_this_handle+0x3be/0x4b1 [jbd2]
       [<ffffffffa00ff1fc>] jbd2__journal_start+0xc2/0xf6 [jbd2]
       [<ffffffffa00ff243>] jbd2_journal_start+0x13/0x15 [jbd2]
       [<ffffffffa013823c>] ext4_journal_start_sb+0xe1/0x116 [ext4]
       [<ffffffffa012748d>] ext4_da_writepages+0x27c/0x517 [ext4]
       [<ffffffff810cd298>] do_writepages+0x24/0x30
       [<ffffffff8111e625>] writeback_single_inode+0xaf/0x1d0
       [<ffffffff8111eb88>] writeback_sb_inodes+0xab/0x134
       [<ffffffff8111f542>] writeback_inodes_wb+0x12b/0x13d
       [<ffffffff810cc920>] balance_dirty_pages_ratelimited_nr+0x2be/0x3d8
       [<ffffffff810c456c>] generic_file_buffered_write+0x1ff/0x267
       [<ffffffff810c593f>] __generic_file_aio_write+0x245/0x27a
       [<ffffffff810c59d9>] generic_file_aio_write+0x65/0xbc
       [<ffffffffa011dd57>] ext4_file_write+0x1f5/0x256 [ext4]
       [<ffffffff810ff5b1>] do_sync_write+0xcb/0x108
       [<ffffffff810fffaf>] vfs_write+0xb1/0x10d
       [<ffffffff811000d4>] sys_write+0x4d/0x77
       [<ffffffff81002b82>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

3 locks held by ffsb/3110:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff810c59bd>] generic_file_aio_write+0x49/0xbc
 #1:  (&type->s_umount_key#36){.+.+..}, at: [<ffffffff8111f4e5>] writeback_inodes_wb+0xce/0x13d
 #2:  (&rq->lock){-.-.-.}, at: [<ffffffff8137132f>] schedule+0x16a/0x725

stack backtrace:
Pid: 3110, comm: ffsb Not tainted 2.6.38-rc6-snitm+ #2
Call Trace:
 [<ffffffff810714fa>] ? print_circular_bug+0xae/0xbc
 [<ffffffff81072e14>] ? __lock_acquire+0xa32/0xd26
 [<ffffffff810731eb>] ? lock_acquire+0xe3/0x110
 [<ffffffff811b4c4d>] ? flush_plug_list+0xbc/0x135
 [<ffffffff81373773>] ? _raw_spin_lock+0x36/0x69
 [<ffffffff811b4c4d>] ? flush_plug_list+0xbc/0x135
 [<ffffffff811b4c4d>] ? flush_plug_list+0xbc/0x135
 [<ffffffff811b4ce0>] ? __blk_flush_plug+0x1a/0x3a
 [<ffffffff81371471>] ? schedule+0x2ac/0x725
 [<ffffffff810700f3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa00fef16>] ? start_this_handle+0x3be/0x4b1 [jbd2]
 [<ffffffff8106001a>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffffa00ff1fc>] ? jbd2__journal_start+0xc2/0xf6 [jbd2]
 [<ffffffffa00ff243>] ? jbd2_journal_start+0x13/0x15 [jbd2]
 [<ffffffffa013823c>] ? ext4_journal_start_sb+0xe1/0x116 [ext4]
 [<ffffffffa0120d2f>] ? ext4_meta_trans_blocks+0x67/0xb8 [ext4]
 [<ffffffffa012748d>] ? ext4_da_writepages+0x27c/0x517 [ext4]
 [<ffffffff810658fd>] ? sched_clock_local+0x1c/0x82
 [<ffffffff810cd298>] ? do_writepages+0x24/0x30
 [<ffffffff8111e625>] ? writeback_single_inode+0xaf/0x1d0
 [<ffffffff8111eb88>] ? writeback_sb_inodes+0xab/0x134
 [<ffffffff8111f542>] ? writeback_inodes_wb+0x12b/0x13d
 [<ffffffff810cc920>] ? balance_dirty_pages_ratelimited_nr+0x2be/0x3d8
 [<ffffffff810c412d>] ? iov_iter_copy_from_user_atomic+0x81/0xf1
 [<ffffffff810c456c>] ? generic_file_buffered_write+0x1ff/0x267
 [<ffffffff81048adf>] ? current_fs_time+0x27/0x2e
 [<ffffffff810c593f>] ? __generic_file_aio_write+0x245/0x27a
 [<ffffffff810658fd>] ? sched_clock_local+0x1c/0x82
 [<ffffffff810c59d9>] ? generic_file_aio_write+0x65/0xbc
 [<ffffffffa011dd57>] ? ext4_file_write+0x1f5/0x256 [ext4]
 [<ffffffff81070983>] ? mark_lock+0x2d/0x22d
 [<ffffffff8107279e>] ? __lock_acquire+0x3bc/0xd26
 [<ffffffff810ff5b1>] ? do_sync_write+0xcb/0x108
 [<ffffffff810700f3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81065a72>] ? local_clock+0x41/0x5a
 [<ffffffff8118e62f>] ? security_file_permission+0x2e/0x33
 [<ffffffff810fffaf>] ? vfs_write+0xb1/0x10d
 [<ffffffff81100724>] ? fget_light+0x57/0xf0
 [<ffffffff81070e61>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff811000d4>] ? sys_write+0x4d/0x77
 [<ffffffff81002b82>] ? system_call_fastpath+0x16/0x1b

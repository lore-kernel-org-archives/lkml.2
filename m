Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab0EaBYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 21:24:42 -0400
Received: from troy.hostgo.com ([64.62.143.130]:46914 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab0EaBYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 21:24:40 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: linux-kernel@vger.kernel.org
Subject: BUG: unable to handle kernel paging request
Date: Sun, 30 May 2010 19:24:31 -0600
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005301924.31807.tfjellstrom@strangesoft.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - troy.hostgo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - strangesoft.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing some rather strange OOPSes and BUG messages from my older
AMD machine. Here is just the latest one, which didn't actually cause the
entire machine to lock up solid.

I've done a memtest, and it was solid, so actual memory errors seems to
be unlikely.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-5-686 (Debian 2.6.32-13) (maks@debian.org) (gcc version 4.3.4 (Debian 4.3.4-10) ) #1 SMP Wed May 19 19:51:54 UTC 2010
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  BIOS-e820: 000000007fff0000 - 000000007fff8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fff8000 - 0000000080000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x7fff0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 base 0E0000000 mask FF8000000 write-combining
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] init_memory_mapping: 0000000000000000-00000000373fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037000000 page 2M
[    0.000000]  0037000000 - 00373fe000 page 4k
[    0.000000] kernel direct mapping tables up to 373fe000 @ 10000-16000
[    0.000000] RAMDISK: 377b7000 - 37fef725
[    0.000000] Allocated new RAMDISK: 00100000 - 00938725
[    0.000000] Move RAMDISK from 00000000377b7000 - 0000000037fef724 to 00100000 - 00938724
[    0.000000] ACPI: RSDP 000fa9f0 00014 (v00 AMI   )
[    0.000000] ACPI: RSDT 7fff0000 0002C (v01 AMIINT VIA_K7   00000010 MSFT 00000097)
[    0.000000] ACPI: FACP 7fff0030 00081 (v01 AMIINT VIA_K7   00000011 MSFT 00000097)
[    0.000000] ACPI: DSDT 7fff0120 03718 (v01    VIA   VIA_K7 00001000 MSFT 0100000D)
[    0.000000] ACPI: FACS 7fff8000 00040
[    0.000000] ACPI: APIC 7fff00c0 00054 (v01 AMIINT VIA_K7   00000009 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1163MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 0 - 373fe000
[    0.000000]   node 0 low ram: 00000000 - 373fe000
[    0.000000]   node 0 bootmap 00012000 - 00018e80
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00014c4154]    TEXT DATA BSS ==> [0001000000 - 00014c4154]
[    0.000000]   #4 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
[    0.000000]   #5 [00014c5000 - 00014cb108]              BRK ==> [00014c5000 - 00014cb108]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #7 [0000100000 - 0000938725]      NEW RAMDISK ==> [0000100000 - 0000938725]
[    0.000000]   #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
[    0.000000] found SMP MP-table at [c00fb990] fb990
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0007fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fff0
[    0.000000] On node 0 totalpages: 524159
[    0.000000] free_area_init_node: node 0, pgdat c13ae680, node_mem_map c14cd200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2328 pages used for memmap
[    0.000000]   HighMem zone: 295642 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @c2800000 s34136 r0 d23208 u4194304
[    0.000000] pcpu-alloc: s34136 r0 d23208 u4194304 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520063
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-5-686 root=UUID=956b3463-56e8-4aa3-8eca-b7f5e9ef90b3 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000373fe:0007fff0)
[    0.000000] Memory: 2065056k/2097088k available (2490k kernel code, 30644k reserved, 1317k data, 376k init, 1191880k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd56000 - 0xfffff000   (2724 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.000000]       .init : 0xc13b9000 - 0xc1417000   ( 376 kB)
[    0.000000]       .data : 0xc126ebad - 0xc13b81e0   (1317 kB)
[    0.000000]       .text : 0xc1000000 - 0xc126ebad   (2490 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:1280
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1670.783 MHz processor.
[    0.004007] Calibrating delay loop (skipped), value calculated using timer frequency.. 3341.56 BogoMIPS (lpj=6683132)
[    0.004037] Security Framework initialized
[    0.004049] SELinux:  Disabled at boot.
[    0.004060] Mount-cache hash table entries: 512
[    0.004260] Initializing cgroup subsys ns
[    0.004266] Initializing cgroup subsys cpuacct
[    0.004272] Initializing cgroup subsys devices
[    0.004276] Initializing cgroup subsys freezer
[    0.004280] Initializing cgroup subsys net_cls
[    0.004312] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004317] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004323] mce: CPU supports 4 MCE banks
[    0.004351] Performance Events: AMD PMU driver.
[    0.004360] ... version:                0
[    0.004363] ... bit width:              48
[    0.004366] ... generic registers:      4
[    0.004369] ... value mask:             0000ffffffffffff
[    0.004372] ... max period:             00007fffffffffff
[    0.004374] ... fixed-purpose events:   0
[    0.004377] ... event mask:             000000000000000f
[    0.004383] Checking 'hlt' instruction... OK.
[    0.020364] SMP alternatives: switching to UP code
[    0.024576] Freeing SMP alternatives: 13k freed
[    0.024593] ACPI: Core revision 20090903
[    0.031652] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.032848] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.072560] CPU0: AMD Athlon(tm) XP 2200+ stepping 00
[    0.076001] Brought up 1 CPUs
[    0.076001] Total of 1 processors activated (3341.56 BogoMIPS).
[    0.076001] CPU0 attaching NULL sched-domain.
[    0.076001] devtmpfs: initialized
[    0.076001] regulator: core version 0.5
[    0.076001] NET: Registered protocol family 16
[    0.076001] ACPI: bus type pci registered
[    0.076001] PCI: PCI BIOS revision 2.10 entry at 0xfdb11, last bus=1
[    0.076001] PCI: Using configuration type 1 for base access
[    0.076001] bio: create slab <bio-0> at 0
[    0.076001] ACPI: EC: Look up EC in DSDT
[    0.081794] ACPI: Interpreter enabled
[    0.081804] ACPI: (supports S0 S1 S4 S5)
[    0.081829] ACPI: Using IOAPIC for interrupt routing
[    0.085752] ACPI: Power Resource [URP1] (off)
[    0.085790] ACPI: Power Resource [URP2] (off)
[    0.085826] ACPI: Power Resource [FDDP] (off)
[    0.085862] ACPI: Power Resource [LPTP] (off)
[    0.086013] ACPI: No dock devices found.
[    0.086162] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.086220] pci 0000:00:00.0: reg 10 32bit mmio pref: [0xe0000000-0xe7ffffff]
[    0.086308] pci 0000:00:01.0: supports D1
[    0.086347] pci 0000:00:05.0: reg 10 32bit mmio: [0xdffec000-0xdffeffff]
[    0.086355] pci 0000:00:05.0: reg 14 io port: [0xec00-0xecff]
[    0.086377] pci 0000:00:05.0: reg 30 32bit mmio pref: [0xdffc0000-0xdffdffff]
[    0.086397] pci 0000:00:05.0: supports D1 D2
[    0.086401] pci 0000:00:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.086406] pci 0000:00:05.0: PME# disabled
[    0.086448] pci 0000:00:08.0: reg 10 32bit mmio pref: [0xdfdf0000-0xdfdfffff]
[    0.086482] pci 0000:00:08.0: reg 30 32bit mmio pref: [0xdfff0000-0xdfff7fff]
[    0.086539] pci 0000:00:0f.0: reg 10 io port: [0xe800-0xe807]
[    0.086547] pci 0000:00:0f.0: reg 14 io port: [0xe400-0xe403]
[    0.086555] pci 0000:00:0f.0: reg 18 io port: [0xe000-0xe007]
[    0.086562] pci 0000:00:0f.0: reg 1c io port: [0xdc00-0xdc03]
[    0.086569] pci 0000:00:0f.0: reg 20 io port: [0xd800-0xd80f]
[    0.086577] pci 0000:00:0f.0: reg 24 io port: [0xd400-0xd4ff]
[    0.086643] pci 0000:00:0f.1: reg 20 io port: [0xfc00-0xfc0f]
[    0.086719] pci 0000:00:10.0: reg 20 io port: [0xd000-0xd01f]
[    0.086743] pci 0000:00:10.0: supports D1 D2
[    0.086746] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.086751] pci 0000:00:10.0: PME# disabled
[    0.086785] pci 0000:00:10.4: reg 10 32bit mmio: [0xdffe7e00-0xdffe7eff]
[    0.086822] pci 0000:00:10.4: supports D1 D2
[    0.086826] pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.086830] pci 0000:00:10.4: PME# disabled
[    0.086888] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.086962] pci 0000:01:00.0: reg 10 32bit mmio pref: [0xd0000000-0xd7ffffff]
[    0.086969] pci 0000:01:00.0: reg 14 io port: [0xb800-0xb8ff]
[    0.086976] pci 0000:01:00.0: reg 18 32bit mmio: [0xdfef0000-0xdfefffff]
[    0.086992] pci 0000:01:00.0: reg 30 32bit mmio pref: [0xdfec0000-0xdfedffff]
[    0.087010] pci 0000:01:00.0: supports D1 D2
[    0.087038] pci 0000:01:00.1: reg 10 32bit mmio pref: [0xc8000000-0xcfffffff]
[    0.087046] pci 0000:01:00.1: reg 14 32bit mmio: [0xdfee0000-0xdfeeffff]
[    0.087074] pci 0000:01:00.1: supports D1 D2
[    0.087117] pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
[    0.087122] pci 0000:00:01.0: bridge 32bit mmio: [0xdfe00000-0xdfefffff]
[    0.087127] pci 0000:00:01.0: bridge 32bit mmio pref: [0xbfd00000-0xdfcfffff]
[    0.087136] pci_bus 0000:00: on NUMA node 0
[    0.087142] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.089345] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.089466] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.089585] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.089701] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 *12 14 15)
[    0.089818] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.089934] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.090052] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.090168] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.090295] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.090300] vgaarb: loaded
[    0.090385] PCI: Using ACPI for IRQ routing
[    0.090573] Switching to clocksource tsc
[    0.091997] pnp: PnP ACPI init
[    0.091997] ACPI: bus type pnp registered
[    0.091997] pnp: PnP ACPI: found 8 devices
[    0.091997] ACPI: ACPI bus type pnp unregistered
[    0.091997] PnPBIOS: Disabled by ACPI PNP
[    0.091997] system 00:01: ioport range 0x290-0x297 has been reserved
[    0.091997] system 00:01: ioport range 0x3f0-0x3f1 has been reserved
[    0.091997] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.091997] system 00:01: ioport range 0x400-0x40f has been reserved
[    0.091997] system 00:01: ioport range 0x820-0x821 has been reserved
[    0.091997] system 00:01: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.126758] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.126763] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
[    0.126770] pci 0000:00:01.0:   MEM window: 0xdfe00000-0xdfefffff
[    0.126775] pci 0000:00:01.0:   PREFETCH window: 0xbfd00000-0xdfcfffff
[    0.126793] pci 0000:00:01.0: setting latency timer to 64
[    0.126800] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.126804] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.126808] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.126812] pci_bus 0000:01: resource 1 mem: [0xdfe00000-0xdfefffff]
[    0.126816] pci_bus 0000:01: resource 2 pref mem [0xbfd00000-0xdfcfffff]
[    0.126867] NET: Registered protocol family 2
[    0.127001] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.127627] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.129557] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.130687] TCP: Hash tables configured (established 131072 bind 65536)
[    0.130691] TCP reno registered
[    0.130845] NET: Registered protocol family 1
[    0.130872] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
[    0.130938] pci 0000:00:11.0: Bypassing VIA 8237 APIC De-Assert Message
[    0.130947] pci 0000:01:00.0: Boot video device
[    0.131032] Unpacking initramfs...
[    0.428570] Freeing initrd memory: 8417k freed
[    0.442488] audit: initializing netlink socket (disabled)
[    0.442511] type=2000 audit(1275268014.441:1): initialized
[    0.442830] highmem bounce pool size: 64 pages
[    0.442839] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.444861] VFS: Disk quotas dquot_6.5.2
[    0.444944] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.445060] msgmni has been set to 1723
[    0.445375] alg: No test for stdrng (krng)
[    0.445413] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.445418] io scheduler noop registered
[    0.445422] io scheduler anticipatory registered
[    0.445425] io scheduler deadline registered
[    0.445470] io scheduler cfq registered (default)
[    0.445684] isapnp: Scanning for PnP cards...
[    0.799033] isapnp: No Plug & Play device found
[    0.800956] Linux agpgart interface v0.103
[    0.801095] agpgart: Detected VIA KT400/KT400A/KT600 chipset
[    0.809177] agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xe0000000
[    0.809211] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.809671] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.809675] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.809823] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.809947] mice: PS/2 mouse device common for all mice
[    0.810007] rtc_cmos 00:03: RTC can wake from S4
[    0.810070] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.810117] rtc0: alarms up to one year, y3k, 114 bytes nvram
[    0.810132] cpuidle: using governor ladder
[    0.810136] cpuidle: using governor menu
[    0.810143] No iBFT detected.
[    0.810700] TCP cubic registered
[    0.810904] NET: Registered protocol family 10
[    0.811544] lo: Disabled Privacy Extensions
[    0.812019] Mobile IPv6
[    0.812023] NET: Registered protocol family 17
[    0.812045] Using IPI No-Shortcut mode
[    0.812134] PM: Resume from disk failed.
[    0.812145] registered taskstats version 1
[    0.812416] rtc_cmos 00:03: setting system clock to 2010-05-31 01:06:55 UTC (1275268015)
[    0.812453] Initalizing network drop monitor service
[    0.812490] Freeing unused kernel memory: 376k freed
[    0.813048] Write protecting the kernel text: 2492k
[    0.813075] Write protecting the kernel read-only data: 916k
[    0.835479] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.836646] udev: starting version 154
[    1.018288] megaraid_mm: Unknown symbol _spin_unlock_irqrestore
[    1.023677] scsi_mod: Unknown symbol _spin_unlock_irqrestore
[    1.027320] skge 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.027335] skge 0000:00:05.0: PCI: Disallowing DAC for device
[    1.027373] skge 1.13 addr 0xdffec000 irq 16 chip Yukon-Lite rev 9
[    1.028358] skge eth0: addr 00:19:5b:86:3e:fb
[    1.087115] usbcore: registered new interface driver usbfs
[    1.087323] usbcore: registered new interface driver hub
[    1.087548] usbcore: registered new device driver usb
[    1.095435] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.095494] ehci_hcd 0000:00:10.4: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[    1.095519] ehci_hcd 0000:00:10.4: EHCI Host Controller
[    1.095553] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
[    1.095638] ehci_hcd 0000:00:10.4: irq 21, io mem 0xdffe7e00
[    1.101496] SCSI subsystem initialized
[    1.130962] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
[    1.131019] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.131023] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.131028] usb usb1: Product: EHCI Host Controller
[    1.131031] usb usb1: Manufacturer: Linux 2.6.32-5-686 ehci_hcd
[    1.131034] usb usb1: SerialNumber: 0000:00:10.4
[    1.131264] usb usb1: configuration #1 chosen from 1 choice
[    1.131358] hub 1-0:1.0: USB hub found
[    1.131378] hub 1-0:1.0: 2 ports detected
[    1.135430] uhci_hcd: USB Universal Host Controller Interface driver
[    1.135523] uhci_hcd 0000:00:10.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    1.135536] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    1.135556] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
[    1.135588] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d000
[    1.135659] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.135663] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.135668] usb usb2: Product: UHCI Host Controller
[    1.135671] usb usb2: Manufacturer: Linux 2.6.32-5-686 uhci_hcd
[    1.135674] usb usb2: SerialNumber: 0000:00:10.0
[    1.135865] usb usb2: configuration #1 chosen from 1 choice
[    1.135958] hub 2-0:1.0: USB hub found
[    1.135975] hub 2-0:1.0: 2 ports detected
[    1.137009] libata version 3.00 loaded.
[    1.142173] pata_via 0000:00:0f.1: version 0.3.4
[    1.142210] pata_via 0000:00:0f.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.145202] scsi0 : pata_via
[    1.145504] scsi1 : pata_via
[    1.147555] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
[    1.147560] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
[    1.368551] ata1.00: ATA-6: ST3160021A, 8.01, max UDMA/100
[    1.368557] ata1.00: 312581808 sectors, multi 16: LBA48 
[    1.384405] ata1.00: configured for UDMA/100
[    1.384575] scsi 0:0:0:0: Direct-Access     ATA      ST3160021A       8.01 PQ: 0 ANSI: 5
[    1.564919] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.564996] sd 0:0:0:0: [sda] Write Protect is off
[    1.565002] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.565035] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.565224]  sda: sda1 sda2
[    1.586549] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.128021] floppy0: no floppy controllers found
[    4.188314] md: linear personality registered for level -1
[    4.192668] md: multipath personality registered for level -4
[    4.196368] md: raid0 personality registered for level 0
[    4.202651] md: raid1 personality registered for level 1
[    4.206019] async_tx: api initialized (async)
[    4.207401] xor: automatically using best checksumming function: pIII_sse
[    4.224006]    pIII_sse  :  3019.000 MB/sec
[    4.224010] xor: using function: pIII_sse (3019.000 MB/sec)
[    4.292008] raid6: int32x1    694 MB/s
[    4.360044] raid6: int32x2    714 MB/s
[    4.428021] raid6: int32x4    587 MB/s
[    4.496099] raid6: int32x8    535 MB/s
[    4.564039] raid6: mmxx1     1384 MB/s
[    4.632020] raid6: mmxx2     2366 MB/s
[    4.700041] raid6: sse1x1    1251 MB/s
[    4.768035] raid6: sse1x2    2035 MB/s
[    4.768038] raid6: using algorithm sse1x2 (2035 MB/s)
[    4.777866] md: raid6 personality registered for level 6
[    4.777871] md: raid5 personality registered for level 5
[    4.777874] md: raid4 personality registered for level 4
[    4.788342] md: raid10 personality registered for level 10
[    4.841838] PM: Starting manual resume from disk
[    4.841846] PM: Resume from partition 8:1
[    4.841849] PM: Checking hibernation image.
[    4.842121] PM: Error -22 checking image file
[    4.842124] PM: Resume from disk failed.
[    4.894116] EXT3-fs: INFO: recovery required on readonly filesystem.
[    4.894121] EXT3-fs: write access will be enabled during recovery.
[    5.299011] kjournald starting.  Commit interval 5 seconds
[    5.299032] EXT3-fs: recovery complete.
[    5.299728] EXT3-fs: mounted filesystem with ordered data mode.
[    7.077683] udev: starting version 154
[    7.571234] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    7.571247] ACPI: Power Button [PWRB]
[    7.571810] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    7.571823] ACPI: Sleep Button [SLPB]
[    7.571968] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    7.571975] ACPI: Power Button [PWRF]
[    7.975727] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    8.228482] processor LNXCPU:00: registered as cooling_device0
[    8.232644] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    8.239414] sata_via 0000:00:0f.0: version 2.4
[    8.239444] sata_via 0000:00:0f.0: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    8.239515] sata_via 0000:00:0f.0: routed to hard irq line 11
[    8.239640] scsi2 : sata_via
[    8.239889] scsi3 : sata_via
[    8.239954] ata3: SATA max UDMA/133 cmd 0xe800 ctl 0xe400 bmdma 0xd800 irq 20
[    8.239959] ata4: SATA max UDMA/133 cmd 0xe000 ctl 0xdc00 bmdma 0xd808 irq 20
[    8.247809] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    8.444019] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    9.022675] ata3.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    9.022682] ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    9.028387] ata3.00: configured for UDMA/133
[    9.028549] scsi 2:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    9.029046] sd 2:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    9.029120] sd 2:0:0:0: [sdb] Write Protect is off
[    9.029125] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    9.029157] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.029351]  sdb:
[    9.064641] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    9.064690] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    9.096768]  [LDM] sdb1
[    9.097761] sd 2:0:0:0: [sdb] Attached SCSI disk
[    9.232012] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    9.800431] ata4.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    9.800438] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    9.808686] ata4.00: configured for UDMA/133
[    9.808854] scsi 3:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    9.809380] sd 3:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    9.809454] sd 3:0:0:0: [sdc] Write Protect is off
[    9.809459] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    9.809490] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.809673]  sdc:
[    9.865173] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    9.865221] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    9.897442]  [LDM] sdc1
[    9.898380] sd 3:0:0:0: [sdc] Attached SCSI disk
[    9.921558] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    9.921592] megaraid: probe new device 0x101e:0x1960:0x101e:0x0511: bus 0:slot 8:func 0
[    9.921624] megaraid 0000:00:08.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.944152] megaraid: fw version:[N661] bios version:[1.01]
[    9.981240] [drm] Initialized drm 1.1.0 20060810
[   10.008082] megaraid 0000:00:08.0: PCI: Disallowing DAC for device
[   10.008088] megaraid: DMA mask for 64-bit failed
[   10.009743] scsi4 : LSI Logic MegaRAID driver
[   10.010458] ACPI: I/O resource vt596_smbus [0x400-0x407] conflicts with ACPI region SMOV [0x400-0x406]
[   10.010505] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.012292] scsi[4]: scanning scsi channel 0 [Phy 0] for non-raid devices
[   10.065048] scsi[4]: scanning scsi channel 1 [Phy 1] for non-raid devices
[   10.070967] scsi[4]: scanning scsi channel 2 [Phy 2] for non-raid devices
[   10.104321] [drm] radeon defaulting to userspace modesetting.
[   10.104459] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.104775] [drm] Initialized radeon 1.32.0 20080528 for 0000:01:00.0 on minor 0
[   10.153993] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   10.176975] Error: Driver 'pcspkr' is already registered, aborting...
[   10.596027] floppy0: no floppy controllers found
[   12.160193] scsi[4]: scanning scsi channel 3 [Phy 3] for non-raid devices
[   12.164756] scsi[4]: scanning scsi channel 4 [virtual] for logical drives
[   12.165285] scsi 4:4:0:0: Direct-Access     MegaRAID LD 0 RAID0  915G N661 PQ: 0 ANSI: 2
[   12.176617] sd 4:4:0:0: [sdd] 1875419136 512-byte logical blocks: (960 GB/894 GiB)
[   12.176676] sd 4:4:0:0: [sdd] Write Protect is off
[   12.176681] sd 4:4:0:0: [sdd] Mode Sense: 00 00 00 00
[   12.176697] sd 4:4:0:0: [sdd] Asking for cache data failed
[   12.176740] sd 4:4:0:0: [sdd] Assuming drive cache: write through
[   12.177083] sd 4:4:0:0: [sdd] Asking for cache data failed
[   12.177121] sd 4:4:0:0: [sdd] Assuming drive cache: write through
[   12.177159]  sdd: unknown partition table
[   12.204360] sd 4:4:0:0: [sdd] Asking for cache data failed
[   12.204404] sd 4:4:0:0: [sdd] Assuming drive cache: write through
[   12.204443] sd 4:4:0:0: [sdd] Attached SCSI disk
[   13.620026] floppy0: no floppy controllers found
[   14.563861] Adding 3903752k swap on /dev/sda1.  Priority:-1 extents:1 across:3903752k 
[   14.810075] EXT3 FS on sda2, internal journal
[   14.932890] loop: module loaded
[   14.980251] w83627hf: Found W83697HF chip at 0x290
[   15.834439] skge eth0: enabling interface
[   15.838355] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.181378] skge eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   18.181698] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   28.692008] eth0: no IPv6 routers present
[   81.956215] md: nonpersistent superblock ...
[   81.956223] md: bind<sdc1>
[   81.956264] md: nonpersistent superblock ...
[   81.956269] md: bind<sdb1>
[   81.958303] raid0: looking at sdb1
[   81.958309] raid0:   comparing sdb1(3907024896)
[   81.958312]  with sdb1(3907024896)
[   81.958315] raid0:   END
[   81.958316] raid0:   ==> UNIQUE
[   81.958319] raid0: 1 zones
[   81.958321] raid0: looking at sdc1
[   81.958324] raid0:   comparing sdc1(3907024896)
[   81.958328]  with sdb1(3907024896)
[   81.958330] raid0:   EQUAL
[   81.958332] raid0: FINAL 1 zones
[   81.958338] raid0: done.
[   81.958341] raid0 : md_size is 7814049792 sectors.
[   81.958344] ******* md0 configuration *********
[   81.958347] zone0=[sdc1/sdb1/]
[   81.958352]         zone offset=0kb device offset=0kb size=3907024896kb
[   81.958355] **********************************
[   81.958357] 
[   81.958375] md0: detected capacity change from 0 to 4000793493504
[   81.962566]  md0: AHDI p2 p3
[  356.426600] BUG: unable to handle kernel paging request at 1a401a54
[  356.426757] IP: [<c108795d>] find_get_page+0x40/0x81
[  356.426864] *pde = 00000000 
[  356.426964] Oops: 0000 [#1] SMP 
[  356.427061] last sysfs file: /sys/devices/virtual/block/md0/removable
[  356.427107] Modules linked in: w83627hf hwmon_vid loop snd_pcsp snd_pcm radeon snd_timer ttm snd drm_kms_helper drm i2c_viapro soundcore megaraid_mbox i2c_algo_bit megaraid_mm snd_page_alloc i2c_core sata_via shpchp processor pci_hotplug tpm_tis tpm tpm_bios evdev button ext3 jbd mbcache raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod sd_mod crc_t10dif ata_generic pata_via uhci_hcd libata thermal ehci_hcd scsi_mod thermal_sys usbcore nls_base skge [last unloaded: scsi_wait_scan]
[  356.428019] 
[  356.428019] Pid: 1229, comm: mkfs.ext4 Not tainted (2.6.32-5-686 #1) MS-6590
[  356.428019] EIP: 0060:[<c108795d>] EFLAGS: 00010203 CPU: 0
[  356.428019] EIP is at find_get_page+0x40/0x81
[  356.428019] EAX: 1a401a4f EBX: 00000000 ECX: 1a401a50 EDX: 00000000
[  356.428019] ESI: dfe7bccc EDI: 1a401a54 EBP: f69a5308 ESP: f641bd5c
[  356.428019]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  356.428019] Process mkfs.ext4 (pid: 1229, ti=f641a000 task=f6fcd980 task.ti=f641a000)
[  356.428019] Stack:
[  356.428019]  1a401a50 00000000 c15fcda0 1af01341 f69a530c 00000000 f69a5308 1af01341
[  356.428019] <0> f69a5308 c1087c6a 00000000 f69a5308 ffffffff c1087ec6 000000d0 1af01341
[  356.428019] <0> c15fcda0 00000000 f69a5308 f69a5258 000001af c10cef9a 00000000 00001000
[  356.428019] Call Trace:
[  356.428019]  [<c1087c6a>] ? find_lock_page+0x10/0x36
[  356.428019]  [<c1087ec6>] ? grab_cache_page_write_begin+0x30/0x88
[  356.428019]  [<c10cef9a>] ? block_write_begin+0x2b/0xc6
[  356.428019]  [<c10d21a1>] ? blkdev_write_begin+0x29/0x2d
[  356.428019]  [<c10d14c8>] ? blkdev_get_block+0x0/0xb8
[  356.428019]  [<c10886fa>] ? generic_file_buffered_write+0xd0/0x21d
[  356.428019]  [<c1088c44>] ? __generic_file_aio_write+0x265/0x28d
[  356.428019]  [<c1047c3a>] ? atomic_notifier_call_chain+0xc/0xf
[  356.428019]  [<c119e7b5>] ? do_con_write+0x1993/0x19cd
[  356.428019]  [<c10d1996>] ? blkdev_aio_write+0x2f/0x69
[  356.428019]  [<c10b312e>] ? do_sync_write+0xc0/0x107
[  356.428019]  [<c1047af6>] ? up+0x9/0x2a
[  356.428019]  [<c10445ce>] ? autoremove_wake_function+0x0/0x2d
[  356.428019]  [<c126d514>] ? mutex_lock+0xb/0x24
[  356.428019]  [<c110263c>] ? security_file_permission+0xc/0xd
[  356.428019]  [<c10b306e>] ? do_sync_write+0x0/0x107
[  356.428019]  [<c10b3a5a>] ? vfs_write+0x7e/0xd6
[  356.428019]  [<c10b3b4a>] ? sys_write+0x3c/0x63
[  356.428019]  [<c10030fb>] ? sysenter_do_call+0x12/0x28
[  356.428019] Code: 0c 8b 44 24 10 e8 74 01 0b 00 85 c0 89 c6 74 44 8b 08 b8 ff ff ff ff f6 c1 01 0f 45 c8 8d 41 ff 83 f8 fd 89 0c 24 77 d5 8d 79 04 <8b> 59 04 89 7c 24 04 85 db 74 c7 8d 6b 01 89 d8 8b 7c 24 04 3e 
[  356.428019] EIP: [<c108795d>] find_get_page+0x40/0x81 SS:ESP 0068:f641bd5c
[  356.428019] CR2: 000000001a401a54
[  356.433563] ---[ end trace 2999fa4b920534ab ]---
[  358.528064] BUG: unable to handle kernel paging request at c1137ddb
[  358.528177] IP: [<c10ce734>] lock_buffer+0x8/0x1d
[  358.528260] *pde = 36f18063 *pte = 01137161 
[  358.528357] Oops: 0003 [#2] SMP 
[  358.528451] last sysfs file: /sys/devices/virtual/block/md0/removable
[  358.528496] Modules linked in: w83627hf hwmon_vid loop snd_pcsp snd_pcm radeon snd_timer ttm snd drm_kms_helper drm i2c_viapro soundcore megaraid_mbox i2c_algo_bit megaraid_mm snd_page_alloc i2c_core sata_via shpchp processor pci_hotplug tpm_tis tpm tpm_bios evdev button ext3 jbd mbcache raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod sd_mod crc_t10dif ata_generic pata_via uhci_hcd libata thermal ehci_hcd scsi_mod thermal_sys usbcore nls_base skge [last unloaded: scsi_wait_scan]
[  358.530267] 
[  358.530308] Pid: 1229, comm: mkfs.ext4 Tainted: G      D    (2.6.32-5-686 #1) MS-6590
[  358.530360] EIP: 0060:[<c10ce734>] EFLAGS: 00010246 CPU: 0
[  358.530404] EIP is at lock_buffer+0x8/0x1d
[  358.530445] EAX: 00000000 EBX: c1137ddb ECX: 00000002 EDX: f641a000
[  358.530490] ESI: c1b89e20 EDI: dfe7bcc0 EBP: 0f001001 ESP: f641bafc
[  358.530534]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  358.530579] Process mkfs.ext4 (pid: 1229, ti=f641a000 task=f6fcd980 task.ti=f641a000)
[  358.530630] Stack:
[  358.530667]  c1137ddb c10cfea4 00000000 00010888 c10cfe6a f69a5308 0000000d 1a401a50
[  358.530905] <0> c108e746 c1b89e20 c108eb6b c1b89e20 1a401a50 c108ec3d 0000000e c10884b2
[  358.531203] <0> 00000000 00000000 f69a5308 00000000 ffffffff 0000000e 00000000 c1b8b700
[  358.531532] Call Trace:
[  358.531582]  [<c1137ddb>] ? radix_tree_node_rcu_free+0x0/0x37
[  358.531628]  [<c10cfea4>] ? block_invalidatepage+0x3a/0x8b
[  358.531673]  [<c10cfe6a>] ? block_invalidatepage+0x0/0x8b
[  358.531720]  [<c108e746>] ? do_invalidatepage+0x16/0x18
[  358.531764]  [<c108eb6b>] ? truncate_inode_page+0x47/0x80
[  358.531808]  [<c108ec3d>] ? truncate_inode_pages_range+0x99/0x23f
[  358.531857]  [<c10884b2>] ? wait_on_page_writeback_range+0x9f/0xdf
[  358.531904]  [<c108edec>] ? truncate_inode_pages+0x9/0xc
[  358.531948]  [<c10d237b>] ? __blkdev_put+0x61/0x10f
[  358.531995]  [<c10b420b>] ? __fput+0xd5/0x170
[  358.532002]  [<c10b18e0>] ? filp_close+0x4e/0x54
[  358.532002]  [<c1032530>] ? put_files_struct+0x60/0xa6
[  358.532002]  [<c1033b8b>] ? do_exit+0x1d4/0x5c6
[  358.532002]  [<c126c3e6>] ? printk+0xe/0x18
[  358.532002]  [<c100609d>] ? oops_end+0x98/0x9d
[  358.532002]  [<c101c0bf>] ? no_context+0x105/0x10e
[  358.532002]  [<c101c1dd>] ? __bad_area_nosemaphore+0x115/0x11d
[  358.532002]  [<c102bd85>] ? finish_task_switch+0x34/0x8e
[  358.532002]  [<c126ccde>] ? schedule+0x78f/0x7dc
[  358.532002]  [<c102db97>] ? try_to_wake_up+0x25d/0x269
[  358.532002]  [<c108be2c>] ? get_page_from_freelist+0xc0/0x3c7
[  358.532002]  [<c101c49e>] ? do_page_fault+0x13f/0x287
[  358.532002]  [<c101c21e>] ? bad_area+0x2d/0x32
[  358.532002]  [<c101c35f>] ? do_page_fault+0x0/0x287
[  358.532002]  [<c126e023>] ? error_code+0x73/0x78
[  358.532002]  [<c108795d>] ? find_get_page+0x40/0x81
[  358.532002]  [<c1087c6a>] ? find_lock_page+0x10/0x36
[  358.532002]  [<c1087ec6>] ? grab_cache_page_write_begin+0x30/0x88
[  358.532002]  [<c10cef9a>] ? block_write_begin+0x2b/0xc6
[  358.532002]  [<c10d21a1>] ? blkdev_write_begin+0x29/0x2d
[  358.532002]  [<c10d14c8>] ? blkdev_get_block+0x0/0xb8
[  358.532002]  [<c10886fa>] ? generic_file_buffered_write+0xd0/0x21d
[  358.532002]  [<c1088c44>] ? __generic_file_aio_write+0x265/0x28d
[  358.532002]  [<c1047c3a>] ? atomic_notifier_call_chain+0xc/0xf
[  358.532002]  [<c119e7b5>] ? do_con_write+0x1993/0x19cd
[  358.532002]  [<c10d1996>] ? blkdev_aio_write+0x2f/0x69
[  358.532002]  [<c10b312e>] ? do_sync_write+0xc0/0x107
[  358.532002]  [<c1047af6>] ? up+0x9/0x2a
[  358.532002]  [<c10445ce>] ? autoremove_wake_function+0x0/0x2d
[  358.532002]  [<c126d514>] ? mutex_lock+0xb/0x24
[  358.532002]  [<c110263c>] ? security_file_permission+0xc/0xd
[  358.532002]  [<c10b306e>] ? do_sync_write+0x0/0x107
[  358.532002]  [<c10b3a5a>] ? vfs_write+0x7e/0xd6
[  358.532002]  [<c10b3b4a>] ? sys_write+0x3c/0x63
[  358.532002]  [<c10030fb>] ? sysenter_do_call+0x12/0x28
[  358.532002] Code: 89 c3 3e 0f ba 28 02 19 c0 85 c0 74 14 b9 e0 e3 0c c1 ba 02 00 00 00 6a 02 89 d8 e8 f8 e9 19 00 59 5b c3 53 89 c3 e8 e6 e6 19 00 <3e> 0f ba 2b 02 19 c0 85 c0 74 08 89 d8 5b e9 c1 ff ff ff 5b c3 
[  358.532002] EIP: [<c10ce734>] lock_buffer+0x8/0x1d SS:ESP 0068:f641bafc
[  358.532002] CR2: 00000000c1137ddb
[  358.532002] ---[ end trace 2999fa4b920534ac ]---
[  358.532002] Fixing recursive fault but reboot is needed!


-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net

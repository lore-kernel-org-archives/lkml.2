Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab3AGJjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:39:24 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:44397 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3AGJjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 04:39:20 -0500
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 7 Jan 2013 10:38:59 +0100
Message-ID: <CAH9NwWfRBqaukZiCXOyk4J1_LxhrikSZTnZrtkzNRJqvYjDHHw@mail.gmail.com>
Subject: task XYZ/1:12 blocked for more than 120 seconds.
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all..

I am running 3.6.11 kernel on a device with a broken BIOS.

[    5.200356] smpboot: CPU1: Not responding

Now I am wonder why I get warnings about blocked tasks. Should
the kernel not handle this case correctly and not try to use CPU1 in
the scheduler? Adding nosmp to the kernel cmd line works, but it does
not look like a real solution to me. In the end I am delivering a
read-to-use linux image, which runs on a handful of different devices.
So nosmp is a bad idea as I need to support smp AMD based devices.

Here is the dmesg output:

root@device:~# dmesg
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.11 (buildserver-au@atfkauss01) (gcc
version 4.4.5 (Ubuntu/Linaro 4.4.5-15ubuntu1) ) #1 SMP PREEMPT Mon Jan
7 10:06:34 CET 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000097fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000098000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003f5fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000003f600000-0x000000003fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection cannot be
enabled: non-PAE kernel!
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x3f600 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF write-back
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 0C0000000 write-back
[    0.000000]   1 base 0000E0000 mask 0FFFF8000 write-protect
[    0.000000]   2 base 03F600000 mask FFFE00000 uncachable
[    0.000000]   3 base 03F800000 mask FFF800000 uncachable
[    0.000000]   4 base 0FFE00000 mask FFFE00000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000fb880-0x000fb88f]
mapped at [c00fb880]
[    0.000000] initial memory mapped: [mem 0x00000000-0x017fffff]
[    0.000000] Base memory trampoline at [c008a000] 8a000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x377fdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x373fffff] page 2M
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x377fdfff @ [mem
0x017fa000-0x017fffff]
[    0.000000] RAMDISK: [mem 0x2ea9a000-0x2f8bffff]
[    0.000000] ACPI BIOS Bug: Error: A valid RSDP was not found
(20120711/tbxfroot-219)
[    0.000000] 126MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x3f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00097fff]
[    0.000000]   node   0: [mem 0x00100000-0x3f5fffff]
[    0.000000] On node 0 totalpages: 259464
[    0.000000] free_area_init_node: node 0, pgdat c1400580,
node_mem_map f700d200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3944 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 253 pages used for memmap
[    0.000000]   HighMem zone: 32005 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] MPTABLE: OEM ID: INTELFDK
[    0.000000] MPTABLE: Product ID: INTELFDK
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x40000000-0xfebfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2
nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f6fef000 s25088 r0 d24064 u49152
[    0.000000] pcpu-alloc: s25088 r0 d24064 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 257435
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-3.6.11-bachmann root=/dev/sda2 ro rootwait
console=ttyS0,19200n8 console=tty0
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0003f600)
[    0.000000] Memory: 1009572k/1038336k available (2875k kernel code,
28284k reserved, 1243k data, 336k init, 129032k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff66000 - 0xfffff000   ( 612 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1406000 - 0xc145a000   ( 336 kB)
[    0.000000]       .data : 0xc12cef00 - 0xc1405d00   (1243 kB)
[    0.000000]       .text : 0xc1000000 - 0xc12cef00   (2875 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f6808000 soft=f680a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1595.934 MHz processor
[    0.002003] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3191.86 BogoMIPS (lpj=1595934)
[    0.002637] pid_max: default: 32768 minimum: 301
[    0.003072] Mount-cache hash table entries: 512
[    0.003759] CPU: Physical Processor ID: 0
[    0.004007] CPU: Processor Core ID: 0
[    0.004245] process: using mwait in idle threads
[    0.004543] Last level iTLB entries: 4KB 32, 2MB 0, 4MB 0
[    0.004543] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 8
[    0.004543] tlb_flushall_shift is 0x6
[    0.005116] Freeing SMP alternatives: 12k freed
[    0.005474] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.006071] ExtINT not setup in hardware but reported by MP table
[    0.006766] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.017360] smpboot: CPU0: Genuine Intel(R) CPU        @ 1.60GHz stepping 01
[    0.118867] Performance Events: PEBS fmt0+, generic architected
perfmon, Intel PMU driver.
[    0.118981] ... version:                3
[    0.118981] ... bit width:              40
[    0.118986] ... generic registers:      2
[    0.119240] ... value mask:             000000ffffffffff
[    0.119557] ... max period:             000000007fffffff
[    0.119985] ... fixed-purpose events:   3
[    0.120239] ... event mask:             0000000700000003
[    0.131993] CPU 1 irqstacks, hard=f6866000 soft=f6870000
[    0.131999] smpboot: Booting Node   0, Processors  #1 OK
[    5.200356] smpboot: CPU1: Not responding
[    5.200629] Brought up 1 CPUs
[    5.200838] smpboot: Total of 1 processors activated (3191.86 BogoMIPS)
[    5.201813] devtmpfs: initialized
[    5.202591] reboot: PCI series board detected. Selecting Bachmann
BPC600-method for reboots.
[    5.203183] NET: Registered protocol family 16
[    5.205139] PCI: Using configuration type 1 for base access
[    5.212858] bio: create slab <bio-0> at 0
[    5.213388] ACPI: Interpreter disabled.
[    5.214232] SCSI subsystem initialized
[    5.214757] libata version 3.00 loaded.
[    5.215435] PCI: Probing PCI hardware
[    5.215681] PCI: root bus 00: using default resources
[    5.215687] PCI: Probing PCI hardware (bus 00)
[    5.215797] PCI host bridge to bus 0000:00
[    5.216068] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    5.216217] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    5.216618] pci_bus 0000:00: No busn resource found for root bus,
will use [bus 00-ff]
[    5.217217] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted
under domain [bus 00-ff]
[    5.217239] pci 0000:00:00.0: [8086:4114] type 00 class 0x060000
[    5.217303] pci 0000:00:01.0: [8086:8183] type 00 class 0x060000
[    5.217391] pci 0000:00:02.0: [8086:4108] type 00 class 0x030000
[    5.217414] pci 0000:00:02.0: reg 10: [mem 0xdff00000-0xdfffffff]
[    5.217427] pci 0000:00:02.0: reg 14: [io  0x8000-0x8007]
[    5.217439] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff]
[    5.217452] pci 0000:00:02.0: reg 1c: [mem 0xbffc0000-0xbfffffff]
[    5.217535] pci 0000:00:03.0: [8086:8182] type 00 class 0x040000
[    5.217571] pci 0000:00:03.0: reg 10: [mem 0xbff00000-0xbff7ffff]
[    5.217589] pci 0000:00:03.0: reg 14: [io  0x8008-0x800f]
[    5.217608] pci 0000:00:03.0: reg 18: [mem 0xa0000000-0xafffffff]
[    5.217627] pci 0000:00:03.0: reg 1c: [mem 0x9ffc0000-0x9fffffff]
[    5.217796] pci 0000:00:17.0: [8086:8184] type 01 class 0x060400
[    5.217912] pci 0000:00:17.0: PME# supported from D0 D3hot D3cold
[    5.217954] pci 0000:00:18.0: [8086:8185] type 01 class 0x060400
[    5.218081] pci 0000:00:18.0: PME# supported from D0 D3hot D3cold
[    5.218599] pci 0000:00:19.0: [8086:8180] type 01 class 0x060400
[    5.218721] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    5.218764] pci 0000:00:1a.0: [8086:8181] type 01 class 0x060400
[    5.218883] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    5.218928] pci 0000:00:1b.0: [8086:811b] type 00 class 0x040300
[    5.218959] pci 0000:00:1b.0: reg 10: [mem 0x9fbfc000-0x9fbfffff 64bit]
[    5.219084] pci 0000:00:1b.0: PME# supported from D0 D3hot
[    5.219126] pci 0000:00:1f.0: [8086:8186] type 00 class 0x060100
[    5.219316] pci_bus 0000:01: busn_res: [bus 01-02] is inserted
under [bus 00-ff]
[    5.219351] pci 0000:01:00.0: [8086:8800] type 01 class 0x060400
[    5.219413] pci 0000:01:00.0: reg 38: [mem 0x00000000-0x0000ffff pref]
[    5.219501] pci 0000:01:00.0: supports D1
[    5.219508] pci 0000:01:00.0: PME# supported from D0 D1 D3hot D3cold
[    5.219535] pci 0000:00:17.0: PCI bridge to [bus 01-02]
[    5.219862] pci 0000:00:17.0:   bridge window [io  0x9000-0x9fff]
[    5.219873] pci 0000:00:17.0:   bridge window [mem 0x9fe00000-0x9fefffff]
[    5.219884] pci 0000:00:17.0:   bridge window [mem
0x9fa00000-0x9fafffff pref]
[    5.219959] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 01-02]
[    5.219996] pci 0000:02:00.0: [8086:8801] type 00 class 0xff0000
[    5.220060] pci 0000:02:00.0: reg 14: [mem 0x9feff800-0x9fefffff]
[    5.220160] pci 0000:02:00.0: reg 30: [mem 0x9fae0000-0x9fafffff pref]
[    5.220307] pci 0000:02:00.1: [8086:8802] type 00 class 0x020000
[    5.220355] pci 0000:02:00.1: reg 10: [io  0x9000-0x901f]
[    5.220382] pci 0000:02:00.1: reg 14: [mem 0x9feff600-0x9feff7ff]
[    5.220565] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
[    5.220623] pci 0000:02:00.2: [8086:8803] type 00 class 0xff0000
[    5.220690] pci 0000:02:00.2: reg 14: [mem 0x9feff5c0-0x9feff5ff]
[    5.220873] pci 0000:02:00.2: PME# supported from D0 D3hot D3cold
[    5.220948] pci 0000:02:02.0: [8086:8804] type 00 class 0x0c0310
[    5.220996] pci 0000:02:02.0: reg 10: [mem 0x9feff400-0x9feff4ff]
[    5.221198] pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
[    5.221265] pci 0000:02:02.1: [8086:8805] type 00 class 0x0c0310
[    5.221314] pci 0000:02:02.1: reg 10: [mem 0x9feff300-0x9feff3ff]
[    5.221516] pci 0000:02:02.1: PME# supported from D0 D3hot D3cold
[    5.221574] pci 0000:02:02.2: [8086:8806] type 00 class 0x0c0310
[    5.221622] pci 0000:02:02.2: reg 10: [mem 0x9feff200-0x9feff2ff]
[    5.221824] pci 0000:02:02.2: PME# supported from D0 D3hot D3cold
[    5.221882] pci 0000:02:02.3: [8086:8807] type 00 class 0x0c0320
[    5.221930] pci 0000:02:02.3: reg 10: [mem 0x9feff100-0x9feff1ff]
[    5.222132] pci 0000:02:02.3: PME# supported from D0 D3hot D3cold
[    5.222189] pci 0000:02:02.4: [8086:8808] type 00 class 0x0c03fe
[    5.222297] pci 0000:02:02.4: reg 14: [mem 0x9fefc000-0x9fefdfff]
[    5.222539] pci 0000:02:04.0: [8086:8809] type 00 class 0x080501
[    5.222587] pci 0000:02:04.0: reg 10: [mem 0x9fefbe00-0x9fefbfff]
[    5.222834] pci 0000:02:04.1: [8086:880a] type 00 class 0x080501
[    5.222882] pci 0000:02:04.1: reg 10: [mem 0x9fefbc00-0x9fefbdff]
[    5.223153] pci 0000:02:06.0: [8086:880b] type 00 class 0x010601
[    5.223291] pci 0000:02:06.0: reg 20: [io  0x9020-0x903f]
[    5.223317] pci 0000:02:06.0: reg 24: [mem 0x9fefb800-0x9fefbbff]
[    5.223344] pci 0000:02:06.0: reg 30: [mem 0x9fac0000-0x9fadffff pref]
[    5.223505] pci 0000:02:08.0: [8086:880c] type 00 class 0x0c0310
[    5.223553] pci 0000:02:08.0: reg 10: [mem 0x9fefb700-0x9fefb7ff]
[    5.223755] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
[    5.223813] pci 0000:02:08.1: [8086:880d] type 00 class 0x0c0310
[    5.223861] pci 0000:02:08.1: reg 10: [mem 0x9fefb600-0x9fefb6ff]
[    5.224063] pci 0000:02:08.1: PME# supported from D0 D3hot D3cold
[    5.224120] pci 0000:02:08.2: [8086:880e] type 00 class 0x0c0310
[    5.224169] pci 0000:02:08.2: reg 10: [mem 0x9fefb500-0x9fefb5ff]
[    5.224380] pci 0000:02:08.2: PME# supported from D0 D3hot D3cold
[    5.224438] pci 0000:02:08.3: [8086:880f] type 00 class 0x0c0320
[    5.224487] pci 0000:02:08.3: reg 10: [mem 0x9fefb400-0x9fefb4ff]
[    5.224689] pci 0000:02:08.3: PME# supported from D0 D3hot D3cold
[    5.224766] pci 0000:02:0a.0: [8086:8810] type 00 class 0xff0000
[    5.224838] pci 0000:02:0a.0: reg 14: [mem 0x9fefb300-0x9fefb3ff]
[    5.225087] pci 0000:02:0a.1: [8086:8811] type 00 class 0x070002
[    5.225135] pci 0000:02:0a.1: reg 10: [io  0x9040-0x9047]
[    5.225162] pci 0000:02:0a.1: reg 14: [mem 0x9fefb2f0-0x9fefb2ff]
[    5.225356] pci 0000:02:0a.1: PME# supported from D0 D3hot D3cold
[    5.225414] pci 0000:02:0a.2: [8086:8812] type 00 class 0x070002
[    5.225462] pci 0000:02:0a.2: reg 10: [io  0x9048-0x904f]
[    5.225489] pci 0000:02:0a.2: reg 14: [mem 0x9fefb2e0-0x9fefb2ef]
[    5.225717] pci 0000:02:0a.3: [8086:8813] type 00 class 0x070002
[    5.225765] pci 0000:02:0a.3: reg 10: [io  0x9050-0x9057]
[    5.225791] pci 0000:02:0a.3: reg 14: [mem 0x9fefb2d0-0x9fefb2df]
[    5.226019] pci 0000:02:0a.4: [8086:8814] type 00 class 0x070002
[    5.226067] pci 0000:02:0a.4: reg 10: [io  0x9058-0x905f]
[    5.226093] pci 0000:02:0a.4: reg 14: [mem 0x9fefb2c0-0x9fefb2cf]
[    5.226602] pci 0000:02:0c.0: [8086:8815] type 00 class 0xff0000
[    5.226675] pci 0000:02:0c.0: reg 14: [mem 0x9fefb100-0x9fefb1ff]
[    5.226925] pci 0000:02:0c.1: [8086:8816] type 00 class 0x0c8000
[    5.226992] pci 0000:02:0c.1: reg 14: [mem 0x9fefb0e0-0x9fefb0ff]
[    5.227231] pci 0000:02:0c.2: [8086:8817] type 00 class 0x0c8000
[    5.227298] pci 0000:02:0c.2: reg 14: [mem 0x9fefaf00-0x9fefafff]
[    5.227527] pci 0000:02:0c.3: [8086:8818] type 00 class 0x0c0900
[    5.227594] pci 0000:02:0c.3: reg 14: [mem 0x9fefac00-0x9fefadff]
[    5.227822] pci 0000:02:0c.4: [8086:8819] type 00 class 0xff0000
[    5.227889] pci 0000:02:0c.4: reg 14: [mem 0x9fefab00-0x9fefabff]
[    5.228157] pci 0000:01:00.0: PCI bridge to [bus 02]
[    5.228223] pci 0000:01:00.0:   bridge window [io  0x9000-0x9fff]
[    5.228235] pci 0000:01:00.0:   bridge window [mem 0x9fe00000-0x9fefffff]
[    5.228252] pci 0000:01:00.0:   bridge window [mem
0x9fa00000-0x9fafffff 64bit pref]
[    5.228333] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-ff]
[    5.228343] pci 0000:00:18.0: PCI bridge to [bus 03]
[    5.228718] pci_bus 0000:04: busn_res: [bus 04-08] is inserted
under [bus 00-ff]
[    5.228764] pci 0000:04:00.0: [12d8:a404] type 01 class 0x060400
[    5.229231] pci 0000:04:00.0: supports D1 D2
[    5.229239] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.229263] pci 0000:00:19.0: PCI bridge to [bus 04-08]
[    5.229588] pci 0000:00:19.0:   bridge window [io  0xa000-0xbfff]
[    5.229598] pci 0000:00:19.0:   bridge window [mem 0x9fc00000-0x9fdfffff]
[    5.229730] pci_bus 0000:05: busn_res: [bus 05-08] is inserted
under [bus 04-08]
[    5.229779] pci 0000:05:01.0: [12d8:a404] type 01 class 0x060400
[    5.229960] pci 0000:05:01.0: supports D1 D2
[    5.229967] pci 0000:05:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.230043] pci 0000:05:02.0: [12d8:a404] type 01 class 0x060400
[    5.230235] pci 0000:05:02.0: supports D1 D2
[    5.230243] pci 0000:05:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.230319] pci 0000:05:03.0: [12d8:a404] type 01 class 0x060400
[    5.230500] pci 0000:05:03.0: supports D1 D2
[    5.230507] pci 0000:05:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.230608] pci 0000:04:00.0: PCI bridge to [bus 05-08]
[    5.230938] pci 0000:04:00.0:   bridge window [io  0xa000-0xbfff]
[    5.230950] pci 0000:04:00.0:   bridge window [mem 0x9fc00000-0x9fdfffff]
[    5.231079] pci_bus 0000:06: busn_res: [bus 06] is inserted under [bus 05-08]
[    5.231133] pci 0000:06:00.0: [8086:10d3] type 00 class 0x020000
[    5.231173] pci 0000:06:00.0: reg 10: [mem 0x9fde0000-0x9fdfffff]
[    5.231213] pci 0000:06:00.0: reg 14: [mem 0x9fdc0000-0x9fddffff]
[    5.231245] pci 0000:06:00.0: reg 18: [io  0xa000-0xa01f]
[    5.231276] pci 0000:06:00.0: reg 1c: [mem 0x9fdbc000-0x9fdbffff]
[    5.231499] pci 0000:06:00.0: PME# supported from D0 D3hot
[    5.231549] pci 0000:05:01.0: PCI bridge to [bus 06]
[    5.231866] pci 0000:05:01.0:   bridge window [io  0xa000-0xafff]
[    5.231877] pci 0000:05:01.0:   bridge window [mem 0x9fd00000-0x9fdfffff]
[    5.232011] pci_bus 0000:07: busn_res: [bus 07] is inserted under [bus 05-08]
[    5.232065] pci 0000:07:00.0: [8086:10d3] type 00 class 0x020000
[    5.232105] pci 0000:07:00.0: reg 10: [mem 0x9fce0000-0x9fcfffff]
[    5.232136] pci 0000:07:00.0: reg 14: [mem 0x9fcc0000-0x9fcdffff]
[    5.232168] pci 0000:07:00.0: reg 18: [io  0xb000-0xb01f]
[    5.232212] pci 0000:07:00.0: reg 1c: [mem 0x9fcbc000-0x9fcbffff]
[    5.232435] pci 0000:07:00.0: PME# supported from D0 D3hot
[    5.232484] pci 0000:05:02.0: PCI bridge to [bus 07]
[    5.232801] pci 0000:05:02.0:   bridge window [io  0xb000-0xbfff]
[    5.232813] pci 0000:05:02.0:   bridge window [mem 0x9fc00000-0x9fcfffff]
[    5.232946] pci_bus 0000:08: busn_res: [bus 08] is inserted under [bus 05-08]
[    5.232957] pci 0000:05:03.0: PCI bridge to [bus 08]
[    5.233333] pci_bus 0000:09: busn_res: [bus 09] is inserted under [bus 00-ff]
[    5.233343] pci 0000:00:1a.0: PCI bridge to [bus 09]
[    5.233691] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 09
[    5.239776] PCI: pci_cache_line_size set to 64 bytes
[    5.240098] e820: reserve RAM buffer [mem 0x00098000-0x0009ffff]
[    5.240106] e820: reserve RAM buffer [mem 0x3f600000-0x3fffffff]
[    5.240961] pnp: PnP ACPI: disabled
[    5.251426] pci 0000:00:18.0: bridge window [io  0x1000-0x0fff] to
[bus 03] add_size 1000
[    5.251442] pci 0000:00:18.0: bridge window [mem
0x00100000-0x000fffff pref] to [bus 03] add_size 200000
[    5.251452] pci 0000:00:18.0: bridge window [mem
0x00100000-0x000fffff] to [bus 03] add_size 200000
[    5.251521] pci 0000:00:19.0: bridge window [mem
0x00100000-0x000fffff pref] to [bus 04-08] add_size 200000
[    5.251533] pci 0000:00:1a.0: bridge window [io  0x1000-0x0fff] to
[bus 09] add_size 1000
[    5.251543] pci 0000:00:1a.0: bridge window [mem
0x00100000-0x000fffff pref] to [bus 09] add_size 200000
[    5.251552] pci 0000:00:1a.0: bridge window [mem
0x00100000-0x000fffff] to [bus 09] add_size 200000
[    5.251569] pci 0000:00:18.0: res[8]=[mem 0x00100000-0x000fffff]
get_res_add_size add_size 200000
[    5.251578] pci 0000:00:18.0: res[9]=[mem 0x00100000-0x000fffff
pref] get_res_add_size add_size 200000
[    5.251586] pci 0000:00:19.0: res[9]=[mem 0x00100000-0x000fffff
pref] get_res_add_size add_size 200000
[    5.251595] pci 0000:00:1a.0: res[8]=[mem 0x00100000-0x000fffff]
get_res_add_size add_size 200000
[    5.251603] pci 0000:00:1a.0: res[9]=[mem 0x00100000-0x000fffff
pref] get_res_add_size add_size 200000
[    5.251611] pci 0000:00:18.0: res[7]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    5.251619] pci 0000:00:1a.0: res[7]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    5.251632] pci 0000:00:18.0: BAR 8: assigned [mem 0x40000000-0x401fffff]
[    5.252040] pci 0000:00:18.0: BAR 9: assigned [mem
0x40200000-0x403fffff pref]
[    5.252214] pci 0000:00:19.0: BAR 9: assigned [mem
0x40400000-0x405fffff pref]
[    5.252643] pci 0000:00:1a.0: BAR 8: assigned [mem 0x40600000-0x407fffff]
[    5.253212] pci 0000:00:1a.0: BAR 9: assigned [mem
0x40800000-0x409fffff pref]
[    5.253641] pci 0000:00:18.0: BAR 7: assigned [io  0x1000-0x1fff]
[    5.254005] pci 0000:00:1a.0: BAR 7: assigned [io  0x2000-0x2fff]
[    5.254220] pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x10000)
[    5.254623] pci 0000:01:00.0: PCI bridge to [bus 02]
[    5.255233] pci 0000:01:00.0:   bridge window [io  0x9000-0x9fff]
[    5.255604] pci 0000:01:00.0:   bridge window [mem 0x9fe00000-0x9fefffff]
[    5.256004] pci 0000:01:00.0:   bridge window [mem
0x9fa00000-0x9fafffff 64bit pref]
[    5.256218] pci 0000:00:17.0: PCI bridge to [bus 01-02]
[    5.256540] pci 0000:00:17.0:   bridge window [io  0x9000-0x9fff]
[    5.256906] pci 0000:00:17.0:   bridge window [mem 0x9fe00000-0x9fefffff]
[    5.257212] pci 0000:00:17.0:   bridge window [mem
0x9fa00000-0x9fafffff pref]
[    5.257645] pci 0000:00:18.0: PCI bridge to [bus 03]
[    5.258607] pci 0000:00:18.0:   bridge window [io  0x1000-0x1fff]
[    5.258979] pci 0000:00:18.0:   bridge window [mem 0x40000000-0x401fffff]
[    5.259213] pci 0000:00:18.0:   bridge window [mem
0x40200000-0x403fffff pref]
[    5.259648] pci 0000:05:01.0: PCI bridge to [bus 06]
[    5.260210] pci 0000:05:01.0:   bridge window [io  0xa000-0xafff]
[    5.260580] pci 0000:05:01.0:   bridge window [mem 0x9fd00000-0x9fdfffff]
[    5.260989] pci 0000:05:02.0: PCI bridge to [bus 07]
[    5.261210] pci 0000:05:02.0:   bridge window [io  0xb000-0xbfff]
[    5.261578] pci 0000:05:02.0:   bridge window [mem 0x9fc00000-0x9fcfffff]
[    5.261986] pci 0000:05:03.0: PCI bridge to [bus 08]
[    5.262229] pci 0000:04:00.0: PCI bridge to [bus 05-08]
[    5.262551] pci 0000:04:00.0:   bridge window [io  0xa000-0xbfff]
[    5.262919] pci 0000:04:00.0:   bridge window [mem 0x9fc00000-0x9fdfffff]
[    5.263220] pci 0000:00:19.0: PCI bridge to [bus 04-08]
[    5.263541] pci 0000:00:19.0:   bridge window [io  0xa000-0xbfff]
[    5.264212] pci 0000:00:19.0:   bridge window [mem 0x9fc00000-0x9fdfffff]
[    5.264612] pci 0000:00:19.0:   bridge window [mem
0x40400000-0x405fffff pref]
[    5.265044] pci 0000:00:1a.0: PCI bridge to [bus 09]
[    5.265209] pci 0000:00:1a.0:   bridge window [io  0x2000-0x2fff]
[    5.265575] pci 0000:00:1a.0:   bridge window [mem 0x40600000-0x407fffff]
[    5.265974] pci 0000:00:1a.0:   bridge window [mem
0x40800000-0x409fffff pref]
[    5.266357] pci 0000:00:17.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    5.266756] pci 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    5.267216] pci 0000:00:18.0: enabling device (0004 -> 0007)
[    5.267563] pci 0000:00:18.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    5.268217] pci 0000:00:19.0: PCI->APIC IRQ transform: INT C -> IRQ 16
[    5.268642] pci 0000:00:1a.0: enabling device (0004 -> 0007)
[    5.268989] pci 0000:00:1a.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    5.269210] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    5.269218] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    5.269226] pci_bus 0000:01: resource 0 [io  0x9000-0x9fff]
[    5.269234] pci_bus 0000:01: resource 1 [mem 0x9fe00000-0x9fefffff]
[    5.269241] pci_bus 0000:01: resource 2 [mem 0x9fa00000-0x9fafffff pref]
[    5.269249] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
[    5.269256] pci_bus 0000:02: resource 1 [mem 0x9fe00000-0x9fefffff]
[    5.269264] pci_bus 0000:02: resource 2 [mem 0x9fa00000-0x9fafffff
64bit pref]
[    5.269272] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    5.269280] pci_bus 0000:03: resource 1 [mem 0x40000000-0x401fffff]
[    5.269287] pci_bus 0000:03: resource 2 [mem 0x40200000-0x403fffff pref]
[    5.269295] pci_bus 0000:04: resource 0 [io  0xa000-0xbfff]
[    5.269302] pci_bus 0000:04: resource 1 [mem 0x9fc00000-0x9fdfffff]
[    5.269310] pci_bus 0000:04: resource 2 [mem 0x40400000-0x405fffff pref]
[    5.269317] pci_bus 0000:05: resource 0 [io  0xa000-0xbfff]
[    5.269325] pci_bus 0000:05: resource 1 [mem 0x9fc00000-0x9fdfffff]
[    5.269332] pci_bus 0000:06: resource 0 [io  0xa000-0xafff]
[    5.269340] pci_bus 0000:06: resource 1 [mem 0x9fd00000-0x9fdfffff]
[    5.269347] pci_bus 0000:07: resource 0 [io  0xb000-0xbfff]
[    5.269355] pci_bus 0000:07: resource 1 [mem 0x9fc00000-0x9fcfffff]
[    5.269363] pci_bus 0000:09: resource 0 [io  0x2000-0x2fff]
[    5.269370] pci_bus 0000:09: resource 1 [mem 0x40600000-0x407fffff]
[    5.269378] pci_bus 0000:09: resource 2 [mem 0x40800000-0x409fffff pref]
[    5.269459] NET: Registered protocol family 2
[    5.270304] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    5.271934] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    5.272851] TCP: Hash tables configured (established 131072 bind 65536)
[    5.273299] TCP: reno registered
[    5.273531] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    5.273904] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    5.275391] NET: Registered protocol family 1
[    5.275722] pci 0000:00:02.0: Boot video device
[    5.275826] pci 0000:02:02.0: PCI->APIC IRQ transform: INT B -> IRQ 19
[    5.276286] pci 0000:02:02.1: PCI->APIC IRQ transform: INT B -> IRQ 19
[    5.276721] pci 0000:02:02.2: PCI->APIC IRQ transform: INT B -> IRQ 19
[    5.277149] pci 0000:02:02.3: PCI->APIC IRQ transform: INT B -> IRQ 19
[    5.277283] pci 0000:02:08.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    5.277712] pci 0000:02:08.1: PCI->APIC IRQ transform: INT A -> IRQ 16
[    5.278255] pci 0000:02:08.2: PCI->APIC IRQ transform: INT A -> IRQ 16
[    5.278683] pci 0000:02:08.3: PCI->APIC IRQ transform: INT A -> IRQ 16
[    5.279333] PCI: CLS 64 bytes, default 64
[    5.279459] Unpacking initramfs...
[    6.024147] Freeing initrd memory: 14488k freed
[    6.044499] platform rtc_cmos: registered platform RTC device (no
PNP device found)
[    6.046605] bounce pool size: 64 pages
[    6.056333] fuse init (API version 7.20)
[    6.057042] msgmni has been set to 1748
[    6.057320] io scheduler noop registered (default)
[    6.123737] Serial: 8250/16550 driver, 6 ports, IRQ sharing disabled
[    6.125879] serial 0000:02:0a.1: PCI->APIC IRQ transform: INT B -> IRQ 19
[    6.127080] 0000:02:0a.1: ttyS4 at I/O 0x9040 (irq = 19) is a 16550A
[    6.127632] serial 0000:02:0a.2: PCI->APIC IRQ transform: INT B -> IRQ 19
[    6.129081] 0000:02:0a.2: ttyS5 at I/O 0x9048 (irq = 19) is a 16550A
[    6.130080] serial 0000:02:0a.3: PCI->APIC IRQ transform: INT B -> IRQ 19
[    6.131077] 0000:02:0a.3: ttyS0 at I/O 0x9050 (irq = 19) is a 16550A
[    6.132237] serial 0000:02:0a.4: PCI->APIC IRQ transform: INT B -> IRQ 19
[    6.134079] 0000:02:0a.4: ttyS1 at I/O 0x9058 (irq = 19) is a 16550A
[    6.138234] loop: module loaded
[    6.139200] ACPI Exception: AE_BAD_PARAMETER, Thread 4135803904
could not acquire Mutex [0x1] (20120711/utmutex-276)
[    6.142187] ACPI Exception: AE_BAD_PARAMETER, Thread 4135803904
could not acquire Mutex [0x1] (20120711/utmutex-276)
[    6.145178] ACPI Exception: AE_BAD_PARAMETER, Thread 4135803904
could not acquire Mutex [0x1] (20120711/utmutex-276)
[    6.149944] ahci 0000:02:06.0: version 3.0
[    6.149986] ahci 0000:02:06.0: PCI->APIC IRQ transform: INT D -> IRQ 17
[    6.150172] ahci 0000:02:06.0: irq 40 for MSI/MSI-X
[    6.150258] ahci: SSS flag set, parallel bus scan disabled
[    6.151136] ahci 0000:02:06.0: AHCI 0001.0100 32 slots 2 ports 3
Gbps 0x3 impl SATA mode
[    6.152076] ahci 0000:02:06.0: flags: ncq sntf stag pm led clo only
pmp pio slum part ccc
[    6.153107] ahci 0000:02:06.0: setting latency timer to 64
[    6.154630] scsi0 : ahci
[    6.155371] scsi1 : ahci
[    6.156292] ata1: SATA max UDMA/133 abar m1024@0x9fefb800 port
0x9fefb900 irq 40
[    6.157128] ata2: SATA max UDMA/133 abar m1024@0x9fefb800 port
0x9fefb980 irq 40
[    6.159422] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    6.160072] e100: Copyright(c) 1999-2006 Intel Corporation
[    6.161222] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[    6.162068] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    6.163121] e1000e 0000:06:00.0: Disabling ASPM L0s L1
[    6.164105] e1000e 0000:06:00.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    6.166119] e1000e 0000:06:00.0: Interrupt Throttling Rate
(ints/sec) set to dynamic conservative mode
[    6.167208] e1000e 0000:06:00.0: irq 41 for MSI/MSI-X
[    6.167226] e1000e 0000:06:00.0: irq 42 for MSI/MSI-X
[    6.167242] e1000e 0000:06:00.0: irq 43 for MSI/MSI-X
[    6.274541] e1000e 0000:06:00.0: eth0: (PCI Express:2.5GT/s:Width
x1) 00:10:7e:03:46:cf
[    6.275058] e1000e 0000:06:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    6.276070] e1000e 0000:06:00.0: eth0: MAC: 3, PHY: 8, PBA No: 123456-078
[    6.278064] e1000e 0000:07:00.0: Disabling ASPM L0s L1
[    6.279087] e1000e 0000:07:00.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    6.280223] e1000e 0000:07:00.0: Interrupt Throttling Rate
(ints/sec) set to dynamic conservative mode
[    6.281210] e1000e 0000:07:00.0: irq 44 for MSI/MSI-X
[    6.281228] e1000e 0000:07:00.0: irq 45 for MSI/MSI-X
[    6.281244] e1000e 0000:07:00.0: irq 46 for MSI/MSI-X
[    6.389476] e1000e 0000:07:00.0: eth1: (PCI Express:2.5GT/s:Width
x1) 00:10:7e:03:46:d0
[    6.390040] e1000e 0000:07:00.0: eth1: Intel(R) PRO/1000 Network Connection
[    6.391052] e1000e 0000:07:00.0: eth1: MAC: 3, PHY: 8, PBA No: 123456-078
[    6.393702] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    6.394077] rtc0: alarms up to one day, 114 bytes nvram
[    6.396097] i2c /dev entries driver
[    6.398279] cpuidle: using governor ladder
[    6.399152] TCP: cubic registered
[    6.400034] NET: Registered protocol family 17
[    6.401058] Key type dns_resolver registered
[    6.403082] Using IPI Shortcut mode
[    6.404429] registered taskstats version 1

...
...

[   16.182328] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: Rx/Tx
[   16.183509] br0: port 1(eth0) entered forwarding state
[   16.184279] br0: port 1(eth0) entered forwarding state
[   17.542813] wd_keepalive (2200): /proc/2200/oom_adj is deprecated,
please use /proc/2200/oom_score_adj instead.
[   31.234981] br0: port 1(eth0) entered forwarding state
[  246.176317] INFO: task migration/1:9 blocked for more than 120 seconds.
[  246.177396] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.178420] migration/1     D c12d5c20     0     9      2 0x00000000
[  246.182444]  f6858400 00000046 f6ff4b00 c12d5c20 07a19add 00000000
f6ff4b00 f6835c00
[  246.191393]  c1458b00 c1458b00 c1453000 c1458b00 f6ff4b00 c1453000
c1453000 00000000
[  246.201394]  00000000 c12cd2cf c1051d9e 00000046 00000000 f6841ef4
f6841f2c 00000001
[  246.210393] Call Trace:
[  246.211434]  [<c12cd2cf>] ? _raw_spin_unlock_irqrestore+0xf/0x30
[  246.212491]  [<c1051d9e>] ? try_to_wake_up+0x12e/0x180
[  246.214381]  [<c104ceb7>] ? __wake_up_common+0x47/0x70
[  246.215471]  [<c104d660>] ? complete+0x40/0x60
[  246.216460]  [<c10731f0>] ? ikconfig_read_current+0x30/0x30
[  246.217474]  [<c1045062>] ? kthread+0x62/0x90
[  246.218460]  [<c1045000>] ? kthread_worker_fn+0xe0/0xe0
[  246.219476]  [<c12ce376>] ? kernel_thread_helper+0x6/0xd
[  246.221362] INFO: task ksoftirqd/1:12 blocked for more than 120 seconds.
[  246.222483] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.223506] ksoftirqd/1     D c12d5c20     0    12      2 0x00000000
[  246.226422]  f6859000 00000046 f6ff4b00 c12d5c20 07c10940 00000000
f6ff4b00 f6835c00
[  246.235384]  c1458b00 c1458b00 c1453000 c1458b00 f6ff4b00 c1453000
c1453000 00000000
[  246.247349]  00000000 c12cd2cf c1051d9e 00000046 00000000 f6841ef8
f6841f30 00000001
[  246.256383] Call Trace:
[  246.257421]  [<c12cd2cf>] ? _raw_spin_unlock_irqrestore+0xf/0x30
[  246.258470]  [<c1051d9e>] ? try_to_wake_up+0x12e/0x180
[  246.259460]  [<c104ceb7>] ? __wake_up_common+0x47/0x70
[  246.260464]  [<c104d660>] ? complete+0x40/0x60
[  246.261451]  [<c10313e0>] ? __do_softirq+0x120/0x120
[  246.262455]  [<c1045062>] ? kthread+0x62/0x90
[  246.263454]  [<c1045000>] ? kthread_worker_fn+0xe0/0xe0
[  246.264473]  [<c12ce376>] ? kernel_thread_helper+0x6/0xd
[  366.247062] INFO: task migration/1:9 blocked for more than 120 seconds.
[  366.248147] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  366.249168] migration/1     D c12d5c20     0     9      2 0x00000000
[  366.253192]  f6858400 00000046 f6ff4b00 c12d5c20 07a19add 00000000
f6ff4b00 f6835c00
[  366.262139]  c1458b00 c1458b00 c1453000 c1458b00 f6ff4b00 c1453000
c1453000 00000000
[  366.271136]  00000000 c12cd2cf c1051d9e 00000046 00000000 f6841ef4
f6841f2c 00000001
[  366.281076] Call Trace:
[  366.283093]  [<c12cd2cf>] ? _raw_spin_unlock_irqrestore+0xf/0x30
[  366.284235]  [<c1051d9e>] ? try_to_wake_up+0x12e/0x180
[  366.285217]  [<c104ceb7>] ? __wake_up_common+0x47/0x70
[  366.287209]  [<c104d660>] ? complete+0x40/0x60
[  366.288204]  [<c10731f0>] ? ikconfig_read_current+0x30/0x30
[  366.290194]  [<c1045062>] ? kthread+0x62/0x90
[  366.291203]  [<c1045000>] ? kthread_worker_fn+0xe0/0xe0
[  366.292275]  [<c12ce376>] ? kernel_thread_helper+0x6/0xd
[  366.293215] INFO: task ksoftirqd/1:12 blocked for more than 120 seconds.
[  366.294236] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  366.295251] ksoftirqd/1     D c12d5c20     0    12      2 0x00000000
[  366.299142]  f6859000 00000046 f6ff4b00 c12d5c20 07c10940 00000000
f6ff4b00 f6835c00
[  366.308130]  c1458b00 c1458b00 c1453000 c1458b00 f6ff4b00 c1453000
c1453000 00000000
[  366.317133]  00000000 c12cd2cf c1051d9e 00000046 00000000 f6841ef8
f6841f30 00000001
[  366.326130] Call Trace:
[  366.327168]  [<c12cd2cf>] ? _raw_spin_unlock_irqrestore+0xf/0x30
[  366.328215]  [<c1051d9e>] ? try_to_wake_up+0x12e/0x180
[  366.330114]  [<c104ceb7>] ? __wake_up_common+0x47/0x70
[  366.331214]  [<c104d660>] ? complete+0x40/0x60
[  366.332213]  [<c10313e0>] ? __do_softirq+0x120/0x120
[  366.333212]  [<c1045062>] ? kthread+0x62/0x90
[  366.334218]  [<c1045000>] ? kthread_worker_fn+0xe0/0xe0
[  366.336158]  [<c12ce376>] ? kernel_thread_helper+0x6/0xd
[  486.318812] INFO: task migration/1:9 blocked for more than 120 seconds.
[  486.319900] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  486.320911] migration/1     D c12d5c20     0     9      2 0x00000000
[  486.324940]  f6858400 00000046 f6ff4b00 c12d5c20 07a19add 00000000
f6ff4b00 f6835c00
[  486.333884]  c1458b00 c1458b00 c1453000 c1458b00 f6ff4b00 c1453000
c1453000 00000000
[  486.342882]  00000000 c12cd2cf c1051d9e 00000046 00000000 f6841ef4
f6841f2c 00000001
[  486.354823] Call Trace:
[  486.356852]  [<c12cd2cf>] ? _raw_spin_unlock_irqrestore+0xf/0x30
[  486.357975]  [<c1051d9e>] ? try_to_wake_up+0x12e/0x180
[  486.358960]  [<c104ceb7>] ? __wake_up_common+0x47/0x70
[  486.360963]  [<c104d660>] ? complete+0x40/0x60
[  486.361962]  [<c10731f0>] ? ikconfig_read_current+0x30/0x30
[  486.362975]  [<c1045062>] ? kthread+0x62/0x90
[  486.363946]  [<c1045000>] ? kthread_worker_fn+0xe0/0xe0
[  486.364962]  [<c12ce376>] ? kernel_thread_helper+0x6/0xd
[  486.365956] INFO: task ksoftirqd/1:12 blocked for more than 120 seconds.
[  486.366967] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  486.367994] ksoftirqd/1     D c12d5c20     0    12      2 0x00000000
[  486.371828]  f6859000 00000046 f6ff4b00 c12d5c20 07c10940 00000000
f6ff4b00 f6835c00
[  486.380884]  c1458b00 c1458b00 c1453000 c1458b00 f6ff4b00 c1453000
c1453000 00000000
[  486.389876]  00000000 c12cd2cf c1051d9e 00000046 00000000 f6841ef8
f6841f30 00000001
[  486.398873] Call Trace:
[  486.399916]  [<c12cd2cf>] ? _raw_spin_unlock_irqrestore+0xf/0x30
[  486.400963]  [<c1051d9e>] ? try_to_wake_up+0x12e/0x180
[  486.402807]  [<c104ceb7>] ? __wake_up_common+0x47/0x70
[  486.403947]  [<c104d660>] ? complete+0x40/0x60
[  486.404999]  [<c10313e0>] ? __do_softirq+0x120/0x120
[  486.405951]  [<c1045062>] ? kthread+0x62/0x90
[  486.406946]  [<c1045000>] ? kthread_worker_fn+0xe0/0xe0
[  486.408819]  [<c12ce376>] ? kernel_thread_helper+0x6/0xd
[  606.391557] INFO: task migration/1:9 blocked for more than 120 seconds.
[  606.392644] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  606.393671] migration/1     D c12d5c20     0     9      2 0x00000000
[  606.397688]  f6858400 00000046 f6ff4b00 c12d5c20 07a19add 00000000
f6ff4b00 f6835c00
[  606.406633]  c1458b00 c1458b00 c1453000 c1458b00 f6ff4b00 c1453000
c1453000 00000000
[  606.415637]  00000000 c12cd2cf c1051d9e 00000046 00000000 f6841ef4
f6841f2c 00000001
[  606.427564] Call Trace:
[  606.429593]  [<c12cd2cf>] ? _raw_spin_unlock_irqrestore+0xf/0x30
[  606.430720]  [<c1051d9e>] ? try_to_wake_up+0x12e/0x180
[  606.431711]  [<c104ceb7>] ? __wake_up_common+0x47/0x70
[  606.432708]  [<c104d660>] ? complete+0x40/0x60
[  606.433696]  [<c10731f0>] ? ikconfig_read_current+0x30/0x30
[  606.434712]  [<c1045062>] ? kthread+0x62/0x90
[  606.435712]  [<c1045000>] ? kthread_worker_fn+0xe0/0xe0
[  606.436704]  [<c12ce376>] ? kernel_thread_helper+0x6/0xd
[  606.437705] INFO: task ksoftirqd/1:12 blocked for more than 120 seconds.
[  606.438721] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  606.439737] ksoftirqd/1     D c12d5c20     0    12      2 0x00000000
[  606.442659]  f6859000 00000046 f6ff4b00 c12d5c20 07c10940 00000000
f6ff4b00 f6835c00
[  606.452624]  c1458b00 c1458b00 c1453000 c1458b00 f6ff4b00 c1453000
c1453000 00000000
[  606.461622]  00000000 c12cd2cf c1051d9e 00000046 00000000 f6841ef8
f6841f30 00000001
[  606.471620] Call Trace:
[  606.473638]  [<c12cd2cf>] ? _raw_spin_unlock_irqrestore+0xf/0x30
[  606.474720]  [<c1051d9e>] ? try_to_wake_up+0x12e/0x180
[  606.475698]  [<c104ceb7>] ? __wake_up_common+0x47/0x70
[  606.476700]  [<c104d660>] ? complete+0x40/0x60
[  606.477691]  [<c10313e0>] ? __do_softirq+0x120/0x120
[  606.478700]  [<c1045062>] ? kthread+0x62/0x90
[  606.480673]  [<c1045000>] ? kthread_worker_fn+0xe0/0xe0
[  606.481712]  [<c12ce376>] ? kernel_thread_helper+0x6/0xd
[  726.464301] INFO: task migration/1:9 blocked for more than 120 seconds.
[  726.465386] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  726.466399] migration/1     D c12d5c20     0     9      2 0x00000000
[  726.470430]  f6858400 00000046 f6ff4b00 c12d5c20 07a19add 00000000
f6ff4b00 f6835c00
[  726.480378]  c1458b00 c1458b00 c1453000 c1458b00 f6ff4b00 c1453000
c1453000 00000000
[  726.490379]  00000000 c12cd2cf c1051d9e 00000046 00000000 f6841ef4
f6841f2c 00000001
[  726.499376] Call Trace:
[  726.500417]  [<c12cd2cf>] ? _raw_spin_unlock_irqrestore+0xf/0x30
[  726.502445]  [<c1051d9e>] ? try_to_wake_up+0x12e/0x180
[  726.503462]  [<c104ceb7>] ? __wake_up_common+0x47/0x70
[  726.504458]  [<c104d660>] ? complete+0x40/0x60
[  726.505441]  [<c10731f0>] ? ikconfig_read_current+0x30/0x30
[  726.506462]  [<c1045062>] ? kthread+0x62/0x90
[  726.508365]  [<c1045000>] ? kthread_worker_fn+0xe0/0xe0
[  726.509452]  [<c12ce376>] ? kernel_thread_helper+0x6/0xd
[  726.511444] INFO: task ksoftirqd/1:12 blocked for more than 120 seconds.
[  726.512473] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  726.513478] ksoftirqd/1     D c12d5c20     0    12      2 0x00000000
[  726.517366]  f6859000 00000046 f6ff4b00 c12d5c20 07c10940 00000000
f6ff4b00 f6835c00
[  726.527385]  c1458b00 c1458b00 c1453000 c1458b00 f6ff4b00 c1453000
c1453000 00000000
[  726.536380]  00000000 c12cd2cf c1051d9e 00000046 00000000 f6841ef8
f6841f30 00000001
[  726.545380] Call Trace:
[  726.546423]  [<c12cd2cf>] ? _raw_spin_unlock_irqrestore+0xf/0x30
[  726.547463]  [<c1051d9e>] ? try_to_wake_up+0x12e/0x180
[  726.549382]  [<c104ceb7>] ? __wake_up_common+0x47/0x70
[  726.550473]  [<c104d660>] ? complete+0x40/0x60
[  726.551458]  [<c10313e0>] ? __do_softirq+0x120/0x120
[  726.552452]  [<c1045062>] ? kthread+0x62/0x90
[  726.554445]  [<c1045000>] ? kthread_worker_fn+0xe0/0xe0
[  726.555456]  [<c12ce376>] ? kernel_thread_helper+0x6/0xd

thanks
--
Christian Gmeiner, MSc

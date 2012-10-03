Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965006Ab2JCSF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:05:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37108 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2JCSFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:05:51 -0400
Date: Wed, 3 Oct 2012 11:03:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        arekm@pld-linux.org, baggins@pld-linux.org
Subject: Re: [3.5.4] rcu_sched self-detected stall on CPU { 1}  (t=54862991
 jiffies)
Message-ID: <20121003180348.GM2527@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1377033.GMb6SBRYYa@pawels>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377033.GMb6SBRYYa@pawels>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100318-2876-0000-0000-000000B2EE29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 10:05:23AM +0200, Paweł Sikora wrote:
> Hi,
> 
> with the new stable line i'm observing strange locks on my old amd-phenom-II mini-server.
> here's a dmesg:

Hello, Paweł,

Does the combination of a10d206e (rcu: Fix day-one dyntick-idle
stall-warning bug) and c96ea7cf (rcu: Avoid spurious RCU CPU stall
warnings) get rid of these?  Both are now in mainline.

							Thanx, Paul

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.5.4 (pawels@hal) (gcc version 4.7.1 20120810 (release) (PLD-Linux) ) #5 SMP Mon Sep 17 09:18:01 CEST 2012
> [    0.000000] Command line: root=/dev/md0
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x00000000000983ff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000098400-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfd80fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000cfde0000-0x00000000cfde2fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000cfde3000-0x00000000cfdeffff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000cfdf0000-0x00000000cfdfffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000127ffffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.4 present.
> [    0.000000] DMI: Gigabyte Technology Co., Ltd. GA-MA785GMT-UD2H/GA-MA785GMT-UD2H, BIOS F5 11/30/2009
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x128000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-C7FFF write-protect
> [    0.000000]   C8000-FFFFF uncachable
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
> [    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
> [    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
> [    0.000000]   3 base 0000CFE00000 mask FFFFFFE00000 uncachable
> [    0.000000]   4 base 000100000000 mask FFFFE0000000 write-back
> [    0.000000]   5 base 000120000000 mask FFFFF8000000 write-back
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] TOM2: 0000000128000000 aka 4736M
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820: update [mem 0xcfe00000-0xffffffff] usable ==> reserved
> [    0.000000] e820: last_pfn = 0xcfd81 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000f59c0-0x000f59cf] mapped at [ffff8800000f59c0]
> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
> [    0.000000] Base memory trampoline at [ffff880000092000] 92000 size 24576
> [    0.000000] Using GB pages for direct mapping
> [    0.000000] init_memory_mapping: [mem 0x00000000-0xcfd80fff]
> [    0.000000]  [mem 0x00000000-0xbfffffff] page 1G
> [    0.000000]  [mem 0xc0000000-0xcfbfffff] page 2M
> [    0.000000]  [mem 0xcfc00000-0xcfd80fff] page 4k
> [    0.000000] kernel direct mapping tables up to 0xcfd80fff @ [mem 0x1f9fd000-0x1fffffff]
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x127ffffff]
> [    0.000000]  [mem 0x100000000-0x127ffffff] page 2M
> [    0.000000] kernel direct mapping tables up to 0x127ffffff @ [mem 0xcfd7f000-0xcfd80fff]
> [    0.000000] RAMDISK: [mem 0x37b24000-0x37feffff]
> [    0.000000] ACPI: RSDP 00000000000f7360 00014 (v00 GBT   )
> [    0.000000] ACPI: RSDT 00000000cfde3000 00034 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
> [    0.000000] ACPI: FACP 00000000cfde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
> [    0.000000] ACPI: DSDT 00000000cfde30c0 0747E (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
> [    0.000000] ACPI: FACS 00000000cfde0000 00040
> [    0.000000] ACPI: MCFG 00000000cfdea640 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
> [    0.000000] ACPI: TAMG 00000000cfdea680 0032A (v01 GBT    GBT   B0 5455312E BG?? 53450101)
> [    0.000000] ACPI: APIC 00000000cfdea540 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] Scanning NUMA topology in Northbridge 24
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000127ffffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x127ffffff]
> [    0.000000]   NODE_DATA [mem 0x127ffc000-0x127ffffff]
> [    0.000000]  [ffffea0000000000-ffffea00049fffff] PMD -> [ffff880123800000-ffff8801275fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x127ffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00010000-0x00097fff]
> [    0.000000]   node   0: [mem 0x00100000-0xcfd80fff]
> [    0.000000]   node   0: [mem 0x100000000-0x127ffffff]
> [    0.000000] On node 0 totalpages: 1015049
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 6 pages reserved
> [    0.000000]   DMA zone: 3906 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 16320 pages used for memmap
> [    0.000000]   DMA32 zone: 830913 pages, LIFO batch:31
> [    0.000000]   Normal zone: 2560 pages used for memmap
> [    0.000000]   Normal zone: 161280 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x4008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 0000000000098000 - 0000000000099000
> [    0.000000] PM: Registered nosave memory: 0000000000099000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 00000000cfd81000 - 00000000cfde0000
> [    0.000000] PM: Registered nosave memory: 00000000cfde0000 - 00000000cfde3000
> [    0.000000] PM: Registered nosave memory: 00000000cfde3000 - 00000000cfdf0000
> [    0.000000] PM: Registered nosave memory: 00000000cfdf0000 - 00000000cfe00000
> [    0.000000] PM: Registered nosave memory: 00000000cfe00000 - 00000000e0000000
> [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
> [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
> [    0.000000] e820: [mem 0xcfe00000-0xdfffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880127c00000 s82560 r8192 d23936 u524288
> [    0.000000] pcpu-alloc: s82560 r8192 d23936 u524288 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 996099
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: root=/dev/md0
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Node 0: aperture @ c4000000 size 32 MB
> [    0.000000] Aperture pointing to e820 RAM. Ignoring.
> [    0.000000] Your BIOS doesn't leave a aperture memory hole
> [    0.000000] Please enable the IOMMU option in the BIOS setup
> [    0.000000] This costs you 64 MB of RAM
> [    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
> [    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
> [    0.000000] Memory: 3849032k/4849664k available (4740k kernel code, 789468k absent, 211164k reserved, 4015k data, 620k init)
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] NR_IRQS:4352 nr_irqs:712 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 16252928 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] Fast TSC calibration using PIT
> [    0.003333] Detected 3214.401 MHz processor.
> [    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 6431.66 BogoMIPS (lpj=10714670)
> [    0.000063] pid_max: default: 32768 minimum: 301
> [    0.000109] Security Framework initialized
> [    0.000142] AppArmor: AppArmor disabled by boot time parameter
> [    0.000372] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.001451] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.001947] Mount-cache hash table entries: 256
> [    0.002113] Initializing cgroup subsys cpuacct
> [    0.002143] Initializing cgroup subsys memory
> [    0.002178] Initializing cgroup subsys devices
> [    0.002208] Initializing cgroup subsys freezer
> [    0.002238] Initializing cgroup subsys net_cls
> [    0.002267] Initializing cgroup subsys blkio
> [    0.002297] Initializing cgroup subsys perf_event
> [    0.002343] tseg: 00cfe00000
> [    0.002344] CPU: Physical Processor ID: 0
> [    0.002374] CPU: Processor Core ID: 0
> [    0.002403] mce: CPU supports 6 MCE banks
> [    0.002448] LVT offset 0 assigned for vector 0xf9
> [    0.002480] using AMD E400 aware idle routine
> [    0.003093] ACPI: Core revision 20120320
> [    0.015633] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.048612] CPU0: AMD Phenom(tm) II X2 555 Processor stepping 03
> [    0.152168] Performance Events: AMD PMU driver.
> [    0.152224] ... version:                0
> [    0.152253] ... bit width:              48
> [    0.152282] ... generic registers:      4
> [    0.152311] ... value mask:             0000ffffffffffff
> [    0.152341] ... max period:             00007fffffffffff
> [    0.152370] ... fixed-purpose events:   0
> [    0.152399] ... event mask:             000000000000000f
> [    0.152520] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.152606] Booting Node   0, Processors  #1
> [    0.165772] Brought up 2 CPUs
> [    0.165788] System has AMD C1E enabled
> [    0.165802] Switch to broadcast mode on CPU1
> [    0.165894] Total of 2 processors activated (12862.33 BogoMIPS).
> [    0.168174] Switch to broadcast mode on CPU0
> [    0.168320] devtmpfs: initialized
> [    0.169516] PM: Registering ACPI NVS region [mem 0xcfde0000-0xcfde2fff] (12288 bytes)
> [    0.169617] dummy: 
> [    0.169680] NET: Registered protocol family 16
> [    0.169772] node 0 link 0: io port [c000, ffff]
> [    0.169775] TOM: 00000000d8000000 aka 3456M
> [    0.169805] Fam 10h mmconf [mem 0xe0000000-0xe00fffff]
> [    0.169806] node 0 link 0: mmio [a0000, bffff]
> [    0.169808] node 0 link 0: mmio [d8000000, dfffffff]
> [    0.169810] node 0 link 0: mmio [f0000000, fe02ffff]
> [    0.169811] node 0 link 0: mmio [e0000000, e03fffff] ==> [e0100000, e03fffff]
> [    0.169813] TOM2: 0000000128000000 aka 4736M
> [    0.169843] bus: [00, 03] on node 0 link 0
> [    0.169844] bus: 00 [io  0x0000-0xffff]
> [    0.169846] bus: 00 [mem 0x000a0000-0x000bffff]
> [    0.169847] bus: 00 [mem 0xd8000000-0xdfffffff]
> [    0.169847] bus: 00 [mem 0xe0400000-0xffffffff]
> [    0.169848] bus: 00 [mem 0xe0100000-0xe03fffff]
> [    0.169849] bus: 00 [mem 0x128000000-0xfcffffffff]
> [    0.169881] ACPI: bus type pci registered
> [    0.169949] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.169982] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
> [    0.179052] PCI: Using configuration type 1 for base access
> [    0.179534] bio: create slab <bio-0> at 0
> [    0.179629] ACPI: Added _OSI(Module Device)
> [    0.179660] ACPI: Added _OSI(Processor Device)
> [    0.179690] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.179719] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.180172] ACPI: EC: Look up EC in DSDT
> [    0.182774] ACPI: Interpreter enabled
> [    0.182807] ACPI: (supports S0 S3 S4 S5)
> [    0.182951] ACPI: Using IOAPIC for interrupt routing
> [    0.185321] ACPI: No dock devices found.
> [    0.185354] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.185426] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.185509] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
> [    0.185540] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
> [    0.185571] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
> [    0.185603] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
> [    0.185636] pci_root PNP0A03:00: host bridge window [mem 0xd7f00000-0xfebfffff]
> [    0.185690] PCI host bridge to bus 0000:00
> [    0.186190] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.186220] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.186251] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.186281] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
> [    0.186312] pci_bus 0000:00: root bus resource [mem 0xd7f00000-0xfebfffff]
> [    0.186350] pci 0000:00:00.0: [1022:9601] type 00 class 0x060000
> [    0.186360] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
> [    0.186393] pci 0000:00:01.0: [1022:9602] type 01 class 0x060400
> [    0.186430] pci 0000:00:0a.0: [1022:9609] type 01 class 0x060400
> [    0.186458] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
> [    0.186482] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
> [    0.186500] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
> [    0.186509] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
> [    0.186517] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
> [    0.186526] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
> [    0.186535] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
> [    0.186544] pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
> [    0.186597] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
> [    0.186609] pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
> [    0.186670] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
> [    0.186682] pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
> [    0.186749] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
> [    0.186766] pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
> [    0.186844] pci 0000:00:12.2: supports D1 D2
> [    0.186845] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
> [    0.186867] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
> [    0.186879] pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
> [    0.186939] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
> [    0.186951] pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
> [    0.187017] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
> [    0.187034] pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
> [    0.187112] pci 0000:00:13.2: supports D1 D2
> [    0.187113] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
> [    0.187137] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
> [    0.187231] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
> [    0.187246] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
> [    0.187255] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
> [    0.187263] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
> [    0.187272] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
> [    0.187280] pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
> [    0.187333] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
> [    0.187404] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
> [    0.187444] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
> [    0.187457] pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
> [    0.187520] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
> [    0.187532] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
> [    0.187541] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
> [    0.187551] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
> [    0.187563] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
> [    0.187599] pci 0000:01:05.0: [1002:9710] type 00 class 0x030000
> [    0.187605] pci 0000:01:05.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
> [    0.187609] pci 0000:01:05.0: reg 14: [io  0xee00-0xeeff]
> [    0.187612] pci 0000:01:05.0: reg 18: [mem 0xfdef0000-0xfdefffff]
> [    0.187620] pci 0000:01:05.0: reg 24: [mem 0xfdd00000-0xfddfffff]
> [    0.187634] pci 0000:01:05.0: supports D1 D2
> [    0.187669] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    0.187700] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
> [    0.187702] pci 0000:00:01.0:   bridge window [mem 0xfdd00000-0xfdefffff]
> [    0.187705] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
> [    0.187735] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
> [    0.187747] pci 0000:02:00.0: reg 10: [io  0xde00-0xdeff]
> [    0.187765] pci 0000:02:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
> [    0.187778] pci 0000:02:00.0: reg 20: [mem 0xfdfe0000-0xfdfeffff 64bit pref]
> [    0.187786] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
> [    0.187829] pci 0000:02:00.0: supports D1 D2
> [    0.187831] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.195844] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
> [    0.195879] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
> [    0.195881] pci 0000:00:0a.0:   bridge window [mem 0xfda00000-0xfdafffff]
> [    0.195884] pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
> [    0.195943] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
> [    0.195976] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
> [    0.195980] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff]
> [    0.195983] pci 0000:00:14.4:   bridge window [mem 0xfdb00000-0xfdbfffff pref]
> [    0.195985] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> [    0.195986] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> [    0.195987] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    0.195989] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
> [    0.195990] pci 0000:00:14.4:   bridge window [mem 0xd7f00000-0xfebfffff] (subtractive decode)
> [    0.196002] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.196143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
> [    0.196182] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
> [    0.196200] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
> [    0.196219]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    0.196251]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
> [    0.196283] ACPI _OSC control for PCIe not granted, disabling ASPM
> [    0.204466] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.204810] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.205152] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.205492] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.205833] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.206171] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.206508] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.206846] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> [    0.207240] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.207273] vgaarb: loaded
> [    0.207301] vgaarb: bridge control possible 0000:01:05.0
> [    0.207378] PCI: Using ACPI for IRQ routing
> [    0.215682] PCI: pci_cache_line_size set to 64 bytes
> [    0.215688] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
> [    0.215773] e820: reserve RAM buffer [mem 0x00098400-0x0009ffff]
> [    0.215774] e820: reserve RAM buffer [mem 0xcfd81000-0xcfffffff]
> [    0.215837] NetLabel: Initializing
> [    0.215866] NetLabel:  domain hash size = 128
> [    0.215895] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.215932] NetLabel:  unlabeled traffic allowed by default
> [    0.216984] pnp: PnP ACPI init
> [    0.217021] ACPI: bus type pnp registered
> [    0.217111] pnp 00:00: [bus 00-ff]
> [    0.217113] pnp 00:00: [io  0x0cf8-0x0cff]
> [    0.217114] pnp 00:00: [io  0x0000-0x0cf7 window]
> [    0.217115] pnp 00:00: [io  0x0d00-0xffff window]
> [    0.217117] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    0.217118] pnp 00:00: [mem 0x000c0000-0x000dffff window]
> [    0.217120] pnp 00:00: [mem 0xd7f00000-0xfebfffff window]
> [    0.217144] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
> [    0.217150] pnp 00:01: [io  0x0010-0x001f]
> [    0.217151] pnp 00:01: [io  0x0022-0x003f]
> [    0.217153] pnp 00:01: [io  0x0044-0x005f]
> [    0.217154] pnp 00:01: [io  0x0062-0x0063]
> [    0.217155] pnp 00:01: [io  0x0065-0x006f]
> [    0.217156] pnp 00:01: [io  0x0074-0x007f]
> [    0.217157] pnp 00:01: [io  0x0091-0x0093]
> [    0.217158] pnp 00:01: [io  0x00a2-0x00bf]
> [    0.217160] pnp 00:01: [io  0x00e0-0x00ef]
> [    0.217161] pnp 00:01: [io  0x04d0-0x04d1]
> [    0.217162] pnp 00:01: [io  0x0220-0x0225]
> [    0.217164] pnp 00:01: [io  0x0290-0x0294]
> [    0.217193] system 00:01: [io  0x04d0-0x04d1] has been reserved
> [    0.217224] system 00:01: [io  0x0220-0x0225] has been reserved
> [    0.217255] system 00:01: [io  0x0290-0x0294] has been reserved
> [    0.217286] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.217552] pnp 00:02: [io  0x4100-0x411f]
> [    0.217553] pnp 00:02: [io  0x0228-0x022f]
> [    0.217554] pnp 00:02: [io  0x040b]
> [    0.217556] pnp 00:02: [io  0x04d6]
> [    0.217557] pnp 00:02: [io  0x0c00-0x0c01]
> [    0.217558] pnp 00:02: [io  0x0c14]
> [    0.217559] pnp 00:02: [io  0x0c50-0x0c52]
> [    0.217560] pnp 00:02: [io  0x0c6c-0x0c6d]
> [    0.217561] pnp 00:02: [io  0x0c6f]
> [    0.217562] pnp 00:02: [io  0x0cd0-0x0cd1]
> [    0.217564] pnp 00:02: [io  0x0cd2-0x0cd3]
> [    0.217565] pnp 00:02: [io  0x0cd4-0x0cdf]
> [    0.217566] pnp 00:02: [io  0x4000-0x40fe]
> [    0.217567] pnp 00:02: [io  0x4210-0x4217]
> [    0.217568] pnp 00:02: [io  0x0b00-0x0b0f]
> [    0.217569] pnp 00:02: [io  0x0b10-0x0b1f]
> [    0.217571] pnp 00:02: [io  0x0b20-0x0b3f]
> [    0.217572] pnp 00:02: [mem 0x00000000-0x00000fff window]
> [    0.217573] pnp 00:02: [mem 0xfee00400-0xfee00fff window]
> [    0.217577] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
> [    0.217628] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
> [    0.217679] system 00:02: [io  0x4100-0x411f] has been reserved
> [    0.217711] system 00:02: [io  0x0228-0x022f] has been reserved
> [    0.217741] system 00:02: [io  0x040b] has been reserved
> [    0.217772] system 00:02: [io  0x04d6] has been reserved
> [    0.217803] system 00:02: [io  0x0c00-0x0c01] has been reserved
> [    0.217833] system 00:02: [io  0x0c14] has been reserved
> [    0.217864] system 00:02: [io  0x0c50-0x0c52] has been reserved
> [    0.217895] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
> [    0.217926] system 00:02: [io  0x0c6f] has been reserved
> [    0.217957] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
> [    0.217988] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
> [    0.218019] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
> [    0.218050] system 00:02: [io  0x4000-0x40fe] has been reserved
> [    0.218081] system 00:02: [io  0x4210-0x4217] has been reserved
> [    0.218112] system 00:02: [io  0x0b00-0x0b0f] has been reserved
> [    0.218143] system 00:02: [io  0x0b10-0x0b1f] has been reserved
> [    0.218174] system 00:02: [io  0x0b20-0x0b3f] has been reserved
> [    0.218205] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
> [    0.218239] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.218302] pnp 00:03: [dma 4]
> [    0.218304] pnp 00:03: [io  0x0000-0x000f]
> [    0.218305] pnp 00:03: [io  0x0080-0x0090]
> [    0.218306] pnp 00:03: [io  0x0094-0x009f]
> [    0.218307] pnp 00:03: [io  0x00c0-0x00df]
> [    0.218324] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.218354] pnp 00:04: [io  0x0070-0x0073]
> [    0.218366] pnp 00:04: [irq 8]
> [    0.218381] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.218385] pnp 00:05: [io  0x0061]
> [    0.218399] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.218405] pnp 00:06: [io  0x00f0-0x00ff]
> [    0.218412] pnp 00:06: [irq 13]
> [    0.218428] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.218666] pnp 00:07: [io  0x0060]
> [    0.218667] pnp 00:07: [io  0x0064]
> [    0.218674] pnp 00:07: [irq 1]
> [    0.218696] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.218713] pnp 00:08: [mem 0xe0000000-0xefffffff]
> [    0.218741] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.218773] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.218860] pnp 00:09: [mem 0x000d4400-0x000d7fff]
> [    0.218862] pnp 00:09: [mem 0x000f0000-0x000f7fff]
> [    0.218863] pnp 00:09: [mem 0x000f8000-0x000fbfff]
> [    0.218864] pnp 00:09: [mem 0x000fc000-0x000fffff]
> [    0.218866] pnp 00:09: [mem 0xcfde0000-0xcfdfffff]
> [    0.218867] pnp 00:09: [mem 0xffff0000-0xffffffff]
> [    0.218868] pnp 00:09: [mem 0x00000000-0x0009ffff]
> [    0.218869] pnp 00:09: [mem 0x00100000-0xcfddffff]
> [    0.218872] pnp 00:09: [mem 0xcfef0000-0xd7eeffff]
> [    0.218873] pnp 00:09: [mem 0xfec00000-0xfec00fff]
> [    0.218874] pnp 00:09: [mem 0xfee00000-0xfee00fff]
> [    0.218875] pnp 00:09: [mem 0xfff80000-0xfffeffff]
> [    0.218878] pnp 00:09: disabling [mem 0x000d4400-0x000d7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
> [    0.218914] pnp 00:09: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
> [    0.218949] pnp 00:09: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
> [    0.218984] pnp 00:09: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
> [    0.219019] pnp 00:09: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
> [    0.219066] pnp 00:09: disabling [mem 0x00100000-0xcfddffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
> [    0.219131] system 00:09: [mem 0xcfde0000-0xcfdfffff] could not be reserved
> [    0.219163] system 00:09: [mem 0xffff0000-0xffffffff] has been reserved
> [    0.219194] system 00:09: [mem 0xcfef0000-0xd7eeffff] could not be reserved
> [    0.219226] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
> [    0.219257] system 00:09: [mem 0xfee00000-0xfee00fff] could not be reserved
> [    0.219289] system 00:09: [mem 0xfff80000-0xfffeffff] has been reserved
> [    0.219320] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.219333] pnp: PnP ACPI: found 10 devices
> [    0.219363] ACPI: ACPI bus type pnp unregistered
> [    0.225024] Switching to clocksource acpi_pm
> [    0.225093] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    0.225125] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
> [    0.225156] pci 0000:00:01.0:   bridge window [mem 0xfdd00000-0xfdefffff]
> [    0.225188] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
> [    0.225223] pci 0000:02:00.0: BAR 6: assigned [mem 0xfdf00000-0xfdf0ffff pref]
> [    0.225256] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
> [    0.225286] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
> [    0.225318] pci 0000:00:0a.0:   bridge window [mem 0xfda00000-0xfdafffff]
> [    0.225349] pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
> [    0.225383] pci 0000:00:14.4: PCI bridge to [bus 03-03]
> [    0.225414] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
> [    0.225448] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff]
> [    0.225480] pci 0000:00:14.4:   bridge window [mem 0xfdb00000-0xfdbfffff pref]
> [    0.225535] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.225537] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.225538] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.225540] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
> [    0.225541] pci_bus 0000:00: resource 8 [mem 0xd7f00000-0xfebfffff]
> [    0.225543] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
> [    0.225544] pci_bus 0000:01: resource 1 [mem 0xfdd00000-0xfdefffff]
> [    0.225546] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff 64bit pref]
> [    0.225547] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
> [    0.225548] pci_bus 0000:02: resource 1 [mem 0xfda00000-0xfdafffff]
> [    0.225550] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
> [    0.225551] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
> [    0.225553] pci_bus 0000:03: resource 1 [mem 0xfdc00000-0xfdcfffff]
> [    0.225554] pci_bus 0000:03: resource 2 [mem 0xfdb00000-0xfdbfffff pref]
> [    0.225556] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
> [    0.225557] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
> [    0.225558] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.225560] pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000dffff]
> [    0.225561] pci_bus 0000:03: resource 8 [mem 0xd7f00000-0xfebfffff]
> [    0.225585] NET: Registered protocol family 2
> [    0.225689] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.226331] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> [    0.228300] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.228596] TCP: Hash tables configured (established 524288 bind 65536)
> [    0.228627] TCP: reno registered
> [    0.228664] UDP hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.228715] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.228812] NET: Registered protocol family 1
> [    0.228850] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
> [    0.611213] pci 0000:01:05.0: Boot video device
> [    0.611219] PCI: CLS 4 bytes, default 64
> [    0.611254] Trying to unpack rootfs image as initramfs...
> [    0.676677] Freeing initrd memory: 4912k freed
> [    0.678813] PCI-DMA: Disabling AGP.
> [    0.678906] PCI-DMA: aperture base @ c4000000 size 65536 KB
> [    0.678935] PCI-DMA: using GART IOMMU.
> [    0.678966] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> [    0.681974] LVT offset 1 assigned for vector 0x400
> [    0.682012] IBS: LVT offset 1 assigned
> [    0.682059] perf: AMD IBS detected (0x0000001f)
> [    0.682197] audit: initializing netlink socket (disabled)
> [    0.682235] type=2000 audit(1348242257.570:1): initialized
> [    0.695375] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.696830] VFS: Disk quotas dquot_6.5.2
> [    0.696895] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.696988] ROMFS MTD (C) 2007 Red Hat, Inc.
> [    0.697036] msgmni has been set to 7656
> [    0.697392] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.697454] io scheduler noop registered
> [    0.697486] io scheduler deadline registered
> [    0.697533] io scheduler cfq registered (default)
> [    0.697563] start plist test
> [    0.698643] end plist test
> [    0.698843] pcieport 0000:00:0a.0: irq 40 for MSI/MSI-X
> [    0.698940] GHES: HEST is not enabled!
> [    0.711346] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.711697] Linux agpgart interface v0.103
> [    0.712834] brd: module loaded
> [    0.712890] Fixed MDIO Bus: probed
> [    0.712939] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [    0.712970] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
> [    0.713121] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.713232] mousedev: PS/2 mouse device common for all mice
> [    0.713301] rtc_cmos 00:04: RTC can wake from S4
> [    0.713440] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
> [    0.713495] rtc0: alarms up to one month, 242 bytes nvram
> [    0.713528] cpuidle: using governor ladder
> [    0.713558] cpuidle: using governor menu
> [    0.713687] drop_monitor: Initializing network drop monitor service
> [    0.713765] TCP: cubic registered
> [    0.713857] NET: Registered protocol family 10
> [    0.714011] mip6: Mobile IPv6
> [    0.714041] NET: Registered protocol family 17
> [    0.714080] Key type dns_resolver registered
> [    0.714251] registered taskstats version 1
> [    0.714712] rtc_cmos 00:04: setting system clock to 2012-09-21 15:44:18 UTC (1348242258)
> [    0.715503] Freeing unused kernel memory: 620k freed
> [    0.715647] Write protecting the kernel read-only data: 8192k
> [    0.718750] Freeing unused kernel memory: 1392k freed
> [    0.719640] Freeing unused kernel memory: 248k freed
> [    0.721801] SCSI subsystem initialized
> [    0.722715] libata version 3.00 loaded.
> [    0.723475] ahci 0000:00:11.0: version 3.0
> [    0.723583] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
> [    0.723619] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
> [    0.724023] scsi0 : ahci
> [    0.724107] scsi1 : ahci
> [    0.724181] scsi2 : ahci
> [    0.724279] scsi3 : ahci
> [    0.724377] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
> [    0.724875] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
> [    0.724909] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
> [    0.724942] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
> [    0.736941] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    1.210153] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.210219] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.210279] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.210337] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.216354] ata1.00: ATA-8: SAMSUNG HD204UI, 1AQ10001, max UDMA/133
> [    1.216392] ata1.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
> [    1.216493] ata2.00: ATA-8: SAMSUNG HD204UI, 1AQ10001, max UDMA/133
> [    1.216529] ata2.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
> [    1.216713] ata4.00: ATA-7: SAMSUNG HD103SI, 1AG01118, max UDMA7
> [    1.216747] ata4.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
> [    1.216790] ata3.00: ATA-7: SAMSUNG HD103SI, 1AG01118, max UDMA7
> [    1.216823] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
> [    1.222647] ata1.00: configured for UDMA/133
> [    1.222737] ata2.00: configured for UDMA/133
> [    1.222758] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD204UI  1AQ1 PQ: 0 ANSI: 5
> [    1.222924] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD204UI  1AQ1 PQ: 0 ANSI: 5
> [    1.223267] ata4.00: configured for UDMA/133
> [    1.223313] ata3.00: configured for UDMA/133
> [    1.223404] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD103SI  1AG0 PQ: 0 ANSI: 5
> [    1.223566] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD103SI  1AG0 PQ: 0 ANSI: 5
> [    1.226413] md: raid1 personality registered for level 1
> [    1.227149] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> [    1.227163] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> [    1.227186] sd 1:0:0:0: [sdb] Write Protect is off
> [    1.227187] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.227198] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.227302] sd 0:0:0:0: [sda] Write Protect is off
> [    1.227334] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.227346] sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> [    1.227348] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.227440] sd 2:0:0:0: [sdc] Write Protect is off
> [    1.227474] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    1.227495] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.227568] sd 3:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> [    1.227623] sd 3:0:0:0: [sdd] Write Protect is off
> [    1.227654] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> [    1.227663] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.229276] systemd-udevd[104]: starting version 187
> [    1.231902]  sdd: sdd1
> [    1.232081] sd 3:0:0:0: [sdd] Attached SCSI disk
> [    1.237547]  sdc: sdc1
> [    1.238961] sd 2:0:0:0: [sdc] Attached SCSI disk
> [    1.241108]  sdb: sdb1 sdb2 sdb3
> [    1.244892] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    1.245963]  sda: sda1 sda2 sda3
> [    1.251881] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.546258] md: md0 stopped.
> [    1.548693] md: bind<sdb1>
> [    1.548856] md: bind<sda1>
> [    1.548950] bio: create slab <bio-1> at 1
> [    1.549011] md/raid1:md0: active with 2 out of 2 mirrors
> [    1.549164] md0: detected capacity change from 0 to 8192262144
> [    1.557140]  md0: unknown partition table
> [    1.569944] kjournald starting.  Commit interval 5 seconds
> [    1.569970] EXT3-fs (md0): mounted filesystem with writeback data mode
> [    1.682581] Refined TSC clocksource calibration: 3214.524 MHz.
> [    1.682618] Switching to clocksource tsc
> [    3.082555] systemd-udevd[492]: starting version 187
> [    3.359727] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    3.359732] ACPI: Power Button [PWRB]
> [    3.359774] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    3.359776] ACPI: Power Button [PWRF]
> [    3.369687] microcode: CPU0: patch_level=0x010000af
> [    3.428697] MCE: In-kernel MCE decoding enabled.
> [    3.451466] EDAC MC: Ver: 2.1.0
> [    3.508000] AMD64 EDAC driver v3.4.0
> [    3.508066] EDAC amd64: DRAM ECC disabled.
> [    3.508071] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
> [    3.508071]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
> [    3.508071]  (Note that use of the override may cause unknown side effects.)
> [    3.534189] Uniform Multi-Platform E-IDE driver
> [    3.542484] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
> [    3.542502] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
> [    3.542506]     ide0: BM-DMA at 0xfa00-0xfa07
> [    3.542515]     ide1: BM-DMA at 0xfa08-0xfa0f
> [    3.542518] Probing IDE interface ide0...
> [    3.596389] wmi: Mapper loaded
> [    3.627908] kvm: Nested Virtualization enabled
> [    3.627911] kvm: Nested Paging enabled
> [    3.706224] ACPI: processor limited to max C-state 1
> [    3.756976] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    3.757046] r8169 0000:02:00.0: irq 41 for MSI/MSI-X
> [    3.757167] r8169 0000:02:00.0: eth0: RTL8168c/8111c at 0xffffc9000064e000, 6c:f0:49:07:87:17, XID 1c4000c0 IRQ 41
> [    3.757169] r8169 0000:02:00.0: eth0: jumbo features [frames: 6128 bytes, tx checksumming: ko]
> [    3.767264] microcode: failed to load file amd-ucode/microcode_amd.bin
> [    3.767279] microcode: CPU1: patch_level=0x010000af
> [    3.767634] microcode: failed to load file amd-ucode/microcode_amd.bin
> [    3.767663] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    3.809482] input: PC Speaker as /devices/platform/pcspkr/input/input3
> [    3.846131] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    3.893903] ACPI: bus type usb registered
> [    3.893926] usbcore: registered new interface driver usbfs
> [    3.893933] usbcore: registered new interface driver hub
> [    3.894317] usbcore: registered new device driver usb
> [    3.923577] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    3.940615] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    3.985941] powernow-k8: Found 1 AMD Phenom(tm) II X2 555 Processor (2 cpu cores) (version 2.20.00)
> [    3.985949] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
> [    3.985949] [Firmware Bug]: powernow-k8: Try again with latest BIOS.
> [    4.081738] Probing IDE interface ide1...
> [    4.620897] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    4.620932] ide1 at 0x170-0x177,0x376 on irq 15
> [    4.621411] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [    4.621618] ehci_hcd 0000:00:12.2: EHCI Host Controller
> [    4.621816] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
> [    4.621824] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
> [    4.621846] ehci_hcd 0000:00:12.2: debug port 1
> [    4.621869] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
> [    4.630835] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
> [    4.630852] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    4.630853] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.630855] usb usb1: Product: EHCI Host Controller
> [    4.630856] usb usb1: Manufacturer: Linux 3.5.4 ehci_hcd
> [    4.630857] usb usb1: SerialNumber: 0000:00:12.2
> [    4.630937] hub 1-0:1.0: USB hub found
> [    4.630940] hub 1-0:1.0: 6 ports detected
> [    4.631032] ehci_hcd 0000:00:13.2: EHCI Host Controller
> [    4.631036] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
> [    4.631043] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
> [    4.631060] ehci_hcd 0000:00:13.2: debug port 1
> [    4.631082] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
> [    4.640811] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
> [    4.640825] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    4.640827] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.640828] usb usb2: Product: EHCI Host Controller
> [    4.640829] usb usb2: Manufacturer: Linux 3.5.4 ehci_hcd
> [    4.640830] usb usb2: SerialNumber: 0000:00:13.2
> [    4.640905] hub 2-0:1.0: USB hub found
> [    4.640908] hub 2-0:1.0: 6 ports detected
> [    4.641058] ohci_hcd 0000:00:12.0: OHCI Host Controller
> [    4.641064] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
> [    4.641088] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
> [    4.696046] [drm] Initialized drm 1.1.0 20060810
> [    4.697996] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.697999] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.698000] usb usb3: Product: OHCI Host Controller
> [    4.698001] usb usb3: Manufacturer: Linux 3.5.4 ohci_hcd
> [    4.698003] usb usb3: SerialNumber: 0000:00:12.0
> [    4.698089] hub 3-0:1.0: USB hub found
> [    4.698094] hub 3-0:1.0: 3 ports detected
> [    4.698189] ohci_hcd 0000:00:12.1: OHCI Host Controller
> [    4.698195] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
> [    4.698209] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
> [    4.754563] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.754565] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.754567] usb usb4: Product: OHCI Host Controller
> [    4.754568] usb usb4: Manufacturer: Linux 3.5.4 ohci_hcd
> [    4.754569] usb usb4: SerialNumber: 0000:00:12.1
> [    4.754643] hub 4-0:1.0: USB hub found
> [    4.754648] hub 4-0:1.0: 3 ports detected
> [    4.754734] ohci_hcd 0000:00:13.0: OHCI Host Controller
> [    4.754738] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
> [    4.754764] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
> [    4.795200] [drm] radeon defaulting to kernel modesetting.
> [    4.795203] [drm] radeon kernel modesetting enabled.
> [    4.795421] [drm] initializing kernel modesetting (RS880 0x1002:0x9710 0x1458:0xD000).
> [    4.795437] [drm] register mmio base: 0xFDEF0000
> [    4.795438] [drm] register mmio size: 65536
> [    4.795705] ATOM BIOS: B43106_DVI
> [    4.795721] radeon 0000:01:05.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
> [    4.795723] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
> [    4.797878] [drm] Detected VRAM RAM=128M, BAR=128M
> [    4.797882] [drm] RAM width 32bits DDR
> [    4.797931] [TTM] Zone  kernel: Available graphics memory: 1961078 kiB
> [    4.797931] [TTM] Initializing pool allocator
> [    4.797935] [TTM] Initializing DMA pool allocator
> [    4.797955] [drm] radeon: 128M of VRAM memory ready
> [    4.797955] [drm] radeon: 512M of GTT memory ready.
> [    4.797966] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    4.797967] [drm] Driver supports precise vblank timestamp query.
> [    4.797981] [drm] radeon: irq initialized.
> [    4.797984] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [    4.798548] [drm] Loading RS780 Microcode
> [    4.811209] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.811212] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.811213] usb usb5: Product: OHCI Host Controller
> [    4.811215] usb usb5: Manufacturer: Linux 3.5.4 ohci_hcd
> [    4.811216] usb usb5: SerialNumber: 0000:00:13.0
> [    4.811320] hub 5-0:1.0: USB hub found
> [    4.811326] hub 5-0:1.0: 3 ports detected
> [    4.811752] ohci_hcd 0000:00:13.1: OHCI Host Controller
> [    4.811758] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
> [    4.811773] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
> [    4.867776] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.867778] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.867780] usb usb6: Product: OHCI Host Controller
> [    4.867781] usb usb6: Manufacturer: Linux 3.5.4 ohci_hcd
> [    4.867782] usb usb6: SerialNumber: 0000:00:13.1
> [    4.867869] hub 6-0:1.0: USB hub found
> [    4.867874] hub 6-0:1.0: 3 ports detected
> [    4.867972] ohci_hcd 0000:00:14.5: OHCI Host Controller
> [    4.867978] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
> [    4.867990] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
> [    4.878238] [drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
> [    4.878271] radeon 0000:01:05.0: WB enabled
> [    4.878273] radeon 0000:01:05.0: fence driver on ring 0 use gpu addr 0x00000000a0000c00 and cpu addr 0xffff88011fa87c00
> [    4.878327] radeon 0000:01:05.0: setting latency timer to 64
> [    4.909476] [drm] ring test on 0 succeeded in 1 usecs
> [    4.909565] [drm] ib test on ring 0 succeeded in 0 usecs
> [    4.909688] [drm] Radeon Display Connectors
> [    4.909689] [drm] Connector 0:
> [    4.909690] [drm]   VGA-1
> [    4.909692] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
> [    4.909692] [drm]   Encoders:
> [    4.909693] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> [    4.909694] [drm] Connector 1:
> [    4.909695] [drm]   DVI-D-1
> [    4.909695] [drm]   HPD1
> [    4.909696] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
> [    4.909697] [drm]   Encoders:
> [    4.909697] [drm]     DFP1: INTERNAL_KLDSCP_LVTMA
> [    4.909713] [drm] radeon: power management initialized
> [    4.946178] [drm] fb mappable at 0xD8142000
> [    4.946179] [drm] vram apper at 0xD8000000
> [    4.946180] [drm] size 5242880
> [    4.946181] [drm] fb depth is 24
> [    4.946182] [drm]    pitch is 5120
> [    4.946203] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.946205] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.946206] usb usb7: Product: OHCI Host Controller
> [    4.946208] usb usb7: Manufacturer: Linux 3.5.4 ohci_hcd
> [    4.946209] usb usb7: SerialNumber: 0000:00:14.5
> [    4.946230] fbcon: radeondrmfb (fb0) is primary device
> [    4.947046] hub 7-0:1.0: USB hub found
> [    4.947051] hub 7-0:1.0: 2 ports detected
> [    4.947550] ACPI Warning: 0x0000000000000b00-0x0000000000000b07 SystemIO conflicts with Region \SOR1 1 (20120320/utaddress-251)
> [    4.947553] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    4.964182] Console: switching to colour frame buffer device 160x64
> [    4.967985] fb0: radeondrmfb frame buffer device
> [    4.967986] drm: registered panic notifier
> [    4.968006] [drm] Initialized radeon 2.18.0 20080528 for 0000:01:05.0 on minor 0
> [    4.986149] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
> [    4.986219] sp5100_tco: mmio address 0xfec000f0 already in use
> [    5.330312] Adding 996024k swap on /dev/sda2.  Priority:0 extents:1 across:996024k 
> [    5.331259] Adding 996024k swap on /dev/sdb2.  Priority:0 extents:1 across:996024k 
> [    5.576689] EXT3-fs (md0): using internal journal
> [    5.871365] md: md1 stopped.
> [    5.872026] md: bind<sdb3>
> [    5.872136] md: bind<sda3>
> [    5.917283] md: raid0 personality registered for level 0
> [    5.917386] md/raid0:md1: md_size is 7778068480 sectors.
> [    5.917387] md: RAID0 configuration for md1 - 1 zone
> [    5.917388] md: zone0=[sda3/sdb3]
> [    5.917390]       zone-offset=         0KB, device-offset=         0KB, size=3889034240KB
> [    5.917391] 
> [    5.917397] md1: detected capacity change from 0 to 3982371061760
> [    5.929165]  md1: unknown partition table
> [    5.931666] md: md2 stopped.
> [    5.932456] md: bind<sdd1>
> [    5.932601] md: bind<sdc1>
> [    5.956761] md: raid10 personality registered for level 10
> [    5.956930] md/raid10:md2: active with 2 out of 2 devices
> [    5.956945] md2: detected capacity change from 0 to 1000203091968
> [    5.958806]  md2: unknown partition table
> [    6.393574] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
> [    6.486722] EXT4-fs (md2): mounted filesystem with ordered data mode. Opts: (null)
> [    7.309145] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    7.379565] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    7.501090] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [    7.709014] r8169 0000:02:00.0: eth0: link down
> [    7.709024] r8169 0000:02:00.0: eth0: link down
> [    7.709384] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [    8.539522] RPC: Registered named UNIX socket transport module.
> [    8.539525] RPC: Registered udp transport module.
> [    8.539525] RPC: Registered tcp transport module.
> [    8.539526] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    8.655374] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [   10.310309] r8169 0000:02:00.0: eth0: link up
> [   10.310658] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   11.244047] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> [   11.274451] NFSD: starting 90-second grace period
> [   30.060205] fuse init (API version 7.19)
> [   31.416298] ata1.00: configured for UDMA/133
> [   31.416304] ata1: EH complete
> [   31.542320] ata2.00: configured for UDMA/133
> [   31.542324] ata2: EH complete
> [   31.736351] ata3.00: configured for UDMA/133
> [   31.736355] ata3: EH complete
> [   31.896208] ata4.00: configured for UDMA/133
> [   31.896211] ata4: EH complete
> [   33.404405] EXT4-fs (md1): re-mounted. Opts: commit=0
> [   33.424331] EXT4-fs (md2): re-mounted. Opts: commit=0
> [  101.929675] FS-Cache: Loaded
> [  102.100119] NFS: Registering the id_resolver key type
> [  102.100131] Key type id_resolver registered
> [  102.100132] Key type id_legacy registered
> [  102.100139] FS-Cache: Netfs 'nfs' registered for caching
> [ 1557.697286] INFO: task rsync:3526 blocked for more than 120 seconds.
> [ 1557.697289] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1557.697291] rsync           D ffff880127c13680     0  3526      1 0x00000004
> [ 1557.697294]  ffff88011824dcb8 0000000000000082 ffff88010b079b80 ffff88011824dfd8
> [ 1557.697297]  ffff88011824dfd8 ffff88011824dfd8 ffff880121dd9b80 ffff88010b079b80
> [ 1557.697298]  0000000000000000 ffff88010b079b80 ffff880127c13ed8 0000000000000002
> [ 1557.697300] Call Trace:
> [ 1557.697306]  [<ffffffff810f7e00>] ? __lock_page+0x70/0x70
> [ 1557.697309]  [<ffffffff814949c4>] schedule+0x24/0x70
> [ 1557.697311]  [<ffffffff81494a9a>] io_schedule+0x8a/0xd0
> [ 1557.697313]  [<ffffffff810f7e09>] sleep_on_page+0x9/0x10
> [ 1557.697315]  [<ffffffff81492d38>] __wait_on_bit+0x58/0x90
> [ 1557.697317]  [<ffffffff810f8811>] ? find_get_pages_tag+0xd1/0x180
> [ 1557.697319]  [<ffffffff810f7f28>] wait_on_page_bit+0x78/0x80
> [ 1557.697321]  [<ffffffff8106e460>] ? autoremove_wake_function+0x40/0x40
> [ 1557.697323]  [<ffffffff810f8469>] filemap_fdatawait_range+0xf9/0x190
> [ 1557.697325]  [<ffffffff810f9495>] filemap_write_and_wait_range+0x65/0x70
> [ 1557.697334]  [<ffffffffa05badce>] nfs_file_fsync+0x3e/0xf0 [nfs]
> [ 1557.697337]  [<ffffffff81181bc6>] vfs_fsync+0x26/0x40
> [ 1557.697342]  [<ffffffffa05bb3f8>] nfs_file_flush+0x58/0x80 [nfs]
> [ 1557.697344]  [<ffffffff811539ba>] filp_close+0x3a/0x90
> [ 1557.697346]  [<ffffffff81153d4b>] sys_close+0x7b/0xc0
> [ 1557.697348]  [<ffffffff8149d2b9>] system_call_fastpath+0x16/0x1b
> [ 1677.488515] INFO: task rsync:3526 blocked for more than 120 seconds.
> [ 1677.488518] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1677.488520] rsync           D ffff880127c13680     0  3526      1 0x00000004
> [ 1677.488523]  ffff88011824dcb8 0000000000000082 ffff88010b079b80 ffff88011824dfd8
> [ 1677.488525]  ffff88011824dfd8 ffff88011824dfd8 ffff880121dd9b80 ffff88010b079b80
> [ 1677.488527]  0000000000000000 ffff88010b079b80 ffff880127c13ed8 0000000000000002
> [ 1677.488529] Call Trace:
> [ 1677.488535]  [<ffffffff810f7e00>] ? __lock_page+0x70/0x70
> [ 1677.488538]  [<ffffffff814949c4>] schedule+0x24/0x70
> [ 1677.488540]  [<ffffffff81494a9a>] io_schedule+0x8a/0xd0
> [ 1677.488542]  [<ffffffff810f7e09>] sleep_on_page+0x9/0x10
> [ 1677.488544]  [<ffffffff81492d38>] __wait_on_bit+0x58/0x90
> [ 1677.488546]  [<ffffffff810f8811>] ? find_get_pages_tag+0xd1/0x180
> [ 1677.488548]  [<ffffffff810f7f28>] wait_on_page_bit+0x78/0x80
> [ 1677.488550]  [<ffffffff8106e460>] ? autoremove_wake_function+0x40/0x40
> [ 1677.488552]  [<ffffffff810f8469>] filemap_fdatawait_range+0xf9/0x190
> [ 1677.488554]  [<ffffffff810f9495>] filemap_write_and_wait_range+0x65/0x70
> [ 1677.488562]  [<ffffffffa05badce>] nfs_file_fsync+0x3e/0xf0 [nfs]
> [ 1677.488565]  [<ffffffff81181bc6>] vfs_fsync+0x26/0x40
> [ 1677.488571]  [<ffffffffa05bb3f8>] nfs_file_flush+0x58/0x80 [nfs]
> [ 1677.488573]  [<ffffffff811539ba>] filp_close+0x3a/0x90
> [ 1677.488574]  [<ffffffff81153d4b>] sys_close+0x7b/0xc0
> [ 1677.488576]  [<ffffffff8149d2b9>] system_call_fastpath+0x16/0x1b
> [ 1797.279752] INFO: task rsync:3526 blocked for more than 120 seconds.
> [ 1797.279755] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1797.279756] rsync           D ffff880127c13680     0  3526      1 0x00000004
> [ 1797.279759]  ffff88011824dcb8 0000000000000082 ffff88010b079b80 ffff88011824dfd8
> [ 1797.279762]  ffff88011824dfd8 ffff88011824dfd8 ffff880121dd9b80 ffff88010b079b80
> [ 1797.279764]  0000000000000000 ffff88010b079b80 ffff880127c13ed8 0000000000000002
> [ 1797.279766] Call Trace:
> [ 1797.279772]  [<ffffffff810f7e00>] ? __lock_page+0x70/0x70
> [ 1797.279775]  [<ffffffff814949c4>] schedule+0x24/0x70
> [ 1797.279777]  [<ffffffff81494a9a>] io_schedule+0x8a/0xd0
> [ 1797.279779]  [<ffffffff810f7e09>] sleep_on_page+0x9/0x10
> [ 1797.279781]  [<ffffffff81492d38>] __wait_on_bit+0x58/0x90
> [ 1797.279783]  [<ffffffff810f8811>] ? find_get_pages_tag+0xd1/0x180
> [ 1797.279784]  [<ffffffff810f7f28>] wait_on_page_bit+0x78/0x80
> [ 1797.279787]  [<ffffffff8106e460>] ? autoremove_wake_function+0x40/0x40
> [ 1797.279788]  [<ffffffff810f8469>] filemap_fdatawait_range+0xf9/0x190
> [ 1797.279790]  [<ffffffff810f9495>] filemap_write_and_wait_range+0x65/0x70
> [ 1797.279799]  [<ffffffffa05badce>] nfs_file_fsync+0x3e/0xf0 [nfs]
> [ 1797.279802]  [<ffffffff81181bc6>] vfs_fsync+0x26/0x40
> [ 1797.279807]  [<ffffffffa05bb3f8>] nfs_file_flush+0x58/0x80 [nfs]
> [ 1797.279809]  [<ffffffff811539ba>] filp_close+0x3a/0x90
> [ 1797.279811]  [<ffffffff81153d4b>] sys_close+0x7b/0xc0
> [ 1797.279813]  [<ffffffff8149d2b9>] system_call_fastpath+0x16/0x1b
> [ 1917.071041] INFO: task rsync:3526 blocked for more than 120 seconds.
> [ 1917.071043] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1917.071045] rsync           D ffff880127c13680     0  3526      1 0x00000004
> [ 1917.071048]  ffff88011824dcb8 0000000000000082 ffff88010b079b80 ffff88011824dfd8
> [ 1917.071050]  ffff88011824dfd8 ffff88011824dfd8 ffff880121dd9b80 ffff88010b079b80
> [ 1917.071052]  0000000000000000 ffff88010b079b80 ffff880127c13ed8 0000000000000002
> [ 1917.071054] Call Trace:
> [ 1917.071060]  [<ffffffff810f7e00>] ? __lock_page+0x70/0x70
> [ 1917.071063]  [<ffffffff814949c4>] schedule+0x24/0x70
> [ 1917.071065]  [<ffffffff81494a9a>] io_schedule+0x8a/0xd0
> [ 1917.071067]  [<ffffffff810f7e09>] sleep_on_page+0x9/0x10
> [ 1917.071069]  [<ffffffff81492d38>] __wait_on_bit+0x58/0x90
> [ 1917.071071]  [<ffffffff810f8811>] ? find_get_pages_tag+0xd1/0x180
> [ 1917.071073]  [<ffffffff810f7f28>] wait_on_page_bit+0x78/0x80
> [ 1917.071075]  [<ffffffff8106e460>] ? autoremove_wake_function+0x40/0x40
> [ 1917.071077]  [<ffffffff810f8469>] filemap_fdatawait_range+0xf9/0x190
> [ 1917.071079]  [<ffffffff810f9495>] filemap_write_and_wait_range+0x65/0x70
> [ 1917.071088]  [<ffffffffa05badce>] nfs_file_fsync+0x3e/0xf0 [nfs]
> [ 1917.071090]  [<ffffffff81181bc6>] vfs_fsync+0x26/0x40
> [ 1917.071096]  [<ffffffffa05bb3f8>] nfs_file_flush+0x58/0x80 [nfs]
> [ 1917.071098]  [<ffffffff811539ba>] filp_close+0x3a/0x90
> [ 1917.071100]  [<ffffffff81153d4b>] sys_close+0x7b/0xc0
> [ 1917.071102]  [<ffffffff8149d2b9>] system_call_fastpath+0x16/0x1b
> [ 2036.862216] INFO: task rsync:3526 blocked for more than 120 seconds.
> [ 2036.862218] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2036.862220] rsync           D ffff880127c13680     0  3526      1 0x00000004
> [ 2036.862223]  ffff88011824dcb8 0000000000000082 ffff88010b079b80 ffff88011824dfd8
> [ 2036.862225]  ffff88011824dfd8 ffff88011824dfd8 ffff880121dd9b80 ffff88010b079b80
> [ 2036.862227]  0000000000000000 ffff88010b079b80 ffff880127c13ed8 0000000000000002
> [ 2036.862229] Call Trace:
> [ 2036.862235]  [<ffffffff810f7e00>] ? __lock_page+0x70/0x70
> [ 2036.862239]  [<ffffffff814949c4>] schedule+0x24/0x70
> [ 2036.862240]  [<ffffffff81494a9a>] io_schedule+0x8a/0xd0
> [ 2036.862242]  [<ffffffff810f7e09>] sleep_on_page+0x9/0x10
> [ 2036.862244]  [<ffffffff81492d38>] __wait_on_bit+0x58/0x90
> [ 2036.862246]  [<ffffffff810f8811>] ? find_get_pages_tag+0xd1/0x180
> [ 2036.862248]  [<ffffffff810f7f28>] wait_on_page_bit+0x78/0x80
> [ 2036.862250]  [<ffffffff8106e460>] ? autoremove_wake_function+0x40/0x40
> [ 2036.862252]  [<ffffffff810f8469>] filemap_fdatawait_range+0xf9/0x190
> [ 2036.862254]  [<ffffffff810f9495>] filemap_write_and_wait_range+0x65/0x70
> [ 2036.862263]  [<ffffffffa05badce>] nfs_file_fsync+0x3e/0xf0 [nfs]
> [ 2036.862266]  [<ffffffff81181bc6>] vfs_fsync+0x26/0x40
> [ 2036.862271]  [<ffffffffa05bb3f8>] nfs_file_flush+0x58/0x80 [nfs]
> [ 2036.862274]  [<ffffffff811539ba>] filp_close+0x3a/0x90
> [ 2036.862275]  [<ffffffff81153d4b>] sys_close+0x7b/0xc0
> [ 2036.862277]  [<ffffffff8149d2b9>] system_call_fastpath+0x16/0x1b
> [ 2156.653453] INFO: task rsync:3526 blocked for more than 120 seconds.
> [ 2156.653455] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2156.653457] rsync           D ffff880127c13680     0  3526      1 0x00000004
> [ 2156.653460]  ffff88011824dcb8 0000000000000082 ffff88010b079b80 ffff88011824dfd8
> [ 2156.653462]  ffff88011824dfd8 ffff88011824dfd8 ffff880121dd9b80 ffff88010b079b80
> [ 2156.653464]  0000000000000000 ffff88010b079b80 ffff880127c13ed8 0000000000000002
> [ 2156.653466] Call Trace:
> [ 2156.653472]  [<ffffffff810f7e00>] ? __lock_page+0x70/0x70
> [ 2156.653475]  [<ffffffff814949c4>] schedule+0x24/0x70
> [ 2156.653477]  [<ffffffff81494a9a>] io_schedule+0x8a/0xd0
> [ 2156.653479]  [<ffffffff810f7e09>] sleep_on_page+0x9/0x10
> [ 2156.653481]  [<ffffffff81492d38>] __wait_on_bit+0x58/0x90
> [ 2156.653483]  [<ffffffff810f8811>] ? find_get_pages_tag+0xd1/0x180
> [ 2156.653485]  [<ffffffff810f7f28>] wait_on_page_bit+0x78/0x80
> [ 2156.653487]  [<ffffffff8106e460>] ? autoremove_wake_function+0x40/0x40
> [ 2156.653489]  [<ffffffff810f8469>] filemap_fdatawait_range+0xf9/0x190
> [ 2156.653491]  [<ffffffff810f9495>] filemap_write_and_wait_range+0x65/0x70
> [ 2156.653499]  [<ffffffffa05badce>] nfs_file_fsync+0x3e/0xf0 [nfs]
> [ 2156.653502]  [<ffffffff81181bc6>] vfs_fsync+0x26/0x40
> [ 2156.653508]  [<ffffffffa05bb3f8>] nfs_file_flush+0x58/0x80 [nfs]
> [ 2156.653510]  [<ffffffff811539ba>] filp_close+0x3a/0x90
> [ 2156.653511]  [<ffffffff81153d4b>] sys_close+0x7b/0xc0
> [ 2156.653514]  [<ffffffff8149d2b9>] system_call_fastpath+0x16/0x1b
> [ 2276.444766] INFO: task rsync:3526 blocked for more than 120 seconds.
> [ 2276.444769] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2276.444770] rsync           D ffff880127c13680     0  3526      1 0x00000004
> [ 2276.444773]  ffff88011824dcb8 0000000000000082 ffff88010b079b80 ffff88011824dfd8
> [ 2276.444776]  ffff88011824dfd8 ffff88011824dfd8 ffff880121dd9b80 ffff88010b079b80
> [ 2276.444778]  0000000000000000 ffff88010b079b80 ffff880127c13ed8 0000000000000002
> [ 2276.444779] Call Trace:
> [ 2276.444785]  [<ffffffff810f7e00>] ? __lock_page+0x70/0x70
> [ 2276.444788]  [<ffffffff814949c4>] schedule+0x24/0x70
> [ 2276.444790]  [<ffffffff81494a9a>] io_schedule+0x8a/0xd0
> [ 2276.444792]  [<ffffffff810f7e09>] sleep_on_page+0x9/0x10
> [ 2276.444794]  [<ffffffff81492d38>] __wait_on_bit+0x58/0x90
> [ 2276.444796]  [<ffffffff810f8811>] ? find_get_pages_tag+0xd1/0x180
> [ 2276.444798]  [<ffffffff810f7f28>] wait_on_page_bit+0x78/0x80
> [ 2276.444800]  [<ffffffff8106e460>] ? autoremove_wake_function+0x40/0x40
> [ 2276.444802]  [<ffffffff810f8469>] filemap_fdatawait_range+0xf9/0x190
> [ 2276.444804]  [<ffffffff810f9495>] filemap_write_and_wait_range+0x65/0x70
> [ 2276.444813]  [<ffffffffa05badce>] nfs_file_fsync+0x3e/0xf0 [nfs]
> [ 2276.444816]  [<ffffffff81181bc6>] vfs_fsync+0x26/0x40
> [ 2276.444821]  [<ffffffffa05bb3f8>] nfs_file_flush+0x58/0x80 [nfs]
> [ 2276.444823]  [<ffffffff811539ba>] filp_close+0x3a/0x90
> [ 2276.444824]  [<ffffffff81153d4b>] sys_close+0x7b/0xc0
> [ 2276.444827]  [<ffffffff8149d2b9>] system_call_fastpath+0x16/0x1b
> [ 2396.235997] INFO: task rsync:3526 blocked for more than 120 seconds.
> [ 2396.235999] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2396.236001] rsync           D ffff880127c13680     0  3526      1 0x00000004
> [ 2396.236004]  ffff88011824dcb8 0000000000000082 ffff88010b079b80 ffff88011824dfd8
> [ 2396.236006]  ffff88011824dfd8 ffff88011824dfd8 ffff880121dd9b80 ffff88010b079b80
> [ 2396.236008]  0000000000000000 ffff88010b079b80 ffff880127c13ed8 0000000000000002
> [ 2396.236010] Call Trace:
> [ 2396.236016]  [<ffffffff810f7e00>] ? __lock_page+0x70/0x70
> [ 2396.236019]  [<ffffffff814949c4>] schedule+0x24/0x70
> [ 2396.236021]  [<ffffffff81494a9a>] io_schedule+0x8a/0xd0
> [ 2396.236023]  [<ffffffff810f7e09>] sleep_on_page+0x9/0x10
> [ 2396.236025]  [<ffffffff81492d38>] __wait_on_bit+0x58/0x90
> [ 2396.236027]  [<ffffffff810f8811>] ? find_get_pages_tag+0xd1/0x180
> [ 2396.236029]  [<ffffffff810f7f28>] wait_on_page_bit+0x78/0x80
> [ 2396.236031]  [<ffffffff8106e460>] ? autoremove_wake_function+0x40/0x40
> [ 2396.236033]  [<ffffffff810f8469>] filemap_fdatawait_range+0xf9/0x190
> [ 2396.236035]  [<ffffffff810f9495>] filemap_write_and_wait_range+0x65/0x70
> [ 2396.236044]  [<ffffffffa05badce>] nfs_file_fsync+0x3e/0xf0 [nfs]
> [ 2396.236047]  [<ffffffff81181bc6>] vfs_fsync+0x26/0x40
> [ 2396.236052]  [<ffffffffa05bb3f8>] nfs_file_flush+0x58/0x80 [nfs]
> [ 2396.236054]  [<ffffffff811539ba>] filp_close+0x3a/0x90
> [ 2396.236056]  [<ffffffff81153d4b>] sys_close+0x7b/0xc0
> [ 2396.236058]  [<ffffffff8149d2b9>] system_call_fastpath+0x16/0x1b
> [ 2516.027131] INFO: task rsync:3526 blocked for more than 120 seconds.
> [ 2516.027134] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2516.027135] rsync           D ffff880127c13680     0  3526      1 0x00000004
> [ 2516.027139]  ffff88011824dcb8 0000000000000082 ffff88010b079b80 ffff88011824dfd8
> [ 2516.027141]  ffff88011824dfd8 ffff88011824dfd8 ffff880121dd9b80 ffff88010b079b80
> [ 2516.027143]  0000000000000000 ffff88010b079b80 ffff880127c13ed8 0000000000000002
> [ 2516.027145] Call Trace:
> [ 2516.027151]  [<ffffffff810f7e00>] ? __lock_page+0x70/0x70
> [ 2516.027154]  [<ffffffff814949c4>] schedule+0x24/0x70
> [ 2516.027156]  [<ffffffff81494a9a>] io_schedule+0x8a/0xd0
> [ 2516.027158]  [<ffffffff810f7e09>] sleep_on_page+0x9/0x10
> [ 2516.027160]  [<ffffffff81492d38>] __wait_on_bit+0x58/0x90
> [ 2516.027162]  [<ffffffff810f8811>] ? find_get_pages_tag+0xd1/0x180
> [ 2516.027164]  [<ffffffff810f7f28>] wait_on_page_bit+0x78/0x80
> [ 2516.027166]  [<ffffffff8106e460>] ? autoremove_wake_function+0x40/0x40
> [ 2516.027168]  [<ffffffff810f8469>] filemap_fdatawait_range+0xf9/0x190
> [ 2516.027170]  [<ffffffff810f9495>] filemap_write_and_wait_range+0x65/0x70
> [ 2516.027179]  [<ffffffffa05badce>] nfs_file_fsync+0x3e/0xf0 [nfs]
> [ 2516.027182]  [<ffffffff81181bc6>] vfs_fsync+0x26/0x40
> [ 2516.027187]  [<ffffffffa05bb3f8>] nfs_file_flush+0x58/0x80 [nfs]
> [ 2516.027189]  [<ffffffff811539ba>] filp_close+0x3a/0x90
> [ 2516.027191]  [<ffffffff81153d4b>] sys_close+0x7b/0xc0
> [ 2516.027193]  [<ffffffff8149d2b9>] system_call_fastpath+0x16/0x1b
> [ 2635.818372] INFO: task rsync:3526 blocked for more than 120 seconds.
> [ 2635.818374] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2635.818376] rsync           D ffff880127c13680     0  3526      1 0x00000004
> [ 2635.818379]  ffff88011824dcb8 0000000000000082 ffff88010b079b80 ffff88011824dfd8
> [ 2635.818382]  ffff88011824dfd8 ffff88011824dfd8 ffff880121dd9b80 ffff88010b079b80
> [ 2635.818384]  0000000000000000 ffff88010b079b80 ffff880127c13ed8 0000000000000002
> [ 2635.818385] Call Trace:
> [ 2635.818391]  [<ffffffff810f7e00>] ? __lock_page+0x70/0x70
> [ 2635.818395]  [<ffffffff814949c4>] schedule+0x24/0x70
> [ 2635.818396]  [<ffffffff81494a9a>] io_schedule+0x8a/0xd0
> [ 2635.818398]  [<ffffffff810f7e09>] sleep_on_page+0x9/0x10
> [ 2635.818400]  [<ffffffff81492d38>] __wait_on_bit+0x58/0x90
> [ 2635.818402]  [<ffffffff810f8811>] ? find_get_pages_tag+0xd1/0x180
> [ 2635.818404]  [<ffffffff810f7f28>] wait_on_page_bit+0x78/0x80
> [ 2635.818406]  [<ffffffff8106e460>] ? autoremove_wake_function+0x40/0x40
> [ 2635.818408]  [<ffffffff810f8469>] filemap_fdatawait_range+0xf9/0x190
> [ 2635.818410]  [<ffffffff810f9495>] filemap_write_and_wait_range+0x65/0x70
> [ 2635.818419]  [<ffffffffa05badce>] nfs_file_fsync+0x3e/0xf0 [nfs]
> [ 2635.818422]  [<ffffffff81181bc6>] vfs_fsync+0x26/0x40
> [ 2635.818427]  [<ffffffffa05bb3f8>] nfs_file_flush+0x58/0x80 [nfs]
> [ 2635.818429]  [<ffffffff811539ba>] filp_close+0x3a/0x90
> [ 2635.818431]  [<ffffffff81153d4b>] sys_close+0x7b/0xc0
> [ 2635.818433]  [<ffffffff8149d2b9>] system_call_fastpath+0x16/0x1b
> [255646.692961] INFO: rcu_sched self-detected stall on CPU { 1}  (t=54862991 jiffies)
> [255646.692965] sending NMI to all CPUs:
> [255646.692971] NMI backtrace for cpu 0
> [255646.692974] CPU 0 
> [255646.692975] Modules linked in: nfs fscache fuse binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid10 raid0 autofs4 dummy ata_generic pata_acpi sp5100_tco pata_atiixp radeon ttm drm_kms_helper drm i2c_algo_bit ide_pci_generic freq_table mperf i2c_piix4 ohci_hcd ehci_hcd usbcore shpchp pci_hotplug i2c_core pcspkr evdev r8169 usb_common k10temp hwmon processor mii kvm_amd kvm wmi atiixp ide_core edac_core edac_mce_amd microcode button sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
> [255646.693007] 
> [255646.693009] Pid: 0, comm: swapper/0 Not tainted 3.5.4 #5 Gigabyte Technology Co., Ltd. GA-MA785GMT-UD2H/GA-MA785GMT-UD2H
> [255646.693011] RIP: 0010:[<ffffffff81495775>]  [<ffffffff81495775>] _raw_spin_lock_irqsave+0x35/0x40
> [255646.693017] RSP: 0018:ffffffff81801d88  EFLAGS: 00000097
> [255646.693018] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000037
> [255646.693019] RDX: 0000000000000036 RSI: 0000000000000002 RDI: ffffffff819aec68
> [255646.693020] RBP: ffffffff81801d88 R08: 0000000000000000 R09: ffffffff81825350
> [255646.693021] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880127c0dc80
> [255646.693022] R13: 0000000000000005 R14: ffffffff81801ec4 R15: ffffffff8185cc40
> [255646.693023] FS:  00007ff0362017c0(0000) GS:ffff880127c00000(0000) knlGS:00000000f757d6c0
> [255646.693024] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [255646.693025] CR2: 00007f56a1827000 CR3: 00000000c98b7000 CR4: 00000000000007f0
> [255646.693026] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [255646.693027] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [255646.693029] Process swapper/0 (pid: 0, threadinfo ffffffff81800000, task ffffffff81813440)
> [255646.693029] Stack:
> [255646.693030]  ffffffff81801dc8 ffffffff81098c9e ffffffff81801da8 0000000000000001
> [255646.693032]  ffffffff81801ec4 0000000000000005 ffffffff81801ec4 0000000000000000
> [255646.693034]  ffffffff81801e18 ffffffff81098535 0000000100000002 000000000000e640
> [255646.693036] Call Trace:
> [255646.693039]  [<ffffffff81098c9e>] tick_broadcast_oneshot_control+0x7e/0x120
> [255646.693042]  [<ffffffff81098535>] tick_notify+0x315/0x410
> [255646.693044]  [<ffffffff814992ad>] notifier_call_chain+0x4d/0x70
> [255646.693046]  [<ffffffff81073be9>] __raw_notifier_call_chain+0x9/0x10
> [255646.693048]  [<ffffffff81073c01>] raw_notifier_call_chain+0x11/0x20
> [255646.693050]  [<ffffffff81097b12>] clockevents_notify+0x32/0x180
> [255646.693052]  [<ffffffff8101b53e>] amd_e400_idle+0x9e/0x110
> [255646.693054]  [<ffffffff8101c01e>] cpu_idle+0xfe/0x120
> [255646.693056]  [<ffffffff8146f0c9>] rest_init+0x6d/0x74
> [255646.693058]  [<ffffffff818a3c20>] start_kernel+0x3ad/0x3ba
> [255646.693060]  [<ffffffff818a3672>] ? repair_env_string+0x5e/0x5e
> [255646.693062]  [<ffffffff818a3356>] x86_64_start_reservations+0x131/0x135
> [255646.693064]  [<ffffffff818a345a>] x86_64_start_kernel+0x100/0x10f
> [255646.693064] Code: 90 48 89 c6 fa 66 66 90 66 66 90 ba 00 01 00 00 f0 66 0f c1 17 0f b6 ce 38 d1 74 13 66 2e 0f 1f 84 00 00 00 00 00 f3 90 0f b6 17 <38> ca 75 f7 48 89 f0 5d c3 66 90 55 48 89 e5 fa 66 66 90 66 66 
> [255646.693080] NMI backtrace for cpu 1
> [255646.693081] CPU 1 
> [255646.693082] Modules linked in: nfs fscache fuse binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid10 raid0 autofs4 dummy ata_generic pata_acpi sp5100_tco pata_atiixp radeon ttm drm_kms_helper drm i2c_algo_bit ide_pci_generic freq_table mperf i2c_piix4 ohci_hcd ehci_hcd usbcore shpchp pci_hotplug i2c_core pcspkr evdev r8169 usb_common k10temp hwmon processor mii kvm_amd kvm wmi atiixp ide_core edac_core edac_mce_amd microcode button sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
> [255646.693113] 
> [255646.693115] Pid: 0, comm: swapper/1 Not tainted 3.5.4 #5 Gigabyte Technology Co., Ltd. GA-MA785GMT-UD2H/GA-MA785GMT-UD2H
> [255646.693117] RIP: 0010:[<ffffffff812570b9>]  [<ffffffff812570b9>] __const_udelay+0x9/0x40
> [255646.693122] RSP: 0018:ffff880127c83b08  EFLAGS: 00000006
> [255646.693123] RAX: 0000000000000003 RBX: 0000000000002710 RCX: 00000000000000dd
> [255646.693125] RDX: 0000000000a37e2e RSI: 0000000000000002 RDI: 0000000000418958
> [255646.693126] RBP: ffff880127c83b20 R08: 0000000000000431 R09: 0000000000000000
> [255646.693126] R10: 0000000000000000 R11: 0000000000040000 R12: ffffffff81828440
> [255646.693127] R13: ffffffff81828500 R14: ffff880127c8e680 R15: 0000e8e902576c95
> [255646.693129] FS:  00007ff0362017c0(0000) GS:ffff880127c80000(0000) knlGS:00000000f757d6c0
> [255646.693130] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [255646.693131] CR2: 00007fecafc56000 CR3: 00000000c98b7000 CR4: 00000000000007e0
> [255646.693132] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [255646.693133] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [255646.693134] Process swapper/1 (pid: 0, threadinfo ffff880121e06000, task ffff880121ddb020)
> [255646.693135] Stack:
> [255646.693136]  ffffffff8103361a 00000000000000f1 ffff880127c8ec00 ffff880127c83b70
> [255646.693138]  ffffffff810cb462 ffff880127c83b60 ffff880127c83b70 ffffffff8107c2b3
> [255646.693139]  0000000000000001 0000000000000001 0000000000000000 ffff880127c8e680
> [255646.693141] Call Trace:
> [255646.693142]  <IRQ> 
> [255646.693143]  [<ffffffff8103361a>] ? arch_trigger_all_cpu_backtrace+0x5a/0x80
> [255646.693148]  [<ffffffff810cb462>] __rcu_pending+0x192/0x4c0
> [255646.693151]  [<ffffffff8107c2b3>] ? calc_global_load+0x1a3/0x220
> [255646.693152]  [<ffffffff810cb7b7>] rcu_pending+0x27/0x60
> [255646.693154]  [<ffffffff810cc0c9>] rcu_check_callbacks+0x99/0x140
> [255646.693156]  [<ffffffff8105cd53>] update_process_times+0x43/0x80
> [255646.693159]  [<ffffffff810994f1>] tick_sched_timer+0x61/0xc0
> [255646.693161]  [<ffffffff81071cfe>] __run_hrtimer+0x6e/0x1c0
> [255646.693163]  [<ffffffff81099490>] ? tick_nohz_handler+0x100/0x100
> [255646.693164]  [<ffffffff810725df>] hrtimer_interrupt+0xef/0x220
> [255646.693166]  [<ffffffff81098732>] tick_do_broadcast.constprop.3+0x82/0x90
> [255646.693168]  [<ffffffff8109880d>] tick_handle_oneshot_broadcast+0xcd/0x100
> [255646.693170]  [<ffffffff81015810>] timer_interrupt+0x10/0x20
> [255646.693172]  [<ffffffff810c31d4>] handle_irq_event_percpu+0x54/0x1f0
> [255646.693174]  [<ffffffff810c33ac>] handle_irq_event+0x3c/0x60
> [255646.693176]  [<ffffffff810c599f>] handle_edge_irq+0x6f/0x110
> [255646.693178]  [<ffffffff8101508d>] handle_irq+0x1d/0x30
> [255646.693179]  [<ffffffff81014d45>] do_IRQ+0x55/0xd0
> [255646.693182]  [<ffffffff8149592a>] common_interrupt+0x6a/0x6a
> [255646.693184]  [<ffffffff813158de>] ? add_interrupt_randomness+0x16e/0x1d0
> [255646.693186]  [<ffffffff810544c0>] ? __do_softirq+0x60/0x1c0
> [255646.693189]  [<ffffffff8149e69c>] call_softirq+0x1c/0x30
> [255646.693191]  [<ffffffff8101510d>] do_softirq+0x6d/0xa0
> [255646.693192]  [<ffffffff810548b5>] irq_exit+0xa5/0xb0
> [255646.693194]  [<ffffffff81014d4e>] do_IRQ+0x5e/0xd0
> [255646.693195]  [<ffffffff8149592a>] common_interrupt+0x6a/0x6a
> [255646.693196]  <EOI> 
> [255646.693197]  [<ffffffff8103ad76>] ? native_safe_halt+0x6/0x10
> [255646.693200]  [<ffffffff81097b27>] ? clockevents_notify+0x47/0x180
> [255646.693202]  [<ffffffff8101b35a>] default_idle+0x4a/0x190
> [255646.693203]  [<ffffffff8101b52a>] amd_e400_idle+0x8a/0x110
> [255646.693205]  [<ffffffff8101c01e>] cpu_idle+0xfe/0x120
> [255646.693207]  [<ffffffff814830f8>] start_secondary+0x1de/0x1e5
> [255646.693208] Code: 00 00 48 ff c8 75 fb 48 ff c8 5d c3 66 0f 1f 44 00 00 55 48 89 e5 ff 15 6e 94 5e 00 5d c3 0f 1f 40 00 65 48 8b 14 25 98 35 01 00 <48> 8d 0c 92 55 48 8d 04 bd 00 00 00 00 48 89 ca 48 89 e5 48 c1 
> [255646.695978] Clocksource tsc unstable (delta = 357271812021 ns)
> [255647.643789] Switching to clocksource acpi_pm
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


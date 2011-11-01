Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1KAQcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:32:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:32658 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab1KAQcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:32:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,438,1315206000"; 
   d="scan'208";a="69333809"
Date: Wed, 2 Nov 2011 00:32:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Carsten Emde <cbe@osadl.org>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111101163212.GA19501@localhost>
References: <20111031082634.GA10348@localhost>
 <20111031095152.GL6160@linux.vnet.ibm.com>
 <20111031104325.GA25808@localhost>
 <20111031114142.GA32555@localhost>
 <20111031121951.GM6160@linux.vnet.ibm.com>
 <1320075882.4793.4.camel@gandalf.stny.rr.com>
 <20111101003434.GR6160@linux.vnet.ibm.com>
 <20111101070720.GA22936@localhost>
 <20111101160014.GH2287@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101160014.GH2287@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmmmm...  Please see below for a diagnostic patch that prints out who
> the kernel believes the idle thread is.  Could you please give this
> a go?

Sure. Here it goes :)

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-ioless-full-next-20111025+ (wfg@bee) (gcc version 4.5.0 (GCC) ) #889 SMP Wed Nov 2 00:25:42 CST 2011
[    0.000000] Command line: hpet=disable run=/home/wfg/ioless-balance_dirty_pages/test-each-fs.sh log_buf_len=8M debug sched_debug apic=debug dynamic_printk drm.debug=6 sysrq_always_enabled panic=10 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 netconsole=@:/eth0,6666@192.168.1.1/00:30:48:fe:19:95 ip=192.168.1.52:192.168.1.11:192.168.1.1:255.255.255.0:fat:eth0:none nfsroot=192.168.1.11:/nfsroot/wfg,tcp,v3,nocto,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-3.1.0-ioless-full-next-20111025+ 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
[    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bcde3000 (usable)
[    0.000000]  BIOS-e820: 00000000bcde3000 - 00000000bcffb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bcffb000 - 00000000bf6bd000 (usable)
[    0.000000]  BIOS-e820: 00000000bf6bd000 - 00000000bf6bf000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf6bf000 - 00000000bf714000 (usable)
[    0.000000]  BIOS-e820: 00000000bf714000 - 00000000bf7bf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7bf000 - 00000000bf7e7000 (usable)
[    0.000000]  BIOS-e820: 00000000bf7e7000 - 00000000bf7ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf7ff000 - 00000000bf800000 (usable)
[    0.000000]  BIOS-e820: 00000000bf800000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fd000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] DMI:                  /DX58SO, BIOS SOX5810J.86A.2127.2008.0914.1638 09/14/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000ff4c0] ff4c0
[    0.000000]   mpc: ff4d0-ff6a8
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
[    0.000000]  0000000000 - 00bf800000 page 4k
[    0.000000] kernel direct mapping tables up to bf800000 @ 1fa02000-20000000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 258225(98%)
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 INTEL )
[    0.000000] ACPI: XSDT 00000000bf7fe120 0006C (v01 INTEL  DX58SO   0000084F      01000013)
[    0.000000] ACPI: FACP 00000000bf7fd000 000F4 (v03 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000450/0x0 (20110623/tbfadt-560)
[    0.000000] ACPI Warning: Invalid length for Pm2ControlBlock: 0, using default 8 (20110623/tbfadt-610)
[    0.000000] ACPI: DSDT 00000000bf7f8000 043CE (v02 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: FACS 00000000bf726000 00040
[    0.000000] ACPI: APIC 00000000bf7f7000 00138 (v02 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: WDDT 00000000bf7f6000 00040 (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: MCFG 00000000bf7f5000 0003C (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: ASF! 00000000bf7f4000 000AC (v32 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: SSDT 00000000bf7ea000 070AC (v01 INTEL  SSDT  PM 0000084F MSFT 0100000D)
[    0.000000] ACPI: DMAR 00000000bf7e7000 00140 (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: WDTT 00000000bf7f2000 0020C (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: ASPT 00000000bf7f3000 00034 (v04 INTEL  PerfTune 0000084F MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000000bf800000
[    0.000000] Initmem setup node 0 0000000000000000-00000000bf800000
[    0.000000]   NODE_DATA [00000000bf7e2000 - 00000000bf7e6fff]
[    0.000000]  [ffffea0000000000-ffffea0002ffffff] PMD -> [ffff8800b9c00000-ffff8800bcbfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009c
[    0.000000]     0: 0x00000100 -> 0x000bcde3
[    0.000000]     0: 0x000bcffb -> 0x000bf6bd
[    0.000000]     0: 0x000bf6bf -> 0x000bf714
[    0.000000]     0: 0x000bf7bf -> 0x000bf7e7
[    0.000000]     0: 0x000bf7ff -> 0x000bf800
[    0.000000] On node 0 totalpages: 783535
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12192 pages used for memmap
[    0.000000]   DMA32 zone: 767363 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bcde3000 - 00000000bcffb000
[    0.000000] PM: Registered nosave memory: 00000000bf6bd000 - 00000000bf6bf000
[    0.000000] PM: Registered nosave memory: 00000000bf714000 - 00000000bf7bf000
[    0.000000] PM: Registered nosave memory: 00000000bf7e7000 - 00000000bf7ff000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:38000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff8800b7c00000 s1916992 r8192 d24512 u2097152
[    0.000000] pcpu-alloc: s1916992 r8192 d24512 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07 
[    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 771274
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hpet=disable run=/home/wfg/ioless-balance_dirty_pages/test-each-fs.sh log_buf_len=8M debug sched_debug apic=debug dynamic_printk drm.debug=6 sysrq_always_enabled panic=10 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 netconsole=@:/eth0,6666@192.168.1.1/00:30:48:fe:19:95 ip=192.168.1.52:192.168.1.11:192.168.1.1:255.255.255.0:fat:eth0:none nfsroot=192.168.1.11:/nfsroot/wfg,tcp,v3,nocto,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-3.1.0-ioless-full-next-20111025+ 
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 3012424k/3137536k available (9797k kernel code, 3396k absent, 121716k reserved, 5797k data, 2768k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:808 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 25165824 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 3200.263 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6400.52 BogoMIPS (lpj=3200263)
[    0.000706] pid_max: default: 32768 minimum: 301
[    0.001885] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003938] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004935] Mount-cache hash table entries: 256
[    0.005636] Initializing cgroup subsys debug
[    0.005946] Initializing cgroup subsys cpuacct
[    0.006277] Initializing cgroup subsys memory
[    0.006613] Initializing cgroup subsys devices
[    0.006929] Initializing cgroup subsys freezer
[    0.007255] Initializing cgroup subsys blkio
[    0.007619] CPU: Physical Processor ID: 0
[    0.007917] CPU: Processor Core ID: 0
[    0.008216] mce: CPU supports 9 MCE banks
[    0.008521] CPU0: Thermal monitoring enabled (TM1)
[    0.008857] using mwait in idle threads.
[    0.010011] ACPI: Core revision 20110623
[    0.021816] ftrace: allocating 38070 entries in 150 pages
[    0.030748] Getting VERSION: 60015
[    0.031025] Getting VERSION: 60015
[    0.031310] Getting ID: 0
[    0.031556] Getting ID: 0
[    0.031804] Switched APIC routing to physical flat.
[    0.032142] enabled ExtINT on CPU#0
[    0.032641] ENABLING IO-APIC IRQs
[    0.032914] init IO_APIC IRQs
[    0.033182]  apic 8 pin 0 not connected
[    0.033481] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.034045] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.034619] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.035186] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.035750] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.036317] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.036880] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.037446] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.038011] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.038577] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.039150] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.039721] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.040294] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.040864] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.041436] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.042005]  apic 8 pin 16 not connected
[    0.042302]  apic 8 pin 17 not connected
[    0.042596]  apic 8 pin 18 not connected
[    0.042890]  apic 8 pin 19 not connected
[    0.043186]  apic 8 pin 20 not connected
[    0.043480]  apic 8 pin 21 not connected
[    0.043775]  apic 8 pin 22 not connected
[    0.044072]  apic 8 pin 23 not connected
[    0.044501] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054842] CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
[    0.055325] Using local APIC timer interrupts.
[    0.055325] calibrating APIC timer ...
[    0.156671] ... lapic delta = 833238
[    0.156952] ... PM-Timer delta = 357901
[    0.157242] ... PM-Timer result ok
[    0.157517] ..... delta 833238
[    0.157779] ..... mult: 35792740
[    0.158047] ..... calibration result: 133318
[    0.158355] ..... CPU clock speed is 3199.0634 MHz.
[    0.158684] ..... host bus clock speed is 133.0318 MHz.
[    0.159040] Performance Events: PEBS fmt1+, erratum AAJ80 worked around, Nehalem events, Intel PMU driver.
[    0.159803] ... version:                3
[    0.160104] ... bit width:              48
[    0.160405] ... generic registers:      4
[    0.160702] ... value mask:             0000ffffffffffff
[    0.161050] ... max period:             000000007fffffff
[    0.161396] ... fixed-purpose events:   3
[    0.161694] ... event mask:             000000070000000f
[    0.162244] Testing tracer nop: PASSED
[    0.162657] lockdep: fixing up alternatives.
[    0.163021] Booting Node   0, Processors  #1
[    0.163243] smpboot cpu 1: start_ip = 97000
[    0.174779] masked ExtINT on CPU#1
[    0.194959] Dumping ftrace buffer:
[    0.195071] lockdep: fixing up alternatives.
[    0.195094]  #2
[    0.195095] smpboot cpu 2: start_ip = 97000
[    0.196062]    (ftrace buffer empty)
[    0.196344] ------------[ cut here ]------------
[    0.196668] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:454 rcu_idle_exit_common+0x155/0x165()
[    0.197262] Hardware name:         
[    0.197542] Current pid: 0 comm: kworker/0:0 / Idle pid: 0 comm: kworker/0:0
[    0.197828] Modules linked in:
[    0.201247] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-ioless-full-next-20111025+ #889
[    0.201808] Call Trace:
[    0.202048]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    0.202479]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    0.202842]  [<ffffffff810d5b80>] rcu_idle_exit_common+0x155/0x165
[    0.203220]  [<ffffffff810d6096>] rcu_irq_enter+0x75/0xa3
[    0.203570]  [<ffffffff8107ac7f>] irq_enter+0x1b/0x74
[    0.203908]  [<ffffffff8106f29e>] scheduler_ipi+0x5e/0xd5
[    0.204258]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
[    0.204645]  [<ffffffff8198ce33>] reschedule_interrupt+0x73/0x80
[    0.205015]  <EOI>  [<ffffffff819878df>] ? notifier_call_chain+0x63/0x63
[    0.205456]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
[    0.205808]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
[    0.206159]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
[    0.206169] masked ExtINT on CPU#2
[    0.206767]  [<ffffffff81979e95>] start_secondary+0x1de/0x1e2
[    0.207151] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.207475] ------------[ cut here ]------------
[    0.207797] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:366 rcu_idle_enter_common+0x13b/0x17b()
[    0.208394] Hardware name:         
[    0.208673] Current pid: 0 comm: kworker/0:0 / Idle pid: 0 comm: kworker/0:0
[    0.208959] Modules linked in:
[    0.209411] Pid: 0, comm: kworker/0:0 Tainted: G        W   3.1.0-ioless-full-next-20111025+ #889
[    0.210004] Call Trace:
[    0.210244]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    0.210675]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    0.211037]  [<ffffffff810d5ccb>] rcu_idle_enter_common+0x13b/0x17b
[    0.211418]  [<ffffffff810d5f4f>] rcu_irq_exit+0x6b/0x95
[    0.211765]  [<ffffffff8107ad88>] irq_exit+0xb0/0xb2
[    0.212100]  [<ffffffff8106f310>] scheduler_ipi+0xd0/0xd5
[    0.212450]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
[    0.212835]  [<ffffffff8198ce33>] reschedule_interrupt+0x73/0x80
[    0.213206]  <EOI>  [<ffffffff819878df>] ? notifier_call_chain+0x63/0x63
[    0.213640]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
[    0.213988]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
[    0.214338]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
[    0.214670]  [<ffffffff81979e95>] start_secondary+0x1de/0x1e2
[    0.215032] ---[ end trace 4eaa2a86a8e2da23 ]---
[    0.226333] lockdep: fixing up alternatives.
[    0.226666]  #3
[    0.226758] smpboot cpu 3: start_ip = 97000
[    0.238295] masked ExtINT on CPU#3
[    0.258556] lockdep: fixing up alternatives.
[    0.258894]  #4
[    0.258986] smpboot cpu 4: start_ip = 97000
[    0.270520] masked ExtINT on CPU#4
[    0.290795] lockdep: fixing up alternatives.
[    0.291127]  #5
[    0.291218] smpboot cpu 5: start_ip = 97000
[    0.302758] masked ExtINT on CPU#5
[    0.323023] lockdep: fixing up alternatives.
[    0.323359]  #6
[    0.323451] smpboot cpu 6: start_ip = 97000
[    0.334990] masked ExtINT on CPU#6
[    0.355252] lockdep: fixing up alternatives.
[    0.355591]  #7
[    0.355684] smpboot cpu 7: start_ip = 97000
[    0.367216] masked ExtINT on CPU#7
[    0.387378] Brought up 8 CPUs
[    0.387640] Total of 8 processors activated (51204.20 BogoMIPS).
[    0.391382] CPU0 attaching sched-domain:
[    0.391681]  domain 0: span 0,4 level SIBLING
[    0.392026]   groups: 0 (cpu_power = 589) 4 (cpu_power = 589)
[    0.392562]   domain 1: span 0-7 level MC
[    0.392893]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    0.393849] CPU1 attaching sched-domain:
[    0.394143]  domain 0: span 1,5 level SIBLING
[    0.394491]   groups: 1 (cpu_power = 589) 5 (cpu_power = 589)
[    0.395019]   domain 1: span 0-7 level MC
[    0.395354]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    0.396310] CPU2 attaching sched-domain:
[    0.396606]  domain 0: span 2,6 level SIBLING
[    0.396950]   groups: 2 (cpu_power = 589) 6 (cpu_power = 589)
[    0.397482]   domain 1: span 0-7 level MC
[    0.397813]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    0.398767] CPU3 attaching sched-domain:
[    0.399061]  domain 0: span 3,7 level SIBLING
[    0.399408]   groups: 3 (cpu_power = 589) 7 (cpu_power = 589)
[    0.399937]   domain 1: span 0-7 level MC
[    0.400270]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    0.401224] CPU4 attaching sched-domain:
[    0.401518]  domain 0: span 0,4 level SIBLING
[    0.401862]   groups: 4 (cpu_power = 589) 0 (cpu_power = 589)
[    0.402394]   domain 1: span 0-7 level MC
[    0.402725]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    0.403679] CPU5 attaching sched-domain:
[    0.403973]  domain 0: span 1,5 level SIBLING
[    0.404319]   groups: 5 (cpu_power = 589) 1 (cpu_power = 589)
[    0.404848]   domain 1: span 0-7 level MC
[    0.405179]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    0.406133] CPU6 attaching sched-domain:
[    0.406430]  domain 0: span 2,6 level SIBLING
[    0.406774]   groups: 6 (cpu_power = 589) 2 (cpu_power = 589)
[    0.407305]   domain 1: span 0-7 level MC
[    0.407636]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    0.408591] CPU7 attaching sched-domain:
[    0.408886]  domain 0: span 3,7 level SIBLING
[    0.409231]   groups: 7 (cpu_power = 589) 3 (cpu_power = 589)
[    0.409761]   domain 1: span 0-7 level MC
[    0.410093]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    0.411496] devtmpfs: initialized
[    0.412761] PM: Registering ACPI NVS region at bcde3000 (2195456 bytes)
[    0.413218] PM: Registering ACPI NVS region at bf714000 (700416 bytes)
[    0.414290] xor: automatically using best checksumming function: generic_sse
[    0.419153]    generic_sse: 11928.000 MB/sec
[    0.419462] xor: using function: generic_sse (11928.000 MB/sec)
[    0.419948] kworker/u:0 used greatest stack depth: 5608 bytes left
[    0.419976] RTC time:  0:29:12, date: 11/02/11
[    0.420061] NET: Registered protocol family 16
[    0.420960] kworker/u:0 used greatest stack depth: 5192 bytes left
[    0.421852] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.422411] ACPI: bus type pci registered
[    0.422908] dca service started, version 1.12.1
[    0.423310] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.423921] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.436072] PCI: Using configuration type 1 for base access
[    0.461454] bio: create slab <bio-0> at 0
[    0.477963] raid6: int64x1   2777 MB/s
[    0.494899] raid6: int64x2   3207 MB/s
[    0.511840] raid6: int64x4   2714 MB/s
[    0.528784] raid6: int64x8   2089 MB/s
[    0.545725] raid6: sse2x1    7871 MB/s
[    0.562669] raid6: sse2x2    9242 MB/s
[    0.579608] raid6: sse2x4   10484 MB/s
[    0.579898] raid6: using algorithm sse2x4 (10484 MB/s)
[    0.580324] ACPI: Added _OSI(Module Device)
[    0.580636] ACPI: Added _OSI(Processor Device)
[    0.580951] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.581276] ACPI: Added _OSI(Processor Aggregator Device)
[    0.585665] ACPI: EC: Look up EC in DSDT
[    0.606694] ACPI: Interpreter enabled
[    0.606981] ACPI: (supports S0 S1 S3 S4 S5)
[    0.607488] ACPI: Using IOAPIC for interrupt routing
[    0.620407] ACPI: No dock devices found.
[    0.620708] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.621907] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3d])
[    0.623518] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.623915] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.624309] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.624849] pci_root PNP0A03:00: host bridge window [mem 0x000c4000-0x000cbfff]
[    0.625387] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfedfffff]
[    0.625927] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xf7ffffff]
[    0.626489] pci 0000:00:00.0: [8086:3405] type 0 class 0x000600
[    0.626927] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    0.627350] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.627739] pci 0000:00:01.0: PME# disabled
[    0.628069] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    0.628498] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.628876] pci 0000:00:03.0: PME# disabled
[    0.629208] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    0.629635] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.630013] pci 0000:00:07.0: PME# disabled
[    0.630345] pci 0000:00:10.0: [8086:3425] type 0 class 0x000800
[    0.630795] pci 0000:00:10.1: [8086:3426] type 0 class 0x000800
[    0.631242] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    0.631694] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    0.632137] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    0.632580] pci 0000:00:14.3: [8086:3438] type 0 class 0x000800
[    0.633027] pci 0000:00:19.0: [8086:10cc] type 0 class 0x000200
[    0.633414] pci 0000:00:19.0: reg 10: [mem 0xe0300000-0xe031ffff]
[    0.633803] pci 0000:00:19.0: reg 14: [mem 0xe0323000-0xe0323fff]
[    0.634186] pci 0000:00:19.0: reg 18: [io  0x2100-0x211f]
[    0.634597] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.634976] pci 0000:00:19.0: PME# disabled
[    0.635298] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    0.635727] pci 0000:00:1a.0: reg 20: [io  0x20e0-0x20ff]
[    0.636129] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
[    0.639521] pci 0000:00:1a.1: reg 20: [io  0x20c0-0x20df]
[    0.639923] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    0.640342] pci 0000:00:1a.2: reg 20: [io  0x20a0-0x20bf]
[    0.640757] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    0.641145] pci 0000:00:1a.7: reg 10: [mem 0xe0322000-0xe03223ff]
[    0.641608] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.641987] pci 0000:00:1a.7: PME# disabled
[    0.642315] pci 0000:00:1b.0: [8086:3a3e] type 0 class 0x000403
[    0.642708] pci 0000:00:1b.0: reg 10: [mem 0xf7f00000-0xf7f03fff 64bit]
[    0.643171] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.643553] pci 0000:00:1b.0: PME# disabled
[    0.643879] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    0.644316] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.644696] pci 0000:00:1c.0: PME# disabled
[    0.645023] pci 0000:00:1c.1: [8086:3a42] type 1 class 0x000604
[    0.645464] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.645841] pci 0000:00:1c.1: PME# disabled
[    0.646172] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    0.646616] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.646994] pci 0000:00:1c.4: PME# disabled
[    0.647326] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    0.647750] pci 0000:00:1d.0: reg 20: [io  0x2080-0x209f]
[    0.648152] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    0.648575] pci 0000:00:1d.1: reg 20: [io  0x2060-0x207f]
[    0.648980] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    0.649405] pci 0000:00:1d.2: reg 20: [io  0x2040-0x205f]
[    0.649817] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    0.650205] pci 0000:00:1d.7: reg 10: [mem 0xe0321000-0xe03213ff]
[    0.650668] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.651046] pci 0000:00:1d.7: PME# disabled
[    0.651373] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.651811] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    0.652276] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.652661] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.653209] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
[    0.653804] pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
[    0.654192] pci 0000:00:1f.2: reg 10: [io  0x2128-0x212f]
[    0.654552] pci 0000:00:1f.2: reg 14: [io  0x2134-0x2137]
[    0.654909] pci 0000:00:1f.2: reg 18: [io  0x2120-0x2127]
[    0.655265] pci 0000:00:1f.2: reg 1c: [io  0x2130-0x2133]
[    0.655625] pci 0000:00:1f.2: reg 20: [io  0x2020-0x203f]
[    0.655983] pci 0000:00:1f.2: reg 24: [mem 0xe0320000-0xe03207ff]
[    0.656398] pci 0000:00:1f.2: PME# supported from D3hot
[    0.656744] pci 0000:00:1f.2: PME# disabled
[    0.657065] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    0.657454] pci 0000:00:1f.3: reg 10: [mem 0xf7f04000-0xf7f040ff 64bit]
[    0.657873] pci 0000:00:1f.3: reg 20: [io  0x2000-0x201f]
[    0.658296] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.658705] pci 0000:02:00.0: [5333:9043] type 0 class 0x000300
[    0.659084] pci 0000:02:00.0: reg 10: [mem 0xe0200000-0xe027ffff]
[    0.659469] pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff pref]
[    0.659898] pci 0000:02:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.660312] pci 0000:02:00.0: supports D1 D2
[    0.660647] pci 0000:02:00.1: [5333:903f] type 0 class 0x000403
[    0.661026] pci 0000:02:00.1: reg 10: [mem 0xe0280000-0xe0283fff]
[    0.661473] pci 0000:02:00.1: supports D1 D2
[    0.661799] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.662145] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.662553] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.663150] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.663554] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.663955] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    0.664386] pci 0000:06:00.0: [11ab:6121] type 0 class 0x000101
[    0.664777] pci 0000:06:00.0: reg 10: [io  0x1018-0x101f]
[    0.665140] pci 0000:06:00.0: reg 14: [io  0x1024-0x1027]
[    0.665507] pci 0000:06:00.0: reg 18: [io  0x1010-0x1017]
[    0.665872] pci 0000:06:00.0: reg 1c: [io  0x1020-0x1023]
[    0.666237] pci 0000:06:00.0: reg 20: [io  0x1000-0x100f]
[    0.666604] pci 0000:06:00.0: reg 24: [mem 0xe0100000-0xe01003ff]
[    0.667042] pci 0000:06:00.0: supports D1
[    0.667343] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
[    0.667711] pci 0000:06:00.0: PME# disabled
[    0.668036] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.668385] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.668762] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.669208] pci 0000:07:03.0: [104c:8023] type 0 class 0x000c00
[    0.669598] pci 0000:07:03.0: reg 10: [mem 0xe0004000-0xe00047ff]
[    0.669983] pci 0000:07:03.0: reg 14: [mem 0xe0000000-0xe0003fff]
[    0.670434] pci 0000:07:03.0: supports D1 D2
[    0.670742] pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
[    0.671117] pci 0000:07:03.0: PME# disabled
[    0.671477] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.671892] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.672300] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.672858] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.673422] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.674007] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000cbfff] (subtractive decode)
[    0.674593] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    0.675179] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xf7ffffff] (subtractive decode)
[    0.675801] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.677077] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.677702] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
[    0.678170] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
[    0.678641] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
[    0.679106] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.679576] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.680052] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.680616]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
[    0.703889] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.704971] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.706051] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.707129] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.708214] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.709297] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.710373] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.711451] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.712768] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.713345] vgaarb: loaded
[    0.713595] vgaarb: bridge control possible 0000:02:00.0
[    0.714157] SCSI subsystem initialized
[    0.714621] libata version 3.00 loaded.
[    0.715188] usbcore: registered new interface driver usbfs
[    0.715606] usbcore: registered new interface driver hub
[    0.716026] usbcore: registered new device driver usb
[    0.716819] wmi: Mapper loaded
[    0.717153] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.717539] PCI: Using ACPI for IRQ routing
[    0.719416] PCI: Discovered peer bus 3f
[    0.719788] pci 0000:3f:00.0: [8086:2c41] type 0 class 0x000600
[    0.720198] pci 0000:3f:00.1: [8086:2c01] type 0 class 0x000600
[    0.720600] pci 0000:3f:02.0: [8086:2c10] type 0 class 0x000600
[    0.720996] pci 0000:3f:02.1: [8086:2c11] type 0 class 0x000600
[    0.721401] pci 0000:3f:03.0: [8086:2c18] type 0 class 0x000600
[    0.721796] pci 0000:3f:03.1: [8086:2c19] type 0 class 0x000600
[    0.722196] pci 0000:3f:03.4: [8086:2c1c] type 0 class 0x000600
[    0.722595] pci 0000:3f:04.0: [8086:2c20] type 0 class 0x000600
[    0.722991] pci 0000:3f:04.1: [8086:2c21] type 0 class 0x000600
[    0.723392] pci 0000:3f:04.2: [8086:2c22] type 0 class 0x000600
[    0.723788] pci 0000:3f:04.3: [8086:2c23] type 0 class 0x000600
[    0.724197] pci 0000:3f:05.0: [8086:2c28] type 0 class 0x000600
[    0.724593] pci 0000:3f:05.1: [8086:2c29] type 0 class 0x000600
[    0.724989] pci 0000:3f:05.2: [8086:2c2a] type 0 class 0x000600
[    0.725388] pci 0000:3f:05.3: [8086:2c2b] type 0 class 0x000600
[    0.725787] pci 0000:3f:06.0: [8086:2c30] type 0 class 0x000600
[    0.726187] pci 0000:3f:06.1: [8086:2c31] type 0 class 0x000600
[    0.726585] pci 0000:3f:06.2: [8086:2c32] type 0 class 0x000600
[    0.726980] pci 0000:3f:06.3: [8086:2c33] type 0 class 0x000600
[    0.728811] PCI: pci_cache_line_size set to 64 bytes
[    0.729383] reserve RAM buffer: 000000000009cc00 - 000000000009ffff 
[    0.729645] reserve RAM buffer: 00000000bcde3000 - 00000000bfffffff 
[    0.730064] reserve RAM buffer: 00000000bf6bd000 - 00000000bfffffff 
[    0.730487] reserve RAM buffer: 00000000bf714000 - 00000000bfffffff 
[    0.730905] reserve RAM buffer: 00000000bf7e7000 - 00000000bfffffff 
[    0.731326] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff 
[    0.760154] pnp: PnP ACPI init
[    0.760594] ACPI: bus type pnp registered
[    0.761505] pnp 00:00: [bus 00-3d]
[    0.761783] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.762088] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.762416] pnp 00:00: [io  0x0d00-0xffff window]
[    0.762740] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.763094] pnp 00:00: [mem 0x000c4000-0x000cbfff window]
[    0.763444] pnp 00:00: [mem 0xfed40000-0xfedfffff window]
[    0.763793] pnp 00:00: [mem 0xd0000000-0xf7ffffff window]
[    0.764150] pnp 00:00: [mem 0x00000000 window]
[    0.764608] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.765283] pnp 00:01: [io  0x0000-0x000f]
[    0.765586] pnp 00:01: [io  0x0081-0x0083]
[    0.765886] pnp 00:01: [io  0x0087]
[    0.766170] pnp 00:01: [io  0x0089-0x008b]
[    0.766472] pnp 00:01: [io  0x008f]
[    0.769718] pnp 00:01: [io  0x00c0-0x00df]
[    0.770023] pnp 00:01: [dma 4]
[    0.770381] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.770788] pnp 00:02: [io  0x0070-0x0071]
[    0.771098] pnp 00:02: [io  0x0074-0x0077]
[    0.771403] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.771971] pnp 00:02: [irq 8]
[    0.772327] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.772738] pnp 00:03: [io  0x00f0]
[    0.773024] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.773594] pnp 00:03: [irq 13]
[    0.773955] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.774366] pnp 00:04: [io  0x0061]
[    0.774747] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.775161] pnp 00:05: [io  0x0500-0x053f]
[    0.775463] pnp 00:05: [io  0x0400-0x047f]
[    0.775764] pnp 00:05: [io  0x0092]
[    0.776047] pnp 00:05: [io  0x0680-0x06ff]
[    0.776349] pnp 00:05: [io  0x0010-0x001f]
[    0.776650] pnp 00:05: [io  0x0072-0x0073]
[    0.776954] pnp 00:05: [io  0x0080]
[    0.777234] pnp 00:05: [io  0x0084-0x0086]
[    0.777535] pnp 00:05: [io  0x0088]
[    0.777813] pnp 00:05: [io  0x008c-0x008e]
[    0.778118] pnp 00:05: [io  0x0090-0x009f]
[    0.778597] system 00:05: [io  0x0500-0x053f] has been reserved
[    0.778976] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.779347] system 00:05: [io  0x0680-0x06ff] has been reserved
[    0.779718] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.780200] pnp 00:06: [io  0x0060]
[    0.780480] pnp 00:06: [io  0x0064]
[    0.780928] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.781875] pnp 00:07: [mem 0xfec00000-0xfec000ff]
[    0.782318] pnp 00:07: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.782844] pnp: PnP ACPI: found 8 devices
[    0.783151] ACPI: ACPI bus type pnp unregistered
[    0.794368] Switching to clocksource acpi_pm
[    0.794809] pci 0000:02:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.795438] PCI: max bus depth: 1 pci_try_num: 2
[    0.795852] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.796205] pci 0000:02:00.0: BAR 6: assigned [mem 0xe0290000-0xe029ffff pref]
[    0.796738] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.797092] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.797494] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.798062] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.798413] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.798778] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    0.799132] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.799476] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.799872] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.800280] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    0.800627] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.801056] IOAPIC[0]: Set routing entry (8-16 -> 0x29 -> IRQ 16 Mode:1 Active:1 Dest:0)
[    0.801626] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.802038] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.802441] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.802863] IOAPIC[0]: Set routing entry (8-17 -> 0x41 -> IRQ 17 Mode:1 Active:1 Dest:0)
[    0.803432] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.803855] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.804260] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.804664] pci 0000:00:1e.0: setting latency timer to 64
[    0.805024] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.805380] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.805736] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.806129] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.806511] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.806906] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.807287] pci_bus 0000:02: resource 1 [mem 0xe0200000-0xe02fffff]
[    0.807668] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.808211] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    0.808567] pci_bus 0000:06: resource 1 [mem 0xe0100000-0xe01fffff]
[    0.808961] pci_bus 0000:07: resource 1 [mem 0xe0000000-0xe00fffff]
[    0.809342] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.809696] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.810058] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.810439] pci_bus 0000:07: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.810833] pci_bus 0000:07: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.811214] pci_bus 0000:07: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.811594] pci_bus 0000:3f: resource 0 [io  0x0000-0xffff]
[    0.811959] pci_bus 0000:3f: resource 1 [mem 0x00000000-0xfffffffff]
[    0.812401] NET: Registered protocol family 2
[    0.813027] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.815466] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.819182] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    0.822801] TCP: Hash tables configured (established 524288 bind 65536)
[    0.823213] TCP reno registered
[    0.823545] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    0.824202] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    0.824966] NET: Registered protocol family 1
[    0.825489] RPC: Registered named UNIX socket transport module.
[    0.825874] RPC: Registered udp transport module.
[    0.826197] RPC: Registered tcp transport module.
[    0.826520] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.826959] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.827350] pci 0000:00:1a.0: Performing full reset
[    0.827708] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.828099] pci 0000:00:1a.1: Performing full reset
[    0.828445] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.828845] pci 0000:00:1a.2: Performing full reset
[    0.829344] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.829756] pci 0000:00:1d.0: Performing full reset
[    0.830108] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.830499] pci 0000:00:1d.1: Performing full reset
[    0.830856] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.831247] pci 0000:00:1d.2: Performing full reset
[    0.831737] pci 0000:02:00.0: Boot video device
[    0.832112] PCI: CLS 64 bytes, default 64
[    0.836341] Machine check injector initialized
[    0.838593] microcode: CPU0 sig=0x106a4, pf=0x2, revision=0x6
[    0.838972] microcode: CPU1 sig=0x106a4, pf=0x2, revision=0x6
[    0.839342] microcode: CPU2 sig=0x106a4, pf=0x2, revision=0x6
[    0.839720] microcode: CPU3 sig=0x106a4, pf=0x2, revision=0x6
[    0.840090] microcode: CPU4 sig=0x106a4, pf=0x2, revision=0x6
[    0.840463] microcode: CPU5 sig=0x106a4, pf=0x2, revision=0x6
[    0.840842] microcode: CPU6 sig=0x106a4, pf=0x2, revision=0x6
[    0.841215] microcode: CPU7 sig=0x106a4, pf=0x2, revision=0x6
[    0.841695] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.842764] audit: initializing netlink socket (disabled)
[    0.843138] type=2000 audit(1320193751.595:1): initialized
[    0.877553] Testing tracer function: .. no entries found ..FAILED!
[    1.014130] Testing tracer irqsoff: 
[    1.046033] failed to start irqsoff tracer
[    1.046605] .. no entries found ..FAILED!
[    1.061983] Testing tracer wakeup: 
[    1.093885] failed to start wakeup tracer
[    1.395956] .. no entries found ..FAILED!
[    1.408910] Testing tracer function_graph: 
[    1.424919] Failed to init function_graph tracer, init returned -19
[    1.425457] FAILED!
[    1.433188] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.445891] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.447275] fuse init (API version 7.17)
[    1.447837] kworker/u:0 used greatest stack depth: 5184 bytes left
[    1.448247] JFS: nTxBlock = 8192, nTxLock = 65536
[    1.452309] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.454995] NILFS version 2 loaded
[    1.456326] Btrfs loaded
[    1.456576] msgmni has been set to 5883
[    1.458088] async_tx: api initialized (async)
[    1.458607] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.459218] io scheduler noop registered
[    1.459514] io scheduler deadline registered
[    1.459982] io scheduler cfq registered (default)
[    1.460810] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    1.461337] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    1.461885] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    1.462596] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.463424] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    1.464027] ACPI: Sleep Button [SLPB]
[    1.464459] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.465017] ACPI: Power Button [PWRF]
[    1.466067] ACPI: acpi_idle registered with cpuidle
[    1.466822] Monitor-Mwait will be used to enter C-1 state
[    1.467225] Monitor-Mwait will be used to enter C-3 state
[    1.475018] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.519702] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.533596] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    1.589626] Initializing Nozomi driver 2.1d
[    1.590452] Non-volatile memory driver v1.3
[    1.591226] Linux agpgart interface v0.103
[    1.591624] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.592223] Hangcheck: Using getrawmonotonic().
[    1.592615] [drm] Initialized drm 1.1.0 20060810
[    1.592937] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    1.831685] Refined TSC clocksource calibration: 3200.113 MHz.
[    1.832054] Switching to clocksource tsc
[    4.603018] floppy0: no floppy controllers found
[    4.603490] ------------[ cut here ]------------
[    4.603814] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.604403] Hardware name:         
[    4.604682] VFS: do_fd_request called on non-open device
[    4.605027] Modules linked in:
[    4.605324] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #889
[    4.605904] Call Trace:
[    4.606148]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.606521]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.606884]  [<ffffffff813eb45a>] ? blk_throtl_drain+0xf6/0x105
[    4.607255]  [<ffffffff8198437e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.607633]  [<ffffffff8151ae8d>] do_fd_request+0x37/0xaa
[    4.607985]  [<ffffffff813d8b66>] __blk_run_queue+0x1e/0x20
[    4.608341]  [<ffffffff813de06e>] blk_drain_queue+0x41/0x7a
[    4.608697]  [<ffffffff813de1cc>] blk_cleanup_queue+0x125/0x184
[    4.609067]  [<ffffffff82141483>] floppy_init+0xd9c/0xdc2
[    4.609416]  [<ffffffff821406e7>] ? daring+0x65/0x65
[    4.609751]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.610112]  [<ffffffff82111c16>] kernel_init+0xcb/0x14f
[    4.610459]  [<ffffffff8198d1c4>] kernel_thread_helper+0x4/0x10
[    4.610828]  [<ffffffff819845f4>] ? retint_restore_args+0x13/0x13
[    4.611203]  [<ffffffff82111b4b>] ? start_kernel+0x390/0x390
[    4.611563]  [<ffffffff8198d1c0>] ? gs_change+0x13/0x13
[    4.611906] ---[ end trace 4eaa2a86a8e2da24 ]---
[    4.612357] ------------[ cut here ]------------
[    4.612679] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.613268] Hardware name:         
[    4.613546] VFS: do_fd_request called on non-open device
[    4.613892] Modules linked in:
[    4.614189] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #889
[    4.614770] Call Trace:
[    4.615012]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.615383]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.615746]  [<ffffffff813eb45a>] ? blk_throtl_drain+0xf6/0x105
[    4.616116]  [<ffffffff8198437e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.616494]  [<ffffffff8151ae8d>] do_fd_request+0x37/0xaa
[    4.616844]  [<ffffffff813d8b66>] __blk_run_queue+0x1e/0x20
[    4.617200]  [<ffffffff813de06e>] blk_drain_queue+0x41/0x7a
[    4.617557]  [<ffffffff813de1cc>] blk_cleanup_queue+0x125/0x184
[    4.617926]  [<ffffffff82141483>] floppy_init+0xd9c/0xdc2
[    4.618276]  [<ffffffff821406e7>] ? daring+0x65/0x65
[    4.618610]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.618970]  [<ffffffff82111c16>] kernel_init+0xcb/0x14f
[    4.619317]  [<ffffffff8198d1c4>] kernel_thread_helper+0x4/0x10
[    4.619687]  [<ffffffff819845f4>] ? retint_restore_args+0x13/0x13
[    4.620063]  [<ffffffff82111b4b>] ? start_kernel+0x390/0x390
[    4.620423]  [<ffffffff8198d1c0>] ? gs_change+0x13/0x13
[    4.620766] ---[ end trace 4eaa2a86a8e2da25 ]---
[    4.621140] ------------[ cut here ]------------
[    4.621462] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.622051] Hardware name:         
[    4.622329] VFS: do_fd_request called on non-open device
[    4.622675] Modules linked in:
[    4.622971] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #889
[    4.623551] Call Trace:
[    4.623792]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.624164]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.624526]  [<ffffffff813eb45a>] ? blk_throtl_drain+0xf6/0x105
[    4.624895]  [<ffffffff8198437e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.625274]  [<ffffffff8151ae8d>] do_fd_request+0x37/0xaa
[    4.625624]  [<ffffffff813d8b66>] __blk_run_queue+0x1e/0x20
[    4.625981]  [<ffffffff813de06e>] blk_drain_queue+0x41/0x7a
[    4.626338]  [<ffffffff813de1cc>] blk_cleanup_queue+0x125/0x184
[    4.626708]  [<ffffffff82141483>] floppy_init+0xd9c/0xdc2
[    4.627057]  [<ffffffff821406e7>] ? daring+0x65/0x65
[    4.627392]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.627752]  [<ffffffff82111c16>] kernel_init+0xcb/0x14f
[    4.628099]  [<ffffffff8198d1c4>] kernel_thread_helper+0x4/0x10
[    4.628468]  [<ffffffff819845f4>] ? retint_restore_args+0x13/0x13
[    4.628843]  [<ffffffff82111b4b>] ? start_kernel+0x390/0x390
[    4.629202]  [<ffffffff8198d1c0>] ? gs_change+0x13/0x13
[    4.629545] ---[ end trace 4eaa2a86a8e2da26 ]---
[    4.629922] ------------[ cut here ]------------
[    4.630244] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.630831] Hardware name:         
[    4.631110] VFS: do_fd_request called on non-open device
[    4.631455] Modules linked in:
[    4.631752] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #889
[    4.632334] Call Trace:
[    4.632575]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.632948]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.633311]  [<ffffffff813eb45a>] ? blk_throtl_drain+0xf6/0x105
[    4.633679]  [<ffffffff8198437e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.634059]  [<ffffffff8151ae8d>] do_fd_request+0x37/0xaa
[    4.634409]  [<ffffffff813d8b66>] __blk_run_queue+0x1e/0x20
[    4.634765]  [<ffffffff813de06e>] blk_drain_queue+0x41/0x7a
[    4.635122]  [<ffffffff813de1cc>] blk_cleanup_queue+0x125/0x184
[    4.635491]  [<ffffffff82141483>] floppy_init+0xd9c/0xdc2
[    4.635841]  [<ffffffff821406e7>] ? daring+0x65/0x65
[    4.636176]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.636535]  [<ffffffff82111c16>] kernel_init+0xcb/0x14f
[    4.636882]  [<ffffffff8198d1c4>] kernel_thread_helper+0x4/0x10
[    4.637250]  [<ffffffff819845f4>] ? retint_restore_args+0x13/0x13
[    4.637625]  [<ffffffff82111b4b>] ? start_kernel+0x390/0x390
[    4.637984]  [<ffffffff8198d1c0>] ? gs_change+0x13/0x13
[    4.638326] ---[ end trace 4eaa2a86a8e2da27 ]---
[    4.638693] ------------[ cut here ]------------
[    4.639015] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.639603] Hardware name:         
[    4.639882] VFS: do_fd_request called on non-open device
[    4.640227] Modules linked in:
[    4.640525] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #889
[    4.641107] Call Trace:
[    4.641349]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.641721]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.642084]  [<ffffffff813eb45a>] ? blk_throtl_drain+0xf6/0x105
[    4.642454]  [<ffffffff8198437e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.642833]  [<ffffffff8151ae8d>] do_fd_request+0x37/0xaa
[    4.643184]  [<ffffffff813d8b66>] __blk_run_queue+0x1e/0x20
[    4.643541]  [<ffffffff813de06e>] blk_drain_queue+0x41/0x7a
[    4.643898]  [<ffffffff813de1cc>] blk_cleanup_queue+0x125/0x184
[    4.644267]  [<ffffffff82141483>] floppy_init+0xd9c/0xdc2
[    4.644618]  [<ffffffff821406e7>] ? daring+0x65/0x65
[    4.644952]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.645312]  [<ffffffff82111c16>] kernel_init+0xcb/0x14f
[    4.645659]  [<ffffffff8198d1c4>] kernel_thread_helper+0x4/0x10
[    4.646029]  [<ffffffff819845f4>] ? retint_restore_args+0x13/0x13
[    4.646405]  [<ffffffff82111b4b>] ? start_kernel+0x390/0x390
[    4.646764]  [<ffffffff8198d1c0>] ? gs_change+0x13/0x13
[    4.647106] ---[ end trace 4eaa2a86a8e2da28 ]---
[    4.647474] ------------[ cut here ]------------
[    4.647795] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.648383] Hardware name:         
[    4.648662] VFS: do_fd_request called on non-open device
[    4.649008] Modules linked in:
[    4.649304] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #889
[    4.649885] Call Trace:
[    4.650127]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.650499]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.650862]  [<ffffffff813eb45a>] ? blk_throtl_drain+0xf6/0x105
[    4.651230]  [<ffffffff8198437e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.651608]  [<ffffffff8151ae8d>] do_fd_request+0x37/0xaa
[    4.651958]  [<ffffffff813d8b66>] __blk_run_queue+0x1e/0x20
[    4.652313]  [<ffffffff813de06e>] blk_drain_queue+0x41/0x7a
[    4.652669]  [<ffffffff813de1cc>] blk_cleanup_queue+0x125/0x184
[    4.653038]  [<ffffffff82141483>] floppy_init+0xd9c/0xdc2
[    4.653388]  [<ffffffff821406e7>] ? daring+0x65/0x65
[    4.653723]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.654083]  [<ffffffff82111c16>] kernel_init+0xcb/0x14f
[    4.654430]  [<ffffffff8198d1c4>] kernel_thread_helper+0x4/0x10
[    4.654800]  [<ffffffff819845f4>] ? retint_restore_args+0x13/0x13
[    4.655176]  [<ffffffff82111b4b>] ? start_kernel+0x390/0x390
[    4.655536]  [<ffffffff8198d1c0>] ? gs_change+0x13/0x13
[    4.655879] ---[ end trace 4eaa2a86a8e2da29 ]---
[    4.656248] ------------[ cut here ]------------
[    4.656570] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.657159] Hardware name:         
[    4.657438] VFS: do_fd_request called on non-open device
[    4.657783] Modules linked in:
[    4.658081] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #889
[    4.658663] Call Trace:
[    4.658904]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.659277]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.659640]  [<ffffffff813eb45a>] ? blk_throtl_drain+0xf6/0x105
[    4.660009]  [<ffffffff8198437e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.660389]  [<ffffffff8151ae8d>] do_fd_request+0x37/0xaa
[    4.660739]  [<ffffffff813d8b66>] __blk_run_queue+0x1e/0x20
[    4.661096]  [<ffffffff813de06e>] blk_drain_queue+0x41/0x7a
[    4.661454]  [<ffffffff813de1cc>] blk_cleanup_queue+0x125/0x184
[    4.661823]  [<ffffffff82141483>] floppy_init+0xd9c/0xdc2
[    4.662173]  [<ffffffff821406e7>] ? daring+0x65/0x65
[    4.662507]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.665835]  [<ffffffff82111c16>] kernel_init+0xcb/0x14f
[    4.666181]  [<ffffffff8198d1c4>] kernel_thread_helper+0x4/0x10
[    4.666551]  [<ffffffff819845f4>] ? retint_restore_args+0x13/0x13
[    4.666926]  [<ffffffff82111b4b>] ? start_kernel+0x390/0x390
[    4.667285]  [<ffffffff8198d1c0>] ? gs_change+0x13/0x13
[    4.667627] ---[ end trace 4eaa2a86a8e2da2a ]---
[    4.667995] ------------[ cut here ]------------
[    4.668316] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.668904] Hardware name:         
[    4.669183] VFS: do_fd_request called on non-open device
[    4.669529] Modules linked in:
[    4.669825] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #889
[    4.670407] Call Trace:
[    4.670649]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.671022]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.671384]  [<ffffffff813eb45a>] ? blk_throtl_drain+0xf6/0x105
[    4.671753]  [<ffffffff8198437e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.672131]  [<ffffffff8151ae8d>] do_fd_request+0x37/0xaa
[    4.672481]  [<ffffffff813d8b66>] __blk_run_queue+0x1e/0x20
[    4.672837]  [<ffffffff813de06e>] blk_drain_queue+0x41/0x7a
[    4.673194]  [<ffffffff813de1cc>] blk_cleanup_queue+0x125/0x184
[    4.673563]  [<ffffffff82141483>] floppy_init+0xd9c/0xdc2
[    4.673913]  [<ffffffff821406e7>] ? daring+0x65/0x65
[    4.674247]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.674606]  [<ffffffff82111c16>] kernel_init+0xcb/0x14f
[    4.674952]  [<ffffffff8198d1c4>] kernel_thread_helper+0x4/0x10
[    4.675321]  [<ffffffff819845f4>] ? retint_restore_args+0x13/0x13
[    4.675697]  [<ffffffff82111b4b>] ? start_kernel+0x390/0x390
[    4.676056]  [<ffffffff8198d1c0>] ? gs_change+0x13/0x13
[    4.676399] ---[ end trace 4eaa2a86a8e2da2b ]---
[    4.680050] brd: module loaded
[    4.682129] loop: module loaded
[    4.682902] Loading iSCSI transport class v2.0-870.
[    4.683870] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    4.684226] Detecting Adaptec I2O RAID controllers...
[    4.684748] Adaptec aacraid driver 1.1-7[28000]-ms
[    4.685666] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.686259] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.07-k.
[    4.686992] iscsi: registered transport (qla4xxx)
[    4.687394] QLogic iSCSI HBA Driver
[    4.687762] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    4.688375] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    4.688868] megasas: 00.00.06.12-rc1 Wed. Oct. 5 17:00:00 PDT 2011
[    4.689342] mpt2sas version 09.100.00.01 loaded
[    4.690051] ahci 0000:00:1f.2: version 3.0
[    4.690383] IOAPIC[0]: Set routing entry (8-19 -> 0x61 -> IRQ 19 Mode:1 Active:1 Dest:0)
[    4.690957] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    4.691406] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    4.691820] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    4.692392] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    4.692959] ahci 0000:00:1f.2: setting latency timer to 64
[    4.704081] scsi0 : ahci
[    4.704524] scsi1 : ahci
[    4.704943] scsi2 : ahci
[    4.705356] scsi3 : ahci
[    4.705772] scsi4 : ahci
[    4.706184] scsi5 : ahci
[    4.706864] ata1: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320100 irq 43
[    4.707407] ata2: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320180 irq 43
[    4.707952] ata3: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320200 irq 43
[    4.708492] ata4: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320280 irq 43
[    4.709035] ata5: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320300 irq 43
[    4.709574] ata6: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320380 irq 43
[    4.710148] ahci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.710563] ahci 0000:06:00.0: Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.
[    4.711227] ahci 0000:06:00.0: controller can't do NCQ, turning off CAP_NCQ
[    4.711634] ahci 0000:06:00.0: controller can't do PMP, turning off CAP_PMP
[    4.712044] ahci 0000:06:00.0: masking port_map 0x7 -> 0x3
[    4.712412] ahci: SSS flag set, parallel bus scan disabled
[    4.712806] ahci 0000:06:00.0: AHCI 0001.0000 32 slots 3 ports 3 Gbps 0x3 impl IDE mode
[    4.713369] ahci 0000:06:00.0: flags: 64bit stag led slum part 
[    4.714608] scsi6 : ahci
[    4.715037] scsi7 : ahci
[    4.715453] scsi8 : ahci
[    4.715847] ata7: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100100 irq 16
[    4.716390] ata8: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100180 irq 16
[    4.716933] ata9: DUMMY
[    4.720380] tun: Universal TUN/TAP device driver, 1.6
[    4.720723] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.721348] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    4.721702] Copyright (c) 2007 Atheros Corporation.
[    4.722390] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.7 (July 20, 2011)
[    4.723080] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.723456] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.723908] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    4.724320] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.724778] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    4.725144] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    4.725542] IOAPIC[0]: Set routing entry (8-20 -> 0x71 -> IRQ 20 Mode:1 Active:1 Dest:0)
[    4.726117] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.726531] e1000e 0000:00:19.0: setting latency timer to 64
[    4.727003] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    4.916594] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:c0:79:88:54
[    4.917165] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.917605] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
[    4.918105] Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[    4.918500] Copyright (c) 2007-2011 Intel Corporation.
[    4.918931] Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[    4.919470] Copyright (c) 2009 - 2011 Intel Corporation.
[    4.919908] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.6.7-k
[    4.920463] ixgbe: Copyright (c) 1999-2011 Intel Corporation.
[    4.920917] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    4.921335] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    4.921873] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    4.922415] sky2: driver version 1.29
[    4.923204] usbcore: registered new interface driver catc
[    4.923554] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[    4.923981] usbcore: registered new interface driver kaweth
[    4.924342] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    4.924946] usbcore: registered new interface driver pegasus
[    4.925310] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[    4.925778] usbcore: registered new interface driver rtl8150
[    4.926208] usbcore: registered new interface driver asix
[    4.926617] usbcore: registered new interface driver cdc_ether
[    4.927047] usbcore: registered new interface driver cdc_eem
[    4.927465] usbcore: registered new interface driver dm9601
[    4.927886] usbcore: registered new interface driver smsc75xx
[    4.928324] usbcore: registered new interface driver smsc95xx
[    4.928745] usbcore: registered new interface driver gl620a
[    4.929164] usbcore: registered new interface driver net1080
[    4.929583] usbcore: registered new interface driver plusb
[    4.930012] usbcore: registered new interface driver rndis_host
[    4.930441] usbcore: registered new interface driver cdc_subset
[    4.930872] usbcore: registered new interface driver zaurus
[    4.931301] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    4.931904] usbcore: registered new interface driver int51x1
[    4.932268] cdc_ncm: 04-Aug-2011
[    4.932599] usbcore: registered new interface driver cdc_ncm
[    4.932963] Fusion MPT base driver 3.04.20
[    4.933264] Copyright (c) 1999-2008 LSI Corporation
[    4.933601] Fusion MPT SPI Host driver 3.04.20
[    4.934013] Fusion MPT FC Host driver 3.04.20
[    4.934417] Fusion MPT SAS Host driver 3.04.20
[    4.934828] Fusion MPT misc device (ioctl) driver 3.04.20
[    4.935270] mptctl: Registered with Fusion MPT base driver
[    4.935625] mptctl: /dev/mptctl @ (major,minor=10,220)
[    4.936078] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.936470] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    4.936878] IOAPIC[0]: Set routing entry (8-18 -> 0x81 -> IRQ 18 Mode:1 Active:1 Dest:0)
[    4.937452] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.937877] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.938247] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.938651] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file 'devices'
[    4.939206] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.939624] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.940174] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.940774] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.941427] ehci_hcd 0000:00:1a.7: debug port 1
[    4.941747] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.946231] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.949600] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.949988] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0322000
[    4.950349] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.954807] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.960893] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.961326] usb usb1: default language 0x0409
[    4.961646] usb usb1: udev 1, busnum 1, minor = 0
[    4.961975] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.962375] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.962912] usb usb1: Product: EHCI Host Controller
[    4.963243] usb usb1: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ ehci_hcd
[    4.963791] usb usb1: SerialNumber: 0000:00:1a.7
[    4.964274] usb usb1: usb_probe_device
[    4.964564] usb usb1: configuration #1 chosen from 1 choice
[    4.964950] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.965403] hub 1-0:1.0: usb_probe_interface
[    4.965712] hub 1-0:1.0: usb_probe_interface - got id
[    4.966054] hub 1-0:1.0: USB hub found
[    4.966348] hub 1-0:1.0: 6 ports detected
[    4.966647] hub 1-0:1.0: standalone hub
[    4.966942] hub 1-0:1.0: no power switching (usb 1.0)
[    4.967278] hub 1-0:1.0: individual port over-current protection
[    4.967649] hub 1-0:1.0: power on to power good time: 20ms
[    4.968020] hub 1-0:1.0: local power source is good
[    4.968351] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.968811] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.969345] IOAPIC[0]: Set routing entry (8-23 -> 0x89 -> IRQ 23 Mode:1 Active:1 Dest:0)
[    4.969920] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.970343] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.970710] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.971062] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    4.971473] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    4.972022] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.972621] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.973259] ehci_hcd 0000:00:1d.7: debug port 1
[    4.973578] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.978053] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.978453] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.978837] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0321000
[    4.979197] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.983649] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.989800] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.990202] usb usb2: default language 0x0409
[    4.990523] usb usb2: udev 1, busnum 2, minor = 128
[    4.990858] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.991260] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.991797] usb usb2: Product: EHCI Host Controller
[    4.992127] usb usb2: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ ehci_hcd
[    4.992678] usb usb2: SerialNumber: 0000:00:1d.7
[    4.993149] usb usb2: usb_probe_device
[    4.993439] usb usb2: configuration #1 chosen from 1 choice
[    4.993806] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.994250] hub 2-0:1.0: usb_probe_interface
[    4.994559] hub 2-0:1.0: usb_probe_interface - got id
[    4.994900] hub 2-0:1.0: USB hub found
[    4.995194] hub 2-0:1.0: 6 ports detected
[    4.995492] hub 2-0:1.0: standalone hub
[    4.995787] hub 2-0:1.0: no power switching (usb 1.0)
[    4.996123] hub 2-0:1.0: individual port over-current protection
[    4.996495] hub 2-0:1.0: power on to power good time: 20ms
[    4.996856] hub 2-0:1.0: local power source is good
[    4.997187] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.997635] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.998215] uhci_hcd: USB Universal Host Controller Interface driver
[    4.998634] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.999057] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.999423] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.999777] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '003'
[    5.000188] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    5.000732] uhci_hcd 0000:00:1a.0: detected 2 ports
[    5.001069] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    5.001466] uhci_hcd 0000:00:1a.0: Performing full reset
[    5.001828] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    5.002195] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020e0
[    5.002605] usb usb3: default language 0x0409
[    5.002929] usb usb3: udev 1, busnum 3, minor = 256
[    5.003260] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.003660] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.004197] usb usb3: Product: UHCI Host Controller
[    5.004528] usb usb3: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.005079] usb usb3: SerialNumber: 0000:00:1a.0
[    5.005548] usb usb3: usb_probe_device
[    5.005843] usb usb3: configuration #1 chosen from 1 choice
[    5.006206] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    5.006644] hub 3-0:1.0: usb_probe_interface
[    5.006956] hub 3-0:1.0: usb_probe_interface - got id
[    5.007292] hub 3-0:1.0: USB hub found
[    5.007585] hub 3-0:1.0: 2 ports detected
[    5.007886] hub 3-0:1.0: standalone hub
[    5.008177] hub 3-0:1.0: no power switching (usb 1.0)
[    5.008514] hub 3-0:1.0: individual port over-current protection
[    5.008891] hub 3-0:1.0: power on to power good time: 2ms
[    5.009246] hub 3-0:1.0: local power source is good
[    5.009576] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    5.010007] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.010472] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    5.010909] IOAPIC[0]: Set routing entry (8-21 -> 0x91 -> IRQ 21 Mode:1 Active:1 Dest:0)
[    5.011479] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    5.011903] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.012270] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.012618] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[    5.013034] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    5.013580] uhci_hcd 0000:00:1a.1: detected 2 ports
[    5.013732] ata5: SATA link down (SStatus 0 SControl 300)
[    5.013773] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.013808] ata4: SATA link down (SStatus 0 SControl 300)
[    5.013845] ata3: SATA link down (SStatus 0 SControl 300)
[    5.013882] ata6: SATA link down (SStatus 0 SControl 300)
[    5.015689] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    5.016090] uhci_hcd 0000:00:1a.1: Performing full reset
[    5.016447] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    5.016832] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020c0
[    5.017231] usb usb4: default language 0x0409
[    5.017550] usb usb4: udev 1, busnum 4, minor = 384
[    5.017883] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.018284] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.018820] usb usb4: Product: UHCI Host Controller
[    5.019150] usb usb4: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.019701] usb usb4: SerialNumber: 0000:00:1a.1
[    5.020171] usb usb4: usb_probe_device
[    5.020462] usb usb4: configuration #1 chosen from 1 choice
[    5.020729] ata7: SATA link down (SStatus 0 SControl 300)
[    5.021194] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    5.021634] hub 4-0:1.0: usb_probe_interface
[    5.021947] hub 4-0:1.0: usb_probe_interface - got id
[    5.022283] hub 4-0:1.0: USB hub found
[    5.022575] hub 4-0:1.0: 2 ports detected
[    5.022876] hub 4-0:1.0: standalone hub
[    5.023168] hub 4-0:1.0: no power switching (usb 1.0)
[    5.023503] hub 4-0:1.0: individual port over-current protection
[    5.023876] hub 4-0:1.0: power on to power good time: 2ms
[    5.024230] hub 4-0:1.0: local power source is good
[    5.024559] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    5.024994] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.025452] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    5.025885] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    5.026303] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.026673] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.027021] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '005'
[    5.027433] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    5.027981] uhci_hcd 0000:00:1a.2: detected 2 ports
[    5.028314] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    5.028715] uhci_hcd 0000:00:1a.2: Performing full reset
[    5.029072] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    5.029457] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000020a0
[    5.029861] usb usb5: default language 0x0409
[    5.030181] usb usb5: udev 1, busnum 5, minor = 512
[    5.030512] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.030916] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.031450] usb usb5: Product: UHCI Host Controller
[    5.031783] usb usb5: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.032333] usb usb5: SerialNumber: 0000:00:1a.2
[    5.032816] usb usb5: usb_probe_device
[    5.033106] usb usb5: configuration #1 chosen from 1 choice
[    5.033468] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    5.033915] hub 5-0:1.0: usb_probe_interface
[    5.034225] hub 5-0:1.0: usb_probe_interface - got id
[    5.037532] hub 5-0:1.0: USB hub found
[    5.037828] hub 5-0:1.0: 2 ports detected
[    5.038126] hub 5-0:1.0: standalone hub
[    5.038417] hub 5-0:1.0: no power switching (usb 1.0)
[    5.038756] hub 5-0:1.0: individual port over-current protection
[    5.039128] hub 5-0:1.0: power on to power good time: 2ms
[    5.039483] hub 5-0:1.0: local power source is good
[    5.039815] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    5.040243] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.040704] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    5.041134] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.041552] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.041922] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.042271] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '006'
[    5.042685] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    5.043230] uhci_hcd 0000:00:1d.0: detected 2 ports
[    5.043562] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    5.043961] uhci_hcd 0000:00:1d.0: Performing full reset
[    5.044319] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    5.044688] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
[    5.045086] usb usb6: default language 0x0409
[    5.045405] usb usb6: udev 1, busnum 6, minor = 640
[    5.045739] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.046139] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.046674] usb usb6: Product: UHCI Host Controller
[    5.047005] usb usb6: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.047552] usb usb6: SerialNumber: 0000:00:1d.0
[    5.048018] usb usb6: usb_probe_device
[    5.048308] usb usb6: configuration #1 chosen from 1 choice
[    5.048675] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    5.049117] hub 6-0:1.0: usb_probe_interface
[    5.049425] hub 6-0:1.0: usb_probe_interface - got id
[    5.049765] hub 6-0:1.0: USB hub found
[    5.050058] hub 6-0:1.0: 2 ports detected
[    5.050355] hub 6-0:1.0: standalone hub
[    5.050649] hub 6-0:1.0: no power switching (usb 1.0)
[    5.050984] hub 6-0:1.0: individual port over-current protection
[    5.051355] hub 6-0:1.0: power on to power good time: 2ms
[    5.051711] hub 6-0:1.0: local power source is good
[    5.052042] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    5.052468] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.052942] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    5.053359] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.053780] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.054147] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.054496] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '007'
[    5.054927] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    5.055473] uhci_hcd 0000:00:1d.1: detected 2 ports
[    5.055810] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    5.056207] uhci_hcd 0000:00:1d.1: Performing full reset
[    5.056565] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    5.056598] ata1.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[    5.056600] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.057687] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
[    5.058087] usb usb7: default language 0x0409
[    5.058407] usb usb7: udev 1, busnum 7, minor = 768
[    5.058741] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    5.059142] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.059677] usb usb7: Product: UHCI Host Controller
[    5.060008] usb usb7: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.060561] usb usb7: SerialNumber: 0000:00:1d.1
[    5.061031] usb usb7: usb_probe_device
[    5.061322] usb usb7: configuration #1 chosen from 1 choice
[    5.061689] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    5.062129] hub 7-0:1.0: usb_probe_interface
[    5.062438] hub 7-0:1.0: usb_probe_interface - got id
[    5.062778] hub 7-0:1.0: USB hub found
[    5.063071] hub 7-0:1.0: 2 ports detected
[    5.063370] hub 7-0:1.0: standalone hub
[    5.063664] hub 7-0:1.0: no power switching (usb 1.0)
[    5.064000] hub 7-0:1.0: individual port over-current protection
[    5.064370] hub 7-0:1.0: power on to power good time: 2ms
[    5.064727] hub 7-0:1.0: local power source is good
[    5.065057] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    5.065484] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.065959] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    5.066377] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.066797] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.067164] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.067512] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '008'
[    5.067950] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    5.068549] hub 1-0:1.0: port 1: status 0501 change 0001
[    5.068562] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    5.068569] uhci_hcd 0000:00:1d.2: detected 2 ports
[    5.068574] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    5.068575] uhci_hcd 0000:00:1d.2: Performing full reset
[    5.068589] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    5.068596] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    5.068649] usb usb8: default language 0x0409
[    5.068661] usb usb8: udev 1, busnum 8, minor = 896
[    5.068663] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    5.068666] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.068667] usb usb8: Product: UHCI Host Controller
[    5.068669] usb usb8: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.068670] usb usb8: SerialNumber: 0000:00:1d.2
[    5.068853] usb usb8: usb_probe_device
[    5.068855] usb usb8: configuration #1 chosen from 1 choice
[    5.068869] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    5.068959] hub 8-0:1.0: usb_probe_interface
[    5.068961] hub 8-0:1.0: usb_probe_interface - got id
[    5.068962] hub 8-0:1.0: USB hub found
[    5.068969] hub 8-0:1.0: 2 ports detected
[    5.068970] hub 8-0:1.0: standalone hub
[    5.068971] hub 8-0:1.0: no power switching (usb 1.0)
[    5.068972] hub 8-0:1.0: individual port over-current protection
[    5.068974] hub 8-0:1.0: power on to power good time: 2ms
[    5.068982] hub 8-0:1.0: local power source is good
[    5.068983] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    5.069019] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.069093] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    5.069224] Initializing USB Mass Storage driver...
[    5.069339] usbcore: registered new interface driver usb-storage
[    5.069341] USB Mass Storage support registered.
[    5.069475] usbcore: registered new interface driver libusual
[    5.069566] usbcore: registered new interface driver ums-alauda
[    5.069646] usbcore: registered new interface driver ums-cypress
[    5.069731] usbcore: registered new interface driver ums-datafab
[    5.069815] usbcore: registered new interface driver ums-freecom
[    5.069894] usbcore: registered new interface driver ums-isd200
[    5.069980] usbcore: registered new interface driver ums-jumpshot
[    5.070070] usbcore: registered new interface driver ums-karma
[    5.070156] usbcore: registered new interface driver ums-onetouch
[    5.070238] usbcore: registered new interface driver ums-sddr09
[    5.070312] usbcore: registered new interface driver ums-sddr55
[    5.070394] usbcore: registered new interface driver ums-usbat
[    5.070580] usbcore: registered new interface driver usbserial
[    5.070653] USB Serial support registered for generic
[    5.070738] usbcore: registered new interface driver usbserial_generic
[    5.070741] usbserial: USB Serial Driver core
[    5.070815] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    5.070913] usbcore: registered new interface driver belkin
[    5.070914] belkin_sa: v1.3:USB Belkin Serial converter driver
[    5.070980] USB Serial support registered for MCT U232
[    5.071056] usbcore: registered new interface driver mct_u232
[    5.071057] mct_u232: z2.1:Magic Control Technology USB-RS232 converter driver
[    5.071355] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.074605] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.074622] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.075008] mousedev: PS/2 mouse device common for all mice
[    5.075645] rtc_cmos 00:02: RTC can wake from S4
[    5.075894] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    5.075919] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    5.075992] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    5.076209] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[    5.076346] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.076351] iTCO_vendor_support: vendor-support=0
[    5.076353] SoftDog: cannot register miscdev on minor=130 (err=-16)
[    5.076361] md: linear personality registered for level -1
[    5.076363] md: raid0 personality registered for level 0
[    5.076365] md: raid1 personality registered for level 1
[    5.076366] md: raid10 personality registered for level 10
[    5.076367] md: raid6 personality registered for level 6
[    5.076369] md: raid5 personality registered for level 5
[    5.076370] md: raid4 personality registered for level 4
[    5.076372] md: multipath personality registered for level -4
[    5.076373] md: faulty personality registered for level -5
[    5.076796] device-mapper: uevent: version 1.0.3
[    5.077051] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    5.077163] device-mapper: multipath: version 1.3.0 loaded
[    5.077174] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.077178] device-mapper: multipath queue-length: version 0.1.0 loaded
[    5.077180] device-mapper: multipath service-time: version 0.2.0 loaded
[    5.077355] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    5.079044] cpuidle: using governor ladder
[    5.099249] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 001403 0  ACK POWER sig=k CSC CONNECT
[    5.099866] hub 1-0:1.0: port 2: status 0501 change 0001
[    5.102405] cpuidle: using governor menu
[    5.102685] usbcore: registered new interface driver usbhid
[    5.102687] usbhid: USB HID core driver
[    5.103172] dell_wmi: No known WMI GUID found
[    5.103174] acer_wmi: Acer Laptop ACPI-WMI Extras
[    5.103179] acer_wmi: No or unsupported WMI interface, unable to load
[    5.103670] IOAPIC[0]: Set routing entry (8-22 -> 0x99 -> IRQ 22 Mode:1 Active:1 Dest:0)
[    5.103675] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.103735] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    5.103772] ALSA hda_intel.c:2733 chipset global capabilities = 0x4401
[    5.103786] ALSA hda_intel.c:1163 Clearing TCSEL
[    5.107391] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC CONNECT
[    5.107986] hub 1-0:1.0: port 4: status 0501 change 0001
[    5.108444] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    5.109458] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[    5.109498] ALSA hda_intel.c:1009 codec_mask = 0x4
[    5.109618] ALSA hda_intel.c:1472 codec #2 probed OK
[    5.110514] uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
[    5.114583] ALSA hda_codec.c:3994 hda_codec: model 'intel-x58' is selected for config 8086:22 (DX58SO)
[    5.115204] hda_codec: ALC889: SKU not ready 0x411111f0
[    5.115223] ata1.00: configured for UDMA/133
[    5.115474] scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    5.115840] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.115918] sd 0:0:0:0: [sda] Write Protect is off
[    5.115920] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.115952] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.118669] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input2
[    5.122043] ALSA hda_codec.c:2378 Cannot find slave Side Playback Volume, skipped
[    5.122697] ALSA hda_codec.c:2378 Cannot find slave Headphone Playback Volume, skipped
[    5.123257] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Volume, skipped
[    5.123905] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Volume, skipped
[    5.124539] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    5.124572] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Volume, skipped
[    5.124581] ALSA hda_codec.c:2378 Cannot find slave Side Playback Switch, skipped
[    5.124584] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Switch, skipped
[    5.124587] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Switch, skipped
[    5.124589] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Switch, skipped
[    5.125602] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input3
[    5.125970] ALSA device list:
[    5.125971]   #0: HDA Intel at 0xf7f00000 irq 45
[    5.125973] oprofile: using NMI interrupt.
[    5.126010] netem: version 1.3
[    5.126012] Netfilter messages via NETLINK v0.30.
[    5.126043] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.126777] ctnetlink v0.93: registering with nfnetlink.
[    5.126811] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    5.126812] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    5.127106] xt_time: kernel timezone is -0000
[    5.128550] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.128611] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    5.128630] arp_tables: (C) 2002 David S. Miller
[    5.128656] TCP bic registered
[    5.128657] TCP cubic registered
[    5.128659] TCP westwood registered
[    5.128660] TCP highspeed registered
[    5.128661] TCP hybla registered
[    5.128662] TCP htcp registered
[    5.128663] TCP vegas registered
[    5.128664] TCP veno registered
[    5.128665] TCP scalable registered
[    5.128666] TCP lp registered
[    5.128667] TCP yeah registered
[    5.128668] TCP illinois registered
[    5.128669] Initializing XFRM netlink socket
[    5.129171] NET: Registered protocol family 10
[    5.132289] IPv6 over IPv4 tunneling driver
[    5.133998] NET: Registered protocol family 17
[    5.134008] NET: Registered protocol family 15
[    5.134126] Bridge firewalling registered
[    5.134137] Ebtables v2.0 registered
[    5.134229] Registering the dns_resolver key type
[    5.134285] 
[    5.134286] printing PIC contents
[    5.134289] ... PIC  IMR: ffff
[    5.134293] ... PIC  IRR: 0c21
[    5.134302] ... PIC  ISR: 0000
[    5.134306] ... PIC ELCR: 0c20
[    5.134307] printing local APIC contents on CPU#0/0:
[    5.134308] ... APIC ID:      00000000 (0)
[    5.134309] ... APIC VERSION: 00060015
[    5.134310] ... APIC TASKPRI: 00000000 (00)
[    5.134311] ... APIC PROCPRI: 00000000
[    5.134312] ... APIC LDR: 01000000
[    5.134313] ... APIC DFR: ffffffff
[    5.134313] ... APIC SPIV: 000001ff
[    5.134314] ... APIC ISR field:
[    5.134315] 0000000000000000000000000000000000000000000000000000000000000000
[    5.134318] ... APIC TMR field:
[    5.134319] 0000000000000000000000000000000000000002000000000000000000000000
[    5.134322] ... APIC IRR field:
[    5.134323] 0000000000000000000000000000000000000000000000000000000000000000
[    5.134325] ... APIC ESR: 00000000
[    5.134326] ... APIC ICR: 000000ef
[    5.134327] ... APIC ICR2: 05000000
[    5.134328] ... APIC LVTT: 000000ef
[    5.134329] ... APIC LVTPC: 00000400
[    5.134330] ... APIC LVT0: 00010700
[    5.134330] ... APIC LVT1: 00000400
[    5.134331] ... APIC LVTERR: 000000fe
[    5.134332] ... APIC TMICT: 00002075
[    5.134333] ... APIC TMCCT: 00000000
[    5.134334] ... APIC TDCR: 00000003
[    5.134334] 
[    5.134375] number of MP IRQ sources: 15.
[    5.134376] number of IO-APIC #8 registers: 24.
[    5.134377] testing the IO APIC.......................
[    5.134388] 
[    5.134389] IO APIC #8......
[    5.134390] .... register #00: 08000000
[    5.134390] .......    : physical APIC id: 08
[    5.134391] .......    : Delivery Type: 0
[    5.134392] .......    : LTS          : 0
[    5.134393] .... register #01: 00170020
[    5.134394] .......     : max redirection entries: 17
[    5.134395] .......     : PRQ implemented: 0
[    5.134396] .......     : IO APIC version: 20
[    5.134397] .... IRQ redirection table:
[    5.134398]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    5.134403]  00 00  1    0    0   0   0    0    0    00
[    5.134409]  01 00  0    0    0   0   0    0    0    31
[    5.134414]  02 00  0    0    0   0   0    0    0    30
[    5.134420]  03 00  0    0    0   0   0    0    0    33
[    5.134425]  04 00  0    0    0   0   0    0    0    34
[    5.134431]  05 00  0    0    0   0   0    0    0    35
[    5.134436]  06 00  1    0    0   0   0    0    0    36
[    5.134441]  07 00  0    0    0   0   0    0    0    37
[    5.134446]  08 00  0    0    0   0   0    0    0    38
[    5.134450]  09 00  0    1    0   0   0    0    0    39
[    5.134455]  0a 00  0    0    0   0   0    0    0    3A
[    5.134460]  0b 00  0    0    0   0   0    0    0    3B
[    5.134464]  0c 00  0    0    0   0   0    0    0    3C
[    5.134469]  0d 00  0    0    0   0   0    0    0    3D
[    5.134474]  0e 00  0    0    0   0   0    0    0    3E
[    5.134479]  0f 00  0    0    0   0   0    0    0    3F
[    5.134483]  10 00  0    1    0   1   0    0    0    29
[    5.134488]  11 00  1    1    0   1   0    0    0    41
[    5.134493]  12 00  0    1    0   1   0    0    0    81
[    5.134498]  13 00  0    1    0   1   0    0    0    61
[    5.134503]  14 00  1    1    0   1   0    0    0    71
[    5.134507]  15 00  0    1    0   1   0    0    0    91
[    5.134512]  16 00  1    1    0   1   0    0    0    99
[    5.134517]  17 00  0    1    0   1   0    0    0    89
[    5.134519] IRQ to pin mappings:
[    5.134520] IRQ0 -> 0:2
[    5.134521] IRQ1 -> 0:1
[    5.134522] IRQ3 -> 0:3
[    5.134524] IRQ4 -> 0:4
[    5.134525] IRQ5 -> 0:5
[    5.134526] IRQ6 -> 0:6
[    5.134527] IRQ7 -> 0:7
[    5.134528] IRQ8 -> 0:8
[    5.134529] IRQ9 -> 0:9
[    5.134531] IRQ10 -> 0:10
[    5.134532] IRQ11 -> 0:11
[    5.134533] IRQ12 -> 0:12
[    5.134534] IRQ13 -> 0:13
[    5.134535] IRQ14 -> 0:14
[    5.134536] IRQ15 -> 0:15
[    5.134537] IRQ16 -> 0:16
[    5.134539] IRQ17 -> 0:17
[    5.134540] IRQ18 -> 0:18
[    5.134541] IRQ19 -> 0:19
[    5.134543] IRQ20 -> 0:20
[    5.134544] IRQ21 -> 0:21
[    5.134545] IRQ22 -> 0:22
[    5.134546] IRQ23 -> 0:23
[    5.134548] .................................... done.
[    5.134886] PM: Hibernation image not present or could not be loaded.
[    5.134909] registered taskstats version 1
[    5.134910] Running tests on trace events:
[    5.134911] Testing event kfree_skb: 
[    5.168464] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.171635] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.171991] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.172372] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.173455] OK
[    5.173669] Testing event consume_skb: OK
[    5.189615] Testing event skb_copy_datagram_iovec: OK
[    5.205529] Testing event net_dev_xmit: 
[    5.206479]  sda: sda1 sda2 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    5.207218] hub 1-0:1.0: state 7 ports 6 chg 0016 evt 0000
[    5.207590] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    5.208788] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.221452] OK
[    5.221665] Testing event net_dev_queue: OK
[    5.239566] Testing event netif_receive_skb: OK
[    5.256601] Testing event netif_rx: 
[    5.258392] ehci_hcd 0000:00:1a.7: port 1 high speed
[    5.258885] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    5.273259] OK
[    5.273472] Testing event napi_poll: OK
[    5.291419] Testing event sock_rcvqueue_full: 
[    5.309938] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    5.310161] OK
[    5.310163] Testing event sock_exceed_buf_limit: OK
[    5.327214] Testing event udp_fail_queue_rcv_skb: OK
[    5.343318] Testing event hda_send_cmd: OK
[    5.360166] Testing event hda_get_response: 
[    5.365062] ehci_hcd 0000:00:1a.7: port 1 high speed
[    5.365552] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    5.370711] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.378893] OK
[    5.379107] Testing event hda_bus_reset: OK
[    5.395987] Testing event hda_power_down: OK
[    5.413072] Testing event hda_power_up: OK
[    5.430015] Testing event hda_unsol_event: 
[    5.435758] usb 1-1: default language 0x0409
[    5.443151] usb 1-1: udev 2, busnum 1, minor = 1
[    5.443567] usb 1-1: New USB device found, idVendor=0b95, idProduct=1780
[    5.443964] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    5.444486] usb 1-1: Product: AX88178 
[    5.444772] usb 1-1: Manufacturer: ASIX Elec. Corp.
[    5.445107] usb 1-1: SerialNumber: 000013
[    5.445127] ata2.00: ATAPI: PLEXTOR DVDR   PX-712A, 1.07, max UDMA/33
[    5.445129] ata2.00: applying bridge limits
[    5.446428] usb 1-1: usb_probe_device
[    5.446597] OK
[    5.446598] Testing event scsi_dispatch_cmd_start: 
[    5.447165] usb 1-1: configuration #1 chosen from 1 choice
[    5.448483] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    5.449469] asix 1-1:1.0: usb_probe_interface
[    5.449780] asix 1-1:1.0: usb_probe_interface - got id
[    5.463691] OK
[    5.463904] Testing event scsi_dispatch_cmd_error: 
[    5.476133] ata2.00: configured for UDMA/33
[    5.477727] scsi 1:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-712A   1.07 PQ: 0 ANSI: 5
[    5.480509] OK
[    5.480722] Testing event scsi_dispatch_cmd_done: OK
[    5.497813] Testing event scsi_dispatch_cmd_timeout: OK
[    5.515723] Testing event scsi_eh_wakeup: OK
[    5.535623] Testing event i915_gem_object_create: OK
[    5.554585] Testing event i915_gem_object_bind: OK
[    5.572451] Testing event i915_gem_object_unbind: OK
[    5.588346] Testing event i915_gem_object_change_domain: OK
[    5.604382] Testing event i915_gem_object_pwrite: OK
[    5.621304] Testing event i915_gem_object_pread: OK
[    5.637327] Testing event i915_gem_object_fault: OK
[    5.654213] Testing event i915_gem_object_clflush: OK
[    5.671201] Testing event i915_gem_object_destroy: OK
[    5.690162] Testing event i915_gem_evict: OK
[    5.708044] Testing event i915_gem_evict_everything: OK
[    5.724022] Testing event i915_gem_ring_dispatch: OK
[    5.742000] Testing event i915_gem_ring_flush: OK
[    5.758936] Testing event i915_gem_request_add: OK
[    5.774868] Testing event i915_gem_request_complete: 
[    5.782428] ata8: SATA link down (SStatus 0 SControl 300)
[    5.790731] OK
[    5.790944] Testing event i915_gem_request_retire: OK
[    5.807756] Testing event i915_gem_request_wait_begin: OK
[    5.823658] Testing event i915_gem_request_wait_end: OK
[    5.839719] Testing event i915_ring_wait_begin: OK
[    5.857542] Testing event i915_ring_wait_end: OK
[    5.873461] Testing event i915_flip_request: OK
[    5.889547] Testing event i915_flip_complete: OK
[    5.906446] Testing event i915_reg_rw: OK
[    5.922531] Testing event drm_vblank_event: OK
[    5.939327] Testing event drm_vblank_event_queued: OK
[    5.955358] Testing event drm_vblank_event_delivered: OK
[    5.972337] Testing event block_rq_abort: OK
[    5.989307] Testing event block_rq_requeue: OK
[    6.006141] Testing event block_rq_complete: OK
[    6.022083] Testing event block_rq_insert: OK
[    6.038166] Testing event block_rq_issue: OK
[    6.055091] Testing event block_bio_bounce: OK
[    6.073061] Testing event block_bio_complete: OK
[    6.089988] Testing event block_bio_backmerge: OK
[    6.106902] Testing event block_bio_frontmerge: OK
[    6.123888] Testing event block_bio_queue: OK
[    6.140846] Testing event block_getrq: OK
[    6.157634] Testing event block_sleeprq: 
[    6.162563] asix 1-1:1.0: eth1: register 'asix' at usb-0000:00:1a.7-1, ASIX AX88178 USB 2.0 Ethernet, 00:23:54:5c:02:83
[    6.163436] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    6.163877] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    6.164377] ehci_hcd 0000:00:1a.7: port 2 low speed --> companion
[    6.173566] OK
[    6.173778] Testing event block_plug: 
[    6.184209] usb usb5: suspend_rh (auto-stop)
[    6.184230] usb usb8: suspend_rh (auto-stop)
[    6.185012] usb usb6: suspend_rh (auto-stop)
[    6.185348] usb usb7: suspend_rh (auto-stop)
[    6.185686] usb usb4: suspend_rh (auto-stop)
[    6.190508] OK
[    6.190722] Testing event block_unplug: OK
[    6.207500] Testing event block_split: 
[    6.215060] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    6.215844] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    6.223423] OK
[    6.223637] Testing event block_bio_remap: OK
[    6.240472] Testing event block_rq_remap: OK
[    6.257491] Testing event btrfs_transaction_commit: 
[    6.267265] ehci_hcd 0000:00:1a.7: port 4 high speed
[    6.267757] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    6.274253] OK
[    6.274466] Testing event btrfs_inode_new: OK
[    6.291380] Testing event btrfs_inode_request: OK
[    6.308268] Testing event btrfs_inode_evict: 
[    6.318803] usb 1-4: new high-speed USB device number 4 using ehci_hcd
[    6.325124] OK
[    6.325337] Testing event btrfs_get_extent: OK
[    6.342152] Testing event btrfs_ordered_extent_add: OK
[    6.359038] Testing event btrfs_ordered_extent_remove: 
[    6.369946] ehci_hcd 0000:00:1a.7: port 4 high speed
[    6.370438] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    6.374816] OK
[    6.375029] Testing event btrfs_ordered_extent_start: OK
[    6.392069] Testing event btrfs_ordered_extent_put: OK
[    6.408990] Testing event btrfs_finish_ordered_io: OK
[    6.425808] Testing event __extent_writepage: OK
[    6.441842] Testing event btrfs_writepage_end_io_hook: OK
[    6.458767] Testing event btrfs_sync_file: OK
[    6.474766] Testing event btrfs_sync_fs: OK
[    6.491726] Testing event btrfs_delayed_tree_ref: OK
[    6.508545] Testing event btrfs_delayed_data_ref: OK
[    6.524524] Testing event btrfs_delayed_ref_head: OK
[    6.540427] Testing event btrfs_chunk_alloc: OK
[    6.556533] Testing event btrfs_chunk_free: OK
[    6.573505] Testing event btrfs_cow_block: OK
[    6.590377] Testing event btrfs_reserved_extent_alloc: OK
[    6.609366] Testing event btrfs_reserved_extent_free: OK
[    6.627304] Testing event xfs_attr_list_sf: OK
[    6.644132] Testing event xfs_attr_list_sf_all: OK
[    6.660106] Testing event xfs_attr_list_leaf: OK
[    6.676166] Testing event xfs_attr_list_leaf_end: OK
[    6.694117] Testing event xfs_attr_list_full: OK
[    6.711058] Testing event xfs_attr_list_add: OK
[    6.727995] Testing event xfs_attr_list_wrong_blk: OK
[    6.745878] Testing event xfs_attr_list_notfound: OK
[    6.763832] Testing event xfs_perag_get: OK
[    6.779831] Testing event xfs_perag_get_tag: OK
[    6.797719] Testing event xfs_perag_put: OK
[    6.813604] Testing event xfs_perag_set_reclaim: OK
[    6.829611] Testing event xfs_perag_clear_reclaim: OK
[    6.845629] Testing event xfs_attr_list_node_descend: OK
[    6.862574] Testing event xfs_iext_insert: OK
[    6.879469] Testing event xfs_iext_remove: OK
[    6.899325] Testing event xfs_bmap_pre_update: OK
[    6.917372] Testing event xfs_bmap_post_update: OK
[    6.935291] Testing event xfs_extlist: OK
[    6.951198] Testing event xfs_buf_init: OK
[    6.967228] Testing event xfs_buf_free: OK
[    6.985125] Testing event xfs_buf_hold: OK
[    7.001117] Testing event xfs_buf_rele: OK
[    7.018111] Testing event xfs_buf_iodone: OK
[    7.035043] Testing event xfs_buf_iorequest: OK
[    7.053923] Testing event xfs_buf_bawrite: OK
[    7.070810] Testing event xfs_buf_lock: OK
[    7.086831] Testing event xfs_buf_lock_done: OK
[    7.102780] Testing event xfs_buf_trylock: OK
[    7.119782] Testing event xfs_buf_unlock: OK
[    7.136587] Testing event xfs_buf_iowait: OK
[    7.152680] Testing event xfs_buf_iowait_done: OK
[    7.170637] Testing event xfs_buf_delwri_queue: OK
[    7.187590] Testing event xfs_buf_delwri_dequeue: OK
[    7.204394] Testing event xfs_buf_delwri_split: OK
[    7.220347] Testing event xfs_buf_get_uncached: OK
[    7.236384] Testing event xfs_bdstrat_shut: OK
[    7.253294] Testing event xfs_buf_item_relse: OK
[    7.270324] Testing event xfs_buf_item_iodone: OK
[    7.288254] Testing event xfs_buf_item_iodone_async: OK
[    7.305220] Testing event xfs_buf_error_relse: OK
[    7.322121] Testing event xfs_trans_read_buf_io: OK
[    7.338980] Testing event xfs_trans_read_buf_shut: OK
[    7.355000] Testing event xfs_btree_corrupt: 
[    7.369181] usb 1-4: default language 0x0409
[    7.370777] OK
[    7.370986] Testing event xfs_da_btree_corrupt: 
[    7.371122] usb 1-4: udev 4, busnum 1, minor = 3
[    7.371124] usb 1-4: New USB device found, idVendor=1307, idProduct=0165
[    7.371127] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.371129] usb 1-4: Product: USB Mass Storage Device
[    7.371130] usb 1-4: Manufacturer: Teclast Technology
[    7.371132] usb 1-4: SerialNumber: 0000000000020D
[    7.371391] usb 1-4: usb_probe_device
[    7.371393] usb 1-4: configuration #1 chosen from 1 choice
[    7.371488] usb 1-4: adding 1-4:1.0 (config #1, interface 0)
[    7.371666] usb-storage 1-4:1.0: usb_probe_interface
[    7.371670] usb-storage 1-4:1.0: usb_probe_interface - got id
[    7.371970] scsi9 : usb-storage 1-4:1.0
[    7.372317] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[    7.372346] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    7.372354] uhci_hcd 0000:00:1a.0: port 2 portsc 01a3,00
[    7.372364] hub 3-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    7.394765] OK
[    7.394978] Testing event xfs_reset_dqcounts: OK
[    7.411720] Testing event xfs_inode_item_push: OK
[    7.427872] Testing event xfs_buf_find: OK
[    7.444794] Testing event xfs_buf_get: OK
[    7.461745] Testing event xfs_buf_read: 
[    7.475209] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    7.479460] OK
[    7.479675] Testing event xfs_buf_ioerror: OK
[    7.496619] Testing event xfs_buf_item_size: OK
[    7.513453] Testing event xfs_buf_item_size_stale: OK
[    7.530466] Testing event xfs_buf_item_format: OK
[    7.547421] Testing event xfs_buf_item_format_stale: OK
[    7.564250] Testing event xfs_buf_item_pin: 
[    7.576910] usb 3-2: new low-speed USB device number 2 using uhci_hcd
[    7.580089] OK
[    7.580302] Testing event xfs_buf_item_unpin: OK
[    7.597161] Testing event xfs_buf_item_unpin_stale: OK
[    7.613173] Testing event xfs_buf_item_trylock: OK
[    7.629168] Testing event xfs_buf_item_unlock: OK
[    7.646250] Testing event xfs_buf_item_unlock_stale: OK
[    7.663088] Testing event xfs_buf_item_committed: OK
[    7.680117] Testing event xfs_buf_item_push: OK
[    7.696977] Testing event xfs_buf_item_pushbuf: OK
[    7.713979] Testing event xfs_trans_get_buf: OK
[    7.730849] Testing event xfs_trans_get_buf_recur: OK
[    7.747872] Testing event xfs_trans_getsb: OK
[    7.764659] Testing event xfs_trans_getsb_recur: 
[    7.777099] usb 3-2: skipped 1 descriptor after interface
[    7.777704] usb 3-2: skipped 1 descriptor after interface
[    7.780436] OK
[    7.780649] Testing event xfs_trans_read_buf: 
[    7.787061] usb 3-2: default language 0x0409
[    7.798396] OK
[    7.798610] Testing event xfs_trans_read_buf_recur: OK
[    7.816457] Testing event xfs_trans_log_buf: 
[    7.817937] usb 3-2: udev 2, busnum 3, minor = 257
[    7.818440] usb 3-2: New USB device found, idVendor=0557, idProduct=2220
[    7.818841] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.819347] usb 3-2: Product: ATEN  CS-1758/54
[    7.819664] usb 3-2: Manufacturer: ATEN
[    7.820405] usb 3-2: usb_probe_device
[    7.820693] usb 3-2: configuration #1 chosen from 1 choice
[    7.823943] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[    7.834259] OK
[    7.834474] Testing event xfs_trans_brelse: OK
[    7.850350] Testing event xfs_trans_bjoin: 
[    7.864246] usbserial_generic 3-2:1.0: usb_probe_interface
[    7.864757] usbserial_generic 3-2:1.0: usb_probe_interface - got id
[    7.865261] usbhid 3-2:1.0: usb_probe_interface
[    7.865579] usbhid 3-2:1.0: usb_probe_interface - got id
[    7.866263] OK
[    7.866479] Testing event xfs_trans_bhold: OK
[    7.883410] Testing event xfs_trans_bhold_release: OK
[    7.901345] Testing event xfs_trans_binval: 
[    7.902042] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input4
[    7.902959] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    7.903672] generic-usb 0003:0557:2220.0001: input: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input0
[    7.904522] usb 3-2: adding 3-2:1.1 (config #1, interface 1)
[    7.916848] usbserial_generic 3-2:1.1: usb_probe_interface
[    7.917203] usbserial_generic 3-2:1.1: usb_probe_interface - got id
[    7.917599] usbhid 3-2:1.1: usb_probe_interface
[    7.917999] usbhid 3-2:1.1: usb_probe_interface - got id
[    7.919013] OK
[    7.919226] Testing event xfs_ilock: OK
[    7.935323] Testing event xfs_ilock_nowait: 
[    7.946297] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.1/input/input5
[    7.947389] generic-usb 0003:0557:2220.0002: input: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input1
[    7.948139] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    7.948580] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.948980] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    7.953009] OK
[    7.953223] Testing event xfs_ilock_demote: OK
[    7.972138] Testing event xfs_iunlock: OK
[    7.991106] Testing event xfs_iget_skip: OK
[    8.007942] Testing event xfs_iget_reclaim: OK
[    8.023886] Testing event xfs_iget_reclaim_fail: OK
[    8.040756] Testing event xfs_iget_hit: OK
[    8.057939] Testing event xfs_iget_miss: OK
[    8.075919] Testing event xfs_getattr: OK
[    8.093871] Testing event xfs_setattr: OK
[    8.110635] Testing event xfs_readlink: OK
[    8.127712] Testing event xfs_alloc_file_space: OK
[    8.146600] Testing event xfs_free_file_space: OK
[    8.164616] Testing event xfs_readdir: OK
[    8.182331] Testing event xfs_get_acl: OK
[    8.198517] Testing event xfs_vm_bmap: OK
[    8.216422] Testing event xfs_file_ioctl: OK
[    8.233356] Testing event xfs_file_compat_ioctl: OK
[    8.250257] Testing event xfs_ioctl_setattr: OK
[    8.267240] Testing event xfs_dir_fsync: OK
[    8.284195] Testing event xfs_file_fsync: OK
[    8.300971] Testing event xfs_destroy_inode: OK
[    8.317880] Testing event xfs_write_inode: OK
[    8.334074] Testing event xfs_evict_inode: OK
[    8.350990] Testing event xfs_dquot_dqalloc: OK
[    8.369826] scsi 9:0:0:0: Direct-Access     Teclast  CoolFlash        0.00 PQ: 0 ANSI: 2
[    8.369916] scsi: killing requests for dead queue
[    8.370057] scsi: killing requests for dead queue
[    8.370178] scsi: killing requests for dead queue
[    8.370299] scsi: killing requests for dead queue
[    8.370425] scsi: killing requests for dead queue
[    8.370545] scsi: killing requests for dead queue
[    8.370664] scsi: killing requests for dead queue
[    8.371510] scsi_scan_9 used greatest stack depth: 4704 bytes left
[    8.372553] sd 9:0:0:0: [sdb] 63084544 512-byte logical blocks: (32.2 GB/30.0 GiB)
[    8.373177] sd 9:0:0:0: [sdb] Write Protect is off
[    8.373179] sd 9:0:0:0: [sdb] Mode Sense: 00 00 00 00
[    8.373789] sd 9:0:0:0: [sdb] Asking for cache data failed
[    8.373790] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    8.375199] Testing event xfs_dquot_dqdetach: 
[    8.378005] sd 9:0:0:0: [sdb] Asking for cache data failed
[    8.378549] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    8.393608] OK
[    8.393819] Testing event xfs_ihold: OK
[    8.410598] Testing event xfs_irele: OK
[    8.428545] Testing event xfs_inode_pin: OK
[    8.446629] Testing event xfs_inode_unpin: OK
[    8.463576] Testing event xfs_inode_unpin_nowait: OK
[    8.482388] Testing event xfs_remove: OK
[    8.499315] Testing event xfs_link: 
[    8.512465]  sdb: sdb1 sdb2 sdb3
[    8.516576] sd 9:0:0:0: [sdb] Asking for cache data failed
[    8.516978] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    8.517164] OK
[    8.517166] Testing event xfs_lookup: 
[    8.520722] sd 9:0:0:0: [sdb] Attached SCSI removable disk
[    8.535115] OK
[    8.535328] Testing event xfs_create: OK
[    8.552333] Testing event xfs_symlink: OK
[    8.571249] Testing event xfs_rename: OK
[    8.588237] Testing event xfs_dqadjust: OK
[    8.605174] Testing event xfs_dqreclaim_want: OK
[    8.622136] Testing event xfs_dqreclaim_dirty: OK
[    8.639104] Testing event xfs_dqreclaim_unlink: OK
[    8.656030] Testing event xfs_dqattach_found: OK
[    8.672951] Testing event xfs_dqattach_get: OK
[    8.689916] Testing event xfs_dqinit: OK
[    8.706840] Testing event xfs_dqreuse: OK
[    8.723842] Testing event xfs_dqalloc: OK
[    8.740760] Testing event xfs_dqtobp_read: OK
[    8.757713] Testing event xfs_dqread: OK
[    8.774681] Testing event xfs_dqread_fail: OK
[    8.791632] Testing event xfs_dqlookup_found: OK
[    8.808522] Testing event xfs_dqlookup_want: OK
[    8.825496] Testing event xfs_dqlookup_freelist: OK
[    8.842516] Testing event xfs_dqlookup_done: OK
[    8.860325] Testing event xfs_dqget_hit: OK
[    8.877301] Testing event xfs_dqget_miss: OK
[    8.894260] Testing event xfs_dqput: OK
[    8.911262] Testing event xfs_dqput_wait: OK
[    8.928210] Testing event xfs_dqput_free: OK
[    8.945159] Testing event xfs_dqrele: OK
[    8.962108] Testing event xfs_dqflush: OK
[    8.979051] Testing event xfs_dqflush_force: OK
[    8.995943] Testing event xfs_dqflush_done: OK
[    9.012893] Testing event xfs_log_done_nonperm: OK
[    9.029853] Testing event xfs_log_done_perm: OK
[    9.046819] Testing event xfs_log_reserve: OK
[    9.063738] Testing event xfs_log_umount_write: OK
[    9.080735] Testing event xfs_log_grant_enter: OK
[    9.097645] Testing event xfs_log_grant_exit: OK
[    9.114626] Testing event xfs_log_grant_error: OK
[    9.131525] Testing event xfs_log_grant_sleep1: OK
[    9.148522] Testing event xfs_log_grant_wake1: OK
[    9.165469] Testing event xfs_log_grant_sleep2: OK
[    9.182401] Testing event xfs_log_grant_wake2: OK
[    9.199250] Testing event xfs_log_grant_wake_up: OK
[    9.216214] Testing event xfs_log_regrant_write_enter: OK
[    9.233284] Testing event xfs_log_regrant_write_exit: OK
[    9.251271] Testing event xfs_log_regrant_write_error: OK
[    9.268111] Testing event xfs_log_regrant_write_sleep1: OK
[    9.287993] Testing event xfs_log_regrant_write_wake1: OK
[    9.306029] Testing event xfs_log_regrant_write_sleep2: OK
[    9.322946] Testing event xfs_log_regrant_write_wake2: OK
[    9.339905] Testing event xfs_log_regrant_write_wake_up: OK
[    9.356826] Testing event xfs_log_regrant_reserve_enter: OK
[    9.373824] Testing event xfs_log_regrant_reserve_exit: OK
[    9.390823] Testing event xfs_log_regrant_reserve_sub: OK
[    9.407717] Testing event xfs_log_ungrant_enter: OK
[    9.424662] Testing event xfs_log_ungrant_exit: OK
[    9.441618] Testing event xfs_log_ungrant_sub: OK
[    9.458510] Testing event xfs_ail_push: OK
[    9.475503] Testing event xfs_ail_pushbuf: OK
[    9.492438] Testing event xfs_ail_pushbuf_pinned: OK
[    9.509341] Testing event xfs_ail_pinned: OK
[    9.526302] Testing event xfs_ail_locked: OK
[    9.543307] Testing event xfs_file_read: OK
[    9.561246] Testing event xfs_file_buffered_write: OK
[    9.578234] Testing event xfs_file_direct_write: OK
[    9.595135] Testing event xfs_file_splice_read: OK
[    9.612158] Testing event xfs_file_splice_write: OK
[    9.628944] Testing event xfs_writepage: OK
[    9.646888] Testing event xfs_releasepage: OK
[    9.663874] Testing event xfs_invalidatepage: OK
[    9.680823] Testing event xfs_map_blocks_found: OK
[    9.697790] Testing event xfs_map_blocks_alloc: OK
[    9.714742] Testing event xfs_get_blocks_found: OK
[    9.731663] Testing event xfs_get_blocks_alloc: OK
[    9.748665] Testing event xfs_delalloc_enospc: OK
[    9.765507] Testing event xfs_unwritten_convert: OK
[    9.782554] Testing event xfs_get_blocks_notfound: OK
[    9.799453] Testing event xfs_setfilesize: OK
[    9.816449] Testing event xfs_itruncate_data_start: OK
[    9.833362] Testing event xfs_itruncate_data_end: OK
[    9.850346] Testing event xfs_pagecache_inval: OK
[    9.867296] Testing event xfs_bunmap: OK
[    9.884243] Testing event xfs_alloc_busy: OK
[    9.901069] Testing event xfs_alloc_busy_enomem: OK
[    9.918086] Testing event xfs_alloc_busy_force: OK
[    9.935093] Testing event xfs_alloc_busy_reuse: OK
[    9.952029] Testing event xfs_alloc_busy_clear: OK
[    9.968945] Testing event xfs_alloc_busy_trim: OK
[    9.985912] Testing event xfs_trans_commit_lsn: OK
[   10.002838] Testing event xfs_agf: OK
[   10.019805] Testing event xfs_free_extent: OK
[   10.036741] Testing event xfs_alloc_exact_done: OK
[   10.053682] Testing event xfs_alloc_exact_notfound: OK
[   10.070628] Testing event xfs_alloc_exact_error: OK
[   10.087561] Testing event xfs_alloc_near_nominleft: OK
[   10.104503] Testing event xfs_alloc_near_first: OK
[   10.121482] Testing event xfs_alloc_near_greater: OK
[   10.138400] Testing event xfs_alloc_near_lesser: OK
[   10.155397] Testing event xfs_alloc_near_error: OK
[   10.172318] Testing event xfs_alloc_near_noentry: OK
[   10.189278] Testing event xfs_alloc_near_busy: OK
[   10.206207] Testing event xfs_alloc_size_neither: OK
[   10.223186] Testing event xfs_alloc_size_noentry: OK
[   10.240106] Testing event xfs_alloc_size_nominleft: OK
[   10.257084] Testing event xfs_alloc_size_done: OK
[   10.273999] Testing event xfs_alloc_size_error: OK
[   10.290985] Testing event xfs_alloc_size_busy: OK
[   10.307859] Testing event xfs_alloc_small_freelist: OK
[   10.324688] Testing event xfs_alloc_small_notenough: OK
[   10.340866] Testing event xfs_alloc_small_done: OK
[   10.357680] Testing event xfs_alloc_small_error: OK
[   10.374806] Testing event xfs_alloc_vextent_badargs: OK
[   10.391614] Testing event xfs_alloc_vextent_nofix: OK
[   10.408559] Testing event xfs_alloc_vextent_noagbp: OK
[   10.425570] Testing event xfs_alloc_vextent_loopfailed: OK
[   10.442506] Testing event xfs_alloc_vextent_allfailed: OK
[   10.459416] Testing event xfs_dir2_sf_addname: OK
[   10.476424] Testing event xfs_dir2_sf_create: OK
[   10.493358] Testing event xfs_dir2_sf_lookup: OK
[   10.510389] Testing event xfs_dir2_sf_replace: OK
[   10.527189] Testing event xfs_dir2_sf_removename: OK
[   10.544202] Testing event xfs_dir2_sf_toino4: OK
[   10.561233] Testing event xfs_dir2_sf_toino8: OK
[   10.578057] Testing event xfs_dir2_sf_to_block: OK
[   10.595042] Testing event xfs_dir2_block_addname: OK
[   10.611990] Testing event xfs_dir2_block_lookup: OK
[   10.628904] Testing event xfs_dir2_block_replace: OK
[   10.645889] Testing event xfs_dir2_block_removename: OK
[   10.662799] Testing event xfs_dir2_block_to_sf: OK
[   10.679782] Testing event xfs_dir2_block_to_leaf: OK
[   10.696710] Testing event xfs_dir2_leaf_addname: OK
[   10.713674] Testing event xfs_dir2_leaf_lookup: OK
[   10.730504] Testing event xfs_dir2_leaf_replace: OK
[   10.747570] Testing event xfs_dir2_leaf_removename: OK
[   10.765513] Testing event xfs_dir2_leaf_to_block: OK
[   10.782451] Testing event xfs_dir2_leaf_to_node: OK
[   10.799400] Testing event xfs_dir2_node_addname: OK
[   10.816222] Testing event xfs_dir2_node_lookup: OK
[   10.832317] Testing event xfs_dir2_node_replace: OK
[   10.849240] Testing event xfs_dir2_node_removename: OK
[   10.866167] Testing event xfs_dir2_node_to_leaf: OK
[   10.883090] Testing event xfs_dir2_leafn_add: OK
[   10.900030] Testing event xfs_dir2_leafn_remove: OK
[   10.917039] Testing event xfs_dir2_grow_inode: OK
[   10.933939] Testing event xfs_dir2_shrink_inode: OK
[   10.950931] Testing event xfs_dir2_leafn_moveents: OK
[   10.967849] Testing event xfs_swap_extent_before: OK
[   10.984813] Testing event xfs_swap_extent_after: OK
[   11.001656] Testing event xfs_log_recover_item_add: OK
[   11.018721] Testing event xfs_log_recover_item_add_cont: OK
[   11.035641] Testing event xfs_log_recover_item_reorder_head: OK
[   11.052627] Testing event xfs_log_recover_item_reorder_tail: OK
[   11.069518] Testing event xfs_log_recover_item_recover: OK
[   11.086513] Testing event xfs_log_recover_buf_not_cancel: OK
[   11.103427] Testing event xfs_log_recover_buf_cancel: OK
[   11.120358] Testing event xfs_log_recover_buf_cancel_add: OK
[   11.137242] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   11.154272] Testing event xfs_log_recover_buf_recover: OK
[   11.171203] Testing event xfs_log_recover_buf_inode_buf: OK
[   11.188177] Testing event xfs_log_recover_buf_reg_buf: OK
[   11.205115] Testing event xfs_log_recover_buf_dquot_buf: OK
[   11.222100] Testing event xfs_log_recover_inode_recover: OK
[   11.239045] Testing event xfs_log_recover_inode_cancel: OK
[   11.255992] Testing event xfs_log_recover_inode_skip: OK
[   11.272821] Testing event xfs_discard_extent: OK
[   11.289889] Testing event xfs_discard_toosmall: OK
[   11.306843] Testing event xfs_discard_exclude: OK
[   11.323780] Testing event xfs_discard_busy: OK
[   11.340697] Testing event jbd2_checkpoint: OK
[   11.357657] Testing event jbd2_start_commit: OK
[   11.374608] Testing event jbd2_commit_locking: OK
[   11.391548] Testing event jbd2_commit_flushing: OK
[   11.408505] Testing event jbd2_commit_logging: OK
[   11.425464] Testing event jbd2_end_commit: OK
[   11.442418] Testing event jbd2_submit_inode_data: OK
[   11.459358] Testing event jbd2_run_stats: OK
[   11.476259] Testing event jbd2_checkpoint_stats: OK
[   11.493251] Testing event jbd2_cleanup_journal_tail: OK
[   11.510170] Testing event jbd_checkpoint: OK
[   11.527100] Testing event jbd_start_commit: OK
[   11.546969] Testing event jbd_commit_locking: OK
[   11.564033] Testing event jbd_commit_flushing: OK
[   11.580973] Testing event jbd_commit_logging: OK
[   11.597936] Testing event jbd_drop_transaction: OK
[   11.614875] Testing event jbd_end_commit: OK
[   11.631777] Testing event jbd_do_submit_data: OK
[   11.648718] Testing event jbd_cleanup_journal_tail: OK
[   11.665666] Testing event jbd_update_superblock_end: OK
[   11.682648] Testing event ext4_free_inode: OK
[   11.699587] Testing event ext4_request_inode: OK
[   11.716544] Testing event ext4_allocate_inode: OK
[   11.733490] Testing event ext4_evict_inode: OK
[   11.750439] Testing event ext4_drop_inode: OK
[   11.767349] Testing event ext4_mark_inode_dirty: OK
[   11.784325] Testing event ext4_begin_ordered_truncate: OK
[   11.801203] Testing event ext4_write_begin: OK
[   11.818069] Testing event ext4_da_write_begin: OK
[   11.834041] Testing event ext4_ordered_write_end: OK
[   11.850132] Testing event ext4_writeback_write_end: OK
[   11.867911] Testing event ext4_journalled_write_end: OK
[   11.884088] Testing event ext4_da_write_end: OK
[   11.900814] Testing event ext4_da_writepages: OK
[   11.916993] Testing event ext4_da_write_pages: OK
[   11.933974] Testing event ext4_da_writepages_result: OK
[   11.951737] Testing event ext4_writepage: OK
[   11.970598] Testing event ext4_readpage: OK
[   11.986624] Testing event ext4_releasepage: OK
[   12.002682] Testing event ext4_invalidatepage: OK
[   12.019559] Testing event ext4_discard_blocks: OK
[   12.036381] Testing event ext4_mb_new_inode_pa: OK
[   12.052567] Testing event ext4_mb_new_group_pa: OK
[   12.070376] Testing event ext4_mb_release_inode_pa: OK
[   12.087417] Testing event ext4_mb_release_group_pa: OK
[   12.104185] Testing event ext4_discard_preallocations: OK
[   12.120286] Testing event ext4_mb_discard_preallocations: OK
[   12.137079] Testing event ext4_request_blocks: OK
[   12.153221] Testing event ext4_allocate_blocks: OK
[   12.171032] Testing event ext4_free_blocks: OK
[   12.187187] Testing event ext4_sync_file_enter: OK
[   12.203996] Testing event ext4_sync_file_exit: OK
[   12.220998] Testing event ext4_sync_fs: OK
[   12.237911] Testing event ext4_alloc_da_blocks: OK
[   12.254890] Testing event ext4_mballoc_alloc: OK
[   12.271634] Testing event ext4_mballoc_prealloc: OK
[   12.287581] Testing event ext4_mballoc_discard: OK
[   12.303676] Testing event ext4_mballoc_free: OK
[   12.320758] Testing event ext4_forget: OK
[   12.337630] Testing event ext4_da_update_reserve_space: OK
[   12.356516] Testing event ext4_da_reserve_space: OK
[   12.373495] Testing event ext4_da_release_space: OK
[   12.390454] Testing event ext4_mb_bitmap_load: OK
[   12.407376] Testing event ext4_mb_buddy_bitmap_load: OK
[   12.424379] Testing event ext4_read_block_bitmap_load: OK
[   12.441282] Testing event ext4_load_inode_bitmap: OK
[   12.458261] Testing event ext4_direct_IO_enter: OK
[   12.475215] Testing event ext4_direct_IO_exit: OK
[   12.492140] Testing event ext4_fallocate_enter: OK
[   12.509074] Testing event ext4_fallocate_exit: OK
[   12.526057] Testing event ext4_unlink_enter: OK
[   12.542965] Testing event ext4_unlink_exit: OK
[   12.559952] Testing event ext4_truncate_enter: OK
[   12.576864] Testing event ext4_truncate_exit: OK
[   12.593847] Testing event ext4_ext_map_blocks_enter: OK
[   12.610756] Testing event ext4_ind_map_blocks_enter: OK
[   12.627783] Testing event ext4_ext_map_blocks_exit: OK
[   12.644666] Testing event ext4_ind_map_blocks_exit: OK
[   12.661634] Testing event ext4_ext_load_extent: OK
[   12.678624] Testing event ext4_load_inode: OK
[   12.695542] Testing event ext4_journal_start: OK
[   12.712521] Testing event ext4_trim_extent: OK
[   12.729420] Testing event ext4_trim_all_free: OK
[   12.746334] Testing event ext4_ext_handle_uninitialized_extents: OK
[   12.763300] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   12.780205] Testing event ext4_ext_put_in_cache: OK
[   12.797209] Testing event ext4_ext_in_cache: OK
[   12.814123] Testing event ext4_find_delalloc_range: OK
[   12.831058] Testing event ext4_get_reserved_cluster_alloc: OK
[   12.848015] Testing event ext4_ext_show_extent: OK
[   12.864978] Testing event ext4_remove_blocks: OK
[   12.881903] Testing event ext4_ext_rm_leaf: OK
[   12.898883] Testing event ext4_ext_rm_idx: OK
[   12.915680] Testing event ext4_ext_remove_space: OK
[   12.932638] Testing event ext4_ext_remove_space_done: OK
[   12.948615] Testing event ext3_free_inode: OK
[   12.964760] Testing event ext3_request_inode: OK
[   12.981552] Testing event ext3_allocate_inode: OK
[   13.000583] Testing event ext3_evict_inode: OK
[   13.019533] Testing event ext3_drop_inode: OK
[   13.036413] Testing event ext3_mark_inode_dirty: OK
[   13.053383] Testing event ext3_write_begin: OK
[   13.070335] Testing event ext3_ordered_write_end: OK
[   13.087263] Testing event ext3_writeback_write_end: OK
[   13.104263] Testing event ext3_journalled_write_end: OK
[   13.121250] Testing event ext3_ordered_writepage: OK
[   13.138095] Testing event ext3_writeback_writepage: OK
[   13.155107] Testing event ext3_journalled_writepage: OK
[   13.172000] Testing event ext3_readpage: OK
[   13.189004] Testing event ext3_releasepage: OK
[   13.205911] Testing event ext3_invalidatepage: OK
[   13.222842] Testing event ext3_discard_blocks: OK
[   13.239793] Testing event ext3_request_blocks: OK
[   13.256788] Testing event ext3_allocate_blocks: OK
[   13.273702] Testing event ext3_free_blocks: OK
[   13.290581] Testing event ext3_sync_file_enter: OK
[   13.307592] Testing event ext3_sync_file_exit: OK
[   13.324542] Testing event ext3_sync_fs: OK
[   13.341491] Testing event ext3_rsv_window_add: OK
[   13.358425] Testing event ext3_discard_reservation: OK
[   13.375417] Testing event ext3_alloc_new_reservation: OK
[   13.392386] Testing event ext3_reserved: OK
[   13.410309] Testing event ext3_forget: OK
[   13.427257] Testing event ext3_read_block_bitmap: OK
[   13.444191] Testing event ext3_direct_IO_enter: OK
[   13.461138] Testing event ext3_direct_IO_exit: OK
[   13.478072] Testing event ext3_unlink_enter: OK
[   13.495031] Testing event ext3_unlink_exit: OK
[   13.512002] Testing event ext3_truncate_enter: OK
[   13.528909] Testing event ext3_truncate_exit: OK
[   13.545772] Testing event ext3_get_blocks_enter: OK
[   13.563873] Testing event ext3_get_blocks_exit: OK
[   13.581849] Testing event ext3_load_inode: OK
[   13.600735] Testing event writeback_nothread: OK
[   13.617653] Testing event writeback_queue: OK
[   13.636611] Testing event writeback_exec: OK
[   13.655417] Testing event writeback_start: OK
[   13.671375] Testing event writeback_written: OK
[   13.687425] Testing event writeback_wait: OK
[   13.704400] Testing event writeback_pages_written: OK
[   13.721324] Testing event writeback_nowork: OK
[   13.738250] Testing event writeback_wake_background: OK
[   13.755246] Testing event writeback_wake_thread: OK
[   13.772157] Testing event writeback_wake_forker_thread: OK
[   13.789106] Testing event writeback_bdi_register: OK
[   13.806035] Testing event writeback_bdi_unregister: OK
[   13.823029] Testing event writeback_thread_start: OK
[   13.839989] Testing event writeback_thread_stop: OK
[   13.856813] Testing event wbc_writepage: OK
[   13.872858] Testing event writeback_queue_io: OK
[   13.889829] Testing event task_io: OK
[   13.906706] Testing event global_dirty_state: OK
[   13.923688] Testing event bdi_dirty_state: OK
[   13.940632] Testing event blkcg_dirty_ratelimit: OK
[   13.957619] Testing event bdi_dirty_ratelimit: OK
[   13.974565] Testing event balance_dirty_pages: OK
[   13.991494] Testing event writeback_congestion_wait: OK
[   14.008336] Testing event writeback_wait_iff_congested: OK
[   14.025379] Testing event writeback_single_inode_requeue: OK
[   14.042318] Testing event writeback_single_inode: OK
[   14.059315] Testing event kmalloc: OK
[   14.076214] Testing event kmem_cache_alloc: OK
[   14.093162] Testing event kmalloc_node: OK
[   14.110091] Testing event kmem_cache_alloc_node: OK
[   14.127056] Testing event kfree: OK
[   14.143918] Testing event kmem_cache_free: OK
[   14.159992] Testing event mm_page_free_direct: OK
[   14.176913] Testing event mm_pagevec_free: OK
[   14.193850] Testing event mm_page_alloc: OK
[   14.210819] Testing event mm_page_alloc_zone_locked: OK
[   14.227745] Testing event mm_page_pcpu_drain: OK
[   14.244733] Testing event mm_page_alloc_extfrag: OK
[   14.261685] Testing event mm_vmscan_kswapd_sleep: OK
[   14.278627] Testing event mm_vmscan_kswapd_wake: OK
[   14.295422] Testing event mm_vmscan_wakeup_kswapd: OK
[   14.311373] Testing event mm_vmscan_direct_reclaim_begin: OK
[   14.328465] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   14.346311] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   14.365353] Testing event mm_vmscan_direct_reclaim_end: OK
[   14.384256] Testing event mm_vmscan_memcg_reclaim_end: OK
[   14.401203] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   14.418139] Testing event mm_shrink_slab_start: OK
[   14.435104] Testing event mm_shrink_slab_end: OK
[   14.452066] Testing event mm_vmscan_lru_isolate: OK
[   14.468980] Testing event mm_vmscan_memcg_isolate: OK
[   14.485989] Testing event mm_vmscan_writepage: OK
[   14.502884] Testing event mm_vmscan_lru_shrink_inactive: OK
[   14.519875] Testing event replace_swap_token: OK
[   14.536820] Testing event put_swap_token: OK
[   14.553811] Testing event disable_swap_token: OK
[   14.570665] Testing event update_swap_token_priority: OK
[   14.587628] Testing event cpu_idle: OK
[   14.607485] Testing event cpu_frequency: OK
[   14.623536] Testing event machine_suspend: OK
[   14.640501] Testing event power_start: OK
[   14.657452] Testing event power_frequency: OK
[   14.674363] Testing event power_end: OK
[   14.691385] Testing event clock_enable: OK
[   14.709298] Testing event clock_disable: OK
[   14.726233] Testing event clock_set_rate: OK
[   14.743188] Testing event power_domain_target: OK
[   14.761119] Testing event ftrace_test_filter: OK
[   14.778144] Testing event module_load: OK
[   14.795878] Testing event module_free: OK
[   14.811974] Testing event module_get: OK
[   14.828941] Testing event module_put: OK
[   14.845758] Testing event module_request: OK
[   14.862726] Testing event lock_acquire: OK
[   14.879753] Testing event lock_release: OK
[   14.896691] Testing event lock_contended: OK
[   14.913620] Testing event lock_acquired: OK
[   14.930561] Testing event rcu_utilization: OK
[   14.947549] Testing event rcu_grace_period: OK
[   14.964447] Testing event rcu_grace_period_init: OK
[   14.981403] Testing event rcu_preempt_task: OK
[   14.998335] Testing event rcu_unlock_preempted_task: OK
[   15.015308] Testing event rcu_quiescent_state_report: OK
[   15.032248] Testing event rcu_fqs: OK
[   15.049197] Testing event rcu_dyntick: OK
[   15.066159] Testing event rcu_callback: OK
[   15.084130] Testing event rcu_kfree_callback: OK
[   15.101072] Testing event rcu_batch_start: OK
[   15.117980] Testing event rcu_invoke_callback: OK
[   15.134931] Testing event rcu_invoke_kfree_callback: OK
[   15.151877] Testing event rcu_batch_end: OK
[   15.168830] Testing event rcu_torture_read: OK
[   15.185775] Testing event workqueue_queue_work: OK
[   15.202740] Testing event workqueue_activate_work: OK
[   15.219652] Testing event workqueue_execute_start: OK
[   15.236551] Testing event workqueue_execute_end: OK
[   15.253565] Testing event signal_generate: OK
[   15.270496] Testing event signal_deliver: OK
[   15.287460] Testing event signal_overflow_fail: OK
[   15.304410] Testing event signal_lose_info: OK
[   15.321322] Testing event timer_init: OK
[   15.338283] Testing event timer_start: OK
[   15.355268] Testing event timer_expire_entry: OK
[   15.372238] Testing event timer_expire_exit: OK
[   15.389173] Testing event timer_cancel: OK
[   15.407164] Testing event hrtimer_init: OK
[   15.424161] Testing event hrtimer_start: OK
[   15.440993] Testing event hrtimer_expire_entry: OK
[   15.457954] Testing event hrtimer_expire_exit: OK
[   15.477059] Testing event hrtimer_cancel: OK
[   15.495808] Testing event itimer_state: OK
[   15.513789] Testing event itimer_expire: OK
[   15.531822] Testing event irq_handler_entry: OK
[   15.550592] Testing event irq_handler_exit: OK
[   15.569530] Testing event softirq_entry: OK
[   15.588466] Testing event softirq_exit: OK
[   15.605435] Testing event softirq_raise: OK
[   15.622403] Testing event sched_kthread_stop: OK
[   15.639355] Testing event sched_kthread_stop_ret: OK
[   15.656244] Testing event sched_wakeup: OK
[   15.672258] Testing event sched_wakeup_new: OK
[   15.689257] Testing event sched_switch: OK
[   15.706200] Testing event sched_migrate_task: OK
[   15.723108] Testing event sched_process_free: OK
[   15.739990] Testing event sched_process_exit: OK
[   15.757082] Testing event sched_wait_task: OK
[   15.773971] Testing event sched_process_wait: OK
[   15.790769] Testing event sched_process_fork: OK
[   15.806703] Testing event sched_stat_wait: OK
[   15.823828] Testing event sched_stat_sleep: OK
[   15.842593] Testing event sched_stat_iowait: OK
[   15.859524] Testing event sched_stat_runtime: OK
[   15.877757] Testing event sched_pi_setprio: OK
[   15.895442] Testing event mce_record: OK
[   15.913639] Testing event sys_enter: OK
[   15.932412] Testing event sys_exit: OK
[   15.951407] Testing event emulate_vsyscall: OK
[   15.970194] Testing event kvm_mmu_pagetable_walk: OK
[   15.987330] Testing event kvm_mmu_paging_element: OK
[   16.005090] Testing event kvm_mmu_set_accessed_bit: OK
[   16.021182] Testing event kvm_mmu_set_dirty_bit: OK
[   16.038034] Testing event kvm_mmu_walker_error: OK
[   16.053962] Testing event kvm_mmu_get_page: OK
[   16.071105] Testing event kvm_mmu_sync_page: OK
[   16.088828] Testing event kvm_mmu_unsync_page: OK
[   16.107041] Testing event kvm_mmu_prepare_zap_page: OK
[   16.125797] Testing event kvm_mmu_delay_free_pages: OK
[   16.144837] Testing event mark_mmio_spte: OK
[   16.163604] Testing event handle_mmio_page_fault: OK
[   16.179771] Testing event kvm_mmu_audit: OK
[   16.196676] Testing event kvm_entry: OK
[   16.213627] Testing event kvm_hypercall: OK
[   16.230570] Testing event kvm_hv_hypercall: OK
[   16.247498] Testing event kvm_pio: OK
[   16.264257] Testing event kvm_cpuid: OK
[   16.280249] Testing event kvm_apic: OK
[   16.297166] Testing event kvm_exit: OK
[   16.313157] Testing event kvm_inj_virq: OK
[   16.329130] Testing event kvm_inj_exception: OK
[   16.345075] Testing event kvm_page_fault: OK
[   16.361015] Testing event kvm_msr: OK
[   16.376977] Testing event kvm_cr: OK
[   16.392911] Testing event kvm_pic_set_irq: OK
[   16.408846] Testing event kvm_apic_ipi: OK
[   16.424812] Testing event kvm_apic_accept_irq: OK
[   16.440717] Testing event kvm_nested_vmrun: OK
[   16.456699] Testing event kvm_nested_intercepts: OK
[   16.472653] Testing event kvm_nested_vmexit: OK
[   16.488599] Testing event kvm_nested_vmexit_inject: OK
[   16.504590] Testing event kvm_nested_intr_vmexit: OK
[   16.520481] Testing event kvm_invlpga: OK
[   16.536466] Testing event kvm_skinit: OK
[   16.552374] Testing event kvm_emulate_insn: OK
[   16.568361] Testing event vcpu_match_mmio: OK
[   16.584295] Testing event kvm_userspace_exit: OK
[   16.602507] Testing event kvm_set_irq: OK
[   16.621264] Testing event kvm_ioapic_set_irq: OK
[   16.640373] Testing event kvm_msi_set_irq: OK
[   16.660145] Testing event kvm_ack_irq: OK
[   16.679224] Testing event kvm_mmio: OK
[   16.698206] Testing event kvm_fpu: OK
[   16.716906] Testing event kvm_age_page: OK
[   16.735032] Testing event kvm_try_async_get_page: OK
[   16.753857] Testing event kvm_async_pf_doublefault: OK
[   16.771896] Testing event kvm_async_pf_not_present: OK
[   16.790772] Testing event kvm_async_pf_ready: OK
[   16.807788] Testing event kvm_async_pf_completed: OK
[   16.824739] Running tests on trace event systems:
[   16.825063] Testing event system skb: OK
[   16.841756] Testing event system net: OK
[   16.858687] Testing event system napi: OK
[   16.875493] Testing event system sock: OK
[   16.892585] Testing event system udp: OK
[   16.910343] Testing event system hda: OK
[   16.927519] Testing event system scsi: OK
[   16.944394] Testing event system i915: OK
[   16.963213] Testing event system drm: OK
[   16.980336] Testing event system block: OK
[   16.997964] Testing event system btrfs: OK
[   17.016128] Testing event system xfs: OK
[   17.065772] Testing event system jbd2: OK
[   17.083193] Testing event system jbd: OK
[   17.101458] Testing event system ext4: OK
[   17.126127] Testing event system ext3: OK
[   17.146425] Testing event system writeback: OK
[   17.165841] Testing event system kmem: OK
[   17.182899] Testing event system vmscan: OK
[   17.201137] Testing event system power: OK
[   17.217776] Testing event system test: OK
[   17.234349] Testing event system module: OK
[   17.251381] Testing event system lock: OK
[   17.270523] Testing event system rcu: OK
[   17.288683] Testing event system workqueue: OK
[   17.305382] Testing event system signal: OK
[   17.322149] Testing event system timer: OK
[   17.341409] Testing event system irq: OK
[   17.360215] Testing event system sched: OK
[   17.377690] Testing event system mce: OK
[   17.394028] Testing event system raw_syscalls: OK
[   17.410908] Testing event system vsyscall: OK
[   17.427803] Testing event system syscalls: OK
[   17.446138] Testing event system kvmmmu: OK
[   17.464279] Testing event system kvm: OK
[   17.484239] Running tests on all trace events:
[   17.484553] Testing all events: OK
[   17.615751] ------------[ cut here ]------------
[   17.616076] WARNING: at /c/wfg/linux-next/kernel/trace/trace_events.c:1721 event_trace_self_tests_init+0x33/0x66()
[   17.616729] Hardware name:         
[   17.617008] Modules linked in:
[   17.617306] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #889
[   17.617890] Call Trace:
[   17.618134]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[   17.618507]  [<ffffffff8212c832>] ? test_work+0x64/0x64
[   17.618854]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
[   17.619221]  [<ffffffff8212c865>] event_trace_self_tests_init+0x33/0x66
[   17.619617]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[   17.622950]  [<ffffffff82111c16>] kernel_init+0xcb/0x14f
[   17.623298]  [<ffffffff8198d1c4>] kernel_thread_helper+0x4/0x10
[   17.623670]  [<ffffffff819845f4>] ? retint_restore_args+0x13/0x13
[   17.624046]  [<ffffffff82111b4b>] ? start_kernel+0x390/0x390
[   17.624405]  [<ffffffff8198d1c0>] ? gs_change+0x13/0x13
[   17.624750] ---[ end trace 4eaa2a86a8e2da2d ]---
[   17.625070] Failed to enable function tracer for event tests
[   17.625429] Testing ftrace filter: OK
[   17.626196] Testing kprobe tracing: OK
[   17.659594]   Magic number: 3:103:455
[   17.659992] netconsole: local port 6665
[   17.660284] netconsole: local IP 10.0.0.0
[   17.660587] netconsole: interface 'eth0'
[   17.660881] netconsole: remote port 6666
[   17.661176] netconsole: remote IP 192.168.1.1
[   17.661487] netconsole: remote ethernet address 00:30:48:fe:19:95
[   17.661865] netconsole: device eth0 not up yet, forcing it
[   17.750733] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   17.801246] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   17.801930] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.694096] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   20.694904] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.699220] console [netcon0] enabled
[   20.699510] netconsole: network logging started
[   20.700064] rtc_cmos 00:02: setting system clock to 2011-11-02 00:29:32 UTC (1320193772)
[   20.715224] IP-Config: Complete:
[   20.715514]      device=eth0, addr=192.168.1.52, mask=255.255.255.0, gw=192.168.1.1,
[   20.716100]      host=fat, domain=, nis-domain=(none),
[   20.716498]      bootserver=192.168.1.11, rootserver=192.168.1.11, rootpath=
[   20.717545] md: Waiting for all devices to be available before autodetect
[   20.717971] md: If you don't use raid, use raid=noautodetect
[   20.718921] md: Autodetecting RAID arrays.
[   20.719256] md: Scanned 0 and added 0 devices.
[   20.719589] md: autorun ...
[   20.719857] md: ... autorun DONE.
[   21.724351] VFS: Mounted root (nfs filesystem) on device 0:16.
[   21.724782] debug: unmapping init memory ffffffff81f3c000..ffffffff821f0000
[   21.830299] startpar used greatest stack depth: 3752 bytes left
[   21.846163] uname used greatest stack depth: 3672 bytes left
[   21.887814] S02hostname.sh used greatest stack depth: 3640 bytes left
[   21.908580] mountpoint used greatest stack depth: 3544 bytes left
[   22.199611] input_id used greatest stack depth: 3512 bytes left
[   22.369388] amixer used greatest stack depth: 3496 bytes left
[   23.766864] EXT4-fs (sda5): recovery complete
[   23.767260] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   25.594368] nfsroot-fat used greatest stack depth: 3480 bytes left
[   25.618794] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   25.619468] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   25.621931] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   25.622500] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   25.758132] rc used greatest stack depth: 3272 bytes left
[   26.209054] xauth used greatest stack depth: 3160 bytes left
[   26.288790] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   26.290260] NFSD: starting 90-second grace period

> ------------------------------------------------------------------------
> 
> rcu: Add more information to the wrong-idle-task complaint
> 
> The current code just complains if the current task is not the idle task.
> This commit therefore adds printing of the identity of the idle task.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index e0df33f..f4e7bc3 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -66,10 +66,14 @@ static void rcu_idle_enter_common(long long oldval)
>  	}
>  	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
>  	if (!idle_cpu(smp_processor_id())) {
> -		WARN_ON_ONCE(1);	/* must be idle task! */
> +		struct task_struct *idle = idle_task(smp_processor_id());
> +
>  		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
>  					    oldval, rcu_dynticks_nesting));
>  		ftrace_dump(DUMP_ALL);
> +		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
> +			  current->pid, current->comm,
> +			  idle->pid, idle->comm); /* must be idle task! */
>  	}
>  	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
>  }
> @@ -116,10 +120,14 @@ static void rcu_idle_exit_common(long long oldval)
>  	}
>  	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
>  	if (!idle_cpu(smp_processor_id())) {
> -		WARN_ON_ONCE(1);	/* must be idle task! */
> +		struct task_struct *idle = idle_task(smp_processor_id());
> +
>  		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
>  			  oldval, rcu_dynticks_nesting));
>  		ftrace_dump(DUMP_ALL);
> +		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
> +			  current->pid, current->comm,
> +			  idle->pid, idle->comm); /* must be idle task! */
>  	}
>  }
>  
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index cc04876..2a8d9a6 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -356,10 +356,14 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
>  	}
>  	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
>  	if (!idle_cpu(smp_processor_id())) {
> -		WARN_ON_ONCE(1);	/* must be idle task! */
> +		struct task_struct *idle = idle_task(smp_processor_id());
> +
>  		trace_rcu_dyntick("Error on entry: not idle task",
>  				   oldval, rdtp->dynticks_nesting);
>  		ftrace_dump(DUMP_ALL);
> +		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
> +			  current->pid, current->comm,
> +			  idle->pid, idle->comm); /* must be idle task! */
>  	}
>  	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
>  	smp_mb__before_atomic_inc();  /* See above. */
> @@ -445,10 +449,14 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
>  	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
>  	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
>  	if (!idle_cpu(smp_processor_id())) {
> -		WARN_ON_ONCE(1);	/* must be idle task! */
> +		struct task_struct *idle = idle_task(smp_processor_id());
> +
>  		trace_rcu_dyntick("Error on exit: not idle task",
>  				  oldval, rdtp->dynticks_nesting);
>  		ftrace_dump(DUMP_ALL);
> +		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
> +			  current->pid, current->comm,
> +			  idle->pid, idle->comm); /* must be idle task! */
>  	}
>  }
>  

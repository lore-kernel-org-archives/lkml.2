Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447Ab1JaMbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 08:31:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:20948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932848Ab1JaMbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 08:31:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,432,1315206000"; 
   d="scan'208";a="68794971"
Date: Mon, 31 Oct 2011 20:31:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111031123125.GA6162@localhost>
References: <20111031082634.GA10348@localhost>
 <20111031095152.GL6160@linux.vnet.ibm.com>
 <20111031104325.GA25808@localhost>
 <20111031114142.GA32555@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031114142.GA32555@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 07:41:42PM +0800, Wu Fengguang wrote:
> On Mon, Oct 31, 2011 at 06:43:25PM +0800, Wu Fengguang wrote:
> > On Mon, Oct 31, 2011 at 05:51:52PM +0800, Paul E. McKenney wrote:
> > > On Mon, Oct 31, 2011 at 04:26:34PM +0800, Wu Fengguang wrote:
> > > > Hi Paul,
> > > >
> > > > I got two warnings in rcutree.c. The last working kernels are
> > > > linux-next 20111014 and linux v3.1.
> > > 
> > > Interesting.  Could you please enable RCU event tracing at boot?
> > 
> > Sorry I cannot...possibly due to another ftrace bug.
> > 
> > > The RCU event tracing is at tracing/events/rcu/enable relative to
> > > the debugfs mount point at runtime, if that helps.
> > 
> > It's exactly that linux next 20111025 (comparing to 20111014) no
> > longer produces all the trace events that made me looking into the
> > dmesg and find the warning from RCU (rather than the expected warning
> > from ftrace).
> > 
> > The trace output is now:
> > 
> >         # tracer: nop
> >         #
> >         # WARNING: FUNCTION TRACING IS CORRUPTED
> >         #          MAY BE MISSING FUNCTION EVENTS
> >         #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> >         #              | |       |          |         |
> > (nothing more)
> 
> I checked the other test box and got the same warnings. Below is the
> full dmesg.

Here is another dmesg showing the warnings inside kvm.

btw, I turned on the ftrace self tests and it shows a warning, too.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-ioless-full-next-20111025+ (wfg@bee) (gcc version 4.5.0 (GCC) ) #883 SMP Mon Oct 31 20:20:26 CST 2011
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
[    0.000000] early log buf free: 258224(98%)
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
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff8800b7c00000 s1917184 r8192 d24320 u2097152
[    0.000000] pcpu-alloc: s1917184 r8192 d24320 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07
[    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 771274
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hpet=disable run=/home/wfg/ioless-balance_dirty_pages/test-each-fs.sh log_buf_len=8M debug sched_debug apic=debug dynamic_printk drm.debug=6 sysrq_always_enabled panic=10 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 netconsole=@:/eth0,6666@192.168.1.1/00:30:48:fe:19:95 ip=192.168.1.52:192.168.1.11:192.168.1.1:255.255.255.0:fat:eth0:none nfsroot=192.168.1.11:/nfsroot/wfg,tcp,v3,nocto,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-3.1.0-ioless-full-next-20111025+
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 3012392k/3137536k available (9805k kernel code, 3396k absent, 121748k reserved, 5807k data, 2772k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  RCU torture testing starts during boot.
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
[    0.002000] Detected 3199.835 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6399.67 BogoMIPS (lpj=3199835)
[    0.000706] pid_max: default: 32768 minimum: 301
[    0.001895] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003957] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004956] Mount-cache hash table entries: 256
[    0.005662] Initializing cgroup subsys debug
[    0.005971] Initializing cgroup subsys cpuacct
[    0.006302] Initializing cgroup subsys memory
[    0.006638] Initializing cgroup subsys devices
[    0.006952] Initializing cgroup subsys freezer
[    0.007277] Initializing cgroup subsys blkio
[    0.007641] CPU: Physical Processor ID: 0
[    0.007938] CPU: Processor Core ID: 0
[    0.008236] mce: CPU supports 9 MCE banks
[    0.008540] CPU0: Thermal monitoring enabled (TM1)
[    0.008875] using mwait in idle threads.
[    0.010033] ACPI: Core revision 20110623
[    0.021714] ftrace: allocating 38119 entries in 150 pages
[    0.030688] Getting VERSION: 60015
[    0.030964] Getting VERSION: 60015
[    0.031249] Getting ID: 0
[    0.031494] Getting ID: 0
[    0.031740] Switched APIC routing to physical flat.
[    0.032070] enabled ExtINT on CPU#0
[    0.032579] ENABLING IO-APIC IRQs
[    0.032850] init IO_APIC IRQs
[    0.033109]  apic 8 pin 0 not connected
[    0.033414] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.033977] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.034549] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.035113] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.035679] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.036245] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.036808] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.037373] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.037936] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.038503] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.039072] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.039642] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.040213] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.040780] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.041351] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.041918]  apic 8 pin 16 not connected
[    0.042214]  apic 8 pin 17 not connected
[    0.042507]  apic 8 pin 18 not connected
[    0.042801]  apic 8 pin 19 not connected
[    0.043095]  apic 8 pin 20 not connected
[    0.043390]  apic 8 pin 21 not connected
[    0.043682]  apic 8 pin 22 not connected
[    0.043976]  apic 8 pin 23 not connected
[    0.044406] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054776] CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
[    0.055258] Using local APIC timer interrupts.
[    0.055259] calibrating APIC timer ...
[    0.157165] ... lapic delta = 833239
[    0.157445] ... PM-Timer delta = 357901
[    0.157735] ... PM-Timer result ok
[    0.158009] ..... delta 833239
[    0.158271] ..... mult: 35792783
[    0.158539] ..... calibration result: 133318
[    0.158846] ..... CPU clock speed is 3199.0635 MHz.
[    0.159176] ..... host bus clock speed is 133.0318 MHz.
[    0.159531] Performance Events: PEBS fmt1+, erratum AAJ80 worked around, Nehalem events, Intel PMU driver.
[    0.160292] ... version:                3
[    0.160592] ... bit width:              48
[    0.160892] ... generic registers:      4
[    0.161190] ... value mask:             0000ffffffffffff
[    0.161537] ... max period:             000000007fffffff
[    0.161881] ... fixed-purpose events:   3
[    0.162179] ... event mask:             000000070000000f
[    0.162728] Testing tracer nop: PASSED
[    0.163141] lockdep: fixing up alternatives.
[    0.163505] Booting Node   0, Processors  #1
[    0.163728] smpboot cpu 1: start_ip = 97000
[    0.175296] masked ExtINT on CPU#1
[    0.195528] ------------[ cut here ]------------
[    0.195644] lockdep: fixing up alternatives.
[    0.195667]  #2
[    0.195667] smpboot cpu 2: start_ip = 97000
[    0.196674] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:444 rcu_idle_exit_common+0xd2/0x117()
[    0.197264] Hardware name:
[    0.197542] Modules linked in:
[    0.197839] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-ioless-full-next-20111025+ #883
[    0.201340] Call Trace:
[    0.201579]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    0.202009]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
[    0.202374]  [<ffffffff810d77d1>] rcu_idle_exit_common+0xd2/0x117
[    0.202749]  [<ffffffff810d7cd3>] rcu_irq_enter+0x75/0xa2
[    0.203098]  [<ffffffff8107ac7f>] irq_enter+0x1b/0x74
[    0.203435]  [<ffffffff8106f29e>] scheduler_ipi+0x5e/0xd5
[    0.203784]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
[    0.204169]  [<ffffffff8198ea73>] reschedule_interrupt+0x73/0x80
[    0.204540]  <EOI>  [<ffffffff8198951f>] ? notifier_call_chain+0x63/0x63
[    0.204973]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
[    0.205322]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
[    0.205672]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
[    0.206013]  [<ffffffff8197bad5>] start_secondary+0x1de/0x1e2
[    0.206400] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.206721] Dumping ftrace buffer:
[    0.206774] masked ExtINT on CPU#2
[    0.207272]    (ftrace buffer empty)
[    0.207557] ------------[ cut here ]------------
[    0.207879] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:359 rcu_idle_enter_common+0xb3/0x130()
[    0.208471] Hardware name:
[    0.208748] Modules linked in:
[    0.209044] Pid: 0, comm: kworker/0:0 Tainted: G        W   3.1.0-ioless-full-next-20111025+ #883
[    0.209636] Call Trace:
[    0.209875]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    0.210304]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
[    0.210668]  [<ffffffff810d78c9>] rcu_idle_enter_common+0xb3/0x130
[    0.211046]  [<ffffffff810d7b8c>] rcu_irq_exit+0x6b/0x95
[    0.211393]  [<ffffffff8107ad88>] irq_exit+0xb0/0xb2
[    0.211726]  [<ffffffff8106f310>] scheduler_ipi+0xd0/0xd5
[    0.212075]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
[    0.212461]  [<ffffffff8198ea73>] reschedule_interrupt+0x73/0x80
[    0.212831]  <EOI>  [<ffffffff8198951f>] ? notifier_call_chain+0x63/0x63
[    0.213265]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
[    0.213613]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
[    0.213964]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
[    0.214296]  [<ffffffff8197bad5>] start_secondary+0x1de/0x1e2
[    0.214657] ---[ end trace 4eaa2a86a8e2da23 ]---
[    0.227000] lockdep: fixing up alternatives.
[    0.227332]  #3
[    0.227424] smpboot cpu 3: start_ip = 97000
[    0.238992] masked ExtINT on CPU#3
[    0.259314] lockdep: fixing up alternatives.
[    0.259652]  #4
[    0.259743] smpboot cpu 4: start_ip = 97000
[    0.271308] masked ExtINT on CPU#4
[    0.291641] lockdep: fixing up alternatives.
[    0.291973]  #5
[    0.292065] smpboot cpu 5: start_ip = 97000
[    0.303634] masked ExtINT on CPU#5
[    0.323959] lockdep: fixing up alternatives.
[    0.324295]  #6
[    0.324387] smpboot cpu 6: start_ip = 97000
[    0.335957] masked ExtINT on CPU#6
[    0.356279] lockdep: fixing up alternatives.
[    0.356619]  #7
[    0.356711] smpboot cpu 7: start_ip = 97000
[    0.368276] masked ExtINT on CPU#7
[    0.388497] Brought up 8 CPUs
[    0.388759] Total of 8 processors activated (51197.36 BogoMIPS).
[    0.392515] CPU0 attaching sched-domain:
[    0.392814]  domain 0: span 0,4 level SIBLING
[    0.393158]   groups: 0 (cpu_power = 589) 4 (cpu_power = 589)
[    0.393692]   domain 1: span 0-7 level MC
[    0.394023]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    0.394977] CPU1 attaching sched-domain:
[    0.395272]  domain 0: span 1,5 level SIBLING
[    0.395618]   groups: 1 (cpu_power = 589) 5 (cpu_power = 589)
[    0.396147]   domain 1: span 0-7 level MC
[    0.396480]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    0.397429] CPU2 attaching sched-domain:
[    0.397726]  domain 0: span 2,6 level SIBLING
[    0.398069]   groups: 2 (cpu_power = 589) 6 (cpu_power = 589)
[    0.398601]   domain 1: span 0-7 level MC
[    0.398932]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    0.399884] CPU3 attaching sched-domain:
[    0.400178]  domain 0: span 3,7 level SIBLING
[    0.400523]   groups: 3 (cpu_power = 589) 7 (cpu_power = 589)
[    0.401052]   domain 1: span 0-7 level MC
[    0.401382]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    0.402333] CPU4 attaching sched-domain:
[    0.402629]  domain 0: span 0,4 level SIBLING
[    0.402972]   groups: 4 (cpu_power = 589) 0 (cpu_power = 589)
[    0.403503]   domain 1: span 0-7 level MC
[    0.403832]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    0.404784] CPU5 attaching sched-domain:
[    0.405079]  domain 0: span 1,5 level SIBLING
[    0.405421]   groups: 5 (cpu_power = 589) 1 (cpu_power = 589)
[    0.405953]   domain 1: span 0-7 level MC
[    0.406283]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    0.407235] CPU6 attaching sched-domain:
[    0.407532]  domain 0: span 2,6 level SIBLING
[    0.407875]   groups: 6 (cpu_power = 589) 2 (cpu_power = 589)
[    0.408404]   domain 1: span 0-7 level MC
[    0.408738]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    0.409690] CPU7 attaching sched-domain:
[    0.409983]  domain 0: span 3,7 level SIBLING
[    0.410326]   groups: 7 (cpu_power = 589) 3 (cpu_power = 589)
[    0.410858]   domain 1: span 0-7 level MC
[    0.411188]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    0.412583] devtmpfs: initialized
[    0.413849] PM: Registering ACPI NVS region at bcde3000 (2195456 bytes)
[    0.414302] PM: Registering ACPI NVS region at bf714000 (700416 bytes)
[    0.415374] xor: automatically using best checksumming function: generic_sse
[    0.420460]    generic_sse: 11932.000 MB/sec
[    0.420767] xor: using function: generic_sse (11932.000 MB/sec)
[    0.421254] kworker/u:0 used greatest stack depth: 5608 bytes left
[    0.421282] RTC time: 20:23:51, date: 10/31/11
[    0.421367] NET: Registered protocol family 16
[    0.422265] kworker/u:0 used greatest stack depth: 5192 bytes left
[    0.423152] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.423707] ACPI: bus type pci registered
[    0.424204] dca service started, version 1.12.1
[    0.424604] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.425215] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.437325] PCI: Using configuration type 1 for base access
[    0.462834] bio: create slab <bio-0> at 0
[    0.479454] raid6: int64x1   3171 MB/s
[    0.496442] raid6: int64x2   3421 MB/s
[    0.513451] raid6: int64x4   2742 MB/s
[    0.530455] raid6: int64x8   2093 MB/s
[    0.547428] raid6: sse2x1    7933 MB/s
[    0.564422] raid6: sse2x2    9285 MB/s
[    0.581417] raid6: sse2x4   10789 MB/s
[    0.581704] raid6: using algorithm sse2x4 (10789 MB/s)
[    0.582126] ACPI: Added _OSI(Module Device)
[    0.582437] ACPI: Added _OSI(Processor Device)
[    0.582752] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.583076] ACPI: Added _OSI(Processor Aggregator Device)
[    0.587430] ACPI: EC: Look up EC in DSDT
[    0.608433] ACPI: Interpreter enabled
[    0.608719] ACPI: (supports S0 S1 S3 S4 S5)
[    0.609226] ACPI: Using IOAPIC for interrupt routing
[    0.622177] ACPI: No dock devices found.
[    0.622480] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.623682] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3d])
[    0.625283] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.625683] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.626076] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.626614] pci_root PNP0A03:00: host bridge window [mem 0x000c4000-0x000cbfff]
[    0.627149] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfedfffff]
[    0.628161] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xf7ffffff]
[    0.628722] pci 0000:00:00.0: [8086:3405] type 0 class 0x000600
[    0.629160] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    0.629591] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.629974] pci 0000:00:01.0: PME# disabled
[    0.630302] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    0.630731] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.631108] pci 0000:00:03.0: PME# disabled
[    0.631448] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    0.631872] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.632248] pci 0000:00:07.0: PME# disabled
[    0.632586] pci 0000:00:10.0: [8086:3425] type 0 class 0x000800
[    0.633029] pci 0000:00:10.1: [8086:3426] type 0 class 0x000800
[    0.633480] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    0.633924] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    0.634366] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    0.634810] pci 0000:00:14.3: [8086:3438] type 0 class 0x000800
[    0.635256] pci 0000:00:19.0: [8086:10cc] type 0 class 0x000200
[    0.635647] pci 0000:00:19.0: reg 10: [mem 0xe0300000-0xe031ffff]
[    0.636031] pci 0000:00:19.0: reg 14: [mem 0xe0323000-0xe0323fff]
[    0.636417] pci 0000:00:19.0: reg 18: [io  0x2100-0x211f]
[    0.636825] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.637204] pci 0000:00:19.0: PME# disabled
[    0.637535] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    0.637955] pci 0000:00:1a.0: reg 20: [io  0x20e0-0x20ff]
[    0.638357] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
[    0.638782] pci 0000:00:1a.1: reg 20: [io  0x20c0-0x20df]
[    0.642143] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    0.642566] pci 0000:00:1a.2: reg 20: [io  0x20a0-0x20bf]
[    0.642978] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    0.643366] pci 0000:00:1a.7: reg 10: [mem 0xe0322000-0xe03223ff]
[    0.643833] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.644210] pci 0000:00:1a.7: PME# disabled
[    0.644543] pci 0000:00:1b.0: [8086:3a3e] type 0 class 0x000403
[    0.644927] pci 0000:00:1b.0: reg 10: [mem 0xf7f00000-0xf7f03fff 64bit]
[    0.645390] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.645770] pci 0000:00:1b.0: PME# disabled
[    0.646095] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    0.646534] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.646911] pci 0000:00:1c.0: PME# disabled
[    0.647238] pci 0000:00:1c.1: [8086:3a42] type 1 class 0x000604
[    0.647681] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.648058] pci 0000:00:1c.1: PME# disabled
[    0.648387] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    0.648828] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.649205] pci 0000:00:1c.4: PME# disabled
[    0.649539] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    0.649960] pci 0000:00:1d.0: reg 20: [io  0x2080-0x209f]
[    0.650364] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    0.650788] pci 0000:00:1d.1: reg 20: [io  0x2060-0x207f]
[    0.651190] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    0.651614] pci 0000:00:1d.2: reg 20: [io  0x2040-0x205f]
[    0.652025] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    0.652416] pci 0000:00:1d.7: reg 10: [mem 0xe0321000-0xe03213ff]
[    0.652876] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.653253] pci 0000:00:1d.7: PME# disabled
[    0.653579] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.654016] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    0.654485] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.654866] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.655415] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
[    0.656006] pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
[    0.656397] pci 0000:00:1f.2: reg 10: [io  0x2128-0x212f]
[    0.656755] pci 0000:00:1f.2: reg 14: [io  0x2134-0x2137]
[    0.657111] pci 0000:00:1f.2: reg 18: [io  0x2120-0x2127]
[    0.657470] pci 0000:00:1f.2: reg 1c: [io  0x2130-0x2133]
[    0.657826] pci 0000:00:1f.2: reg 20: [io  0x2020-0x203f]
[    0.658183] pci 0000:00:1f.2: reg 24: [mem 0xe0320000-0xe03207ff]
[    0.658598] pci 0000:00:1f.2: PME# supported from D3hot
[    0.658943] pci 0000:00:1f.2: PME# disabled
[    0.659262] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    0.659650] pci 0000:00:1f.3: reg 10: [mem 0xf7f04000-0xf7f040ff 64bit]
[    0.660069] pci 0000:00:1f.3: reg 20: [io  0x2000-0x201f]
[    0.660496] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.660900] pci 0000:02:00.0: [5333:9043] type 0 class 0x000300
[    0.661278] pci 0000:02:00.0: reg 10: [mem 0xe0200000-0xe027ffff]
[    0.661663] pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff pref]
[    0.662090] pci 0000:02:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.662507] pci 0000:02:00.0: supports D1 D2
[    0.662838] pci 0000:02:00.1: [5333:903f] type 0 class 0x000403
[    0.663217] pci 0000:02:00.1: reg 10: [mem 0xe0280000-0xe0283fff]
[    0.663662] pci 0000:02:00.1: supports D1 D2
[    0.663987] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.664334] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.664741] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.665337] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.665741] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.666143] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    0.666573] pci 0000:06:00.0: [11ab:6121] type 0 class 0x000101
[    0.666963] pci 0000:06:00.0: reg 10: [io  0x1018-0x101f]
[    0.667328] pci 0000:06:00.0: reg 14: [io  0x1024-0x1027]
[    0.667695] pci 0000:06:00.0: reg 18: [io  0x1010-0x1017]
[    0.668061] pci 0000:06:00.0: reg 1c: [io  0x1020-0x1023]
[    0.668429] pci 0000:06:00.0: reg 20: [io  0x1000-0x100f]
[    0.668793] pci 0000:06:00.0: reg 24: [mem 0xe0100000-0xe01003ff]
[    0.669232] pci 0000:06:00.0: supports D1
[    0.669533] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
[    0.669900] pci 0000:06:00.0: PME# disabled
[    0.670225] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.670574] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.670951] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.671400] pci 0000:07:03.0: [104c:8023] type 0 class 0x000c00
[    0.671788] pci 0000:07:03.0: reg 10: [mem 0xe0004000-0xe00047ff]
[    0.672172] pci 0000:07:03.0: reg 14: [mem 0xe0000000-0xe0003fff]
[    0.672622] pci 0000:07:03.0: supports D1 D2
[    0.672929] pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
[    0.673303] pci 0000:07:03.0: PME# disabled
[    0.673663] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.674077] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.674485] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.675043] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.675603] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.676186] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000cbfff] (subtractive decode)
[    0.676772] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    0.677356] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xf7ffffff] (subtractive decode)
[    0.677976] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.679250] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.679873] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
[    0.680342] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
[    0.680812] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
[    0.681276] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.681747] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.682224] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.682789]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
[    0.706103] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.707183] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.708260] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.709342] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.710433] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.711512] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.712588] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.713666] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.714976] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.715552] vgaarb: loaded
[    0.715802] vgaarb: bridge control possible 0000:02:00.0
[    0.716360] SCSI subsystem initialized
[    0.716828] libata version 3.00 loaded.
[    0.717383] usbcore: registered new interface driver usbfs
[    0.717798] usbcore: registered new interface driver hub
[    0.718221] usbcore: registered new device driver usb
[    0.719029] wmi: Mapper loaded
[    0.719354] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.719743] PCI: Using ACPI for IRQ routing
[    0.721630] PCI: Discovered peer bus 3f
[    0.722006] pci 0000:3f:00.0: [8086:2c41] type 0 class 0x000600
[    0.722414] pci 0000:3f:00.1: [8086:2c01] type 0 class 0x000600
[    0.722815] pci 0000:3f:02.0: [8086:2c10] type 0 class 0x000600
[    0.723210] pci 0000:3f:02.1: [8086:2c11] type 0 class 0x000600
[    0.723614] pci 0000:3f:03.0: [8086:2c18] type 0 class 0x000600
[    0.724010] pci 0000:3f:03.1: [8086:2c19] type 0 class 0x000600
[    0.724412] pci 0000:3f:03.4: [8086:2c1c] type 0 class 0x000600
[    0.724810] pci 0000:3f:04.0: [8086:2c20] type 0 class 0x000600
[    0.725205] pci 0000:3f:04.1: [8086:2c21] type 0 class 0x000600
[    0.725604] pci 0000:3f:04.2: [8086:2c22] type 0 class 0x000600
[    0.726000] pci 0000:3f:04.3: [8086:2c23] type 0 class 0x000600
[    0.726406] pci 0000:3f:05.0: [8086:2c28] type 0 class 0x000600
[    0.726802] pci 0000:3f:05.1: [8086:2c29] type 0 class 0x000600
[    0.727197] pci 0000:3f:05.2: [8086:2c2a] type 0 class 0x000600
[    0.727597] pci 0000:3f:05.3: [8086:2c2b] type 0 class 0x000600
[    0.727995] pci 0000:3f:06.0: [8086:2c30] type 0 class 0x000600
[    0.728397] pci 0000:3f:06.1: [8086:2c31] type 0 class 0x000600
[    0.728793] pci 0000:3f:06.2: [8086:2c32] type 0 class 0x000600
[    0.729189] pci 0000:3f:06.3: [8086:2c33] type 0 class 0x000600
[    0.731015] PCI: pci_cache_line_size set to 64 bytes
[    0.731589] reserve RAM buffer: 000000000009cc00 - 000000000009ffff
[    0.731851] reserve RAM buffer: 00000000bcde3000 - 00000000bfffffff
[    0.732270] reserve RAM buffer: 00000000bf6bd000 - 00000000bfffffff
[    0.732692] reserve RAM buffer: 00000000bf714000 - 00000000bfffffff
[    0.733111] reserve RAM buffer: 00000000bf7e7000 - 00000000bfffffff
[    0.733532] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff
[    0.762560] pnp: PnP ACPI init
[    0.763000] ACPI: bus type pnp registered
[    0.763912] pnp 00:00: [bus 00-3d]
[    0.764190] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.764498] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.764822] pnp 00:00: [io  0x0d00-0xffff window]
[    0.765145] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.765499] pnp 00:00: [mem 0x000c4000-0x000cbfff window]
[    0.765848] pnp 00:00: [mem 0xfed40000-0xfedfffff window]
[    0.766197] pnp 00:00: [mem 0xd0000000-0xf7ffffff window]
[    0.766554] pnp 00:00: [mem 0x00000000 window]
[    0.767007] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.767680] pnp 00:01: [io  0x0000-0x000f]
[    0.767981] pnp 00:01: [io  0x0081-0x0083]
[    0.768283] pnp 00:01: [io  0x0087]
[    0.768566] pnp 00:01: [io  0x0089-0x008b]
[    0.768867] pnp 00:01: [io  0x008f]
[    0.769145] pnp 00:01: [io  0x00c0-0x00df]
[    0.772393] pnp 00:01: [dma 4]
[    0.772749] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.773157] pnp 00:02: [io  0x0070-0x0071]
[    0.773464] pnp 00:02: [io  0x0074-0x0077]
[    0.773769] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.774333] pnp 00:02: [irq 8]
[    0.774696] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.775108] pnp 00:03: [io  0x00f0]
[    0.775395] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.775963] pnp 00:03: [irq 13]
[    0.776322] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.776737] pnp 00:04: [io  0x0061]
[    0.777115] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.777530] pnp 00:05: [io  0x0500-0x053f]
[    0.777830] pnp 00:05: [io  0x0400-0x047f]
[    0.778130] pnp 00:05: [io  0x0092]
[    0.778412] pnp 00:05: [io  0x0680-0x06ff]
[    0.778712] pnp 00:05: [io  0x0010-0x001f]
[    0.779012] pnp 00:05: [io  0x0072-0x0073]
[    0.779312] pnp 00:05: [io  0x0080]
[    0.779594] pnp 00:05: [io  0x0084-0x0086]
[    0.779894] pnp 00:05: [io  0x0088]
[    0.780172] pnp 00:05: [io  0x008c-0x008e]
[    0.780476] pnp 00:05: [io  0x0090-0x009f]
[    0.780954] system 00:05: [io  0x0500-0x053f] has been reserved
[    0.781323] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.781700] system 00:05: [io  0x0680-0x06ff] has been reserved
[    0.782070] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.782553] pnp 00:06: [io  0x0060]
[    0.782832] pnp 00:06: [io  0x0064]
[    0.783277] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.784224] pnp 00:07: [mem 0xfec00000-0xfec000ff]
[    0.784663] pnp 00:07: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.785189] pnp: PnP ACPI: found 8 devices
[    0.785495] ACPI: ACPI bus type pnp unregistered
[    0.796640] Switching to clocksource acpi_pm
[    0.797090] pci 0000:02:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.797718] PCI: max bus depth: 1 pci_try_num: 2
[    0.798129] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.798482] pci 0000:02:00.0: BAR 6: assigned [mem 0xe0290000-0xe029ffff pref]
[    0.799014] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.799365] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.799766] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.800334] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.800685] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.801037] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    0.801399] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.801742] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.802135] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.802543] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    0.802889] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.803324] IOAPIC[0]: Set routing entry (8-16 -> 0x29 -> IRQ 16 Mode:1 Active:1 Dest:0)
[    0.803892] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.804309] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.804712] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.805136] IOAPIC[0]: Set routing entry (8-17 -> 0x41 -> IRQ 17 Mode:1 Active:1 Dest:0)
[    0.805703] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.806121] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.806525] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.806929] pci 0000:00:1e.0: setting latency timer to 64
[    0.807286] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.807643] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.807998] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.808384] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.808765] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.809160] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.809542] pci_bus 0000:02: resource 1 [mem 0xe0200000-0xe02fffff]
[    0.809923] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.810460] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    0.810816] pci_bus 0000:06: resource 1 [mem 0xe0100000-0xe01fffff]
[    0.811210] pci_bus 0000:07: resource 1 [mem 0xe0000000-0xe00fffff]
[    0.811589] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.811945] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.812304] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.812684] pci_bus 0000:07: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.813078] pci_bus 0000:07: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.813459] pci_bus 0000:07: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.813839] pci_bus 0000:3f: resource 0 [io  0x0000-0xffff]
[    0.814208] pci_bus 0000:3f: resource 1 [mem 0x00000000-0xfffffffff]
[    0.814650] NET: Registered protocol family 2
[    0.815275] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.817692] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.821438] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    0.825039] TCP: Hash tables configured (established 524288 bind 65536)
[    0.825460] TCP reno registered
[    0.825791] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    0.826446] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    0.827206] NET: Registered protocol family 1
[    0.827723] RPC: Registered named UNIX socket transport module.
[    0.828112] RPC: Registered udp transport module.
[    0.828435] RPC: Registered tcp transport module.
[    0.828757] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.829199] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.829590] pci 0000:00:1a.0: Performing full reset
[    0.829936] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.830332] pci 0000:00:1a.1: Performing full reset
[    0.830678] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.831082] pci 0000:00:1a.2: Performing full reset
[    0.831582] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.831972] pci 0000:00:1d.0: Performing full reset
[    0.832342] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.832733] pci 0000:00:1d.1: Performing full reset
[    0.833094] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.833485] pci 0000:00:1d.2: Performing full reset
[    0.833975] pci 0000:02:00.0: Boot video device
[    0.834356] PCI: CLS 64 bytes, default 64
[    0.838553] Machine check injector initialized
[    0.840800] microcode: CPU0 sig=0x106a4, pf=0x2, revision=0x6
[    0.841193] microcode: CPU1 sig=0x106a4, pf=0x2, revision=0x6
[    0.841564] microcode: CPU2 sig=0x106a4, pf=0x2, revision=0x6
[    0.841937] microcode: CPU3 sig=0x106a4, pf=0x2, revision=0x6
[    0.842307] microcode: CPU4 sig=0x106a4, pf=0x2, revision=0x6
[    0.842680] microcode: CPU5 sig=0x106a4, pf=0x2, revision=0x6
[    0.843052] microcode: CPU6 sig=0x106a4, pf=0x2, revision=0x6
[    0.843424] microcode: CPU7 sig=0x106a4, pf=0x2, revision=0x6
[    0.843885] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.844950] audit: initializing netlink socket (disabled)
[    0.845331] type=2000 audit(1320092631.596:1): initialized
[    0.870393] rcu-torture:--- Start of test: nreaders=16 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
[    0.881087] Testing tracer function: .. no entries found ..FAILED!
[    0.995144] Testing tracer irqsoff:
[    1.009098] failed to start irqsoff tracer
[    1.009680] .. no entries found ..FAILED!
[    1.017100] Testing tracer wakeup:
[    1.032094] failed to start wakeup tracer
[    1.336420] .. no entries found ..FAILED!
[    1.343105] Testing tracer function_graph:
[    1.351196] Failed to init function_graph tracer, init returned -19
[    1.351740] FAILED!
[    1.361666] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.399513] kworker/u:0 used greatest stack depth: 5184 bytes left
[    1.417551] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.422116] fuse init (API version 7.17)
[    1.424882] JFS: nTxBlock = 8192, nTxLock = 65536
[    1.432874] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.443003] NILFS version 2 loaded
[    1.447850] Btrfs loaded
[    1.448140] msgmni has been set to 5883
[    1.457974] async_tx: api initialized (async)
[    1.459714] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.460793] io scheduler noop registered
[    1.461125] io scheduler deadline registered
[    1.461970] io scheduler cfq registered (default)
[    1.463410] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    1.464186] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    1.465430] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    1.469041] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.471672] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    1.472299] ACPI: Sleep Button [SLPB]
[    1.473615] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.474203] ACPI: Power Button [PWRF]
[    1.476577] ACPI: acpi_idle registered with cpuidle
[    1.477881] Monitor-Mwait will be used to enter C-1 state
[    1.479293] Monitor-Mwait will be used to enter C-3 state
[    1.498637] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.679634] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.687190] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    1.707995] Initializing Nozomi driver 2.1d
[    1.710528] Non-volatile memory driver v1.3
[    1.711711] Linux agpgart interface v0.103
[    1.712534] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.716138] Hangcheck: Using getrawmonotonic().
[    1.716720] [drm] Initialized drm 1.1.0 20060810
[    1.717046] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    1.836137] Refined TSC clocksource calibration: 3200.113 MHz.
[    1.836512] Switching to clocksource tsc
[    4.736235] floppy0: no floppy controllers found
[    4.737108] ------------[ cut here ]------------
[    4.737439] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.738034] Hardware name:
[    4.738316] VFS: do_fd_request called on non-open device
[    4.738667] Modules linked in:
[    4.738968] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #883
[    4.739557] Call Trace:
[    4.739803]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.740182]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.740552]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.740929]  [<ffffffff81985fbe>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.741315]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.741672]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.742034]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.742396]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.742774]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.743130]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.743473]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.743839]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.744193]  [<ffffffff8198ee04>] kernel_thread_helper+0x4/0x10
[    4.744569]  [<ffffffff81986234>] ? retint_restore_args+0x13/0x13
[    4.744952]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.745318]  [<ffffffff8198ee00>] ? gs_change+0x13/0x13
[    4.745667] ---[ end trace 4eaa2a86a8e2da24 ]---
[    4.746126] ------------[ cut here ]------------
[    4.746454] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.747050] Hardware name:
[    4.747334] VFS: do_fd_request called on non-open device
[    4.747684] Modules linked in:
[    4.747986] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #883
[    4.748575] Call Trace:
[    4.748821]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.749200]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.749570]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.749946]  [<ffffffff81985fbe>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.750332]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.750688]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.751051]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.751414]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.751790]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.752146]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.752486]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.752852]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.753207]  [<ffffffff8198ee04>] kernel_thread_helper+0x4/0x10
[    4.753586]  [<ffffffff81986234>] ? retint_restore_args+0x13/0x13
[    4.753968]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.754335]  [<ffffffff8198ee00>] ? gs_change+0x13/0x13
[    4.754684] ---[ end trace 4eaa2a86a8e2da25 ]---
[    4.755080] ------------[ cut here ]------------
[    4.755410] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.756007] Hardware name:
[    4.756291] VFS: do_fd_request called on non-open device
[    4.756645] Modules linked in:
[    4.756947] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #883
[    4.757539] Call Trace:
[    4.757785]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.758165]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.758536]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.758913]  [<ffffffff81985fbe>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.759300]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.759657]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.760021]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.760384]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.760760]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.761117]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.761458]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.761824]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.762177]  [<ffffffff8198ee04>] kernel_thread_helper+0x4/0x10
[    4.762554]  [<ffffffff81986234>] ? retint_restore_args+0x13/0x13
[    4.762935]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.763302]  [<ffffffff8198ee00>] ? gs_change+0x13/0x13
[    4.763651] ---[ end trace 4eaa2a86a8e2da26 ]---
[    4.764049] ------------[ cut here ]------------
[    4.764376] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.764971] Hardware name:
[    4.765253] VFS: do_fd_request called on non-open device
[    4.765604] Modules linked in:
[    4.765904] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #883
[    4.766491] Call Trace:
[    4.766736]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.767115]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.767485]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.767861]  [<ffffffff81985fbe>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.768247]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.768603]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.768966]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.769329]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.769705]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.770060]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.770402]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.770769]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.771122]  [<ffffffff8198ee04>] kernel_thread_helper+0x4/0x10
[    4.771500]  [<ffffffff81986234>] ? retint_restore_args+0x13/0x13
[    4.771884]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.772251]  [<ffffffff8198ee00>] ? gs_change+0x13/0x13
[    4.772600] ---[ end trace 4eaa2a86a8e2da27 ]---
[    4.772998] ------------[ cut here ]------------
[    4.773326] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.773924] Hardware name:
[    4.774207] VFS: do_fd_request called on non-open device
[    4.774560] Modules linked in:
[    4.774863] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #883
[    4.775454] Call Trace:
[    4.775701]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.776081]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.776452]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.776828]  [<ffffffff81985fbe>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.777216]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.777573]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.777936]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.778300]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.778677]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.779033]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.779374]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.779740]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.780092]  [<ffffffff8198ee04>] kernel_thread_helper+0x4/0x10
[    4.780468]  [<ffffffff81986234>] ? retint_restore_args+0x13/0x13
[    4.780850]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.781216]  [<ffffffff8198ee00>] ? gs_change+0x13/0x13
[    4.781564] ---[ end trace 4eaa2a86a8e2da28 ]---
[    4.781960] ------------[ cut here ]------------
[    4.782288] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.782883] Hardware name:
[    4.783166] VFS: do_fd_request called on non-open device
[    4.783517] Modules linked in:
[    4.783818] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #883
[    4.784407] Call Trace:
[    4.784652]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.785031]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.785401]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.785777]  [<ffffffff81985fbe>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.786162]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.786520]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.786881]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.787244]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.787621]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.787978]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.788320]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.788688]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.789041]  [<ffffffff8198ee04>] kernel_thread_helper+0x4/0x10
[    4.789419]  [<ffffffff81986234>] ? retint_restore_args+0x13/0x13
[    4.789803]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.790169]  [<ffffffff8198ee00>] ? gs_change+0x13/0x13
[    4.790520] ---[ end trace 4eaa2a86a8e2da29 ]---
[    4.790917] ------------[ cut here ]------------
[    4.791244] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.791842] Hardware name:
[    4.792126] VFS: do_fd_request called on non-open device
[    4.792478] Modules linked in:
[    4.792781] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #883
[    4.793371] Call Trace:
[    4.793618]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.793997]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.794366]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.794741]  [<ffffffff81985fbe>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.795126]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.795483]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.795847]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.796211]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.799554]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.799909]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.800249]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.800615]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.800969]  [<ffffffff8198ee04>] kernel_thread_helper+0x4/0x10
[    4.801345]  [<ffffffff81986234>] ? retint_restore_args+0x13/0x13
[    4.801727]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.802094]  [<ffffffff8198ee00>] ? gs_change+0x13/0x13
[    4.802442] ---[ end trace 4eaa2a86a8e2da2a ]---
[    4.802837] ------------[ cut here ]------------
[    4.803164] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.803760] Hardware name:
[    4.804043] VFS: do_fd_request called on non-open device
[    4.804395] Modules linked in:
[    4.804696] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #883
[    4.805284] Call Trace:
[    4.805529]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.805907]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.806276]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.806652]  [<ffffffff81985fbe>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.807038]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.807394]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.807757]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.808120]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.808497]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.808852]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.809192]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.809558]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.809912]  [<ffffffff8198ee04>] kernel_thread_helper+0x4/0x10
[    4.810288]  [<ffffffff81986234>] ? retint_restore_args+0x13/0x13
[    4.810670]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.811035]  [<ffffffff8198ee00>] ? gs_change+0x13/0x13
[    4.811384] ---[ end trace 4eaa2a86a8e2da2b ]---
[    4.824225] brd: module loaded
[    4.831093] loop: module loaded
[    4.834815] Loading iSCSI transport class v2.0-870.
[    4.840948] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    4.841319] Detecting Adaptec I2O RAID controllers...
[    4.842649] Adaptec aacraid driver 1.1-7[28000]-ms
[    4.844218] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.845599] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.07-k.
[    4.847258] iscsi: registered transport (qla4xxx)
[    4.848050] QLogic iSCSI HBA Driver
[    4.848815] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    4.849686] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    4.850682] megasas: 00.00.06.12-rc1 Wed. Oct. 5 17:00:00 PDT 2011
[    4.851546] mpt2sas version 09.100.00.01 loaded
[    4.854232] ahci 0000:00:1f.2: version 3.0
[    4.854575] IOAPIC[0]: Set routing entry (8-19 -> 0x61 -> IRQ 19 Mode:1 Active:1 Dest:0)
[    4.855155] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    4.855627] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    4.856056] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    4.856640] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems
[    4.857215] ahci 0000:00:1f.2: setting latency timer to 64
[    4.876583] scsi0 : ahci
[    4.878359] scsi1 : ahci
[    4.880713] scsi2 : ahci
[    4.882243] scsi3 : ahci
[    4.883772] scsi4 : ahci
[    4.885319] scsi5 : ahci
[    4.886945] ata1: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320100 irq 43
[    4.887504] ata2: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320180 irq 43
[    4.888054] ata3: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320200 irq 43
[    4.888609] ata4: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320280 irq 43
[    4.889158] ata5: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320300 irq 43
[    4.889713] ata6: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320380 irq 43
[    4.890301] ahci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.890729] ahci 0000:06:00.0: Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.
[    4.891403] ahci 0000:06:00.0: controller can't do NCQ, turning off CAP_NCQ
[    4.891817] ahci 0000:06:00.0: controller can't do PMP, turning off CAP_PMP
[    4.892236] ahci 0000:06:00.0: masking port_map 0x7 -> 0x3
[    4.892659] ahci: SSS flag set, parallel bus scan disabled
[    4.893059] ahci 0000:06:00.0: AHCI 0001.0000 32 slots 3 ports 3 Gbps 0x3 impl IDE mode
[    4.893639] ahci 0000:06:00.0: flags: 64bit stag led slum part
[    4.899211] scsi6 : ahci
[    4.900831] scsi7 : ahci
[    4.902377] scsi8 : ahci
[    4.903524] ata7: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100100 irq 16
[    4.904075] ata8: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100180 irq 16
[    4.904631] ata9: DUMMY
[    4.926076] tun: Universal TUN/TAP device driver, 1.6
[    4.926429] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.928175] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    4.928540] Copyright (c) 2007 Atheros Corporation.
[    4.930820] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.7 (July 20, 2011)
[    4.932248] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.932631] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.933461] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    4.933881] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.934735] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    4.935108] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    4.935532] IOAPIC[0]: Set routing entry (8-20 -> 0x71 -> IRQ 20 Mode:1 Active:1 Dest:0)
[    4.936111] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.936539] e1000e 0000:00:19.0: setting latency timer to 64
[    4.937048] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.124567] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:c0:79:88:54
[    5.125139] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.125584] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
[    5.126286] Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[    5.126687] Copyright (c) 2007-2011 Intel Corporation.
[    5.127328] Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[    5.127869] Copyright (c) 2009 - 2011 Intel Corporation.
[    5.128525] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.6.7-k
[    5.129082] ixgbe: Copyright (c) 1999-2011 Intel Corporation.
[    5.129763] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    5.130183] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    5.131142] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    5.132259] sky2: driver version 1.29
[    5.134285] usbcore: registered new interface driver catc
[    5.134639] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[    5.135269] usbcore: registered new interface driver kaweth
[    5.135631] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    5.136436] usbcore: registered new interface driver pegasus
[    5.136801] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[    5.137473] usbcore: registered new interface driver rtl8150
[    5.138093] usbcore: registered new interface driver asix
[    5.138704] usbcore: registered new interface driver cdc_ether
[    5.139327] usbcore: registered new interface driver cdc_eem
[    5.139941] usbcore: registered new interface driver dm9601
[    5.140567] usbcore: registered new interface driver smsc75xx
[    5.141189] usbcore: registered new interface driver smsc95xx
[    5.141817] usbcore: registered new interface driver gl620a
[    5.142435] usbcore: registered new interface driver net1080
[    5.143051] usbcore: registered new interface driver plusb
[    5.143673] usbcore: registered new interface driver rndis_host
[    5.144296] usbcore: registered new interface driver cdc_subset
[    5.144918] usbcore: registered new interface driver zaurus
[    5.145540] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    5.146338] usbcore: registered new interface driver int51x1
[    5.146704] cdc_ncm: 04-Aug-2011
[    5.147292] usbcore: registered new interface driver cdc_ncm
[    5.147658] Fusion MPT base driver 3.04.20
[    5.147962] Copyright (c) 1999-2008 LSI Corporation
[    5.148317] Fusion MPT SPI Host driver 3.04.20
[    5.149097] Fusion MPT FC Host driver 3.04.20
[    5.149732] Fusion MPT SAS Host driver 3.04.20
[    5.150351] Fusion MPT misc device (ioctl) driver 3.04.20
[    5.150994] mptctl: Registered with Fusion MPT base driver
[    5.151361] mptctl: /dev/mptctl @ (major,minor=10,220)
[    5.152029] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.152435] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    5.152864] IOAPIC[0]: Set routing entry (8-18 -> 0x81 -> IRQ 18 Mode:1 Active:1 Dest:0)
[    5.153449] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.153884] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    5.154262] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.154700] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file 'devices'
[    5.155277] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.155708] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    5.156273] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    5.156883] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    5.157560] ehci_hcd 0000:00:1a.7: debug port 1
[    5.160857] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.165339] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    5.165744] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    5.166139] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0322000
[    5.166509] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.170981] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    5.177222] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    5.177678] usb usb1: default language 0x0409
[    5.178003] usb usb1: udev 1, busnum 1, minor = 0
[    5.178334] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.178738] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.179280] usb usb1: Product: EHCI Host Controller
[    5.179614] usb usb1: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ ehci_hcd
[    5.180167] usb usb1: SerialNumber: 0000:00:1a.7
[    5.197238] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.198229] ata4: SATA link down (SStatus 0 SControl 300)
[    5.198622] ata5: SATA link down (SStatus 0 SControl 300)
[    5.199227] ata6: SATA link down (SStatus 0 SControl 300)
[    5.201225] ata3: SATA link down (SStatus 0 SControl 300)
[    5.207930] usb usb1: usb_probe_device
[    5.208233] usb usb1: configuration #1 chosen from 1 choice
[    5.208635] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    5.209192] hub 1-0:1.0: usb_probe_interface
[    5.209239] ata7: SATA link down (SStatus 0 SControl 300)
[    5.209865] hub 1-0:1.0: usb_probe_interface - got id
[    5.210212] hub 1-0:1.0: USB hub found
[    5.210511] hub 1-0:1.0: 6 ports detected
[    5.210813] hub 1-0:1.0: standalone hub
[    5.211107] hub 1-0:1.0: no power switching (usb 1.0)
[    5.211453] hub 1-0:1.0: individual port over-current protection
[    5.211831] hub 1-0:1.0: power on to power good time: 20ms
[    5.212218] hub 1-0:1.0: local power source is good
[    5.212553] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    5.213029] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.213635] IOAPIC[0]: Set routing entry (8-23 -> 0x89 -> IRQ 23 Mode:1 Active:1 Dest:0)
[    5.214217] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.214651] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.215023] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.215384] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    5.215805] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    5.216363] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    5.216971] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    5.217630] ehci_hcd 0000:00:1d.7: debug port 1
[    5.217955] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.222441] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    5.222848] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    5.223248] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0321000
[    5.223615] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.228114] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    5.234221] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.234670] usb usb2: default language 0x0409
[    5.235000] usb usb2: udev 1, busnum 2, minor = 128
[    5.235342] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.235750] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.236297] usb usb2: Product: EHCI Host Controller
[    5.236632] usb usb2: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ ehci_hcd
[    5.237187] usb usb2: SerialNumber: 0000:00:1d.7
[    5.238051] usb usb2: usb_probe_device
[    5.238357] usb usb2: configuration #1 chosen from 1 choice
[    5.238729] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    5.239371] hub 2-0:1.0: usb_probe_interface
[    5.239685] hub 2-0:1.0: usb_probe_interface - got id
[    5.240026] hub 2-0:1.0: USB hub found
[    5.240334] hub 2-0:1.0: 6 ports detected
[    5.240637] hub 2-0:1.0: standalone hub
[    5.240933] hub 2-0:1.0: no power switching (usb 1.0)
[    5.241280] hub 2-0:1.0: individual port over-current protection
[    5.241658] hub 2-0:1.0: power on to power good time: 20ms
[    5.242024] hub 2-0:1.0: local power source is good
[    5.242365] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    5.242839] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.243671] uhci_hcd: USB Universal Host Controller Interface driver
[    5.244109] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.244545] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.244586] ata1.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[    5.244589] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.245686] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.246042] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '003'
[    5.246468] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    5.247019] uhci_hcd 0000:00:1a.0: detected 2 ports
[    5.247363] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    5.247767] uhci_hcd 0000:00:1a.0: Performing full reset
[    5.248131] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    5.248510] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020e0
[    5.248944] usb usb3: default language 0x0409
[    5.249282] usb usb3: udev 1, busnum 3, minor = 256
[    5.249618] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.250025] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.250571] usb usb3: Product: UHCI Host Controller
[    5.250905] usb usb3: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.251465] usb usb3: SerialNumber: 0000:00:1a.0
[    5.252165] usb usb3: usb_probe_device
[    5.252471] usb usb3: configuration #1 chosen from 1 choice
[    5.252843] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    5.253493] hub 3-0:1.0: usb_probe_interface
[    5.253807] hub 3-0:1.0: usb_probe_interface - got id
[    5.254149] hub 3-0:1.0: USB hub found
[    5.254458] hub 3-0:1.0: 2 ports detected
[    5.254761] hub 3-0:1.0: standalone hub
[    5.255058] hub 3-0:1.0: no power switching (usb 1.0)
[    5.255406] hub 3-0:1.0: individual port over-current protection
[    5.255785] hub 3-0:1.0: power on to power good time: 2ms
[    5.256149] hub 3-0:1.0: local power source is good
[    5.256491] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    5.256939] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.257437] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    5.257907] IOAPIC[0]: Set routing entry (8-21 -> 0x91 -> IRQ 21 Mode:1 Active:1 Dest:0)
[    5.258491] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    5.258918] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.259297] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.259654] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[    5.260074] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    5.260631] uhci_hcd 0000:00:1a.1: detected 2 ports
[    5.260970] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    5.261378] uhci_hcd 0000:00:1a.1: Performing full reset
[    5.261742] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    5.262141] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020c0
[    5.262568] usb usb4: default language 0x0409
[    5.262898] usb usb4: udev 1, busnum 4, minor = 384
[    5.263239] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.263646] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.264185] usb usb4: Product: UHCI Host Controller
[    5.264525] usb usb4: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.265081] usb usb4: SerialNumber: 0000:00:1a.1
[    5.265621] usb usb4: usb_probe_device
[    5.265915] usb usb4: configuration #1 chosen from 1 choice
[    5.266294] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    5.266770] hub 4-0:1.0: usb_probe_interface
[    5.267083] hub 4-0:1.0: usb_probe_interface - got id
[    5.267429] hub 4-0:1.0: USB hub found
[    5.267727] hub 4-0:1.0: 2 ports detected
[    5.268029] hub 4-0:1.0: standalone hub
[    5.268329] hub 4-0:1.0: no power switching (usb 1.0)
[    5.268671] hub 4-0:1.0: individual port over-current protection
[    5.269048] hub 4-0:1.0: power on to power good time: 2ms
[    5.269422] hub 4-0:1.0: local power source is good
[    5.269758] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    5.270204] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.270699] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    5.271162] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    5.271594] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.271967] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.272334] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '005'
[    5.272756] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    5.273328] uhci_hcd 0000:00:1a.2: detected 2 ports
[    5.273668] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    5.274073] uhci_hcd 0000:00:1a.2: Performing full reset
[    5.274442] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    5.274836] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000020a0
[    5.275262] usb usb5: default language 0x0409
[    5.275593] usb usb5: udev 1, busnum 5, minor = 512
[    5.275930] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.276343] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.276884] usb usb5: Product: UHCI Host Controller
[    5.277224] usb usb5: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.277783] usb usb5: SerialNumber: 0000:00:1a.2
[    5.281302] usb usb5: usb_probe_device
[    5.281596] usb usb5: configuration #1 chosen from 1 choice
[    5.281966] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    5.282443] hub 5-0:1.0: usb_probe_interface
[    5.282756] hub 5-0:1.0: usb_probe_interface - got id
[    5.283097] hub 5-0:1.0: USB hub found
[    5.283400] hub 5-0:1.0: 2 ports detected
[    5.283702] hub 5-0:1.0: standalone hub
[    5.283997] hub 5-0:1.0: no power switching (usb 1.0)
[    5.284354] hub 5-0:1.0: individual port over-current protection
[    5.284731] hub 5-0:1.0: power on to power good time: 2ms
[    5.285095] hub 5-0:1.0: local power source is good
[    5.285435] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    5.285881] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.286378] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    5.286845] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.287277] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.287650] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.288006] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '006'
[    5.288442] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    5.288995] uhci_hcd 0000:00:1d.0: detected 2 ports
[    5.289338] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    5.289741] uhci_hcd 0000:00:1d.0: Performing full reset
[    5.290104] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    5.290481] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
[    5.290906] usb usb6: default language 0x0409
[    5.291241] usb usb6: udev 1, busnum 6, minor = 640
[    5.291576] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.291983] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.292531] usb usb6: Product: UHCI Host Controller
[    5.292867] usb usb6: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.293426] usb usb6: SerialNumber: 0000:00:1d.0
[    5.293977] usb usb6: usb_probe_device
[    5.294277] usb usb6: configuration #1 chosen from 1 choice
[    5.294647] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    5.295117] hub 6-0:1.0: usb_probe_interface
[    5.295440] hub 6-0:1.0: usb_probe_interface - got id
[    5.295782] hub 6-0:1.0: USB hub found
[    5.296079] hub 6-0:1.0: 2 ports detected
[    5.296386] hub 6-0:1.0: standalone hub
[    5.296682] hub 6-0:1.0: no power switching (usb 1.0)
[    5.297023] hub 6-0:1.0: individual port over-current protection
[    5.297405] hub 6-0:1.0: power on to power good time: 2ms
[    5.297768] hub 6-0:1.0: local power source is good
[    5.298104] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    5.298560] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.299068] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    5.299531] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.299956] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.300334] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.300692] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '007'
[    5.301113] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    5.301671] uhci_hcd 0000:00:1d.1: detected 2 ports
[    5.302010] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    5.302420] uhci_hcd 0000:00:1d.1: Performing full reset
[    5.302785] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    5.302892] ata1.00: configured for UDMA/133
[    5.303135] scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    5.304045] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
[    5.304480] usb usb7: default language 0x0409
[    5.304809] usb usb7: udev 1, busnum 7, minor = 768
[    5.304817] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.304950] sd 0:0:0:0: [sda] Write Protect is off
[    5.304953] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.305007] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.306978] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    5.307390] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.307931] usb usb7: Product: UHCI Host Controller
[    5.308270] usb usb7: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.308825] usb usb7: SerialNumber: 0000:00:1d.1
[    5.309465] usb usb7: usb_probe_device
[    5.309759] usb usb7: configuration #1 chosen from 1 choice
[    5.310130] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    5.310608] hub 7-0:1.0: usb_probe_interface
[    5.310921] hub 7-0:1.0: usb_probe_interface - got id
[    5.311267] hub 7-0:1.0: USB hub found
[    5.311565] hub 7-0:1.0: 2 ports detected
[    5.311867] hub 7-0:1.0: standalone hub
[    5.312163] hub 7-0:1.0: no power switching (usb 1.0)
[    5.312542] hub 7-0:1.0: individual port over-current protection
[    5.312920] hub 7-0:1.0: power on to power good time: 2ms
[    5.313289] hub 7-0:1.0: local power source is good
[    5.313624] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    5.314075] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.314583] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    5.315029] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.315475] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    5.316077] hub 1-0:1.0: port 1: status 0501 change 0001
[    5.316446] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 001403 0  ACK POWER sig=k CSC CONNECT
[    5.317048] hub 1-0:1.0: port 2: status 0501 change 0001
[    5.317421] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC CONNECT
[    5.318023] hub 1-0:1.0: port 4: status 0501 change 0001
[    5.318407] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.318781] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.319138] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '008'
[    5.319563] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    5.320117] uhci_hcd 0000:00:1d.2: detected 2 ports
[    5.320461] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    5.320864] uhci_hcd 0000:00:1d.2: Performing full reset
[    5.321233] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    5.321607] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    5.322027] usb usb8: default language 0x0409
[    5.322362] usb usb8: udev 1, busnum 8, minor = 896
[    5.322697] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    5.323103] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.323646] usb usb8: Product: UHCI Host Controller
[    5.323982] usb usb8: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    5.324544] usb usb8: SerialNumber: 0000:00:1d.2
[    5.325070] usb usb8: usb_probe_device
[    5.325371] usb usb8: configuration #1 chosen from 1 choice
[    5.325742] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    5.326221] hub 8-0:1.0: usb_probe_interface
[    5.326534] hub 8-0:1.0: usb_probe_interface - got id
[    5.326876] hub 8-0:1.0: USB hub found
[    5.327174] hub 8-0:1.0: 2 ports detected
[    5.327483] hub 8-0:1.0: standalone hub
[    5.327778] hub 8-0:1.0: no power switching (usb 1.0)
[    5.328119] hub 8-0:1.0: individual port over-current protection
[    5.328501] hub 8-0:1.0: power on to power good time: 2ms
[    5.328864] hub 8-0:1.0: local power source is good
[    5.329199] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    5.329649] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.330152] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    5.330697] Initializing USB Mass Storage driver...
[    5.331164] usbcore: registered new interface driver usb-storage
[    5.331547] USB Mass Storage support registered.
[    5.332022] usbcore: registered new interface driver libusual
[    5.332486] usbcore: registered new interface driver ums-alauda
[    5.332952] usbcore: registered new interface driver ums-cypress
[    5.333434] usbcore: registered new interface driver ums-datafab
[    5.333900] usbcore: registered new interface driver ums-freecom
[    5.334372] usbcore: registered new interface driver ums-isd200
[    5.334836] usbcore: registered new interface driver ums-jumpshot
[    5.335314] usbcore: registered new interface driver ums-karma
[    5.335778] usbcore: registered new interface driver ums-onetouch
[    5.336259] usbcore: registered new interface driver ums-sddr09
[    5.336720] usbcore: registered new interface driver ums-sddr55
[    5.337182] usbcore: registered new interface driver ums-usbat
[    5.337745] usbcore: registered new interface driver usbserial
[    5.338204] USB Serial support registered for generic
[    5.338652] usbcore: registered new interface driver usbserial_generic
[    5.339051] usbserial: USB Serial Driver core
[    5.339442] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    5.340115] usbcore: registered new interface driver belkin
[    5.340483] belkin_sa: v1.3:USB Belkin Serial converter driver
[    5.340939] USB Serial support registered for MCT U232
[    5.341386] usbcore: registered new interface driver mct_u232
[    5.341754] mct_u232: z2.1:Magic Control Technology USB-RS232 converter driver
[    5.344011] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.347910] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.348273] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.350274] mousedev: PS/2 mouse device common for all mice
[    5.353671] rtc_cmos 00:02: RTC can wake from S4
[    5.354599] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    5.355009] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    5.355814] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    5.356240] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[    5.356616] uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
[    5.357509] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[    5.358415] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.358796] iTCO_vendor_support: vendor-support=0
[    5.359126] SoftDog: cannot register miscdev on minor=130 (err=-16)
[    5.359531] md: linear personality registered for level -1
[    5.362852] md: raid0 personality registered for level 0
[    5.362855] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    5.363569] md: raid1 personality registered for level 1
[    5.363921] md: raid10 personality registered for level 10
[    5.364283] md: raid6 personality registered for level 6
[    5.364634] md: raid5 personality registered for level 5
[    5.364985] md: raid4 personality registered for level 4
[    5.365340] md: multipath personality registered for level -4
[    5.365708] md: faulty personality registered for level -5
[    5.367292] device-mapper: uevent: version 1.0.3
[    5.368403] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    5.369124] device-mapper: multipath: version 1.3.0 loaded
[    5.369573] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.369971] device-mapper: multipath queue-length: version 0.1.0 loaded
[    5.370426] device-mapper: multipath service-time: version 0.2.0 loaded
[    5.370986] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    5.371629] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    5.383006] cpuidle: using governor ladder
[    5.385250] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.390031] cpuidle: using governor menu
[    5.390595] usbcore: registered new interface driver usbhid
[    5.390956] usbhid: USB HID core driver
[    5.391699] dell_wmi: No known WMI GUID found
[    5.392015] acer_wmi: Acer Laptop ACPI-WMI Extras
[    5.392357] acer_wmi: No or unsupported WMI interface, unable to load
[    5.393241] IOAPIC[0]: Set routing entry (8-22 -> 0x99 -> IRQ 22 Mode:1 Active:1 Dest:0)
[    5.393818] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.394436] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    5.394844] ALSA hda_intel.c:2733 chipset global capabilities = 0x4401
[    5.395197]  sda: sda1 sda2 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    5.395626] ALSA hda_intel.c:1163 Clearing TCSEL
[    5.396950] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.398432] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.403227] ALSA hda_intel.c:1009 codec_mask = 0x4
[    5.403848] ALSA hda_intel.c:1472 codec #2 probed OK
[    5.409353] ALSA hda_codec.c:3994 hda_codec: model 'intel-x58' is selected for config 8086:22 (DX58SO)
[    5.409971] hda_codec: ALC889: SKU not ready 0x411111f0
[    5.411047] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input2
[    5.414939] ALSA hda_codec.c:2378 Cannot find slave Side Playback Volume, skipped
[    5.415495] ALSA hda_codec.c:2378 Cannot find slave Headphone Playback Volume, skipped
[    5.416063] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Volume, skipped
[    5.416616] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Volume, skipped
[    5.417179] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Volume, skipped
[    5.417761] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.417766] ALSA hda_codec.c:2378 Cannot find slave Side Playback Switch, skipped
[    5.417772] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Switch, skipped
[    5.417776] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Switch, skipped
[    5.417779] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Switch, skipped
[    5.420342] hub 1-0:1.0: state 7 ports 6 chg 0016 evt 0000
[    5.420712] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    5.421966] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input3
[    5.423584] ALSA device list:
[    5.423848]   #0: HDA Intel at 0xf7f00000 irq 45
[    5.424175] oprofile: using NMI interrupt.
[    5.424532] netem: version 1.3
[    5.424799] Netfilter messages via NETLINK v0.30.
[    5.425170] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.426652] ctnetlink v0.93: registering with nfnetlink.
[    5.427054] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    5.427513] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    5.428319] xt_time: kernel timezone is -0000
[    5.430844] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.431291] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    5.431708] arp_tables: (C) 2002 David S. Miller
[    5.432076] TCP bic registered
[    5.432349] TCP cubic registered
[    5.432621] TCP westwood registered
[    5.432903] TCP highspeed registered
[    5.433188] TCP hybla registered
[    5.433466] TCP htcp registered
[    5.433736] TCP vegas registered
[    5.434008] TCP veno registered
[    5.434282] TCP scalable registered
[    5.434564] TCP lp registered
[    5.434831] TCP yeah registered
[    5.435101] TCP illinois registered
[    5.435387] Initializing XFRM netlink socket
[    5.436974] NET: Registered protocol family 10
[    5.441957] IPv6 over IPv4 tunneling driver
[    5.445062] NET: Registered protocol family 17
[    5.445398] NET: Registered protocol family 15
[    5.445897] Bridge firewalling registered
[    5.446219] Ebtables v2.0 registered
[    5.446642] Registering the dns_resolver key type
[    5.447085]
[    5.447086] printing PIC contents
[    5.447576] ... PIC  IMR: ffff
[    5.447843] ... PIC  IRR: 0c21
[    5.448115] ... PIC  ISR: 0000
[    5.448389] ... PIC ELCR: 0c20
[    5.448659] printing local APIC contents on CPU#0/0:
[    5.448999] ... APIC ID:      00000000 (0)
[    5.449305] ... APIC VERSION: 00060015
[    5.449597] ... APIC TASKPRI: 00000000 (00)
[    5.449904] ... APIC PROCPRI: 00000000
[    5.450195] ... APIC LDR: 01000000
[    5.450475] ... APIC DFR: ffffffff
[    5.450754] ... APIC SPIV: 000001ff
[    5.451035] ... APIC ISR field:
[    5.451305] 0000000000000000000000000000000000000000000000000000000000000000
[    5.451997] ... APIC TMR field:
[    5.452277] 0000000000000000000000000000000000000002000000000000000000000000
[    5.452969] ... APIC IRR field:
[    5.453240] 0000000000000000000000000000000000000000000000000000000000008000
[    5.453933] ... APIC ESR: 00000000
[    5.454213] ... APIC ICR: 000000fd
[    5.454493] ... APIC ICR2: 07000000
[    5.454776] ... APIC LVTT: 000000ef
[    5.455059] ... APIC LVTPC: 00000400
[    5.455346] ... APIC LVT0: 00010700
[    5.455628] ... APIC LVT1: 00000400
[    5.455911] ... APIC LVTERR: 000000fe
[    5.456201] ... APIC TMICT: 00002074
[    5.456487] ... APIC TMCCT: 00000000
[    5.456772] ... APIC TDCR: 00000003
[    5.457054]
[    5.457262] number of MP IRQ sources: 15.
[    5.457564] number of IO-APIC #8 registers: 24.
[    5.457885] testing the IO APIC.......................
[    5.458238]
[    5.458446] IO APIC #8......
[    5.458705] .... register #00: 08000000
[    5.459000] .......    : physical APIC id: 08
[    5.459319] .......    : Delivery Type: 0
[    5.459621] .......    : LTS          : 0
[    5.459923] .... register #01: 00170020
[    5.460222] .......     : max redirection entries: 17
[    5.460562] .......     : PRQ implemented: 0
[    5.460873] .......     : IO APIC version: 20
[    5.461188] .... IRQ redirection table:
[    5.461487]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    5.461848]  00 00  1    0    0   0   0    0    0    00
[    5.462236]  01 00  0    0    0   0   0    0    0    31
[    5.462623]  02 00  0    0    0   0   0    0    0    30
[    5.463009]  03 00  0    0    0   0   0    0    0    33
[    5.463399]  04 00  0    0    0   0   0    0    0    34
[    5.463785]  05 00  0    0    0   0   0    0    0    35
[    5.464171]  06 00  1    0    0   0   0    0    0    36
[    5.464560]  07 00  0    0    0   0   0    0    0    37
[    5.464946]  08 00  0    0    0   0   0    0    0    38
[    5.465335]  09 00  0    1    0   0   0    0    0    39
[    5.465720]  0a 00  0    0    0   0   0    0    0    3A
[    5.466106]  0b 00  0    0    0   0   0    0    0    3B
[    5.466497]  0c 00  0    0    0   0   0    0    0    3C
[    5.466884]  0d 00  0    0    0   0   0    0    0    3D
[    5.467275]  0e 00  0    0    0   0   0    0    0    3E
[    5.467661]  0f 00  0    0    0   0   0    0    0    3F
[    5.468048]  10 00  0    1    0   1   0    0    0    29
[    5.468439]  11 00  1    1    0   1   0    0    0    41
[    5.468825]  12 00  0    1    0   1   0    0    0    81
[    5.469215]  13 00  0    1    0   1   0    0    0    61
[    5.469602]  14 00  1    1    0   1   0    0    0    71
[    5.469989]  15 00  0    1    0   1   0    0    0    91
[    5.470380]  16 00  1    1    0   1   0    0    0    99
[    5.470768]  17 00  0    1    0   1   0    0    0    89
[    5.471149] IRQ to pin mappings:
[    5.471461] IRQ0
[    5.471519] ehci_hcd 0000:00:1a.7: port 1 high speed
[    5.471523] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    5.472669] -> 0:2
[    5.472931] IRQ1 -> 0:1
[    5.473248] IRQ3 -> 0:3
[    5.473561] IRQ4 -> 0:4
[    5.473873] IRQ5 -> 0:5
[    5.477150] IRQ6 -> 0:6
[    5.477466] IRQ7 -> 0:7
[    5.477777] IRQ8 -> 0:8
[    5.478089] IRQ9 -> 0:9
[    5.478405] IRQ10 -> 0:10
[    5.478723] IRQ11 -> 0:11
[    5.479041] IRQ12 -> 0:12
[    5.479364] IRQ13 -> 0:13
[    5.479682] IRQ14 -> 0:14
[    5.480000] IRQ15 -> 0:15
[    5.480323] IRQ16 -> 0:16
[    5.480641] IRQ17 -> 0:17
[    5.480959] IRQ18 -> 0:18
[    5.481282] IRQ19 -> 0:19
[    5.481600] IRQ20 -> 0:20
[    5.481919] IRQ21 -> 0:21
[    5.482242] IRQ22 -> 0:22
[    5.482560] IRQ23 -> 0:23
[    5.482879] .................................... done.
[    5.483947] PM: Hibernation image not present or could not be loaded.
[    5.484418] registered taskstats version 1
[    5.484724] Running tests on trace events:
[    5.485029] Testing event kfree_skb: OK
[    5.501656] Testing event consume_skb:
[    5.503244] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.518997] OK
[    5.519211] Testing event skb_copy_datagram_iovec:
[    5.522242] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    5.538249] OK
[    5.538463] Testing event net_dev_xmit: OK
[    5.555661] Testing event net_dev_queue: OK
[    5.572660] Testing event netif_receive_skb:
[    5.575522] ehci_hcd 0000:00:1a.7: port 1 high speed
[    5.576018] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    5.591335] OK
[    5.591550] Testing event netif_rx: OK
[    5.608784] Testing event napi_poll:
[    5.610550] ata2.00: ATAPI: PLEXTOR DVDR   PX-712A, 1.07, max UDMA/33
[    5.611104] ata2.00: applying bridge limits
[    5.626490] OK
[    5.626705] Testing event sock_rcvqueue_full:
[    5.641799] ata2.00: configured for UDMA/33
[    5.643641] scsi 1:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-712A   1.07 PQ: 0 ANSI: 5
[    5.644255] OK
[    5.644466] Testing event sock_exceed_buf_limit:
[    5.646038] usb 1-1: default language 0x0409
[    5.652916] usb 1-1: udev 2, busnum 1, minor = 1
[    5.653250] usb 1-1: New USB device found, idVendor=0b95, idProduct=1780
[    5.653652] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    5.654070] usb 1-1: Product: AX88178
[    5.654368] usb 1-1: Manufacturer: ASIX Elec. Corp.
[    5.654701] usb 1-1: SerialNumber: 000013
[    5.655197] usb 1-1: usb_probe_device
[    5.655493] usb 1-1: configuration #1 chosen from 1 choice
[    5.656479] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    5.658126] asix 1-1:1.0: usb_probe_interface
[    5.658450] asix 1-1:1.0: usb_probe_interface - got id
[    5.661483] OK
[    5.661698] Testing event udp_fail_queue_rcv_skb: OK
[    5.679520] Testing event hda_send_cmd: OK
[    5.696656] Testing event hda_get_response: OK
[    5.714154] Testing event hda_bus_reset: OK
[    5.730658] Testing event hda_power_down: OK
[    5.748409] Testing event hda_power_up: OK
[    5.765521] Testing event hda_unsol_event: OK
[    5.782654] Testing event scsi_dispatch_cmd_start: OK
[    5.800215] Testing event scsi_dispatch_cmd_error: OK
[    5.817661] Testing event scsi_dispatch_cmd_done: OK
[    5.834657] Testing event scsi_dispatch_cmd_timeout: OK
[    5.851827] Testing event scsi_eh_wakeup: OK
[    5.868664] Testing event i915_gem_object_create: OK
[    5.885805] Testing event i915_gem_object_bind: OK
[    5.902815] Testing event i915_gem_object_unbind: OK
[    5.920823] Testing event i915_gem_object_change_domain: OK
[    5.938766] Testing event i915_gem_object_pwrite:
[    5.952470] ata8: SATA link down (SStatus 0 SControl 300)
[    5.954696] OK
[    5.954908] Testing event i915_gem_object_pread: OK
[    5.972848] Testing event i915_gem_object_fault: OK
[    5.989831] Testing event i915_gem_object_clflush: OK
[    6.006830] Testing event i915_gem_object_destroy: OK
[    6.025842] Testing event i915_gem_evict: OK
[    6.044786] Testing event i915_gem_evict_everything: OK
[    6.063806] Testing event i915_gem_ring_dispatch: OK
[    6.081841] Testing event i915_gem_ring_flush: OK
[    6.099797] Testing event i915_gem_request_add: OK
[    6.117823] Testing event i915_gem_request_complete: OK
[    6.136833] Testing event i915_gem_request_retire: OK
[    6.154844] Testing event i915_gem_request_wait_begin: OK
[    6.174853] Testing event i915_gem_request_wait_end: OK
[    6.192913] Testing event i915_ring_wait_begin: OK
[    6.209851] Testing event i915_ring_wait_end: OK
[    6.228799] Testing event i915_flip_request: OK
[    6.244846] Testing event i915_flip_complete: OK
[    6.262859] Testing event i915_reg_rw: OK
[    6.281823] Testing event drm_vblank_event: OK
[    6.298865] Testing event drm_vblank_event_queued: OK
[    6.316909] Testing event drm_vblank_event_delivered: OK
[    6.334908] Testing event block_rq_abort: OK
[    6.351819] Testing event block_rq_requeue: OK
[    6.368805] Testing event block_rq_complete:
[    6.374709] asix 1-1:1.0: eth1: register 'asix' at usb-0000:00:1a.7-1, ASIX AX88178 USB 2.0 Ethernet, 00:23:54:5c:02:83
[    6.375642] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    6.376097] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    6.376604] ehci_hcd 0000:00:1a.7: port 2 low speed --> companion
[    6.387725] OK
[    6.387938] Testing event block_rq_insert: OK
[    6.405818] Testing event block_rq_issue: OK
[    6.422842] Testing event block_bio_bounce:
[    6.427468] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    6.428241] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    6.439759] OK
[    6.439971] Testing event block_bio_complete:
[    6.452473] usb usb5: suspend_rh (auto-stop)
[    6.452963] usb usb6: suspend_rh (auto-stop)
[    6.453325] usb usb7: suspend_rh (auto-stop)
[    6.453654] usb usb8: suspend_rh (auto-stop)
[    6.453990] usb usb4: suspend_rh (auto-stop)
[    6.458709] OK
[    6.458922] Testing event block_bio_backmerge: OK
[    6.476900] Testing event block_bio_frontmerge:
[    6.479678] ehci_hcd 0000:00:1a.7: port 4 high speed
[    6.480169] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    6.496728] OK
[    6.496940] Testing event block_bio_queue: OK
[    6.513952] Testing event block_getrq: OK
[    6.530915] Testing event block_sleeprq:
[    6.532439] usb 1-4: new high-speed USB device number 4 using ehci_hcd
[    6.547649] OK
[    6.547862] Testing event block_plug: OK
[    6.565901] Testing event block_unplug: OK
[    6.582833] Testing event block_split:
[    6.583682] ehci_hcd 0000:00:1a.7: port 4 high speed
[    6.584172] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    6.599640] OK
[    6.599853] Testing event block_bio_remap: OK
[    6.616910] Testing event block_rq_remap: OK
[    6.633956] Testing event btrfs_transaction_commit: OK
[    6.650991] Testing event btrfs_inode_new: OK
[    6.667869] Testing event btrfs_inode_request: OK
[    6.685763] Testing event btrfs_inode_evict: OK
[    6.701818] Testing event btrfs_get_extent: OK
[    6.718909] Testing event btrfs_ordered_extent_add: OK
[    6.735837] Testing event btrfs_ordered_extent_remove: OK
[    6.752857] Testing event btrfs_ordered_extent_start: OK
[    6.770825] Testing event btrfs_ordered_extent_put: OK
[    6.787996] Testing event btrfs_finish_ordered_io: OK
[    6.804899] Testing event __extent_writepage: OK
[    6.822841] Testing event btrfs_writepage_end_io_hook: OK
[    6.839854] Testing event btrfs_sync_file: OK
[    6.856802] Testing event btrfs_sync_fs: OK
[    6.872831] Testing event btrfs_delayed_tree_ref: OK
[    6.889832] Testing event btrfs_delayed_data_ref: OK
[    6.907937] Testing event btrfs_delayed_ref_head: OK
[    6.925808] Testing event btrfs_chunk_alloc: OK
[    6.944847] Testing event btrfs_chunk_free: OK
[    6.961921] Testing event btrfs_cow_block: OK
[    6.979837] Testing event btrfs_reserved_extent_alloc: OK
[    6.997859] Testing event btrfs_reserved_extent_free: OK
[    7.014916] Testing event xfs_attr_list_sf: OK
[    7.032944] Testing event xfs_attr_list_sf_all: OK
[    7.050814] Testing event xfs_attr_list_leaf: OK
[    7.066844] Testing event xfs_attr_list_leaf_end: OK
[    7.083816] Testing event xfs_attr_list_full: OK
[    7.100832] Testing event xfs_attr_list_add: OK
[    7.117834] Testing event xfs_attr_list_wrong_blk: OK
[    7.133822] Testing event xfs_attr_list_notfound: OK
[    7.151842] Testing event xfs_perag_get: OK
[    7.168894] Testing event xfs_perag_get_tag: OK
[    7.185857] Testing event xfs_perag_put: OK
[    7.203879] Testing event xfs_perag_set_reclaim: OK
[    7.220994] Testing event xfs_perag_clear_reclaim: OK
[    7.240891] Testing event xfs_attr_list_node_descend: OK
[    7.259948] Testing event xfs_iext_insert: OK
[    7.279892] Testing event xfs_iext_remove: OK
[    7.296860] Testing event xfs_bmap_pre_update: OK
[    7.314843] Testing event xfs_bmap_post_update: OK
[    7.331878] Testing event xfs_extlist: OK
[    7.349928] Testing event xfs_buf_init: OK
[    7.366807] Testing event xfs_buf_free: OK
[    7.382840] Testing event xfs_buf_hold: OK
[    7.398866] Testing event xfs_buf_rele: OK
[    7.416810] Testing event xfs_buf_iodone: OK
[    7.432837] Testing event xfs_buf_iorequest: OK
[    7.448817] Testing event xfs_buf_bawrite: OK
[    7.465838] Testing event xfs_buf_lock: OK
[    7.483890] Testing event xfs_buf_lock_done: OK
[    7.500994] Testing event xfs_buf_trylock: OK
[    7.517852] Testing event xfs_buf_unlock: OK
[    7.534904] Testing event xfs_buf_iowait: OK
[    7.552853] Testing event xfs_buf_iowait_done: OK
[    7.569818] Testing event xfs_buf_delwri_queue:
[    7.585932] usb 1-4: default language 0x0409
[    7.586921] OK
[    7.587129] Testing event xfs_buf_delwri_dequeue:
[    7.587989] usb 1-4: udev 4, busnum 1, minor = 3
[    7.588581] usb 1-4: New USB device found, idVendor=1307, idProduct=0165
[    7.588982] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.589550] usb 1-4: Product: USB Mass Storage Device
[    7.589885] usb 1-4: Manufacturer: Teclast Technology
[    7.590218] usb 1-4: SerialNumber: 0000000000020D
[    7.590941] usb 1-4: usb_probe_device
[    7.591226] usb 1-4: configuration #1 chosen from 1 choice
[    7.591748] usb 1-4: adding 1-4:1.0 (config #1, interface 0)
[    7.592262] usb-storage 1-4:1.0: usb_probe_interface
[    7.592629] usb-storage 1-4:1.0: usb_probe_interface - got id
[    7.593136] scsi9 : usb-storage 1-4:1.0
[    7.593916] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[    7.594399] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.594751] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    7.595107] uhci_hcd 0000:00:1a.0: port 2 portsc 01a3,00
[    7.595570] hub 3-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    7.604691] OK
[    7.604903] Testing event xfs_buf_delwri_split: OK
[    7.622869] Testing event xfs_buf_get_uncached: OK
[    7.639926] Testing event xfs_bdstrat_shut: OK
[    7.657892] Testing event xfs_buf_item_relse: OK
[    7.675824] Testing event xfs_buf_item_iodone: OK
[    7.691966] Testing event xfs_buf_item_iodone_async:
[    7.699432] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    7.708701] OK
[    7.708914] Testing event xfs_buf_error_relse: OK
[    7.726937] Testing event xfs_trans_read_buf_io: OK
[    7.745879] Testing event xfs_trans_read_buf_shut: OK
[    7.763859] Testing event xfs_btree_corrupt: OK
[    7.780850] Testing event xfs_da_btree_corrupt: OK
[    7.797898] Testing event xfs_reset_dqcounts:
[    7.801432] usb 3-2: new low-speed USB device number 2 using uhci_hcd
[    7.814755] OK
[    7.814969] Testing event xfs_inode_item_push: OK
[    7.831929] Testing event xfs_buf_find: OK
[    7.848889] Testing event xfs_buf_get: OK
[    7.865908] Testing event xfs_buf_read: OK
[    7.883875] Testing event xfs_buf_ioerror: OK
[    7.901822] Testing event xfs_buf_item_size: OK
[    7.919873] Testing event xfs_buf_item_size_stale: OK
[    7.936886] Testing event xfs_buf_item_format: OK
[    7.954913] Testing event xfs_buf_item_format_stale: OK
[    7.972933] Testing event xfs_buf_item_pin: OK
[    7.990897] Testing event xfs_buf_item_unpin:
[    8.005128] usb 3-2: skipped 1 descriptor after interface
[    8.005789] usb 3-2: skipped 1 descriptor after interface
[    8.007763] OK
[    8.007976] Testing event xfs_buf_item_unpin_stale:
[    8.012096] usb 3-2: default language 0x0409
[    8.024676] OK
[    8.024890] Testing event xfs_buf_item_trylock: OK
[    8.041837] Testing event xfs_buf_item_unlock:
[    8.043054] usb 3-2: udev 2, busnum 3, minor = 257
[    8.043640] usb 3-2: New USB device found, idVendor=0557, idProduct=2220
[    8.044041] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.044601] usb 3-2: Product: ATEN  CS-1758/54
[    8.044919] usb 3-2: Manufacturer: ATEN
[    8.045621] usb 3-2: usb_probe_device
[    8.045907] usb 3-2: configuration #1 chosen from 1 choice
[    8.049122] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[    8.058847] OK
[    8.059060] Testing event xfs_buf_item_unlock_stale: OK
[    8.076894] Testing event xfs_buf_item_committed:
[    8.088413] usbserial_generic 3-2:1.0: usb_probe_interface
[    8.088922] usbserial_generic 3-2:1.0: usb_probe_interface - got id
[    8.089479] usbhid 3-2:1.0: usb_probe_interface
[    8.089798] usbhid 3-2:1.0: usb_probe_interface - got id
[    8.093711] OK
[    8.093923] Testing event xfs_buf_item_push: OK
[    8.112883] Testing event xfs_buf_item_pushbuf:
[    8.123664] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input4
[    8.124575] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    8.125298] generic-usb 0003:0557:2220.0001: input: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input0
[    8.126163] usb 3-2: adding 3-2:1.1 (config #1, interface 1)
[    8.129699] OK
[    8.129912] Testing event xfs_trans_get_buf:
[    8.136456] usbserial_generic 3-2:1.1: usb_probe_interface
[    8.136966] usbserial_generic 3-2:1.1: usb_probe_interface - got id
[    8.137476] usbhid 3-2:1.1: usb_probe_interface
[    8.137796] usbhid 3-2:1.1: usb_probe_interface - got id
[    8.147678] OK
[    8.147890] Testing event xfs_trans_get_buf_recur: OK
[    8.165899] Testing event xfs_trans_getsb:
[    8.168545] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.1/input/input5
[    8.169761] generic-usb 0003:0557:2220.0002: input: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input1
[    8.170605] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    8.171043] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.171511] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    8.183743] OK
[    8.183956] Testing event xfs_trans_getsb_recur: OK
[    8.200890] Testing event xfs_trans_read_buf: OK
[    8.218060] Testing event xfs_trans_read_buf_recur: OK
[    8.236899] Testing event xfs_trans_log_buf: OK
[    8.253865] Testing event xfs_trans_brelse: OK
[    8.269880] Testing event xfs_trans_bjoin: OK
[    8.286978] Testing event xfs_trans_bhold: OK
[    8.304945] Testing event xfs_trans_bhold_release: OK
[    8.321824] Testing event xfs_trans_binval: OK
[    8.339949] Testing event xfs_ilock: OK
[    8.356980] Testing event xfs_ilock_nowait: OK
[    8.374902] Testing event xfs_ilock_demote: OK
[    8.391895] Testing event xfs_iunlock: OK
[    8.408904] Testing event xfs_iget_skip: OK
[    8.425983] Testing event xfs_iget_reclaim: OK
[    8.442891] Testing event xfs_iget_reclaim_fail: OK
[    8.460912] Testing event xfs_iget_hit: OK
[    8.477943] Testing event xfs_iget_miss: OK
[    8.494967] Testing event xfs_getattr: OK
[    8.514066] Testing event xfs_setattr: OK
[    8.531902] Testing event xfs_readlink: OK
[    8.549897] Testing event xfs_alloc_file_space: OK
[    8.566890] Testing event xfs_free_file_space: OK
[    8.583896] Testing event xfs_readdir:
[    8.594820] scsi 9:0:0:0: Direct-Access     Teclast  CoolFlash        0.00 PQ: 0 ANSI: 2
[    8.595727] scsi: killing requests for dead queue
[    8.596182] scsi: killing requests for dead queue
[    8.596678] scsi: killing requests for dead queue
[    8.597116] scsi: killing requests for dead queue
[    8.597591] scsi: killing requests for dead queue
[    8.598046] scsi: killing requests for dead queue
[    8.598508] scsi: killing requests for dead queue
[    8.599347] scsi_scan_9 used greatest stack depth: 4704 bytes left
[    8.600554] sd 9:0:0:0: [sdb] 63084544 512-byte logical blocks: (32.2 GB/30.0 GiB)
[    8.601619] OK
[    8.601777] sd 9:0:0:0: [sdb] Write Protect is off
[    8.601779] sd 9:0:0:0: [sdb] Mode Sense: 00 00 00 00
[    8.602408] sd 9:0:0:0: [sdb] Asking for cache data failed
[    8.602409] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    8.603224] Testing event xfs_get_acl:
[    8.606662] sd 9:0:0:0: [sdb] Asking for cache data failed
[    8.607168] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    8.619694] OK
[    8.619904] Testing event xfs_vm_bmap: OK
[    8.636750] Testing event xfs_file_ioctl: OK
[    8.652764] Testing event xfs_file_compat_ioctl: OK
[    8.668763] Testing event xfs_ioctl_setattr: OK
[    8.684746] Testing event xfs_dir_fsync: OK
[    8.700835] Testing event xfs_file_fsync: OK
[    8.716753] Testing event xfs_destroy_inode: OK
[    8.732864] Testing event xfs_write_inode:
[    8.741475]  sdb: sdb1 sdb2 sdb3
[    8.745314] sd 9:0:0:0: [sdb] Asking for cache data failed
[    8.745684] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    8.746059] sd 9:0:0:0: [sdb] Attached SCSI removable disk
[    8.751733] OK
[    8.751945] Testing event xfs_evict_inode: OK
[    8.768841] Testing event xfs_dquot_dqalloc: OK
[    8.784986] Testing event xfs_dquot_dqdetach: OK
[    8.802969] Testing event xfs_ihold: OK
[    8.820930] Testing event xfs_irele: OK
[    8.840862] Testing event xfs_inode_pin: OK
[    8.857916] Testing event xfs_inode_unpin: OK
[    8.874956] Testing event xfs_inode_unpin_nowait: OK
[    8.892977] Testing event xfs_remove: OK
[    8.910966] Testing event xfs_link: OK
[    8.927896] Testing event xfs_lookup: OK
[    8.943857] Testing event xfs_create: OK
[    8.960943] Testing event xfs_symlink: OK
[    8.977901] Testing event xfs_rename: OK
[    8.994882] Testing event xfs_dqadjust: OK
[    9.011880] Testing event xfs_dqreclaim_want: OK
[    9.028912] Testing event xfs_dqreclaim_dirty: OK
[    9.045897] Testing event xfs_dqreclaim_unlink: OK
[    9.062948] Testing event xfs_dqattach_found: OK
[    9.080016] Testing event xfs_dqattach_get: OK
[    9.096910] Testing event xfs_dqinit: OK
[    9.114947] Testing event xfs_dqreuse: OK
[    9.132935] Testing event xfs_dqalloc: OK
[    9.150931] Testing event xfs_dqtobp_read: OK
[    9.170978] Testing event xfs_dqread: OK
[    9.188918] Testing event xfs_dqread_fail: OK
[    9.206916] Testing event xfs_dqlookup_found: OK
[    9.224936] Testing event xfs_dqlookup_want: OK
[    9.241898] Testing event xfs_dqlookup_freelist: OK
[    9.257896] Testing event xfs_dqlookup_done: OK
[    9.273915] Testing event xfs_dqget_hit: OK
[    9.289910] Testing event xfs_dqget_miss: OK
[    9.305925] Testing event xfs_dqput: OK
[    9.322974] Testing event xfs_dqput_wait: OK
[    9.339888] Testing event xfs_dqput_free: OK
[    9.356904] Testing event xfs_dqrele: OK
[    9.374973] Testing event xfs_dqflush: OK
[    9.392963] Testing event xfs_dqflush_force: OK
[    9.414968] Testing event xfs_dqflush_done: OK
[    9.433934] Testing event xfs_log_done_nonperm: OK
[    9.450936] Testing event xfs_log_done_perm: OK
[    9.468008] Testing event xfs_log_reserve: OK
[    9.484932] Testing event xfs_log_umount_write: OK
[    9.501960] Testing event xfs_log_grant_enter: OK
[    9.518944] Testing event xfs_log_grant_exit: OK
[    9.535988] Testing event xfs_log_grant_error: OK
[    9.552814] Testing event xfs_log_grant_sleep1: OK
[    9.569956] Testing event xfs_log_grant_wake1: OK
[    9.586929] Testing event xfs_log_grant_sleep2: OK
[    9.604926] Testing event xfs_log_grant_wake2: OK
[    9.622944] Testing event xfs_log_grant_wake_up: OK
[    9.640969] Testing event xfs_log_regrant_write_enter: OK
[    9.659956] Testing event xfs_log_regrant_write_exit: OK
[    9.677941] Testing event xfs_log_regrant_write_error: OK
[    9.694908] Testing event xfs_log_regrant_write_sleep1: OK
[    9.710962] Testing event xfs_log_regrant_write_wake1: OK
[    9.727960] Testing event xfs_log_regrant_write_sleep2: OK
[    9.744951] Testing event xfs_log_regrant_write_wake2: OK
[    9.762958] Testing event xfs_log_regrant_write_wake_up: OK
[    9.780950] Testing event xfs_log_regrant_reserve_enter: OK
[    9.798984] Testing event xfs_log_regrant_reserve_exit: OK
[    9.815964] Testing event xfs_log_regrant_reserve_sub: OK
[    9.832973] Testing event xfs_log_ungrant_enter: OK
[    9.850964] Testing event xfs_log_ungrant_exit: OK
[    9.867938] Testing event xfs_log_ungrant_sub: OK
[    9.883916] Testing event xfs_ail_push: OK
[    9.900949] Testing event xfs_ail_pushbuf: OK
[    9.918047] Testing event xfs_ail_pushbuf_pinned: OK
[    9.934951] Testing event xfs_ail_pinned: OK
[    9.951993] Testing event xfs_ail_locked: OK
[    9.968984] Testing event xfs_file_read: OK
[    9.985988] Testing event xfs_file_buffered_write: OK
[   10.002962] Testing event xfs_file_direct_write: OK
[   10.020955] Testing event xfs_file_splice_read: OK
[   10.038054] Testing event xfs_file_splice_write: OK
[   10.055039] Testing event xfs_writepage: OK
[   10.072956] Testing event xfs_releasepage: OK
[   10.089957] Testing event xfs_invalidatepage: OK
[   10.106942] Testing event xfs_map_blocks_found: OK
[   10.122972] Testing event xfs_map_blocks_alloc: OK
[   10.140956] Testing event xfs_get_blocks_found: OK
[   10.157945] Testing event xfs_get_blocks_alloc: OK
[   10.175065] Testing event xfs_delalloc_enospc: OK
[   10.191957] Testing event xfs_unwritten_convert: OK
[   10.207977] Testing event xfs_get_blocks_notfound: OK
[   10.225065] Testing event xfs_setfilesize: OK
[   10.242973] Testing event xfs_itruncate_data_start: OK
[   10.260948] Testing event xfs_itruncate_data_end: OK
[   10.277977] Testing event xfs_pagecache_inval: OK
[   10.294957] Testing event xfs_bunmap: OK
[   10.312014] Testing event xfs_alloc_busy: OK
[   10.329013] Testing event xfs_alloc_busy_enomem: OK
[   10.347005] Testing event xfs_alloc_busy_force: OK
[   10.365999] Testing event xfs_alloc_busy_reuse: OK
[   10.382941] Testing event xfs_alloc_busy_clear: OK
[   10.398936] Testing event xfs_alloc_busy_trim: OK
[   10.415961] Testing event xfs_trans_commit_lsn: OK
[   10.431950] Testing event xfs_agf: OK
[   10.449960] Testing event xfs_free_extent: OK
[   10.467005] Testing event xfs_alloc_exact_done: OK
[   10.483999] Testing event xfs_alloc_exact_notfound: OK
[   10.500986] Testing event xfs_alloc_exact_error: OK
[   10.517968] Testing event xfs_alloc_near_nominleft: OK
[   10.535005] Testing event xfs_alloc_near_first: OK
[   10.551930] Testing event xfs_alloc_near_greater: OK
[   10.568973] Testing event xfs_alloc_near_lesser: OK
[   10.585964] Testing event xfs_alloc_near_error: OK
[   10.601972] Testing event xfs_alloc_near_noentry: OK
[   10.618965] Testing event xfs_alloc_near_busy: OK
[   10.636084] Testing event xfs_alloc_size_neither: OK
[   10.652980] Testing event xfs_alloc_size_noentry: OK
[   10.670970] Testing event xfs_alloc_size_nominleft: OK
[   10.687980] Testing event xfs_alloc_size_done: OK
[   10.705991] Testing event xfs_alloc_size_error: OK
[   10.723989] Testing event xfs_alloc_size_busy: OK
[   10.742044] Testing event xfs_alloc_small_freelist: OK
[   10.758974] Testing event xfs_alloc_small_notenough: OK
[   10.776071] Testing event xfs_alloc_small_done: OK
[   10.792999] Testing event xfs_alloc_small_error: OK
[   10.809979] Testing event xfs_alloc_vextent_badargs: OK
[   10.826985] Testing event xfs_alloc_vextent_nofix: OK
[   10.844031] Testing event xfs_alloc_vextent_noagbp: OK
[   10.860959] Testing event xfs_alloc_vextent_loopfailed: OK
[   10.877853] Testing event xfs_alloc_vextent_allfailed: OK
[   10.894829] Testing event xfs_dir2_sf_addname: OK
[   10.911837] Testing event xfs_dir2_sf_create: OK
[   10.928833] Testing event xfs_dir2_sf_lookup: OK
[   10.945833] Testing event xfs_dir2_sf_replace: OK
[   10.962845] Testing event xfs_dir2_sf_removename: OK
[   10.979834] Testing event xfs_dir2_sf_toino4: OK
[   10.996835] Testing event xfs_dir2_sf_toino8: OK
[   11.013831] Testing event xfs_dir2_sf_to_block: OK
[   11.030849] Testing event xfs_dir2_block_addname: OK
[   11.047844] Testing event xfs_dir2_block_lookup: OK
[   11.064831] Testing event xfs_dir2_block_replace: OK
[   11.081841] Testing event xfs_dir2_block_removename: OK
[   11.098843] Testing event xfs_dir2_block_to_sf: OK
[   11.116836] Testing event xfs_dir2_block_to_leaf: OK
[   11.133843] Testing event xfs_dir2_leaf_addname: OK
[   11.150854] Testing event xfs_dir2_leaf_lookup: OK
[   11.240853] Testing event xfs_dir2_leaf_replace: OK
[   11.257854] Testing event xfs_dir2_leaf_removename: OK
[   11.274845] Testing event xfs_dir2_leaf_to_block: OK
[   11.291844] Testing event xfs_dir2_leaf_to_node: OK
[   11.308841] Testing event xfs_dir2_node_addname: OK
[   11.325829] Testing event xfs_dir2_node_lookup: OK
[   11.342844] Testing event xfs_dir2_node_replace: OK
[   11.359853] Testing event xfs_dir2_node_removename: OK
[   11.376848] Testing event xfs_dir2_node_to_leaf: OK
[   11.393849] Testing event xfs_dir2_leafn_add: OK
[   11.410852] Testing event xfs_dir2_leafn_remove: OK
[   11.427851] Testing event xfs_dir2_grow_inode: OK
[   11.444860] Testing event xfs_dir2_shrink_inode: OK
[   11.504852] Testing event xfs_dir2_leafn_moveents: OK
[   11.521852] Testing event xfs_swap_extent_before: OK
[   11.538855] Testing event xfs_swap_extent_after: OK
[   11.555868] Testing event xfs_log_recover_item_add: OK
[   11.572856] Testing event xfs_log_recover_item_add_cont: OK
[   11.589854] Testing event xfs_log_recover_item_reorder_head: OK
[   11.606860] Testing event xfs_log_recover_item_reorder_tail: OK
[   11.623868] Testing event xfs_log_recover_item_recover: OK
[   11.641037] Testing event xfs_log_recover_buf_not_cancel: OK
[   11.657858] Testing event xfs_log_recover_buf_cancel: OK
[   11.715863] Testing event xfs_log_recover_buf_cancel_add: OK
[   11.732865] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   11.749859] Testing event xfs_log_recover_buf_recover: OK
[   11.766859] Testing event xfs_log_recover_buf_inode_buf: OK
[   11.783860] Testing event xfs_log_recover_buf_reg_buf: OK
[   11.801140] Testing event xfs_log_recover_buf_dquot_buf: OK
[   11.817862] Testing event xfs_log_recover_inode_recover: OK
[   11.834862] Testing event xfs_log_recover_inode_cancel: OK
[   11.851862] Testing event xfs_log_recover_inode_skip: OK
[   11.868864] Testing event xfs_discard_extent: OK
[   11.885865] Testing event xfs_discard_toosmall: OK
[   11.902870] Testing event xfs_discard_exclude: OK
[   11.920140] Testing event xfs_discard_busy: OK
[   11.936892] Testing event jbd2_checkpoint: OK
[   11.954880] Testing event jbd2_start_commit: OK
[   11.971881] Testing event jbd2_commit_locking: OK
[   11.988882] Testing event jbd2_commit_flushing: OK
[   12.005887] Testing event jbd2_commit_logging: OK
[   12.022886] Testing event jbd2_end_commit: OK
[   12.087890] Testing event jbd2_submit_inode_data: OK
[   12.104890] Testing event jbd2_run_stats: OK
[   12.121898] Testing event jbd2_checkpoint_stats: OK
[   12.141861] Testing event jbd2_cleanup_journal_tail: OK
[   12.158887] Testing event jbd_checkpoint: OK
[   12.221891] Testing event jbd_start_commit: OK
[   12.238867] Testing event jbd_commit_locking: OK
[   12.255891] Testing event jbd_commit_flushing: OK
[   12.273034] Testing event jbd_commit_logging: OK
[   12.289882] Testing event jbd_drop_transaction: OK
[   12.306898] Testing event jbd_end_commit: OK
[   12.323896] Testing event jbd_do_submit_data: OK
[   12.340942] Testing event jbd_cleanup_journal_tail: OK
[   12.357903] Testing event jbd_update_superblock_end: OK
[   12.374893] Testing event ext4_free_inode: OK
[   12.391894] Testing event ext4_request_inode: OK
[   12.408902] Testing event ext4_allocate_inode: OK
[   12.425901] Testing event ext4_evict_inode: OK
[   12.442903] Testing event ext4_drop_inode: OK
[   12.459900] Testing event ext4_mark_inode_dirty: OK
[   12.477029] Testing event ext4_begin_ordered_truncate: OK
[   12.494898] Testing event ext4_write_begin: OK
[   12.511899] Testing event ext4_da_write_begin: OK
[   12.528900] Testing event ext4_ordered_write_end: OK
[   12.545905] Testing event ext4_writeback_write_end: OK
[   12.607065] Testing event ext4_journalled_write_end: OK
[   12.623908] Testing event ext4_da_write_end: OK
[   12.640905] Testing event ext4_da_writepages: OK
[   12.657904] Testing event ext4_da_write_pages: OK
[   12.675705] Testing event ext4_da_writepages_result: OK
[   12.692909] Testing event ext4_writepage: OK
[   12.735911] Testing event ext4_readpage: OK
[   12.766907] Testing event ext4_releasepage: OK
[   12.819912] Testing event ext4_invalidatepage: OK
[   12.836910] Testing event ext4_discard_blocks: OK
[   12.854955] Testing event ext4_mb_new_inode_pa: OK
[   12.871941] Testing event ext4_mb_new_group_pa: OK
[   12.888912] Testing event ext4_mb_release_inode_pa: OK
[   12.905930] Testing event ext4_mb_release_group_pa: OK
[   12.922913] Testing event ext4_discard_preallocations: OK
[   12.940010] Testing event ext4_mb_discard_preallocations: OK
[   12.956916] Testing event ext4_request_blocks: OK
[   13.069586] Testing event ext4_allocate_blocks: OK
[   13.085917] Testing event ext4_free_blocks: OK
[   13.102918] Testing event ext4_sync_file_enter: OK
[   13.119927] Testing event ext4_sync_file_exit: OK
[   13.136922] Testing event ext4_sync_fs: OK
[   13.153926] Testing event ext4_alloc_da_blocks: OK
[   13.171049] Testing event ext4_mballoc_alloc: OK
[   13.187928] Testing event ext4_mballoc_prealloc: OK
[   13.204929] Testing event ext4_mballoc_discard: OK
[   13.221923] Testing event ext4_mballoc_free: OK
[   13.238927] Testing event ext4_forget: OK
[   13.255936] Testing event ext4_da_update_reserve_space: OK
[   13.273112] Testing event ext4_da_reserve_space: OK
[   13.289926] Testing event ext4_da_release_space: OK
[   13.306936] Testing event ext4_mb_bitmap_load: OK
[   13.323935] Testing event ext4_mb_buddy_bitmap_load: OK
[   13.340933] Testing event ext4_read_block_bitmap_load: OK
[   13.357930] Testing event ext4_load_inode_bitmap: OK
[   13.374934] Testing event ext4_direct_IO_enter: OK
[   13.391932] Testing event ext4_direct_IO_exit: OK
[   13.408936] Testing event ext4_fallocate_enter: OK
[   13.425930] Testing event ext4_fallocate_exit: OK
[   13.442935] Testing event ext4_unlink_enter: OK
[   13.459933] Testing event ext4_unlink_exit: OK
[   13.476937] Testing event ext4_truncate_enter: OK
[   13.493942] Testing event ext4_truncate_exit: OK
[   13.511247] Testing event ext4_ext_map_blocks_enter: OK
[   13.527927] Testing event ext4_ind_map_blocks_enter: OK
[   13.544937] Testing event ext4_ext_map_blocks_exit: OK
[   13.562081] Testing event ext4_ind_map_blocks_exit: OK
[   13.578942] Testing event ext4_ext_load_extent: OK
[   13.595942] Testing event ext4_load_inode: OK
[   13.612939] Testing event ext4_journal_start: OK
[   13.629939] Testing event ext4_trim_extent: OK
[   13.646982] Testing event ext4_trim_all_free: OK
[   13.663943] Testing event ext4_ext_handle_uninitialized_extents: OK
[   13.680940] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   13.697940] Testing event ext4_ext_put_in_cache: OK
[   13.714957] Testing event ext4_ext_in_cache: OK
[   13.731951] Testing event ext4_find_delalloc_range: OK
[   13.748953] Testing event ext4_get_reserved_cluster_alloc: OK
[   13.765943] Testing event ext4_ext_show_extent: OK
[   13.782949] Testing event ext4_remove_blocks: OK
[   13.799944] Testing event ext4_ext_rm_leaf: OK
[   13.816952] Testing event ext4_ext_rm_idx: OK
[   13.833948] Testing event ext4_ext_remove_space: OK
[   13.850949] Testing event ext4_ext_remove_space_done: OK
[   13.867956] Testing event ext3_free_inode: OK
[   13.885378] Testing event ext3_request_inode: OK
[   13.901948] Testing event ext3_allocate_inode: OK
[   13.918948] Testing event ext3_evict_inode: OK
[   13.935954] Testing event ext3_drop_inode: OK
[   13.952952] Testing event ext3_mark_inode_dirty: OK
[   13.969968] Testing event ext3_write_begin: OK
[   13.986952] Testing event ext3_ordered_write_end: OK
[   14.003952] Testing event ext3_writeback_write_end: OK
[   14.020953] Testing event ext3_journalled_write_end: OK
[   14.037964] Testing event ext3_ordered_writepage: OK
[   14.054953] Testing event ext3_writeback_writepage: OK
[   14.071962] Testing event ext3_journalled_writepage: OK
[   14.089103] Testing event ext3_readpage: OK
[   14.106054] Testing event ext3_releasepage: OK
[   14.122955] Testing event ext3_invalidatepage: OK
[   14.139961] Testing event ext3_discard_blocks: OK
[   14.156962] Testing event ext3_request_blocks: OK
[   14.173963] Testing event ext3_allocate_blocks: OK
[   14.190959] Testing event ext3_free_blocks: OK
[   14.207966] Testing event ext3_sync_file_enter: OK
[   14.224951] Testing event ext3_sync_file_exit: OK
[   14.289355] Testing event ext3_sync_fs: OK
[   14.333964] Testing event ext3_rsv_window_add: OK
[   14.350971] Testing event ext3_discard_reservation: OK
[   14.367969] Testing event ext3_alloc_new_reservation: OK
[   14.384967] Testing event ext3_reserved: OK
[   14.401965] Testing event ext3_forget: OK
[   14.418974] Testing event ext3_read_block_bitmap: OK
[   14.435969] Testing event ext3_direct_IO_enter: OK
[   14.453006] Testing event ext3_direct_IO_exit: OK
[   14.469980] Testing event ext3_unlink_enter: OK
[   14.486971] Testing event ext3_unlink_exit: OK
[   14.503971] Testing event ext3_truncate_enter: OK
[   14.520975] Testing event ext3_truncate_exit: OK
[   14.537971] Testing event ext3_get_blocks_enter: OK
[   14.554974] Testing event ext3_get_blocks_exit: OK
[   14.572970] Testing event ext3_load_inode: OK
[   14.589984] Testing event writeback_nothread: OK
[   14.606975] Testing event writeback_queue: OK
[   14.623981] Testing event writeback_exec: OK
[   14.640977] Testing event writeback_start: OK
[   14.657971] Testing event writeback_written: OK
[   14.674982] Testing event writeback_wait: OK
[   14.692058] Testing event writeback_pages_written: OK
[   14.708977] Testing event writeback_nowork: OK
[   14.725978] Testing event writeback_wake_background: OK
[   14.742981] Testing event writeback_wake_thread: OK
[   14.759981] Testing event writeback_wake_forker_thread: OK
[   14.776983] Testing event writeback_bdi_register: OK
[   14.793981] Testing event writeback_bdi_unregister: OK
[   14.810987] Testing event writeback_thread_start: OK
[   14.827994] Testing event writeback_thread_stop: OK
[   14.844999] Testing event wbc_writepage: OK
[   14.944988] Testing event writeback_queue_io: OK
[   14.961988] Testing event task_io: OK
[   14.978995] Testing event global_dirty_state: OK
[   14.995993] Testing event bdi_dirty_state: OK
[   15.012990] Testing event blkcg_dirty_ratelimit: OK
[   15.029987] Testing event bdi_dirty_ratelimit: OK
[   15.046993] Testing event balance_dirty_pages: OK
[   15.063985] Testing event writeback_congestion_wait: OK
[   15.080997] Testing event writeback_wait_iff_congested: OK
[   15.097993] Testing event writeback_single_inode_requeue: OK
[   15.114996] Testing event writeback_single_inode: OK
[   15.159004] Testing event kmalloc: OK
[   15.204993] Testing event kmem_cache_alloc: OK
[   15.221995] Testing event kmalloc_node: OK
[   15.238997] Testing event kmem_cache_alloc_node: OK
[   15.257012] Testing event kfree: OK
[   15.273987] Testing event kmem_cache_free: OK
[   15.290995] Testing event mm_page_free_direct: OK
[   15.308003] Testing event mm_pagevec_free: OK
[   15.325009] Testing event mm_page_alloc: OK
[   15.342018] Testing event mm_page_alloc_zone_locked: OK
[   15.359005] Testing event mm_page_pcpu_drain: OK
[   15.376612] Testing event mm_page_alloc_extfrag: OK
[   15.393003] Testing event mm_vmscan_kswapd_sleep: OK
[   15.410144] Testing event mm_vmscan_kswapd_wake: OK
[   15.427987] Testing event mm_vmscan_wakeup_kswapd: OK
[   15.445007] Testing event mm_vmscan_direct_reclaim_begin: OK
[   15.462006] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   15.479374] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   15.496012] Testing event mm_vmscan_direct_reclaim_end: OK
[   15.513006] Testing event mm_vmscan_memcg_reclaim_end: OK
[   15.530006] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   15.547010] Testing event mm_shrink_slab_start: OK
[   15.564008] Testing event mm_shrink_slab_end: OK
[   15.581486] Testing event mm_vmscan_lru_isolate: OK
[   15.599005] Testing event mm_vmscan_memcg_isolate: OK
[   15.616163] Testing event mm_vmscan_writepage: OK
[   15.633325] Testing event mm_vmscan_lru_shrink_inactive: OK
[   15.650010] Testing event replace_swap_token: OK
[   15.667007] Testing event put_swap_token: OK
[   15.686986] Testing event disable_swap_token: OK
[   15.705001] Testing event update_swap_token_priority: OK
[   15.722015] Testing event cpu_idle: OK
[   15.739011] Testing event cpu_frequency: OK
[   15.756804] Testing event machine_suspend: OK
[   15.774039] Testing event power_start: OK
[   15.791016] Testing event power_frequency: OK
[   15.808280] Testing event power_end: OK
[   15.825020] Testing event clock_enable: OK
[   15.842077] Testing event clock_disable: OK
[   15.859028] Testing event clock_set_rate: OK
[   15.876207] Testing event power_domain_target: OK
[   15.894143] Testing event ftrace_test_filter: OK
[   15.912173] Testing event module_load: OK
[   15.929210] Testing event module_free: OK
[   15.946137] Testing event module_get: OK
[   15.963165] Testing event module_put: OK
[   15.980158] Testing event module_request: OK
[   15.998225] Testing event lock_acquire: OK
[   16.015233] Testing event lock_release: OK
[   16.032245] Testing event lock_contended: OK
[   16.049277] Testing event lock_acquired: OK
[   16.067225] Testing event rcu_utilization: OK
[   16.085041] Testing event rcu_grace_period: OK
[   16.101190] Testing event rcu_grace_period_init: OK
[   16.118177] Testing event rcu_preempt_task: OK
[   16.136156] Testing event rcu_unlock_preempted_task: OK
[   16.153208] Testing event rcu_quiescent_state_report: OK
[   16.170112] Testing event rcu_fqs: OK
[   16.186269] Testing event rcu_dyntick: OK
[   16.204210] Testing event rcu_callback: OK
[   16.222187] Testing event rcu_kfree_callback: OK
[   16.239112] Testing event rcu_batch_start: OK
[   16.255156] Testing event rcu_invoke_callback: OK
[   16.272173] Testing event rcu_invoke_kfree_callback: OK
[   16.289204] Testing event rcu_batch_end: OK
[   16.306176] Testing event rcu_torture_read: OK
[   16.323237] Testing event workqueue_queue_work: OK
[   16.340201] Testing event workqueue_activate_work: OK
[   16.359195] Testing event workqueue_execute_start: OK
[   16.376194] Testing event workqueue_execute_end: OK
[   16.393267] Testing event signal_generate: OK
[   16.410247] Testing event signal_deliver: OK
[   16.427196] Testing event signal_overflow_fail: OK
[   16.444259] Testing event signal_lose_info: OK
[   16.461206] Testing event timer_init: OK
[   16.479173] Testing event timer_start: OK
[   16.496156] Testing event timer_expire_entry: OK
[   16.512176] Testing event timer_expire_exit: OK
[   16.530169] Testing event timer_cancel: OK
[   16.547164] Testing event hrtimer_init: OK
[   16.565205] Testing event hrtimer_start: OK
[   16.581163] Testing event hrtimer_expire_entry: OK
[   16.599188] Testing event hrtimer_expire_exit: OK
[   16.617163] Testing event hrtimer_cancel: OK
[   16.633166] Testing event itimer_state: OK
[   16.650207] Testing event itimer_expire: OK
[   16.669177] Testing event irq_handler_entry: OK
[   16.688274] Testing event irq_handler_exit: OK
[   16.707248] Testing event softirq_entry: OK
[   16.725133] Testing event softirq_exit: OK
[   16.741290] Testing event softirq_raise: OK
[   16.760190] Testing event sched_kthread_stop: OK
[   16.778364] Testing event sched_kthread_stop_ret: OK
[   16.797191] Testing event sched_wakeup: OK
[   16.815264] Testing event sched_wakeup_new: OK
[   16.833221] Testing event sched_switch: OK
[   16.850152] Testing event sched_migrate_task: OK
[   16.868234] Testing event sched_process_free: OK
[   16.886144] Testing event sched_process_exit: OK
[   16.904211] Testing event sched_wait_task: OK
[   16.921153] Testing event sched_process_wait: OK
[   16.938248] Testing event sched_process_fork: OK
[   16.955200] Testing event sched_stat_wait: OK
[   16.973198] Testing event sched_stat_sleep: OK
[   16.990203] Testing event sched_stat_iowait: OK
[   17.006239] Testing event sched_stat_runtime: OK
[   17.023206] Testing event sched_pi_setprio: OK
[   17.041343] Testing event mce_record: OK
[   17.058233] Testing event sys_enter: OK
[   17.075107] Testing event sys_exit: OK
[   17.093310] Testing event emulate_vsyscall: OK
[   17.110251] Testing event kvm_mmu_pagetable_walk: OK
[   17.127290] Testing event kvm_mmu_paging_element: OK
[   17.144234] Testing event kvm_mmu_set_accessed_bit: OK
[   17.161255] Testing event kvm_mmu_set_dirty_bit: OK
[   17.178212] Testing event kvm_mmu_walker_error: OK
[   17.196307] Testing event kvm_mmu_get_page: OK
[   17.213228] Testing event kvm_mmu_sync_page: OK
[   17.230203] Testing event kvm_mmu_unsync_page: OK
[   17.249219] Testing event kvm_mmu_prepare_zap_page: OK
[   17.266203] Testing event kvm_mmu_delay_free_pages: OK
[   17.283298] Testing event mark_mmio_spte: OK
[   17.301238] Testing event handle_mmio_page_fault: OK
[   17.318247] Testing event kvm_mmu_audit: OK
[   17.336212] Testing event kvm_entry: OK
[   17.352279] Testing event kvm_hypercall: OK
[   17.369220] Testing event kvm_hv_hypercall: OK
[   17.388278] Testing event kvm_pio: OK
[   17.405224] Testing event kvm_cpuid: OK
[   17.421361] Testing event kvm_apic: OK
[   17.438206] Testing event kvm_exit: OK
[   17.454223] Testing event kvm_inj_virq: OK
[   17.472240] Testing event kvm_inj_exception: OK
[   17.489263] Testing event kvm_page_fault: OK
[   17.508315] Testing event kvm_msr: OK
[   17.525286] Testing event kvm_cr: OK
[   17.542222] Testing event kvm_pic_set_irq: OK
[   17.558222] Testing event kvm_apic_ipi: OK
[   17.575264] Testing event kvm_apic_accept_irq: OK
[   17.592269] Testing event kvm_nested_vmrun: OK
[   17.610257] Testing event kvm_nested_intercepts: OK
[   17.627274] Testing event kvm_nested_vmexit: OK
[   17.644343] Testing event kvm_nested_vmexit_inject: OK
[   17.662234] Testing event kvm_nested_intr_vmexit: OK
[   17.679238] Testing event kvm_invlpga: OK
[   17.696345] Testing event kvm_skinit: OK
[   17.713233] Testing event kvm_emulate_insn: OK
[   17.729238] Testing event vcpu_match_mmio: OK
[   17.747219] Testing event kvm_userspace_exit: OK
[   17.765363] Testing event kvm_set_irq: OK
[   17.783269] Testing event kvm_ioapic_set_irq: OK
[   17.801250] Testing event kvm_msi_set_irq: OK
[   17.818337] Testing event kvm_ack_irq: OK
[   17.835215] Testing event kvm_mmio: OK
[   17.852247] Testing event kvm_fpu: OK
[   17.870265] Testing event kvm_age_page: OK
[   17.887212] Testing event kvm_try_async_get_page: OK
[   17.903216] Testing event kvm_async_pf_doublefault: OK
[   17.920276] Testing event kvm_async_pf_not_present: OK
[   17.937276] Testing event kvm_async_pf_ready: OK
[   17.955271] Testing event kvm_async_pf_completed: OK
[   17.973291] Running tests on trace event systems:
[   17.973614] Testing event system skb: OK
[   17.990347] Testing event system net: OK
[   18.007420] Testing event system napi: OK
[   18.024267] Testing event system sock: OK
[   18.042293] Testing event system udp: OK
[   18.059256] Testing event system hda: OK
[   18.077527] Testing event system scsi: OK
[   18.095437] Testing event system i915: OK
[   18.114215] Testing event system drm: OK
[   18.132423] Testing event system block: OK
[   18.150924] Testing event system btrfs: OK
[   18.169140] Testing event system xfs: OK
[   18.222565] Testing event system jbd2: OK
[   18.240621] Testing event system jbd: OK
[   18.258642] Testing event system ext4: OK
[   18.282843] Testing event system ext3: OK
[   18.304173] Testing event system writeback: OK
[   18.323360] Testing event system kmem: OK
[   18.342862] Testing event system vmscan: OK
[   18.361037] Testing event system power: OK
[   18.378769] Testing event system test: OK
[   18.396274] Testing event system module: OK
[   18.413428] Testing event system lock: OK
[   18.430466] Testing event system rcu: OK
[   18.447829] Testing event system workqueue: OK
[   18.464311] Testing event system signal: OK
[   18.481541] Testing event system timer: OK
[   18.498749] Testing event system irq: OK
[   18.515425] Testing event system sched: OK
[   18.534908] Testing event system mce: OK
[   18.552351] Testing event system raw_syscalls: OK
[   18.569316] Testing event system vsyscall: OK
[   18.587266] Testing event system syscalls: OK
[   18.604812] Testing event system kvmmmu: OK
[   18.623797] Testing event system kvm: OK
[   18.644819] Running tests on all trace events:
[   18.645135] Testing all events: OK
[   18.781183] ------------[ cut here ]------------
[   18.781507] WARNING: at /c/wfg/linux-next/kernel/trace/trace_events.c:1721 event_trace_self_tests_init+0x33/0x66()
[   18.782167] Hardware name:
[   18.782446] Modules linked in:
[   18.782747] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #883
[   18.783331] Call Trace:
[   18.783574]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[   18.783961]  [<ffffffff821320ff>] ? test_work+0x64/0x64
[   18.787256]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
[   18.787621]  [<ffffffff82132132>] event_trace_self_tests_init+0x33/0x66
[   18.788032]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[   18.788391]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[   18.788744]  [<ffffffff8198ee04>] kernel_thread_helper+0x4/0x10
[   18.789118]  [<ffffffff81986234>] ? retint_restore_args+0x13/0x13
[   18.789493]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[   18.789865]  [<ffffffff8198ee00>] ? gs_change+0x13/0x13
[   18.790207] ---[ end trace 4eaa2a86a8e2da2d ]---
[   18.790526] Failed to enable function tracer for event tests
[   18.790897] Testing ftrace filter: OK
[   18.791659] Testing kprobe tracing: OK
[   18.807872]   Magic number: 15:300:398
[   18.808277] netconsole: local port 6665
[   18.808568] netconsole: local IP 10.0.0.0
[   18.808878] netconsole: interface 'eth0'
[   18.809172] netconsole: remote port 6666
[   18.809466] netconsole: remote IP 192.168.1.1
[   18.809780] netconsole: remote ethernet address 00:30:48:fe:19:95
[   18.810158] netconsole: device eth0 not up yet, forcing it
[   18.906038] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   18.956931] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   18.957606] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   22.078681] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   22.079634] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   22.085173] console [netcon0] enabled
[   22.085465] netconsole: network logging started
[   22.085824] rtc_cmos 00:02: setting system clock to 2011-10-31 20:24:13 UTC (1320092653)
[   22.106869] IP-Config: Complete:
[   22.107144]      device=eth0, addr=192.168.1.52, mask=255.255.255.0, gw=192.168.1.1,
[   22.107687]      host=fat, domain=, nis-domain=(none),
[   22.108084]      bootserver=192.168.1.11, rootserver=192.168.1.11, rootpath=
[   22.108981] md: Waiting for all devices to be available before autodetect
[   22.109389] md: If you don't use raid, use raid=noautodetect
[   22.110962] md: Autodetecting RAID arrays.
[   22.111269] md: Scanned 0 and added 0 devices.
[   22.111588] md: autorun ...
[   22.111856] md: ... autorun DONE.
[   23.119351] VFS: Mounted root (nfs filesystem) on device 0:16.
[   23.119750] debug: unmapping init memory ffffffff81f41000..ffffffff821f6000
[   23.212173] stty used greatest stack depth: 4616 bytes left
[   23.226672] startpar used greatest stack depth: 3752 bytes left
[   23.246414] sed used greatest stack depth: 3672 bytes left
[   23.271251] S02hostname.sh used greatest stack depth: 3640 bytes left
[   23.288010] mountpoint used greatest stack depth: 3544 bytes left
[   23.621671] grep used greatest stack depth: 3496 bytes left
[   25.071504] EXT4-fs (sda5): recovery complete
[   25.071889] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   25.410186] ifup used greatest stack depth: 3464 bytes left
[   26.032066] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   26.032680] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   26.036148] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   26.036732] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   26.164768] S90mountdebugfs used greatest stack depth: 3032 bytes left
[   26.694237] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   26.695780] NFSD: starting 90-second grace period
[   28.040116] mount.nfs used greatest stack depth: 2632 bytes left
[   29.778594] XFS (sda7): Mounting Filesystem
[   29.868876] XFS (sda7): Ending clean mount
[   32.363170] eth0: no IPv6 routers present
w

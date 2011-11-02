Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab1KBPCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:02:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:1643 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab1KBPCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:02:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,444,1315206000"; 
   d="scan'208";a="69748152"
Date: Wed, 2 Nov 2011 23:01:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Carsten Emde <cbe@osadl.org>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111102150146.GA3648@localhost>
References: <20111031104325.GA25808@localhost>
 <20111031114142.GA32555@localhost>
 <20111031121951.GM6160@linux.vnet.ibm.com>
 <1320075882.4793.4.camel@gandalf.stny.rr.com>
 <20111101003434.GR6160@linux.vnet.ibm.com>
 <20111101070720.GA22936@localhost>
 <20111101160014.GH2287@linux.vnet.ibm.com>
 <20111101163212.GA19501@localhost>
 <20111102144403.GA22445@linux.vnet.ibm.com>
 <1320245786.4793.32.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320245786.4793.32.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 10:56:26PM +0800, Steven Rostedt wrote:
> On Wed, 2011-11-02 at 07:44 -0700, Paul E. McKenney wrote:
> 
> > rcu: Fix idle-task checks
> > 
> > RCU has traditionally relied on idle_cpu() to determine whether a given
> > CPU is running in the context of an idle task, but recent changes have
> > invalidated this approach.
> 
> Correct. idle_cpu() returns if the CPU is idle or not, not if the CPU is
> running the idle thread. If the CPU wakes up on the idle thread and
> there's tasks on the run queue, then idle_cpu() will return false, even
> though the task running is the idle thread. But the CPU itself is not
> technically idle.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

With the patch I no longer see the RCU warnings. Below is the full dmesg.

Tested-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks,
Fengguang
---
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-ioless-full-next-20111025+ (wfg@bee) (gcc version 4.5.0 (GCC) ) #890 SMP Wed Nov 2 22:51:56 CST 2011
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
[    0.000000] Memory: 3012416k/3137536k available (9798k kernel code, 3396k absent, 121724k reserved, 5804k data, 2768k init)
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
[    0.002000] Detected 3199.735 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6399.47 BogoMIPS (lpj=3199735)
[    0.000707] pid_max: default: 32768 minimum: 301
[    0.001906] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003980] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004981] Mount-cache hash table entries: 256
[    0.005689] Initializing cgroup subsys debug
[    0.005999] Initializing cgroup subsys cpuacct
[    0.006332] Initializing cgroup subsys memory
[    0.006669] Initializing cgroup subsys devices
[    0.006985] Initializing cgroup subsys freezer
[    0.007310] Initializing cgroup subsys blkio
[    0.007675] CPU: Physical Processor ID: 0
[    0.007974] CPU: Processor Core ID: 0
[    0.008273] mce: CPU supports 9 MCE banks
[    0.008579] CPU0: Thermal monitoring enabled (TM1)
[    0.008916] using mwait in idle threads.
[    0.010072] ACPI: Core revision 20110623
[    0.021870] ftrace: allocating 38072 entries in 150 pages
[    0.030771] Getting VERSION: 60015
[    0.031048] Getting VERSION: 60015
[    0.031334] Getting ID: 0
[    0.031582] Getting ID: 0
[    0.031829] Switched APIC routing to physical flat.
[    0.032161] enabled ExtINT on CPU#0
[    0.032669] ENABLING IO-APIC IRQs
[    0.032943] init IO_APIC IRQs
[    0.033211]  apic 8 pin 0 not connected
[    0.033510] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.034075] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.034650] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.035218] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.035784] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.036351] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.036917] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.037484] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.038050] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.038618] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.039192] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.039765] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.040338] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.040909] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.041482] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.042051]  apic 8 pin 16 not connected
[    0.042348]  apic 8 pin 17 not connected
[    0.042643]  apic 8 pin 18 not connected
[    0.042937]  apic 8 pin 19 not connected
[    0.043235]  apic 8 pin 20 not connected
[    0.043529]  apic 8 pin 21 not connected
[    0.043824]  apic 8 pin 22 not connected
[    0.044119]  apic 8 pin 23 not connected
[    0.044550] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054922] CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
[    0.055406] Using local APIC timer interrupts.
[    0.055407] calibrating APIC timer ...
[    0.157163] ... lapic delta = 833232
[    0.157444] ... PM-Timer delta = 357899
[    0.157735] ... PM-Timer result ok
[    0.158010] ..... delta 833232
[    0.158272] ..... mult: 35792482
[    0.158542] ..... calibration result: 133317
[    0.158850] ..... CPU clock speed is 3199.0617 MHz.
[    0.159181] ..... host bus clock speed is 133.0317 MHz.
[    0.159538] Performance Events: PEBS fmt1+, erratum AAJ80 worked around, Nehalem events, Intel PMU driver.
[    0.160302] ... version:                3
[    0.160603] ... bit width:              48
[    0.160905] ... generic registers:      4
[    0.161204] ... value mask:             0000ffffffffffff
[    0.161554] ... max period:             000000007fffffff
[    0.161901] ... fixed-purpose events:   3
[    0.162200] ... event mask:             000000070000000f
[    0.162750] Testing tracer nop: PASSED
[    0.163163] lockdep: fixing up alternatives.
[    0.163527] Booting Node   0, Processors  #1
[    0.163750] smpboot cpu 1: start_ip = 97000
[    0.175319] masked ExtINT on CPU#1
[    0.195664] lockdep: fixing up alternatives.
[    0.195996]  #2
[    0.196088] smpboot cpu 2: start_ip = 97000
[    0.207660] masked ExtINT on CPU#2
[    0.227984] lockdep: fixing up alternatives.
[    0.228318]  #3
[    0.228410] smpboot cpu 3: start_ip = 97000
[    0.239981] masked ExtINT on CPU#3
[    0.260303] lockdep: fixing up alternatives.
[    0.260642]  #4
[    0.260734] smpboot cpu 4: start_ip = 97000
[    0.272302] masked ExtINT on CPU#4
[    0.292638] lockdep: fixing up alternatives.
[    0.292972]  #5
[    0.293064] smpboot cpu 5: start_ip = 97000
[    0.307610] masked ExtINT on CPU#5
[    0.327935] lockdep: fixing up alternatives.
[    0.328272]  #6
[    0.328364] smpboot cpu 6: start_ip = 97000
[    0.339935] masked ExtINT on CPU#6
[    0.360256] lockdep: fixing up alternatives.
[    0.360596]  #7
[    0.360688] smpboot cpu 7: start_ip = 97000
[    0.372255] masked ExtINT on CPU#7
[    0.392478] Brought up 8 CPUs
[    0.392740] Total of 8 processors activated (51195.76 BogoMIPS).
[    0.396499] CPU0 attaching sched-domain:
[    0.396798]  domain 0: span 0,4 level SIBLING
[    0.397142]   groups: 0 (cpu_power = 589) 4 (cpu_power = 589)
[    0.397676]   domain 1: span 0-7 level MC
[    0.398007]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    0.398963] CPU1 attaching sched-domain:
[    0.399257]  domain 0: span 1,5 level SIBLING
[    0.399606]   groups: 1 (cpu_power = 589) 5 (cpu_power = 589)
[    0.400135]   domain 1: span 0-7 level MC
[    0.400466]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    0.401422] CPU2 attaching sched-domain:
[    0.401720]  domain 0: span 2,6 level SIBLING
[    0.402065]   groups: 2 (cpu_power = 589) 6 (cpu_power = 589)
[    0.402598]   domain 1: span 0-7 level MC
[    0.402930]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    0.403885] CPU3 attaching sched-domain:
[    0.404180]  domain 0: span 3,7 level SIBLING
[    0.404527]   groups: 3 (cpu_power = 589) 7 (cpu_power = 589)
[    0.405057]   domain 1: span 0-7 level MC
[    0.405389]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    0.406345] CPU4 attaching sched-domain:
[    0.406643]  domain 0: span 0,4 level SIBLING
[    0.406987]   groups: 4 (cpu_power = 589) 0 (cpu_power = 589)
[    0.407520]   domain 1: span 0-7 level MC
[    0.407851]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    0.408808] CPU5 attaching sched-domain:
[    0.409102]  domain 0: span 1,5 level SIBLING
[    0.409446]   groups: 5 (cpu_power = 589) 1 (cpu_power = 589)
[    0.409979]   domain 1: span 0-7 level MC
[    0.410311]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    0.411265] CPU6 attaching sched-domain:
[    0.411563]  domain 0: span 2,6 level SIBLING
[    0.411908]   groups: 6 (cpu_power = 589) 2 (cpu_power = 589)
[    0.412438]   domain 1: span 0-7 level MC
[    0.412772]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    0.413728] CPU7 attaching sched-domain:
[    0.414022]  domain 0: span 3,7 level SIBLING
[    0.414365]   groups: 7 (cpu_power = 589) 3 (cpu_power = 589)
[    0.414900]   domain 1: span 0-7 level MC
[    0.415232]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    0.416637] devtmpfs: initialized
[    0.417905] PM: Registering ACPI NVS region at bcde3000 (2195456 bytes)
[    0.418361] PM: Registering ACPI NVS region at bf714000 (700416 bytes)
[    0.419430] xor: automatically using best checksumming function: generic_sse
[    0.424465]    generic_sse: 11932.000 MB/sec
[    0.424775] xor: using function: generic_sse (11932.000 MB/sec)
[    0.425262] kworker/u:0 used greatest stack depth: 5608 bytes left
[    0.425290] RTC time: 22:54:23, date: 11/02/11
[    0.425375] NET: Registered protocol family 16
[    0.426276] kworker/u:0 used greatest stack depth: 5192 bytes left
[    0.426782] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.427335] ACPI: bus type pci registered
[    0.427836] dca service started, version 1.12.1
[    0.428231] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.428848] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.440943] PCI: Using configuration type 1 for base access
[    0.465795] bio: create slab <bio-0> at 0
[    0.482462] raid6: int64x1   2777 MB/s
[    0.499448] raid6: int64x2   3207 MB/s
[    0.516460] raid6: int64x4   2718 MB/s
[    0.533450] raid6: int64x8   2089 MB/s
[    0.550438] raid6: sse2x1    7878 MB/s
[    0.567427] raid6: sse2x2    9238 MB/s
[    0.584421] raid6: sse2x4   10785 MB/s
[    0.584710] raid6: using algorithm sse2x4 (10785 MB/s)
[    0.585131] ACPI: Added _OSI(Module Device)
[    0.585445] ACPI: Added _OSI(Processor Device)
[    0.585760] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.586084] ACPI: Added _OSI(Processor Aggregator Device)
[    0.590501] ACPI: EC: Look up EC in DSDT
[    0.611570] ACPI: Interpreter enabled
[    0.611858] ACPI: (supports S0 S1 S3 S4 S5)
[    0.612364] ACPI: Using IOAPIC for interrupt routing
[    0.625157] ACPI: No dock devices found.
[    0.625462] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.626661] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3d])
[    0.628268] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.628669] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.629064] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.629604] pci_root PNP0A03:00: host bridge window [mem 0x000c4000-0x000cbfff]
[    0.630140] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfedfffff]
[    0.630682] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xf7ffffff]
[    0.631242] pci 0000:00:00.0: [8086:3405] type 0 class 0x000600
[    0.631690] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    0.632117] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.632505] pci 0000:00:01.0: PME# disabled
[    0.632836] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    0.633262] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.633644] pci 0000:00:03.0: PME# disabled
[    0.633977] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    0.634403] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.634785] pci 0000:00:07.0: PME# disabled
[    0.635118] pci 0000:00:10.0: [8086:3425] type 0 class 0x000800
[    0.635573] pci 0000:00:10.1: [8086:3426] type 0 class 0x000800
[    0.636022] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    0.636471] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    0.636916] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    0.637355] pci 0000:00:14.3: [8086:3438] type 0 class 0x000800
[    0.637807] pci 0000:00:19.0: [8086:10cc] type 0 class 0x000200
[    0.638196] pci 0000:00:19.0: reg 10: [mem 0xe0300000-0xe031ffff]
[    0.638584] pci 0000:00:19.0: reg 14: [mem 0xe0323000-0xe0323fff]
[    0.638969] pci 0000:00:19.0: reg 18: [io  0x2100-0x211f]
[    0.639377] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.639761] pci 0000:00:19.0: PME# disabled
[    0.640085] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    0.640512] pci 0000:00:1a.0: reg 20: [io  0x20e0-0x20ff]
[    0.640916] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
[    0.641337] pci 0000:00:1a.1: reg 20: [io  0x20c0-0x20df]
[    0.641745] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    0.642165] pci 0000:00:1a.2: reg 20: [io  0x20a0-0x20bf]
[    0.642581] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    0.642971] pci 0000:00:1a.7: reg 10: [mem 0xe0322000-0xe03223ff]
[    0.643435] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.643815] pci 0000:00:1a.7: PME# disabled
[    0.644145] pci 0000:00:1b.0: [8086:3a3e] type 0 class 0x000403
[    0.644538] pci 0000:00:1b.0: reg 10: [mem 0xf7f00000-0xf7f03fff 64bit]
[    0.645002] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.645380] pci 0000:00:1b.0: PME# disabled
[    0.645712] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    0.646149] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.646531] pci 0000:00:1c.0: PME# disabled
[    0.646860] pci 0000:00:1c.1: [8086:3a42] type 1 class 0x000604
[    0.647298] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.647680] pci 0000:00:1c.1: PME# disabled
[    0.648011] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    0.648458] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.648836] pci 0000:00:1c.4: PME# disabled
[    0.649169] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    0.649594] pci 0000:00:1d.0: reg 20: [io  0x2080-0x209f]
[    0.649997] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    0.650422] pci 0000:00:1d.1: reg 20: [io  0x2060-0x207f]
[    0.650829] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    0.651251] pci 0000:00:1d.2: reg 20: [io  0x2040-0x205f]
[    0.651668] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    0.652060] pci 0000:00:1d.7: reg 10: [mem 0xe0321000-0xe03213ff]
[    0.652525] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.652905] pci 0000:00:1d.7: PME# disabled
[    0.653230] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.653674] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    0.654141] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.654527] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.655078] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
[    0.655676] pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
[    0.656065] pci 0000:00:1f.2: reg 10: [io  0x2128-0x212f]
[    0.656427] pci 0000:00:1f.2: reg 14: [io  0x2134-0x2137]
[    0.656784] pci 0000:00:1f.2: reg 18: [io  0x2120-0x2127]
[    0.657142] pci 0000:00:1f.2: reg 1c: [io  0x2130-0x2133]
[    0.657503] pci 0000:00:1f.2: reg 20: [io  0x2020-0x203f]
[    0.657861] pci 0000:00:1f.2: reg 24: [mem 0xe0320000-0xe03207ff]
[    0.658275] pci 0000:00:1f.2: PME# supported from D3hot
[    0.658626] pci 0000:00:1f.2: PME# disabled
[    0.658948] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    0.659336] pci 0000:00:1f.3: reg 10: [mem 0xf7f04000-0xf7f040ff 64bit]
[    0.659759] pci 0000:00:1f.3: reg 20: [io  0x2000-0x201f]
[    0.663162] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.663571] pci 0000:02:00.0: [5333:9043] type 0 class 0x000300
[    0.663950] pci 0000:02:00.0: reg 10: [mem 0xe0200000-0xe027ffff]
[    0.664334] pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff pref]
[    0.664766] pci 0000:02:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.665179] pci 0000:02:00.0: supports D1 D2
[    0.665513] pci 0000:02:00.1: [5333:903f] type 0 class 0x000403
[    0.665892] pci 0000:02:00.1: reg 10: [mem 0xe0280000-0xe0283fff]
[    0.666335] pci 0000:02:00.1: supports D1 D2
[    0.666663] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.667010] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.667419] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.668017] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.668421] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.668824] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    0.669252] pci 0000:06:00.0: [11ab:6121] type 0 class 0x000101
[    0.669646] pci 0000:06:00.0: reg 10: [io  0x1018-0x101f]
[    0.670010] pci 0000:06:00.0: reg 14: [io  0x1024-0x1027]
[    0.670374] pci 0000:06:00.0: reg 18: [io  0x1010-0x1017]
[    0.670743] pci 0000:06:00.0: reg 1c: [io  0x1020-0x1023]
[    0.671107] pci 0000:06:00.0: reg 20: [io  0x1000-0x100f]
[    0.671475] pci 0000:06:00.0: reg 24: [mem 0xe0100000-0xe01003ff]
[    0.671914] pci 0000:06:00.0: supports D1
[    0.672212] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
[    0.672582] pci 0000:06:00.0: PME# disabled
[    0.672907] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.673253] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.673633] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.674082] pci 0000:07:03.0: [104c:8023] type 0 class 0x000c00
[    0.674473] pci 0000:07:03.0: reg 10: [mem 0xe0004000-0xe00047ff]
[    0.674858] pci 0000:07:03.0: reg 14: [mem 0xe0000000-0xe0003fff]
[    0.675306] pci 0000:07:03.0: supports D1 D2
[    0.675618] pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
[    0.675993] pci 0000:07:03.0: PME# disabled
[    0.676351] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.676769] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.677175] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.677737] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.678297] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.678885] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000cbfff] (subtractive decode)
[    0.679473] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    0.680058] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xf7ffffff] (subtractive decode)
[    0.680681] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.681957] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.682585] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
[    0.683056] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
[    0.683528] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
[    0.683995] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.684467] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.684944] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.685508]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
[    0.708629] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.709714] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.710796] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.711875] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.712954] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.714038] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.715117] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.716197] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.717524] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.718097] vgaarb: loaded
[    0.718347] vgaarb: bridge control possible 0000:02:00.0
[    0.718909] SCSI subsystem initialized
[    0.719371] libata version 3.00 loaded.
[    0.719958] usbcore: registered new interface driver usbfs
[    0.720370] usbcore: registered new interface driver hub
[    0.720799] usbcore: registered new device driver usb
[    0.721593] wmi: Mapper loaded
[    0.721921] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.722306] PCI: Using ACPI for IRQ routing
[    0.724195] PCI: Discovered peer bus 3f
[    0.724571] pci 0000:3f:00.0: [8086:2c41] type 0 class 0x000600
[    0.724973] pci 0000:3f:00.1: [8086:2c01] type 0 class 0x000600
[    0.725376] pci 0000:3f:02.0: [8086:2c10] type 0 class 0x000600
[    0.725782] pci 0000:3f:02.1: [8086:2c11] type 0 class 0x000600
[    0.726183] pci 0000:3f:03.0: [8086:2c18] type 0 class 0x000600
[    0.726584] pci 0000:3f:03.1: [8086:2c19] type 0 class 0x000600
[    0.726983] pci 0000:3f:03.4: [8086:2c1c] type 0 class 0x000600
[    0.727385] pci 0000:3f:04.0: [8086:2c20] type 0 class 0x000600
[    0.727782] pci 0000:3f:04.1: [8086:2c21] type 0 class 0x000600
[    0.728178] pci 0000:3f:04.2: [8086:2c22] type 0 class 0x000600
[    0.728577] pci 0000:3f:04.3: [8086:2c23] type 0 class 0x000600
[    0.728977] pci 0000:3f:05.0: [8086:2c28] type 0 class 0x000600
[    0.729374] pci 0000:3f:05.1: [8086:2c29] type 0 class 0x000600
[    0.729775] pci 0000:3f:05.2: [8086:2c2a] type 0 class 0x000600
[    0.730172] pci 0000:3f:05.3: [8086:2c2b] type 0 class 0x000600
[    0.730580] pci 0000:3f:06.0: [8086:2c30] type 0 class 0x000600
[    0.730978] pci 0000:3f:06.1: [8086:2c31] type 0 class 0x000600
[    0.731381] pci 0000:3f:06.2: [8086:2c32] type 0 class 0x000600
[    0.731780] pci 0000:3f:06.3: [8086:2c33] type 0 class 0x000600
[    0.733610] PCI: pci_cache_line_size set to 64 bytes
[    0.734178] reserve RAM buffer: 000000000009cc00 - 000000000009ffff 
[    0.734447] reserve RAM buffer: 00000000bcde3000 - 00000000bfffffff 
[    0.734868] reserve RAM buffer: 00000000bf6bd000 - 00000000bfffffff 
[    0.735288] reserve RAM buffer: 00000000bf714000 - 00000000bfffffff 
[    0.735711] reserve RAM buffer: 00000000bf7e7000 - 00000000bfffffff 
[    0.736131] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff 
[    0.765149] pnp: PnP ACPI init
[    0.765596] ACPI: bus type pnp registered
[    0.766509] pnp 00:00: [bus 00-3d]
[    0.766787] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.767090] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.767419] pnp 00:00: [io  0x0d00-0xffff window]
[    0.767745] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.768095] pnp 00:00: [mem 0x000c4000-0x000cbfff window]
[    0.768450] pnp 00:00: [mem 0xfed40000-0xfedfffff window]
[    0.768800] pnp 00:00: [mem 0xd0000000-0xf7ffffff window]
[    0.769150] pnp 00:00: [mem 0x00000000 window]
[    0.769615] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.770284] pnp 00:01: [io  0x0000-0x000f]
[    0.770591] pnp 00:01: [io  0x0081-0x0083]
[    0.770893] pnp 00:01: [io  0x0087]
[    0.771172] pnp 00:01: [io  0x0089-0x008b]
[    0.771476] pnp 00:01: [io  0x008f]
[    0.771756] pnp 00:01: [io  0x00c0-0x00df]
[    0.772058] pnp 00:01: [dma 4]
[    0.772420] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.772827] pnp 00:02: [io  0x0070-0x0071]
[    0.773129] pnp 00:02: [io  0x0074-0x0077]
[    0.773443] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.774008] pnp 00:02: [irq 8]
[    0.774363] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.774780] pnp 00:03: [io  0x00f0]
[    0.775062] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.775636] pnp 00:03: [irq 13]
[    0.776000] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.776417] pnp 00:04: [io  0x0061]
[    0.776796] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.777204] pnp 00:05: [io  0x0500-0x053f]
[    0.777511] pnp 00:05: [io  0x0400-0x047f]
[    0.777813] pnp 00:05: [io  0x0092]
[    0.778092] pnp 00:05: [io  0x0680-0x06ff]
[    0.778397] pnp 00:05: [io  0x0010-0x001f]
[    0.778698] pnp 00:05: [io  0x0072-0x0073]
[    0.779000] pnp 00:05: [io  0x0080]
[    0.779282] pnp 00:05: [io  0x0084-0x0086]
[    0.779589] pnp 00:05: [io  0x0088]
[    0.779868] pnp 00:05: [io  0x008c-0x008e]
[    0.780171] pnp 00:05: [io  0x0090-0x009f]
[    0.780659] system 00:05: [io  0x0500-0x053f] has been reserved
[    0.781031] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.781406] system 00:05: [io  0x0680-0x06ff] has been reserved
[    0.781778] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.782258] pnp 00:06: [io  0x0060]
[    0.782544] pnp 00:06: [io  0x0064]
[    0.782992] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.783935] pnp 00:07: [mem 0xfec00000-0xfec000ff]
[    0.784377] pnp 00:07: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.784904] pnp: PnP ACPI: found 8 devices
[    0.785206] ACPI: ACPI bus type pnp unregistered
[    0.796470] Switching to clocksource acpi_pm
[    0.796910] pci 0000:02:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.797548] PCI: max bus depth: 1 pci_try_num: 2
[    0.797961] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.798316] pci 0000:02:00.0: BAR 6: assigned [mem 0xe0290000-0xe029ffff pref]
[    0.798850] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.799202] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.799604] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.803146] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.803498] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.803852] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    0.804211] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.804555] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.804948] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.805356] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    0.805703] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.806139] IOAPIC[0]: Set routing entry (8-16 -> 0x29 -> IRQ 16 Mode:1 Active:1 Dest:0)
[    0.806709] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.807129] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.807533] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.807957] IOAPIC[0]: Set routing entry (8-17 -> 0x41 -> IRQ 17 Mode:1 Active:1 Dest:0)
[    0.808526] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.808945] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.809349] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.809753] pci 0000:00:1e.0: setting latency timer to 64
[    0.810109] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.810465] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.810822] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.811208] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.811590] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.811985] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.812367] pci_bus 0000:02: resource 1 [mem 0xe0200000-0xe02fffff]
[    0.812750] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.813289] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    0.813644] pci_bus 0000:06: resource 1 [mem 0xe0100000-0xe01fffff]
[    0.814040] pci_bus 0000:07: resource 1 [mem 0xe0000000-0xe00fffff]
[    0.814422] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.814777] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.815138] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.815520] pci_bus 0000:07: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.815916] pci_bus 0000:07: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.816297] pci_bus 0000:07: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.816679] pci_bus 0000:3f: resource 0 [io  0x0000-0xffff]
[    0.817048] pci_bus 0000:3f: resource 1 [mem 0x00000000-0xfffffffff]
[    0.817491] NET: Registered protocol family 2
[    0.818132] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.820553] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.824335] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    0.827960] TCP: Hash tables configured (established 524288 bind 65536)
[    0.828373] TCP reno registered
[    0.828707] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    0.829370] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    0.830141] NET: Registered protocol family 1
[    0.830657] RPC: Registered named UNIX socket transport module.
[    0.831048] RPC: Registered udp transport module.
[    0.831373] RPC: Registered tcp transport module.
[    0.831698] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.832141] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.832534] pci 0000:00:1a.0: Performing full reset
[    0.832890] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.833282] pci 0000:00:1a.1: Performing full reset
[    0.833629] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.834036] pci 0000:00:1a.2: Performing full reset
[    0.834535] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.834953] pci 0000:00:1d.0: Performing full reset
[    0.835307] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.835698] pci 0000:00:1d.1: Performing full reset
[    0.836061] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.836453] pci 0000:00:1d.2: Performing full reset
[    0.836944] pci 0000:02:00.0: Boot video device
[    0.837321] PCI: CLS 64 bytes, default 64
[    0.841496] Machine check injector initialized
[    0.843727] microcode: CPU0 sig=0x106a4, pf=0x2, revision=0x6
[    0.844116] microcode: CPU1 sig=0x106a4, pf=0x2, revision=0x6
[    0.844488] microcode: CPU2 sig=0x106a4, pf=0x2, revision=0x6
[    0.844859] microcode: CPU3 sig=0x106a4, pf=0x2, revision=0x6
[    0.845230] microcode: CPU4 sig=0x106a4, pf=0x2, revision=0x6
[    0.845605] microcode: CPU5 sig=0x106a4, pf=0x2, revision=0x6
[    0.845983] microcode: CPU6 sig=0x106a4, pf=0x2, revision=0x6
[    0.846358] microcode: CPU7 sig=0x106a4, pf=0x2, revision=0x6
[    0.846819] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.847871] audit: initializing netlink socket (disabled)
[    0.848257] type=2000 audit(1320274462.598:1): initialized
[    0.881914] Testing tracer function: PASSED
[    1.018832] Testing dynamic ftrace: PASSED
[    1.256108] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 627) (2 2 4 1 1068) PASSED
[    1.343599] Testing dynamic ftrace ops #2: (1 0 1 1018 0) (1 1 2 1237 0) (2 1 3 3 1490) (2 2 4 260 1746) PASSED
[    1.481937] Testing tracer irqsoff: PASSED
[    1.558939] Testing tracer wakeup: 
[    1.840964] Refined TSC clocksource calibration: 3200.113 MHz.
[    1.841490] Switching to clocksource tsc
[    1.912938] PASSED
[    1.928942] Testing tracer wakeup_rt: PASSED
[    2.299962] Testing tracer function_graph: PASSED
[    2.461022] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.472796] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.474135] fuse init (API version 7.17)
[    2.475033] JFS: nTxBlock = 8192, nTxLock = 65536
[    2.479014] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    2.480161] kworker/u:0 used greatest stack depth: 5184 bytes left
[    2.481546] NILFS version 2 loaded
[    2.482799] Btrfs loaded
[    2.483055] msgmni has been set to 5883
[    2.484319] async_tx: api initialized (async)
[    2.484823] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.485421] io scheduler noop registered
[    2.485718] io scheduler deadline registered
[    2.486165] io scheduler cfq registered (default)
[    2.486970] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.487492] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.488018] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    2.488689] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.489465] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    2.490056] ACPI: Sleep Button [SLPB]
[    2.490479] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.491031] ACPI: Power Button [PWRF]
[    2.492045] ACPI: acpi_idle registered with cpuidle
[    2.492769] Monitor-Mwait will be used to enter C-1 state
[    2.493169] Monitor-Mwait will be used to enter C-3 state
[    2.500458] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.538590] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.564043] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    2.610228] Initializing Nozomi driver 2.1d
[    2.610988] Non-volatile memory driver v1.3
[    2.611755] Linux agpgart interface v0.103
[    2.612141] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    2.612739] Hangcheck: Using getrawmonotonic().
[    2.613117] [drm] Initialized drm 1.1.0 20060810
[    2.613439] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    5.633099] floppy0: no floppy controllers found
[    5.633591] ------------[ cut here ]------------
[    5.633916] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    5.634507] Hardware name:         
[    5.634786] VFS: do_fd_request called on non-open device
[    5.635132] Modules linked in:
[    5.635429] Pid: 1, comm: swapper Not tainted 3.1.0-ioless-full-next-20111025+ #890
[    5.635978] Call Trace:
[    5.636221]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    5.636594]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    5.636958]  [<ffffffff813eb75a>] ? blk_throtl_drain+0xf6/0x105
[    5.637328]  [<ffffffff8198467e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    5.637708]  [<ffffffff8151b18d>] do_fd_request+0x37/0xaa
[    5.638060]  [<ffffffff813d8e66>] __blk_run_queue+0x1e/0x20
[    5.638417]  [<ffffffff813de36e>] blk_drain_queue+0x41/0x7a
[    5.638774]  [<ffffffff813de4cc>] blk_cleanup_queue+0x125/0x184
[    5.639144]  [<ffffffff821434b3>] floppy_init+0xd9c/0xdc2
[    5.639495]  [<ffffffff82142717>] ? daring+0x65/0x65
[    5.639832]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    5.640193]  [<ffffffff82113c16>] kernel_init+0xcb/0x14f
[    5.640542]  [<ffffffff8198d4c4>] kernel_thread_helper+0x4/0x10
[    5.640913]  [<ffffffff819848f4>] ? retint_restore_args+0x13/0x13
[    5.641289]  [<ffffffff82113b4b>] ? start_kernel+0x390/0x390
[    5.641649]  [<ffffffff8198d4c0>] ? gs_change+0x13/0x13
[    5.641997] ---[ end trace 586f36ee88a74fcf ]---
[    5.642411] ------------[ cut here ]------------
[    5.642734] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    5.643324] Hardware name:         
[    5.643604] VFS: do_fd_request called on non-open device
[    5.643951] Modules linked in:
[    5.644249] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #890
[    5.644832] Call Trace:
[    5.645074]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    5.645448]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    5.645813]  [<ffffffff813eb75a>] ? blk_throtl_drain+0xf6/0x105
[    5.646183]  [<ffffffff8198467e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    5.646562]  [<ffffffff8151b18d>] do_fd_request+0x37/0xaa
[    5.646914]  [<ffffffff813d8e66>] __blk_run_queue+0x1e/0x20
[    5.647271]  [<ffffffff813de36e>] blk_drain_queue+0x41/0x7a
[    5.647629]  [<ffffffff813de4cc>] blk_cleanup_queue+0x125/0x184
[    5.648000]  [<ffffffff821434b3>] floppy_init+0xd9c/0xdc2
[    5.651326]  [<ffffffff82142717>] ? daring+0x65/0x65
[    5.651661]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    5.652020]  [<ffffffff82113c16>] kernel_init+0xcb/0x14f
[    5.652367]  [<ffffffff8198d4c4>] kernel_thread_helper+0x4/0x10
[    5.652737]  [<ffffffff819848f4>] ? retint_restore_args+0x13/0x13
[    5.653114]  [<ffffffff82113b4b>] ? start_kernel+0x390/0x390
[    5.653475]  [<ffffffff8198d4c0>] ? gs_change+0x13/0x13
[    5.653818] ---[ end trace 586f36ee88a74fd0 ]---
[    5.654185] ------------[ cut here ]------------
[    5.654507] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    5.655095] Hardware name:         
[    5.655374] VFS: do_fd_request called on non-open device
[    5.655720] Modules linked in:
[    5.656017] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #890
[    5.656598] Call Trace:
[    5.656841]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    5.657213]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    5.657577]  [<ffffffff813eb75a>] ? blk_throtl_drain+0xf6/0x105
[    5.657946]  [<ffffffff8198467e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    5.658325]  [<ffffffff8151b18d>] do_fd_request+0x37/0xaa
[    5.658676]  [<ffffffff813d8e66>] __blk_run_queue+0x1e/0x20
[    5.659033]  [<ffffffff813de36e>] blk_drain_queue+0x41/0x7a
[    5.659390]  [<ffffffff813de4cc>] blk_cleanup_queue+0x125/0x184
[    5.659760]  [<ffffffff821434b3>] floppy_init+0xd9c/0xdc2
[    5.660110]  [<ffffffff82142717>] ? daring+0x65/0x65
[    5.660445]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    5.660805]  [<ffffffff82113c16>] kernel_init+0xcb/0x14f
[    5.661152]  [<ffffffff8198d4c4>] kernel_thread_helper+0x4/0x10
[    5.661521]  [<ffffffff819848f4>] ? retint_restore_args+0x13/0x13
[    5.661897]  [<ffffffff82113b4b>] ? start_kernel+0x390/0x390
[    5.662257]  [<ffffffff8198d4c0>] ? gs_change+0x13/0x13
[    5.662600] ---[ end trace 586f36ee88a74fd1 ]---
[    5.662966] ------------[ cut here ]------------
[    5.663288] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    5.663875] Hardware name:         
[    5.664154] VFS: do_fd_request called on non-open device
[    5.664500] Modules linked in:
[    5.664797] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #890
[    5.665378] Call Trace:
[    5.665619]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    5.665992]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    5.666356]  [<ffffffff813eb75a>] ? blk_throtl_drain+0xf6/0x105
[    5.666725]  [<ffffffff8198467e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    5.667104]  [<ffffffff8151b18d>] do_fd_request+0x37/0xaa
[    5.667454]  [<ffffffff813d8e66>] __blk_run_queue+0x1e/0x20
[    5.667812]  [<ffffffff813de36e>] blk_drain_queue+0x41/0x7a
[    5.668169]  [<ffffffff813de4cc>] blk_cleanup_queue+0x125/0x184
[    5.668538]  [<ffffffff821434b3>] floppy_init+0xd9c/0xdc2
[    5.668889]  [<ffffffff82142717>] ? daring+0x65/0x65
[    5.669224]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    5.669585]  [<ffffffff82113c16>] kernel_init+0xcb/0x14f
[    5.669932]  [<ffffffff8198d4c4>] kernel_thread_helper+0x4/0x10
[    5.670303]  [<ffffffff819848f4>] ? retint_restore_args+0x13/0x13
[    5.670680]  [<ffffffff82113b4b>] ? start_kernel+0x390/0x390
[    5.671041]  [<ffffffff8198d4c0>] ? gs_change+0x13/0x13
[    5.671385] ---[ end trace 586f36ee88a74fd2 ]---
[    5.671752] ------------[ cut here ]------------
[    5.672075] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    5.672664] Hardware name:         
[    5.672944] VFS: do_fd_request called on non-open device
[    5.673292] Modules linked in:
[    5.673589] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #890
[    5.674172] Call Trace:
[    5.674415]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    5.674788]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    5.675152]  [<ffffffff813eb75a>] ? blk_throtl_drain+0xf6/0x105
[    5.675522]  [<ffffffff8198467e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    5.675902]  [<ffffffff8151b18d>] do_fd_request+0x37/0xaa
[    5.676252]  [<ffffffff813d8e66>] __blk_run_queue+0x1e/0x20
[    5.676610]  [<ffffffff813de36e>] blk_drain_queue+0x41/0x7a
[    5.676967]  [<ffffffff813de4cc>] blk_cleanup_queue+0x125/0x184
[    5.677338]  [<ffffffff821434b3>] floppy_init+0xd9c/0xdc2
[    5.677688]  [<ffffffff82142717>] ? daring+0x65/0x65
[    5.678023]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    5.678383]  [<ffffffff82113c16>] kernel_init+0xcb/0x14f
[    5.678730]  [<ffffffff8198d4c4>] kernel_thread_helper+0x4/0x10
[    5.679100]  [<ffffffff819848f4>] ? retint_restore_args+0x13/0x13
[    5.679476]  [<ffffffff82113b4b>] ? start_kernel+0x390/0x390
[    5.679836]  [<ffffffff8198d4c0>] ? gs_change+0x13/0x13
[    5.680179] ---[ end trace 586f36ee88a74fd3 ]---
[    5.680545] ------------[ cut here ]------------
[    5.680867] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    5.681455] Hardware name:         
[    5.681734] VFS: do_fd_request called on non-open device
[    5.682080] Modules linked in:
[    5.682377] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #890
[    5.682959] Call Trace:
[    5.683201]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    5.683574]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    5.683937]  [<ffffffff813eb75a>] ? blk_throtl_drain+0xf6/0x105
[    5.684306]  [<ffffffff8198467e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    5.684686]  [<ffffffff8151b18d>] do_fd_request+0x37/0xaa
[    5.685036]  [<ffffffff813d8e66>] __blk_run_queue+0x1e/0x20
[    5.685393]  [<ffffffff813de36e>] blk_drain_queue+0x41/0x7a
[    5.685750]  [<ffffffff813de4cc>] blk_cleanup_queue+0x125/0x184
[    5.686120]  [<ffffffff821434b3>] floppy_init+0xd9c/0xdc2
[    5.686471]  [<ffffffff82142717>] ? daring+0x65/0x65
[    5.686807]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    5.687168]  [<ffffffff82113c16>] kernel_init+0xcb/0x14f
[    5.687517]  [<ffffffff8198d4c4>] kernel_thread_helper+0x4/0x10
[    5.687888]  [<ffffffff819848f4>] ? retint_restore_args+0x13/0x13
[    5.688264]  [<ffffffff82113b4b>] ? start_kernel+0x390/0x390
[    5.688625]  [<ffffffff8198d4c0>] ? gs_change+0x13/0x13
[    5.688969] ---[ end trace 586f36ee88a74fd4 ]---
[    5.689337] ------------[ cut here ]------------
[    5.689660] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    5.690250] Hardware name:         
[    5.690530] VFS: do_fd_request called on non-open device
[    5.690876] Modules linked in:
[    5.691174] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #890
[    5.691758] Call Trace:
[    5.692000]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    5.692374]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    5.692737]  [<ffffffff813eb75a>] ? blk_throtl_drain+0xf6/0x105
[    5.693106]  [<ffffffff8198467e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    5.693485]  [<ffffffff8151b18d>] do_fd_request+0x37/0xaa
[    5.693835]  [<ffffffff813d8e66>] __blk_run_queue+0x1e/0x20
[    5.694192]  [<ffffffff813de36e>] blk_drain_queue+0x41/0x7a
[    5.694551]  [<ffffffff813de4cc>] blk_cleanup_queue+0x125/0x184
[    5.694920]  [<ffffffff821434b3>] floppy_init+0xd9c/0xdc2
[    5.695271]  [<ffffffff82142717>] ? daring+0x65/0x65
[    5.695605]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    5.695966]  [<ffffffff82113c16>] kernel_init+0xcb/0x14f
[    5.696313]  [<ffffffff8198d4c4>] kernel_thread_helper+0x4/0x10
[    5.696683]  [<ffffffff819848f4>] ? retint_restore_args+0x13/0x13
[    5.697059]  [<ffffffff82113b4b>] ? start_kernel+0x390/0x390
[    5.697418]  [<ffffffff8198d4c0>] ? gs_change+0x13/0x13
[    5.697761] ---[ end trace 586f36ee88a74fd5 ]---
[    5.698130] ------------[ cut here ]------------
[    5.698453] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    5.699041] Hardware name:         
[    5.699320] VFS: do_fd_request called on non-open device
[    5.699666] Modules linked in:
[    5.699963] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #890
[    5.700544] Call Trace:
[    5.700785]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    5.701158]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    5.701521]  [<ffffffff813eb75a>] ? blk_throtl_drain+0xf6/0x105
[    5.701890]  [<ffffffff8198467e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    5.702269]  [<ffffffff8151b18d>] do_fd_request+0x37/0xaa
[    5.702620]  [<ffffffff813d8e66>] __blk_run_queue+0x1e/0x20
[    5.702977]  [<ffffffff813de36e>] blk_drain_queue+0x41/0x7a
[    5.703334]  [<ffffffff813de4cc>] blk_cleanup_queue+0x125/0x184
[    5.703705]  [<ffffffff821434b3>] floppy_init+0xd9c/0xdc2
[    5.704055]  [<ffffffff82142717>] ? daring+0x65/0x65
[    5.704391]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    5.704752]  [<ffffffff82113c16>] kernel_init+0xcb/0x14f
[    5.705100]  [<ffffffff8198d4c4>] kernel_thread_helper+0x4/0x10
[    5.705470]  [<ffffffff819848f4>] ? retint_restore_args+0x13/0x13
[    5.705847]  [<ffffffff82113b4b>] ? start_kernel+0x390/0x390
[    5.706208]  [<ffffffff8198d4c0>] ? gs_change+0x13/0x13
[    5.706552] ---[ end trace 586f36ee88a74fd6 ]---
[    5.710235] brd: module loaded
[    5.712277] loop: module loaded
[    5.713058] Loading iSCSI transport class v2.0-870.
[    5.714075] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    5.714432] Detecting Adaptec I2O RAID controllers...
[    5.714964] Adaptec aacraid driver 1.1-7[28000]-ms
[    5.715884] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    5.716480] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.07-k.
[    5.717219] iscsi: registered transport (qla4xxx)
[    5.717623] QLogic iSCSI HBA Driver
[    5.717986] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    5.718607] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    5.719103] megasas: 00.00.06.12-rc1 Wed. Oct. 5 17:00:00 PDT 2011
[    5.719572] mpt2sas version 09.100.00.01 loaded
[    5.723272] ahci 0000:00:1f.2: version 3.0
[    5.723603] IOAPIC[0]: Set routing entry (8-19 -> 0x61 -> IRQ 19 Mode:1 Active:1 Dest:0)
[    5.724179] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    5.724628] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    5.725043] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    5.725614] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    5.726180] ahci 0000:00:1f.2: setting latency timer to 64
[    5.737428] scsi0 : ahci
[    5.737874] scsi1 : ahci
[    5.738298] scsi2 : ahci
[    5.738712] scsi3 : ahci
[    5.739130] scsi4 : ahci
[    5.739544] scsi5 : ahci
[    5.740224] ata1: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320100 irq 43
[    5.740766] ata2: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320180 irq 43
[    5.741311] ata3: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320200 irq 43
[    5.741852] ata4: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320280 irq 43
[    5.742397] ata5: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320300 irq 43
[    5.742938] ata6: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320380 irq 43
[    5.743513] ahci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.743935] ahci 0000:06:00.0: Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.
[    5.744602] ahci 0000:06:00.0: controller can't do NCQ, turning off CAP_NCQ
[    5.745009] ahci 0000:06:00.0: controller can't do PMP, turning off CAP_PMP
[    5.745424] ahci 0000:06:00.0: masking port_map 0x7 -> 0x3
[    5.745793] ahci: SSS flag set, parallel bus scan disabled
[    5.746189] ahci 0000:06:00.0: AHCI 0001.0000 32 slots 3 ports 3 Gbps 0x3 impl IDE mode
[    5.746753] ahci 0000:06:00.0: flags: 64bit stag led slum part 
[    5.747982] scsi6 : ahci
[    5.748410] scsi7 : ahci
[    5.748828] scsi8 : ahci
[    5.749218] ata7: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100100 irq 16
[    5.749761] ata8: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100180 irq 16
[    5.750304] ata9: DUMMY
[    5.753725] tun: Universal TUN/TAP device driver, 1.6
[    5.754068] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.754693] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    5.755048] Copyright (c) 2007 Atheros Corporation.
[    5.755736] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.7 (July 20, 2011)
[    5.756433] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    5.756810] e100: Copyright(c) 1999-2006 Intel Corporation
[    5.757259] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    5.757672] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    5.758134] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    5.758501] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    5.758899] IOAPIC[0]: Set routing entry (8-20 -> 0x71 -> IRQ 20 Mode:1 Active:1 Dest:0)
[    5.759475] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.759889] e1000e 0000:00:19.0: setting latency timer to 64
[    5.760362] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.949630] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:c0:79:88:54
[    5.950198] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.950637] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
[    5.951130] Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[    5.951526] Copyright (c) 2007-2011 Intel Corporation.
[    5.951958] Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[    5.952504] Copyright (c) 2009 - 2011 Intel Corporation.
[    5.952945] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.6.7-k
[    5.953501] ixgbe: Copyright (c) 1999-2011 Intel Corporation.
[    5.953954] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    5.954372] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    5.954904] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    5.955447] sky2: driver version 1.29
[    5.956232] usbcore: registered new interface driver catc
[    5.956583] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[    5.957011] usbcore: registered new interface driver kaweth
[    5.957372] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    5.957974] usbcore: registered new interface driver pegasus
[    5.958340] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[    5.958806] usbcore: registered new interface driver rtl8150
[    5.959244] usbcore: registered new interface driver asix
[    5.959653] usbcore: registered new interface driver cdc_ether
[    5.960079] usbcore: registered new interface driver cdc_eem
[    5.960497] usbcore: registered new interface driver dm9601
[    5.960919] usbcore: registered new interface driver smsc75xx
[    5.961359] usbcore: registered new interface driver smsc95xx
[    5.961785] usbcore: registered new interface driver gl620a
[    5.962210] usbcore: registered new interface driver net1080
[    5.962628] usbcore: registered new interface driver plusb
[    5.963040] usbcore: registered new interface driver rndis_host
[    5.963477] usbcore: registered new interface driver cdc_subset
[    5.963902] usbcore: registered new interface driver zaurus
[    5.964326] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    5.964931] usbcore: registered new interface driver int51x1
[    5.965296] cdc_ncm: 04-Aug-2011
[    5.965625] usbcore: registered new interface driver cdc_ncm
[    5.965986] Fusion MPT base driver 3.04.20
[    5.966293] Copyright (c) 1999-2008 LSI Corporation
[    5.966632] Fusion MPT SPI Host driver 3.04.20
[    5.967045] Fusion MPT FC Host driver 3.04.20
[    5.967456] Fusion MPT SAS Host driver 3.04.20
[    5.967863] Fusion MPT misc device (ioctl) driver 3.04.20
[    5.968309] mptctl: Registered with Fusion MPT base driver
[    5.968664] mptctl: /dev/mptctl @ (major,minor=10,220)
[    5.969117] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.969510] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    5.969920] IOAPIC[0]: Set routing entry (8-18 -> 0x81 -> IRQ 18 Mode:1 Active:1 Dest:0)
[    5.970496] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.970922] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    5.971294] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.971700] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file 'devices'
[    5.972257] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.972677] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    5.973228] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    5.973831] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    5.974486] ehci_hcd 0000:00:1a.7: debug port 1
[    5.974807] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.979285] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    5.979686] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    5.980076] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0322000
[    5.980437] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.984927] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    5.991098] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    5.991530] usb usb1: default language 0x0409
[    5.991851] usb usb1: udev 1, busnum 1, minor = 0
[    5.992181] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.992582] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.993119] usb usb1: Product: EHCI Host Controller
[    5.993449] usb usb1: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ ehci_hcd
[    5.993999] usb usb1: SerialNumber: 0000:00:1a.7
[    5.994483] usb usb1: usb_probe_device
[    5.994773] usb usb1: configuration #1 chosen from 1 choice
[    5.995161] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    5.995617] hub 1-0:1.0: usb_probe_interface
[    5.995926] hub 1-0:1.0: usb_probe_interface - got id
[    5.996269] hub 1-0:1.0: USB hub found
[    5.996563] hub 1-0:1.0: 6 ports detected
[    5.996863] hub 1-0:1.0: standalone hub
[    5.997159] hub 1-0:1.0: no power switching (usb 1.0)
[    5.997497] hub 1-0:1.0: individual port over-current protection
[    5.997869] hub 1-0:1.0: power on to power good time: 20ms
[    5.998242] hub 1-0:1.0: local power source is good
[    5.998574] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    5.999036] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.999575] IOAPIC[0]: Set routing entry (8-23 -> 0x89 -> IRQ 23 Mode:1 Active:1 Dest:0)
[    6.000153] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.000579] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.000947] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.001301] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    6.001715] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    6.002265] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    6.002866] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    6.003508] ehci_hcd 0000:00:1d.7: debug port 1
[    6.003829] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.008309] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    6.008711] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    6.009097] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0321000
[    6.012443] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    6.016912] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    6.023098] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.023516] usb usb2: default language 0x0409
[    6.023835] usb usb2: udev 1, busnum 2, minor = 128
[    6.024172] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.024574] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.025113] usb usb2: Product: EHCI Host Controller
[    6.025444] usb usb2: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ ehci_hcd
[    6.025993] usb usb2: SerialNumber: 0000:00:1d.7
[    6.026463] usb usb2: usb_probe_device
[    6.026753] usb usb2: configuration #1 chosen from 1 choice
[    6.027123] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    6.027564] hub 2-0:1.0: usb_probe_interface
[    6.027872] hub 2-0:1.0: usb_probe_interface - got id
[    6.028214] hub 2-0:1.0: USB hub found
[    6.028513] hub 2-0:1.0: 6 ports detected
[    6.028811] hub 2-0:1.0: standalone hub
[    6.029108] hub 2-0:1.0: no power switching (usb 1.0)
[    6.029445] hub 2-0:1.0: individual port over-current protection
[    6.029817] hub 2-0:1.0: power on to power good time: 20ms
[    6.030181] hub 2-0:1.0: local power source is good
[    6.030512] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    6.030962] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    6.031540] uhci_hcd: USB Universal Host Controller Interface driver
[    6.031960] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.032385] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.032753] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.033105] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '003'
[    6.033517] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    6.034062] uhci_hcd 0000:00:1a.0: detected 2 ports
[    6.034399] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    6.034797] uhci_hcd 0000:00:1a.0: Performing full reset
[    6.035159] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    6.035525] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020e0
[    6.035937] usb usb3: default language 0x0409
[    6.036267] usb usb3: udev 1, busnum 3, minor = 256
[    6.036598] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.036999] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.037538] usb usb3: Product: UHCI Host Controller
[    6.037869] usb usb3: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    6.038423] usb usb3: SerialNumber: 0000:00:1a.0
[    6.038894] usb usb3: usb_probe_device
[    6.039191] usb usb3: configuration #1 chosen from 1 choice
[    6.039555] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    6.039995] hub 3-0:1.0: usb_probe_interface
[    6.040310] hub 3-0:1.0: usb_probe_interface - got id
[    6.040649] hub 3-0:1.0: USB hub found
[    6.040943] hub 3-0:1.0: 2 ports detected
[    6.041246] hub 3-0:1.0: standalone hub
[    6.041540] hub 3-0:1.0: no power switching (usb 1.0)
[    6.041877] hub 3-0:1.0: individual port over-current protection
[    6.042256] hub 3-0:1.0: power on to power good time: 2ms
[    6.042613] hub 3-0:1.0: local power source is good
[    6.042944] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    6.043376] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    6.043838] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    6.044276] IOAPIC[0]: Set routing entry (8-21 -> 0x91 -> IRQ 21 Mode:1 Active:1 Dest:0)
[    6.044847] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.045270] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.045638] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.045987] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[    6.046403] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.046951] uhci_hcd 0000:00:1a.1: detected 2 ports
[    6.047289] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    6.047687] uhci_hcd 0000:00:1a.1: Performing full reset
[    6.048046] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    6.048087] ata6: SATA link down (SStatus 0 SControl 300)
[    6.048112] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.048136] ata4: SATA link down (SStatus 0 SControl 300)
[    6.048159] ata3: SATA link down (SStatus 0 SControl 300)
[    6.048183] ata5: SATA link down (SStatus 0 SControl 300)
[    6.050204] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020c0
[    6.050606] usb usb4: default language 0x0409
[    6.050926] usb usb4: udev 1, busnum 4, minor = 384
[    6.051260] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.051661] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.052198] usb usb4: Product: UHCI Host Controller
[    6.052529] usb usb4: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    6.053082] usb usb4: SerialNumber: 0000:00:1a.1
[    6.053550] usb usb4: usb_probe_device
[    6.053840] usb usb4: configuration #1 chosen from 1 choice
[    6.054210] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    6.054650] hub 4-0:1.0: usb_probe_interface
[    6.054958] hub 4-0:1.0: usb_probe_interface - got id
[    6.055102] ata7: SATA link down (SStatus 0 SControl 300)
[    6.055653] hub 4-0:1.0: USB hub found
[    6.055946] hub 4-0:1.0: 2 ports detected
[    6.056248] hub 4-0:1.0: standalone hub
[    6.056539] hub 4-0:1.0: no power switching (usb 1.0)
[    6.056876] hub 4-0:1.0: individual port over-current protection
[    6.057251] hub 4-0:1.0: power on to power good time: 2ms
[    6.057607] hub 4-0:1.0: local power source is good
[    6.057939] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    6.058370] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    6.058834] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    6.059266] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    6.059686] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    6.060053] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    6.060406] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '005'
[    6.060819] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    6.061369] uhci_hcd 0000:00:1a.2: detected 2 ports
[    6.061703] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    6.062104] uhci_hcd 0000:00:1a.2: Performing full reset
[    6.062464] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    6.062850] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000020a0
[    6.063255] usb usb5: default language 0x0409
[    6.063576] usb usb5: udev 1, busnum 5, minor = 512
[    6.063906] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.064311] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.064845] usb usb5: Product: UHCI Host Controller
[    6.065178] usb usb5: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    6.065730] usb usb5: SerialNumber: 0000:00:1a.2
[    6.066200] usb usb5: usb_probe_device
[    6.066491] usb usb5: configuration #1 chosen from 1 choice
[    6.066853] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    6.067298] hub 5-0:1.0: usb_probe_interface
[    6.067607] hub 5-0:1.0: usb_probe_interface - got id
[    6.067943] hub 5-0:1.0: USB hub found
[    6.068241] hub 5-0:1.0: 2 ports detected
[    6.068539] hub 5-0:1.0: standalone hub
[    6.068830] hub 5-0:1.0: no power switching (usb 1.0)
[    6.069170] hub 5-0:1.0: individual port over-current protection
[    6.069542] hub 5-0:1.0: power on to power good time: 2ms
[    6.069897] hub 5-0:1.0: local power source is good
[    6.070231] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    6.070662] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    6.071125] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    6.071555] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.071974] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.072346] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.072694] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '006'
[    6.073109] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    6.073656] uhci_hcd 0000:00:1d.0: detected 2 ports
[    6.073990] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    6.074390] uhci_hcd 0000:00:1d.0: Performing full reset
[    6.074749] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    6.075119] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
[    6.075518] usb usb6: default language 0x0409
[    6.075838] usb usb6: udev 1, busnum 6, minor = 640
[    6.076174] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    6.076575] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.077114] usb usb6: Product: UHCI Host Controller
[    6.077446] usb usb6: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    6.077996] usb usb6: SerialNumber: 0000:00:1d.0
[    6.078462] usb usb6: usb_probe_device
[    6.078752] usb usb6: configuration #1 chosen from 1 choice
[    6.079120] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    6.079560] hub 6-0:1.0: usb_probe_interface
[    6.079869] hub 6-0:1.0: usb_probe_interface - got id
[    6.080212] hub 6-0:1.0: USB hub found
[    6.080509] hub 6-0:1.0: 2 ports detected
[    6.080808] hub 6-0:1.0: standalone hub
[    6.081104] hub 6-0:1.0: no power switching (usb 1.0)
[    6.081441] hub 6-0:1.0: individual port over-current protection
[    6.081815] hub 6-0:1.0: power on to power good time: 2ms
[    6.082173] hub 6-0:1.0: local power source is good
[    6.082504] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    6.082932] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    6.083405] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    6.083825] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.084246] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.084613] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.087940] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '007'
[    6.088283] ata1.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[    6.088285] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.089110] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    6.089654] uhci_hcd 0000:00:1d.1: detected 2 ports
[    6.089988] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    6.090388] uhci_hcd 0000:00:1d.1: Performing full reset
[    6.090746] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    6.091116] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
[    6.091516] usb usb7: default language 0x0409
[    6.091835] usb usb7: udev 1, busnum 7, minor = 768
[    6.092170] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    6.092570] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.093106] usb usb7: Product: UHCI Host Controller
[    6.093436] usb usb7: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    6.093986] usb usb7: SerialNumber: 0000:00:1d.1
[    6.094467] usb usb7: usb_probe_device
[    6.094757] usb usb7: configuration #1 chosen from 1 choice
[    6.095125] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    6.095570] hub 7-0:1.0: usb_probe_interface
[    6.095880] hub 7-0:1.0: usb_probe_interface - got id
[    6.096221] hub 7-0:1.0: USB hub found
[    6.096515] hub 7-0:1.0: 2 ports detected
[    6.096813] hub 7-0:1.0: standalone hub
[    6.097107] hub 7-0:1.0: no power switching (usb 1.0)
[    6.097445] hub 7-0:1.0: individual port over-current protection
[    6.097816] hub 7-0:1.0: power on to power good time: 2ms
[    6.098198] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    6.098793] hub 1-0:1.0: port 1: status 0501 change 0001
[    6.099153] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 001403 0  ACK POWER sig=k CSC CONNECT
[    6.099745] hub 1-0:1.0: port 2: status 0501 change 0001
[    6.100107] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC CONNECT
[    6.100701] hub 1-0:1.0: port 4: status 0501 change 0001
[    6.101068] hub 7-0:1.0: local power source is good
[    6.101401] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    6.101830] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    6.102301] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    6.102720] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.103143] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.103510] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.103862] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '008'
[    6.104277] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    6.104821] uhci_hcd 0000:00:1d.2: detected 2 ports
[    6.105157] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    6.105554] uhci_hcd 0000:00:1d.2: Performing full reset
[    6.105913] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    6.106283] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    6.106682] usb usb8: default language 0x0409
[    6.107002] usb usb8: udev 1, busnum 8, minor = 896
[    6.107337] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    6.107737] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.108274] usb usb8: Product: UHCI Host Controller
[    6.108605] usb usb8: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    6.109160] usb usb8: SerialNumber: 0000:00:1d.2
[    6.109624] usb usb8: usb_probe_device
[    6.109915] usb usb8: configuration #1 chosen from 1 choice
[    6.110286] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    6.110727] hub 8-0:1.0: usb_probe_interface
[    6.111037] hub 8-0:1.0: usb_probe_interface - got id
[    6.111379] hub 8-0:1.0: USB hub found
[    6.111673] hub 8-0:1.0: 2 ports detected
[    6.111972] hub 8-0:1.0: standalone hub
[    6.112268] hub 8-0:1.0: no power switching (usb 1.0)
[    6.112605] hub 8-0:1.0: individual port over-current protection
[    6.112979] hub 8-0:1.0: power on to power good time: 2ms
[    6.113337] hub 8-0:1.0: local power source is good
[    6.113669] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    6.114101] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    6.114570] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    6.115059] Initializing USB Mass Storage driver...
[    6.115485] usbcore: registered new interface driver usb-storage
[    6.115857] USB Mass Storage support registered.
[    6.116285] usbcore: registered new interface driver libusual
[    6.116715] usbcore: registered new interface driver ums-alauda
[    6.117155] usbcore: registered new interface driver ums-cypress
[    6.117598] usbcore: registered new interface driver ums-datafab
[    6.118035] usbcore: registered new interface driver ums-freecom
[    6.118479] usbcore: registered new interface driver ums-isd200
[    6.118914] usbcore: registered new interface driver ums-jumpshot
[    6.119361] usbcore: registered new interface driver ums-karma
[    6.119792] usbcore: registered new interface driver ums-onetouch
[    6.120240] usbcore: registered new interface driver ums-sddr09
[    6.120679] usbcore: registered new interface driver ums-sddr55
[    6.121117] usbcore: registered new interface driver ums-usbat
[    6.121618] usbcore: registered new interface driver usbserial
[    6.122048] USB Serial support registered for generic
[    6.122464] usbcore: registered new interface driver usbserial_generic
[    6.122856] usbserial: USB Serial Driver core
[    6.123228] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    6.123874] usbcore: registered new interface driver belkin
[    6.124234] belkin_sa: v1.3:USB Belkin Serial converter driver
[    6.124655] USB Serial support registered for MCT U232
[    6.125066] usbcore: registered new interface driver mct_u232
[    6.125434] mct_u232: z2.1:Magic Control Technology USB-RS232 converter driver
[    6.126209] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    6.129768] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.130114] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    6.130126] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.130485] mousedev: PS/2 mouse device common for all mice
[    6.131133] rtc_cmos 00:02: RTC can wake from S4
[    6.131343] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    6.131384] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    6.131442] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    6.131631] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[    6.131759] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.131764] iTCO_vendor_support: vendor-support=0
[    6.131767] SoftDog: cannot register miscdev on minor=130 (err=-16)
[    6.131775] md: linear personality registered for level -1
[    6.131777] md: raid0 personality registered for level 0
[    6.131778] md: raid1 personality registered for level 1
[    6.131780] md: raid10 personality registered for level 10
[    6.131781] md: raid6 personality registered for level 6
[    6.131783] md: raid5 personality registered for level 5
[    6.131784] md: raid4 personality registered for level 4
[    6.131786] md: multipath personality registered for level -4
[    6.131787] md: faulty personality registered for level -5
[    6.132190] device-mapper: uevent: version 1.0.3
[    6.132431] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    6.132532] device-mapper: multipath: version 1.3.0 loaded
[    6.132541] device-mapper: multipath round-robin: version 1.0.0 loaded
[    6.132543] device-mapper: multipath queue-length: version 0.1.0 loaded
[    6.132544] device-mapper: multipath service-time: version 0.2.0 loaded
[    6.132714] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    6.134127] cpuidle: using governor ladder
[    6.143090] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[    6.143139] cpuidle: using governor menu
[    6.143407] usbcore: registered new interface driver usbhid
[    6.143409] usbhid: USB HID core driver
[    6.143831] dell_wmi: No known WMI GUID found
[    6.143832] acer_wmi: Acer Laptop ACPI-WMI Extras
[    6.143837] acer_wmi: No or unsupported WMI interface, unable to load
[    6.144325] IOAPIC[0]: Set routing entry (8-22 -> 0x99 -> IRQ 22 Mode:1 Active:1 Dest:0)
[    6.144330] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    6.144394] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    6.144433] ALSA hda_intel.c:2733 chipset global capabilities = 0x4401
[    6.144447] ALSA hda_intel.c:1163 Clearing TCSEL
[    6.146592] ata1.00: configured for UDMA/133
[    6.146791] scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    6.147229] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    6.147369] sd 0:0:0:0: [sda] Write Protect is off
[    6.147371] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.147424] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.150409] uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
[    6.152198] ALSA hda_intel.c:1009 codec_mask = 0x4
[    6.152689] ALSA hda_intel.c:1472 codec #2 probed OK
[    6.158176] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    6.158275] ALSA hda_codec.c:3994 hda_codec: model 'intel-x58' is selected for config 8086:22 (DX58SO)
[    6.158277] hda_codec: ALC889: SKU not ready 0x411111f0
[    6.158559] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input2
[    6.161588] ALSA hda_codec.c:2378 Cannot find slave Side Playback Volume, skipped
[    6.162215] ALSA hda_codec.c:2378 Cannot find slave Headphone Playback Volume, skipped
[    6.162780] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Volume, skipped
[    6.163401] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Volume, skipped
[    6.163959] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Volume, skipped
[    6.164585] ALSA hda_codec.c:2378 Cannot find slave Side Playback Switch, skipped
[    6.168184] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Switch, skipped
[    6.168730] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Switch, skipped
[    6.169361] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Switch, skipped
[    6.170123] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.170794] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input3
[    6.171959] ALSA device list:
[    6.172257]   #0: HDA Intel at 0xf7f00000 irq 45
[    6.172579] oprofile: using NMI interrupt.
[    6.172917] netem: version 1.3
[    6.173220] Netfilter messages via NETLINK v0.30.
[    6.173578] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    6.174722] ctnetlink v0.93: registering with nfnetlink.
[    6.175146] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    6.175553] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    6.176314] xt_time: kernel timezone is -0000
[    6.178069] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.178519] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    6.178923] arp_tables: (C) 2002 David S. Miller
[    6.179312] TCP bic registered
[    6.179575] TCP cubic registered
[    6.179845] TCP westwood registered
[    6.180163] TCP highspeed registered
[    6.180447] TCP hybla registered
[    6.180716] TCP htcp registered
[    6.180982] TCP vegas registered
[    6.181287] TCP veno registered
[    6.181555] TCP scalable registered
[    6.181835] TCP lp registered
[    6.182133] TCP yeah registered
[    6.182139] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.182753] TCP illinois registered
[    6.183032] Initializing XFRM netlink socket
[    6.183896] NET: Registered protocol family 10
[    6.187487] IPv6 over IPv4 tunneling driver
[    6.189577] NET: Registered protocol family 17
[    6.189902] NET: Registered protocol family 15
[    6.190427] Bridge firewalling registered
[    6.190736] Ebtables v2.0 registered
[    6.191208] Registering the dns_resolver key type
[    6.191593] 
[    6.191593] printing PIC contents
[    6.192072] ... PIC  IMR: ffff
[    6.192337] ... PIC  IRR: 0c21
[    6.192698] ... PIC  ISR: 0000
[    6.192964] ... PIC ELCR: 0c20
[    6.193329] printing local APIC contents on CPU#0/0:
[    6.193663] ... APIC ID:      00000000 (0)
[    6.193964] ... APIC VERSION: 00060015
[    6.194253] ... APIC TASKPRI: 00000000 (00)
[    6.194558] ... APIC PROCPRI: 00000000
[    6.194847] ... APIC LDR: 01000000
[    6.195123] ... APIC DFR: ffffffff
[    6.195399] ... APIC SPIV: 000001ff
[    6.195677] ... APIC ISR field:
[    6.195944] 0000000000000000000000000000000000000000000000000000000000000000
[    6.196621] ... APIC TMR field:
[    6.196887] 0000000000000000000000000000000000000002000000000000000000000000
[    6.197565] ... APIC IRR field:
[    6.197832] 0000000000010000000000000000020000000000000000000000000000008000
[    6.198511] ... APIC ESR: 00000000
[    6.198787] ... APIC ICR: 000000ef
[    6.199063] ... APIC ICR2: 05000000
[    6.199342] ... APIC LVTT: 000000ef
[    6.199621] ... APIC LVTPC: 00000400
[    6.199904] ... APIC LVT0: 00010700
[    6.200183] ... APIC LVT1: 00000400
[    6.200462] ... APIC LVTERR: 000000fe
[    6.200747] ... APIC TMICT: 00001b64
[    6.201030] ... APIC TMCCT: 00000000
[    6.201313] ... APIC TDCR: 00000003
[    6.201592] 
[    6.201919] hub 1-0:1.0: state 7 ports 6 chg 0016 evt 0000
[    6.201924] number of MP IRQ sources: 15.
[    6.201925] number of IO-APIC #8 registers: 24.
[    6.201926] testing the IO APIC.......................
[    6.201933] 
[    6.201934] IO APIC #8......
[    6.201935] .... register #00: 08000000
[    6.201936] .......    : physical APIC id: 08
[    6.201937] .......    : Delivery Type: 0
[    6.201937] .......    : LTS          : 0
[    6.201938] .... register #01: 00170020
[    6.201939] .......     : max redirection entries: 17
[    6.201940] .......     : PRQ implemented: 0
[    6.201941] .......     : IO APIC version: 20
[    6.201942] .... IRQ redirection table:
[    6.201943]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    6.201947]  00 00  1    0    0   0   0    0    0    00
[    6.201952]  01 00  0    0    0   0   0    0    0    31
[    6.201957]  02 00  0    0    0   0   0    0    0    30
[    6.201961]  03 00  0    0    0   0   0    0    0    33
[    6.201966]  04 00  0    0    0   0   0    0    0    34
[    6.201971]  05 00  0    0    0   0   0    0    0    35
[    6.201976]  06 00  1    0    0   0   0    0    0    36
[    6.201980]  07 00  0    0    0   0   0    0    0    37
[    6.201985]  08 00  0    0    0   0   0    0    0    38
[    6.201990]  09 00  0    1    0   0   0    0    0    39
[    6.201995]  0a 00  0    0    0   0   0    0    0    3A
[    6.201999]  0b 00  0    0    0   0   0    0    0    3B
[    6.202004]  0c 00  0    0    0   0   0    0    0    3C
[    6.202008]  0d 00  0    0    0   0   0    0    0    3D
[    6.202013]  0e 00  0    0    0   0   0    0    0    3E
[    6.202018]  0f 00  0    0    0   0   0    0    0    3F
[    6.202022]  10 00  0    1    0   1   0    0    0    29
[    6.202027]  11 00  1    1    0   1   0    0    0    41
[    6.202032]  12 00  0    1    0   1   0    0    0    81
[    6.202037]  13 00  0    1    0   1   0    0    0    61
[    6.202041]  14 00  1    1    0   1   0    0    0    71
[    6.202046]  15 00  0    1    0   1   0    0    0    91
[    6.202051]  16 00  1    1    0   1   0    0    0    99
[    6.202056]  17 00  0    1    0   1   0    0    0    89
[    6.202057] IRQ to pin mappings:
[    6.202058] IRQ0 -> 0:2
[    6.202060] IRQ1 -> 0:1
[    6.202061] IRQ3 -> 0:3
[    6.202062] IRQ4 -> 0:4
[    6.202063] IRQ5 -> 0:5
[    6.202064] IRQ6 -> 0:6
[    6.202065] IRQ7 -> 0:7
[    6.202067] IRQ8 -> 0:8
[    6.202068] IRQ9 -> 0:9
[    6.202069] IRQ10 -> 0:10
[    6.202070] IRQ11 -> 0:11
[    6.202071] IRQ12 -> 0:12
[    6.202134] IRQ13 -> 0:13
[    6.202136] IRQ14 -> 0:14
[    6.202137] IRQ15 -> 0:15
[    6.202139] IRQ16 -> 0:16
[    6.202141] IRQ17 -> 0:17
[    6.202143] IRQ18 -> 0:18
[    6.202145] IRQ19 -> 0:19
[    6.202146] IRQ20 -> 0:20
[    6.202148] IRQ21 -> 0:21
[    6.202150] IRQ22 -> 0:22
[    6.202152] IRQ23 -> 0:23
[    6.202154] .................................... done.
[    6.202653] PM: Hibernation image not present or could not be loaded.
[    6.202676] registered taskstats version 1
[    6.202678] Running tests on trace events:
[    6.202679] Testing event kfree_skb: 
[    6.222643] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    6.224354] OK
[    6.224567] Testing event consume_skb: OK
[    6.240497] Testing event skb_copy_datagram_iovec: 
[    6.246961]  sda: sda1 sda2 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    6.248910] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.257469] OK
[    6.257683] Testing event net_dev_xmit: 
[    6.274465] ehci_hcd 0000:00:1a.7: port 1 high speed
[    6.274496] OK
[    6.274498] Testing event net_dev_queue: 
[    6.275347] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    6.290409] OK
[    6.290623] Testing event netif_receive_skb: OK
[    6.306678] Testing event netif_rx: OK
[    6.323671] Testing event napi_poll: 
[    6.327285] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    6.340543] OK
[    6.340756] Testing event sock_rcvqueue_full: OK
[    6.360579] Testing event sock_exceed_buf_limit: OK
[    6.376529] Testing event udp_fail_queue_rcv_skb: 
[    6.380467] ehci_hcd 0000:00:1a.7: port 1 high speed
[    6.380960] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    6.392517] OK
[    6.392732] Testing event hda_send_cmd: 
[    6.405196] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.409422] OK
[    6.409636] Testing event hda_get_response: OK
[    6.425709] Testing event hda_bus_reset: OK
[    6.442694] Testing event hda_power_down: 
[    6.451492] usb 1-1: default language 0x0409
[    6.458801] usb 1-1: udev 2, busnum 1, minor = 1
[    6.459203] usb 1-1: New USB device found, idVendor=0b95, idProduct=1780
[    6.459600] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    6.462993] usb 1-1: Product: AX88178 
[    6.463201] OK
[    6.463202] Testing event hda_power_up: 
[    6.463727] usb 1-1: Manufacturer: ASIX Elec. Corp.
[    6.464365] usb 1-1: SerialNumber: 000013
[    6.465493] usb 1-1: usb_probe_device
[    6.465780] usb 1-1: configuration #1 chosen from 1 choice
[    6.466862] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    6.467977] asix 1-1:1.0: usb_probe_interface
[    6.468386] asix 1-1:1.0: usb_probe_interface - got id
[    6.476569] ata2.00: ATAPI: PLEXTOR DVDR   PX-712A, 1.07, max UDMA/33
[    6.476962] ata2.00: applying bridge limits
[    6.481488] OK
[    6.481700] Testing event hda_unsol_event: OK
[    6.499688] Testing event scsi_dispatch_cmd_start: 
[    6.507830] ata2.00: configured for UDMA/33
[    6.509439] scsi 1:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-712A   1.07 PQ: 0 ANSI: 5
[    6.516462] OK
[    6.516673] Testing event scsi_dispatch_cmd_error: OK
[    6.533670] Testing event scsi_dispatch_cmd_done: OK
[    6.550717] Testing event scsi_dispatch_cmd_timeout: OK
[    6.567591] Testing event scsi_eh_wakeup: OK
[    6.583521] Testing event i915_gem_object_create: OK
[    6.599589] Testing event i915_gem_object_bind: OK
[    6.615523] Testing event i915_gem_object_unbind: OK
[    6.631600] Testing event i915_gem_object_change_domain: OK
[    6.648683] Testing event i915_gem_object_pwrite: OK
[    6.666753] Testing event i915_gem_object_pread: OK
[    6.683700] Testing event i915_gem_object_fault: OK
[    6.702655] Testing event i915_gem_object_clflush: OK
[    6.720644] Testing event i915_gem_object_destroy: OK
[    6.737715] Testing event i915_gem_evict: OK
[    6.754596] Testing event i915_gem_evict_everything: OK
[    6.771603] Testing event i915_gem_ring_dispatch: OK
[    6.788629] Testing event i915_gem_ring_flush: OK
[    6.805629] Testing event i915_gem_request_add: 
[    6.815287] ata8: SATA link down (SStatus 0 SControl 300)
[    6.822447] OK
[    6.822661] Testing event i915_gem_request_complete: OK
[    6.839591] Testing event i915_gem_request_retire: OK
[    6.855491] Testing event i915_gem_request_wait_begin: OK
[    6.871602] Testing event i915_gem_request_wait_end: OK
[    6.887665] Testing event i915_ring_wait_begin: OK
[    6.904603] Testing event i915_ring_wait_end: OK
[    6.920598] Testing event i915_flip_request: OK
[    6.938537] Testing event i915_flip_complete: OK
[    6.955649] Testing event i915_reg_rw: OK
[    6.971759] Testing event drm_vblank_event: OK
[    6.988699] Testing event drm_vblank_event_queued: OK
[    7.005637] Testing event drm_vblank_event_delivered: OK
[    7.021679] Testing event block_rq_abort: OK
[    7.038606] Testing event block_rq_requeue: OK
[    7.054662] Testing event block_rq_complete: OK
[    7.073663] Testing event block_rq_insert: OK
[    7.090691] Testing event block_rq_issue: OK
[    7.108651] Testing event block_bio_bounce: OK
[    7.127659] Testing event block_bio_complete: OK
[    7.146602] Testing event block_bio_backmerge: OK
[    7.162611] Testing event block_bio_frontmerge: OK
[    7.178518] Testing event block_bio_queue: 
[    7.183517] asix 1-1:1.0: eth1: register 'asix' at usb-0000:00:1a.7-1, ASIX AX88178 USB 2.0 Ethernet, 00:23:54:5c:02:83
[    7.184407] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    7.184847] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    7.185303] ehci_hcd 0000:00:1a.7: port 2 low speed --> companion
[    7.194445] OK
[    7.194659] Testing event block_getrq: 
[    7.203185] usb usb5: suspend_rh (auto-stop)
[    7.203671] usb usb6: suspend_rh (auto-stop)
[    7.203997] usb usb7: suspend_rh (auto-stop)
[    7.204422] usb usb8: suspend_rh (auto-stop)
[    7.204758] usb usb4: suspend_rh (auto-stop)
[    7.210509] OK
[    7.210723] Testing event block_sleeprq: OK
[    7.228639] Testing event block_plug: 
[    7.236239] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    7.237013] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    7.244486] OK
[    7.244700] Testing event block_unplug: OK
[    7.261724] Testing event block_split: OK
[    7.278721] Testing event block_bio_remap: 
[    7.288501] ehci_hcd 0000:00:1a.7: port 4 high speed
[    7.288994] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    7.295436] OK
[    7.295650] Testing event block_rq_remap: OK
[    7.311596] Testing event btrfs_transaction_commit: OK
[    7.327738] Testing event btrfs_inode_new: 
[    7.340297] usb 1-4: new high-speed USB device number 4 using ehci_hcd
[    7.345498] OK
[    7.345710] Testing event btrfs_inode_request: OK
[    7.363608] Testing event btrfs_inode_evict: OK
[    7.380709] Testing event btrfs_get_extent: 
[    7.391503] ehci_hcd 0000:00:1a.7: port 4 high speed
[    7.391995] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    7.397591] OK
[    7.397806] Testing event btrfs_ordered_extent_add: OK
[    7.414646] Testing event btrfs_ordered_extent_remove: OK
[    7.431746] Testing event btrfs_ordered_extent_start: OK
[    7.448599] Testing event btrfs_ordered_extent_put: OK
[    7.464691] Testing event btrfs_finish_ordered_io: OK
[    7.481598] Testing event __extent_writepage: OK
[    7.497597] Testing event btrfs_writepage_end_io_hook: OK
[    7.513650] Testing event btrfs_sync_file: OK
[    7.529683] Testing event btrfs_sync_fs: OK
[    7.546671] Testing event btrfs_delayed_tree_ref: OK
[    7.563612] Testing event btrfs_delayed_data_ref: OK
[    7.579681] Testing event btrfs_delayed_ref_head: OK
[    7.596596] Testing event btrfs_chunk_alloc: OK
[    7.612712] Testing event btrfs_chunk_free: OK
[    7.629696] Testing event btrfs_cow_block: OK
[    7.646617] Testing event btrfs_reserved_extent_alloc: OK
[    7.662715] Testing event btrfs_reserved_extent_free: OK
[    7.679679] Testing event xfs_attr_list_sf: OK
[    7.695654] Testing event xfs_attr_list_sf_all: OK
[    7.712625] Testing event xfs_attr_list_leaf: OK
[    7.728607] Testing event xfs_attr_list_leaf_end: OK
[    7.745704] Testing event xfs_attr_list_full: OK
[    7.762619] Testing event xfs_attr_list_add: OK
[    7.778564] Testing event xfs_attr_list_wrong_blk: OK
[    7.794609] Testing event xfs_attr_list_notfound: OK
[    7.811589] Testing event xfs_perag_get: OK
[    7.827624] Testing event xfs_perag_get_tag: OK
[    7.844692] Testing event xfs_perag_put: OK
[    7.862567] Testing event xfs_perag_set_reclaim: OK
[    7.878583] Testing event xfs_perag_clear_reclaim: OK
[    7.894568] Testing event xfs_attr_list_node_descend: OK
[    7.910588] Testing event xfs_iext_insert: OK
[    7.926608] Testing event xfs_iext_remove: OK
[    7.942714] Testing event xfs_bmap_pre_update: OK
[    7.959585] Testing event xfs_bmap_post_update: OK
[    7.977736] Testing event xfs_extlist: OK
[    7.996646] Testing event xfs_buf_init: OK
[    8.013600] Testing event xfs_buf_free: OK
[    8.031621] Testing event xfs_buf_hold: OK
[    8.047613] Testing event xfs_buf_rele: OK
[    8.063703] Testing event xfs_buf_iodone: OK
[    8.080580] Testing event xfs_buf_iorequest: OK
[    8.096617] Testing event xfs_buf_bawrite: OK
[    8.112618] Testing event xfs_buf_lock: OK
[    8.128640] Testing event xfs_buf_lock_done: OK
[    8.144725] Testing event xfs_buf_trylock: OK
[    8.161678] Testing event xfs_buf_unlock: OK
[    8.177585] Testing event xfs_buf_iowait: OK
[    8.193627] Testing event xfs_buf_iowait_done: OK
[    8.209729] Testing event xfs_buf_delwri_queue: OK
[    8.226780] Testing event xfs_buf_delwri_dequeue: OK
[    8.244838] Testing event xfs_buf_delwri_split: OK
[    8.261783] Testing event xfs_buf_get_uncached: OK
[    8.278770] Testing event xfs_bdstrat_shut: OK
[    8.298655] Testing event xfs_buf_item_relse: OK
[    8.314760] Testing event xfs_buf_item_iodone: OK
[    8.331605] Testing event xfs_buf_item_iodone_async: OK
[    8.347702] Testing event xfs_buf_error_relse: OK
[    8.364805] Testing event xfs_trans_read_buf_io: OK
[    8.382709] Testing event xfs_trans_read_buf_shut: 
[    8.393748] usb 1-4: default language 0x0409
[    8.395752] usb 1-4: udev 4, busnum 1, minor = 3
[    8.396080] usb 1-4: New USB device found, idVendor=1307, idProduct=0165
[    8.396545] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    8.396958] usb 1-4: Product: USB Mass Storage Device
[    8.397356] usb 1-4: Manufacturer: Teclast Technology
[    8.397694] usb 1-4: SerialNumber: 0000000000020D
[    8.398350] usb 1-4: usb_probe_device
[    8.398643] usb 1-4: configuration #1 chosen from 1 choice
[    8.399064] usb 1-4: adding 1-4:1.0 (config #1, interface 0)
[    8.399759] OK
[    8.399798] usb-storage 1-4:1.0: usb_probe_interface
[    8.399803] usb-storage 1-4:1.0: usb_probe_interface - got id
[    8.399954] scsi9 : usb-storage 1-4:1.0
[    8.400389] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[    8.400423] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.400427] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.400430] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    8.400439] uhci_hcd 0000:00:1a.0: port 2 portsc 01a3,00
[    8.400449] hub 3-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    8.403312] Testing event xfs_btree_corrupt: OK
[    8.424813] Testing event xfs_da_btree_corrupt: OK
[    8.441607] Testing event xfs_reset_dqcounts: OK
[    8.459705] Testing event xfs_inode_item_push: OK
[    8.477696] Testing event xfs_buf_find: OK
[    8.494830] Testing event xfs_buf_get: 
[    8.504353] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    8.511613] OK
[    8.511826] Testing event xfs_buf_read: OK
[    8.530691] Testing event xfs_buf_ioerror: OK
[    8.549788] Testing event xfs_buf_item_size: OK
[    8.566714] Testing event xfs_buf_item_size_stale: OK
[    8.583775] Testing event xfs_buf_item_format: OK
[    8.600670] Testing event xfs_buf_item_format_stale: 
[    8.606275] usb 3-2: new low-speed USB device number 2 using uhci_hcd
[    8.616568] OK
[    8.616782] Testing event xfs_buf_item_pin: OK
[    8.633751] Testing event xfs_buf_item_unpin: OK
[    8.650752] Testing event xfs_buf_item_unpin_stale: OK
[    8.668890] Testing event xfs_buf_item_trylock: OK
[    8.686705] Testing event xfs_buf_item_unlock: OK
[    8.703779] Testing event xfs_buf_item_unlock_stale: OK
[    8.720705] Testing event xfs_buf_item_committed: OK
[    8.737698] Testing event xfs_buf_item_push: OK
[    8.754760] Testing event xfs_buf_item_pushbuf: OK
[    8.772646] Testing event xfs_trans_get_buf: OK
[    8.788772] Testing event xfs_trans_get_buf_recur: 
[    8.805131] usb 3-2: skipped 1 descriptor after interface
[    8.805712] usb 3-2: skipped 1 descriptor after interface
[    8.805900] OK
[    8.805902] Testing event xfs_trans_getsb: 
[    8.814123] usb 3-2: default language 0x0409
[    8.822562] OK
[    8.822776] Testing event xfs_trans_getsb_recur: OK
[    8.839791] Testing event xfs_trans_read_buf: 
[    8.845098] usb 3-2: udev 2, busnum 3, minor = 257
[    8.845668] usb 3-2: New USB device found, idVendor=0557, idProduct=2220
[    8.846067] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.846558] usb 3-2: Product: ATEN  CS-1758/54
[    8.846875] usb 3-2: Manufacturer: ATEN
[    8.847448] usb 3-2: usb_probe_device
[    8.847735] usb 3-2: configuration #1 chosen from 1 choice
[    8.851067] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[    8.856422] OK
[    8.856635] Testing event xfs_trans_read_buf_recur: OK
[    8.874617] Testing event xfs_trans_log_buf: 
[    8.891444] usbserial_generic 3-2:1.0: usb_probe_interface
[    8.891956] usbserial_generic 3-2:1.0: usb_probe_interface - got id
[    8.892509] usbhid 3-2:1.0: usb_probe_interface
[    8.892827] usbhid 3-2:1.0: usb_probe_interface - got id
[    8.893542] OK
[    8.893757] Testing event xfs_trans_brelse: OK
[    8.911671] Testing event xfs_trans_bjoin: 
[    8.924869] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input4
[    8.925769] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    8.926594] generic-usb 0003:0557:2220.0001: input: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input0
[    8.927404] usb 3-2: adding 3-2:1.1 (config #1, interface 1)
[    8.928562] OK
[    8.928777] Testing event xfs_trans_bhold: 
[    8.937378] usbserial_generic 3-2:1.1: usb_probe_interface
[    8.937890] usbserial_generic 3-2:1.1: usb_probe_interface - got id
[    8.938355] usbhid 3-2:1.1: usb_probe_interface
[    8.938675] usbhid 3-2:1.1: usb_probe_interface - got id
[    8.945544] OK
[    8.945757] Testing event xfs_trans_bhold_release: OK
[    8.964691] Testing event xfs_trans_binval: 
[    8.966580] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.1/input/input5
[    8.967953] generic-usb 0003:0557:2220.0002: input: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input1
[    8.968753] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    8.969307] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.969662] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    8.980628] OK
[    8.980843] Testing event xfs_ilock: OK
[    8.998740] Testing event xfs_ilock_nowait: OK
[    9.017783] Testing event xfs_ilock_demote: OK
[    9.036642] Testing event xfs_iunlock: OK
[    9.052727] Testing event xfs_iget_skip: OK
[    9.069709] Testing event xfs_iget_reclaim: OK
[    9.085730] Testing event xfs_iget_reclaim_fail: OK
[    9.102754] Testing event xfs_iget_hit: OK
[    9.119813] Testing event xfs_iget_miss: OK
[    9.136774] Testing event xfs_getattr: OK
[    9.154843] Testing event xfs_setattr: OK
[    9.172817] Testing event xfs_readlink: OK
[    9.189641] Testing event xfs_alloc_file_space: OK
[    9.205713] Testing event xfs_free_file_space: OK
[    9.223709] Testing event xfs_readdir: OK
[    9.240671] Testing event xfs_get_acl: OK
[    9.256697] Testing event xfs_vm_bmap: OK
[    9.272857] Testing event xfs_file_ioctl: OK
[    9.290823] Testing event xfs_file_compat_ioctl: OK
[    9.308857] Testing event xfs_ioctl_setattr: OK
[    9.326713] Testing event xfs_dir_fsync: OK
[    9.342718] Testing event xfs_file_fsync: OK
[    9.359761] Testing event xfs_destroy_inode: OK
[    9.376786] Testing event xfs_write_inode: OK
[    9.393800] Testing event xfs_evict_inode: 
[    9.401619] scsi 9:0:0:0: Direct-Access     Teclast  CoolFlash        0.00 PQ: 0 ANSI: 2
[    9.402499] scsi: killing requests for dead queue
[    9.402953] scsi: killing requests for dead queue
[    9.403443] scsi: killing requests for dead queue
[    9.403879] scsi: killing requests for dead queue
[    9.404373] scsi: killing requests for dead queue
[    9.404853] scsi: killing requests for dead queue
[    9.405340] scsi: killing requests for dead queue
[    9.406385] scsi_scan_9 used greatest stack depth: 4968 bytes left
[    9.407555] sd 9:0:0:0: [sdb] 63084544 512-byte logical blocks: (32.2 GB/30.0 GiB)
[    9.408777] sd 9:0:0:0: [sdb] Write Protect is off
[    9.409103] sd 9:0:0:0: [sdb] Mode Sense: 00 00 00 00
[    9.410104] sd 9:0:0:0: [sdb] Asking for cache data failed
[    9.410457] OK
[    9.410458] Testing event xfs_dquot_dqalloc: 
[    9.410865] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    9.416103] sd 9:0:0:0: [sdb] Asking for cache data failed
[    9.416460] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    9.428484] OK
[    9.428694] Testing event xfs_dquot_dqdetach: OK
[    9.444768] Testing event xfs_ihold: OK
[    9.462719] Testing event xfs_irele: OK
[    9.478703] Testing event xfs_inode_pin: OK
[    9.494682] Testing event xfs_inode_unpin: OK
[    9.511608] Testing event xfs_inode_unpin_nowait: OK
[    9.527759] Testing event xfs_remove: OK
[    9.544795] Testing event xfs_link: 
[    9.550798]  sdb: sdb1 sdb2 sdb3
[    9.555332] sd 9:0:0:0: [sdb] Asking for cache data failed
[    9.555685] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    9.556058] sd 9:0:0:0: [sdb] Attached SCSI removable disk
[    9.561674] OK
[    9.561886] Testing event xfs_lookup: OK
[    9.579688] Testing event xfs_create: OK
[    9.595785] Testing event xfs_symlink: OK
[    9.612700] Testing event xfs_rename: OK
[    9.629821] Testing event xfs_dqadjust: OK
[    9.647683] Testing event xfs_dqreclaim_want: OK
[    9.664730] Testing event xfs_dqreclaim_dirty: OK
[    9.680666] Testing event xfs_dqreclaim_unlink: OK
[    9.696791] Testing event xfs_dqattach_found: OK
[    9.713832] Testing event xfs_dqattach_get: OK
[    9.731918] Testing event xfs_dqinit: OK
[    9.749743] Testing event xfs_dqreuse: OK
[    9.768743] Testing event xfs_dqalloc: OK
[    9.787820] Testing event xfs_dqtobp_read: OK
[    9.804669] Testing event xfs_dqread: OK
[    9.820635] Testing event xfs_dqread_fail: OK
[    9.836808] Testing event xfs_dqlookup_found: OK
[    9.853667] Testing event xfs_dqlookup_want: OK
[    9.869621] Testing event xfs_dqlookup_freelist: OK
[    9.885836] Testing event xfs_dqlookup_done: OK
[    9.902713] Testing event xfs_dqget_hit: OK
[    9.918795] Testing event xfs_dqget_miss: OK
[    9.935797] Testing event xfs_dqput: OK
[    9.952814] Testing event xfs_dqput_wait: OK
[    9.969739] Testing event xfs_dqput_free: OK
[    9.987752] Testing event xfs_dqrele: OK
[   10.004816] Testing event xfs_dqflush: OK
[   10.021845] Testing event xfs_dqflush_force: OK
[   10.038724] Testing event xfs_dqflush_done: OK
[   10.054886] Testing event xfs_log_done_nonperm: OK
[   10.071747] Testing event xfs_log_done_perm: OK
[   10.089755] Testing event xfs_log_reserve: OK
[   10.105795] Testing event xfs_log_umount_write: OK
[   10.122714] Testing event xfs_log_grant_enter: OK
[   10.138830] Testing event xfs_log_grant_exit: OK
[   10.155823] Testing event xfs_log_grant_error: OK
[   10.172789] Testing event xfs_log_grant_sleep1: OK
[   10.189849] Testing event xfs_log_grant_wake1: OK
[   10.206790] Testing event xfs_log_grant_sleep2: OK
[   10.223917] Testing event xfs_log_grant_wake2: OK
[   10.240850] Testing event xfs_log_grant_wake_up: OK
[   10.257856] Testing event xfs_log_regrant_write_enter: OK
[   10.274816] Testing event xfs_log_regrant_write_exit: OK
[   10.291851] Testing event xfs_log_regrant_write_error: OK
[   10.311860] Testing event xfs_log_regrant_write_sleep1: OK
[   10.328852] Testing event xfs_log_regrant_write_wake1: OK
[   10.345780] Testing event xfs_log_regrant_write_sleep2: OK
[   10.362895] Testing event xfs_log_regrant_write_wake2: OK
[   10.379857] Testing event xfs_log_regrant_write_wake_up: OK
[   10.396941] Testing event xfs_log_regrant_reserve_enter: OK
[   10.413743] Testing event xfs_log_regrant_reserve_exit: OK
[   10.430762] Testing event xfs_log_regrant_reserve_sub: OK
[   10.447834] Testing event xfs_log_ungrant_enter: OK
[   10.464895] Testing event xfs_log_ungrant_exit: OK
[   10.481746] Testing event xfs_log_ungrant_sub: OK
[   10.498880] Testing event xfs_ail_push: OK
[   10.516796] Testing event xfs_ail_pushbuf: OK
[   10.533858] Testing event xfs_ail_pushbuf_pinned: OK
[   10.550808] Testing event xfs_ail_pinned: OK
[   10.567892] Testing event xfs_ail_locked: OK
[   10.584825] Testing event xfs_file_read: OK
[   10.602705] Testing event xfs_file_buffered_write: OK
[   10.619767] Testing event xfs_file_direct_write: OK
[   10.638771] Testing event xfs_file_splice_read: OK
[   10.655738] Testing event xfs_file_splice_write: OK
[   10.673860] Testing event xfs_writepage: OK
[   10.690715] Testing event xfs_releasepage: OK
[   10.706731] Testing event xfs_invalidatepage: OK
[   10.722828] Testing event xfs_map_blocks_found: OK
[   10.740774] Testing event xfs_map_blocks_alloc: OK
[   10.758811] Testing event xfs_get_blocks_found: OK
[   10.775749] Testing event xfs_get_blocks_alloc: OK
[   10.791892] Testing event xfs_delalloc_enospc: OK
[   10.809865] Testing event xfs_unwritten_convert: OK
[   10.827961] Testing event xfs_get_blocks_notfound: OK
[   10.844749] Testing event xfs_setfilesize: OK
[   10.860679] Testing event xfs_itruncate_data_start: OK
[   10.876834] Testing event xfs_itruncate_data_end: OK
[   10.893703] Testing event xfs_pagecache_inval: OK
[   10.910849] Testing event xfs_bunmap: OK
[   10.928738] Testing event xfs_alloc_busy: OK
[   10.945906] Testing event xfs_alloc_busy_enomem: OK
[   10.962878] Testing event xfs_alloc_busy_force: OK
[   10.979970] Testing event xfs_alloc_busy_reuse: OK
[   10.996761] Testing event xfs_alloc_busy_clear: OK
[   11.013900] Testing event xfs_alloc_busy_trim: OK
[   11.031851] Testing event xfs_trans_commit_lsn: OK
[   11.049721] Testing event xfs_agf: OK
[   11.067788] Testing event xfs_free_extent: OK
[   11.085877] Testing event xfs_alloc_exact_done: OK
[   11.103806] Testing event xfs_alloc_exact_notfound: OK
[   11.120804] Testing event xfs_alloc_exact_error: OK
[   11.139837] Testing event xfs_alloc_near_nominleft: OK
[   11.157766] Testing event xfs_alloc_near_first: OK
[   11.174843] Testing event xfs_alloc_near_greater: OK
[   11.193788] Testing event xfs_alloc_near_lesser: OK
[   11.212788] Testing event xfs_alloc_near_error: OK
[   11.230884] Testing event xfs_alloc_near_noentry: OK
[   11.247884] Testing event xfs_alloc_near_busy: OK
[   11.264829] Testing event xfs_alloc_size_neither: OK
[   11.281830] Testing event xfs_alloc_size_noentry: OK
[   11.298847] Testing event xfs_alloc_size_nominleft: OK
[   11.315738] Testing event xfs_alloc_size_done: OK
[   11.331894] Testing event xfs_alloc_size_error: OK
[   11.348836] Testing event xfs_alloc_size_busy: OK
[   11.365845] Testing event xfs_alloc_small_freelist: OK
[   11.382885] Testing event xfs_alloc_small_notenough: OK
[   11.399837] Testing event xfs_alloc_small_done: OK
[   11.416769] Testing event xfs_alloc_small_error: OK
[   11.433831] Testing event xfs_alloc_vextent_badargs: OK
[   11.450839] Testing event xfs_alloc_vextent_nofix: OK
[   11.467889] Testing event xfs_alloc_vextent_noagbp: OK
[   11.484854] Testing event xfs_alloc_vextent_loopfailed: OK
[   11.501889] Testing event xfs_alloc_vextent_allfailed: OK
[   11.518896] Testing event xfs_dir2_sf_addname: OK
[   11.535875] Testing event xfs_dir2_sf_create: OK
[   11.552829] Testing event xfs_dir2_sf_lookup: OK
[   11.569794] Testing event xfs_dir2_sf_replace: OK
[   11.586861] Testing event xfs_dir2_sf_removename: OK
[   11.603754] Testing event xfs_dir2_sf_toino4: OK
[   11.619854] Testing event xfs_dir2_sf_toino8: OK
[   11.636844] Testing event xfs_dir2_sf_to_block: OK
[   11.653800] Testing event xfs_dir2_block_addname: OK
[   11.670778] Testing event xfs_dir2_block_lookup: OK
[   11.687893] Testing event xfs_dir2_block_replace: OK
[   11.704899] Testing event xfs_dir2_block_removename: OK
[   11.721862] Testing event xfs_dir2_block_to_sf: OK
[   11.738758] Testing event xfs_dir2_block_to_leaf: OK
[   11.754922] Testing event xfs_dir2_leaf_addname: OK
[   11.772909] Testing event xfs_dir2_leaf_lookup: OK
[   11.790901] Testing event xfs_dir2_leaf_replace: OK
[   11.807909] Testing event xfs_dir2_leaf_removename: OK
[   11.824787] Testing event xfs_dir2_leaf_to_block: OK
[   11.841901] Testing event xfs_dir2_leaf_to_node: OK
[   11.858727] Testing event xfs_dir2_node_addname: OK
[   11.875751] Testing event xfs_dir2_node_lookup: OK
[   11.891864] Testing event xfs_dir2_node_replace: OK
[   11.909739] Testing event xfs_dir2_node_removename: OK
[   11.926987] Testing event xfs_dir2_node_to_leaf: OK
[   11.943705] Testing event xfs_dir2_leafn_add: OK
[   11.960794] Testing event xfs_dir2_leafn_remove: OK
[   11.976973] Testing event xfs_dir2_grow_inode: OK
[   11.993949] Testing event xfs_dir2_shrink_inode: OK
[   12.011826] Testing event xfs_dir2_leafn_moveents: OK
[   12.029913] Testing event xfs_swap_extent_before: OK
[   12.046732] Testing event xfs_swap_extent_after: OK
[   12.063931] Testing event xfs_log_recover_item_add: OK
[   12.081793] Testing event xfs_log_recover_item_add_cont: OK
[   12.098811] Testing event xfs_log_recover_item_reorder_head: OK
[   12.115873] Testing event xfs_log_recover_item_reorder_tail: OK
[   12.132876] Testing event xfs_log_recover_item_recover: OK
[   12.149955] Testing event xfs_log_recover_buf_not_cancel: OK
[   12.166849] Testing event xfs_log_recover_buf_cancel: OK
[   12.183885] Testing event xfs_log_recover_buf_cancel_add: OK
[   12.200914] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   12.218911] Testing event xfs_log_recover_buf_recover: OK
[   12.237757] Testing event xfs_log_recover_buf_inode_buf: OK
[   12.254884] Testing event xfs_log_recover_buf_reg_buf: OK
[   12.273856] Testing event xfs_log_recover_buf_dquot_buf: OK
[   12.292785] Testing event xfs_log_recover_inode_recover: OK
[   12.310959] Testing event xfs_log_recover_inode_cancel: OK
[   12.328901] Testing event xfs_log_recover_inode_skip: OK
[   12.346897] Testing event xfs_discard_extent: OK
[   12.363878] Testing event xfs_discard_toosmall: OK
[   12.380859] Testing event xfs_discard_exclude: OK
[   12.396765] Testing event xfs_discard_busy: OK
[   12.412837] Testing event jbd2_checkpoint: OK
[   12.431832] Testing event jbd2_start_commit: OK
[   12.450824] Testing event jbd2_commit_locking: OK
[   12.467925] Testing event jbd2_commit_flushing: OK
[   12.484924] Testing event jbd2_commit_logging: OK
[   12.501888] Testing event jbd2_end_commit: OK
[   12.518882] Testing event jbd2_submit_inode_data: OK
[   12.535799] Testing event jbd2_run_stats: OK
[   12.552877] Testing event jbd2_checkpoint_stats: OK
[   12.569971] Testing event jbd2_cleanup_journal_tail: OK
[   12.586934] Testing event jbd_checkpoint: OK
[   12.604898] Testing event jbd_start_commit: OK
[   12.621970] Testing event jbd_commit_locking: OK
[   12.638820] Testing event jbd_commit_flushing: OK
[   12.655838] Testing event jbd_commit_logging: OK
[   12.673970] Testing event jbd_drop_transaction: OK
[   12.691788] Testing event jbd_end_commit: OK
[   12.708825] Testing event jbd_do_submit_data: OK
[   12.725899] Testing event jbd_cleanup_journal_tail: OK
[   12.742878] Testing event jbd_update_superblock_end: OK
[   12.759899] Testing event ext4_free_inode: OK
[   12.776934] Testing event ext4_request_inode: OK
[   12.793916] Testing event ext4_allocate_inode: OK
[   12.810795] Testing event ext4_evict_inode: OK
[   12.826955] Testing event ext4_drop_inode: OK
[   12.844942] Testing event ext4_mark_inode_dirty: OK
[   12.861779] Testing event ext4_begin_ordered_truncate: OK
[   12.878943] Testing event ext4_write_begin: OK
[   12.896798] Testing event ext4_da_write_begin: OK
[   12.914032] Testing event ext4_ordered_write_end: OK
[   12.932793] Testing event ext4_writeback_write_end: OK
[   12.948825] Testing event ext4_journalled_write_end: OK
[   12.966916] Testing event ext4_da_write_end: OK
[   12.984794] Testing event ext4_da_writepages: OK
[   13.001887] Testing event ext4_da_write_pages: OK
[   13.018912] Testing event ext4_da_writepages_result: OK
[   13.035851] Testing event ext4_writepage: OK
[   13.051942] Testing event ext4_readpage: OK
[   13.069967] Testing event ext4_releasepage: OK
[   13.086921] Testing event ext4_invalidatepage: OK
[   13.103958] Testing event ext4_discard_blocks: OK
[   13.120948] Testing event ext4_mb_new_inode_pa: OK
[   13.138952] Testing event ext4_mb_new_group_pa: OK
[   13.157915] Testing event ext4_mb_release_inode_pa: OK
[   13.175806] Testing event ext4_mb_release_group_pa: OK
[   13.192918] Testing event ext4_discard_preallocations: OK
[   13.211902] Testing event ext4_mb_discard_preallocations: OK
[   13.230903] Testing event ext4_request_blocks: OK
[   13.248936] Testing event ext4_allocate_blocks: OK
[   13.265927] Testing event ext4_free_blocks: OK
[   13.282952] Testing event ext4_sync_file_enter: OK
[   13.299840] Testing event ext4_sync_file_exit: OK
[   13.318000] Testing event ext4_sync_fs: OK
[   13.334905] Testing event ext4_alloc_da_blocks: OK
[   13.351917] Testing event ext4_mballoc_alloc: OK
[   13.368865] Testing event ext4_mballoc_prealloc: OK
[   13.386861] Testing event ext4_mballoc_discard: OK
[   13.404887] Testing event ext4_mballoc_free: OK
[   13.424866] Testing event ext4_forget: OK
[   13.440853] Testing event ext4_da_update_reserve_space: OK
[   13.457842] Testing event ext4_da_reserve_space: OK
[   13.473982] Testing event ext4_da_release_space: OK
[   13.491953] Testing event ext4_mb_bitmap_load: OK
[   13.509962] Testing event ext4_mb_buddy_bitmap_load: OK
[   13.526996] Testing event ext4_read_block_bitmap_load: OK
[   13.543897] Testing event ext4_load_inode_bitmap: OK
[   13.560930] Testing event ext4_direct_IO_enter: OK
[   13.577867] Testing event ext4_direct_IO_exit: OK
[   13.596864] Testing event ext4_fallocate_enter: OK
[   13.615841] Testing event ext4_fallocate_exit: OK
[   13.632836] Testing event ext4_unlink_enter: OK
[   13.648932] Testing event ext4_unlink_exit: OK
[   13.665960] Testing event ext4_truncate_enter: OK
[   13.683006] Testing event ext4_truncate_exit: OK
[   13.700824] Testing event ext4_ext_map_blocks_enter: OK
[   13.717935] Testing event ext4_ind_map_blocks_enter: OK
[   13.735877] Testing event ext4_ext_map_blocks_exit: OK
[   13.753878] Testing event ext4_ind_map_blocks_exit: OK
[   13.771934] Testing event ext4_ext_load_extent: OK
[   13.789809] Testing event ext4_load_inode: OK
[   13.806010] Testing event ext4_journal_start: OK
[   13.823030] Testing event ext4_trim_extent: OK
[   13.839885] Testing event ext4_trim_all_free: OK
[   13.856878] Testing event ext4_ext_handle_uninitialized_extents: OK
[   13.873940] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   13.891884] Testing event ext4_ext_put_in_cache: OK
[   13.909018] Testing event ext4_ext_in_cache: OK
[   13.925874] Testing event ext4_find_delalloc_range: OK
[   13.942892] Testing event ext4_get_reserved_cluster_alloc: OK
[   13.959892] Testing event ext4_ext_show_extent: OK
[   13.976966] Testing event ext4_remove_blocks: OK
[   13.993960] Testing event ext4_ext_rm_leaf: OK
[   14.010838] Testing event ext4_ext_rm_idx: OK
[   14.027049] Testing event ext4_ext_remove_space: OK
[   14.043887] Testing event ext4_ext_remove_space_done: OK
[   14.060884] Testing event ext3_free_inode: OK
[   14.077927] Testing event ext3_request_inode: OK
[   14.094940] Testing event ext3_allocate_inode: OK
[   14.111947] Testing event ext3_evict_inode: OK
[   14.128891] Testing event ext3_drop_inode: OK
[   14.145904] Testing event ext3_mark_inode_dirty: OK
[   14.163894] Testing event ext3_write_begin: OK
[   14.180871] Testing event ext3_ordered_write_end: OK
[   14.197991] Testing event ext3_writeback_write_end: OK
[   14.215846] Testing event ext3_journalled_write_end: OK
[   14.232904] Testing event ext3_ordered_writepage: OK
[   14.249899] Testing event ext3_writeback_writepage: OK
[   14.266892] Testing event ext3_journalled_writepage: OK
[   14.283876] Testing event ext3_readpage: OK
[   14.299853] Testing event ext3_releasepage: OK
[   14.316014] Testing event ext3_invalidatepage: OK
[   14.333015] Testing event ext3_discard_blocks: OK
[   14.349926] Testing event ext3_request_blocks: OK
[   14.366977] Testing event ext3_allocate_blocks: OK
[   14.383947] Testing event ext3_free_blocks: OK
[   14.400959] Testing event ext3_sync_file_enter: OK
[   14.417848] Testing event ext3_sync_file_exit: OK
[   14.434954] Testing event ext3_sync_fs: OK
[   14.452996] Testing event ext3_rsv_window_add: OK
[   14.472035] Testing event ext3_discard_reservation: OK
[   14.489904] Testing event ext3_alloc_new_reservation: OK
[   14.508950] Testing event ext3_reserved: OK
[   14.526967] Testing event ext3_forget: OK
[   14.543998] Testing event ext3_read_block_bitmap: OK
[   14.560963] Testing event ext3_direct_IO_enter: OK
[   14.577933] Testing event ext3_direct_IO_exit: OK
[   14.595970] Testing event ext3_unlink_enter: OK
[   14.612965] Testing event ext3_unlink_exit: OK
[   14.629918] Testing event ext3_truncate_enter: OK
[   14.649089] Testing event ext3_truncate_exit: OK
[   14.667994] Testing event ext3_get_blocks_enter: OK
[   14.686005] Testing event ext3_get_blocks_exit: OK
[   14.703998] Testing event ext3_load_inode: OK
[   14.720872] Testing event writeback_nothread: OK
[   14.736944] Testing event writeback_queue: OK
[   14.755104] Testing event writeback_exec: OK
[   14.771924] Testing event writeback_start: OK
[   14.789913] Testing event writeback_written: OK
[   14.807936] Testing event writeback_wait: OK
[   14.824034] Testing event writeback_pages_written: OK
[   14.841012] Testing event writeback_nowork: OK
[   14.858999] Testing event writeback_wake_background: OK
[   14.876019] Testing event writeback_wake_thread: OK
[   14.893006] Testing event writeback_wake_forker_thread: OK
[   14.910010] Testing event writeback_bdi_register: OK
[   14.926965] Testing event writeback_bdi_unregister: OK
[   14.944009] Testing event writeback_thread_start: OK
[   14.961052] Testing event writeback_thread_stop: OK
[   14.977983] Testing event wbc_writepage: OK
[   14.995021] Testing event writeback_queue_io: OK
[   15.011971] Testing event task_io: OK
[   15.029001] Testing event global_dirty_state: OK
[   15.046874] Testing event bdi_dirty_state: OK
[   15.063936] Testing event blkcg_dirty_ratelimit: OK
[   15.080966] Testing event bdi_dirty_ratelimit: OK
[   15.097980] Testing event balance_dirty_pages: OK
[   15.115061] Testing event writeback_congestion_wait: OK
[   15.132873] Testing event writeback_wait_iff_congested: OK
[   15.148822] Testing event writeback_single_inode_requeue: OK
[   15.164941] Testing event writeback_single_inode: OK
[   15.182125] Testing event kmalloc: OK
[   15.198933] Testing event kmem_cache_alloc: OK
[   15.217019] Testing event kmalloc_node: OK
[   15.234860] Testing event kmem_cache_alloc_node: OK
[   15.250880] Testing event kfree: OK
[   15.266992] Testing event kmem_cache_free: OK
[   15.284020] Testing event mm_page_free_direct: OK
[   15.301029] Testing event mm_pagevec_free: OK
[   15.317990] Testing event mm_page_alloc: OK
[   15.334914] Testing event mm_page_alloc_zone_locked: OK
[   15.352004] Testing event mm_page_pcpu_drain: OK
[   15.368961] Testing event mm_page_alloc_extfrag: OK
[   15.387034] Testing event mm_vmscan_kswapd_sleep: OK
[   15.404072] Testing event mm_vmscan_kswapd_wake: OK
[   15.420931] Testing event mm_vmscan_wakeup_kswapd: OK
[   15.438877] Testing event mm_vmscan_direct_reclaim_begin: OK
[   15.454936] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   15.471937] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   15.488904] Testing event mm_vmscan_direct_reclaim_end: OK
[   15.506991] Testing event mm_vmscan_memcg_reclaim_end: OK
[   15.524032] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   15.541012] Testing event mm_shrink_slab_start: OK
[   15.557869] Testing event mm_shrink_slab_end: OK
[   15.573899] Testing event mm_vmscan_lru_isolate: OK
[   15.590007] Testing event mm_vmscan_memcg_isolate: OK
[   15.606998] Testing event mm_vmscan_writepage: OK
[   15.624040] Testing event mm_vmscan_lru_shrink_inactive: OK
[   15.640999] Testing event replace_swap_token: OK
[   15.658039] Testing event put_swap_token: OK
[   15.674989] Testing event disable_swap_token: OK
[   15.692022] Testing event update_swap_token_priority: OK
[   15.709075] Testing event cpu_idle: OK
[   15.725976] Testing event cpu_frequency: OK
[   15.742949] Testing event machine_suspend: OK
[   15.760078] Testing event power_start: OK
[   15.777013] Testing event power_frequency: OK
[   15.794998] Testing event power_end: OK
[   15.812003] Testing event clock_enable: OK
[   15.828940] Testing event clock_disable: OK
[   15.845894] Testing event clock_set_rate: OK
[   15.862847] Testing event power_domain_target: OK
[   15.880019] Testing event ftrace_test_filter: OK
[   15.897918] Testing event module_load: OK
[   15.914889] Testing event module_free: OK
[   15.931864] Testing event module_get: OK
[   15.947975] Testing event module_put: OK
[   15.965952] Testing event module_request: OK
[   15.981983] Testing event lock_acquire: OK
[   15.999118] Testing event lock_release: OK
[   16.016957] Testing event lock_contended: OK
[   16.033871] Testing event lock_acquired: OK
[   16.050035] Testing event rcu_utilization: OK
[   16.067931] Testing event rcu_grace_period: OK
[   16.083892] Testing event rcu_grace_period_init: OK
[   16.100073] Testing event rcu_preempt_task: OK
[   16.118974] Testing event rcu_unlock_preempted_task: OK
[   16.137004] Testing event rcu_quiescent_state_report: OK
[   16.153905] Testing event rcu_fqs: OK
[   16.170028] Testing event rcu_dyntick: OK
[   16.187056] Testing event rcu_callback: OK
[   16.204037] Testing event rcu_kfree_callback: OK
[   16.221982] Testing event rcu_batch_start: OK
[   16.239980] Testing event rcu_invoke_callback: OK
[   16.258034] Testing event rcu_invoke_kfree_callback: OK
[   16.276967] Testing event rcu_batch_end: OK
[   16.295028] Testing event rcu_torture_read: OK
[   16.312909] Testing event workqueue_queue_work: OK
[   16.329932] Testing event workqueue_activate_work: OK
[   16.348964] Testing event workqueue_execute_start: OK
[   16.367030] Testing event workqueue_execute_end: OK
[   16.383974] Testing event signal_generate: OK
[   16.400967] Testing event signal_deliver: OK
[   16.420036] Testing event signal_overflow_fail: OK
[   16.437015] Testing event signal_lose_info: OK
[   16.454093] Testing event timer_init: OK
[   16.471045] Testing event timer_start: OK
[   16.487998] Testing event timer_expire_entry: OK
[   16.505102] Testing event timer_expire_exit: OK
[   16.525042] Testing event timer_cancel: OK
[   16.542043] Testing event hrtimer_init: OK
[   16.560057] Testing event hrtimer_start: OK
[   16.577925] Testing event hrtimer_expire_entry: OK
[   16.594080] Testing event hrtimer_expire_exit: OK
[   16.611078] Testing event hrtimer_cancel: OK
[   16.628040] Testing event itimer_state: OK
[   16.647112] Testing event itimer_expire: OK
[   16.664036] Testing event irq_handler_entry: OK
[   16.681018] Testing event irq_handler_exit: OK
[   16.698051] Testing event softirq_entry: OK
[   16.715029] Testing event softirq_exit: OK
[   16.732111] Testing event softirq_raise: OK
[   16.750167] Testing event sched_kthread_stop: OK
[   16.767916] Testing event sched_kthread_stop_ret: OK
[   16.783894] Testing event sched_wakeup: OK
[   16.799917] Testing event sched_wakeup_new: OK
[   16.815929] Testing event sched_switch: OK
[   16.831896] Testing event sched_migrate_task: OK
[   16.847924] Testing event sched_process_free: OK
[   16.863895] Testing event sched_process_exit: OK
[   16.881987] Testing event sched_wait_task: OK
[   16.901063] Testing event sched_process_wait: OK
[   16.917935] Testing event sched_process_fork: OK
[   16.935095] Testing event sched_stat_wait: OK
[   16.953099] Testing event sched_stat_sleep: OK
[   16.970093] Testing event sched_stat_iowait: OK
[   16.987064] Testing event sched_stat_runtime: OK
[   17.004030] Testing event sched_pi_setprio: OK
[   17.021056] Testing event mce_record: OK
[   17.037905] Testing event sys_enter: OK
[   17.056038] Testing event sys_exit: OK
[   17.074128] Testing event emulate_vsyscall: OK
[   17.091078] Testing event kvm_mmu_pagetable_walk: OK
[   17.109108] Testing event kvm_mmu_paging_element: OK
[   17.126082] Testing event kvm_mmu_set_accessed_bit: OK
[   17.143057] Testing event kvm_mmu_set_dirty_bit: OK
[   17.159944] Testing event kvm_mmu_walker_error: OK
[   17.177080] Testing event kvm_mmu_get_page: OK
[   17.193946] Testing event kvm_mmu_sync_page: OK
[   17.210068] Testing event kvm_mmu_unsync_page: OK
[   17.227950] Testing event kvm_mmu_prepare_zap_page: OK
[   17.244029] Testing event kvm_mmu_delay_free_pages: OK
[   17.260980] Testing event mark_mmio_spte: OK
[   17.277090] Testing event handle_mmio_page_fault: OK
[   17.294076] Testing event kvm_mmu_audit: OK
[   17.310979] Testing event kvm_entry: OK
[   17.327063] Testing event kvm_hypercall: OK
[   17.343882] Testing event kvm_hv_hypercall: OK
[   17.360130] Testing event kvm_pio: OK
[   17.377063] Testing event kvm_cpuid: OK
[   17.394051] Testing event kvm_apic: OK
[   17.411004] Testing event kvm_exit: OK
[   17.427004] Testing event kvm_inj_virq: OK
[   17.443059] Testing event kvm_inj_exception: OK
[   17.460079] Testing event kvm_page_fault: OK
[   17.476960] Testing event kvm_msr: OK
[   17.493023] Testing event kvm_cr: OK
[   17.510001] Testing event kvm_pic_set_irq: OK
[   17.526957] Testing event kvm_apic_ipi: OK
[   17.544124] Testing event kvm_apic_accept_irq: OK
[   17.562151] Testing event kvm_nested_vmrun: OK
[   17.579101] Testing event kvm_nested_intercepts: OK
[   17.596109] Testing event kvm_nested_vmexit: OK
[   17.612985] Testing event kvm_nested_vmexit_inject: OK
[   17.630106] Testing event kvm_nested_intr_vmexit: OK
[   17.647071] Testing event kvm_invlpga: OK
[   17.664112] Testing event kvm_skinit: OK
[   17.680946] Testing event kvm_emulate_insn: OK
[   17.698110] Testing event vcpu_match_mmio: OK
[   17.714962] Testing event kvm_userspace_exit: OK
[   17.732135] Testing event kvm_set_irq: OK
[   17.750015] Testing event kvm_ioapic_set_irq: OK
[   17.767095] Testing event kvm_msi_set_irq: OK
[   17.784079] Testing event kvm_ack_irq: OK
[   17.801067] Testing event kvm_mmio: OK
[   17.819047] Testing event kvm_fpu: OK
[   17.836032] Testing event kvm_age_page: OK
[   17.854029] Testing event kvm_try_async_get_page: OK
[   17.871112] Testing event kvm_async_pf_doublefault: OK
[   17.888034] Testing event kvm_async_pf_not_present: OK
[   17.908097] Testing event kvm_async_pf_ready: OK
[   17.926017] Testing event kvm_async_pf_completed: OK
[   17.943068] Running tests on trace event systems:
[   17.943393] Testing event system skb: OK
[   17.960227] Testing event system net: OK
[   17.978148] Testing event system napi: OK
[   17.997149] Testing event system sock: OK
[   18.015054] Testing event system udp: OK
[   18.031991] Testing event system hda: OK
[   18.051325] Testing event system scsi: OK
[   18.070084] Testing event system i915: OK
[   18.088012] Testing event system drm: OK
[   18.105131] Testing event system block: OK
[   18.123712] Testing event system btrfs: OK
[   18.142959] Testing event system xfs: OK
[   18.192891] Testing event system jbd2: OK
[   18.210438] Testing event system jbd: OK
[   18.227430] Testing event system ext4: OK
[   18.250747] Testing event system ext3: OK
[   18.271677] Testing event system writeback: OK
[   18.292068] Testing event system kmem: OK
[   18.309655] Testing event system vmscan: OK
[   18.327809] Testing event system power: OK
[   18.345553] Testing event system test: OK
[   18.362040] Testing event system module: OK
[   18.379219] Testing event system lock: OK
[   18.396229] Testing event system rcu: OK
[   18.413678] Testing event system workqueue: OK
[   18.430223] Testing event system signal: OK
[   18.447227] Testing event system timer: OK
[   18.464475] Testing event system irq: OK
[   18.483217] Testing event system sched: OK
[   18.502794] Testing event system mce: OK
[   18.519117] Testing event system raw_syscalls: OK
[   18.537107] Testing event system vsyscall: OK
[   18.556060] Testing event system syscalls: OK
[   18.575498] Testing event system kvmmmu: OK
[   18.592593] Testing event system kvm: OK
[   18.612644] Running tests on all trace events:
[   18.612959] Testing all events: OK
[   18.754777] Running tests again, along with the function tracer
[   18.755238] Running tests on trace events:
[   18.755614] Testing event kfree_skb: OK
[   18.773649] Testing event consume_skb: OK
[   18.791554] Testing event skb_copy_datagram_iovec: OK
[   18.809571] Testing event net_dev_xmit: OK
[   18.829704] Testing event net_dev_queue: OK
[   18.849596] Testing event netif_receive_skb: OK
[   18.869655] Testing event netif_rx: OK
[   18.888640] Testing event napi_poll: OK
[   18.906560] Testing event sock_rcvqueue_full: OK
[   18.924639] Testing event sock_exceed_buf_limit: OK
[   18.942658] Testing event udp_fail_queue_rcv_skb: OK
[   18.960553] Testing event hda_send_cmd: OK
[   18.978679] Testing event hda_get_response: OK
[   18.997417] Testing event hda_bus_reset: OK
[   19.016708] Testing event hda_power_down: OK
[   19.035376] Testing event hda_power_up: OK
[   19.052615] Testing event hda_unsol_event: OK
[   19.070655] Testing event scsi_dispatch_cmd_start: OK
[   19.088684] Testing event scsi_dispatch_cmd_error: OK
[   19.106599] Testing event scsi_dispatch_cmd_done: OK
[   19.124408] Testing event scsi_dispatch_cmd_timeout: OK
[   19.143582] Testing event scsi_eh_wakeup: OK
[   19.161652] Testing event i915_gem_object_create: OK
[   19.180411] Testing event i915_gem_object_bind: OK
[   19.197648] Testing event i915_gem_object_unbind: OK
[   19.216595] Testing event i915_gem_object_change_domain: OK
[   19.234628] Testing event i915_gem_object_pwrite: OK
[   19.253677] Testing event i915_gem_object_pread: OK
[   19.271645] Testing event i915_gem_object_fault: OK
[   19.289645] Testing event i915_gem_object_clflush: OK
[   19.307657] Testing event i915_gem_object_destroy: OK
[   19.325658] Testing event i915_gem_evict: OK
[   19.343722] Testing event i915_gem_evict_everything: OK
[   19.361684] Testing event i915_gem_ring_dispatch: OK
[   19.379724] Testing event i915_gem_ring_flush: OK
[   19.397665] Testing event i915_gem_request_add: OK
[   19.415669] Testing event i915_gem_request_complete: OK
[   19.433619] Testing event i915_gem_request_retire: OK
[   19.451576] Testing event i915_gem_request_wait_begin: OK
[   19.469686] Testing event i915_gem_request_wait_end: OK
[   19.487655] Testing event i915_ring_wait_begin: OK
[   19.505692] Testing event i915_ring_wait_end: OK
[   19.523700] Testing event i915_flip_request: OK
[   19.541660] Testing event i915_flip_complete: OK
[   19.559659] Testing event i915_reg_rw: OK
[   19.577640] Testing event drm_vblank_event: OK
[   19.594575] Testing event drm_vblank_event_queued: OK
[   19.612580] Testing event drm_vblank_event_delivered: OK
[   19.630609] Testing event block_rq_abort: OK
[   19.648673] Testing event block_rq_requeue: OK
[   19.666654] Testing event block_rq_complete: OK
[   19.684669] Testing event block_rq_insert: OK
[   19.701543] Testing event block_rq_issue: OK
[   19.718542] Testing event block_bio_bounce: OK
[   19.735697] Testing event block_bio_complete: OK
[   19.753678] Testing event block_bio_backmerge: OK
[   19.772696] Testing event block_bio_frontmerge: OK
[   19.794690] Testing event block_bio_queue: OK
[   19.812603] Testing event block_getrq: OK
[   19.832699] Testing event block_sleeprq: OK
[   19.852411] Testing event block_plug: OK
[   19.871652] Testing event block_unplug: OK
[   19.890717] Testing event block_split: OK
[   19.908452] Testing event block_bio_remap: OK
[   19.927628] Testing event block_rq_remap: OK
[   19.945716] Testing event btrfs_transaction_commit: OK
[   19.963435] Testing event btrfs_inode_new: OK
[   19.980656] Testing event btrfs_inode_request: OK
[   19.999641] Testing event btrfs_inode_evict: OK
[   20.017397] Testing event btrfs_get_extent: OK
[   20.034705] Testing event btrfs_ordered_extent_add: OK
[   20.052417] Testing event btrfs_ordered_extent_remove: OK
[   20.069700] Testing event btrfs_ordered_extent_start: OK
[   20.087703] Testing event btrfs_ordered_extent_put: OK
[   20.105451] Testing event btrfs_finish_ordered_io: OK
[   20.122520] Testing event __extent_writepage: OK
[   20.139474] Testing event btrfs_writepage_end_io_hook: OK
[   20.156391] Testing event btrfs_sync_file: OK
[   20.173721] Testing event btrfs_sync_fs: OK
[   20.191687] Testing event btrfs_delayed_tree_ref: OK
[   20.209704] Testing event btrfs_delayed_data_ref: OK
[   20.227605] Testing event btrfs_delayed_ref_head: OK
[   20.245617] Testing event btrfs_chunk_alloc: OK
[   20.265698] Testing event btrfs_chunk_free: OK
[   20.284699] Testing event btrfs_cow_block: OK
[   20.302374] Testing event btrfs_reserved_extent_alloc: OK
[   20.319756] Testing event btrfs_reserved_extent_free: OK
[   20.337706] Testing event xfs_attr_list_sf: OK
[   20.355616] Testing event xfs_attr_list_sf_all: OK
[   20.372693] Testing event xfs_attr_list_leaf: OK
[   20.390706] Testing event xfs_attr_list_leaf_end: OK
[   20.408748] Testing event xfs_attr_list_full: OK
[   20.426750] Testing event xfs_attr_list_add: OK
[   20.444619] Testing event xfs_attr_list_wrong_blk: OK
[   20.462625] Testing event xfs_attr_list_notfound: OK
[   20.482716] Testing event xfs_perag_get: OK
[   20.501745] Testing event xfs_perag_get_tag: OK
[   20.519580] Testing event xfs_perag_put: OK
[   20.537633] Testing event xfs_perag_set_reclaim: OK
[   20.555755] Testing event xfs_perag_clear_reclaim: OK
[   20.574725] Testing event xfs_attr_list_node_descend: OK
[   20.592769] Testing event xfs_iext_insert: OK
[   20.610762] Testing event xfs_iext_remove: OK
[   20.628686] Testing event xfs_bmap_pre_update: OK
[   20.647730] Testing event xfs_bmap_post_update: OK
[   20.666698] Testing event xfs_extlist: OK
[   20.684700] Testing event xfs_buf_init: OK
[   20.702730] Testing event xfs_buf_free: OK
[   20.720722] Testing event xfs_buf_hold: OK
[   20.738709] Testing event xfs_buf_rele: OK
[   20.756762] Testing event xfs_buf_iodone: OK
[   20.774711] Testing event xfs_buf_iorequest: OK
[   20.792723] Testing event xfs_buf_bawrite: OK
[   20.810717] Testing event xfs_buf_lock: OK
[   20.828720] Testing event xfs_buf_lock_done: OK
[   20.846739] Testing event xfs_buf_trylock: OK
[   20.864518] Testing event xfs_buf_unlock: OK
[   20.881773] Testing event xfs_buf_iowait: OK
[   20.899754] Testing event xfs_buf_iowait_done: OK
[   20.919717] Testing event xfs_buf_delwri_queue: OK
[   20.938730] Testing event xfs_buf_delwri_dequeue: OK
[   20.956745] Testing event xfs_buf_delwri_split: OK
[   20.974633] Testing event xfs_buf_get_uncached: OK
[   20.992630] Testing event xfs_bdstrat_shut: OK
[   21.010792] Testing event xfs_buf_item_relse: OK
[   21.028592] Testing event xfs_buf_item_iodone: OK
[   21.045692] Testing event xfs_buf_item_iodone_async: OK
[   21.064706] Testing event xfs_buf_error_relse: OK
[   21.082714] Testing event xfs_trans_read_buf_io: OK
[   21.100707] Testing event xfs_trans_read_buf_shut: OK
[   21.118724] Testing event xfs_btree_corrupt: OK
[   21.136474] Testing event xfs_da_btree_corrupt: OK
[   21.153687] Testing event xfs_reset_dqcounts: OK
[   21.171765] Testing event xfs_inode_item_push: OK
[   21.189786] Testing event xfs_buf_find: OK
[   21.207724] Testing event xfs_buf_get: OK
[   21.225741] Testing event xfs_buf_read: OK
[   21.243706] Testing event xfs_buf_ioerror: OK
[   21.261775] Testing event xfs_buf_item_size: OK
[   21.279733] Testing event xfs_buf_item_size_stale: OK
[   21.297684] Testing event xfs_buf_item_format: OK
[   21.315607] Testing event xfs_buf_item_format_stale: OK
[   21.333738] Testing event xfs_buf_item_pin: OK
[   21.351781] Testing event xfs_buf_item_unpin: OK
[   21.369677] Testing event xfs_buf_item_unpin_stale: OK
[   21.387778] Testing event xfs_buf_item_trylock: OK
[   21.405579] Testing event xfs_buf_item_unlock: OK
[   21.422698] Testing event xfs_buf_item_unlock_stale: OK
[   21.440611] Testing event xfs_buf_item_committed: OK
[   21.458705] Testing event xfs_buf_item_push: OK
[   21.476731] Testing event xfs_buf_item_pushbuf: OK
[   21.494706] Testing event xfs_trans_get_buf: OK
[   21.513696] Testing event xfs_trans_get_buf_recur: OK
[   21.531738] Testing event xfs_trans_getsb: OK
[   21.549541] Testing event xfs_trans_getsb_recur: OK
[   21.566693] Testing event xfs_trans_read_buf: OK
[   21.584729] Testing event xfs_trans_read_buf_recur: OK
[   21.602736] Testing event xfs_trans_log_buf: OK
[   21.621788] Testing event xfs_trans_brelse: OK
[   21.639723] Testing event xfs_trans_bjoin: OK
[   21.657767] Testing event xfs_trans_bhold: OK
[   21.675796] Testing event xfs_trans_bhold_release: OK
[   21.693674] Testing event xfs_trans_binval: OK
[   21.711724] Testing event xfs_ilock: OK
[   21.729684] Testing event xfs_ilock_nowait: OK
[   21.747662] Testing event xfs_ilock_demote: OK
[   21.765676] Testing event xfs_iunlock: OK
[   21.785665] Testing event xfs_iget_skip: OK
[   21.803800] Testing event xfs_iget_reclaim: OK
[   21.822670] Testing event xfs_iget_reclaim_fail: OK
[   21.842744] Testing event xfs_iget_hit: OK
[   21.862762] Testing event xfs_iget_miss: OK
[   21.881490] Testing event xfs_getattr: OK
[   21.900757] Testing event xfs_setattr: OK
[   21.918751] Testing event xfs_readlink: OK
[   21.936784] Testing event xfs_alloc_file_space: OK
[   21.954789] Testing event xfs_free_file_space: OK
[   21.972718] Testing event xfs_readdir: OK
[   21.990829] Testing event xfs_get_acl: OK
[   22.008737] Testing event xfs_vm_bmap: OK
[   22.026766] Testing event xfs_file_ioctl: OK
[   22.044864] Testing event xfs_file_compat_ioctl: OK
[   22.062802] Testing event xfs_ioctl_setattr: OK
[   22.080829] Testing event xfs_dir_fsync: OK
[   22.098826] Testing event xfs_file_fsync: OK
[   22.116771] Testing event xfs_destroy_inode: OK
[   22.134754] Testing event xfs_write_inode: OK
[   22.152601] Testing event xfs_evict_inode: OK
[   22.169755] Testing event xfs_dquot_dqalloc: OK
[   22.187804] Testing event xfs_dquot_dqdetach: OK
[   22.205747] Testing event xfs_ihold: OK
[   22.223754] Testing event xfs_irele: OK
[   22.243762] Testing event xfs_inode_pin: OK
[   22.262857] Testing event xfs_inode_unpin: OK
[   22.281754] Testing event xfs_inode_unpin_nowait: OK
[   22.299812] Testing event xfs_remove: OK
[   22.318717] Testing event xfs_link: OK
[   22.336800] Testing event xfs_lookup: OK
[   22.354498] Testing event xfs_create: OK
[   22.373727] Testing event xfs_symlink: OK
[   22.393793] Testing event xfs_rename: OK
[   22.411479] Testing event xfs_dqadjust: OK
[   22.428472] Testing event xfs_dqreclaim_want: OK
[   22.445447] Testing event xfs_dqreclaim_dirty: OK
[   22.462545] Testing event xfs_dqreclaim_unlink: OK
[   22.481777] Testing event xfs_dqattach_found: OK
[   22.499752] Testing event xfs_dqattach_get: OK
[   22.517766] Testing event xfs_dqinit: OK
[   22.535727] Testing event xfs_dqreuse: OK
[   22.553709] Testing event xfs_dqalloc: OK
[   22.571435] Testing event xfs_dqtobp_read: OK
[   22.588473] Testing event xfs_dqread: OK
[   22.605521] Testing event xfs_dqread_fail: OK
[   22.622483] Testing event xfs_dqlookup_found: OK
[   22.639553] Testing event xfs_dqlookup_want: OK
[   22.656534] Testing event xfs_dqlookup_freelist: OK
[   22.673461] Testing event xfs_dqlookup_done: OK
[   22.692807] Testing event xfs_dqget_hit: OK
[   22.711771] Testing event xfs_dqget_miss: OK
[   22.729790] Testing event xfs_dqput: OK
[   22.748769] Testing event xfs_dqput_wait: OK
[   22.766819] Testing event xfs_dqput_free: OK
[   22.784734] Testing event xfs_dqrele: OK
[   22.802574] Testing event xfs_dqflush: OK
[   22.819450] Testing event xfs_dqflush_force: OK
[   22.836464] Testing event xfs_dqflush_done: OK
[   22.853496] Testing event xfs_log_done_nonperm: OK
[   22.872770] Testing event xfs_log_done_perm: OK
[   22.890766] Testing event xfs_log_reserve: OK
[   22.908843] Testing event xfs_log_umount_write: OK
[   22.926837] Testing event xfs_log_grant_enter: OK
[   22.944815] Testing event xfs_log_grant_exit: OK
[   22.962856] Testing event xfs_log_grant_error: OK
[   22.981821] Testing event xfs_log_grant_sleep1: OK
[   22.999656] Testing event xfs_log_grant_wake1: OK
[   23.016570] Testing event xfs_log_grant_sleep2: OK
[   23.033788] Testing event xfs_log_grant_wake2: OK
[   23.054735] Testing event xfs_log_grant_wake_up: OK
[   23.072854] Testing event xfs_log_regrant_write_enter: OK
[   23.090797] Testing event xfs_log_regrant_write_exit: OK
[   23.108792] Testing event xfs_log_regrant_write_error: OK
[   23.126816] Testing event xfs_log_regrant_write_sleep1: OK
[   23.144753] Testing event xfs_log_regrant_write_wake1: OK
[   23.162794] Testing event xfs_log_regrant_write_sleep2: OK
[   23.180850] Testing event xfs_log_regrant_write_wake2: OK
[   23.198781] Testing event xfs_log_regrant_write_wake_up: OK
[   23.216567] Testing event xfs_log_regrant_reserve_enter: OK
[   23.234737] Testing event xfs_log_regrant_reserve_exit: OK
[   23.253851] Testing event xfs_log_regrant_reserve_sub: OK
[   23.273820] Testing event xfs_log_ungrant_enter: OK
[   23.292806] Testing event xfs_log_ungrant_exit: OK
[   23.310777] Testing event xfs_log_ungrant_sub: OK
[   23.328808] Testing event xfs_ail_push: OK
[   23.346804] Testing event xfs_ail_pushbuf: OK
[   23.364841] Testing event xfs_ail_pushbuf_pinned: OK
[   23.382490] Testing event xfs_ail_pinned: OK
[   23.401745] Testing event xfs_ail_locked: OK
[   23.421862] Testing event xfs_file_read: OK
[   23.440469] Testing event xfs_file_buffered_write: OK
[   23.457533] Testing event xfs_file_direct_write: OK
[   23.474575] Testing event xfs_file_splice_read: OK
[   23.491528] Testing event xfs_file_splice_write: OK
[   23.508507] Testing event xfs_writepage: OK
[   23.525583] Testing event xfs_releasepage: OK
[   23.543797] Testing event xfs_invalidatepage: OK
[   23.561887] Testing event xfs_map_blocks_found: OK
[   23.579683] Testing event xfs_map_blocks_alloc: OK
[   23.597813] Testing event xfs_get_blocks_found: OK
[   23.617863] Testing event xfs_get_blocks_alloc: OK
[   23.637918] Testing event xfs_delalloc_enospc: OK
[   23.657866] Testing event xfs_unwritten_convert: OK
[   23.676861] Testing event xfs_get_blocks_notfound: OK
[   23.694770] Testing event xfs_setfilesize: OK
[   23.712588] Testing event xfs_itruncate_data_start: OK
[   23.729754] Testing event xfs_itruncate_data_end: OK
[   23.749803] Testing event xfs_pagecache_inval: OK
[   23.768691] Testing event xfs_bunmap: OK
[   23.785770] Testing event xfs_alloc_busy: OK
[   23.803866] Testing event xfs_alloc_busy_enomem: OK
[   23.821635] Testing event xfs_alloc_busy_force: OK
[   23.838808] Testing event xfs_alloc_busy_reuse: OK
[   23.856598] Testing event xfs_alloc_busy_clear: OK
[   23.874581] Testing event xfs_alloc_busy_trim: OK
[   23.891628] Testing event xfs_trans_commit_lsn: OK
[   23.908830] Testing event xfs_agf: OK
[   23.926502] Testing event xfs_free_extent: OK
[   23.943867] Testing event xfs_alloc_exact_done: OK
[   23.962863] Testing event xfs_alloc_exact_notfound: OK
[   23.980820] Testing event xfs_alloc_exact_error: OK
[   23.998847] Testing event xfs_alloc_near_nominleft: OK
[   24.016874] Testing event xfs_alloc_near_first: OK
[   24.034736] Testing event xfs_alloc_near_greater: OK
[   24.052530] Testing event xfs_alloc_near_lesser: OK
[   24.069803] Testing event xfs_alloc_near_error: OK
[   24.088586] Testing event xfs_alloc_near_noentry: OK
[   24.105806] Testing event xfs_alloc_near_busy: OK
[   24.123868] Testing event xfs_alloc_size_neither: OK
[   24.141797] Testing event xfs_alloc_size_noentry: OK
[   24.159830] Testing event xfs_alloc_size_nominleft: OK
[   24.177543] Testing event xfs_alloc_size_done: OK
[   24.194854] Testing event xfs_alloc_size_error: OK
[   24.212679] Testing event xfs_alloc_size_busy: OK
[   24.229811] Testing event xfs_alloc_small_freelist: OK
[   24.247856] Testing event xfs_alloc_small_notenough: OK
[   24.265892] Testing event xfs_alloc_small_done: OK
[   24.283836] Testing event xfs_alloc_small_error: OK
[   24.301834] Testing event xfs_alloc_vextent_badargs: OK
[   24.319759] Testing event xfs_alloc_vextent_nofix: OK
[   24.337851] Testing event xfs_alloc_vextent_noagbp: OK
[   24.355777] Testing event xfs_alloc_vextent_loopfailed: OK
[   24.373879] Testing event xfs_alloc_vextent_allfailed: OK
[   24.391709] Testing event xfs_dir2_sf_addname: OK
[   24.408794] Testing event xfs_dir2_sf_create: OK
[   24.426794] Testing event xfs_dir2_sf_lookup: OK
[   24.446745] Testing event xfs_dir2_sf_replace: OK
[   24.464885] Testing event xfs_dir2_sf_removename: OK
[   24.482818] Testing event xfs_dir2_sf_toino4: OK
[   24.500821] Testing event xfs_dir2_sf_toino8: OK
[   24.519717] Testing event xfs_dir2_sf_to_block: OK
[   24.537858] Testing event xfs_dir2_block_addname: OK
[   24.555871] Testing event xfs_dir2_block_lookup: OK
[   24.573686] Testing event xfs_dir2_block_replace: OK
[   24.590764] Testing event xfs_dir2_block_removename: OK
[   24.608866] Testing event xfs_dir2_block_to_sf: OK
[   24.626849] Testing event xfs_dir2_block_to_leaf: OK
[   24.644924] Testing event xfs_dir2_leaf_addname: OK
[   24.662894] Testing event xfs_dir2_leaf_lookup: OK
[   24.680773] Testing event xfs_dir2_leaf_replace: OK
[   24.698687] Testing event xfs_dir2_leaf_removename: OK
[   24.715763] Testing event xfs_dir2_leaf_to_block: OK
[   24.732831] Testing event xfs_dir2_leaf_to_node: OK
[   24.750848] Testing event xfs_dir2_node_addname: OK
[   24.770895] Testing event xfs_dir2_node_lookup: OK
[   24.790900] Testing event xfs_dir2_node_replace: OK
[   24.808926] Testing event xfs_dir2_node_removename: OK
[   24.827809] Testing event xfs_dir2_node_to_leaf: OK
[   24.845764] Testing event xfs_dir2_leafn_add: OK
[   24.864808] Testing event xfs_dir2_leafn_remove: OK
[   24.883582] Testing event xfs_dir2_grow_inode: OK
[   24.902538] Testing event xfs_dir2_shrink_inode: OK
[   24.921711] Testing event xfs_dir2_leafn_moveents: OK
[   24.941671] Testing event xfs_swap_extent_before: OK
[   24.959560] Testing event xfs_swap_extent_after: OK
[   24.976605] Testing event xfs_log_recover_item_add: OK
[   24.994591] Testing event xfs_log_recover_item_add_cont: OK
[   25.013655] Testing event xfs_log_recover_item_reorder_head: OK
[   25.031597] Testing event xfs_log_recover_item_reorder_tail: OK
[   25.050849] Testing event xfs_log_recover_item_recover: OK
[   25.068637] Testing event xfs_log_recover_buf_not_cancel: OK
[   25.086588] Testing event xfs_log_recover_buf_cancel: OK
[   25.105618] Testing event xfs_log_recover_buf_cancel_add: OK
[   25.122902] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   25.140671] Testing event xfs_log_recover_buf_recover: OK
[   25.157639] Testing event xfs_log_recover_buf_inode_buf: OK
[   25.174675] Testing event xfs_log_recover_buf_reg_buf: OK
[   25.191612] Testing event xfs_log_recover_buf_dquot_buf: OK
[   25.208851] Testing event xfs_log_recover_inode_recover: OK
[   25.226714] Testing event xfs_log_recover_inode_cancel: OK
[   25.244574] Testing event xfs_log_recover_inode_skip: OK
[   25.263584] Testing event xfs_discard_extent: OK
[   25.280912] Testing event xfs_discard_toosmall: OK
[   25.298723] Testing event xfs_discard_exclude: OK
[   25.317677] Testing event xfs_discard_busy: OK
[   25.334575] Testing event jbd2_checkpoint: OK
[   25.351594] Testing event jbd2_start_commit: OK
[   25.370876] Testing event jbd2_commit_locking: OK
[   25.390598] Testing event jbd2_commit_flushing: OK
[   25.407631] Testing event jbd2_commit_logging: OK
[   25.424802] Testing event jbd2_end_commit: OK
[   25.442845] Testing event jbd2_submit_inode_data: OK
[   25.462675] Testing event jbd2_run_stats: OK
[   25.482554] Testing event jbd2_checkpoint_stats: OK
[   25.499897] Testing event jbd2_cleanup_journal_tail: OK
[   25.518637] Testing event jbd_checkpoint: OK
[   25.535650] Testing event jbd_start_commit: OK
[   25.552788] Testing event jbd_commit_locking: OK
[   25.572897] Testing event jbd_commit_flushing: OK
[   25.592599] Testing event jbd_commit_logging: OK
[   25.611906] Testing event jbd_drop_transaction: OK
[   25.631603] Testing event jbd_end_commit: OK
[   25.650836] Testing event jbd_do_submit_data: OK
[   25.669593] Testing event jbd_cleanup_journal_tail: OK
[   25.686596] Testing event jbd_update_superblock_end: OK
[   25.703595] Testing event ext4_free_inode: OK
[   25.720876] Testing event ext4_request_inode: OK
[   25.738752] Testing event ext4_allocate_inode: OK
[   25.755635] Testing event ext4_evict_inode: OK
[   25.772653] Testing event ext4_drop_inode: OK
[   25.789656] Testing event ext4_mark_inode_dirty: OK
[   25.806692] Testing event ext4_begin_ordered_truncate: OK
[   25.823641] Testing event ext4_write_begin: OK
[   25.840901] Testing event ext4_da_write_begin: OK
[   25.858821] Testing event ext4_ordered_write_end: OK
[   25.876643] Testing event ext4_writeback_write_end: OK
[   25.893598] Testing event ext4_journalled_write_end: OK
[   25.910662] Testing event ext4_da_write_end: OK
[   25.929687] Testing event ext4_da_writepages: OK
[   25.946888] Testing event ext4_da_write_pages: OK
[   25.964663] Testing event ext4_da_writepages_result: OK
[   25.981636] Testing event ext4_writepage: OK
[   25.999603] Testing event ext4_readpage: OK
[   26.016897] Testing event ext4_releasepage: OK
[   26.034749] Testing event ext4_invalidatepage: OK
[   26.052696] Testing event ext4_discard_blocks: OK
[   26.070617] Testing event ext4_mb_new_inode_pa: OK
[   26.089699] Testing event ext4_mb_new_group_pa: OK
[   26.107929] Testing event ext4_mb_release_inode_pa: OK
[   26.127659] Testing event ext4_mb_release_group_pa: OK
[   26.146938] Testing event ext4_discard_preallocations: OK
[   26.164749] Testing event ext4_mb_discard_preallocations: OK
[   26.182624] Testing event ext4_request_blocks: OK
[   26.199667] Testing event ext4_allocate_blocks: OK
[   26.216872] Testing event ext4_free_blocks: OK
[   26.234932] Testing event ext4_sync_file_enter: OK
[   26.252738] Testing event ext4_sync_file_exit: OK
[   26.270614] Testing event ext4_sync_fs: OK
[   26.287955] Testing event ext4_alloc_da_blocks: OK
[   26.309759] Testing event ext4_mballoc_alloc: OK
[   26.326617] Testing event ext4_mballoc_prealloc: OK
[   26.343915] Testing event ext4_mballoc_discard: OK
[   26.361613] Testing event ext4_mballoc_free: OK
[   26.378885] Testing event ext4_forget: OK
[   26.397966] Testing event ext4_da_update_reserve_space: OK
[   26.415861] Testing event ext4_da_reserve_space: OK
[   26.433614] Testing event ext4_da_release_space: OK
[   26.450881] Testing event ext4_mb_bitmap_load: OK
[   26.468982] Testing event ext4_mb_buddy_bitmap_load: OK
[   26.488964] Testing event ext4_read_block_bitmap_load: OK
[   26.508963] Testing event ext4_load_inode_bitmap: OK
[   26.528910] Testing event ext4_direct_IO_enter: OK
[   26.547676] Testing event ext4_direct_IO_exit: OK
[   26.564589] Testing event ext4_fallocate_enter: OK
[   26.581940] Testing event ext4_fallocate_exit: OK
[   26.599936] Testing event ext4_unlink_enter: OK
[   26.617782] Testing event ext4_unlink_exit: OK
[   26.634963] Testing event ext4_truncate_enter: OK
[   26.652616] Testing event ext4_truncate_exit: OK
[   26.669854] Testing event ext4_ext_map_blocks_enter: OK
[   26.688905] Testing event ext4_ind_map_blocks_enter: OK
[   26.706973] Testing event ext4_ext_map_blocks_exit: OK
[   26.726648] Testing event ext4_ind_map_blocks_exit: OK
[   26.745977] Testing event ext4_ext_load_extent: OK
[   26.763952] Testing event ext4_load_inode: OK
[   26.781883] Testing event ext4_journal_start: OK
[   26.799856] Testing event ext4_trim_extent: OK
[   26.819586] Testing event ext4_trim_all_free: OK
[   26.838925] Testing event ext4_ext_handle_uninitialized_extents: OK
[   26.856745] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   26.873904] Testing event ext4_ext_put_in_cache: OK
[   26.891925] Testing event ext4_ext_in_cache: OK
[   26.909844] Testing event ext4_find_delalloc_range: OK
[   26.927849] Testing event ext4_get_reserved_cluster_alloc: OK
[   26.945653] Testing event ext4_ext_show_extent: OK
[   26.964914] Testing event ext4_remove_blocks: OK
[   26.983935] Testing event ext4_ext_rm_leaf: OK
[   27.001735] Testing event ext4_ext_rm_idx: OK
[   27.018751] Testing event ext4_ext_remove_space: OK
[   27.035736] Testing event ext4_ext_remove_space_done: OK
[   27.052707] Testing event ext3_free_inode: OK
[   27.071605] Testing event ext3_request_inode: OK
[   27.089643] Testing event ext3_allocate_inode: OK
[   27.106918] Testing event ext3_evict_inode: OK
[   27.124779] Testing event ext3_drop_inode: OK
[   27.141638] Testing event ext3_mark_inode_dirty: OK
[   27.158657] Testing event ext3_write_begin: OK
[   27.175671] Testing event ext3_ordered_write_end: OK
[   27.192634] Testing event ext3_writeback_write_end: OK
[   27.209889] Testing event ext3_journalled_write_end: OK
[   27.227979] Testing event ext3_ordered_writepage: OK
[   27.247932] Testing event ext3_writeback_writepage: OK
[   27.266649] Testing event ext3_journalled_writepage: OK
[   27.284015] Testing event ext3_readpage: OK
[   27.301705] Testing event ext3_releasepage: OK
[   27.318589] Testing event ext3_invalidatepage: OK
[   27.335906] Testing event ext3_discard_blocks: OK
[   27.353619] Testing event ext3_request_blocks: OK
[   27.370858] Testing event ext3_allocate_blocks: OK
[   27.388922] Testing event ext3_free_blocks: OK
[   27.405926] Testing event ext3_sync_file_enter: OK
[   27.423910] Testing event ext3_sync_file_exit: OK
[   27.442667] Testing event ext3_sync_fs: OK
[   27.459925] Testing event ext3_rsv_window_add: OK
[   27.477769] Testing event ext3_discard_reservation: OK
[   27.494996] Testing event ext3_alloc_new_reservation: OK
[   27.512753] Testing event ext3_reserved: OK
[   27.529774] Testing event ext3_forget: OK
[   27.546878] Testing event ext3_read_block_bitmap: OK
[   27.564723] Testing event ext3_direct_IO_enter: OK
[   27.581673] Testing event ext3_direct_IO_exit: OK
[   27.598757] Testing event ext3_unlink_enter: OK
[   27.615802] Testing event ext3_unlink_exit: OK
[   27.632746] Testing event ext3_truncate_enter: OK
[   27.649680] Testing event ext3_truncate_exit: OK
[   27.668995] Testing event ext3_get_blocks_enter: OK
[   27.689002] Testing event ext3_get_blocks_exit: OK
[   27.707675] Testing event ext3_load_inode: OK
[   27.725975] Testing event writeback_nothread: OK
[   27.743961] Testing event writeback_queue: OK
[   27.761690] Testing event writeback_exec: OK
[   27.778958] Testing event writeback_start: OK
[   27.796904] Testing event writeback_written: OK
[   27.814955] Testing event writeback_wait: OK
[   27.832915] Testing event writeback_pages_written: OK
[   27.850990] Testing event writeback_nowork: OK
[   27.869693] Testing event writeback_wake_background: OK
[   27.887004] Testing event writeback_wake_thread: OK
[   27.904976] Testing event writeback_wake_forker_thread: OK
[   27.922973] Testing event writeback_bdi_register: OK
[   27.940955] Testing event writeback_bdi_unregister: OK
[   27.958989] Testing event writeback_thread_start: OK
[   27.976691] Testing event writeback_thread_stop: OK
[   27.993924] Testing event wbc_writepage: OK
[   28.012036] Testing event writeback_queue_io: OK
[   28.029983] Testing event task_io: OK
[   28.047712] Testing event global_dirty_state: OK
[   28.064743] Testing event bdi_dirty_state: OK
[   28.083970] Testing event blkcg_dirty_ratelimit: OK
[   28.101930] Testing event bdi_dirty_ratelimit: OK
[   28.119979] Testing event balance_dirty_pages: OK
[   28.137985] Testing event writeback_congestion_wait: OK
[   28.155802] Testing event writeback_wait_iff_congested: OK
[   28.175016] Testing event writeback_single_inode_requeue: OK
[   28.195019] Testing event writeback_single_inode: OK
[   28.213758] Testing event kmalloc: OK
[   28.231999] Testing event kmem_cache_alloc: OK
[   28.250988] Testing event kmalloc_node: OK
[   28.269002] Testing event kmem_cache_alloc_node: OK
[   28.286987] Testing event kfree: OK
[   28.304653] Testing event kmem_cache_free: OK
[   28.322013] Testing event mm_page_free_direct: OK
[   28.340015] Testing event mm_pagevec_free: OK
[   28.358980] Testing event mm_page_alloc: OK
[   28.376928] Testing event mm_page_alloc_zone_locked: OK
[   28.395045] Testing event mm_page_pcpu_drain: OK
[   28.412982] Testing event mm_page_alloc_extfrag: OK
[   28.431043] Testing event mm_vmscan_kswapd_sleep: OK
[   28.448908] Testing event mm_vmscan_kswapd_wake: OK
[   28.465702] Testing event mm_vmscan_wakeup_kswapd: OK
[   28.482753] Testing event mm_vmscan_direct_reclaim_begin: OK
[   28.501048] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   28.521040] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   28.538934] Testing event mm_vmscan_direct_reclaim_end: OK
[   28.557035] Testing event mm_vmscan_memcg_reclaim_end: OK
[   28.574783] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   28.591673] Testing event mm_shrink_slab_start: OK
[   28.608788] Testing event mm_shrink_slab_end: OK
[   28.625679] Testing event mm_vmscan_lru_isolate: OK
[   28.642762] Testing event mm_vmscan_memcg_isolate: OK
[   28.660903] Testing event mm_vmscan_writepage: OK
[   28.677966] Testing event mm_vmscan_lru_shrink_inactive: OK
[   28.695962] Testing event replace_swap_token: OK
[   28.713941] Testing event put_swap_token: OK
[   28.732033] Testing event disable_swap_token: OK
[   28.750042] Testing event update_swap_token_priority: OK
[   28.767791] Testing event cpu_idle: OK
[   28.784705] Testing event cpu_frequency: OK
[   28.801768] Testing event machine_suspend: OK
[   28.818992] Testing event power_start: OK
[   28.837067] Testing event power_frequency: OK
[   28.854783] Testing event power_end: OK
[   28.871673] Testing event clock_enable: OK
[   28.888762] Testing event clock_disable: OK
[   28.905717] Testing event clock_set_rate: OK
[   28.922727] Testing event power_domain_target: OK
[   28.939689] Testing event ftrace_test_filter: OK
[   28.956775] Testing event module_load: OK
[   28.974985] Testing event module_free: OK
[   28.995002] Testing event module_get: OK
[   29.013051] Testing event module_put: OK
[   29.031098] Testing event module_request: OK
[   29.048705] Testing event lock_acquire: OK
[   29.065789] Testing event lock_release: OK
[   29.083968] Testing event lock_contended: OK
[   29.101876] Testing event lock_acquired: OK
[   29.118863] Testing event rcu_utilization: OK
[   29.136689] Testing event rcu_grace_period: OK
[   29.154073] Testing event rcu_grace_period_init: OK
[   29.171969] Testing event rcu_preempt_task: OK
[   29.190007] Testing event rcu_unlock_preempted_task: OK
[   29.208074] Testing event rcu_quiescent_state_report: OK
[   29.225710] Testing event rcu_fqs: OK
[   29.245025] Testing event rcu_dyntick: OK
[   29.265004] Testing event rcu_callback: OK
[   29.285061] Testing event rcu_kfree_callback: OK
[   29.305070] Testing event rcu_batch_start: OK
[   29.323730] Testing event rcu_invoke_callback: OK
[   29.343001] Testing event rcu_invoke_kfree_callback: OK
[   29.361862] Testing event rcu_batch_end: OK
[   29.378787] Testing event rcu_torture_read: OK
[   29.396072] Testing event workqueue_queue_work: OK
[   29.414048] Testing event workqueue_activate_work: OK
[   29.431787] Testing event workqueue_execute_start: OK
[   29.448749] Testing event workqueue_execute_end: OK
[   29.468040] Testing event signal_generate: OK
[   29.488019] Testing event signal_deliver: OK
[   29.505837] Testing event signal_overflow_fail: OK
[   29.523084] Testing event signal_lose_info: OK
[   29.543816] Testing event timer_init: OK
[   29.560991] Testing event timer_start: OK
[   29.580116] Testing event timer_expire_entry: OK
[   29.598098] Testing event timer_expire_exit: OK
[   29.615748] Testing event timer_cancel: OK
[   29.635068] Testing event hrtimer_init: OK
[   29.653862] Testing event hrtimer_start: OK
[   29.670987] Testing event hrtimer_expire_entry: OK
[   29.688957] Testing event hrtimer_expire_exit: OK
[   29.707077] Testing event hrtimer_cancel: OK
[   29.726075] Testing event itimer_state: OK
[   29.745017] Testing event itimer_expire: OK
[   29.763086] Testing event irq_handler_entry: OK
[   29.780979] Testing event irq_handler_exit: OK
[   29.798955] Testing event softirq_entry: OK
[   29.819058] Testing event softirq_exit: OK
[   29.838065] Testing event softirq_raise: OK
[   29.856072] Testing event sched_kthread_stop: OK
[   29.874022] Testing event sched_kthread_stop_ret: OK
[   29.892008] Testing event sched_wakeup: OK
[   29.910090] Testing event sched_wakeup_new: OK
[   29.928086] Testing event sched_switch: OK
[   29.946129] Testing event sched_migrate_task: OK
[   29.964107] Testing event sched_process_free: OK
[   29.983081] Testing event sched_process_exit: OK
[   30.003085] Testing event sched_wait_task: OK
[   30.022026] Testing event sched_process_wait: OK
[   30.040028] Testing event sched_process_fork: OK
[   30.058106] Testing event sched_stat_wait: OK
[   30.075979] Testing event sched_stat_sleep: OK
[   30.094103] Testing event sched_stat_iowait: OK
[   30.111868] Testing event sched_stat_runtime: OK
[   30.129001] Testing event sched_pi_setprio: OK
[   30.147046] Testing event mce_record: OK
[   30.165106] Testing event sys_enter: OK
[   30.183052] Testing event sys_exit: OK
[   30.201052] Testing event emulate_vsyscall: OK
[   30.219029] Testing event kvm_mmu_pagetable_walk: OK
[   30.237030] Testing event kvm_mmu_paging_element: OK
[   30.255036] Testing event kvm_mmu_set_accessed_bit: OK
[   30.273001] Testing event kvm_mmu_set_dirty_bit: OK
[   30.291091] Testing event kvm_mmu_walker_error: OK
[   30.309105] Testing event kvm_mmu_get_page: OK
[   30.326753] Testing event kvm_mmu_sync_page: OK
[   30.343825] Testing event kvm_mmu_unsync_page: OK
[   30.360812] Testing event kvm_mmu_prepare_zap_page: OK
[   30.378039] Testing event kvm_mmu_delay_free_pages: OK
[   30.396087] Testing event mark_mmio_spte: OK
[   30.414097] Testing event handle_mmio_page_fault: OK
[   30.433073] Testing event kvm_mmu_audit: OK
[   30.450876] Testing event kvm_entry: OK
[   30.468045] Testing event kvm_hypercall: OK
[   30.486058] Testing event kvm_hv_hypercall: OK
[   30.504065] Testing event kvm_pio: OK
[   30.522047] Testing event kvm_cpuid: OK
[   30.540036] Testing event kvm_apic: OK
[   30.557044] Testing event kvm_exit: OK
[   30.575030] Testing event kvm_inj_virq: OK
[   30.595088] Testing event kvm_inj_exception: OK
[   30.614051] Testing event kvm_page_fault: OK
[   30.634121] Testing event kvm_msr: OK
[   30.653091] Testing event kvm_cr: OK
[   30.673037] Testing event kvm_pic_set_irq: OK
[   30.691104] Testing event kvm_apic_ipi: OK
[   30.709090] Testing event kvm_apic_accept_irq: OK
[   30.727047] Testing event kvm_nested_vmrun: OK
[   30.745061] Testing event kvm_nested_intercepts: OK
[   30.765138] Testing event kvm_nested_vmexit: OK
[   30.784113] Testing event kvm_nested_vmexit_inject: OK
[   30.802028] Testing event kvm_nested_intr_vmexit: OK
[   30.820016] Testing event kvm_invlpga: OK
[   30.838089] Testing event kvm_skinit: OK
[   30.856021] Testing event kvm_emulate_insn: OK
[   30.874061] Testing event vcpu_match_mmio: OK
[   30.891994] Testing event kvm_userspace_exit: OK
[   30.912123] Testing event kvm_set_irq: OK
[   30.931024] Testing event kvm_ioapic_set_irq: OK
[   30.951094] Testing event kvm_msi_set_irq: OK
[   30.969925] Testing event kvm_ack_irq: OK
[   30.987043] Testing event kvm_mmio: OK
[   31.003790] Testing event kvm_fpu: OK
[   31.021128] Testing event kvm_age_page: OK
[   31.040100] Testing event kvm_try_async_get_page: OK
[   31.059127] Testing event kvm_async_pf_doublefault: OK
[   31.076992] Testing event kvm_async_pf_not_present: OK
[   31.094992] Testing event kvm_async_pf_ready: OK
[   31.113044] Testing event kvm_async_pf_completed: OK
[   31.131048] Running tests on trace event systems:
[   31.131459] Testing event system skb: OK
[   31.151319] Testing event system net: OK
[   31.171494] Testing event system napi: OK
[   31.189032] Testing event system sock: OK
[   31.207153] Testing event system udp: OK
[   31.225053] Testing event system hda: OK
[   31.245645] Testing event system scsi: OK
[   31.264538] Testing event system i915: OK
[   31.287747] Testing event system drm: OK
[   31.305328] Testing event system block: OK
[   31.327008] Testing event system btrfs: OK
[   31.351619] Testing event system xfs: OK
[   31.447603] Testing event system jbd2: OK
[   31.467085] Testing event system jbd: OK
[   31.488221] Testing event system ext4: OK
[   31.524375] Testing event system ext3: OK
[   31.550681] Testing event system writeback: OK
[   31.574244] Testing event system kmem: OK
[   31.596420] Testing event system vmscan: OK
[   31.619282] Testing event system power: OK
[   31.639253] Testing event system test: OK
[   31.657084] Testing event system module: OK
[   31.675555] Testing event system lock: OK
[   31.694099] Testing event system rcu: OK
[   31.714791] Testing event system workqueue: OK
[   31.734454] Testing event system signal: OK
[   31.752490] Testing event system timer: OK
[   31.772372] Testing event system irq: OK
[   31.790537] Testing event system sched: OK
[   31.813852] Testing event system mce: OK
[   31.832155] Testing event system raw_syscalls: OK
[   31.850240] Testing event system vsyscall: OK
[   31.868075] Testing event system syscalls: OK
[   31.887182] Testing event system kvmmmu: OK
[   31.907276] Testing event system kvm: OK
[   31.933655] Running tests on all trace events:
[   31.934079] Testing all events: OK
[   32.200947] Testing ftrace filter: OK
[   32.201733] Testing kprobe tracing: OK
[   32.238114]   Magic number: 3:406:956
[   32.238464] tty ptyzd: hash matches
[   32.238791] netconsole: local port 6665
[   32.239090] netconsole: local IP 10.0.0.0
[   32.239388] netconsole: interface 'eth0'
[   32.239683] netconsole: remote port 6666
[   32.239978] netconsole: remote IP 192.168.1.1
[   32.240292] netconsole: remote ethernet address 00:30:48:fe:19:95
[   32.240668] netconsole: device eth0 not up yet, forcing it
[   32.329536] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   32.380174] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   32.380812] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   35.248075] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   35.248926] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   35.254189] console [netcon0] enabled
[   35.254478] netconsole: network logging started
[   35.255109] rtc_cmos 00:02: setting system clock to 2011-11-02 22:54:57 UTC (1320274497)
[   35.270285] IP-Config: Complete:
[   35.270575]      device=eth0, addr=192.168.1.52, mask=255.255.255.0, gw=192.168.1.1,
[   35.271192]      host=fat, domain=, nis-domain=(none),
[   35.271595]      bootserver=192.168.1.11, rootserver=192.168.1.11, rootpath=
[   35.272673] md: Waiting for all devices to be available before autodetect
[   35.273100] md: If you don't use raid, use raid=noautodetect
[   35.274171] md: Autodetecting RAID arrays.
[   35.274494] md: Scanned 0 and added 0 devices.
[   35.274828] md: autorun ...
[   35.275098] md: ... autorun DONE.
[   36.284315] VFS: Mounted root (nfs filesystem) on device 0:16.
[   36.284746] debug: unmapping init memory ffffffff81f3e000..ffffffff821f2000
[   37.198498] stty used greatest stack depth: 4616 bytes left
[   37.274840] startpar used greatest stack depth: 3752 bytes left
[   37.320678] sed used greatest stack depth: 3672 bytes left
[   37.409707] S02hostname.sh used greatest stack depth: 3640 bytes left
[   37.473142] mountpoint used greatest stack depth: 3544 bytes left
[   38.586073] ifup used greatest stack depth: 3496 bytes left
[   39.898859] mkdir used greatest stack depth: 3368 bytes left
[   40.800678] EXT4-fs (sda5): recovery complete
[   40.801074] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   43.655369] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   43.656044] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   43.658480] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   43.659036] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   44.448843] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   44.457178] NFSD: starting 90-second grace period
[   45.393080] udevadm used greatest stack depth: 3304 bytes left
[   46.125563] eth0: no IPv6 routers present
[   47.024207] mount.nfs used greatest stack depth: 2632 bytes left
[   80.976905] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)

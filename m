Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1JaI0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 04:26:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:62732 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab1JaI0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 04:26:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,429,1315206000"; 
   d="gz'50?scan'50,208,50";a="68729330"
Date: Mon, 31 Oct 2011 16:26:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111031082634.GA10348@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paul,

I got two warnings in rcutree.c. The last working kernels are
linux-next 20111014 and linux v3.1.

[    0.194593] ------------[ cut here ]------------
[    0.194707] lockdep: fixing up alternatives.
[    0.194730]  #2
[    0.194731] smpboot cpu 2: start_ip = 97000
[    0.195737] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:444 rcu_idle_exit_common+0xd2/0x117()
[    0.196325] Hardware name:         
[    0.196603] Modules linked in:
[    0.196899] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-ioless-full-next-20111025+ #881
[    0.197459] Call Trace:
[    0.197699]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    0.201075]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
[    0.201438]  [<ffffffff810d5afd>] rcu_idle_exit_common+0xd2/0x117
[    0.201812]  [<ffffffff810d5fff>] rcu_irq_enter+0x75/0xa2
[    0.202160]  [<ffffffff8107ac7f>] irq_enter+0x1b/0x74
[    0.202496]  [<ffffffff8106f29e>] scheduler_ipi+0x5e/0xd5
[    0.202845]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
[    0.203229]  [<ffffffff8198bb73>] reschedule_interrupt+0x73/0x80
[    0.203598]  <EOI>  [<ffffffff8198661f>] ? notifier_call_chain+0x63/0x63
[    0.204030]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
[    0.204378]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
[    0.204727]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
[    0.205068]  [<ffffffff81978bd5>] start_secondary+0x1de/0x1e2
[    0.205454] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.205774] Dumping ftrace buffer:
[    0.205806] masked ExtINT on CPU#2
[    0.206327]    (ftrace buffer empty)
[    0.206611] ------------[ cut here ]------------
[    0.206931] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:359 rcu_idle_enter_common+0xb3/0x130()
[    0.207521] Hardware name:         
[    0.207797] Modules linked in:
[    0.208093] Pid: 0, comm: kworker/0:0 Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
[    0.208683] Call Trace:
[    0.208921]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    0.209350]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
[    0.209713]  [<ffffffff810d5bf5>] rcu_idle_enter_common+0xb3/0x130
[    0.210091]  [<ffffffff810d5eb8>] rcu_irq_exit+0x6b/0x95
[    0.210436]  [<ffffffff8107ad88>] irq_exit+0xb0/0xb2
[    0.210769]  [<ffffffff8106f310>] scheduler_ipi+0xd0/0xd5
[    0.211118]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
[    0.211503]  [<ffffffff8198bb73>] reschedule_interrupt+0x73/0x80
[    0.211871]  <EOI>  [<ffffffff8198661f>] ? notifier_call_chain+0x63/0x63
[    0.212303]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
[    0.212651]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
[    0.213000]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
[    0.213331]  [<ffffffff81978bd5>] start_secondary+0x1de/0x1e2
[    0.213692] ---[ end trace 4eaa2a86a8e2da23 ]---

Below is the full dmesg. kconfig is also attached.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-ioless-full-next-20111025+ (wfg@bee) (gcc version 4.5.0 (GCC) ) #881 SMP Mon Oct 31 01:03:49 CST 2011
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
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff8800b7c00000 s1916992 r8192 d24512 u2097152
[    0.000000] pcpu-alloc: s1916992 r8192 d24512 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07 
[    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 771274
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hpet=disable run=/home/wfg/ioless-balance_dirty_pages/test-each-fs.sh log_buf_len=8M debug sched_debug apic=debug dynamic_printk drm.debug=6 sysrq_always_enabled panic=10 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 netconsole=@:/eth0,6666@192.168.1.1/00:30:48:fe:19:95 ip=192.168.1.52:192.168.1.11:192.168.1.1:255.255.255.0:fat:eth0:none nfsroot=192.168.1.11:/nfsroot/wfg,tcp,v3,nocto,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-3.1.0-ioless-full-next-20111025+ 
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 3012432k/3137536k available (9793k kernel code, 3396k absent, 121708k reserved, 5791k data, 2768k init)
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
[    0.002000] Detected 3200.599 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6401.19 BogoMIPS (lpj=3200599)
[    0.000703] pid_max: default: 32768 minimum: 301
[    0.001894] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003955] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004951] Mount-cache hash table entries: 256
[    0.005655] Initializing cgroup subsys debug
[    0.005963] Initializing cgroup subsys cpuacct
[    0.006294] Initializing cgroup subsys memory
[    0.006629] Initializing cgroup subsys devices
[    0.006943] Initializing cgroup subsys freezer
[    0.007267] Initializing cgroup subsys blkio
[    0.007629] CPU: Physical Processor ID: 0
[    0.007926] CPU: Processor Core ID: 0
[    0.008223] mce: CPU supports 9 MCE banks
[    0.008526] CPU0: Thermal monitoring enabled (TM1)
[    0.008862] using mwait in idle threads.
[    0.010012] ACPI: Core revision 20110623
[    0.021747] ftrace: allocating 38070 entries in 150 pages
[    0.030613] Getting VERSION: 60015
[    0.030889] Getting VERSION: 60015
[    0.031172] Getting ID: 0
[    0.031417] Getting ID: 0
[    0.031663] Switched APIC routing to physical flat.
[    0.031992] enabled ExtINT on CPU#0
[    0.032499] ENABLING IO-APIC IRQs
[    0.032771] init IO_APIC IRQs
[    0.033030]  apic 8 pin 0 not connected
[    0.033334] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.033897] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.034467] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.035029] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.035594] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.036158] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.036720] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.037286] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.037848] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.038413] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.038982] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.039553] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.040122] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.040689] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.041259] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.041824]  apic 8 pin 16 not connected
[    0.042120]  apic 8 pin 17 not connected
[    0.042412]  apic 8 pin 18 not connected
[    0.042705]  apic 8 pin 19 not connected
[    0.042998]  apic 8 pin 20 not connected
[    0.043294]  apic 8 pin 21 not connected
[    0.043587]  apic 8 pin 22 not connected
[    0.043880]  apic 8 pin 23 not connected
[    0.044309] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054651] CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
[    0.055132] Using local APIC timer interrupts.
[    0.055132] calibrating APIC timer ...
[    0.156670] ... lapic delta = 833239
[    0.156950] ... PM-Timer delta = 357901
[    0.157238] ... PM-Timer result ok
[    0.157512] ..... delta 833239
[    0.157772] ..... mult: 35792783
[    0.158040] ..... calibration result: 133318
[    0.158345] ..... CPU clock speed is 3199.0634 MHz.
[    0.158674] ..... host bus clock speed is 133.0318 MHz.
[    0.159028] Performance Events: PEBS fmt1+, erratum AAJ80 worked around, Nehalem events, Intel PMU driver.
[    0.159788] ... version:                3
[    0.160088] ... bit width:              48
[    0.160388] ... generic registers:      4
[    0.160685] ... value mask:             0000ffffffffffff
[    0.161032] ... max period:             000000007fffffff
[    0.161376] ... fixed-purpose events:   3
[    0.161674] ... event mask:             000000070000000f
[    0.162304] lockdep: fixing up alternatives.
[    0.162667] Booting Node   0, Processors  #1
[    0.162886] smpboot cpu 1: start_ip = 97000
[    0.174423] masked ExtINT on CPU#1
[    0.194593] ------------[ cut here ]------------
[    0.194707] lockdep: fixing up alternatives.
[    0.194730]  #2
[    0.194731] smpboot cpu 2: start_ip = 97000
[    0.195737] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:444 rcu_idle_exit_common+0xd2/0x117()
[    0.196325] Hardware name:         
[    0.196603] Modules linked in:
[    0.196899] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-ioless-full-next-20111025+ #881
[    0.197459] Call Trace:
[    0.197699]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    0.201075]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
[    0.201438]  [<ffffffff810d5afd>] rcu_idle_exit_common+0xd2/0x117
[    0.201812]  [<ffffffff810d5fff>] rcu_irq_enter+0x75/0xa2
[    0.202160]  [<ffffffff8107ac7f>] irq_enter+0x1b/0x74
[    0.202496]  [<ffffffff8106f29e>] scheduler_ipi+0x5e/0xd5
[    0.202845]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
[    0.203229]  [<ffffffff8198bb73>] reschedule_interrupt+0x73/0x80
[    0.203598]  <EOI>  [<ffffffff8198661f>] ? notifier_call_chain+0x63/0x63
[    0.204030]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
[    0.204378]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
[    0.204727]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
[    0.205068]  [<ffffffff81978bd5>] start_secondary+0x1de/0x1e2
[    0.205454] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.205774] Dumping ftrace buffer:
[    0.205806] masked ExtINT on CPU#2
[    0.206327]    (ftrace buffer empty)
[    0.206611] ------------[ cut here ]------------
[    0.206931] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:359 rcu_idle_enter_common+0xb3/0x130()
[    0.207521] Hardware name:         
[    0.207797] Modules linked in:
[    0.208093] Pid: 0, comm: kworker/0:0 Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
[    0.208683] Call Trace:
[    0.208921]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    0.209350]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
[    0.209713]  [<ffffffff810d5bf5>] rcu_idle_enter_common+0xb3/0x130
[    0.210091]  [<ffffffff810d5eb8>] rcu_irq_exit+0x6b/0x95
[    0.210436]  [<ffffffff8107ad88>] irq_exit+0xb0/0xb2
[    0.210769]  [<ffffffff8106f310>] scheduler_ipi+0xd0/0xd5
[    0.211118]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
[    0.211503]  [<ffffffff8198bb73>] reschedule_interrupt+0x73/0x80
[    0.211871]  <EOI>  [<ffffffff8198661f>] ? notifier_call_chain+0x63/0x63
[    0.212303]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
[    0.212651]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
[    0.213000]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
[    0.213331]  [<ffffffff81978bd5>] start_secondary+0x1de/0x1e2
[    0.213692] ---[ end trace 4eaa2a86a8e2da23 ]---
[    0.225972] lockdep: fixing up alternatives.
[    0.226304]  #3
[    0.226395] smpboot cpu 3: start_ip = 97000
[    0.237931] masked ExtINT on CPU#3
[    0.258195] lockdep: fixing up alternatives.
[    0.258529]  #4
[    0.258620] smpboot cpu 4: start_ip = 97000
[    0.270164] masked ExtINT on CPU#4
[    0.290438] lockdep: fixing up alternatives.
[    0.290774]  #5
[    0.290866] smpboot cpu 5: start_ip = 97000
[    0.302399] masked ExtINT on CPU#5
[    0.322667] lockdep: fixing up alternatives.
[    0.323002]  #6
[    0.323094] smpboot cpu 6: start_ip = 97000
[    0.334636] masked ExtINT on CPU#6
[    0.354901] lockdep: fixing up alternatives.
[    0.355236]  #7
[    0.355328] smpboot cpu 7: start_ip = 97000
[    0.366862] masked ExtINT on CPU#7
[    0.387025] Brought up 8 CPUs
[    0.387289] Total of 8 processors activated (51209.58 BogoMIPS).
[    0.391026] CPU0 attaching sched-domain:
[    0.391327]  domain 0: span 0,4 level SIBLING
[    0.391671]   groups: 0 (cpu_power = 589) 4 (cpu_power = 589)
[    0.392199]   domain 1: span 0-7 level MC
[    0.392533]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    0.393486] CPU1 attaching sched-domain:
[    0.393780]  domain 0: span 1,5 level SIBLING
[    0.394124]   groups: 1 (cpu_power = 589) 5 (cpu_power = 589)
[    0.394655]   domain 1: span 0-7 level MC
[    0.394985]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    0.395936] CPU2 attaching sched-domain:
[    0.396232]  domain 0: span 2,6 level SIBLING
[    0.396574]   groups: 2 (cpu_power = 589) 6 (cpu_power = 589)
[    0.397101]   domain 1: span 0-7 level MC
[    0.397433]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    0.398383] CPU3 attaching sched-domain:
[    0.398676]  domain 0: span 3,7 level SIBLING
[    0.399018]   groups: 3 (cpu_power = 589) 7 (cpu_power = 589)
[    0.399548]   domain 1: span 0-7 level MC
[    0.399878]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    0.400827] CPU4 attaching sched-domain:
[    0.401121]  domain 0: span 0,4 level SIBLING
[    0.401466]   groups: 4 (cpu_power = 589) 0 (cpu_power = 589)
[    0.401994]   domain 1: span 0-7 level MC
[    0.402326]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    0.403274] CPU5 attaching sched-domain:
[    0.403567]  domain 0: span 1,5 level SIBLING
[    0.403909]   groups: 5 (cpu_power = 589) 1 (cpu_power = 589)
[    0.404439]   domain 1: span 0-7 level MC
[    0.404768]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    0.405718] CPU6 attaching sched-domain:
[    0.406011]  domain 0: span 2,6 level SIBLING
[    0.406356]   groups: 6 (cpu_power = 589) 2 (cpu_power = 589)
[    0.406882]   domain 1: span 0-7 level MC
[    0.407214]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    0.408162] CPU7 attaching sched-domain:
[    0.408458]  domain 0: span 3,7 level SIBLING
[    0.408800]   groups: 7 (cpu_power = 589) 3 (cpu_power = 589)
[    0.409329]   domain 1: span 0-7 level MC
[    0.409658]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    0.411054] devtmpfs: initialized
[    0.412327] PM: Registering ACPI NVS region at bcde3000 (2195456 bytes)
[    0.412779] PM: Registering ACPI NVS region at bf714000 (700416 bytes)
[    0.413831] xor: automatically using best checksumming function: generic_sse
[    0.419141]    generic_sse: 11928.000 MB/sec
[    0.419448] xor: using function: generic_sse (11928.000 MB/sec)
[    0.419937] kworker/u:0 used greatest stack depth: 5608 bytes left
[    0.419965] RTC time: 15:08:07, date: 10/31/11
[    0.420049] NET: Registered protocol family 16
[    0.420946] kworker/u:0 used greatest stack depth: 5192 bytes left
[    0.421833] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.422388] ACPI: bus type pci registered
[    0.422885] dca service started, version 1.12.1
[    0.423285] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.423895] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.436051] PCI: Using configuration type 1 for base access
[    0.461151] bio: create slab <bio-0> at 0
[    0.477951] raid6: int64x1   3167 MB/s
[    0.494886] raid6: int64x2   3417 MB/s
[    0.511833] raid6: int64x4   2742 MB/s
[    0.528795] raid6: int64x8   2093 MB/s
[    0.545718] raid6: sse2x1    7921 MB/s
[    0.562653] raid6: sse2x2    9300 MB/s
[    0.579595] raid6: sse2x4   10710 MB/s
[    0.579882] raid6: using algorithm sse2x4 (10710 MB/s)
[    0.580304] ACPI: Added _OSI(Module Device)
[    0.580615] ACPI: Added _OSI(Processor Device)
[    0.580928] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.581251] ACPI: Added _OSI(Processor Aggregator Device)
[    0.585616] ACPI: EC: Look up EC in DSDT
[    0.606574] ACPI: Interpreter enabled
[    0.606860] ACPI: (supports S0 S1 S3 S4 S5)
[    0.607365] ACPI: Using IOAPIC for interrupt routing
[    0.620153] ACPI: No dock devices found.
[    0.620449] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.621650] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3d])
[    0.623257] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.623655] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.624047] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.624584] pci_root PNP0A03:00: host bridge window [mem 0x000c4000-0x000cbfff]
[    0.625118] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfedfffff]
[    0.625658] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xf7ffffff]
[    0.626213] pci 0000:00:00.0: [8086:3405] type 0 class 0x000600
[    0.626655] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    0.627078] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.627464] pci 0000:00:01.0: PME# disabled
[    0.627794] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    0.628219] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.628598] pci 0000:00:03.0: PME# disabled
[    0.628929] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    0.629354] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.629733] pci 0000:00:07.0: PME# disabled
[    0.630064] pci 0000:00:10.0: [8086:3425] type 0 class 0x000800
[    0.630515] pci 0000:00:10.1: [8086:3426] type 0 class 0x000800
[    0.630961] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    0.631404] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    0.631852] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    0.632292] pci 0000:00:14.3: [8086:3438] type 0 class 0x000800
[    0.632741] pci 0000:00:19.0: [8086:10cc] type 0 class 0x000200
[    0.633128] pci 0000:00:19.0: reg 10: [mem 0xe0300000-0xe031ffff]
[    0.633514] pci 0000:00:19.0: reg 14: [mem 0xe0323000-0xe0323fff]
[    0.633897] pci 0000:00:19.0: reg 18: [io  0x2100-0x211f]
[    0.634304] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.634685] pci 0000:00:19.0: PME# disabled
[    0.635008] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    0.635434] pci 0000:00:1a.0: reg 20: [io  0x20e0-0x20ff]
[    0.635836] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
[    0.636256] pci 0000:00:1a.1: reg 20: [io  0x20c0-0x20df]
[    0.636661] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    0.637080] pci 0000:00:1a.2: reg 20: [io  0x20a0-0x20bf]
[    0.640448] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    0.640836] pci 0000:00:1a.7: reg 10: [mem 0xe0322000-0xe03223ff]
[    0.641294] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.641673] pci 0000:00:1a.7: PME# disabled
[    0.642000] pci 0000:00:1b.0: [8086:3a3e] type 0 class 0x000403
[    0.642391] pci 0000:00:1b.0: reg 10: [mem 0xf7f00000-0xf7f03fff 64bit]
[    0.642853] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.643230] pci 0000:00:1b.0: PME# disabled
[    0.643557] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    0.643992] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.644369] pci 0000:00:1c.0: PME# disabled
[    0.644698] pci 0000:00:1c.1: [8086:3a42] type 1 class 0x000604
[    0.645135] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.645515] pci 0000:00:1c.1: PME# disabled
[    0.645843] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    0.646279] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.646662] pci 0000:00:1c.4: PME# disabled
[    0.646993] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    0.647416] pci 0000:00:1d.0: reg 20: [io  0x2080-0x209f]
[    0.647817] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    0.648237] pci 0000:00:1d.1: reg 20: [io  0x2060-0x207f]
[    0.648644] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    0.649063] pci 0000:00:1d.2: reg 20: [io  0x2040-0x205f]
[    0.649477] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    0.649865] pci 0000:00:1d.7: reg 10: [mem 0xe0321000-0xe03213ff]
[    0.650323] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.650704] pci 0000:00:1d.7: PME# disabled
[    0.651026] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.651471] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    0.651935] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.652317] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.652865] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
[    0.653457] pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
[    0.653844] pci 0000:00:1f.2: reg 10: [io  0x2128-0x212f]
[    0.654201] pci 0000:00:1f.2: reg 14: [io  0x2134-0x2137]
[    0.654560] pci 0000:00:1f.2: reg 18: [io  0x2120-0x2127]
[    0.654915] pci 0000:00:1f.2: reg 1c: [io  0x2130-0x2133]
[    0.655271] pci 0000:00:1f.2: reg 20: [io  0x2020-0x203f]
[    0.655630] pci 0000:00:1f.2: reg 24: [mem 0xe0320000-0xe03207ff]
[    0.656041] pci 0000:00:1f.2: PME# supported from D3hot
[    0.656389] pci 0000:00:1f.2: PME# disabled
[    0.656708] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    0.657093] pci 0000:00:1f.3: reg 10: [mem 0xf7f04000-0xf7f040ff 64bit]
[    0.657512] pci 0000:00:1f.3: reg 20: [io  0x2000-0x201f]
[    0.657934] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.658341] pci 0000:02:00.0: [5333:9043] type 0 class 0x000300
[    0.658718] pci 0000:02:00.0: reg 10: [mem 0xe0200000-0xe027ffff]
[    0.659099] pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff pref]
[    0.659527] pci 0000:02:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.659939] pci 0000:02:00.0: supports D1 D2
[    0.660270] pci 0000:02:00.1: [5333:903f] type 0 class 0x000403
[    0.660651] pci 0000:02:00.1: reg 10: [mem 0xe0280000-0xe0283fff]
[    0.661093] pci 0000:02:00.1: supports D1 D2
[    0.661421] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.661767] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.662171] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.662768] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.663168] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.663571] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    0.663997] pci 0000:06:00.0: [11ab:6121] type 0 class 0x000101
[    0.664390] pci 0000:06:00.0: reg 10: [io  0x1018-0x101f]
[    0.664753] pci 0000:06:00.0: reg 14: [io  0x1024-0x1027]
[    0.665117] pci 0000:06:00.0: reg 18: [io  0x1010-0x1017]
[    0.665483] pci 0000:06:00.0: reg 1c: [io  0x1020-0x1023]
[    0.665847] pci 0000:06:00.0: reg 20: [io  0x1000-0x100f]
[    0.666212] pci 0000:06:00.0: reg 24: [mem 0xe0100000-0xe01003ff]
[    0.666652] pci 0000:06:00.0: supports D1
[    0.666950] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
[    0.667320] pci 0000:06:00.0: PME# disabled
[    0.667644] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.667988] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.668369] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.668814] pci 0000:07:03.0: [104c:8023] type 0 class 0x000c00
[    0.669200] pci 0000:07:03.0: reg 10: [mem 0xe0004000-0xe00047ff]
[    0.669587] pci 0000:07:03.0: reg 14: [mem 0xe0000000-0xe0003fff]
[    0.670034] pci 0000:07:03.0: supports D1 D2
[    0.670342] pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
[    0.670715] pci 0000:07:03.0: PME# disabled
[    0.671072] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.671488] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.671892] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.672451] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.673007] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.673591] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000cbfff] (subtractive decode)
[    0.674173] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    0.674757] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xf7ffffff] (subtractive decode)
[    0.675377] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.676647] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.677268] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
[    0.677737] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
[    0.678202] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
[    0.678669] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.679133] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.679611] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.680169]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
[    0.703276] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.704353] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.705428] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.706501] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.707576] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.708654] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.709729] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.710802] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.712112] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.712688] vgaarb: loaded
[    0.712940] vgaarb: bridge control possible 0000:02:00.0
[    0.713499] SCSI subsystem initialized
[    0.713965] libata version 3.00 loaded.
[    0.714528] usbcore: registered new interface driver usbfs
[    0.714943] usbcore: registered new interface driver hub
[    0.715368] usbcore: registered new device driver usb
[    0.716158] wmi: Mapper loaded
[    0.716485] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.716869] PCI: Using ACPI for IRQ routing
[    0.718743] PCI: Discovered peer bus 3f
[    0.719121] pci 0000:3f:00.0: [8086:2c41] type 0 class 0x000600
[    0.719520] pci 0000:3f:00.1: [8086:2c01] type 0 class 0x000600
[    0.719922] pci 0000:3f:02.0: [8086:2c10] type 0 class 0x000600
[    0.720321] pci 0000:3f:02.1: [8086:2c11] type 0 class 0x000600
[    0.720720] pci 0000:3f:03.0: [8086:2c18] type 0 class 0x000600
[    0.721118] pci 0000:3f:03.1: [8086:2c19] type 0 class 0x000600
[    0.721514] pci 0000:3f:03.4: [8086:2c1c] type 0 class 0x000600
[    0.721912] pci 0000:3f:04.0: [8086:2c20] type 0 class 0x000600
[    0.722310] pci 0000:3f:04.1: [8086:2c21] type 0 class 0x000600
[    0.722704] pci 0000:3f:04.2: [8086:2c22] type 0 class 0x000600
[    0.723099] pci 0000:3f:04.3: [8086:2c23] type 0 class 0x000600
[    0.723505] pci 0000:3f:05.0: [8086:2c28] type 0 class 0x000600
[    0.723901] pci 0000:3f:05.1: [8086:2c29] type 0 class 0x000600
[    0.724299] pci 0000:3f:05.2: [8086:2c2a] type 0 class 0x000600
[    0.724693] pci 0000:3f:05.3: [8086:2c2b] type 0 class 0x000600
[    0.725092] pci 0000:3f:06.0: [8086:2c30] type 0 class 0x000600
[    0.725489] pci 0000:3f:06.1: [8086:2c31] type 0 class 0x000600
[    0.725887] pci 0000:3f:06.2: [8086:2c32] type 0 class 0x000600
[    0.726285] pci 0000:3f:06.3: [8086:2c33] type 0 class 0x000600
[    0.728115] PCI: pci_cache_line_size set to 64 bytes
[    0.728679] reserve RAM buffer: 000000000009cc00 - 000000000009ffff 
[    0.728942] reserve RAM buffer: 00000000bcde3000 - 00000000bfffffff 
[    0.729366] reserve RAM buffer: 00000000bf6bd000 - 00000000bfffffff 
[    0.729783] reserve RAM buffer: 00000000bf714000 - 00000000bfffffff 
[    0.730205] reserve RAM buffer: 00000000bf7e7000 - 00000000bfffffff 
[    0.730621] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff 
[    0.759581] pnp: PnP ACPI init
[    0.760024] ACPI: bus type pnp registered
[    0.760929] pnp 00:00: [bus 00-3d]
[    0.761210] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.761511] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.761838] pnp 00:00: [io  0x0d00-0xffff window]
[    0.762164] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.762514] pnp 00:00: [mem 0x000c4000-0x000cbfff window]
[    0.762863] pnp 00:00: [mem 0xfed40000-0xfedfffff window]
[    0.763216] pnp 00:00: [mem 0xd0000000-0xf7ffffff window]
[    0.763564] pnp 00:00: [mem 0x00000000 window]
[    0.764029] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.764699] pnp 00:01: [io  0x0000-0x000f]
[    0.765006] pnp 00:01: [io  0x0081-0x0083]
[    0.765306] pnp 00:01: [io  0x0087]
[    0.765584] pnp 00:01: [io  0x0089-0x008b]
[    0.765885] pnp 00:01: [io  0x008f]
[    0.766166] pnp 00:01: [io  0x00c0-0x00df]
[    0.766467] pnp 00:01: [dma 4]
[    0.766823] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.770182] pnp 00:02: [io  0x0070-0x0071]
[    0.770483] pnp 00:02: [io  0x0074-0x0077]
[    0.770788] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.771353] pnp 00:02: [irq 8]
[    0.771712] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.772125] pnp 00:03: [io  0x00f0]
[    0.772405] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.772976] pnp 00:03: [irq 13]
[    0.773335] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.773745] pnp 00:04: [io  0x0061]
[    0.774129] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.774536] pnp 00:05: [io  0x0500-0x053f]
[    0.774837] pnp 00:05: [io  0x0400-0x047f]
[    0.775143] pnp 00:05: [io  0x0092]
[    0.775420] pnp 00:05: [io  0x0680-0x06ff]
[    0.775720] pnp 00:05: [io  0x0010-0x001f]
[    0.776023] pnp 00:05: [io  0x0072-0x0073]
[    0.776322] pnp 00:05: [io  0x0080]
[    0.776599] pnp 00:05: [io  0x0084-0x0086]
[    0.776900] pnp 00:05: [io  0x0088]
[    0.777180] pnp 00:05: [io  0x008c-0x008e]
[    0.777479] pnp 00:05: [io  0x0090-0x009f]
[    0.777959] system 00:05: [io  0x0500-0x053f] has been reserved
[    0.778327] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.778695] system 00:05: [io  0x0680-0x06ff] has been reserved
[    0.779068] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.779545] pnp 00:06: [io  0x0060]
[    0.779824] pnp 00:06: [io  0x0064]
[    0.780268] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.781212] pnp 00:07: [mem 0xfec00000-0xfec000ff]
[    0.781652] pnp 00:07: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.782181] pnp: PnP ACPI: found 8 devices
[    0.782480] ACPI: ACPI bus type pnp unregistered
[    0.793721] Switching to clocksource acpi_pm
[    0.794163] pci 0000:02:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.794782] PCI: max bus depth: 1 pci_try_num: 2
[    0.795209] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.795562] pci 0000:02:00.0: BAR 6: assigned [mem 0xe0290000-0xe029ffff pref]
[    0.796093] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.796445] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.796845] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.797412] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.797762] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.798114] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    0.798478] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.798821] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.799211] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.799619] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    0.799964] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.800396] IOAPIC[0]: Set routing entry (8-16 -> 0x29 -> IRQ 16 Mode:1 Active:1 Dest:0)
[    0.800963] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.801380] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.801781] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.802206] IOAPIC[0]: Set routing entry (8-17 -> 0x41 -> IRQ 17 Mode:1 Active:1 Dest:0)
[    0.802773] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.803192] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.803595] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.803998] pci 0000:00:1e.0: setting latency timer to 64
[    0.804356] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.804711] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.805066] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.805454] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.805834] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.806232] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.806612] pci_bus 0000:02: resource 1 [mem 0xe0200000-0xe02fffff]
[    0.806992] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.807532] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    0.807888] pci_bus 0000:06: resource 1 [mem 0xe0100000-0xe01fffff]
[    0.808281] pci_bus 0000:07: resource 1 [mem 0xe0000000-0xe00fffff]
[    0.808660] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.809014] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.809374] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.809754] pci_bus 0000:07: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.810149] pci_bus 0000:07: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.810529] pci_bus 0000:07: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.810908] pci_bus 0000:3f: resource 0 [io  0x0000-0xffff]
[    0.811275] pci_bus 0000:3f: resource 1 [mem 0x00000000-0xfffffffff]
[    0.811716] NET: Registered protocol family 2
[    0.812342] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.814790] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.818575] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    0.822170] TCP: Hash tables configured (established 524288 bind 65536)
[    0.822581] TCP reno registered
[    0.822914] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    0.823563] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    0.824319] NET: Registered protocol family 1
[    0.824841] RPC: Registered named UNIX socket transport module.
[    0.825229] RPC: Registered udp transport module.
[    0.825551] RPC: Registered tcp transport module.
[    0.825872] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.826312] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.826701] pci 0000:00:1a.0: Performing full reset
[    0.827060] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.827449] pci 0000:00:1a.1: Performing full reset
[    0.827795] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.828199] pci 0000:00:1a.2: Performing full reset
[    0.828697] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.829112] pci 0000:00:1d.0: Performing full reset
[    0.829464] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.829854] pci 0000:00:1d.1: Performing full reset
[    0.830215] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.830605] pci 0000:00:1d.2: Performing full reset
[    0.831092] pci 0000:02:00.0: Boot video device
[    0.831465] PCI: CLS 64 bytes, default 64
[    0.835647] Machine check injector initialized
[    0.837884] microcode: CPU0 sig=0x106a4, pf=0x2, revision=0x6
[    0.838263] microcode: CPU1 sig=0x106a4, pf=0x2, revision=0x6
[    0.838633] microcode: CPU2 sig=0x106a4, pf=0x2, revision=0x6
[    0.839010] microcode: CPU3 sig=0x106a4, pf=0x2, revision=0x6
[    0.839378] microcode: CPU4 sig=0x106a4, pf=0x2, revision=0x6
[    0.839751] microcode: CPU5 sig=0x106a4, pf=0x2, revision=0x6
[    0.840127] microcode: CPU6 sig=0x106a4, pf=0x2, revision=0x6
[    0.840498] microcode: CPU7 sig=0x106a4, pf=0x2, revision=0x6
[    0.840959] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.842023] audit: initializing netlink socket (disabled)
[    0.842395] type=2000 audit(1320073687.595:1): initialized
[    0.874810] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.887118] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.888463] fuse init (API version 7.17)
[    0.889386] JFS: nTxBlock = 8192, nTxLock = 65536
[    0.893297] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    0.895921] NILFS version 2 loaded
[    0.897214] Btrfs loaded
[    0.897462] msgmni has been set to 5883
[    0.898927] async_tx: api initialized (async)
[    0.899440] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.900053] io scheduler noop registered
[    0.900347] io scheduler deadline registered
[    0.900791] io scheduler cfq registered (default)
[    0.901594] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.902146] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.902664] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    0.903365] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.904184] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    0.904763] ACPI: Sleep Button [SLPB]
[    0.905199] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.905739] ACPI: Power Button [PWRF]
[    0.906743] ACPI: acpi_idle registered with cpuidle
[    0.907482] Monitor-Mwait will be used to enter C-1 state
[    0.907904] Monitor-Mwait will be used to enter C-3 state
[    0.915347] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.958791] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.974672] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    1.022725] Initializing Nozomi driver 2.1d
[    1.023527] Non-volatile memory driver v1.3
[    1.024273] Linux agpgart interface v0.103
[    1.024670] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.025265] Hangcheck: Using getrawmonotonic().
[    1.025659] [drm] Initialized drm 1.1.0 20060810
[    1.025979] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    1.831038] Refined TSC clocksource calibration: 3200.113 MHz.
[    1.831406] Switching to clocksource tsc
[    4.036175] floppy0: no floppy controllers found
[    4.036642] ------------[ cut here ]------------
[    4.036966] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.037553] Hardware name:         
[    4.037831] VFS: do_fd_request called on non-open device
[    4.038176] Modules linked in:
[    4.038472] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
[    4.039052] Call Trace:
[    4.039294]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.042617]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.042979]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
[    4.043347]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.043724]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
[    4.044073]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
[    4.044428]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
[    4.044783]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
[    4.045152]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
[    4.045501]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
[    4.045834]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.046193]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
[    4.046539]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
[    4.046907]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
[    4.047280]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
[    4.047637]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
[    4.047979] ---[ end trace 4eaa2a86a8e2da24 ]---
[    4.048424] ------------[ cut here ]------------
[    4.048745] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.049329] Hardware name:         
[    4.049606] VFS: do_fd_request called on non-open device
[    4.049950] Modules linked in:
[    4.050245] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
[    4.050824] Call Trace:
[    4.051064]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.051434]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.051795]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
[    4.052162]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.052539]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
[    4.052888]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
[    4.053242]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
[    4.053597]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
[    4.053965]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
[    4.054313]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
[    4.054646]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.055003]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
[    4.055348]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
[    4.055715]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
[    4.056089]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
[    4.056446]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
[    4.056787] ---[ end trace 4eaa2a86a8e2da25 ]---
[    4.057155] ------------[ cut here ]------------
[    4.057474] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.058058] Hardware name:         
[    4.058334] VFS: do_fd_request called on non-open device
[    4.058678] Modules linked in:
[    4.058972] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
[    4.059550] Call Trace:
[    4.059790]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.060161]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.060523]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
[    4.060891]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.061268]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
[    4.061617]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
[    4.061973]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
[    4.062328]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
[    4.062697]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
[    4.063046]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
[    4.063379]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.063738]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
[    4.064084]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
[    4.064451]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
[    4.064827]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
[    4.065185]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
[    4.065528] ---[ end trace 4eaa2a86a8e2da26 ]---
[    4.065895] ------------[ cut here ]------------
[    4.066216] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.066802] Hardware name:         
[    4.067081] VFS: do_fd_request called on non-open device
[    4.067427] Modules linked in:
[    4.067722] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
[    4.068300] Call Trace:
[    4.068540]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.068910]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.069270]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
[    4.069637]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.070014]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
[    4.070362]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
[    4.070717]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
[    4.071071]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
[    4.071439]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
[    4.071788]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
[    4.072121]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.072478]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
[    4.072823]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
[    4.073190]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
[    4.073564]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
[    4.073922]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
[    4.074263] ---[ end trace 4eaa2a86a8e2da27 ]---
[    4.074629] ------------[ cut here ]------------
[    4.074949] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.075534] Hardware name:         
[    4.075811] VFS: do_fd_request called on non-open device
[    4.076155] Modules linked in:
[    4.076449] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
[    4.077026] Call Trace:
[    4.077267]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.077638]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.078001]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
[    4.078369]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.078746]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
[    4.079096]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
[    4.079452]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
[    4.079807]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
[    4.080176]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
[    4.080525]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
[    4.080858]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.081217]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
[    4.081563]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
[    4.081932]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
[    4.082305]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
[    4.082663]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
[    4.083003] ---[ end trace 4eaa2a86a8e2da28 ]---
[    4.083366] ------------[ cut here ]------------
[    4.083685] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.084271] Hardware name:         
[    4.084548] VFS: do_fd_request called on non-open device
[    4.084893] Modules linked in:
[    4.085187] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
[    4.085766] Call Trace:
[    4.086006]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.086376]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.086737]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
[    4.087104]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.087481]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
[    4.087829]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
[    4.088184]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
[    4.088539]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
[    4.088907]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
[    4.089255]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
[    4.089588]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.089946]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
[    4.090290]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
[    4.090657]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
[    4.091031]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
[    4.091389]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
[    4.091730] ---[ end trace 4eaa2a86a8e2da29 ]---
[    4.092093] ------------[ cut here ]------------
[    4.092413] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.092997] Hardware name:         
[    4.093274] VFS: do_fd_request called on non-open device
[    4.093619] Modules linked in:
[    4.093913] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
[    4.094491] Call Trace:
[    4.094732]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.095104]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.095465]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
[    4.095834]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.096212]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
[    4.096560]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
[    4.096914]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
[    4.097268]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
[    4.097636]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
[    4.097985]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
[    4.098319]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.098679]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
[    4.099025]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
[    4.099393]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
[    4.099768]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
[    4.100126]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
[    4.100469] ---[ end trace 4eaa2a86a8e2da2a ]---
[    4.100833] ------------[ cut here ]------------
[    4.101154] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.101740] Hardware name:         
[    4.102018] VFS: do_fd_request called on non-open device
[    4.102363] Modules linked in:
[    4.102658] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
[    4.106193] Call Trace:
[    4.106432]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.106804]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.107165]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
[    4.107532]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.107909]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
[    4.108257]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
[    4.108612]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
[    4.108967]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
[    4.109334]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
[    4.109683]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
[    4.110015]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.110373]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
[    4.110718]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
[    4.111085]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
[    4.111459]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
[    4.111817]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
[    4.112157] ---[ end trace 4eaa2a86a8e2da2b ]---
[    4.115669] brd: module loaded
[    4.117641] loop: module loaded
[    4.118381] Loading iSCSI transport class v2.0-870.
[    4.119313] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    4.119667] Detecting Adaptec I2O RAID controllers...
[    4.120182] Adaptec aacraid driver 1.1-7[28000]-ms
[    4.121074] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.121646] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.07-k.
[    4.122373] iscsi: registered transport (qla4xxx)
[    4.122771] QLogic iSCSI HBA Driver
[    4.123131] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    4.123736] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    4.124223] megasas: 00.00.06.12-rc1 Wed. Oct. 5 17:00:00 PDT 2011
[    4.124686] mpt2sas version 09.100.00.01 loaded
[    4.125373] ahci 0000:00:1f.2: version 3.0
[    4.125702] IOAPIC[0]: Set routing entry (8-19 -> 0x61 -> IRQ 19 Mode:1 Active:1 Dest:0)
[    4.126272] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    4.126717] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    4.127129] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    4.127696] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    4.128259] ahci 0000:00:1f.2: setting latency timer to 64
[    4.139104] scsi0 : ahci
[    4.139542] scsi1 : ahci
[    4.139949] scsi2 : ahci
[    4.140351] scsi3 : ahci
[    4.140755] scsi4 : ahci
[    4.141160] scsi5 : ahci
[    4.141817] ata1: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320100 irq 43
[    4.142356] ata2: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320180 irq 43
[    4.142898] ata3: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320200 irq 43
[    4.143439] ata4: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320280 irq 43
[    4.143981] ata5: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320300 irq 43
[    4.144521] ata6: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320380 irq 43
[    4.145092] ahci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.145506] ahci 0000:06:00.0: Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.
[    4.146168] ahci 0000:06:00.0: controller can't do NCQ, turning off CAP_NCQ
[    4.146573] ahci 0000:06:00.0: controller can't do PMP, turning off CAP_PMP
[    4.146982] ahci 0000:06:00.0: masking port_map 0x7 -> 0x3
[    4.147350] ahci: SSS flag set, parallel bus scan disabled
[    4.147746] ahci 0000:06:00.0: AHCI 0001.0000 32 slots 3 ports 3 Gbps 0x3 impl IDE mode
[    4.148309] ahci 0000:06:00.0: flags: 64bit stag led slum part 
[    4.149519] scsi6 : ahci
[    4.149940] scsi7 : ahci
[    4.150346] scsi8 : ahci
[    4.150736] ata7: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100100 irq 16
[    4.151276] ata8: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100180 irq 16
[    4.151816] ata9: DUMMY
[    4.155090] tun: Universal TUN/TAP device driver, 1.6
[    4.155426] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.156041] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    4.156391] Copyright (c) 2007 Atheros Corporation.
[    4.157062] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.7 (July 20, 2011)
[    4.157749] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.158123] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.158564] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    4.158977] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.159425] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    4.159793] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    4.160186] IOAPIC[0]: Set routing entry (8-20 -> 0x71 -> IRQ 20 Mode:1 Active:1 Dest:0)
[    4.160756] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.161167] e1000e 0000:00:19.0: setting latency timer to 64
[    4.161633] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    4.351667] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:c0:79:88:54
[    4.352232] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.352668] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
[    4.353162] Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[    4.353555] Copyright (c) 2007-2011 Intel Corporation.
[    4.353980] Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[    4.354518] Copyright (c) 2009 - 2011 Intel Corporation.
[    4.354950] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.6.7-k
[    4.355501] ixgbe: Copyright (c) 1999-2011 Intel Corporation.
[    4.355950] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    4.356367] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    4.356893] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    4.357424] sky2: driver version 1.29
[    4.358188] usbcore: registered new interface driver catc
[    4.358538] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[    4.358961] usbcore: registered new interface driver kaweth
[    4.359321] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    4.359921] usbcore: registered new interface driver pegasus
[    4.360287] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[    4.360752] usbcore: registered new interface driver rtl8150
[    4.361180] usbcore: registered new interface driver asix
[    4.361585] usbcore: registered new interface driver cdc_ether
[    4.362005] usbcore: registered new interface driver cdc_eem
[    4.362424] usbcore: registered new interface driver dm9601
[    4.362842] usbcore: registered new interface driver smsc75xx
[    4.363273] usbcore: registered new interface driver smsc95xx
[    4.363689] usbcore: registered new interface driver gl620a
[    4.364109] usbcore: registered new interface driver net1080
[    4.364522] usbcore: registered new interface driver plusb
[    4.364929] usbcore: registered new interface driver rndis_host
[    4.365360] usbcore: registered new interface driver cdc_subset
[    4.365786] usbcore: registered new interface driver zaurus
[    4.366204] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    4.366802] usbcore: registered new interface driver int51x1
[    4.367163] cdc_ncm: 04-Aug-2011
[    4.367488] usbcore: registered new interface driver cdc_ncm
[    4.367846] Fusion MPT base driver 3.04.20
[    4.368150] Copyright (c) 1999-2008 LSI Corporation
[    4.368486] Fusion MPT SPI Host driver 3.04.20
[    4.368887] Fusion MPT FC Host driver 3.04.20
[    4.369291] Fusion MPT SAS Host driver 3.04.20
[    4.369695] Fusion MPT misc device (ioctl) driver 3.04.20
[    4.370132] mptctl: Registered with Fusion MPT base driver
[    4.370484] mptctl: /dev/mptctl @ (major,minor=10,220)
[    4.370925] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.371319] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    4.371725] IOAPIC[0]: Set routing entry (8-18 -> 0x81 -> IRQ 18 Mode:1 Active:1 Dest:0)
[    4.372296] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.372718] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.373086] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.373487] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file 'devices'
[    4.374036] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.374456] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.375000] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.375602] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.376252] ehci_hcd 0000:00:1a.7: debug port 1
[    4.376571] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.381047] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.381446] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.381828] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0322000
[    4.382191] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.386642] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.393010] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.393435] usb usb1: default language 0x0409
[    4.393753] usb usb1: udev 1, busnum 1, minor = 0
[    4.394081] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.394481] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.395016] usb usb1: Product: EHCI Host Controller
[    4.395345] usb usb1: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ ehci_hcd
[    4.398849] usb usb1: SerialNumber: 0000:00:1a.7
[    4.399324] usb usb1: usb_probe_device
[    4.399613] usb usb1: configuration #1 chosen from 1 choice
[    4.399997] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.400446] hub 1-0:1.0: usb_probe_interface
[    4.400753] hub 1-0:1.0: usb_probe_interface - got id
[    4.401094] hub 1-0:1.0: USB hub found
[    4.401385] hub 1-0:1.0: 6 ports detected
[    4.401682] hub 1-0:1.0: standalone hub
[    4.401976] hub 1-0:1.0: no power switching (usb 1.0)
[    4.402310] hub 1-0:1.0: individual port over-current protection
[    4.402681] hub 1-0:1.0: power on to power good time: 20ms
[    4.403051] hub 1-0:1.0: local power source is good
[    4.403379] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.403837] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.404364] IOAPIC[0]: Set routing entry (8-23 -> 0x89 -> IRQ 23 Mode:1 Active:1 Dest:0)
[    4.404930] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.405355] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.405721] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.406070] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    4.406479] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    4.407025] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.407621] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.408257] ehci_hcd 0000:00:1d.7: debug port 1
[    4.408575] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.413053] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.413452] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.413832] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0321000
[    4.414194] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.418647] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.424905] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.425304] usb usb2: default language 0x0409
[    4.425621] usb usb2: udev 1, busnum 2, minor = 128
[    4.425954] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.426353] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.426886] usb usb2: Product: EHCI Host Controller
[    4.427215] usb usb2: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ ehci_hcd
[    4.427761] usb usb2: SerialNumber: 0000:00:1d.7
[    4.428225] usb usb2: usb_probe_device
[    4.428513] usb usb2: configuration #1 chosen from 1 choice
[    4.428879] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.429317] hub 2-0:1.0: usb_probe_interface
[    4.429626] hub 2-0:1.0: usb_probe_interface - got id
[    4.429966] hub 2-0:1.0: USB hub found
[    4.430258] hub 2-0:1.0: 6 ports detected
[    4.430557] hub 2-0:1.0: standalone hub
[    4.430848] hub 2-0:1.0: no power switching (usb 1.0)
[    4.431185] hub 2-0:1.0: individual port over-current protection
[    4.431556] hub 2-0:1.0: power on to power good time: 20ms
[    4.431917] hub 2-0:1.0: local power source is good
[    4.432247] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.432692] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.433264] uhci_hcd: USB Universal Host Controller Interface driver
[    4.433681] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.434104] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.434470] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.434821] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '003'
[    4.435236] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    4.435779] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.436114] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.436510] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.436871] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    4.437237] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020e0
[    4.437646] usb usb3: default language 0x0409
[    4.437969] usb usb3: udev 1, busnum 3, minor = 256
[    4.438297] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.438696] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.439228] usb usb3: Product: UHCI Host Controller
[    4.439557] usb usb3: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    4.440107] usb usb3: SerialNumber: 0000:00:1a.0
[    4.440567] usb usb3: usb_probe_device
[    4.440861] usb usb3: configuration #1 chosen from 1 choice
[    4.441223] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.441657] hub 3-0:1.0: usb_probe_interface
[    4.441968] hub 3-0:1.0: usb_probe_interface - got id
[    4.442303] hub 3-0:1.0: USB hub found
[    4.442594] hub 3-0:1.0: 2 ports detected
[    4.442894] hub 3-0:1.0: standalone hub
[    4.443184] hub 3-0:1.0: no power switching (usb 1.0)
[    4.443519] hub 3-0:1.0: individual port over-current protection
[    4.443893] hub 3-0:1.0: power on to power good time: 2ms
[    4.444246] hub 3-0:1.0: local power source is good
[    4.444574] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.445001] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.445461] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    4.445893] IOAPIC[0]: Set routing entry (8-21 -> 0x91 -> IRQ 21 Mode:1 Active:1 Dest:0)
[    4.446459] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.446878] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.447243] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.447589] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[    4.448003] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    4.448546] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.448847] ata3: SATA link down (SStatus 0 SControl 300)
[    4.448884] ata4: SATA link down (SStatus 0 SControl 300)
[    4.448907] ata6: SATA link down (SStatus 0 SControl 300)
[    4.448930] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.448951] ata5: SATA link down (SStatus 0 SControl 300)
[    4.450645] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.451044] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.451401] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    4.451781] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020c0
[    4.452180] usb usb4: default language 0x0409
[    4.452498] usb usb4: udev 1, busnum 4, minor = 384
[    4.452829] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.453228] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.453760] usb usb4: Product: UHCI Host Controller
[    4.454092] usb usb4: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    4.454639] usb usb4: SerialNumber: 0000:00:1a.1
[    4.455103] usb usb4: usb_probe_device
[    4.455392] usb usb4: configuration #1 chosen from 1 choice
[    4.455754] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.455818] ata7: SATA link down (SStatus 0 SControl 300)
[    4.456540] hub 4-0:1.0: usb_probe_interface
[    4.456852] hub 4-0:1.0: usb_probe_interface - got id
[    4.457187] hub 4-0:1.0: USB hub found
[    4.457478] hub 4-0:1.0: 2 ports detected
[    4.457774] hub 4-0:1.0: standalone hub
[    4.458066] hub 4-0:1.0: no power switching (usb 1.0)
[    4.458401] hub 4-0:1.0: individual port over-current protection
[    4.458771] hub 4-0:1.0: power on to power good time: 2ms
[    4.459126] hub 4-0:1.0: local power source is good
[    4.459454] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.459885] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.460339] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    4.460762] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.461182] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.461548] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.461897] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '005'
[    4.462307] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    4.462851] uhci_hcd 0000:00:1a.2: detected 2 ports
[    4.463182] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.463577] uhci_hcd 0000:00:1a.2: Performing full reset
[    4.463936] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    4.464318] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000020a0
[    4.464715] usb usb5: default language 0x0409
[    4.465037] usb usb5: udev 1, busnum 5, minor = 512
[    4.465366] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.465769] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.466300] usb usb5: Product: UHCI Host Controller
[    4.466628] usb usb5: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    4.467176] usb usb5: SerialNumber: 0000:00:1a.2
[    4.467635] usb usb5: usb_probe_device
[    4.467931] usb usb5: configuration #1 chosen from 1 choice
[    4.468292] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.468730] hub 5-0:1.0: usb_probe_interface
[    4.469043] hub 5-0:1.0: usb_probe_interface - got id
[    4.469378] hub 5-0:1.0: USB hub found
[    4.469671] hub 5-0:1.0: 2 ports detected
[    4.469972] hub 5-0:1.0: standalone hub
[    4.470263] hub 5-0:1.0: no power switching (usb 1.0)
[    4.470600] hub 5-0:1.0: individual port over-current protection
[    4.470973] hub 5-0:1.0: power on to power good time: 2ms
[    4.471327] hub 5-0:1.0: local power source is good
[    4.471657] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.472085] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.472540] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    4.472970] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.473387] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.473757] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.474103] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '006'
[    4.477473] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    4.478017] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.478348] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.478745] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.479102] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.479467] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
[    4.479866] usb usb6: default language 0x0409
[    4.480184] usb usb6: udev 1, busnum 6, minor = 640
[    4.480512] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.480916] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.481446] usb usb6: Product: UHCI Host Controller
[    4.481777] usb usb6: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    4.482323] usb usb6: SerialNumber: 0000:00:1d.0
[    4.482785] usb usb6: usb_probe_device
[    4.483074] usb usb6: configuration #1 chosen from 1 choice
[    4.483434] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.483875] hub 6-0:1.0: usb_probe_interface
[    4.484182] hub 6-0:1.0: usb_probe_interface - got id
[    4.484516] hub 6-0:1.0: USB hub found
[    4.484811] hub 6-0:1.0: 2 ports detected
[    4.485107] hub 6-0:1.0: standalone hub
[    4.485397] hub 6-0:1.0: no power switching (usb 1.0)
[    4.485734] hub 6-0:1.0: individual port over-current protection
[    4.486104] hub 6-0:1.0: power on to power good time: 2ms
[    4.486457] hub 6-0:1.0: local power source is good
[    4.486788] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    4.487212] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.487678] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    4.488097] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.488513] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.488881] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.489227] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '007'
[    4.489652] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    4.490200] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.490401] ata1.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[    4.490403] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.491282] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.491680] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.492036] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    4.492401] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
[    4.492800] usb usb7: default language 0x0409
[    4.493117] usb usb7: udev 1, busnum 7, minor = 768
[    4.493445] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.493848] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.494378] usb usb7: Product: UHCI Host Controller
[    4.494709] usb usb7: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    4.495255] usb usb7: SerialNumber: 0000:00:1d.1
[    4.495733] usb usb7: usb_probe_device
[    4.496022] usb usb7: configuration #1 chosen from 1 choice
[    4.496384] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.496823] hub 7-0:1.0: usb_probe_interface
[    4.497131] hub 7-0:1.0: usb_probe_interface - got id
[    4.497466] hub 7-0:1.0: USB hub found
[    4.497762] hub 7-0:1.0: 2 ports detected
[    4.498060] hub 7-0:1.0: standalone hub
[    4.498351] hub 7-0:1.0: no power switching (usb 1.0)
[    4.498688] hub 7-0:1.0: individual port over-current protection
[    4.499059] hub 7-0:1.0: power on to power good time: 2ms
[    4.499414] hub 7-0:1.0: local power source is good
[    4.499746] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.500172] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.500643] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    4.501062] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.501479] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.501848] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.502197] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '008'
[    4.502609] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    4.503179] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.503777] hub 1-0:1.0: port 1: status 0501 change 0001
[    4.504131] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.504725] hub 1-0:1.0: port 2: status 0501 change 0001
[    4.504738] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.504743] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.504745] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.504758] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    4.504765] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    4.504818] usb usb8: default language 0x0409
[    4.504829] usb usb8: udev 1, busnum 8, minor = 896
[    4.504830] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    4.504832] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.504833] usb usb8: Product: UHCI Host Controller
[    4.504835] usb usb8: Manufacturer: Linux 3.1.0-ioless-full-next-20111025+ uhci_hcd
[    4.504836] usb usb8: SerialNumber: 0000:00:1d.2
[    4.505031] usb usb8: usb_probe_device
[    4.505035] usb usb8: configuration #1 chosen from 1 choice
[    4.505048] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    4.505139] hub 8-0:1.0: usb_probe_interface
[    4.505141] hub 8-0:1.0: usb_probe_interface - got id
[    4.505142] hub 8-0:1.0: USB hub found
[    4.505148] hub 8-0:1.0: 2 ports detected
[    4.505150] hub 8-0:1.0: standalone hub
[    4.505151] hub 8-0:1.0: no power switching (usb 1.0)
[    4.505152] hub 8-0:1.0: individual port over-current protection
[    4.505154] hub 8-0:1.0: power on to power good time: 2ms
[    4.505163] hub 8-0:1.0: local power source is good
[    4.505165] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    4.505204] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    4.505295] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    4.505434] Initializing USB Mass Storage driver...
[    4.505532] usbcore: registered new interface driver usb-storage
[    4.505534] USB Mass Storage support registered.
[    4.505679] usbcore: registered new interface driver libusual
[    4.505762] usbcore: registered new interface driver ums-alauda
[    4.505847] usbcore: registered new interface driver ums-cypress
[    4.505918] usbcore: registered new interface driver ums-datafab
[    4.505991] usbcore: registered new interface driver ums-freecom
[    4.506076] usbcore: registered new interface driver ums-isd200
[    4.506165] usbcore: registered new interface driver ums-jumpshot
[    4.506243] usbcore: registered new interface driver ums-karma
[    4.506313] usbcore: registered new interface driver ums-onetouch
[    4.506391] usbcore: registered new interface driver ums-sddr09
[    4.506479] usbcore: registered new interface driver ums-sddr55
[    4.506565] usbcore: registered new interface driver ums-usbat
[    4.506723] usbcore: registered new interface driver usbserial
[    4.506811] USB Serial support registered for generic
[    4.506906] usbcore: registered new interface driver usbserial_generic
[    4.506907] usbserial: USB Serial Driver core
[    4.506972] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    4.507053] usbcore: registered new interface driver belkin
[    4.507054] belkin_sa: v1.3:USB Belkin Serial converter driver
[    4.507125] USB Serial support registered for MCT U232
[    4.507213] usbcore: registered new interface driver mct_u232
[    4.507215] mct_u232: z2.1:Magic Control Technology USB-RS232 converter driver
[    4.507486] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    4.510687] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.510703] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.511075] mousedev: PS/2 mouse device common for all mice
[    4.511779] rtc_cmos 00:02: RTC can wake from S4
[    4.511985] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    4.512024] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    4.512100] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    4.512310] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[    4.512440] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.512445] iTCO_vendor_support: vendor-support=0
[    4.512447] SoftDog: cannot register miscdev on minor=130 (err=-16)
[    4.512455] md: linear personality registered for level -1
[    4.512457] md: raid0 personality registered for level 0
[    4.512459] md: raid1 personality registered for level 1
[    4.512460] md: raid10 personality registered for level 10
[    4.512461] md: raid6 personality registered for level 6
[    4.512463] md: raid5 personality registered for level 5
[    4.512464] md: raid4 personality registered for level 4
[    4.512465] md: multipath personality registered for level -4
[    4.512467] md: faulty personality registered for level -5
[    4.512878] device-mapper: uevent: version 1.0.3
[    4.513125] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    4.513232] device-mapper: multipath: version 1.3.0 loaded
[    4.513242] device-mapper: multipath round-robin: version 1.0.0 loaded
[    4.513244] device-mapper: multipath queue-length: version 0.1.0 loaded
[    4.513246] device-mapper: multipath service-time: version 0.2.0 loaded
[    4.513416] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    4.515015] cpuidle: using governor ladder
[    4.534821] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.535434] hub 1-0:1.0: port 4: status 0501 change 0001
[    4.535848] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    4.537659] cpuidle: using governor menu
[    4.538165] usbcore: registered new interface driver usbhid
[    4.538520] usbhid: USB HID core driver
[    4.539231] dell_wmi: No known WMI GUID found
[    4.539603] acer_wmi: Acer Laptop ACPI-WMI Extras
[    4.539930] acer_wmi: No or unsupported WMI interface, unable to load
[    4.540796] IOAPIC[0]: Set routing entry (8-22 -> 0x99 -> IRQ 22 Mode:1 Active:1 Dest:0)
[    4.541364] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    4.544529] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[    4.544545] uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
[    4.545661] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    4.546053] ALSA hda_intel.c:2733 chipset global capabilities = 0x4401
[    4.546454] ALSA hda_intel.c:1163 Clearing TCSEL
[    4.548602] ata1.00: configured for UDMA/133
[    4.549147] scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    4.550030] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    4.550660] sd 0:0:0:0: [sda] Write Protect is off
[    4.550986] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.551350] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.554626] ALSA hda_intel.c:1009 codec_mask = 0x4
[    4.555153] ALSA hda_intel.c:1472 codec #2 probed OK
[    4.559596] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    4.560675] ALSA hda_codec.c:3994 hda_codec: model 'intel-x58' is selected for config 8086:22 (DX58SO)
[    4.561287] hda_codec: ALC889: SKU not ready 0x411111f0
[    4.561958] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input2
[    4.565579] ALSA hda_codec.c:2378 Cannot find slave Side Playback Volume, skipped
[    4.566120] ALSA hda_codec.c:2378 Cannot find slave Headphone Playback Volume, skipped
[    4.566754] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Volume, skipped
[    4.567296] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Volume, skipped
[    4.567930] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Volume, skipped
[    4.568555] ALSA hda_codec.c:2378 Cannot find slave Side Playback Switch, skipped
[    4.569097] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Switch, skipped
[    4.569720] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Switch, skipped
[    4.570272] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Switch, skipped
[    4.571475] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.571643] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input3
[    4.572045] ALSA device list:
[    4.572046]   #0: HDA Intel at 0xf7f00000 irq 45
[    4.572049] oprofile: using NMI interrupt.
[    4.572084] netem: version 1.3
[    4.572086] Netfilter messages via NETLINK v0.30.
[    4.572117] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    4.572898] ctnetlink v0.93: registering with nfnetlink.
[    4.572931] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    4.572932] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    4.573247] xt_time: kernel timezone is -0000
[    4.574610] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.574671] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    4.574689] arp_tables: (C) 2002 David S. Miller
[    4.574715] TCP bic registered
[    4.574716] TCP cubic registered
[    4.574717] TCP westwood registered
[    4.574718] TCP highspeed registered
[    4.574720] TCP hybla registered
[    4.574721] TCP htcp registered
[    4.574722] TCP vegas registered
[    4.574723] TCP veno registered
[    4.574724] TCP scalable registered
[    4.574725] TCP lp registered
[    4.574726] TCP yeah registered
[    4.574727] TCP illinois registered
[    4.574728] Initializing XFRM netlink socket
[    4.575294] NET: Registered protocol family 10
[    4.578279] IPv6 over IPv4 tunneling driver
[    4.579911] NET: Registered protocol family 17
[    4.579921] NET: Registered protocol family 15
[    4.580034] Bridge firewalling registered
[    4.580045] Ebtables v2.0 registered
[    4.580134] Registering the dns_resolver key type
[    4.580188] 
[    4.580189] printing PIC contents
[    4.580194] ... PIC  IMR: ffff
[    4.580198] ... PIC  IRR: 0c21
[    4.580210] ... PIC  ISR: 0000
[    4.580214] ... PIC ELCR: 0c20
[    4.580215] printing local APIC contents on CPU#0/0:
[    4.580216] ... APIC ID:      00000000 (0)
[    4.580217] ... APIC VERSION: 00060015
[    4.580218] ... APIC TASKPRI: 00000000 (00)
[    4.580219] ... APIC PROCPRI: 00000000
[    4.580220] ... APIC LDR: 01000000
[    4.580221] ... APIC DFR: ffffffff
[    4.580222] ... APIC SPIV: 000001ff
[    4.580222] ... APIC ISR field:
[    4.580223] 0000000000000000000000000000000000000000000000000000000000000000
[    4.580226] ... APIC TMR field:
[    4.580227] 0000000000000000000000000000000000000002000000000000000000000000
[    4.580230] ... APIC IRR field:
[    4.580231] 0000000000000000000000000000000000000000000000000000000000000000
[    4.580233] ... APIC ESR: 00000000
[    4.580234] ... APIC ICR: 000000ef
[    4.580235] ... APIC ICR2: 01000000
[    4.580236] ... APIC LVTT: 000000ef
[    4.580236] ... APIC LVTPC: 00000400
[    4.580237] ... APIC LVT0: 00010700
[    4.580238] ... APIC LVT1: 00000400
[    4.580239] ... APIC LVTERR: 000000fe
[    4.580240] ... APIC TMICT: 00002073
[    4.580241] ... APIC TMCCT: 00000516
[    4.580241] ... APIC TDCR: 00000003
[    4.580242] 
[    4.580243] number of MP IRQ sources: 15.
[    4.580244] number of IO-APIC #8 registers: 24.
[    4.580245] testing the IO APIC.......................
[    4.580253] 
[    4.580254] IO APIC #8......
[    4.580254] .... register #00: 08000000
[    4.580255] .......    : physical APIC id: 08
[    4.580256] .......    : Delivery Type: 0
[    4.580257] .......    : LTS          : 0
[    4.580258] .... register #01: 00170020
[    4.580259] .......     : max redirection entries: 17
[    4.580260] .......     : PRQ implemented: 0
[    4.580261] .......     : IO APIC version: 20
[    4.580261] .... IRQ redirection table:
[    4.580262]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    4.580267]  00 00  1    0    0   0   0    0    0    00
[    4.580272]  01 00  0    0    0   0   0    0    0    31
[    4.580278]  02 00  0    0    0   0   0    0    0    30
[    4.580283]  03 00  0    0    0   0   0    0    0    33
[    4.580289]  04 00  0    0    0   0   0    0    0    34
[    4.580295]  05 00  0    0    0   0   0    0    0    35
[    4.580300]  06 00  1    0    0   0   0    0    0    36
[    4.580305]  07 00  0    0    0   0   0    0    0    37
[    4.580309]  08 00  0    0    0   0   0    0    0    38
[    4.580314]  09 00  0    1    0   0   0    0    0    39
[    4.580318]  0a 00  0    0    0   0   0    0    0    3A
[    4.580323]  0b 00  0    0    0   0   0    0    0    3B
[    4.580328]  0c 00  0    0    0   0   0    0    0    3C
[    4.580333]  0d 00  0    0    0   0   0    0    0    3D
[    4.580337]  0e 00  0    0    0   0   0    0    0    3E
[    4.580342]  0f 00  0    0    0   0   0    0    0    3F
[    4.580346]  10 00  0    1    0   1   0    0    0    29
[    4.580351]  11 00  1    1    0   1   0    0    0    41
[    4.580355]  12 00  0    1    0   1   0    0    0    81
[    4.580360]  13 00  0    1    0   1   0    0    0    61
[    4.580365]  14 00  1    1    0   1   0    0    0    71
[    4.580370]  15 00  0    1    0   1   0    0    0    91
[    4.580374]  16 00  1    1    0   1   0    0    0    99
[    4.580379]  17 00  0    1    0   1   0    0    0    89
[    4.580381] IRQ to pin mappings:
[    4.580382] IRQ0 -> 0:2
[    4.580383] IRQ1 -> 0:1
[    4.580384] IRQ3 -> 0:3
[    4.580385] IRQ4 -> 0:4
[    4.580386] IRQ5 -> 0:5
[    4.580388] IRQ6 -> 0:6
[    4.580389] IRQ7 -> 0:7
[    4.580390] IRQ8 -> 0:8
[    4.580391] IRQ9 -> 0:9
[    4.580392] IRQ10 -> 0:10
[    4.580393] IRQ11 -> 0:11
[    4.580394] IRQ12 -> 0:12
[    4.580395] IRQ13 -> 0:13
[    4.580401] IRQ14 -> 0:14
[    4.580402] IRQ15 -> 0:15
[    4.580403] IRQ16 -> 0:16
[    4.580436] IRQ17 -> 0:17
[    4.580438] IRQ18 -> 0:18
[    4.580440] IRQ19 -> 0:19
[    4.580442] IRQ20 -> 0:20
[    4.580444] IRQ21 -> 0:21
[    4.580446] IRQ22 -> 0:22
[    4.580448] IRQ23 -> 0:23
[    4.580450] .................................... done.
[    4.580860] PM: Hibernation image not present or could not be loaded.
[    4.580893] registered taskstats version 1
[    4.581642]   Magic number: 15:11:135
[    4.581662] block ram0: hash matches
[    4.581752] netconsole: local port 6665
[    4.581753] netconsole: local IP 10.0.0.0
[    4.581754] netconsole: interface 'eth0'
[    4.581755] netconsole: remote port 6666
[    4.581756] netconsole: remote IP 192.168.1.1
[    4.581757] netconsole: remote ethernet address 00:30:48:fe:19:95
[    4.581759] netconsole: device eth0 not up yet, forcing it
[    4.616859] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.617212] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.617566] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.635341] hub 1-0:1.0: state 7 ports 6 chg 0016 evt 0000
[    4.635700] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.640298]  sda: sda1 sda2 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    4.642044] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.677358] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    4.686365] ehci_hcd 0000:00:1a.7: port 1 high speed
[    4.686699] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    4.728055] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    4.728745] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.737967] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    4.791041] ehci_hcd 0000:00:1a.7: port 1 high speed
[    4.791376] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    4.804786] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.861660] usb 1-1: default language 0x0409
[    4.868591] usb 1-1: udev 2, busnum 1, minor = 1
[    4.868910] usb 1-1: New USB device found, idVendor=0b95, idProduct=1780
[    4.869304] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.869727] usb 1-1: Product: AX88178 
[    4.870015] usb 1-1: Manufacturer: ASIX Elec. Corp.
[    4.870342] usb 1-1: SerialNumber: 000013
[    4.870809] usb 1-1: usb_probe_device
[    4.871093] usb 1-1: configuration #1 chosen from 1 choice
[    4.872057] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    4.873049] asix 1-1:1.0: usb_probe_interface
[    4.873358] asix 1-1:1.0: usb_probe_interface - got id
[    4.879261] ata2.00: ATAPI: PLEXTOR DVDR   PX-712A, 1.07, max UDMA/33
[    4.879674] ata2.00: applying bridge limits
[    4.910499] ata2.00: configured for UDMA/33
[    4.911951] scsi 1:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-712A   1.07 PQ: 0 ANSI: 5
[    5.216594] ata8: SATA link down (SStatus 0 SControl 300)
[    5.585475] asix 1-1:1.0: eth1: register 'asix' at usb-0000:00:1a.7-1, ASIX AX88178 USB 2.0 Ethernet, 00:23:54:5c:02:83
[    5.586147] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    5.586628] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    5.587011] ehci_hcd 0000:00:1a.7: port 2 low speed --> companion
[    5.638221] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    5.638842] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    5.685046] usb usb8: suspend_rh (auto-stop)
[    5.685052] usb usb5: suspend_rh (auto-stop)
[    5.685080] usb usb6: suspend_rh (auto-stop)
[    5.685101] usb usb7: suspend_rh (auto-stop)
[    5.685132] usb usb4: suspend_rh (auto-stop)
[    5.690253] ehci_hcd 0000:00:1a.7: port 4 high speed
[    5.690587] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    5.741839] usb 1-4: new high-speed USB device number 4 using ehci_hcd
[    5.792936] ehci_hcd 0000:00:1a.7: port 4 high speed
[    5.793271] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    6.792058] usb 1-4: default language 0x0409
[    6.793792] usb 1-4: udev 4, busnum 1, minor = 3
[    6.794118] usb 1-4: New USB device found, idVendor=1307, idProduct=0165
[    6.794512] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    6.794938] usb 1-4: Product: USB Mass Storage Device
[    6.795276] usb 1-4: Manufacturer: Teclast Technology
[    6.795620] usb 1-4: SerialNumber: 0000000000020D
[    6.796126] usb 1-4: usb_probe_device
[    6.796410] usb 1-4: configuration #1 chosen from 1 choice
[    6.796852] usb 1-4: adding 1-4:1.0 (config #1, interface 0)
[    6.797355] usb-storage 1-4:1.0: usb_probe_interface
[    6.797703] usb-storage 1-4:1.0: usb_probe_interface - got id
[    6.798340] scsi9 : usb-storage 1-4:1.0
[    6.799167] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[    6.799691] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    6.800046] uhci_hcd 0000:00:1a.0: port 2 portsc 01a3,00
[    6.800396] hub 3-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    6.904320] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    7.006011] usb 3-2: new low-speed USB device number 2 using uhci_hcd
[    7.179318] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[    7.180134] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    7.183224] console [netcon0] enabled
[    7.183516] netconsole: network logging started
[    7.184110] rtc_cmos 00:02: setting system clock to 2011-10-31 15:08:14 UTC (1320073694)
[    7.199461] IP-Config: Complete:
[    7.199749]      device=eth0, addr=192.168.1.52, mask=255.255.255.0, gw=192.168.1.1,
[    7.200345]      host=fat, domain=, nis-domain=(none),
[    7.200744]      bootserver=192.168.1.11, rootserver=192.168.1.11, rootpath=
[    7.201837] md: Waiting for all devices to be available before autodetect
[    7.202262] md: If you don't use raid, use raid=noautodetect
[    7.203175] md: Autodetecting RAID arrays.
[    7.203485] md: Scanned 0 and added 0 devices.
[    7.203801] md: autorun ...
[    7.204054] md: ... autorun DONE.
[    7.209071] usb 3-2: skipped 1 descriptor after interface
[    7.209478] usb 3-2: skipped 1 descriptor after interface
[    7.216044] usb 3-2: default language 0x0409
[    7.247944] usb 3-2: udev 2, busnum 3, minor = 257
[    7.248311] usb 3-2: New USB device found, idVendor=0557, idProduct=2220
[    7.248712] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.249208] usb 3-2: Product: ATEN  CS-1758/54
[    7.249528] usb 3-2: Manufacturer: ATEN
[    7.249978] usb 3-2: usb_probe_device
[    7.250284] usb 3-2: configuration #1 chosen from 1 choice
[    7.252959] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[    7.291931] usbserial_generic 3-2:1.0: usb_probe_interface
[    7.292298] usbserial_generic 3-2:1.0: usb_probe_interface - got id
[    7.292720] usbhid 3-2:1.0: usb_probe_interface
[    7.293079] usbhid 3-2:1.0: usb_probe_interface - got id
[    7.327419] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input4
[    7.328153] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    7.329022] generic-usb 0003:0557:2220.0001: input: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input0
[    7.329795] usb 3-2: adding 3-2:1.1 (config #1, interface 1)
[    7.339840] usbserial_generic 3-2:1.1: usb_probe_interface
[    7.340300] usbserial_generic 3-2:1.1: usb_probe_interface - got id
[    7.340720] usbhid 3-2:1.1: usb_probe_interface
[    7.341108] usbhid 3-2:1.1: usb_probe_interface - got id
[    7.369221] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.1/input/input5
[    7.370412] generic-usb 0003:0557:2220.0002: input: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input1
[    7.371204] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    7.371684] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.372085] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    7.796859] scsi 9:0:0:0: Direct-Access     Teclast  CoolFlash        0.00 PQ: 0 ANSI: 2
[    7.797630] scsi: killing requests for dead queue
[    7.798243] scsi: killing requests for dead queue
[    7.798849] scsi: killing requests for dead queue
[    7.799411] scsi: killing requests for dead queue
[    7.800004] scsi: killing requests for dead queue
[    7.800584] scsi: killing requests for dead queue
[    7.801143] scsi: killing requests for dead queue
[    7.802326] scsi_scan_9 used greatest stack depth: 4968 bytes left
[    7.803895] sd 9:0:0:0: [sdb] 63084544 512-byte logical blocks: (32.2 GB/30.0 GiB)
[    7.805116] sd 9:0:0:0: [sdb] Write Protect is off
[    7.805470] sd 9:0:0:0: [sdb] Mode Sense: 00 00 00 00
[    7.806538] sd 9:0:0:0: [sdb] Asking for cache data failed
[    7.806906] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    7.811861] sd 9:0:0:0: [sdb] Asking for cache data failed
[    7.812232] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    7.946224]  sdb: sdb1 sdb2 sdb3
[    7.951138] sd 9:0:0:0: [sdb] Asking for cache data failed
[    7.951508] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    7.951899] sd 9:0:0:0: [sdb] Attached SCSI removable disk
[    8.210492] VFS: Mounted root (nfs filesystem) on device 0:16.
[    8.210919] debug: unmapping init memory ffffffff81f3a000..ffffffff821ee000
[    8.317368] stty used greatest stack depth: 4624 bytes left
[    8.334815] startpar used greatest stack depth: 3760 bytes left
[    8.359897] sed used greatest stack depth: 3680 bytes left
[    8.394067] S02hostname.sh used greatest stack depth: 3648 bytes left
[    8.415688] mountpoint used greatest stack depth: 3552 bytes left
[    8.703704] input_id used greatest stack depth: 3472 bytes left
[   10.769469] EXT4-fs (sda5): recovery complete
[   10.769862] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   11.210789] grep used greatest stack depth: 3376 bytes left
[   11.755641] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   11.756270] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   11.758253] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   11.758829] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   12.388890] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   12.390334] NFSD: starting 90-second grace period
[   12.736493] udevadm used greatest stack depth: 3312 bytes left
[   13.829866] mount.nfs used greatest stack depth: 2640 bytes left
[   18.018828] eth0: no IPv6 routers present
[  120.880818] XFS (sda7): Mounting Filesystem
[  120.951448] XFS (sda7): Ending clean mount
[  121.531949] XFS (sdb3): Mounting Filesystem
[  122.270060] XFS (sdb3): Ending clean mount

--RnlQjJ0d97Da+TV1
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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

--RnlQjJ0d97Da+TV1--

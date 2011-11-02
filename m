Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab1KBQVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:21:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:28988 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431Ab1KBQV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:21:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,444,1315206000"; 
   d="scan'208";a="69777489"
Date: Thu, 3 Nov 2011 00:21:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: FS <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [linux-next warning] VFS: do_fd_request called on non-open device
Message-ID: <20111102162113.GB6717@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I got this warning in latest next-20111102 and next-20111025.  The
last working kernel is next-20111014. Wondering if anybody has the
quick answer.

[    7.365671] floppy0: no floppy controllers found
[    7.366160] ------------[ cut here ]------------
[    7.366485] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    7.367073] Hardware name:         
[    7.367351] VFS: do_fd_request called on non-open device
[    7.367697] Modules linked in:
[    7.367994] Pid: 1, comm: swapper Not tainted 3.1.0-ioless-full-next-20111102+ #891
[    7.368542] Call Trace:
[    7.368786]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    7.369159]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    7.369524]  [<ffffffff813ec2d2>] ? blk_throtl_drain+0x11a/0x13b
[    7.369898]  [<ffffffff8198604e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    7.370278]  [<ffffffff8151bc61>] do_fd_request+0x37/0xaa
[    7.370630]  [<ffffffff813d9866>] __blk_run_queue+0x1e/0x20
[    7.370988]  [<ffffffff813ded77>] blk_drain_queue+0x41/0x7a
[    7.371345]  [<ffffffff813deed5>] blk_cleanup_queue+0x125/0x184
[    7.371718]  [<ffffffff82146452>] floppy_init+0xd9c/0xdc2
[    7.372067]  [<ffffffff821456b6>] ? daring+0x65/0x65
[    7.372403]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    7.372765]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    7.373114]  [<ffffffff8198eec4>] kernel_thread_helper+0x4/0x10
[    7.373484]  [<ffffffff819862f4>] ? retint_restore_args+0x13/0x13
[    7.373861]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    7.374222]  [<ffffffff8198eec0>] ? gs_change+0x13/0x13
[    7.374569] ---[ end trace 06a7c1a65a7ee637 ]---

Full dmesg and kconfig attached.

Thanks,
Fengguang

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-ioless-full-next-20111102+ (wfg@bee) (gcc version 4.5.0 (GCC) ) #891 SMP Wed Nov 2 23:36:24 CST 2011
[    0.000000] Command line: hpet=disable run=/home/wfg/ioless-balance_dirty_pages/test-each-fs.sh log_buf_len=8M debug sched_debug apic=debug dynamic_printk drm.debug=6 sysrq_always_enabled panic=10 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 netconsole=@:/eth0,6666@192.168.1.1/00:30:48:fe:19:95 ip=192.168.1.52:192.168.1.11:192.168.1.1:255.255.255.0:fat:eth0:none nfsroot=192.168.1.11:/nfsroot/wfg,tcp,v3,nocto,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-3.1.0-ioless-full-next-20111102+ 
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
[    0.000000] Kernel command line: hpet=disable run=/home/wfg/ioless-balance_dirty_pages/test-each-fs.sh log_buf_len=8M debug sched_debug apic=debug dynamic_printk drm.debug=6 sysrq_always_enabled panic=10 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 netconsole=@:/eth0,6666@192.168.1.1/00:30:48:fe:19:95 ip=192.168.1.52:192.168.1.11:192.168.1.1:255.255.255.0:fat:eth0:none nfsroot=192.168.1.11:/nfsroot/wfg,tcp,v3,nocto,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-3.1.0-ioless-full-next-20111102+ 
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 3012404k/3137536k available (9805k kernel code, 3396k absent, 121736k reserved, 5806k data, 2768k init)
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
[    0.002000] Detected 3199.911 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6399.82 BogoMIPS (lpj=3199911)
[    0.000706] pid_max: default: 32768 minimum: 301
[    0.001886] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003949] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004948] Mount-cache hash table entries: 256
[    0.005657] Initializing cgroup subsys debug
[    0.005966] Initializing cgroup subsys cpuacct
[    0.006299] Initializing cgroup subsys memory
[    0.006635] Initializing cgroup subsys devices
[    0.006950] Initializing cgroup subsys freezer
[    0.007276] Initializing cgroup subsys blkio
[    0.007640] CPU: Physical Processor ID: 0
[    0.007939] CPU: Processor Core ID: 0
[    0.008237] mce: CPU supports 9 MCE banks
[    0.008543] CPU0: Thermal monitoring enabled (TM1)
[    0.008880] using mwait in idle threads.
[    0.010042] ACPI: Core revision 20110623
[    0.021693] ftrace: allocating 38082 entries in 150 pages
[    0.030583] Getting VERSION: 60015
[    0.030860] Getting VERSION: 60015
[    0.031136] Getting ID: 0
[    0.031392] Getting ID: 0
[    0.031638] Switched APIC routing to physical flat.
[    0.031969] enabled ExtINT on CPU#0
[    0.032477] ENABLING IO-APIC IRQs
[    0.032751] init IO_APIC IRQs
[    0.033010]  apic 8 pin 0 not connected
[    0.033317] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.033882] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.034455] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.035020] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.035588] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.036152] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.036721] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.037289] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.037855] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.038423] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.038994] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.039568] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.040139] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.040712] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.041284] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.041852]  apic 8 pin 16 not connected
[    0.042147]  apic 8 pin 17 not connected
[    0.042444]  apic 8 pin 18 not connected
[    0.042738]  apic 8 pin 19 not connected
[    0.043033]  apic 8 pin 20 not connected
[    0.043330]  apic 8 pin 21 not connected
[    0.043624]  apic 8 pin 22 not connected
[    0.043918]  apic 8 pin 23 not connected
[    0.044349] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054722] CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
[    0.055205] Using local APIC timer interrupts.
[    0.055206] calibrating APIC timer ...
[    0.157162] ... lapic delta = 833238
[    0.157442] ... PM-Timer delta = 357901
[    0.157733] ... PM-Timer result ok
[    0.158006] ..... delta 833238
[    0.158268] ..... mult: 35792740
[    0.158536] ..... calibration result: 133318
[    0.158843] ..... CPU clock speed is 3199.0635 MHz.
[    0.159173] ..... host bus clock speed is 133.0318 MHz.
[    0.159530] Performance Events: PEBS fmt1+, erratum AAJ80 worked around, Nehalem events, Intel PMU driver.
[    0.160294] ... version:                3
[    0.160595] ... bit width:              48
[    0.160897] ... generic registers:      4
[    0.161195] ... value mask:             0000ffffffffffff
[    0.161543] ... max period:             000000007fffffff
[    0.161889] ... fixed-purpose events:   3
[    0.162187] ... event mask:             000000070000000f
[    0.162735] Testing tracer nop: PASSED
[    0.163145] lockdep: fixing up alternatives.
[    0.163510] Booting Node   0, Processors  #1
[    0.163733] smpboot cpu 1: start_ip = 97000
[    0.175301] masked ExtINT on CPU#1
[    0.195648] lockdep: fixing up alternatives.
[    0.195981]  #2
[    0.196073] smpboot cpu 2: start_ip = 97000
[    0.207645] masked ExtINT on CPU#2
[    0.227971] lockdep: fixing up alternatives.
[    0.228305]  #3
[    0.228397] smpboot cpu 3: start_ip = 97000
[    0.239966] masked ExtINT on CPU#3
[    0.260287] lockdep: fixing up alternatives.
[    0.260627]  #4
[    0.260719] smpboot cpu 4: start_ip = 97000
[    0.272288] masked ExtINT on CPU#4
[    0.292622] lockdep: fixing up alternatives.
[    0.292956]  #5
[    0.293048] smpboot cpu 5: start_ip = 97000
[    0.307590] masked ExtINT on CPU#5
[    0.327915] lockdep: fixing up alternatives.
[    0.328252]  #6
[    0.328344] smpboot cpu 6: start_ip = 97000
[    0.339914] masked ExtINT on CPU#6
[    0.360235] lockdep: fixing up alternatives.
[    0.360574]  #7
[    0.360667] smpboot cpu 7: start_ip = 97000
[    2.001023] masked ExtINT on CPU#7
[    2.121239] Brought up 8 CPUs
[    2.121501] Total of 8 processors activated (51198.57 BogoMIPS).
[    2.125305] CPU0 attaching sched-domain:
[    2.125603]  domain 0: span 0,4 level SIBLING
[    2.125947]   groups: 0 (cpu_power = 589) 4 (cpu_power = 589)
[    2.126480]   domain 1: span 0-7 level MC
[    2.126810]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    2.127765] CPU1 attaching sched-domain:
[    2.128063]  domain 0: span 1,5 level SIBLING
[    2.128407]   groups: 1 (cpu_power = 589) 5 (cpu_power = 589)
[    2.128936]   domain 1: span 0-7 level MC
[    2.129270]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    2.130225] CPU2 attaching sched-domain:
[    2.130519]  domain 0: span 2,6 level SIBLING
[    2.130863]   groups: 2 (cpu_power = 589) 6 (cpu_power = 589)
[    2.131394]   domain 1: span 0-7 level MC
[    2.131725]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    2.132679] CPU3 attaching sched-domain:
[    2.132973]  domain 0: span 3,7 level SIBLING
[    2.133320]   groups: 3 (cpu_power = 589) 7 (cpu_power = 589)
[    2.133849]   domain 1: span 0-7 level MC
[    2.134183]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    2.135138] CPU4 attaching sched-domain:
[    2.135432]  domain 0: span 0,4 level SIBLING
[    2.135776]   groups: 4 (cpu_power = 589) 0 (cpu_power = 589)
[    2.136308]   domain 1: span 0-7 level MC
[    2.136638]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    2.137592] CPU5 attaching sched-domain:
[    2.137886]  domain 0: span 1,5 level SIBLING
[    2.138232]   groups: 5 (cpu_power = 589) 1 (cpu_power = 589)
[    2.138762]   domain 1: span 0-7 level MC
[    2.139095]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    2.140048] CPU6 attaching sched-domain:
[    2.140343]  domain 0: span 2,6 level SIBLING
[    2.140686]   groups: 6 (cpu_power = 589) 2 (cpu_power = 589)
[    2.141218]   domain 1: span 0-7 level MC
[    2.141548]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    2.142504] CPU7 attaching sched-domain:
[    2.142800]  domain 0: span 3,7 level SIBLING
[    2.143147]   groups: 7 (cpu_power = 589) 3 (cpu_power = 589)
[    2.143677]   domain 1: span 0-7 level MC
[    2.144011]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    2.145412] devtmpfs: initialized
[    2.146683] PM: Registering ACPI NVS region at bcde3000 (2195456 bytes)
[    2.147141] PM: Registering ACPI NVS region at bf714000 (700416 bytes)
[    2.148220] xor: automatically using best checksumming function: generic_sse
[    2.152974]    generic_sse: 11932.000 MB/sec
[    2.153282] xor: using function: generic_sse (11932.000 MB/sec)
[    2.153768] kworker/u:0 used greatest stack depth: 5608 bytes left
[    2.153795] RTC time:  0:03:22, date: 11/03/11
[    2.153881] NET: Registered protocol family 16
[    2.154778] kworker/u:0 used greatest stack depth: 5192 bytes left
[    2.155661] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    2.156216] ACPI: bus type pci registered
[    2.156711] dca service started, version 1.12.1
[    2.157114] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    2.157726] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    2.170991] PCI: Using configuration type 1 for base access
[    2.195600] bio: create slab <bio-0> at 0
[    2.212967] raid6: int64x1   3171 MB/s
[    2.229961] raid6: int64x2   3289 MB/s
[    2.246957] raid6: int64x4   2738 MB/s
[    2.263943] raid6: int64x8   2089 MB/s
[    2.280941] raid6: sse2x1    7929 MB/s
[    2.297935] raid6: sse2x2    9296 MB/s
[    2.314937] raid6: sse2x4   10660 MB/s
[    2.315225] raid6: using algorithm sse2x4 (10660 MB/s)
[    2.315646] ACPI: Added _OSI(Module Device)
[    2.315958] ACPI: Added _OSI(Processor Device)
[    2.316273] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.316597] ACPI: Added _OSI(Processor Aggregator Device)
[    2.320936] ACPI: EC: Look up EC in DSDT
[    2.341944] ACPI: Interpreter enabled
[    2.342231] ACPI: (supports S0 S1 S3 S4 S5)
[    2.342737] ACPI: Using IOAPIC for interrupt routing
[    2.355639] ACPI: No dock devices found.
[    2.355941] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.357145] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3d])
[    2.358765] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    2.359164] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    2.359559] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    2.360101] pci_root PNP0A03:00: host bridge window [mem 0x000c4000-0x000cbfff]
[    2.360638] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfedfffff]
[    2.361178] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xf7ffffff]
[    2.361738] pci 0000:00:00.0: [8086:3405] type 0 class 0x000600
[    2.362182] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    2.362608] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.362997] pci 0000:00:01.0: PME# disabled
[    2.363330] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    2.363757] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    2.364138] pci 0000:00:03.0: PME# disabled
[    2.364471] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    2.364897] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    2.365278] pci 0000:00:07.0: PME# disabled
[    2.365612] pci 0000:00:10.0: [8086:3425] type 0 class 0x000800
[    2.366066] pci 0000:00:10.1: [8086:3426] type 0 class 0x000800
[    2.366512] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    2.366961] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    2.367405] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    2.367846] pci 0000:00:14.3: [8086:3438] type 0 class 0x000800
[    2.368298] pci 0000:00:19.0: [8086:10cc] type 0 class 0x000200
[    2.368686] pci 0000:00:19.0: reg 10: [mem 0xe0300000-0xe031ffff]
[    2.369073] pci 0000:00:19.0: reg 14: [mem 0xe0323000-0xe0323fff]
[    2.369457] pci 0000:00:19.0: reg 18: [io  0x2100-0x211f]
[    2.369864] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    2.370248] pci 0000:00:19.0: PME# disabled
[    2.370571] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    2.370997] pci 0000:00:1a.0: reg 20: [io  0x20e0-0x20ff]
[    2.371401] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
[    2.371822] pci 0000:00:1a.1: reg 20: [io  0x20c0-0x20df]
[    2.372230] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    2.372651] pci 0000:00:1a.2: reg 20: [io  0x20a0-0x20bf]
[    2.373066] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    2.373456] pci 0000:00:1a.7: reg 10: [mem 0xe0322000-0xe03223ff]
[    2.373920] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    2.374300] pci 0000:00:1a.7: PME# disabled
[    2.374630] pci 0000:00:1b.0: [8086:3a3e] type 0 class 0x000403
[    2.375022] pci 0000:00:1b.0: reg 10: [mem 0xf7f00000-0xf7f03fff 64bit]
[    2.375487] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    2.375865] pci 0000:00:1b.0: PME# disabled
[    2.376195] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    2.376633] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.377014] pci 0000:00:1c.0: PME# disabled
[    2.377343] pci 0000:00:1c.1: [8086:3a42] type 1 class 0x000604
[    2.377780] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    2.378162] pci 0000:00:1c.1: PME# disabled
[    2.378494] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    2.378938] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    2.379316] pci 0000:00:1c.4: PME# disabled
[    2.379648] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    2.380073] pci 0000:00:1d.0: reg 20: [io  0x2080-0x209f]
[    2.380477] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    2.380898] pci 0000:00:1d.1: reg 20: [io  0x2060-0x207f]
[    2.381309] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    2.381732] pci 0000:00:1d.2: reg 20: [io  0x2040-0x205f]
[    2.382152] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    2.382543] pci 0000:00:1d.7: reg 10: [mem 0xe0321000-0xe03213ff]
[    2.383011] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.383391] pci 0000:00:1d.7: PME# disabled
[    2.383713] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    2.384156] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    2.384622] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    2.385009] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    2.385560] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
[    2.386156] pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
[    2.386546] pci 0000:00:1f.2: reg 10: [io  0x2128-0x212f]
[    2.386905] pci 0000:00:1f.2: reg 14: [io  0x2134-0x2137]
[    2.387266] pci 0000:00:1f.2: reg 18: [io  0x2120-0x2127]
[    2.387625] pci 0000:00:1f.2: reg 1c: [io  0x2130-0x2133]
[    2.387986] pci 0000:00:1f.2: reg 20: [io  0x2020-0x203f]
[    2.388345] pci 0000:00:1f.2: reg 24: [mem 0xe0320000-0xe03207ff]
[    2.388760] pci 0000:00:1f.2: PME# supported from D3hot
[    2.389109] pci 0000:00:1f.2: PME# disabled
[    2.389432] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    2.389819] pci 0000:00:1f.3: reg 10: [mem 0xf7f04000-0xf7f040ff 64bit]
[    2.390242] pci 0000:00:1f.3: reg 20: [io  0x2000-0x201f]
[    2.393643] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.394051] pci 0000:02:00.0: [5333:9043] type 0 class 0x000300
[    2.394431] pci 0000:02:00.0: reg 10: [mem 0xe0200000-0xe027ffff]
[    2.394814] pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff pref]
[    2.395245] pci 0000:02:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    2.395659] pci 0000:02:00.0: supports D1 D2
[    2.395992] pci 0000:02:00.1: [5333:903f] type 0 class 0x000403
[    2.396371] pci 0000:02:00.1: reg 10: [mem 0xe0280000-0xe0283fff]
[    2.396814] pci 0000:02:00.1: supports D1 D2
[    2.397142] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    2.397489] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    2.397892] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.398491] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    2.398891] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    2.399298] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    2.399725] pci 0000:06:00.0: [11ab:6121] type 0 class 0x000101
[    2.400119] pci 0000:06:00.0: reg 10: [io  0x1018-0x101f]
[    2.400484] pci 0000:06:00.0: reg 14: [io  0x1024-0x1027]
[    2.400849] pci 0000:06:00.0: reg 18: [io  0x1010-0x1017]
[    2.401216] pci 0000:06:00.0: reg 1c: [io  0x1020-0x1023]
[    2.401580] pci 0000:06:00.0: reg 20: [io  0x1000-0x100f]
[    2.401947] pci 0000:06:00.0: reg 24: [mem 0xe0100000-0xe01003ff]
[    2.402386] pci 0000:06:00.0: supports D1
[    2.402684] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
[    2.403054] pci 0000:06:00.0: PME# disabled
[    2.403379] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    2.403725] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    2.404106] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    2.404553] pci 0000:07:03.0: [104c:8023] type 0 class 0x000c00
[    2.404945] pci 0000:07:03.0: reg 10: [mem 0xe0004000-0xe00047ff]
[    2.405331] pci 0000:07:03.0: reg 14: [mem 0xe0000000-0xe0003fff]
[    2.405780] pci 0000:07:03.0: supports D1 D2
[    2.406091] pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
[    2.406465] pci 0000:07:03.0: PME# disabled
[    2.406823] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    2.407241] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    2.407647] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    2.408209] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    2.408768] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    2.409356] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000cbfff] (subtractive decode)
[    2.409944] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    2.410528] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xf7ffffff] (subtractive decode)
[    2.411150] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.412896] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    2.413519] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
[    2.413996] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
[    2.414462] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
[    2.414934] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    2.415400] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    2.415876] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    2.416439]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
[    2.439761] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    2.440841] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    2.441930] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    2.443010] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    2.444092] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    2.445172] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    2.446249] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    2.447329] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    2.448644] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    2.449223] vgaarb: loaded
[    2.449472] vgaarb: bridge control possible 0000:02:00.0
[    2.450033] SCSI subsystem initialized
[    2.450495] libata version 3.00 loaded.
[    2.451058] usbcore: registered new interface driver usbfs
[    2.451472] usbcore: registered new interface driver hub
[    2.451894] usbcore: registered new device driver usb
[    2.452676] wmi: Mapper loaded
[    2.453010] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    2.453395] PCI: Using ACPI for IRQ routing
[    2.455280] PCI: Discovered peer bus 3f
[    2.455652] pci 0000:3f:00.0: [8086:2c41] type 0 class 0x000600
[    2.456058] pci 0000:3f:00.1: [8086:2c01] type 0 class 0x000600
[    2.456461] pci 0000:3f:02.0: [8086:2c10] type 0 class 0x000600
[    2.456857] pci 0000:3f:02.1: [8086:2c11] type 0 class 0x000600
[    2.457264] pci 0000:3f:03.0: [8086:2c18] type 0 class 0x000600
[    2.457661] pci 0000:3f:03.1: [8086:2c19] type 0 class 0x000600
[    2.458062] pci 0000:3f:03.4: [8086:2c1c] type 0 class 0x000600
[    2.458462] pci 0000:3f:04.0: [8086:2c20] type 0 class 0x000600
[    2.458859] pci 0000:3f:04.1: [8086:2c21] type 0 class 0x000600
[    2.459260] pci 0000:3f:04.2: [8086:2c22] type 0 class 0x000600
[    2.459657] pci 0000:3f:04.3: [8086:2c23] type 0 class 0x000600
[    2.460064] pci 0000:3f:05.0: [8086:2c28] type 0 class 0x000600
[    2.460461] pci 0000:3f:05.1: [8086:2c29] type 0 class 0x000600
[    2.460858] pci 0000:3f:05.2: [8086:2c2a] type 0 class 0x000600
[    2.461258] pci 0000:3f:05.3: [8086:2c2b] type 0 class 0x000600
[    2.461659] pci 0000:3f:06.0: [8086:2c30] type 0 class 0x000600
[    2.462061] pci 0000:3f:06.1: [8086:2c31] type 0 class 0x000600
[    2.462461] pci 0000:3f:06.2: [8086:2c32] type 0 class 0x000600
[    2.462859] pci 0000:3f:06.3: [8086:2c33] type 0 class 0x000600
[    2.464674] PCI: pci_cache_line_size set to 64 bytes
[    2.465247] reserve RAM buffer: 000000000009cc00 - 000000000009ffff 
[    2.465509] reserve RAM buffer: 00000000bcde3000 - 00000000bfffffff 
[    2.465932] reserve RAM buffer: 00000000bf6bd000 - 00000000bfffffff 
[    2.466350] reserve RAM buffer: 00000000bf714000 - 00000000bfffffff 
[    2.466769] reserve RAM buffer: 00000000bf7e7000 - 00000000bfffffff 
[    2.467191] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff 
[    2.495871] pnp: PnP ACPI init
[    2.496316] ACPI: bus type pnp registered
[    2.497234] pnp 00:00: [bus 00-3d]
[    2.497510] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.497811] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.498139] pnp 00:00: [io  0x0d00-0xffff window]
[    2.498464] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.498813] pnp 00:00: [mem 0x000c4000-0x000cbfff window]
[    2.499170] pnp 00:00: [mem 0xfed40000-0xfedfffff window]
[    2.499521] pnp 00:00: [mem 0xd0000000-0xf7ffffff window]
[    2.499871] pnp 00:00: [mem 0x00000000 window]
[    2.500334] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.501019] pnp 00:01: [io  0x0000-0x000f]
[    2.501321] pnp 00:01: [io  0x0081-0x0083]
[    2.501623] pnp 00:01: [io  0x0087]
[    2.501905] pnp 00:01: [io  0x0089-0x008b]
[    2.502206] pnp 00:01: [io  0x008f]
[    2.502484] pnp 00:01: [io  0x00c0-0x00df]
[    2.502786] pnp 00:01: [dma 4]
[    2.503146] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.503554] pnp 00:02: [io  0x0070-0x0071]
[    2.503855] pnp 00:02: [io  0x0074-0x0077]
[    2.504168] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    2.504733] pnp 00:02: [irq 8]
[    2.505092] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.505504] pnp 00:03: [io  0x00f0]
[    2.505785] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    2.506361] pnp 00:03: [irq 13]
[    2.506733] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.507149] pnp 00:04: [io  0x0061]
[    2.507523] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.507936] pnp 00:05: [io  0x0500-0x053f]
[    2.508237] pnp 00:05: [io  0x0400-0x047f]
[    2.508538] pnp 00:05: [io  0x0092]
[    2.508817] pnp 00:05: [io  0x0680-0x06ff]
[    2.509122] pnp 00:05: [io  0x0010-0x001f]
[    2.509423] pnp 00:05: [io  0x0072-0x0073]
[    2.509726] pnp 00:05: [io  0x0080]
[    2.510009] pnp 00:05: [io  0x0084-0x0086]
[    2.510311] pnp 00:05: [io  0x0088]
[    2.510591] pnp 00:05: [io  0x008c-0x008e]
[    2.510900] pnp 00:05: [io  0x0090-0x009f]
[    2.511380] system 00:05: [io  0x0500-0x053f] has been reserved
[    2.511750] system 00:05: [io  0x0400-0x047f] has been reserved
[    2.512123] system 00:05: [io  0x0680-0x06ff] has been reserved
[    2.512493] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.512975] pnp 00:06: [io  0x0060]
[    2.513254] pnp 00:06: [io  0x0064]
[    2.513696] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.514645] pnp 00:07: [mem 0xfec00000-0xfec000ff]
[    2.515088] pnp 00:07: Plug and Play ACPI device, IDs PNP0003 (active)
[    2.515616] pnp: PnP ACPI: found 8 devices
[    2.515923] ACPI: ACPI bus type pnp unregistered
[    2.527035] Switching to clocksource acpi_pm
[    2.527474] pci 0000:02:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    2.528103] PCI: max bus depth: 1 pci_try_num: 2
[    2.528518] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.528873] pci 0000:02:00.0: BAR 6: assigned [mem 0xe0290000-0xe029ffff pref]
[    2.529407] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    2.529762] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    2.530165] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.533705] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    2.534057] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    2.534411] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    2.534772] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    2.535117] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    2.535506] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    2.535914] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    2.536259] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    2.536691] IOAPIC[0]: Set routing entry (8-16 -> 0x29 -> IRQ 16 Mode:1 Active:1 Dest:0)
[    2.537259] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.537674] pci 0000:00:01.0: setting latency timer to 64
[    2.538029] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.538427] pci 0000:00:03.0: setting latency timer to 64
[    2.538791] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.539192] pci 0000:00:07.0: setting latency timer to 64
[    2.539563] IOAPIC[0]: Set routing entry (8-17 -> 0x41 -> IRQ 17 Mode:1 Active:1 Dest:0)
[    2.540132] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.540544] pci 0000:00:1c.0: setting latency timer to 64
[    2.540899] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.541299] pci 0000:00:1c.1: setting latency timer to 64
[    2.541667] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.542067] pci 0000:00:1c.4: setting latency timer to 64
[    2.542422] pci 0000:00:1e.0: setting latency timer to 64
[    2.542781] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.543138] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.543505] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.543886] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000cbfff]
[    2.544268] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfedfffff]
[    2.544659] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xf7ffffff]
[    2.545041] pci_bus 0000:02: resource 1 [mem 0xe0200000-0xe02fffff]
[    2.545423] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.545967] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    2.546322] pci_bus 0000:06: resource 1 [mem 0xe0100000-0xe01fffff]
[    2.546711] pci_bus 0000:07: resource 1 [mem 0xe0000000-0xe00fffff]
[    2.547092] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    2.547448] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    2.547811] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    2.548192] pci_bus 0000:07: resource 7 [mem 0x000c4000-0x000cbfff]
[    2.548584] pci_bus 0000:07: resource 8 [mem 0xfed40000-0xfedfffff]
[    2.548965] pci_bus 0000:07: resource 9 [mem 0xd0000000-0xf7ffffff]
[    2.549346] pci_bus 0000:3f: resource 0 [io  0x0000-0xffff]
[    2.549711] pci_bus 0000:3f: resource 1 [mem 0x00000000-0xfffffffff]
[    2.550152] NET: Registered protocol family 2
[    2.550786] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.553171] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.556927] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    2.560472] TCP: Hash tables configured (established 524288 bind 65536)
[    2.560884] TCP reno registered
[    2.561217] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    2.561870] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    2.562633] NET: Registered protocol family 1
[    2.563155] RPC: Registered named UNIX socket transport module.
[    2.563544] RPC: Registered udp transport module.
[    2.563869] RPC: Registered tcp transport module.
[    2.564194] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.564634] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    2.565025] pci 0000:00:1a.0: Performing full reset
[    2.565372] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    2.565769] pci 0000:00:1a.1: Performing full reset
[    2.566116] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
[    2.566515] pci 0000:00:1a.2: Performing full reset
[    2.567014] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    2.567405] pci 0000:00:1d.0: Performing full reset
[    2.567774] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    2.568166] pci 0000:00:1d.1: Performing full reset
[    2.568523] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    2.568914] pci 0000:00:1d.2: Performing full reset
[    2.569401] pci 0000:02:00.0: Boot video device
[    2.569781] PCI: CLS 64 bytes, default 64
[    2.573954] Machine check injector initialized
[    2.576115] microcode: CPU0 sig=0x106a4, pf=0x2, revision=0x6
[    2.576503] microcode: CPU1 sig=0x106a4, pf=0x2, revision=0x6
[    2.576875] microcode: CPU2 sig=0x106a4, pf=0x2, revision=0x6
[    2.577245] microcode: CPU3 sig=0x106a4, pf=0x2, revision=0x6
[    2.577622] microcode: CPU4 sig=0x106a4, pf=0x2, revision=0x6
[    2.577994] microcode: CPU5 sig=0x106a4, pf=0x2, revision=0x6
[    2.578367] microcode: CPU6 sig=0x106a4, pf=0x2, revision=0x6
[    2.578736] microcode: CPU7 sig=0x106a4, pf=0x2, revision=0x6
[    2.579196] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.580240] audit: initializing netlink socket (disabled)
[    2.580630] type=2000 audit(1320278600.702:1): initialized
[    2.615492] Testing tracer function: PASSED
[    2.751360] Testing dynamic ftrace: PASSED
[    2.988689] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 1049) (2 2 4 1 1291) PASSED
[    3.076174] Testing dynamic ftrace ops #2: (1 0 1 990 0) (1 1 2 1208 0) (2 1 3 7 1228) (2 2 4 451 1642) PASSED
[    3.217519] Testing tracer irqsoff: PASSED
[    3.293522] Testing tracer wakeup: 
[    3.573546] Refined TSC clocksource calibration: 3200.113 MHz.
[    3.574071] Switching to clocksource tsc
[    3.647519] PASSED
[    3.662528] Testing tracer wakeup_rt: PASSED
[    4.034541] Testing tracer function_graph: PASSED
[    4.194609] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.206370] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.207705] fuse init (API version 7.17)
[    4.208590] JFS: nTxBlock = 8192, nTxLock = 65536
[    4.212537] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    4.215055] NILFS version 2 loaded
[    4.216289] Btrfs loaded
[    4.216547] msgmni has been set to 5883
[    4.217803] async_tx: api initialized (async)
[    4.218304] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.218899] io scheduler noop registered
[    4.219195] io scheduler deadline registered
[    4.219647] io scheduler cfq registered (default)
[    4.220386] pcieport 0000:00:1c.0: setting latency timer to 64
[    4.220816] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    4.221288] pcieport 0000:00:1c.1: setting latency timer to 64
[    4.221711] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    4.222182] pcieport 0000:00:1c.4: setting latency timer to 64
[    4.222605] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    4.223274] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.224042] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    4.224631] ACPI: Sleep Button [SLPB]
[    4.225052] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.225600] ACPI: Power Button [PWRF]
[    4.226614] ACPI: acpi_idle registered with cpuidle
[    4.227345] Monitor-Mwait will be used to enter C-1 state
[    4.227746] Monitor-Mwait will be used to enter C-3 state
[    4.235026] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.237495] kworker/u:1 used greatest stack depth: 5184 bytes left
[    4.272337] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.293625] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    4.340807] Initializing Nozomi driver 2.1d
[    4.341569] Non-volatile memory driver v1.3
[    4.342333] Linux agpgart interface v0.103
[    4.342720] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    4.343317] Hangcheck: Using getrawmonotonic().
[    4.343695] [drm] Initialized drm 1.1.0 20060810
[    4.344017] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    7.365671] floppy0: no floppy controllers found
[    7.366160] ------------[ cut here ]------------
[    7.366485] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    7.367073] Hardware name:         
[    7.367351] VFS: do_fd_request called on non-open device
[    7.367697] Modules linked in:
[    7.367994] Pid: 1, comm: swapper Not tainted 3.1.0-ioless-full-next-20111102+ #891
[    7.368542] Call Trace:
[    7.368786]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    7.369159]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    7.369524]  [<ffffffff813ec2d2>] ? blk_throtl_drain+0x11a/0x13b
[    7.369898]  [<ffffffff8198604e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    7.370278]  [<ffffffff8151bc61>] do_fd_request+0x37/0xaa
[    7.370630]  [<ffffffff813d9866>] __blk_run_queue+0x1e/0x20
[    7.370988]  [<ffffffff813ded77>] blk_drain_queue+0x41/0x7a
[    7.371345]  [<ffffffff813deed5>] blk_cleanup_queue+0x125/0x184
[    7.371718]  [<ffffffff82146452>] floppy_init+0xd9c/0xdc2
[    7.372067]  [<ffffffff821456b6>] ? daring+0x65/0x65
[    7.372403]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    7.372765]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    7.373114]  [<ffffffff8198eec4>] kernel_thread_helper+0x4/0x10
[    7.373484]  [<ffffffff819862f4>] ? retint_restore_args+0x13/0x13
[    7.373861]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    7.374222]  [<ffffffff8198eec0>] ? gs_change+0x13/0x13
[    7.374569] ---[ end trace 06a7c1a65a7ee637 ]---
[    7.374984] ------------[ cut here ]------------
[    7.375307] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    7.375895] Hardware name:         
[    7.376173] VFS: do_fd_request called on non-open device
[    7.376520] Modules linked in:
[    7.376817] Pid: 1, comm: swapper Tainted: G        W    3.1.0-ioless-full-next-20111102+ #891
[    7.377400] Call Trace:
[    7.380614]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    7.380986]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    7.381348]  [<ffffffff813ec2d2>] ? blk_throtl_drain+0x11a/0x13b
[    7.381720]  [<ffffffff8198604e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    7.382099]  [<ffffffff8151bc61>] do_fd_request+0x37/0xaa
[    7.382449]  [<ffffffff813d9866>] __blk_run_queue+0x1e/0x20
[    7.382805]  [<ffffffff813ded77>] blk_drain_queue+0x41/0x7a
[    7.383162]  [<ffffffff813deed5>] blk_cleanup_queue+0x125/0x184
[    7.383532]  [<ffffffff82146452>] floppy_init+0xd9c/0xdc2
[    7.383881]  [<ffffffff821456b6>] ? daring+0x65/0x65
[    7.384216]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    7.384576]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    7.384922]  [<ffffffff8198eec4>] kernel_thread_helper+0x4/0x10
[    7.385292]  [<ffffffff819862f4>] ? retint_restore_args+0x13/0x13
[    7.385667]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    7.386027]  [<ffffffff8198eec0>] ? gs_change+0x13/0x13
[    7.386370] ---[ end trace 06a7c1a65a7ee638 ]---
[    7.386738] ------------[ cut here ]------------
[    7.387059] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    7.387647] Hardware name:         
[    7.387925] VFS: do_fd_request called on non-open device
[    7.388270] Modules linked in:
[    7.388566] Pid: 1, comm: swapper Tainted: G        W    3.1.0-ioless-full-next-20111102+ #891
[    7.389150] Call Trace:
[    7.389392]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    7.389764]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    7.390127]  [<ffffffff813ec2d2>] ? blk_throtl_drain+0x11a/0x13b
[    7.390499]  [<ffffffff8198604e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    7.390878]  [<ffffffff8151bc61>] do_fd_request+0x37/0xaa
[    7.391228]  [<ffffffff813d9866>] __blk_run_queue+0x1e/0x20
[    7.391584]  [<ffffffff813ded77>] blk_drain_queue+0x41/0x7a
[    7.391940]  [<ffffffff813deed5>] blk_cleanup_queue+0x125/0x184
[    7.392309]  [<ffffffff82146452>] floppy_init+0xd9c/0xdc2
[    7.392658]  [<ffffffff821456b6>] ? daring+0x65/0x65
[    7.392993]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    7.393352]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    7.393699]  [<ffffffff8198eec4>] kernel_thread_helper+0x4/0x10
[    7.394068]  [<ffffffff819862f4>] ? retint_restore_args+0x13/0x13
[    7.394444]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    7.394804]  [<ffffffff8198eec0>] ? gs_change+0x13/0x13
[    7.395147] ---[ end trace 06a7c1a65a7ee639 ]---
[    7.395513] ------------[ cut here ]------------
[    7.395834] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    7.396422] Hardware name:         
[    7.396700] VFS: do_fd_request called on non-open device
[    7.397046] Modules linked in:
[    7.397342] Pid: 1, comm: swapper Tainted: G        W    3.1.0-ioless-full-next-20111102+ #891
[    7.397926] Call Trace:
[    7.398169]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    7.398542]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    7.398907]  [<ffffffff813ec2d2>] ? blk_throtl_drain+0x11a/0x13b
[    7.399279]  [<ffffffff8198604e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    7.399659]  [<ffffffff8151bc61>] do_fd_request+0x37/0xaa
[    7.400010]  [<ffffffff813d9866>] __blk_run_queue+0x1e/0x20
[    7.400368]  [<ffffffff813ded77>] blk_drain_queue+0x41/0x7a
[    7.400725]  [<ffffffff813deed5>] blk_cleanup_queue+0x125/0x184
[    7.401095]  [<ffffffff82146452>] floppy_init+0xd9c/0xdc2
[    7.401446]  [<ffffffff821456b6>] ? daring+0x65/0x65
[    7.401781]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    7.402142]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    7.402489]  [<ffffffff8198eec4>] kernel_thread_helper+0x4/0x10
[    7.402860]  [<ffffffff819862f4>] ? retint_restore_args+0x13/0x13
[    7.403237]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    7.403597]  [<ffffffff8198eec0>] ? gs_change+0x13/0x13
[    7.403942] ---[ end trace 06a7c1a65a7ee63a ]---
[    7.404310] ------------[ cut here ]------------
[    7.404632] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    7.405221] Hardware name:         
[    7.405499] VFS: do_fd_request called on non-open device
[    7.405844] Modules linked in:
[    7.406140] Pid: 1, comm: swapper Tainted: G        W    3.1.0-ioless-full-next-20111102+ #891
[    7.406724] Call Trace:
[    7.406966]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    7.407338]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    7.407701]  [<ffffffff813ec2d2>] ? blk_throtl_drain+0x11a/0x13b
[    7.408074]  [<ffffffff8198604e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    7.408453]  [<ffffffff8151bc61>] do_fd_request+0x37/0xaa
[    7.408802]  [<ffffffff813d9866>] __blk_run_queue+0x1e/0x20
[    7.409159]  [<ffffffff813ded77>] blk_drain_queue+0x41/0x7a
[    7.409516]  [<ffffffff813deed5>] blk_cleanup_queue+0x125/0x184
[    7.409885]  [<ffffffff82146452>] floppy_init+0xd9c/0xdc2
[    7.410235]  [<ffffffff821456b6>] ? daring+0x65/0x65
[    7.410569]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    7.410929]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    7.411275]  [<ffffffff8198eec4>] kernel_thread_helper+0x4/0x10
[    7.411644]  [<ffffffff819862f4>] ? retint_restore_args+0x13/0x13
[    7.412020]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    7.412379]  [<ffffffff8198eec0>] ? gs_change+0x13/0x13
[    7.412722] ---[ end trace 06a7c1a65a7ee63b ]---
[    7.413089] ------------[ cut here ]------------
[    7.413411] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    7.413998] Hardware name:         
[    7.414277] VFS: do_fd_request called on non-open device
[    7.414623] Modules linked in:
[    7.414919] Pid: 1, comm: swapper Tainted: G        W    3.1.0-ioless-full-next-20111102+ #891
[    7.415504] Call Trace:
[    7.415746]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    7.416120]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    7.416484]  [<ffffffff813ec2d2>] ? blk_throtl_drain+0x11a/0x13b
[    7.416857]  [<ffffffff8198604e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    7.417237]  [<ffffffff8151bc61>] do_fd_request+0x37/0xaa
[    7.417588]  [<ffffffff813d9866>] __blk_run_queue+0x1e/0x20
[    7.417946]  [<ffffffff813ded77>] blk_drain_queue+0x41/0x7a
[    7.418303]  [<ffffffff813deed5>] blk_cleanup_queue+0x125/0x184
[    7.418673]  [<ffffffff82146452>] floppy_init+0xd9c/0xdc2
[    7.419023]  [<ffffffff821456b6>] ? daring+0x65/0x65
[    7.419359]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    7.419719]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    7.420066]  [<ffffffff8198eec4>] kernel_thread_helper+0x4/0x10
[    7.420435]  [<ffffffff819862f4>] ? retint_restore_args+0x13/0x13
[    7.420811]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    7.421170]  [<ffffffff8198eec0>] ? gs_change+0x13/0x13
[    7.421514] ---[ end trace 06a7c1a65a7ee63c ]---
[    7.421882] ------------[ cut here ]------------
[    7.422203] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    7.422792] Hardware name:         
[    7.423070] VFS: do_fd_request called on non-open device
[    7.423417] Modules linked in:
[    7.423713] Pid: 1, comm: swapper Tainted: G        W    3.1.0-ioless-full-next-20111102+ #891
[    7.424298] Call Trace:
[    7.424539]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    7.424911]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    7.425274]  [<ffffffff813ec2d2>] ? blk_throtl_drain+0x11a/0x13b
[    7.425646]  [<ffffffff8198604e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    7.426026]  [<ffffffff8151bc61>] do_fd_request+0x37/0xaa
[    7.426375]  [<ffffffff813d9866>] __blk_run_queue+0x1e/0x20
[    7.426732]  [<ffffffff813ded77>] blk_drain_queue+0x41/0x7a
[    7.427088]  [<ffffffff813deed5>] blk_cleanup_queue+0x125/0x184
[    7.427457]  [<ffffffff82146452>] floppy_init+0xd9c/0xdc2
[    7.427807]  [<ffffffff821456b6>] ? daring+0x65/0x65
[    7.428141]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    7.428501]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    7.428847]  [<ffffffff8198eec4>] kernel_thread_helper+0x4/0x10
[    7.429216]  [<ffffffff819862f4>] ? retint_restore_args+0x13/0x13
[    7.429591]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    7.429950]  [<ffffffff8198eec0>] ? gs_change+0x13/0x13
[    7.430293] ---[ end trace 06a7c1a65a7ee63d ]---
[    7.430668] ------------[ cut here ]------------
[    7.430990] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    7.431578] Hardware name:         
[    7.431856] VFS: do_fd_request called on non-open device
[    7.432202] Modules linked in:
[    7.432499] Pid: 1, comm: swapper Tainted: G        W    3.1.0-ioless-full-next-20111102+ #891
[    7.433084] Call Trace:
[    7.433326]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    7.433699]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    7.434061]  [<ffffffff813ec2d2>] ? blk_throtl_drain+0x11a/0x13b
[    7.434433]  [<ffffffff8198604e>] ? _raw_spin_unlock_irq+0x30/0x3c
[    7.434811]  [<ffffffff8151bc61>] do_fd_request+0x37/0xaa
[    7.435161]  [<ffffffff813d9866>] __blk_run_queue+0x1e/0x20
[    7.435517]  [<ffffffff813ded77>] blk_drain_queue+0x41/0x7a
[    7.435873]  [<ffffffff813deed5>] blk_cleanup_queue+0x125/0x184
[    7.436243]  [<ffffffff82146452>] floppy_init+0xd9c/0xdc2
[    7.436594]  [<ffffffff821456b6>] ? daring+0x65/0x65
[    7.436929]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    7.437290]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    7.437638]  [<ffffffff8198eec4>] kernel_thread_helper+0x4/0x10
[    7.438007]  [<ffffffff819862f4>] ? retint_restore_args+0x13/0x13
[    7.438384]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    7.438745]  [<ffffffff8198eec0>] ? gs_change+0x13/0x13
[    7.439089] ---[ end trace 06a7c1a65a7ee63e ]---
[    7.442729] brd: module loaded
[    7.444745] loop: module loaded
[    7.445497] Loading iSCSI transport class v2.0-870.
[    7.446447] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    7.446810] Detecting Adaptec I2O RAID controllers...
[    7.447335] Adaptec aacraid driver 1.1-7[28000]-ms
[    7.448257] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    7.451816] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.07-k.
[    7.452539] iscsi: registered transport (qla4xxx)
[    7.452948] QLogic iSCSI HBA Driver
[    7.453306] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    7.453917] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    7.454407] megasas: 00.00.06.12-rc1 Wed. Oct. 5 17:00:00 PDT 2011
[    7.454885] mpt2sas version 10.100.00.00 loaded
[    7.455597] ahci 0000:00:1f.2: version 3.0
[    7.455933] IOAPIC[0]: Set routing entry (8-19 -> 0x61 -> IRQ 19 Mode:1 Active:1 Dest:0)
[    7.456503] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    7.456954] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    7.457362] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    7.457936] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    7.458498] ahci 0000:00:1f.2: setting latency timer to 64
[    7.469999] scsi0 : ahci
[    7.470437] scsi1 : ahci
[    7.470853] scsi2 : ahci
[    7.471256] scsi3 : ahci
[    7.471662] scsi4 : ahci
[    7.472070] scsi5 : ahci
[    7.472743] ata1: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320100 irq 43
[    7.473285] ata2: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320180 irq 43
[    7.473829] ata3: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320200 irq 43
[    7.474369] ata4: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320280 irq 43
[    7.474912] ata5: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320300 irq 43
[    7.475453] ata6: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320380 irq 43
[    7.476024] ahci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.476438] ahci 0000:06:00.0: Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.
[    7.477102] ahci 0000:06:00.0: controller can't do NCQ, turning off CAP_NCQ
[    7.477508] ahci 0000:06:00.0: controller can't do PMP, turning off CAP_PMP
[    7.477917] ahci 0000:06:00.0: masking port_map 0x7 -> 0x3
[    7.478285] ahci: SSS flag set, parallel bus scan disabled
[    7.478680] ahci 0000:06:00.0: AHCI 0001.0000 32 slots 3 ports 3 Gbps 0x3 impl IDE mode
[    7.479243] ahci 0000:06:00.0: flags: 64bit stag led slum part 
[    7.479617] ahci 0000:06:00.0: setting latency timer to 64
[    7.480832] scsi6 : ahci
[    7.481245] scsi7 : ahci
[    7.481664] scsi8 : ahci
[    7.482050] ata7: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100100 irq 16
[    7.482594] ata8: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100180 irq 16
[    7.483140] ata9: DUMMY
[    7.486529] tun: Universal TUN/TAP device driver, 1.6
[    7.486890] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    7.487517] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    7.487873] Copyright (c) 2007 Atheros Corporation.
[    7.488555] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.7 (July 20, 2011)
[    7.489249] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    7.489626] e100: Copyright(c) 1999-2006 Intel Corporation
[    7.490078] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    7.490490] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    7.490950] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    7.491316] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    7.491719] IOAPIC[0]: Set routing entry (8-20 -> 0x71 -> IRQ 20 Mode:1 Active:1 Dest:0)
[    7.492289] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    7.492706] e1000e 0000:00:19.0: setting latency timer to 64
[    7.493178] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    7.684226] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:c0:79:88:54
[    7.684798] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    7.685239] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
[    7.685737] Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[    7.686132] Copyright (c) 2007-2011 Intel Corporation.
[    7.686562] Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[    7.687100] Copyright (c) 2009 - 2011 Intel Corporation.
[    7.687539] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.6.7-k
[    7.688093] ixgbe: Copyright (c) 1999-2011 Intel Corporation.
[    7.688546] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    7.688964] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    7.689498] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    7.690043] sky2: driver version 1.29
[    7.690849] usbcore: registered new interface driver catc
[    7.691199] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[    7.691627] usbcore: registered new interface driver kaweth
[    7.691988] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    7.692589] usbcore: registered new interface driver pegasus
[    7.692954] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[    7.693416] usbcore: registered new interface driver rtl8150
[    7.693842] usbcore: registered new interface driver asix
[    7.694251] usbcore: registered new interface driver cdc_ether
[    7.694681] usbcore: registered new interface driver cdc_eem
[    7.695097] usbcore: registered new interface driver dm9601
[    7.695517] usbcore: registered new interface driver smsc75xx
[    7.695948] usbcore: registered new interface driver smsc95xx
[    7.696368] usbcore: registered new interface driver gl620a
[    7.696791] usbcore: registered new interface driver net1080
[    7.697209] usbcore: registered new interface driver plusb
[    7.697620] usbcore: registered new interface driver rndis_host
[    7.698054] usbcore: registered new interface driver cdc_subset
[    7.698482] usbcore: registered new interface driver zaurus
[    7.698901] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    7.699501] usbcore: registered new interface driver int51x1
[    7.699865] cdc_ncm: 04-Aug-2011
[    7.700196] usbcore: registered new interface driver cdc_ncm
[    7.700557] Fusion MPT base driver 3.04.20
[    7.700863] Copyright (c) 1999-2008 LSI Corporation
[    7.701202] Fusion MPT SPI Host driver 3.04.20
[    7.701611] Fusion MPT FC Host driver 3.04.20
[    7.702021] Fusion MPT SAS Host driver 3.04.20
[    7.702427] Fusion MPT misc device (ioctl) driver 3.04.20
[    7.702866] mptctl: Registered with Fusion MPT base driver
[    7.703221] mptctl: /dev/mptctl @ (major,minor=10,220)
[    7.703672] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.704064] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    7.704474] IOAPIC[0]: Set routing entry (8-18 -> 0x81 -> IRQ 18 Mode:1 Active:1 Dest:0)
[    7.705050] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.705477] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    7.705847] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    7.706252] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file 'devices'
[    7.706807] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    7.707226] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    7.707773] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    7.708372] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    7.709024] ehci_hcd 0000:00:1a.7: debug port 1
[    7.709344] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.713822] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    7.714222] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    7.714607] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0322000
[    7.714971] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.719434] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    7.725668] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    7.726104] usb usb1: default language 0x0409
[    7.726424] usb usb1: udev 1, busnum 1, minor = 0
[    7.726754] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.727155] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.727691] usb usb1: Product: EHCI Host Controller
[    7.728022] usb usb1: Manufacturer: Linux 3.1.0-ioless-full-next-20111102+ ehci_hcd
[    7.728572] usb usb1: SerialNumber: 0000:00:1a.7
[    7.729058] usb usb1: usb_probe_device
[    7.729349] usb usb1: configuration #1 chosen from 1 choice
[    7.729734] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    7.730188] hub 1-0:1.0: usb_probe_interface
[    7.730498] hub 1-0:1.0: usb_probe_interface - got id
[    7.730840] hub 1-0:1.0: USB hub found
[    7.731135] hub 1-0:1.0: 6 ports detected
[    7.731434] hub 1-0:1.0: standalone hub
[    7.731730] hub 1-0:1.0: no power switching (usb 1.0)
[    7.732067] hub 1-0:1.0: individual port over-current protection
[    7.732439] hub 1-0:1.0: power on to power good time: 20ms
[    7.732812] hub 1-0:1.0: local power source is good
[    7.733143] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    7.733602] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    7.734139] IOAPIC[0]: Set routing entry (8-23 -> 0x89 -> IRQ 23 Mode:1 Active:1 Dest:0)
[    7.734712] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    7.735136] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    7.735503] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.735855] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    7.736267] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    7.739793] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    7.740392] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    7.741032] ehci_hcd 0000:00:1d.7: debug port 1
[    7.741351] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.745836] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    7.746237] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    7.746619] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0321000
[    7.746983] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.751448] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    7.757667] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    7.758087] usb usb2: default language 0x0409
[    7.758407] usb usb2: udev 1, busnum 2, minor = 128
[    7.758741] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    7.759141] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.759677] usb usb2: Product: EHCI Host Controller
[    7.760007] usb usb2: Manufacturer: Linux 3.1.0-ioless-full-next-20111102+ ehci_hcd
[    7.760556] usb usb2: SerialNumber: 0000:00:1d.7
[    7.761031] usb usb2: usb_probe_device
[    7.761321] usb usb2: configuration #1 chosen from 1 choice
[    7.761689] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    7.762128] hub 2-0:1.0: usb_probe_interface
[    7.762436] hub 2-0:1.0: usb_probe_interface - got id
[    7.762777] hub 2-0:1.0: USB hub found
[    7.763069] hub 2-0:1.0: 6 ports detected
[    7.763367] hub 2-0:1.0: standalone hub
[    7.763661] hub 2-0:1.0: no power switching (usb 1.0)
[    7.763997] hub 2-0:1.0: individual port over-current protection
[    7.764368] hub 2-0:1.0: power on to power good time: 20ms
[    7.764729] hub 2-0:1.0: local power source is good
[    7.765059] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    7.765511] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    7.766089] uhci_hcd: USB Universal Host Controller Interface driver
[    7.766509] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.766932] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    7.767299] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    7.767651] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '003'
[    7.768063] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    7.768608] uhci_hcd 0000:00:1a.0: detected 2 ports
[    7.768944] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    7.769341] uhci_hcd 0000:00:1a.0: Performing full reset
[    7.769703] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    7.770069] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020e0
[    7.770481] usb usb3: default language 0x0409
[    7.770805] usb usb3: udev 1, busnum 3, minor = 256
[    7.771136] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.771538] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.772075] usb usb3: Product: UHCI Host Controller
[    7.772406] usb usb3: Manufacturer: Linux 3.1.0-ioless-full-next-20111102+ uhci_hcd
[    7.772961] usb usb3: SerialNumber: 0000:00:1a.0
[    7.773431] usb usb3: usb_probe_device
[    7.773727] usb usb3: configuration #1 chosen from 1 choice
[    7.774090] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    7.774533] hub 3-0:1.0: usb_probe_interface
[    7.774848] hub 3-0:1.0: usb_probe_interface - got id
[    7.775185] hub 3-0:1.0: USB hub found
[    7.775479] hub 3-0:1.0: 2 ports detected
[    7.775782] hub 3-0:1.0: standalone hub
[    7.776075] hub 3-0:1.0: no power switching (usb 1.0)
[    7.776411] hub 3-0:1.0: individual port over-current protection
[    7.776785] hub 3-0:1.0: power on to power good time: 2ms
[    7.777140] hub 3-0:1.0: local power source is good
[    7.777470] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    7.777900] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    7.778358] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    7.778797] IOAPIC[0]: Set routing entry (8-21 -> 0x91 -> IRQ 21 Mode:1 Active:1 Dest:0)
[    7.779368] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    7.779792] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    7.780159] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    7.780507] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[    7.780678] ata4: SATA link down (SStatus 0 SControl 300)
[    7.780726] ata3: SATA link down (SStatus 0 SControl 300)
[    7.780764] ata5: SATA link down (SStatus 0 SControl 300)
[    7.780800] ata6: SATA link down (SStatus 0 SControl 300)
[    7.780846] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.782697] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    7.783240] uhci_hcd 0000:00:1a.1: detected 2 ports
[    7.783572] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    7.783972] uhci_hcd 0000:00:1a.1: Performing full reset
[    7.784330] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    7.784714] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020c0
[    7.785113] usb usb4: default language 0x0409
[    7.785433] usb usb4: udev 1, busnum 4, minor = 384
[    7.785765] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    7.786166] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.786702] usb usb4: Product: UHCI Host Controller
[    7.787032] usb usb4: Manufacturer: Linux 3.1.0-ioless-full-next-20111102+ uhci_hcd
[    7.787581] usb usb4: SerialNumber: 0000:00:1a.1
[    7.787677] ata7: SATA link down (SStatus 0 SControl 300)
[    7.788400] usb usb4: usb_probe_device
[    7.788695] usb usb4: configuration #1 chosen from 1 choice
[    7.789062] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    7.789503] hub 4-0:1.0: usb_probe_interface
[    7.789816] hub 4-0:1.0: usb_probe_interface - got id
[    7.790153] hub 4-0:1.0: USB hub found
[    7.790447] hub 4-0:1.0: 2 ports detected
[    7.790747] hub 4-0:1.0: standalone hub
[    7.791039] hub 4-0:1.0: no power switching (usb 1.0)
[    7.791375] hub 4-0:1.0: individual port over-current protection
[    7.791748] hub 4-0:1.0: power on to power good time: 2ms
[    7.792102] hub 4-0:1.0: local power source is good
[    7.792434] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    7.792866] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    7.793325] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    7.793761] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    7.794181] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    7.794549] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    7.794902] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '005'
[    7.795315] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    7.795864] uhci_hcd 0000:00:1a.2: detected 2 ports
[    7.796198] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    7.796595] uhci_hcd 0000:00:1a.2: Performing full reset
[    7.796958] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    7.797343] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000020a0
[    7.797746] usb usb5: default language 0x0409
[    7.798066] usb usb5: udev 1, busnum 5, minor = 512
[    7.798396] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    7.798800] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.799333] usb usb5: Product: UHCI Host Controller
[    7.799665] usb usb5: Manufacturer: Linux 3.1.0-ioless-full-next-20111102+ uhci_hcd
[    7.800216] usb usb5: SerialNumber: 0000:00:1a.2
[    7.800690] usb usb5: usb_probe_device
[    7.800980] usb usb5: configuration #1 chosen from 1 choice
[    7.801342] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    7.801786] hub 5-0:1.0: usb_probe_interface
[    7.802095] hub 5-0:1.0: usb_probe_interface - got id
[    7.802431] hub 5-0:1.0: USB hub found
[    7.802729] hub 5-0:1.0: 2 ports detected
[    7.803027] hub 5-0:1.0: standalone hub
[    7.803318] hub 5-0:1.0: no power switching (usb 1.0)
[    7.803657] hub 5-0:1.0: individual port over-current protection
[    7.804028] hub 5-0:1.0: power on to power good time: 2ms
[    7.804383] hub 5-0:1.0: local power source is good
[    7.804715] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    7.805143] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    7.805605] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    7.806038] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    7.806456] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.806827] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.807177] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '006'
[    7.807589] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    7.808140] uhci_hcd 0000:00:1d.0: detected 2 ports
[    7.808473] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    7.808875] uhci_hcd 0000:00:1d.0: Performing full reset
[    7.809233] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    7.809600] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
[    7.810001] usb usb6: default language 0x0409
[    7.810321] usb usb6: udev 1, busnum 6, minor = 640
[    7.810655] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    7.811056] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.811591] usb usb6: Product: UHCI Host Controller
[    7.811924] usb usb6: Manufacturer: Linux 3.1.0-ioless-full-next-20111102+ uhci_hcd
[    7.812475] usb usb6: SerialNumber: 0000:00:1d.0
[    7.812947] usb usb6: usb_probe_device
[    7.813238] usb usb6: configuration #1 chosen from 1 choice
[    7.813601] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    7.814047] hub 6-0:1.0: usb_probe_interface
[    7.814356] hub 6-0:1.0: usb_probe_interface - got id
[    7.814697] hub 6-0:1.0: USB hub found
[    7.814990] hub 6-0:1.0: 2 ports detected
[    7.815288] hub 6-0:1.0: standalone hub
[    7.818557] hub 6-0:1.0: no power switching (usb 1.0)
[    7.818897] hub 6-0:1.0: individual port over-current protection
[    7.819268] hub 6-0:1.0: power on to power good time: 2ms
[    7.819622] hub 6-0:1.0: local power source is good
[    7.819956] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    7.820387] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    7.820859] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    7.821277] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    7.821699] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    7.822065] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.822414] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '007'
[    7.822828] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    7.823372] uhci_hcd 0000:00:1d.1: detected 2 ports
[    7.823708] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    7.824105] uhci_hcd 0000:00:1d.1: Performing full reset
[    7.824464] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    7.824834] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
[    7.825232] usb usb7: default language 0x0409
[    7.825551] usb usb7: udev 1, busnum 7, minor = 768
[    7.825885] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    7.826285] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.826590] ata1.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[    7.826592] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.827573] usb usb7: Product: UHCI Host Controller
[    7.827906] usb usb7: Manufacturer: Linux 3.1.0-ioless-full-next-20111102+ uhci_hcd
[    7.828455] usb usb7: SerialNumber: 0000:00:1d.1
[    7.828928] usb usb7: usb_probe_device
[    7.829218] usb usb7: configuration #1 chosen from 1 choice
[    7.829581] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    7.830029] hub 7-0:1.0: usb_probe_interface
[    7.830338] hub 7-0:1.0: usb_probe_interface - got id
[    7.830679] hub 7-0:1.0: USB hub found
[    7.830971] hub 7-0:1.0: 2 ports detected
[    7.831269] hub 7-0:1.0: standalone hub
[    7.831561] hub 7-0:1.0: no power switching (usb 1.0)
[    7.831944] hub 7-0:1.0: individual port over-current protection
[    7.832316] hub 7-0:1.0: power on to power good time: 2ms
[    7.832698] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    7.833291] hub 1-0:1.0: port 1: status 0501 change 0001
[    7.833646] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 001403 0  ACK POWER sig=k CSC CONNECT
[    7.834243] hub 1-0:1.0: port 2: status 0501 change 0001
[    7.834265] hub 7-0:1.0: local power source is good
[    7.834267] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    7.834303] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    7.834399] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    7.834462] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.834469] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    7.834472] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    7.834483] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '008'
[    7.834491] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    7.834500] uhci_hcd 0000:00:1d.2: detected 2 ports
[    7.834506] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    7.834508] uhci_hcd 0000:00:1d.2: Performing full reset
[    7.834526] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    7.834539] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    7.834600] usb usb8: default language 0x0409
[    7.834614] usb usb8: udev 1, busnum 8, minor = 896
[    7.834616] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    7.834618] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.834619] usb usb8: Product: UHCI Host Controller
[    7.834621] usb usb8: Manufacturer: Linux 3.1.0-ioless-full-next-20111102+ uhci_hcd
[    7.834623] usb usb8: SerialNumber: 0000:00:1d.2
[    7.834814] usb usb8: usb_probe_device
[    7.834816] usb usb8: configuration #1 chosen from 1 choice
[    7.834829] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    7.834936] hub 8-0:1.0: usb_probe_interface
[    7.834938] hub 8-0:1.0: usb_probe_interface - got id
[    7.834940] hub 8-0:1.0: USB hub found
[    7.834948] hub 8-0:1.0: 2 ports detected
[    7.834949] hub 8-0:1.0: standalone hub
[    7.834950] hub 8-0:1.0: no power switching (usb 1.0)
[    7.834951] hub 8-0:1.0: individual port over-current protection
[    7.834953] hub 8-0:1.0: power on to power good time: 2ms
[    7.834961] hub 8-0:1.0: local power source is good
[    7.834963] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    7.834998] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    7.835077] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    7.835221] Initializing USB Mass Storage driver...
[    7.835340] usbcore: registered new interface driver usb-storage
[    7.835342] USB Mass Storage support registered.
[    7.835464] usbcore: registered new interface driver libusual
[    7.835546] usbcore: registered new interface driver ums-alauda
[    7.835633] usbcore: registered new interface driver ums-cypress
[    7.835737] usbcore: registered new interface driver ums-datafab
[    7.835821] usbcore: registered new interface driver ums-freecom
[    7.835894] usbcore: registered new interface driver ums-isd200
[    7.835973] usbcore: registered new interface driver ums-jumpshot
[    7.836059] usbcore: registered new interface driver ums-karma
[    7.836147] usbcore: registered new interface driver ums-onetouch
[    7.836231] usbcore: registered new interface driver ums-sddr09
[    7.836307] usbcore: registered new interface driver ums-sddr55
[    7.836390] usbcore: registered new interface driver ums-usbat
[    7.836571] usbcore: registered new interface driver usbserial
[    7.836660] USB Serial support registered for generic
[    7.836748] usbcore: registered new interface driver usbserial_generic
[    7.836750] usbserial: USB Serial Driver core
[    7.836829] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    7.836927] usbcore: registered new interface driver belkin
[    7.836928] belkin_sa: v1.3:USB Belkin Serial converter driver
[    7.836997] USB Serial support registered for MCT U232
[    7.837077] usbcore: registered new interface driver mct_u232
[    7.837079] mct_u232: z2.1:Magic Control Technology USB-RS232 converter driver
[    7.837369] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    7.840580] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.840596] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.840983] mousedev: PS/2 mouse device common for all mice
[    7.841687] rtc_cmos 00:02: RTC can wake from S4
[    7.841929] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    7.841967] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    7.842040] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    7.842245] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[    7.842366] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.842370] iTCO_vendor_support: vendor-support=0
[    7.842372] SoftDog: cannot register miscdev on minor=130 (err=-16)
[    7.842381] md: linear personality registered for level -1
[    7.842383] md: raid0 personality registered for level 0
[    7.842384] md: raid1 personality registered for level 1
[    7.842386] md: raid10 personality registered for level 10
[    7.842388] md: raid6 personality registered for level 6
[    7.842389] md: raid5 personality registered for level 5
[    7.842390] md: raid4 personality registered for level 4
[    7.842392] md: multipath personality registered for level -4
[    7.842393] md: faulty personality registered for level -5
[    7.842814] device-mapper: uevent: version 1.0.3
[    7.843062] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    7.843165] device-mapper: multipath: version 1.3.0 loaded
[    7.843176] device-mapper: multipath round-robin: version 1.0.0 loaded
[    7.843178] device-mapper: multipath queue-length: version 0.1.0 loaded
[    7.843180] device-mapper: multipath service-time: version 0.2.0 loaded
[    7.843355] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    7.844918] cpuidle: using governor ladder
[    7.868050] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC CONNECT
[    7.868665] hub 1-0:1.0: port 4: status 0501 change 0001
[    7.869079] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    7.870916] cpuidle: using governor menu
[    7.871430] usbcore: registered new interface driver usbhid
[    7.871801] usbhid: USB HID core driver
[    7.872457] dell_wmi: No known WMI GUID found
[    7.872784] acer_wmi: Acer Laptop ACPI-WMI Extras
[    7.873112] acer_wmi: No or unsupported WMI interface, unable to load
[    7.873897] IOAPIC[0]: Set routing entry (8-22 -> 0x99 -> IRQ 22 Mode:1 Active:1 Dest:0)
[    7.874467] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    7.875080] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    7.875474] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    7.875873] ALSA hda_intel.c:2733 chipset global capabilities = 0x4401
[    7.876279] ALSA hda_intel.c:1163 Clearing TCSEL
[    7.877691] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[    7.878056] uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
[    7.883738] ALSA hda_intel.c:1009 codec_mask = 0x4
[    7.884230] ALSA hda_intel.c:1472 codec #2 probed OK
[    7.884902] ata1.00: configured for UDMA/133
[    7.885419] scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    7.886403] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    7.887082] sd 0:0:0:0: [sda] Write Protect is off
[    7.887412] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.887820] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.889900] ALSA hda_codec.c:3994 hda_codec: model 'intel-x58' is selected for config 8086:22 (DX58SO)
[    7.890516] hda_codec: ALC889: SKU not ready 0x411111f0
[    7.891232] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input2
[    7.892781] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    7.894865] ALSA hda_codec.c:2378 Cannot find slave Side Playback Volume, skipped
[    7.898483] ALSA hda_codec.c:2378 Cannot find slave Headphone Playback Volume, skipped
[    7.899053] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Volume, skipped
[    7.899597] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Volume, skipped
[    7.900259] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Volume, skipped
[    7.900911] ALSA hda_codec.c:2378 Cannot find slave Side Playback Switch, skipped
[    7.901456] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Switch, skipped
[    7.902107] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Switch, skipped
[    7.902772] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Switch, skipped
[    7.904251] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input3
[    7.904950] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.905478] ALSA device list:
[    7.905751]   #0: HDA Intel at 0xf7f00000 irq 45
[    7.906073] oprofile: using NMI interrupt.
[    7.906410] netem: version 1.3
[    7.906771] Netfilter messages via NETLINK v0.30.
[    7.907131] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    7.908331] ctnetlink v0.93: registering with nfnetlink.
[    7.908767] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    7.909175] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    7.909965] xt_time: kernel timezone is -0000
[    7.911895] ip_tables: (C) 2000-2006 Netfilter Core Team
[    7.912301] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    7.912815] arp_tables: (C) 2002 David S. Miller
[    7.913163] TCP bic registered
[    7.913427] TCP cubic registered
[    7.913804] TCP westwood registered
[    7.914086] TCP highspeed registered
[    7.914368] TCP hybla registered
[    7.914637] TCP htcp registered
[    7.915011] TCP vegas registered
[    7.915280] TCP veno registered
[    7.915546] TCP scalable registered
[    7.915930] TCP lp registered
[    7.916191] TCP yeah registered
[    7.916456] TCP illinois registered
[    7.916840] Initializing XFRM netlink socket
[    7.917832] NET: Registered protocol family 10
[    7.919787] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.921444] IPv6 over IPv4 tunneling driver
[    7.923634] NET: Registered protocol family 17
[    7.924085] NET: Registered protocol family 15
[    7.924518] Bridge firewalling registered
[    7.924974] Ebtables v2.0 registered
[    7.925353] Registering the dns_resolver key type
[    7.925831] 
[    7.925831] printing PIC contents
[    7.926312] ... PIC  IMR: ffff
[    7.926577] ... PIC  IRR: 0c21
[    7.926938] ... PIC  ISR: 0000
[    7.927204] ... PIC ELCR: 0c20
[    7.927468] printing local APIC contents on CPU#0/0:
[    7.927801] ... APIC ID:      00000000 (0)
[    7.928102] ... APIC VERSION: 00060015
[    7.928392] ... APIC TASKPRI: 00000000 (00)
[    7.928696] ... APIC PROCPRI: 00000000
[    7.928985] ... APIC LDR: 01000000
[    7.929261] ... APIC DFR: ffffffff
[    7.929536] ... APIC SPIV: 000001ff
[    7.929814] ... APIC ISR field:
[    7.930081] 0000000000000000000000000000000000000000000000000000000000000000
[    7.930759] ... APIC TMR field:
[    7.931025] 0000000000000000000000000000000000000002000000000000000000000000
[    7.931702] ... APIC IRR field:
[    7.931969] 0000000000010000000000000000000000000000000000000000000000008000
[    7.932646] ... APIC ESR: 00000000
[    7.932922] ... APIC ICR: 000000ef
[    7.933197] ... APIC ICR2: 05000000
[    7.933476] ... APIC LVTT: 000000ef
[    7.933754] ... APIC LVTPC: 00000400
[    7.934035] ... APIC LVT0: 00010700
[    7.934313] ... APIC LVT1: 00000400
[    7.934591] ... APIC LVTERR: 000000fe
[    7.934875] ... APIC TMICT: 00001a26
[    7.935157] ... APIC TMCCT: 00000000
[    7.935438] ... APIC TDCR: 00000003
[    7.935716] 
[    7.936084] number of MP IRQ sources: 15.
[    7.936159] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.936162] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.937183] number of IO-APIC #8 registers: 24.
[    7.937500] testing the IO APIC.......................
[    7.937936] 
[    7.938140] IO APIC #8......
[    7.938396] .... register #00: 08000000
[    7.938774] .......    : physical APIC id: 08
[    7.939085] .......    : Delivery Type: 0
[    7.939382] .......    : LTS          : 0
[    7.939767] .... register #01: 00170020
[    7.940059] .......     : max redirection entries: 17
[    7.940395] .......     : PRQ implemented: 0
[    7.940790] .......     : IO APIC version: 20
[    7.941100] .... IRQ redirection table:
[    7.941391]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    7.941833]  00 00  1    0    0   0   0    0    0    00
[    7.942216]  01 00  0    0    0   0   0    0    0    31
[    7.942596]  02 00  0    0    0   0   0    0    0    30
[    7.943068]  03 00  0    0    0   0   0    0    0    33
[    7.943447]  04 00  0    0    0   0   0    0    0    34
[    7.943917]  05 00  0    0    0   0   0    0    0    35
[    7.944299]  06 00  1    0    0   0   0    0    0    36
[    7.944768]  07 00  0    0    0   0   0    0    0    37
[    7.945151]  08 00  0    0    0   0   0    0    0    38
[    7.945530]  09 00  0    1    0   0   0    0    0    39
[    7.945998]  0a 00  0    0    0   0   0    0    0    3A
[    7.946379]  0b 00  0    0    0   0   0    0    0    3B
[    7.946848]  0c 00  0    0    0   0   0    0    0    3C
[    7.947230]  0d 00  0    0    0   0   0    0    0    3D
[    7.947608]  0e 00  0    0    0   0   0    0    0    3E
[    7.948075]  0f 00  0    0    0   0   0    0    0    3F
[    7.948454]  10 00  0    1    0   1   0    0    0    29
[    7.948925]  11 00  1    1    0   1   0    0    0    41
[    7.949307]  12 00  0    1    0   1   0    0    0    81
[    7.949774]  13 00  0    1    0   1   0    0    0    61
[    7.950157]  14 00  1    1    0   1   0    0    0    71
[    7.950560]  15 00  0    1    0   1   0    0    0    91
[    7.951032]  16 00  1    1    0   1   0    0    0    99
[    7.951412]  17 00  0    1    0   1   0    0    0    89
[    7.951880] IRQ to pin mappings:
[    7.952151] IRQ0 -> 0:2
[    7.952457] IRQ1 -> 0:1
[    7.952854] IRQ3 -> 0:3
[    7.953163] IRQ4 -> 0:4
[    7.953470] IRQ5 -> 0:5
[    7.953865] IRQ6 -> 0:6
[    7.954173] IRQ7 -> 0:7
[    7.954481] IRQ8 -> 0:8
[    7.954876] IRQ9 -> 0:9
[    7.955183] IRQ10 -> 0:10
[    7.955495] IRQ11 -> 0:11
[    7.955895] IRQ12 -> 0:12
[    7.956211] IRQ13 -> 0:13
[    7.956524] IRQ14 -> 0:14
[    7.956928] IRQ15 -> 0:15
[    7.957242] IRQ16 -> 0:16
[    7.957555] IRQ17 -> 0:17
[    7.957955] IRQ18 -> 0:18
[    7.958268] IRQ19 -> 0:19
[    7.958582] IRQ20 -> 0:20
[    7.958985] IRQ21 -> 0:21
[    7.959298] IRQ22 -> 0:22
[    7.959611] IRQ23 -> 0:23
[    7.960012] .................................... done.
[    7.960825] PM: Hibernation image not present or could not be loaded.
[    7.961232] registered taskstats version 1
[    7.961535] Running tests on trace events:
[    7.961888] Testing event kfree_skb: 
[    7.968840] hub 1-0:1.0: state 7 ports 6 chg 0016 evt 0000
[    7.969361] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    7.978030] OK
[    7.978246] Testing event consume_skb: 
[    7.985342]  sda: sda1 sda2 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    7.987628] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.995059] OK
[    7.995273] Testing event skb_copy_datagram_iovec: OK
[    8.014268] Testing event net_dev_xmit: 
[    8.021097] ehci_hcd 0000:00:1a.7: port 1 high speed
[    8.021591] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    8.033078] OK
[    8.033290] Testing event net_dev_queue: OK
[    8.052223] Testing event netif_receive_skb: OK
[    8.070153] Testing event netif_rx: 
[    8.072838] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    8.088025] OK
[    8.088237] Testing event napi_poll: OK
[    8.104201] Testing event sock_rcvqueue_full: OK
[    8.120226] Testing event sock_exceed_buf_limit: 
[    8.126101] ehci_hcd 0000:00:1a.7: port 1 high speed
[    8.126593] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    8.139809] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    8.140043] OK
[    8.140046] Testing event udp_fail_queue_rcv_skb: OK
[    8.156161] Testing event hda_send_cmd: OK
[    8.172138] Testing event hda_get_response: OK
[    8.190155] Testing event hda_bus_reset: 
[    8.200066] usb 1-1: default language 0x0409
[    8.206966] OK
[    8.207176] Testing event hda_power_down: 
[    8.207253] usb 1-1: udev 2, busnum 1, minor = 1
[    8.207255] usb 1-1: New USB device found, idVendor=0b95, idProduct=1780
[    8.207257] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    8.207259] usb 1-1: Product: AX88178 
[    8.207260] usb 1-1: Manufacturer: ASIX Elec. Corp.
[    8.207262] usb 1-1: SerialNumber: 000013
[    8.209827] usb 1-1: usb_probe_device
[    8.210147] usb 1-1: configuration #1 chosen from 1 choice
[    8.210913] ata2.00: ATAPI: PLEXTOR DVDR   PX-712A, 1.07, max UDMA/33
[    8.211316] ata2.00: applying bridge limits
[    8.211322] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    8.212154] asix 1-1:1.0: usb_probe_interface
[    8.212463] asix 1-1:1.0: usb_probe_interface - got id
[    8.228983] OK
[    8.229194] Testing event hda_power_up: 
[    8.242296] ata2.00: configured for UDMA/33
[    8.244024] scsi 1:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-712A   1.07 PQ: 0 ANSI: 5
[    8.248011] OK
[    8.248223] Testing event hda_unsol_event: OK
[    8.268174] Testing event scsi_dispatch_cmd_start: OK
[    8.285202] Testing event scsi_dispatch_cmd_error: OK
[    8.302170] Testing event scsi_dispatch_cmd_done: OK
[    8.318187] Testing event scsi_dispatch_cmd_timeout: OK
[    8.334135] Testing event scsi_eh_wakeup: OK
[    8.350182] Testing event i915_gem_object_create: OK
[    8.366265] Testing event i915_gem_object_bind: OK
[    8.384272] Testing event i915_gem_object_unbind: OK
[    8.401185] Testing event i915_gem_object_change_domain: OK
[    8.418267] Testing event i915_gem_object_pwrite: OK
[    8.435265] Testing event i915_gem_object_pread: OK
[    8.453210] Testing event i915_gem_object_fault: OK
[    8.469321] Testing event i915_gem_object_clflush: OK
[    8.488194] Testing event i915_gem_object_destroy: OK
[    8.505257] Testing event i915_gem_evict: OK
[    8.522258] Testing event i915_gem_evict_everything: OK
[    8.540169] Testing event i915_gem_ring_dispatch: 
[    8.549873] ata8: SATA link down (SStatus 0 SControl 300)
[    8.556139] OK
[    8.556352] Testing event i915_gem_ring_flush: OK
[    8.574284] Testing event i915_gem_request_add: OK
[    8.593220] Testing event i915_gem_request_complete: OK
[    8.610165] Testing event i915_gem_request_retire: OK
[    8.627237] Testing event i915_gem_request_wait_begin: OK
[    8.647186] Testing event i915_gem_request_wait_end: OK
[    8.663167] Testing event i915_ring_wait_begin: OK
[    8.680172] Testing event i915_ring_wait_end: OK
[    8.696206] Testing event i915_flip_request: OK
[    8.712179] Testing event i915_flip_complete: OK
[    8.728102] Testing event i915_reg_rw: OK
[    8.744221] Testing event drm_vblank_event: OK
[    8.761357] Testing event drm_vblank_event_queued: OK
[    8.778235] Testing event drm_vblank_event_delivered: OK
[    8.796391] Testing event block_rq_abort: OK
[    8.815295] Testing event block_rq_requeue: 
[    8.831837] usb usb5: suspend_rh (auto-stop)
[    8.832333] usb usb6: suspend_rh (auto-stop)
[    8.835071] OK
[    8.835285] Testing event block_rq_complete: OK
[    8.852251] Testing event block_rq_insert: OK
[    8.871179] Testing event block_rq_issue: OK
[    8.887225] Testing event block_bio_bounce: OK
[    8.903318] Testing event block_bio_complete: OK
[    8.920198] Testing event block_bio_backmerge: 
[    8.926630] asix 1-1:1.0: eth1: register 'asix' at usb-0000:00:1a.7-1, ASIX AX88178 USB 2.0 Ethernet, 00:23:54:5c:02:83
[    8.927477] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    8.927952] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    8.928336] ehci_hcd 0000:00:1a.7: port 2 low speed --> companion
[    8.936947] OK
[    8.937160] Testing event block_bio_frontmerge: OK
[    8.953230] Testing event block_bio_queue: OK
[    8.969252] Testing event block_getrq: 
[    8.979877] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    8.980648] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    8.987086] OK
[    8.987299] Testing event block_sleeprq: OK
[    9.004250] Testing event block_plug: OK
[    9.022333] Testing event block_unplug: 
[    9.032008] ehci_hcd 0000:00:1a.7: port 4 high speed
[    9.032500] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    9.040117] OK
[    9.040331] Testing event block_split: OK
[    9.058244] Testing event block_bio_remap: OK
[    9.077331] Testing event block_rq_remap: 
[    9.081821] usb usb7: suspend_rh (auto-stop)
[    9.081852] usb usb4: suspend_rh (auto-stop)
[    9.082622] usb usb8: suspend_rh (auto-stop)
[    9.083810] usb 1-4: new high-speed USB device number 4 using ehci_hcd
[    9.095108] OK
[    9.095322] Testing event btrfs_transaction_commit: OK
[    9.112299] Testing event btrfs_inode_new: OK
[    9.129178] Testing event btrfs_inode_request: 
[    9.135136] ehci_hcd 0000:00:1a.7: port 4 high speed
[    9.135630] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    9.145157] OK
[    9.145371] Testing event btrfs_inode_evict: OK
[    9.163328] Testing event btrfs_get_extent: OK
[    9.182237] Testing event btrfs_ordered_extent_add: OK
[    9.200181] Testing event btrfs_ordered_extent_remove: OK
[    9.216320] Testing event btrfs_ordered_extent_start: OK
[    9.234408] Testing event btrfs_ordered_extent_put: OK
[    9.251234] Testing event btrfs_finish_ordered_io: OK
[    9.270202] Testing event __extent_writepage: OK
[    9.286221] Testing event btrfs_writepage_end_io_hook: OK
[    9.303242] Testing event btrfs_sync_file: OK
[    9.319259] Testing event btrfs_sync_fs: OK
[    9.336253] Testing event btrfs_delayed_tree_ref: OK
[    9.354322] Testing event btrfs_delayed_data_ref: OK
[    9.373197] Testing event btrfs_delayed_ref_head: OK
[    9.390355] Testing event btrfs_chunk_alloc: OK
[    9.407323] Testing event btrfs_chunk_free: OK
[    9.424257] Testing event btrfs_cow_block: OK
[    9.441205] Testing event btrfs_reserved_extent_alloc: OK
[    9.458211] Testing event btrfs_reserved_extent_free: OK
[    9.475299] Testing event xfs_attr_list_sf: OK
[    9.493359] Testing event xfs_attr_list_sf_all: OK
[    9.511243] Testing event xfs_attr_list_leaf: OK
[    9.529214] Testing event xfs_attr_list_leaf_end: OK
[    9.545263] Testing event xfs_attr_list_full: OK
[    9.562300] Testing event xfs_attr_list_add: OK
[    9.579196] Testing event xfs_attr_list_wrong_blk: OK
[    9.596160] Testing event xfs_attr_list_notfound: OK
[    9.612260] Testing event xfs_perag_get: OK
[    9.629269] Testing event xfs_perag_get_tag: OK
[    9.645194] Testing event xfs_perag_put: OK
[    9.661125] Testing event xfs_perag_set_reclaim: OK
[    9.677255] Testing event xfs_perag_clear_reclaim: OK
[    9.694193] Testing event xfs_attr_list_node_descend: OK
[    9.710199] Testing event xfs_iext_insert: OK
[    9.726207] Testing event xfs_iext_remove: OK
[    9.742195] Testing event xfs_bmap_pre_update: OK
[    9.758192] Testing event xfs_bmap_post_update: OK
[    9.774248] Testing event xfs_extlist: OK
[    9.790242] Testing event xfs_buf_init: OK
[    9.806173] Testing event xfs_buf_free: OK
[    9.824221] Testing event xfs_buf_hold: OK
[    9.841387] Testing event xfs_buf_rele: OK
[    9.860347] Testing event xfs_buf_iodone: OK
[    9.878211] Testing event xfs_buf_iorequest: OK
[    9.895294] Testing event xfs_buf_bawrite: OK
[    9.912250] Testing event xfs_buf_lock: OK
[    9.929191] Testing event xfs_buf_lock_done: OK
[    9.947204] Testing event xfs_buf_trylock: OK
[    9.963249] Testing event xfs_buf_unlock: OK
[    9.979156] Testing event xfs_buf_iowait: OK
[    9.995379] Testing event xfs_buf_iowait_done: OK
[   10.012344] Testing event xfs_buf_delwri_queue: OK
[   10.029337] Testing event xfs_buf_delwri_dequeue: OK
[   10.046368] Testing event xfs_buf_delwri_split: OK
[   10.063290] Testing event xfs_buf_get_uncached: OK
[   10.080238] Testing event xfs_bdstrat_shut: OK
[   10.097227] Testing event xfs_buf_item_relse: OK
[   10.113251] Testing event xfs_buf_item_iodone: OK
[   10.131297] Testing event xfs_buf_item_iodone_async: 
[   10.137096] usb 1-4: default language 0x0409
[   10.138973] usb 1-4: udev 4, busnum 1, minor = 3
[   10.139301] usb 1-4: New USB device found, idVendor=1307, idProduct=0165
[   10.139698] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   10.140223] usb 1-4: Product: USB Mass Storage Device
[   10.140563] usb 1-4: Manufacturer: Teclast Technology
[   10.141029] usb 1-4: SerialNumber: 0000000000020D
[   10.141544] usb 1-4: usb_probe_device
[   10.141911] usb 1-4: configuration #1 chosen from 1 choice
[   10.142322] usb 1-4: adding 1-4:1.0 (config #1, interface 0)
[   10.142892] usb-storage 1-4:1.0: usb_probe_interface
[   10.143227] usb-storage 1-4:1.0: usb_probe_interface - got id
[   10.143702] scsi9 : usb-storage 1-4:1.0
[   10.147378] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[   10.147936] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   10.148295] uhci_hcd 0000:00:1a.0: port 2 portsc 01a3,00
[   10.148647] hub 3-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[   10.150997] OK
[   10.151209] Testing event xfs_buf_error_relse: OK
[   10.168295] Testing event xfs_trans_read_buf_io: OK
[   10.186304] Testing event xfs_trans_read_buf_shut: OK
[   10.205271] Testing event xfs_btree_corrupt: OK
[   10.223369] Testing event xfs_da_btree_corrupt: OK
[   10.240324] Testing event xfs_reset_dqcounts: 
[   10.253882] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[   10.257176] OK
[   10.257389] Testing event xfs_inode_item_push: OK
[   10.274350] Testing event xfs_buf_find: OK
[   10.291312] Testing event xfs_buf_get: OK
[   10.308253] Testing event xfs_buf_read: OK
[   10.324261] Testing event xfs_buf_ioerror: OK
[   10.340166] Testing event xfs_buf_item_size: 
[   10.355889] usb 3-2: new low-speed USB device number 2 using uhci_hcd
[   10.356148] OK
[   10.356150] Testing event xfs_buf_item_size_stale: OK
[   10.372327] Testing event xfs_buf_item_format: OK
[   10.390269] Testing event xfs_buf_item_format_stale: OK
[   10.408285] Testing event xfs_buf_item_pin: OK
[   10.427345] Testing event xfs_buf_item_unpin: OK
[   10.444400] Testing event xfs_buf_item_unpin_stale: OK
[   10.461318] Testing event xfs_buf_item_trylock: OK
[   10.478343] Testing event xfs_buf_item_unlock: OK
[   10.496310] Testing event xfs_buf_item_unlock_stale: OK
[   10.513368] Testing event xfs_buf_item_committed: OK
[   10.531469] Testing event xfs_buf_item_push: OK
[   10.549265] Testing event xfs_buf_item_pushbuf: 
[   10.557671] usb 3-2: skipped 1 descriptor after interface
[   10.558238] usb 3-2: skipped 1 descriptor after interface
[   10.564666] usb 3-2: default language 0x0409
[   10.566071] OK
[   10.566285] Testing event xfs_trans_get_buf: OK
[   10.583470] Testing event xfs_trans_get_buf_recur: 
[   10.595639] usb 3-2: udev 2, busnum 3, minor = 257
[   10.596138] usb 3-2: New USB device found, idVendor=0557, idProduct=2220
[   10.596537] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   10.596987] usb 3-2: Product: ATEN  CS-1758/54
[   10.597304] usb 3-2: Manufacturer: ATEN
[   10.597822] usb 3-2: usb_probe_device
[   10.598109] usb 3-2: configuration #1 chosen from 1 choice
[   10.600634] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[   10.601258] OK
[   10.601471] Testing event xfs_trans_getsb: OK
[   10.618257] Testing event xfs_trans_getsb_recur: OK
[   10.634356] Testing event xfs_trans_read_buf: 
[   10.642896] usbserial_generic 3-2:1.0: usb_probe_interface
[   10.643413] usbserial_generic 3-2:1.0: usb_probe_interface - got id
[   10.643915] usbhid 3-2:1.0: usb_probe_interface
[   10.644235] usbhid 3-2:1.0: usb_probe_interface - got id
[   10.651188] OK
[   10.651402] Testing event xfs_trans_read_buf_recur: OK
[   10.668363] Testing event xfs_trans_log_buf: 
[   10.677234] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input4
[   10.678140] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   10.678941] generic-usb 0003:0557:2220.0001: input: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input0
[   10.679662] usb 3-2: adding 3-2:1.1 (config #1, interface 1)
[   10.686111] OK
[   10.686324] Testing event xfs_trans_brelse: 
[   10.689854] usbserial_generic 3-2:1.1: usb_probe_interface
[   10.690366] usbserial_generic 3-2:1.1: usb_probe_interface - got id
[   10.690779] usbhid 3-2:1.1: usb_probe_interface
[   10.691098] usbhid 3-2:1.1: usb_probe_interface - got id
[   10.703156] OK
[   10.703370] Testing event xfs_trans_bjoin: 
[   10.719206] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.1/input/input5
[   10.720368] OK
[   10.720585] Testing event xfs_trans_bhold: 
[   10.721000] generic-usb 0003:0557:2220.0002: input: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input1
[   10.722072] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[   10.722503] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   10.722956] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[   10.738170] OK
[   10.738384] Testing event xfs_trans_bhold_release: OK
[   10.757273] Testing event xfs_trans_binval: OK
[   10.774419] Testing event xfs_ilock: OK
[   10.791297] Testing event xfs_ilock_nowait: OK
[   10.807331] Testing event xfs_ilock_demote: OK
[   10.824286] Testing event xfs_iunlock: OK
[   10.841355] Testing event xfs_iget_skip: OK
[   10.860308] Testing event xfs_iget_reclaim: OK
[   10.877478] Testing event xfs_iget_reclaim_fail: OK
[   10.896278] Testing event xfs_iget_hit: OK
[   10.912351] Testing event xfs_iget_miss: OK
[   10.930400] Testing event xfs_getattr: OK
[   10.947480] Testing event xfs_setattr: OK
[   10.965345] Testing event xfs_readlink: OK
[   10.982324] Testing event xfs_alloc_file_space: OK
[   10.999294] Testing event xfs_free_file_space: OK
[   11.016365] Testing event xfs_readdir: OK
[   11.034394] Testing event xfs_get_acl: OK
[   11.052241] Testing event xfs_vm_bmap: OK
[   11.068228] Testing event xfs_file_ioctl: OK
[   11.084365] Testing event xfs_file_compat_ioctl: OK
[   11.101267] Testing event xfs_ioctl_setattr: OK
[   11.117353] Testing event xfs_dir_fsync: OK
[   11.134402] Testing event xfs_file_fsync: 
[   11.148385] scsi 9:0:0:0: Direct-Access     Teclast  CoolFlash        0.00 PQ: 0 ANSI: 2
[   11.149247] scsi: killing requests for dead queue
[   11.149572] scsi: killing requests for dead queue
[   11.150084] scsi: killing requests for dead queue
[   11.150406] scsi: killing requests for dead queue
[   11.150949] scsi: killing requests for dead queue
[   11.151272] scsi: killing requests for dead queue
[   11.151753] scsi: killing requests for dead queue
[   11.152081] scsi: killing requests for dead queue
[   11.152563] scsi: killing requests for dead queue
[   11.152897] scsi: killing requests for dead queue
[   11.153123] OK
[   11.153125] Testing event xfs_destroy_inode: scsi: killing requests for dead queue
[   11.154130] scsi: killing requests for dead queue
[   11.154591] scsi: killing requests for dead queue
[   11.154926] scsi: killing requests for dead queue
[   11.155896] scsi_scan_9 used greatest stack depth: 4968 bytes left
[   11.156995] sd 9:0:0:0: [sdb] 63084544 512-byte logical blocks: (32.2 GB/30.0 GiB)
[   11.158115] sd 9:0:0:0: [sdb] Write Protect is off
[   11.158440] sd 9:0:0:0: [sdb] Mode Sense: 00 00 00 00
[   11.159364] sd 9:0:0:0: [sdb] Asking for cache data failed
[   11.159714] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[   11.164238] sd 9:0:0:0: [sdb] Asking for cache data failed
[   11.164589] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[   11.170097] OK
[   11.170303] Testing event xfs_write_inode: OK
[   11.188195] Testing event xfs_evict_inode: OK
[   11.206197] Testing event xfs_dquot_dqalloc: OK
[   11.223273] Testing event xfs_dquot_dqdetach: OK
[   11.240165] Testing event xfs_ihold: OK
[   11.258253] Testing event xfs_irele: OK
[   11.276192] Testing event xfs_inode_pin: OK
[   11.294240] Testing event xfs_inode_unpin: 
[   11.298886]  sdb: sdb1 sdb2 sdb3
[   11.303372] sd 9:0:0:0: [sdb] Asking for cache data failed
[   11.303724] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[   11.304105] sd 9:0:0:0: [sdb] Attached SCSI removable disk
[   11.310072] OK
[   11.310284] Testing event xfs_inode_unpin_nowait: OK
[   11.326325] Testing event xfs_remove: OK
[   11.342352] Testing event xfs_link: OK
[   11.360271] Testing event xfs_lookup: OK
[   11.377313] Testing event xfs_create: OK
[   11.395368] Testing event xfs_symlink: OK
[   11.412367] Testing event xfs_rename: OK
[   11.429398] Testing event xfs_dqadjust: OK
[   11.446269] Testing event xfs_dqreclaim_want: OK
[   11.462305] Testing event xfs_dqreclaim_dirty: OK
[   11.478457] Testing event xfs_dqreclaim_unlink: OK
[   11.495463] Testing event xfs_dqattach_found: OK
[   11.512245] Testing event xfs_dqattach_get: OK
[   11.529413] Testing event xfs_dqinit: OK
[   11.547360] Testing event xfs_dqreuse: OK
[   11.564394] Testing event xfs_dqalloc: OK
[   11.581454] Testing event xfs_dqtobp_read: OK
[   11.599318] Testing event xfs_dqread: OK
[   11.615315] Testing event xfs_dqread_fail: OK
[   11.632432] Testing event xfs_dqlookup_found: OK
[   11.650425] Testing event xfs_dqlookup_want: OK
[   11.667395] Testing event xfs_dqlookup_freelist: OK
[   11.685420] Testing event xfs_dqlookup_done: OK
[   11.702414] Testing event xfs_dqget_hit: OK
[   11.719254] Testing event xfs_dqget_miss: OK
[   11.735338] Testing event xfs_dqput: OK
[   11.751320] Testing event xfs_dqput_wait: OK
[   11.768352] Testing event xfs_dqput_free: OK
[   11.784360] Testing event xfs_dqrele: OK
[   11.800303] Testing event xfs_dqflush: OK
[   11.816390] Testing event xfs_dqflush_force: OK
[   11.836507] Testing event xfs_dqflush_done: OK
[   11.853379] Testing event xfs_log_done_nonperm: OK
[   11.870362] Testing event xfs_log_done_perm: OK
[   11.887382] Testing event xfs_log_reserve: OK
[   11.904382] Testing event xfs_log_umount_write: OK
[   11.921322] Testing event xfs_log_grant_enter: OK
[   11.940339] Testing event xfs_log_grant_exit: OK
[   11.958400] Testing event xfs_log_grant_error: OK
[   11.975283] Testing event xfs_log_grant_sleep1: OK
[   11.991317] Testing event xfs_log_grant_wake1: OK
[   12.007397] Testing event xfs_log_grant_sleep2: OK
[   12.024354] Testing event xfs_log_grant_wake2: OK
[   12.041427] Testing event xfs_log_grant_wake_up: OK
[   12.059358] Testing event xfs_log_regrant_write_enter: OK
[   12.076359] Testing event xfs_log_regrant_write_exit: OK
[   12.093259] Testing event xfs_log_regrant_write_error: OK
[   12.109435] Testing event xfs_log_regrant_write_sleep1: OK
[   12.126436] Testing event xfs_log_regrant_write_wake1: OK
[   12.143376] Testing event xfs_log_regrant_write_sleep2: OK
[   12.160300] Testing event xfs_log_regrant_write_wake2: OK
[   12.177375] Testing event xfs_log_regrant_write_wake_up: OK
[   12.194440] Testing event xfs_log_regrant_reserve_enter: OK
[   12.212525] Testing event xfs_log_regrant_reserve_exit: OK
[   12.229328] Testing event xfs_log_regrant_reserve_sub: OK
[   12.246351] Testing event xfs_log_ungrant_enter: OK
[   12.263318] Testing event xfs_log_ungrant_exit: OK
[   12.280464] Testing event xfs_log_ungrant_sub: OK
[   12.297278] Testing event xfs_ail_push: OK
[   12.313280] Testing event xfs_ail_pushbuf: OK
[   12.329284] Testing event xfs_ail_pushbuf_pinned: OK
[   12.346407] Testing event xfs_ail_pinned: OK
[   12.365422] Testing event xfs_ail_locked: OK
[   12.383442] Testing event xfs_file_read: OK
[   12.401296] Testing event xfs_file_buffered_write: OK
[   12.418392] Testing event xfs_file_direct_write: OK
[   12.435449] Testing event xfs_file_splice_read: OK
[   12.452442] Testing event xfs_file_splice_write: OK
[   12.469427] Testing event xfs_writepage: OK
[   12.486297] Testing event xfs_releasepage: OK
[   12.502296] Testing event xfs_invalidatepage: OK
[   12.518306] Testing event xfs_map_blocks_found: OK
[   12.534407] Testing event xfs_map_blocks_alloc: OK
[   12.551456] Testing event xfs_get_blocks_found: OK
[   12.568377] Testing event xfs_get_blocks_alloc: OK
[   12.586435] Testing event xfs_delalloc_enospc: OK
[   12.603411] Testing event xfs_unwritten_convert: OK
[   12.621263] Testing event xfs_get_blocks_notfound: OK
[   12.637283] Testing event xfs_setfilesize: OK
[   12.655393] Testing event xfs_itruncate_data_start: OK
[   12.674447] Testing event xfs_itruncate_data_end: OK
[   12.691416] Testing event xfs_pagecache_inval: OK
[   12.708289] Testing event xfs_bunmap: OK
[   12.724491] Testing event xfs_alloc_busy: OK
[   12.741383] Testing event xfs_alloc_busy_enomem: OK
[   12.758370] Testing event xfs_alloc_busy_force: OK
[   12.775364] Testing event xfs_alloc_busy_reuse: OK
[   12.792398] Testing event xfs_alloc_busy_clear: OK
[   12.810341] Testing event xfs_alloc_busy_trim: OK
[   12.826412] Testing event xfs_trans_commit_lsn: OK
[   12.843364] Testing event xfs_agf: OK
[   12.859377] Testing event xfs_free_extent: OK
[   12.876347] Testing event xfs_alloc_exact_done: OK
[   12.892418] Testing event xfs_alloc_exact_notfound: OK
[   12.909367] Testing event xfs_alloc_exact_error: OK
[   12.926410] Testing event xfs_alloc_near_nominleft: OK
[   12.944404] Testing event xfs_alloc_near_first: OK
[   12.961341] Testing event xfs_alloc_near_greater: OK
[   12.977341] Testing event xfs_alloc_near_lesser: OK
[   12.993368] Testing event xfs_alloc_near_error: OK
[   13.009411] Testing event xfs_alloc_near_noentry: OK
[   13.026539] Testing event xfs_alloc_near_busy: OK
[   13.043444] Testing event xfs_alloc_size_neither: OK
[   13.060442] Testing event xfs_alloc_size_noentry: OK
[   13.077431] Testing event xfs_alloc_size_nominleft: OK
[   13.094303] Testing event xfs_alloc_size_done: OK
[   13.110302] Testing event xfs_alloc_size_error: OK
[   13.126492] Testing event xfs_alloc_size_busy: OK
[   13.144441] Testing event xfs_alloc_small_freelist: OK
[   13.161379] Testing event xfs_alloc_small_notenough: OK
[   13.180383] Testing event xfs_alloc_small_done: OK
[   13.198428] Testing event xfs_alloc_small_error: OK
[   13.215305] Testing event xfs_alloc_vextent_badargs: OK
[   13.231350] Testing event xfs_alloc_vextent_nofix: OK
[   13.248473] Testing event xfs_alloc_vextent_noagbp: OK
[   13.265467] Testing event xfs_alloc_vextent_loopfailed: OK
[   13.283437] Testing event xfs_alloc_vextent_allfailed: OK
[   13.300468] Testing event xfs_dir2_sf_addname: OK
[   13.317418] Testing event xfs_dir2_sf_create: OK
[   13.334518] Testing event xfs_dir2_sf_lookup: OK
[   13.351375] Testing event xfs_dir2_sf_replace: OK
[   13.369397] Testing event xfs_dir2_sf_removename: OK
[   13.386481] Testing event xfs_dir2_sf_toino4: OK
[   13.403483] Testing event xfs_dir2_sf_toino8: OK
[   13.420471] Testing event xfs_dir2_sf_to_block: OK
[   13.437443] Testing event xfs_dir2_block_addname: OK
[   13.454334] Testing event xfs_dir2_block_lookup: OK
[   13.470359] Testing event xfs_dir2_block_replace: OK
[   13.487263] Testing event xfs_dir2_block_removename: OK
[   13.503578] Testing event xfs_dir2_block_to_sf: OK
[   13.521483] Testing event xfs_dir2_block_to_leaf: OK
[   13.540437] Testing event xfs_dir2_leaf_addname: OK
[   13.559397] Testing event xfs_dir2_leaf_lookup: OK
[   13.578315] Testing event xfs_dir2_leaf_replace: OK
[   13.594395] Testing event xfs_dir2_leaf_removename: OK
[   13.611283] Testing event xfs_dir2_leaf_to_block: OK
[   13.627310] Testing event xfs_dir2_leaf_to_node: OK
[   13.643331] Testing event xfs_dir2_node_addname: OK
[   13.659319] Testing event xfs_dir2_node_lookup: OK
[   13.675281] Testing event xfs_dir2_node_replace: OK
[   13.691448] Testing event xfs_dir2_node_removename: OK
[   13.709355] Testing event xfs_dir2_node_to_leaf: OK
[   13.726306] Testing event xfs_dir2_leafn_add: OK
[   13.742287] Testing event xfs_dir2_leafn_remove: OK
[   13.758515] Testing event xfs_dir2_grow_inode: OK
[   13.776312] Testing event xfs_dir2_shrink_inode: OK
[   13.792500] Testing event xfs_dir2_leafn_moveents: OK
[   13.809489] Testing event xfs_swap_extent_before: OK
[   13.826485] Testing event xfs_swap_extent_after: OK
[   13.843496] Testing event xfs_log_recover_item_add: OK
[   13.860459] Testing event xfs_log_recover_item_add_cont: OK
[   13.878398] Testing event xfs_log_recover_item_reorder_head: OK
[   13.895316] Testing event xfs_log_recover_item_reorder_tail: OK
[   13.911274] Testing event xfs_log_recover_item_recover: OK
[   13.927500] Testing event xfs_log_recover_buf_not_cancel: OK
[   13.944496] Testing event xfs_log_recover_buf_cancel: OK
[   13.961317] Testing event xfs_log_recover_buf_cancel_add: OK
[   13.977449] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   13.994495] Testing event xfs_log_recover_buf_recover: OK
[   14.011497] Testing event xfs_log_recover_buf_inode_buf: OK
[   14.029412] Testing event xfs_log_recover_buf_reg_buf: OK
[   14.047468] Testing event xfs_log_recover_buf_dquot_buf: OK
[   14.064320] Testing event xfs_log_recover_inode_recover: OK
[   14.080371] Testing event xfs_log_recover_inode_cancel: OK
[   14.097455] Testing event xfs_log_recover_inode_skip: OK
[   14.114431] Testing event xfs_discard_extent: OK
[   14.131508] Testing event xfs_discard_toosmall: OK
[   14.148507] Testing event xfs_discard_exclude: OK
[   14.166504] Testing event xfs_discard_busy: OK
[   14.183500] Testing event jbd2_checkpoint: OK
[   14.200343] Testing event jbd2_start_commit: OK
[   14.216368] Testing event jbd2_commit_locking: OK
[   14.232466] Testing event jbd2_commit_flushing: OK
[   14.249480] Testing event jbd2_commit_logging: OK
[   14.266494] Testing event jbd2_end_commit: OK
[   14.283362] Testing event jbd2_submit_inode_data: OK
[   14.299413] Testing event jbd2_run_stats: OK
[   14.316478] Testing event jbd2_checkpoint_stats: OK
[   14.334415] Testing event jbd2_cleanup_journal_tail: OK
[   14.351423] Testing event jbd_checkpoint: OK
[   14.368378] Testing event jbd_start_commit: OK
[   14.384518] Testing event jbd_commit_locking: OK
[   14.401423] Testing event jbd_commit_flushing: OK
[   14.418479] Testing event jbd_commit_logging: OK
[   14.435505] Testing event jbd_drop_transaction: OK
[   14.452486] Testing event jbd_end_commit: OK
[   14.469513] Testing event jbd_do_submit_data: OK
[   14.486477] Testing event jbd_cleanup_journal_tail: OK
[   14.503355] Testing event jbd_update_superblock_end: OK
[   14.519400] Testing event ext4_free_inode: OK
[   14.535516] Testing event ext4_request_inode: OK
[   14.553521] Testing event ext4_allocate_inode: OK
[   14.570469] Testing event ext4_evict_inode: OK
[   14.587429] Testing event ext4_drop_inode: OK
[   14.603460] Testing event ext4_mark_inode_dirty: OK
[   14.620516] Testing event ext4_begin_ordered_truncate: OK
[   14.637524] Testing event ext4_write_begin: OK
[   14.654479] Testing event ext4_da_write_begin: OK
[   14.671501] Testing event ext4_ordered_write_end: OK
[   14.688520] Testing event ext4_writeback_write_end: OK
[   14.705498] Testing event ext4_journalled_write_end: OK
[   14.722590] Testing event ext4_da_write_end: OK
[   14.739499] Testing event ext4_da_writepages: OK
[   14.756363] Testing event ext4_da_write_pages: OK
[   14.772420] Testing event ext4_da_writepages_result: OK
[   14.789495] Testing event ext4_writepage: OK
[   14.807562] Testing event ext4_readpage: OK
[   14.824457] Testing event ext4_releasepage: OK
[   14.840386] Testing event ext4_invalidatepage: OK
[   14.856509] Testing event ext4_discard_blocks: OK
[   14.873367] Testing event ext4_mb_new_inode_pa: OK
[   14.892443] Testing event ext4_mb_new_group_pa: OK
[   14.908471] Testing event ext4_mb_release_inode_pa: OK
[   14.925528] Testing event ext4_mb_release_group_pa: OK
[   14.943537] Testing event ext4_discard_preallocations: OK
[   14.960535] Testing event ext4_mb_discard_preallocations: OK
[   14.977484] Testing event ext4_request_blocks: OK
[   14.994409] Testing event ext4_allocate_blocks: OK
[   15.011561] Testing event ext4_free_blocks: OK
[   15.029537] Testing event ext4_sync_file_enter: OK
[   15.047628] Testing event ext4_sync_file_exit: OK
[   15.064425] Testing event ext4_sync_fs: OK
[   15.081408] Testing event ext4_alloc_da_blocks: OK
[   15.097422] Testing event ext4_mballoc_alloc: OK
[   15.114454] Testing event ext4_mballoc_prealloc: OK
[   15.131539] Testing event ext4_mballoc_discard: OK
[   15.148540] Testing event ext4_mballoc_free: OK
[   15.165544] Testing event ext4_forget: OK
[   15.182398] Testing event ext4_da_update_reserve_space: OK
[   15.199445] Testing event ext4_da_reserve_space: OK
[   15.215424] Testing event ext4_da_release_space: OK
[   15.231505] Testing event ext4_mb_bitmap_load: OK
[   15.249456] Testing event ext4_mb_buddy_bitmap_load: OK
[   15.266554] Testing event ext4_read_block_bitmap_load: OK
[   15.283544] Testing event ext4_load_inode_bitmap: OK
[   15.300539] Testing event ext4_direct_IO_enter: OK
[   15.317543] Testing event ext4_direct_IO_exit: OK
[   15.334510] Testing event ext4_fallocate_enter: OK
[   15.351379] Testing event ext4_fallocate_exit: OK
[   15.367579] Testing event ext4_unlink_enter: OK
[   15.384454] Testing event ext4_unlink_exit: OK
[   15.401460] Testing event ext4_truncate_enter: OK
[   15.418501] Testing event ext4_truncate_exit: OK
[   15.435589] Testing event ext4_ext_convert_to_initialized_enter: OK
[   15.453439] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   15.470527] Testing event ext4_ext_map_blocks_enter: OK
[   15.487642] Testing event ext4_ind_map_blocks_enter: OK
[   15.504454] Testing event ext4_ext_map_blocks_exit: OK
[   15.522459] Testing event ext4_ind_map_blocks_exit: OK
[   15.539588] Testing event ext4_ext_load_extent: OK
[   15.557443] Testing event ext4_load_inode: OK
[   15.574468] Testing event ext4_journal_start: OK
[   15.591515] Testing event ext4_trim_extent: OK
[   15.608478] Testing event ext4_trim_all_free: OK
[   15.625469] Testing event ext4_ext_handle_uninitialized_extents: OK
[   15.642547] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   15.659543] Testing event ext4_ext_put_in_cache: OK
[   15.676502] Testing event ext4_ext_in_cache: OK
[   15.693558] Testing event ext4_find_delalloc_range: OK
[   15.710504] Testing event ext4_get_reserved_cluster_alloc: OK
[   15.727394] Testing event ext4_ext_show_extent: OK
[   15.743418] Testing event ext4_remove_blocks: OK
[   15.759596] Testing event ext4_ext_rm_leaf: OK
[   15.776385] Testing event ext4_ext_rm_idx: OK
[   15.794518] Testing event ext4_ext_remove_space: OK
[   15.812548] Testing event ext4_ext_remove_space_done: OK
[   15.829562] Testing event ext3_free_inode: OK
[   15.846425] Testing event ext3_request_inode: OK
[   15.862449] Testing event ext3_allocate_inode: OK
[   15.878473] Testing event ext3_evict_inode: OK
[   15.894476] Testing event ext3_drop_inode: OK
[   15.910603] Testing event ext3_mark_inode_dirty: OK
[   15.928660] Testing event ext3_write_begin: OK
[   15.945463] Testing event ext3_ordered_write_end: OK
[   15.962471] Testing event ext3_writeback_write_end: OK
[   15.980478] Testing event ext3_journalled_write_end: OK
[   15.997527] Testing event ext3_ordered_writepage: OK
[   16.014427] Testing event ext3_writeback_writepage: OK
[   16.030513] Testing event ext3_journalled_writepage: OK
[   16.048654] Testing event ext3_readpage: OK
[   16.065657] Testing event ext3_releasepage: OK
[   16.083385] Testing event ext3_invalidatepage: OK
[   16.101478] Testing event ext3_discard_blocks: OK
[   16.119524] Testing event ext3_request_blocks: OK
[   16.136571] Testing event ext3_allocate_blocks: OK
[   16.153560] Testing event ext3_free_blocks: OK
[   16.170507] Testing event ext3_sync_file_enter: OK
[   16.187560] Testing event ext3_sync_file_exit: OK
[   16.205530] Testing event ext3_sync_fs: OK
[   16.222478] Testing event ext3_rsv_window_add: OK
[   16.241490] Testing event ext3_discard_reservation: OK
[   16.259484] Testing event ext3_alloc_new_reservation: OK
[   16.276460] Testing event ext3_reserved: OK
[   16.292470] Testing event ext3_forget: OK
[   16.308623] Testing event ext3_read_block_bitmap: OK
[   16.326583] Testing event ext3_direct_IO_enter: OK
[   16.343581] Testing event ext3_direct_IO_exit: OK
[   16.361545] Testing event ext3_unlink_enter: OK
[   16.378575] Testing event ext3_unlink_exit: OK
[   16.395574] Testing event ext3_truncate_enter: OK
[   16.412541] Testing event ext3_truncate_exit: OK
[   16.429583] Testing event ext3_get_blocks_enter: OK
[   16.446543] Testing event ext3_get_blocks_exit: OK
[   16.463583] Testing event ext3_load_inode: OK
[   16.480554] Testing event writeback_nothread: OK
[   16.497423] Testing event writeback_queue: OK
[   16.513486] Testing event writeback_exec: OK
[   16.530383] Testing event writeback_start: OK
[   16.547453] Testing event writeback_written: OK
[   16.563552] Testing event writeback_wait: OK
[   16.581394] Testing event writeback_pages_written: OK
[   16.597535] Testing event writeback_nowork: OK
[   16.615589] Testing event writeback_wake_background: OK
[   16.632555] Testing event writeback_wake_thread: OK
[   16.649619] Testing event writeback_wake_forker_thread: OK
[   16.666497] Testing event writeback_bdi_register: OK
[   16.683514] Testing event writeback_bdi_unregister: OK
[   16.700613] Testing event writeback_thread_start: OK
[   16.717499] Testing event writeback_thread_stop: OK
[   16.734516] Testing event wbc_writepage: OK
[   16.751588] Testing event writeback_queue_io: OK
[   16.768560] Testing event task_io: OK
[   16.785606] Testing event global_dirty_state: OK
[   16.803457] Testing event bdi_dirty_state: OK
[   16.819500] Testing event blkcg_dirty_ratelimit: OK
[   16.836626] Testing event bdi_dirty_ratelimit: OK
[   16.853553] Testing event balance_dirty_pages: OK
[   16.871517] Testing event writeback_congestion_wait: OK
[   16.888561] Testing event writeback_wait_iff_congested: OK
[   16.905599] Testing event writeback_single_inode_requeue: OK
[   16.922604] Testing event writeback_single_inode: OK
[   16.939589] Testing event kmalloc: OK
[   16.956598] Testing event kmem_cache_alloc: OK
[   16.973529] Testing event kmalloc_node: OK
[   16.991498] Testing event kmem_cache_alloc_node: OK
[   17.008441] Testing event kfree: OK
[   17.024621] Testing event kmem_cache_free: OK
[   17.042616] Testing event mm_page_free_direct: OK
[   17.059598] Testing event mm_pagevec_free: OK
[   17.077542] Testing event mm_page_alloc: OK
[   17.095522] Testing event mm_page_alloc_zone_locked: OK
[   17.112552] Testing event mm_page_pcpu_drain: OK
[   17.129552] Testing event mm_page_alloc_extfrag: OK
[   17.146563] Testing event mm_vmscan_kswapd_sleep: OK
[   17.163562] Testing event mm_vmscan_kswapd_wake: OK
[   17.180510] Testing event mm_vmscan_wakeup_kswapd: OK
[   17.199512] Testing event mm_vmscan_direct_reclaim_begin: OK
[   17.217613] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   17.234564] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   17.251615] Testing event mm_vmscan_direct_reclaim_end: OK
[   17.268573] Testing event mm_vmscan_memcg_reclaim_end: OK
[   17.285593] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   17.302609] Testing event mm_shrink_slab_start: OK
[   17.319596] Testing event mm_shrink_slab_end: OK
[   17.336476] Testing event mm_vmscan_lru_isolate: OK
[   17.353556] Testing event mm_vmscan_memcg_isolate: OK
[   17.371646] Testing event mm_vmscan_writepage: OK
[   17.388523] Testing event mm_vmscan_lru_shrink_inactive: OK
[   17.407517] Testing event replace_swap_token: OK
[   17.424541] Testing event put_swap_token: OK
[   17.441550] Testing event disable_swap_token: OK
[   17.458605] Testing event update_swap_token_priority: OK
[   17.475570] Testing event cpu_idle: OK
[   17.493627] Testing event cpu_frequency: OK
[   17.510434] Testing event machine_suspend: OK
[   17.528533] Testing event power_start: OK
[   17.547570] Testing event power_frequency: OK
[   17.564583] Testing event power_end: OK
[   17.581473] Testing event clock_enable: OK
[   17.597463] Testing event clock_disable: OK
[   17.614431] Testing event clock_set_rate: OK
[   17.630471] Testing event power_domain_target: OK
[   17.646582] Testing event ftrace_test_filter: OK
[   17.663540] Testing event module_load: OK
[   17.680519] Testing event module_free: OK
[   17.696511] Testing event module_get: OK
[   17.712526] Testing event module_put: OK
[   17.728592] Testing event module_request: OK
[   17.745428] Testing event lock_acquire: OK
[   17.761557] Testing event lock_release: OK
[   17.778466] Testing event lock_contended: OK
[   17.794429] Testing event lock_acquired: OK
[   17.810633] Testing event rcu_utilization: OK
[   17.827677] Testing event rcu_grace_period: OK
[   17.845600] Testing event rcu_grace_period_init: OK
[   17.863455] Testing event rcu_preempt_task: OK
[   17.879618] Testing event rcu_unlock_preempted_task: OK
[   17.896588] Testing event rcu_quiescent_state_report: OK
[   17.913554] Testing event rcu_fqs: OK
[   17.929564] Testing event rcu_dyntick: OK
[   17.946578] Testing event rcu_callback: OK
[   17.965512] Testing event rcu_kfree_callback: OK
[   17.981526] Testing event rcu_batch_start: OK
[   17.998610] Testing event rcu_invoke_callback: OK
[   18.016492] Testing event rcu_invoke_kfree_callback: OK
[   18.032575] Testing event rcu_batch_end: OK
[   18.048665] Testing event workqueue_queue_work: OK
[   18.065652] Testing event workqueue_activate_work: OK
[   18.082544] Testing event workqueue_execute_start: OK
[   18.099644] Testing event workqueue_execute_end: OK
[   18.117572] Testing event signal_generate: OK
[   18.135543] Testing event signal_deliver: OK
[   18.151688] Testing event signal_overflow_fail: OK
[   18.168555] Testing event signal_lose_info: OK
[   18.185556] Testing event timer_init: OK
[   18.202686] Testing event timer_start: OK
[   18.219755] Testing event timer_expire_entry: OK
[   18.236571] Testing event timer_expire_exit: OK
[   18.254565] Testing event timer_cancel: OK
[   18.271600] Testing event hrtimer_init: OK
[   18.288628] Testing event hrtimer_start: OK
[   18.305590] Testing event hrtimer_expire_entry: OK
[   18.322602] Testing event hrtimer_expire_exit: OK
[   18.339699] Testing event hrtimer_cancel: OK
[   18.357626] Testing event itimer_state: OK
[   18.375653] Testing event itimer_expire: OK
[   18.393641] Testing event irq_handler_entry: OK
[   18.410511] Testing event irq_handler_exit: OK
[   18.427536] Testing event softirq_entry: OK
[   18.443620] Testing event softirq_exit: OK
[   18.460606] Testing event softirq_raise: OK
[   18.477659] Testing event sched_kthread_stop: OK
[   18.494619] Testing event sched_kthread_stop_ret: OK
[   18.511487] Testing event sched_wakeup: OK
[   18.527543] Testing event sched_wakeup_new: OK
[   18.543586] Testing event sched_switch: OK
[   18.561530] Testing event sched_migrate_task: OK
[   18.577518] Testing event sched_process_free: OK
[   18.593564] Testing event sched_process_exit: OK
[   18.609506] Testing event sched_wait_task: OK
[   18.626568] Testing event sched_process_wait: OK
[   18.643575] Testing event sched_process_fork: OK
[   18.661662] Testing event sched_stat_wait: OK
[   18.678644] Testing event sched_stat_sleep: OK
[   18.695526] Testing event sched_stat_iowait: OK
[   18.711538] Testing event sched_stat_runtime: OK
[   18.727545] Testing event sched_pi_setprio: OK
[   18.744536] Testing event mce_record: OK
[   18.760646] Testing event sys_enter: OK
[   18.778546] Testing event sys_exit: OK
[   18.794708] Testing event emulate_vsyscall: OK
[   18.812677] Testing event kvm_mmu_pagetable_walk: OK
[   18.829664] Testing event kvm_mmu_paging_element: OK
[   18.846685] Testing event kvm_mmu_set_accessed_bit: OK
[   18.863623] Testing event kvm_mmu_set_dirty_bit: OK
[   18.880574] Testing event kvm_mmu_walker_error: OK
[   18.897709] Testing event kvm_mmu_get_page: OK
[   18.914578] Testing event kvm_mmu_sync_page: OK
[   18.932626] Testing event kvm_mmu_unsync_page: OK
[   18.949576] Testing event kvm_mmu_prepare_zap_page: OK
[   18.966634] Testing event kvm_mmu_delay_free_pages: OK
[   18.984640] Testing event mark_mmio_spte: OK
[   19.001632] Testing event handle_mmio_page_fault: OK
[   19.018496] Testing event kvm_mmu_audit: OK
[   19.036590] Testing event kvm_entry: OK
[   19.053581] Testing event kvm_hypercall: OK
[   19.070651] Testing event kvm_hv_hypercall: OK
[   19.087675] Testing event kvm_pio: OK
[   19.104750] Testing event kvm_cpuid: OK
[   19.121679] Testing event kvm_apic: OK
[   19.138675] Testing event kvm_exit: OK
[   19.155639] Testing event kvm_inj_virq: OK
[   19.172679] Testing event kvm_inj_exception: OK
[   19.189662] Testing event kvm_page_fault: OK
[   19.206539] Testing event kvm_msr: OK
[   19.222604] Testing event kvm_cr: OK
[   19.239584] Testing event kvm_pic_set_irq: OK
[   19.255592] Testing event kvm_apic_ipi: OK
[   19.272648] Testing event kvm_apic_accept_irq: OK
[   19.290684] Testing event kvm_nested_vmrun: OK
[   19.308589] Testing event kvm_nested_intercepts: OK
[   19.327691] Testing event kvm_nested_vmexit: OK
[   19.345685] Testing event kvm_nested_vmexit_inject: OK
[   19.362729] Testing event kvm_nested_intr_vmexit: OK
[   19.379625] Testing event kvm_invlpga: OK
[   19.395622] Testing event kvm_skinit: OK
[   19.412642] Testing event kvm_emulate_insn: OK
[   19.429588] Testing event vcpu_match_mmio: OK
[   19.448594] Testing event kvm_userspace_exit: OK
[   19.467651] Testing event kvm_set_irq: OK
[   19.484674] Testing event kvm_ioapic_set_irq: OK
[   19.501485] Testing event kvm_msi_set_irq: OK
[   19.517519] Testing event kvm_ack_irq: OK
[   19.533514] Testing event kvm_mmio: OK
[   19.549490] Testing event kvm_fpu: OK
[   19.565519] Testing event kvm_age_page: OK
[   19.581566] Testing event kvm_try_async_get_page: OK
[   19.597483] Testing event kvm_async_pf_doublefault: OK
[   19.613533] Testing event kvm_async_pf_not_present: OK
[   19.629624] Testing event kvm_async_pf_ready: OK
[   19.646694] Testing event kvm_async_pf_completed: OK
[   19.664497] Running tests on trace event systems:
[   19.664821] Testing event system skb: OK
[   19.681637] Testing event system net: OK
[   19.700647] Testing event system napi: OK
[   19.719532] Testing event system sock: OK
[   19.735788] Testing event system udp: OK
[   19.753664] Testing event system hda: OK
[   19.771724] Testing event system scsi: OK
[   19.789688] Testing event system i915: OK
[   19.807588] Testing event system drm: OK
[   19.824859] Testing event system block: OK
[   19.842201] Testing event system btrfs: OK
[   19.860418] Testing event system xfs: OK
[   19.911830] Testing event system jbd2: OK
[   19.928972] Testing event system jbd: OK
[   19.946974] Testing event system ext4: OK
[   19.970095] Testing event system ext3: OK
[   19.990165] Testing event system writeback: OK
[   20.009824] Testing event system kmem: OK
[   20.027988] Testing event system vmscan: OK
[   20.046319] Testing event system power: OK
[   20.063971] Testing event system test: OK
[   20.081537] Testing event system module: OK
[   20.100704] Testing event system lock: OK
[   20.117672] Testing event system rcu: OK
[   20.135065] Testing event system workqueue: OK
[   20.151662] Testing event system signal: OK
[   20.168666] Testing event system timer: OK
[   20.185996] Testing event system irq: OK
[   20.203970] Testing event system sched: OK
[   20.222241] Testing event system mce: OK
[   20.238552] Testing event system raw_syscalls: OK
[   20.255654] Testing event system vsyscall: OK
[   20.272575] Testing event system syscalls: OK
[   20.289971] Testing event system kvmmmu: OK
[   20.308181] Testing event system kvm: OK
[   20.330074] Running tests on all trace events:
[   20.330398] Testing all events: OK
[   20.474302] Running tests again, along with the function tracer
[   20.474764] Running tests on trace events:
[   20.475137] Testing event kfree_skb: OK
[   20.492006] Testing event consume_skb: OK
[   20.509219] Testing event skb_copy_datagram_iovec: OK
[   20.526975] Testing event net_dev_xmit: OK
[   20.544227] Testing event net_dev_queue: OK
[   20.561995] Testing event netif_receive_skb: OK
[   20.580024] Testing event netif_rx: OK
[   20.598939] Testing event napi_poll: OK
[   20.616206] Testing event sock_rcvqueue_full: OK
[   20.634154] Testing event sock_exceed_buf_limit: OK
[   20.651907] Testing event udp_fail_queue_rcv_skb: OK
[   20.668935] Testing event hda_send_cmd: OK
[   20.685938] Testing event hda_get_response: OK
[   20.702976] Testing event hda_bus_reset: OK
[   20.720030] Testing event hda_power_down: OK
[   20.737003] Testing event hda_power_up: OK
[   20.754178] Testing event hda_unsol_event: OK
[   20.774167] Testing event scsi_dispatch_cmd_start: OK
[   20.793959] Testing event scsi_dispatch_cmd_error: OK
[   20.813207] Testing event scsi_dispatch_cmd_done: OK
[   20.832038] Testing event scsi_dispatch_cmd_timeout: OK
[   20.848999] Testing event scsi_eh_wakeup: OK
[   20.866105] Testing event i915_gem_object_create: OK
[   20.884009] Testing event i915_gem_object_bind: OK
[   20.903202] Testing event i915_gem_object_unbind: OK
[   20.922236] Testing event i915_gem_object_change_domain: OK
[   20.940963] Testing event i915_gem_object_pwrite: OK
[   20.959247] Testing event i915_gem_object_pread: OK
[   20.977001] Testing event i915_gem_object_fault: OK
[   20.993891] Testing event i915_gem_object_clflush: OK
[   21.011287] Testing event i915_gem_object_destroy: OK
[   21.029304] Testing event i915_gem_evict: OK
[   21.047291] Testing event i915_gem_evict_everything: OK
[   21.065018] Testing event i915_gem_ring_dispatch: OK
[   21.084237] Testing event i915_gem_ring_flush: OK
[   21.103195] Testing event i915_gem_request_add: OK
[   21.123283] Testing event i915_gem_request_complete: OK
[   21.141275] Testing event i915_gem_request_retire: OK
[   21.159973] Testing event i915_gem_request_wait_begin: OK
[   21.178315] Testing event i915_gem_request_wait_end: OK
[   21.199231] Testing event i915_ring_wait_begin: OK
[   21.217231] Testing event i915_ring_wait_end: OK
[   21.235017] Testing event i915_flip_request: OK
[   21.254325] Testing event i915_flip_complete: OK
[   21.273256] Testing event i915_reg_rw: OK
[   21.291157] Testing event drm_vblank_event: OK
[   21.310070] Testing event drm_vblank_event_queued: OK
[   21.328179] Testing event drm_vblank_event_delivered: OK
[   21.348200] Testing event block_rq_abort: OK
[   21.368327] Testing event block_rq_requeue: OK
[   21.386248] Testing event block_rq_complete: OK
[   21.404026] Testing event block_rq_insert: OK
[   21.423166] Testing event block_rq_issue: OK
[   21.441019] Testing event block_bio_bounce: OK
[   21.458208] Testing event block_bio_complete: OK
[   21.476151] Testing event block_bio_backmerge: OK
[   21.493105] Testing event block_bio_frontmerge: OK
[   21.511310] Testing event block_bio_queue: OK
[   21.529313] Testing event block_getrq: OK
[   21.548364] Testing event block_sleeprq: OK
[   21.568267] Testing event block_plug: OK
[   21.587187] Testing event block_unplug: OK
[   21.607211] Testing event block_split: OK
[   21.626346] Testing event block_bio_remap: OK
[   21.644255] Testing event block_rq_remap: OK
[   21.662219] Testing event btrfs_transaction_commit: OK
[   21.682993] Testing event btrfs_inode_new: OK
[   21.700215] Testing event btrfs_inode_request: OK
[   21.718273] Testing event btrfs_inode_evict: OK
[   21.736262] Testing event btrfs_get_extent: OK
[   21.753969] Testing event btrfs_ordered_extent_add: OK
[   21.771261] Testing event btrfs_ordered_extent_remove: OK
[   21.790296] Testing event btrfs_ordered_extent_start: OK
[   21.808301] Testing event btrfs_ordered_extent_put: OK
[   21.826978] Testing event btrfs_finish_ordered_io: OK
[   21.844275] Testing event __extent_writepage: OK
[   21.862175] Testing event btrfs_writepage_end_io_hook: OK
[   21.880237] Testing event btrfs_sync_file: OK
[   21.898019] Testing event btrfs_sync_fs: OK
[   21.915111] Testing event btrfs_delayed_tree_ref: OK
[   21.933271] Testing event btrfs_delayed_data_ref: OK
[   21.951219] Testing event btrfs_delayed_ref_head: OK
[   21.969202] Testing event btrfs_chunk_alloc: OK
[   21.987336] Testing event btrfs_chunk_free: OK
[   22.006236] Testing event btrfs_cow_block: OK
[   22.025313] Testing event btrfs_reserved_extent_alloc: OK
[   22.044043] Testing event btrfs_reserved_extent_free: OK
[   22.061275] Testing event xfs_attr_list_sf: OK
[   22.079208] Testing event xfs_attr_list_sf_all: OK
[   22.099327] Testing event xfs_attr_list_leaf: OK
[   22.117227] Testing event xfs_attr_list_leaf_end: OK
[   22.137283] Testing event xfs_attr_list_full: OK
[   22.156245] Testing event xfs_attr_list_add: OK
[   22.174203] Testing event xfs_attr_list_wrong_blk: OK
[   22.192336] Testing event xfs_attr_list_notfound: OK
[   22.210280] Testing event xfs_perag_get: OK
[   22.228300] Testing event xfs_perag_get_tag: OK
[   22.246419] Testing event xfs_perag_put: OK
[   22.264245] Testing event xfs_perag_set_reclaim: OK
[   22.282211] Testing event xfs_perag_clear_reclaim: OK
[   22.300225] Testing event xfs_attr_list_node_descend: OK
[   22.319335] Testing event xfs_iext_insert: OK
[   22.339257] Testing event xfs_iext_remove: OK
[   22.357144] Testing event xfs_bmap_pre_update: OK
[   22.374135] Testing event xfs_bmap_post_update: OK
[   22.391111] Testing event xfs_extlist: OK
[   22.408285] Testing event xfs_buf_init: OK
[   22.428323] Testing event xfs_buf_free: OK
[   22.447355] Testing event xfs_buf_hold: OK
[   22.465240] Testing event xfs_buf_rele: OK
[   22.483273] Testing event xfs_buf_iodone: OK
[   22.501165] Testing event xfs_buf_iorequest: OK
[   22.519294] Testing event xfs_buf_bawrite: OK
[   22.537356] Testing event xfs_buf_lock: OK
[   22.555162] Testing event xfs_buf_lock_done: OK
[   22.572131] Testing event xfs_buf_trylock: OK
[   22.590225] Testing event xfs_buf_unlock: OK
[   22.608168] Testing event xfs_buf_iowait: OK
[   22.625303] Testing event xfs_buf_iowait_done: OK
[   22.643280] Testing event xfs_buf_delwri_queue: OK
[   22.661287] Testing event xfs_buf_delwri_dequeue: OK
[   22.679135] Testing event xfs_buf_delwri_split: OK
[   22.696238] Testing event xfs_buf_get_uncached: OK
[   22.714100] Testing event xfs_bdstrat_shut: OK
[   22.731389] Testing event xfs_buf_item_relse: OK
[   22.749311] Testing event xfs_buf_item_iodone: OK
[   22.767314] Testing event xfs_buf_item_iodone_async: OK
[   22.785315] Testing event xfs_buf_error_relse: OK
[   22.803205] Testing event xfs_trans_read_buf_io: OK
[   22.821227] Testing event xfs_trans_read_buf_shut: OK
[   22.839300] Testing event xfs_btree_corrupt: OK
[   22.859352] Testing event xfs_da_btree_corrupt: OK
[   22.879348] Testing event xfs_reset_dqcounts: OK
[   22.897362] Testing event xfs_inode_item_push: OK
[   22.915332] Testing event xfs_buf_find: OK
[   22.933230] Testing event xfs_buf_get: OK
[   22.951273] Testing event xfs_buf_read: OK
[   22.970319] Testing event xfs_buf_ioerror: OK
[   22.988317] Testing event xfs_buf_item_size: OK
[   23.006361] Testing event xfs_buf_item_size_stale: OK
[   23.024309] Testing event xfs_buf_item_format: OK
[   23.042177] Testing event xfs_buf_item_format_stale: OK
[   23.060253] Testing event xfs_buf_item_pin: OK
[   23.078191] Testing event xfs_buf_item_unpin: OK
[   23.096311] Testing event xfs_buf_item_unpin_stale: OK
[   23.115359] Testing event xfs_buf_item_trylock: OK
[   23.135274] Testing event xfs_buf_item_unlock: OK
[   23.153303] Testing event xfs_buf_item_unlock_stale: OK
[   23.171307] Testing event xfs_buf_item_committed: OK
[   23.189262] Testing event xfs_buf_item_push: OK
[   23.207305] Testing event xfs_buf_item_pushbuf: OK
[   23.226380] Testing event xfs_trans_get_buf: OK
[   23.244315] Testing event xfs_trans_get_buf_recur: OK
[   23.264320] Testing event xfs_trans_getsb: OK
[   23.284307] Testing event xfs_trans_getsb_recur: OK
[   23.302274] Testing event xfs_trans_read_buf: OK
[   23.319230] Testing event xfs_trans_read_buf_recur: OK
[   23.336240] Testing event xfs_trans_log_buf: OK
[   23.354364] Testing event xfs_trans_brelse: OK
[   23.372259] Testing event xfs_trans_bjoin: OK
[   23.390355] Testing event xfs_trans_bhold: OK
[   23.408258] Testing event xfs_trans_bhold_release: OK
[   23.426344] Testing event xfs_trans_binval: OK
[   23.444355] Testing event xfs_ilock: OK
[   23.462254] Testing event xfs_ilock_nowait: OK
[   23.480338] Testing event xfs_ilock_demote: OK
[   23.498388] Testing event xfs_iunlock: OK
[   23.516379] Testing event xfs_iget_skip: OK
[   23.534371] Testing event xfs_iget_reclaim: OK
[   23.552278] Testing event xfs_iget_reclaim_fail: OK
[   23.570372] Testing event xfs_iget_hit: OK
[   23.588032] Testing event xfs_iget_miss: OK
[   23.607378] Testing event xfs_getattr: OK
[   23.627287] Testing event xfs_setattr: OK
[   23.645231] Testing event xfs_readlink: OK
[   23.662361] Testing event xfs_alloc_file_space: OK
[   23.680283] Testing event xfs_free_file_space: OK
[   23.698341] Testing event xfs_readdir: OK
[   23.716331] Testing event xfs_get_acl: OK
[   23.734253] Testing event xfs_vm_bmap: OK
[   23.751328] Testing event xfs_file_ioctl: OK
[   23.769293] Testing event xfs_file_compat_ioctl: OK
[   23.787179] Testing event xfs_ioctl_setattr: OK
[   23.805288] Testing event xfs_dir_fsync: OK
[   23.825336] Testing event xfs_file_fsync: OK
[   23.844154] Testing event xfs_destroy_inode: OK
[   23.862131] Testing event xfs_write_inode: OK
[   23.880371] Testing event xfs_evict_inode: OK
[   23.898243] Testing event xfs_dquot_dqalloc: OK
[   23.915254] Testing event xfs_dquot_dqdetach: OK
[   23.933334] Testing event xfs_ihold: OK
[   23.953369] Testing event xfs_irele: OK
[   23.973417] Testing event xfs_inode_pin: OK
[   23.991268] Testing event xfs_inode_unpin: OK
[   24.009343] Testing event xfs_inode_unpin_nowait: OK
[   24.029429] Testing event xfs_remove: OK
[   24.049339] Testing event xfs_link: OK
[   24.069339] Testing event xfs_lookup: OK
[   24.087082] Testing event xfs_create: OK
[   24.104428] Testing event xfs_symlink: OK
[   24.122393] Testing event xfs_rename: OK
[   24.140377] Testing event xfs_dqadjust: OK
[   24.158350] Testing event xfs_dqreclaim_want: OK
[   24.176214] Testing event xfs_dqreclaim_dirty: OK
[   24.194393] Testing event xfs_dqreclaim_unlink: OK
[   24.212367] Testing event xfs_dqattach_found: OK
[   24.230203] Testing event xfs_dqattach_get: OK
[   24.247362] Testing event xfs_dqinit: OK
[   24.265362] Testing event xfs_dqreuse: OK
[   24.283286] Testing event xfs_dqalloc: OK
[   24.303236] Testing event xfs_dqtobp_read: OK
[   24.321302] Testing event xfs_dqread: OK
[   24.339324] Testing event xfs_dqread_fail: OK
[   24.357060] Testing event xfs_dqlookup_found: OK
[   24.374081] Testing event xfs_dqlookup_want: OK
[   24.393407] Testing event xfs_dqlookup_freelist: OK
[   24.413355] Testing event xfs_dqlookup_done: OK
[   24.431382] Testing event xfs_dqget_hit: OK
[   24.449417] Testing event xfs_dqget_miss: OK
[   24.467365] Testing event xfs_dqput: OK
[   24.488366] Testing event xfs_dqput_wait: OK
[   24.506399] Testing event xfs_dqput_free: OK
[   24.524419] Testing event xfs_dqrele: OK
[   24.542133] Testing event xfs_dqflush: OK
[   24.561193] Testing event xfs_dqflush_force: OK
[   24.578134] Testing event xfs_dqflush_done: OK
[   24.595367] Testing event xfs_log_done_nonperm: OK
[   24.613392] Testing event xfs_log_done_perm: OK
[   24.631379] Testing event xfs_log_reserve: OK
[   24.649404] Testing event xfs_log_umount_write: OK
[   24.667355] Testing event xfs_log_grant_enter: OK
[   24.685055] Testing event xfs_log_grant_exit: OK
[   24.704465] Testing event xfs_log_grant_error: OK
[   24.723370] Testing event xfs_log_grant_sleep1: OK
[   24.742073] Testing event xfs_log_grant_wake1: OK
[   24.759170] Testing event xfs_log_grant_sleep2: OK
[   24.776046] Testing event xfs_log_grant_wake2: OK
[   24.793035] Testing event xfs_log_grant_wake_up: OK
[   24.810075] Testing event xfs_log_regrant_write_enter: OK
[   24.827083] Testing event xfs_log_regrant_write_exit: OK
[   24.844145] Testing event xfs_log_regrant_write_error: OK
[   24.861063] Testing event xfs_log_regrant_write_sleep1: OK
[   24.880421] Testing event xfs_log_regrant_write_wake1: OK
[   24.899391] Testing event xfs_log_regrant_write_sleep2: OK
[   24.917417] Testing event xfs_log_regrant_write_wake2: OK
[   24.936414] Testing event xfs_log_regrant_write_wake_up: OK
[   24.954370] Testing event xfs_log_regrant_reserve_enter: OK
[   24.972153] Testing event xfs_log_regrant_reserve_exit: OK
[   24.990382] Testing event xfs_log_regrant_reserve_sub: OK
[   25.009370] Testing event xfs_log_ungrant_enter: OK
[   25.027248] Testing event xfs_log_ungrant_exit: OK
[   25.045295] Testing event xfs_log_ungrant_sub: OK
[   25.062203] Testing event xfs_ail_push: OK
[   25.079415] Testing event xfs_ail_pushbuf: OK
[   25.097143] Testing event xfs_ail_pushbuf_pinned: OK
[   25.116406] Testing event xfs_ail_pinned: OK
[   25.136394] Testing event xfs_ail_locked: OK
[   25.155384] Testing event xfs_file_read: OK
[   25.174373] Testing event xfs_file_buffered_write: OK
[   25.192355] Testing event xfs_file_direct_write: OK
[   25.210418] Testing event xfs_file_splice_read: OK
[   25.228266] Testing event xfs_file_splice_write: OK
[   25.246339] Testing event xfs_writepage: OK
[   25.264212] Testing event xfs_releasepage: OK
[   25.281453] Testing event xfs_invalidatepage: OK
[   25.299404] Testing event xfs_map_blocks_found: OK
[   25.317332] Testing event xfs_map_blocks_alloc: OK
[   25.334436] Testing event xfs_get_blocks_found: OK
[   25.352446] Testing event xfs_get_blocks_alloc: OK
[   25.370437] Testing event xfs_delalloc_enospc: OK
[   25.389474] Testing event xfs_unwritten_convert: OK
[   25.407318] Testing event xfs_get_blocks_notfound: OK
[   25.425316] Testing event xfs_setfilesize: OK
[   25.443411] Testing event xfs_itruncate_data_start: OK
[   25.461340] Testing event xfs_itruncate_data_end: OK
[   25.481390] Testing event xfs_pagecache_inval: OK
[   25.500452] Testing event xfs_bunmap: OK
[   25.518392] Testing event xfs_alloc_busy: OK
[   25.536374] Testing event xfs_alloc_busy_enomem: OK
[   25.556342] Testing event xfs_alloc_busy_force: OK
[   25.575332] Testing event xfs_alloc_busy_reuse: OK
[   25.594069] Testing event xfs_alloc_busy_clear: OK
[   25.611275] Testing event xfs_alloc_busy_trim: OK
[   25.631106] Testing event xfs_trans_commit_lsn: OK
[   25.649151] Testing event xfs_agf: OK
[   25.667394] Testing event xfs_free_extent: OK
[   25.685393] Testing event xfs_alloc_exact_done: OK
[   25.703139] Testing event xfs_alloc_exact_notfound: OK
[   25.722204] Testing event xfs_alloc_exact_error: OK
[   25.739207] Testing event xfs_alloc_near_nominleft: OK
[   25.758433] Testing event xfs_alloc_near_first: OK
[   25.777429] Testing event xfs_alloc_near_greater: OK
[   25.798385] Testing event xfs_alloc_near_lesser: OK
[   25.817136] Testing event xfs_alloc_near_error: OK
[   25.834446] Testing event xfs_alloc_near_noentry: OK
[   25.852441] Testing event xfs_alloc_near_busy: OK
[   25.870460] Testing event xfs_alloc_size_neither: OK
[   25.888455] Testing event xfs_alloc_size_noentry: OK
[   25.906343] Testing event xfs_alloc_size_nominleft: OK
[   25.924117] Testing event xfs_alloc_size_done: OK
[   25.941464] Testing event xfs_alloc_size_error: OK
[   25.959392] Testing event xfs_alloc_size_busy: OK
[   25.978178] Testing event xfs_alloc_small_freelist: OK
[   25.995366] Testing event xfs_alloc_small_notenough: OK
[   26.013219] Testing event xfs_alloc_small_done: OK
[   26.030438] Testing event xfs_alloc_small_error: OK
[   26.048376] Testing event xfs_alloc_vextent_badargs: OK
[   26.066374] Testing event xfs_alloc_vextent_nofix: OK
[   26.085240] Testing event xfs_alloc_vextent_noagbp: OK
[   26.103361] Testing event xfs_alloc_vextent_loopfailed: OK
[   26.122413] Testing event xfs_alloc_vextent_allfailed: OK
[   26.142423] Testing event xfs_dir2_sf_addname: OK
[   26.160371] Testing event xfs_dir2_sf_create: OK
[   26.178480] Testing event xfs_dir2_sf_lookup: OK
[   26.196266] Testing event xfs_dir2_sf_replace: OK
[   26.213350] Testing event xfs_dir2_sf_removename: OK
[   26.231424] Testing event xfs_dir2_sf_toino4: OK
[   26.249428] Testing event xfs_dir2_sf_toino8: OK
[   26.267425] Testing event xfs_dir2_sf_to_block: OK
[   26.285389] Testing event xfs_dir2_block_addname: OK
[   26.303265] Testing event xfs_dir2_block_lookup: OK
[   26.320240] Testing event xfs_dir2_block_replace: OK
[   26.337284] Testing event xfs_dir2_block_removename: OK
[   26.354216] Testing event xfs_dir2_block_to_sf: OK
[   26.371223] Testing event xfs_dir2_block_to_leaf: OK
[   26.388409] Testing event xfs_dir2_leaf_addname: OK
[   26.406306] Testing event xfs_dir2_leaf_lookup: OK
[   26.426476] Testing event xfs_dir2_leaf_replace: OK
[   26.446446] Testing event xfs_dir2_leaf_removename: OK
[   26.465451] Testing event xfs_dir2_leaf_to_block: OK
[   26.484400] Testing event xfs_dir2_leaf_to_node: OK
[   26.502389] Testing event xfs_dir2_node_addname: OK
[   26.520498] Testing event xfs_dir2_node_lookup: OK
[   26.538479] Testing event xfs_dir2_node_replace: OK
[   26.556210] Testing event xfs_dir2_node_removename: OK
[   26.574483] Testing event xfs_dir2_node_to_leaf: OK
[   26.594229] Testing event xfs_dir2_leafn_add: OK
[   26.611437] Testing event xfs_dir2_leafn_remove: OK
[   26.629410] Testing event xfs_dir2_grow_inode: OK
[   26.647502] Testing event xfs_dir2_shrink_inode: OK
[   26.665539] Testing event xfs_dir2_leafn_moveents: OK
[   26.683119] Testing event xfs_swap_extent_before: OK
[   26.700213] Testing event xfs_swap_extent_after: OK
[   26.718469] Testing event xfs_log_recover_item_add: OK
[   26.738490] Testing event xfs_log_recover_item_add_cont: OK
[   26.758473] Testing event xfs_log_recover_item_reorder_head: OK
[   26.778411] Testing event xfs_log_recover_item_reorder_tail: OK
[   26.798212] Testing event xfs_log_recover_item_recover: OK
[   26.816401] Testing event xfs_log_recover_buf_not_cancel: OK
[   26.834499] Testing event xfs_log_recover_buf_cancel: OK
[   26.852124] Testing event xfs_log_recover_buf_cancel_add: OK
[   26.869218] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   26.888385] Testing event xfs_log_recover_buf_recover: OK
[   26.906424] Testing event xfs_log_recover_buf_inode_buf: OK
[   26.924414] Testing event xfs_log_recover_buf_reg_buf: OK
[   26.942219] Testing event xfs_log_recover_buf_dquot_buf: OK
[   26.960377] Testing event xfs_log_recover_inode_recover: OK
[   26.979448] Testing event xfs_log_recover_inode_cancel: OK
[   26.997417] Testing event xfs_log_recover_inode_skip: OK
[   27.015426] Testing event xfs_discard_extent: OK
[   27.033494] Testing event xfs_discard_toosmall: OK
[   27.051507] Testing event xfs_discard_exclude: OK
[   27.069127] Testing event xfs_discard_busy: OK
[   27.086162] Testing event jbd2_checkpoint: OK
[   27.103227] Testing event jbd2_start_commit: OK
[   27.121458] Testing event jbd2_commit_locking: OK
[   27.141414] Testing event jbd2_commit_flushing: OK
[   27.159484] Testing event jbd2_commit_logging: OK
[   27.177454] Testing event jbd2_end_commit: OK
[   27.195116] Testing event jbd2_submit_inode_data: OK
[   27.212185] Testing event jbd2_run_stats: OK
[   27.229234] Testing event jbd2_checkpoint_stats: OK
[   27.248459] Testing event jbd2_cleanup_journal_tail: OK
[   27.266496] Testing event jbd_checkpoint: OK
[   27.284338] Testing event jbd_start_commit: OK
[   27.302390] Testing event jbd_commit_locking: OK
[   27.320143] Testing event jbd_commit_flushing: OK
[   27.337166] Testing event jbd_commit_logging: OK
[   27.354168] Testing event jbd_drop_transaction: OK
[   27.371170] Testing event jbd_end_commit: OK
[   27.388238] Testing event jbd_do_submit_data: OK
[   27.407495] Testing event jbd_cleanup_journal_tail: OK
[   27.427485] Testing event jbd_update_superblock_end: OK
[   27.446180] Testing event ext4_free_inode: OK
[   27.465518] Testing event ext4_request_inode: OK
[   27.484510] Testing event ext4_allocate_inode: OK
[   27.502494] Testing event ext4_evict_inode: OK
[   27.520421] Testing event ext4_drop_inode: OK
[   27.538181] Testing event ext4_mark_inode_dirty: OK
[   27.557414] Testing event ext4_begin_ordered_truncate: OK
[   27.576400] Testing event ext4_write_begin: OK
[   27.594238] Testing event ext4_da_write_begin: OK
[   27.611184] Testing event ext4_ordered_write_end: OK
[   27.628117] Testing event ext4_writeback_write_end: OK
[   27.645180] Testing event ext4_journalled_write_end: OK
[   27.662185] Testing event ext4_da_write_end: OK
[   27.679181] Testing event ext4_da_writepages: OK
[   27.696324] Testing event ext4_da_write_pages: OK
[   27.713354] Testing event ext4_da_writepages_result: OK
[   27.731305] Testing event ext4_writepage: OK
[   27.751325] Testing event ext4_readpage: OK
[   27.768121] Testing event ext4_releasepage: OK
[   27.785428] Testing event ext4_invalidatepage: OK
[   27.803297] Testing event ext4_discard_blocks: OK
[   27.820186] Testing event ext4_mb_new_inode_pa: OK
[   27.837201] Testing event ext4_mb_new_group_pa: OK
[   27.856162] Testing event ext4_mb_release_inode_pa: OK
[   27.875212] Testing event ext4_mb_release_group_pa: OK
[   27.892508] Testing event ext4_discard_preallocations: OK
[   27.910190] Testing event ext4_mb_discard_preallocations: OK
[   27.927197] Testing event ext4_request_blocks: OK
[   27.944189] Testing event ext4_allocate_blocks: OK
[   27.961336] Testing event ext4_free_blocks: OK
[   27.978329] Testing event ext4_sync_file_enter: OK
[   27.995531] Testing event ext4_sync_file_exit: OK
[   28.013251] Testing event ext4_sync_fs: OK
[   28.030248] Testing event ext4_alloc_da_blocks: OK
[   28.047289] Testing event ext4_mballoc_alloc: OK
[   28.064256] Testing event ext4_mballoc_prealloc: OK
[   28.081253] Testing event ext4_mballoc_discard: OK
[   28.098448] Testing event ext4_mballoc_free: OK
[   28.116215] Testing event ext4_forget: OK
[   28.133259] Testing event ext4_da_update_reserve_space: OK
[   28.150216] Testing event ext4_da_reserve_space: OK
[   28.167204] Testing event ext4_da_release_space: OK
[   28.184204] Testing event ext4_mb_bitmap_load: OK
[   28.201557] Testing event ext4_mb_buddy_bitmap_load: OK
[   28.220294] Testing event ext4_read_block_bitmap_load: OK
[   28.237272] Testing event ext4_load_inode_bitmap: OK
[   28.254164] Testing event ext4_direct_IO_enter: OK
[   28.273205] Testing event ext4_direct_IO_exit: OK
[   28.292301] Testing event ext4_fallocate_enter: OK
[   28.309269] Testing event ext4_fallocate_exit: OK
[   28.329260] Testing event ext4_unlink_enter: OK
[   28.346519] Testing event ext4_unlink_exit: OK
[   28.364426] Testing event ext4_truncate_enter: OK
[   28.382270] Testing event ext4_truncate_exit: OK
[   28.399206] Testing event ext4_ext_convert_to_initialized_enter: OK
[   28.416278] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   28.433487] Testing event ext4_ext_map_blocks_enter: OK
[   28.451548] Testing event ext4_ind_map_blocks_enter: OK
[   28.471232] Testing event ext4_ext_map_blocks_exit: OK
[   28.488253] Testing event ext4_ind_map_blocks_exit: OK
[   28.505519] Testing event ext4_ext_load_extent: OK
[   28.523563] Testing event ext4_load_inode: OK
[   28.541317] Testing event ext4_journal_start: OK
[   28.558513] Testing event ext4_trim_extent: OK
[   28.576294] Testing event ext4_trim_all_free: OK
[   28.595484] Testing event ext4_ext_handle_uninitialized_extents: OK
[   28.616276] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   28.633310] Testing event ext4_ext_put_in_cache: OK
[   28.650465] Testing event ext4_ext_in_cache: OK
[   28.668524] Testing event ext4_find_delalloc_range: OK
[   28.686276] Testing event ext4_get_reserved_cluster_alloc: OK
[   28.703202] Testing event ext4_ext_show_extent: OK
[   28.720307] Testing event ext4_remove_blocks: OK
[   28.737414] Testing event ext4_ext_rm_leaf: OK
[   28.754204] Testing event ext4_ext_rm_idx: OK
[   28.771500] Testing event ext4_ext_remove_space: OK
[   28.789565] Testing event ext4_ext_remove_space_done: OK
[   28.808243] Testing event ext3_free_inode: OK
[   28.825496] Testing event ext3_request_inode: OK
[   28.843546] Testing event ext3_allocate_inode: OK
[   28.861222] Testing event ext3_evict_inode: OK
[   28.878247] Testing event ext3_drop_inode: OK
[   28.897509] Testing event ext3_mark_inode_dirty: OK
[   28.916264] Testing event ext3_write_begin: OK
[   28.933534] Testing event ext3_ordered_write_end: OK
[   28.951291] Testing event ext3_writeback_write_end: OK
[   28.968487] Testing event ext3_journalled_write_end: OK
[   28.987254] Testing event ext3_ordered_writepage: OK
[   29.004543] Testing event ext3_writeback_writepage: OK
[   29.022544] Testing event ext3_journalled_writepage: OK
[   29.040285] Testing event ext3_readpage: OK
[   29.057583] Testing event ext3_releasepage: OK
[   29.075550] Testing event ext3_invalidatepage: OK
[   29.093383] Testing event ext3_discard_blocks: OK
[   29.111247] Testing event ext3_request_blocks: OK
[   29.128232] Testing event ext3_allocate_blocks: OK
[   29.145510] Testing event ext3_free_blocks: OK
[   29.163509] Testing event ext3_sync_file_enter: OK
[   29.182603] Testing event ext3_sync_file_exit: OK
[   29.200281] Testing event ext3_sync_fs: OK
[   29.217480] Testing event ext3_rsv_window_add: OK
[   29.235268] Testing event ext3_discard_reservation: OK
[   29.254553] Testing event ext3_alloc_new_reservation: OK
[   29.273522] Testing event ext3_reserved: OK
[   29.291223] Testing event ext3_forget: OK
[   29.308430] Testing event ext3_read_block_bitmap: OK
[   29.326355] Testing event ext3_direct_IO_enter: OK
[   29.343604] Testing event ext3_direct_IO_exit: OK
[   29.361261] Testing event ext3_unlink_enter: OK
[   29.378500] Testing event ext3_unlink_exit: OK
[   29.396540] Testing event ext3_truncate_enter: OK
[   29.414569] Testing event ext3_truncate_exit: OK
[   29.432562] Testing event ext3_get_blocks_enter: OK
[   29.450447] Testing event ext3_get_blocks_exit: OK
[   29.468544] Testing event ext3_load_inode: OK
[   29.486468] Testing event writeback_nothread: OK
[   29.506248] Testing event writeback_queue: OK
[   29.525509] Testing event writeback_exec: OK
[   29.543244] Testing event writeback_start: OK
[   29.560313] Testing event writeback_written: OK
[   29.578266] Testing event writeback_wait: OK
[   29.597497] Testing event writeback_pages_written: OK
[   29.615311] Testing event writeback_nowork: OK
[   29.632548] Testing event writeback_wake_background: OK
[   29.650326] Testing event writeback_wake_thread: OK
[   29.668266] Testing event writeback_wake_forker_thread: OK
[   29.685247] Testing event writeback_bdi_register: OK
[   29.702577] Testing event writeback_bdi_unregister: OK
[   29.720640] Testing event writeback_thread_start: OK
[   29.738656] Testing event writeback_thread_stop: OK
[   29.756233] Testing event wbc_writepage: OK
[   29.775541] Testing event writeback_queue_io: OK
[   29.795549] Testing event task_io: OK
[   29.813316] Testing event global_dirty_state: OK
[   29.830251] Testing event bdi_dirty_state: OK
[   29.847602] Testing event blkcg_dirty_ratelimit: OK
[   29.865628] Testing event bdi_dirty_ratelimit: OK
[   29.883262] Testing event balance_dirty_pages: OK
[   29.900274] Testing event writeback_congestion_wait: OK
[   29.917327] Testing event writeback_wait_iff_congested: OK
[   29.934260] Testing event writeback_single_inode_requeue: OK
[   29.951330] Testing event writeback_single_inode: OK
[   29.970351] Testing event kmalloc: OK
[   29.989562] Testing event kmem_cache_alloc: OK
[   30.009493] Testing event kmalloc_node: OK
[   30.028543] Testing event kmem_cache_alloc_node: OK
[   30.046543] Testing event kfree: OK
[   30.063424] Testing event kmem_cache_free: OK
[   30.080516] Testing event mm_page_free_direct: OK
[   30.098565] Testing event mm_pagevec_free: OK
[   30.116411] Testing event mm_page_alloc: OK
[   30.133609] Testing event mm_page_alloc_zone_locked: OK
[   30.152603] Testing event mm_page_pcpu_drain: OK
[   30.170421] Testing event mm_page_alloc_extfrag: OK
[   30.188497] Testing event mm_vmscan_kswapd_sleep: OK
[   30.206398] Testing event mm_vmscan_kswapd_wake: OK
[   30.223351] Testing event mm_vmscan_wakeup_kswapd: OK
[   30.240306] Testing event mm_vmscan_direct_reclaim_begin: OK
[   30.257297] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   30.274295] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   30.291294] Testing event mm_vmscan_direct_reclaim_end: OK
[   30.308299] Testing event mm_vmscan_memcg_reclaim_end: OK
[   30.325294] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   30.342294] Testing event mm_shrink_slab_start: OK
[   30.359258] Testing event mm_shrink_slab_end: OK
[   30.376338] Testing event mm_vmscan_lru_isolate: OK
[   30.394570] Testing event mm_vmscan_memcg_isolate: OK
[   30.414552] Testing event mm_vmscan_writepage: OK
[   30.432354] Testing event mm_vmscan_lru_shrink_inactive: OK
[   30.449577] Testing event replace_swap_token: OK
[   30.467617] Testing event put_swap_token: OK
[   30.485588] Testing event disable_swap_token: OK
[   30.503639] Testing event update_swap_token_priority: OK
[   30.521495] Testing event cpu_idle: OK
[   30.538611] Testing event cpu_frequency: OK
[   30.556291] Testing event machine_suspend: OK
[   30.573308] Testing event power_start: OK
[   30.590326] Testing event power_frequency: OK
[   30.607284] Testing event power_end: OK
[   30.624351] Testing event clock_enable: OK
[   30.643593] Testing event clock_disable: OK
[   30.663416] Testing event clock_set_rate: OK
[   30.681419] Testing event power_domain_target: OK
[   30.699507] Testing event ftrace_test_filter: OK
[   30.716565] Testing event module_load: OK
[   30.734537] Testing event module_free: OK
[   30.752299] Testing event module_get: OK
[   30.771454] Testing event module_put: OK
[   30.789597] Testing event module_request: OK
[   30.807594] Testing event lock_acquire: OK
[   30.825622] Testing event lock_release: OK
[   30.843554] Testing event lock_contended: OK
[   30.861514] Testing event lock_acquired: OK
[   30.878444] Testing event rcu_utilization: OK
[   30.895581] Testing event rcu_grace_period: OK
[   30.913295] Testing event rcu_grace_period_init: OK
[   30.930311] Testing event rcu_preempt_task: OK
[   30.950579] Testing event rcu_unlock_preempted_task: OK
[   30.968579] Testing event rcu_quiescent_state_report: OK
[   30.986326] Testing event rcu_fqs: OK
[   31.005610] Testing event rcu_dyntick: OK
[   31.023577] Testing event rcu_callback: OK
[   31.041649] Testing event rcu_kfree_callback: OK
[   31.059549] Testing event rcu_batch_start: OK
[   31.077653] Testing event rcu_invoke_callback: OK
[   31.095632] Testing event rcu_invoke_kfree_callback: OK
[   31.113620] Testing event rcu_batch_end: OK
[   31.131558] Testing event workqueue_queue_work: OK
[   31.149614] Testing event workqueue_activate_work: OK
[   31.167662] Testing event workqueue_execute_start: OK
[   31.185408] Testing event workqueue_execute_end: OK
[   31.202555] Testing event signal_generate: OK
[   31.220649] Testing event signal_deliver: OK
[   31.238612] Testing event signal_overflow_fail: OK
[   31.256569] Testing event signal_lose_info: OK
[   31.276633] Testing event timer_init: OK
[   31.294599] Testing event timer_start: OK
[   31.312417] Testing event timer_expire_entry: OK
[   31.330409] Testing event timer_expire_exit: OK
[   31.349573] Testing event timer_cancel: OK
[   31.367523] Testing event hrtimer_init: OK
[   31.384278] Testing event hrtimer_start: OK
[   31.401634] Testing event hrtimer_expire_entry: OK
[   31.419586] Testing event hrtimer_expire_exit: OK
[   31.437612] Testing event hrtimer_cancel: OK
[   31.455390] Testing event itimer_state: OK
[   31.472618] Testing event itimer_expire: OK
[   31.490412] Testing event irq_handler_entry: OK
[   31.507622] Testing event irq_handler_exit: OK
[   31.525629] Testing event softirq_entry: OK
[   31.543417] Testing event softirq_exit: OK
[   31.560646] Testing event softirq_raise: OK
[   31.578628] Testing event sched_kthread_stop: OK
[   31.596573] Testing event sched_kthread_stop_ret: OK
[   31.614574] Testing event sched_wakeup: OK
[   31.632607] Testing event sched_wakeup_new: OK
[   31.650549] Testing event sched_switch: OK
[   31.668339] Testing event sched_migrate_task: OK
[   31.686681] Testing event sched_process_free: OK
[   31.706565] Testing event sched_process_exit: OK
[   31.724520] Testing event sched_wait_task: OK
[   31.741699] Testing event sched_process_wait: OK
[   31.759616] Testing event sched_process_fork: OK
[   31.777644] Testing event sched_stat_wait: OK
[   31.795683] Testing event sched_stat_sleep: OK
[   31.813544] Testing event sched_stat_iowait: OK
[   31.831637] Testing event sched_stat_runtime: OK
[   31.849354] Testing event sched_pi_setprio: OK
[   31.868496] Testing event mce_record: OK
[   31.886692] Testing event sys_enter: OK
[   31.904634] Testing event sys_exit: OK
[   31.922686] Testing event emulate_vsyscall: OK
[   31.940633] Testing event kvm_mmu_pagetable_walk: OK
[   31.958669] Testing event kvm_mmu_paging_element: OK
[   31.976658] Testing event kvm_mmu_set_accessed_bit: OK
[   31.994470] Testing event kvm_mmu_set_dirty_bit: OK
[   32.011560] Testing event kvm_mmu_walker_error: OK
[   32.029623] Testing event kvm_mmu_get_page: OK
[   32.047588] Testing event kvm_mmu_sync_page: OK
[   32.067589] Testing event kvm_mmu_unsync_page: OK
[   32.087554] Testing event kvm_mmu_prepare_zap_page: OK
[   32.105438] Testing event kvm_mmu_delay_free_pages: OK
[   32.122663] Testing event mark_mmio_spte: OK
[   32.140637] Testing event handle_mmio_page_fault: OK
[   32.158675] Testing event kvm_mmu_audit: OK
[   32.176699] Testing event kvm_entry: OK
[   32.194456] Testing event kvm_hypercall: OK
[   32.212373] Testing event kvm_hv_hypercall: OK
[   32.229649] Testing event kvm_pio: OK
[   32.247650] Testing event kvm_cpuid: OK
[   32.265618] Testing event kvm_apic: OK
[   32.283647] Testing event kvm_exit: OK
[   32.301568] Testing event kvm_inj_virq: OK
[   32.321577] Testing event kvm_inj_exception: OK
[   32.341641] Testing event kvm_page_fault: OK
[   32.360563] Testing event kvm_msr: OK
[   32.377548] Testing event kvm_cr: OK
[   32.394561] Testing event kvm_pic_set_irq: OK
[   32.413584] Testing event kvm_apic_ipi: OK
[   32.431661] Testing event kvm_apic_accept_irq: OK
[   32.449648] Testing event kvm_nested_vmrun: OK
[   32.467702] Testing event kvm_nested_intercepts: OK
[   32.485642] Testing event kvm_nested_vmexit: OK
[   32.503621] Testing event kvm_nested_vmexit_inject: OK
[   32.523685] Testing event kvm_nested_intr_vmexit: OK
[   32.543591] Testing event kvm_invlpga: OK
[   32.561427] Testing event kvm_skinit: OK
[   32.578427] Testing event kvm_emulate_insn: OK
[   32.595675] Testing event vcpu_match_mmio: OK
[   32.613569] Testing event kvm_userspace_exit: OK
[   32.631668] Testing event kvm_set_irq: OK
[   32.649651] Testing event kvm_ioapic_set_irq: OK
[   32.669670] Testing event kvm_msi_set_irq: OK
[   32.689514] Testing event kvm_ack_irq: OK
[   32.706471] Testing event kvm_mmio: OK
[   32.723670] Testing event kvm_fpu: OK
[   32.741662] Testing event kvm_age_page: OK
[   32.759610] Testing event kvm_try_async_get_page: OK
[   32.777749] Testing event kvm_async_pf_doublefault: OK
[   32.795741] Testing event kvm_async_pf_not_present: OK
[   32.813657] Testing event kvm_async_pf_ready: OK
[   32.831651] Testing event kvm_async_pf_completed: OK
[   32.851704] Running tests on trace event systems:
[   32.852097] Testing event system skb: OK
[   32.871859] Testing event system net: OK
[   32.889972] Testing event system napi: OK
[   32.907721] Testing event system sock: OK
[   32.925780] Testing event system udp: OK
[   32.944678] Testing event system hda: OK
[   32.963249] Testing event system scsi: OK
[   32.982025] Testing event system i915: OK
[   33.005339] Testing event system drm: OK
[   33.023806] Testing event system block: OK
[   33.045583] Testing event system btrfs: OK
[   33.068250] Testing event system xfs: OK
[   33.163657] Testing event system jbd2: OK
[   33.183685] Testing event system jbd: OK
[   33.204832] Testing event system ext4: OK
[   33.241333] Testing event system ext3: OK
[   33.269113] Testing event system writeback: OK
[   33.292729] Testing event system kmem: OK
[   33.313076] Testing event system vmscan: OK
[   33.334806] Testing event system power: OK
[   33.354839] Testing event system test: OK
[   33.372680] Testing event system module: OK
[   33.391189] Testing event system lock: OK
[   33.409055] Testing event system rcu: OK
[   33.430234] Testing event system workqueue: OK
[   33.449089] Testing event system signal: OK
[   33.467019] Testing event system timer: OK
[   33.489000] Testing event system irq: OK
[   33.509153] Testing event system sched: OK
[   33.530487] Testing event system mce: OK
[   33.547631] Testing event system raw_syscalls: OK
[   33.565823] Testing event system vsyscall: OK
[   33.583659] Testing event system syscalls: OK
[   33.603424] Testing event system kvmmmu: OK
[   33.623896] Testing event system kvm: OK
[   33.650007] Running tests on all trace events:
[   33.650380] Testing all events: OK
[   33.918505] Testing ftrace filter: OK
[   33.919289] Testing kprobe tracing: OK
[   33.955686]   Magic number: 3:763:50
[   33.956079] netconsole: local port 6665
[   33.956371] netconsole: local IP 10.0.0.0
[   33.956674] netconsole: interface 'eth0'
[   33.956969] netconsole: remote port 6666
[   33.957264] netconsole: remote IP 192.168.1.1
[   33.957578] netconsole: remote ethernet address 00:30:48:fe:19:95
[   33.957955] netconsole: device eth0 not up yet, forcing it
[   34.047113] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   34.097755] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   34.098394] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   37.001575] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   37.002384] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   37.007584] console [netcon0] enabled
[   37.007879] netconsole: network logging started
[   37.008510] rtc_cmos 00:02: setting system clock to 2011-11-03 00:03:57 UTC (1320278637)
[   37.023866] IP-Config: Complete:
[   37.024157]      device=eth0, addr=192.168.1.52, mask=255.255.255.0, gw=192.168.1.1,
[   37.024769]      host=fat, domain=, nis-domain=(none),
[   37.025172]      bootserver=192.168.1.11, rootserver=192.168.1.11, rootpath=
[   37.026254] md: Waiting for all devices to be available before autodetect
[   37.026681] md: If you don't use raid, use raid=noautodetect
[   37.027547] md: Autodetecting RAID arrays.
[   37.027860] md: Scanned 0 and added 0 devices.
[   37.028177] md: autorun ...
[   37.028432] md: ... autorun DONE.
[   38.037198] VFS: Mounted root (nfs filesystem) on device 0:16.
[   38.037628] debug: unmapping init memory ffffffff81f41000..ffffffff821f5000
[   38.151309] stty used greatest stack depth: 4616 bytes left
[   38.168926] startpar used greatest stack depth: 3752 bytes left
[   38.194023] sed used greatest stack depth: 3672 bytes left
[   38.232278] S02hostname.sh used greatest stack depth: 3640 bytes left
[   38.254122] mountpoint used greatest stack depth: 3544 bytes left
[   39.764190] S04ssh used greatest stack depth: 3496 bytes left
[   40.264904] EXT4-fs (sda5): recovery complete
[   40.265314] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   41.162803] grep used greatest stack depth: 3320 bytes left
[   41.269174] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   41.269786] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   41.271948] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   41.272532] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   41.413011] rc used greatest stack depth: 3288 bytes left
[   41.886879] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   41.888165] NFSD: starting 90-second grace period
[   43.216783] mount.nfs used greatest stack depth: 2632 bytes left
[   47.113070] eth0: no IPv6 routers present
[   78.318159] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.1.0 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
# CONFIG_CGROUP_TASK_COUNTER is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_CMPXCHG_DOUBLE=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_H323=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
# CONFIG_NF_CONNTRACK_SNMP is not set
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_TPROXY=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
CONFIG_NETFILTER_XT_TARGET_CT=y
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_HL=y
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
CONFIG_NETFILTER_XT_TARGET_LED=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TEE=y
CONFIG_NETFILTER_XT_TARGET_TPROXY=y
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_OSF=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_SOCKET=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_IP_NF_TARGET_NETMAP=y
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_NF_NAT_PROTO_DCCP=y
CONFIG_NF_NAT_PROTO_GRE=y
CONFIG_NF_NAT_PROTO_UDPLITE=y
CONFIG_NF_NAT_PROTO_SCTP=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
CONFIG_NF_NAT_TFTP=y
CONFIG_NF_NAT_AMANDA=y
CONFIG_NF_NAT_PPTP=y
CONFIG_NF_NAT_H323=y
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_CLUSTERIP=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=y
# CONFIG_BRIDGE_EBT_IP6 is not set
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set

#
# Classification
#
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_HAVE_BPF_JIT=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=128
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_MVSAS_TASKLET is not set
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PLATFORM=y
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MULTICORE_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=y
# CONFIG_MACVLAN is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_DCA=y
CONFIG_IGBVF=y
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_DCA=y
# CONFIG_IXGBEVF is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_ZNET is not set
CONFIG_IP1000=y
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_SEEQ8005 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
CONFIG_SIS190=y
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
CONFIG_VIA_VELOCITY=y
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_TR is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
# CONFIG_PINCTRL is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_CORE is not set
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=1024
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_ENABLE_REALTEK_QUIRKS=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_WMI=y
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WMI=y
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_MXM_WMI is not set
# CONFIG_SAMSUNG_Q10 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_HYPERV is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_EFI_VARS is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_SIGMA is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG2=y
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_ACL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set

--gBBFr7Ir9EOA20Yy--

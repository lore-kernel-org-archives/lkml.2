Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2KIEXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 23:23:41 -0500
Received: from mga14.intel.com ([143.182.124.37]:15841 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab2KIEXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 23:23:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,743,1344236400"; 
   d="3'?scan'208";a="215337188"
Date: Fri, 9 Nov 2012 12:23:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at kernel/rcutree.c:1562 rcu_do_batch()
Message-ID: <20121109042330.GA16556@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Paul,

I got the below warning in stable kernel 3.6.3. linux-next does
not have this issue. Bisect shows that the first bad commit is

commit b1420f1c8bfc30ecf6380a31d0f686884834b599
Author: Paul E. McKenney <paul.mckenney@linaro.org>
Date:   Thu Mar 1 13:18:08 2012 -0800

    rcu: Make rcu_barrier() less disruptive


[   92.252733] do_IRQ: 1.59 No irq handler for vector (irq -1)
[   92.253257] ------------[ cut here ]------------
[   92.253675] WARNING: at /c/kernel-tests/src/stable/kernel/rcutree.c:1562 rcu_do_batch+0x17e/0x63b()
[   92.254474] Hardware name: Bochs
[   92.254766] Modules linked in:
[   92.256689] Pid: 9, comm: migration/1 Not tainted 3.6.3 #1306
[   92.256689] Call Trace:
[   92.256689]  <IRQ>  [<ffffffff81033dbd>] warn_slowpath_common+0x83/0x9c
[   92.256689]  [<ffffffff81033df0>] warn_slowpath_null+0x1a/0x1c
[   92.256689]  [<ffffffff810a70fd>] rcu_do_batch+0x17e/0x63b
[   92.256689]  [<ffffffff810a6705>] ? rcu_report_qs_rnp+0x28b/0x2d5
[   92.256689]  [<ffffffff810a769d>] ? rcu_process_callbacks+0xe3/0x236
[   92.256689]  [<ffffffff810a772c>] rcu_process_callbacks+0x172/0x236
[   92.256689]  [<ffffffff8103b6cc>] __do_softirq+0xf6/0x231
[   92.256689]  [<ffffffff8107fe2c>] ? tick_program_event+0x24/0x26
[   92.256689]  [<ffffffff817d23bc>] call_softirq+0x1c/0x30
[   92.256689]  [<ffffffff81003f7c>] do_softirq+0x4a/0xa6
[   92.256689]  [<ffffffff8103ba98>] irq_exit+0x51/0xbc
[   92.256689]  [<ffffffff817d2a2f>] smp_apic_timer_interrupt+0x8b/0x99
[   92.256689]  [<ffffffff817d1c2f>] apic_timer_interrupt+0x6f/0x80
[   92.256689]  <EOI>  [<ffffffff81067440>] ? local_clock+0x1d/0x5a
[   92.256689]  [<ffffffff8109ea37>] ? stop_machine_cpu_stop+0x104/0x119
[   92.256689]  [<ffffffff8109e6d5>] cpu_stopper_thread+0xdd/0x17d
[   92.256689]  [<ffffffff8109e933>] ? queue_stop_cpus_work+0x130/0x130
[   92.256689]  [<ffffffff817ca044>] ? _raw_spin_unlock_irqrestore+0x47/0x65
[   92.256689]  [<ffffffff81086613>] ? trace_hardirqs_on_caller+0x125/0x181
[   92.256689]  [<ffffffff8108667c>] ? trace_hardirqs_on+0xd/0xf
[   92.256689]  [<ffffffff8109e5f8>] ? cpu_stop_signal_done+0x2c/0x2c
[   92.256689]  [<ffffffff81055e74>] kthread+0x9a/0xa2
[   92.256689]  [<ffffffff817d22c4>] kernel_thread_helper+0x4/0x10
[   92.256689]  [<ffffffff817ca4b0>] ? retint_restore_args+0x13/0x13
[   92.256689]  [<ffffffff81055dda>] ? __init_kthread_worker+0x5a/0x5a
[   92.317029]  [<ffffffff817d22c0>] ? gs_change+0x13/0x13

Thanks,
Fengguang

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-fat-3599-2012-10-22-01-01-57-3.6.3-1306"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.3 (kbuild@bee) (gcc version 4.7.1 (Debian 4.7.1-6) ) #1306 SMP Mon Oct 22 00:52:40 CST 2012
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=stable/linux-3.6.y log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=vmlinuz-2012-10-22-00-52-52-stable:linux-3.6.y:9f2a940-9f2a940-x86_64-lkp-8-fat BOOT_IMAGE=kernel-tests/kernels/x86_64-lkp/9f2a940/vmlinuz-3.6.3
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x1fffdfff]
[    0.000000]  [mem 0x00000000-0x1fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x1fffdfff @ [mem 0x1fefc000-0x1fffdfff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127932(97%)
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e600000-ffff88001edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130945
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3901 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 124990 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88001f200000 s1917056 r8192 d24448 u2097152
[    0.000000] pcpu-alloc: s1917056 r8192 d24448 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1f20d140
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128891
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=stable/linux-3.6.y log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=vmlinuz-2012-10-22-00-52-52-stable:linux-3.6.y:9f2a940-9f2a940-x86_64-lkp-8-fat BOOT_IMAGE=kernel-tests/kernels/x86_64-lkp/9f2a940/vmlinuz-3.6.3
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 474836k/524280k available (8020k kernel code, 500k absent, 48944k reserved, 5101k data, 2724k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3200.020 MHz processor
[    0.024004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6400.04 BogoMIPS (lpj=12800080)
[    0.028745] pid_max: default: 32768 minimum: 301
[    0.032316] Mount-cache hash table entries: 256
[    0.038033] mce: CPU supports 10 MCE banks
[    0.038952] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.038952] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.038952] tlb_flushall_shift is 0x6
[    0.044463] ACPI: Core revision 20120711
[    0.088735] ftrace: allocating 31348 entries in 123 pages
[    0.100300] Getting VERSION: 50014
[    0.101097] Getting VERSION: 50014
[    0.104016] Getting ID: 0
[    0.104746] Getting ID: ff000000
[    0.108015] Getting LVT0: 8700
[    0.108767] Getting LVT1: 8400
[    0.109553] enabled ExtINT on CPU#0
[    0.110998] ENABLING IO-APIC IRQs
[    0.112015] init IO_APIC IRQs
[    0.116012]  apic 2 pin 0 not connected
[    0.116867] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.118512] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.120032] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.121680] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.123337] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.124030] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.125662] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.128036] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.132030] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.133664] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.136037] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.140031] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.144034] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.148031] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.149694] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.152027]  apic 2 pin 16 not connected
[    0.156013]  apic 2 pin 17 not connected
[    0.156847]  apic 2 pin 18 not connected
[    0.157678]  apic 2 pin 19 not connected
[    0.158504]  apic 2 pin 20 not connected
[    0.159338]  apic 2 pin 21 not connected
[    0.160014]  apic 2 pin 22 not connected
[    0.164014]  apic 2 pin 23 not connected
[    0.164986] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.168014] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.169588] Using local APIC timer interrupts.
[    0.169588] calibrating APIC timer ...
[    0.176011] ... lapic delta = 11896979
[    0.176011] ... PM-Timer delta = 681367
[    0.176011] APIC calibration not consistent with PM-Timer: 190ms instead of 100ms
[    0.176011] APIC delta adjusted to PM-Timer: 6250040 (11896979)
[    0.176011] TSC delta adjusted to PM-Timer: 320010188 (609140790)
[    0.176011] ..... delta 6250040
[    0.176011] ..... mult: 268420397
[    0.176011] ..... calibration result: 4000025
[    0.176011] ..... CPU clock speed is 3200.0407 MHz.
[    0.176011] ..... host bus clock speed is 1000.0025 MHz.
[    0.176061] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.185598] SMP alternatives: lockdep: fixing up alternatives
[    0.186908] smpboot: Booting Node   0, Processors  #1 OK
[    0.028001] masked ExtINT on CPU#1
[    0.028001] calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
[    0.028001] Probably due to long platform interrupts. Consider using "lpj=" boot option.
[    0.396062] Brought up 2 CPUs
[    0.396815] ----------------
[    0.397532] | NMI testsuite:
[    0.396061] KVM setup async PF for cpu 1
[    0.396061] kvm-stealtime: cpu 1, msr 1f40d140
[    0.400028] --------------------
[    0.404028]   remote IPI:  ok  |
[    0.420628]    local IPI:  ok  |
[    0.444040] --------------------
[    0.444806] Good, all   2 testcases passed! |
[    0.445674] ---------------------------------
[    0.446570] smpboot: Total of 2 processors activated (9795.62 BogoMIPS)
[    0.460152] CPU0 attaching sched-domain:
[    0.464035]  domain 0: span 0-1 level CPU
[    0.464937]   groups: 0 1
[    0.468644] CPU1 attaching sched-domain:
[    0.469467]  domain 0: span 0-1 level CPU
[    0.472648]   groups: 1 0
[    0.484431] xor: automatically using best checksumming function:
[    0.528044]    generic_sse:   260.000 MB/sec
[    0.528919] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.540280] khelper (16) used greatest stack depth: 5224 bytes left
[    0.541396] NET: Registered protocol family 16
[    0.548247] kworker/u:1 (21) used greatest stack depth: 4824 bytes left
[    0.560117] ACPI: bus type pci registered
[    0.572427] PCI: Using configuration type 1 for base access
[    0.892360] bio: create slab <bio-0> at 0
[    0.960073] raid6: sse2x1    4431 MB/s
[    1.028076] raid6: sse2x2    5163 MB/s
[    1.096078] raid6: sse2x4    6032 MB/s
[    1.096892] raid6: using algorithm sse2x4 (6032 MB/s)
[    1.100072] raid6: using intx1 recovery algorithm
[    1.108682] ACPI: Added _OSI(Module Device)
[    1.109005] ACPI: Added _OSI(Processor Device)
[    1.112081] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.113002] ACPI: Added _OSI(Processor Aggregator Device)
[    1.121485] ACPI: EC: Look up EC in DSDT
[    1.217545] ACPI: Interpreter enabled
[    1.218377] ACPI: (supports S0 S3 S4 S5)
[    1.219775] ACPI: Using IOAPIC for interrupt routing
[    1.516272] ACPI: No dock devices found.
[    1.517118] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.524239] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.525426] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.527014] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.528100] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.532101] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    1.533763] PCI: root bus 00: using default resources
[    1.534737] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.556181] PCI host bridge to bus 0000:00
[    1.560114] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    1.564102] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.565116] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.566186] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    1.568175] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.572409] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.573879] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.576921] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    1.584725] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.586130] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    1.587682] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    1.588261] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.596512] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.598550] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    1.606984] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    1.608316] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.612420] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    1.616109] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    1.620116] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    1.624242] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    1.628476] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    1.632312] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.636110] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    1.637704] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    1.644297] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.648756] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    1.650372] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    1.660982] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.664758] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.668427] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    1.674805] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.676755] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    1.680723] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    1.689882] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.691606] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    1.692719] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    1.702798] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    1.704426] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    1.712112] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    1.716351] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    1.720470] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    1.725139] pci_bus 0000:00: on NUMA node 0
[    1.728157] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.757036]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    1.760118]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    2.309140] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    2.313691] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    2.320323] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    2.328887] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    2.331249] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    2.356615] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.360218] vgaarb: loaded
[    2.360924] vgaarb: bridge control possible 0000:00:02.0
[    2.388347] SCSI subsystem initialized
[    2.389048] ACPI: bus type scsi registered
[    2.392349] libata version 3.00 loaded.
[    2.396387] ACPI: bus type usb registered
[    2.404570] usbcore: registered new interface driver usbfs
[    2.408356] usbcore: registered new interface driver hub
[    2.420239] usbcore: registered new device driver usb
[    2.421265] PCI: Using ACPI for IRQ routing
[    2.424364] PCI: pci_cache_line_size set to 64 bytes
[    2.432613] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    2.433669] e820: reserve RAM buffer [mem 0x1fffe000-0x1fffffff]
[    2.440862] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    2.441965] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.444939] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    2.472278] Switching to clocksource hpet
[    2.810517] pnp: PnP ACPI init
[    2.811384] ACPI: bus type pnp registered
[    2.812463] pnp 00:00: [bus 00-ff]
[    2.813247] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.814105] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.815016] pnp 00:00: [io  0x0d00-0xffff window]
[    2.824677] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.825674] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    2.902194] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.903455] pnp 00:01: [io  0x0070-0x0071]
[    2.904372] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    2.905988] pnp 00:01: [irq 8]
[    2.906745] pnp 00:01: [io  0x0072-0x0077]
[    2.944943] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.946481] pnp 00:02: [io  0x0060]
[    2.947277] pnp 00:02: [io  0x0064]
[    2.948120] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    2.957380] pnp 00:02: [irq 1]
[    2.984513] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.986053] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    2.987698] pnp 00:03: [irq 12]
[    3.021411] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    3.022926] pnp 00:04: [io  0x03f2-0x03f5]
[    3.023781] pnp 00:04: [io  0x03f7]
[    3.024632] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    3.033458] pnp 00:04: [irq 6]
[    3.034214] pnp 00:04: [dma 2]
[    3.113178] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    3.115032] pnp 00:05: [io  0x0378-0x037f]
[    3.115895] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    3.117653] pnp 00:05: [irq 7]
[    3.155484] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    3.157400] pnp 00:06: [io  0x03f8-0x03ff]
[    3.158256] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    3.185316] pnp 00:06: [irq 4]
[    3.214429] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.217849] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    3.237567] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    3.240682] pnp: PnP ACPI: found 8 devices
[    3.241528] ACPI: ACPI bus type pnp unregistered
[    3.466924] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    3.467928] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    3.469904] NET: Registered protocol family 2
[    3.482898] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    3.489506] TCP bind hash table entries: 16384 (order: 8, 1310720 bytes)
[    3.503167] TCP: Hash tables configured (established 16384 bind 16384)
[    3.504413] TCP: reno registered
[    3.505188] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    3.506294] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    3.507781] NET: Registered protocol family 1
[    3.554636] RPC: Registered named UNIX socket transport module.
[    3.555679] RPC: Registered udp transport module.
[    3.556701] RPC: Registered tcp transport module.
[    3.557613] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.558733] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.570190] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    3.571236] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    3.577196] pci 0000:00:02.0: Boot video device
[    3.578239] PCI: CLS 0 bytes, default 64
[    3.877608] DMA-API: preallocated 32768 debug entries
[    3.878559] DMA-API: debugging enabled by kernel config
[    3.939474] Initializing RT-Tester: OK
[    3.994482] Kprobe smoke test started
[    4.144118] Kprobe smoke test passed successfully
[    4.192383] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.528475] VFS: Disk quotas dquot_6.5.2
[    4.536533] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.642158] NFS: Registering the id_resolver key type
[    4.643236] Key type id_resolver registered
[    4.644141] Key type id_legacy registered
[    4.645005] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.711707] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.723592] fuse init (API version 7.20)
[    4.756641] msgmni has been set to 927
[    4.778103] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    4.779662] io scheduler noop registered
[    4.780543] io scheduler deadline registered
[    4.811011] io scheduler cfq registered (default)
[    4.811928] start plist test
[    4.813614] end plist test
[    4.814319] list_sort_test: start testing list_sort()
[    4.877339] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.894332] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.895441] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    4.915681] tsc: Refined TSC clocksource calibration: 3200.109 MHz
[    4.916794] Switching to clocksource tsc
[    4.940834] acpiphp: Slot [3] registered
[    4.963542] acpiphp: Slot [4] registered
[    4.964926] acpiphp: Slot [5] registered
[    4.966282] acpiphp: Slot [6] registered
[    4.979534] acpiphp: Slot [7] registered
[    4.981062] acpiphp: Slot [8] registered
[    4.993506] acpiphp: Slot [9] registered
[    4.996145] acpiphp: Slot [10] registered
[    5.007595] acpiphp: Slot [11] registered
[    5.013687] acpiphp: Slot [12] registered
[    5.035354] acpiphp: Slot [13] registered
[    5.036742] acpiphp: Slot [14] registered
[    5.038124] acpiphp: Slot [15] registered
[    5.058334] acpiphp: Slot [16] registered
[    5.059719] acpiphp: Slot [17] registered
[    5.061274] acpiphp: Slot [18] registered
[    5.078857] acpiphp: Slot [19] registered
[    5.080464] acpiphp: Slot [20] registered
[    5.097328] acpiphp: Slot [21] registered
[    5.098711] acpiphp: Slot [22] registered
[    5.142157] acpiphp: Slot [23] registered
[    5.143531] acpiphp: Slot [24] registered
[    5.144935] acpiphp: Slot [25] registered
[    5.216108] acpiphp: Slot [26] registered
[    5.217485] acpiphp: Slot [27] registered
[    5.233602] acpiphp: Slot [28] registered
[    5.234986] acpiphp: Slot [29] registered
[    5.251588] acpiphp: Slot [30] registered
[    5.253104] acpiphp: Slot [31] registered
[    5.301620] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    5.303222] ACPI: Power Button [PWRF]
[    5.582087] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    5.587275] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:3)
[    5.589197] virtio-pci 0000:00:05.0: setting latency timer to 64
[    5.621129] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    5.622153] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:3)
[    5.627909] virtio-pci 0000:00:06.0: setting latency timer to 64
[    5.648154] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    5.649215] virtio-pci 0000:00:07.0: setting latency timer to 64
[    5.664083] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[    5.665136] virtio-pci 0000:00:08.0: setting latency timer to 64
[    5.695287] virtio-pci 0000:00:09.0: setting latency timer to 64
[    5.697098] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    5.725150] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled

[    6.140324] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    6.184784] Non-volatile memory driver v1.3
[    6.224118] Linux agpgart interface v0.103
[    6.261567] [drm] Initialized drm 1.1.0 20060810
[    6.381119] brd: module loaded
[    6.463985] loop: module loaded
[    6.465147] virtio-pci 0000:00:05.0: irq 40 for MSI/MSI-X
[    6.466433] virtio-pci 0000:00:05.0: irq 41 for MSI/MSI-X
[    6.489529]  vda: unknown partition table
[    6.495278] virtio-pci 0000:00:06.0: irq 42 for MSI/MSI-X
[    6.496470] virtio-pci 0000:00:06.0: irq 43 for MSI/MSI-X
[    6.516280]  vdb: unknown partition table
[    6.518183] virtio-pci 0000:00:07.0: irq 44 for MSI/MSI-X
[    6.519202] virtio-pci 0000:00:07.0: irq 45 for MSI/MSI-X
[    6.550965]  vdc: unknown partition table
[    6.561240] virtio-pci 0000:00:08.0: irq 46 for MSI/MSI-X
[    6.562263] virtio-pci 0000:00:08.0: irq 47 for MSI/MSI-X
[    6.580294]  vdd: unknown partition table
[    6.582329] virtio-pci 0000:00:09.0: irq 48 for MSI/MSI-X
[    6.583353] virtio-pci 0000:00:09.0: irq 49 for MSI/MSI-X
[    6.610911]  vde: unknown partition table
[    6.620260] virtio-pci 0000:00:0a.0: irq 50 for MSI/MSI-X
[    6.621284] virtio-pci 0000:00:0a.0: irq 51 for MSI/MSI-X
[    6.641093]  vdf: unknown partition table
[    6.643203] lkdtm: No crash points registered, enable through debugfs
[    6.651684] Uniform Multi-Platform E-IDE driver
[    6.653479] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    6.654705] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[    6.655867] pci 0000:00:01.1: setting latency timer to 64
[    6.656886]     ide0: BM-DMA at 0xc1c0-0xc1c7
[    6.657794]     ide1: BM-DMA at 0xc1c8-0xc1cf
[    6.658666] Probing IDE interface ide0...
[    7.232684] Probing IDE interface ide1...
[    7.964125] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    8.636711] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    8.637876] hdc: MWDMA2 mode selected
[    8.638844] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    8.640088] ide1 at 0x170-0x177,0x376 on irq 15
[    8.682243] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    8.702341] ide-gd driver 1.18
[    8.703461] ide-cd driver 5.00
[    8.704805] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[    8.706080] cdrom: Uniform CD-ROM driver Revision: 3.20
[    8.771411] Loading iSCSI transport class v2.0-870.
[    8.832550] Adaptec aacraid driver 1.2-0[29800]-ms
[    8.834289] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    8.872417] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.04.00.03-k.
[    8.899926] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    8.926752] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    8.928289] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
[    8.935571] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    9.003390] RocketRAID 3xxx/4xxx Controller driver v1.6 (091225)
[    9.044231] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    9.062815] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    9.063799] Copyright (c) 2007 Atheros Corporation.
[    9.077104] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    9.087997] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    9.087997]   http://www.scyld.com/network/drivers.html
[    9.123942] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    9.155574] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    9.156945] e100: Copyright(c) 1999-2006 Intel Corporation
[    9.184268] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    9.185411] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    9.186532] e1000 0000:00:03.0: setting latency timer to 64
[    9.554166] e1000 0000:00:03.0: eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    9.555320] e1000 0000:00:03.0: eth0: Intel(R) PRO/1000 Network Connection
[    9.556900] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[    9.557928] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    9.617112] igb: Intel(R) Gigabit Ethernet Network Driver - version 4.0.1-k
[    9.618241] igb: Copyright (c) 2007-2012 Intel Corporation.
[    9.629675] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    9.630832] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    9.636223] sky2: driver version 1.30
[    9.649262] usbcore: registered new interface driver catc
[    9.680619] usbcore: registered new interface driver kaweth
[    9.681619] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    9.695336] usbcore: registered new interface driver pegasus
[    9.696874] usbcore: registered new interface driver rtl8150
[    9.698270] usbcore: registered new interface driver asix
[    9.712284] usbcore: registered new interface driver cdc_ether
[    9.746411] usbcore: registered new interface driver cdc_eem
[    9.747743] usbcore: registered new interface driver dm9601
[    9.757566] usbcore: registered new interface driver smsc75xx
[    9.759993] usbcore: registered new interface driver smsc95xx
[    9.781442] usbcore: registered new interface driver gl620a
[    9.791333] usbcore: registered new interface driver net1080
[    9.792668] usbcore: registered new interface driver plusb
[    9.798276] usbcore: registered new interface driver rndis_host
[    9.852428] usbcore: registered new interface driver cdc_subset
[    9.853784] usbcore: registered new interface driver zaurus
[    9.863591] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    9.865501] usbcore: registered new interface driver int51x1
[    9.878337] usbcore: registered new interface driver ipheth
[    9.879732] usbcore: registered new interface driver sierra_net
[    9.881219] usbcore: registered new interface driver cdc_ncm
[    9.882229] Fusion MPT base driver 3.04.20
[    9.883065] Copyright (c) 1999-2008 LSI Corporation
[    9.884057] Fusion MPT SPI Host driver 3.04.20
[    9.913246] Fusion MPT FC Host driver 3.04.20
[    9.922602] Fusion MPT SAS Host driver 3.04.20
[    9.923889] Fusion MPT misc device (ioctl) driver 3.04.20
[    9.925314] mptctl: Registered with Fusion MPT base driver
[    9.926304] mptctl: /dev/mptctl @ (major,minor=10,220)
[    9.940319] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.945831] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.947231] uhci_hcd: USB Universal Host Controller Interface driver
[    9.958711] Initializing USB Mass Storage driver...
[    9.960042] usbcore: registered new interface driver usb-storage
[    9.961087] USB Mass Storage support registered.
[    9.973659] usbcore: registered new interface driver ums-alauda
[    9.975012] usbcore: registered new interface driver ums-datafab
[    9.981312] usbcore: registered new interface driver ums-freecom
[    9.990310] usbcore: registered new interface driver ums-isd200
[    9.991657] usbcore: registered new interface driver ums-jumpshot
[    9.993316] usbcore: registered new interface driver ums-sddr09
[   10.011573] usbcore: registered new interface driver ums-sddr55
[   10.012943] usbcore: registered new interface driver ums-usbat
[   10.014331] usbcore: registered new interface driver usbtest
[   10.016067] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   10.042003] serio: i8042 KBD port at 0x60,0x64 irq 1
[   10.043000] serio: i8042 AUX port at 0x60,0x64 irq 12
[   10.057883] mousedev: PS/2 mouse device common for all mice
[   10.065912] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   10.109098] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   10.111398] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   10.112987] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   10.141496] i6300esb: initialized (0xffffc90000022000). heartbeat=30 sec (nowayout=0)
[   10.155292] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   10.157028] iTCO_vendor_support: vendor-support=0
[   10.158022] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[   10.162939] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[   10.190675] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   10.192681] md: linear personality registered for level -1
[   10.197189] md: raid0 personality registered for level 0
[   10.198158] md: raid1 personality registered for level 1
[   10.199115] md: raid10 personality registered for level 10
[   10.200177] md: raid6 personality registered for level 6
[   10.201146] md: raid5 personality registered for level 5
[   10.202107] md: raid4 personality registered for level 4
[   10.203078] md: multipath personality registered for level -4
[   10.210134] md: faulty personality registered for level -5
[   10.233701] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[   10.249230] device-mapper: multipath: version 1.5.0 loaded
[   10.250243] device-mapper: multipath round-robin: version 1.0.0 loaded
[   10.257814] EDAC MC: Ver: 3.0.0
[   10.289321] cpuidle: using governor ladder
[   10.290174] cpuidle: using governor menu
[   10.296160] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   10.326491] usbcore: registered new interface driver usbhid
[   10.327493] usbhid: USB HID core driver
[   10.328333] oprofile: using NMI interrupt.
[   10.359574] TCP: bic registered
[   10.360347] Initializing XFRM netlink socket
[   10.374755] NET: Registered protocol family 10
[   10.391020] sit: IPv6 over IPv4 tunneling driver
[   10.393552] NET: Registered protocol family 17
[   10.394623] 8021q: 802.1Q VLAN Support v1.8
[   10.412959] sctp: Hash tables configured (established 1638 bind 1638)
[   10.424168] Key type dns_resolver registered
[   10.427188] 
[   10.427188] printing PIC contents
[   10.428876] ... PIC  IMR: ffff
[   10.429622] ... PIC  IRR: 9013
[   10.430359] ... PIC  ISR: 0000
[   10.431097] ... PIC ELCR: 0c00
[   10.443320] printing local APIC contents on CPU#0/0:
[   10.444257] ... APIC ID:      00000000 (0)
[   10.445111] ... APIC VERSION: 00050014
[   10.445917] ... APIC TASKPRI: 00000000 (00)
[   10.446766] ... APIC PROCPRI: 00000000
[   10.447312] ... APIC LDR: 01000000
[   10.447312] ... APIC DFR: ffffffff
[   10.447312] ... APIC SPIV: 000001ff
[   10.447312] ... APIC ISR field:
[   10.447312] 0000000000000000000000000000000000000000000000000000000000000000
[   10.447312] ... APIC TMR field:
[   10.447312] 0000000000000000000000000000000000000000000000000000000000000000
[   10.447312] ... APIC IRR field:
[   10.447312] 0000000000000000000000000000000000000000000000000000000020000000
[   10.447312] ... APIC ESR: 00000000
[   10.447312] ... APIC ICR: 000008fd
[   10.447312] ... APIC ICR2: 02000000
[   10.447312] ... APIC LVTT: 000000ef
[   10.447312] ... APIC LVTPC: 00010000
[   10.447312] ... APIC LVT0: 00010700
[   10.447312] ... APIC LVT1: 00000400
[   10.447312] ... APIC LVTERR: 000000fe
[   10.447312] ... APIC TMICT: 7ffffffe
[   10.447312] ... APIC TMCCT: 7fb0bccd
[   10.447312] ... APIC TDCR: 00000003
[   10.447312] 
[   10.522134] number of MP IRQ sources: 15.
[   10.522971] number of IO-APIC #2 registers: 24.
[   10.523852] testing the IO APIC.......................
[   10.524849] IO APIC #2......
[   10.525562] .... register #00: 00000000
[   10.526368] .......    : physical APIC id: 00
[   10.527227] .......    : Delivery Type: 0
[   10.532080] .......    : LTS          : 0
[   10.532907] .... register #01: 00170011
[   10.533721] .......     : max redirection entries: 17
[   10.534647] .......     : PRQ implemented: 0
[   10.535496] .......     : IO APIC version: 11
[   10.546092] .... register #02: 00000000
[   10.546907] .......     : arbitration: 00
[   10.547729] .... IRQ redirection table:
[   10.548585]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   10.549578]  00 00  1    0    0   0   0    0    0    00
[   10.550606]  01 03  0    0    0   0   0    1    1    31
[   10.551637]  02 03  0    0    0   0   0    1    1    30
[   10.556094]  03 03  1    0    0   0   0    1    1    33
[   10.557126]  04 03  1    0    0   0   0    1    1    34
[   10.558150]  05 03  1    1    0   0   0    1    1    35
[   10.559171]  06 03  1    0    0   0   0    1    1    36
[   10.567131]  07 03  1    0    0   0   0    1    1    37
[   10.568275]  08 03  1    0    0   0   0    1    1    38
[   10.569305]  09 03  0    1    0   0   0    1    1    39
[   10.570331]  0a 03  1    1    0   0   0    1    1    3A
[   10.571358]  0b 03  1    1    0   0   0    1    1    3B
[   10.572438]  0c 03  0    0    0   0   0    1    1    3C
[   10.573466]  0d 03  1    0    0   0   0    1    1    3D
[   10.574488]  0e 03  0    0    0   0   0    1    1    3E
[   10.575511]  0f 03  0    0    0   0   0    1    1    3F
[   10.584090]  10 00  1    0    0   0   0    0    0    00
[   10.585123]  11 00  1    0    0   0   0    0    0    00
[   10.586147]  12 00  1    0    0   0   0    0    0    00
[   10.587178]  13 00  1    0    0   0   0    0    0    00
[   10.588643]  14 00  1    0    0   0   0    0    0    00
[   10.589685]  15 00  1    0    0   0   0    0    0    00
[   10.590705]  16 00  1    0    0   0   0    0    0    00
[   10.591845]  17 00  1    0    0   0   0    0    0    00
[   10.592919] IRQ to pin mappings:
[   10.593677] IRQ0 -> 0:2
[   10.594478] IRQ1 -> 0:1
[   10.595274] IRQ3 -> 0:3
[   10.596400] IRQ4 -> 0:4
[   10.597207] IRQ5 -> 0:5
[   10.598006] IRQ6 -> 0:6
[   10.598810] IRQ7 -> 0:7
[   10.599725] IRQ8 -> 0:8
[   10.600583] IRQ9 -> 0:9
[   10.601383] IRQ10 -> 0:10
[   10.602201] IRQ11 -> 0:11
[   10.603017] IRQ12 -> 0:12
[   10.610397] IRQ13 -> 0:13
[   10.611218] IRQ14 -> 0:14
[   10.612207] IRQ15 -> 0:15
[   10.613025] .................................... done.
[   10.675469] PM: Hibernation image not present or could not be loaded.
[   10.676645] registered taskstats version 1
[   10.683572] rtc-test rtc-test.0: setting system clock to 2012-10-21 17:00:27 UTC (1350838827)
[   10.685461] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   10.730684] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   10.731807] 8021q: adding VLAN 0 to HW filter on device eth0
[   10.739625] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[   12.736359] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   12.740087] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   12.756076] Sending DHCP requests ., OK
[   12.776080] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0.2.15
[   12.778191] IP-Config: Complete:
[   12.778951]      device=eth0, addr=10.0.2.15, mask=255.255.255.0, gw=10.0.2.2
[   12.780130]      host=kvm, domain=, nis-domain=(none)
[   12.781067]      bootserver=10.0.2.2, rootserver=10.239.97.14, rootpath=
[   12.782692] md: Waiting for all devices to be available before autodetect
[   12.783811] md: If you don't use raid, use raid=noautodetect
[   12.794921] md: Autodetecting RAID arrays.
[   12.795770] md: Scanned 0 and added 0 devices.
[   12.796862] md: autorun ...
[   12.797574] md: ... autorun DONE.
[   16.201348] VFS: Mounted root (nfs filesystem) on device 0:12.
[   16.202836] debug: unmapping init [mem 0xffffffff81cd2000-0xffffffff81f7afff]
[   17.036485] modprobe (1192) used greatest stack depth: 3296 bytes left
[   23.744952] S02mountkernfs. (1213) used greatest stack depth: 3120 bytes left
[   87.537591] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   87.567265] NFSD: starting 90-second grace period
[   87.595746] rpc.nfsd (2123) used greatest stack depth: 2848 bytes left
Kernel tests: Boot OK!
[   91.895211] Adding 307196k swap on /dev/vda.  Priority:-1 extents:1 across:307196k 
[   92.122744] Unregister pv shared memory for cpu 1
[   92.161962] CPU0 attaching NULL sched-domain.
[   92.162988] CPU1 attaching NULL sched-domain.
[   92.164149] CPU0 attaching NULL sched-domain.
[   92.252733] do_IRQ: 1.59 No irq handler for vector (irq -1)
[   92.253257] ------------[ cut here ]------------
[   92.253675] WARNING: at /c/kernel-tests/src/stable/kernel/rcutree.c:1562 rcu_do_batch+0x17e/0x63b()
[   92.254474] Hardware name: Bochs
[   92.254766] Modules linked in:
[   92.256689] Pid: 9, comm: migration/1 Not tainted 3.6.3 #1306
[   92.256689] Call Trace:
[   92.256689]  <IRQ>  [<ffffffff81033dbd>] warn_slowpath_common+0x83/0x9c
[   92.256689]  [<ffffffff81033df0>] warn_slowpath_null+0x1a/0x1c
[   92.256689]  [<ffffffff810a70fd>] rcu_do_batch+0x17e/0x63b
[   92.256689]  [<ffffffff810a6705>] ? rcu_report_qs_rnp+0x28b/0x2d5
[   92.256689]  [<ffffffff810a769d>] ? rcu_process_callbacks+0xe3/0x236
[   92.256689]  [<ffffffff810a772c>] rcu_process_callbacks+0x172/0x236
[   92.256689]  [<ffffffff8103b6cc>] __do_softirq+0xf6/0x231
[   92.256689]  [<ffffffff8107fe2c>] ? tick_program_event+0x24/0x26
[   92.256689]  [<ffffffff817d23bc>] call_softirq+0x1c/0x30
[   92.256689]  [<ffffffff81003f7c>] do_softirq+0x4a/0xa6
[   92.256689]  [<ffffffff8103ba98>] irq_exit+0x51/0xbc
[   92.256689]  [<ffffffff817d2a2f>] smp_apic_timer_interrupt+0x8b/0x99
[   92.256689]  [<ffffffff817d1c2f>] apic_timer_interrupt+0x6f/0x80
[   92.256689]  <EOI>  [<ffffffff81067440>] ? local_clock+0x1d/0x5a
[   92.256689]  [<ffffffff8109ea37>] ? stop_machine_cpu_stop+0x104/0x119
[   92.256689]  [<ffffffff8109e6d5>] cpu_stopper_thread+0xdd/0x17d
[   92.256689]  [<ffffffff8109e933>] ? queue_stop_cpus_work+0x130/0x130
[   92.256689]  [<ffffffff817ca044>] ? _raw_spin_unlock_irqrestore+0x47/0x65
[   92.256689]  [<ffffffff81086613>] ? trace_hardirqs_on_caller+0x125/0x181
[   92.256689]  [<ffffffff8108667c>] ? trace_hardirqs_on+0xd/0xf
[   92.256689]  [<ffffffff8109e5f8>] ? cpu_stop_signal_done+0x2c/0x2c
[   92.256689]  [<ffffffff81055e74>] kthread+0x9a/0xa2
[   92.256689]  [<ffffffff817d22c4>] kernel_thread_helper+0x4/0x10
[   92.256689]  [<ffffffff817ca4b0>] ? retint_restore_args+0x13/0x13
[   92.256689]  [<ffffffff81055dda>] ? __init_kthread_worker+0x5a/0x5a
[   92.317029]  [<ffffffff817d22c0>] ? gs_change+0x13/0x13
[   92.317029] ---[ end trace 08af298aa58b8cc5 ]---
[   92.318733] smpboot: CPU 1 is now offline
[   92.318734] SMP alternatives: lockdep: fixing up alternatives
[   92.318740] SMP alternatives: switching to UP code
[   92.511719] SMP alternatives: lockdep: fixing up alternatives
[   92.513064] SMP alternatives: switching to SMP code
[   92.546264] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   92.317029] masked ExtINT on CPU#1
[   92.746152] CPU0 attaching NULL sched-domain.
[   92.747264] CPU0 attaching sched-domain:
[   92.748209]  domain 0: span 0-1 level CPU
[   92.749160]   groups: 0 (cpu_power = 1021) 1 (cpu_power = 1019)
[   92.750572] CPU1 attaching sched-domain:
[   92.751426]  domain 0: span 0-1 level CPU
[   92.756091]   groups: 1 (cpu_power = 1019) 0 (cpu_power = 1021)
[   92.807506] KVM setup async PF for cpu 1
[   92.811491] kvm-stealtime: cpu 1, msr 1f40d140

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.3"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.6.3 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
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
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
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
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

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
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
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
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

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
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
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
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
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
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
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
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
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
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y
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
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

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
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

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
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
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
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MULTICORE_RAID456 is not set
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

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
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
# CONFIG_CNIC is not set
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
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
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
# CONFIG_PCMCIA_XIRCOM is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
# CONFIG_IGB_PTP is not set
# CONFIG_IGBVF is not set
CONFIG_IXGB=y
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_ZNET is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
CONFIG_NE2K_PCI=y
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_SEEQ8005 is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
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
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

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
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
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
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
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
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
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
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
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
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
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
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

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
# CONFIG_HSI is not set

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_AVS is not set
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
# CONFIG_SENSORS_HIH6130 is not set
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
# CONFIG_SENSORS_MCP3021 is not set
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
# CONFIG_SENSORS_INA2XX is not set
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
CONFIG_WATCHDOG_CORE=y
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
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
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
# CONFIG_VIA_WDT is not set
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
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
CONFIG_LPC_ICH=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
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
CONFIG_FB_TILEBLITTING=y

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
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
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
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_CHIPIDEA is not set

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
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

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
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD64 is not set
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_EDAC_SBRIDGE is not set
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
CONFIG_RTC_DRV_TEST=y

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
# CONFIG_RTC_DRV_CMOS is not set
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
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

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

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
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
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
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
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_ACL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
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
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
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
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
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
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
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
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
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
# CONFIG_UPROBE_EVENT is not set
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
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
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
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
CONFIG_DEBUG_NMI_SELFTEST=y

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
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
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
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
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
# CONFIG_CRYPTO_XTS is not set

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
# CONFIG_CRYPTO_SHA512 is not set
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
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
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
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VHOST_NET is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=UTF-8
Content-Disposition: attachment; filename="dmesg-kvm_bisect3-inn-12919-2012-11-03-16-40-41-3.4.0-rc4-bisect3-00033-gdc36be4-13"
Content-Transfer-Encoding: 8bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.0-rc4-bisect3-00033-gdc36be4 (wfg@bee) (gcc version 4.7.1 (Debian 4.7.1-5) ) #13 SMP Sat Nov 3 16:31:14 CST 2012
[    0.000000] Command line: hung_task_panic=1 bisect-reboot x86_64-lkp branch=stable/linux-3.6.y dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm_bisect3::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-bisect3
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000093c00 (usable)
[    0.000000]  BIOS-e820: 0000000000093c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fffe000 (usable)
[    0.000000]  BIOS-e820: 000000001fffe000 - 0000000020000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000fdac0] fdac0
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000008e000] 8e000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000001fffe000
[    0.000000]  0000000000 - 001fffe000 page 4k
[    0.000000] kernel direct mapping tables up to 1fffe000 @ 1fefc000-1fffe000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128035(97%)
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e600000-ffff88001edfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000093
[    0.000000]     0: 0x00000100 -> 0x0001fffe
[    0.000000] On node 0 totalpages: 130945
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3902 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 124990 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 20000000:deffc000)
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88001f200000 s1914752 r8192 d22656 u2097152
[    0.000000] pcpu-alloc: s1914752 r8192 d22656 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1f20d180
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128892
[    0.000000] Kernel command line: hung_task_panic=1 bisect-reboot x86_64-lkp branch=stable/linux-3.6.y dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm_bisect3::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-bisect3
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 475256k/524280k available (7800k kernel code, 500k absent, 48524k reserved, 4925k data, 2696k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: PIT calibration matches HPET. 1 loops
[    0.000000] Detected 2693.508 MHz processor.
[    0.016005] Calibrating delay loop (skipped), value calculated using timer frequency.. 5387.01 BogoMIPS (lpj=10774032)
[    0.021490] pid_max: default: 32768 minimum: 301
[    0.024545] Mount-cache hash table entries: 256
[    0.033616] mce: CPU supports 10 MCE banks
[    0.040494] ACPI: Core revision 20120320
[    0.083006] ftrace: allocating 30627 entries in 120 pages
[    0.096578] Getting VERSION: 50014
[    0.100020] Getting VERSION: 50014
[    0.101602] Getting ID: 0
[    0.104020] Getting ID: ff000000
[    0.105551] Getting LVT0: 8700
[    0.107001] Getting LVT1: 8400
[    0.108094] enabled ExtINT on CPU#0
[    0.112711] ENABLING IO-APIC IRQs
[    0.114400] init IO_APIC IRQs
[    0.116017]  apic 2 pin 0 not connected
[    0.118031] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.120047] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.124043] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.128042] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.132045] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.136044] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.139605] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.140048] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.144044] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.148046] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.152043] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.156043] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.160045] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.164050] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.168049] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.172036]  apic 2 pin 16 not connected
[    0.173693]  apic 2 pin 17 not connected
[    0.176016]  apic 2 pin 18 not connected
[    0.177661]  apic 2 pin 19 not connected
[    0.180016]  apic 2 pin 20 not connected
[    0.181704]  apic 2 pin 21 not connected
[    0.183349]  apic 2 pin 22 not connected
[    0.184017]  apic 2 pin 23 not connected
[    0.185905] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.188017] CPU0: Intel Common KVM processor stepping 01
[    0.193307] Using local APIC timer interrupts.
[    0.193309] calibrating APIC timer ...
[    0.200011] ... lapic delta = 6250617
[    0.200011] ... PM-Timer delta = 357996
[    0.200011] ... PM-Timer result ok
[    0.200011] ..... delta 6250617
[    0.200011] ..... mult: 268445178
[    0.200011] ..... calibration result: 4000394
[    0.200011] ..... CPU clock speed is 2693.3363 MHz.
[    0.200011] ..... host bus clock speed is 1000.0394 MHz.
[    0.200100] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.206007] lockdep: fixing up alternatives.
[    0.208425] Booting Node   0, Processors  #1 Ok.
[    0.020001] masked ExtINT on CPU#1
[    0.020001] calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
[    0.020001] Probably due to long platform interrupts. Consider using "lpj=" boot option.
[    0.412184] Brought up 2 CPUs
[    0.413652] ----------------
[    0.416029] | NMI testsuite:
[    0.417431] --------------------
[    0.416039] KVM setup async PF for cpu 1
[    0.416043] kvm-stealtime: cpu 1, msr 1f40d180
[    0.424030]   remote IPI:  ok  |
[    0.441451]    local IPI:  ok  |
[    0.464054] --------------------
[    0.465537] Good, all   2 testcases passed! |
[    0.467413] ---------------------------------
[    0.468035] Total of 2 processors activated (6357.76 BogoMIPS).
[    0.472548] CPU0 attaching sched-domain:
[    0.474175]  domain 0: span 0-1 level CPU
[    0.476038]   groups: 0 1
[    0.478699] CPU1 attaching sched-domain:
[    0.480035]  domain 0: span 0-1 level CPU
[    0.484034]   groups: 1 0
[    0.509100] xor: automatically using best checksumming function: generic_sse
[    0.528066]    generic_sse:   109.000 MB/sec
[    0.530173] xor: using function: generic_sse (109.000 MB/sec)
[    0.532045] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.548685] kworker/u:0 used greatest stack depth: 5240 bytes left
[    0.552815] NET: Registered protocol family 16
[    0.557932] kworker/u:0 used greatest stack depth: 4776 bytes left
[    0.568332] ACPI: bus type pci registered
[    0.570211] PCI: Using configuration type 1 for base access
[    0.904499] bio: create slab <bio-0> at 0
[    0.976076] raid6: int64x1   1902 MB/s
[    1.044093] raid6: int64x2   1711 MB/s
[    1.112085] raid6: int64x4   1690 MB/s
[    1.180104] raid6: int64x8   1628 MB/s
[    1.248092] raid6: sse2x1    4668 MB/s
[    1.316094] raid6: sse2x2    6389 MB/s
[    1.384094] raid6: sse2x4    7310 MB/s
[    1.386847] raid6: using algorithm sse2x4 (7310 MB/s)
[    1.392328] ACPI: Added _OSI(Module Device)
[    1.394218] ACPI: Added _OSI(Processor Device)
[    1.396109] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.398080] ACPI: Added _OSI(Processor Aggregator Device)
[    1.405649] ACPI: EC: Look up EC in DSDT
[    1.488039] ACPI: Interpreter enabled
[    1.488100] ACPI: (supports S0 S3 S4 S5)
[    1.492130] ACPI: Using IOAPIC for interrupt routing
[    1.705454] ACPI: No dock devices found.
[    1.707313] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.712387] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.715031] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.716113] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.720113] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.724114] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    1.728139] PCI: root bus 00: using default resources
[    1.748192] PCI host bridge to bus 0000:00
[    1.750080] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.752130] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    1.754653] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.756791] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.760990] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.766443] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    1.769282] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.772868] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    1.776134] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    1.780469] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.784705] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.789348] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    1.800715] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    1.803519] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.805035] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    1.808967] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    1.817800] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    1.820373] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.823751] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    1.824957] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    1.834936] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.837101] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    1.840978] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    1.847343] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.849049] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.852984] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    1.861546] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.865022] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    1.868127] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    1.875270] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.877111] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    1.881025] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    1.890031] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.893071] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    1.896124] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    1.904322] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.907060] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    1.912561] pci_bus 0000:00: on NUMA node 0
[    1.914450] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.943384]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.380857] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    2.385080] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    2.389908] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    2.393759] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    2.397659] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    2.420326] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.423592] vgaarb: loaded
[    2.424157] vgaarb: bridge control possible 0000:00:02.0
[    2.452487] SCSI subsystem initialized
[    2.456671] libata version 3.00 loaded.
[    2.464235] usbcore: registered new interface driver usbfs
[    2.466313] usbcore: registered new interface driver hub
[    2.472697] usbcore: registered new device driver usb
[    2.480302] PCI: Using ACPI for IRQ routing
[    2.482038] PCI: pci_cache_line_size set to 64 bytes
[    2.486034] reserve RAM buffer: 0000000000093c00 - 000000000009ffff 
[    2.487508] reserve RAM buffer: 000000001fffe000 - 000000001fffffff 
[    2.509122] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    2.512198] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.514779] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    2.536323] Switching to clocksource hpet
[    2.730571] pnp: PnP ACPI init
[    2.732510] ACPI: bus type pnp registered
[    2.734642] pnp 00:00: [bus 00-ff]
[    2.736298] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.738115] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.740351] pnp 00:00: [io  0x0d00-0xffff window]
[    2.742271] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.744619] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    2.753394] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.755908] pnp 00:01: [io  0x0070-0x0071]
[    2.757745] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    2.771340] pnp 00:01: [irq 8]
[    2.772942] pnp 00:01: [io  0x0072-0x0077]
[    2.779177] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.782334] pnp 00:02: [io  0x0060]
[    2.783931] pnp 00:02: [io  0x0064]
[    2.785728] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    2.791321] pnp 00:02: [irq 1]
[    2.800192] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.803373] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    2.807233] pnp 00:03: [irq 12]
[    2.821578] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.824980] pnp 00:04: [io  0x03f2-0x03f5]
[    2.826931] pnp 00:04: [io  0x03f7]
[    2.828650] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    2.833375] pnp 00:04: [irq 6]
[    2.835148] pnp 00:04: [dma 2]
[    2.851571] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.855313] pnp 00:05: [io  0x0378-0x037f]
[    2.857420] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    2.861153] pnp 00:05: [irq 7]
[    2.890335] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.894533] pnp 00:06: [io  0x03f8-0x03ff]
[    2.896831] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    2.901535] pnp 00:06: [irq 4]
[    2.917143] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.924508] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    2.950311] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.956296] pnp: PnP ACPI: found 8 devices
[    2.958312] ACPI: ACPI bus type pnp unregistered
[    3.109766] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    3.111938] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    3.115095] NET: Registered protocol family 2
[    3.117513] IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
[    3.121267] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    3.125502] TCP bind hash table entries: 16384 (order: 8, 1310720 bytes)
[    3.131067] TCP: Hash tables configured (established 16384 bind 16384)
[    3.133546] TCP: reno registered
[    3.135187] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    3.137789] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    3.141230] NET: Registered protocol family 1
[    3.171700] RPC: Registered named UNIX socket transport module.
[    3.174005] RPC: Registered udp transport module.
[    3.175885] RPC: Registered tcp transport module.
[    3.178075] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.180936] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.183189] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    3.185743] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    3.188480] pci 0000:00:02.0: Boot video device
[    3.190853] PCI: CLS 0 bytes, default 64
[    3.392595] DMA-API: preallocated 32768 debug entries
[    3.394789] DMA-API: debugging enabled by kernel config
[    3.532704] Initializing RT-Tester: OK
[    3.561943] Kprobe smoke test started
[    3.740226] Kprobe smoke test passed successfully
[    3.782270] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.081372] VFS: Disk quotas dquot_6.5.2
[    4.084367] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.174784] NFS: Registering the id_resolver key type
[    4.232470] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.272994] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.341133] fuse init (API version 7.18)
[    4.353786] msgmni has been set to 928
[    4.364652] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.367961] io scheduler noop registered
[    4.370029] io scheduler deadline registered
[    4.401654] Refined TSC clocksource calibration: 2693.504 MHz.
[    4.403801] Switching to clocksource tsc
[    4.431434] io scheduler cfq registered (default)
[    4.433493] start plist test
[    4.437408] end plist test
[    4.439079] list_sort_test: start testing list_sort()
[    4.503716] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.507526] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.510038] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    4.561173] acpiphp: Slot [3] registered
[    4.631177] acpiphp: Slot [4] registered
[    4.640744] acpiphp: Slot [5] registered
[    4.643502] acpiphp: Slot [6] registered
[    4.646260] acpiphp: Slot [7] registered
[    4.680228] acpiphp: Slot [8] registered
[    4.682842] acpiphp: Slot [9] registered
[    4.685678] acpiphp: Slot [10] registered
[    4.688267] acpiphp: Slot [11] registered
[    4.700491] acpiphp: Slot [12] registered
[    4.702915] acpiphp: Slot [13] registered
[    4.705669] acpiphp: Slot [14] registered
[    4.708590] acpiphp: Slot [15] registered
[    4.720520] acpiphp: Slot [16] registered
[    4.723384] acpiphp: Slot [17] registered
[    4.726820] acpiphp: Slot [18] registered
[    4.760479] acpiphp: Slot [19] registered
[    4.763213] acpiphp: Slot [20] registered
[    4.766172] acpiphp: Slot [21] registered
[    4.768857] acpiphp: Slot [22] registered
[    4.780538] acpiphp: Slot [23] registered
[    4.783108] acpiphp: Slot [24] registered
[    4.786404] acpiphp: Slot [25] registered
[    4.820798] acpiphp: Slot [26] registered
[    4.823551] acpiphp: Slot [27] registered
[    4.826243] acpiphp: Slot [28] registered
[    4.851515] acpiphp: Slot [29] registered
[    4.860497] acpiphp: Slot [30] registered
[    4.863476] acpiphp: Slot [31] registered
[    4.885777] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    4.889142] ACPI: Power Button [PWRF]
[    5.025865] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    5.028147] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:3)
[    5.033278] virtio-pci 0000:00:04.0: setting latency timer to 64
[    5.054860] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    5.057102] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:3)
[    5.060934] virtio-pci 0000:00:05.0: setting latency timer to 64
[    5.104655] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    5.106895] virtio-pci 0000:00:06.0: setting latency timer to 64
[    5.133354] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    5.135521] virtio-pci 0000:00:07.0: setting latency timer to 64
[    5.171661] virtio-pci 0000:00:08.0: setting latency timer to 64
[    5.180545] virtio-pci 0000:00:09.0: setting latency timer to 64
[    5.185522] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
ÿ[    5.508601] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.581752] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.624427] Non-volatile memory driver v1.3
[    5.627019] Linux agpgart interface v0.103
[    5.632854] [drm] Initialized drm 1.1.0 20060810
[    5.713685] brd: module loaded
[    5.738825] loop: module loaded
[    5.742051] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    5.743888] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    5.815899]  vda: unknown partition table
[    5.852415] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    5.854260] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    5.893360]  vdb: unknown partition table
[    5.896875] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    5.898715] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    5.982311]  vdc: unknown partition table
[    6.012434] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    6.014284] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    6.101537]  vdd: unknown partition table
[    6.132426] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    6.134269] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    6.202258]  vde: unknown partition table
[    6.242491] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    6.244513] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    6.292564]  vdf: unknown partition table
[    6.295762] lkdtm: No crash points registered, enable through debugfs
[    6.297794] Uniform Multi-Platform E-IDE driver
[    6.305979] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    6.308959] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[    6.322816] pci 0000:00:01.1: setting latency timer to 64
[    6.324984]     ide0: BM-DMA at 0xc1c0-0xc1c7
[    6.326928]     ide1: BM-DMA at 0xc1c8-0xc1cf
[    6.336224] Probing IDE interface ide0...
[    6.901215] Probing IDE interface ide1...
[    7.632356] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    8.305206] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    8.307819] hdc: MWDMA2 mode selected
[    8.309849] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    8.312030] ide1 at 0x170-0x177,0x376 on irq 15
[    8.336948] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    8.341656] ide-gd driver 1.18
[    8.348604] ide-cd driver 5.00
[    8.351194] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[    8.353945] cdrom: Uniform CD-ROM driver Revision: 3.20
[    8.372420] Loading iSCSI transport class v2.0-870.
[    8.401838] Adaptec aacraid driver 1.2-0[28900]-ms
[    8.411898] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    8.418041] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.13-k.
[    8.432529] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    8.436715] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    8.439738] megasas: 00.00.06.14-rc1 Fri. Jan. 6 17:00:00 PDT 2012
[    8.520353] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    8.550343] RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
[    8.566864] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    8.590269] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    8.593329] Copyright (c) 2007 Atheros Corporation.
[    8.640280] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    8.648972] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    8.648974]   http://www.scyld.com/network/drivers.html
[    8.681403] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    8.760391] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    8.765287] e100: Copyright(c) 1999-2006 Intel Corporation
[    8.781678] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    8.784623] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    8.787131] e1000 0000:00:03.0: setting latency timer to 64
[    8.993869] e1000 0000:00:03.0: eth0: (PCI:33MHz:32-bit) 00:00:00:00:00:ff
[    8.996397] e1000 0000:00:03.0: eth0: Intel(R) PRO/1000 Network Connection
[    8.999552] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[    9.004073] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    9.021516] igb: Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[    9.024189] igb: Copyright (c) 2007-2012 Intel Corporation.
[    9.029223] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    9.031856] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    9.051492] sky2: driver version 1.30
[    9.058156] usbcore: registered new interface driver catc
[    9.062811] usbcore: registered new interface driver kaweth
[    9.065198] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    9.083249] usbcore: registered new interface driver pegasus
[    9.085977] usbcore: registered new interface driver rtl8150
[    9.088672] usbcore: registered new interface driver asix
[    9.102494] usbcore: registered new interface driver cdc_ether
[    9.105579] usbcore: registered new interface driver cdc_eem
[    9.108146] usbcore: registered new interface driver dm9601
[    9.112044] usbcore: registered new interface driver smsc75xx
[    9.114736] usbcore: registered new interface driver smsc95xx
[    9.131700] usbcore: registered new interface driver gl620a
[    9.134499] usbcore: registered new interface driver net1080
[    9.137818] usbcore: registered new interface driver plusb
[    9.142744] usbcore: registered new interface driver rndis_host
[    9.172295] usbcore: registered new interface driver cdc_subset
[    9.175228] usbcore: registered new interface driver zaurus
[    9.188730] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    9.193110] usbcore: registered new interface driver int51x1
[    9.241262] usbcore: registered new interface driver ipheth
[    9.281302] usbcore: registered new interface driver sierra_net
[    9.301590] usbcore: registered new interface driver cdc_ncm
[    9.303867] Fusion MPT base driver 3.04.20
[    9.305725] Copyright (c) 1999-2008 LSI Corporation
[    9.307953] Fusion MPT SPI Host driver 3.04.20
[    9.321573] Fusion MPT FC Host driver 3.04.20
[    9.324134] Fusion MPT SAS Host driver 3.04.20
[    9.326826] Fusion MPT misc device (ioctl) driver 3.04.20
[    9.329848] mptctl: Registered with Fusion MPT base driver
[    9.333223] mptctl: /dev/mptctl @ (major,minor=10,220)
[    9.359444] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.363657] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.366683] uhci_hcd: USB Universal Host Controller Interface driver
[    9.383211] Initializing USB Mass Storage driver...
[    9.385780] usbcore: registered new interface driver usb-storage
[    9.388207] USB Mass Storage support registered.
[    9.402734] usbcore: registered new interface driver ums-alauda
[    9.405457] usbcore: registered new interface driver ums-datafab
[    9.408633] usbcore: registered new interface driver ums-freecom
[    9.422581] usbcore: registered new interface driver ums-isd200
[    9.425453] usbcore: registered new interface driver ums-jumpshot
[    9.428359] usbcore: registered new interface driver ums-sddr09
[    9.442373] usbcore: registered new interface driver ums-sddr55
[    9.445374] usbcore: registered new interface driver ums-usbat
[    9.449908] usbcore: registered new interface driver usbtest
[    9.461378] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    9.468394] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.470791] serio: i8042 AUX port at 0x60,0x64 irq 12
[    9.503738] mousedev: PS/2 mouse device common for all mice
[    9.533076] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    9.576114] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    9.581925] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    9.584373] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    9.601195] i6300esb: initialized (0xffffc90000022000). heartbeat=30 sec (nowayout=0)
[    9.605884] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    9.609855] iTCO_wdt: No device detected
[    9.612982] iTCO_vendor_support: vendor-support=0
[    9.615076] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16)
[    9.619202] watchdog: error registering /dev/watchdog (err=-16)
[    9.622683] md: linear personality registered for level -1
[    9.624924] md: raid0 personality registered for level 0
[    9.627278] md: raid1 personality registered for level 1
[    9.629513] md: raid10 personality registered for level 10
[    9.632916] md: raid6 personality registered for level 6
[    9.635084] md: raid5 personality registered for level 5
[    9.637288] md: raid4 personality registered for level 4
[    9.639502] md: multipath personality registered for level -4
[    9.641836] md: faulty personality registered for level -5
[    9.666723] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    9.682283] device-mapper: multipath: version 1.3.0 loaded
[    9.684449] device-mapper: multipath round-robin: version 1.0.0 loaded
[    9.780197] EDAC MC: Ver: 2.1.0
[    9.784610] cpuidle: using governor ladder
[    9.786503] cpuidle: using governor menu
[    9.830376] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    9.883834] usbcore: registered new interface driver usbhid
[    9.886337] usbhid: USB HID core driver
[    9.888452] oprofile: using NMI interrupt.
[    9.900586] TCP: bic registered
[    9.902266] Initializing XFRM netlink socket
[    9.931731] NET: Registered protocol family 10
[    9.961498] IPv6 over IPv4 tunneling driver
[    9.971869] NET: Registered protocol family 17
[    9.974228] 8021q: 802.1Q VLAN Support v1.8
[   10.001483] sctp: Hash tables configured (established 1638 bind 1638)
[   10.030727] Registering the dns_resolver key type
[   10.033521] 
[   10.033522] printing PIC contents
[   10.036557] ... PIC  IMR: ffff
[   10.038154] ... PIC  IRR: 9013
[   10.039741] ... PIC  ISR: 0000
[   10.042617] ... PIC ELCR: 0c00
[   10.044296] printing local APIC contents on CPU#0/0:
[   10.046296] ... APIC ID:      00000000 (0)
[   10.048289] ... APIC VERSION: 00050014
[   10.048289] ... APIC TASKPRI: 00000000 (00)
[   10.048289] ... APIC PROCPRI: 00000000
[   10.048289] ... APIC LDR: 01000000
[   10.048289] ... APIC DFR: ffffffff
[   10.048289] ... APIC SPIV: 000001ff
[   10.048289] ... APIC ISR field:
[   10.048289] 0000000000000000000000000000000000000000000000000000000000000000
[   10.048289] ... APIC TMR field:
[   10.048289] 0000000000000000000000000000000000000000000000000000000000000000
[   10.048289] ... APIC IRR field:
[   10.048289] 0000000000000000000000000000000000000000000000000000000000008000
[   10.048289] ... APIC ESR: 00000000
[   10.048289] ... APIC ICR: 000008fd
[   10.048289] ... APIC ICR2: 02000000
[   10.048289] ... APIC LVTT: 000000ef
[   10.048289] ... APIC LVTPC: 00010000
[   10.048289] ... APIC LVT0: 00010700
[   10.048289] ... APIC LVT1: 00000400
[   10.048289] ... APIC LVTERR: 000000fe
[   10.048289] ... APIC TMICT: 0003c9a8
[   10.048289] ... APIC TMCCT: 00000000
[   10.048289] ... APIC TDCR: 00000003
[   10.048289] 
[   10.140092] number of MP IRQ sources: 15.
[   10.141880] number of IO-APIC #2 registers: 24.
[   10.143841] testing the IO APIC.......................
[   10.145965] 
[   10.147248] IO APIC #2......
[   10.148881] .... register #00: 00000000
[   10.151746] .......    : physical APIC id: 00
[   10.153723] .......    : Delivery Type: 0
[   10.155600] .......    : LTS          : 0
[   10.157439] .... register #01: 00170011
[   10.159321] .......     : max redirection entries: 17
[   10.161576] .......     : PRQ implemented: 0
[   10.163492] .......     : IO APIC version: 11
[   10.165429] .... register #02: 00000000
[   10.167179] .......     : arbitration: 00
[   10.169198] .... IRQ redirection table:
[   10.171718]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   10.174075]  00 00  1    0    0   0   0    0    0    00
[   10.176462]  01 03  0    0    0   0   0    1    1    31
[   10.178692]  02 03  0    0    0   0   0    1    1    30
[   10.182153]  03 03  1    0    0   0   0    1    1    33
[   10.184592]  04 03  1    0    0   0   0    1    1    34
[   10.187141]  05 03  1    1    0   0   0    1    1    35
[   10.189454]  06 03  1    0    0   0   0    1    1    36
[   10.191921]  07 03  1    0    0   0   0    1    1    37
[   10.194285]  08 03  1    0    0   0   0    1    1    38
[   10.196891]  09 03  0    1    0   0   0    1    1    39
[   10.199080]  0a 03  1    1    0   0   0    1    1    3A
[   10.201488]  0b 03  1    1    0   0   0    1    1    3B
[   10.203752]  0c 03  0    0    0   0   0    1    1    3C
[   10.205897]  0d 03  1    0    0   0   0    1    1    3D
[   10.209070]  0e 03  0    0    0   0   0    1    1    3E
[   10.211273]  0f 03  0    0    0   0   0    1    1    3F
[   10.213589]  10 00  1    0    0   0   0    0    0    00
[   10.215751]  11 00  1    0    0   0   0    0    0    00
[   10.218016]  12 00  1    0    0   0   0    0    0    00
[   10.221280]  13 00  1    0    0   0   0    0    0    00
[   10.223476]  14 00  1    0    0   0   0    0    0    00
[   10.225735]  15 00  1    0    0   0   0    0    0    00
[   10.227875]  16 00  1    0    0   0   0    0    0    00
[   10.230245]  17 00  1    0    0   0   0    0    0    00
[   10.232608] IRQ to pin mappings:
[   10.234295] IRQ0 -> 0:2
[   10.235958] IRQ1 -> 0:1
[   10.237688] IRQ3 -> 0:3
[   10.239353] IRQ4 -> 0:4
[   10.241428] IRQ5 -> 0:5
[   10.243114] IRQ6 -> 0:6
[   10.244867] IRQ7 -> 0:7
[   10.246542] IRQ8 -> 0:8
[   10.250345] IRQ9 -> 0:9
[   10.252395] IRQ10 -> 0:10
[   10.254376] IRQ11 -> 0:11
[   10.256204] IRQ12 -> 0:12
[   10.257962] IRQ13 -> 0:13
[   10.259976] IRQ14 -> 0:14
[   10.262087] IRQ15 -> 0:15
[   10.263852] .................................... done.
[   10.283139] PM: Hibernation image not present or could not be loaded.
[   10.285625] registered taskstats version 1
[   10.301152] rtc-test rtc-test.0: setting system clock to 2012-11-03 08:39:56 UTC (1351931996)
[   10.305317] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   10.342142] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[   10.364948] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   10.367100] 8021q: adding VLAN 0 to HW filter on device eth0
[   12.368314] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   12.372464] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   12.388082] Sending DHCP requests ., OK
[   12.412168] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0.2.15
[   12.416235] IP-Config: Complete:
[   12.417922]      device=eth0, addr=10.0.2.15, mask=255.255.255.0, gw=10.0.2.2
[   12.420577]      host=kvm_bisect3, domain=, nis-domain=(none)
[   12.439377]      bootserver=10.0.2.2, rootserver=10.239.97.14, rootpath=
[   12.444812] md: Waiting for all devices to be available before autodetect
[   12.447286] md: If you don't use raid, use raid=noautodetect
[   12.464915] md: Autodetecting RAID arrays.
[   12.466733] md: Scanned 0 and added 0 devices.
[   12.468901] md: autorun ...
[   12.471691] md: ... autorun DONE.
[   15.925756] VFS: Mounted root (nfs filesystem) on device 0:12.
[   15.928223] debug: unmapping init memory ffffffff81c6f000..ffffffff81f11000
[   16.367925] modprobe used greatest stack depth: 3440 bytes left
[   18.316120] ps used greatest stack depth: 3296 bytes left
[   20.028140] hwclock used greatest stack depth: 3152 bytes left
[   23.112196] eth0: no IPv6 routers present
[   28.665491] S36udev-mtab used greatest stack depth: 3024 bytes left
[   41.686534] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   41.693122] NFSD: starting 90-second grace period
[   43.741033] Adding 307196k swap on /dev/vda.  Priority:-1 extents:1 across:307196k 
[   43.886247] event trace: Could not enable event function
[   43.899626] Unregister pv shared memory for cpu 1
[   43.903800] CPU0 attaching NULL sched-domain.
[   43.905825] CPU1 attaching NULL sched-domain.
[   43.907748] CPU0 attaching NULL sched-domain.
[   44.125057] CPU 1 is now offline
[   44.127163] lockdep: fixing up alternatives.
[   44.129197] SMP alternatives: switching to UP code
[   44.327286] lockdep: fixing up alternatives.
[   44.329563] SMP alternatives: switching to SMP code
[   44.356727] Booting Node 0 Processor 1 APIC 0x1
[   43.913577] masked ExtINT on CPU#1
[   44.410383] CPU0 attaching NULL sched-domain.
[   44.412885] CPU0 attaching sched-domain:
[   44.414602]  domain 0: span 0-1 level CPU
[   44.417886]   groups: 0 (cpu_power = 1018) 1
[   44.420621] CPU1 attaching sched-domain:
[   44.422533]  domain 0: span 0-1 level CPU
[   44.424660]   groups: 1 0 (cpu_power = 1018)
[   44.434310] KVM setup async PF for cpu 1
[   44.435871] kvm-stealtime: cpu 1, msr 1f40d180
[   45.458272] Unregister pv shared memory for cpu 1
[   45.461087] CPU0 attaching NULL sched-domain.
[   45.463152] CPU1 attaching NULL sched-domain.
[   45.465370] CPU0 attaching NULL sched-domain.
[   45.469738] ------------[ cut here ]------------
[   45.471727] WARNING: at /c/wfg/mm/kernel/rcutree.c:1547 rcu_do_batch+0x17e/0x60c()
[   45.473490] Hardware name: Bochs
[   45.473701] Modules linked in:
[   45.473701] Pid: 2290, comm: migration/1 Not tainted 3.4.0-rc4-bisect3-00033-gdc36be4 #13
[   45.473701] Call Trace:
[   45.473701]  <IRQ>  [<ffffffff81030ad5>] warn_slowpath_common+0x83/0x9c
[   45.473701]  [<ffffffff81030b08>] warn_slowpath_null+0x1a/0x1c
[   45.473701]  [<ffffffff8109f0ac>] rcu_do_batch+0x17e/0x60c
[   45.473701]  [<ffffffff8109fae5>] ? rcu_report_qs_rnp+0x284/0x2ce
[   45.473701]  [<ffffffff810a0760>] ? __rcu_process_callbacks+0x94/0x163
[   45.473701]  [<ffffffff810a07ec>] __rcu_process_callbacks+0x120/0x163
[   45.473701]  [<ffffffff810a088e>] rcu_process_callbacks+0x5f/0xf4
[   45.473701]  [<ffffffff81036ea5>] __do_softirq+0xe9/0x211
[   45.473701]  [<ffffffff8101bc05>] ? lapic_next_event+0x1d/0x21
[   45.473701]  [<ffffffff8179b42c>] call_softirq+0x1c/0x30
[   45.473701]  [<ffffffff81003f80>] do_softirq+0x4a/0xa6
[   45.473701]  [<ffffffff8103725e>] irq_exit+0x51/0xbc
[   45.473701]  [<ffffffff8179ba9f>] smp_apic_timer_interrupt+0x8b/0x99
[   45.473701]  [<ffffffff8179aa2f>] apic_timer_interrupt+0x6f/0x80
[   45.473701]  <EOI>  [<ffffffff81061c54>] ? local_clock+0x1d/0x5a
[   45.473701]  [<ffffffff810987cf>] ? stop_machine_cpu_stop+0x104/0x119
[   45.473701]  [<ffffffff8109846d>] cpu_stopper_thread+0xdd/0x17d
[   45.473701]  [<ffffffff810986cb>] ? queue_stop_cpus_work+0x130/0x130
[   45.473701]  [<ffffffff81792ef4>] ? _raw_spin_unlock_irqrestore+0x47/0x65
[   45.473701]  [<ffffffff810807a6>] ? trace_hardirqs_on_caller+0x125/0x181
[   45.473701]  [<ffffffff8108080f>] ? trace_hardirqs_on+0xd/0xf
[   45.473701]  [<ffffffff81098390>] ? cpu_stop_signal_done+0x2c/0x2c
[   45.473701]  [<ffffffff81050ba5>] kthread+0x9a/0xa2
[   45.473701]  [<ffffffff8179b334>] kernel_thread_helper+0x4/0x10
[   45.473701]  [<ffffffff81793330>] ? retint_restore_args+0x13/0x13
[   45.473701]  [<ffffffff81050b0b>] ? __init_kthread_worker+0x5a/0x5a
[   45.473701]  [<ffffffff8179b330>] ? gs_change+0x13/0x13
[   45.473701] ---[ end trace b464466e1c43566e ]---
[   45.473701] ------------[ cut here ]------------
[   45.473701] WARNING: at /c/wfg/mm/kernel/rcutree.c:1878 __call_rcu+0xcd/0x2e3()
[   45.473701] Hardware name: Bochs
[   45.473701] Modules linked in:
[   45.473701] Pid: 2290, comm: migration/1 Tainted: G        W    3.4.0-rc4-bisect3-00033-gdc36be4 #13
[   45.473701] Call Trace:
[   45.473701]  <IRQ>  [<ffffffff81030ad5>] warn_slowpath_common+0x83/0x9c
[   45.473701]  [<ffffffff81056a39>] ? release_tgcred.isra.6+0x25/0x25
[   45.473701]  [<ffffffff81030b08>] warn_slowpath_null+0x1a/0x1c
[   45.473701]  [<ffffffff810a0468>] __call_rcu+0xcd/0x2e3
[   45.473701]  [<ffffffff810abba9>] ? rb_commit+0x58/0x85
[   45.473701]  [<ffffffff810a06ca>] call_rcu_sched+0x17/0x19
[   45.473701]  [<ffffffff81056a12>] __put_cred+0x60/0x62
[   45.473701]  [<ffffffff81056f9b>] exit_creds+0x83/0xca
[   45.473701]  [<ffffffff8102dfbf>] __put_task_struct+0x68/0xdf
[   45.473701]  [<ffffffff81033178>] delayed_put_task_struct+0x67/0x8e
[   45.473701]  [<ffffffff8109f262>] rcu_do_batch+0x334/0x60c
[   45.473701]  [<ffffffff8109fae5>] ? rcu_report_qs_rnp+0x284/0x2ce
[   45.473701]  [<ffffffff810a0760>] ? __rcu_process_callbacks+0x94/0x163
[   45.473701]  [<ffffffff810a07ec>] __rcu_process_callbacks+0x120/0x163
[   45.473701]  [<ffffffff810a088e>] rcu_process_callbacks+0x5f/0xf4
[   45.473701]  [<ffffffff81036ea5>] __do_softirq+0xe9/0x211
[   45.473701]  [<ffffffff8101bc05>] ? lapic_next_event+0x1d/0x21
[   45.473701]  [<ffffffff8179b42c>] call_softirq+0x1c/0x30
[   45.473701]  [<ffffffff81003f80>] do_softirq+0x4a/0xa6
[   45.473701]  [<ffffffff8103725e>] irq_exit+0x51/0xbc
[   45.473701]  [<ffffffff8179ba9f>] smp_apic_timer_interrupt+0x8b/0x99
[   45.473701]  [<ffffffff8179aa2f>] apic_timer_interrupt+0x6f/0x80
[   45.473701]  <EOI>  [<ffffffff81061c54>] ? local_clock+0x1d/0x5a
[   45.473701]  [<ffffffff810987cf>] ? stop_machine_cpu_stop+0x104/0x119
[   45.473701]  [<ffffffff8109846d>] cpu_stopper_thread+0xdd/0x17d
[   45.473701]  [<ffffffff810986cb>] ? queue_stop_cpus_work+0x130/0x130
[   45.473701]  [<ffffffff81792ef4>] ? _raw_spin_unlock_irqrestore+0x47/0x65
[   45.473701]  [<ffffffff810807a6>] ? trace_hardirqs_on_caller+0x125/0x181
[   45.473701]  [<ffffffff8108080f>] ? trace_hardirqs_on+0xd/0xf
[   45.473701]  [<ffffffff81098390>] ? cpu_stop_signal_done+0x2c/0x2c
[   45.473701]  [<ffffffff81050ba5>] kthread+0x9a/0xa2
[   45.473701]  [<ffffffff8179b334>] kernel_thread_helper+0x4/0x10
[   45.473701]  [<ffffffff81793330>] ? retint_restore_args+0x13/0x13
[   45.473701]  [<ffffffff81050b0b>] ? __init_kthread_worker+0x5a/0x5a
[   45.473701]  [<ffffffff8179b330>] ? gs_change+0x13/0x13
[   45.473701] ---[ end trace b464466e1c43566f ]---
[   45.601193] CPU 1 is now offline
[   45.602909] lockdep: fixing up alternatives.
[   45.604829] SMP alternatives: switching to UP code
[   46.935638] mount.nfs used greatest stack depth: 2960 bytes left

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=UTF-8
Content-Disposition: attachment; filename="dmesg-kvm_bisect3-inn-8580-2012-11-08-10-12-10-3.4.0-rc4-bisect3-00008-gb1420f1-17"
Content-Transfer-Encoding: 8bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.0-rc4-bisect3-00008-gb1420f1 (wfg@bee) (gcc version 4.7.1 (Debian 4.7.1-5) ) #17 SMP Thu Nov 8 10:09:10 CST 2012
[    0.000000] Command line: hung_task_panic=1 bisect-reboot x86_64-lkp branch=stable/linux-3.6.y dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm_bisect3::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-bisect3
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000093c00 (usable)
[    0.000000]  BIOS-e820: 0000000000093c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fffe000 (usable)
[    0.000000]  BIOS-e820: 000000001fffe000 - 0000000020000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000fdac0] fdac0
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000008e000] 8e000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000001fffe000
[    0.000000]  0000000000 - 001fffe000 page 4k
[    0.000000] kernel direct mapping tables up to 1fffe000 @ 1fefc000-1fffe000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128035(97%)
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e600000-ffff88001edfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000093
[    0.000000]     0: 0x00000100 -> 0x0001fffe
[    0.000000] On node 0 totalpages: 130945
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3902 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 124990 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 20000000:deffc000)
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88001f200000 s1914752 r8192 d22656 u2097152
[    0.000000] pcpu-alloc: s1914752 r8192 d22656 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1f20d180
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128892
[    0.000000] Kernel command line: hung_task_panic=1 bisect-reboot x86_64-lkp branch=stable/linux-3.6.y dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm_bisect3::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-bisect3
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 475260k/524280k available (7799k kernel code, 500k absent, 48520k reserved, 4926k data, 2696k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2693.378 MHz processor.
[    0.008005] Calibrating delay loop (skipped), value calculated using timer frequency.. 5386.75 BogoMIPS (lpj=10773512)
[    0.013345] pid_max: default: 32768 minimum: 301
[    0.016514] Mount-cache hash table entries: 256
[    0.021266] mce: CPU supports 10 MCE banks
[    0.027673] ACPI: Core revision 20120320
[    0.062600] ftrace: allocating 30617 entries in 120 pages
[    0.072456] Getting VERSION: 50014
[    0.073941] Getting VERSION: 50014
[    0.076018] Getting ID: 0
[    0.077291] Getting ID: ff000000
[    0.078694] Getting LVT0: 8700
[    0.080015] Getting LVT1: 8400
[    0.081441] enabled ExtINT on CPU#0
[    0.085108] ENABLING IO-APIC IRQs
[    0.086535] init IO_APIC IRQs
[    0.088013]  apic 2 pin 0 not connected
[    0.089580] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.092050] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.096048] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.099391] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.100040] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.104038] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.108040] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.111133] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.112044] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.116046] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.120041] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.124040] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.127035] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.128047] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.132043] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.136031]  apic 2 pin 16 not connected
[    0.137553]  apic 2 pin 17 not connected
[    0.140013]  apic 2 pin 18 not connected
[    0.141668]  apic 2 pin 19 not connected
[    0.143319]  apic 2 pin 20 not connected
[    0.144015]  apic 2 pin 21 not connected
[    0.145686]  apic 2 pin 22 not connected
[    0.148014]  apic 2 pin 23 not connected
[    0.149686] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.152014] CPU0: Intel Common KVM processor stepping 01
[    0.154133] Using local APIC timer interrupts.
[    0.154134] calibrating APIC timer ...
[    0.160009] ... lapic delta = 6499631
[    0.160009] ... PM-Timer delta = 372247
[    0.160009] APIC calibration not consistent with PM-Timer: 103ms instead of 100ms
[    0.160009] APIC delta adjusted to PM-Timer: 6250067 (6499631)
[    0.160009] TSC delta adjusted to PM-Timer: 269350369 (280105452)
[    0.160009] ..... delta 6250067
[    0.160009] ..... mult: 268421557
[    0.160009] ..... calibration result: 4000042
[    0.160009] ..... CPU clock speed is 2693.2014 MHz.
[    0.160009] ..... host bus clock speed is 1000.0042 MHz.
[    0.160083] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.173432] lockdep: fixing up alternatives.
[    0.175731] Booting Node   0, Processors  #1 Ok.
[    0.012000] masked ExtINT on CPU#1
[    0.012000] calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
[    0.012000] Probably due to long platform interrupts. Consider using "lpj=" boot option.
[    0.348199] Brought up 2 CPUs
[    0.349738] ----------------
[    0.352026] | NMI testsuite:
[    0.353483] --------------------
[    0.352036] KVM setup async PF for cpu 1
[    0.352039] kvm-stealtime: cpu 1, msr 1f40d180
[    0.356027]   remote IPI:  ok  |
[    0.377255]    local IPI:  ok  |
[    0.400057] --------------------
[    0.401621] Good, all   2 testcases passed! |
[    0.403451] ---------------------------------
[    0.404031] Total of 2 processors activated (6844.93 BogoMIPS).
[    0.408848] CPU0 attaching sched-domain:
[    0.410578]  domain 0: span 0-1 level CPU
[    0.413267]   groups: 0 1
[    0.415079] CPU1 attaching sched-domain:
[    0.416032]  domain 0: span 0-1 level CPU
[    0.417831]   groups: 1 0
[    0.439516] xor: automatically using best checksumming function: generic_sse
[    0.460051]    generic_sse:   170.000 MB/sec
[    0.461878] xor: using function: generic_sse (170.000 MB/sec)
[    0.464044] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.468451] kworker/u:0 used greatest stack depth: 5256 bytes left
[    0.472773] NET: Registered protocol family 16
[    0.476930] kworker/u:0 used greatest stack depth: 4792 bytes left
[    0.484306] ACPI: bus type pci registered
[    0.488105] PCI: Using configuration type 1 for base access
[    0.716403] bio: create slab <bio-0> at 0
[    0.804066] raid6: int64x1   2077 MB/s
[    0.872084] raid6: int64x2   1708 MB/s
[    0.940078] raid6: int64x4   1632 MB/s
[    1.008101] raid6: int64x8   1643 MB/s
[    1.076079] raid6: sse2x1    4092 MB/s
[    1.144078] raid6: sse2x2    5352 MB/s
[    1.212086] raid6: sse2x4    7717 MB/s
[    1.214136] raid6: using algorithm sse2x4 (7717 MB/s)
[    1.228194] ACPI: Added _OSI(Module Device)
[    1.229853] ACPI: Added _OSI(Processor Device)
[    1.232096] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.233766] ACPI: Added _OSI(Processor Aggregator Device)
[    1.239010] ACPI: EC: Look up EC in DSDT
[    1.302410] ACPI: Interpreter enabled
[    1.303931] ACPI: (supports S0 S3 S4 S5)
[    1.305846] ACPI: Using IOAPIC for interrupt routing
[    1.516146] ACPI: No dock devices found.
[    1.517896] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.524355] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.526765] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.528107] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.532101] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.540102] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    1.543434] PCI: root bus 00: using default resources
[    1.548178] PCI host bridge to bus 0000:00
[    1.549783] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.552112] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    1.554404] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.556583] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.559402] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.564111] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    1.567004] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.568622] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    1.572118] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    1.574607] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.579343] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.581369] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    1.591513] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    1.592547] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.596926] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    1.599751] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    1.605601] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    1.607752] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.608997] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    1.612988] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    1.620197] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.623348] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    1.624982] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    1.632953] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.635978] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.636933] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    1.645281] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.648109] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    1.651051] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    1.658231] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.661038] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    1.664110] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    1.670595] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.673050] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    1.676557] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    1.683285] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.684551] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    1.690533] pci_bus 0000:00: on NUMA node 0
[    1.692206] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.717016]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.050131] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    2.055164] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    2.061322] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    2.072384] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    2.078270] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    2.084709] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.088223] vgaarb: loaded
[    2.089586] vgaarb: bridge control possible 0000:00:02.0
[    2.096634] SCSI subsystem initialized
[    2.100246] libata version 3.00 loaded.
[    2.108468] usbcore: registered new interface driver usbfs
[    2.112389] usbcore: registered new interface driver hub
[    2.114462] usbcore: registered new device driver usb
[    2.121215] PCI: Using ACPI for IRQ routing
[    2.124149] PCI: pci_cache_line_size set to 64 bytes
[    2.126661] reserve RAM buffer: 0000000000093c00 - 000000000009ffff 
[    2.128159] reserve RAM buffer: 000000001fffe000 - 000000001fffffff 
[    2.137192] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    2.140178] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.145327] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    2.160332] Switching to clocksource hpet
[    2.517983] pnp: PnP ACPI init
[    2.519895] ACPI: bus type pnp registered
[    2.522939] pnp 00:00: [bus 00-ff]
[    2.524441] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.530196] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.531860] pnp 00:00: [io  0x0d00-0xffff window]
[    2.534468] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.537411] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    2.557678] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.560337] pnp 00:01: [io  0x0070-0x0071]
[    2.563919] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    2.568305] pnp 00:01: [irq 8]
[    2.569650] pnp 00:01: [io  0x0072-0x0077]
[    2.592860] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.600449] pnp 00:02: [io  0x0060]
[    2.601918] pnp 00:02: [io  0x0064]
[    2.603375] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    2.612698] pnp 00:02: [irq 1]
[    2.656550] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.659617] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    2.675422] pnp 00:03: [irq 12]
[    2.685226] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.687724] pnp 00:04: [io  0x03f2-0x03f5]
[    2.689582] pnp 00:04: [io  0x03f7]
[    2.691146] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    2.694671] pnp 00:04: [irq 6]
[    2.706365] pnp 00:04: [dma 2]
[    2.709010] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.712294] pnp 00:05: [io  0x0378-0x037f]
[    2.713757] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    2.727155] pnp 00:05: [irq 7]
[    2.736607] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.740376] pnp 00:06: [io  0x03f8-0x03ff]
[    2.741988] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    2.744852] pnp 00:06: [irq 4]
[    2.756617] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.762444] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    2.766689] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.772319] pnp: PnP ACPI: found 8 devices
[    2.775094] ACPI: ACPI bus type pnp unregistered
[    2.991222] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    2.994260] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    2.997086] NET: Registered protocol family 2
[    2.999274] IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
[    3.003096] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    3.007181] TCP bind hash table entries: 16384 (order: 8, 1310720 bytes)
[    3.012687] TCP: Hash tables configured (established 16384 bind 16384)
[    3.014973] TCP: reno registered
[    3.016815] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    3.031145] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    3.034278] NET: Registered protocol family 1
[    3.066232] RPC: Registered named UNIX socket transport module.
[    3.068228] RPC: Registered udp transport module.
[    3.069922] RPC: Registered tcp transport module.
[    3.071747] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.074007] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.076544] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    3.078769] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    3.081215] pci 0000:00:02.0: Boot video device
[    3.083097] PCI: CLS 0 bytes, default 64
[    3.313316] DMA-API: preallocated 32768 debug entries
[    3.315491] DMA-API: debugging enabled by kernel config
[    3.381298] Initializing RT-Tester: OK
[    3.412193] Kprobe smoke test started
[    3.596225] Kprobe smoke test passed successfully
[    3.624452] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.894551] VFS: Disk quotas dquot_6.5.2
[    3.897027] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.938529] NFS: Registering the id_resolver key type
[    3.945518] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    3.997964] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.000926] fuse init (API version 7.18)
[    4.005020] msgmni has been set to 928
[    4.023523] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.026612] io scheduler noop registered
[    4.027983] io scheduler deadline registered
[    4.037971] io scheduler cfq registered (default)
[    4.039517] start plist test
[    4.043465] end plist test
[    4.044676] list_sort_test: start testing list_sort()
[    4.177096] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.180244] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.182098] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    4.205381] acpiphp: Slot [3] registered
[    4.216897] acpiphp: Slot [4] registered
[    4.219471] acpiphp: Slot [5] registered
[    4.222305] acpiphp: Slot [6] registered
[    4.245371] acpiphp: Slot [7] registered
[    4.256860] acpiphp: Slot [8] registered
[    4.259452] acpiphp: Slot [9] registered
[    4.262083] acpiphp: Slot [10] registered
[    4.264856] acpiphp: Slot [11] registered
[    4.276595] acpiphp: Slot [12] registered
[    4.278864] acpiphp: Slot [13] registered
[    4.281337] acpiphp: Slot [14] registered
[    4.283481] acpiphp: Slot [15] registered
[    4.296091] acpiphp: Slot [16] registered
[    4.298829] acpiphp: Slot [17] registered
[    4.301651] acpiphp: Slot [18] registered
[    4.304297] acpiphp: Slot [19] registered
[    4.315574] acpiphp: Slot [20] registered
[    4.318162] Refined TSC clocksource calibration: 2693.501 MHz.
[    4.319925] Switching to clocksource tsc
[    4.321572] acpiphp: Slot [21] registered
[    4.323568] acpiphp: Slot [22] registered
[    4.326115] acpiphp: Slot [23] registered
[    4.328505] acpiphp: Slot [24] registered
[    4.330898] acpiphp: Slot [25] registered
[    4.333337] acpiphp: Slot [26] registered
[    4.341161] acpiphp: Slot [27] registered
[    4.343575] acpiphp: Slot [28] registered
[    4.375522] acpiphp: Slot [29] registered
[    4.378017] acpiphp: Slot [30] registered
[    4.380885] acpiphp: Slot [31] registered
[    4.403070] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    4.406675] ACPI: Power Button [PWRF]
[    4.551092] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.552876] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:3)
[    4.555877] virtio-pci 0000:00:04.0: setting latency timer to 64
[    4.574589] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.576786] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:3)
[    4.580619] virtio-pci 0000:00:05.0: setting latency timer to 64
[    4.598569] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.600862] virtio-pci 0000:00:06.0: setting latency timer to 64
[    4.608003] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    4.616971] virtio-pci 0000:00:07.0: setting latency timer to 64
[    4.632466] virtio-pci 0000:00:08.0: setting latency timer to 64
[    4.636770] virtio-pci 0000:00:09.0: setting latency timer to 64
[    4.641461] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
ÿ[    4.928503] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.986198] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.008331] Non-volatile memory driver v1.3
[    5.015163] Linux agpgart interface v0.103
[    5.030187] [drm] Initialized drm 1.1.0 20060810
[    5.137550] brd: module loaded
[    5.186029] loop: module loaded
[    5.187993] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    5.189785] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    5.225597]  vda: unknown partition table
[    5.228586] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    5.230347] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    5.287505]  vdb: unknown partition table
[    5.294588] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    5.296395] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    5.339230]  vdc: unknown partition table
[    5.342265] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    5.344058] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    5.414417]  vdd: unknown partition table
[    5.445527] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    5.447276] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    5.494122]  vde: unknown partition table
[    5.496974] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    5.498730] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    5.539167]  vdf: unknown partition table
[    5.542151] lkdtm: No crash points registered, enable through debugfs
[    5.544057] Uniform Multi-Platform E-IDE driver
[    5.549777] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    5.551934] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[    5.554003] pci 0000:00:01.1: setting latency timer to 64
[    5.555988]     ide0: BM-DMA at 0xc1c0-0xc1c7
[    5.557637]     ide1: BM-DMA at 0xc1c8-0xc1cf
[    5.559158] Probing IDE interface ide0...
[    6.145016] Probing IDE interface ide1...
[    6.876265] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    7.548955] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    7.551021] hdc: MWDMA2 mode selected
[    7.552711] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    7.554473] ide1 at 0x170-0x177,0x376 on irq 15
[    7.572417] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    7.585165] ide-gd driver 1.18
[    7.586828] ide-cd driver 5.00
[    7.588936] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[    7.591133] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.626287] Loading iSCSI transport class v2.0-870.
[    7.634254] Adaptec aacraid driver 1.2-0[28900]-ms
[    7.645961] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    7.686813] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.13-k.
[    7.695650] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    7.705170] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    7.707621] megasas: 00.00.06.14-rc1 Fri. Jan. 6 17:00:00 PDT 2012
[    7.715588] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    7.717856] RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
[    7.735178] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    7.738149] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    7.739860] Copyright (c) 2007 Atheros Corporation.
[    7.746808] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    7.755188] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    7.755190]   http://www.scyld.com/network/drivers.html
[    7.760693] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    7.765180] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    7.767032] e100: Copyright(c) 1999-2006 Intel Corporation
[    7.772037] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    7.774101] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    7.776952] e1000 0000:00:03.0: setting latency timer to 64
[    8.006156] e1000 0000:00:03.0: eth0: (PCI:33MHz:32-bit) 00:00:00:00:00:ff
[    8.008258] e1000 0000:00:03.0: eth0: Intel(R) PRO/1000 Network Connection
[    8.015187] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[    8.017023] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    8.025178] igb: Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[    8.027201] igb: Copyright (c) 2007-2012 Intel Corporation.
[    8.036190] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    8.038242] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    8.045630] sky2: driver version 1.30
[    8.056353] usbcore: registered new interface driver catc
[    8.058425] usbcore: registered new interface driver kaweth
[    8.060215] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    8.065188] usbcore: registered new interface driver pegasus
[    8.068177] usbcore: registered new interface driver rtl8150
[    8.075180] usbcore: registered new interface driver asix
[    8.085198] usbcore: registered new interface driver cdc_ether
[    8.087337] usbcore: registered new interface driver cdc_eem
[    8.095176] usbcore: registered new interface driver dm9601
[    8.097360] usbcore: registered new interface driver smsc75xx
[    8.099547] usbcore: registered new interface driver smsc95xx
[    8.105177] usbcore: registered new interface driver gl620a
[    8.115175] usbcore: registered new interface driver net1080
[    8.117345] usbcore: registered new interface driver plusb
[    8.119426] usbcore: registered new interface driver rndis_host
[    8.125176] usbcore: registered new interface driver cdc_subset
[    8.135176] usbcore: registered new interface driver zaurus
[    8.137301] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    8.165177] usbcore: registered new interface driver int51x1
[    8.175178] usbcore: registered new interface driver ipheth
[    8.177341] usbcore: registered new interface driver sierra_net
[    8.179515] usbcore: registered new interface driver cdc_ncm
[    8.181332] Fusion MPT base driver 3.04.20
[    8.182799] Copyright (c) 1999-2008 LSI Corporation
[    8.184539] Fusion MPT SPI Host driver 3.04.20
[    8.196562] Fusion MPT FC Host driver 3.04.20
[    8.198533] Fusion MPT SAS Host driver 3.04.20
[    8.205182] Fusion MPT misc device (ioctl) driver 3.04.20
[    8.207392] mptctl: Registered with Fusion MPT base driver
[    8.209167] mptctl: /dev/mptctl @ (major,minor=10,220)
[    8.213181] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.225185] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    8.227390] uhci_hcd: USB Universal Host Controller Interface driver
[    8.230249] Initializing USB Mass Storage driver...
[    8.235174] usbcore: registered new interface driver usb-storage
[    8.237012] USB Mass Storage support registered.
[    8.245160] usbcore: registered new interface driver ums-alauda
[    8.247277] usbcore: registered new interface driver ums-datafab
[    8.255160] usbcore: registered new interface driver ums-freecom
[    8.257333] usbcore: registered new interface driver ums-isd200
[    8.265160] usbcore: registered new interface driver ums-jumpshot
[    8.267346] usbcore: registered new interface driver ums-sddr09
[    8.275161] usbcore: registered new interface driver ums-sddr55
[    8.277396] usbcore: registered new interface driver ums-usbat
[    8.279653] usbcore: registered new interface driver usbtest
[    8.282640] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    8.334096] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.335858] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.346148] mousedev: PS/2 mouse device common for all mice
[    8.361633] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    8.372688] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    8.386675] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    8.388975] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    8.405546] i6300esb: initialized (0xffffc90000022000). heartbeat=30 sec (nowayout=0)
[    8.415203] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    8.425384] iTCO_wdt: No device detected
[    8.426953] iTCO_vendor_support: vendor-support=0
[    8.428660] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16)
[    8.431610] watchdog: error registering /dev/watchdog (err=-16)
[    8.447628] md: linear personality registered for level -1
[    8.449482] md: raid0 personality registered for level 0
[    8.451269] md: raid1 personality registered for level 1
[    8.466094] md: raid10 personality registered for level 10
[    8.467925] md: raid6 personality registered for level 6
[    8.469740] md: raid5 personality registered for level 5
[    8.482086] md: raid4 personality registered for level 4
[    8.483879] md: multipath personality registered for level -4
[    8.495786] md: faulty personality registered for level -5
[    8.526741] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    8.545471] device-mapper: multipath: version 1.3.0 loaded
[    8.547348] device-mapper: multipath round-robin: version 1.0.0 loaded
[    8.565732] EDAC MC: Ver: 2.1.0
[    8.583221] cpuidle: using governor ladder
[    8.584804] cpuidle: using governor menu
[    8.602382] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    8.634989] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[    8.665711] usbcore: registered new interface driver usbhid
[    8.667574] usbhid: USB HID core driver
[    8.669095] oprofile: using NMI interrupt.
[    8.675484] TCP: bic registered
[    8.677060] Initializing XFRM netlink socket
[    8.687693] NET: Registered protocol family 10
[    8.696818] IPv6 over IPv4 tunneling driver
[    8.706299] NET: Registered protocol family 17
[    8.708196] 8021q: 802.1Q VLAN Support v1.8
[    8.716356] sctp: Hash tables configured (established 1638 bind 1638)
[    8.725288] Registering the dns_resolver key type
[    8.727608] 
[    8.727609] printing PIC contents
[    8.730077] ... PIC  IMR: ffff
[    8.731424] ... PIC  IRR: 9013
[    8.732795] ... PIC  ISR: 0000
[    8.734147] ... PIC ELCR: 0c00
[    8.745524] printing local APIC contents on CPU#0/0:
[    8.747249] ... APIC ID:      00000000 (0)
[    8.748803] ... APIC VERSION: 00050014
[    8.749506] ... APIC TASKPRI: 00000000 (00)
[    8.749506] ... APIC PROCPRI: 00000000
[    8.749506] ... APIC LDR: 01000000
[    8.749506] ... APIC DFR: ffffffff
[    8.749506] ... APIC SPIV: 000001ff
[    8.749506] ... APIC ISR field:
[    8.749506] 0000000000000000000000000000000000000000000000000000000000000000
[    8.749506] ... APIC TMR field:
[    8.749506] 0000000000000000000000000000000000000000000000000000000000000000
[    8.749506] ... APIC IRR field:
[    8.749506] 0000000000000000000000000000000000000000000000000000000000008000
[    8.749506] ... APIC ESR: 00000000
[    8.749506] ... APIC ICR: 000008fd
[    8.749506] ... APIC ICR2: 02000000
[    8.749506] ... APIC LVTT: 000000ef
[    8.749506] ... APIC LVTPC: 00010000
[    8.749506] ... APIC LVT0: 00010700
[    8.749506] ... APIC LVT1: 00000400
[    8.749506] ... APIC LVTERR: 000000fe
[    8.749506] ... APIC TMICT: 0002602d
[    8.749506] ... APIC TMCCT: 00000000
[    8.749506] ... APIC TDCR: 00000003
[    8.749506] 
[    8.847074] number of MP IRQ sources: 15.
[    8.848632] number of IO-APIC #2 registers: 24.
[    8.850277] testing the IO APIC.......................
[    8.852059] 
[    8.866133] IO APIC #2......
[    8.867445] .... register #00: 00000000
[    8.868967] .......    : physical APIC id: 00
[    8.870576] .......    : Delivery Type: 0
[    8.872127] .......    : LTS          : 0
[    8.873659] .... register #01: 00170011
[    8.877223] .......     : max redirection entries: 17
[    8.878961] .......     : PRQ implemented: 0
[    8.880563] .......     : IO APIC version: 11
[    8.882181] .... register #02: 00000000
[    8.883679] .......     : arbitration: 00
[    8.895259] .... IRQ redirection table:
[    8.896779]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    8.898631]  00 00  1    0    0   0   0    0    0    00
[    8.900548]  01 03  0    0    0   0   0    1    1    31
[    8.902446]  02 03  0    0    0   0   0    1    1    30
[    8.916399]  03 03  1    0    0   0   0    1    1    33
[    8.918295]  04 03  1    0    0   0   0    1    1    34
[    8.920202]  05 03  1    1    0   0   0    1    1    35
[    8.922105]  06 03  1    0    0   0   0    1    1    36
[    8.936215]  07 03  1    0    0   0   0    1    1    37
[    8.938139]  08 03  1    0    0   0   0    1    1    38
[    8.940056]  09 03  0    1    0   0   0    1    1    39
[    8.952987]  0a 03  1    1    0   0   0    1    1    3A
[    8.954909]  0b 03  1    1    0   0   0    1    1    3B
[    8.956841]  0c 03  0    0    0   0   0    1    1    3C
[    8.958744]  0d 03  1    0    0   0   0    1    1    3D
[    8.960647]  0e 03  0    0    0   0   0    1    1    3E
[    8.962572]  0f 03  0    0    0   0   0    1    1    3F
[    8.964480]  10 00  1    0    0   0   0    0    0    00
[    8.974408]  11 00  1    0    0   0   0    0    0    00
[    8.976340]  12 00  1    0    0   0   0    0    0    00
[    8.978253]  13 00  1    0    0   0   0    0    0    00
[    8.980157]  14 00  1    0    0   0   0    0    0    00
[    8.982051]  15 00  1    0    0   0   0    0    0    00
[    8.983952]  16 00  1    0    0   0   0    0    0    00
[    8.988936]  17 00  1    0    0   0   0    0    0    00
[    8.990827] IRQ to pin mappings:
[    8.992243] IRQ0 -> 0:2
[    8.993695] IRQ1 -> 0:1
[    9.003470] IRQ3 -> 0:3
[    9.004959] IRQ4 -> 0:4
[    9.006417] IRQ5 -> 0:5
[    9.007853] IRQ6 -> 0:6
[    9.009333] IRQ7 -> 0:7
[    9.010771] IRQ8 -> 0:8
[    9.012245] IRQ9 -> 0:9
[    9.013687] IRQ10 -> 0:10
[    9.025205] IRQ11 -> 0:11
[    9.026689] IRQ12 -> 0:12
[    9.028195] IRQ13 -> 0:13
[    9.029674] IRQ14 -> 0:14
[    9.055282] IRQ15 -> 0:15
[    9.056819] .................................... done.
[    9.065956] PM: Hibernation image not present or could not be loaded.
[    9.068108] registered taskstats version 1
[    9.075308] rtc-test rtc-test.0: setting system clock to 2012-11-08 02:11:24 UTC (1352340684)
[    9.078791] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    9.117204] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    9.119134] 8021q: adding VLAN 0 to HW filter on device eth0
[   11.120558] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   11.124122] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   11.140043] Sending DHCP requests ., OK
[   11.152052] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0.2.15
[   11.155401] IP-Config: Complete:
[   11.177953]      device=eth0, addr=10.0.2.15, mask=255.255.255.0, gw=10.0.2.2
[   11.180130]      host=kvm_bisect3, domain=, nis-domain=(none)
[   11.182011]      bootserver=10.0.2.2, rootserver=10.239.97.14, rootpath=
[   11.184839] md: Waiting for all devices to be available before autodetect
[   11.197058] md: If you don't use raid, use raid=noautodetect
[   11.215959] md: Autodetecting RAID arrays.
[   11.217586] md: Scanned 0 and added 0 devices.
[   11.219220] md: autorun ...
[   11.220530] md: ... autorun DONE.
[   15.109894] VFS: Mounted root (nfs filesystem) on device 0:12.
[   15.113014] debug: unmapping init memory ffffffff81c6f000..ffffffff81f11000
[   15.639778] modprobe used greatest stack depth: 3456 bytes left
[   17.176879] S02mountkernfs. used greatest stack depth: 3168 bytes left
[   18.949963] pci-db used greatest stack depth: 3040 bytes left
[   20.005261] ide-cd: hdc: DMA read error
[   20.006829] hdc: DMA disabled
[   20.980525] hdparm used greatest stack depth: 3024 bytes left
[   21.704068] eth0: no IPv6 routers present
[   46.493593] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   46.509404] NFSD: starting 90-second grace period
[   48.715244] Adding 307196k swap on /dev/vda.  Priority:-1 extents:1 across:307196k 
[   48.869281] Unregister pv shared memory for cpu 1
[   48.871552] CPU0 attaching NULL sched-domain.
[   48.873333] CPU1 attaching NULL sched-domain.
[   48.875117] CPU0 attaching NULL sched-domain.
[   49.081718] ------------[ cut here ]------------
[   49.082563] WARNING: at /c/wfg/mm/kernel/rcutree.c:1548 rcu_do_batch+0x17e/0x60c()
[   49.083837] Hardware name: Bochs
[   49.084399] Modules linked in:
[   49.084946] Pid: 7, comm: migration/1 Not tainted 3.4.0-rc4-bisect3-00008-gb1420f1 #17
[   49.085588] Call Trace:
[   49.085588]  <IRQ>  [<ffffffff81030b05>] warn_slowpath_common+0x83/0x9c
[   49.085588]  [<ffffffff81030b38>] warn_slowpath_null+0x1a/0x1c
[   49.085588]  [<ffffffff8109ebf2>] rcu_do_batch+0x17e/0x60c
[   49.085588]  [<ffffffff8109ea5c>] ? check_for_new_grace_period+0xe3/0xfb
[   49.085588]  [<ffffffff8108032b>] ? trace_hardirqs_on_caller+0x172/0x181
[   49.085588]  [<ffffffff81080347>] ? trace_hardirqs_on+0xd/0xf
[   49.085588]  [<ffffffff810a0332>] __rcu_process_callbacks+0x120/0x163
[   49.085588]  [<ffffffff810a03d4>] rcu_process_callbacks+0x5f/0xf4
[   49.085588]  [<ffffffff81036ee5>] __do_softirq+0xe9/0x211
[   49.085588]  [<ffffffff8101bc25>] ? lapic_next_event+0x1d/0x21
[   49.085588]  [<ffffffff8179b1ec>] call_softirq+0x1c/0x30
[   49.085588]  [<ffffffff81003f80>] do_softirq+0x4a/0xa6
[   49.085588]  [<ffffffff8103729e>] irq_exit+0x51/0xbc
[   49.085588]  [<ffffffff8179b85f>] smp_apic_timer_interrupt+0x8b/0x99
[   49.085588]  [<ffffffff8179a7ef>] apic_timer_interrupt+0x6f/0x80
[   49.085588]  <EOI>  [<ffffffff810616a8>] ? local_clock+0x1d/0x5a
[   49.085588]  [<ffffffff81098317>] ? stop_machine_cpu_stop+0x104/0x119
[   49.085588]  [<ffffffff81097fb5>] cpu_stopper_thread+0xdd/0x17d
[   49.085588]  [<ffffffff81098213>] ? queue_stop_cpus_work+0x130/0x130
[   49.085588]  [<ffffffff81792c3c>] ? _raw_spin_unlock_irqrestore+0x47/0x65
[   49.085588]  [<ffffffff810802de>] ? trace_hardirqs_on_caller+0x125/0x181
[   49.085588]  [<ffffffff81080347>] ? trace_hardirqs_on+0xd/0xf
[   49.085588]  [<ffffffff81097ed8>] ? cpu_stop_signal_done+0x2c/0x2c
[   49.085588]  [<ffffffff81050bdd>] kthread+0x9a/0xa2
[   49.085588]  [<ffffffff8179b0f4>] kernel_thread_helper+0x4/0x10
[   49.085588]  [<ffffffff817930b0>] ? retint_restore_args+0x13/0x13
[   49.085588]  [<ffffffff81050b43>] ? __init_kthread_worker+0x5a/0x5a
[   49.085588]  [<ffffffff8179b0f0>] ? gs_change+0x13/0x13
[   49.085588] ---[ end trace f972e587bcf98c7c ]---
[   49.085588] ------------[ cut here ]------------
[   49.085588] WARNING: at /c/wfg/mm/kernel/rcutree.c:1879 __call_rcu+0xcd/0x2e3()
[   49.085588] Hardware name: Bochs
[   49.085588] Modules linked in:
[   49.085588] Pid: 7, comm: migration/1 Tainted: G        W    3.4.0-rc4-bisect3-00008-gb1420f1 #17
[   49.085588] Call Trace:
[   49.085588]  <IRQ>  [<ffffffff81030b05>] warn_slowpath_common+0x83/0x9c
[   49.085588]  [<ffffffff81056518>] ? put_cred_rcu+0xaf/0xaf
[   49.085588]  [<ffffffff81030b38>] warn_slowpath_null+0x1a/0x1c
[   49.085588]  [<ffffffff8109ffae>] __call_rcu+0xcd/0x2e3
[   49.085588]  [<ffffffff810a0210>] call_rcu_sched+0x17/0x19
[   49.085588]  [<ffffffff81056467>] release_tgcred.isra.6+0x23/0x25
[   49.085588]  [<ffffffff810564df>] put_cred_rcu+0x76/0xaf
[   49.085588]  [<ffffffff8109eda8>] rcu_do_batch+0x334/0x60c
[   49.085588]  [<ffffffff8109ea5c>] ? check_for_new_grace_period+0xe3/0xfb
[   49.085588]  [<ffffffff810a0332>] __rcu_process_callbacks+0x120/0x163
[   49.085588]  [<ffffffff810a03d4>] rcu_process_callbacks+0x5f/0xf4
[   49.085588]  [<ffffffff81036ee5>] __do_softirq+0xe9/0x211
[   49.085588]  [<ffffffff8101bc25>] ? lapic_next_event+0x1d/0x21
[   49.085588]  [<ffffffff8179b1ec>] call_softirq+0x1c/0x30
[   49.085588]  [<ffffffff81003f80>] do_softirq+0x4a/0xa6
[   49.085588]  [<ffffffff8103729e>] irq_exit+0x51/0xbc
[   49.085588]  [<ffffffff8179b85f>] smp_apic_timer_interrupt+0x8b/0x99
[   49.085588]  [<ffffffff8179a7ef>] apic_timer_interrupt+0x6f/0x80
[   49.085588]  <EOI>  [<ffffffff810616a8>] ? local_clock+0x1d/0x5a
[   49.085588]  [<ffffffff81098317>] ? stop_machine_cpu_stop+0x104/0x119
[   49.085588]  [<ffffffff81097fb5>] cpu_stopper_thread+0xdd/0x17d
[   49.085588]  [<ffffffff81098213>] ? queue_stop_cpus_work+0x130/0x130
[   49.085588]  [<ffffffff81792c3c>] ? _raw_spin_unlock_irqrestore+0x47/0x65
[   49.085588]  [<ffffffff810802de>] ? trace_hardirqs_on_caller+0x125/0x181
[   49.085588]  [<ffffffff81080347>] ? trace_hardirqs_on+0xd/0xf
[   49.085588]  [<ffffffff81097ed8>] ? cpu_stop_signal_done+0x2c/0x2c
[   49.085588]  [<ffffffff81050bdd>] kthread+0x9a/0xa2
[   49.085588]  [<ffffffff8179b0f4>] kernel_thread_helper+0x4/0x10
[   49.085588]  [<ffffffff817930b0>] ? retint_restore_args+0x13/0x13
[   49.085588]  [<ffffffff81050b43>] ? __init_kthread_worker+0x5a/0x5a
[   49.085588]  [<ffffffff8179b0f0>] ? gs_change+0x13/0x13
[   49.085588] ---[ end trace f972e587bcf98c7d ]---
[   49.237529] CPU 1 is now offline
[   49.238970] lockdep: fixing up alternatives.
[   49.240602] SMP alternatives: switching to UP code
[   49.285687] event trace: Could not enable event function
[   49.436828] lockdep: fixing up alternatives.
[   49.438474] SMP alternatives: switching to SMP code
[   49.460729] Booting Node 0 Processor 1 APIC 0x1
[   49.224182] masked ExtINT on CPU#1
[   49.506377] CPU0 attaching NULL sched-domain.
[   49.508316] CPU0 attaching sched-domain:
[   49.509853]  domain 0: span 0-1 level CPU
[   49.511521]   groups: 0 (cpu_power = 988) 1 (cpu_power = 1023)
[   49.514039] CPU1 attaching sched-domain:
[   49.515722]  domain 0: span 0-1 level CPU
[   49.517824]   groups: 1 (cpu_power = 1023) 0 (cpu_power = 988)
[   49.520916] KVM setup async PF for cpu 1
[   49.522469] kvm-stealtime: cpu 1, msr 1f40d180
[   50.543494] Unregister pv shared memory for cpu 1
[   50.545716] CPU0 attaching NULL sched-domain.
[   50.547419] CPU1 attaching NULL sched-domain.
[   50.549244] CPU0 attaching NULL sched-domain.
[   50.556538] CPU 1 is now offline
[   50.557944] lockdep: fixing up alternatives.
[   50.575735] SMP alternatives: switching to UP code

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=UTF-8
Content-Disposition: attachment; filename="dmesg-kvm_bisect3-inn-12761-2012-11-08-10-10-28-3.4.0-rc4-bisect3-00008-gb1420f1-17"
Content-Transfer-Encoding: 8bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.0-rc4-bisect3-00008-gb1420f1 (wfg@bee) (gcc version 4.7.1 (Debian 4.7.1-5) ) #17 SMP Thu Nov 8 10:09:10 CST 2012
[    0.000000] Command line: hung_task_panic=1 bisect-reboot x86_64-lkp branch=stable/linux-3.6.y dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm_bisect3::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-bisect3
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000093c00 (usable)
[    0.000000]  BIOS-e820: 0000000000093c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fffe000 (usable)
[    0.000000]  BIOS-e820: 000000001fffe000 - 0000000020000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000fdac0] fdac0
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000008e000] 8e000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000001fffe000
[    0.000000]  0000000000 - 001fffe000 page 4k
[    0.000000] kernel direct mapping tables up to 1fffe000 @ 1fefc000-1fffe000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128035(97%)
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e600000-ffff88001edfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000093
[    0.000000]     0: 0x00000100 -> 0x0001fffe
[    0.000000] On node 0 totalpages: 130945
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3902 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 124990 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 20000000:deffc000)
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88001f200000 s1914752 r8192 d22656 u2097152
[    0.000000] pcpu-alloc: s1914752 r8192 d22656 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1f20d180
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128892
[    0.000000] Kernel command line: hung_task_panic=1 bisect-reboot x86_64-lkp branch=stable/linux-3.6.y dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm_bisect3::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-bisect3
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 475260k/524280k available (7799k kernel code, 500k absent, 48520k reserved, 4926k data, 2696k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using HPET reference calibration
[    0.000000] Detected 2693.412 MHz processor.
[    0.028007] Calibrating delay loop (skipped), value calculated using timer frequency.. 5386.82 BogoMIPS (lpj=10773648)
[    0.031696] pid_max: default: 32768 minimum: 301
[    0.032554] Mount-cache hash table entries: 256
[    0.040243] mce: CPU supports 10 MCE banks
[    0.046410] ACPI: Core revision 20120320
[    0.081407] ftrace: allocating 30617 entries in 120 pages
[    0.092423] Getting VERSION: 50014
[    0.096019] Getting VERSION: 50014
[    0.097454] Getting ID: 0
[    0.100018] Getting ID: ff000000
[    0.101386] Getting LVT0: 8700
[    0.102704] Getting LVT1: 8400
[    0.104076] enabled ExtINT on CPU#0
[    0.106557] ENABLING IO-APIC IRQs
[    0.108016] init IO_APIC IRQs
[    0.112013]  apic 2 pin 0 not connected
[    0.113527] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.116041] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.118966] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.120039] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.124047] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.126955] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.128039] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.132039] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.134935] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.136039] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.140040] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.142955] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.144038] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.148041] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.152040] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.156031]  apic 2 pin 16 not connected
[    0.157509]  apic 2 pin 17 not connected
[    0.160014]  apic 2 pin 18 not connected
[    0.164014]  apic 2 pin 19 not connected
[    0.165493]  apic 2 pin 20 not connected
[    0.168014]  apic 2 pin 21 not connected
[    0.169496]  apic 2 pin 22 not connected
[    0.170972]  apic 2 pin 23 not connected
[    0.172010] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.172014] CPU0: Intel Common KVM processor stepping 01
[    0.180017] Using local APIC timer interrupts.
[    0.180018] calibrating APIC timer ...
[    0.188011] ... lapic delta = 9998914
[    0.188011] ... PM-Timer delta = 572663
[    0.188011] APIC calibration not consistent with PM-Timer: 159ms instead of 100ms
[    0.188011] APIC delta adjusted to PM-Timer: 6250013 (9998914)
[    0.188011] TSC delta adjusted to PM-Timer: 269349876 (430912095)
[    0.188011] ..... delta 6250013
[    0.188011] ..... mult: 268419238
[    0.188011] ..... calibration result: 4000008
[    0.188011] ..... CPU clock speed is 2693.1995 MHz.
[    0.188011] ..... host bus clock speed is 1000.0008 MHz.
[    0.188081] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.197584] lockdep: fixing up alternatives.
[    0.202710] Booting Node   0, Processors  #1 Ok.
[    0.032001] masked ExtINT on CPU#1
[    0.032001] calibrate_delay_direct() dropping max bogoMips estimate 4 = 21545038
[    0.032001] calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
[    0.032001] Probably due to long platform interrupts. Consider using "lpj=" boot option.
[    0.336116] Brought up 2 CPUs
[    0.337481] ----------------
[    0.340024] | NMI testsuite:
[    0.341301] --------------------
[    0.340033] KVM setup async PF for cpu 1
[    0.340036] kvm-stealtime: cpu 1, msr 1f40d180
[    0.348024]   remote IPI:  ok  |
[    0.369090]    local IPI:  ok  |
[    0.392044] --------------------
[    0.393390] Good, all   2 testcases passed! |
[    0.394944] ---------------------------------
[    0.396030] Total of 2 processors activated (10043.97 BogoMIPS).
[    0.398568] CPU0 attaching sched-domain:
[    0.400034]  domain 0: span 0-1 level CPU
[    0.404029]   groups: 0 1
[    0.405593] CPU1 attaching sched-domain:
[    0.408030]  domain 0: span 0-1 level CPU
[    0.409623]   groups: 1 0
[    0.422062] xor: automatically using best checksumming function: generic_sse
[    0.444052]    generic_sse:   112.000 MB/sec
[    0.445628] xor: using function: generic_sse (112.000 MB/sec)
[    0.447447] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.452383] kworker/u:0 used greatest stack depth: 5256 bytes left
[    0.452670] NET: Registered protocol family 16
[    0.460585] kworker/u:0 used greatest stack depth: 4792 bytes left
[    0.466151] ACPI: bus type pci registered
[    0.472379] PCI: Using configuration type 1 for base access
[    0.764431] bio: create slab <bio-0> at 0
[    0.840076] raid6: int64x1   1928 MB/s
[    0.908066] raid6: int64x2   1820 MB/s
[    0.980100] raid6: int64x4   1506 MB/s
[    1.048091] raid6: int64x8   1570 MB/s
[    1.116082] raid6: sse2x1    4178 MB/s
[    1.184082] raid6: sse2x2    6898 MB/s
[    1.252090] raid6: sse2x4    7590 MB/s
[    1.253554] raid6: using algorithm sse2x4 (7590 MB/s)
[    1.255568] ACPI: Added _OSI(Module Device)
[    1.256115] ACPI: Added _OSI(Processor Device)
[    1.257692] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.260095] ACPI: Added _OSI(Processor Aggregator Device)
[    1.266907] ACPI: EC: Look up EC in DSDT
[    1.330234] ACPI: Interpreter enabled
[    1.332095] ACPI: (supports S0 S3 S4 S5)
[    1.334477] ACPI: Using IOAPIC for interrupt routing
[    1.511276] ACPI: No dock devices found.
[    1.512104] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.516290] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.518416] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.520100] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.522929] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.528105] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    1.531079] PCI: root bus 00: using default resources
[    1.536179] PCI host bridge to bus 0000:00
[    1.537734] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.540111] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    1.542318] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.548375] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.552761] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.557576] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    1.560285] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.568666] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    1.576123] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    1.578809] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.584684] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.589282] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    1.600199] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    1.602699] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.604904] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    1.608939] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    1.616110] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    1.618313] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.624987] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    1.627572] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    1.640383] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.643108] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    1.644891] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    1.654842] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.656958] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.660913] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    1.669643] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.672984] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    1.676896] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    1.684920] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.688111] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    1.690656] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    1.700135] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.702876] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    1.704889] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    1.714451] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.716546] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    1.722923] pci_bus 0000:00: on NUMA node 0
[    1.724191] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.756242]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.069390] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    2.073511] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    2.078595] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    2.082294] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    2.086524] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    2.112379] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.115267] vgaarb: loaded
[    2.116138] vgaarb: bridge control possible 0000:00:02.0
[    2.128204] SCSI subsystem initialized
[    2.129832] libata version 3.00 loaded.
[    2.132590] usbcore: registered new interface driver usbfs
[    2.144388] usbcore: registered new interface driver hub
[    2.146023] usbcore: registered new device driver usb
[    2.148537] PCI: Using ACPI for IRQ routing
[    2.152149] PCI: pci_cache_line_size set to 64 bytes
[    2.154455] reserve RAM buffer: 0000000000093c00 - 000000000009ffff 
[    2.156159] reserve RAM buffer: 000000001fffe000 - 000000001fffffff 
[    2.181057] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    2.184176] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.186252] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    2.208292] Switching to clocksource hpet
[    2.364935] pnp: PnP ACPI init
[    2.366412] ACPI: bus type pnp registered
[    2.368178] pnp 00:00: [bus 00-ff]
[    2.369550] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.371039] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.373329] pnp 00:00: [io  0x0d00-0xffff window]
[    2.374948] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.376834] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    2.396450] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.406233] pnp 00:01: [io  0x0070-0x0071]
[    2.412441] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    2.415355] pnp 00:01: [irq 8]
[    2.418154] pnp 00:01: [io  0x0072-0x0077]
[    2.423620] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.426260] pnp 00:02: [io  0x0060]
[    2.427668] pnp 00:02: [io  0x0064]
[    2.432714] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    2.435555] pnp 00:02: [irq 1]
[    2.438103] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.444342] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    2.447253] pnp 00:03: [irq 12]
[    2.449293] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.451795] pnp 00:04: [io  0x03f2-0x03f5]
[    2.457938] pnp 00:04: [io  0x03f7]
[    2.459322] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    2.462815] pnp 00:04: [irq 6]
[    2.467713] pnp 00:04: [dma 2]
[    2.469810] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.472888] pnp 00:05: [io  0x0378-0x037f]
[    2.474390] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    2.484385] pnp 00:05: [irq 7]
[    2.486320] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.489882] pnp 00:06: [io  0x03f8-0x03ff]
[    2.491387] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    2.494389] pnp 00:06: [irq 4]
[    2.507624] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.513156] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    2.516170] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.520802] pnp: PnP ACPI: found 8 devices
[    2.522303] ACPI: ACPI bus type pnp unregistered
[    2.656777] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    2.658611] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    2.660995] NET: Registered protocol family 2
[    2.662899] IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
[    2.666134] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    2.679606] TCP bind hash table entries: 16384 (order: 8, 1310720 bytes)
[    2.684356] TCP: Hash tables configured (established 16384 bind 16384)
[    2.709235] TCP: reno registered
[    2.710609] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    2.712708] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    2.715243] NET: Registered protocol family 1
[    2.766790] RPC: Registered named UNIX socket transport module.
[    2.768893] RPC: Registered udp transport module.
[    2.770506] RPC: Registered tcp transport module.
[    2.772279] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.774246] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.776261] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.784194] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.788489] pci 0000:00:02.0: Boot video device
[    2.790291] PCI: CLS 0 bytes, default 64
[    3.123596] DMA-API: preallocated 32768 debug entries
[    3.125478] DMA-API: debugging enabled by kernel config
[    3.162105] Initializing RT-Tester: OK
[    3.191009] Kprobe smoke test started
[    3.373713] Kprobe smoke test passed successfully
[    3.411277] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.652188] VFS: Disk quotas dquot_6.5.2
[    3.686072] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.727419] NFS: Registering the id_resolver key type
[    3.765690] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    3.810895] ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.813850] fuse init (API version 7.18)
[    3.827988] msgmni has been set to 928
[    3.836300] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.839064] io scheduler noop registered
[    3.841268] io scheduler deadline registered
[    3.907771] io scheduler cfq registered (default)
[    3.909545] start plist test
[    3.913100] end plist test
[    3.914333] list_sort_test: start testing list_sort()
[    3.955279] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.958945] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.960994] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    3.985126] acpiphp: Slot [3] registered
[    3.987427] acpiphp: Slot [4] registered
[    3.990166] acpiphp: Slot [5] registered
[    3.992704] acpiphp: Slot [6] registered
[    4.018132] acpiphp: Slot [7] registered
[    4.020554] acpiphp: Slot [8] registered
[    4.087705] acpiphp: Slot [9] registered
[    4.090170] acpiphp: Slot [10] registered
[    4.098090] acpiphp: Slot [11] registered
[    4.100503] acpiphp: Slot [12] registered
[    4.102870] acpiphp: Slot [13] registered
[    4.128244] acpiphp: Slot [14] registered
[    4.130179] Refined TSC clocksource calibration: 2693.503 MHz.
[    4.132099] Switching to clocksource tsc
[    4.137322] acpiphp: Slot [15] registered
[    4.148321] acpiphp: Slot [16] registered
[    4.150509] acpiphp: Slot [17] registered
[    4.152730] acpiphp: Slot [18] registered
[    4.154935] acpiphp: Slot [19] registered
[    4.197806] acpiphp: Slot [20] registered
[    4.209624] acpiphp: Slot [21] registered
[    4.211810] acpiphp: Slot [22] registered
[    4.214169] acpiphp: Slot [23] registered
[    4.237866] acpiphp: Slot [24] registered
[    4.247924] acpiphp: Slot [25] registered
[    4.250158] acpiphp: Slot [26] registered
[    4.252451] acpiphp: Slot [27] registered
[    4.254696] acpiphp: Slot [28] registered
[    4.276905] acpiphp: Slot [29] registered
[    4.284176] acpiphp: Slot [30] registered
[    4.286405] acpiphp: Slot [31] registered
[    4.301689] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    4.304542] ACPI: Power Button [PWRF]
[    4.460995] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.463132] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:3)
[    4.466141] virtio-pci 0000:00:04.0: setting latency timer to 64
[    4.484209] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.486040] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:3)
[    4.500046] virtio-pci 0000:00:05.0: setting latency timer to 64
[    4.510244] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.512144] virtio-pci 0000:00:06.0: setting latency timer to 64
[    4.530204] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    4.532193] virtio-pci 0000:00:07.0: setting latency timer to 64
[    4.538051] virtio-pci 0000:00:08.0: setting latency timer to 64
[    4.548008] virtio-pci 0000:00:09.0: setting latency timer to 64
[    4.559120] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
ÿ[    4.840596] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.890023] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.912112] Non-volatile memory driver v1.3
[    4.914619] Linux agpgart interface v0.103
[    4.920309] [drm] Initialized drm 1.1.0 20060810
[    5.058944] brd: module loaded
[    5.111022] loop: module loaded
[    5.113037] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    5.114832] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    5.149012]  vda: unknown partition table
[    5.158645] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    5.160397] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    5.202693]  vdb: unknown partition table
[    5.205551] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    5.207309] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    5.253628]  vdc: unknown partition table
[    5.258657] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    5.260449] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    5.300926]  vdd: unknown partition table
[    5.303920] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    5.305710] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    5.388950]  vde: unknown partition table
[    5.398868] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    5.400676] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    5.434728]  vdf: unknown partition table
[    5.437764] lkdtm: No crash points registered, enable through debugfs
[    5.440463] Uniform Multi-Platform E-IDE driver
[    5.452177] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    5.455076] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[    5.457879] pci 0000:00:01.1: setting latency timer to 64
[    5.459634]     ide0: BM-DMA at 0xc1c0-0xc1c7
[    5.461207]     ide1: BM-DMA at 0xc1c8-0xc1cf
[    5.462770] Probing IDE interface ide0...
[    6.040960] Probing IDE interface ide1...
[    6.776248] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    7.449767] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    7.451811] hdc: MWDMA2 mode selected
[    7.453488] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    7.463943] ide1 at 0x170-0x177,0x376 on irq 15
[    7.499988] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    7.538106] ide-gd driver 1.18
[    7.540123] ide-cd driver 5.00
[    7.542515] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[    7.545421] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.658391] Loading iSCSI transport class v2.0-870.
[    7.679744] Adaptec aacraid driver 1.2-0[28900]-ms
[    7.699042] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    7.728180] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.13-k.
[    7.732273] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    7.737593] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    7.747618] megasas: 00.00.06.14-rc1 Fri. Jan. 6 17:00:00 PDT 2012
[    7.750318] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    7.757624] RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
[    7.771562] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    7.774490] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    7.776231] Copyright (c) 2007 Atheros Corporation.
[    7.789192] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    7.791565] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    7.791566]   http://www.scyld.com/network/drivers.html
[    7.807942] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    7.810745] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    7.812627] e100: Copyright(c) 1999-2006 Intel Corporation
[    7.814768] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    7.816837] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    7.818801] e1000 0000:00:03.0: setting latency timer to 64
[    8.337176] e1000 0000:00:03.0: eth0: (PCI:33MHz:32-bit) 00:00:00:00:00:ff
[    8.339228] e1000 0000:00:03.0: eth0: Intel(R) PRO/1000 Network Connection
[    8.341703] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[    8.343480] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    8.347604] igb: Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[    8.349632] igb: Copyright (c) 2007-2012 Intel Corporation.
[    8.355597] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    8.357679] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    8.368057] sky2: driver version 1.30
[    8.372953] usbcore: registered new interface driver catc
[    8.377594] usbcore: registered new interface driver kaweth
[    8.379331] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    8.387596] usbcore: registered new interface driver pegasus
[    8.397593] usbcore: registered new interface driver rtl8150
[    8.399734] usbcore: registered new interface driver asix
[    8.401788] usbcore: registered new interface driver cdc_ether
[    8.403900] usbcore: registered new interface driver cdc_eem
[    8.406671] usbcore: registered new interface driver dm9601
[    8.413719] usbcore: registered new interface driver smsc75xx
[    8.416323] usbcore: registered new interface driver smsc95xx
[    8.422740] usbcore: registered new interface driver gl620a
[    8.427664] usbcore: registered new interface driver net1080
[    8.436512] usbcore: registered new interface driver plusb
[    8.440234] usbcore: registered new interface driver rndis_host
[    8.447627] usbcore: registered new interface driver cdc_subset
[    8.507621] usbcore: registered new interface driver zaurus
[    8.516832] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    8.527617] usbcore: registered new interface driver int51x1
[    8.529909] usbcore: registered new interface driver ipheth
[    8.532194] usbcore: registered new interface driver sierra_net
[    8.534486] usbcore: registered new interface driver cdc_ncm
[    8.536379] Fusion MPT base driver 3.04.20
[    8.537976] Copyright (c) 1999-2008 LSI Corporation
[    8.539805] Fusion MPT SPI Host driver 3.04.20
[    8.560919] Fusion MPT FC Host driver 3.04.20
[    8.567605] Fusion MPT SAS Host driver 3.04.20
[    8.569849] Fusion MPT misc device (ioctl) driver 3.04.20
[    8.576466] mptctl: Registered with Fusion MPT base driver
[    8.578390] mptctl: /dev/mptctl @ (major,minor=10,220)
[    8.588074] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.590805] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    8.597629] uhci_hcd: USB Universal Host Controller Interface driver
[    8.606754] Initializing USB Mass Storage driver...
[    8.613417] usbcore: registered new interface driver usb-storage
[    8.615383] USB Mass Storage support registered.
[    8.617612] usbcore: registered new interface driver ums-alauda
[    8.620367] usbcore: registered new interface driver ums-datafab
[    8.624716] usbcore: registered new interface driver ums-freecom
[    8.627597] usbcore: registered new interface driver ums-isd200
[    8.636433] usbcore: registered new interface driver ums-jumpshot
[    8.641817] usbcore: registered new interface driver ums-sddr09
[    8.644599] usbcore: registered new interface driver ums-sddr55
[    8.647214] usbcore: registered new interface driver ums-usbat
[    8.650074] usbcore: registered new interface driver usbtest
[    8.657181] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    8.662454] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.672068] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.685071] mousedev: PS/2 mouse device common for all mice
[    8.707990] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    8.726022] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    8.745921] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    8.748376] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    8.757744] i6300esb: initialized (0xffffc90000022000). heartbeat=30 sec (nowayout=0)
[    8.761879] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    8.768548] iTCO_wdt: No device detected
[    8.770062] iTCO_vendor_support: vendor-support=0
[    8.771584] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16)
[    8.774309] watchdog: error registering /dev/watchdog (err=-16)
[    8.776108] md: linear personality registered for level -1
[    8.787902] md: raid0 personality registered for level 0
[    8.789870] md: raid1 personality registered for level 1
[    8.791818] md: raid10 personality registered for level 10
[    8.793809] md: raid6 personality registered for level 6
[    8.795802] md: raid5 personality registered for level 5
[    8.797846] md: raid4 personality registered for level 4
[    8.800179] md: multipath personality registered for level -4
[    8.802400] md: faulty personality registered for level -5
[    8.808649] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    8.818928] device-mapper: multipath: version 1.3.0 loaded
[    8.821016] device-mapper: multipath round-robin: version 1.0.0 loaded
[    8.849249] EDAC MC: Ver: 2.1.0
[    8.852277] cpuidle: using governor ladder
[    8.853710] cpuidle: using governor menu
[    8.891551] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    8.945742] usbcore: registered new interface driver usbhid
[    8.947973] usbhid: USB HID core driver
[    8.949998] oprofile: using NMI interrupt.
[    8.960307] TCP: bic registered
[    8.969089] Initializing XFRM netlink socket
[    8.972587] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[    8.975047] NET: Registered protocol family 10
[    8.980182] IPv6 over IPv4 tunneling driver
[    9.000520] NET: Registered protocol family 17
[    9.002399] 8021q: 802.1Q VLAN Support v1.8
[    9.015337] sctp: Hash tables configured (established 1638 bind 1638)
[    9.019774] Registering the dns_resolver key type
[    9.022111] 
[    9.022112] printing PIC contents
[    9.024619] ... PIC  IMR: ffff
[    9.025951] ... PIC  IRR: 9013
[    9.027276] ... PIC  ISR: 0000
[    9.036661] ... PIC ELCR: 0c00
[    9.045219] printing local APIC contents on CPU#0/0:
[    9.047154] ... APIC ID:      00000000 (0)
[    9.049059] ... APIC VERSION: 00050014
[    9.049210] ... APIC TASKPRI: 00000000 (00)
[    9.049210] ... APIC PROCPRI: 00000000
[    9.049210] ... APIC LDR: 01000000
[    9.049210] ... APIC DFR: ffffffff
[    9.049210] ... APIC SPIV: 000001ff
[    9.049210] ... APIC ISR field:
[    9.049210] 0000000000000000000000000000000000000000000000000000000000000000
[    9.049210] ... APIC TMR field:
[    9.049210] 0000000000000000000000000000000000000000000000000000000000000000
[    9.049210] ... APIC IRR field:
[    9.049210] 0000000000000000000000000000000000000000000000000000000000008000
[    9.049210] ... APIC ESR: 00000000
[    9.049210] ... APIC ICR: 000008fd
[    9.049210] ... APIC ICR2: 02000000
[    9.049210] ... APIC LVTT: 000000ef
[    9.049210] ... APIC LVTPC: 00010000
[    9.049210] ... APIC LVT0: 00010700
[    9.049210] ... APIC LVT1: 00000400
[    9.049210] ... APIC LVTERR: 000000fe
[    9.049210] ... APIC TMICT: 0003caec
[    9.049210] ... APIC TMCCT: 00000000
[    9.049210] ... APIC TDCR: 00000003
[    9.049210] 
[    9.182413] number of MP IRQ sources: 15.
[    9.183959] number of IO-APIC #2 registers: 24.
[    9.198710] testing the IO APIC.......................
[    9.200473] 
[    9.201491] IO APIC #2......
[    9.202780] .... register #00: 00000000
[    9.204286] .......    : physical APIC id: 00
[    9.217958] .......    : Delivery Type: 0
[    9.219468] .......    : LTS          : 0
[    9.220999] .... register #01: 00170011
[    9.222465] .......     : max redirection entries: 17
[    9.238252] .......     : PRQ implemented: 0
[    9.239820] .......     : IO APIC version: 11
[    9.241414] .... register #02: 00000000
[    9.242892] .......     : arbitration: 00
[    9.244411] .... IRQ redirection table:
[    9.246020]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    9.247865]  00 00  1    0    0   0   0    0    0    00
[    9.249748]  01 03  0    0    0   0   0    1    1    31
[    9.251625]  02 03  0    0    0   0   0    1    1    30
[    9.253503]  03 03  1    0    0   0   0    1    1    33
[    9.255361]  04 03  1    0    0   0   0    1    1    34
[    9.257238]  05 03  1    1    0   0   0    1    1    35
[    9.259118]  06 03  1    0    0   0   0    1    1    36
[    9.261004]  07 03  1    0    0   0   0    1    1    37
[    9.262872]  08 03  1    0    0   0   0    1    1    38
[    9.264757]  09 03  0    1    0   0   0    1    1    39
[    9.266612]  0a 03  1    1    0   0   0    1    1    3A
[    9.268492]  0b 03  1    1    0   0   0    1    1    3B
[    9.270364]  0c 03  0    0    0   0   0    1    1    3C
[    9.272246]  0d 03  1    0    0   0   0    1    1    3D
[    9.274112]  0e 03  0    0    0   0   0    1    1    3E
[    9.275972]  0f 03  0    0    0   0   0    1    1    3F
[    9.277935]  10 00  1    0    0   0   0    0    0    00
[    9.279917]  11 00  1    0    0   0   0    0    0    00
[    9.281805]  12 00  1    0    0   0   0    0    0    00
[    9.283661]  13 00  1    0    0   0   0    0    0    00
[    9.285550]  14 00  1    0    0   0   0    0    0    00
[    9.287418]  15 00  1    0    0   0   0    0    0    00
[    9.289388]  16 00  1    0    0   0   0    0    0    00
[    9.291253]  17 00  1    0    0   0   0    0    0    00
[    9.293119] IRQ to pin mappings:
[    9.295083] IRQ0 -> 0:2
[    9.296545] IRQ1 -> 0:1
[    9.297982] IRQ3 -> 0:3
[    9.299400] IRQ4 -> 0:4
[    9.300846] IRQ5 -> 0:5
[    9.302260] IRQ6 -> 0:6
[    9.303681] IRQ7 -> 0:7
[    9.305118] IRQ8 -> 0:8
[    9.306549] IRQ9 -> 0:9
[    9.307984] IRQ10 -> 0:10
[    9.309488] IRQ11 -> 0:11
[    9.311183] IRQ12 -> 0:12
[    9.312689] IRQ13 -> 0:13
[    9.314141] IRQ14 -> 0:14
[    9.315601] IRQ15 -> 0:15
[    9.317196] .................................... done.
[    9.321161] PM: Hibernation image not present or could not be loaded.
[    9.323297] registered taskstats version 1
[    9.337825] rtc-test rtc-test.0: setting system clock to 2012-11-08 02:09:44 UTC (1352340584)
[    9.341457] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    9.360806] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    9.362651] 8021q: adding VLAN 0 to HW filter on device eth0
[   11.364523] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   11.368053] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   11.380059] Sending DHCP requests ., OK
[   11.420070] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0.2.15
[   11.423497] IP-Config: Complete:
[   11.424914]      device=eth0, addr=10.0.2.15, mask=255.255.255.0, gw=10.0.2.2
[   11.427052]      host=kvm_bisect3, domain=, nis-domain=(none)
[   11.430097]      bootserver=10.0.2.2, rootserver=10.239.97.14, rootpath=
[   11.432946] md: Waiting for all devices to be available before autodetect
[   11.435032] md: If you don't use raid, use raid=noautodetect
[   11.469650] md: Autodetecting RAID arrays.
[   11.471230] md: Scanned 0 and added 0 devices.
[   11.473055] md: autorun ...
[   11.474340] md: ... autorun DONE.
[   15.458641] VFS: Mounted root (nfs filesystem) on device 0:12.
[   15.460656] debug: unmapping init memory ffffffff81c6f000..ffffffff81f11000
[   15.962971] modprobe used greatest stack depth: 3456 bytes left
[   22.060333] eth0: no IPv6 routers present
[   26.622258] S20pidentd used greatest stack depth: 3184 bytes left
[   28.333637] S36udev-mtab used greatest stack depth: 3040 bytes left
[   42.748808] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   42.759095] NFSD: starting 90-second grace period
[   45.244298] Adding 307196k swap on /dev/vda.  Priority:-1 extents:1 across:307196k 
[   45.541560] event trace: Could not enable event function
[   45.632213] Unregister pv shared memory for cpu 1
[   45.634547] CPU0 attaching NULL sched-domain.
[   45.637411] CPU1 attaching NULL sched-domain.
[   45.639362] CPU0 attaching NULL sched-domain.
[   45.844688] ------------[ cut here ]------------
[   45.845482] WARNING: at /c/wfg/mm/kernel/rcutree.c:1548 rcu_do_batch+0x17e/0x60c()
[   45.846690] Hardware name: Bochs
[   45.847198] Modules linked in:
[   45.847726] Pid: 7, comm: migration/1 Not tainted 3.4.0-rc4-bisect3-00008-gb1420f1 #17
[   45.848622] Call Trace:
[   45.848622]  <IRQ>  [<ffffffff81030b05>] warn_slowpath_common+0x83/0x9c
[   45.848622]  [<ffffffff81030b38>] warn_slowpath_null+0x1a/0x1c
[   45.848622]  [<ffffffff8109ebf2>] rcu_do_batch+0x17e/0x60c
[   45.848622]  [<ffffffff8109ea5c>] ? check_for_new_grace_period+0xe3/0xfb
[   45.848622]  [<ffffffff8108032b>] ? trace_hardirqs_on_caller+0x172/0x181
[   45.848622]  [<ffffffff81080347>] ? trace_hardirqs_on+0xd/0xf
[   45.848622]  [<ffffffff810a0332>] __rcu_process_callbacks+0x120/0x163
[   45.848622]  [<ffffffff810a03d4>] rcu_process_callbacks+0x5f/0xf4
[   45.848622]  [<ffffffff81036ee5>] __do_softirq+0xe9/0x211
[   45.848622]  [<ffffffff8101bc25>] ? lapic_next_event+0x1d/0x21
[   45.848622]  [<ffffffff8179b1ec>] call_softirq+0x1c/0x30
[   45.848622]  [<ffffffff81003f80>] do_softirq+0x4a/0xa6
[   45.848622]  [<ffffffff8103729e>] irq_exit+0x51/0xbc
[   45.848622]  [<ffffffff8179b85f>] smp_apic_timer_interrupt+0x8b/0x99
[   45.848622]  [<ffffffff8179a7ef>] apic_timer_interrupt+0x6f/0x80
[   45.848622]  <EOI>  [<ffffffff810616a8>] ? local_clock+0x1d/0x5a
[   45.848622]  [<ffffffff81098317>] ? stop_machine_cpu_stop+0x104/0x119
[   45.848622]  [<ffffffff81097fb5>] cpu_stopper_thread+0xdd/0x17d
[   45.848622]  [<ffffffff81098213>] ? queue_stop_cpus_work+0x130/0x130
[   45.848622]  [<ffffffff81792c3c>] ? _raw_spin_unlock_irqrestore+0x47/0x65
[   45.848622]  [<ffffffff810802de>] ? trace_hardirqs_on_caller+0x125/0x181
[   45.848622]  [<ffffffff81080347>] ? trace_hardirqs_on+0xd/0xf
[   45.848622]  [<ffffffff81097ed8>] ? cpu_stop_signal_done+0x2c/0x2c
[   45.848622]  [<ffffffff81050bdd>] kthread+0x9a/0xa2
[   45.848622]  [<ffffffff8179b0f4>] kernel_thread_helper+0x4/0x10
[   45.848622]  [<ffffffff817930b0>] ? retint_restore_args+0x13/0x13
[   45.848622]  [<ffffffff81050b43>] ? __init_kthread_worker+0x5a/0x5a
[   45.848622]  [<ffffffff8179b0f0>] ? gs_change+0x13/0x13
[   45.848622] ---[ end trace ae22fa67ca0ad523 ]---
[   45.848622] ------------[ cut here ]------------
[   45.848622] WARNING: at /c/wfg/mm/kernel/rcutree.c:1879 __call_rcu+0xcd/0x2e3()
[   45.848622] Hardware name: Bochs
[   45.848622] Modules linked in:
[   45.848622] Pid: 7, comm: migration/1 Tainted: G        W    3.4.0-rc4-bisect3-00008-gb1420f1 #17
[   45.911816] Call Trace:
[   45.911816]  <IRQ>  [<ffffffff81030b05>] warn_slowpath_common+0x83/0x9c
[   45.911816]  [<ffffffff81056518>] ? put_cred_rcu+0xaf/0xaf
[   45.911816]  [<ffffffff81030b38>] warn_slowpath_null+0x1a/0x1c
[   45.911816]  [<ffffffff8109ffae>] __call_rcu+0xcd/0x2e3
[   45.911816]  [<ffffffff810afb6b>] ? trace_nowake_buffer_unlock_commit+0x39/0x42
[   45.911816]  [<ffffffff810a0210>] call_rcu_sched+0x17/0x19
[   45.911816]  [<ffffffff81056467>] release_tgcred.isra.6+0x23/0x25
[   45.911816]  [<ffffffff810564df>] put_cred_rcu+0x76/0xaf
[   45.911816]  [<ffffffff8109eda8>] rcu_do_batch+0x334/0x60c
[   45.911816]  [<ffffffff8109ea5c>] ? check_for_new_grace_period+0xe3/0xfb
[   45.911816]  [<ffffffff810a0332>] __rcu_process_callbacks+0x120/0x163
[   45.911816]  [<ffffffff810a03d4>] rcu_process_callbacks+0x5f/0xf4
[   45.911816]  [<ffffffff81036ee5>] __do_softirq+0xe9/0x211
[   45.911816]  [<ffffffff8101bc25>] ? lapic_next_event+0x1d/0x21
[   45.911816]  [<ffffffff8179b1ec>] call_softirq+0x1c/0x30
[   45.911816]  [<ffffffff81003f80>] do_softirq+0x4a/0xa6
[   45.911816]  [<ffffffff8103729e>] irq_exit+0x51/0xbc
[   45.911816]  [<ffffffff8179b85f>] smp_apic_timer_interrupt+0x8b/0x99
[   45.911816]  [<ffffffff8179a7ef>] apic_timer_interrupt+0x6f/0x80
[   45.911816]  <EOI>  [<ffffffff810616a8>] ? local_clock+0x1d/0x5a
[   45.911816]  [<ffffffff81098317>] ? stop_machine_cpu_stop+0x104/0x119
[   45.911816]  [<ffffffff81097fb5>] cpu_stopper_thread+0xdd/0x17d
[   45.911816]  [<ffffffff81098213>] ? queue_stop_cpus_work+0x130/0x130
[   45.911816]  [<ffffffff81792c3c>] ? _raw_spin_unlock_irqrestore+0x47/0x65
[   45.911816]  [<ffffffff810802de>] ? trace_hardirqs_on_caller+0x125/0x181
[   45.911816]  [<ffffffff81080347>] ? trace_hardirqs_on+0xd/0xf
[   45.911816]  [<ffffffff81097ed8>] ? cpu_stop_signal_done+0x2c/0x2c
[   45.911816]  [<ffffffff81050bdd>] kthread+0x9a/0xa2
[   45.911816]  [<ffffffff8179b0f4>] kernel_thread_helper+0x4/0x10
[   45.911816]  [<ffffffff817930b0>] ? retint_restore_args+0x13/0x13
[   45.911816]  [<ffffffff81050b43>] ? __init_kthread_worker+0x5a/0x5a
[   45.911816]  [<ffffffff8179b0f0>] ? gs_change+0x13/0x13
[   45.911816] ---[ end trace ae22fa67ca0ad524 ]---
[   45.917769] CPU 1 is now offline
[   45.917772] lockdep: fixing up alternatives.
[   45.917782] SMP alternatives: switching to UP code
[   46.243618] lockdep: fixing up alternatives.
[   46.306847] SMP alternatives: switching to SMP code
[   46.343352] Booting Node 0 Processor 1 APIC 0x1
[   45.911816] masked ExtINT on CPU#1
[   46.407219] CPU0 attaching NULL sched-domain.
[   46.409207] CPU0 attaching sched-domain:
[   46.410817]  domain 0: span 0-1 level CPU
[   46.412534]   groups: 0 (cpu_power = 1009) 1 (cpu_power = 1023)
[   46.415173] CPU1 attaching sched-domain:
[   46.416809]  domain 0: span 0-1 level CPU
[   46.418503]   groups: 1 (cpu_power = 1023) 0 (cpu_power = 1009)
[   46.437620] KVM setup async PF for cpu 1
[   46.437620] kvm-stealtime: cpu 1, msr 1f40d180
[   47.527065] Unregister pv shared memory for cpu 1
[   47.529333] CPU0 attaching NULL sched-domain.
[   47.530864] CPU1 attaching NULL sched-domain.
[   47.532787] CPU0 attaching NULL sched-domain.
[   47.559633] CPU 1 is now offline
[   47.561126] lockdep: fixing up alternatives.
[   47.562744] SMP alternatives: switching to UP code
[   49.181576] mount.nfs used greatest stack depth: 2992 bytes left

--UugvWAfsgieZRqgk--

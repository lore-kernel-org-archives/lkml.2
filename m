Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2LSJ5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 04:57:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:53548 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab2LSJ5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:57:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="264335396"
Date: Wed, 19 Dec 2012 17:56:32 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at block/genhd.c:1574 disk_clear_events()
Message-ID: <20121219095632.GA27488@localhost>
References: <20121219095241.GA27310@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219095241.GA27310@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha,

However note that this warning does not show up in next-20121219.

Thanks,
Fengguang

On Wed, Dec 19, 2012 at 05:52:41PM +0800, Fengguang Wu wrote:
> Hi Sasha,
> 
> I got the below warning and it's bisected to
> 
> commit 42f8570f437b65aaf3ef176a38ad7d7fc5847d8b
> Author: Sasha Levin <sasha.levin@oracle.com>
> Date:   Mon Dec 17 10:01:23 2012 -0500
> 
>     workqueue: use new hashtable implementation
> 
> 
> [   89.243805] write_dev_root_ (3265) used greatest stack depth: 2704 bytes left
> [   89.666207] ------------[ cut here ]------------
> [   89.667098] WARNING: at /c/kernel-tests/src/stable/block/genhd.c:1574 disk_clear_events+0xcf/0x108()
> [   89.668040] Hardware name: Bochs
> [   89.668040] Modules linked in:
> [   89.668040] Pid: 3328, comm: ata_id Not tainted 3.7.0-01930-gbff6343 #1167
> [   89.668040] Call Trace:
> [   89.668040]  [<ffffffff810997c4>] warn_slowpath_common+0x83/0x9c
> [   89.671922]  [<ffffffff810997f7>] warn_slowpath_null+0x1a/0x1c
> [   89.671922]  [<ffffffff816aea77>] disk_clear_events+0xcf/0x108
> [   89.671922]  [<ffffffff811bd8be>] check_disk_change+0x27/0x59
> [   89.671922]  [<ffffffff822e48e2>] cdrom_open+0x49/0x68b
> [   89.671922]  [<ffffffff82c12c07>] ? __mutex_unlock_slowpath+0x116/0x126
> [   89.671922]  [<ffffffff810e9868>] ? trace_hardirqs_on_caller+0x123/0x17f
> [   89.671922]  [<ffffffff82c12c0f>] ? __mutex_unlock_slowpath+0x11e/0x126
> [   89.671922]  [<ffffffff81ab0291>] idecd_open+0x88/0xb7
> [   89.671922]  [<ffffffff811be58f>] __blkdev_get+0x102/0x3ec
> [   89.671922]  [<ffffffff811bea08>] blkdev_get+0x18f/0x30f
> [   89.671922]  [<ffffffff810e92e4>] ? lock_release+0x17d/0x1cd
> [   89.671922]  [<ffffffff811beb88>] ? blkdev_get+0x30f/0x30f
> [   89.671922]  [<ffffffff82c14fe2>] ? _raw_spin_unlock+0x28/0x3b
> [   89.671922]  [<ffffffff811beb88>] ? blkdev_get+0x30f/0x30f
> [   89.671922]  [<ffffffff811bebfd>] blkdev_open+0x75/0x80
> [   89.671922]  [<ffffffff8118f510>] do_dentry_open+0x1ea/0x295
> [   89.671922]  [<ffffffff8118f5f0>] finish_open+0x35/0x41
> [   89.671922]  [<ffffffff8119c720>] do_last+0x878/0xa25
> [   89.671922]  [<ffffffff8119a308>] ? inode_permission+0x45/0x47
> [   89.671922]  [<ffffffff8119c993>] path_openat+0xc6/0x333
> [   89.671922]  [<ffffffff810e611a>] ? lock_release_holdtime.part.22+0x4e/0x55
> [   89.671922]  [<ffffffff8119cf37>] do_filp_open+0x38/0x86
> [   89.671922]  [<ffffffff811a6b4e>] ? spin_unlock+0x9/0xb
> [   89.671922]  [<ffffffff811a779c>] ? __alloc_fd+0xf3/0x104
> [   89.671922]  [<ffffffff81190170>] do_sys_open+0x6c/0xf9
> [   89.671922]  [<ffffffff8119021e>] sys_open+0x21/0x23
> [   89.671922]  [<ffffffff82c1c3d9>] system_call_fastpath+0x16/0x1b
> 
> Thanks,
> Fengguang
> 

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.7.0-01930-gbff6343 (kbuild@bee) (gcc version 4.7.2 (Debian 4.7.2-4) ) #1167 SMP Wed Dec 19 04:07:23 CST 2012
> [    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=devel-bee-x86_64-2012-12-19-03-23 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=vmlinuz-2012-12-19-04-08-07-devel-bee-x86_64-2012-12-19-03-23:bff6343-bff6343-x86_64-allyesdebian-8-fat BOOT_IMAGE=kernel-tests/kernels/x86_64-allyesdebian/bff6343/vmlinuz-3.7.0-01930-gbff6343
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x1fffe max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
> [    0.000000]   mpc: fdac0-fdbe4
> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
> [    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x1fffdfff]
> [    0.000000]  [mem 0x00000000-0x1fffdfff] page 4k
> [    0.000000] kernel direct mapping tables up to 0x1fffdfff @ [mem 0x1fefc000-0x1fffdfff]
> [    0.000000] log_buf_len: 8388608
> [    0.000000] early log buf free: 127856(97%)
> [    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 000000001fffff40 00040
> [    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001fffdfff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x1fffdfff]
> [    0.000000]   NODE_DATA [mem 0x1f6f7000-0x1f6fbfff]
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:1f6ef001, boot clock
> [    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e600000-ffff88001edfffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00010000-0x00092fff]
> [    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
> [    0.000000] On node 0 totalpages: 130945
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 6 pages reserved
> [    0.000000]   DMA zone: 3901 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 1984 pages used for memmap
> [    0.000000]   DMA32 zone: 124990 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
> [    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> [    0.000000] e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 478 pages/cpu @ffff88001f200000 s1926616 r8192 d23080 u2097152
> [    0.000000] pcpu-alloc: s1926616 r8192 d23080 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] kvm-clock: cpu 0, msr 0:1f6ef001, primary cpu clock
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1f20e2c0
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 128891
> [    0.000000] Policy zone: DMA32
> [    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=devel-bee-x86_64-2012-12-19-03-23 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=vmlinuz-2012-12-19-04-08-07-devel-bee-x86_64-2012-12-19-03-23:bff6343-bff6343-x86_64-allyesdebian-8-fat BOOT_IMAGE=kernel-tests/kernels/x86_64-allyesdebian/bff6343/vmlinuz-3.7.0-01930-gbff6343
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 436420k/524280k available (28808k kernel code, 500k absent, 87360k reserved, 19879k data, 3888k init)
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] NR_IRQS:33024 nr_irqs:512 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6367 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> [    0.000000] ----------------------------------------------------------------------------
> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
> [    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
> [    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
> [    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq read-recursion/123:  ok  |
> [    0.000000]       soft-irq read-recursion/123:  ok  |
> [    0.000000]       hard-irq read-recursion/132:  ok  |
> [    0.000000]       soft-irq read-recursion/132:  ok  |
> [    0.000000]       hard-irq read-recursion/213:  ok  |
> [    0.000000]       soft-irq read-recursion/213:  ok  |
> [    0.000000]       hard-irq read-recursion/231:  ok  |
> [    0.000000]       soft-irq read-recursion/231:  ok  |
> [    0.000000]       hard-irq read-recursion/312:  ok  |
> [    0.000000]       soft-irq read-recursion/312:  ok  |
> [    0.000000]       hard-irq read-recursion/321:  ok  |
> [    0.000000]       soft-irq read-recursion/321:  ok  |
> [    0.000000] -------------------------------------------------------
> [    0.000000] Good, all 218 testcases passed! |
> [    0.000000] ---------------------------------
> [    0.000000] ODEBUG: 0 of 0 active objects replaced
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 3199.986 MHz processor
> [    0.008000] Calibrating delay loop (skipped) preset value.. 6399.97 BogoMIPS (lpj=12799944)
> [    0.008000] pid_max: default: 32768 minimum: 301
> [    0.008173] Security Framework initialized
> [    0.008849] AppArmor: AppArmor disabled by boot time parameter
> [    0.009987] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.011440] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.012248] Mount-cache hash table entries: 256
> [    0.014992] Initializing cgroup subsys devices
> [    0.016019] Initializing cgroup subsys freezer
> [    0.016746] Initializing cgroup subsys net_cls
> [    0.017460] Initializing cgroup subsys blkio
> [    0.018461] mce: CPU supports 10 MCE banks
> [    0.019189] numa_add_cpu cpu 0 node 0: mask now 0
> [    0.020010] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.020010] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.020010] tlb_flushall_shift: 6
> [    0.022094] debug: unmapping init [mem 0xffffffff8435a000-0xffffffff84365fff]
> [    0.024831] ACPI: Core revision 20121018
> [    0.029245] ftrace: allocating 111074 entries in 434 pages
> [    0.052469] Getting VERSION: 50014
> [    0.053077] Getting VERSION: 50014
> [    0.053659] Getting ID: 0
> [    0.054158] Getting ID: ff000000
> [    0.054718] Getting LVT0: 8700
> [    0.055266] Getting LVT1: 8400
> [    0.055853] enabled ExtINT on CPU#0
> [    0.056704] ENABLING IO-APIC IRQs
> [    0.057280] init IO_APIC IRQs
> [    0.057816]  apic 2 pin 0 not connected
> [    0.058461] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.060025] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.061271] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.062521] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.064023] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.065268] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.066496] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.067724] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.068022] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.069248] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.070485] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.072022] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.073272] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.074520] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.076023] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.080019]  apic 2 pin 16 not connected
> [    0.080661]  apic 2 pin 17 not connected
> [    0.081293]  apic 2 pin 18 not connected
> [    0.081927]  apic 2 pin 19 not connected
> [    0.082572]  apic 2 pin 20 not connected
> [    0.083203]  apic 2 pin 21 not connected
> [    0.084005]  apic 2 pin 22 not connected
> [    0.084643]  apic 2 pin 23 not connected
> [    0.085412] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.086365] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.088005] Using local APIC timer interrupts.
> [    0.088005] calibrating APIC timer ...
> [    0.092000] ... lapic delta = 6249981
> [    0.092000] ... PM-Timer delta = 357954
> [    0.092000] ... PM-Timer result ok
> [    0.092000] ..... delta 6249981
> [    0.092000] ..... mult: 268434639
> [    0.092000] ..... calibration result: 3999987
> [    0.092000] ..... CPU clock speed is 3200.0443 MHz.
> [    0.092000] ..... host bus clock speed is 999.3987 MHz.
> [    0.092054] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.095475] Testing tracer nop: PASSED
> [    0.096922] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.100121] SMP alternatives: lockdep: fixing up alternatives
> [    0.101111] smpboot: Booting Node   0, Processors  #1 OK
> [    0.008000] kvm-clock: cpu 1, msr 0:1f6ef041, secondary cpu clock
> [    0.008000] masked ExtINT on CPU#1
> [    0.008000] numa_add_cpu cpu 1 node 0: mask now 0-1
> [    0.120101] Brought up 2 CPUs
> [    0.120083] KVM setup async PF for cpu 1
> [    0.120083] kvm-stealtime: cpu 1, msr 1f40e2c0
> [    0.124010] ----------------
> [    0.124532] | NMI testsuite:
> [    0.125044] --------------------
> [    0.125597]   remote IPI:  ok  |
> [    0.126053]    local IPI:  ok  |
> [    0.128014] --------------------
> [    0.128571] Good, all   2 testcases passed! |
> [    0.129250] ---------------------------------
> [    0.129930] smpboot: Total of 2 processors activated (12799.94 BogoMIPS)
> [    0.131330] CPU0 attaching sched-domain:
> [    0.131972]  domain 0: span 0-1 level CPU
> [    0.132399]   groups: 0 (cpu_power = 1023) 1 (cpu_power = 1023)
> [    0.133613] CPU1 attaching sched-domain:
> [    0.134243]  domain 0: span 0-1 level CPU
> [    0.134952]   groups: 1 (cpu_power = 1023) 0 (cpu_power = 1023)
> [    0.136800] devtmpfs: initialized
> [    0.152022] Testing tracer function: PASSED
> [    0.505956] Testing dynamic ftrace: PASSED
> [    1.000348] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 20) (2 2 4 1 209) PASSED
> [    1.682790] Testing dynamic ftrace ops #2: (1 0 1 31 0) (1 1 2 216 0) (2 1 3 2 29) (2 2 4 210 238) PASSED
> [    2.375070] Testing ftrace recursion: PASSED
> [    2.429364] Testing ftrace recursion safe: PASSED
> [    2.482477] Testing ftrace regs: PASSED
> [    2.544034] Testing tracer irqsoff: PASSED
> [    3.040035] Testing tracer wakeup: ret = 0
> [    3.636072] ftrace-test (22) used greatest stack depth: 6352 bytes left
> [    3.640027] PASSED
> [    3.648020] Testing tracer wakeup_rt: ret = 0
> [    4.224020] PASSED
> [    4.228021] Testing tracer function_graph: PASSED
> [    4.827012] xor: automatically using best checksumming function:
> [    4.865534]    generic_sse:   263.000 MB/sec
> [    4.866203] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    4.867939] regulator-dummy: no parameters
> [    4.868821] NET: Registered protocol family 16
> [    4.874598] ACPI: bus type pci registered
> [    4.875428] dca service started, version 1.12.1
> [    4.876100] PCI: Using configuration type 1 for base access
> [    4.956841] bio: create slab <bio-0> at 0
> [    5.025485] raid6: sse2x1    8131 MB/s
> [    5.093491] raid6: sse2x2    9424 MB/s
> [    5.161447] raid6: sse2x4   10491 MB/s
> [    5.162061] raid6: using algorithm sse2x4 (10491 MB/s)
> [    5.162856] raid6: using intx1 recovery algorithm
> [    5.163806] ACPI: Added _OSI(Module Device)
> [    5.164007] ACPI: Added _OSI(Processor Device)
> [    5.164697] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    5.165450] ACPI: Added _OSI(Processor Aggregator Device)
> [    5.169166] ACPI: EC: Look up EC in DSDT
> [    5.177932] ACPI: Interpreter enabled
> [    5.178575] ACPI: (supports S0 S3 S4 S5)
> [    5.179589] ACPI: Using IOAPIC for interrupt routing
> [    5.195561] ACPI: No dock devices found.
> [    5.196006] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> [    5.197527] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    5.198437] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    5.201073] pci_root PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
> [    5.202344] pci_root PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
> [    5.203716] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> [    5.204006] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
> [    5.205180] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> [    5.206425] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
> [    5.208015] PCI: root bus 00: using default resources
> [    5.208789] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
> [    5.210692] PCI host bridge to bus 0000:00
> [    5.212006] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    5.212834] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> [    5.213733] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
> [    5.214800] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    5.216069] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    5.217465] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    5.220160] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
> [    5.221847] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    5.223120] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    5.224016] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    5.225239] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    5.228454] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
> [    5.230389] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
> [    5.236959] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
> [    5.238222] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    5.240009] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
> [    5.241564] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
> [    5.245639] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
> [    5.246737] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
> [    5.248005] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
> [    5.251328] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
> [    5.252719] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
> [    5.254211] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
> [    5.258938] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
> [    5.260374] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
> [    5.261825] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
> [    5.266290] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
> [    5.268006] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
> [    5.269496] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
> [    5.273958] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
> [    5.275560] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
> [    5.276638] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
> [    5.281325] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
> [    5.282886] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
> [    5.284663] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
> [    5.288967] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
> [    5.290566] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
> [    5.292006] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
> [    5.296615] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
> [    5.297864] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
> [    5.301177] ACPI: Invalid Power Resource to register!
> [    5.301984] ACPI: Invalid Power Resource to register!
> [    5.302800] ACPI: Invalid Power Resource to register!
> [    5.303614] ACPI: Invalid Power Resource to register!
> [    5.304030] ACPI: Invalid Power Resource to register!
> [    5.304803] ACPI: Invalid Power Resource to register!
> [    5.305580] ACPI: Invalid Power Resource to register!
> [    5.306399] ACPI: Invalid Power Resource to register!
> [    5.307210] ACPI: Invalid Power Resource to register!
> [    5.308028] ACPI: Invalid Power Resource to register!
> [    5.308802] ACPI: Invalid Power Resource to register!
> [    5.309608] ACPI: Invalid Power Resource to register!
> [    5.310416] ACPI: Invalid Power Resource to register!
> [    5.311229] ACPI: Invalid Power Resource to register!
> [    5.312263] ACPI _OSC control for PCIe not granted, disabling ASPM
> [    5.337784] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    5.339207] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    5.340642] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    5.342019] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    5.343451] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
> [    5.345715] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    5.346972] vgaarb: loaded
> [    5.347507] vgaarb: bridge control possible 0000:00:02.0
> [    5.348504] tps65010: version 2 May 2005
> [    5.384082] tps65010: no chip?
> [    5.385696] SCSI subsystem initialized
> [    5.386355] ACPI: bus type scsi registered
> [    5.388127] libata version 3.00 loaded.
> [    5.388750] ACPI: bus type usb registered
> [    5.389087] usbcore: registered new interface driver usbfs
> [    5.392006] usbcore: registered new interface driver hub
> [    5.392096] usbcore: registered new device driver usb
> [    5.400315] pps_core: LinuxPPS API ver. 1 registered
> [    5.401062] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    5.402413] PTP clock support registered
> [    5.404361] wmi: Mapper loaded
> [    5.405253] Advanced Linux Sound Architecture Driver Initialized.
> [    5.406127] PCI: Using ACPI for IRQ routing
> [    5.406127] PCI: pci_cache_line_size set to 64 bytes
> [    5.408006] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
> [    5.408006] e820: reserve RAM buffer [mem 0x1fffe000-0x1fffffff]
> [    5.408429] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
> [    5.409719] NET: Registered protocol family 23
> [    5.410628] Bluetooth: Core ver 2.16
> [    5.411275] NET: Registered protocol family 31
> [    5.411963] Bluetooth: HCI device and connection manager initialized
> [    5.412045] Bluetooth: HCI socket layer initialized
> [    5.412807] Bluetooth: L2CAP socket layer initialized
> [    5.413696] Bluetooth: SCO socket layer initialized
> [    5.414438] NET: Registered protocol family 8
> [    5.416004] NET: Registered protocol family 20
> [    5.417226] cfg80211: Calling CRDA to update world regulatory domain
> [    5.420600] nfc: nfc_init: NFC Core ver 0.1
> [    5.421353] NET: Registered protocol family 39
> [    5.424006] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    5.424006] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    5.424551] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
> [    5.428262] Switching to clocksource kvm-clock
> [    5.717063] FS-Cache: Loaded
> [    5.717887] CacheFiles: Loaded
> [    5.718525] pnp: PnP ACPI init
> [    5.719112] ACPI: bus type pnp registered
> [    5.719843] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    5.721183] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    5.722191] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    5.723490] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    5.724504] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    5.725801] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    5.726812] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    5.728007] pnp 00:03: [dma 2]
> [    5.728663] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    5.729700] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    5.730989] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    5.732005] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    5.733317] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    5.734762] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
> [    5.736039] pnp: PnP ACPI: found 7 devices
> [    5.736680] ACPI: ACPI bus type pnp unregistered
> [    5.753492] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
> [    5.754281] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
> [    5.755784] NET: Registered protocol family 2
> [    5.757919] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
> [    5.759066] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
> [    5.760409] TCP: Hash tables configured (established 4096 bind 4096)
> [    5.761399] TCP: reno registered
> [    5.761984] UDP hash table entries: 256 (order: 3, 49152 bytes)
> [    5.762905] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
> [    5.764498] NET: Registered protocol family 1
> [    5.766198] RPC: Registered named UNIX socket transport module.
> [    5.767053] RPC: Registered udp transport module.
> [    5.767766] RPC: Registered tcp transport module.
> [    5.768506] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    5.769387] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    5.770220] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    5.771058] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    5.771930] pci 0000:00:02.0: Boot video device
> [    5.772752] PCI: CLS 0 bytes, default 64
> [    5.814702] DMA-API: preallocated 32768 debug entries
> [    5.815443] DMA-API: debugging enabled by kernel config
> [    5.818238] kvm: no hardware support
> [    5.818872] has_svm: not amd
> [    5.819366] kvm: no hardware support
> [    5.820239] Machine check injector initialized
> [    5.822020] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
> [    5.822908] microcode: CPU1 sig=0xf61, pf=0x1, revision=0x1
> [    5.823879] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    5.825774] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
> [    5.827127] cryptomgr_test (35) used greatest stack depth: 5888 bytes left
> [    5.828238] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
> [    5.829929] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
> [    5.833874] Initializing RT-Tester: OK
> [    5.834708] audit: initializing netlink socket (disabled)
> [    5.835588] type=2000 audit(1355861553.832:1): initialized
> [    5.921482] Kprobe smoke test started
> [    6.005717] Kprobe smoke test passed successfully
> [    6.008516] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    6.011585] VFS: Disk quotas dquot_6.5.2
> [    6.012374] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    6.015026] DLM installed
> [    6.017523] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> [    6.021474] FS-Cache: Netfs 'nfs' registered for caching
> [    6.023279] NFS: Registering the id_resolver key type
> [    6.024174] Key type id_resolver registered
> [    6.024836] Key type id_legacy registered
> [    6.025489] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [    6.028629] FS-Cache: Netfs 'cifs' registered for caching
> [    6.030207] Key type cifs.spnego registered
> [    6.030919] Key type cifs.idmap registered
> [    6.031675] NTFS driver 2.1.30 [Flags: R/W].
> [    6.032779] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
> [    6.033633] jffs2: version 2.2. (NAND) (SUMMARY)  
> [    6.035703] ROMFS MTD (C) 2007 Red Hat, Inc.
> [    6.036541] QNX4 filesystem 0.2.3 registered.
> [    6.037508] fuse init (API version 7.20)
> [    6.038958] JFS: nTxBlock = 3409, nTxLock = 27276
> [    6.043343] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> [    6.046643] 9p: Installing v9fs 9p2000 file system support
> [    6.047534] FS-Cache: Netfs '9p' registered for caching
> [    6.048626] NILFS version 2 loaded
> [    6.049168] BeFS version: 0.9.3
> [    6.049860] OCFS2 1.5.0
> [    6.050909] ocfs2: Registered cluster interface o2cb
> [    6.051900] ocfs2: Registered cluster interface user
> [    6.052681] OCFS2 DLMFS 1.5.0
> [    6.053539] OCFS2 User DLM kernel interface loaded
> [    6.054227] OCFS2 Node Manager 1.5.0
> [    6.055429] OCFS2 DLM 1.5.0
> [    6.057320] Btrfs loaded
> [    6.059078] GFS2 installed
> [    6.059981] ceph: loaded (mds proto 32)
> [    6.060636] msgmni has been set to 852
> [    6.062108] alg: No test for cipher_null (cipher_null-generic)
> [    6.063135] alg: No test for ecb(cipher_null) (ecb-cipher_null)
> [    6.064240] alg: No test for compress_null (compress_null-generic)
> [    6.065319] alg: No test for digest_null (digest_null-generic)
> [    6.066426] cryptomgr_test (70) used greatest stack depth: 5504 bytes left
> [    6.068319] cryptomgr_test (74) used greatest stack depth: 5312 bytes left
> [    6.072930] alg: No test for fcrypt (fcrypt-generic)
> [    6.076470] cryptomgr_test (101) used greatest stack depth: 4992 bytes left
> [    6.080558] alg: No test for stdrng (krng)
> [    6.089081] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
> [    6.090196] NET: Registered protocol family 38
> [    6.090925] async_tx: api initialized (async)
> [    6.091780] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
> [    6.093106] io scheduler noop registered
> [    6.093772] io scheduler deadline registered
> [    6.094625] io scheduler cfq registered (default)
> [    6.096830] list_sort_test: start testing list_sort()
> [    6.099168] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    6.100108] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    6.101030] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
> [    6.102065] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
> [    6.103238] cpcihp_generic: not configured, disabling.
> [    6.104151] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [    6.105096] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    6.106466] acpiphp: Slot [3] registered
> [    6.107213] acpiphp: Slot [4] registered
> [    6.107980] acpiphp: Slot [5] registered
> [    6.108756] acpiphp: Slot [6] registered
> [    6.109511] acpiphp: Slot [7] registered
> [    6.110225] acpiphp: Slot [8] registered
> [    6.110957] acpiphp: Slot [9] registered
> [    6.111685] acpiphp: Slot [10] registered
> [    6.112454] acpiphp: Slot [11] registered
> [    6.113191] acpiphp: Slot [12] registered
> [    6.113956] acpiphp: Slot [13] registered
> [    6.114687] acpiphp: Slot [14] registered
> [    6.115412] acpiphp: Slot [15] registered
> [    6.116196] acpiphp: Slot [16] registered
> [    6.116943] acpiphp: Slot [17] registered
> [    6.117714] acpiphp: Slot [18] registered
> [    6.118451] acpiphp: Slot [19] registered
> [    6.119182] acpiphp: Slot [20] registered
> [    6.119952] acpiphp: Slot [21] registered
> [    6.120705] acpiphp: Slot [22] registered
> [    6.121439] acpiphp: Slot [23] registered
> [    6.122200] acpiphp: Slot [24] registered
> [    6.122953] acpiphp: Slot [25] registered
> [    6.130317] acpiphp: Slot [26] registered
> [    6.131063] acpiphp: Slot [27] registered
> [    6.131829] acpiphp: Slot [28] registered
> [    6.132585] acpiphp: Slot [29] registered
> [    6.133321] acpiphp: Slot [30] registered
> [    6.134093] acpiphp: Slot [31] registered
> [    6.138038] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
> [    6.139865] VIA Graphics Integration Chipset framebuffer 2.4 initializing
> [    6.141294] vmlfb: initializing
> [    6.141958] Could not find Carillo Ranch MCH device.
> [    6.142879] no IO addresses supplied
> [    6.143675] hgafb: HGA card not detected.
> [    6.144336] hgafb: probe of hgafb.0 failed with error -22
> [    6.145358] usbcore: registered new interface driver udlfb
> [    6.147240] uvesafb: failed to execute /sbin/v86d
> [    6.147965] uvesafb: make sure that the v86d helper is installed and executable
> [    6.149127] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
> [    6.150082] uvesafb: vbe_init() failed with -22
> [    6.150785] uvesafb: probe of uvesafb.0 failed with error -22
> [    6.152114] ipmi message handler version 39.2
> [    6.152811] ipmi device interface
> [    6.153503] IPMI System Interface driver.
> [    6.154272] ipmi_si: Adding default-specified kcs state machine
> [    6.155197] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> [    6.156684] ipmi_si: Interface detection failed
> [    6.157534] ipmi_si: Adding default-specified smic state machine
> [    6.158464] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
> [    6.159904] ipmi_si: Interface detection failed
> [    6.160720] ipmi_si: Adding default-specified bt state machine
> [    6.161664] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
> [    6.163082] ipmi_si: Interface detection failed
> [    6.164255] ipmi_si: Unable to find any System Interface(s)
> [    6.165080] IPMI Watchdog: driver initialized
> [    6.165788] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
> [    6.167244] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    6.168471] ACPI: Power Button [PWRF]
> [    6.181031] GHES: HEST is not enabled!
> [    6.181675] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    6.183197] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
> [    6.184068] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:3)
> [    6.185353] virtio-pci 0000:00:05.0: setting latency timer to 64
> [    6.187109] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> [    6.187969] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:3)
> [    6.189260] virtio-pci 0000:00:06.0: setting latency timer to 64
> [    6.190794] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> [    6.191652] virtio-pci 0000:00:07.0: setting latency timer to 64
> [    6.193161] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
> [    6.194054] virtio-pci 0000:00:08.0: setting latency timer to 64
> [    6.195326] virtio-pci 0000:00:09.0: setting latency timer to 64
> [    6.196626] virtio-pci 0000:00:0a.0: setting latency timer to 64
> [    6.197867] XENFS: not registering filesystem on non-xen platform
> [    6.199045] HDLC line discipline maxframe=4096
> [    6.199771] N_HDLC line discipline registered.
> [    6.200539] r3964: Philips r3964 Driver $Revision: 1.10 $
> [    6.201327] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    6.223773] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    6.227082] Cyclades driver 2.6
> [    6.227874] MOXA Intellio family driver version 6.0k
> [    6.228814] MOXA Smartio/Industio family driver version 2.0.5
> [    6.229756] Initializing Nozomi driver 2.1d
> [    6.230551] RocketPort device driver module, version 2.09, 12-June-2003
> [    6.231551] No rocketport ports found; unloading driver
> [    6.232349] SyncLink GT
> [    6.232874] SyncLink GT, tty major#244
> [    6.233597] SyncLink GT no devices found
> [    6.234225] SyncLink MultiPort driver $Revision: 4.38 $
> [    6.252482] SyncLink MultiPort driver $Revision: 4.38 $, tty major#243
> [    6.253409] SyncLink serial driver $Revision: 4.38 $
> [    6.271720] SyncLink serial driver $Revision: 4.38 $, tty major#242
> [    6.273547] lp: driver loaded but no devices found
> [    6.274277] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
> [    6.275254] ac.o: No PCI boards found.
> [    6.275865] ac.o: For an ISA board you must supply memory and irq parameters.
> [    6.277391] Non-volatile memory driver v1.3
> [    6.279031] ppdev: user-space parallel port driver
> [    6.279781] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    6.280591] smapi::smapi_init, ERROR invalid usSmapiID
> [    6.281346] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
> [    6.282722] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
> [    6.283870] mwave: mwavedd::mwave_init: Error: Failed to initialize
> [    6.284778] Linux agpgart interface v0.103
> [    6.286092] SyncLink PC Card driver $Revision: 4.34 $, tty major#240
> [    6.287132] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    6.288488] Hangcheck: Using getrawmonotonic().
> [    6.289448] [drm] Initialized drm 1.1.0 20060810
> [    6.290543] [drm] radeon defaulting to kernel modesetting.
> [    6.291338] [drm] radeon kernel modesetting enabled.
> [    6.292887] parport_pc 00:04: reported by Plug and Play ACPI
> [    6.293884] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> [    6.392791] lp0: using parport0 (interrupt-driven).
> [    6.396234] Floppy drive(s): fd0 is 1.44M
> [    6.402017] brd: module loaded
> [    6.406813] loop: module loaded
> [    6.407360] Compaq SMART2 Driver (v 2.6.0)
> [    6.408125] HP CISS Driver (v 3.6.26)
> [    6.409739] MM: desc_per_page = 128
> [    6.412828] FDC 0 is a S82078B
> [    6.413286] nbd: registered device at major 43
> [    6.421281] virtio-pci 0000:00:05.0: irq 40 for MSI/MSI-X
> [    6.422112] virtio-pci 0000:00:05.0: irq 41 for MSI/MSI-X
> [    6.441497]  vda: unknown partition table
> [    6.442776] virtio-pci 0000:00:06.0: irq 42 for MSI/MSI-X
> [    6.443607] virtio-pci 0000:00:06.0: irq 43 for MSI/MSI-X
> [    6.458582]  vdb: unknown partition table
> [    6.459781] virtio-pci 0000:00:07.0: irq 44 for MSI/MSI-X
> [    6.460649] virtio-pci 0000:00:07.0: irq 45 for MSI/MSI-X
> [    6.475822]  vdc: unknown partition table
> [    6.477065] virtio-pci 0000:00:08.0: irq 46 for MSI/MSI-X
> [    6.477898] virtio-pci 0000:00:08.0: irq 47 for MSI/MSI-X
> [    6.493577]  vdd: unknown partition table
> [    6.494805] virtio-pci 0000:00:09.0: irq 48 for MSI/MSI-X
> [    6.495680] virtio-pci 0000:00:09.0: irq 49 for MSI/MSI-X
> [    6.510626]  vde: unknown partition table
> [    6.511847] virtio-pci 0000:00:0a.0: irq 50 for MSI/MSI-X
> [    6.512711] virtio-pci 0000:00:0a.0: irq 51 for MSI/MSI-X
> [    6.527667]  vdf: unknown partition table
> [    6.528991] events: mcg drbd: 10
> [    6.558457] drbd: initialized. Version: 8.4.2 (api:1/proto:86-101)
> [    6.559341] drbd: built-in
> [    6.559839] drbd: registered as block device major 147
> [    6.560745] rbd: loaded rbd (rados block device)
> [    6.561571] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> [    6.562949] lkdtm: No crash points registered, enable through debugfs
> [    6.564041] Phantom Linux Driver, version n0.9.8, init OK
> [    6.565176] i2c-core: driver [apds9802als] using legacy suspend method
> [    6.566143] i2c-core: driver [apds9802als] using legacy resume method
> [    6.567084] i2c-core: driver [isl29003] using legacy suspend method
> [    6.568048] i2c-core: driver [isl29003] using legacy resume method
> [    6.568990] i2c-core: driver [tsl2550] using legacy suspend method
> [    6.569919] i2c-core: driver [tsl2550] using legacy resume method
> [    6.570854] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    6.572253] c2port c2port0: C2 port uc added
> [    6.572919] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
> [    6.574839] usbcore: registered new interface driver pn533
> [    6.575679] Uniform Multi-Platform E-IDE driver
> [    6.576599] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
> [    6.577740] piix 0000:00:01.1: not 100% native mode: will probe irqs later
> [    6.578734] pci 0000:00:01.1: setting latency timer to 64
> [    6.579599]     ide0: BM-DMA at 0xc1c0-0xc1c7
> [    6.580346]     ide1: BM-DMA at 0xc1c8-0xc1cf
> [    6.581045] Probing IDE interface ide0...
> [    6.820117] tsc: Refined TSC clocksource calibration: 3200.110 MHz
> [    7.148340] Probing IDE interface ide1...
> [    7.884151] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
> [    8.556327] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
> [    8.557326] hdc: MWDMA2 mode selected
> [    8.558133] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    8.558989] ide1 at 0x170-0x177,0x376 on irq 15
> [    8.560800] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    8.562247] ide-gd driver 1.18
> [    8.562838] ide-cd driver 5.00
> [    8.563812] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
> [    8.564945] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    8.568406] Loading iSCSI transport class v2.0-870.
> [    8.569872] rdac: device handler registered
> [    8.570772] hp_sw: device handler registered
> [    8.571453] emc: device handler registered
> [    8.572118] alua: device handler registered
> [    8.574029] fnic: Cisco FCoE HBA Driver, ver 1.5.0.2
> [    8.575359] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v1.0.12 (Jun 04, 2012)
> [    8.577176] iscsi: registered transport (tcp)
> [    8.578096] Loading Adaptec I2O RAID: Version 2.4 Build 5go
> [    8.578907] Detecting Adaptec I2O RAID controllers...
> [    8.579920] Adaptec aacraid driver 1.2-0[29801]-ms
> [    8.580982] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
> [    8.588950] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
> [    8.590106] scsi: <fdomain> Detection failed (no card)
> [    8.591086] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.04.00.08-k.
> [    8.592630] iscsi: registered transport (qla4xxx)
> [    8.593430] QLogic iSCSI HBA Driver
> [    8.594013] Brocade BFA FC/FCOE SCSI driver - version: 3.1.2.1
> [    8.595265] DC390: clustering now enabled by default. If you get problems load
> [    8.596429]        with "disable_clustering=1" and report to maintainers
> [    8.597530] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> [    8.598848] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> [    8.599890] megasas: 06.504.01.00-rc1 Mon. Oct. 1 17:00:00 PDT 2012
> [    8.600897] mpt2sas version 14.100.00.00 loaded
> [    8.601917] GDT-HA: Storage RAID Controller Driver. Version: 3.05
> [    8.603012] 3ware Storage Controller device driver for Linux v1.26.02.003.
> [    8.604054] 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
> [    8.605286] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v3.26.02.000.
> [    8.606558] ppa: Version 2.07 (for Linux 2.4.x)
> [    8.609545] imm: Version 2.05 (for Linux 2.4.0)
> [    8.610750] ipr: IBM Power RAID SCSI Device Driver version: 2.5.4 (July 11, 2012)
> [    8.611989] RocketRAID 3xxx/4xxx Controller driver v1.8
> [    8.612895] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
> [    8.614086] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
> [    8.615270] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
> [    8.616243] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
> [    8.617190] iscsi: registered transport (cxgb3i)
> [    8.617922] Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
> [    8.618837] iscsi: registered transport (cxgb4i)
> [    8.619567] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2012)
> [    8.620681] iscsi: registered transport (bnx2i)
> [    8.622062] iscsi: registered transport (be2iscsi)
> [    8.622792] In beiscsi_module_init, tt=ffffffff83d6bcf0
> [    8.624034] VMware PVSCSI driver - version 1.0.2.0-k
> [    8.624888] hv_vmbus: registering driver hv_storvsc
> [    8.625628] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [    8.626616] osst :I: Tape driver with OnStream support version 0.99.4
> [    8.626616] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> [    8.628809] SCSI Media Changer driver v0.25 
> [    8.629647] osd: LOADED open-osd 0.2.1
> [    8.638149] scsi_debug: host protection
> [    8.638796] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
> [    8.641455] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
> [    8.644105] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.00 MiB)
> [    8.646167] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    8.646486] Rounding down aligned max_sectors from 4294967295 to 4294967288
> [    8.648075] sd 0:0:0:0: [sda] Write Protect is off
> [    8.648817] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
> [    8.654645] SSFDC read-only Flash Translation layer
> [    8.655395] mtdoops: mtd device (mtddev=name/number) must be supplied
> [    8.656452] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
> [    8.657408] Could not find PAR responsible for SC520CDP Flash Bank #0
> [    8.658310] Trying default address 0x8400000
> [    8.659004] Could not find PAR responsible for SC520CDP Flash Bank #1
> [    8.659903] Trying default address 0x8c00000
> [    8.660116] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [    8.661888] Could not find PAR responsible for SC520CDP DIL Flash
> [    8.662777] Trying default address 0x9400000
> [    8.663496] SC520 CDP flash device: 0x800000 at 0x8400000
> [    8.664300] Failed to ioremap_nocache
> [    8.664900] NetSc520 flash device: 0x100000 at 0x200000
> [    8.665668] Failed to ioremap_nocache
> [    8.666258] Failed to ioremap_nocache
> [    8.666980] Generic platform RAM MTD, (c) 2004 Simtec Electronics
> [    8.693786] No recognised DiskOnChip devices found
> [    8.694535] slram: not enough parameters.
> [    8.695165] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
> [    8.696334] pmc551: not detected
> [    8.698508]  sda: unknown partition table
> [    8.700725] ftl_cs: FTL header not found.
> [    8.708930] DiskOnChip Millennium Plus 32MB is not supported, ignoring.
> [    8.716108] sd 0:0:0:0: [sda] Attached SCSI disk
> [    8.731696] No valid DiskOnChip devices found
> [    8.732441] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [    8.733800] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [    8.735150] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [    8.736551] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [    8.737930] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [    8.739276] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [    8.740683] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), page size: 512, OOB size: 16
> [    8.742282] flash size: 128 MiB
> [    8.742831] page size: 512 bytes
> [    8.743389] OOB area size: 16 bytes
> [    8.743963] sector size: 16 KiB
> [    8.744530] pages number: 262144
> [    8.745084] pages per sector: 32
> [    8.745660] bus width: 8
> [    8.746134] bits in sector size: 14
> [    8.746715] bits in page size: 9
> [    8.747264] bits in OOB size: 4
> [    8.747837] flash size with OOB: 135168 KiB
> [    8.748514] page address bytes: 4
> [    8.749071] sector address bytes: 3
> [    8.749677] options: 0x42
> [    8.752398] Scanning device for bad blocks
> [    8.794962] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
> [    8.795875] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
> [    8.797520] ftl_cs: FTL header not found.
> [    8.799124] usbcore: registered new interface driver alauda
> [    8.832016] onenand_wait: timeout! ctrl=0x0000 intr=0x0000
> [    8.832840] OneNAND Manufacturer: Samsung (0xec)
> [    8.833572] OneNAND 16MB 1.8V 16-bit (0x04)
> [    8.834221] OneNAND version = 0x001e
> [    8.834812] Lock scheme is Continuous Lock
> [    8.835522] Scanning device for bad blocks
> [    8.837645] Creating 1 MTD partitions on "OneNAND simulator":
> [    8.838506] 0x000000000000-0x000001000000 : "OneNAND simulator partition"
> [    8.840178] ftl_cs: FTL header not found.
> [    8.956612] parport_pc 00:04: master is unqueued, this is deprecated
> [    8.958936] parport0: AVR Butterfly
> [    8.959566] parport0: cannot grant exclusive access for device spi-lm70llp
> [    8.960545] spi-lm70llp: spi_lm70llp probe fail, status -12
> [    8.961662] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
> [    8.964912] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
> [    8.967935] D-Link DE-620 pocket adapter io 0x378, which is busy.
> [    8.970706] tun: Universal TUN/TAP device driver, 1.6
> [    8.971440] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    8.972667] arcnet loaded.
> [    8.973154] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
> [    8.974138] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
> [    8.975312] arcnet: raw mode (`r') encapsulation support loaded.
> [    8.976185] arcnet: cap mode (`c') encapsulation support loaded.
> [    8.977112] arcnet: COM90xx chipset support
> [    9.277009] S3: No ARCnet cards found.
> [    9.277654] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
> [    9.278799] E-mail me if you actually test this driver, please!
> [    9.279639]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
> [    9.280914] arcnet: RIM I (entirely mem-mapped) support
> [    9.281688] E-mail me if you actually test the RIM I driver, please!
> [    9.282605] Given: node 00h, shmem 0h, irq 0
> [    9.283265] No autoprobe for RIM I; you must specify the shmem and irq!
> [    9.284206] arcnet: COM20020 PCI support
> [    9.285002] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
> [    9.286589] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <johns393@maroon.tc.umn.edu>
> [    9.287877] vcan: Virtual CAN interface driver
> [    9.288611] slcan: serial line CAN interface driver
> [    9.289335] slcan: 10 dynamic interface channels.
> [    9.290050] CAN device driver interface
> [    9.290757] usbcore: registered new interface driver ems_usb
> [    9.291632] usbcore: registered new interface driver esd_usb2
> [    9.292609] sja1000 CAN netdevice driver
> [    9.294282] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
> [    9.295406] Atheros(R) L2 Ethernet Driver - version 2.2.3
> [    9.296220] Copyright (c) 2007 Atheros Corporation.
> [    9.297388] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec 05, 2012)
> [    9.298782] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.78.00-0 (2012/09/27)
> [    9.300592] Brocade 10G Ethernet driver - version: 3.1.2.1
> [    9.302090] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.39
> [    9.303096] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
> [    9.304130] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
> [    9.304130]   http://www.scyld.com/network/drivers.html
> [    9.306098] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
> [    9.307186] DE600: port 0x378 busy
> [    9.308123] vxge: Copyright(c) 2002-2010 Exar Corp.
> [    9.308888] vxge: Driver version: 2.5.3.22640-k
> [    9.316434] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> [    9.317299] e100: Copyright(c) 1999-2006 Intel Corporation
> [    9.318189] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
> [    9.319182] e1000: Copyright (c) 1999-2006 Intel Corporation.
> [    9.320142] e1000 0000:00:03.0: setting latency timer to 64
> [    9.648914] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
> [    9.649867] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
> [    9.650897] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
> [    9.651740] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
> [    9.652715] igb: Intel(R) Gigabit Ethernet Network Driver - version 4.1.2-k
> [    9.653683] igb: Copyright (c) 2007-2012 Intel Corporation.
> [    9.654591] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.2-k
> [    9.655779] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
> [    9.656762] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.11.33-k
> [    9.657958] ixgbe: Copyright (c) 1999-2012 Intel Corporation.
> [    9.658933] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.7.12-k
> [    9.660314] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
> [    9.661294] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
> [    9.662272] ixgb: Copyright (c) 1999-2008 Intel Corporation.
> [    9.663263] jme: JMicron JMC2XX ethernet driver version 1.0.8
> [    9.664299] sky2: driver version 1.30
> [    9.665736] myri10ge: Version 1.5.3-1.534
> [    9.666654] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
> [    9.667746] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
> [    9.669027] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.0.29
> [    9.670456] QLogic/NetXen Network Driver v4.0.80
> [    9.671392] atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
> [    9.672822] Solarflare NET driver v3.2
> [    9.674649] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
> [    9.675485] tehuti: Options: hw_csum 
> [    9.676187] tlan: ThunderLAN driver v1.17
> [    9.676931] tlan: 0 devices installed, PCI: 0  EISA: 0
> [    9.678128] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
> [    9.678913] AX.25: 6pack driver, Revision: 0.3.0
> [    9.679617] YAM driver version 0.8 by F1OAT/F6FBB
> [    9.682006] AX.25: bpqether driver version 004
> [    9.682732] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
> [    9.682732] baycom_ser_fdx: version 0.10
> [    9.685829] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
> [    9.686686] hdlcdrv: version 0.8
> [    9.687234] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
> [    9.687234] baycom_ser_hdx: version 0.10
> [    9.690475] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
> [    9.690475] baycom_par: version 0.9
> [    9.693546] usbcore: registered new interface driver irda-usb
> [    9.694462] usbcore: registered new interface driver stir4200
> [    9.696265] usbcore: registered new interface driver mcs7780
> [    9.697509] usbcore: registered new interface driver kingsun-sir
> [    9.698417] usbcore: registered new interface driver ksdazzle-sir
> [    9.699366] usbcore: registered new interface driver ks959-sir
> [    9.700732] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
> [    9.701535] plip0: Parallel port at 0x378, using IRQ 7.
> [    9.702296] PPP generic driver version 2.4.2
> [    9.703228] PPP BSD Compression module registered
> [    9.703947] PPP Deflate Compression module registered
> [    9.704761] PPP MPPE Compression module registered
> [    9.705489] NET: Registered protocol family 24
> [    9.706221] PPTP driver version 0.8.5
> [    9.707401] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
> [    9.708841] CSLIP: code copyright 1989 Regents of the University of California.
> [    9.709965] SLIP linefill/keepalive option.
> [    9.710716] hdlc: HDLC support module revision 1.22
> [    9.711622] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
> [    9.712549] cycx_drv: Cyclom 2X Support Module v0.6 (c) 1998-2003 Arnaldo Carvalho de Melo <acme@conectiva.com.br>
> [    9.714012] cyclomx: CYCLOM 2X(tm) Sync Card Driver v0.11 (c) 1998-2003 Arnaldo Carvalho de Melo <acme@conectiva.com.br>
> [    9.715735] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
> [    9.716914] ipw2200: Copyright(c) 2003-2006 Intel Corporation
> [    9.717822] libipw: 802.11 data/management/control stack, git-1.1.13
> [    9.718739] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
> [    9.719941] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
> [    9.721455] orinoco_plx 0.15 (Pavel Roskin <proski@gnu.org>, David Gibson <hermes@gibson.dropbear.id.au>, Daniel Barlow <dan@telent.net>)
> [    9.723217] orinoco_tmd 0.15 (Joerg Dorchain <joerg@dorchain.net>)
> [    9.724185] orinoco_nortel 0.15 (Tobias Hoffmann & Christoph Jungegger <disdos@traum404.de>)
> [    9.725640] usbcore: registered new interface driver orinoco_usb
> [    9.726547] airo(): Probing for PCI adapters
> [    9.727279] airo(): Finished probing for PCI adapters
> [    9.728213] Atmel at76x USB Wireless LAN Driver 0.17 loading
> [    9.729144] usbcore: registered new interface driver at76c50x-usb
> [    9.730386] Broadcom 43xx driver loaded [ Features: PMNLS ]
> [    9.731307] Broadcom 43xx-legacy driver loaded [ Features: PLID ]
> [    9.732539] usbcore: registered new interface driver zd1211rw
> [    9.733536] usbcore: registered new interface driver rtl8187
> [    9.734506] usbcore: registered new interface driver rtl8192cu
> [    9.735770] usbcore: registered new interface driver rndis_wlan
> [    9.736723] usbcore: registered new interface driver zd1201
> [    9.737650] usbcore: registered new interface driver usb8xxx
> [    9.738511] libertas_sdio: Libertas SDIO driver
> [    9.739199] libertas_sdio: Copyright Pierre Ossman
> [    9.739986] libertas_spi: Libertas SPI driver
> [    9.741007] usbcore: registered new interface driver lbtf_usb
> [    9.742029] Intel(R) Wireless WiFi driver for Linux, in-tree:
> [    9.742858] Copyright(c) 2003-2012 Intel Corporation
> [    9.743750] iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:
> [    9.744745] iwl4965: Copyright(c) 2003-2011 Intel Corporation
> [    9.745709] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
> [    9.747040] iwl3945: Copyright(c) 2003-2011 Intel Corporation
> [    9.748353] usbcore: registered new interface driver rt2500usb
> [    9.749261] usbcore: registered new interface driver rt73usb
> [    9.750168] usbcore: registered new interface driver rt2800usb
> [    9.751062] usbcore: registered new interface driver p54usb
> [    9.752071] mac80211_hwsim: Initializing radio 0
> [    9.753816] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [    9.755405] ieee80211 phy0: hwaddr 020000000000 registered
> [    9.756345] mac80211_hwsim: Initializing radio 1
> [    9.757559] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
> [    9.759072] ieee80211 phy1: hwaddr 020000000100 registered
> [    9.760422] mac80211_hwsim: initializing netlink
> [    9.761571] usbcore: registered new interface driver i2400m_usb
> [    9.763128] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMAC hardware
> [    9.764362] VMware vmxnet3 virtual NIC driver - version 1.1.29.0-k-NAPI
> [    9.765421] usbcore: registered new interface driver catc
> [    9.766306] usbcore: registered new interface driver kaweth
> [    9.767113] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
> [    9.768351] usbcore: registered new interface driver pegasus
> [    9.769237] usbcore: registered new interface driver rtl8150
> [    9.770084] hso: /c/kernel-tests/src/stable/drivers/net/usb/hso.c: Option Wireless
> [    9.771322] usbcore: registered new interface driver hso
> [    9.772227] usbcore: registered new interface driver asix
> [    9.773077] usbcore: registered new interface driver cdc_ether
> [    9.773993] usbcore: registered new interface driver cdc_eem
> [    9.774865] usbcore: registered new interface driver dm9601
> [    9.775782] usbcore: registered new interface driver smsc75xx
> [    9.776699] usbcore: registered new interface driver smsc95xx
> [    9.777614] usbcore: registered new interface driver gl620a
> [    9.778482] usbcore: registered new interface driver net1080
> [    9.779348] usbcore: registered new interface driver plusb
> [    9.780248] usbcore: registered new interface driver rndis_host
> [    9.781159] usbcore: registered new interface driver cdc_subset
> [    9.782095] usbcore: registered new interface driver zaurus
> [    9.782965] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
> [    9.784208] usbcore: registered new interface driver int51x1
> [    9.785096] usbcore: registered new interface driver cdc_phonet
> [    9.786024] usbcore: registered new interface driver kalmia
> [    9.786890] usbcore: registered new interface driver ipheth
> [    9.787791] usbcore: registered new interface driver sierra_net
> [    9.788711] usbcore: registered new interface driver cx82310_eth
> [    9.789649] usbcore: registered new interface driver cdc_ncm
> [    9.790520] usbcore: registered new interface driver lg-vl600
> [    9.791342] hv_vmbus: registering driver hv_netvsc
> [    9.792263] Madge ATM Ambassador driver version 1.2.4
> [    9.793105] Madge ATM Horizon [Ultra] driver version 1.2.1
> [    9.794105] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
> [    9.795197] idt77252_init: at ffffffff841c4fdb
> [    9.795999] Solos PCI Driver Version 0.07
> [    9.796756] adummy: version 1.0
> [    9.797844] I2O subsystem v1.325
> [    9.798401] i2o: max drivers = 8
> [    9.799342] I2O Configuration OSM v1.323
> [    9.800222] I2O Bus Adapter OSM v1.317
> [    9.800883] I2O Block Device OSM v1.325
> [    9.802725] I2O SCSI Peripheral OSM v1.316
> [    9.803414] I2O ProcFS OSM v1.316
> [    9.804105] Fusion MPT base driver 3.04.20
> [    9.804759] Copyright (c) 1999-2008 LSI Corporation
> [    9.805574] Fusion MPT SPI Host driver 3.04.20
> [    9.806362] Fusion MPT FC Host driver 3.04.20
> [    9.807134] Fusion MPT SAS Host driver 3.04.20
> [    9.807946] Fusion MPT misc device (ioctl) driver 3.04.20
> [    9.809023] mptctl: Registered with Fusion MPT base driver
> [    9.809868] mptctl: /dev/mptctl @ (major,minor=10,220)
> [    9.810625] Fusion MPT LAN driver 3.04.20
> [    9.812296] Generic UIO driver for PCI 2.3 devices version: 0.01.0
> [    9.815173] aoe: AoE v81 initialised.
> [    9.823373] usbcore: registered new interface driver hwa-rc
> [    9.824299] usbcore: registered new interface driver i1480-dfu-usb
> [    9.825564] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    9.826482] ehci-pci: EHCI PCI platform driver
> [    9.827288] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    9.828333] uhci_hcd: USB Universal Host Controller Interface driver
> [    9.829604] driver u132_hcd
> [    9.830460] usbcore: registered new interface driver hwa-hc
> [    9.831606] usbcore: registered new interface driver wusb-cbaf
> [    9.832595] usbcore: registered new interface driver cdc_acm
> [    9.833413] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
> [    9.834716] usbcore: registered new interface driver usblp
> [    9.835599] usbcore: registered new interface driver cdc_wdm
> [    9.836506] usbcore: registered new interface driver usbtmc
> [    9.837316] Initializing USB Mass Storage driver...
> [    9.838135] usbcore: registered new interface driver usb-storage
> [    9.838991] USB Mass Storage support registered.
> [    9.839767] usbcore: registered new interface driver ums-alauda
> [    9.840701] usbcore: registered new interface driver ums-cypress
> [    9.841640] usbcore: registered new interface driver ums-datafab
> [    9.842547] usbcore: registered new interface driver ums_eneub6250
> [    9.843495] usbcore: registered new interface driver ums-freecom
> [    9.844414] usbcore: registered new interface driver ums-isd200
> [    9.845316] usbcore: registered new interface driver ums-jumpshot
> [    9.846258] usbcore: registered new interface driver ums-karma
> [    9.847153] usbcore: registered new interface driver ums-onetouch
> [    9.848124] usbcore: registered new interface driver ums-realtek
> [    9.849030] usbcore: registered new interface driver ums-sddr09
> [    9.849969] usbcore: registered new interface driver ums-sddr55
> [    9.850867] usbcore: registered new interface driver ums-usbat
> [    9.851806] usbcore: registered new interface driver mdc800
> [    9.852644] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
> [    9.853888] usbcore: registered new interface driver microtekX6
> [    9.854911] usbcore: registered new interface driver usbserial
> [    9.855837] usbcore: registered new interface driver usbserial_generic
> [    9.856861] usbserial: USB Serial support registered for generic
> [    9.857797] usbcore: registered new interface driver aircable
> [    9.858683] usbserial: USB Serial support registered for aircable
> [    9.859628] usbcore: registered new interface driver ark3116
> [    9.860525] usbserial: USB Serial support registered for ark3116
> [    9.861459] usbcore: registered new interface driver belkin_sa
> [    9.862341] usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
> [    9.863764] usbcore: registered new interface driver ch341
> [    9.864636] usbserial: USB Serial support registered for ch341-uart
> [    9.865604] usbcore: registered new interface driver cp210x
> [    9.866459] usbserial: USB Serial support registered for cp210x
> [    9.867364] usbcore: registered new interface driver cyberjack
> [    9.868299] usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
> [    9.869648] usbcore: registered new interface driver cypress_m8
> [    9.870547] usbserial: USB Serial support registered for DeLorme Earthmate USB
> [    9.871742] usbserial: USB Serial support registered for HID->COM RS232 Adapter
> [    9.872943] usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
> [    9.874155] usbcore: registered new interface driver usb_debug
> [    9.875039] usbserial: USB Serial support registered for debug
> [    9.875955] usbcore: registered new interface driver digi_acceleport
> [    9.876927] usbserial: USB Serial support registered for Digi 2 port USB adapter
> [    9.878138] usbserial: USB Serial support registered for Digi 4 port USB adapter
> [    9.879323] usbcore: registered new interface driver io_edgeport
> [    9.880275] usbserial: USB Serial support registered for Edgeport 2 port adapter
> [    9.881510] usbserial: USB Serial support registered for Edgeport 4 port adapter
> [    9.882684] usbserial: USB Serial support registered for Edgeport 8 port adapter
> [    9.883898] usbserial: USB Serial support registered for EPiC device
> [    9.884887] usbcore: registered new interface driver io_ti
> [    9.885765] usbserial: USB Serial support registered for Edgeport TI 1 port adapter
> [    9.886992] usbserial: USB Serial support registered for Edgeport TI 2 port adapter
> [    9.888247] usbcore: registered new interface driver empeg
> [    9.889094] usbserial: USB Serial support registered for empeg
> [    9.890015] usbcore: registered new interface driver ftdi_sio
> [    9.890895] usbserial: USB Serial support registered for FTDI USB Serial Device
> [    9.892120] usbcore: registered new interface driver funsoft
> [    9.892991] usbserial: USB Serial support registered for funsoft
> [    9.893922] usbcore: registered new interface driver garmin_gps
> [    9.894816] usbserial: USB Serial support registered for Garmin GPS usb/tty
> [    9.895865] usbcore: registered new interface driver hp4x
> [    9.896727] usbserial: USB Serial support registered for hp4X
> [    9.897643] usbcore: registered new interface driver ipaq
> [    9.898480] usbserial: USB Serial support registered for PocketPC PDA
> [    9.899421] usbcore: registered new interface driver ipw
> [    9.900300] usbserial: USB Serial support registered for IPWireless converter
> [    9.901326] usbcore: registered new interface driver ir_usb
> [    9.902205] usbserial: USB Serial support registered for IR Dongle
> [    9.903131] usbcore: registered new interface driver iuu_phoenix
> [    9.904090] usbserial: USB Serial support registered for iuu_phoenix
> [    9.905043] usbcore: registered new interface driver keyspan
> [    9.905943] usbserial: USB Serial support registered for Keyspan - (without firmware)
> [    9.907170] usbserial: USB Serial support registered for Keyspan 1 port adapter
> [    9.908398] usbserial: USB Serial support registered for Keyspan 2 port adapter
> [    9.909607] usbserial: USB Serial support registered for Keyspan 4 port adapter
> [    9.910789] usbcore: registered new interface driver keyspan_pda
> [    9.911717] usbserial: USB Serial support registered for Keyspan PDA
> [    9.912676] usbserial: USB Serial support registered for Keyspan PDA - (prerenumeration)
> [    9.913971] usbserial: USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
> [    9.915330] usbcore: registered new interface driver kl5kusb105
> [    9.916274] usbserial: USB Serial support registered for KL5KUSB105D / PalmConnect
> [    9.917524] usbcore: registered new interface driver kobil_sct
> [    9.918403] usbserial: USB Serial support registered for KOBIL USB smart card terminal
> [    9.919704] usbcore: registered new interface driver mct_u232
> [    9.920596] usbserial: USB Serial support registered for MCT U232
> [    9.921549] usbcore: registered new interface driver mos7720
> [    9.922412] usbserial: USB Serial support registered for Moschip 2 port adapter
> [    9.923632] usbcore: registered new interface driver mos7840
> [    9.924530] usbserial: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
> [    9.925870] usbcore: registered new interface driver moto_modem
> [    9.926765] usbserial: USB Serial support registered for moto-modem
> [    9.927741] usbcore: registered new interface driver navman
> [    9.928626] usbserial: USB Serial support registered for navman
> [    9.929561] usbcore: registered new interface driver omninet
> [    9.930421] usbserial: USB Serial support registered for ZyXEL - omni.net lcd plus usb
> [    9.931696] usbcore: registered new interface driver opticon
> [    9.932593] usbserial: USB Serial support registered for opticon
> [    9.933562] usbcore: registered new interface driver option
> [    9.934410] usbserial: USB Serial support registered for GSM modem (1-port)
> [    9.935425] usbcore: registered new interface driver oti6858
> [    9.936341] usbserial: USB Serial support registered for oti6858
> [    9.937264] usbcore: registered new interface driver pl2303
> [    9.938157] usbserial: USB Serial support registered for pl2303
> [    9.939061] usbcore: registered new interface driver qcaux
> [    9.939934] usbserial: USB Serial support registered for qcaux
> [    9.940872] usbcore: registered new interface driver qcserial
> [    9.941784] usbserial: USB Serial support registered for Qualcomm USB modem
> [    9.942802] usbcore: registered new interface driver safe_serial
> [    9.943734] usbserial: USB Serial support registered for safe_serial
> [    9.944710] usbcore: registered new interface driver siemens_mpi
> [    9.945652] usbserial: USB Serial support registered for siemens_mpi
> [    9.946619] usbcore: registered new interface driver sierra
> [    9.947503] usbserial: USB Serial support registered for Sierra USB modem
> [    9.948520] usbcore: registered new interface driver spcp8x5
> [    9.949380] usbserial: USB Serial support registered for SPCP8x5
> [    9.950328] usbcore: registered new interface driver ssu100
> [    9.951194] usbserial: USB Serial support registered for Quatech SSU-100 USB to Serial Driver
> [    9.952563] usbcore: registered new interface driver symbolserial
> [    9.953507] usbserial: USB Serial support registered for symbol
> [    9.954408] usbcore: registered new interface driver ti_usb_3410_5052
> [    9.955364] usbserial: USB Serial support registered for TI USB 3410 1 port adapter
> [    9.956633] usbserial: USB Serial support registered for TI USB 5052 2 port adapter
> [    9.957886] usbcore: registered new interface driver visor
> [    9.958735] usbserial: USB Serial support registered for Handspring Visor / Palm OS
> [    9.959968] usbserial: USB Serial support registered for Sony Clie 5.0
> [    9.960958] usbserial: USB Serial support registered for Sony Clie 3.5
> [    9.961960] usbcore: registered new interface driver whiteheat
> [    9.962844] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
> [    9.964265] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
> [    9.965520] usbcore: registered new interface driver vivopay_serial
> [    9.966456] usbserial: USB Serial support registered for vivopay-serial
> [    9.967430] usbcore: registered new interface driver zio
> [    9.968306] usbserial: USB Serial support registered for zio
> [    9.969198] usbcore: registered new interface driver adutux
> [    9.970316] usbcore: registered new interface driver appledisplay
> [    9.977984] usbcore: registered new interface driver cypress_cy7c63
> [    9.978936] usbcore: registered new interface driver cytherm
> [    9.979843] usbcore: registered new interface driver emi26 - firmware loader
> [    9.980893] usbcore: registered new interface driver emi62 - firmware loader
> [    9.981894] driver ftdi-elan
> [    9.983129] usbcore: registered new interface driver ftdi-elan
> [    9.984091] usbcore: registered new interface driver idmouse
> [    9.984979] usbcore: registered new interface driver iowarrior
> [    9.985904] usbcore: registered new interface driver isight_firmware
> [    9.986863] usbcore: registered new interface driver usblcd
> [    9.987735] usbcore: registered new interface driver ldusb
> [    9.988616] usbcore: registered new interface driver usbled
> [    9.989575] usbcore: registered new interface driver legousbtower
> [    9.990522] usbcore: registered new interface driver rio500
> [    9.991415] usbcore: registered new interface driver usbtest
> [    9.992337] usbcore: registered new interface driver trancevibrator
> [    9.993282] usbcore: registered new interface driver uss720
> [    9.994124] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
> [    9.995504] uss720: NOTE: this is a special purpose driver to allow nonstandard
> [    9.996655] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
> [    9.997800] uss720: If you just want to connect to a printer, use usblp instead
> [    9.998995] usbcore: registered new interface driver usbsevseg
> [    9.999928] usbcore: registered new interface driver yurex
> [   10.000809] usbcore: registered new interface driver sisusb
> [   10.001712] usbcore: registered new interface driver cxacru
> [   10.002594] usbcore: registered new interface driver speedtch
> [   10.003517] usbcore: registered new interface driver ueagle-atm
> [   10.004388] xusbatm: malformed module parameters
> [   10.005305] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [   10.007610] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   10.008550] serio: i8042 AUX port at 0x60,0x64 irq 12
> [   10.009744] parport0: cannot grant exclusive access for device parkbd
> [   10.058502] mousedev: PS/2 mouse device common for all mice
> [   10.060950] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [   10.063272] usbcore: registered new interface driver appletouch
> [   10.064220] usbcore: registered new interface driver bcm5974
> [   10.067329] usbcore: registered new interface driver iforce
> [   10.068837] usbcore: registered new interface driver xpad
> [   10.069729] parport0: cannot grant exclusive access for device walkera0701
> [   10.070729] usbcore: registered new interface driver usb_acecad
> [   10.071679] usbcore: registered new interface driver aiptek
> [   10.072812] usbcore: registered new interface driver gtco
> [   10.073940] usbcore: registered new interface driver hanwang
> [   10.075064] usbcore: registered new interface driver kbtab
> [   10.076147] usbcore: registered new interface driver wacom
> [   10.078813] mk712: device not present
> [   10.079500] usbcore: registered new interface driver usbtouchscreen
> [   10.080827] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
> [   10.081797] usbcore: registered new interface driver ati_remote2
> [   10.082727] cm109: Keymap for Komunikate KIP1000 phone loaded
> [   10.083658] usbcore: registered new interface driver cm109
> [   10.084489] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
> [   10.085506] usbcore: registered new interface driver keyspan_remote
> [   10.086625] input: PC Speaker as /devices/platform/pcspkr/input/input2
> [   10.087916] usbcore: registered new interface driver powermate
> [   10.089014] usbcore: registered new interface driver yealink
> [   10.090042] rtc_cmos 00:00: RTC can wake from S4
> [   10.091323] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
> [   10.092388] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
> [   10.095017] rtc-test rtc-test.0: rtc core: registered test as rtc1
> [   10.096251] rtc-test rtc-test.1: rtc core: registered test as rtc2
> [   10.097253] i2c /dev entries driver
> [   10.098641] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
> [   10.212877] usbcore: registered new interface driver i2c-diolan-u2c
> [   10.213776] i2c-parport: adapter type unspecified
> [   10.214519] i2c-parport-light: adapter type unspecified
> [   10.215437] usbcore: registered new interface driver i2c-tiny-usb
> [   10.216349] pps_ldisc: PPS line discipline registered
> [   10.217102] pps_parport: parallel port PPS client
> [   10.217850] parport0: cannot grant exclusive access for device pps_parport
> [   10.218832] pps_parport: couldn't register with parport0
> [   10.219680] Driver for 1-wire Dallas network protocol.
> [   10.220740] usbcore: registered new interface driver DS9490R
> [   10.221675] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
> [   10.223259] i2c-core: driver [max17040] using legacy suspend method
> [   10.224176] i2c-core: driver [max17040] using legacy resume method
> [   10.510082] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
> [   11.512159] i2c i2c-0: detect fail: address match, 0x2c
> [   11.528161] i2c i2c-0: detect fail: address match, 0x2d
> [   11.544151] i2c i2c-0: detect fail: address match, 0x2e
> [   11.560155] i2c i2c-0: detect fail: address match, 0x2f
> [   11.760168] applesmc: supported laptop not found!
> [   11.760887] applesmc: driver init failed (ret=-19)!
> [   20.104388] pc87360: PC8736x not detected, module not inserted
> [   20.608670] usbcore: registered new interface driver pcwd_usb
> [   20.609490] acquirewdt: WDT driver for Acquire single board computer initialising
> [   20.610900] acquirewdt: I/O address 0x0043 already in use
> [   20.611688] acquirewdt: probe of acquirewdt failed with error -5
> [   20.612638] advantechwdt: WDT driver for Advantech single board computer initialising
> [   20.614156] advantechwdt: initialized. timeout=60 sec (nowayout=0)
> [   20.615101] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
> [   20.615876] alim7101_wdt: ALi M7101 PMU not present - WDT not set
> [   20.616851] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
> [   20.617861] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
> [   20.618927] ib700wdt: WDT driver for IB700 single board computer initialising
> [   20.620042] ib700wdt: START method I/O 443 is not available
> [   20.620907] ib700wdt: probe of ib700wdt failed with error -5
> [   20.621701] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
> [   20.622934] wafer5823wdt: I/O address 0x0443 already in use
> [   20.623782] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
> [   20.624863] i6300esb: cannot register miscdev on minor=130 (err=-16)
> [   20.625832] i6300ESB timer: probe of 0000:00:0b.0 failed with error -16
> [   20.626817] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
> [   20.627654] iTCO_vendor_support: vendor-support=0
> [   20.628498] it87_wdt: no device
> [   20.629110] sc1200wdt: build 20020303
> [   20.629736] sc1200wdt: io parameter must be specified
> [   20.630569] pc87413_wdt: Version 1.1 at io 0x2E
> [   20.631244] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
> [   20.632164] nv_tco: NV TCO WatchDog Timer Driver v0.01
> [   20.633167] sbc60xxwdt: I/O address 0x0443 already in use
> [   20.633942] sbc8360: failed to register misc device
> [   20.634752] cpu5wdt: misc_register failed
> [   20.635417] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
> [   20.637719] smsc37b787_wdt: Unable to register miscdev on minor 130
> [   20.638649] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
> [   20.639998] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
> [   20.641207] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
> [   20.642101] w83697hf_wdt: WDT driver for W83697HF/HG initializing
> [   20.643022] w83697hf_wdt: watchdog not found at address 0x2e
> [   20.643834] w83697hf_wdt: No W83697HF/HG could be found
> [   20.644667] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
> [   20.645924] w83697ug_wdt: No W83697UG/UF could be found
> [   20.646753] w83877f_wdt: I/O address 0x0443 already in use
> [   20.647538] w83977f_wdt: driver v1.00
> [   20.648143] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
> [   20.649112] machzwd: MachZ ZF-Logic Watchdog driver initializing
> [   20.649944] machzwd: no ZF-Logic found
> [   20.650612] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
> [   20.651559] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
> [   20.652832] watchdog: Software Watchdog: a legacy watchdog module is probably present.
> [   20.654164] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
> [   20.655772] md: linear personality registered for level -1
> [   20.656650] md: raid0 personality registered for level 0
> [   20.657402] md: raid1 personality registered for level 1
> [   20.658142] md: raid10 personality registered for level 10
> [   20.658979] md: raid6 personality registered for level 6
> [   20.659741] md: raid5 personality registered for level 5
> [   20.660596] md: raid4 personality registered for level 4
> [   20.661356] md: multipath personality registered for level -4
> [   20.662150] md: faulty personality registered for level -5
> [   20.663504] device-mapper: uevent: version 1.0.3
> [   20.664614] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
> [   20.667151] device-mapper: multipath: version 1.5.0 loaded
> [   20.667945] device-mapper: multipath round-robin: version 1.0.0 loaded
> [   20.668890] device-mapper: multipath queue-length: version 0.1.0 loaded
> [   20.669810] device-mapper: multipath service-time: version 0.2.0 loaded
> [   20.671377] device-mapper: dm-log-userspace: version 1.1.0 loaded
> [   20.672520] Bluetooth: Virtual HCI driver ver 1.3
> [   20.673343] Bluetooth: HCI UART driver ver 2.2
> [   20.674009] Bluetooth: HCI H4 protocol initialized
> [   20.674781] Bluetooth: HCI BCSP protocol initialized
> [   20.675498] Bluetooth: HCILL protocol initialized
> [   20.676198] Bluetooth: HCIATH3K protocol initialized
> [   20.677079] usbcore: registered new interface driver bcm203x
> [   20.677940] usbcore: registered new interface driver bpa10x
> [   20.678870] usbcore: registered new interface driver bfusb
> [   20.679885] usbcore: registered new interface driver btusb
> [   20.680714] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
> [   20.681605] usbcore: registered new interface driver ath3k
> [   20.689416] CAPI 2.0 started up with major 68 (middleware)
> [   20.690189] Modular ISDN core version 1.1.29
> [   20.691149] NET: Registered protocol family 34
> [   20.691840] DSP module 2.0
> [   20.692358] mISDN_dsp: DSP clocks every 64 samples. This equals 2 jiffies.
> [   20.694984] mISDN: Layer-1-over-IP driver Rev. 2.00
> [   20.695924] 0 virtual devices registered
> [   20.696742] b1pci: revision 1.1.2.2
> [   20.697301] b1: revision 1.1.2.2
> [   20.697833] b1dma: revision 1.1.2.3
> [   20.698477] b1pci: revision 1.1.2.2
> [   20.699159] t1pci: revision 1.1.2.2
> [   20.699809] c4: revision 1.1.2.2
> [   20.700602] mISDN: HFC-multi driver 2.03
> [   20.701361] usbcore: registered new interface driver HFC-S_USB
> [   20.702168] AVM Fritz PCI driver Rev. 2.3
> [   20.702944] Sedlbauer Speedfax+ Driver Rev. 2.0
> [   20.703714] Infineon ISDN Driver Rev. 1.0
> [   20.704466] Winbond W6692 PCI driver Rev. 2.0
> [   20.705211] mISDNipac module version 2.0
> [   20.705826] mISDN: ISAR driver Rev. 2.1
> [   20.706496] gigaset: Driver for Gigaset 307x
> [   20.707136] gigaset: Kernel CAPI interface
> [   20.707883] usbcore: registered new interface driver usb_gigaset
> [   20.708813] usb_gigaset: USB Driver for Gigaset 307x using M105
> [   20.709716] usbcore: registered new interface driver bas_gigaset
> [   20.710618] bas_gigaset: USB Driver for Gigaset 307x
> [   20.711404] EDAC MC: Ver: 3.0.0
> [   20.713646] AMD64 EDAC driver v3.4.0
> [   20.714476] cpuidle: using governor ladder
> [   20.715108] cpuidle: using governor menu
> [   20.715823] sdhci: Secure Digital Host Controller Interface driver
> [   20.716727] sdhci: Copyright(c) Pierre Ossman
> [   20.717461] wbsd: Winbond W83L51xD SD/MMC card interface driver
> [   20.718276] wbsd: Copyright(c) Pierre Ossman
> [   20.719248] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
> [   20.721060] usbcore: registered new interface driver vub300
> [   20.722102] usbcore: registered new interface driver ushc
> [   20.722941] sdhci-pltfm: SDHCI platform and OF driver helper
> [   20.724617] leds_ss4200: no LED devices found
> [   20.726731] user_mad: couldn't register device number
> [   20.727482] user_verbs: couldn't register device number
> [   20.728246] ucm: couldn't register device number
> [   20.730450] ib_qib: Unable to register ipathfs
> [   20.734340] iscsi: registered transport (iser)
> [   20.735068] EFI Variables Facility v0.08 2004-May-17
> [   20.736176] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [   20.737346] No iBFT detected.
> [   20.740881] usbcore: registered new interface driver usbhid
> [   20.741660] usbhid: USB HID core driver
> [   20.742547] usbip_core: USB/IP Core v1.0.0
> [   20.743366] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
> [   20.744764] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 1
> [   20.747278] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [   20.748227] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   20.749400] usb usb1: Product: USB/IP Virtual Host Controller
> [   20.750191] usb usb1: Manufacturer: Linux 3.7.0-01930-gbff6343 vhci_hcd
> [   20.751145] usb usb1: SerialNumber: vhci_hcd
> [   20.752640] hub 1-0:1.0: USB hub found
> [   20.753300] hub 1-0:1.0: 8 ports detected
> [   20.754864] vhci_hcd: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
> [   20.756007] usbcore: registered new interface driver usbip-host
> [   20.756932] usbip_host: USB/IP Host Driver v1.0.0
> [   20.757708] usbcore: registered new interface driver prism2_usb
> [   20.758668] usbcore: registered new interface driver r8712u
> [   20.759461] zram: num_devices not specified. Using default: 1
> [   20.760281] zram: Creating 1 devices ...
> [   20.761653] input: Speakup as /devices/virtual/input/input4
> [   20.762964] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
> [   20.764129] speakup 3.1.6: initialized
> [   20.764713] synth name on entry is: (null)
> [   20.765502] asus_wmi: Asus Management GUID not found
> [   20.766231] asus_wmi: Management GUID not found
> [   20.767556] asus_wmi: Management GUID not found
> [   20.768823] msi_laptop: driver 0.5 successfully loaded
> [   20.769851] compal_laptop: Motherboard not recognized (You could try the module's force-parameter)
> [   20.771199] dell_wmi: No known WMI GUID found
> [   20.771864] dell_wmi_aio: No known WMI GUID found
> [   20.772660] acer_wmi: Acer Laptop ACPI-WMI Extras
> [   20.773359] acer_wmi: No or unsupported WMI interface, unable to load
> [   20.774229] acerhdf: Acer Aspire One Fan driver, v.0.5.26
> [   20.775074] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Bochs, please report, aborting!
> [   20.776602] hdaps: supported laptop not found!
> [   20.777272] hdaps: driver init failed (ret=-19)!
> [   20.778337] fujitsu_laptop: driver 0.6.0 successfully loaded
> [   20.779269] msi_wmi: This machine doesn't have MSI-hotkeys through WMI
> [   20.780544] intel_oaktrail: Platform not recognized (You could try the module's force-parameter)
> [   20.781656] hv_utils: Registering HyperV Utility Driver
> [   20.782695] hv_vmbus: registering driver hv_util
> [   20.801749] no UART detected at 0x1
> [   20.802801] MTVAP port 0x378 is busy
> [   20.803462] snd_mtpav: probe of snd_mtpav failed with error -16
> [   20.804665] snd_mts64: probe of snd_mts64.0 failed with error -5
> [   20.805842] snd_portman2x4: probe of snd_portman2x4.0 failed with error -5
> [   20.807081] Error: Driver 'pcspkr' is already registered, aborting...
> [   20.810105] ASIHPI driver 4.10.01
> [   20.813495] snd_hda_intel 0000:00:04.0: irq 52 for MSI/MSI-X
> [   20.818780] snd_hda_intel 0000:00:04.0: setting latency timer to 64
> [   20.852438] vhci_hcd: changed 0
> [   23.844150] hda-intel 0000:00:04.0: azx_get_response timeout, switching to polling mode: last cmd=0x000f0000
> [   24.848150] hda-intel 0000:00:04.0: No response from codec, disabling MSI: last cmd=0x000f0000
> [   24.856996] usbcore: registered new interface driver snd-usb-audio
> [   24.857973] usbcore: registered new interface driver snd-ua101
> [   24.858920] usbcore: registered new interface driver snd-usb-usx2y
> [   24.859898] usbcore: registered new interface driver snd-usb-us122l
> [   24.860901] usbcore: registered new interface driver snd-usb-caiaq
> [   24.861880] usbcore: registered new interface driver snd-usb-6fire
> [   24.862932] oprofile: using NMI interrupt.
> [   24.863845] pktgen: Packet Generator for packet performance testing. Version: 2.74
> [   24.866061] drop_monitor: Initializing network drop monitor service
> [   24.867279] NET: Registered protocol family 26
> [   24.868050] GACT probability on
> [   24.868673] Mirror/redirect action on
> [   24.869263] Simple TC action Loaded
> [   24.870283] netem: version 1.3
> [   24.870888] u32 classifier
> [   24.871373]     Performance counters on
> [   24.871982]     input device check on
> [   24.872679]     Actions configured
> [   24.873285] Netfilter messages via NETLINK v0.30.
> [   24.874116] nf_conntrack version 0.5.0 (3409 buckets, 13636 max)
> [   24.875659] ctnetlink v0.93: registering with nfnetlink.
> [   24.876715] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
> [   24.877665] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
> [   24.879021] xt_time: kernel timezone is -0000
> [   24.879744] ip_set: protocol 6
> [   24.880330] IPVS: Registered protocols (TCP, UDP, SCTP, AH, ESP)
> [   24.881380] IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
> [   24.882803] IPVS: Creating netns size=3088 id=0
> [   24.883571] IPVS: ipvs loaded.
> [   24.884158] IPVS: [rr] scheduler registered.
> [   24.884840] IPVS: [wrr] scheduler registered.
> [   24.885527] IPVS: [lc] scheduler registered.
> [   24.886197] IPVS: [wlc] scheduler registered.
> [   24.886890] IPVS: [lblc] scheduler registered.
> [   24.887581] IPVS: [lblcr] scheduler registered.
> [   24.888275] IPVS: [dh] scheduler registered.
> [   24.889003] IPVS: [sh] scheduler registered.
> [   24.889651] IPVS: [sed] scheduler registered.
> [   24.890306] IPVS: [nq] scheduler registered.
> [   24.891057] IPVS: [sip] pe registered.
> [   24.891709] IPv4 over IPv4 tunneling driver
> [   24.892913] gre: GRE over IPv4 demultiplexor driver
> [   24.893635] ip_gre: GRE over IPv4 tunneling driver
> [   24.895106] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   24.896154] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
> [   24.897204] arp_tables: (C) 2002 David S. Miller
> [   24.897982] TCP: bic registered
> [   24.898601] TCP: cubic registered
> [   24.899149] TCP: westwood registered
> [   24.899745] TCP: highspeed registered
> [   24.900374] TCP: hybla registered
> [   24.900941] TCP: htcp registered
> [   24.901478] TCP: vegas registered
> [   24.902021] TCP: veno registered
> [   24.902643] TCP: scalable registered
> [   24.903214] TCP: lp registered
> [   24.903744] TCP: yeah registered
> [   24.904297] TCP: illinois registered
> [   24.904945] Initializing XFRM netlink socket
> [   24.906501] NET: Registered protocol family 10
> [   24.910870] mip6: Mobile IPv6
> [   24.911479] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   24.912578] sit: IPv6 over IPv4 tunneling driver
> [   24.914367] NET: Registered protocol family 17
> [   24.915187] NET: Registered protocol family 15
> [   24.916090] Bridge firewalling registered
> [   24.916768] Ebtables v2.0 registered
> [   24.917696] NET: Registered protocol family 4
> [   24.918581] NET: Registered protocol family 5
> [   24.921117] NET: Registered protocol family 6
> [   24.932660] NET: Registered protocol family 11
> [   24.933517] NET: Registered protocol family 3
> [   24.934242] can: controller area network core (rev 20120528 abi 9)
> [   24.935545] NET: Registered protocol family 29
> [   24.936243] can: raw protocol (rev 20120528)
> [   24.936923] can: broadcast manager protocol (rev 20120528 t)
> [   24.937825] can: netlink gateway (rev 20101209)
> [   24.939622] IrCOMM protocol (Dag Brattli)
> [   24.945232] Bluetooth: Can't register RFCOMM TTY driver
> [   24.946097] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   24.946934] Bluetooth: BNEP filters: protocol multicast
> [   24.947725] Bluetooth: BNEP socket layer initialized
> [   24.948480] Bluetooth: CMTP (CAPI Emulation) ver 1.0
> [   24.949255] Bluetooth: CMTP socket layer initialized
> [   24.950068] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> [   24.950993] Bluetooth: HIDP socket layer initialized
> [   24.952040] RPC: Registered rdma transport module.
> [   24.953271] NET: Registered protocol family 33
> [   24.954025] Key type rxrpc registered
> [   24.954691] Key type rxrpc_s registered
> [   24.956818] RxRPC: Registered security type 2 'rxkad'
> [   24.957664] lec:lane_module_init: lec.c: initialized
> [   24.958445] mpoa:atm_mpoa_init: mpc.c: initialized
> [   24.959166] l2tp_core: L2TP core driver, V2.0
> [   24.959901] l2tp_ppp: PPPoL2TP kernel driver, V2.0
> [   24.960651] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
> [   24.961655] l2tp_netlink: L2TP netlink interface
> [   24.962400] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
> [   24.963364] l2tp_debugfs: L2TP debugfs support
> [   24.964135] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
> [   24.965150] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
> [   24.966857] DECnet: Routing cache hash table of 256 buckets, 20Kbytes
> [   24.967861] NET: Registered protocol family 12
> [   24.968708] NET: Registered protocol family 35
> [   24.969751] 8021q: 802.1Q VLAN Support v1.8
> [   24.971960] DCCP: Activated CCID 2 (TCP-like)
> [   24.972875] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
> [   24.993538] DCCP watch registered (port=0)
> [   24.994847] sctp: Hash tables configured (established 1638 bind 1638)
> [   25.017079] sctp_probe: probe registered (port=0)
> [   25.018336] NET: Registered protocol family 21
> [   25.019510] Registered RDS/iwarp transport
> [   25.020458] Registered RDS/infiniband transport
> [   25.021395] Registered RDS/tcp transport
> [   25.022288] lib80211: common routines for IEEE802.11 drivers
> [   25.023195] lib80211_crypt: registered algorithm 'NULL'
> [   25.024034] lib80211_crypt: registered algorithm 'WEP'
> [   25.024806] lib80211_crypt: registered algorithm 'CCMP'
> [   25.025573] lib80211_crypt: registered algorithm 'TKIP'
> [   25.026310] tipc: Activated (version 2.0.0)
> [   25.028068] NET: Registered protocol family 30
> [   25.028745] tipc: Started in single node mode
> [   25.029419] 9pnet: Installing 9P2000 support
> [   25.030397] NET: Registered protocol family 36
> [   25.031161] Key type dns_resolver registered
> [   25.031870] Key type ceph registered
> [   25.032481] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
> [   25.033755] batman_adv: B.A.T.M.A.N. advanced 2012.5.0 (compatibility version 14) loaded
> [   25.037259] 
> [   25.037259] printing PIC contents
> [   25.038093] ... PIC  IMR: ffff
> [   25.038616] ... PIC  IRR: 9153
> [   25.039137] ... PIC  ISR: 0000
> [   25.039675] ... PIC ELCR: 0c00
> [   25.040279] printing local APIC contents on CPU#0/0:
> [   25.041058] ... APIC ID:      00000000 (0)
> [   25.041711] ... APIC VERSION: 00050014
> [   25.042324] ... APIC TASKPRI: 00000000 (00)
> [   25.042991] ... APIC PROCPRI: 00000000
> [   25.043609] ... APIC LDR: 01000000
> [   25.044185] ... APIC DFR: ffffffff
> [   25.044271] ... APIC SPIV: 000001ff
> [   25.044271] ... APIC ISR field:
> [   25.044271] 0000000000000000000000000000000000000000000000000000000000000000
> [   25.044271] ... APIC TMR field:
> [   25.044271] 0000000004000000000000000000000000000000000000000000000000000000
> [   25.044271] ... APIC IRR field:
> [   25.044271] 0000000000000000000000000000000000000000000000000000000000000000
> [   25.044271] ... APIC ESR: 00000000
> [   25.044271] ... APIC ICR: 000008fd
> [   25.044271] ... APIC ICR2: 02000000
> [   25.044271] ... APIC LVTT: 000000ef
> [   25.044271] ... APIC LVTPC: 00010000
> [   25.044271] ... APIC LVT0: 00010700
> [   25.044271] ... APIC LVT1: 00000400
> [   25.044271] ... APIC LVTERR: 000000fe
> [   25.044271] ... APIC TMICT: 001a980b
> [   25.044271] ... APIC TMCCT: 00068c51
> [   25.044271] ... APIC TDCR: 00000003
> [   25.044271] 
> [   25.058697] number of MP IRQ sources: 15.
> [   25.059324] number of IO-APIC #2 registers: 24.
> [   25.060023] testing the IO APIC.......................
> [   25.060774] IO APIC #2......
> [   25.061267] .... register #00: 00000000
> [   25.061870] .......    : physical APIC id: 00
> [   25.062525] .......    : Delivery Type: 0
> [   25.063135] .......    : LTS          : 0
> [   25.063772] .... register #01: 00170011
> [   25.064396] .......     : max redirection entries: 17
> [   25.065125] .......     : PRQ implemented: 0
> [   25.065769] .......     : IO APIC version: 11
> [   25.066421] .... register #02: 00000000
> [   25.067016] .......     : arbitration: 00
> [   25.067652] .... IRQ redirection table:
> [   25.068267]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
> [   25.069046]  00 00  1    0    0   0   0    0    0    00
> [   25.069870]  01 03  0    0    0   0   0    1    1    31
> [   25.070697]  02 03  0    0    0   0   0    1    1    30
> [   25.071536]  03 03  0    0    0   0   0    1    1    33
> [   25.072418]  04 03  1    0    0   0   0    1    1    34
> [   25.073273]  05 03  1    1    0   0   0    1    1    35
> [   25.074105]  06 03  0    0    0   0   0    1    1    36
> [   25.074930]  07 03  0    0    0   0   0    1    1    37
> [   25.075770]  08 03  0    0    0   0   0    1    1    38
> [   25.076638]  09 03  0    1    0   0   0    1    1    39
> [   25.077542]  0a 03  0    1    0   0   0    1    1    3A
> [   25.078363]  0b 03  1    1    0   0   0    1    1    3B
> [   25.079187]  0c 03  0    0    0   0   0    1    1    3C
> [   25.080085]  0d 03  0    0    0   0   0    1    1    3D
> [   25.080921]  0e 03  0    0    0   0   0    1    1    3E
> [   25.081745]  0f 03  0    0    0   0   0    1    1    3F
> [   25.082567]  10 00  1    0    0   0   0    0    0    00
> [   25.083394]  11 00  1    0    0   0   0    0    0    00
> [   25.084260]  12 00  1    0    0   0   0    0    0    00
> [   25.085099]  13 00  1    0    0   0   0    0    0    00
> [   25.085925]  14 00  1    0    0   0   0    0    0    00
> [   25.086750]  15 00  1    0    0   0   0    0    0    00
> [   25.087591]  16 00  1    0    0   0   0    0    0    00
> [   25.088482]  17 00  1    0    0   0   0    0    0    00
> [   25.089329] IRQ to pin mappings:
> [   25.089870] IRQ0 -> 0:2
> [   25.090468] IRQ1 -> 0:1
> [   25.091067] IRQ3 -> 0:3
> [   25.091686] IRQ4 -> 0:4
> [   25.092322] IRQ5 -> 0:5
> [   25.092931] IRQ6 -> 0:6
> [   25.093533] IRQ7 -> 0:7
> [   25.094127] IRQ8 -> 0:8
> [   25.094732] IRQ9 -> 0:9
> [   25.095333] IRQ10 -> 0:10
> [   25.095964] IRQ11 -> 0:11
> [   25.096621] IRQ12 -> 0:12
> [   25.097235] IRQ13 -> 0:13
> [   25.097862] IRQ14 -> 0:14
> [   25.098480] IRQ15 -> 0:15
> [   25.099095] .................................... done.
> [   25.100904] PM: Hibernation image not present or could not be loaded.
> [   25.101950] registered taskstats version 1
> [   25.102609] Running tests on trace events:
> [   25.103261] Testing event 9p_client_req: OK
> [   25.112828] Testing event 9p_client_res: OK
> [   25.120872] Testing event 9p_protocol_dump: OK
> [   25.128869] Testing event drv_return_void: OK
> [   25.136713] Testing event drv_return_int: OK
> [   25.184896] Testing event drv_return_bool: OK
> [   25.200790] Testing event drv_return_u64: OK
> [   25.216758] Testing event drv_start: OK
> [   25.232789] Testing event drv_get_et_strings: OK
> [   25.248790] Testing event drv_get_et_sset_count: OK
> [   25.264740] Testing event drv_get_et_stats: OK
> [   25.280820] Testing event drv_suspend: OK
> [   25.296733] Testing event drv_resume: OK
> [   25.312750] Testing event drv_set_wakeup: OK
> [   25.328745] Testing event drv_stop: OK
> [   25.344793] Testing event drv_add_interface: OK
> [   25.360784] Testing event drv_change_interface: OK
> [   25.376793] Testing event drv_remove_interface: OK
> [   25.392748] Testing event drv_config: OK
> [   25.408748] Testing event drv_bss_info_changed: OK
> [   25.424792] Testing event drv_prepare_multicast: OK
> [   25.440749] Testing event drv_configure_filter: OK
> [   25.456781] Testing event drv_set_tim: OK
> [   25.472745] Testing event drv_set_key: OK
> [   25.488750] Testing event drv_update_tkip_key: OK
> [   25.504734] Testing event drv_hw_scan: OK
> [   25.520747] Testing event drv_cancel_hw_scan: OK
> [   25.536791] Testing event drv_sched_scan_start: OK
> [   25.559220] Testing event drv_sched_scan_stop: OK
> [   25.568664] Testing event drv_sw_scan_start: OK
> [   25.592702] Testing event drv_sw_scan_complete: OK
> [   25.608816] Testing event drv_get_stats: OK
> [   25.624789] Testing event drv_get_tkip_seq: OK
> [   25.640703] Testing event drv_set_frag_threshold: OK
> [   25.656713] Testing event drv_set_rts_threshold: OK
> [   25.672724] Testing event drv_set_coverage_class: OK
> [   25.688682] Testing event drv_sta_notify: OK
> [   25.704643] Testing event drv_sta_state: OK
> [   25.720739] Testing event drv_sta_rc_update: OK
> [   25.736740] Testing event drv_sta_add: OK
> [   25.744707] Testing event drv_sta_remove: OK
> [   25.768723] Testing event drv_conf_tx: OK
> [   25.776693] Testing event drv_get_tsf: OK
> [   25.784786] Testing event drv_set_tsf: OK
> [   25.792694] Testing event drv_reset_tsf: OK
> [   25.800755] Testing event drv_tx_last_beacon: OK
> [   25.848817] Testing event drv_ampdu_action: OK
> [   25.864790] Testing event drv_get_survey: OK
> [   25.880857] Testing event drv_flush: OK
> [   25.896746] Testing event drv_channel_switch: OK
> [   25.912769] Testing event drv_set_antenna: OK
> [   25.928777] Testing event drv_get_antenna: OK
> [   25.936715] Testing event drv_remain_on_channel: OK
> [   25.960772] Testing event drv_cancel_remain_on_channel: OK
> [   25.976770] Testing event drv_set_ringparam: OK
> [   25.992689] Testing event drv_get_ringparam: OK
> [   26.008741] Testing event drv_tx_frames_pending: OK
> [   26.016653] Testing event drv_offchannel_tx_cancel_wait: OK
> [   26.040717] Testing event drv_set_bitrate_mask: OK
> [   26.056781] Testing event drv_set_rekey_data: OK
> [   26.072811] Testing event drv_rssi_callback: OK
> [   26.088779] Testing event drv_release_buffered_frames: OK
> [   26.104701] Testing event drv_allow_buffered_frames: OK
> [   26.120781] Testing event drv_get_rssi: OK
> [   26.136786] Testing event drv_mgd_prepare_tx: OK
> [   26.152763] Testing event drv_add_chanctx: OK
> [   26.168810] Testing event drv_remove_chanctx: OK
> [   26.184696] Testing event drv_change_chanctx: OK
> [   26.200766] Testing event drv_assign_vif_chanctx: OK
> [   26.216814] Testing event drv_unassign_vif_chanctx: OK
> [   26.232712] Testing event drv_start_ap: OK
> [   26.248777] Testing event drv_stop_ap: OK
> [   26.264715] Testing event drv_restart_complete: OK
> [   26.280745] Testing event api_start_tx_ba_session: OK
> [   26.296787] Testing event api_start_tx_ba_cb: OK
> [   26.304709] Testing event api_stop_tx_ba_session: OK
> [   26.328819] Testing event api_stop_tx_ba_cb: OK
> [   26.344787] Testing event api_restart_hw: OK
> [   26.360749] Testing event api_beacon_loss: OK
> [   26.376780] Testing event api_connection_loss: OK
> [   26.392777] Testing event api_cqm_rssi_notify: OK
> [   26.408660] Testing event api_scan_completed: OK
> [   26.424780] Testing event api_sched_scan_results: OK
> [   26.440760] Testing event api_sched_scan_stopped: OK
> [   26.456828] Testing event api_sta_block_awake: OK
> [   26.472823] Testing event api_chswitch_done: OK
> [   26.488820] Testing event api_ready_on_channel: OK
> [   26.496678] Testing event api_remain_on_channel_expired: OK
> [   26.520809] Testing event api_gtk_rekey_notify: OK
> [   26.536720] Testing event api_enable_rssi_reports: OK
> [   26.552778] Testing event api_eosp: OK
> [   26.568784] Testing event wake_queue: OK
> [   26.584761] Testing event stop_queue: OK
> [   26.600754] Testing event rdev_suspend: OK
> [   26.616826] Testing event rdev_return_int: OK
> [   26.632782] Testing event rdev_scan: OK
> [   26.648664] Testing event rdev_resume: OK
> [   26.664757] Testing event rdev_return_void: OK
> [   26.680780] Testing event rdev_get_ringparam: OK
> [   26.696716] Testing event rdev_get_antenna: OK
> [   26.712756] Testing event rdev_rfkill_poll: OK
> [   26.728781] Testing event rdev_set_wakeup: OK
> [   26.744724] Testing event rdev_add_virtual_intf: OK
> [   26.760757] Testing event rdev_return_wdev: OK
> [   26.776787] Testing event rdev_del_virtual_intf: OK
> [   26.792766] Testing event rdev_change_virtual_intf: OK
> [   26.808828] Testing event rdev_add_key: OK
> [   26.824824] Testing event rdev_get_key: OK
> [   26.840796] Testing event rdev_del_key: OK
> [   26.856778] Testing event rdev_set_default_key: OK
> [   26.872710] Testing event rdev_set_default_mgmt_key: OK
> [   26.888759] Testing event rdev_start_ap: OK
> [   26.904780] Testing event rdev_change_beacon: OK
> [   26.920716] Testing event rdev_stop_ap: OK
> [   26.936757] Testing event rdev_get_et_stats: OK
> [   26.952823] Testing event rdev_sched_scan_stop: OK
> [   26.968810] Testing event rdev_set_rekey_data: OK
> [   26.984875] Testing event rdev_get_mesh_config: OK
> [   26.992760] Testing event rdev_leave_mesh: OK
> [   27.000677] Testing event rdev_leave_ibss: OK
> [   27.008696] Testing event rdev_flush_pmksa: OK
> [   27.016745] Testing event rdev_add_station: OK
> [   27.024719] Testing event rdev_change_station: OK
> [   27.032710] Testing event rdev_del_station: OK
> [   27.040670] Testing event rdev_get_station: OK
> [   27.112649] Testing event rdev_del_mpath: OK
> [   27.128753] Testing event rdev_set_wds_peer: OK
> [   27.136708] Testing event rdev_dump_station: OK
> [   27.144660] Testing event rdev_return_int_station_info: OK
> [   27.176671] Testing event rdev_add_mpath: OK
> [   27.192654] Testing event rdev_change_mpath: OK
> [   27.208709] Testing event rdev_get_mpath: OK
> [   27.224704] Testing event rdev_dump_mpath: OK
> [   27.240783] Testing event rdev_return_int_mpath_info: OK
> [   27.260791] Testing event rdev_return_int_mesh_config: OK
> [   27.280786] Testing event rdev_update_mesh_config: OK
> [   27.296739] Testing event rdev_join_mesh: OK
> [   27.312706] Testing event rdev_change_bss: OK
> [   27.328840] Testing event rdev_set_txq_params: OK
> [   27.344779] Testing event rdev_libertas_set_mesh_channel: OK
> [   27.360646] Testing event rdev_set_monitor_channel: OK
> [   27.376662] Testing event rdev_auth: OK
> [   27.392753] Testing event rdev_assoc: OK
> [   27.400719] Testing event rdev_deauth: OK
> [   27.424775] Testing event rdev_disassoc: OK
> [   27.440760] Testing event rdev_mgmt_tx_cancel_wait: OK
> [   27.456782] Testing event rdev_set_power_mgmt: OK
> [   27.476637] Testing event rdev_connect: OK
> [   27.492840] Testing event rdev_set_cqm_rssi_config: OK
> [   27.512791] Testing event rdev_set_cqm_txe_config: OK
> [   27.528789] Testing event rdev_disconnect: OK
> [   27.544771] Testing event rdev_join_ibss: OK
> [   27.552621] Testing event rdev_set_wiphy_params: OK
> [   27.576779] Testing event rdev_get_tx_power: OK
> [   27.596743] Testing event rdev_set_tx_power: OK
> [   27.612680] Testing event rdev_return_int_int: OK
> [   27.628730] Testing event rdev_set_bitrate_mask: OK
> [   27.644733] Testing event rdev_mgmt_frame_register: OK
> [   27.660723] Testing event rdev_return_int_tx_rx: OK
> [   27.676732] Testing event rdev_return_void_tx_rx: OK
> [   27.692688] Testing event rdev_set_ringparam: OK
> [   27.700725] Testing event rdev_set_antenna: OK
> [   27.724739] Testing event rdev_sched_scan_start: OK
> [   27.740699] Testing event rdev_tdls_mgmt: OK
> [   27.756786] Testing event rdev_dump_survey: OK
> [   27.772771] Testing event rdev_return_int_survey_info: OK
> [   27.780711] Testing event rdev_tdls_oper: OK
> [   27.804743] Testing event rdev_probe_client: OK
> [   27.820714] Testing event rdev_set_pmksa: OK
> [   27.836696] Testing event rdev_del_pmksa: OK
> [   27.852722] Testing event rdev_remain_on_channel: OK
> [   27.868740] Testing event rdev_return_int_cookie: OK
> [   27.884694] Testing event rdev_cancel_remain_on_channel: OK
> [   27.892741] Testing event rdev_mgmt_tx: OK
> [   27.916763] Testing event rdev_set_noack_map: OK
> [   27.932731] Testing event rdev_get_et_sset_count: OK
> [   27.948723] Testing event rdev_get_et_strings: OK
> [   27.964688] Testing event rdev_get_channel: OK
> [   27.980714] Testing event rdev_return_chandef: OK
> [   27.996694] Testing event rdev_start_p2p_device: OK
> [   28.012762] Testing event rdev_stop_p2p_device: OK
> [   28.028735] Testing event cfg80211_return_bool: OK
> [   28.044811] Testing event cfg80211_notify_new_peer_candidate: OK
> [   28.060780] Testing event cfg80211_send_rx_auth: OK
> [   28.076682] Testing event cfg80211_send_rx_assoc: OK
> [   28.092712] Testing event __cfg80211_send_deauth: OK
> [   28.100718] Testing event __cfg80211_send_disassoc: OK
> [   28.108797] Testing event cfg80211_send_unprot_deauth: OK
> [   28.140723] Testing event cfg80211_send_unprot_disassoc: OK
> [   28.156695] Testing event cfg80211_send_auth_timeout: OK
> [   28.172735] Testing event cfg80211_send_assoc_timeout: OK
> [   28.188778] Testing event cfg80211_michael_mic_failure: OK
> [   28.204777] Testing event cfg80211_ready_on_channel: OK
> [   28.220756] Testing event cfg80211_ready_on_channel_expired: OK
> [   28.228700] Testing event cfg80211_new_sta: OK
> [   28.252698] Testing event cfg80211_del_sta: OK
> [   28.268682] Testing event cfg80211_rx_mgmt: OK
> [   28.284661] Testing event cfg80211_mgmt_tx_status: OK
> [   28.300767] Testing event cfg80211_cqm_rssi_notify: OK
> [   28.316730] Testing event cfg80211_reg_can_beacon: OK
> [   28.332764] Testing event cfg80211_ch_switch_notify: OK
> [   28.340710] Testing event cfg80211_ibss_joined: OK
> [   28.348725] Testing event cfg80211_rx_spurious_frame: OK
> [   28.384702] Testing event cfg80211_rx_unexpected_4addr_frame: OK
> [   28.400651] Testing event cfg80211_probe_status: OK
> [   28.416858] Testing event cfg80211_cqm_pktloss_notify: OK
> [   28.432691] Testing event cfg80211_gtk_rekey_notify: OK
> [   28.448643] Testing event cfg80211_pmksa_candidate_notify: OK
> [   28.471483] Testing event cfg80211_report_obss_beacon: OK
> [   28.492724] Testing event cfg80211_tdls_oper_request: OK
> [   28.508723] Testing event cfg80211_scan_done: OK
> [   28.524677] Testing event cfg80211_sched_scan_results: OK
> [   28.540706] Testing event cfg80211_sched_scan_stopped: OK
> [   28.556786] Testing event cfg80211_get_bss: OK
> [   28.572681] Testing event cfg80211_inform_bss_frame: OK
> [   28.592794] Testing event cfg80211_return_bss: OK
> [   28.608787] Testing event cfg80211_return_uint: OK
> [   28.624770] Testing event cfg80211_return_u32: OK
> [   28.632626] Testing event rpc_call_status: OK
> [   28.656824] Testing event rpc_bind_status: OK
> [   28.672865] Testing event rpc_connect_status: OK
> [   28.688898] Testing event rpc_task_begin: OK
> [   28.704893] Testing event rpc_task_run_action: OK
> [   28.720681] Testing event rpc_task_complete: OK
> [   28.728694] Testing event rpc_task_sleep: OK
> [   28.752841] Testing event rpc_task_wakeup: OK
> [   28.760745] Testing event kfree_skb: OK
> [   28.768867] Testing event consume_skb: OK
> [   28.776692] Testing event skb_copy_datagram_iovec: OK
> [   28.784819] Testing event net_dev_xmit: OK
> [   28.792720] Testing event net_dev_queue: OK
> [   28.848800] Testing event netif_receive_skb: OK
> [   28.864805] Testing event netif_rx: OK
> [   28.872698] Testing event napi_poll: OK
> [   28.896768] Testing event sock_rcvqueue_full: OK
> [   28.912696] Testing event sock_exceed_buf_limit: OK
> [   28.920693] Testing event udp_fail_queue_rcv_skb: OK
> [   28.928702] Testing event azx_pcm_trigger: OK
> [   28.960777] Testing event azx_get_position: OK
> [   28.976749] Testing event hda_send_cmd: OK
> [   28.996882] Testing event hda_get_response: OK
> [   29.013005] Testing event hda_bus_reset: OK
> [   29.024838] Testing event hda_power_down: OK
> [   29.032716] Testing event hda_power_up: OK
> [   29.068726] Testing event hda_power_count: OK
> [   29.084812] Testing event hda_unsol_event: OK
> [   29.092788] Testing event mc_event: OK
> [   29.100687] Testing event scsi_dispatch_cmd_start: OK
> [   29.108736] Testing event scsi_dispatch_cmd_error: OK
> [   29.148736] Testing event scsi_dispatch_cmd_done: OK
> [   29.164869] Testing event scsi_dispatch_cmd_timeout: OK
> [   29.180696] Testing event scsi_eh_wakeup: OK
> [   29.196779] Testing event regmap_reg_write: OK
> [   29.212723] Testing event regmap_reg_read: OK
> [   29.228733] Testing event regmap_reg_read_cache: OK
> [   29.244678] Testing event regmap_hw_read_start: OK
> [   29.260914] Testing event regmap_hw_read_done: OK
> [   29.280710] Testing event regmap_hw_write_start: OK
> [   29.288945] Testing event regmap_hw_write_done: OK
> [   29.316712] Testing event regcache_sync: OK
> [   29.332762] Testing event regmap_cache_only: OK
> [   29.340707] Testing event regmap_cache_bypass: OK
> [   29.364713] Testing event i915_gem_object_create: OK
> [   29.380739] Testing event i915_gem_object_bind: OK
> [   29.396837] Testing event i915_gem_object_unbind: OK
> [   29.412789] Testing event i915_gem_object_change_domain: OK
> [   29.428829] Testing event i915_gem_object_pwrite: OK
> [   29.436850] Testing event i915_gem_object_pread: OK
> [   29.444818] Testing event i915_gem_object_fault: OK
> [   29.452878] Testing event i915_gem_object_clflush: OK
> [   29.460821] Testing event i915_gem_object_destroy: OK
> [   29.468832] Testing event i915_gem_evict: OK
> [   29.476817] Testing event i915_gem_evict_everything: OK
> [   29.488712] Testing event i915_gem_ring_dispatch: OK
> [   29.496731] Testing event i915_gem_ring_flush: OK
> [   29.576782] Testing event i915_gem_request_add: OK
> [   29.592896] Testing event i915_gem_request_complete: OK
> [   29.612783] Testing event i915_gem_request_retire: OK
> [   29.628805] Testing event i915_gem_request_wait_begin: OK
> [   29.644860] Testing event i915_gem_request_wait_end: OK
> [   29.652813] Testing event i915_ring_wait_begin: OK
> [   29.660813] Testing event i915_ring_wait_end: OK
> [   29.668741] Testing event i915_flip_request: OK
> [   29.676791] Testing event i915_flip_complete: OK
> [   29.684805] Testing event i915_reg_rw: OK
> [   29.692865] Testing event intel_gpu_freq_change: OK
> [   29.700816] Testing event radeon_bo_create: OK
> [   29.708839] Testing event radeon_fence_emit: OK
> [   29.716818] Testing event radeon_fence_retire: OK
> [   29.804930] Testing event radeon_fence_wait_begin: OK
> [   29.812729] Testing event radeon_fence_wait_end: OK
> [   29.836822] Testing event drm_vblank_event: OK
> [   29.852829] Testing event drm_vblank_event_queued: OK
> [   29.860732] Testing event drm_vblank_event_delivered: OK
> [   29.868905] Testing event mix_pool_bytes: OK
> [   29.876817] Testing event mix_pool_bytes_nolock: OK
> [   29.884759] Testing event credit_entropy_bits: OK
> [   29.892829] Testing event get_random_bytes: OK
> [   29.900817] Testing event extract_entropy: OK
> [   29.908949] Testing event extract_entropy_user: OK
> [   29.916824] Testing event regulator_enable: OK
> [   29.924829] Testing event regulator_enable_delay: OK
> [   29.932816] Testing event regulator_enable_complete: OK
> [   30.028765] Testing event regulator_disable: OK
> [   30.044828] Testing event regulator_disable_complete: OK
> [   30.060803] Testing event regulator_set_voltage: OK
> [   30.076757] Testing event regulator_set_voltage_complete: OK
> [   30.096842] Testing event gpio_direction: OK
> [   30.104776] Testing event gpio_value: OK
> [   30.128803] Testing event block_rq_abort: OK
> [   30.144887] Testing event block_rq_requeue: OK
> [   30.160844] Testing event block_rq_complete: OK
> [   30.176871] Testing event block_rq_insert: OK
> [   30.184837] Testing event block_rq_issue: OK
> [   30.192808] Testing event block_bio_bounce: OK
> [   30.200842] Testing event block_bio_complete: OK
> [   30.208786] Testing event block_bio_backmerge: OK
> [   30.216878] Testing event block_bio_frontmerge: OK
> [   30.224808] Testing event block_bio_queue: OK
> [   30.232903] Testing event block_getrq: OK
> [   30.240793] Testing event block_sleeprq: OK
> [   30.248812] Testing event block_plug: OK
> [   30.256806] Testing event block_unplug: OK
> [   30.264853] Testing event block_split: OK
> [   30.368793] Testing event block_bio_remap: OK
> [   30.376880] Testing event block_rq_remap: OK
> [   30.400855] Testing event gfs2_glock_state_change: OK
> [   30.408876] Testing event gfs2_glock_put: OK
> [   30.416876] Testing event gfs2_demote_rq: OK
> [   30.428693] Testing event gfs2_promote: OK
> [   30.468900] Testing event gfs2_glock_queue: OK
> [   30.484727] Testing event gfs2_glock_lock_time: OK
> [   30.500866] Testing event gfs2_pin: OK
> [   30.516724] Testing event gfs2_log_flush: OK
> [   30.532878] Testing event gfs2_log_blocks: OK
> [   30.548838] Testing event gfs2_ail_flush: OK
> [   30.556871] Testing event gfs2_bmap: OK
> [   30.564731] Testing event gfs2_block_alloc: OK
> [   30.572880] Testing event gfs2_rs: OK
> [   30.580802] Testing event btrfs_transaction_commit: OK
> [   30.628881] Testing event btrfs_inode_new: OK
> [   30.636713] Testing event btrfs_inode_request: OK
> [   30.660857] Testing event btrfs_inode_evict: OK
> [   30.676863] Testing event btrfs_get_extent: OK
> [   30.696935] Testing event btrfs_ordered_extent_add: OK
> [   30.704713] Testing event btrfs_ordered_extent_remove: OK
> [   30.712652] Testing event btrfs_ordered_extent_start: OK
> [   30.744659] Testing event btrfs_ordered_extent_put: OK
> [   30.760773] Testing event __extent_writepage: OK
> [   30.768709] Testing event btrfs_writepage_end_io_hook: OK
> [   30.776736] Testing event btrfs_sync_file: OK
> [   30.808801] Testing event btrfs_sync_fs: OK
> [   30.824849] Testing event btrfs_delayed_tree_ref: OK
> [   30.832715] Testing event btrfs_delayed_data_ref: OK
> [   30.840828] Testing event btrfs_delayed_ref_head: OK
> [   30.848764] Testing event btrfs_chunk_alloc: OK
> [   30.856754] Testing event btrfs_chunk_free: OK
> [   30.864773] Testing event btrfs_cow_block: OK
> [   30.872762] Testing event btrfs_space_reservation: OK
> [   30.880724] Testing event btrfs_reserved_extent_alloc: OK
> [   30.952892] Testing event btrfs_reserved_extent_free: OK
> [   30.968774] Testing event find_free_extent: OK
> [   30.984848] Testing event btrfs_reserve_extent: OK
> [   30.992673] Testing event btrfs_reserve_extent_cluster: OK
> [   31.016878] Testing event btrfs_find_cluster: OK
> [   31.024683] Testing event btrfs_failed_cluster_setup: OK
> [   31.048828] Testing event btrfs_setup_cluster: OK
> [   31.064878] Testing event alloc_extent_state: OK
> [   31.072709] Testing event free_extent_state: OK
> [   31.096800] Testing event ocfs2_adjust_rightmost_branch: OK
> [   31.112879] Testing event ocfs2_rotate_tree_right: OK
> [   31.128806] Testing event ocfs2_append_rec_to_path: OK
> [   31.144770] Testing event ocfs2_insert_extent_start: OK
> [   31.160828] Testing event ocfs2_add_clusters_in_btree: OK
> [   31.176873] Testing event ocfs2_num_free_extents: OK
> [   31.184730] Testing event ocfs2_complete_edge_insert: OK
> [   31.208848] Testing event ocfs2_grow_tree: OK
> [   31.224778] Testing event ocfs2_rotate_subtree: OK
> [   31.240874] Testing event ocfs2_insert_extent: OK
> [   31.248791] Testing event ocfs2_split_extent: OK
> [   31.272841] Testing event ocfs2_remove_extent: OK
> [   31.280687] Testing event ocfs2_commit_truncate: OK
> [   31.304822] Testing event ocfs2_validate_extent_block: OK
> [   31.320718] Testing event ocfs2_rotate_leaf: OK
> [   31.336860] Testing event ocfs2_add_clusters_in_btree_ret: OK
> [   31.352889] Testing event ocfs2_mark_extent_written: OK
> [   31.368671] Testing event ocfs2_truncate_log_append: OK
> [   31.384854] Testing event ocfs2_replay_truncate_records: OK
> [   31.399194] Testing event ocfs2_flush_truncate_log: OK
> [   31.416865] Testing event ocfs2_begin_truncate_log_recovery: OK
> [   31.432856] Testing event ocfs2_truncate_log_recovery_num: OK
> [   31.440714] Testing event ocfs2_complete_truncate_log_recovery: OK
> [   31.464828] Testing event ocfs2_free_cached_blocks: OK
> [   31.472617] Testing event ocfs2_cache_cluster_dealloc: OK
> [   31.480662] Testing event ocfs2_run_deallocs: OK
> [   31.512909] Testing event ocfs2_cache_block_dealloc: OK
> [   31.529060] Testing event ocfs2_trim_extent: OK
> [   31.545055] Testing event ocfs2_trim_group: OK
> [   31.560706] Testing event ocfs2_trim_fs: OK
> [   31.568700] Testing event ocfs2_la_set_sizes: OK
> [   31.576797] Testing event ocfs2_alloc_should_use_local: OK
> [   31.612841] Testing event ocfs2_load_local_alloc: OK
> [   31.628834] Testing event ocfs2_begin_local_alloc_recovery: OK
> [   31.644894] Testing event ocfs2_reserve_local_alloc_bits: OK
> [   31.660837] Testing event ocfs2_local_alloc_count_bits: OK
> [   31.676895] Testing event ocfs2_local_alloc_find_clear_bits_search_bitmap: OK
> [   31.692850] Testing event ocfs2_local_alloc_find_clear_bits: OK
> [   31.708807] Testing event ocfs2_sync_local_to_main: OK
> [   31.716969] Testing event ocfs2_sync_local_to_main_free: OK
> [   31.724737] Testing event ocfs2_local_alloc_new_window: OK
> [   31.756826] Testing event ocfs2_local_alloc_new_window_result: OK
> [   31.764700] Testing event ocfs2_update_last_group_and_inode: OK
> [   31.772747] Testing event ocfs2_group_extend: OK
> [   31.804756] Testing event ocfs2_group_add: OK
> [   31.820716] Testing event ocfs2_validate_group_descriptor: OK
> [   31.836741] Testing event ocfs2_block_group_alloc_contig: OK
> [   31.852755] Testing event ocfs2_block_group_alloc_discontig: OK
> [   31.868775] Testing event ocfs2_block_group_alloc: OK
> [   31.884762] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
> [   31.900883] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
> [   31.908723] Testing event ocfs2_reserve_new_inode_new_group: OK
> [   31.916819] Testing event ocfs2_block_group_set_bits: OK
> [   31.924688] Testing event ocfs2_relink_block_group: OK
> [   31.932817] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
> [   31.940669] Testing event ocfs2_cluster_group_search_max_block: OK
> [   31.948837] Testing event ocfs2_block_group_search_max_block: OK
> [   31.956691] Testing event ocfs2_search_chain_begin: OK
> [   31.964818] Testing event ocfs2_search_chain_succ: OK
> [   31.972667] Testing event ocfs2_search_chain_end: OK
> [   31.980814] Testing event ocfs2_claim_suballoc_bits: OK
> [   31.988757] Testing event ocfs2_claim_new_inode_at_loc: OK
> [   31.996789] Testing event ocfs2_block_group_clear_bits: OK
> [   32.108699] Testing event ocfs2_free_suballoc_bits: OK
> [   32.124839] Testing event ocfs2_free_clusters: OK
> [   32.140844] Testing event ocfs2_get_suballoc_slot_bit: OK
> [   32.156885] Testing event ocfs2_test_suballoc_bit: OK
> [   32.172986] Testing event ocfs2_test_inode_bit: OK
> [   32.189029] Testing event ocfs2_validate_refcount_block: OK
> [   32.204871] Testing event ocfs2_purge_refcount_trees: OK
> [   32.212695] Testing event ocfs2_create_refcount_tree: OK
> [   32.220813] Testing event ocfs2_create_refcount_tree_blkno: OK
> [   32.228759] Testing event ocfs2_change_refcount_rec: OK
> [   32.236729] Testing event ocfs2_expand_inline_ref_root: OK
> [   32.244674] Testing event ocfs2_divide_leaf_refcount_block: OK
> [   32.252732] Testing event ocfs2_new_leaf_refcount_block: OK
> [   32.260674] Testing event ocfs2_insert_refcount_rec: OK
> [   32.268812] Testing event ocfs2_split_refcount_rec: OK
> [   32.276754] Testing event ocfs2_split_refcount_rec_insert: OK
> [   32.284815] Testing event ocfs2_increase_refcount_begin: OK
> [   32.292751] Testing event ocfs2_increase_refcount_change: OK
> [   32.300855] Testing event ocfs2_increase_refcount_insert: OK
> [   32.308753] Testing event ocfs2_increase_refcount_split: OK
> [   32.428744] Testing event ocfs2_remove_refcount_extent: OK
> [   32.436675] Testing event ocfs2_restore_refcount_block: OK
> [   32.444732] Testing event ocfs2_decrease_refcount_rec: OK
> [   32.452678] Testing event ocfs2_decrease_refcount: OK
> [   32.460804] Testing event ocfs2_mark_extent_refcounted: OK
> [   32.468682] Testing event ocfs2_calc_refcount_meta_credits: OK
> [   32.476674] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
> [   32.540744] Testing event ocfs2_add_refcount_flag: OK
> [   32.548738] Testing event ocfs2_prepare_refcount_change_for_del: OK
> [   32.556670] Testing event ocfs2_lock_refcount_allocators: OK
> [   32.564736] Testing event ocfs2_duplicate_clusters_by_page: OK
> [   32.572753] Testing event ocfs2_duplicate_clusters_by_jbd: OK
> [   32.580757] Testing event ocfs2_clear_ext_refcount: OK
> [   32.588801] Testing event ocfs2_replace_clusters: OK
> [   32.596759] Testing event ocfs2_make_clusters_writable: OK
> [   32.604809] Testing event ocfs2_refcount_cow_hunk: OK
> [   32.612751] Testing event ocfs2_symlink_get_block: OK
> [   32.620808] Testing event ocfs2_get_block: OK
> [   32.628750] Testing event ocfs2_get_block_end: OK
> [   32.636732] Testing event ocfs2_readpage: OK
> [   32.644676] Testing event ocfs2_writepage: OK
> [   32.652815] Testing event ocfs2_bmap: OK
> [   32.780705] Testing event ocfs2_try_to_write_inline_data: OK
> [   32.788765] Testing event ocfs2_write_begin_nolock: OK
> [   32.796701] Testing event ocfs2_write_end_inline: OK
> [   32.804688] Testing event ocfs2_fault: OK
> [   32.812728] Testing event ocfs2_file_open: OK
> [   32.820685] Testing event ocfs2_file_release: OK
> [   32.876684] Testing event ocfs2_sync_file: OK
> [   32.884693] Testing event ocfs2_file_aio_write: OK
> [   32.892766] Testing event ocfs2_file_splice_write: OK
> [   32.900684] Testing event ocfs2_file_splice_read: OK
> [   32.908762] Testing event ocfs2_file_aio_read: OK
> [   32.916751] Testing event ocfs2_truncate_file: OK
> [   32.924806] Testing event ocfs2_truncate_file_error: OK
> [   32.932699] Testing event ocfs2_extend_allocation: OK
> [   32.940670] Testing event ocfs2_extend_allocation_end: OK
> [   32.948725] Testing event ocfs2_write_zero_page: OK
> [   32.956666] Testing event ocfs2_zero_extend_range: OK
> [   32.964688] Testing event ocfs2_zero_extend: OK
> [   32.972765] Testing event ocfs2_setattr: OK
> [   32.980881] Testing event ocfs2_write_remove_suid: OK
> [   32.988809] Testing event ocfs2_zero_partial_clusters: OK
> [   32.996736] Testing event ocfs2_zero_partial_clusters_range1: OK
> [   33.132629] Testing event ocfs2_zero_partial_clusters_range2: OK
> [   33.148724] Testing event ocfs2_remove_inode_range: OK
> [   33.164734] Testing event ocfs2_prepare_inode_for_write: OK
> [   33.172728] Testing event generic_file_aio_read_ret: OK
> [   33.180664] Testing event ocfs2_iget_begin: OK
> [   33.188687] Testing event ocfs2_iget5_locked: OK
> [   33.196747] Testing event ocfs2_iget_end: OK
> [   33.204772] Testing event ocfs2_find_actor: OK
> [   33.212816] Testing event ocfs2_populate_inode: OK
> [   33.220807] Testing event ocfs2_read_locked_inode: OK
> [   33.228739] Testing event ocfs2_check_orphan_recovery_state: OK
> [   33.236770] Testing event ocfs2_validate_inode_block: OK
> [   33.244808] Testing event ocfs2_inode_is_valid_to_delete: OK
> [   33.252762] Testing event ocfs2_query_inode_wipe_begin: OK
> [   33.260810] Testing event ocfs2_query_inode_wipe_succ: OK
> [   33.268749] Testing event ocfs2_query_inode_wipe_end: OK
> [   33.276737] Testing event ocfs2_cleanup_delete_inode: OK
> [   33.284763] Testing event ocfs2_delete_inode: OK
> [   33.292806] Testing event ocfs2_clear_inode: OK
> [   33.436703] Testing event ocfs2_drop_inode: OK
> [   33.444738] Testing event ocfs2_inode_revalidate: OK
> [   33.452815] Testing event ocfs2_mark_inode_dirty: OK
> [   33.460762] Testing event ocfs2_read_virt_blocks: OK
> [   33.468813] Testing event ocfs2_refresh_slot_info: OK
> [   33.476760] Testing event ocfs2_map_slot_buffers: OK
> [   33.484809] Testing event ocfs2_map_slot_buffers_block: OK
> [   33.492766] Testing event ocfs2_find_slot: OK
> [   33.500689] Testing event ocfs2_do_node_down: OK
> [   33.508736] Testing event ocfs2_remount: OK
> [   33.516809] Testing event ocfs2_fill_super: OK
> [   33.524753] Testing event ocfs2_parse_options: OK
> [   33.532805] Testing event ocfs2_put_super: OK
> [   33.540695] Testing event ocfs2_statfs: OK
> [   33.548728] Testing event ocfs2_dismount_volume: OK
> [   33.556761] Testing event ocfs2_initialize_super: OK
> [   33.564816] Testing event ocfs2_validate_xattr_block: OK
> [   33.572809] Testing event ocfs2_xattr_extend_allocation: OK
> [   33.724704] Testing event ocfs2_init_xattr_set_ctxt: OK
> [   33.732765] Testing event ocfs2_xattr_bucket_find: OK
> [   33.740822] Testing event ocfs2_xattr_index_block_find: OK
> [   33.748753] Testing event ocfs2_xattr_index_block_find_rec: OK
> [   33.756818] Testing event ocfs2_iterate_xattr_buckets: OK
> [   33.764744] Testing event ocfs2_iterate_xattr_bucket: OK
> [   33.772703] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
> [   33.780730] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
> [   33.788683] Testing event ocfs2_xattr_create_index_block_begin: OK
> [   33.796746] Testing event ocfs2_xattr_create_index_block: OK
> [   33.804827] Testing event ocfs2_defrag_xattr_bucket: OK
> [   33.812740] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
> [   33.820807] Testing event ocfs2_divide_xattr_bucket_begin: OK
> [   33.828810] Testing event ocfs2_divide_xattr_bucket_move: OK
> [   33.836752] Testing event ocfs2_cp_xattr_bucket: OK
> [   33.844758] Testing event ocfs2_mv_xattr_buckets: OK
> [   33.852814] Testing event ocfs2_adjust_xattr_cross_cluster: OK
> [   33.860766] Testing event ocfs2_add_new_xattr_cluster_begin: OK
> [   33.868749] Testing event ocfs2_add_new_xattr_cluster: OK
> [   34.028873] Testing event ocfs2_add_new_xattr_cluster_insert: OK
> [   34.036689] Testing event ocfs2_extend_xattr_bucket: OK
> [   34.044785] Testing event ocfs2_add_new_xattr_bucket: OK
> [   34.052666] Testing event ocfs2_xattr_bucket_value_truncate: OK
> [   34.092843] Testing event ocfs2_rm_xattr_cluster: OK
> [   34.108872] Testing event ocfs2_reflink_xattr_header: OK
> [   34.124634] Testing event ocfs2_create_empty_xattr_block: OK
> [   34.132610] Testing event ocfs2_xattr_set_entry_bucket: OK
> [   34.140728] Testing event ocfs2_xattr_set_entry_index_block: OK
> [   34.148735] Testing event ocfs2_xattr_bucket_value_refcount: OK
> [   34.156724] Testing event ocfs2_reflink_xattr_buckets: OK
> [   34.164858] Testing event ocfs2_reflink_xattr_rec: OK
> [   34.172724] Testing event ocfs2_resv_insert: OK
> [   34.180640] Testing event ocfs2_resmap_find_free_bits_begin: OK
> [   34.188690] Testing event ocfs2_resmap_find_free_bits_end: OK
> [   34.268747] Testing event ocfs2_resv_find_window_begin: OK
> [   34.283256] Testing event ocfs2_resv_find_window_prev: OK
> [   34.300888] Testing event ocfs2_resv_find_window_next: OK
> [   34.316790] Testing event ocfs2_cannibalize_resv_begin: OK
> [   34.332775] Testing event ocfs2_cannibalize_resv_end: OK
> [   34.348876] Testing event ocfs2_resmap_resv_bits: OK
> [   34.364734] Testing event ocfs2_resmap_claimed_bits_begin: OK
> [   34.380808] Testing event ocfs2_resmap_claimed_bits_end: OK
> [   34.396700] Testing event ocfs2_recover_local_quota_file: OK
> [   34.412806] Testing event ocfs2_finish_quota_recovery: OK
> [   34.428866] Testing event olq_set_dquot: OK
> [   34.436806] Testing event ocfs2_validate_quota_block: OK
> [   34.444815] Testing event ocfs2_sync_dquot: OK
> [   34.452702] Testing event ocfs2_sync_dquot_helper: OK
> [   34.460699] Testing event ocfs2_write_dquot: OK
> [   34.508804] Testing event ocfs2_release_dquot: OK
> [   34.524763] Testing event ocfs2_acquire_dquot: OK
> [   34.540776] Testing event ocfs2_mark_dquot_dirty: OK
> [   34.556809] Testing event ocfs2_search_dirblock: OK
> [   34.564713] Testing event ocfs2_validate_dir_block: OK
> [   34.572790] Testing event ocfs2_find_entry_el: OK
> [   34.580696] Testing event ocfs2_dx_dir_search: OK
> [   34.620777] Testing event ocfs2_dx_dir_search_leaf_info: OK
> [   34.636651] Testing event ocfs2_delete_entry_dx: OK
> [   34.652817] Testing event ocfs2_readdir: OK
> [   34.668798] Testing event ocfs2_find_files_on_disk: OK
> [   34.684878] Testing event ocfs2_check_dir_for_entry: OK
> [   34.692689] Testing event ocfs2_dx_dir_attach_index: OK
> [   34.716760] Testing event ocfs2_dx_dir_format_cluster: OK
> [   34.724710] Testing event ocfs2_dx_dir_index_root_block: OK
> [   34.748889] Testing event ocfs2_extend_dir: OK
> [   34.764694] Testing event ocfs2_dx_dir_rebalance: OK
> [   34.772739] Testing event ocfs2_dx_dir_rebalance_split: OK
> [   34.796738] Testing event ocfs2_prepare_dir_for_insert: OK
> [   34.804650] Testing event ocfs2_lookup: OK
> [   34.812758] Testing event ocfs2_mkdir: OK
> [   34.844697] Testing event ocfs2_create: OK
> [   34.860901] Testing event ocfs2_unlink: OK
> [   34.876858] Testing event ocfs2_symlink_create: OK
> [   34.884766] Testing event ocfs2_mv_orphaned_inode_to_new: OK
> [   34.892805] Testing event ocfs2_lookup_ret: OK
> [   34.900700] Testing event ocfs2_mknod: OK
> [   34.940764] Testing event ocfs2_link: OK
> [   34.956726] Testing event ocfs2_unlink_noent: OK
> [   34.972770] Testing event ocfs2_double_lock: OK
> [   34.988768] Testing event ocfs2_double_lock_end: OK
> [   35.004890] Testing event ocfs2_rename: OK
> [   35.020769] Testing event ocfs2_rename_target_exists: OK
> [   35.036776] Testing event ocfs2_rename_disagree: OK
> [   35.052806] Testing event ocfs2_rename_over_existing: OK
> [   35.060662] Testing event ocfs2_create_symlink_data: OK
> [   35.068681] Testing event ocfs2_symlink_begin: OK
> [   35.100743] Testing event ocfs2_blkno_stringify: OK
> [   35.116763] Testing event ocfs2_orphan_add_begin: OK
> [   35.124659] Testing event ocfs2_orphan_add_end: OK
> [   35.132672] Testing event ocfs2_orphan_del: OK
> [   35.164773] Testing event ocfs2_dentry_revalidate: OK
> [   35.180649] Testing event ocfs2_dentry_revalidate_negative: OK
> [   35.196724] Testing event ocfs2_dentry_revalidate_delete: OK
> [   35.212765] Testing event ocfs2_dentry_revalidate_orphaned: OK
> [   35.228815] Testing event ocfs2_dentry_revalidate_nofsdata: OK
> [   35.244797] Testing event ocfs2_dentry_revalidate_ret: OK
> [   35.260685] Testing event ocfs2_find_local_alias: OK
> [   35.276702] Testing event ocfs2_dentry_attach_lock: OK
> [   35.292813] Testing event ocfs2_dentry_attach_lock_found: OK
> [   35.308779] Testing event ocfs2_get_dentry_begin: OK
> [   35.316740] Testing event ocfs2_get_dentry_test_bit: OK
> [   35.340812] Testing event ocfs2_get_dentry_stale: OK
> [   35.356777] Testing event ocfs2_get_dentry_generation: OK
> [   35.364760] Testing event ocfs2_get_dentry_end: OK
> [   35.388792] Testing event ocfs2_get_parent: OK
> [   35.404794] Testing event ocfs2_get_parent_end: OK
> [   35.420713] Testing event ocfs2_encode_fh_begin: OK
> [   35.436804] Testing event ocfs2_encode_fh_self: OK
> [   35.452891] Testing event ocfs2_encode_fh_parent: OK
> [   35.460664] Testing event ocfs2_encode_fh_type: OK
> [   35.468697] Testing event ocfs2_commit_cache_begin: OK
> [   35.500869] Testing event ocfs2_commit_cache_end: OK
> [   35.516886] Testing event ocfs2_extend_trans: OK
> [   35.532859] Testing event ocfs2_extend_trans_restart: OK
> [   35.548812] Testing event ocfs2_journal_access: OK
> [   35.556749] Testing event ocfs2_journal_dirty: OK
> [   35.564676] Testing event ocfs2_journal_init: OK
> [   35.596830] Testing event ocfs2_journal_init_maxlen: OK
> [   35.604855] Testing event ocfs2_journal_shutdown: OK
> [   35.616845] Testing event ocfs2_journal_shutdown_wait: OK
> [   35.624848] Testing event ocfs2_complete_recovery: OK
> [   35.632781] Testing event ocfs2_complete_recovery_end: OK
> [   35.640717] Testing event ocfs2_complete_recovery_slot: OK
> [   35.648763] Testing event ocfs2_recovery_thread_node: OK
> [   35.656655] Testing event ocfs2_recovery_thread_end: OK
> [   35.728606] Testing event ocfs2_recovery_thread: OK
> [   35.744633] Testing event ocfs2_replay_journal_recovered: OK
> [   35.760654] Testing event ocfs2_replay_journal_lock_err: OK
> [   35.776635] Testing event ocfs2_replay_journal_skip: OK
> [   35.792642] Testing event ocfs2_recover_node: OK
> [   35.808803] Testing event ocfs2_recover_node_skip: OK
> [   35.816732] Testing event ocfs2_mark_dead_nodes: OK
> [   35.824603] Testing event ocfs2_queue_orphan_scan_begin: OK
> [   35.832827] Testing event ocfs2_queue_orphan_scan_end: OK
> [   35.840627] Testing event ocfs2_orphan_filldir: OK
> [   35.848634] Testing event ocfs2_recover_orphans: OK
> [   35.904621] Testing event ocfs2_recover_orphans_iput: OK
> [   35.912766] Testing event ocfs2_wait_on_mount: OK
> [   35.920828] Testing event ocfs2_read_blocks_sync: OK
> [   35.928670] Testing event ocfs2_read_blocks_sync_jbd: OK
> [   35.968864] Testing event ocfs2_read_blocks_from_disk: OK
> [   35.984696] Testing event ocfs2_read_blocks_bh: OK
> [   36.000919] Testing event ocfs2_read_blocks_end: OK
> [   36.016845] Testing event ocfs2_write_block: OK
> [   36.024839] Testing event ocfs2_read_blocks_begin: OK
> [   36.032849] Testing event ocfs2_purge_copied_metadata_tree: OK
> [   36.040747] Testing event ocfs2_metadata_cache_purge: OK
> [   36.048724] Testing event ocfs2_buffer_cached_begin: OK
> [   36.096664] Testing event ocfs2_buffer_cached_end: OK
> [   36.112840] Testing event ocfs2_append_cache_array: OK
> [   36.128776] Testing event ocfs2_insert_cache_tree: OK
> [   36.144842] Testing event ocfs2_expand_cache: OK
> [   36.160755] Testing event ocfs2_set_buffer_uptodate: OK
> [   36.176704] Testing event ocfs2_set_buffer_uptodate_begin: OK
> [   36.192977] Testing event ocfs2_remove_metadata_array: OK
> [   36.208795] Testing event ocfs2_remove_metadata_tree: OK
> [   36.224834] Testing event ocfs2_remove_block_from_cache: OK
> [   36.232772] Testing event xfs_attr_list_sf: OK
> [   36.256728] Testing event xfs_attr_list_sf_all: OK
> [   36.272796] Testing event xfs_attr_list_leaf: OK
> [   36.288790] Testing event xfs_attr_list_leaf_end: OK
> [   36.304888] Testing event xfs_attr_list_full: OK
> [   36.320805] Testing event xfs_attr_list_add: OK
> [   36.336871] Testing event xfs_attr_list_wrong_blk: OK
> [   36.352788] Testing event xfs_attr_list_notfound: OK
> [   36.368906] Testing event xfs_attr_leaf_list: OK
> [   36.376667] Testing event xfs_attr_node_list: OK
> [   36.384740] Testing event xfs_perag_get: OK
> [   36.392626] Testing event xfs_perag_get_tag: OK
> [   36.400683] Testing event xfs_perag_put: OK
> [   36.408669] Testing event xfs_perag_set_reclaim: OK
> [   36.464685] Testing event xfs_perag_clear_reclaim: OK
> [   36.480821] Testing event xfs_perag_set_eofblocks: OK
> [   36.496838] Testing event xfs_perag_clear_eofblocks: OK
> [   36.512840] Testing event xfs_attr_list_node_descend: OK
> [   36.528687] Testing event xfs_iext_insert: OK
> [   36.544887] Testing event xfs_iext_remove: OK
> [   36.560798] Testing event xfs_bmap_pre_update: OK
> [   36.576840] Testing event xfs_bmap_post_update: OK
> [   36.592779] Testing event xfs_extlist: OK
> [   36.608743] Testing event xfs_buf_init: OK
> [   36.624884] Testing event xfs_buf_free: OK
> [   36.640815] Testing event xfs_buf_hold: OK
> [   36.656864] Testing event xfs_buf_rele: OK
> [   36.672684] Testing event xfs_buf_iodone: OK
> [   36.688889] Testing event xfs_buf_iorequest: OK
> [   36.704837] Testing event xfs_buf_bawrite: OK
> [   36.720793] Testing event xfs_buf_lock: OK
> [   36.736859] Testing event xfs_buf_lock_done: OK
> [   36.744762] Testing event xfs_buf_trylock: OK
> [   36.768825] Testing event xfs_buf_unlock: OK
> [   36.784796] Testing event xfs_buf_iowait: OK
> [   36.800829] Testing event xfs_buf_iowait_done: OK
> [   36.816868] Testing event xfs_buf_delwri_queue: OK
> [   36.824978] Testing event xfs_buf_delwri_queued: OK
> [   36.848818] Testing event xfs_buf_delwri_split: OK
> [   36.864797] Testing event xfs_buf_get_uncached: OK
> [   36.880909] Testing event xfs_bdstrat_shut: OK
> [   36.896932] Testing event xfs_buf_item_relse: OK
> [   36.912685] Testing event xfs_buf_item_iodone: OK
> [   36.928879] Testing event xfs_buf_item_iodone_async: OK
> [   36.944823] Testing event xfs_buf_error_relse: OK
> [   36.960790] Testing event xfs_trans_read_buf_io: OK
> [   36.968624] Testing event xfs_trans_read_buf_shut: OK
> [   36.976707] Testing event xfs_btree_corrupt: OK
> [   37.008872] Testing event xfs_da_btree_corrupt: OK
> [   37.024955] Testing event xfs_reset_dqcounts: OK
> [   37.041017] Testing event xfs_inode_item_push: OK
> [   37.056856] Testing event xfs_buf_find: OK
> [   37.072852] Testing event xfs_buf_get: OK
> [   37.088940] Testing event xfs_buf_read: OK
> [   37.104859] Testing event xfs_buf_ioerror: OK
> [   37.120856] Testing event xfs_buf_item_size: OK
> [   37.136868] Testing event xfs_buf_item_size_stale: OK
> [   37.144670] Testing event xfs_buf_item_format: OK
> [   37.175439] Testing event xfs_buf_item_format_stale: OK
> [   37.192821] Testing event xfs_buf_item_pin: OK
> [   37.208820] Testing event xfs_buf_item_unpin: OK
> [   37.224869] Testing event xfs_buf_item_unpin_stale: OK
> [   37.232665] Testing event xfs_buf_item_unlock: OK
> [   37.240818] Testing event xfs_buf_item_unlock_stale: OK
> [   37.248703] Testing event xfs_buf_item_committed: OK
> [   37.256767] Testing event xfs_buf_item_push: OK
> [   37.264675] Testing event xfs_trans_get_buf: OK
> [   37.272750] Testing event xfs_trans_get_buf_recur: OK
> [   37.280677] Testing event xfs_trans_getsb: OK
> [   37.288766] Testing event xfs_trans_getsb_recur: OK
> [   37.296701] Testing event xfs_trans_read_buf: OK
> [   37.384946] Testing event xfs_trans_read_buf_recur: OK
> [   37.400681] Testing event xfs_trans_log_buf: OK
> [   37.408696] Testing event xfs_trans_brelse: OK
> [   37.432759] Testing event xfs_trans_bjoin: OK
> [   37.448861] Testing event xfs_trans_bhold: OK
> [   37.464781] Testing event xfs_trans_bhold_release: OK
> [   37.480884] Testing event xfs_trans_binval: OK
> [   37.488716] Testing event xfs_ilock: OK
> [   37.496654] Testing event xfs_ilock_nowait: OK
> [   37.504774] Testing event xfs_ilock_demote: OK
> [   37.548834] Testing event xfs_iunlock: OK
> [   37.556785] Testing event xfs_iget_skip: OK
> [   37.580848] Testing event xfs_iget_reclaim: OK
> [   37.596830] Testing event xfs_iget_reclaim_fail: OK
> [   37.612716] Testing event xfs_iget_hit: OK
> [   37.632778] Testing event xfs_iget_miss: OK
> [   37.648829] Testing event xfs_getattr: OK
> [   37.664685] Testing event xfs_setattr: OK
> [   37.672832] Testing event xfs_readlink: OK
> [   37.696770] Testing event xfs_alloc_file_space: OK
> [   37.712819] Testing event xfs_free_file_space: OK
> [   37.732775] Testing event xfs_readdir: OK
> [   37.748903] Testing event xfs_get_acl: OK
> [   37.768796] Testing event xfs_vm_bmap: OK
> [   37.784684] Testing event xfs_file_ioctl: OK
> [   37.792840] Testing event xfs_file_compat_ioctl: OK
> [   37.816704] Testing event xfs_ioctl_setattr: OK
> [   37.832840] Testing event xfs_dir_fsync: OK
> [   37.840817] Testing event xfs_file_fsync: OK
> [   37.848765] Testing event xfs_destroy_inode: OK
> [   37.856692] Testing event xfs_evict_inode: OK
> [   37.896819] Testing event xfs_update_time: OK
> [   37.912765] Testing event xfs_dquot_dqalloc: OK
> [   37.920702] Testing event xfs_dquot_dqdetach: OK
> [   37.928783] Testing event xfs_inode_set_eofblocks_tag: OK
> [   37.936682] Testing event xfs_inode_clear_eofblocks_tag: OK
> [   37.944785] Testing event xfs_inode_free_eofblocks_invalid: OK
> [   37.952710] Testing event xfs_ihold: OK
> [   37.960871] Testing event xfs_irele: OK
> [   37.968708] Testing event xfs_inode_pin: OK
> [   37.976792] Testing event xfs_inode_unpin: OK
> [   37.984709] Testing event xfs_inode_unpin_nowait: OK
> [   37.992832] Testing event xfs_remove: OK
> [   38.000761] Testing event xfs_link: OK
> [   38.008910] Testing event xfs_lookup: OK
> [   38.016753] Testing event xfs_create: OK
> [   38.024873] Testing event xfs_symlink: OK
> [   38.032713] Testing event xfs_rename: OK
> [   38.040832] Testing event xfs_dqadjust: OK
> [   38.048694] Testing event xfs_dqreclaim_want: OK
> [   38.056871] Testing event xfs_dqreclaim_dirty: OK
> [   38.064667] Testing event xfs_dqreclaim_busy: OK
> [   38.072790] Testing event xfs_dqreclaim_done: OK
> [   38.248717] Testing event xfs_dqattach_found: OK
> [   38.264854] Testing event xfs_dqattach_get: OK
> [   38.272797] Testing event xfs_dqalloc: OK
> [   38.280810] Testing event xfs_dqtobp_read: OK
> [   38.288778] Testing event xfs_dqread: OK
> [   38.296871] Testing event xfs_dqread_fail: OK
> [   38.304700] Testing event xfs_dqget_hit: OK
> [   38.312807] Testing event xfs_dqget_miss: OK
> [   38.320776] Testing event xfs_dqget_freeing: OK
> [   38.328844] Testing event xfs_dqget_dup: OK
> [   38.336802] Testing event xfs_dqput: OK
> [   38.344883] Testing event xfs_dqput_wait: OK
> [   38.352694] Testing event xfs_dqput_free: OK
> [   38.360822] Testing event xfs_dqrele: OK
> [   38.368682] Testing event xfs_dqflush: OK
> [   38.376807] Testing event xfs_dqflush_force: OK
> [   38.384755] Testing event xfs_dqflush_done: OK
> [   38.392819] Testing event xfs_log_done_nonperm: OK
> [   38.400777] Testing event xfs_log_done_perm: OK
> [   38.408835] Testing event xfs_log_umount_write: OK
> [   38.416850] Testing event xfs_log_grant_sleep: OK
> [   38.424836] Testing event xfs_log_grant_wake: OK
> [   38.432770] Testing event xfs_log_grant_wake_up: OK
> [   38.616717] Testing event xfs_log_reserve: OK
> [   38.624673] Testing event xfs_log_reserve_exit: OK
> [   38.648701] Testing event xfs_log_regrant: OK
> [   38.664860] Testing event xfs_log_regrant_exit: OK
> [   38.680835] Testing event xfs_log_regrant_reserve_enter: OK
> [   38.688756] Testing event xfs_log_regrant_reserve_exit: OK
> [   38.696795] Testing event xfs_log_regrant_reserve_sub: OK
> [   38.728835] Testing event xfs_log_ungrant_enter: OK
> [   38.744790] Testing event xfs_log_ungrant_exit: OK
> [   38.760855] Testing event xfs_log_ungrant_sub: OK
> [   38.776719] Testing event xfs_log_force: OK
> [   38.784762] Testing event xfs_ail_push: OK
> [   38.792868] Testing event xfs_ail_pinned: OK
> [   38.800790] Testing event xfs_ail_locked: OK
> [   38.808906] Testing event xfs_ail_flushing: OK
> [   38.816794] Testing event xfs_file_read: OK
> [   38.824794] Testing event xfs_file_buffered_write: OK
> [   38.832683] Testing event xfs_file_direct_write: OK
> [   38.840779] Testing event xfs_file_splice_read: OK
> [   38.848700] Testing event xfs_file_splice_write: OK
> [   38.856777] Testing event xfs_writepage: OK
> [   38.864705] Testing event xfs_releasepage: OK
> [   38.968917] Testing event xfs_invalidatepage: OK
> [   38.976777] Testing event xfs_map_blocks_found: OK
> [   38.984895] Testing event xfs_map_blocks_alloc: OK
> [   38.992956] Testing event xfs_get_blocks_found: OK
> [   39.000705] Testing event xfs_get_blocks_alloc: OK
> [   39.008774] Testing event xfs_delalloc_enospc: OK
> [   39.016852] Testing event xfs_unwritten_convert: OK
> [   39.024809] Testing event xfs_get_blocks_notfound: OK
> [   39.032927] Testing event xfs_setfilesize: OK
> [   39.040798] Testing event xfs_itruncate_extents_start: OK
> [   39.048874] Testing event xfs_itruncate_extents_end: OK
> [   39.056775] Testing event xfs_pagecache_inval: OK
> [   39.064869] Testing event xfs_bunmap: OK
> [   39.072772] Testing event xfs_extent_busy: OK
> [   39.080861] Testing event xfs_extent_busy_enomem: OK
> [   39.088755] Testing event xfs_extent_busy_force: OK
> [   39.096915] Testing event xfs_extent_busy_reuse: OK
> [   39.104758] Testing event xfs_extent_busy_clear: OK
> [   39.112907] Testing event xfs_extent_busy_trim: OK
> [   39.120772] Testing event xfs_trans_commit_lsn: OK
> [   39.128854] Testing event xfs_agf: OK
> [   39.136737] Testing event xfs_free_extent: OK
> [   39.144862] Testing event xfs_alloc_exact_done: OK
> [   39.336830] Testing event xfs_alloc_exact_notfound: OK
> [   39.352737] Testing event xfs_alloc_exact_error: OK
> [   39.368862] Testing event xfs_alloc_near_nominleft: OK
> [   39.384854] Testing event xfs_alloc_near_first: OK
> [   39.392775] Testing event xfs_alloc_near_greater: OK
> [   39.400900] Testing event xfs_alloc_near_lesser: OK
> [   39.408797] Testing event xfs_alloc_near_error: OK
> [   39.416877] Testing event xfs_alloc_near_noentry: OK
> [   39.424791] Testing event xfs_alloc_near_busy: OK
> [   39.432824] Testing event xfs_alloc_size_neither: OK
> [   39.440787] Testing event xfs_alloc_size_noentry: OK
> [   39.448894] Testing event xfs_alloc_size_nominleft: OK
> [   39.456787] Testing event xfs_alloc_size_done: OK
> [   39.464814] Testing event xfs_alloc_size_error: OK
> [   39.472828] Testing event xfs_alloc_size_busy: OK
> [   39.480819] Testing event xfs_alloc_small_freelist: OK
> [   39.488756] Testing event xfs_alloc_small_notenough: OK
> [   39.496919] Testing event xfs_alloc_small_done: OK
> [   39.504813] Testing event xfs_alloc_small_error: OK
> [   39.512857] Testing event xfs_alloc_vextent_badargs: OK
> [   39.520849] Testing event xfs_alloc_vextent_nofix: OK
> [   39.528866] Testing event xfs_alloc_vextent_noagbp: OK
> [   39.536805] Testing event xfs_alloc_vextent_loopfailed: OK
> [   39.544823] Testing event xfs_alloc_vextent_allfailed: OK
> [   39.552795] Testing event xfs_dir2_sf_addname: OK
> [   39.560835] Testing event xfs_dir2_sf_create: OK
> [   39.568824] Testing event xfs_dir2_sf_lookup: OK
> [   39.768864] Testing event xfs_dir2_sf_replace: OK
> [   39.776749] Testing event xfs_dir2_sf_removename: OK
> [   39.800799] Testing event xfs_dir2_sf_toino4: OK
> [   39.816824] Testing event xfs_dir2_sf_toino8: OK
> [   39.824783] Testing event xfs_dir2_sf_to_block: OK
> [   39.832736] Testing event xfs_dir2_block_addname: OK
> [   39.840790] Testing event xfs_dir2_block_lookup: OK
> [   39.880769] Testing event xfs_dir2_block_replace: OK
> [   39.896776] Testing event xfs_dir2_block_removename: OK
> [   39.912812] Testing event xfs_dir2_block_to_sf: OK
> [   39.928824] Testing event xfs_dir2_block_to_leaf: OK
> [   39.944820] Testing event xfs_dir2_leaf_addname: OK
> [   39.952787] Testing event xfs_dir2_leaf_lookup: OK
> [   39.960761] Testing event xfs_dir2_leaf_replace: OK
> [   39.992962] Testing event xfs_dir2_leaf_removename: OK
> [   40.000769] Testing event xfs_dir2_leaf_to_block: OK
> [   40.008881] Testing event xfs_dir2_leaf_to_node: OK
> [   40.016714] Testing event xfs_dir2_node_addname: OK
> [   40.024782] Testing event xfs_dir2_node_lookup: OK
> [   40.079498] Testing event xfs_dir2_node_replace: OK
> [   40.088714] Testing event xfs_dir2_node_removename: OK
> [   40.096790] Testing event xfs_dir2_node_to_leaf: OK
> [   40.128734] Testing event xfs_attr_sf_add: OK
> [   40.144758] Testing event xfs_attr_sf_addname: OK
> [   40.152832] Testing event xfs_attr_sf_create: OK
> [   40.160788] Testing event xfs_attr_sf_lookup: OK
> [   40.168924] Testing event xfs_attr_sf_remove: OK
> [   40.176852] Testing event xfs_attr_sf_removename: OK
> [   40.184763] Testing event xfs_attr_sf_to_leaf: OK
> [   40.192916] Testing event xfs_attr_leaf_add: OK
> [   40.200789] Testing event xfs_attr_leaf_add_old: OK
> [   40.208841] Testing event xfs_attr_leaf_add_new: OK
> [   40.216807] Testing event xfs_attr_leaf_add_work: OK
> [   40.224881] Testing event xfs_attr_leaf_addname: OK
> [   40.320788] Testing event xfs_attr_leaf_create: OK
> [   40.336829] Testing event xfs_attr_leaf_compact: OK
> [   40.352774] Testing event xfs_attr_leaf_get: OK
> [   40.368905] Testing event xfs_attr_leaf_lookup: OK
> [   40.376734] Testing event xfs_attr_leaf_replace: OK
> [   40.400793] Testing event xfs_attr_leaf_remove: OK
> [   40.416951] Testing event xfs_attr_leaf_removename: OK
> [   40.424788] Testing event xfs_attr_leaf_split: OK
> [   40.432823] Testing event xfs_attr_leaf_split_before: OK
> [   40.440774] Testing event xfs_attr_leaf_split_after: OK
> [   40.448909] Testing event xfs_attr_leaf_clearflag: OK
> [   40.456770] Testing event xfs_attr_leaf_setflag: OK
> [   40.464913] Testing event xfs_attr_leaf_flipflags: OK
> [   40.472790] Testing event xfs_attr_leaf_to_sf: OK
> [   40.480838] Testing event xfs_attr_leaf_to_node: OK
> [   40.488806] Testing event xfs_attr_leaf_rebalance: OK
> [   40.496820] Testing event xfs_attr_leaf_unbalance: OK
> [   40.504674] Testing event xfs_attr_leaf_toosmall: OK
> [   40.512885] Testing event xfs_attr_node_addname: OK
> [   40.520799] Testing event xfs_attr_node_get: OK
> [   40.528806] Testing event xfs_attr_node_lookup: OK
> [   40.536713] Testing event xfs_attr_node_replace: OK
> [   40.544689] Testing event xfs_attr_node_removename: OK
> [   40.688849] Testing event xfs_attr_fillstate: OK
> [   40.704928] Testing event xfs_attr_refillstate: OK
> [   40.720801] Testing event xfs_attr_rmtval_get: OK
> [   40.736819] Testing event xfs_attr_rmtval_set: OK
> [   40.752857] Testing event xfs_attr_rmtval_remove: OK
> [   40.768885] Testing event xfs_da_split: OK
> [   40.784774] Testing event xfs_da_join: OK
> [   40.800865] Testing event xfs_da_link_before: OK
> [   40.816883] Testing event xfs_da_link_after: OK
> [   40.832885] Testing event xfs_da_unlink_back: OK
> [   40.848771] Testing event xfs_da_unlink_forward: OK
> [   40.864757] Testing event xfs_da_root_split: OK
> [   40.880949] Testing event xfs_da_root_join: OK
> [   40.896794] Testing event xfs_da_node_add: OK
> [   40.904676] Testing event xfs_da_node_create: OK
> [   40.928825] Testing event xfs_da_node_split: OK
> [   40.944770] Testing event xfs_da_node_remove: OK
> [   40.952685] Testing event xfs_da_node_rebalance: OK
> [   40.976770] Testing event xfs_da_node_unbalance: OK
> [   40.992955] Testing event xfs_da_node_toosmall: OK
> [   41.000826] Testing event xfs_da_swap_lastblock: OK
> [   41.008823] Testing event xfs_da_grow_inode: OK
> [   41.040979] Testing event xfs_da_shrink_inode: OK
> [   41.048828] Testing event xfs_da_fixhashpath: OK
> [   41.072772] Testing event xfs_da_path_shift: OK
> [   41.080707] Testing event xfs_dir2_leafn_add: OK
> [   41.104906] Testing event xfs_dir2_leafn_remove: OK
> [   41.120778] Testing event xfs_dir2_grow_inode: OK
> [   41.128701] Testing event xfs_dir2_shrink_inode: OK
> [   41.136684] Testing event xfs_dir2_leafn_moveents: OK
> [   41.168825] Testing event xfs_swap_extent_before: OK
> [   41.184897] Testing event xfs_swap_extent_after: OK
> [   41.200772] Testing event xfs_log_recover_item_add: OK
> [   41.216754] Testing event xfs_log_recover_item_add_cont: OK
> [   41.232807] Testing event xfs_log_recover_item_reorder_head: OK
> [   41.240775] Testing event xfs_log_recover_item_reorder_tail: OK
> [   41.248805] Testing event xfs_log_recover_item_recover: OK
> [   41.280886] Testing event xfs_log_recover_buf_not_cancel: OK
> [   41.296692] Testing event xfs_log_recover_buf_cancel: OK
> [   41.312904] Testing event xfs_log_recover_buf_cancel_add: OK
> [   41.328789] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
> [   41.344925] Testing event xfs_log_recover_buf_recover: OK
> [   41.352686] Testing event xfs_log_recover_buf_inode_buf: OK
> [   41.360788] Testing event xfs_log_recover_buf_reg_buf: OK
> [   41.392797] Testing event xfs_log_recover_buf_dquot_buf: OK
> [   41.408749] Testing event xfs_log_recover_inode_recover: OK
> [   41.424770] Testing event xfs_log_recover_inode_cancel: OK
> [   41.440738] Testing event xfs_log_recover_inode_skip: OK
> [   41.456773] Testing event xfs_discard_extent: OK
> [   41.472678] Testing event xfs_discard_toosmall: OK
> [   41.488803] Testing event xfs_discard_exclude: OK
> [   41.505011] Testing event xfs_discard_busy: OK
> [   41.512817] Testing event jbd2_checkpoint: OK
> [   41.536788] Testing event jbd2_start_commit: OK
> [   41.544700] Testing event jbd2_commit_locking: OK
> [   41.568884] Testing event jbd2_commit_flushing: OK
> [   41.584788] Testing event jbd2_commit_logging: OK
> [   41.600701] Testing event jbd2_drop_transaction: OK
> [   41.608817] Testing event jbd2_end_commit: OK
> [   41.632902] Testing event jbd2_submit_inode_data: OK
> [   41.640764] Testing event jbd2_run_stats: OK
> [   41.664818] Testing event jbd2_checkpoint_stats: OK
> [   41.680886] Testing event jbd2_update_log_tail: OK
> [   41.696762] Testing event jbd2_write_superblock: OK
> [   41.712823] Testing event jbd_checkpoint: OK
> [   41.728767] Testing event jbd_start_commit: OK
> [   41.744814] Testing event jbd_commit_locking: OK
> [   41.760878] Testing event jbd_commit_flushing: OK
> [   41.776897] Testing event jbd_commit_logging: OK
> [   41.784711] Testing event jbd_drop_transaction: OK
> [   41.808812] Testing event jbd_end_commit: OK
> [   41.824858] Testing event jbd_do_submit_data: OK
> [   41.840955] Testing event jbd_cleanup_journal_tail: OK
> [   41.856857] Testing event journal_write_superblock: OK
> [   41.872774] Testing event ext4_free_inode: OK
> [   41.888757] Testing event ext4_request_inode: OK
> [   41.896727] Testing event ext4_allocate_inode: OK
> [   41.920786] Testing event ext4_evict_inode: OK
> [   41.936757] Testing event ext4_drop_inode: OK
> [   41.952927] Testing event ext4_mark_inode_dirty: OK
> [   41.968691] Testing event ext4_begin_ordered_truncate: OK
> [   41.984692] Testing event ext4_write_begin: OK
> [   42.000714] Testing event ext4_da_write_begin: OK
> [   42.016713] Testing event ext4_ordered_write_end: OK
> [   42.032688] Testing event ext4_writeback_write_end: OK
> [   42.048687] Testing event ext4_journalled_write_end: OK
> [   42.064723] Testing event ext4_da_write_end: OK
> [   42.080678] Testing event ext4_da_writepages: OK
> [   42.088713] Testing event ext4_da_write_pages: OK
> [   42.096677] Testing event ext4_da_writepages_result: OK
> [   42.128764] Testing event ext4_writepage: OK
> [   42.144687] Testing event ext4_readpage: OK
> [   42.152717] Testing event ext4_releasepage: OK
> [   42.160718] Testing event ext4_invalidatepage: OK
> [   42.192779] Testing event ext4_discard_blocks: OK
> [   42.208760] Testing event ext4_mb_new_inode_pa: OK
> [   42.224691] Testing event ext4_mb_new_group_pa: OK
> [   42.240764] Testing event ext4_mb_release_inode_pa: OK
> [   42.256771] Testing event ext4_mb_release_group_pa: OK
> [   42.272766] Testing event ext4_discard_preallocations: OK
> [   42.288761] Testing event ext4_mb_discard_preallocations: OK
> [   42.304775] Testing event ext4_request_blocks: OK
> [   42.320755] Testing event ext4_allocate_blocks: OK
> [   42.336779] Testing event ext4_free_blocks: OK
> [   42.352757] Testing event ext4_sync_file_enter: OK
> [   42.368773] Testing event ext4_sync_file_exit: OK
> [   42.384765] Testing event ext4_sync_fs: OK
> [   42.400733] Testing event ext4_alloc_da_blocks: OK
> [   42.416726] Testing event ext4_mballoc_alloc: OK
> [   42.424760] Testing event ext4_mballoc_prealloc: OK
> [   42.448771] Testing event ext4_mballoc_discard: OK
> [   42.464757] Testing event ext4_mballoc_free: OK
> [   42.480698] Testing event ext4_forget: OK
> [   42.488683] Testing event ext4_da_update_reserve_space: OK
> [   42.512762] Testing event ext4_da_reserve_space: OK
> [   42.520767] Testing event ext4_da_release_space: OK
> [   42.544768] Testing event ext4_mb_bitmap_load: OK
> [   42.560777] Testing event ext4_mb_buddy_bitmap_load: OK
> [   42.576771] Testing event ext4_read_block_bitmap_load: OK
> [   42.592767] Testing event ext4_load_inode_bitmap: OK
> [   42.608784] Testing event ext4_direct_IO_enter: OK
> [   42.624764] Testing event ext4_direct_IO_exit: OK
> [   42.640774] Testing event ext4_fallocate_enter: OK
> [   42.656687] Testing event ext4_fallocate_exit: OK
> [   42.672772] Testing event ext4_unlink_enter: OK
> [   42.692770] Testing event ext4_unlink_exit: OK
> [   42.708783] Testing event ext4_truncate_enter: OK
> [   42.724770] Testing event ext4_truncate_exit: OK
> [   42.740780] Testing event ext4_ext_convert_to_initialized_enter: OK
> [   42.756765] Testing event ext4_ext_convert_to_initialized_fastpath: OK
> [   42.772761] Testing event ext4_ext_map_blocks_enter: OK
> [   42.788770] Testing event ext4_ind_map_blocks_enter: OK
> [   42.796649] Testing event ext4_ext_map_blocks_exit: OK
> [   42.820717] Testing event ext4_ind_map_blocks_exit: OK
> [   42.828715] Testing event ext4_ext_load_extent: OK
> [   42.836719] Testing event ext4_load_inode: OK
> [   42.868696] Testing event ext4_journal_start: OK
> [   42.884708] Testing event ext4_trim_extent: OK
> [   42.892657] Testing event ext4_trim_all_free: OK
> [   42.900753] Testing event ext4_ext_handle_uninitialized_extents: OK
> [   42.932762] Testing event ext4_get_implied_cluster_alloc_exit: OK
> [   42.948784] Testing event ext4_ext_put_in_cache: OK
> [   42.971609] Testing event ext4_ext_in_cache: OK
> [   42.988685] Testing event ext4_find_delalloc_range: OK
> [   43.004760] Testing event ext4_get_reserved_cluster_alloc: OK
> [   43.020777] Testing event ext4_ext_show_extent: OK
> [   43.036690] Testing event ext4_remove_blocks: OK
> [   43.052764] Testing event ext4_ext_rm_leaf: OK
> [   43.068779] Testing event ext4_ext_rm_idx: OK
> [   43.084692] Testing event ext4_ext_remove_space: OK
> [   43.100685] Testing event ext4_ext_remove_space_done: OK
> [   43.116767] Testing event ext4_es_insert_extent: OK
> [   43.124770] Testing event ext4_es_remove_extent: OK
> [   43.148769] Testing event ext4_es_find_extent_enter: OK
> [   43.164778] Testing event ext4_es_find_extent_exit: OK
> [   43.180691] Testing event ext3_free_inode: OK
> [   43.196768] Testing event ext3_request_inode: OK
> [   43.212775] Testing event ext3_allocate_inode: OK
> [   43.228691] Testing event ext3_evict_inode: OK
> [   43.244670] Testing event ext3_drop_inode: OK
> [   43.252710] Testing event ext3_mark_inode_dirty: OK
> [   43.260719] Testing event ext3_write_begin: OK
> [   43.292782] Testing event ext3_ordered_write_end: OK
> [   43.312766] Testing event ext3_writeback_write_end: OK
> [   43.328774] Testing event ext3_journalled_write_end: OK
> [   43.344779] Testing event ext3_ordered_writepage: OK
> [   43.364773] Testing event ext3_writeback_writepage: OK
> [   43.380785] Testing event ext3_journalled_writepage: OK
> [   43.400763] Testing event ext3_readpage: OK
> [   43.420773] Testing event ext3_releasepage: OK
> [   43.428754] Testing event ext3_invalidatepage: OK
> [   43.452769] Testing event ext3_discard_blocks: OK
> [   43.468786] Testing event ext3_request_blocks: OK
> [   43.484775] Testing event ext3_allocate_blocks: OK
> [   43.500822] Testing event ext3_free_blocks: OK
> [   43.508727] Testing event ext3_sync_file_enter: OK
> [   43.532806] Testing event ext3_sync_file_exit: OK
> [   43.548896] Testing event ext3_sync_fs: OK
> [   43.564821] Testing event ext3_rsv_window_add: OK
> [   43.580705] Testing event ext3_discard_reservation: OK
> [   43.596775] Testing event ext3_alloc_new_reservation: OK
> [   43.612762] Testing event ext3_reserved: OK
> [   43.628824] Testing event ext3_forget: OK
> [   43.644876] Testing event ext3_read_block_bitmap: OK
> [   43.652740] Testing event ext3_direct_IO_enter: OK
> [   43.676772] Testing event ext3_direct_IO_exit: OK
> [   43.692827] Testing event ext3_unlink_enter: OK
> [   43.708715] Testing event ext3_unlink_exit: OK
> [   43.724690] Testing event ext3_truncate_enter: OK
> [   43.732740] Testing event ext3_truncate_exit: OK
> [   43.740711] Testing event ext3_get_blocks_enter: OK
> [   43.748630] Testing event ext3_get_blocks_exit: OK
> [   43.756785] Testing event ext3_load_inode: OK
> [   43.764775] Testing event writeback_nothread: OK
> [   43.772740] Testing event writeback_queue: OK
> [   43.780693] Testing event writeback_exec: OK
> [   43.788771] Testing event writeback_start: OK
> [   43.796691] Testing event writeback_written: OK
> [   43.804729] Testing event writeback_wait: OK
> [   43.812699] Testing event writeback_pages_written: OK
> [   43.820702] Testing event writeback_nowork: OK
> [   43.828688] Testing event writeback_wake_background: OK
> [   43.836719] Testing event writeback_wake_thread: OK
> [   43.844689] Testing event writeback_wake_forker_thread: OK
> [   43.852719] Testing event writeback_bdi_register: OK
> [   43.860717] Testing event writeback_bdi_unregister: OK
> [   43.868746] Testing event writeback_thread_start: OK
> [   43.876710] Testing event writeback_thread_stop: OK
> [   43.884748] Testing event wbc_writepage: OK
> [   43.892711] Testing event writeback_queue_io: OK
> [   43.900749] Testing event global_dirty_state: OK
> [   43.908715] Testing event bdi_dirty_ratelimit: OK
> [   43.916747] Testing event balance_dirty_pages: OK
> [   44.128878] Testing event writeback_sb_inodes_requeue: OK
> [   44.144854] Testing event writeback_congestion_wait: OK
> [   44.152816] Testing event writeback_wait_iff_congested: OK
> [   44.160976] Testing event writeback_single_inode: OK
> [   44.168862] Testing event mm_migrate_pages: OK
> [   44.176809] Testing event mm_compaction_isolate_migratepages: OK
> [   44.184708] Testing event mm_compaction_isolate_freepages: OK
> [   44.192711] Testing event mm_compaction_migratepages: OK
> [   44.200758] Testing event kmalloc: OK
> [   44.208780] Testing event kmem_cache_alloc: OK
> [   44.216839] Testing event kmalloc_node: OK
> [   44.224684] Testing event kmem_cache_alloc_node: OK
> [   44.324794] Testing event kfree: OK
> [   44.340787] Testing event kmem_cache_free: OK
> [   44.356799] Testing event mm_page_free: OK
> [   44.372743] Testing event mm_page_free_batched: OK
> [   44.380710] Testing event mm_page_alloc: OK
> [   44.404746] Testing event mm_page_alloc_zone_locked: OK
> [   44.420758] Testing event mm_page_pcpu_drain: OK
> [   44.436746] Testing event mm_page_alloc_extfrag: OK
> [   44.452757] Testing event mm_vmscan_kswapd_sleep: OK
> [   44.468841] Testing event mm_vmscan_kswapd_wake: OK
> [   44.484738] Testing event mm_vmscan_wakeup_kswapd: OK
> [   44.492741] Testing event mm_vmscan_direct_reclaim_begin: OK
> [   44.516743] Testing event mm_vmscan_memcg_reclaim_begin: OK
> [   44.532756] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
> [   44.548756] Testing event mm_vmscan_direct_reclaim_end: OK
> [   44.564852] Testing event mm_vmscan_memcg_reclaim_end: OK
> [   44.580749] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
> [   44.588715] Testing event mm_shrink_slab_start: OK
> [   44.612809] Testing event mm_shrink_slab_end: OK
> [   44.620754] Testing event mm_vmscan_lru_isolate: OK
> [   44.628707] Testing event mm_vmscan_memcg_isolate: OK
> [   44.660830] Testing event mm_vmscan_writepage: OK
> [   44.668760] Testing event mm_vmscan_lru_shrink_inactive: OK
> [   44.676825] Testing event oom_score_adj_update: OK
> [   44.684697] Testing event rpm_suspend: OK
> [   44.692818] Testing event rpm_resume: OK
> [   44.700742] Testing event rpm_idle: OK
> [   44.708798] Testing event rpm_return_int: OK
> [   44.716741] Testing event cpu_idle: OK
> [   44.724749] Testing event cpu_frequency: OK
> [   44.732729] Testing event machine_suspend: OK
> [   44.740826] Testing event wakeup_source_activate: OK
> [   44.748741] Testing event wakeup_source_deactivate: OK
> [   44.756823] Testing event power_start: OK
> [   44.764730] Testing event power_frequency: OK
> [   44.772817] Testing event power_end: OK
> [   44.780732] Testing event clock_enable: OK
> [   44.788782] Testing event clock_disable: OK
> [   44.796740] Testing event clock_set_rate: OK
> [   44.804922] Testing event power_domain_target: OK
> [   44.812732] Testing event ftrace_test_filter: OK
> [   44.820811] Testing event module_load: OK
> [   44.828736] Testing event module_free: OK
> [   45.012841] Testing event module_get: OK
> [   45.028738] Testing event module_put: OK
> [   45.044832] Testing event module_request: OK
> [   45.060831] Testing event lock_acquire: OK
> [   45.068703] Testing event lock_release: OK
> [   45.092739] Testing event lock_contended: OK
> [   45.108773] Testing event lock_acquired: OK
> [   45.124856] Testing event sched_kthread_stop: OK
> [   45.140829] Testing event sched_kthread_stop_ret: OK
> [   45.156861] Testing event sched_wakeup: OK
> [   45.164746] Testing event sched_wakeup_new: OK
> [   45.172818] Testing event sched_switch: OK
> [   45.180704] Testing event sched_migrate_task: OK
> [   45.188765] Testing event sched_process_free: OK
> [   45.236680] Testing event sched_process_exit: OK
> [   45.252741] Testing event sched_wait_task: OK
> [   45.268849] Testing event sched_process_wait: OK
> [   45.284746] Testing event sched_process_fork: OK
> [   45.292740] Testing event sched_process_exec: OK
> [   45.300798] Testing event sched_stat_wait: OK
> [   45.308737] Testing event sched_stat_sleep: OK
> [   45.352835] Testing event sched_stat_iowait: OK
> [   45.368714] Testing event sched_stat_blocked: OK
> [   45.384863] Testing event sched_stat_runtime: OK
> [   45.400775] Testing event sched_pi_setprio: OK
> [   45.416703] Testing event rcu_utilization: OK
> [   45.432646] Testing event rcu_grace_period: OK
> [   45.440799] Testing event rcu_grace_period_init: OK
> [   45.464759] Testing event rcu_preempt_task: OK
> [   45.480723] Testing event rcu_unlock_preempted_task: OK
> [   45.496932] Testing event rcu_quiescent_state_report: OK
> [   45.512856] Testing event rcu_fqs: OK
> [   45.528702] Testing event rcu_dyntick: OK
> [   45.544925] Testing event rcu_prep_idle: OK
> [   45.552729] Testing event rcu_callback: OK
> [   45.560709] Testing event rcu_kfree_callback: OK
> [   45.592803] Testing event rcu_batch_start: OK
> [   45.612764] Testing event rcu_invoke_callback: OK
> [   45.628814] Testing event rcu_invoke_kfree_callback: OK
> [   45.636800] Testing event rcu_batch_end: OK
> [   45.644976] Testing event rcu_torture_read: OK
> [   45.652952] Testing event rcu_barrier: OK
> [   45.692975] Testing event workqueue_queue_work: OK
> [   45.708843] Testing event workqueue_activate_work: OK
> [   45.716781] Testing event workqueue_execute_start: OK
> [   45.740771] Testing event workqueue_execute_end: OK
> [   45.756856] Testing event signal_generate: OK
> [   45.764738] Testing event signal_deliver: OK
> [   45.788743] Testing event timer_init: OK
> [   45.796816] Testing event timer_start: OK
> [   45.804951] Testing event timer_expire_entry: OK
> [   45.812724] Testing event timer_expire_exit: OK
> [   45.820715] Testing event timer_cancel: OK
> [   45.868836] Testing event hrtimer_init: OK
> [   45.883299] Testing event hrtimer_start: OK
> [   45.900831] Testing event hrtimer_expire_entry: OK
> [   45.916826] Testing event hrtimer_expire_exit: OK
> [   45.932832] Testing event hrtimer_cancel: OK
> [   45.948750] Testing event itimer_state: OK
> [   45.964815] Testing event itimer_expire: OK
> [   45.980845] Testing event irq_handler_entry: OK
> [   45.996846] Testing event irq_handler_exit: OK
> [   46.012836] Testing event softirq_entry: OK
> [   46.020729] Testing event softirq_exit: OK
> [   46.044783] Testing event softirq_raise: OK
> [   46.052731] Testing event console: OK
> [   46.060715] Testing event task_newtask: OK
> [   46.068791] Testing event task_rename: OK
> [   46.076816] Testing event mce_record: OK
> [   46.084730] Testing event sys_enter: OK
> [   46.092710] Testing event sys_exit: OK
> [   46.100695] Testing event emulate_vsyscall: OK
> [   46.172742] Testing event xen_mc_batch: OK
> [   46.188706] Testing event xen_mc_issue: OK
> [   46.204737] Testing event xen_mc_entry: OK
> [   46.220810] Testing event xen_mc_entry_alloc: OK
> [   46.236701] Testing event xen_mc_callback: OK
> [   46.252804] Testing event xen_mc_flush_reason: OK
> [   46.268746] Testing event xen_mc_flush: OK
> [   46.284729] Testing event xen_mc_extend_args: OK
> [   46.300747] Testing event xen_mmu_set_pte: OK
> [   46.316750] Testing event xen_mmu_set_pte_atomic: OK
> [   46.324724] Testing event xen_mmu_set_domain_pte: OK
> [   46.348767] Testing event xen_mmu_set_pte_at: OK
> [   46.364839] Testing event xen_mmu_pte_clear: OK
> [   46.380828] Testing event xen_mmu_set_pmd: OK
> [   46.388721] Testing event xen_mmu_pmd_clear: OK
> [   46.396825] Testing event xen_mmu_set_pud: OK
> [   46.404717] Testing event xen_mmu_set_pgd: OK
> [   46.412800] Testing event xen_mmu_pud_clear: OK
> [   46.420731] Testing event xen_mmu_pgd_clear: OK
> [   46.428745] Testing event xen_mmu_ptep_modify_prot_start: OK
> [   46.436711] Testing event xen_mmu_ptep_modify_prot_commit: OK
> [   46.444901] Testing event xen_mmu_alloc_ptpage: OK
> [   46.452723] Testing event xen_mmu_release_ptpage: OK
> [   46.460818] Testing event xen_mmu_pgd_pin: OK
> [   46.468714] Testing event xen_mmu_pgd_unpin: OK
> [   46.476830] Testing event xen_mmu_flush_tlb_all: OK
> [   46.484794] Testing event xen_mmu_flush_tlb: OK
> [   46.492806] Testing event xen_mmu_flush_tlb_single: OK
> [   46.500744] Testing event xen_mmu_flush_tlb_others: OK
> [   46.508722] Testing event xen_mmu_write_cr3: OK
> [   46.516717] Testing event xen_cpu_write_ldt_entry: OK
> [   46.524825] Testing event xen_cpu_write_idt_entry: OK
> [   46.684792] Testing event xen_cpu_load_idt: OK
> [   46.692691] Testing event xen_cpu_write_gdt_entry: OK
> [   46.716793] Testing event xen_cpu_set_ldt: OK
> [   46.732751] Testing event kvm_mmu_pagetable_walk: OK
> [   46.748807] Testing event kvm_mmu_paging_element: OK
> [   46.764727] Testing event kvm_mmu_set_accessed_bit: OK
> [   46.780777] Testing event kvm_mmu_set_dirty_bit: OK
> [   46.796716] Testing event kvm_mmu_walker_error: OK
> [   46.812786] Testing event kvm_mmu_get_page: OK
> [   46.828803] Testing event kvm_mmu_sync_page: OK
> [   46.844832] Testing event kvm_mmu_unsync_page: OK
> [   46.860877] Testing event kvm_mmu_prepare_zap_page: OK
> [   46.868827] Testing event kvm_mmu_delay_free_pages: OK
> [   46.892759] Testing event mark_mmio_spte: OK
> [   46.908767] Testing event handle_mmio_page_fault: OK
> [   46.924836] Testing event fast_page_fault: OK
> [   46.944763] Testing event kvm_entry: OK
> [   46.960883] Testing event kvm_hypercall: OK
> [   46.976753] Testing event kvm_hv_hypercall: OK
> [   46.984715] Testing event kvm_pio: OK
> [   47.008788] Testing event kvm_cpuid: OK
> [   47.016708] Testing event kvm_apic: OK
> [   47.044813] Testing event kvm_exit: OK
> [   47.060834] Testing event kvm_inj_virq: OK
> [   47.076775] Testing event kvm_inj_exception: OK
> [   47.092754] Testing event kvm_page_fault: OK
> [   47.100718] Testing event kvm_msr: OK
> [   47.124777] Testing event kvm_cr: OK
> [   47.132770] Testing event kvm_pic_set_irq: OK
> [   47.156795] Testing event kvm_apic_ipi: OK
> [   47.172772] Testing event kvm_apic_accept_irq: OK
> [   47.188821] Testing event kvm_eoi: OK
> [   47.204713] Testing event kvm_pv_eoi: OK
> [   47.216747] Testing event kvm_nested_vmrun: OK
> [   47.240742] Testing event kvm_nested_intercepts: OK
> [   47.256761] Testing event kvm_nested_vmexit: OK
> [   47.272767] Testing event kvm_nested_vmexit_inject: OK
> [   47.288764] Testing event kvm_nested_intr_vmexit: OK
> [   47.304797] Testing event kvm_invlpga: OK
> [   47.320747] Testing event kvm_skinit: OK
> [   47.336775] Testing event kvm_emulate_insn: OK
> [   47.356775] Testing event vcpu_match_mmio: OK
> [   47.372894] Testing event kvm_update_master_clock: OK
> [   47.388789] Testing event kvm_track_tsc: OK
> [   47.404797] Testing event kvm_userspace_exit: OK
> [   47.420781] Testing event kvm_set_irq: OK
> [   47.436760] Testing event kvm_ioapic_set_irq: OK
> [   47.444763] Testing event kvm_msi_set_irq: OK
> [   47.472758] Testing event kvm_ack_irq: OK
> [   47.488718] Testing event kvm_mmio: OK
> [   47.504867] Testing event kvm_fpu: OK
> [   47.512856] Testing event kvm_age_page: OK
> [   47.536821] Testing event kvm_try_async_get_page: OK
> [   47.552756] Testing event kvm_async_pf_doublefault: OK
> [   47.568722] Testing event kvm_async_pf_not_present: OK
> [   47.576708] Testing event kvm_async_pf_ready: OK
> [   47.600757] Testing event kvm_async_pf_completed: OK
> [   47.616762] Running tests on trace event systems:
> [   47.617487] Testing event system kvm: OK
> [   47.640019] Testing event system kvmmmu: OK
> [   47.661683] Testing event system xen: OK
> [   47.683517] Testing event system vsyscall: OK
> [   47.700784] Testing event system raw_syscalls: OK
> [   47.716875] Testing event system mce: OK
> [   47.732776] Testing event system task: OK
> [   47.748858] Testing event system printk: OK
> [   47.764849] Testing event system irq: OK
> [   47.781083] Testing event system timer: OK
> [   47.797560] Testing event system signal: OK
> [   47.812862] Testing event system workqueue: OK
> [   47.821024] Testing event system rcu: OK
> [   47.829991] Testing event system sched: OK
> [   47.862052] Testing event system lock: OK
> [   47.877059] Testing event system module: OK
> [   47.885045] Testing event system test: OK
> [   47.908746] Testing event system power: OK
> [   47.925579] Testing event system rpm: OK
> [   47.940892] Testing event system oom: OK
> [   47.956785] Testing event system vmscan: OK
> [   47.965892] Testing event system kmem: OK
> [   47.973667] Testing event system compaction: OK
> [   47.980898] Testing event system migrate: OK
> [   47.988870] Testing event system writeback: OK
> [   48.002460] Testing event system ext3: OK
> [   48.063768] Testing event system ext4: OK
> [   48.083573] Testing event system jbd: OK
> [   48.093366] Testing event system jbd2: OK
> [   48.101637] Testing event system xfs: OK
> [   48.187732] Testing event system ocfs2: OK
> [   48.267510] Testing event system btrfs: OK
> [   48.287013] Testing event system gfs2: OK
> [   48.305610] Testing event system block: OK
> [   48.313895] Testing event system gpio: OK
> [   48.320757] Testing event system regulator: OK
> [   48.353171] Testing event system random: OK
> [   48.369036] Testing event system drm: OK
> [   48.384857] Testing event system radeon: OK
> [   48.400966] Testing event system i915: OK
> [   48.418525] Testing event system regmap: OK
> [   48.437399] Testing event system scsi: OK
> [   48.445015] Testing event system ras: OK
> [   48.452809] Testing event system hda: OK
> [   48.461181] Testing event system hda_intel: OK
> [   48.500773] Testing event system syscalls: OK
> [   48.517584] Testing event system udp: OK
> [   48.532783] Testing event system sock: OK
> [   48.548864] Testing event system napi: OK
> [   48.564683] Testing event system net: OK
> [   48.580999] Testing event system skb: OK
> [   48.596885] Testing event system sunrpc: OK
> [   48.613295] Testing event system cfg80211: OK
> [   48.643876] Testing event system mac80211: OK
> [   48.676400] Testing event system 9p: OK
> [   48.692867] Running tests on all trace events:
> [   48.693557] Testing all events: OK
> [   49.440133] Running tests again, along with the function tracer
> [   49.441310] Running tests on trace events:
> [   49.442174] Testing event 9p_client_req: OK
> [   49.453856] Testing event 9p_client_res: OK
> [   49.465786] Testing event 9p_protocol_dump: OK
> [   49.493948] Testing event drv_return_void: OK
> [   49.513997] Testing event drv_return_int: OK
> [   49.525838] Testing event drv_return_bool: OK
> [   49.549923] Testing event drv_return_u64: OK
> [   49.569828] Testing event drv_start: OK
> [   49.585884] Testing event drv_get_et_strings: OK
> [   49.605861] Testing event drv_get_et_sset_count: OK
> [   49.617786] Testing event drv_get_et_stats: OK
> [   49.629746] Testing event drv_suspend: OK
> [   49.642020] Testing event drv_resume: OK
> [   49.660341] Testing event drv_set_wakeup: OK
> [   49.689908] Testing event drv_stop: OK
> [   49.701810] Testing event drv_add_interface: OK
> [   49.713888] Testing event drv_change_interface: OK
> [   49.725760] Testing event drv_remove_interface: OK
> [   49.757890] Testing event drv_config: OK
> [   49.769841] Testing event drv_bss_info_changed: OK
> [   49.781943] Testing event drv_prepare_multicast: OK
> [   49.810021] Testing event drv_configure_filter: OK
> [   49.821903] Testing event drv_set_tim: OK
> [   49.833902] Testing event drv_set_key: OK
> [   49.841763] Testing event drv_update_tkip_key: OK
> [   49.877844] Testing event drv_hw_scan: OK
> [   49.897884] Testing event drv_cancel_hw_scan: OK
> [   49.909798] Testing event drv_sched_scan_start: OK
> [   49.933998] Testing event drv_sched_scan_stop: OK
> [   49.945790] Testing event drv_sw_scan_start: OK
> [   49.969967] Testing event drv_sw_scan_complete: OK
> [   49.989850] Testing event drv_get_stats: OK
> [   50.001864] Testing event drv_get_tkip_seq: OK
> [   50.025992] Testing event drv_set_frag_threshold: OK
> [   50.045937] Testing event drv_set_rts_threshold: OK
> [   50.065889] Testing event drv_set_coverage_class: OK
> [   50.085833] Testing event drv_sta_notify: OK
> [   50.105987] Testing event drv_sta_state: OK
> [   50.117866] Testing event drv_sta_rc_update: OK
> [   50.141908] Testing event drv_sta_add: OK
> [   50.153870] Testing event drv_sta_remove: OK
> [   50.165847] Testing event drv_conf_tx: OK
> [   50.193986] Testing event drv_get_tsf: OK
> [   50.213942] Testing event drv_set_tsf: OK
> [   50.225805] Testing event drv_reset_tsf: OK
> [   50.250058] Testing event drv_tx_last_beacon: OK
> [   50.261835] Testing event drv_ampdu_action: OK
> [   50.273869] Testing event drv_get_survey: OK
> [   50.301980] Testing event drv_flush: OK
> [   50.321912] Testing event drv_channel_switch: OK
> [   50.341904] Testing event drv_set_antenna: OK
> [   50.361987] Testing event drv_get_antenna: OK
> [   50.381960] Testing event drv_remain_on_channel: OK
> [   50.401987] Testing event drv_cancel_remain_on_channel: OK
> [   50.421926] Testing event drv_set_ringparam: OK
> [   50.441934] Testing event drv_get_ringparam: OK
> [   50.453818] Testing event drv_tx_frames_pending: OK
> [   50.477939] Testing event drv_offchannel_tx_cancel_wait: OK
> [   50.489811] Testing event drv_set_bitrate_mask: OK
> [   50.513981] Testing event drv_set_rekey_data: OK
> [   50.533848] Testing event drv_rssi_callback: OK
> [   50.553936] Testing event drv_release_buffered_frames: OK
> [   50.573956] Testing event drv_allow_buffered_frames: OK
> [   50.593869] Testing event drv_get_rssi: OK
> [   50.606163] Testing event drv_mgd_prepare_tx: OK
> [   50.629944] Testing event drv_add_chanctx: OK
> [   50.641886] Testing event drv_remove_chanctx: OK
> [   50.654055] Testing event drv_change_chanctx: OK
> [   50.665736] Testing event drv_assign_vif_chanctx: OK
> [   50.677664] Testing event drv_unassign_vif_chanctx: OK
> [   50.713921] Testing event drv_start_ap: OK
> [   50.726118] Testing event drv_stop_ap: OK
> [   50.738046] Testing event drv_restart_complete: OK
> [   50.765788] Testing event api_start_tx_ba_session: OK
> [   50.777824] Testing event api_start_tx_ba_cb: OK
> [   50.802151] Testing event api_stop_tx_ba_session: OK
> [   50.821899] Testing event api_stop_tx_ba_cb: OK
> [   50.841839] Testing event api_restart_hw: OK
> [   50.854221] Testing event api_beacon_loss: OK
> [   50.866003] Testing event api_connection_loss: OK
> [   50.877757] Testing event api_cqm_rssi_notify: OK
> [   50.886184] Testing event api_scan_completed: OK
> [   50.897997] Testing event api_sched_scan_results: OK
> [   50.942247] Testing event api_sched_scan_stopped: OK
> [   50.961935] Testing event api_sta_block_awake: OK
> [   50.973830] Testing event api_chswitch_done: OK
> [   50.998188] Testing event api_ready_on_channel: OK
> [   51.010128] Testing event api_remain_on_channel_expired: OK
> [   51.022043] Testing event api_gtk_rekey_notify: OK
> [   51.034110] Testing event api_enable_rssi_reports: OK
> [   51.066169] Testing event api_eosp: OK
> [   51.086164] Testing event wake_queue: OK
> [   51.098128] Testing event stop_queue: OK
> [   51.110033] Testing event rdev_suspend: OK
> [   51.121766] Testing event rdev_return_int: OK
> [   51.130129] Testing event rdev_scan: OK
> [   51.142047] Testing event rdev_resume: OK
> [   51.185883] Testing event rdev_return_void: OK
> [   51.198251] Testing event rdev_get_ringparam: OK
> [   51.209976] Testing event rdev_get_antenna: OK
> [   51.222067] Testing event rdev_rfkill_poll: OK
> [   51.234026] Testing event rdev_set_wakeup: OK
> [   51.269803] Testing event rdev_add_virtual_intf: OK
> [   51.282030] Testing event rdev_return_wdev: OK
> [   51.305780] Testing event rdev_del_virtual_intf: OK
> [   51.326151] Testing event rdev_change_virtual_intf: OK
> [   51.346056] Testing event rdev_add_key: OK
> [   51.365955] Testing event rdev_get_key: OK
> [   51.377848] Testing event rdev_del_key: OK
> [   51.390099] Testing event rdev_set_default_key: OK
> [   51.401747] Testing event rdev_set_default_mgmt_key: OK
> [   51.413992] Testing event rdev_start_ap: OK
> [   51.449844] Testing event rdev_change_beacon: OK
> [   51.461833] Testing event rdev_stop_ap: OK
> [   51.486089] Testing event rdev_get_et_stats: OK
> [   51.506071] Testing event rdev_sched_scan_stop: OK
> [   51.525830] Testing event rdev_set_rekey_data: OK
> [   51.546062] Testing event rdev_get_mesh_config: OK
> [   51.565803] Testing event rdev_leave_mesh: OK
> [   51.585817] Testing event rdev_leave_ibss: OK
> [   51.605825] Testing event rdev_flush_pmksa: OK
> [   51.625864] Testing event rdev_add_station: OK
> [   51.645970] Testing event rdev_change_station: OK
> [   51.657910] Testing event rdev_del_station: OK
> [   51.669699] Testing event rdev_get_station: OK
> [   51.682147] Testing event rdev_del_mpath: OK
> [   51.694071] Testing event rdev_set_wds_peer: OK
> [   51.706054] Testing event rdev_dump_station: OK
> [   51.718137] Testing event rdev_return_int_station_info: OK
> [   51.730015] Testing event rdev_add_mpath: OK
> [   51.741785] Testing event rdev_change_mpath: OK
> [   51.798192] Testing event rdev_get_mpath: OK
> [   51.818184] Testing event rdev_dump_mpath: OK
> [   51.837913] Testing event rdev_return_int_mpath_info: OK
> [   51.849815] Testing event rdev_return_int_mesh_config: OK
> [   51.874142] Testing event rdev_update_mesh_config: OK
> [   51.893828] Testing event rdev_join_mesh: OK
> [   51.913929] Testing event rdev_change_bss: OK
> [   51.926162] Testing event rdev_set_txq_params: OK
> [   51.950122] Testing event rdev_libertas_set_mesh_channel: OK
> [   51.970079] Testing event rdev_set_monitor_channel: OK
> [   51.989832] Testing event rdev_auth: OK
> [   52.009827] Testing event rdev_assoc: OK
> [   52.029961] Testing event rdev_deauth: OK
> [   52.041826] Testing event rdev_disassoc: OK
> [   52.054051] Testing event rdev_mgmt_tx_cancel_wait: OK
> [   52.081917] Testing event rdev_set_power_mgmt: OK
> [   52.101916] Testing event rdev_connect: OK
> [   52.113790] Testing event rdev_set_cqm_rssi_config: OK
> [   52.126049] Testing event rdev_set_cqm_txe_config: OK
> [   52.137718] Testing event rdev_disconnect: OK
> [   52.146000] Testing event rdev_join_ibss: OK
> [   52.186173] Testing event rdev_set_wiphy_params: OK
> [   52.198163] Testing event rdev_get_tx_power: OK
> [   52.209994] Testing event rdev_set_tx_power: OK
> [   52.221945] Testing event rdev_return_int_int: OK
> [   52.254210] Testing event rdev_set_bitrate_mask: OK
> [   52.265849] Testing event rdev_mgmt_frame_register: OK
> [   52.277774] Testing event rdev_return_int_tx_rx: OK
> [   52.290145] Testing event rdev_return_void_tx_rx: OK
> [   52.302076] Testing event rdev_set_ringparam: OK
> [   52.338247] Testing event rdev_set_antenna: OK
> [   52.357904] Testing event rdev_sched_scan_start: OK
> [   52.378154] Testing event rdev_tdls_mgmt: OK
> [   52.390166] Testing event rdev_dump_survey: OK
> [   52.402001] Testing event rdev_return_int_survey_info: OK
> [   52.413766] Testing event rdev_tdls_oper: OK
> [   52.445919] Testing event rdev_probe_client: OK
> [   52.465853] Testing event rdev_set_pmksa: OK
> [   52.478179] Testing event rdev_del_pmksa: OK
> [   52.502113] Testing event rdev_remain_on_channel: OK
> [   52.522090] Testing event rdev_return_int_cookie: OK
> [   52.541904] Testing event rdev_cancel_remain_on_channel: OK
> [   52.553813] Testing event rdev_mgmt_tx: OK
> [   52.578167] Testing event rdev_set_noack_map: OK
> [   52.597922] Testing event rdev_get_et_sset_count: OK
> [   52.618178] Testing event rdev_get_et_strings: OK
> [   52.637825] Testing event rdev_get_channel: OK
> [   52.657940] Testing event rdev_return_chandef: OK
> [   52.670191] Testing event rdev_start_p2p_device: OK
> [   52.682057] Testing event rdev_stop_p2p_device: OK
> [   52.710230] Testing event cfg80211_return_bool: OK
> [   52.721849] Testing event cfg80211_notify_new_peer_candidate: OK
> [   52.733714] Testing event cfg80211_send_rx_auth: OK
> [   52.742146] Testing event cfg80211_send_rx_assoc: OK
> [   52.753866] Testing event __cfg80211_send_deauth: OK
> [   52.765701] Testing event __cfg80211_send_disassoc: OK
> [   52.778099] Testing event cfg80211_send_unprot_deauth: OK
> [   52.790057] Testing event cfg80211_send_unprot_disassoc: OK
> [   52.841904] Testing event cfg80211_send_auth_timeout: OK
> [   52.862139] Testing event cfg80211_send_assoc_timeout: OK
> [   52.873887] Testing event cfg80211_michael_mic_failure: OK
> [   52.898173] Testing event cfg80211_ready_on_channel: OK
> [   52.916779] Testing event cfg80211_ready_on_channel_expired: OK
> [   52.933797] Testing event cfg80211_new_sta: OK
> [   52.953758] Testing event cfg80211_del_sta: OK
> [   52.974122] Testing event cfg80211_rx_mgmt: OK
> [   52.994068] Testing event cfg80211_mgmt_tx_status: OK
> [   53.013836] Testing event cfg80211_cqm_rssi_notify: OK
> [   53.034135] Testing event cfg80211_reg_can_beacon: OK
> [   53.053861] Testing event cfg80211_ch_switch_notify: OK
> [   53.073855] Testing event cfg80211_ibss_joined: OK
> [   53.094106] Testing event cfg80211_rx_spurious_frame: OK
> [   53.114088] Testing event cfg80211_rx_unexpected_4addr_frame: OK
> [   53.133944] Testing event cfg80211_probe_status: OK
> [   53.158032] Testing event cfg80211_cqm_pktloss_notify: OK
> [   53.177751] Testing event cfg80211_gtk_rekey_notify: OK
> [   53.198008] Testing event cfg80211_pmksa_candidate_notify: OK
> [   53.218015] Testing event cfg80211_report_obss_beacon: OK
> [   53.229991] Testing event cfg80211_tdls_oper_request: OK
> [   53.254199] Testing event cfg80211_scan_done: OK
> [   53.266075] Testing event cfg80211_sched_scan_results: OK
> [   53.290139] Testing event cfg80211_sched_scan_stopped: OK
> [   53.309942] Testing event cfg80211_get_bss: OK
> [   53.322160] Testing event cfg80211_inform_bss_frame: OK
> [   53.333958] Testing event cfg80211_return_bss: OK
> [   53.345808] Testing event cfg80211_return_uint: OK
> [   53.357692] Testing event cfg80211_return_u32: OK
> [   53.365980] Testing event rpc_call_status: OK
> [   53.410050] Testing event rpc_bind_status: OK
> [   53.421893] Testing event rpc_connect_status: OK
> [   53.433824] Testing event rpc_task_begin: OK
> [   53.461923] Testing event rpc_task_run_action: OK
> [   53.473800] Testing event rpc_task_complete: OK
> [   53.485868] Testing event rpc_task_sleep: OK
> [   53.517917] Testing event rpc_task_wakeup: OK
> [   53.529813] Testing event kfree_skb: OK
> [   53.541801] Testing event consume_skb: OK
> [   53.569873] Testing event skb_copy_datagram_iovec: OK
> [   53.581777] Testing event net_dev_xmit: OK
> [   53.593855] Testing event net_dev_queue: OK
> [   53.605787] Testing event netif_receive_skb: OK
> [   53.617725] Testing event netif_rx: OK
> [   53.654064] Testing event napi_poll: OK
> [   53.673940] Testing event sock_rcvqueue_full: OK
> [   53.694139] Testing event sock_exceed_buf_limit: OK
> [   53.705792] Testing event udp_fail_queue_rcv_skb: OK
> [   53.717843] Testing event azx_pcm_trigger: OK
> [   53.745955] Testing event azx_get_position: OK
> [   53.765907] Testing event hda_send_cmd: OK
> [   53.785827] Testing event hda_get_response: OK
> [   53.806305] Testing event hda_bus_reset: OK
> [   53.817855] Testing event hda_power_down: OK
> [   53.830102] Testing event hda_power_up: OK
> [   53.857879] Testing event hda_power_count: OK
> [   53.869873] Testing event hda_unsol_event: OK
> [   53.882128] Testing event mc_event: OK
> [   53.894132] Testing event scsi_dispatch_cmd_start: OK
> [   53.926265] Testing event scsi_dispatch_cmd_error: OK
> [   53.937842] Testing event scsi_dispatch_cmd_done: OK
> [   53.961846] Testing event scsi_dispatch_cmd_timeout: OK
> [   53.981857] Testing event scsi_eh_wakeup: OK
> [   53.993907] Testing event regmap_reg_write: OK
> [   54.018168] Testing event regmap_reg_read: OK
> [   54.037904] Testing event regmap_reg_read_cache: OK
> [   54.049915] Testing event regmap_hw_read_start: OK
> [   54.074344] Testing event regmap_hw_read_done: OK
> [   54.086029] Testing event regmap_hw_write_start: OK
> [   54.110347] Testing event regmap_hw_write_done: OK
> [   54.122278] Testing event regcache_sync: OK
> [   54.134171] Testing event regmap_cache_only: OK
> [   54.162353] Testing event regmap_cache_bypass: OK
> [   54.181977] Testing event i915_gem_object_create: OK
> [   54.202316] Testing event i915_gem_object_bind: OK
> [   54.222320] Testing event i915_gem_object_unbind: OK
> [   54.234224] Testing event i915_gem_object_change_domain: OK
> [   54.246149] Testing event i915_gem_object_pwrite: OK
> [   54.273954] Testing event i915_gem_object_pread: OK
> [   54.294225] Testing event i915_gem_object_fault: OK
> [   54.305851] Testing event i915_gem_object_clflush: OK
> [   54.318090] Testing event i915_gem_object_destroy: OK
> [   54.346166] Testing event i915_gem_evict: OK
> [   54.365992] Testing event i915_gem_evict_everything: OK
> [   54.386160] Testing event i915_gem_ring_dispatch: OK
> [   54.397914] Testing event i915_gem_ring_flush: OK
> [   54.409759] Testing event i915_gem_request_add: OK
> [   54.422210] Testing event i915_gem_request_complete: OK
> [   54.434055] Testing event i915_gem_request_retire: OK
> [   54.469929] Testing event i915_gem_request_wait_begin: OK
> [   54.481808] Testing event i915_gem_request_wait_end: OK
> [   54.505912] Testing event i915_ring_wait_begin: OK
> [   54.518175] Testing event i915_ring_wait_end: OK
> [   54.530027] Testing event i915_flip_request: OK
> [   54.542027] Testing event i915_flip_complete: OK
> [   54.574006] Testing event i915_reg_rw: OK
> [   54.585823] Testing event intel_gpu_freq_change: OK
> [   54.609973] Testing event radeon_bo_create: OK
> [   54.629960] Testing event radeon_fence_emit: OK
> [   54.641857] Testing event radeon_fence_retire: OK
> [   54.653839] Testing event radeon_fence_wait_begin: OK
> [   54.665805] Testing event radeon_fence_wait_end: OK
> [   54.698056] Testing event drm_vblank_event: OK
> [   54.717968] Testing event drm_vblank_event_queued: OK
> [   54.729767] Testing event drm_vblank_event_delivered: OK
> [   54.753867] Testing event mix_pool_bytes: OK
> [   54.773953] Testing event mix_pool_bytes_nolock: OK
> [   54.785723] Testing event credit_entropy_bits: OK
> [   54.793822] Testing event get_random_bytes: OK
> [   54.825887] Testing event extract_entropy: OK
> [   54.837945] Testing event extract_entropy_user: OK
> [   54.861901] Testing event regulator_enable: OK
> [   54.873900] Testing event regulator_enable_delay: OK
> [   54.897991] Testing event regulator_enable_complete: OK
> [   54.917923] Testing event regulator_disable: OK
> [   54.929797] Testing event regulator_disable_complete: OK
> [   54.941707] Testing event regulator_set_voltage: OK
> [   54.953730] Testing event regulator_set_voltage_complete: OK
> [   54.985994] Testing event gpio_direction: OK
> [   55.005877] Testing event gpio_value: OK
> [   55.017950] Testing event block_rq_abort: OK
> [   55.029683] Testing event block_rq_requeue: OK
> [   55.041941] Testing event block_rq_complete: OK
> [   55.073892] Testing event block_rq_insert: OK
> [   55.085837] Testing event block_rq_issue: OK
> [   55.109873] Testing event block_bio_bounce: OK
> [   55.121729] Testing event block_bio_complete: OK
> [   55.129884] Testing event block_bio_backmerge: OK
> [   55.143222] Testing event block_bio_frontmerge: OK
> [   55.177900] Testing event block_bio_queue: OK
> [   55.197850] Testing event block_getrq: OK
> [   55.217861] Testing event block_sleeprq: OK
> [   55.229795] Testing event block_plug: OK
> [   55.237764] Testing event block_unplug: OK
> [   55.270037] Testing event block_split: OK
> [   55.289928] Testing event block_bio_remap: OK
> [   55.301804] Testing event block_rq_remap: OK
> [   55.326022] Testing event gfs2_glock_state_change: OK
> [   55.337834] Testing event gfs2_glock_put: OK
> [   55.362149] Testing event gfs2_demote_rq: OK
> [   55.381941] Testing event gfs2_promote: OK
> [   55.393890] Testing event gfs2_glock_queue: OK
> [   55.417942] Testing event gfs2_glock_lock_time: OK
> [   55.438016] Testing event gfs2_pin: OK
> [   55.458002] Testing event gfs2_log_flush: OK
> [   55.477904] Testing event gfs2_log_blocks: OK
> [   55.497997] Testing event gfs2_ail_flush: OK
> [   55.511339] Testing event gfs2_bmap: OK
> [   55.521921] Testing event gfs2_block_alloc: OK
> [   55.549989] Testing event gfs2_rs: OK
> [   55.570072] Testing event btrfs_transaction_commit: OK
> [   55.581849] Testing event btrfs_inode_new: OK
> [   55.606011] Testing event btrfs_inode_request: OK
> [   55.626231] Testing event btrfs_inode_evict: OK
> [   55.637840] Testing event btrfs_get_extent: OK
> [   55.649890] Testing event btrfs_ordered_extent_add: OK
> [   55.677961] Testing event btrfs_ordered_extent_remove: OK
> [   55.689802] Testing event btrfs_ordered_extent_start: OK
> [   55.701832] Testing event btrfs_ordered_extent_put: OK
> [   55.713808] Testing event __extent_writepage: OK
> [   55.725690] Testing event btrfs_writepage_end_io_hook: OK
> [   55.737847] Testing event btrfs_sync_file: OK
> [   55.777979] Testing event btrfs_sync_fs: OK
> [   55.798201] Testing event btrfs_delayed_tree_ref: OK
> [   55.817957] Testing event btrfs_delayed_data_ref: OK
> [   55.829821] Testing event btrfs_delayed_ref_head: OK
> [   55.853974] Testing event btrfs_chunk_alloc: OK
> [   55.865786] Testing event btrfs_chunk_free: OK
> [   55.877874] Testing event btrfs_cow_block: OK
> [   55.889720] Testing event btrfs_space_reservation: OK
> [   55.921954] Testing event btrfs_reserved_extent_alloc: OK
> [   55.934018] Testing event btrfs_reserved_extent_free: OK
> [   55.945838] Testing event find_free_extent: OK
> [   55.973921] Testing event btrfs_reserve_extent: OK
> [   55.993952] Testing event btrfs_reserve_extent_cluster: OK
> [   56.005743] Testing event btrfs_find_cluster: OK
> [   56.031369] Testing event btrfs_failed_cluster_setup: OK
> [   56.041911] Testing event btrfs_setup_cluster: OK
> [   56.053732] Testing event alloc_extent_state: OK
> [   56.065926] Testing event free_extent_state: OK
> [   56.077839] Testing event ocfs2_adjust_rightmost_branch: OK
> [   56.113828] Testing event ocfs2_rotate_tree_right: OK
> [   56.125902] Testing event ocfs2_append_rec_to_path: OK
> [   56.150169] Testing event ocfs2_insert_extent_start: OK
> [   56.168608] Testing event ocfs2_add_clusters_in_btree: OK
> [   56.178116] Testing event ocfs2_num_free_extents: OK
> [   56.190046] Testing event ocfs2_complete_edge_insert: OK
> [   56.217890] Testing event ocfs2_grow_tree: OK
> [   56.229934] Testing event ocfs2_rotate_subtree: OK
> [   56.254164] Testing event ocfs2_insert_extent: OK
> [   56.265891] Testing event ocfs2_split_extent: OK
> [   56.278094] Testing event ocfs2_remove_extent: OK
> [   56.306222] Testing event ocfs2_commit_truncate: OK
> [   56.317885] Testing event ocfs2_validate_extent_block: OK
> [   56.342186] Testing event ocfs2_rotate_leaf: OK
> [   56.354091] Testing event ocfs2_add_clusters_in_btree_ret: OK
> [   56.366048] Testing event ocfs2_mark_extent_written: OK
> [   56.393918] Testing event ocfs2_truncate_log_append: OK
> [   56.405849] Testing event ocfs2_replay_truncate_records: OK
> [   56.429893] Testing event ocfs2_flush_truncate_log: OK
> [   56.442188] Testing event ocfs2_begin_truncate_log_recovery: OK
> [   56.466206] Testing event ocfs2_truncate_log_recovery_num: OK
> [   56.477895] Testing event ocfs2_complete_truncate_log_recovery: OK
> [   56.490029] Testing event ocfs2_free_cached_blocks: OK
> [   56.517936] Testing event ocfs2_cache_cluster_dealloc: OK
> [   56.538196] Testing event ocfs2_run_deallocs: OK
> [   56.549925] Testing event ocfs2_cache_block_dealloc: OK
> [   56.562028] Testing event ocfs2_trim_extent: OK
> [   56.574246] Testing event ocfs2_trim_group: OK
> [   56.586073] Testing event ocfs2_trim_fs: OK
> [   56.598111] Testing event ocfs2_la_set_sizes: OK
> [   56.610069] Testing event ocfs2_alloc_should_use_local: OK
> [   56.653878] Testing event ocfs2_load_local_alloc: OK
> [   56.673955] Testing event ocfs2_begin_local_alloc_recovery: OK
> [   56.693886] Testing event ocfs2_reserve_local_alloc_bits: OK
> [   56.706089] Testing event ocfs2_local_alloc_count_bits: OK
> [   56.729868] Testing event ocfs2_local_alloc_find_clear_bits_search_bitmap: OK
> [   56.749988] Testing event ocfs2_local_alloc_find_clear_bits: OK
> [   56.761845] Testing event ocfs2_sync_local_to_main: OK
> [   56.774015] Testing event ocfs2_sync_local_to_main_free: OK
> [   56.802010] Testing event ocfs2_local_alloc_new_window: OK
> [   56.814018] Testing event ocfs2_local_alloc_new_window_result: OK
> [   56.826036] Testing event ocfs2_update_last_group_and_inode: OK
> [   56.853876] Testing event ocfs2_group_extend: OK
> [   56.865887] Testing event ocfs2_group_add: OK
> [   56.878108] Testing event ocfs2_validate_group_descriptor: OK
> [   56.905882] Testing event ocfs2_block_group_alloc_contig: OK
> [   56.917888] Testing event ocfs2_block_group_alloc_discontig: OK
> [   56.930007] Testing event ocfs2_block_group_alloc: OK
> [   56.957886] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
> [   56.969854] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
> [   56.982054] Testing event ocfs2_reserve_new_inode_new_group: OK
> [   57.009871] Testing event ocfs2_block_group_set_bits: OK
> [   57.030060] Testing event ocfs2_relink_block_group: OK
> [   57.049905] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
> [   57.070128] Testing event ocfs2_cluster_group_search_max_block: OK
> [   57.090168] Testing event ocfs2_block_group_search_max_block: OK
> [   57.109912] Testing event ocfs2_search_chain_begin: OK
> [   57.130133] Testing event ocfs2_search_chain_succ: OK
> [   57.149955] Testing event ocfs2_search_chain_end: OK
> [   57.170188] Testing event ocfs2_claim_suballoc_bits: OK
> [   57.190132] Testing event ocfs2_claim_new_inode_at_loc: OK
> [   57.210141] Testing event ocfs2_block_group_clear_bits: OK
> [   57.230129] Testing event ocfs2_free_suballoc_bits: OK
> [   57.249896] Testing event ocfs2_free_clusters: OK
> [   57.269878] Testing event ocfs2_get_suballoc_slot_bit: OK
> [   57.290130] Testing event ocfs2_test_suballoc_bit: OK
> [   57.310177] Testing event ocfs2_test_inode_bit: OK
> [   57.330144] Testing event ocfs2_validate_refcount_block: OK
> [   57.349919] Testing event ocfs2_purge_refcount_trees: OK
> [   57.370137] Testing event ocfs2_create_refcount_tree: OK
> [   57.390283] Testing event ocfs2_create_refcount_tree_blkno: OK
> [   57.410195] Testing event ocfs2_change_refcount_rec: OK
> [   57.430265] Testing event ocfs2_expand_inline_ref_root: OK
> [   57.449967] Testing event ocfs2_divide_leaf_refcount_block: OK
> [   57.470204] Testing event ocfs2_new_leaf_refcount_block: OK
> [   57.490176] Testing event ocfs2_insert_refcount_rec: OK
> [   57.510132] Testing event ocfs2_split_refcount_rec: OK
> [   57.530162] Testing event ocfs2_split_refcount_rec_insert: OK
> [   57.549913] Testing event ocfs2_increase_refcount_begin: OK
> [   57.569914] Testing event ocfs2_increase_refcount_change: OK
> [   57.590180] Testing event ocfs2_increase_refcount_insert: OK
> [   57.610118] Testing event ocfs2_increase_refcount_split: OK
> [   57.629867] Testing event ocfs2_remove_refcount_extent: OK
> [   57.649950] Testing event ocfs2_restore_refcount_block: OK
> [   57.670130] Testing event ocfs2_decrease_refcount_rec: OK
> [   57.690133] Testing event ocfs2_decrease_refcount: OK
> [   57.710145] Testing event ocfs2_mark_extent_refcounted: OK
> [   57.730200] Testing event ocfs2_calc_refcount_meta_credits: OK
> [   57.749997] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
> [   57.770194] Testing event ocfs2_add_refcount_flag: OK
> [   57.789879] Testing event ocfs2_prepare_refcount_change_for_del: OK
> [   57.810451] Testing event ocfs2_lock_refcount_allocators: OK
> [   57.830015] Testing event ocfs2_duplicate_clusters_by_page: OK
> [   57.842099] Testing event ocfs2_duplicate_clusters_by_jbd: OK
> [   57.854079] Testing event ocfs2_clear_ext_refcount: OK
> [   57.866114] Testing event ocfs2_replace_clusters: OK
> [   57.878048] Testing event ocfs2_make_clusters_writable: OK
> [   57.913887] Testing event ocfs2_refcount_cow_hunk: OK
> [   57.925798] Testing event ocfs2_symlink_get_block: OK
> [   57.950161] Testing event ocfs2_get_block: OK
> [   57.961884] Testing event ocfs2_get_block_end: OK
> [   57.974049] Testing event ocfs2_readpage: OK
> [   58.001895] Testing event ocfs2_writepage: OK
> [   58.021871] Testing event ocfs2_bmap: OK
> [   58.033897] Testing event ocfs2_try_to_write_inline_data: OK
> [   58.046041] Testing event ocfs2_write_begin_nolock: OK
> [   58.058114] Testing event ocfs2_write_end_inline: OK
> [   58.070055] Testing event ocfs2_fault: OK
> [   58.081992] Testing event ocfs2_file_open: OK
> [   58.094073] Testing event ocfs2_file_release: OK
> [   58.137903] Testing event ocfs2_sync_file: OK
> [   58.149903] Testing event ocfs2_file_aio_write: OK
> [   58.173952] Testing event ocfs2_file_splice_write: OK
> [   58.193977] Testing event ocfs2_file_splice_read: OK
> [   58.213836] Testing event ocfs2_file_aio_read: OK
> [   58.225886] Testing event ocfs2_truncate_file: OK
> [   58.249896] Testing event ocfs2_truncate_file_error: OK
> [   58.262126] Testing event ocfs2_extend_allocation: OK
> [   58.274047] Testing event ocfs2_extend_allocation_end: OK
> [   58.301879] Testing event ocfs2_write_zero_page: OK
> [   58.314149] Testing event ocfs2_zero_extend_range: OK
> [   58.326014] Testing event ocfs2_zero_extend: OK
> [   58.338117] Testing event ocfs2_setattr: OK
> [   58.350076] Testing event ocfs2_write_remove_suid: OK
> [   58.385911] Testing event ocfs2_zero_partial_clusters: OK
> [   58.398106] Testing event ocfs2_zero_partial_clusters_range1: OK
> [   58.410001] Testing event ocfs2_zero_partial_clusters_range2: OK
> [   58.437927] Testing event ocfs2_remove_inode_range: OK
> [   58.450096] Testing event ocfs2_prepare_inode_for_write: OK
> [   58.473843] Testing event generic_file_aio_read_ret: OK
> [   58.493864] Testing event ocfs2_iget_begin: OK
> [   58.505884] Testing event ocfs2_iget5_locked: OK
> [   58.518008] Testing event ocfs2_iget_end: OK
> [   58.545856] Testing event ocfs2_find_actor: OK
> [   58.557865] Testing event ocfs2_populate_inode: OK
> [   58.581902] Testing event ocfs2_read_locked_inode: OK
> [   58.593819] Testing event ocfs2_check_orphan_recovery_state: OK
> [   58.605724] Testing event ocfs2_validate_inode_block: OK
> [   58.617914] Testing event ocfs2_inode_is_valid_to_delete: OK
> [   58.630003] Testing event ocfs2_query_inode_wipe_begin: OK
> [   58.666173] Testing event ocfs2_query_inode_wipe_succ: OK
> [   58.677855] Testing event ocfs2_query_inode_wipe_end: OK
> [   58.689771] Testing event ocfs2_cleanup_delete_inode: OK
> [   58.718075] Testing event ocfs2_delete_inode: OK
> [   58.737913] Testing event ocfs2_clear_inode: OK
> [   58.758194] Testing event ocfs2_drop_inode: OK
> [   58.777944] Testing event ocfs2_inode_revalidate: OK
> [   58.798158] Testing event ocfs2_mark_inode_dirty: OK
> [   58.818168] Testing event ocfs2_read_virt_blocks: OK
> [   58.838153] Testing event ocfs2_refresh_slot_info: OK
> [   58.857951] Testing event ocfs2_map_slot_buffers: OK
> [   58.869959] Testing event ocfs2_map_slot_buffers_block: OK
> [   58.882065] Testing event ocfs2_find_slot: OK
> [   58.909939] Testing event ocfs2_do_node_down: OK
> [   58.929981] Testing event ocfs2_remount: OK
> [   58.942212] Testing event ocfs2_fill_super: OK
> [   58.954009] Testing event ocfs2_parse_options: OK
> [   58.981946] Testing event ocfs2_put_super: OK
> [   59.001885] Testing event ocfs2_statfs: OK
> [   59.014036] Testing event ocfs2_dismount_volume: OK
> [   59.038133] Testing event ocfs2_initialize_super: OK
> [   59.057955] Testing event ocfs2_validate_xattr_block: OK
> [   59.077967] Testing event ocfs2_xattr_extend_allocation: OK
> [   59.090145] Testing event ocfs2_init_xattr_set_ctxt: OK
> [   59.113994] Testing event ocfs2_xattr_bucket_find: OK
> [   59.134092] Testing event ocfs2_xattr_index_block_find: OK
> [   59.153860] Testing event ocfs2_xattr_index_block_find_rec: OK
> [   59.174093] Testing event ocfs2_iterate_xattr_buckets: OK
> [   59.186102] Testing event ocfs2_iterate_xattr_bucket: OK
> [   59.197950] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
> [   59.210010] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
> [   59.225867] Testing event ocfs2_xattr_create_index_block_begin: OK
> [   59.266088] Testing event ocfs2_xattr_create_index_block: OK
> [   59.278154] Testing event ocfs2_defrag_xattr_bucket: OK
> [   59.306062] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
> [   59.317866] Testing event ocfs2_divide_xattr_bucket_begin: OK
> [   59.330005] Testing event ocfs2_divide_xattr_bucket_move: OK
> [   59.361858] Testing event ocfs2_cp_xattr_bucket: OK
> [   59.373813] Testing event ocfs2_mv_xattr_buckets: OK
> [   59.401985] Testing event ocfs2_adjust_xattr_cross_cluster: OK
> [   59.421937] Testing event ocfs2_add_new_xattr_cluster_begin: OK
> [   59.442006] Testing event ocfs2_add_new_xattr_cluster: OK
> [   59.461940] Testing event ocfs2_add_new_xattr_cluster_insert: OK
> [   59.488594] Testing event ocfs2_extend_xattr_bucket: OK
> [   59.497914] Testing event ocfs2_add_new_xattr_bucket: OK
> [   59.525972] Testing event ocfs2_xattr_bucket_value_truncate: OK
> [   59.546048] Testing event ocfs2_rm_xattr_cluster: OK
> [   59.566035] Testing event ocfs2_reflink_xattr_header: OK
> [   59.585824] Testing event ocfs2_create_empty_xattr_block: OK
> [   59.597822] Testing event ocfs2_xattr_set_entry_bucket: OK
> [   59.622147] Testing event ocfs2_xattr_set_entry_index_block: OK
> [   59.641944] Testing event ocfs2_xattr_bucket_value_refcount: OK
> [   59.653984] Testing event ocfs2_reflink_xattr_buckets: OK
> [   59.665838] Testing event ocfs2_reflink_xattr_rec: OK
> [   59.677953] Testing event ocfs2_resv_insert: OK
> [   59.689801] Testing event ocfs2_resmap_find_free_bits_begin: OK
> [   59.701798] Testing event ocfs2_resmap_find_free_bits_end: OK
> [   59.713899] Testing event ocfs2_resv_find_window_begin: OK
> [   59.757802] Testing event ocfs2_resv_find_window_prev: OK
> [   59.769857] Testing event ocfs2_resv_find_window_next: OK
> [   59.781770] Testing event ocfs2_cannibalize_resv_begin: OK
> [   59.810446] Testing event ocfs2_cannibalize_resv_end: OK
> [   59.829866] Testing event ocfs2_resmap_resv_bits: OK
> [   59.849978] Testing event ocfs2_resmap_claimed_bits_begin: OK
> [   59.861779] Testing event ocfs2_resmap_claimed_bits_end: OK
> [   59.873857] Testing event ocfs2_recover_local_quota_file: OK
> [   59.886027] Testing event ocfs2_finish_quota_recovery: OK
> [   59.899249] Testing event olq_set_dquot: OK
> [   59.910061] Testing event ocfs2_validate_quota_block: OK
> [   59.921879] Testing event ocfs2_sync_dquot: OK
> [   59.969981] Testing event ocfs2_sync_dquot_helper: OK
> [   59.989964] Testing event ocfs2_write_dquot: OK
> [   60.010107] Testing event ocfs2_release_dquot: OK
> [   60.030010] Testing event ocfs2_acquire_dquot: OK
> [   60.050043] Testing event ocfs2_mark_dquot_dirty: OK
> [   60.062151] Testing event ocfs2_search_dirblock: OK
> [   60.086121] Testing event ocfs2_validate_dir_block: OK
> [   60.106191] Testing event ocfs2_find_entry_el: OK
> [   60.125885] Testing event ocfs2_dx_dir_search: OK
> [   60.137976] Testing event ocfs2_dx_dir_search_leaf_info: OK
> [   60.149891] Testing event ocfs2_delete_entry_dx: OK
> [   60.161787] Testing event ocfs2_readdir: OK
> [   60.193948] Testing event ocfs2_find_files_on_disk: OK
> [   60.205835] Testing event ocfs2_check_dir_for_entry: OK
> [   60.217753] Testing event ocfs2_dx_dir_attach_index: OK
> [   60.229867] Testing event ocfs2_dx_dir_format_cluster: OK
> [   60.262029] Testing event ocfs2_dx_dir_index_root_block: OK
> [   60.281997] Testing event ocfs2_extend_dir: OK
> [   60.293911] Testing event ocfs2_dx_dir_rebalance: OK
> [   60.305938] Testing event ocfs2_dx_dir_rebalance_split: OK
> [   60.317862] Testing event ocfs2_prepare_dir_for_insert: OK
> [   60.349963] Testing event ocfs2_lookup: OK
> [   60.361921] Testing event ocfs2_mkdir: OK
> [   60.387569] Testing event ocfs2_create: OK
> [   60.405986] Testing event ocfs2_unlink: OK
> [   60.417970] Testing event ocfs2_symlink_create: OK
> [   60.441931] Testing event ocfs2_mv_orphaned_inode_to_new: OK
> [   60.461830] Testing event ocfs2_lookup_ret: OK
> [   60.482175] Testing event ocfs2_mknod: OK
> [   60.501829] Testing event ocfs2_link: OK
> [   60.522089] Testing event ocfs2_unlink_noent: OK
> [   60.533848] Testing event ocfs2_double_lock: OK
> [   60.557910] Testing event ocfs2_double_lock_end: OK
> [   60.577952] Testing event ocfs2_rename: OK
> [   60.598039] Testing event ocfs2_rename_target_exists: OK
> [   60.609771] Testing event ocfs2_rename_disagree: OK
> [   60.634216] Testing event ocfs2_rename_over_existing: OK
> [   60.645899] Testing event ocfs2_create_symlink_data: OK
> [   60.670133] Testing event ocfs2_symlink_begin: OK
> [   60.689929] Testing event ocfs2_blkno_stringify: OK
> [   60.710000] Testing event ocfs2_orphan_add_begin: OK
> [   60.730139] Testing event ocfs2_orphan_add_end: OK
> [   60.750231] Testing event ocfs2_orphan_del: OK
> [   60.761812] Testing event ocfs2_dentry_revalidate: OK
> [   60.773821] Testing event ocfs2_dentry_revalidate_negative: OK
> [   60.785787] Testing event ocfs2_dentry_revalidate_delete: OK
> [   60.798136] Testing event ocfs2_dentry_revalidate_orphaned: OK
> [   60.838124] Testing event ocfs2_dentry_revalidate_nofsdata: OK
> [   60.849793] Testing event ocfs2_dentry_revalidate_ret: OK
> [   60.862086] Testing event ocfs2_find_local_alias: OK
> [   60.889968] Testing event ocfs2_dentry_attach_lock: OK
> [   60.909929] Testing event ocfs2_dentry_attach_lock_found: OK
> [   60.930040] Testing event ocfs2_get_dentry_begin: OK
> [   60.949949] Testing event ocfs2_get_dentry_test_bit: OK
> [   60.970201] Testing event ocfs2_get_dentry_stale: OK
> [   60.990027] Testing event ocfs2_get_dentry_generation: OK
> [   61.009869] Testing event ocfs2_get_dentry_end: OK
> [   61.021839] Testing event ocfs2_get_parent: OK
> [   61.045959] Testing event ocfs2_get_parent_end: OK
> [   61.065981] Testing event ocfs2_encode_fh_begin: OK
> [   61.086118] Testing event ocfs2_encode_fh_self: OK
> [   61.106012] Testing event ocfs2_encode_fh_parent: OK
> [   61.126127] Testing event ocfs2_encode_fh_type: OK
> [   61.145917] Testing event ocfs2_commit_cache_begin: OK
> [   61.165854] Testing event ocfs2_commit_cache_end: OK
> [   61.185875] Testing event ocfs2_extend_trans: OK
> [   61.205948] Testing event ocfs2_extend_trans_restart: OK
> [   61.225988] Testing event ocfs2_journal_access: OK
> [   61.245911] Testing event ocfs2_journal_dirty: OK
> [   61.258024] Testing event ocfs2_journal_init: OK
> [   61.269803] Testing event ocfs2_journal_init_maxlen: OK
> [   61.297903] Testing event ocfs2_journal_shutdown: OK
> [   61.309919] Testing event ocfs2_journal_shutdown_wait: OK
> [   61.321802] Testing event ocfs2_complete_recovery: OK
> [   61.350117] Testing event ocfs2_complete_recovery_end: OK
> [   61.369963] Testing event ocfs2_complete_recovery_slot: OK
> [   61.389922] Testing event ocfs2_recovery_thread_node: OK
> [   61.401962] Testing event ocfs2_recovery_thread_end: OK
> [   61.413929] Testing event ocfs2_recovery_thread: OK
> [   61.425872] Testing event ocfs2_replay_journal_recovered: OK
> [   61.437865] Testing event ocfs2_replay_journal_lock_err: OK
> [   61.474035] Testing event ocfs2_replay_journal_skip: OK
> [   61.485912] Testing event ocfs2_recover_node: OK
> [   61.497727] Testing event ocfs2_recover_node_skip: OK
> [   61.526036] Testing event ocfs2_mark_dead_nodes: OK
> [   61.545901] Testing event ocfs2_queue_orphan_scan_begin: OK
> [   61.557906] Testing event ocfs2_queue_orphan_scan_end: OK
> [   61.569962] Testing event ocfs2_orphan_filldir: OK
> [   61.581878] Testing event ocfs2_recover_orphans: OK
> [   61.614091] Testing event ocfs2_recover_orphans_iput: OK
> [   61.626019] Testing event ocfs2_wait_on_mount: OK
> [   61.637860] Testing event ocfs2_read_blocks_sync: OK
> [   61.649979] Testing event ocfs2_read_blocks_sync_jbd: OK
> [   61.661921] Testing event ocfs2_read_blocks_from_disk: OK
> [   61.698037] Testing event ocfs2_read_blocks_bh: OK
> [   61.709824] Testing event ocfs2_read_blocks_end: OK
> [   61.734033] Testing event ocfs2_write_block: OK
> [   61.745918] Testing event ocfs2_read_blocks_begin: OK
> [   61.770001] Testing event ocfs2_purge_copied_metadata_tree: OK
> [   61.790138] Testing event ocfs2_metadata_cache_purge: OK
> [   61.810499] Testing event ocfs2_buffer_cached_begin: OK
> [   61.829893] Testing event ocfs2_buffer_cached_end: OK
> [   61.849843] Testing event ocfs2_append_cache_array: OK
> [   61.861870] Testing event ocfs2_insert_cache_tree: OK
> [   61.889945] Testing event ocfs2_expand_cache: OK
> [   61.909988] Testing event ocfs2_set_buffer_uptodate: OK
> [   61.929937] Testing event ocfs2_set_buffer_uptodate_begin: OK
> [   61.941796] Testing event ocfs2_remove_metadata_array: OK
> [   61.953872] Testing event ocfs2_remove_metadata_tree: OK
> [   61.965810] Testing event ocfs2_remove_block_from_cache: OK
> [   61.997981] Testing event xfs_attr_list_sf: OK
> [   62.017946] Testing event xfs_attr_list_sf_all: OK
> [   62.029885] Testing event xfs_attr_list_leaf: OK
> [   62.053911] Testing event xfs_attr_list_leaf_end: OK
> [   62.065870] Testing event xfs_attr_list_full: OK
> [   62.089924] Testing event xfs_attr_list_add: OK
> [   62.109849] Testing event xfs_attr_list_wrong_blk: OK
> [   62.121886] Testing event xfs_attr_list_notfound: OK
> [   62.145987] Testing event xfs_attr_leaf_list: OK
> [   62.166175] Testing event xfs_attr_node_list: OK
> [   62.177862] Testing event xfs_perag_get: OK
> [   62.202109] Testing event xfs_perag_get_tag: OK
> [   62.222095] Testing event xfs_perag_put: OK
> [   62.233991] Testing event xfs_perag_set_reclaim: OK
> [   62.258042] Testing event xfs_perag_clear_reclaim: OK
> [   62.269986] Testing event xfs_perag_set_eofblocks: OK
> [   62.281888] Testing event xfs_perag_clear_eofblocks: OK
> [   62.309980] Testing event xfs_attr_list_node_descend: OK
> [   62.322002] Testing event xfs_iext_insert: OK
> [   62.333746] Testing event xfs_iext_remove: OK
> [   62.341822] Testing event xfs_bmap_pre_update: OK
> [   62.377864] Testing event xfs_bmap_post_update: OK
> [   62.397896] Testing event xfs_extlist: OK
> [   62.409818] Testing event xfs_buf_init: OK
> [   62.421855] Testing event xfs_buf_free: OK
> [   62.433868] Testing event xfs_buf_hold: OK
> [   62.445738] Testing event xfs_buf_rele: OK
> [   62.481867] Testing event xfs_buf_iodone: OK
> [   62.501859] Testing event xfs_buf_iorequest: OK
> [   62.521852] Testing event xfs_buf_bawrite: OK
> [   62.542005] Testing event xfs_buf_lock: OK
> [   62.561825] Testing event xfs_buf_lock_done: OK
> [   62.581920] Testing event xfs_buf_trylock: OK
> [   62.603293] Testing event xfs_buf_unlock: OK
> [   62.622166] Testing event xfs_buf_iowait: OK
> [   62.641979] Testing event xfs_buf_iowait_done: OK
> [   62.653765] Testing event xfs_buf_delwri_queue: OK
> [   62.661898] Testing event xfs_buf_delwri_queued: OK
> [   62.677759] Testing event xfs_buf_delwri_split: OK
> [   62.689839] Testing event xfs_buf_get_uncached: OK
> [   62.725886] Testing event xfs_bdstrat_shut: OK
> [   62.737863] Testing event xfs_buf_item_relse: OK
> [   62.761970] Testing event xfs_buf_item_iodone: OK
> [   62.788792] Testing event xfs_buf_item_iodone_async: OK
> [   62.797789] Testing event xfs_buf_error_relse: OK
> [   62.809905] Testing event xfs_trans_read_buf_io: OK
> [   62.837917] Testing event xfs_trans_read_buf_shut: OK
> [   62.849853] Testing event xfs_btree_corrupt: OK
> [   62.861874] Testing event xfs_da_btree_corrupt: OK
> [   62.873777] Testing event xfs_reset_dqcounts: OK
> [   62.906000] Testing event xfs_inode_item_push: OK
> [   62.917757] Testing event xfs_buf_find: OK
> [   62.930002] Testing event xfs_buf_get: OK
> [   62.957947] Testing event xfs_buf_read: OK
> [   62.969864] Testing event xfs_buf_ioerror: OK
> [   62.993965] Testing event xfs_buf_item_size: OK
> [   63.005759] Testing event xfs_buf_item_size_stale: OK
> [   63.029944] Testing event xfs_buf_item_format: OK
> [   63.042110] Testing event xfs_buf_item_format_stale: OK
> [   63.066003] Testing event xfs_buf_item_pin: OK
> [   63.077788] Testing event xfs_buf_item_unpin: OK
> [   63.089902] Testing event xfs_buf_item_unpin_stale: OK
> [   63.117854] Testing event xfs_buf_item_unlock: OK
> [   63.141969] Testing event xfs_buf_item_unlock_stale: OK
> [   63.153787] Testing event xfs_buf_item_committed: OK
> [   63.170000] Testing event xfs_buf_item_push: OK
> [   63.193846] Testing event xfs_trans_get_buf: OK
> [   63.206070] Testing event xfs_trans_get_buf_recur: OK
> [   63.229941] Testing event xfs_trans_getsb: OK
> [   63.249892] Testing event xfs_trans_getsb_recur: OK
> [   63.261850] Testing event xfs_trans_read_buf: OK
> [   63.285968] Testing event xfs_trans_read_buf_recur: OK
> [   63.306997] Testing event xfs_trans_log_buf: OK
> [   63.326225] Testing event xfs_trans_brelse: OK
> [   63.338115] Testing event xfs_trans_bjoin: OK
> [   63.361991] Testing event xfs_trans_bhold: OK
> [   63.382997] Testing event xfs_trans_bhold_release: OK
> [   63.401853] Testing event xfs_trans_binval: OK
> [   63.413768] Testing event xfs_ilock: OK
> [   63.421802] Testing event xfs_ilock_nowait: OK
> [   63.453966] Testing event xfs_ilock_demote: OK
> [   63.473966] Testing event xfs_iunlock: OK
> [   63.493893] Testing event xfs_iget_skip: OK
> [   63.513940] Testing event xfs_iget_reclaim: OK
> [   63.525870] Testing event xfs_iget_reclaim_fail: OK
> [   63.537751] Testing event xfs_iget_hit: OK
> [   63.550004] Testing event xfs_iget_miss: OK
> [   63.581928] Testing event xfs_getattr: OK
> [   63.593824] Testing event xfs_setattr: OK
> [   63.618072] Testing event xfs_readlink: OK
> [   63.629832] Testing event xfs_alloc_file_space: OK
> [   63.653859] Testing event xfs_free_file_space: OK
> [   63.665878] Testing event xfs_readdir: OK
> [   63.689935] Testing event xfs_get_acl: OK
> [   63.710129] Testing event xfs_vm_bmap: OK
> [   63.730075] Testing event xfs_file_ioctl: OK
> [   63.741855] Testing event xfs_file_compat_ioctl: OK
> [   63.753963] Testing event xfs_ioctl_setattr: OK
> [   63.765867] Testing event xfs_dir_fsync: OK
> [   63.798030] Testing event xfs_file_fsync: OK
> [   63.817906] Testing event xfs_destroy_inode: OK
> [   63.829850] Testing event xfs_evict_inode: OK
> [   63.841903] Testing event xfs_update_time: OK
> [   63.854117] Testing event xfs_dquot_dqalloc: OK
> [   63.886070] Testing event xfs_dquot_dqdetach: OK
> [   63.897875] Testing event xfs_inode_set_eofblocks_tag: OK
> [   63.909943] Testing event xfs_inode_clear_eofblocks_tag: OK
> [   63.921792] Testing event xfs_inode_free_eofblocks_invalid: OK
> [   63.933916] Testing event xfs_ihold: OK
> [   63.969999] Testing event xfs_irele: OK
> [   63.981787] Testing event xfs_inode_pin: OK
> [   64.006036] Testing event xfs_inode_unpin: OK
> [   64.017854] Testing event xfs_inode_unpin_nowait: OK
> [   64.042054] Testing event xfs_remove: OK
> [   64.053855] Testing event xfs_link: OK
> [   64.061785] Testing event xfs_lookup: OK
> [   64.094006] Testing event xfs_create: OK
> [   64.113971] Testing event xfs_symlink: OK
> [   64.133944] Testing event xfs_rename: OK
> [   64.145918] Testing event xfs_dqadjust: OK
> [   64.157776] Testing event xfs_dqreclaim_want: OK
> [   64.165828] Testing event xfs_dqreclaim_dirty: OK
> [   64.201895] Testing event xfs_dqreclaim_busy: OK
> [   64.222092] Testing event xfs_dqreclaim_done: OK
> [   64.241960] Testing event xfs_dqattach_found: OK
> [   64.253790] Testing event xfs_dqattach_get: OK
> [   64.278030] Testing event xfs_dqalloc: OK
> [   64.289762] Testing event xfs_dqtobp_read: OK
> [   64.313900] Testing event xfs_dqread: OK
> [   64.329811] Testing event xfs_dqread_fail: OK
> [   64.341828] Testing event xfs_dqget_hit: OK
> [   64.365888] Testing event xfs_dqget_miss: OK
> [   64.377807] Testing event xfs_dqget_freeing: OK
> [   64.389996] Testing event xfs_dqget_dup: OK
> [   64.401941] Testing event xfs_dqput: OK
> [   64.413900] Testing event xfs_dqput_wait: OK
> [   64.425956] Testing event xfs_dqput_free: OK
> [   64.466003] Testing event xfs_dqrele: OK
> [   64.477913] Testing event xfs_dqflush: OK
> [   64.490097] Testing event xfs_dqflush_force: OK
> [   64.517937] Testing event xfs_dqflush_done: OK
> [   64.529778] Testing event xfs_log_done_nonperm: OK
> [   64.553972] Testing event xfs_log_done_perm: OK
> [   64.565776] Testing event xfs_log_umount_write: OK
> [   64.577970] Testing event xfs_log_grant_sleep: OK
> [   64.589929] Testing event xfs_log_grant_wake: OK
> [   64.601849] Testing event xfs_log_grant_wake_up: OK
> [   64.637925] Testing event xfs_log_reserve: OK
> [   64.649867] Testing event xfs_log_reserve_exit: OK
> [   64.661864] Testing event xfs_log_regrant: OK
> [   64.673801] Testing event xfs_log_regrant_exit: OK
> [   64.705836] Testing event xfs_log_regrant_reserve_enter: OK
> [   64.717857] Testing event xfs_log_regrant_reserve_exit: OK
> [   64.729774] Testing event xfs_log_regrant_reserve_sub: OK
> [   64.741834] Testing event xfs_log_ungrant_enter: OK
> [   64.754010] Testing event xfs_log_ungrant_exit: OK
> [   64.789943] Testing event xfs_log_ungrant_sub: OK
> [   64.801869] Testing event xfs_log_force: OK
> [   64.826005] Testing event xfs_ail_push: OK
> [   64.837854] Testing event xfs_ail_pinned: OK
> [   64.845819] Testing event xfs_ail_locked: OK
> [   64.857767] Testing event xfs_ail_flushing: OK
> [   64.894102] Testing event xfs_file_read: OK
> [   64.914095] Testing event xfs_file_buffered_write: OK
> [   64.934054] Testing event xfs_file_direct_write: OK
> [   64.954052] Testing event xfs_file_splice_read: OK
> [   64.965827] Testing event xfs_file_splice_write: OK
> [   64.977834] Testing event xfs_writepage: OK
> [   65.005955] Testing event xfs_releasepage: OK
> [   65.017839] Testing event xfs_invalidatepage: OK
> [   65.042008] Testing event xfs_map_blocks_found: OK
> [   65.062049] Testing event xfs_map_blocks_alloc: OK
> [   65.082135] Testing event xfs_get_blocks_found: OK
> [   65.093878] Testing event xfs_get_blocks_alloc: OK
> [   65.105930] Testing event xfs_delalloc_enospc: OK
> [   65.133842] Testing event xfs_unwritten_convert: OK
> [   65.145903] Testing event xfs_get_blocks_notfound: OK
> [   65.157856] Testing event xfs_setfilesize: OK
> [   65.186032] Testing event xfs_itruncate_extents_start: OK
> [   65.205889] Testing event xfs_itruncate_extents_end: OK
> [   65.225955] Testing event xfs_pagecache_inval: OK
> [   65.238059] Testing event xfs_bunmap: OK
> [   65.261952] Testing event xfs_extent_busy: OK
> [   65.273819] Testing event xfs_extent_busy_enomem: OK
> [   65.297936] Testing event xfs_extent_busy_force: OK
> [   65.309851] Testing event xfs_extent_busy_reuse: OK
> [   65.333940] Testing event xfs_extent_busy_clear: OK
> [   65.354012] Testing event xfs_extent_busy_trim: OK
> [   65.365855] Testing event xfs_trans_commit_lsn: OK
> [   65.390069] Testing event xfs_agf: OK
> [   65.410083] Testing event xfs_free_extent: OK
> [   65.421889] Testing event xfs_alloc_exact_done: OK
> [   65.446094] Testing event xfs_alloc_exact_notfound: OK
> [   65.466002] Testing event xfs_alloc_exact_error: OK
> [   65.477770] Testing event xfs_alloc_near_nominleft: OK
> [   65.502150] Testing event xfs_alloc_near_first: OK
> [   65.522038] Testing event xfs_alloc_near_greater: OK
> [   65.541933] Testing event xfs_alloc_near_lesser: OK
> [   65.553770] Testing event xfs_alloc_near_error: OK
> [   65.577953] Testing event xfs_alloc_near_noentry: OK
> [   65.589960] Testing event xfs_alloc_near_busy: OK
> [   65.601855] Testing event xfs_alloc_size_neither: OK
> [   65.630145] Testing event xfs_alloc_size_noentry: OK
> [   65.641909] Testing event xfs_alloc_size_nominleft: OK
> [   65.657816] Testing event xfs_alloc_size_done: OK
> [   65.681932] Testing event xfs_alloc_size_error: OK
> [   65.702002] Testing event xfs_alloc_size_busy: OK
> [   65.713970] Testing event xfs_alloc_small_freelist: OK
> [   65.738030] Testing event xfs_alloc_small_notenough: OK
> [   65.757999] Testing event xfs_alloc_small_done: OK
> [   65.777893] Testing event xfs_alloc_small_error: OK
> [   65.789857] Testing event xfs_alloc_vextent_badargs: OK
> [   65.801880] Testing event xfs_alloc_vextent_nofix: OK
> [   65.829947] Testing event xfs_alloc_vextent_noagbp: OK
> [   65.849822] Testing event xfs_alloc_vextent_loopfailed: OK
> [   65.861823] Testing event xfs_alloc_vextent_allfailed: OK
> [   65.885941] Testing event xfs_dir2_sf_addname: OK
> [   65.905860] Testing event xfs_dir2_sf_create: OK
> [   65.925933] Testing event xfs_dir2_sf_lookup: OK
> [   65.946096] Testing event xfs_dir2_sf_replace: OK
> [   65.957848] Testing event xfs_dir2_sf_removename: OK
> [   65.969954] Testing event xfs_dir2_sf_toino4: OK
> [   65.998023] Testing event xfs_dir2_sf_toino8: OK
> [   66.024390] Testing event xfs_dir2_sf_to_block: OK
> [   66.041872] Testing event xfs_dir2_block_addname: OK
> [   66.053851] Testing event xfs_dir2_block_lookup: OK
> [   66.065943] Testing event xfs_dir2_block_replace: OK
> [   66.077792] Testing event xfs_dir2_block_removename: OK
> [   66.110100] Testing event xfs_dir2_block_to_sf: OK
> [   66.121863] Testing event xfs_dir2_block_to_leaf: OK
> [   66.133754] Testing event xfs_dir2_leaf_addname: OK
> [   66.161958] Testing event xfs_dir2_leaf_lookup: OK
> [   66.181851] Testing event xfs_dir2_leaf_replace: OK
> [   66.201942] Testing event xfs_dir2_leaf_removename: OK
> [   66.213880] Testing event xfs_dir2_leaf_to_block: OK
> [   66.225715] Testing event xfs_dir2_leaf_to_node: OK
> [   66.238106] Testing event xfs_dir2_node_addname: OK
> [   66.269968] Testing event xfs_dir2_node_lookup: OK
> [   66.281903] Testing event xfs_dir2_node_replace: OK
> [   66.293767] Testing event xfs_dir2_node_removename: OK
> [   66.305928] Testing event xfs_dir2_node_to_leaf: OK
> [   66.318020] Testing event xfs_attr_sf_add: OK
> [   66.353920] Testing event xfs_attr_sf_addname: OK
> [   66.373966] Testing event xfs_attr_sf_create: OK
> [   66.393831] Testing event xfs_attr_sf_lookup: OK
> [   66.405819] Testing event xfs_attr_sf_remove: OK
> [   66.430027] Testing event xfs_attr_sf_removename: OK
> [   66.450077] Testing event xfs_attr_sf_to_leaf: OK
> [   66.469860] Testing event xfs_attr_leaf_add: OK
> [   66.481920] Testing event xfs_attr_leaf_add_old: OK
> [   66.493963] Testing event xfs_attr_leaf_add_new: OK
> [   66.522148] Testing event xfs_attr_leaf_add_work: OK
> [   66.533898] Testing event xfs_attr_leaf_addname: OK
> [   66.545913] Testing event xfs_attr_leaf_create: OK
> [   66.557866] Testing event xfs_attr_leaf_compact: OK
> [   66.569962] Testing event xfs_attr_leaf_get: OK
> [   66.581842] Testing event xfs_attr_leaf_lookup: OK
> [   66.594019] Testing event xfs_attr_leaf_replace: OK
> [   66.605842] Testing event xfs_attr_leaf_remove: OK
> [   66.653947] Testing event xfs_attr_leaf_removename: OK
> [   66.674120] Testing event xfs_attr_leaf_split: OK
> [   66.685904] Testing event xfs_attr_leaf_split_before: OK
> [   66.697785] Testing event xfs_attr_leaf_split_after: OK
> [   66.709861] Testing event xfs_attr_leaf_clearflag: OK
> [   66.742180] Testing event xfs_attr_leaf_setflag: OK
> [   66.761907] Testing event xfs_attr_leaf_flipflags: OK
> [   66.773851] Testing event xfs_attr_leaf_to_sf: OK
> [   66.785861] Testing event xfs_attr_leaf_to_node: OK
> [   66.798050] Testing event xfs_attr_leaf_rebalance: OK
> [   66.809773] Testing event xfs_attr_leaf_unbalance: OK
> [   66.821893] Testing event xfs_attr_leaf_toosmall: OK
> [   66.833793] Testing event xfs_attr_node_addname: OK
> [   66.841791] Testing event xfs_attr_node_get: OK
> [   66.893811] Testing event xfs_attr_node_lookup: OK
> [   66.905888] Testing event xfs_attr_node_replace: OK
> [   66.929895] Testing event xfs_attr_node_removename: OK
> [   66.941922] Testing event xfs_attr_fillstate: OK
> [   66.966008] Testing event xfs_attr_refillstate: OK
> [   66.985904] Testing event xfs_attr_rmtval_get: OK
> [   66.997893] Testing event xfs_attr_rmtval_set: OK
> [   67.022081] Testing event xfs_attr_rmtval_remove: OK
> [   67.041953] Testing event xfs_da_split: OK
> [   67.053957] Testing event xfs_da_join: OK
> [   67.078052] Testing event xfs_da_link_before: OK
> [   67.097969] Testing event xfs_da_link_after: OK
> [   67.117952] Testing event xfs_da_unlink_back: OK
> [   67.137924] Testing event xfs_da_unlink_forward: OK
> [   67.149885] Testing event xfs_da_root_split: OK
> [   67.174147] Testing event xfs_da_root_join: OK
> [   67.193850] Testing event xfs_da_node_add: OK
> [   67.214133] Testing event xfs_da_node_create: OK
> [   67.233943] Testing event xfs_da_node_split: OK
> [   67.253925] Testing event xfs_da_node_remove: OK
> [   67.265958] Testing event xfs_da_node_rebalance: OK
> [   67.290050] Testing event xfs_da_node_unbalance: OK
> [   67.309973] Testing event xfs_da_node_toosmall: OK
> [   67.329985] Testing event xfs_da_swap_lastblock: OK
> [   67.345858] Testing event xfs_da_grow_inode: OK
> [   67.357881] Testing event xfs_da_shrink_inode: OK
> [   67.385963] Testing event xfs_da_fixhashpath: OK
> [   67.397706] Testing event xfs_da_path_shift: OK
> [   67.421980] Testing event xfs_dir2_leafn_add: OK
> [   67.441852] Testing event xfs_dir2_leafn_remove: OK
> [   67.453792] Testing event xfs_dir2_grow_inode: OK
> [   67.478093] Testing event xfs_dir2_shrink_inode: OK
> [   67.489820] Testing event xfs_dir2_leafn_moveents: OK
> [   67.505881] Testing event xfs_swap_extent_before: OK
> [   67.517725] Testing event xfs_swap_extent_after: OK
> [   67.525808] Testing event xfs_log_recover_item_add: OK
> [   67.561850] Testing event xfs_log_recover_item_add_cont: OK
> [   67.573862] Testing event xfs_log_recover_item_reorder_head: OK
> [   67.585764] Testing event xfs_log_recover_item_reorder_tail: OK
> [   67.613945] Testing event xfs_log_recover_item_recover: OK
> [   67.633914] Testing event xfs_log_recover_buf_not_cancel: OK
> [   67.654129] Testing event xfs_log_recover_buf_cancel: OK
> [   67.665817] Testing event xfs_log_recover_buf_cancel_add: OK
> [   67.689943] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
> [   67.701890] Testing event xfs_log_recover_buf_recover: OK
> [   67.726102] Testing event xfs_log_recover_buf_inode_buf: OK
> [   67.745846] Testing event xfs_log_recover_buf_reg_buf: OK
> [   67.765944] Testing event xfs_log_recover_buf_dquot_buf: OK
> [   67.785956] Testing event xfs_log_recover_inode_recover: OK
> [   67.805964] Testing event xfs_log_recover_inode_cancel: OK
> [   67.817942] Testing event xfs_log_recover_inode_skip: OK
> [   67.841967] Testing event xfs_discard_extent: OK
> [   67.853855] Testing event xfs_discard_toosmall: OK
> [   67.877895] Testing event xfs_discard_exclude: OK
> [   67.897953] Testing event xfs_discard_busy: OK
> [   67.917980] Testing event jbd2_checkpoint: OK
> [   67.938010] Testing event jbd2_start_commit: OK
> [   67.957910] Testing event jbd2_commit_locking: OK
> [   67.977979] Testing event jbd2_commit_flushing: OK
> [   67.998064] Testing event jbd2_commit_logging: OK
> [   68.017944] Testing event jbd2_drop_transaction: OK
> [   68.029840] Testing event jbd2_end_commit: OK
> [   68.042011] Testing event jbd2_submit_inode_data: OK
> [   68.070088] Testing event jbd2_run_stats: OK
> [   68.081816] Testing event jbd2_checkpoint_stats: OK
> [   68.105966] Testing event jbd2_update_log_tail: OK
> [   68.117819] Testing event jbd2_write_superblock: OK
> [   68.129898] Testing event jbd_checkpoint: OK
> [   68.158044] Testing event jbd_start_commit: OK
> [   68.169760] Testing event jbd_commit_locking: OK
> [   68.194042] Testing event jbd_commit_flushing: OK
> [   68.213889] Testing event jbd_commit_logging: OK
> [   68.233949] Testing event jbd_drop_transaction: OK
> [   68.245801] Testing event jbd_end_commit: OK
> [   68.270025] Testing event jbd_do_submit_data: OK
> [   68.290030] Testing event jbd_cleanup_journal_tail: OK
> [   68.309907] Testing event journal_write_superblock: OK
> [   68.321921] Testing event ext4_free_inode: OK
> [   68.345930] Testing event ext4_request_inode: OK
> [   68.357785] Testing event ext4_allocate_inode: OK
> [   68.369761] Testing event ext4_evict_inode: OK
> [   68.377725] Testing event ext4_drop_inode: OK
> [   68.413900] Testing event ext4_mark_inode_dirty: OK
> [   68.433917] Testing event ext4_begin_ordered_truncate: OK
> [   68.453877] Testing event ext4_write_begin: OK
> [   68.473893] Testing event ext4_da_write_begin: OK
> [   68.493851] Testing event ext4_ordered_write_end: OK
> [   68.505809] Testing event ext4_writeback_write_end: OK
> [   68.529900] Testing event ext4_journalled_write_end: OK
> [   68.541869] Testing event ext4_da_write_end: OK
> [   68.565931] Testing event ext4_da_writepages: OK
> [   68.577823] Testing event ext4_da_write_pages: OK
> [   68.602023] Testing event ext4_da_writepages_result: OK
> [   68.613765] Testing event ext4_writepage: OK
> [   68.637894] Testing event ext4_readpage: OK
> [   68.649974] Testing event ext4_releasepage: OK
> [   68.674082] Testing event ext4_invalidatepage: OK
> [   68.693904] Testing event ext4_discard_blocks: OK
> [   68.713874] Testing event ext4_mb_new_inode_pa: OK
> [   68.733808] Testing event ext4_mb_new_group_pa: OK
> [   68.745783] Testing event ext4_mb_release_inode_pa: OK
> [   68.769972] Testing event ext4_mb_release_group_pa: OK
> [   68.781745] Testing event ext4_discard_preallocations: OK
> [   68.793787] Testing event ext4_mb_discard_preallocations: OK
> [   68.805802] Testing event ext4_request_blocks: OK
> [   68.837939] Testing event ext4_allocate_blocks: OK
> [   68.849814] Testing event ext4_free_blocks: OK
> [   68.873882] Testing event ext4_sync_file_enter: OK
> [   68.885825] Testing event ext4_sync_file_exit: OK
> [   68.909992] Testing event ext4_sync_fs: OK
> [   68.929876] Testing event ext4_alloc_da_blocks: OK
> [   68.950004] Testing event ext4_mballoc_alloc: OK
> [   68.970102] Testing event ext4_mballoc_prealloc: OK
> [   68.989875] Testing event ext4_mballoc_discard: OK
> [   69.001857] Testing event ext4_mballoc_free: OK
> [   69.025923] Testing event ext4_forget: OK
> [   69.045944] Testing event ext4_da_update_reserve_space: OK
> [   69.065752] Testing event ext4_da_reserve_space: OK
> [   69.085954] Testing event ext4_da_release_space: OK
> [   69.105884] Testing event ext4_mb_bitmap_load: OK
> [   69.125930] Testing event ext4_mb_buddy_bitmap_load: OK
> [   69.145913] Testing event ext4_read_block_bitmap_load: OK
> [   69.166020] Testing event ext4_load_inode_bitmap: OK
> [   69.186049] Testing event ext4_direct_IO_enter: OK
> [   69.197801] Testing event ext4_direct_IO_exit: OK
> [   69.209799] Testing event ext4_fallocate_enter: OK
> [   69.237921] Testing event ext4_fallocate_exit: OK
> [   69.249808] Testing event ext4_unlink_enter: OK
> [   69.257891] Testing event ext4_unlink_exit: OK
> [   69.289859] Testing event ext4_truncate_enter: OK
> [   69.316642] Testing event ext4_truncate_exit: OK
> [   69.334036] Testing event ext4_ext_convert_to_initialized_enter: OK
> [   69.358044] Testing event ext4_ext_convert_to_initialized_fastpath: OK
> [   69.377932] Testing event ext4_ext_map_blocks_enter: OK
> [   69.397931] Testing event ext4_ind_map_blocks_enter: OK
> [   69.409826] Testing event ext4_ext_map_blocks_exit: OK
> [   69.421748] Testing event ext4_ind_map_blocks_exit: OK
> [   69.433799] Testing event ext4_ext_load_extent: OK
> [   69.445954] Testing event ext4_load_inode: OK
> [   69.482040] Testing event ext4_journal_start: OK
> [   69.494125] Testing event ext4_trim_extent: OK
> [   69.505879] Testing event ext4_trim_all_free: OK
> [   69.517744] Testing event ext4_ext_handle_uninitialized_extents: OK
> [   69.550030] Testing event ext4_get_implied_cluster_alloc_exit: OK
> [   69.561789] Testing event ext4_ext_put_in_cache: OK
> [   69.590057] Testing event ext4_ext_in_cache: OK
> [   69.609892] Testing event ext4_find_delalloc_range: OK
> [   69.621912] Testing event ext4_get_reserved_cluster_alloc: OK
> [   69.645993] Testing event ext4_ext_show_extent: OK
> [   69.665943] Testing event ext4_remove_blocks: OK
> [   69.685944] Testing event ext4_ext_rm_leaf: OK
> [   69.706179] Testing event ext4_ext_rm_idx: OK
> [   69.726012] Testing event ext4_ext_remove_space: OK
> [   69.745984] Testing event ext4_ext_remove_space_done: OK
> [   69.765976] Testing event ext4_es_insert_extent: OK
> [   69.786230] Testing event ext4_es_remove_extent: OK
> [   69.805993] Testing event ext4_es_find_extent_enter: OK
> [   69.825951] Testing event ext4_es_find_extent_exit: OK
> [   69.846300] Testing event ext3_free_inode: OK
> [   69.873972] Testing event ext3_request_inode: OK
> [   69.893984] Testing event ext3_allocate_inode: OK
> [   69.905886] Testing event ext3_evict_inode: OK
> [   69.930233] Testing event ext3_drop_inode: OK
> [   69.950205] Testing event ext3_mark_inode_dirty: OK
> [   69.961847] Testing event ext3_write_begin: OK
> [   69.986239] Testing event ext3_ordered_write_end: OK
> [   70.005915] Testing event ext3_writeback_write_end: OK
> [   70.017772] Testing event ext3_journalled_write_end: OK
> [   70.042270] Testing event ext3_ordered_writepage: OK
> [   70.054090] Testing event ext3_writeback_writepage: OK
> [   70.077917] Testing event ext3_journalled_writepage: OK
> [   70.097919] Testing event ext3_readpage: OK
> [   70.110329] Testing event ext3_releasepage: OK
> [   70.121849] Testing event ext3_invalidatepage: OK
> [   70.149941] Testing event ext3_discard_blocks: OK
> [   70.161902] Testing event ext3_request_blocks: OK
> [   70.186225] Testing event ext3_allocate_blocks: OK
> [   70.197947] Testing event ext3_free_blocks: OK
> [   70.222281] Testing event ext3_sync_file_enter: OK
> [   70.233912] Testing event ext3_sync_file_exit: OK
> [   70.246091] Testing event ext3_sync_fs: OK
> [   70.258133] Testing event ext3_rsv_window_add: OK
> [   70.269799] Testing event ext3_discard_reservation: OK
> [   70.282166] Testing event ext3_alloc_new_reservation: OK
> [   70.294132] Testing event ext3_reserved: OK
> [   70.337887] Testing event ext3_forget: OK
> [   70.358240] Testing event ext3_read_block_bitmap: OK
> [   70.370119] Testing event ext3_direct_IO_enter: OK
> [   70.382122] Testing event ext3_direct_IO_exit: OK
> [   70.409955] Testing event ext3_unlink_enter: OK
> [   70.421934] Testing event ext3_unlink_exit: OK
> [   70.433784] Testing event ext3_truncate_enter: OK
> [   70.445898] Testing event ext3_truncate_exit: OK
> [   70.478264] Testing event ext3_get_blocks_enter: OK
> [   70.489942] Testing event ext3_get_blocks_exit: OK
> [   70.502116] Testing event ext3_load_inode: OK
> [   70.530193] Testing event writeback_nothread: OK
> [   70.550271] Testing event writeback_queue: OK
> [   70.561865] Testing event writeback_exec: OK
> [   70.570176] Testing event writeback_start: OK
> [   70.602251] Testing event writeback_written: OK
> [   70.622250] Testing event writeback_wait: OK
> [   70.634179] Testing event writeback_pages_written: OK
> [   70.646081] Testing event writeback_nowork: OK
> [   70.674028] Testing event writeback_wake_background: OK
> [   70.693961] Testing event writeback_wake_thread: OK
> [   70.713920] Testing event writeback_wake_forker_thread: OK
> [   70.725763] Testing event writeback_bdi_register: OK
> [   70.750150] Testing event writeback_bdi_unregister: OK
> [   70.770133] Testing event writeback_thread_start: OK
> [   70.790026] Testing event writeback_thread_stop: OK
> [   70.809836] Testing event wbc_writepage: OK
> [   70.830023] Testing event writeback_queue_io: OK
> [   70.849983] Testing event global_dirty_state: OK
> [   70.861864] Testing event bdi_dirty_ratelimit: OK
> [   70.873887] Testing event balance_dirty_pages: OK
> [   70.902158] Testing event writeback_sb_inodes_requeue: OK
> [   70.921940] Testing event writeback_congestion_wait: OK
> [   70.941911] Testing event writeback_wait_iff_congested: OK
> [   70.953810] Testing event writeback_single_inode: OK
> [   70.978053] Testing event mm_migrate_pages: OK
> [   70.989883] Testing event mm_compaction_isolate_migratepages: OK
> [   71.014166] Testing event mm_compaction_isolate_freepages: OK
> [   71.033969] Testing event mm_compaction_migratepages: OK
> [   71.045891] Testing event kmalloc: OK
> [   71.058196] Testing event kmem_cache_alloc: OK
> [   71.069850] Testing event kmalloc_node: OK
> [   71.102012] Testing event kmem_cache_alloc_node: OK
> [   71.113763] Testing event kfree: OK
> [   71.137981] Testing event kmem_cache_free: OK
> [   71.149894] Testing event mm_page_free: OK
> [   71.161907] Testing event mm_page_free_batched: OK
> [   71.189863] Testing event mm_page_alloc: OK
> [   71.209937] Testing event mm_page_alloc_zone_locked: OK
> [   71.229925] Testing event mm_page_pcpu_drain: OK
> [   71.241875] Testing event mm_page_alloc_extfrag: OK
> [   71.265829] Testing event mm_vmscan_kswapd_sleep: OK
> [   71.277940] Testing event mm_vmscan_kswapd_wake: OK
> [   71.301867] Testing event mm_vmscan_wakeup_kswapd: OK
> [   71.321928] Testing event mm_vmscan_direct_reclaim_begin: OK
> [   71.333869] Testing event mm_vmscan_memcg_reclaim_begin: OK
> [   71.357901] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
> [   71.377948] Testing event mm_vmscan_direct_reclaim_end: OK
> [   71.389867] Testing event mm_vmscan_memcg_reclaim_end: OK
> [   71.414101] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
> [   71.433882] Testing event mm_shrink_slab_start: OK
> [   71.453947] Testing event mm_shrink_slab_end: OK
> [   71.465818] Testing event mm_vmscan_lru_isolate: OK
> [   71.490055] Testing event mm_vmscan_memcg_isolate: OK
> [   71.510034] Testing event mm_vmscan_writepage: OK
> [   71.529981] Testing event mm_vmscan_lru_shrink_inactive: OK
> [   71.549862] Testing event oom_score_adj_update: OK
> [   71.569865] Testing event rpm_suspend: OK
> [   71.578066] Testing event rpm_resume: OK
> [   71.605936] Testing event rpm_idle: OK
> [   71.626121] Testing event rpm_return_int: OK
> [   71.645910] Testing event cpu_idle: OK
> [   71.665996] Testing event cpu_frequency: OK
> [   71.685837] Testing event machine_suspend: OK
> [   71.705897] Testing event wakeup_source_activate: OK
> [   71.725954] Testing event wakeup_source_deactivate: OK
> [   71.737770] Testing event power_start: OK
> [   71.745804] Testing event power_frequency: OK
> [   71.757845] Testing event power_end: OK
> [   71.769819] Testing event clock_enable: OK
> [   71.810093] Testing event clock_disable: OK
> [   71.829908] Testing event clock_set_rate: OK
> [   71.849875] Testing event power_domain_target: OK
> [   71.869963] Testing event ftrace_test_filter: OK
> [   71.881898] Testing event module_load: OK
> [   71.893831] Testing event module_free: OK
> [   71.905919] Testing event module_get: OK
> [   71.917833] Testing event module_put: OK
> [   71.953883] Testing event module_request: OK
> [   71.973998] Testing event lock_acquire: OK
> [   71.985854] Testing event lock_release: OK
> [   72.009943] Testing event lock_contended: OK
> [   72.029911] Testing event lock_acquired: OK
> [   72.041812] Testing event sched_kthread_stop: OK
> [   72.065952] Testing event sched_kthread_stop_ret: OK
> [   72.085966] Testing event sched_wakeup: OK
> [   72.105874] Testing event sched_wakeup_new: OK
> [   72.117813] Testing event sched_switch: OK
> [   72.142012] Testing event sched_migrate_task: OK
> [   72.161951] Testing event sched_process_free: OK
> [   72.181960] Testing event sched_process_exit: OK
> [   72.193867] Testing event sched_wait_task: OK
> [   72.205772] Testing event sched_process_wait: OK
> [   72.233929] Testing event sched_process_fork: OK
> [   72.253913] Testing event sched_process_exec: OK
> [   72.273980] Testing event sched_stat_wait: OK
> [   72.285867] Testing event sched_stat_sleep: OK
> [   72.297749] Testing event sched_stat_iowait: OK
> [   72.326033] Testing event sched_stat_blocked: OK
> [   72.346016] Testing event sched_stat_runtime: OK
> [   72.357858] Testing event sched_pi_setprio: OK
> [   72.382103] Testing event rcu_utilization: OK
> [   72.401922] Testing event rcu_grace_period: OK
> [   72.413928] Testing event rcu_grace_period_init: OK
> [   72.425787] Testing event rcu_preempt_task: OK
> [   72.437900] Testing event rcu_unlock_preempted_task: OK
> [   72.470017] Testing event rcu_quiescent_state_report: OK
> [   72.481887] Testing event rcu_fqs: OK
> [   72.489844] Testing event rcu_dyntick: OK
> [   72.521911] Testing event rcu_prep_idle: OK
> [   72.542090] Testing event rcu_callback: OK
> [   72.553840] Testing event rcu_kfree_callback: OK
> [   72.578032] Testing event rcu_batch_start: OK
> [   72.589813] Testing event rcu_invoke_callback: OK
> [   72.614062] Testing event rcu_invoke_kfree_callback: OK
> [   72.640412] Testing event rcu_batch_end: OK
> [   72.649816] Testing event rcu_torture_read: OK
> [   72.673923] Testing event rcu_barrier: OK
> [   72.693830] Testing event workqueue_queue_work: OK
> [   72.714124] Testing event workqueue_activate_work: OK
> [   72.733902] Testing event workqueue_execute_start: OK
> [   72.745865] Testing event workqueue_execute_end: OK
> [   72.769964] Testing event signal_generate: OK
> [   72.781934] Testing event signal_deliver: OK
> [   72.805908] Testing event timer_init: OK
> [   72.825908] Testing event timer_start: OK
> [   72.837844] Testing event timer_expire_entry: OK
> [   72.862106] Testing event timer_expire_exit: OK
> [   72.881857] Testing event timer_cancel: OK
> [   72.902077] Testing event hrtimer_init: OK
> [   72.913835] Testing event hrtimer_start: OK
> [   72.938060] Testing event hrtimer_expire_entry: OK
> [   72.949837] Testing event hrtimer_expire_exit: OK
> [   72.961855] Testing event hrtimer_cancel: OK
> [   72.989878] Testing event itimer_state: OK
> [   73.009925] Testing event itimer_expire: OK
> [   73.021858] Testing event irq_handler_entry: OK
> [   73.046046] Testing event irq_handler_exit: OK
> [   73.065978] Testing event softirq_entry: OK
> [   73.085912] Testing event softirq_exit: OK
> [   73.097768] Testing event softirq_raise: OK
> [   73.106068] Testing event console: OK
> [   73.137871] Testing event task_newtask: OK
> [   73.158084] Testing event task_rename: OK
> [   73.178015] Testing event mce_record: OK
> [   73.197871] Testing event sys_enter: OK
> [   73.209805] Testing event sys_exit: OK
> [   73.217932] Testing event emulate_vsyscall: OK
> [   73.249972] Testing event xen_mc_batch: OK
> [   73.261826] Testing event xen_mc_issue: OK
> [   73.273877] Testing event xen_mc_entry: OK
> [   73.301990] Testing event xen_mc_entry_alloc: OK
> [   73.321857] Testing event xen_mc_callback: OK
> [   73.334031] Testing event xen_mc_flush_reason: OK
> [   73.357925] Testing event xen_mc_flush: OK
> [   73.369844] Testing event xen_mc_extend_args: OK
> [   73.393962] Testing event xen_mmu_set_pte: OK
> [   73.414005] Testing event xen_mmu_set_pte_atomic: OK
> [   73.433903] Testing event xen_mmu_set_domain_pte: OK
> [   73.453930] Testing event xen_mmu_set_pte_at: OK
> [   73.465809] Testing event xen_mmu_pte_clear: OK
> [   73.477924] Testing event xen_mmu_set_pmd: OK
> [   73.505853] Testing event xen_mmu_pmd_clear: OK
> [   73.517936] Testing event xen_mmu_set_pud: OK
> [   73.541874] Testing event xen_mmu_set_pgd: OK
> [   73.553765] Testing event xen_mmu_pud_clear: OK
> [   73.565847] Testing event xen_mmu_pgd_clear: OK
> [   73.577737] Testing event xen_mmu_ptep_modify_prot_start: OK
> [   73.590031] Testing event xen_mmu_ptep_modify_prot_commit: OK
> [   73.601826] Testing event xen_mmu_alloc_ptpage: OK
> [   73.642023] Testing event xen_mmu_release_ptpage: OK
> [   73.661978] Testing event xen_mmu_pgd_pin: OK
> [   73.673851] Testing event xen_mmu_pgd_unpin: OK
> [   73.698111] Testing event xen_mmu_flush_tlb_all: OK
> [   73.709860] Testing event xen_mmu_flush_tlb: OK
> [   73.733965] Testing event xen_mmu_flush_tlb_single: OK
> [   73.754012] Testing event xen_mmu_flush_tlb_others: OK
> [   73.765925] Testing event xen_mmu_write_cr3: OK
> [   73.777771] Testing event xen_cpu_write_ldt_entry: OK
> [   73.806184] Testing event xen_cpu_write_idt_entry: OK
> [   73.817854] Testing event xen_cpu_load_idt: OK
> [   73.842159] Testing event xen_cpu_write_gdt_entry: OK
> [   73.861879] Testing event xen_cpu_set_ldt: OK
> [   73.881879] Testing event kvm_mmu_pagetable_walk: OK
> [   73.893863] Testing event kvm_mmu_paging_element: OK
> [   73.917978] Testing event kvm_mmu_set_accessed_bit: OK
> [   73.937894] Testing event kvm_mmu_set_dirty_bit: OK
> [   73.949805] Testing event kvm_mmu_walker_error: OK
> [   73.963357] Testing event kvm_mmu_get_page: OK
> [   73.974041] Testing event kvm_mmu_sync_page: OK
> [   74.005908] Testing event kvm_mmu_unsync_page: OK
> [   74.026072] Testing event kvm_mmu_prepare_zap_page: OK
> [   74.037816] Testing event kvm_mmu_delay_free_pages: OK
> [   74.061966] Testing event mark_mmio_spte: OK
> [   74.081938] Testing event handle_mmio_page_fault: OK
> [   74.093793] Testing event fast_page_fault: OK
> [   74.105930] Testing event kvm_entry: OK
> [   74.133939] Testing event kvm_hypercall: OK
> [   74.153773] Testing event kvm_hv_hypercall: OK
> [   74.161754] Testing event kvm_pio: OK
> [   74.169942] Testing event kvm_cpuid: OK
> [   74.181875] Testing event kvm_apic: OK
> [   74.221924] Testing event kvm_exit: OK
> [   74.233915] Testing event kvm_inj_virq: OK
> [   74.258035] Testing event kvm_inj_exception: OK
> [   74.269804] Testing event kvm_page_fault: OK
> [   74.281869] Testing event kvm_msr: OK
> [   74.309937] Testing event kvm_cr: OK
> [   74.329827] Testing event kvm_pic_set_irq: OK
> [   74.349819] Testing event kvm_apic_ipi: OK
> [   74.369903] Testing event kvm_apic_accept_irq: OK
> [   74.381857] Testing event kvm_eoi: OK
> [   74.393875] Testing event kvm_pv_eoi: OK
> [   74.421912] Testing event kvm_nested_vmrun: OK
> [   74.433811] Testing event kvm_nested_intercepts: OK
> [   74.458021] Testing event kvm_nested_vmexit: OK
> [   74.477924] Testing event kvm_nested_vmexit_inject: OK
> [   74.489830] Testing event kvm_nested_intr_vmexit: OK
> [   74.501880] Testing event kvm_invlpga: OK
> [   74.529942] Testing event kvm_skinit: OK
> [   74.549927] Testing event kvm_emulate_insn: OK
> [   74.561867] Testing event vcpu_match_mmio: OK
> [   74.573837] Testing event kvm_update_master_clock: OK
> [   74.585806] Testing event kvm_track_tsc: OK
> [   74.593866] Testing event kvm_userspace_exit: OK
> [   74.633814] Testing event kvm_set_irq: OK
> [   74.649939] Testing event kvm_ioapic_set_irq: OK
> [   74.661940] Testing event kvm_msi_set_irq: OK
> [   74.685919] Testing event kvm_ack_irq: OK
> [   74.705963] Testing event kvm_mmio: OK
> [   74.725919] Testing event kvm_fpu: OK
> [   74.745913] Testing event kvm_age_page: OK
> [   74.765904] Testing event kvm_try_async_get_page: OK
> [   74.785872] Testing event kvm_async_pf_doublefault: OK
> [   74.805911] Testing event kvm_async_pf_not_present: OK
> [   74.817802] Testing event kvm_async_pf_ready: OK
> [   74.829812] Testing event kvm_async_pf_completed: OK
> [   74.857793] Running tests on trace event systems:
> [   74.858732] Testing event system kvm: OK
> [   74.895296] Testing event system kvmmmu: OK
> [   74.913612] Testing event system xen: OK
> [   74.953504] Testing event system vsyscall: OK
> [   74.969839] Testing event system raw_syscalls: OK
> [   74.982179] Testing event system mce: OK
> [   74.993739] Testing event system task: OK
> [   75.022249] Testing event system printk: OK
> [   75.041879] Testing event system irq: OK
> [   75.063230] Testing event system timer: OK
> [   75.089427] Testing event system signal: OK
> [   75.114239] Testing event system workqueue: OK
> [   75.134912] Testing event system rcu: OK
> [   75.163092] Testing event system sched: OK
> [   75.183498] Testing event system lock: OK
> [   75.194795] Testing event system module: OK
> [   75.219175] Testing event system test: OK
> [   75.237848] Testing event system power: OK
> [   75.253459] Testing event system rpm: OK
> [   75.266788] Testing event system oom: OK
> [   75.289822] Testing event system vmscan: OK
> [   75.310264] Testing event system kmem: OK
> [   75.337438] Testing event system compaction: OK
> [   75.358565] Testing event system migrate: OK
> [   75.369760] Testing event system writeback: OK
> [   75.393469] Testing event system ext3: OK
> [   75.430225] Testing event system ext4: OK
> [   75.493490] Testing event system jbd: OK
> [   75.508803] Testing event system jbd2: OK
> [   75.533606] Testing event system xfs: OK
> [   75.798641] Testing event system ocfs2: OK
> [   76.058522] Testing event system btrfs: OK
> [   76.095150] Testing event system gfs2: OK
> [   76.122026] Testing event system block: OK
> [   76.152886] Testing event system gpio: OK
> [   76.162147] Testing event system regulator: OK
> [   76.187946] Testing event system random: OK
> [   76.199490] Testing event system drm: OK
> [   76.222507] Testing event system radeon: OK
> [   76.235059] Testing event system i915: OK
> [   76.269401] Testing event system regmap: OK
> [   76.284697] Testing event system scsi: OK
> [   76.307101] Testing event system ras: OK
> [   76.326028] Testing event system hda: OK
> [   76.339833] Testing event system hda_intel: OK
> [   76.362122] Testing event system syscalls: OK
> [   76.384208] Testing event system udp: OK
> [   76.401843] Testing event system sock: OK
> [   76.414158] Testing event system napi: OK
> [   76.425806] Testing event system net: OK
> [   76.438680] Testing event system skb: OK
> [   76.450312] Testing event system sunrpc: OK
> [   76.488133] Testing event system cfg80211: OK
> [   76.583762] Testing event system mac80211: OK
> [   76.660899] Testing event system 9p: OK
> [   76.670568] Running tests on all trace events:
> [   76.671493] Testing all events: OK
> [   78.163755] Testing ftrace filter: OK
> [   78.165774] Testing kprobe tracing: OK
> [   78.173328] kAFS: Red Hat AFS client v0.1 registering.
> [   78.174247] FS-Cache: Netfs 'afs' registered for caching
> [   78.177174] console [netcon0] enabled
> [   78.177819] netconsole: network logging started
> [   78.178758] rtc_cmos 00:00: setting system clock to 2012-12-18 20:13:44 UTC (1355861624)
> [   78.180184] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
> [   78.182813] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
> [   78.183750] 8021q: adding VLAN 0 to HW filter on device bond0
> [   78.186310] IP-Config: Failed to open ipddp0
> [   78.192774] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   78.194374] 8021q: adding VLAN 0 to HW filter on device eth0
> [   78.195320] IP-Config: Failed to open plip0
> [   78.196049] ieee80211 phy0: mac80211_hwsim_start
> [   78.196807] ieee80211 phy0: mac80211_hwsim_add_interface (type=2 mac_addr=02:00:00:00:00:00)
> [   78.198093] ieee80211 phy0: mac80211_hwsim_bss_info_changed(changed=0xe)
> [   78.199061] ieee80211 phy0:   ERP_CTS_PROT: 0
> [   78.199770] ieee80211 phy0:   ERP_PREAMBLE: 0
> [   78.200518] ieee80211 phy0:   ERP_SLOT: 0
> [   78.201175] ieee80211 phy0: mac80211_hwsim_conf_tx (queue=0 txop=0 cw_min=15 cw_max=1023 aifs=2)
> [   78.202528] ieee80211 phy0: mac80211_hwsim_conf_tx (queue=1 txop=0 cw_min=15 cw_max=1023 aifs=2)
> [   78.203851] ieee80211 phy0: mac80211_hwsim_conf_tx (queue=2 txop=0 cw_min=15 cw_max=1023 aifs=2)
> [   78.205196] ieee80211 phy0: mac80211_hwsim_conf_tx (queue=3 txop=0 cw_min=15 cw_max=1023 aifs=2)
> [   78.206567] ieee80211 phy0: mac80211_hwsim_bss_info_changed(changed=0x2000)
> [   78.207586] ieee80211 phy0: mac80211_hwsim_bss_info_changed(changed=0x4000)
> [   78.208621] ieee80211 phy0: mac80211_hwsim_config (freq=2412/noht idle=1 ps=0 smps=static)
> [   78.210028] ieee80211 phy0: mac80211_hwsim_configure_filter
> [   78.210966] ieee80211 phy0: mac80211_hwsim_configure_filter
> [   78.211960] ieee80211 phy0: mac80211_hwsim_configure_filter
> [   78.213481] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   78.214368] ieee80211 phy0: mac80211_hwsim_configure_filter
> [   78.215289] ieee80211 phy1: mac80211_hwsim_start
> [   78.216051] ieee80211 phy1: mac80211_hwsim_add_interface (type=2 mac_addr=02:00:00:00:01:00)
> [   78.217341] ieee80211 phy1: mac80211_hwsim_bss_info_changed(changed=0xe)
> [   78.218300] ieee80211 phy1:   ERP_CTS_PROT: 0
> [   78.219008] ieee80211 phy1:   ERP_PREAMBLE: 0
> [   78.219721] ieee80211 phy1:   ERP_SLOT: 0
> [   78.220427] ieee80211 phy1: mac80211_hwsim_conf_tx (queue=0 txop=0 cw_min=15 cw_max=1023 aifs=2)
> [   78.221745] ieee80211 phy1: mac80211_hwsim_conf_tx (queue=1 txop=0 cw_min=15 cw_max=1023 aifs=2)
> [   78.223085] ieee80211 phy1: mac80211_hwsim_conf_tx (queue=2 txop=0 cw_min=15 cw_max=1023 aifs=2)
> [   78.224451] ieee80211 phy1: mac80211_hwsim_conf_tx (queue=3 txop=0 cw_min=15 cw_max=1023 aifs=2)
> [   78.225755] ieee80211 phy1: mac80211_hwsim_bss_info_changed(changed=0x2000)
> [   78.226726] ieee80211 phy1: mac80211_hwsim_bss_info_changed(changed=0x4000)
> [   78.227693] ieee80211 phy1: mac80211_hwsim_config (freq=2412/noht idle=1 ps=0 smps=static)
> [   78.228980] ieee80211 phy1: mac80211_hwsim_configure_filter
> [   78.229874] ieee80211 phy1: mac80211_hwsim_configure_filter
> [   78.230780] ieee80211 phy1: mac80211_hwsim_configure_filter
> [   78.232083] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [   78.232987] ieee80211 phy1: mac80211_hwsim_configure_filter
> [   78.234000] DHCP/BOOTP: Ignoring device hardwpan0, MTU 127 too small
> [   78.234793] IP-Config: Failed to open irlan0
> [   78.248119] Sending DHCP requests .[   80.196699] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> [   80.198375] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> Unknown ARP type 0x0323 for device hwsim0
> [   83.764118] ., OK
> [   85.268454] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0.2.15
> [   85.271578] ieee80211 phy0: mac80211_hwsim_configure_filter
> [   85.272467] ieee80211 phy0: mac80211_hwsim_configure_filter
> [   85.276430] ieee80211 phy0: mac80211_hwsim_remove_interface (type=2 mac_addr=02:00:00:00:00:00)
> [   85.277728] ieee80211 phy0: mac80211_hwsim_stop
> [   85.278798] ieee80211 phy1: mac80211_hwsim_configure_filter
> [   85.279788] ieee80211 phy1: mac80211_hwsim_configure_filter
> [   85.284416] ieee80211 phy1: mac80211_hwsim_remove_interface (type=2 mac_addr=02:00:00:00:01:00)
> [   85.285780] ieee80211 phy1: mac80211_hwsim_stop
> [   85.287287] IP-Config: Complete:
> [   85.287849]      device=eth0, hwaddr=52:54:00:12:34:56, ipaddr=10.0.2.15, mask=255.255.255.0, gw=10.0.2.2
> [   85.289253]      host=kvm, domain=, nis-domain=(none)
> [   85.290041]      bootserver=10.0.2.2, rootserver=10.239.97.14, rootpath=
> [   85.290829]      nameserver0=10.0.2.3[   85.291515] ALSA device list:
> [   85.292064]   #0: Dummy 1
> [   85.292564]   #1: Loopback 1
> [   85.293080]   #2: Virtual MIDI Card 1
> [   85.293687]   #3: HDA Intel at 0xfebf0000 irq 52
> [   85.295022] md: Waiting for all devices to be available before autodetect
> [   85.295978] md: If you don't use raid, use raid=noautodetect
> [   85.297846] md: Autodetecting RAID arrays.
> [   85.298486] md: Scanned 0 and added 0 devices.
> [   85.299142] md: autorun ...
> [   85.299654] md: ... autorun DONE.
> [   88.420474] VFS: Mounted root (nfs filesystem) on device 0:14.
> [   88.421371] debug: unmapping init [mem 0xffffffff83f8e000-0xffffffff84359fff]
> [   88.422565] Write protecting the kernel read-only data: 45056k
> [   88.424372] debug: unmapping init [mem 0xffff880002c26000-0xffff880002dfffff]
> [   88.425490] debug: unmapping init [mem 0xffff880003aef000-0xffff880003bfffff]
> [   88.574062] modprobe (3166) used greatest stack depth: 3344 bytes left
> [   88.993596] S02mountkernfs. (3187) used greatest stack depth: 3056 bytes left
> [   89.243805] write_dev_root_ (3265) used greatest stack depth: 2704 bytes left
> [   89.666207] ------------[ cut here ]------------
> [   89.667098] WARNING: at /c/kernel-tests/src/stable/block/genhd.c:1574 disk_clear_events+0xcf/0x108()
> [   89.668040] Hardware name: Bochs
> [   89.668040] Modules linked in:
> [   89.668040] Pid: 3328, comm: ata_id Not tainted 3.7.0-01930-gbff6343 #1167
> [   89.668040] Call Trace:
> [   89.668040]  [<ffffffff810997c4>] warn_slowpath_common+0x83/0x9c
> [   89.671922]  [<ffffffff810997f7>] warn_slowpath_null+0x1a/0x1c
> [   89.671922]  [<ffffffff816aea77>] disk_clear_events+0xcf/0x108
> [   89.671922]  [<ffffffff811bd8be>] check_disk_change+0x27/0x59
> [   89.671922]  [<ffffffff822e48e2>] cdrom_open+0x49/0x68b
> [   89.671922]  [<ffffffff82c12c07>] ? __mutex_unlock_slowpath+0x116/0x126
> [   89.671922]  [<ffffffff810e9868>] ? trace_hardirqs_on_caller+0x123/0x17f
> [   89.671922]  [<ffffffff82c12c0f>] ? __mutex_unlock_slowpath+0x11e/0x126
> [   89.671922]  [<ffffffff81ab0291>] idecd_open+0x88/0xb7
> [   89.671922]  [<ffffffff811be58f>] __blkdev_get+0x102/0x3ec
> [   89.671922]  [<ffffffff811bea08>] blkdev_get+0x18f/0x30f
> [   89.671922]  [<ffffffff810e92e4>] ? lock_release+0x17d/0x1cd
> [   89.671922]  [<ffffffff811beb88>] ? blkdev_get+0x30f/0x30f
> [   89.671922]  [<ffffffff82c14fe2>] ? _raw_spin_unlock+0x28/0x3b
> [   89.671922]  [<ffffffff811beb88>] ? blkdev_get+0x30f/0x30f
> [   89.671922]  [<ffffffff811bebfd>] blkdev_open+0x75/0x80
> [   89.671922]  [<ffffffff8118f510>] do_dentry_open+0x1ea/0x295
> [   89.671922]  [<ffffffff8118f5f0>] finish_open+0x35/0x41
> [   89.671922]  [<ffffffff8119c720>] do_last+0x878/0xa25
> [   89.671922]  [<ffffffff8119a308>] ? inode_permission+0x45/0x47
> [   89.671922]  [<ffffffff8119c993>] path_openat+0xc6/0x333
> [   89.671922]  [<ffffffff810e611a>] ? lock_release_holdtime.part.22+0x4e/0x55
> [   89.671922]  [<ffffffff8119cf37>] do_filp_open+0x38/0x86
> [   89.671922]  [<ffffffff811a6b4e>] ? spin_unlock+0x9/0xb
> [   89.671922]  [<ffffffff811a779c>] ? __alloc_fd+0xf3/0x104
> [   89.671922]  [<ffffffff81190170>] do_sys_open+0x6c/0xf9
> [   89.671922]  [<ffffffff8119021e>] sys_open+0x21/0x23
> [   89.671922]  [<ffffffff82c1c3d9>] system_call_fastpath+0x16/0x1b
> [   89.671922] ---[ end trace adf2f552c2f07280 ]---
> [   89.735951] ide-cd: hdc: DMA read error
> [   89.736678] hdc: DMA disabled

> git checkout ae664dba2724e59ddd66291b895f7370e28b9a7a
> 
> 2012-12-19-10:09:44 ae664dba2724e59ddd66291b895f7370e28b9a7a compiling
> /home/wfg/linux
> 
> 2012-12-19-10:17:26 detecting boot state 3.7.0-bisect-01829-gae664db #6 ..............................................1234..5.67...8.....9...................................................................................................................................................................................................OK .OK 10OK 1112OK .13OK .14...OK .OK 1516...OK .17.......................................................................................................................................................................................................OK .OK  SUCCESS
> bisect: good commit ae664dba2724e59ddd66291b895f7370e28b9a7a
> git bisect start bff63438ab6a89c589d8f359c25f4152ed758394 ae664dba2724e59ddd66291b895f7370e28b9a7a --
> Bisecting: 50 revisions left to test after this (roughly 6 steps)
> [e5c71fcd5dbcabede51e14bb4f82eb507f5d3eb6] perf tools: Add support for wildcard in tracepoint system name
> git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
> 
> 2012-12-19-10:27:37 e5c71fcd5dbcabede51e14bb4f82eb507f5d3eb6 compiling
> /home/wfg/linux
> 
> 2012-12-19-10:35:29 detecting boot state 3.7.0-rc8-bisect-00293-ge5c71fc #7 ..1234....567..8............................................................................................................................................................................................OK .9........OK .OK 10OK .11.OK .12.....OK 13OK 1415.........................................................................................................................................................................................OK 16.............OK 17OK  SUCCESS
> Bisecting: 25 revisions left to test after this (roughly 5 steps)
> [2df1885ac7de62ed7afebd153f8e2849e2dd9cff] ima: pass dentry instead of file
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
> 
> 2012-12-19-10:44:28 2df1885ac7de62ed7afebd153f8e2849e2dd9cff compiling
> /home/wfg/linux
> 
> 2012-12-19-10:52:05 detecting boot state 3.7.0-bisect-00025-g2df1885 #8 .....................................1................2..3....4567...8..............................................................................................................................................................................................OK 9..............OK .10.....OK .11OK .12.OK .13OK .OK 1415...OK 16.......................................................................................................................................................................OK .17..............OK  SUCCESS
> Bisecting: 11 revisions left to test after this (roughly 4 steps)
> [8a7dc383ec7f33b2b9886b0e4d4c0414316b331e] Merge remote-tracking branch 'perf/perf/group' into devel-bee-x86_64-2012-12-19-03-23
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
> 
> 2012-12-19-11:02:18 8a7dc383ec7f33b2b9886b0e4d4c0414316b331e compiling
> /home/wfg/linux
> 
> 2012-12-19-11:09:56 detecting boot state 3.7.0-bisect-01893-g8a7dc383 #9 ......................................................1..........2...3.4....5..6...78.9.............................................................10 TEST FAILURE
> Bisecting: 6 revisions left to test after this (roughly 3 steps)
> [c8f2c22cfb52fffba606193789c8c923a6a74644] perf report: Make another loop for linking group hists
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
> 
> 2012-12-19-11:13:08 c8f2c22cfb52fffba606193789c8c923a6a74644 compiling
> /home/wfg/linux
> 
> 2012-12-19-11:20:45 detecting boot state 3.7.0-rc8-bisect-00300-gc8f2c22 #10 .................1....................2.3.......4..5....6.78...9....................................................................................................................................................................OK .10................OK 1112...OK .13.......OK .14.OK .15...OK .16.....OK 17OK 18...OK 19..........................................................................................................................................................OK  SUCCESS
> Bisecting: 3 revisions left to test after this (roughly 2 steps)
> [64f96cbcfa52338693d5aabb9d4e86bc7cde9e11] Merge remote-tracking branch 'wq/for-3.9' into devel-bee-x86_64-2012-12-19-03-23
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
> 
> 2012-12-19-11:30:06 64f96cbcfa52338693d5aabb9d4e86bc7cde9e11 compiling
> /home/wfg/linux
> 
> 2012-12-19-11:37:40 detecting boot state 3.7.0-bisect-01832-g64f96cb #11 ..................................1.................23....4...............56...7......8...9........................... TEST FAILURE
> Bisecting: 0 revisions left to test after this (roughly 1 step)
> [a2c1c57be8d9fd5b716113c8991d3d702eeacf77] workqueue: consider work function when searching for busy work items
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
> 
> 2012-12-19-11:40:07 a2c1c57be8d9fd5b716113c8991d3d702eeacf77 compiling
> /home/wfg/linux
> 
> 2012-12-19-11:47:44 detecting boot state 3.7.0-bisect-01464-ga2c1c57 #12 1...2..3...................4...................5..6...7........................8 TEST FAILURE
> Bisecting: 0 revisions left to test after this (roughly 0 steps)
> [42f8570f437b65aaf3ef176a38ad7d7fc5847d8b] workqueue: use new hashtable implementation
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
> 
> 2012-12-19-11:49:23 42f8570f437b65aaf3ef176a38ad7d7fc5847d8b compiling
> /home/wfg/linux
> 
> 2012-12-19-11:52:55 detecting boot state 3.7.0-bisect-01463-g42f8570 #13 ........................1.............2.3..4........................5... TEST FAILURE
> 42f8570f437b65aaf3ef176a38ad7d7fc5847d8b is the first bad commit
> commit 42f8570f437b65aaf3ef176a38ad7d7fc5847d8b
> Author: Sasha Levin <sasha.levin@oracle.com>
> Date:   Mon Dec 17 10:01:23 2012 -0500
> 
>     workqueue: use new hashtable implementation
>     
>     Switch workqueues to use the new hashtable implementation. This reduces the
>     amount of generic unrelated code in the workqueues.
>     
>     This patch depends on d9b482c ("hashtable: introduce a small and naive
>     hashtable") which was merged in v3.6.
>     
>     Acked-by: Tejun Heo <tj@kernel.org>
>     Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>     Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> :040000 040000 5bf74d371c69b66881d3677135667ca09605fcf8 f0945c1a464c4f5dbc63b8b1b7b217f91b470722 M	kernel
> bisect run success
> 
> ========= linux-next =========
> 
> 2012-12-19-11:54:30 ba93608745f25af64ca481c24b793a46ad3d2845 compiling
> /home/wfg/linux
> 
> 2012-12-19-12:02:13 detecting boot state 3.7.0-bisect-next-20121219 #14 ..1........................2......3.4....56......................7......................................................................................................................OK .8....OK 9.....OK 10....................OK .11.......OK 12.OK 1314.OK 15OK 16......................OK 17......................................................................................................................OK  SUCCESS

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86_64 3.7.0 Kernel Configuration
> #
> CONFIG_64BIT=y
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_GENERIC_GPIO=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ZONE_DMA32=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_HAVE_INTEL_TXT=y
> CONFIG_X86_64_SMP=y
> CONFIG_X86_HT=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
> CONFIG_ARCH_CPU_PROBE_RELEASE=y
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_HAVE_IRQ_WORK=y
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_KERNEL_GZIP=y
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> CONFIG_FHANDLE=y
> CONFIG_AUDIT=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_AUDIT_WATCH=y
> CONFIG_AUDIT_TREE=y
> # CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
> CONFIG_HAVE_GENERIC_HARDIRQS=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_GENERIC_IRQ_CHIP=y
> CONFIG_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> CONFIG_TASK_XACCT=y
> CONFIG_TASK_IO_ACCOUNTING=y
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_RCU_USER_QS is not set
> CONFIG_RCU_FANOUT=64
> CONFIG_RCU_FANOUT_LEAF=16
> # CONFIG_RCU_FANOUT_EXACT is not set
> CONFIG_RCU_FAST_NO_HZ=y
> CONFIG_TREE_RCU_TRACE=y
> # CONFIG_RCU_NOCB_CPU is not set
> CONFIG_IKCONFIG=y
> # CONFIG_IKCONFIG_PROC is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> # CONFIG_NUMA_BALANCING is not set
> CONFIG_CGROUPS=y
> # CONFIG_CGROUP_DEBUG is not set
> CONFIG_CGROUP_FREEZER=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CPUSETS=y
> CONFIG_PROC_PID_CPUSET=y
> # CONFIG_CGROUP_CPUACCT is not set
> CONFIG_RESOURCE_COUNTERS=y
> # CONFIG_MEMCG is not set
> # CONFIG_CGROUP_HUGETLB is not set
> # CONFIG_CGROUP_PERF is not set
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_CFS_BANDWIDTH is not set
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_BLK_CGROUP=y
> # CONFIG_DEBUG_BLK_CGROUP is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> CONFIG_SCHED_AUTOGROUP=y
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> # CONFIG_EXPERT is not set
> CONFIG_HAVE_UID16=y
> CONFIG_UID16=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_COMPAT_BRK is not set
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> CONFIG_OPROFILE=y
> # CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> CONFIG_KPROBES=y
> # CONFIG_JUMP_LABEL is not set
> CONFIG_OPTPROBES=y
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_KRETPROBES=y
> CONFIG_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
> CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
> CONFIG_GENERIC_KERNEL_THREAD=y
> CONFIG_GENERIC_KERNEL_EXECVE=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP_FILTER=y
> CONFIG_HAVE_CONTEXT_TRACKING=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_MODULES_USE_ELF_RELA=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> CONFIG_MODULE_FORCE_LOAD=y
> CONFIG_MODULE_UNLOAD=y
> CONFIG_MODULE_FORCE_UNLOAD=y
> CONFIG_MODVERSIONS=y
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> # CONFIG_MODULE_SIG is not set
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> # CONFIG_BLK_DEV_THROTTLING is not set
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> CONFIG_ACORN_PARTITION=y
> # CONFIG_ACORN_PARTITION_CUMANA is not set
> # CONFIG_ACORN_PARTITION_EESOX is not set
> CONFIG_ACORN_PARTITION_ICS=y
> # CONFIG_ACORN_PARTITION_ADFS is not set
> # CONFIG_ACORN_PARTITION_POWERTEC is not set
> CONFIG_ACORN_PARTITION_RISCIX=y
> CONFIG_OSF_PARTITION=y
> CONFIG_AMIGA_PARTITION=y
> CONFIG_ATARI_PARTITION=y
> CONFIG_MAC_PARTITION=y
> CONFIG_MSDOS_PARTITION=y
> CONFIG_BSD_DISKLABEL=y
> CONFIG_MINIX_SUBPARTITION=y
> CONFIG_SOLARIS_X86_PARTITION=y
> CONFIG_UNIXWARE_DISKLABEL=y
> CONFIG_LDM_PARTITION=y
> # CONFIG_LDM_DEBUG is not set
> CONFIG_SGI_PARTITION=y
> CONFIG_ULTRIX_PARTITION=y
> CONFIG_SUN_PARTITION=y
> CONFIG_KARMA_PARTITION=y
> CONFIG_EFI_PARTITION=y
> # CONFIG_SYSV68_PARTITION is not set
> CONFIG_BLOCK_COMPAT=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_CFQ_GROUP_IOSCHED=y
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_PREEMPT_NOTIFIERS=y
> CONFIG_PADATA=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> CONFIG_SMP=y
> CONFIG_X86_X2APIC=y
> CONFIG_X86_MPPARSE=y
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_PARAVIRT_GUEST=y
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_XEN=y
> CONFIG_XEN_DOM0=y
> CONFIG_XEN_PRIVILEGED_GUEST=y
> CONFIG_XEN_PVHVM=y
> CONFIG_XEN_MAX_DOMAIN_MEMORY=500
> CONFIG_XEN_SAVE_RESTORE=y
> # CONFIG_XEN_DEBUG_FS is not set
> CONFIG_KVM_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_SPINLOCKS is not set
> CONFIG_PARAVIRT_CLOCK=y
> # CONFIG_PARAVIRT_DEBUG is not set
> CONFIG_NO_BOOTMEM=y
> CONFIG_MEMTEST=y
> # CONFIG_MK8 is not set
> # CONFIG_MPSC is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_GENERIC_CPU=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> CONFIG_GART_IOMMU=y
> CONFIG_CALGARY_IOMMU=y
> CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> # CONFIG_MAXSMP is not set
> CONFIG_NR_CPUS=512
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> CONFIG_X86_MCE_AMD=y
> CONFIG_X86_MCE_THRESHOLD=y
> CONFIG_X86_MCE_INJECT=y
> CONFIG_X86_THERMAL_VECTOR=y
> CONFIG_I8K=y
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_INTEL=y
> CONFIG_MICROCODE_AMD=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_DIRECT_GBPAGES=y
> CONFIG_NUMA=y
> CONFIG_AMD_NUMA=y
> CONFIG_X86_64_ACPI_NUMA=y
> CONFIG_NODES_SPAN_OTHER_NODES=y
> CONFIG_NUMA_EMU=y
> CONFIG_NODES_SHIFT=6
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ARCH_MEMORY_PROBE=y
> CONFIG_ARCH_PROC_KCORE_TEXT=y
> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_NEED_MULTIPLE_NODES=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> CONFIG_MEMORY_HOTPLUG=y
> CONFIG_MEMORY_HOTPLUG_SPARSE=y
> CONFIG_MEMORY_HOTREMOVE=y
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=999999
> CONFIG_BALLOON_COMPACTION=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MMU_NOTIFIER=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_MEMORY_FAILURE=y
> CONFIG_HWPOISON_INJECT=y
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> CONFIG_CROSS_MEMORY_ATTACH=y
> # CONFIG_CLEANCACHE is not set
> # CONFIG_FRONTSWAP is not set
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> CONFIG_ARCH_RANDOM=y
> CONFIG_X86_SMAP=y
> CONFIG_EFI=y
> # CONFIG_EFI_STUB is not set
> CONFIG_SECCOMP=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> # CONFIG_CRASH_DUMP is not set
> # CONFIG_KEXEC_JUMP is not set
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_PHYSICAL_ALIGN=0x1000000
> CONFIG_HOTPLUG_CPU=y
> # CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
> # CONFIG_DEBUG_HOTPLUG_CPU0 is not set
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
> CONFIG_USE_PERCPU_NUMA_NODE_ID=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_ARCH_HIBERNATION_HEADER=y
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_HIBERNATE_CALLBACKS=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> # CONFIG_PM_AUTOSLEEP is not set
> # CONFIG_PM_WAKELOCKS is not set
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> CONFIG_PM_ADVANCED_DEBUG=y
> CONFIG_PM_TEST_SUSPEND=y
> CONFIG_PM_SLEEP_DEBUG=y
> # CONFIG_PM_TRACE_RTC is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> # CONFIG_ACPI_PROC_EVENT is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=y
> CONFIG_ACPI_FAN=y
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_I2C=y
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_IPMI=y
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
> CONFIG_ACPI_THERMAL=y
> CONFIG_ACPI_NUMA=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_PCI_SLOT=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> CONFIG_ACPI_HOTPLUG_MEMORY=y
> CONFIG_ACPI_SBS=y
> CONFIG_ACPI_HED=y
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_BGRT is not set
> CONFIG_ACPI_APEI=y
> CONFIG_ACPI_APEI_GHES=y
> CONFIG_ACPI_APEI_PCIEAER=y
> CONFIG_ACPI_APEI_MEMORY_FAILURE=y
> # CONFIG_ACPI_APEI_EINJ is not set
> # CONFIG_ACPI_APEI_ERST_DEBUG is not set
> CONFIG_SFI=y
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_STAT=y
> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> 
> #
> # x86 CPU frequency scaling drivers
> #
> CONFIG_X86_PCC_CPUFREQ=y
> CONFIG_X86_ACPI_CPUFREQ=y
> CONFIG_X86_ACPI_CPUFREQ_CPB=y
> CONFIG_X86_POWERNOW_K8=y
> CONFIG_X86_SPEEDSTEP_CENTRINO=y
> CONFIG_X86_P4_CLOCKMOD=y
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> CONFIG_INTEL_IDLE=y
> 
> #
> # Memory power savings
> #
> CONFIG_I7300_IDLE_IOAT_CHANNEL=y
> CONFIG_I7300_IDLE=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_XEN=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_HOTPLUG_PCI_PCIE=y
> CONFIG_PCIEAER=y
> # CONFIG_PCIE_ECRC is not set
> CONFIG_PCIEAER_INJECT=y
> CONFIG_PCIEASPM=y
> CONFIG_PCIEASPM_DEBUG=y
> CONFIG_PCIEASPM_DEFAULT=y
> # CONFIG_PCIEASPM_POWERSAVE is not set
> # CONFIG_PCIEASPM_PERFORMANCE is not set
> CONFIG_PCIE_PME=y
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> CONFIG_PCI_STUB=y
> CONFIG_XEN_PCIDEV_FRONTEND=y
> CONFIG_HT_IRQ=y
> # CONFIG_PCI_ATS is not set
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> CONFIG_PCI_IOAPIC=y
> CONFIG_PCI_LABEL=y
> CONFIG_ISA_DMA_API=y
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> CONFIG_PCMCIA=y
> CONFIG_PCMCIA_LOAD_CIS=y
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> CONFIG_YENTA=y
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> CONFIG_YENTA_TI=y
> CONFIG_YENTA_ENE_TUNE=y
> CONFIG_YENTA_TOSHIBA=y
> CONFIG_PD6729=y
> CONFIG_I82092=y
> CONFIG_PCCARD_NONSTATIC=y
> CONFIG_HOTPLUG_PCI=y
> CONFIG_HOTPLUG_PCI_ACPI=y
> CONFIG_HOTPLUG_PCI_ACPI_IBM=y
> CONFIG_HOTPLUG_PCI_CPCI=y
> CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
> CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
> CONFIG_HOTPLUG_PCI_SHPC=y
> # CONFIG_RAPIDIO is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_COMPAT_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> # CONFIG_HAVE_AOUT is not set
> CONFIG_BINFMT_MISC=y
> CONFIG_COREDUMP=y
> CONFIG_IA32_EMULATION=y
> CONFIG_IA32_AOUT=y
> # CONFIG_X86_X32 is not set
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_SYSVIPC_COMPAT=y
> CONFIG_KEYS_COMPAT=y
> CONFIG_HAVE_TEXT_POKE_SMP=y
> CONFIG_X86_DEV_DMA_OPS=y
> CONFIG_NET=y
> CONFIG_COMPAT_NETLINK_MESSAGES=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> # CONFIG_PACKET_DIAG is not set
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_XFRM_USER=y
> CONFIG_XFRM_SUB_POLICY=y
> CONFIG_XFRM_MIGRATE=y
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=y
> CONFIG_NET_KEY=y
> CONFIG_NET_KEY_MIGRATE=y
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_IP_FIB_TRIE_STATS=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> CONFIG_IP_ROUTE_CLASSID=y
> CONFIG_IP_PNP=y
> CONFIG_IP_PNP_DHCP=y
> CONFIG_IP_PNP_BOOTP=y
> CONFIG_IP_PNP_RARP=y
> CONFIG_NET_IPIP=y
> CONFIG_NET_IPGRE_DEMUX=y
> CONFIG_NET_IPGRE=y
> CONFIG_NET_IPGRE_BROADCAST=y
> CONFIG_IP_MROUTE=y
> CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> # CONFIG_NET_IPVTI is not set
> CONFIG_INET_AH=y
> CONFIG_INET_ESP=y
> CONFIG_INET_IPCOMP=y
> CONFIG_INET_XFRM_TUNNEL=y
> CONFIG_INET_TUNNEL=y
> CONFIG_INET_XFRM_MODE_TRANSPORT=y
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> CONFIG_INET_XFRM_MODE_BEET=y
> CONFIG_INET_LRO=y
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> # CONFIG_INET_UDP_DIAG is not set
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=y
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_TCP_CONG_WESTWOOD=y
> CONFIG_TCP_CONG_HTCP=y
> CONFIG_TCP_CONG_HSTCP=y
> CONFIG_TCP_CONG_HYBLA=y
> CONFIG_TCP_CONG_VEGAS=y
> CONFIG_TCP_CONG_SCALABLE=y
> CONFIG_TCP_CONG_LP=y
> CONFIG_TCP_CONG_VENO=y
> CONFIG_TCP_CONG_YEAH=y
> CONFIG_TCP_CONG_ILLINOIS=y
> # CONFIG_DEFAULT_BIC is not set
> CONFIG_DEFAULT_CUBIC=y
> # CONFIG_DEFAULT_HTCP is not set
> # CONFIG_DEFAULT_HYBLA is not set
> # CONFIG_DEFAULT_VEGAS is not set
> # CONFIG_DEFAULT_VENO is not set
> # CONFIG_DEFAULT_WESTWOOD is not set
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> CONFIG_IPV6=y
> CONFIG_IPV6_PRIVACY=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> CONFIG_IPV6_OPTIMISTIC_DAD=y
> CONFIG_INET6_AH=y
> CONFIG_INET6_ESP=y
> CONFIG_INET6_IPCOMP=y
> CONFIG_IPV6_MIP6=y
> CONFIG_INET6_XFRM_TUNNEL=y
> CONFIG_INET6_TUNNEL=y
> CONFIG_INET6_XFRM_MODE_TRANSPORT=y
> CONFIG_INET6_XFRM_MODE_TUNNEL=y
> CONFIG_INET6_XFRM_MODE_BEET=y
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
> CONFIG_IPV6_SIT=y
> CONFIG_IPV6_SIT_6RD=y
> CONFIG_IPV6_NDISC_NODETYPE=y
> CONFIG_IPV6_TUNNEL=y
> # CONFIG_IPV6_GRE is not set
> CONFIG_IPV6_MULTIPLE_TABLES=y
> CONFIG_IPV6_SUBTREES=y
> CONFIG_IPV6_MROUTE=y
> CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
> CONFIG_IPV6_PIMSM_V2=y
> # CONFIG_NETLABEL is not set
> CONFIG_NETWORK_SECMARK=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
> CONFIG_BRIDGE_NETFILTER=y
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=y
> # CONFIG_NETFILTER_NETLINK_ACCT is not set
> CONFIG_NETFILTER_NETLINK_QUEUE=y
> CONFIG_NETFILTER_NETLINK_LOG=y
> CONFIG_NF_CONNTRACK=y
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CONNTRACK_SECMARK=y
> CONFIG_NF_CONNTRACK_ZONES=y
> CONFIG_NF_CONNTRACK_PROCFS=y
> CONFIG_NF_CONNTRACK_EVENTS=y
> # CONFIG_NF_CONNTRACK_TIMEOUT is not set
> CONFIG_NF_CONNTRACK_TIMESTAMP=y
> CONFIG_NF_CT_PROTO_DCCP=y
> CONFIG_NF_CT_PROTO_GRE=y
> CONFIG_NF_CT_PROTO_SCTP=y
> CONFIG_NF_CT_PROTO_UDPLITE=y
> CONFIG_NF_CONNTRACK_AMANDA=y
> CONFIG_NF_CONNTRACK_FTP=y
> CONFIG_NF_CONNTRACK_H323=y
> CONFIG_NF_CONNTRACK_IRC=y
> CONFIG_NF_CONNTRACK_BROADCAST=y
> CONFIG_NF_CONNTRACK_NETBIOS_NS=y
> CONFIG_NF_CONNTRACK_SNMP=y
> CONFIG_NF_CONNTRACK_PPTP=y
> CONFIG_NF_CONNTRACK_SANE=y
> CONFIG_NF_CONNTRACK_SIP=y
> CONFIG_NF_CONNTRACK_TFTP=y
> CONFIG_NF_CT_NETLINK=y
> # CONFIG_NF_CT_NETLINK_TIMEOUT is not set
> # CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
> CONFIG_NETFILTER_TPROXY=y
> CONFIG_NETFILTER_XTABLES=y
> 
> #
> # Xtables combined modules
> #
> CONFIG_NETFILTER_XT_MARK=y
> CONFIG_NETFILTER_XT_CONNMARK=y
> CONFIG_NETFILTER_XT_SET=y
> 
> #
> # Xtables targets
> #
> CONFIG_NETFILTER_XT_TARGET_AUDIT=y
> CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
> CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
> CONFIG_NETFILTER_XT_TARGET_CT=y
> CONFIG_NETFILTER_XT_TARGET_DSCP=y
> CONFIG_NETFILTER_XT_TARGET_HL=y
> # CONFIG_NETFILTER_XT_TARGET_HMARK is not set
> CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
> CONFIG_NETFILTER_XT_TARGET_LED=y
> # CONFIG_NETFILTER_XT_TARGET_LOG is not set
> CONFIG_NETFILTER_XT_TARGET_MARK=y
> CONFIG_NETFILTER_XT_TARGET_NFLOG=y
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
> CONFIG_NETFILTER_XT_TARGET_RATEEST=y
> CONFIG_NETFILTER_XT_TARGET_TEE=y
> CONFIG_NETFILTER_XT_TARGET_TPROXY=y
> CONFIG_NETFILTER_XT_TARGET_TRACE=y
> CONFIG_NETFILTER_XT_TARGET_SECMARK=y
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
> CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y
> 
> #
> # Xtables matches
> #
> CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
> CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
> CONFIG_NETFILTER_XT_MATCH_COMMENT=y
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
> CONFIG_NETFILTER_XT_MATCH_CPU=y
> CONFIG_NETFILTER_XT_MATCH_DCCP=y
> CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
> CONFIG_NETFILTER_XT_MATCH_DSCP=y
> CONFIG_NETFILTER_XT_MATCH_ECN=y
> CONFIG_NETFILTER_XT_MATCH_ESP=y
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
> CONFIG_NETFILTER_XT_MATCH_HELPER=y
> CONFIG_NETFILTER_XT_MATCH_HL=y
> CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
> CONFIG_NETFILTER_XT_MATCH_IPVS=y
> CONFIG_NETFILTER_XT_MATCH_LENGTH=y
> CONFIG_NETFILTER_XT_MATCH_LIMIT=y
> CONFIG_NETFILTER_XT_MATCH_MAC=y
> CONFIG_NETFILTER_XT_MATCH_MARK=y
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
> # CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
> CONFIG_NETFILTER_XT_MATCH_OSF=y
> CONFIG_NETFILTER_XT_MATCH_OWNER=y
> CONFIG_NETFILTER_XT_MATCH_POLICY=y
> CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
> CONFIG_NETFILTER_XT_MATCH_QUOTA=y
> CONFIG_NETFILTER_XT_MATCH_RATEEST=y
> CONFIG_NETFILTER_XT_MATCH_REALM=y
> CONFIG_NETFILTER_XT_MATCH_RECENT=y
> CONFIG_NETFILTER_XT_MATCH_SCTP=y
> CONFIG_NETFILTER_XT_MATCH_SOCKET=y
> CONFIG_NETFILTER_XT_MATCH_STATE=y
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
> CONFIG_NETFILTER_XT_MATCH_STRING=y
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
> CONFIG_NETFILTER_XT_MATCH_TIME=y
> CONFIG_NETFILTER_XT_MATCH_U32=y
> CONFIG_IP_SET=y
> CONFIG_IP_SET_MAX=256
> CONFIG_IP_SET_BITMAP_IP=y
> CONFIG_IP_SET_BITMAP_IPMAC=y
> CONFIG_IP_SET_BITMAP_PORT=y
> CONFIG_IP_SET_HASH_IP=y
> CONFIG_IP_SET_HASH_IPPORT=y
> CONFIG_IP_SET_HASH_IPPORTIP=y
> CONFIG_IP_SET_HASH_IPPORTNET=y
> CONFIG_IP_SET_HASH_NET=y
> CONFIG_IP_SET_HASH_NETPORT=y
> CONFIG_IP_SET_HASH_NETIFACE=y
> CONFIG_IP_SET_LIST_SET=y
> CONFIG_IP_VS=y
> CONFIG_IP_VS_IPV6=y
> # CONFIG_IP_VS_DEBUG is not set
> CONFIG_IP_VS_TAB_BITS=12
> 
> #
> # IPVS transport protocol load balancing support
> #
> CONFIG_IP_VS_PROTO_TCP=y
> CONFIG_IP_VS_PROTO_UDP=y
> CONFIG_IP_VS_PROTO_AH_ESP=y
> CONFIG_IP_VS_PROTO_ESP=y
> CONFIG_IP_VS_PROTO_AH=y
> CONFIG_IP_VS_PROTO_SCTP=y
> 
> #
> # IPVS scheduler
> #
> CONFIG_IP_VS_RR=y
> CONFIG_IP_VS_WRR=y
> CONFIG_IP_VS_LC=y
> CONFIG_IP_VS_WLC=y
> CONFIG_IP_VS_LBLC=y
> CONFIG_IP_VS_LBLCR=y
> CONFIG_IP_VS_DH=y
> CONFIG_IP_VS_SH=y
> CONFIG_IP_VS_SED=y
> CONFIG_IP_VS_NQ=y
> 
> #
> # IPVS SH scheduler
> #
> CONFIG_IP_VS_SH_TAB_BITS=8
> 
> #
> # IPVS application helper
> #
> CONFIG_IP_VS_NFCT=y
> CONFIG_IP_VS_PE_SIP=y
> 
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV4=y
> CONFIG_NF_CONNTRACK_IPV4=y
> CONFIG_NF_CONNTRACK_PROC_COMPAT=y
> CONFIG_IP_NF_QUEUE=y
> CONFIG_IP_NF_IPTABLES=y
> CONFIG_IP_NF_MATCH_AH=y
> CONFIG_IP_NF_MATCH_ECN=y
> # CONFIG_IP_NF_MATCH_RPFILTER is not set
> CONFIG_IP_NF_MATCH_TTL=y
> CONFIG_IP_NF_FILTER=y
> CONFIG_IP_NF_TARGET_REJECT=y
> CONFIG_IP_NF_TARGET_ULOG=y
> # CONFIG_NF_NAT_IPV4 is not set
> CONFIG_IP_NF_MANGLE=y
> CONFIG_IP_NF_TARGET_CLUSTERIP=y
> CONFIG_IP_NF_TARGET_ECN=y
> CONFIG_IP_NF_TARGET_TTL=y
> CONFIG_IP_NF_RAW=y
> CONFIG_IP_NF_SECURITY=y
> CONFIG_IP_NF_ARPTABLES=y
> CONFIG_IP_NF_ARPFILTER=y
> CONFIG_IP_NF_ARP_MANGLE=y
> 
> #
> # IPv6: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV6=y
> CONFIG_NF_CONNTRACK_IPV6=y
> CONFIG_IP6_NF_IPTABLES=y
> CONFIG_IP6_NF_MATCH_AH=y
> CONFIG_IP6_NF_MATCH_EUI64=y
> CONFIG_IP6_NF_MATCH_FRAG=y
> CONFIG_IP6_NF_MATCH_OPTS=y
> CONFIG_IP6_NF_MATCH_HL=y
> CONFIG_IP6_NF_MATCH_IPV6HEADER=y
> CONFIG_IP6_NF_MATCH_MH=y
> # CONFIG_IP6_NF_MATCH_RPFILTER is not set
> CONFIG_IP6_NF_MATCH_RT=y
> CONFIG_IP6_NF_TARGET_HL=y
> CONFIG_IP6_NF_FILTER=y
> CONFIG_IP6_NF_TARGET_REJECT=y
> CONFIG_IP6_NF_MANGLE=y
> CONFIG_IP6_NF_RAW=y
> CONFIG_IP6_NF_SECURITY=y
> # CONFIG_NF_NAT_IPV6 is not set
> 
> #
> # DECnet: Netfilter Configuration
> #
> CONFIG_DECNET_NF_GRABULATOR=y
> CONFIG_BRIDGE_NF_EBTABLES=y
> CONFIG_BRIDGE_EBT_BROUTE=y
> CONFIG_BRIDGE_EBT_T_FILTER=y
> CONFIG_BRIDGE_EBT_T_NAT=y
> CONFIG_BRIDGE_EBT_802_3=y
> CONFIG_BRIDGE_EBT_AMONG=y
> CONFIG_BRIDGE_EBT_ARP=y
> CONFIG_BRIDGE_EBT_IP=y
> CONFIG_BRIDGE_EBT_IP6=y
> CONFIG_BRIDGE_EBT_LIMIT=y
> CONFIG_BRIDGE_EBT_MARK=y
> CONFIG_BRIDGE_EBT_PKTTYPE=y
> CONFIG_BRIDGE_EBT_STP=y
> CONFIG_BRIDGE_EBT_VLAN=y
> CONFIG_BRIDGE_EBT_ARPREPLY=y
> CONFIG_BRIDGE_EBT_DNAT=y
> CONFIG_BRIDGE_EBT_MARK_T=y
> CONFIG_BRIDGE_EBT_REDIRECT=y
> CONFIG_BRIDGE_EBT_SNAT=y
> CONFIG_BRIDGE_EBT_LOG=y
> CONFIG_BRIDGE_EBT_ULOG=y
> CONFIG_BRIDGE_EBT_NFLOG=y
> CONFIG_IP_DCCP=y
> CONFIG_INET_DCCP_DIAG=y
> 
> #
> # DCCP CCIDs Configuration (EXPERIMENTAL)
> #
> # CONFIG_IP_DCCP_CCID2_DEBUG is not set
> CONFIG_IP_DCCP_CCID3=y
> # CONFIG_IP_DCCP_CCID3_DEBUG is not set
> CONFIG_IP_DCCP_TFRC_LIB=y
> 
> #
> # DCCP Kernel Hacking
> #
> # CONFIG_IP_DCCP_DEBUG is not set
> CONFIG_NET_DCCPPROBE=y
> CONFIG_IP_SCTP=y
> CONFIG_NET_SCTPPROBE=y
> # CONFIG_SCTP_DBG_MSG is not set
> # CONFIG_SCTP_DBG_OBJCNT is not set
> CONFIG_SCTP_COOKIE_HMAC_MD5=y
> CONFIG_SCTP_COOKIE_HMAC_SHA1=y
> CONFIG_RDS=y
> CONFIG_RDS_RDMA=y
> CONFIG_RDS_TCP=y
> # CONFIG_RDS_DEBUG is not set
> CONFIG_TIPC=y
> CONFIG_TIPC_PORTS=8191
> CONFIG_ATM=y
> CONFIG_ATM_CLIP=y
> # CONFIG_ATM_CLIP_NO_ICMP is not set
> CONFIG_ATM_LANE=y
> CONFIG_ATM_MPOA=y
> CONFIG_ATM_BR2684=y
> # CONFIG_ATM_BR2684_IPFILTER is not set
> CONFIG_L2TP=y
> CONFIG_L2TP_DEBUGFS=y
> CONFIG_L2TP_V3=y
> CONFIG_L2TP_IP=y
> CONFIG_L2TP_ETH=y
> CONFIG_STP=y
> CONFIG_GARP=y
> CONFIG_BRIDGE=y
> CONFIG_BRIDGE_IGMP_SNOOPING=y
> CONFIG_HAVE_NET_DSA=y
> CONFIG_VLAN_8021Q=y
> CONFIG_VLAN_8021Q_GVRP=y
> CONFIG_DECNET=y
> # CONFIG_DECNET_ROUTER is not set
> CONFIG_LLC=y
> CONFIG_LLC2=y
> CONFIG_IPX=y
> # CONFIG_IPX_INTERN is not set
> CONFIG_ATALK=y
> CONFIG_DEV_APPLETALK=y
> CONFIG_IPDDP=y
> CONFIG_IPDDP_ENCAP=y
> CONFIG_IPDDP_DECAP=y
> # CONFIG_X25 is not set
> CONFIG_LAPB=y
> CONFIG_WAN_ROUTER=y
> CONFIG_PHONET=y
> CONFIG_IEEE802154=y
> CONFIG_IEEE802154_6LOWPAN=y
> # CONFIG_MAC802154 is not set
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=y
> CONFIG_NET_SCH_HTB=y
> CONFIG_NET_SCH_HFSC=y
> CONFIG_NET_SCH_ATM=y
> CONFIG_NET_SCH_PRIO=y
> CONFIG_NET_SCH_MULTIQ=y
> CONFIG_NET_SCH_RED=y
> CONFIG_NET_SCH_SFB=y
> CONFIG_NET_SCH_SFQ=y
> CONFIG_NET_SCH_TEQL=y
> CONFIG_NET_SCH_TBF=y
> CONFIG_NET_SCH_GRED=y
> CONFIG_NET_SCH_DSMARK=y
> CONFIG_NET_SCH_NETEM=y
> CONFIG_NET_SCH_DRR=y
> CONFIG_NET_SCH_MQPRIO=y
> CONFIG_NET_SCH_CHOKE=y
> CONFIG_NET_SCH_QFQ=y
> # CONFIG_NET_SCH_CODEL is not set
> # CONFIG_NET_SCH_FQ_CODEL is not set
> CONFIG_NET_SCH_INGRESS=y
> # CONFIG_NET_SCH_PLUG is not set
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=y
> CONFIG_NET_CLS_TCINDEX=y
> CONFIG_NET_CLS_ROUTE4=y
> CONFIG_NET_CLS_FW=y
> CONFIG_NET_CLS_U32=y
> CONFIG_CLS_U32_PERF=y
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=y
> CONFIG_NET_CLS_RSVP6=y
> CONFIG_NET_CLS_FLOW=y
> CONFIG_NET_CLS_CGROUP=y
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=y
> CONFIG_NET_EMATCH_NBYTE=y
> CONFIG_NET_EMATCH_U32=y
> CONFIG_NET_EMATCH_META=y
> CONFIG_NET_EMATCH_TEXT=y
> # CONFIG_NET_EMATCH_CANID is not set
> # CONFIG_NET_EMATCH_IPSET is not set
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=y
> CONFIG_NET_ACT_GACT=y
> CONFIG_GACT_PROB=y
> CONFIG_NET_ACT_MIRRED=y
> CONFIG_NET_ACT_IPT=y
> CONFIG_NET_ACT_NAT=y
> CONFIG_NET_ACT_PEDIT=y
> CONFIG_NET_ACT_SIMP=y
> CONFIG_NET_ACT_SKBEDIT=y
> CONFIG_NET_ACT_CSUM=y
> CONFIG_NET_CLS_IND=y
> CONFIG_NET_SCH_FIFO=y
> CONFIG_DCB=y
> CONFIG_DNS_RESOLVER=y
> CONFIG_BATMAN_ADV=y
> CONFIG_BATMAN_ADV_BLA=y
> # CONFIG_BATMAN_ADV_DAT is not set
> # CONFIG_BATMAN_ADV_DEBUG is not set
> # CONFIG_OPENVSWITCH is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> # CONFIG_NETPRIO_CGROUP is not set
> CONFIG_BQL=y
> CONFIG_BPF_JIT=y
> 
> #
> # Network testing
> #
> CONFIG_NET_PKTGEN=y
> # CONFIG_NET_TCPPROBE is not set
> CONFIG_NET_DROP_MONITOR=y
> CONFIG_HAMRADIO=y
> 
> #
> # Packet Radio protocols
> #
> CONFIG_AX25=y
> # CONFIG_AX25_DAMA_SLAVE is not set
> CONFIG_NETROM=y
> CONFIG_ROSE=y
> 
> #
> # AX.25 network device drivers
> #
> CONFIG_MKISS=y
> CONFIG_6PACK=y
> CONFIG_BPQETHER=y
> CONFIG_BAYCOM_SER_FDX=y
> CONFIG_BAYCOM_SER_HDX=y
> CONFIG_BAYCOM_PAR=y
> CONFIG_YAM=y
> CONFIG_CAN=y
> CONFIG_CAN_RAW=y
> CONFIG_CAN_BCM=y
> CONFIG_CAN_GW=y
> 
> #
> # CAN Device Drivers
> #
> CONFIG_CAN_VCAN=y
> CONFIG_CAN_SLCAN=y
> CONFIG_CAN_DEV=y
> CONFIG_CAN_CALC_BITTIMING=y
> CONFIG_CAN_MCP251X=y
> CONFIG_PCH_CAN=y
> CONFIG_CAN_SJA1000=y
> # CONFIG_CAN_SJA1000_ISA is not set
> # CONFIG_CAN_SJA1000_PLATFORM is not set
> CONFIG_CAN_EMS_PCMCIA=y
> CONFIG_CAN_EMS_PCI=y
> # CONFIG_CAN_PEAK_PCMCIA is not set
> CONFIG_CAN_PEAK_PCI=y
> CONFIG_CAN_PEAK_PCIEC=y
> CONFIG_CAN_KVASER_PCI=y
> CONFIG_CAN_PLX_PCI=y
> # CONFIG_CAN_C_CAN is not set
> # CONFIG_CAN_CC770 is not set
> 
> #
> # CAN USB interfaces
> #
> CONFIG_CAN_EMS_USB=y
> CONFIG_CAN_ESD_USB2=y
> # CONFIG_CAN_KVASER_USB is not set
> # CONFIG_CAN_PEAK_USB is not set
> CONFIG_CAN_SOFTING=y
> CONFIG_CAN_SOFTING_CS=y
> # CONFIG_CAN_DEBUG_DEVICES is not set
> CONFIG_IRDA=y
> 
> #
> # IrDA protocols
> #
> CONFIG_IRLAN=y
> CONFIG_IRNET=y
> CONFIG_IRCOMM=y
> # CONFIG_IRDA_ULTRA is not set
> 
> #
> # IrDA options
> #
> CONFIG_IRDA_CACHE_LAST_LSAP=y
> CONFIG_IRDA_FAST_RR=y
> # CONFIG_IRDA_DEBUG is not set
> 
> #
> # Infrared-port device drivers
> #
> 
> #
> # SIR device drivers
> #
> CONFIG_IRTTY_SIR=y
> 
> #
> # Dongle support
> #
> CONFIG_DONGLE=y
> CONFIG_ESI_DONGLE=y
> CONFIG_ACTISYS_DONGLE=y
> CONFIG_TEKRAM_DONGLE=y
> CONFIG_TOIM3232_DONGLE=y
> CONFIG_LITELINK_DONGLE=y
> CONFIG_MA600_DONGLE=y
> CONFIG_GIRBIL_DONGLE=y
> CONFIG_MCP2120_DONGLE=y
> CONFIG_OLD_BELKIN_DONGLE=y
> CONFIG_ACT200L_DONGLE=y
> CONFIG_KINGSUN_DONGLE=y
> CONFIG_KSDAZZLE_DONGLE=y
> CONFIG_KS959_DONGLE=y
> 
> #
> # FIR device drivers
> #
> CONFIG_USB_IRDA=y
> CONFIG_SIGMATEL_FIR=y
> CONFIG_NSC_FIR=y
> CONFIG_WINBOND_FIR=y
> CONFIG_SMC_IRCC_FIR=y
> CONFIG_ALI_FIR=y
> CONFIG_VLSI_FIR=y
> CONFIG_VIA_FIR=y
> CONFIG_MCS_FIR=y
> CONFIG_BT=y
> CONFIG_BT_RFCOMM=y
> CONFIG_BT_RFCOMM_TTY=y
> CONFIG_BT_BNEP=y
> CONFIG_BT_BNEP_MC_FILTER=y
> CONFIG_BT_BNEP_PROTO_FILTER=y
> CONFIG_BT_CMTP=y
> CONFIG_BT_HIDP=y
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIBTUSB=y
> CONFIG_BT_HCIBTSDIO=y
> CONFIG_BT_HCIUART=y
> CONFIG_BT_HCIUART_H4=y
> CONFIG_BT_HCIUART_BCSP=y
> CONFIG_BT_HCIUART_ATH3K=y
> CONFIG_BT_HCIUART_LL=y
> # CONFIG_BT_HCIUART_3WIRE is not set
> CONFIG_BT_HCIBCM203X=y
> CONFIG_BT_HCIBPA10X=y
> CONFIG_BT_HCIBFUSB=y
> CONFIG_BT_HCIDTL1=y
> CONFIG_BT_HCIBT3C=y
> CONFIG_BT_HCIBLUECARD=y
> CONFIG_BT_HCIBTUART=y
> CONFIG_BT_HCIVHCI=y
> CONFIG_BT_MRVL=y
> CONFIG_BT_MRVL_SDIO=y
> CONFIG_BT_ATH3K=y
> CONFIG_AF_RXRPC=y
> # CONFIG_AF_RXRPC_DEBUG is not set
> CONFIG_RXKAD=y
> CONFIG_FIB_RULES=y
> CONFIG_WIRELESS=y
> CONFIG_WIRELESS_EXT=y
> CONFIG_WEXT_CORE=y
> CONFIG_WEXT_PROC=y
> CONFIG_WEXT_SPY=y
> CONFIG_WEXT_PRIV=y
> CONFIG_CFG80211=y
> # CONFIG_NL80211_TESTMODE is not set
> # CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
> # CONFIG_CFG80211_REG_DEBUG is not set
> CONFIG_CFG80211_DEFAULT_PS=y
> # CONFIG_CFG80211_DEBUGFS is not set
> # CONFIG_CFG80211_INTERNAL_REGDB is not set
> CONFIG_CFG80211_WEXT=y
> CONFIG_LIB80211=y
> CONFIG_LIB80211_CRYPT_WEP=y
> CONFIG_LIB80211_CRYPT_CCMP=y
> CONFIG_LIB80211_CRYPT_TKIP=y
> # CONFIG_LIB80211_DEBUG is not set
> CONFIG_MAC80211=y
> CONFIG_MAC80211_HAS_RC=y
> CONFIG_MAC80211_RC_MINSTREL=y
> CONFIG_MAC80211_RC_MINSTREL_HT=y
> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
> CONFIG_MAC80211_MESH=y
> CONFIG_MAC80211_LEDS=y
> # CONFIG_MAC80211_DEBUGFS is not set
> # CONFIG_MAC80211_MESSAGE_TRACING is not set
> # CONFIG_MAC80211_DEBUG_MENU is not set
> CONFIG_WIMAX=y
> CONFIG_WIMAX_DEBUG_LEVEL=8
> CONFIG_RFKILL=y
> CONFIG_RFKILL_LEDS=y
> CONFIG_RFKILL_INPUT=y
> # CONFIG_RFKILL_REGULATOR is not set
> CONFIG_NET_9P=y
> CONFIG_NET_9P_VIRTIO=y
> CONFIG_NET_9P_RDMA=y
> # CONFIG_NET_9P_DEBUG is not set
> # CONFIG_CAIF is not set
> CONFIG_CEPH_LIB=y
> # CONFIG_CEPH_LIB_PRETTYDEBUG is not set
> # CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
> CONFIG_NFC=y
> CONFIG_NFC_NCI=y
> # CONFIG_NFC_HCI is not set
> # CONFIG_NFC_LLCP is not set
> 
> #
> # Near Field Communication (NFC) devices
> #
> CONFIG_NFC_PN533=y
> CONFIG_HAVE_BPF_JIT=y
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> # CONFIG_DEVTMPFS_MOUNT is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> CONFIG_SYS_HYPERVISOR=y
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_DMA_SHARED_BUFFER=y
> 
> #
> # Bus devices
> #
> CONFIG_CONNECTOR=y
> CONFIG_PROC_EVENTS=y
> CONFIG_MTD=y
> # CONFIG_MTD_TESTS is not set
> CONFIG_MTD_REDBOOT_PARTS=y
> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
> # CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
> # CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
> # CONFIG_MTD_CMDLINE_PARTS is not set
> CONFIG_MTD_AR7_PARTS=y
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_CHAR=y
> CONFIG_MTD_BLKDEVS=y
> CONFIG_MTD_BLOCK=y
> CONFIG_FTL=y
> CONFIG_NFTL=y
> CONFIG_NFTL_RW=y
> CONFIG_INFTL=y
> CONFIG_RFD_FTL=y
> CONFIG_SSFDC=y
> # CONFIG_SM_FTL is not set
> CONFIG_MTD_OOPS=y
> CONFIG_MTD_SWAP=y
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=y
> CONFIG_MTD_JEDECPROBE=y
> CONFIG_MTD_GEN_PROBE=y
> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> CONFIG_MTD_CFI_INTELEXT=y
> CONFIG_MTD_CFI_AMDSTD=y
> CONFIG_MTD_CFI_STAA=y
> CONFIG_MTD_CFI_UTIL=y
> CONFIG_MTD_RAM=y
> CONFIG_MTD_ROM=y
> CONFIG_MTD_ABSENT=y
> 
> #
> # Mapping drivers for chip access
> #
> CONFIG_MTD_COMPLEX_MAPPINGS=y
> CONFIG_MTD_PHYSMAP=y
> # CONFIG_MTD_PHYSMAP_COMPAT is not set
> CONFIG_MTD_SC520CDP=y
> CONFIG_MTD_NETSC520=y
> CONFIG_MTD_TS5500=y
> CONFIG_MTD_SBC_GXX=y
> # CONFIG_MTD_AMD76XROM is not set
> # CONFIG_MTD_ICHXROM is not set
> # CONFIG_MTD_ESB2ROM is not set
> # CONFIG_MTD_CK804XROM is not set
> # CONFIG_MTD_SCB2_FLASH is not set
> # CONFIG_MTD_NETtel is not set
> # CONFIG_MTD_L440GX is not set
> CONFIG_MTD_PCI=y
> CONFIG_MTD_PCMCIA=y
> # CONFIG_MTD_PCMCIA_ANONYMOUS is not set
> # CONFIG_MTD_GPIO_ADDR is not set
> CONFIG_MTD_INTEL_VR_NOR=y
> CONFIG_MTD_PLATRAM=y
> # CONFIG_MTD_LATCH_ADDR is not set
> 
> #
> # Self-contained MTD device drivers
> #
> CONFIG_MTD_PMC551=y
> # CONFIG_MTD_PMC551_BUGFIX is not set
> # CONFIG_MTD_PMC551_DEBUG is not set
> CONFIG_MTD_DATAFLASH=y
> # CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
> # CONFIG_MTD_DATAFLASH_OTP is not set
> CONFIG_MTD_M25P80=y
> CONFIG_M25PXX_USE_FAST_READ=y
> CONFIG_MTD_SST25L=y
> CONFIG_MTD_SLRAM=y
> CONFIG_MTD_PHRAM=y
> CONFIG_MTD_MTDRAM=y
> CONFIG_MTDRAM_TOTAL_SIZE=4096
> CONFIG_MTDRAM_ERASE_SIZE=128
> CONFIG_MTDRAM_ABS_POS=0
> CONFIG_MTD_BLOCK2MTD=y
> 
> #
> # Disk-On-Chip Device Drivers
> #
> CONFIG_MTD_DOC2000=y
> CONFIG_MTD_DOC2001=y
> CONFIG_MTD_DOC2001PLUS=y
> # CONFIG_MTD_DOCG3 is not set
> CONFIG_MTD_DOCPROBE=y
> CONFIG_MTD_DOCECC=y
> # CONFIG_MTD_DOCPROBE_ADVANCED is not set
> CONFIG_MTD_DOCPROBE_ADDRESS=0x0
> CONFIG_MTD_NAND_ECC=y
> # CONFIG_MTD_NAND_ECC_SMC is not set
> CONFIG_MTD_NAND=y
> # CONFIG_MTD_NAND_ECC_BCH is not set
> CONFIG_MTD_SM_COMMON=y
> # CONFIG_MTD_NAND_MUSEUM_IDS is not set
> # CONFIG_MTD_NAND_DENALI is not set
> CONFIG_MTD_NAND_IDS=y
> CONFIG_MTD_NAND_RICOH=y
> CONFIG_MTD_NAND_DISKONCHIP=y
> # CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
> CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
> # CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
> # CONFIG_MTD_NAND_DOCG4 is not set
> CONFIG_MTD_NAND_CAFE=y
> CONFIG_MTD_NAND_NANDSIM=y
> CONFIG_MTD_NAND_PLATFORM=y
> CONFIG_MTD_ALAUDA=y
> CONFIG_MTD_ONENAND=y
> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
> CONFIG_MTD_ONENAND_GENERIC=y
> # CONFIG_MTD_ONENAND_OTP is not set
> CONFIG_MTD_ONENAND_2X_PROGRAM=y
> CONFIG_MTD_ONENAND_SIM=y
> 
> #
> # LPDDR flash memory drivers
> #
> CONFIG_MTD_LPDDR=y
> CONFIG_MTD_QINFO_PROBE=y
> CONFIG_MTD_UBI=y
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_LIMIT=20
> # CONFIG_MTD_UBI_FASTMAP is not set
> # CONFIG_MTD_UBI_GLUEBI is not set
> CONFIG_PARPORT=y
> CONFIG_PARPORT_PC=y
> CONFIG_PARPORT_SERIAL=y
> # CONFIG_PARPORT_PC_FIFO is not set
> # CONFIG_PARPORT_PC_SUPERIO is not set
> CONFIG_PARPORT_PC_PCMCIA=y
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=y
> CONFIG_PARPORT_1284=y
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG_MESSAGES is not set
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=y
> CONFIG_PARIDE=m
> 
> #
> # Parallel IDE high-level drivers
> #
> CONFIG_PARIDE_PD=m
> CONFIG_PARIDE_PCD=m
> CONFIG_PARIDE_PF=m
> CONFIG_PARIDE_PT=m
> CONFIG_PARIDE_PG=m
> 
> #
> # Parallel IDE protocol modules
> #
> CONFIG_PARIDE_ATEN=m
> CONFIG_PARIDE_BPCK=m
> CONFIG_PARIDE_COMM=m
> CONFIG_PARIDE_DSTR=m
> CONFIG_PARIDE_FIT2=m
> CONFIG_PARIDE_FIT3=m
> CONFIG_PARIDE_EPAT=m
> # CONFIG_PARIDE_EPATC8 is not set
> CONFIG_PARIDE_EPIA=m
> CONFIG_PARIDE_FRIQ=m
> CONFIG_PARIDE_FRPW=m
> CONFIG_PARIDE_KBIC=m
> CONFIG_PARIDE_KTTI=m
> CONFIG_PARIDE_ON20=m
> CONFIG_PARIDE_ON26=m
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> CONFIG_BLK_CPQ_DA=y
> CONFIG_BLK_CPQ_CISS_DA=y
> CONFIG_CISS_SCSI_TAPE=y
> CONFIG_BLK_DEV_DAC960=y
> CONFIG_BLK_DEV_UMEM=y
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> CONFIG_BLK_DEV_DRBD=y
> # CONFIG_DRBD_FAULT_INJECTION is not set
> CONFIG_BLK_DEV_NBD=y
> # CONFIG_BLK_DEV_NVME is not set
> CONFIG_BLK_DEV_OSD=y
> CONFIG_BLK_DEV_SX8=y
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=65536
> # CONFIG_BLK_DEV_XIP is not set
> CONFIG_CDROM_PKTCDVD=y
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> CONFIG_ATA_OVER_ETH=y
> CONFIG_XEN_BLKDEV_FRONTEND=y
> CONFIG_XEN_BLKDEV_BACKEND=y
> CONFIG_VIRTIO_BLK=y
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_BLK_DEV_RBD=y
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> CONFIG_AD525X_DPOT=y
> CONFIG_AD525X_DPOT_I2C=y
> CONFIG_AD525X_DPOT_SPI=y
> CONFIG_IBM_ASM=y
> CONFIG_PHANTOM=y
> # CONFIG_INTEL_MID_PTI is not set
> CONFIG_SGI_IOC4=y
> CONFIG_TIFM_CORE=y
> CONFIG_TIFM_7XX1=y
> CONFIG_ICS932S401=y
> CONFIG_ENCLOSURE_SERVICES=y
> CONFIG_HP_ILO=y
> CONFIG_APDS9802ALS=y
> CONFIG_ISL29003=y
> CONFIG_ISL29020=y
> CONFIG_SENSORS_TSL2550=y
> CONFIG_SENSORS_BH1780=y
> CONFIG_SENSORS_BH1770=y
> CONFIG_SENSORS_APDS990X=y
> CONFIG_HMC6352=y
> CONFIG_DS1682=y
> CONFIG_TI_DAC7512=y
> CONFIG_VMWARE_BALLOON=y
> # CONFIG_BMP085_I2C is not set
> # CONFIG_BMP085_SPI is not set
> CONFIG_PCH_PHUB=y
> # CONFIG_USB_SWITCH_FSA9480 is not set
> CONFIG_C2PORT=y
> CONFIG_C2PORT_DURAMAR_2150=y
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> CONFIG_EEPROM_AT25=y
> CONFIG_EEPROM_LEGACY=y
> CONFIG_EEPROM_MAX6875=y
> CONFIG_EEPROM_93CX6=y
> # CONFIG_EEPROM_93XX46 is not set
> CONFIG_CB710_CORE=y
> # CONFIG_CB710_DEBUG is not set
> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> CONFIG_SENSORS_LIS3_I2C=y
> 
> #
> # Altera FPGA firmware download module
> #
> # CONFIG_ALTERA_STAPL is not set
> # CONFIG_INTEL_MEI is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_ATAPI=y
> # CONFIG_BLK_DEV_IDE_SATA is not set
> CONFIG_IDE_GD=y
> CONFIG_IDE_GD_ATA=y
> CONFIG_IDE_GD_ATAPI=y
> # CONFIG_BLK_DEV_IDECS is not set
> CONFIG_BLK_DEV_DELKIN=y
> CONFIG_BLK_DEV_IDECD=y
> CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
> CONFIG_BLK_DEV_IDETAPE=y
> # CONFIG_BLK_DEV_IDEACPI is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> CONFIG_IDE_PROC_FS=y
> 
> #
> # IDE chipset support/bugfixes
> #
> CONFIG_IDE_GENERIC=y
> # CONFIG_BLK_DEV_PLATFORM is not set
> # CONFIG_BLK_DEV_CMD640 is not set
> CONFIG_BLK_DEV_IDEPNP=y
> CONFIG_BLK_DEV_IDEDMA_SFF=y
> 
> #
> # PCI IDE chipsets support
> #
> CONFIG_BLK_DEV_IDEPCI=y
> CONFIG_IDEPCI_PCIBUS_ORDER=y
> # CONFIG_BLK_DEV_OFFBOARD is not set
> # CONFIG_BLK_DEV_GENERIC is not set
> CONFIG_BLK_DEV_OPTI621=y
> # CONFIG_BLK_DEV_RZ1000 is not set
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> CONFIG_BLK_DEV_HPT366=y
> # CONFIG_BLK_DEV_JMICRON is not set
> # CONFIG_BLK_DEV_SC1200 is not set
> CONFIG_BLK_DEV_PIIX=y
> CONFIG_BLK_DEV_IT8172=y
> CONFIG_BLK_DEV_IT8213=y
> # CONFIG_BLK_DEV_IT821X is not set
> # CONFIG_BLK_DEV_NS87415 is not set
> # CONFIG_BLK_DEV_PDC202XX_OLD is not set
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> # CONFIG_BLK_DEV_SIIMAGE is not set
> # CONFIG_BLK_DEV_SIS5513 is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> CONFIG_BLK_DEV_TRM290=y
> # CONFIG_BLK_DEV_VIA82CXXX is not set
> CONFIG_BLK_DEV_TC86C001=y
> CONFIG_BLK_DEV_IDEDMA=y
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=y
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=y
> CONFIG_SCSI_NETLINK=y
> # CONFIG_SCSI_PROC_FS is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> CONFIG_CHR_DEV_ST=y
> CONFIG_CHR_DEV_OSST=y
> CONFIG_BLK_DEV_SR=y
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=y
> CONFIG_CHR_DEV_SCH=y
> CONFIG_SCSI_ENCLOSURE=y
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=y
> CONFIG_SCSI_FC_TGT_ATTRS=y
> CONFIG_SCSI_ISCSI_ATTRS=y
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> CONFIG_SCSI_SAS_ATA=y
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=y
> CONFIG_SCSI_SRP_TGT_ATTRS=y
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_TCP=y
> CONFIG_ISCSI_BOOT_SYSFS=y
> CONFIG_SCSI_CXGB3_ISCSI=y
> CONFIG_SCSI_CXGB4_ISCSI=y
> CONFIG_SCSI_BNX2_ISCSI=y
> CONFIG_SCSI_BNX2X_FCOE=y
> CONFIG_BE2ISCSI=y
> CONFIG_BLK_DEV_3W_XXXX_RAID=y
> CONFIG_SCSI_HPSA=y
> CONFIG_SCSI_3W_9XXX=y
> CONFIG_SCSI_3W_SAS=y
> CONFIG_SCSI_ACARD=y
> CONFIG_SCSI_AACRAID=y
> CONFIG_SCSI_AIC7XXX=y
> CONFIG_AIC7XXX_CMDS_PER_DEVICE=8
> CONFIG_AIC7XXX_RESET_DELAY_MS=15000
> CONFIG_AIC7XXX_DEBUG_ENABLE=y
> CONFIG_AIC7XXX_DEBUG_MASK=0
> CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
> CONFIG_SCSI_AIC7XXX_OLD=y
> CONFIG_SCSI_AIC79XX=y
> CONFIG_AIC79XX_CMDS_PER_DEVICE=32
> CONFIG_AIC79XX_RESET_DELAY_MS=15000
> CONFIG_AIC79XX_DEBUG_ENABLE=y
> CONFIG_AIC79XX_DEBUG_MASK=0
> CONFIG_AIC79XX_REG_PRETTY_PRINT=y
> CONFIG_SCSI_AIC94XX=y
> # CONFIG_AIC94XX_DEBUG is not set
> CONFIG_SCSI_MVSAS=y
> # CONFIG_SCSI_MVSAS_DEBUG is not set
> # CONFIG_SCSI_MVSAS_TASKLET is not set
> CONFIG_SCSI_MVUMI=y
> CONFIG_SCSI_DPT_I2O=y
> CONFIG_SCSI_ADVANSYS=y
> CONFIG_SCSI_ARCMSR=y
> CONFIG_MEGARAID_NEWGEN=y
> CONFIG_MEGARAID_MM=y
> CONFIG_MEGARAID_MAILBOX=y
> CONFIG_MEGARAID_LEGACY=y
> CONFIG_MEGARAID_SAS=y
> CONFIG_SCSI_MPT2SAS=y
> CONFIG_SCSI_MPT2SAS_MAX_SGE=128
> # CONFIG_SCSI_MPT2SAS_LOGGING is not set
> # CONFIG_SCSI_MPT3SAS is not set
> # CONFIG_SCSI_UFSHCD is not set
> CONFIG_SCSI_HPTIOP=y
> CONFIG_SCSI_BUSLOGIC=y
> CONFIG_VMWARE_PVSCSI=y
> CONFIG_HYPERV_STORAGE=y
> CONFIG_LIBFC=y
> CONFIG_LIBFCOE=y
> CONFIG_FCOE=y
> CONFIG_FCOE_FNIC=y
> CONFIG_SCSI_DMX3191D=y
> CONFIG_SCSI_EATA=y
> CONFIG_SCSI_EATA_TAGGED_QUEUE=y
> CONFIG_SCSI_EATA_LINKED_COMMANDS=y
> CONFIG_SCSI_EATA_MAX_TAGS=16
> CONFIG_SCSI_FUTURE_DOMAIN=y
> CONFIG_SCSI_GDTH=y
> CONFIG_SCSI_ISCI=y
> CONFIG_SCSI_IPS=y
> CONFIG_SCSI_INITIO=y
> CONFIG_SCSI_INIA100=y
> CONFIG_SCSI_PPA=y
> CONFIG_SCSI_IMM=y
> # CONFIG_SCSI_IZIP_EPP16 is not set
> # CONFIG_SCSI_IZIP_SLOW_CTR is not set
> CONFIG_SCSI_STEX=y
> CONFIG_SCSI_SYM53C8XX_2=y
> CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
> CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
> CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
> CONFIG_SCSI_SYM53C8XX_MMIO=y
> CONFIG_SCSI_IPR=y
> # CONFIG_SCSI_IPR_TRACE is not set
> # CONFIG_SCSI_IPR_DUMP is not set
> CONFIG_SCSI_QLOGIC_1280=y
> CONFIG_SCSI_QLA_FC=y
> # CONFIG_TCM_QLA2XXX is not set
> CONFIG_SCSI_QLA_ISCSI=y
> # CONFIG_SCSI_LPFC is not set
> CONFIG_SCSI_DC395x=y
> CONFIG_SCSI_DC390T=y
> CONFIG_SCSI_DEBUG=y
> CONFIG_SCSI_PMCRAID=y
> CONFIG_SCSI_PM8001=y
> CONFIG_SCSI_SRP=y
> CONFIG_SCSI_BFA_FC=y
> CONFIG_SCSI_VIRTIO=y
> # CONFIG_SCSI_CHELSIO_FCOE is not set
> CONFIG_SCSI_LOWLEVEL_PCMCIA=y
> CONFIG_PCMCIA_AHA152X=m
> CONFIG_PCMCIA_FDOMAIN=m
> CONFIG_PCMCIA_QLOGIC=m
> CONFIG_PCMCIA_SYM53C500=m
> CONFIG_SCSI_DH=y
> CONFIG_SCSI_DH_RDAC=y
> CONFIG_SCSI_DH_HP_SW=y
> CONFIG_SCSI_DH_EMC=y
> CONFIG_SCSI_DH_ALUA=y
> CONFIG_SCSI_OSD_INITIATOR=y
> CONFIG_SCSI_OSD_ULD=y
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> # CONFIG_SCSI_OSD_DEBUG is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> CONFIG_SATA_AHCI=y
> # CONFIG_SATA_AHCI_PLATFORM is not set
> CONFIG_SATA_INIC162X=y
> CONFIG_SATA_ACARD_AHCI=y
> CONFIG_SATA_SIL24=y
> # CONFIG_ATA_SFF is not set
> 
> #
> # SFF controllers with custom DMA interface
> #
> CONFIG_PDC_ADMA=y
> CONFIG_SATA_QSTOR=y
> CONFIG_SATA_SX4=y
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> CONFIG_ATA_PIIX=y
> # CONFIG_SATA_HIGHBANK is not set
> CONFIG_SATA_MV=y
> CONFIG_SATA_NV=y
> CONFIG_SATA_PROMISE=y
> CONFIG_SATA_SIL=y
> CONFIG_SATA_SIS=y
> CONFIG_SATA_SVW=y
> CONFIG_SATA_ULI=y
> CONFIG_SATA_VIA=y
> CONFIG_SATA_VITESSE=y
> 
> #
> # PATA SFF controllers with BMDMA
> #
> CONFIG_PATA_ALI=y
> CONFIG_PATA_AMD=y
> CONFIG_PATA_ARASAN_CF=y
> CONFIG_PATA_ARTOP=y
> CONFIG_PATA_ATIIXP=y
> CONFIG_PATA_ATP867X=y
> CONFIG_PATA_CMD64X=y
> CONFIG_PATA_CS5520=y
> CONFIG_PATA_CS5530=y
> # CONFIG_PATA_CS5536 is not set
> # CONFIG_PATA_CYPRESS is not set
> CONFIG_PATA_EFAR=y
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT8213 is not set
> CONFIG_PATA_IT821X=y
> CONFIG_PATA_JMICRON=y
> CONFIG_PATA_MARVELL=y
> CONFIG_PATA_NETCELL=y
> # CONFIG_PATA_NINJA32 is not set
> CONFIG_PATA_NS87415=y
> CONFIG_PATA_OLDPIIX=y
> # CONFIG_PATA_OPTIDMA is not set
> CONFIG_PATA_PDC2027X=y
> CONFIG_PATA_PDC_OLD=y
> # CONFIG_PATA_RADISYS is not set
> CONFIG_PATA_RDC=y
> CONFIG_PATA_SC1200=y
> CONFIG_PATA_SCH=y
> CONFIG_PATA_SERVERWORKS=y
> CONFIG_PATA_SIL680=y
> CONFIG_PATA_SIS=y
> CONFIG_PATA_TOSHIBA=y
> CONFIG_PATA_TRIFLEX=y
> CONFIG_PATA_VIA=y
> # CONFIG_PATA_WINBOND is not set
> 
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_CMD640_PCI is not set
> CONFIG_PATA_MPIIX=y
> CONFIG_PATA_NS87410=y
> # CONFIG_PATA_OPTI is not set
> CONFIG_PATA_PCMCIA=y
> CONFIG_PATA_RZ1000=y
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_PATA_ACPI is not set
> CONFIG_ATA_GENERIC=y
> # CONFIG_PATA_LEGACY is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_AUTODETECT=y
> CONFIG_MD_LINEAR=y
> CONFIG_MD_RAID0=y
> CONFIG_MD_RAID1=y
> CONFIG_MD_RAID10=y
> CONFIG_MD_RAID456=y
> # CONFIG_MULTICORE_RAID456 is not set
> CONFIG_MD_MULTIPATH=y
> CONFIG_MD_FAULTY=y
> CONFIG_BLK_DEV_DM=y
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_BUFIO=y
> CONFIG_DM_BIO_PRISON=y
> CONFIG_DM_PERSISTENT_DATA=y
> CONFIG_DM_CRYPT=y
> CONFIG_DM_SNAPSHOT=y
> CONFIG_DM_THIN_PROVISIONING=y
> # CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
> CONFIG_DM_MIRROR=y
> CONFIG_DM_RAID=y
> CONFIG_DM_LOG_USERSPACE=y
> CONFIG_DM_ZERO=y
> CONFIG_DM_MULTIPATH=y
> CONFIG_DM_MULTIPATH_QL=y
> CONFIG_DM_MULTIPATH_ST=y
> CONFIG_DM_DELAY=y
> CONFIG_DM_UEVENT=y
> CONFIG_DM_FLAKEY=y
> # CONFIG_DM_VERITY is not set
> CONFIG_TARGET_CORE=y
> CONFIG_TCM_IBLOCK=y
> CONFIG_TCM_FILEIO=y
> CONFIG_TCM_PSCSI=y
> CONFIG_LOOPBACK_TARGET=y
> CONFIG_TCM_FC=y
> CONFIG_ISCSI_TARGET=y
> # CONFIG_SBP_TARGET is not set
> CONFIG_FUSION=y
> CONFIG_FUSION_SPI=y
> CONFIG_FUSION_FC=y
> CONFIG_FUSION_SAS=y
> CONFIG_FUSION_MAX_SGE=128
> CONFIG_FUSION_CTL=y
> CONFIG_FUSION_LAN=y
> # CONFIG_FUSION_LOGGING is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=y
> CONFIG_FIREWIRE_OHCI=y
> CONFIG_FIREWIRE_SBP2=y
> CONFIG_FIREWIRE_NET=y
> CONFIG_FIREWIRE_NOSY=y
> CONFIG_I2O=y
> CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
> CONFIG_I2O_EXT_ADAPTEC=y
> CONFIG_I2O_EXT_ADAPTEC_DMA64=y
> CONFIG_I2O_CONFIG=y
> CONFIG_I2O_CONFIG_OLD_IOCTL=y
> CONFIG_I2O_BUS=y
> CONFIG_I2O_BLOCK=y
> CONFIG_I2O_SCSI=y
> CONFIG_I2O_PROC=y
> CONFIG_MACINTOSH_DRIVERS=y
> CONFIG_MAC_EMUMOUSEBTN=y
> CONFIG_NETDEVICES=y
> CONFIG_NET_CORE=y
> CONFIG_BONDING=y
> CONFIG_DUMMY=y
> CONFIG_EQUALIZER=y
> CONFIG_NET_FC=y
> CONFIG_MII=y
> CONFIG_IFB=y
> # CONFIG_NET_TEAM is not set
> CONFIG_MACVLAN=y
> CONFIG_MACVTAP=y
> # CONFIG_VXLAN is not set
> CONFIG_NETCONSOLE=y
> CONFIG_NETCONSOLE_DYNAMIC=y
> CONFIG_NETPOLL=y
> # CONFIG_NETPOLL_TRAP is not set
> CONFIG_NET_POLL_CONTROLLER=y
> CONFIG_TUN=y
> CONFIG_VETH=y
> CONFIG_VIRTIO_NET=y
> CONFIG_SUNGEM_PHY=y
> CONFIG_ARCNET=y
> CONFIG_ARCNET_1201=y
> CONFIG_ARCNET_1051=y
> CONFIG_ARCNET_RAW=y
> CONFIG_ARCNET_CAP=y
> CONFIG_ARCNET_COM90xx=y
> CONFIG_ARCNET_COM90xxIO=y
> CONFIG_ARCNET_RIM_I=y
> CONFIG_ARCNET_COM20020=y
> CONFIG_ARCNET_COM20020_PCI=y
> CONFIG_ARCNET_COM20020_CS=y
> CONFIG_ATM_DRIVERS=y
> CONFIG_ATM_DUMMY=y
> CONFIG_ATM_TCP=y
> CONFIG_ATM_LANAI=y
> CONFIG_ATM_ENI=y
> # CONFIG_ATM_ENI_DEBUG is not set
> # CONFIG_ATM_ENI_TUNE_BURST is not set
> CONFIG_ATM_FIRESTREAM=y
> CONFIG_ATM_ZATM=y
> # CONFIG_ATM_ZATM_DEBUG is not set
> CONFIG_ATM_NICSTAR=y
> CONFIG_ATM_NICSTAR_USE_SUNI=y
> CONFIG_ATM_NICSTAR_USE_IDT77105=y
> CONFIG_ATM_IDT77252=y
> # CONFIG_ATM_IDT77252_DEBUG is not set
> # CONFIG_ATM_IDT77252_RCV_ALL is not set
> CONFIG_ATM_IDT77252_USE_SUNI=y
> CONFIG_ATM_AMBASSADOR=y
> # CONFIG_ATM_AMBASSADOR_DEBUG is not set
> CONFIG_ATM_HORIZON=y
> # CONFIG_ATM_HORIZON_DEBUG is not set
> CONFIG_ATM_IA=y
> # CONFIG_ATM_IA_DEBUG is not set
> CONFIG_ATM_FORE200E=y
> # CONFIG_ATM_FORE200E_USE_TASKLET is not set
> CONFIG_ATM_FORE200E_TX_RETRY=16
> CONFIG_ATM_FORE200E_DEBUG=0
> CONFIG_ATM_HE=y
> CONFIG_ATM_HE_USE_SUNI=y
> CONFIG_ATM_SOLOS=y
> 
> #
> # CAIF transport drivers
> #
> 
> #
> # Distributed Switch Architecture drivers
> #
> # CONFIG_NET_DSA_MV88E6XXX is not set
> # CONFIG_NET_DSA_MV88E6060 is not set
> # CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
> # CONFIG_NET_DSA_MV88E6131 is not set
> # CONFIG_NET_DSA_MV88E6123_61_65 is not set
> CONFIG_ETHERNET=y
> CONFIG_MDIO=y
> CONFIG_NET_VENDOR_3COM=y
> CONFIG_PCMCIA_3C574=y
> CONFIG_PCMCIA_3C589=y
> CONFIG_VORTEX=y
> CONFIG_TYPHOON=y
> CONFIG_NET_VENDOR_ADAPTEC=y
> CONFIG_ADAPTEC_STARFIRE=y
> CONFIG_NET_VENDOR_ALTEON=y
> CONFIG_ACENIC=y
> # CONFIG_ACENIC_OMIT_TIGON_I is not set
> CONFIG_NET_VENDOR_AMD=y
> CONFIG_AMD8111_ETH=y
> CONFIG_PCNET32=y
> CONFIG_PCMCIA_NMCLAN=y
> CONFIG_NET_VENDOR_ATHEROS=y
> CONFIG_ATL2=y
> CONFIG_ATL1=y
> CONFIG_ATL1E=y
> CONFIG_ATL1C=y
> CONFIG_NET_CADENCE=y
> # CONFIG_ARM_AT91_ETHER is not set
> # CONFIG_MACB is not set
> CONFIG_NET_VENDOR_BROADCOM=y
> CONFIG_B44=y
> CONFIG_B44_PCI_AUTOSELECT=y
> CONFIG_B44_PCICORE_AUTOSELECT=y
> CONFIG_B44_PCI=y
> CONFIG_BNX2=y
> CONFIG_CNIC=y
> CONFIG_TIGON3=y
> CONFIG_BNX2X=y
> CONFIG_NET_VENDOR_BROCADE=y
> CONFIG_BNA=y
> # CONFIG_NET_CALXEDA_XGMAC is not set
> CONFIG_NET_VENDOR_CHELSIO=y
> CONFIG_CHELSIO_T1=y
> CONFIG_CHELSIO_T1_1G=y
> CONFIG_CHELSIO_T3=y
> CONFIG_CHELSIO_T4=y
> CONFIG_CHELSIO_T4VF=y
> CONFIG_NET_VENDOR_CISCO=y
> CONFIG_ENIC=y
> CONFIG_DNET=y
> CONFIG_NET_VENDOR_DEC=y
> CONFIG_NET_TULIP=y
> CONFIG_DE2104X=y
> CONFIG_DE2104X_DSL=0
> CONFIG_TULIP=y
> # CONFIG_TULIP_MWI is not set
> # CONFIG_TULIP_MMIO is not set
> CONFIG_TULIP_NAPI=y
> CONFIG_TULIP_NAPI_HW_MITIGATION=y
> CONFIG_DE4X5=y
> CONFIG_WINBOND_840=y
> CONFIG_DM9102=y
> CONFIG_ULI526X=y
> CONFIG_PCMCIA_XIRCOM=y
> CONFIG_NET_VENDOR_DLINK=y
> CONFIG_DE600=y
> CONFIG_DE620=y
> CONFIG_DL2K=y
> CONFIG_SUNDANCE=y
> # CONFIG_SUNDANCE_MMIO is not set
> CONFIG_NET_VENDOR_EMULEX=y
> CONFIG_BE2NET=y
> CONFIG_NET_VENDOR_EXAR=y
> CONFIG_S2IO=y
> CONFIG_VXGE=y
> # CONFIG_VXGE_DEBUG_TRACE_ALL is not set
> CONFIG_NET_VENDOR_FUJITSU=y
> CONFIG_PCMCIA_FMVJ18X=y
> CONFIG_NET_VENDOR_HP=y
> CONFIG_HP100=y
> CONFIG_NET_VENDOR_INTEL=y
> CONFIG_E100=y
> CONFIG_E1000=y
> CONFIG_E1000E=y
> CONFIG_IGB=y
> CONFIG_IGB_DCA=y
> CONFIG_IGBVF=y
> CONFIG_IXGB=y
> CONFIG_IXGBE=y
> CONFIG_IXGBE_HWMON=y
> CONFIG_IXGBE_DCA=y
> CONFIG_IXGBE_DCB=y
> CONFIG_IXGBEVF=y
> CONFIG_NET_VENDOR_I825XX=y
> # CONFIG_ZNET is not set
> CONFIG_IP1000=y
> CONFIG_JME=y
> CONFIG_NET_VENDOR_MARVELL=y
> # CONFIG_MVMDIO is not set
> CONFIG_SKGE=y
> CONFIG_SKGE_DEBUG=y
> CONFIG_SKGE_GENESIS=y
> CONFIG_SKY2=y
> CONFIG_SKY2_DEBUG=y
> CONFIG_NET_VENDOR_MELLANOX=y
> CONFIG_MLX4_EN=y
> CONFIG_MLX4_EN_DCB=y
> CONFIG_MLX4_CORE=y
> CONFIG_MLX4_DEBUG=y
> CONFIG_NET_VENDOR_MICREL=y
> CONFIG_KS8842=y
> CONFIG_KS8851=y
> CONFIG_KS8851_MLL=y
> CONFIG_KSZ884X_PCI=y
> CONFIG_NET_VENDOR_MICROCHIP=y
> CONFIG_ENC28J60=y
> # CONFIG_ENC28J60_WRITEVERIFY is not set
> CONFIG_NET_VENDOR_MYRI=y
> CONFIG_MYRI10GE=y
> CONFIG_MYRI10GE_DCA=y
> CONFIG_FEALNX=y
> CONFIG_NET_VENDOR_NATSEMI=y
> CONFIG_NATSEMI=y
> CONFIG_NS83820=y
> CONFIG_NET_VENDOR_8390=y
> CONFIG_PCMCIA_AXNET=y
> CONFIG_NE2K_PCI=y
> CONFIG_PCMCIA_PCNET=y
> CONFIG_NET_VENDOR_NVIDIA=y
> CONFIG_FORCEDETH=y
> CONFIG_NET_VENDOR_OKI=y
> CONFIG_PCH_GBE=y
> CONFIG_ETHOC=y
> CONFIG_NET_PACKET_ENGINE=y
> CONFIG_HAMACHI=y
> CONFIG_YELLOWFIN=y
> CONFIG_NET_VENDOR_QLOGIC=y
> CONFIG_QLA3XXX=y
> CONFIG_QLCNIC=y
> CONFIG_QLGE=y
> CONFIG_NETXEN_NIC=y
> CONFIG_NET_VENDOR_REALTEK=y
> CONFIG_ATP=y
> CONFIG_8139CP=y
> CONFIG_8139TOO=y
> CONFIG_8139TOO_PIO=y
> CONFIG_8139TOO_TUNE_TWISTER=y
> CONFIG_8139TOO_8129=y
> # CONFIG_8139_OLD_RX_RESET is not set
> CONFIG_R8169=y
> CONFIG_NET_VENDOR_RDC=y
> CONFIG_R6040=y
> CONFIG_NET_VENDOR_SEEQ=y
> # CONFIG_SEEQ8005 is not set
> CONFIG_NET_VENDOR_SILAN=y
> CONFIG_SC92031=y
> CONFIG_NET_VENDOR_SIS=y
> CONFIG_SIS900=y
> CONFIG_SIS190=y
> CONFIG_SFC=y
> CONFIG_SFC_MTD=y
> CONFIG_SFC_MCDI_MON=y
> CONFIG_SFC_SRIOV=y
> CONFIG_NET_VENDOR_SMSC=y
> CONFIG_PCMCIA_SMC91C92=y
> CONFIG_EPIC100=y
> CONFIG_SMSC9420=y
> CONFIG_NET_VENDOR_STMICRO=y
> # CONFIG_STMMAC_ETH is not set
> CONFIG_NET_VENDOR_SUN=y
> CONFIG_HAPPYMEAL=y
> CONFIG_SUNGEM=y
> CONFIG_CASSINI=y
> CONFIG_NIU=y
> CONFIG_NET_VENDOR_TEHUTI=y
> CONFIG_TEHUTI=y
> CONFIG_NET_VENDOR_TI=y
> CONFIG_TLAN=y
> CONFIG_NET_VENDOR_VIA=y
> CONFIG_VIA_RHINE=y
> # CONFIG_VIA_RHINE_MMIO is not set
> CONFIG_VIA_VELOCITY=y
> CONFIG_NET_VENDOR_WIZNET=y
> # CONFIG_WIZNET_W5100 is not set
> # CONFIG_WIZNET_W5300 is not set
> CONFIG_NET_VENDOR_XIRCOM=y
> CONFIG_PCMCIA_XIRC2PS=y
> CONFIG_FDDI=y
> CONFIG_DEFXX=y
> # CONFIG_DEFXX_MMIO is not set
> CONFIG_SKFP=y
> CONFIG_HIPPI=y
> CONFIG_ROADRUNNER=y
> # CONFIG_ROADRUNNER_LARGE_RINGS is not set
> CONFIG_NET_SB1000=y
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> # CONFIG_AT803X_PHY is not set
> # CONFIG_AMD_PHY is not set
> CONFIG_MARVELL_PHY=y
> CONFIG_DAVICOM_PHY=y
> CONFIG_QSEMI_PHY=y
> CONFIG_LXT_PHY=y
> CONFIG_CICADA_PHY=y
> CONFIG_VITESSE_PHY=y
> CONFIG_SMSC_PHY=y
> CONFIG_BROADCOM_PHY=y
> # CONFIG_BCM87XX_PHY is not set
> CONFIG_ICPLUS_PHY=y
> CONFIG_REALTEK_PHY=y
> CONFIG_NATIONAL_PHY=y
> CONFIG_STE10XP=y
> CONFIG_LSI_ET1011C_PHY=y
> CONFIG_MICREL_PHY=y
> # CONFIG_FIXED_PHY is not set
> CONFIG_MDIO_BITBANG=y
> # CONFIG_MDIO_GPIO is not set
> # CONFIG_MICREL_KS8995MA is not set
> CONFIG_PLIP=y
> CONFIG_PPP=y
> CONFIG_PPP_BSDCOMP=y
> CONFIG_PPP_DEFLATE=y
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_MPPE=y
> CONFIG_PPP_MULTILINK=y
> CONFIG_PPPOATM=y
> CONFIG_PPPOE=y
> CONFIG_PPTP=y
> CONFIG_PPPOL2TP=y
> CONFIG_PPP_ASYNC=y
> CONFIG_PPP_SYNC_TTY=y
> CONFIG_SLIP=y
> CONFIG_SLHC=y
> CONFIG_SLIP_COMPRESSED=y
> CONFIG_SLIP_SMART=y
> CONFIG_SLIP_MODE_SLIP6=y
> 
> #
> # USB Network Adapters
> #
> CONFIG_USB_CATC=y
> CONFIG_USB_KAWETH=y
> CONFIG_USB_PEGASUS=y
> CONFIG_USB_RTL8150=y
> CONFIG_USB_USBNET=y
> CONFIG_USB_NET_AX8817X=y
> CONFIG_USB_NET_CDCETHER=y
> CONFIG_USB_NET_CDC_EEM=y
> CONFIG_USB_NET_CDC_NCM=y
> # CONFIG_USB_NET_CDC_MBIM is not set
> CONFIG_USB_NET_DM9601=y
> CONFIG_USB_NET_SMSC75XX=y
> CONFIG_USB_NET_SMSC95XX=y
> CONFIG_USB_NET_GL620A=y
> CONFIG_USB_NET_NET1080=y
> CONFIG_USB_NET_PLUSB=y
> CONFIG_USB_NET_MCS7830=y
> CONFIG_USB_NET_RNDIS_HOST=y
> CONFIG_USB_NET_CDC_SUBSET=y
> CONFIG_USB_ALI_M5632=y
> CONFIG_USB_AN2720=y
> CONFIG_USB_BELKIN=y
> CONFIG_USB_ARMLINUX=y
> CONFIG_USB_EPSON2888=y
> CONFIG_USB_KC2190=y
> CONFIG_USB_NET_ZAURUS=y
> CONFIG_USB_NET_CX82310_ETH=y
> CONFIG_USB_NET_KALMIA=y
> # CONFIG_USB_NET_QMI_WWAN is not set
> CONFIG_USB_HSO=y
> CONFIG_USB_NET_INT51X1=y
> CONFIG_USB_CDC_PHONET=y
> CONFIG_USB_IPHETH=y
> CONFIG_USB_SIERRA_NET=y
> CONFIG_USB_VL600=y
> CONFIG_WLAN=y
> CONFIG_PCMCIA_RAYCS=y
> CONFIG_LIBERTAS_THINFIRM=y
> # CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
> CONFIG_LIBERTAS_THINFIRM_USB=y
> CONFIG_AIRO=y
> CONFIG_ATMEL=y
> CONFIG_PCI_ATMEL=y
> CONFIG_PCMCIA_ATMEL=y
> CONFIG_AT76C50X_USB=y
> CONFIG_AIRO_CS=y
> CONFIG_PCMCIA_WL3501=y
> # CONFIG_PRISM54 is not set
> CONFIG_USB_ZD1201=y
> CONFIG_USB_NET_RNDIS_WLAN=y
> CONFIG_RTL8180=y
> CONFIG_RTL8187=y
> CONFIG_RTL8187_LEDS=y
> CONFIG_ADM8211=y
> CONFIG_MAC80211_HWSIM=y
> CONFIG_MWL8K=y
> # CONFIG_ATH_CARDS is not set
> CONFIG_B43=y
> CONFIG_B43_BCMA=y
> # CONFIG_B43_BCMA_EXTRA is not set
> CONFIG_B43_SSB=y
> CONFIG_B43_PCI_AUTOSELECT=y
> CONFIG_B43_PCICORE_AUTOSELECT=y
> CONFIG_B43_PCMCIA=y
> CONFIG_B43_SDIO=y
> CONFIG_B43_BCMA_PIO=y
> CONFIG_B43_PIO=y
> CONFIG_B43_PHY_N=y
> CONFIG_B43_PHY_LP=y
> CONFIG_B43_PHY_HT=y
> CONFIG_B43_LEDS=y
> CONFIG_B43_HWRNG=y
> # CONFIG_B43_DEBUG is not set
> CONFIG_B43LEGACY=y
> CONFIG_B43LEGACY_PCI_AUTOSELECT=y
> CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
> CONFIG_B43LEGACY_LEDS=y
> CONFIG_B43LEGACY_HWRNG=y
> CONFIG_B43LEGACY_DEBUG=y
> CONFIG_B43LEGACY_DMA=y
> CONFIG_B43LEGACY_PIO=y
> CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
> # CONFIG_B43LEGACY_DMA_MODE is not set
> # CONFIG_B43LEGACY_PIO_MODE is not set
> CONFIG_BRCMUTIL=y
> CONFIG_BRCMSMAC=y
> # CONFIG_BRCMFMAC is not set
> # CONFIG_BRCM_TRACING is not set
> # CONFIG_BRCMDBG is not set
> CONFIG_HOSTAP=y
> CONFIG_HOSTAP_FIRMWARE=y
> # CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
> CONFIG_HOSTAP_PLX=y
> CONFIG_HOSTAP_PCI=y
> CONFIG_HOSTAP_CS=y
> # CONFIG_IPW2100 is not set
> CONFIG_IPW2200=y
> CONFIG_IPW2200_MONITOR=y
> CONFIG_IPW2200_RADIOTAP=y
> CONFIG_IPW2200_PROMISCUOUS=y
> CONFIG_IPW2200_QOS=y
> # CONFIG_IPW2200_DEBUG is not set
> CONFIG_LIBIPW=y
> # CONFIG_LIBIPW_DEBUG is not set
> CONFIG_IWLWIFI=y
> CONFIG_IWLDVM=y
> 
> #
> # Debugging Options
> #
> # CONFIG_IWLWIFI_DEBUG is not set
> # CONFIG_IWLWIFI_DEVICE_TRACING is not set
> CONFIG_IWLWIFI_P2P=y
> CONFIG_IWLEGACY=y
> CONFIG_IWL4965=y
> CONFIG_IWL3945=y
> 
> #
> # iwl3945 / iwl4965 Debugging Options
> #
> # CONFIG_IWLEGACY_DEBUG is not set
> CONFIG_LIBERTAS=y
> CONFIG_LIBERTAS_USB=y
> CONFIG_LIBERTAS_CS=y
> CONFIG_LIBERTAS_SDIO=y
> CONFIG_LIBERTAS_SPI=y
> # CONFIG_LIBERTAS_DEBUG is not set
> CONFIG_LIBERTAS_MESH=y
> CONFIG_HERMES=y
> # CONFIG_HERMES_PRISM is not set
> CONFIG_HERMES_CACHE_FW_ON_INIT=y
> CONFIG_PLX_HERMES=y
> CONFIG_TMD_HERMES=y
> CONFIG_NORTEL_HERMES=y
> CONFIG_PCMCIA_HERMES=y
> CONFIG_PCMCIA_SPECTRUM=y
> CONFIG_ORINOCO_USB=y
> CONFIG_P54_COMMON=y
> CONFIG_P54_USB=y
> CONFIG_P54_PCI=y
> CONFIG_P54_SPI=y
> # CONFIG_P54_SPI_DEFAULT_EEPROM is not set
> CONFIG_P54_LEDS=y
> CONFIG_RT2X00=y
> CONFIG_RT2400PCI=y
> CONFIG_RT2500PCI=y
> CONFIG_RT61PCI=y
> CONFIG_RT2800PCI=y
> CONFIG_RT2800PCI_RT33XX=y
> CONFIG_RT2800PCI_RT35XX=y
> CONFIG_RT2800PCI_RT53XX=y
> CONFIG_RT2800PCI_RT3290=y
> CONFIG_RT2500USB=y
> CONFIG_RT73USB=y
> CONFIG_RT2800USB=y
> CONFIG_RT2800USB_RT33XX=y
> CONFIG_RT2800USB_RT35XX=y
> CONFIG_RT2800USB_RT53XX=y
> # CONFIG_RT2800USB_UNKNOWN is not set
> CONFIG_RT2800_LIB=y
> CONFIG_RT2X00_LIB_PCI=y
> CONFIG_RT2X00_LIB_USB=y
> CONFIG_RT2X00_LIB=y
> CONFIG_RT2X00_LIB_FIRMWARE=y
> CONFIG_RT2X00_LIB_CRYPTO=y
> CONFIG_RT2X00_LIB_LEDS=y
> # CONFIG_RT2X00_DEBUG is not set
> CONFIG_RTL8192CE=y
> CONFIG_RTL8192SE=y
> CONFIG_RTL8192DE=y
> # CONFIG_RTL8723AE is not set
> CONFIG_RTL8192CU=y
> CONFIG_RTLWIFI=y
> CONFIG_RTLWIFI_DEBUG=y
> CONFIG_RTL8192C_COMMON=y
> # CONFIG_WL_TI is not set
> CONFIG_ZD1211RW=y
> # CONFIG_ZD1211RW_DEBUG is not set
> CONFIG_MWIFIEX=y
> CONFIG_MWIFIEX_SDIO=y
> CONFIG_MWIFIEX_PCIE=y
> # CONFIG_MWIFIEX_USB is not set
> 
> #
> # WiMAX Wireless Broadband devices
> #
> CONFIG_WIMAX_I2400M=y
> CONFIG_WIMAX_I2400M_USB=y
> CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
> CONFIG_WAN=y
> CONFIG_LANMEDIA=y
> CONFIG_HDLC=y
> CONFIG_HDLC_RAW=y
> CONFIG_HDLC_RAW_ETH=y
> CONFIG_HDLC_CISCO=y
> CONFIG_HDLC_FR=y
> CONFIG_HDLC_PPP=y
> # CONFIG_HDLC_X25 is not set
> CONFIG_PCI200SYN=y
> CONFIG_WANXL=y
> # CONFIG_PC300TOO is not set
> CONFIG_FARSYNC=y
> CONFIG_DSCC4=m
> CONFIG_DSCC4_PCISYNC=y
> CONFIG_DSCC4_PCI_RST=y
> CONFIG_DLCI=y
> CONFIG_DLCI_MAX=8
> CONFIG_WAN_ROUTER_DRIVERS=y
> CONFIG_CYCLADES_SYNC=y
> # CONFIG_CYCLOMX_X25 is not set
> CONFIG_SBNI=y
> # CONFIG_SBNI_MULTILINE is not set
> CONFIG_IEEE802154_DRIVERS=y
> CONFIG_IEEE802154_FAKEHARD=y
> CONFIG_XEN_NETDEV_FRONTEND=y
> CONFIG_XEN_NETDEV_BACKEND=y
> CONFIG_VMXNET3=y
> CONFIG_HYPERV_NET=y
> CONFIG_ISDN=y
> # CONFIG_ISDN_I4L is not set
> CONFIG_ISDN_CAPI=y
> CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
> CONFIG_CAPI_TRACE=y
> CONFIG_ISDN_CAPI_MIDDLEWARE=y
> CONFIG_ISDN_CAPI_CAPI20=y
> 
> #
> # CAPI hardware drivers
> #
> CONFIG_CAPI_AVM=y
> CONFIG_ISDN_DRV_AVMB1_B1PCI=y
> CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
> CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=y
> CONFIG_ISDN_DRV_AVMB1_AVM_CS=y
> CONFIG_ISDN_DRV_AVMB1_T1PCI=y
> CONFIG_ISDN_DRV_AVMB1_C4=y
> # CONFIG_CAPI_EICON is not set
> CONFIG_ISDN_DRV_GIGASET=y
> CONFIG_GIGASET_CAPI=y
> # CONFIG_GIGASET_DUMMYLL is not set
> CONFIG_GIGASET_BASE=y
> CONFIG_GIGASET_M105=y
> CONFIG_GIGASET_M101=y
> # CONFIG_GIGASET_DEBUG is not set
> CONFIG_HYSDN=m
> CONFIG_HYSDN_CAPI=y
> CONFIG_MISDN=y
> CONFIG_MISDN_DSP=y
> CONFIG_MISDN_L1OIP=y
> 
> #
> # mISDN hardware drivers
> #
> CONFIG_MISDN_HFCPCI=y
> CONFIG_MISDN_HFCMULTI=y
> CONFIG_MISDN_HFCUSB=y
> CONFIG_MISDN_AVMFRITZ=y
> CONFIG_MISDN_SPEEDFAX=y
> CONFIG_MISDN_INFINEON=y
> CONFIG_MISDN_W6692=y
> # CONFIG_MISDN_NETJET is not set
> CONFIG_MISDN_IPAC=y
> CONFIG_MISDN_ISAR=y
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> # CONFIG_INPUT_MATRIXKMAP is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=y
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ADP5588=y
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> CONFIG_KEYBOARD_QT2160=y
> CONFIG_KEYBOARD_LKKBD=y
> # CONFIG_KEYBOARD_GPIO is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> CONFIG_KEYBOARD_LM8323=y
> # CONFIG_KEYBOARD_LM8333 is not set
> CONFIG_KEYBOARD_MAX7359=y
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> CONFIG_KEYBOARD_NEWTON=y
> CONFIG_KEYBOARD_OPENCORES=y
> CONFIG_KEYBOARD_STOWAWAY=y
> CONFIG_KEYBOARD_SUNKBD=y
> CONFIG_KEYBOARD_XTKBD=y
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> CONFIG_MOUSE_PS2_ELANTECH=y
> CONFIG_MOUSE_PS2_SENTELIC=y
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> CONFIG_MOUSE_SERIAL=y
> CONFIG_MOUSE_APPLETOUCH=y
> CONFIG_MOUSE_BCM5974=y
> CONFIG_MOUSE_VSXXXAA=y
> # CONFIG_MOUSE_GPIO is not set
> CONFIG_MOUSE_SYNAPTICS_I2C=y
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
> CONFIG_INPUT_JOYSTICK=y
> CONFIG_JOYSTICK_ANALOG=y
> CONFIG_JOYSTICK_A3D=y
> CONFIG_JOYSTICK_ADI=y
> CONFIG_JOYSTICK_COBRA=y
> CONFIG_JOYSTICK_GF2K=y
> CONFIG_JOYSTICK_GRIP=y
> CONFIG_JOYSTICK_GRIP_MP=y
> CONFIG_JOYSTICK_GUILLEMOT=y
> CONFIG_JOYSTICK_INTERACT=y
> CONFIG_JOYSTICK_SIDEWINDER=y
> CONFIG_JOYSTICK_TMDC=y
> CONFIG_JOYSTICK_IFORCE=y
> CONFIG_JOYSTICK_IFORCE_USB=y
> CONFIG_JOYSTICK_IFORCE_232=y
> CONFIG_JOYSTICK_WARRIOR=y
> CONFIG_JOYSTICK_MAGELLAN=y
> CONFIG_JOYSTICK_SPACEORB=y
> CONFIG_JOYSTICK_SPACEBALL=y
> CONFIG_JOYSTICK_STINGER=y
> CONFIG_JOYSTICK_TWIDJOY=y
> CONFIG_JOYSTICK_ZHENHUA=y
> CONFIG_JOYSTICK_DB9=y
> CONFIG_JOYSTICK_GAMECON=y
> CONFIG_JOYSTICK_TURBOGRAFX=y
> # CONFIG_JOYSTICK_AS5011 is not set
> CONFIG_JOYSTICK_JOYDUMP=y
> CONFIG_JOYSTICK_XPAD=y
> CONFIG_JOYSTICK_XPAD_FF=y
> CONFIG_JOYSTICK_XPAD_LEDS=y
> CONFIG_JOYSTICK_WALKERA0701=y
> CONFIG_INPUT_TABLET=y
> CONFIG_TABLET_USB_ACECAD=y
> CONFIG_TABLET_USB_AIPTEK=y
> CONFIG_TABLET_USB_GTCO=y
> CONFIG_TABLET_USB_HANWANG=y
> CONFIG_TABLET_USB_KBTAB=y
> CONFIG_TABLET_USB_WACOM=y
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_TOUCHSCREEN_ADS7846=y
> CONFIG_TOUCHSCREEN_AD7877=y
> CONFIG_TOUCHSCREEN_AD7879=y
> CONFIG_TOUCHSCREEN_AD7879_I2C=y
> # CONFIG_TOUCHSCREEN_AD7879_SPI is not set
> # CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
> # CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
> # CONFIG_TOUCHSCREEN_BU21013 is not set
> # CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
> # CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
> CONFIG_TOUCHSCREEN_DYNAPRO=y
> CONFIG_TOUCHSCREEN_HAMPSHIRE=y
> CONFIG_TOUCHSCREEN_EETI=y
> CONFIG_TOUCHSCREEN_FUJITSU=y
> # CONFIG_TOUCHSCREEN_ILI210X is not set
> CONFIG_TOUCHSCREEN_GUNZE=y
> CONFIG_TOUCHSCREEN_ELO=y
> CONFIG_TOUCHSCREEN_WACOM_W8001=y
> # CONFIG_TOUCHSCREEN_WACOM_I2C is not set
> # CONFIG_TOUCHSCREEN_MAX11801 is not set
> CONFIG_TOUCHSCREEN_MCS5000=y
> # CONFIG_TOUCHSCREEN_MMS114 is not set
> CONFIG_TOUCHSCREEN_MTOUCH=y
> CONFIG_TOUCHSCREEN_INEXIO=y
> CONFIG_TOUCHSCREEN_MK712=y
> CONFIG_TOUCHSCREEN_PENMOUNT=y
> # CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
> CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
> CONFIG_TOUCHSCREEN_TOUCHWIN=y
> # CONFIG_TOUCHSCREEN_PIXCIR is not set
> CONFIG_TOUCHSCREEN_WM97XX=y
> CONFIG_TOUCHSCREEN_WM9705=y
> CONFIG_TOUCHSCREEN_WM9712=y
> CONFIG_TOUCHSCREEN_WM9713=y
> CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
> CONFIG_TOUCHSCREEN_USB_EGALAX=y
> CONFIG_TOUCHSCREEN_USB_PANJIT=y
> CONFIG_TOUCHSCREEN_USB_3M=y
> CONFIG_TOUCHSCREEN_USB_ITM=y
> CONFIG_TOUCHSCREEN_USB_ETURBO=y
> CONFIG_TOUCHSCREEN_USB_GUNZE=y
> CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
> CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
> CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
> CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
> CONFIG_TOUCHSCREEN_USB_GOTOP=y
> CONFIG_TOUCHSCREEN_USB_JASTEC=y
> CONFIG_TOUCHSCREEN_USB_ELO=y
> CONFIG_TOUCHSCREEN_USB_E2I=y
> CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
> CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
> CONFIG_TOUCHSCREEN_USB_NEXIO=y
> CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
> CONFIG_TOUCHSCREEN_TOUCHIT213=y
> # CONFIG_TOUCHSCREEN_TSC_SERIO is not set
> # CONFIG_TOUCHSCREEN_TSC2005 is not set
> CONFIG_TOUCHSCREEN_TSC2007=y
> # CONFIG_TOUCHSCREEN_ST1232 is not set
> CONFIG_TOUCHSCREEN_TPS6507X=y
> CONFIG_INPUT_MISC=y
> # CONFIG_INPUT_AD714X is not set
> # CONFIG_INPUT_BMA150 is not set
> CONFIG_INPUT_PCSPKR=y
> # CONFIG_INPUT_MMA8450 is not set
> # CONFIG_INPUT_MPU3050 is not set
> CONFIG_INPUT_APANEL=y
> # CONFIG_INPUT_GP2A is not set
> # CONFIG_INPUT_GPIO_TILT_POLLED is not set
> CONFIG_INPUT_ATLAS_BTNS=y
> CONFIG_INPUT_ATI_REMOTE2=y
> CONFIG_INPUT_KEYSPAN_REMOTE=y
> # CONFIG_INPUT_KXTJ9 is not set
> CONFIG_INPUT_POWERMATE=y
> CONFIG_INPUT_YEALINK=y
> CONFIG_INPUT_CM109=y
> CONFIG_INPUT_UINPUT=y
> CONFIG_INPUT_PCF50633_PMU=y
> # CONFIG_INPUT_PCF8574 is not set
> # CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
> # CONFIG_INPUT_ADXL34X is not set
> # CONFIG_INPUT_CMA3000 is not set
> CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_CT82C710=y
> CONFIG_SERIO_PARKBD=y
> CONFIG_SERIO_PCIPS2=y
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=y
> CONFIG_SERIO_ALTERA_PS2=y
> # CONFIG_SERIO_PS2MULT is not set
> CONFIG_GAMEPORT=y
> CONFIG_GAMEPORT_NS558=y
> CONFIG_GAMEPORT_L4=y
> CONFIG_GAMEPORT_EMU10K1=y
> CONFIG_GAMEPORT_FM801=y
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_VT_CONSOLE_SLEEP=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
> # CONFIG_LEGACY_PTYS is not set
> CONFIG_SERIAL_NONSTANDARD=y
> CONFIG_ROCKETPORT=y
> CONFIG_CYCLADES=y
> # CONFIG_CYZ_INTR is not set
> CONFIG_MOXA_INTELLIO=y
> CONFIG_MOXA_SMARTIO=y
> CONFIG_SYNCLINK=y
> CONFIG_SYNCLINKMP=y
> CONFIG_SYNCLINK_GT=y
> CONFIG_NOZOMI=y
> CONFIG_ISI=y
> CONFIG_N_HDLC=y
> CONFIG_N_GSM=y
> # CONFIG_TRACE_SINK is not set
> # CONFIG_DEVKMEM is not set
> CONFIG_STALDRV=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_CS=y
> CONFIG_SERIAL_8250_NR_UARTS=32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> CONFIG_SERIAL_8250_RSA=y
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_MAX3100=y
> # CONFIG_SERIAL_MAX310X is not set
> CONFIG_SERIAL_MFD_HSU=y
> # CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_JSM=y
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_IFX6X60 is not set
> CONFIG_SERIAL_PCH_UART=y
> # CONFIG_SERIAL_PCH_UART_CONSOLE is not set
> # CONFIG_SERIAL_ARC is not set
> CONFIG_PRINTER=y
> # CONFIG_LP_CONSOLE is not set
> CONFIG_PPDEV=y
> CONFIG_HVC_DRIVER=y
> CONFIG_HVC_IRQ=y
> CONFIG_HVC_XEN=y
> CONFIG_HVC_XEN_FRONTEND=y
> CONFIG_VIRTIO_CONSOLE=y
> CONFIG_IPMI_HANDLER=y
> # CONFIG_IPMI_PANIC_EVENT is not set
> CONFIG_IPMI_DEVICE_INTERFACE=y
> CONFIG_IPMI_SI=y
> CONFIG_IPMI_WATCHDOG=y
> CONFIG_IPMI_POWEROFF=y
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_TIMERIOMEM=y
> CONFIG_HW_RANDOM_INTEL=y
> CONFIG_HW_RANDOM_AMD=y
> CONFIG_HW_RANDOM_VIA=y
> CONFIG_HW_RANDOM_VIRTIO=y
> CONFIG_HW_RANDOM_TPM=y
> CONFIG_NVRAM=y
> CONFIG_R3964=y
> CONFIG_APPLICOM=y
> 
> #
> # PCMCIA character devices
> #
> CONFIG_SYNCLINK_CS=y
> CONFIG_CARDMAN_4000=y
> CONFIG_CARDMAN_4040=y
> CONFIG_IPWIRELESS=y
> CONFIG_MWAVE=y
> CONFIG_RAW_DRIVER=y
> CONFIG_MAX_RAW_DEVS=256
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> CONFIG_HANGCHECK_TIMER=y
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS=y
> # CONFIG_TCG_TIS_I2C_INFINEON is not set
> CONFIG_TCG_NSC=y
> CONFIG_TCG_ATMEL=y
> CONFIG_TCG_INFINEON=y
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=y
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=y
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCA=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> CONFIG_I2C_ALI1535=y
> CONFIG_I2C_ALI1563=y
> CONFIG_I2C_ALI15X3=y
> CONFIG_I2C_AMD756=y
> CONFIG_I2C_AMD756_S4882=y
> CONFIG_I2C_AMD8111=y
> CONFIG_I2C_I801=y
> CONFIG_I2C_ISCH=y
> CONFIG_I2C_PIIX4=y
> CONFIG_I2C_NFORCE2=y
> CONFIG_I2C_NFORCE2_S4985=y
> CONFIG_I2C_SIS5595=y
> CONFIG_I2C_SIS630=y
> CONFIG_I2C_SIS96X=y
> CONFIG_I2C_VIA=y
> CONFIG_I2C_VIAPRO=y
> 
> #
> # ACPI drivers
> #
> CONFIG_I2C_SCMI=y
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> CONFIG_I2C_EG20T=y
> # CONFIG_I2C_GPIO is not set
> # CONFIG_I2C_INTEL_MID is not set
> CONFIG_I2C_OCORES=y
> CONFIG_I2C_PCA_PLATFORM=y
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=y
> # CONFIG_I2C_XILINX is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_DIOLAN_U2C=y
> CONFIG_I2C_PARPORT=y
> CONFIG_I2C_PARPORT_LIGHT=y
> CONFIG_I2C_TAOS_EVM=y
> CONFIG_I2C_TINY_USB=y
> 
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_I2C_STUB=m
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> CONFIG_SPI=y
> # CONFIG_SPI_DEBUG is not set
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> # CONFIG_SPI_ALTERA is not set
> CONFIG_SPI_BITBANG=y
> CONFIG_SPI_BUTTERFLY=y
> # CONFIG_SPI_GPIO is not set
> CONFIG_SPI_LM70_LLP=y
> # CONFIG_SPI_OC_TINY is not set
> # CONFIG_SPI_PXA2XX_PCI is not set
> # CONFIG_SPI_SC18IS602 is not set
> CONFIG_SPI_TOPCLIFF_PCH=y
> # CONFIG_SPI_XCOMM is not set
> # CONFIG_SPI_XILINX is not set
> # CONFIG_SPI_DESIGNWARE is not set
> 
> #
> # SPI Protocol Masters
> #
> # CONFIG_SPI_SPIDEV is not set
> CONFIG_SPI_TLE62X0=y
> # CONFIG_HSI is not set
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> 
> #
> # PPS clients support
> #
> # CONFIG_PPS_CLIENT_KTIMER is not set
> CONFIG_PPS_CLIENT_LDISC=y
> CONFIG_PPS_CLIENT_PARPORT=y
> # CONFIG_PPS_CLIENT_GPIO is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=y
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> CONFIG_PTP_1588_CLOCK_PCH=y
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_ACPI=y
> # CONFIG_DEBUG_GPIO is not set
> # CONFIG_GPIO_SYSFS is not set
> 
> #
> # Memory mapped GPIO drivers:
> #
> # CONFIG_GPIO_GENERIC_PLATFORM is not set
> # CONFIG_GPIO_IT8761E is not set
> # CONFIG_GPIO_TS5500 is not set
> # CONFIG_GPIO_SCH is not set
> # CONFIG_GPIO_ICH is not set
> # CONFIG_GPIO_VX855 is not set
> 
> #
> # I2C GPIO expanders:
> #
> # CONFIG_GPIO_MAX7300 is not set
> # CONFIG_GPIO_MAX732X is not set
> # CONFIG_GPIO_PCA953X is not set
> # CONFIG_GPIO_PCF857X is not set
> # CONFIG_GPIO_SX150X is not set
> # CONFIG_GPIO_ADP5588 is not set
> 
> #
> # PCI GPIO expanders:
> #
> # CONFIG_GPIO_BT8XX is not set
> # CONFIG_GPIO_AMD8111 is not set
> # CONFIG_GPIO_LANGWELL is not set
> CONFIG_GPIO_PCH=y
> CONFIG_GPIO_ML_IOH=y
> # CONFIG_GPIO_RDC321X is not set
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MAX7301 is not set
> # CONFIG_GPIO_MCP23S08 is not set
> # CONFIG_GPIO_MC33880 is not set
> # CONFIG_GPIO_74X164 is not set
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # MODULbus GPIO expanders:
> #
> 
> #
> # USB GPIO expanders:
> #
> CONFIG_W1=y
> CONFIG_W1_CON=y
> 
> #
> # 1-wire Bus Masters
> #
> CONFIG_W1_MASTER_MATROX=y
> CONFIG_W1_MASTER_DS2490=y
> CONFIG_W1_MASTER_DS2482=y
> # CONFIG_W1_MASTER_DS1WM is not set
> # CONFIG_W1_MASTER_GPIO is not set
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=y
> CONFIG_W1_SLAVE_SMEM=y
> # CONFIG_W1_SLAVE_DS2408 is not set
> # CONFIG_W1_SLAVE_DS2423 is not set
> CONFIG_W1_SLAVE_DS2431=y
> CONFIG_W1_SLAVE_DS2433=y
> # CONFIG_W1_SLAVE_DS2433_CRC is not set
> CONFIG_W1_SLAVE_DS2760=y
> # CONFIG_W1_SLAVE_DS2780 is not set
> # CONFIG_W1_SLAVE_DS2781 is not set
> # CONFIG_W1_SLAVE_DS28E04 is not set
> CONFIG_W1_SLAVE_BQ27000=y
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> CONFIG_PDA_POWER=y
> # CONFIG_TEST_POWER is not set
> CONFIG_BATTERY_DS2760=y
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> CONFIG_BATTERY_DS2782=y
> # CONFIG_BATTERY_WM97XX is not set
> # CONFIG_BATTERY_SBS is not set
> CONFIG_BATTERY_BQ27x00=y
> CONFIG_BATTERY_BQ27X00_I2C=y
> CONFIG_BATTERY_BQ27X00_PLATFORM=y
> CONFIG_BATTERY_MAX17040=y
> # CONFIG_BATTERY_MAX17042 is not set
> CONFIG_CHARGER_PCF50633=y
> # CONFIG_CHARGER_ISP1704 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_LP8727 is not set
> # CONFIG_CHARGER_GPIO is not set
> # CONFIG_CHARGER_MANAGER is not set
> # CONFIG_CHARGER_BQ2415X is not set
> # CONFIG_CHARGER_SMB347 is not set
> # CONFIG_POWER_RESET is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_ABITUGURU=y
> CONFIG_SENSORS_ABITUGURU3=y
> # CONFIG_SENSORS_AD7314 is not set
> CONFIG_SENSORS_AD7414=y
> CONFIG_SENSORS_AD7418=y
> CONFIG_SENSORS_ADCXX=y
> CONFIG_SENSORS_ADM1021=y
> CONFIG_SENSORS_ADM1025=y
> CONFIG_SENSORS_ADM1026=y
> CONFIG_SENSORS_ADM1029=y
> CONFIG_SENSORS_ADM1031=y
> CONFIG_SENSORS_ADM9240=y
> # CONFIG_SENSORS_ADT7410 is not set
> CONFIG_SENSORS_ADT7411=y
> CONFIG_SENSORS_ADT7462=y
> CONFIG_SENSORS_ADT7470=y
> CONFIG_SENSORS_ADT7475=y
> CONFIG_SENSORS_ASC7621=y
> CONFIG_SENSORS_K8TEMP=y
> CONFIG_SENSORS_K10TEMP=y
> CONFIG_SENSORS_FAM15H_POWER=y
> CONFIG_SENSORS_ASB100=y
> CONFIG_SENSORS_ATXP1=y
> CONFIG_SENSORS_DS620=y
> CONFIG_SENSORS_DS1621=y
> CONFIG_SENSORS_I5K_AMB=y
> CONFIG_SENSORS_F71805F=y
> CONFIG_SENSORS_F71882FG=y
> CONFIG_SENSORS_F75375S=y
> CONFIG_SENSORS_FSCHMD=y
> CONFIG_SENSORS_G760A=y
> CONFIG_SENSORS_GL518SM=y
> CONFIG_SENSORS_GL520SM=y
> # CONFIG_SENSORS_GPIO_FAN is not set
> # CONFIG_SENSORS_HIH6130 is not set
> CONFIG_SENSORS_CORETEMP=y
> CONFIG_SENSORS_IBMAEM=y
> CONFIG_SENSORS_IBMPEX=y
> CONFIG_SENSORS_IT87=y
> # CONFIG_SENSORS_JC42 is not set
> CONFIG_SENSORS_LINEAGE=y
> CONFIG_SENSORS_LM63=y
> CONFIG_SENSORS_LM70=y
> CONFIG_SENSORS_LM73=y
> CONFIG_SENSORS_LM75=y
> CONFIG_SENSORS_LM77=y
> CONFIG_SENSORS_LM78=y
> CONFIG_SENSORS_LM80=y
> CONFIG_SENSORS_LM83=y
> CONFIG_SENSORS_LM85=y
> CONFIG_SENSORS_LM87=y
> CONFIG_SENSORS_LM90=y
> CONFIG_SENSORS_LM92=y
> CONFIG_SENSORS_LM93=y
> CONFIG_SENSORS_LTC4151=y
> CONFIG_SENSORS_LTC4215=y
> CONFIG_SENSORS_LTC4245=y
> CONFIG_SENSORS_LTC4261=y
> CONFIG_SENSORS_LM95241=y
> CONFIG_SENSORS_LM95245=y
> CONFIG_SENSORS_MAX1111=y
> CONFIG_SENSORS_MAX16065=y
> CONFIG_SENSORS_MAX1619=y
> CONFIG_SENSORS_MAX1668=y
> # CONFIG_SENSORS_MAX197 is not set
> CONFIG_SENSORS_MAX6639=y
> CONFIG_SENSORS_MAX6642=y
> CONFIG_SENSORS_MAX6650=y
> # CONFIG_SENSORS_MCP3021 is not set
> CONFIG_SENSORS_NTC_THERMISTOR=y
> CONFIG_SENSORS_PC87360=y
> CONFIG_SENSORS_PC87427=y
> CONFIG_SENSORS_PCF8591=y
> # CONFIG_PMBUS is not set
> # CONFIG_SENSORS_SHT15 is not set
> CONFIG_SENSORS_SHT21=y
> CONFIG_SENSORS_SIS5595=y
> CONFIG_SENSORS_SMM665=y
> CONFIG_SENSORS_DME1737=y
> CONFIG_SENSORS_EMC1403=y
> CONFIG_SENSORS_EMC2103=y
> CONFIG_SENSORS_EMC6W201=y
> CONFIG_SENSORS_SMSC47M1=y
> CONFIG_SENSORS_SMSC47M192=y
> CONFIG_SENSORS_SMSC47B397=y
> CONFIG_SENSORS_SCH56XX_COMMON=y
> CONFIG_SENSORS_SCH5627=y
> # CONFIG_SENSORS_SCH5636 is not set
> CONFIG_SENSORS_ADS1015=y
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_ADS7871=y
> CONFIG_SENSORS_AMC6821=y
> # CONFIG_SENSORS_INA2XX is not set
> CONFIG_SENSORS_THMC50=y
> CONFIG_SENSORS_TMP102=y
> CONFIG_SENSORS_TMP401=y
> CONFIG_SENSORS_TMP421=y
> CONFIG_SENSORS_VIA_CPUTEMP=y
> CONFIG_SENSORS_VIA686A=y
> CONFIG_SENSORS_VT1211=y
> CONFIG_SENSORS_VT8231=y
> CONFIG_SENSORS_W83781D=y
> CONFIG_SENSORS_W83791D=y
> CONFIG_SENSORS_W83792D=y
> CONFIG_SENSORS_W83793=y
> CONFIG_SENSORS_W83795=y
> # CONFIG_SENSORS_W83795_FANCTRL is not set
> CONFIG_SENSORS_W83L785TS=y
> CONFIG_SENSORS_W83L786NG=y
> CONFIG_SENSORS_W83627HF=y
> CONFIG_SENSORS_W83627EHF=y
> CONFIG_SENSORS_APPLESMC=y
> 
> #
> # ACPI drivers
> #
> CONFIG_SENSORS_ACPI_POWER=y
> CONFIG_SENSORS_ATK0110=y
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_FAIR_SHARE is not set
> CONFIG_STEP_WISE=y
> # CONFIG_USER_SPACE is not set
> # CONFIG_CPU_THERMAL is not set
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=y
> CONFIG_ACQUIRE_WDT=y
> CONFIG_ADVANTECH_WDT=y
> CONFIG_ALIM1535_WDT=y
> CONFIG_ALIM7101_WDT=y
> CONFIG_F71808E_WDT=y
> CONFIG_SP5100_TCO=y
> CONFIG_SC520_WDT=y
> CONFIG_SBC_FITPC2_WATCHDOG=y
> # CONFIG_EUROTECH_WDT is not set
> CONFIG_IB700_WDT=y
> CONFIG_IBMASR=y
> CONFIG_WAFER_WDT=y
> CONFIG_I6300ESB_WDT=y
> # CONFIG_IE6XX_WDT is not set
> CONFIG_ITCO_WDT=y
> CONFIG_ITCO_VENDOR_SUPPORT=y
> CONFIG_IT8712F_WDT=y
> CONFIG_IT87_WDT=y
> CONFIG_HP_WATCHDOG=y
> CONFIG_HPWDT_NMI_DECODING=y
> CONFIG_SC1200_WDT=y
> CONFIG_PC87413_WDT=y
> CONFIG_NV_TCO=y
> CONFIG_60XX_WDT=y
> CONFIG_SBC8360_WDT=y
> CONFIG_CPU5_WDT=y
> CONFIG_SMSC_SCH311X_WDT=y
> CONFIG_SMSC37B787_WDT=y
> # CONFIG_VIA_WDT is not set
> CONFIG_W83627HF_WDT=y
> CONFIG_W83697HF_WDT=y
> CONFIG_W83697UG_WDT=y
> CONFIG_W83877F_WDT=y
> CONFIG_W83977F_WDT=y
> CONFIG_MACHZ_WDT=y
> CONFIG_SBC_EPX_C3_WATCHDOG=y
> CONFIG_XEN_WDT=y
> 
> #
> # PCI-based Watchdog Cards
> #
> CONFIG_PCIPCWATCHDOG=y
> CONFIG_WDTPCI=y
> 
> #
> # USB-based Watchdog Cards
> #
> CONFIG_USBPCWATCHDOG=y
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=y
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_BLOCKIO=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> CONFIG_SSB_B43_PCI_BRIDGE=y
> CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
> CONFIG_SSB_PCMCIAHOST=y
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> CONFIG_SSB_SDIOHOST=y
> # CONFIG_SSB_DEBUG is not set
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> # CONFIG_SSB_DRIVER_GPIO is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_BLOCKIO=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> # CONFIG_BCMA_DRIVER_GMAC_CMN is not set
> # CONFIG_BCMA_DRIVER_GPIO is not set
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> # CONFIG_MFD_88PM860X is not set
> # CONFIG_MFD_88PM800 is not set
> # CONFIG_MFD_88PM805 is not set
> CONFIG_MFD_SM501=y
> # CONFIG_MFD_SM501_GPIO is not set
> # CONFIG_MFD_RTSX_PCI is not set
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> CONFIG_HTC_PASIC3=y
> # CONFIG_HTC_I2CPLD is not set
> # CONFIG_UCB1400_CORE is not set
> # CONFIG_MFD_LM3533 is not set
> # CONFIG_TPS6105X is not set
> CONFIG_TPS65010=y
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TPS65217 is not set
> # CONFIG_MFD_TPS6586X is not set
> # CONFIG_MFD_TPS65910 is not set
> # CONFIG_MFD_TPS65912_I2C is not set
> # CONFIG_MFD_TPS65912_SPI is not set
> # CONFIG_MFD_TPS80031 is not set
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_TWL6040_CORE is not set
> # CONFIG_MFD_STMPE is not set
> # CONFIG_MFD_TC3589X is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_SMSC is not set
> # CONFIG_PMIC_DA903X is not set
> # CONFIG_MFD_DA9052_SPI is not set
> # CONFIG_MFD_DA9052_I2C is not set
> # CONFIG_MFD_DA9055 is not set
> # CONFIG_PMIC_ADP5520 is not set
> # CONFIG_MFD_LP8788 is not set
> # CONFIG_MFD_MAX77686 is not set
> # CONFIG_MFD_MAX77693 is not set
> # CONFIG_MFD_MAX8907 is not set
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> # CONFIG_MFD_MAX8998 is not set
> # CONFIG_MFD_SEC_CORE is not set
> # CONFIG_MFD_ARIZONA_I2C is not set
> # CONFIG_MFD_ARIZONA_SPI is not set
> CONFIG_MFD_WM8400=y
> # CONFIG_MFD_WM831X_I2C is not set
> # CONFIG_MFD_WM831X_SPI is not set
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_MFD_WM8994 is not set
> CONFIG_MFD_PCF50633=y
> CONFIG_PCF50633_ADC=y
> CONFIG_PCF50633_GPIO=y
> # CONFIG_MFD_MC13XXX_SPI is not set
> # CONFIG_MFD_MC13XXX_I2C is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_EZX_PCAP is not set
> # CONFIG_MFD_CS5535 is not set
> # CONFIG_MFD_TIMBERDALE is not set
> CONFIG_LPC_SCH=y
> CONFIG_LPC_ICH=y
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_WL1273_CORE=y
> # CONFIG_MFD_TPS65090 is not set
> # CONFIG_MFD_AAT2870_CORE is not set
> # CONFIG_MFD_RC5T583 is not set
> # CONFIG_MFD_PALMAS is not set
> # CONFIG_MFD_VIPERBOARD is not set
> # CONFIG_MFD_RETU is not set
> # CONFIG_MFD_AS3711 is not set
> CONFIG_REGULATOR=y
> # CONFIG_REGULATOR_DEBUG is not set
> # CONFIG_REGULATOR_DUMMY is not set
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> # CONFIG_REGULATOR_GPIO is not set
> # CONFIG_REGULATOR_AD5398 is not set
> # CONFIG_REGULATOR_FAN53555 is not set
> # CONFIG_REGULATOR_ISL6271A is not set
> CONFIG_REGULATOR_MAX1586=y
> CONFIG_REGULATOR_MAX8649=y
> CONFIG_REGULATOR_MAX8660=y
> # CONFIG_REGULATOR_MAX8952 is not set
> # CONFIG_REGULATOR_MAX8973 is not set
> CONFIG_REGULATOR_LP3971=y
> # CONFIG_REGULATOR_LP3972 is not set
> # CONFIG_REGULATOR_LP872X is not set
> CONFIG_REGULATOR_PCF50633=y
> # CONFIG_REGULATOR_TPS51632 is not set
> # CONFIG_REGULATOR_TPS62360 is not set
> CONFIG_REGULATOR_TPS65023=y
> CONFIG_REGULATOR_TPS6507X=y
> # CONFIG_REGULATOR_TPS6524X is not set
> CONFIG_REGULATOR_WM8400=y
> CONFIG_MEDIA_SUPPORT=y
> 
> #
> # Multimedia core support
> #
> # CONFIG_MEDIA_CAMERA_SUPPORT is not set
> # CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
> # CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
> # CONFIG_MEDIA_RADIO_SUPPORT is not set
> # CONFIG_MEDIA_RC_SUPPORT is not set
> # CONFIG_VIDEO_ADV_DEBUG is not set
> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> 
> #
> # Media drivers
> #
> # CONFIG_MEDIA_USB_SUPPORT is not set
> # CONFIG_MEDIA_PCI_SUPPORT is not set
> 
> #
> # Supported MMC/SDIO adapters
> #
> 
> #
> # Media ancillary drivers (tuners, sensors, i2c, frontends)
> #
> 
> #
> # Customise DVB Frontends
> #
> CONFIG_DVB_TUNER_DIB0070=y
> CONFIG_DVB_TUNER_DIB0090=y
> 
> #
> # Tools to develop new frontends
> #
> # CONFIG_DVB_DUMMY_FE is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_AMD64=y
> CONFIG_AGP_INTEL=y
> CONFIG_AGP_SIS=y
> CONFIG_AGP_VIA=y
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> CONFIG_VGA_SWITCHEROO=y
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
> # CONFIG_DRM_TTM is not set
> CONFIG_DRM_TDFX=y
> CONFIG_DRM_R128=y
> CONFIG_DRM_RADEON=y
> CONFIG_DRM_RADEON_KMS=y
> CONFIG_DRM_NOUVEAU=y
> CONFIG_NOUVEAU_DEBUG=5
> CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> 
> #
> # I2C encoder or helper chips
> #
> CONFIG_DRM_I2C_CH7006=y
> CONFIG_DRM_I2C_SIL164=y
> # CONFIG_DRM_I810 is not set
> CONFIG_DRM_I915=y
> CONFIG_DRM_I915_KMS=y
> CONFIG_DRM_MGA=y
> CONFIG_DRM_SIS=y
> CONFIG_DRM_VIA=y
> CONFIG_DRM_SAVAGE=y
> CONFIG_DRM_VMWGFX=y
> # CONFIG_DRM_VMWGFX_FBCON is not set
> # CONFIG_DRM_GMA500 is not set
> # CONFIG_DRM_UDL is not set
> # CONFIG_DRM_AST is not set
> # CONFIG_DRM_MGAG200 is not set
> # CONFIG_DRM_CIRRUS_QEMU is not set
> # CONFIG_STUB_POULSBO is not set
> CONFIG_VGASTATE=y
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=y
> CONFIG_FB_BOOT_VESA_SUPPORT=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> # CONFIG_FB_WMT_GE_ROPS is not set
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_HECUBA=y
> CONFIG_FB_SVGALIB=y
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> CONFIG_FB_PM2=y
> CONFIG_FB_PM2_FIFO_DISCONNECT=y
> CONFIG_FB_CYBER2000=y
> CONFIG_FB_CYBER2000_DDC=y
> CONFIG_FB_ARC=y
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_UVESA=y
> CONFIG_FB_VESA=y
> CONFIG_FB_EFI=y
> CONFIG_FB_N411=y
> CONFIG_FB_HGA=y
> CONFIG_FB_S1D13XXX=y
> CONFIG_FB_NVIDIA=y
> # CONFIG_FB_NVIDIA_I2C is not set
> # CONFIG_FB_NVIDIA_DEBUG is not set
> CONFIG_FB_NVIDIA_BACKLIGHT=y
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_I740 is not set
> CONFIG_FB_LE80578=y
> CONFIG_FB_CARILLO_RANCH=y
> CONFIG_FB_MATROX=y
> CONFIG_FB_MATROX_MILLENIUM=y
> CONFIG_FB_MATROX_MYSTIQUE=y
> CONFIG_FB_MATROX_G=y
> CONFIG_FB_MATROX_I2C=y
> CONFIG_FB_MATROX_MAVEN=y
> CONFIG_FB_RADEON=y
> CONFIG_FB_RADEON_I2C=y
> CONFIG_FB_RADEON_BACKLIGHT=y
> # CONFIG_FB_RADEON_DEBUG is not set
> CONFIG_FB_ATY128=y
> CONFIG_FB_ATY128_BACKLIGHT=y
> CONFIG_FB_ATY=y
> CONFIG_FB_ATY_CT=y
> # CONFIG_FB_ATY_GENERIC_LCD is not set
> CONFIG_FB_ATY_GX=y
> CONFIG_FB_ATY_BACKLIGHT=y
> CONFIG_FB_S3=y
> CONFIG_FB_S3_DDC=y
> CONFIG_FB_SAVAGE=y
> # CONFIG_FB_SAVAGE_I2C is not set
> # CONFIG_FB_SAVAGE_ACCEL is not set
> CONFIG_FB_SIS=y
> CONFIG_FB_SIS_300=y
> CONFIG_FB_SIS_315=y
> CONFIG_FB_VIA=y
> # CONFIG_FB_VIA_DIRECT_PROCFS is not set
> CONFIG_FB_VIA_X_COMPATIBILITY=y
> CONFIG_FB_NEOMAGIC=y
> CONFIG_FB_KYRO=y
> CONFIG_FB_3DFX=y
> # CONFIG_FB_3DFX_ACCEL is not set
> CONFIG_FB_3DFX_I2C=y
> CONFIG_FB_VOODOO1=y
> CONFIG_FB_VT8623=y
> CONFIG_FB_TRIDENT=y
> CONFIG_FB_ARK=y
> CONFIG_FB_PM3=y
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_GEODE is not set
> # CONFIG_FB_TMIO is not set
> CONFIG_FB_SM501=y
> # CONFIG_FB_SMSCUFX is not set
> CONFIG_FB_UDL=y
> CONFIG_FB_VIRTUAL=y
> CONFIG_XEN_FBDEV_FRONTEND=y
> CONFIG_FB_METRONOME=y
> CONFIG_FB_MB862XX=y
> CONFIG_FB_MB862XX_PCI_GDC=y
> CONFIG_FB_MB862XX_I2C=y
> # CONFIG_FB_BROADSHEET is not set
> # CONFIG_FB_AUO_K190X is not set
> # CONFIG_EXYNOS_VIDEO is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> # CONFIG_LCD_CLASS_DEVICE is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> # CONFIG_BACKLIGHT_GENERIC is not set
> CONFIG_BACKLIGHT_APPLE=y
> # CONFIG_BACKLIGHT_SAHARA is not set
> # CONFIG_BACKLIGHT_ADP8860 is not set
> # CONFIG_BACKLIGHT_ADP8870 is not set
> # CONFIG_BACKLIGHT_PCF50633 is not set
> # CONFIG_BACKLIGHT_LM3630 is not set
> # CONFIG_BACKLIGHT_LM3639 is not set
> # CONFIG_BACKLIGHT_LP855X is not set
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> # CONFIG_LOGO is not set
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
> CONFIG_SND=y
> CONFIG_SND_TIMER=y
> CONFIG_SND_PCM=y
> CONFIG_SND_HWDEP=y
> CONFIG_SND_RAWMIDI=y
> CONFIG_SND_JACK=y
> CONFIG_SND_SEQUENCER=y
> CONFIG_SND_SEQ_DUMMY=y
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=y
> CONFIG_SND_PCM_OSS=y
> CONFIG_SND_PCM_OSS_PLUGINS=y
> # CONFIG_SND_SEQUENCER_OSS is not set
> CONFIG_SND_HRTIMER=y
> CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
> CONFIG_SND_DYNAMIC_MINORS=y
> CONFIG_SND_SUPPORT_OLD_API=y
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_VMASTER=y
> CONFIG_SND_KCTL_JACK=y
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=y
> CONFIG_SND_OPL3_LIB_SEQ=y
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> CONFIG_SND_EMU10K1_SEQ=y
> CONFIG_SND_MPU401_UART=y
> CONFIG_SND_OPL3_LIB=y
> CONFIG_SND_VX_LIB=y
> CONFIG_SND_AC97_CODEC=y
> CONFIG_SND_DRIVERS=y
> CONFIG_SND_PCSP=y
> CONFIG_SND_DUMMY=y
> CONFIG_SND_ALOOP=y
> CONFIG_SND_VIRMIDI=y
> CONFIG_SND_MTPAV=y
> CONFIG_SND_MTS64=y
> CONFIG_SND_SERIAL_U16550=y
> CONFIG_SND_MPU401=y
> CONFIG_SND_PORTMAN2X4=y
> CONFIG_SND_AC97_POWER_SAVE=y
> CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
> CONFIG_SND_SB_COMMON=y
> CONFIG_SND_SB16_DSP=y
> CONFIG_SND_PCI=y
> CONFIG_SND_AD1889=y
> CONFIG_SND_ALS300=y
> CONFIG_SND_ALS4000=y
> CONFIG_SND_ALI5451=y
> CONFIG_SND_ASIHPI=y
> CONFIG_SND_ATIIXP=y
> CONFIG_SND_ATIIXP_MODEM=y
> CONFIG_SND_AU8810=y
> CONFIG_SND_AU8820=y
> CONFIG_SND_AU8830=y
> # CONFIG_SND_AW2 is not set
> CONFIG_SND_AZT3328=y
> CONFIG_SND_BT87X=y
> # CONFIG_SND_BT87X_OVERCLOCK is not set
> CONFIG_SND_CA0106=y
> CONFIG_SND_CMIPCI=y
> CONFIG_SND_OXYGEN_LIB=y
> CONFIG_SND_OXYGEN=y
> CONFIG_SND_CS4281=y
> CONFIG_SND_CS46XX=y
> CONFIG_SND_CS46XX_NEW_DSP=y
> CONFIG_SND_CS5530=y
> CONFIG_SND_CS5535AUDIO=y
> CONFIG_SND_CTXFI=y
> CONFIG_SND_DARLA20=y
> CONFIG_SND_GINA20=y
> CONFIG_SND_LAYLA20=y
> CONFIG_SND_DARLA24=y
> CONFIG_SND_GINA24=y
> CONFIG_SND_LAYLA24=y
> CONFIG_SND_MONA=y
> CONFIG_SND_MIA=y
> CONFIG_SND_ECHO3G=y
> CONFIG_SND_INDIGO=y
> CONFIG_SND_INDIGOIO=y
> CONFIG_SND_INDIGODJ=y
> CONFIG_SND_INDIGOIOX=y
> CONFIG_SND_INDIGODJX=y
> CONFIG_SND_EMU10K1=y
> CONFIG_SND_EMU10K1X=y
> CONFIG_SND_ENS1370=y
> CONFIG_SND_ENS1371=y
> CONFIG_SND_ES1938=y
> CONFIG_SND_ES1968=y
> CONFIG_SND_ES1968_INPUT=y
> CONFIG_SND_FM801=y
> CONFIG_SND_HDA_INTEL=y
> CONFIG_SND_HDA_PREALLOC_SIZE=64
> CONFIG_SND_HDA_HWDEP=y
> CONFIG_SND_HDA_RECONFIG=y
> CONFIG_SND_HDA_INPUT_BEEP=y
> CONFIG_SND_HDA_INPUT_BEEP_MODE=1
> CONFIG_SND_HDA_INPUT_JACK=y
> CONFIG_SND_HDA_PATCH_LOADER=y
> CONFIG_SND_HDA_CODEC_REALTEK=y
> CONFIG_SND_HDA_CODEC_ANALOG=y
> CONFIG_SND_HDA_CODEC_SIGMATEL=y
> CONFIG_SND_HDA_CODEC_VIA=y
> CONFIG_SND_HDA_CODEC_HDMI=y
> CONFIG_SND_HDA_CODEC_CIRRUS=y
> CONFIG_SND_HDA_CODEC_CONEXANT=y
> CONFIG_SND_HDA_CODEC_CA0110=y
> CONFIG_SND_HDA_CODEC_CA0132=y
> CONFIG_SND_HDA_CODEC_CMEDIA=y
> CONFIG_SND_HDA_CODEC_SI3054=y
> CONFIG_SND_HDA_GENERIC=y
> CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
> CONFIG_SND_HDSP=y
> 
> #
> # Don't forget to add built-in firmwares for HDSP driver
> #
> CONFIG_SND_HDSPM=y
> CONFIG_SND_ICE1712=y
> CONFIG_SND_ICE1724=y
> CONFIG_SND_INTEL8X0=y
> CONFIG_SND_INTEL8X0M=y
> CONFIG_SND_KORG1212=y
> CONFIG_SND_LOLA=y
> CONFIG_SND_LX6464ES=y
> CONFIG_SND_MAESTRO3=y
> CONFIG_SND_MAESTRO3_INPUT=y
> CONFIG_SND_MIXART=y
> CONFIG_SND_NM256=y
> CONFIG_SND_PCXHR=y
> CONFIG_SND_RIPTIDE=y
> CONFIG_SND_RME32=y
> CONFIG_SND_RME96=y
> CONFIG_SND_RME9652=y
> CONFIG_SND_SONICVIBES=y
> CONFIG_SND_TRIDENT=y
> CONFIG_SND_VIA82XX=y
> CONFIG_SND_VIA82XX_MODEM=y
> CONFIG_SND_VIRTUOSO=y
> CONFIG_SND_VX222=y
> CONFIG_SND_YMFPCI=y
> CONFIG_SND_SPI=y
> CONFIG_SND_USB=y
> CONFIG_SND_USB_AUDIO=y
> CONFIG_SND_USB_UA101=y
> CONFIG_SND_USB_USX2Y=y
> CONFIG_SND_USB_CAIAQ=y
> CONFIG_SND_USB_CAIAQ_INPUT=y
> CONFIG_SND_USB_US122L=y
> CONFIG_SND_USB_6FIRE=y
> CONFIG_SND_FIREWIRE=y
> CONFIG_SND_FIREWIRE_LIB=y
> CONFIG_SND_FIREWIRE_SPEAKERS=y
> CONFIG_SND_ISIGHT=y
> # CONFIG_SND_SCS1X is not set
> CONFIG_SND_PCMCIA=y
> CONFIG_SND_VXPOCKET=y
> CONFIG_SND_PDAUDIOCF=y
> # CONFIG_SND_SOC is not set
> # CONFIG_SOUND_PRIME is not set
> CONFIG_AC97_BUS=y
> 
> #
> # HID support
> #
> CONFIG_HID=y
> CONFIG_HID_BATTERY_STRENGTH=y
> CONFIG_HIDRAW=y
> # CONFIG_UHID is not set
> CONFIG_HID_GENERIC=y
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> CONFIG_HID_ACRUX=y
> # CONFIG_HID_ACRUX_FF is not set
> CONFIG_HID_APPLE=y
> # CONFIG_HID_AUREAL is not set
> CONFIG_HID_BELKIN=y
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> CONFIG_HID_PRODIKEYS=y
> CONFIG_HID_CYPRESS=y
> CONFIG_HID_DRAGONRISE=y
> CONFIG_DRAGONRISE_FF=y
> CONFIG_HID_EMS_FF=y
> CONFIG_HID_ELECOM=y
> CONFIG_HID_EZKEY=y
> # CONFIG_HID_HOLTEK is not set
> CONFIG_HID_KEYTOUCH=y
> CONFIG_HID_KYE=y
> CONFIG_HID_UCLOGIC=y
> CONFIG_HID_WALTOP=y
> CONFIG_HID_GYRATION=y
> # CONFIG_HID_ICADE is not set
> CONFIG_HID_TWINHAN=y
> CONFIG_HID_KENSINGTON=y
> CONFIG_HID_LCPOWER=y
> # CONFIG_HID_LENOVO_TPKBD is not set
> CONFIG_HID_LOGITECH=y
> CONFIG_HID_LOGITECH_DJ=y
> CONFIG_LOGITECH_FF=y
> CONFIG_LOGIRUMBLEPAD2_FF=y
> CONFIG_LOGIG940_FF=y
> CONFIG_LOGIWHEELS_FF=y
> CONFIG_HID_MAGICMOUSE=y
> CONFIG_HID_MICROSOFT=y
> CONFIG_HID_MONTEREY=y
> CONFIG_HID_MULTITOUCH=y
> CONFIG_HID_NTRIG=y
> CONFIG_HID_ORTEK=y
> CONFIG_HID_PANTHERLORD=y
> CONFIG_PANTHERLORD_FF=y
> CONFIG_HID_PETALYNX=y
> CONFIG_HID_PICOLCD=y
> CONFIG_HID_PICOLCD_FB=y
> CONFIG_HID_PICOLCD_BACKLIGHT=y
> CONFIG_HID_PICOLCD_LEDS=y
> # CONFIG_HID_PRIMAX is not set
> # CONFIG_HID_PS3REMOTE is not set
> CONFIG_HID_ROCCAT=y
> # CONFIG_HID_SAITEK is not set
> CONFIG_HID_SAMSUNG=y
> CONFIG_HID_SONY=y
> # CONFIG_HID_SPEEDLINK is not set
> CONFIG_HID_SUNPLUS=y
> CONFIG_HID_GREENASIA=y
> CONFIG_GREENASIA_FF=y
> # CONFIG_HID_HYPERV_MOUSE is not set
> CONFIG_HID_SMARTJOYPLUS=y
> CONFIG_SMARTJOYPLUS_FF=y
> # CONFIG_HID_TIVO is not set
> CONFIG_HID_TOPSEED=y
> CONFIG_HID_THRUSTMASTER=y
> CONFIG_THRUSTMASTER_FF=y
> CONFIG_HID_WACOM=y
> # CONFIG_HID_WIIMOTE is not set
> CONFIG_HID_ZEROPLUS=y
> CONFIG_ZEROPLUS_FF=y
> CONFIG_HID_ZYDACRON=y
> # CONFIG_HID_SENSOR_HUB is not set
> 
> #
> # USB HID support
> #
> CONFIG_USB_HID=y
> CONFIG_HID_PID=y
> CONFIG_USB_HIDDEV=y
> 
> #
> # I2C HID support
> #
> # CONFIG_I2C_HID is not set
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB_ARCH_HAS_XHCI=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DYNAMIC_MINORS=y
> CONFIG_USB_SUSPEND=y
> # CONFIG_USB_OTG is not set
> # CONFIG_USB_DWC3 is not set
> CONFIG_USB_MON=y
> CONFIG_USB_WUSB=y
> CONFIG_USB_WUSB_CBAF=y
> # CONFIG_USB_WUSB_CBAF_DEBUG is not set
> 
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_C67X00_HCD=y
> CONFIG_USB_XHCI_HCD=y
> # CONFIG_USB_XHCI_HCD_DEBUGGING is not set
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_USB_EHCI_PCI=y
> # CONFIG_USB_OXU210HP_HCD is not set
> CONFIG_USB_ISP116X_HCD=y
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_ISP1362_HCD is not set
> CONFIG_USB_OHCI_HCD=y
> # CONFIG_USB_OHCI_HCD_SSB is not set
> # CONFIG_USB_OHCI_HCD_PLATFORM is not set
> # CONFIG_USB_EHCI_HCD_PLATFORM is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_UHCI_HCD=y
> CONFIG_USB_U132_HCD=y
> CONFIG_USB_SL811_HCD=y
> # CONFIG_USB_SL811_HCD_ISO is not set
> CONFIG_USB_SL811_CS=y
> CONFIG_USB_R8A66597_HCD=y
> CONFIG_USB_WHCI_HCD=y
> CONFIG_USB_HWA_HCD=y
> # CONFIG_USB_HCD_BCMA is not set
> # CONFIG_USB_HCD_SSB is not set
> # CONFIG_USB_MUSB_HDRC is not set
> # CONFIG_USB_CHIPIDEA is not set
> # CONFIG_USB_RENESAS_USBHS is not set
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=y
> CONFIG_USB_PRINTER=y
> CONFIG_USB_WDM=y
> CONFIG_USB_TMC=y
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=y
> # CONFIG_USB_STORAGE_DEBUG is not set
> CONFIG_USB_STORAGE_REALTEK=y
> CONFIG_REALTEK_AUTOPM=y
> CONFIG_USB_STORAGE_DATAFAB=y
> CONFIG_USB_STORAGE_FREECOM=y
> CONFIG_USB_STORAGE_ISD200=y
> CONFIG_USB_STORAGE_USBAT=y
> CONFIG_USB_STORAGE_SDDR09=y
> CONFIG_USB_STORAGE_SDDR55=y
> CONFIG_USB_STORAGE_JUMPSHOT=y
> CONFIG_USB_STORAGE_ALAUDA=y
> CONFIG_USB_STORAGE_ONETOUCH=y
> CONFIG_USB_STORAGE_KARMA=y
> CONFIG_USB_STORAGE_CYPRESS_ATACB=y
> CONFIG_USB_STORAGE_ENE_UB6250=y
> 
> #
> # USB Imaging devices
> #
> CONFIG_USB_MDC800=y
> CONFIG_USB_MICROTEK=y
> 
> #
> # USB port drivers
> #
> CONFIG_USB_USS720=y
> CONFIG_USB_SERIAL=y
> # CONFIG_USB_SERIAL_CONSOLE is not set
> CONFIG_USB_SERIAL_GENERIC=y
> CONFIG_USB_SERIAL_AIRCABLE=y
> CONFIG_USB_SERIAL_ARK3116=y
> CONFIG_USB_SERIAL_BELKIN=y
> CONFIG_USB_SERIAL_CH341=y
> CONFIG_USB_SERIAL_WHITEHEAT=y
> CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
> CONFIG_USB_SERIAL_CP210X=y
> CONFIG_USB_SERIAL_CYPRESS_M8=y
> CONFIG_USB_SERIAL_EMPEG=y
> CONFIG_USB_SERIAL_FTDI_SIO=y
> CONFIG_USB_SERIAL_FUNSOFT=y
> CONFIG_USB_SERIAL_VISOR=y
> CONFIG_USB_SERIAL_IPAQ=y
> CONFIG_USB_SERIAL_IR=y
> CONFIG_USB_SERIAL_EDGEPORT=y
> CONFIG_USB_SERIAL_EDGEPORT_TI=y
> # CONFIG_USB_SERIAL_F81232 is not set
> CONFIG_USB_SERIAL_GARMIN=y
> CONFIG_USB_SERIAL_IPW=y
> CONFIG_USB_SERIAL_IUU=y
> CONFIG_USB_SERIAL_KEYSPAN_PDA=y
> CONFIG_USB_SERIAL_KEYSPAN=y
> CONFIG_USB_SERIAL_KLSI=y
> CONFIG_USB_SERIAL_KOBIL_SCT=y
> CONFIG_USB_SERIAL_MCT_U232=y
> # CONFIG_USB_SERIAL_METRO is not set
> CONFIG_USB_SERIAL_MOS7720=y
> CONFIG_USB_SERIAL_MOS7715_PARPORT=y
> CONFIG_USB_SERIAL_MOS7840=y
> CONFIG_USB_SERIAL_MOTOROLA=y
> CONFIG_USB_SERIAL_NAVMAN=y
> CONFIG_USB_SERIAL_PL2303=y
> CONFIG_USB_SERIAL_OTI6858=y
> CONFIG_USB_SERIAL_QCAUX=y
> CONFIG_USB_SERIAL_QUALCOMM=y
> CONFIG_USB_SERIAL_SPCP8X5=y
> CONFIG_USB_SERIAL_HP4X=y
> CONFIG_USB_SERIAL_SAFE=y
> # CONFIG_USB_SERIAL_SAFE_PADDED is not set
> CONFIG_USB_SERIAL_SIEMENS_MPI=y
> CONFIG_USB_SERIAL_SIERRAWIRELESS=y
> CONFIG_USB_SERIAL_SYMBOL=y
> CONFIG_USB_SERIAL_TI=y
> CONFIG_USB_SERIAL_CYBERJACK=y
> CONFIG_USB_SERIAL_XIRCOM=y
> CONFIG_USB_SERIAL_WWAN=y
> CONFIG_USB_SERIAL_OPTION=y
> CONFIG_USB_SERIAL_OMNINET=y
> CONFIG_USB_SERIAL_OPTICON=y
> CONFIG_USB_SERIAL_VIVOPAY_SERIAL=y
> CONFIG_USB_SERIAL_ZIO=y
> # CONFIG_USB_SERIAL_ZTE is not set
> CONFIG_USB_SERIAL_SSU100=y
> # CONFIG_USB_SERIAL_QT2 is not set
> CONFIG_USB_SERIAL_DEBUG=y
> 
> #
> # USB Miscellaneous drivers
> #
> CONFIG_USB_EMI62=y
> CONFIG_USB_EMI26=y
> CONFIG_USB_ADUTUX=y
> CONFIG_USB_SEVSEG=y
> CONFIG_USB_RIO500=y
> CONFIG_USB_LEGOTOWER=y
> CONFIG_USB_LCD=y
> CONFIG_USB_LED=y
> CONFIG_USB_CYPRESS_CY7C63=y
> CONFIG_USB_CYTHERM=y
> CONFIG_USB_IDMOUSE=y
> CONFIG_USB_FTDI_ELAN=y
> CONFIG_USB_APPLEDISPLAY=y
> CONFIG_USB_SISUSBVGA=y
> CONFIG_USB_SISUSBVGA_CON=y
> CONFIG_USB_LD=y
> CONFIG_USB_TRANCEVIBRATOR=y
> CONFIG_USB_IOWARRIOR=y
> CONFIG_USB_TEST=y
> CONFIG_USB_ISIGHTFW=y
> CONFIG_USB_YUREX=y
> CONFIG_USB_EZUSB_FX2=y
> 
> #
> # USB Physical Layer drivers
> #
> # CONFIG_USB_ISP1301 is not set
> # CONFIG_USB_RCAR_PHY is not set
> CONFIG_USB_ATM=y
> CONFIG_USB_SPEEDTOUCH=y
> CONFIG_USB_CXACRU=y
> CONFIG_USB_UEAGLEATM=y
> CONFIG_USB_XUSBATM=y
> CONFIG_USB_GADGET=y
> # CONFIG_USB_GADGET_DEBUG is not set
> # CONFIG_USB_GADGET_DEBUG_FILES is not set
> # CONFIG_USB_GADGET_DEBUG_FS is not set
> CONFIG_USB_GADGET_VBUS_DRAW=2
> CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
> 
> #
> # USB Peripheral Controller
> #
> # CONFIG_USB_R8A66597 is not set
> # CONFIG_USB_MV_UDC is not set
> # CONFIG_USB_M66592 is not set
> # CONFIG_USB_AMD5536UDC is not set
> # CONFIG_USB_NET2272 is not set
> # CONFIG_USB_NET2280 is not set
> # CONFIG_USB_GOKU is not set
> CONFIG_USB_EG20T=y
> # CONFIG_USB_DUMMY_HCD is not set
> # CONFIG_USB_ZERO is not set
> # CONFIG_USB_AUDIO is not set
> # CONFIG_USB_ETH is not set
> # CONFIG_USB_G_NCM is not set
> # CONFIG_USB_GADGETFS is not set
> # CONFIG_USB_FUNCTIONFS is not set
> # CONFIG_USB_MASS_STORAGE is not set
> # CONFIG_USB_GADGET_TARGET is not set
> # CONFIG_USB_G_SERIAL is not set
> # CONFIG_USB_MIDI_GADGET is not set
> # CONFIG_USB_G_PRINTER is not set
> # CONFIG_USB_CDC_COMPOSITE is not set
> # CONFIG_USB_G_NOKIA is not set
> # CONFIG_USB_G_ACM_MS is not set
> # CONFIG_USB_G_MULTI is not set
> # CONFIG_USB_G_HID is not set
> # CONFIG_USB_G_DBGP is not set
> 
> #
> # OTG and related infrastructure
> #
> CONFIG_USB_OTG_UTILS=y
> # CONFIG_USB_GPIO_VBUS is not set
> CONFIG_NOP_USB_XCEIV=y
> CONFIG_UWB=y
> CONFIG_UWB_HWA=y
> CONFIG_UWB_WHCI=y
> CONFIG_UWB_I1480U=y
> CONFIG_MMC=y
> # CONFIG_MMC_DEBUG is not set
> # CONFIG_MMC_UNSAFE_RESUME is not set
> # CONFIG_MMC_CLKGATE is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=y
> CONFIG_MMC_BLOCK_MINORS=8
> CONFIG_MMC_BLOCK_BOUNCE=y
> CONFIG_SDIO_UART=y
> # CONFIG_MMC_TEST is not set
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> CONFIG_MMC_SDHCI=y
> CONFIG_MMC_SDHCI_PCI=y
> CONFIG_MMC_RICOH_MMC=y
> # CONFIG_MMC_SDHCI_ACPI is not set
> CONFIG_MMC_SDHCI_PLTFM=y
> CONFIG_MMC_WBSD=y
> CONFIG_MMC_TIFM_SD=y
> CONFIG_MMC_SPI=y
> CONFIG_MMC_SDRICOH_CS=y
> CONFIG_MMC_CB710=y
> CONFIG_MMC_VIA_SDMMC=y
> CONFIG_MMC_VUB300=y
> CONFIG_MMC_USHC=y
> CONFIG_MEMSTICK=y
> # CONFIG_MEMSTICK_DEBUG is not set
> 
> #
> # MemoryStick drivers
> #
> # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
> CONFIG_MSPRO_BLOCK=y
> 
> #
> # MemoryStick Host Controller Drivers
> #
> CONFIG_MEMSTICK_TIFM_MS=y
> CONFIG_MEMSTICK_JMICRON_38X=y
> CONFIG_MEMSTICK_R592=y
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> # CONFIG_LEDS_LM3530 is not set
> # CONFIG_LEDS_LM3642 is not set
> CONFIG_LEDS_PCA9532=y
> # CONFIG_LEDS_PCA9532_GPIO is not set
> # CONFIG_LEDS_GPIO is not set
> CONFIG_LEDS_LP3944=y
> # CONFIG_LEDS_LP5521 is not set
> # CONFIG_LEDS_LP5523 is not set
> CONFIG_LEDS_CLEVO_MAIL=y
> CONFIG_LEDS_PCA955X=y
> # CONFIG_LEDS_PCA9633 is not set
> CONFIG_LEDS_DAC124S085=y
> CONFIG_LEDS_REGULATOR=y
> CONFIG_LEDS_BD2802=y
> CONFIG_LEDS_INTEL_SS4200=y
> CONFIG_LEDS_LT3593=y
> CONFIG_LEDS_DELL_NETBOOKS=y
> # CONFIG_LEDS_TCA6507 is not set
> # CONFIG_LEDS_LM355x is not set
> # CONFIG_LEDS_OT200 is not set
> # CONFIG_LEDS_BLINKM is not set
> CONFIG_LEDS_TRIGGERS=y
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGER_TIMER=y
> # CONFIG_LEDS_TRIGGER_ONESHOT is not set
> CONFIG_LEDS_TRIGGER_IDE_DISK=y
> CONFIG_LEDS_TRIGGER_HEARTBEAT=y
> CONFIG_LEDS_TRIGGER_BACKLIGHT=y
> # CONFIG_LEDS_TRIGGER_CPU is not set
> # CONFIG_LEDS_TRIGGER_GPIO is not set
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> # CONFIG_LEDS_TRIGGER_TRANSIENT is not set
> CONFIG_ACCESSIBILITY=y
> CONFIG_A11Y_BRAILLE_CONSOLE=y
> CONFIG_INFINIBAND=y
> CONFIG_INFINIBAND_USER_MAD=y
> CONFIG_INFINIBAND_USER_ACCESS=y
> CONFIG_INFINIBAND_USER_MEM=y
> CONFIG_INFINIBAND_ADDR_TRANS=y
> CONFIG_INFINIBAND_MTHCA=y
> CONFIG_INFINIBAND_MTHCA_DEBUG=y
> CONFIG_INFINIBAND_IPATH=y
> CONFIG_INFINIBAND_QIB=y
> CONFIG_INFINIBAND_AMSO1100=y
> # CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
> CONFIG_INFINIBAND_CXGB3=y
> # CONFIG_INFINIBAND_CXGB3_DEBUG is not set
> CONFIG_INFINIBAND_CXGB4=y
> CONFIG_MLX4_INFINIBAND=y
> CONFIG_INFINIBAND_NES=y
> # CONFIG_INFINIBAND_NES_DEBUG is not set
> # CONFIG_INFINIBAND_OCRDMA is not set
> CONFIG_INFINIBAND_IPOIB=y
> CONFIG_INFINIBAND_IPOIB_CM=y
> CONFIG_INFINIBAND_IPOIB_DEBUG=y
> # CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
> CONFIG_INFINIBAND_SRP=y
> # CONFIG_INFINIBAND_SRPT is not set
> CONFIG_INFINIBAND_ISER=y
> CONFIG_EDAC=y
> 
> #
> # Reporting subsystems
> #
> CONFIG_EDAC_LEGACY_SYSFS=y
> # CONFIG_EDAC_DEBUG is not set
> CONFIG_EDAC_DECODE_MCE=y
> # CONFIG_EDAC_MCE_INJ is not set
> CONFIG_EDAC_MM_EDAC=y
> CONFIG_EDAC_AMD64=y
> # CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
> CONFIG_EDAC_E752X=y
> CONFIG_EDAC_I82975X=y
> CONFIG_EDAC_I3000=y
> CONFIG_EDAC_I3200=y
> CONFIG_EDAC_X38=y
> CONFIG_EDAC_I5400=y
> CONFIG_EDAC_I7CORE=y
> CONFIG_EDAC_I5000=y
> CONFIG_EDAC_I5100=y
> CONFIG_EDAC_I7300=y
> # CONFIG_EDAC_SBRIDGE is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> CONFIG_RTC_DRV_TEST=y
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS1307=y
> CONFIG_RTC_DRV_DS1374=y
> CONFIG_RTC_DRV_DS1672=y
> # CONFIG_RTC_DRV_DS3232 is not set
> CONFIG_RTC_DRV_MAX6900=y
> CONFIG_RTC_DRV_RS5C372=y
> CONFIG_RTC_DRV_ISL1208=y
> # CONFIG_RTC_DRV_ISL12022 is not set
> CONFIG_RTC_DRV_X1205=y
> # CONFIG_RTC_DRV_PCF8523 is not set
> CONFIG_RTC_DRV_PCF8563=y
> CONFIG_RTC_DRV_PCF8583=y
> CONFIG_RTC_DRV_M41T80=y
> # CONFIG_RTC_DRV_M41T80_WDT is not set
> CONFIG_RTC_DRV_BQ32K=y
> CONFIG_RTC_DRV_S35390A=y
> CONFIG_RTC_DRV_FM3130=y
> CONFIG_RTC_DRV_RX8581=y
> CONFIG_RTC_DRV_RX8025=y
> # CONFIG_RTC_DRV_EM3027 is not set
> # CONFIG_RTC_DRV_RV3029C2 is not set
> 
> #
> # SPI RTC drivers
> #
> # CONFIG_RTC_DRV_M41T93 is not set
> CONFIG_RTC_DRV_M41T94=y
> CONFIG_RTC_DRV_DS1305=y
> CONFIG_RTC_DRV_DS1390=y
> CONFIG_RTC_DRV_MAX6902=y
> CONFIG_RTC_DRV_R9701=y
> CONFIG_RTC_DRV_RS5C348=y
> CONFIG_RTC_DRV_DS3234=y
> CONFIG_RTC_DRV_PCF2123=y
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> CONFIG_RTC_DRV_DS1286=y
> CONFIG_RTC_DRV_DS1511=y
> CONFIG_RTC_DRV_DS1553=y
> CONFIG_RTC_DRV_DS1742=y
> CONFIG_RTC_DRV_STK17TA8=y
> CONFIG_RTC_DRV_M48T86=y
> CONFIG_RTC_DRV_M48T35=y
> CONFIG_RTC_DRV_M48T59=y
> CONFIG_RTC_DRV_MSM6242=y
> CONFIG_RTC_DRV_BQ4802=y
> CONFIG_RTC_DRV_RP5C01=y
> CONFIG_RTC_DRV_V3020=y
> # CONFIG_RTC_DRV_DS2404 is not set
> CONFIG_RTC_DRV_PCF50633=y
> 
> #
> # on-CPU RTC drivers
> #
> CONFIG_DMADEVICES=y
> # CONFIG_DMADEVICES_DEBUG is not set
> 
> #
> # DMA Devices
> #
> # CONFIG_INTEL_MID_DMAC is not set
> CONFIG_INTEL_IOATDMA=y
> # CONFIG_TIMB_DMA is not set
> CONFIG_PCH_DMA=y
> CONFIG_DMA_ENGINE=y
> 
> #
> # DMA Clients
> #
> CONFIG_NET_DMA=y
> CONFIG_ASYNC_TX_DMA=y
> # CONFIG_DMATEST is not set
> CONFIG_DCA=y
> # CONFIG_AUXDISPLAY is not set
> CONFIG_UIO=y
> CONFIG_UIO_CIF=y
> CONFIG_UIO_PDRV=y
> CONFIG_UIO_PDRV_GENIRQ=y
> # CONFIG_UIO_DMEM_GENIRQ is not set
> CONFIG_UIO_AEC=y
> CONFIG_UIO_SERCOS3=y
> CONFIG_UIO_PCI_GENERIC=y
> CONFIG_UIO_NETX=y
> # CONFIG_VFIO is not set
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> CONFIG_VIRTIO_PCI=y
> CONFIG_VIRTIO_BALLOON=y
> CONFIG_VIRTIO_MMIO=y
> # CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> CONFIG_HYPERV=y
> CONFIG_HYPERV_UTILS=y
> # CONFIG_HYPERV_BALLOON is not set
> 
> #
> # Xen driver support
> #
> CONFIG_XEN_BALLOON=y
> # CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
> CONFIG_XEN_SCRUB_PAGES=y
> CONFIG_XEN_DEV_EVTCHN=y
> CONFIG_XEN_BACKEND=y
> CONFIG_XENFS=y
> CONFIG_XEN_COMPAT_XENFS=y
> CONFIG_XEN_SYS_HYPERVISOR=y
> CONFIG_XEN_XENBUS_FRONTEND=y
> CONFIG_XEN_GNTDEV=y
> CONFIG_XEN_GRANT_DEV_ALLOC=y
> CONFIG_SWIOTLB_XEN=y
> CONFIG_XEN_PCIDEV_BACKEND=y
> CONFIG_XEN_PRIVCMD=y
> CONFIG_XEN_ACPI_PROCESSOR=m
> # CONFIG_XEN_MCE_LOG is not set
> CONFIG_XEN_HAVE_PVMMU=y
> CONFIG_STAGING=y
> CONFIG_ET131X=y
> # CONFIG_SLICOSS is not set
> CONFIG_USBIP_CORE=y
> CONFIG_USBIP_VHCI_HCD=y
> CONFIG_USBIP_HOST=y
> # CONFIG_USBIP_DEBUG is not set
> # CONFIG_W35UND is not set
> CONFIG_PRISM2_USB=y
> # CONFIG_ECHO is not set
> CONFIG_COMEDI=m
> # CONFIG_COMEDI_DEBUG is not set
> CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
> CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
> # CONFIG_COMEDI_MISC_DRIVERS is not set
> # CONFIG_COMEDI_PCI_DRIVERS is not set
> # CONFIG_COMEDI_PCMCIA_DRIVERS is not set
> # CONFIG_COMEDI_USB_DRIVERS is not set
> CONFIG_COMEDI_8255=m
> # CONFIG_ASUS_OLED is not set
> # CONFIG_PANEL is not set
> CONFIG_R8187SE=m
> CONFIG_RTL8192U=m
> # CONFIG_RTLLIB is not set
> CONFIG_R8712U=y
> # CONFIG_RTS5139 is not set
> # CONFIG_TRANZPORT is not set
> # CONFIG_IDE_PHISON is not set
> # CONFIG_LINE6_USB is not set
> # CONFIG_USB_SERIAL_QUATECH2 is not set
> # CONFIG_VT6655 is not set
> CONFIG_VT6656=m
> # CONFIG_DX_SEP is not set
> CONFIG_ZRAM=y
> # CONFIG_ZRAM_DEBUG is not set
> CONFIG_ZSMALLOC=y
> # CONFIG_WLAGS49_H2 is not set
> # CONFIG_WLAGS49_H25 is not set
> # CONFIG_FB_SM7XX is not set
> # CONFIG_CRYSTALHD is not set
> # CONFIG_CXT1E1 is not set
> # CONFIG_FB_XGI is not set
> # CONFIG_ACPI_QUICKSTART is not set
> # CONFIG_SBE_2T3E3 is not set
> # CONFIG_USB_ENESTORAGE is not set
> # CONFIG_BCM_WIMAX is not set
> # CONFIG_FT1000 is not set
> 
> #
> # Speakup console speech
> #
> CONFIG_SPEAKUP=y
> CONFIG_SPEAKUP_SYNTH_ACNTSA=y
> CONFIG_SPEAKUP_SYNTH_ACNTPC=y
> CONFIG_SPEAKUP_SYNTH_APOLLO=y
> CONFIG_SPEAKUP_SYNTH_AUDPTR=y
> CONFIG_SPEAKUP_SYNTH_BNS=y
> CONFIG_SPEAKUP_SYNTH_DECTLK=y
> CONFIG_SPEAKUP_SYNTH_DECEXT=y
> # CONFIG_SPEAKUP_SYNTH_DECPC is not set
> CONFIG_SPEAKUP_SYNTH_DTLK=y
> CONFIG_SPEAKUP_SYNTH_KEYPC=y
> CONFIG_SPEAKUP_SYNTH_LTLK=y
> CONFIG_SPEAKUP_SYNTH_SOFT=y
> CONFIG_SPEAKUP_SYNTH_SPKOUT=y
> CONFIG_SPEAKUP_SYNTH_TXPRT=y
> CONFIG_SPEAKUP_SYNTH_DUMMY=y
> # CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
> # CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
> CONFIG_STAGING_MEDIA=y
> 
> #
> # Android
> #
> # CONFIG_ANDROID is not set
> # CONFIG_USB_WPAN_HCD is not set
> # CONFIG_USB_G_CCG is not set
> # CONFIG_WIMAX_GDM72XX is not set
> # CONFIG_CSR_WIFI is not set
> CONFIG_NET_VENDOR_SILICOM=y
> # CONFIG_SBYPASS is not set
> # CONFIG_BPCTL is not set
> # CONFIG_CED1401 is not set
> # CONFIG_DGRP is not set
> # CONFIG_SB105X is not set
> # CONFIG_FIREWIRE_SERIAL is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> CONFIG_ACER_WMI=y
> CONFIG_ACERHDF=y
> CONFIG_ASUS_LAPTOP=y
> CONFIG_DELL_LAPTOP=y
> CONFIG_DELL_WMI=y
> CONFIG_DELL_WMI_AIO=y
> CONFIG_FUJITSU_LAPTOP=y
> # CONFIG_FUJITSU_LAPTOP_DEBUG is not set
> # CONFIG_FUJITSU_TABLET is not set
> CONFIG_AMILO_RFKILL=y
> CONFIG_HP_ACCEL=y
> CONFIG_HP_WMI=y
> CONFIG_MSI_LAPTOP=y
> CONFIG_PANASONIC_LAPTOP=y
> CONFIG_COMPAL_LAPTOP=y
> CONFIG_SONY_LAPTOP=y
> CONFIG_SONYPI_COMPAT=y
> CONFIG_IDEAPAD_LAPTOP=y
> CONFIG_THINKPAD_ACPI=y
> CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
> # CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
> # CONFIG_THINKPAD_ACPI_DEBUG is not set
> # CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
> CONFIG_THINKPAD_ACPI_VIDEO=y
> CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
> CONFIG_SENSORS_HDAPS=y
> # CONFIG_INTEL_MENLOW is not set
> CONFIG_EEEPC_LAPTOP=y
> CONFIG_ASUS_WMI=y
> CONFIG_ASUS_NB_WMI=y
> CONFIG_EEEPC_WMI=y
> CONFIG_ACPI_WMI=y
> CONFIG_MSI_WMI=y
> CONFIG_TOPSTAR_LAPTOP=y
> CONFIG_ACPI_TOSHIBA=y
> CONFIG_TOSHIBA_BT_RFKILL=y
> CONFIG_ACPI_CMPC=y
> CONFIG_INTEL_IPS=y
> # CONFIG_IBM_RTL is not set
> # CONFIG_XO15_EBOOK is not set
> CONFIG_SAMSUNG_LAPTOP=y
> CONFIG_MXM_WMI=y
> CONFIG_INTEL_OAKTRAIL=y
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_APPLE_GMUX is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> CONFIG_IOMMU_API=y
> CONFIG_IOMMU_SUPPORT=y
> CONFIG_AMD_IOMMU=y
> # CONFIG_AMD_IOMMU_STATS is not set
> # CONFIG_AMD_IOMMU_V2 is not set
> CONFIG_DMAR_TABLE=y
> CONFIG_INTEL_IOMMU=y
> # CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
> CONFIG_INTEL_IOMMU_FLOPPY_WA=y
> CONFIG_IRQ_REMAP=y
> 
> #
> # Remoteproc drivers (EXPERIMENTAL)
> #
> # CONFIG_STE_MODEM_RPROC is not set
> 
> #
> # Rpmsg drivers (EXPERIMENTAL)
> #
> # CONFIG_VIRT_DRIVERS is not set
> # CONFIG_PM_DEVFREQ is not set
> # CONFIG_EXTCON is not set
> # CONFIG_MEMORY is not set
> # CONFIG_IIO is not set
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> # CONFIG_IPACK_BUS is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=y
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_EFI_VARS=y
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=y
> CONFIG_DMIID=y
> # CONFIG_DMI_SYSFS is not set
> CONFIG_ISCSI_IBFT_FIND=y
> CONFIG_ISCSI_IBFT=y
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_JBD=y
> # CONFIG_JBD_DEBUG is not set
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_PROC_INFO is not set
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> CONFIG_REISERFS_FS_SECURITY=y
> CONFIG_JFS_FS=y
> CONFIG_JFS_POSIX_ACL=y
> CONFIG_JFS_SECURITY=y
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> # CONFIG_XFS_DEBUG is not set
> CONFIG_GFS2_FS=y
> CONFIG_GFS2_FS_LOCKING_DLM=y
> CONFIG_OCFS2_FS=y
> CONFIG_OCFS2_FS_O2CB=y
> CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
> CONFIG_OCFS2_FS_STATS=y
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> # CONFIG_OCFS2_DEBUG_FS is not set
> CONFIG_BTRFS_FS=y
> CONFIG_BTRFS_FS_POSIX_ACL=y
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> CONFIG_NILFS2_FS=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_FANOTIFY=y
> # CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
> CONFIG_QUOTA=y
> CONFIG_QUOTA_NETLINK_INTERFACE=y
> CONFIG_PRINT_QUOTA_WARNING=y
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> CONFIG_QFMT_V1=y
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> CONFIG_QUOTACTL_COMPAT=y
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=y
> CONFIG_CUSE=y
> CONFIG_GENERIC_ACL=y
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> CONFIG_FSCACHE_STATS=y
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> # CONFIG_FSCACHE_OBJECT_LIST is not set
> CONFIG_CACHEFILES=y
> # CONFIG_CACHEFILES_DEBUG is not set
> # CONFIG_CACHEFILES_HISTOGRAM is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
> CONFIG_NTFS_FS=y
> # CONFIG_NTFS_DEBUG is not set
> CONFIG_NTFS_RW=y
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_TMPFS_XATTR=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_ADFS_FS=y
> # CONFIG_ADFS_FS_RW is not set
> CONFIG_AFFS_FS=y
> CONFIG_ECRYPT_FS=y
> CONFIG_HFS_FS=y
> CONFIG_HFSPLUS_FS=y
> CONFIG_BEFS_FS=y
> # CONFIG_BEFS_DEBUG is not set
> CONFIG_BFS_FS=y
> CONFIG_EFS_FS=y
> CONFIG_JFFS2_FS=y
> CONFIG_JFFS2_FS_DEBUG=0
> CONFIG_JFFS2_FS_WRITEBUFFER=y
> # CONFIG_JFFS2_FS_WBUF_VERIFY is not set
> CONFIG_JFFS2_SUMMARY=y
> CONFIG_JFFS2_FS_XATTR=y
> CONFIG_JFFS2_FS_POSIX_ACL=y
> CONFIG_JFFS2_FS_SECURITY=y
> CONFIG_JFFS2_COMPRESSION_OPTIONS=y
> CONFIG_JFFS2_ZLIB=y
> CONFIG_JFFS2_LZO=y
> CONFIG_JFFS2_RTIME=y
> # CONFIG_JFFS2_RUBIN is not set
> # CONFIG_JFFS2_CMODE_NONE is not set
> CONFIG_JFFS2_CMODE_PRIORITY=y
> # CONFIG_JFFS2_CMODE_SIZE is not set
> # CONFIG_JFFS2_CMODE_FAVOURLZO is not set
> CONFIG_UBIFS_FS=y
> CONFIG_UBIFS_FS_ADVANCED_COMPR=y
> CONFIG_UBIFS_FS_LZO=y
> CONFIG_UBIFS_FS_ZLIB=y
> CONFIG_LOGFS=y
> CONFIG_CRAMFS=y
> CONFIG_SQUASHFS=y
> CONFIG_SQUASHFS_XATTR=y
> CONFIG_SQUASHFS_ZLIB=y
> CONFIG_SQUASHFS_LZO=y
> CONFIG_SQUASHFS_XZ=y
> # CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
> # CONFIG_SQUASHFS_EMBEDDED is not set
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> CONFIG_VXFS_FS=y
> CONFIG_MINIX_FS=y
> CONFIG_OMFS_FS=y
> # CONFIG_HPFS_FS is not set
> CONFIG_QNX4FS_FS=y
> # CONFIG_QNX6FS_FS is not set
> CONFIG_ROMFS_FS=y
> # CONFIG_ROMFS_BACKED_BY_BLOCK is not set
> # CONFIG_ROMFS_BACKED_BY_MTD is not set
> CONFIG_ROMFS_BACKED_BY_BOTH=y
> CONFIG_ROMFS_ON_BLOCK=y
> CONFIG_ROMFS_ON_MTD=y
> CONFIG_PSTORE=y
> # CONFIG_PSTORE_CONSOLE is not set
> # CONFIG_PSTORE_FTRACE is not set
> # CONFIG_PSTORE_RAM is not set
> CONFIG_SYSV_FS=y
> CONFIG_UFS_FS=y
> # CONFIG_UFS_FS_WRITE is not set
> # CONFIG_UFS_DEBUG is not set
> CONFIG_EXOFS_FS=y
> # CONFIG_EXOFS_DEBUG is not set
> CONFIG_ORE=y
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=y
> CONFIG_NFS_V2=y
> CONFIG_NFS_V3=y
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=y
> # CONFIG_NFS_SWAP is not set
> CONFIG_NFS_V4_1=y
> CONFIG_PNFS_FILE_LAYOUT=m
> CONFIG_PNFS_BLOCK=m
> CONFIG_PNFS_OBJLAYOUT=m
> CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
> CONFIG_ROOT_NFS=y
> CONFIG_NFS_FSCACHE=y
> # CONFIG_NFS_USE_LEGACY_DNS is not set
> CONFIG_NFS_USE_KERNEL_DNS=y
> CONFIG_NFSD=y
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_NFSD_V4=y
> # CONFIG_NFSD_FAULT_INJECTION is not set
> CONFIG_LOCKD=y
> CONFIG_LOCKD_V4=y
> CONFIG_NFS_ACL_SUPPORT=y
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=y
> CONFIG_SUNRPC_GSS=y
> CONFIG_SUNRPC_BACKCHANNEL=y
> CONFIG_SUNRPC_XPRT_RDMA=y
> CONFIG_RPCSEC_GSS_KRB5=y
> # CONFIG_SUNRPC_DEBUG is not set
> CONFIG_CEPH_FS=y
> CONFIG_CIFS=y
> # CONFIG_CIFS_STATS is not set
> CONFIG_CIFS_WEAK_PW_HASH=y
> CONFIG_CIFS_UPCALL=y
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> CONFIG_CIFS_ACL=y
> CONFIG_CIFS_DEBUG=y
> # CONFIG_CIFS_DEBUG2 is not set
> CONFIG_CIFS_DFS_UPCALL=y
> # CONFIG_CIFS_SMB2 is not set
> CONFIG_CIFS_FSCACHE=y
> CONFIG_NCP_FS=y
> CONFIG_NCPFS_PACKET_SIGNING=y
> CONFIG_NCPFS_IOCTL_LOCKING=y
> CONFIG_NCPFS_STRONG=y
> CONFIG_NCPFS_NFS_NS=y
> CONFIG_NCPFS_OS2_NS=y
> # CONFIG_NCPFS_SMALLDOS is not set
> CONFIG_NCPFS_NLS=y
> CONFIG_NCPFS_EXTRAS=y
> CONFIG_CODA_FS=y
> CONFIG_AFS_FS=y
> # CONFIG_AFS_DEBUG is not set
> CONFIG_AFS_FSCACHE=y
> CONFIG_9P_FS=y
> CONFIG_9P_FSCACHE=y
> CONFIG_9P_FS_POSIX_ACL=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="utf8"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> CONFIG_NLS_CODEPAGE_850=y
> CONFIG_NLS_CODEPAGE_852=y
> CONFIG_NLS_CODEPAGE_855=y
> CONFIG_NLS_CODEPAGE_857=y
> CONFIG_NLS_CODEPAGE_860=y
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> CONFIG_NLS_CODEPAGE_864=y
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=y
> CONFIG_NLS_CODEPAGE_869=y
> CONFIG_NLS_CODEPAGE_936=y
> CONFIG_NLS_CODEPAGE_950=y
> CONFIG_NLS_CODEPAGE_932=y
> CONFIG_NLS_CODEPAGE_949=y
> CONFIG_NLS_CODEPAGE_874=y
> CONFIG_NLS_ISO8859_8=y
> CONFIG_NLS_CODEPAGE_1250=y
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_ISO8859_2=y
> CONFIG_NLS_ISO8859_3=y
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=y
> CONFIG_NLS_ISO8859_6=y
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> CONFIG_NLS_ISO8859_14=y
> CONFIG_NLS_ISO8859_15=y
> CONFIG_NLS_KOI8_R=y
> CONFIG_NLS_KOI8_U=y
> # CONFIG_NLS_MAC_ROMAN is not set
> # CONFIG_NLS_MAC_CELTIC is not set
> # CONFIG_NLS_MAC_CENTEURO is not set
> # CONFIG_NLS_MAC_CROATIAN is not set
> # CONFIG_NLS_MAC_CYRILLIC is not set
> # CONFIG_NLS_MAC_GAELIC is not set
> # CONFIG_NLS_MAC_GREEK is not set
> # CONFIG_NLS_MAC_ICELAND is not set
> # CONFIG_NLS_MAC_INUIT is not set
> # CONFIG_NLS_MAC_ROMANIAN is not set
> # CONFIG_NLS_MAC_TURKISH is not set
> CONFIG_NLS_UTF8=y
> CONFIG_DLM=y
> CONFIG_DLM_DEBUG=y
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=2048
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_SHIRQ=y
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> # CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=300
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> CONFIG_TIMER_STATS=y
> CONFIG_DEBUG_OBJECTS=y
> # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
> # CONFIG_DEBUG_OBJECTS_FREE is not set
> # CONFIG_DEBUG_OBJECTS_TIMERS is not set
> # CONFIG_DEBUG_OBJECTS_WORK is not set
> # CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
> # CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> CONFIG_DEBUG_SLAB=y
> # CONFIG_DEBUG_SLAB_LEAK is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_RT_MUTEX_TESTER=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> # CONFIG_PROVE_RCU is not set
> CONFIG_SPARSE_RCU_POINTER=y
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> # CONFIG_DEBUG_LOCKDEP is not set
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_STACKTRACE=y
> CONFIG_DEBUG_STACK_USAGE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> CONFIG_DEBUG_VM=y
> # CONFIG_DEBUG_VM_RB is not set
> CONFIG_DEBUG_VIRTUAL=y
> CONFIG_DEBUG_WRITECOUNT=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_LIST=y
> CONFIG_TEST_LIST_SORT=y
> CONFIG_DEBUG_SG=y
> CONFIG_DEBUG_NOTIFIERS=y
> CONFIG_DEBUG_CREDENTIALS=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> CONFIG_BOOT_PRINTK_DELAY=y
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> CONFIG_RCU_CPU_STALL_INFO=y
> CONFIG_RCU_TRACE=y
> CONFIG_KPROBES_SANITY_TEST=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_DEBUG_BLOCK_EXT_DEVT=y
> CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
> CONFIG_DEBUG_PER_CPU_MAPS=y
> CONFIG_LKDTM=y
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> CONFIG_FAULT_INJECTION=y
> # CONFIG_FAILSLAB is not set
> # CONFIG_FAIL_PAGE_ALLOC is not set
> # CONFIG_FAIL_MAKE_REQUEST is not set
> # CONFIG_FAIL_IO_TIMEOUT is not set
> # CONFIG_FAIL_MMC_REQUEST is not set
> # CONFIG_FAULT_INJECTION_DEBUG_FS is not set
> CONFIG_LATENCYTOP=y
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_WANT_PAGE_DEBUG_FLAGS=y
> CONFIG_PAGE_GUARD=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_FENTRY=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> CONFIG_IRQSOFF_TRACER=y
> CONFIG_SCHED_TRACER=y
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> # CONFIG_STACK_TRACER is not set
> CONFIG_BLK_DEV_IO_TRACE=y
> CONFIG_KPROBE_EVENT=y
> # CONFIG_UPROBE_EVENT is not set
> CONFIG_PROBE_EVENTS=y
> CONFIG_DYNAMIC_FTRACE=y
> # CONFIG_FUNCTION_PROFILER is not set
> CONFIG_FTRACE_MCOUNT_RECORD=y
> CONFIG_FTRACE_SELFTEST=y
> CONFIG_FTRACE_STARTUP_TEST=y
> # CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
> CONFIG_MMIOTRACE=y
> # CONFIG_MMIOTRACE_TEST is not set
> # CONFIG_RING_BUFFER_BENCHMARK is not set
> # CONFIG_RBTREE_TEST is not set
> # CONFIG_INTERVAL_TREE_TEST is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> CONFIG_DMA_API_DEBUG=y
> CONFIG_ATOMIC64_SELFTEST=y
> # CONFIG_ASYNC_RAID6_TEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_TEST_KSTRTOX is not set
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> CONFIG_DEBUG_STACKOVERFLOW=y
> CONFIG_X86_PTDUMP=y
> CONFIG_DEBUG_RODATA=y
> CONFIG_DEBUG_RODATA_TEST=y
> CONFIG_DEBUG_SET_MODULE_RONX=y
> CONFIG_DEBUG_NX_TEST=m
> # CONFIG_DEBUG_TLBFLUSH is not set
> # CONFIG_IOMMU_DEBUG is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> # CONFIG_X86_DECODER_SELFTEST is not set
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> CONFIG_IO_DELAY_0X80=y
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=0
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> CONFIG_DEBUG_NMI_SELFTEST=y
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_TRUSTED_KEYS is not set
> # CONFIG_ENCRYPTED_KEYS is not set
> CONFIG_KEYS_DEBUG_PROC_KEYS=y
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> CONFIG_SECURITY_NETWORK=y
> CONFIG_SECURITY_NETWORK_XFRM=y
> CONFIG_SECURITY_PATH=y
> # CONFIG_INTEL_TXT is not set
> CONFIG_LSM_MMAP_MIN_ADDR=65536
> CONFIG_SECURITY_SELINUX=y
> # CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
> # CONFIG_SECURITY_SELINUX_DISABLE is not set
> CONFIG_SECURITY_SELINUX_DEVELOP=y
> CONFIG_SECURITY_SELINUX_AVC_STATS=y
> CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
> # CONFIG_SECURITY_SMACK is not set
> # CONFIG_SECURITY_TOMOYO is not set
> CONFIG_SECURITY_APPARMOR=y
> CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
> # CONFIG_SECURITY_YAMA is not set
> # CONFIG_IMA is not set
> # CONFIG_EVM is not set
> # CONFIG_DEFAULT_SECURITY_SELINUX is not set
> # CONFIG_DEFAULT_SECURITY_APPARMOR is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=y
> CONFIG_ASYNC_CORE=y
> CONFIG_ASYNC_MEMCPY=y
> CONFIG_ASYNC_XOR=y
> CONFIG_ASYNC_PQ=y
> CONFIG_ASYNC_RAID6_RECOV=y
> CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
> CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_FIPS=y
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_PCRYPT=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_TEST=m
> CONFIG_CRYPTO_ABLK_HELPER_X86=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_X86_64=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> CONFIG_CRYPTO_RMD128=y
> CONFIG_CRYPTO_RMD160=y
> CONFIG_CRYPTO_RMD256=y
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA1_SSSE3=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> CONFIG_CRYPTO_WP512=y
> CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_X86_64=y
> CONFIG_CRYPTO_AES_NI_INTEL=y
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> CONFIG_CRYPTO_BLOWFISH_X86_64=y
> CONFIG_CRYPTO_CAMELLIA=y
> # CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
> # CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> # CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
> CONFIG_CRYPTO_CAST6=y
> # CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=y
> CONFIG_CRYPTO_KHAZAD=y
> CONFIG_CRYPTO_SALSA20=y
> CONFIG_CRYPTO_SALSA20_X86_64=y
> CONFIG_CRYPTO_SEED=y
> CONFIG_CRYPTO_SERPENT=y
> # CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
> # CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
> CONFIG_CRYPTO_TEA=y
> CONFIG_CRYPTO_TWOFISH=y
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_X86_64=y
> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
> # CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> CONFIG_CRYPTO_USER_API=y
> CONFIG_CRYPTO_USER_API_HASH=y
> CONFIG_CRYPTO_USER_API_SKCIPHER=y
> CONFIG_CRYPTO_HW=y
> CONFIG_CRYPTO_DEV_PADLOCK=y
> CONFIG_CRYPTO_DEV_PADLOCK_AES=y
> CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
> # CONFIG_ASYMMETRIC_KEY_TYPE is not set
> CONFIG_HAVE_KVM=y
> CONFIG_HAVE_KVM_IRQCHIP=y
> CONFIG_HAVE_KVM_EVENTFD=y
> CONFIG_KVM_APIC_ARCHITECTURE=y
> CONFIG_KVM_MMIO=y
> CONFIG_KVM_ASYNC_PF=y
> CONFIG_HAVE_KVM_MSI=y
> CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_KVM=y
> CONFIG_KVM_INTEL=y
> CONFIG_KVM_AMD=y
> # CONFIG_KVM_MMU_AUDIT is not set
> CONFIG_VHOST_NET=y
> # CONFIG_TCM_VHOST is not set
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_PERCPU_RWSEM=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_REED_SOLOMON=y
> CONFIG_REED_SOLOMON_DEC16=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=y
> CONFIG_TEXTSEARCH_BM=y
> CONFIG_TEXTSEARCH_FSM=y
> CONFIG_BTREE=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> # CONFIG_CPUMASK_OFFSTACK is not set
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_LRU_CACHE=y
> CONFIG_AVERAGE=y
> CONFIG_CORDIC=y
> # CONFIG_DDR is not set
> # CONFIG_IIO_SIMPLE_DUMMY is not set
> # CONFIG_ISDN_DRV_LOOP is not set


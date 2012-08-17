Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2HQNpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:45:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37707 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2HQNpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:45:22 -0400
Date: Fri, 17 Aug 2012 06:43:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: lockdep warning on rt_mutex_lock()
Message-ID: <20120817134328.GB2872@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120817100635.GA30765@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817100635.GA30765@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081713-7182-0000-0000-00000250DD16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 06:06:35PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> FYI, a lockdep warning:

Certainly looks problematic!

Any hint as to what version of the kernel produced this splat?
(Yes, lazy of me to ask, I know, but I am not seeing it in my testing.)

							Thanx, Paul

> [  293.123508] CPA self-test:
> [  293.156399]  4k 3069 large 61 gb 0 x 3130[c0000000-cfffc000] miss 0
> [  321.719166]  4k 65533 large 0 gb 0 x 65533[c0000000-cfffc000] miss 0
> [  326.089755] ------------[ cut here ]------------
> [  326.089755] WARNING: at /c/kernel-tests/src/linux/kernel/lockdep.c:3493 check_flags+0xaa/0x190()
> [  326.089755] Hardware name: Bochs
> [  326.089755] Pid: 8, comm: rcu_kthread Not tainted 3.6.0-rc1 #3
> [  326.089755] Call Trace:
> [  326.089755]  [<c102e02a>] warn_slowpath_common+0x7a/0xa0
> [  326.089755]  [<c10732aa>] ? check_flags+0xaa/0x190
> [  326.089755]  [<c10732aa>] ? check_flags+0xaa/0x190
> [  326.089755]  [<c102e0ed>] warn_slowpath_null+0x1d/0x20
> [  326.089755]  [<c10732aa>] check_flags+0xaa/0x190
> [  326.089755]  [<c10743f4>] lock_is_held+0x34/0xb0
> [  326.089755]  [<c105ebc1>] __might_sleep+0x31/0x1a0
> [  326.089755]  [<c107c0fa>] ? debug_rt_mutex_init+0x1a/0x30
> [  326.089755]  [<c1637f0a>] rt_mutex_lock+0x1a/0x40
> [  326.089755]  [<c108e62a>] rcu_kthread+0xea/0x1a0
> [  326.089755]  [<c108e540>] ? __rcu_process_callbacks+0xd0/0xd0
> [  326.089755]  [<c104f7b7>] kthread+0x67/0x70
> [  326.089755]  [<c104f750>] ? insert_kthread_work+0x80/0x80
> [  326.089755]  [<c163999a>] kernel_thread_helper+0x6/0xd
> [  326.089755] ---[ end trace c73785c318dc0a8f ]---
> [  326.089755] possible reason: unannotated irqs-on.
> [  326.089755] irq event stamp: 440724
> [  326.089755] hardirqs last  enabled at (440723): [<c1638e76>] restore_all_notrace+0x0/0x18
> [  326.089755] hardirqs last disabled at (440724): [<c1076b75>] debug_check_no_locks_freed+0x35/0x160
> [  326.089755] softirqs last  enabled at (440722): [<c10367c7>] __do_softirq+0x2b7/0x370
> [  326.089755] softirqs last disabled at (440715): [<c1003b14>] do_softirq+0x64/0xd0
> [  327.331183]  4k 65533 large 0 gb 0 x 65533[c0000000-cfffc000] miss 0
> [  327.339297] ok.                                                     
> 
> Thanks,
> Fengguang

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.6.0-rc1 (kbuild@bee) (gcc version 4.7.1 (Debian 4.7.1-5) ) #3 PREEMPT Sun Aug 5 01:11:43 CST 2012
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffcfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000fffd000-0x000000000fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] DMI 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0xfffd max_arch_pfn = 0x100000
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
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [c00fdae0]
> [    0.000000]   mpc: fdaf0-fdbe4
> [    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffcfff]
> [    0.000000]  [mem 0x00000000-0x003fffff] page 4k
> [    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
> [    0.000000]  [mem 0x0fc00000-0x0fffcfff] page 4k
> [    0.000000] kernel direct mapping tables up to 0xfffcfff @ [mem 0x023fa000-0x023fffff]
> [    0.000000] log_buf_len: 8388608
> [    0.000000] early log buf free: 128508(98%)
> [    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 255MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 0fffd000
> [    0.000000]   low ram: 0 - 0fffd000
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x0fffcfff]
> [    0.000000]   HighMem  empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00010000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x0fffcfff]
> [    0.000000] On node 0 totalpages: 65420
> [    0.000000] free_area_init_node: node 0, pgdat c18eeea0, node_mem_map cdd3f200
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3951 pages, LIFO batch:0
> [    0.000000]   Normal zone: 480 pages used for memmap
> [    0.000000]   Normal zone: 60957 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] Intel MultiProcessor Specification v1.4
> [    0.000000]     Virtual Wire compatibility mode.
> [    0.000000]   mpc: fdaf0-fdbe4
> [    0.000000] MPTABLE: OEM ID: BOCHSCPU
> [    0.000000] MPTABLE: Product ID: 0.1         
> [    0.000000] MPTABLE: APIC at: 0xFEE00000
> [    0.000000] mapped APIC to         ffffb000 (        fee00000)
> [    0.000000] Processor #0 (Bootup-CPU)
> [    0.000000] Processor #1
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
> [    0.000000] Bus #0 is PCI   
> [    0.000000] Bus #1 is ISA   
> [    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
> [    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0a, APIC ID 2, APIC INT 0a
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
> [    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
> [    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 01
> [    0.000000] Processors: 1
> [    0.000000] mapped IOAPIC to ffffa000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64908
> [    0.000000] Kernel command line: trinity=3m hung_task_panic=1 branch=signal/execve2 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-08-05-01-12-02-signal:execve2:f8cdda8-0d7614f-i386-randconfig-b115-1-nv noapic nolapic acpi=off BOOT_IMAGE=kernel-tests/kernels/i386-randconfig-b115/0d7614f/vmlinuz-3.6.0-rc1
> [    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 210632k/262132k available (6376k kernel code, 51048k reserved, 2851k data, 400k init, 0k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfff8e000 - 0xfffff000   ( 452 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0xd07fd000 - 0xff7fe000   ( 752 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xcfffd000   ( 255 MB)
> [    0.000000]       .init : 0xc1904000 - 0xc1968000   ( 400 kB)
> [    0.000000]       .data : 0xc163a3c9 - 0xc1903280   (2851 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc163a3c9   (6376 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> [    0.000000] NR_IRQS:2304 nr_irqs:48 16
> [    0.000000] CPU 0 irqstacks, hard=cd808000 soft=cd80a000
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
> [    0.000000]  memory used by lock dependency info: 3567 kB
> [    0.000000]  per task-struct memory footprint: 1152 bytes
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
> [    0.000000] tsc: Fast TSC calibration failed
> [    0.000000] tsc: Unable to calibrate against PIT
> [    0.000000] tsc: No reference (HPET/PMTIMER) available
> [    0.000000] tsc: Marking TSC unstable due to could not calculate TSC khz
> [    0.052991] Calibrating delay loop... 8.18 BogoMIPS (lpj=4093)
> [    0.089986] pid_max: default: 32768 minimum: 301
> [    0.241963] Mount-cache hash table entries: 512
> [    1.371791] Initializing cgroup subsys cpuacct
> [    1.383789] Initializing cgroup subsys freezer
> [    1.388788] Initializing cgroup subsys net_cls
> [    1.393788] Initializing cgroup subsys blkio
> [    1.580759] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    1.580759] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    1.580759] tlb_flushall_shift is 0xffffffff
> [    1.584759] CPU: AMD QEMU Virtual CPU version 1.1.0 stepping 03
> [    2.716587] Performance Events: 
> [    2.745582] no APIC, boot with the "lapic" boot parameter to force-enable it.
> [    2.748582] no hardware sampling interrupt available.
> [    2.758580] Broken PMU hardware detected, using software events only.
> [    2.764579] Failed to access perfctr msr (MSR c0010004 is 0)
> [    3.234508] ftrace: Allocated trace_printk buffers
> [    3.790423] Apic disabled
> [    4.148369] device: 'platform': device_add
> [    4.239355] PM: Adding info for No Bus:platform
> [    4.346339] bus: 'platform': registered
> [    4.371335] bus: 'cpu': registered
> [    4.382333] device: 'cpu': device_add
> [    4.420328] PM: Adding info for No Bus:cpu
> [    5.281197] bus: 'virtio': registered
> [    5.436173] NET: Registered protocol family 16
> [    5.622145] device class 'bdi': registering
> [    5.881105] device class 'backlight': registering
> [    5.911101] device class 'video_output': registering
> [    5.923099] device class 'tty': registering
> [    5.933098] device class 'vtconsole': registering
> [    5.953094] device: 'vtcon0': device_add
> [    6.016085] PM: Adding info for No Bus:vtcon0
> [    6.060078] bus: 'spi': registered
> [    6.062078] device class 'spi_master': registering
> [    6.074076] bus: 'hsi': registered
> [    6.082075] bus: 'i2c': registered
> [    6.087074] bus: 'i2c': add driver dummy
> [    6.102072] i2c-core: driver [dummy] registered
> [    6.142066] device class 'dma': registering
> [    6.142066] device: 'cpu0': device_add
> [    6.149065] bus: 'cpu': add device cpu0
> [    6.161063] PM: Adding info for cpu:cpu0
> [    7.911797] device: 'default': device_add
> [    7.950791] PM: Adding info for No Bus:default
> [    8.156759] bio: create slab <bio-0> at 0
> [    8.211751] device class 'block': registering
> [    8.276741] bus: 'i2c': add driver max732x
> [    8.287740] i2c-core: driver [max732x] registered
> [    8.290739] bus: 'spi': add driver mcp23s08
> [    8.294739] bus: 'i2c': add driver mcp230xx
> [    8.297738] i2c-core: driver [mcp230xx] registered
> [    8.299738] bus: 'i2c': add driver pcf857x
> [    8.303737] i2c-core: driver [pcf857x] registered
> [    8.305737] bus: 'platform': add driver tc3589x-gpio
> [    8.317735] device class 'graphics': registering
> [    8.321734] device class 'misc': registering
> [    8.325734] bus: 'i2c': add driver tc3589x
> [    8.330733] i2c-core: driver [tc3589x] registered
> [    8.332733] bus: 'i2c': add driver wm8350
> [    8.335732] i2c-core: driver [wm8350] registered
> [    8.337732] tps65010: version 2 May 2005
> [    8.340732] bus: 'i2c': add driver tps65010
> [    8.343731] i2c-core: driver [tps65010] registered
> [    8.357729] bus: 'i2c': remove driver tps65010
> [    8.361728] driver: 'tps65010': driver_release
> [    8.363728] i2c-core: driver [tps65010] unregistered
> [    8.383725] bus: 'i2c': add driver tps65010
> [    8.388724] i2c-core: driver [tps65010] registered
> [    8.404722] bus: 'i2c': remove driver tps65010
> [    8.405722] driver: 'tps65010': driver_release
> [    8.406721] i2c-core: driver [tps65010] unregistered
> [    8.419720] bus: 'i2c': add driver tps65010
> [    8.422719] i2c-core: driver [tps65010] registered
> [    8.423719] bus: 'i2c': remove driver tps65010
> [    8.425719] driver: 'tps65010': driver_release
> [    8.433717] i2c-core: driver [tps65010] unregistered
> [    8.449715] tps65010: no chip?
> [    8.451715] bus: 'i2c': add driver tps65910
> [    8.471712] i2c-core: driver [tps65910] registered
> [    8.473711] bus: 'i2c': add driver twl
> [    8.478711] i2c-core: driver [twl] registered
> [    8.479710] bus: 'spi': add driver mc13xxx
> [    8.480710] bus: 'spi': add driver ezx-pcap
> [    8.482710] bus: 'i2c': add driver da903x
> [    8.484710] i2c-core: driver [da903x] registered
> [    8.486709] bus: 'i2c': add driver max8998
> [    8.488709] i2c-core: driver [max8998] registered
> [    8.489709] bus: 'i2c': add driver tps65090
> [    8.492708] i2c-core: driver [tps65090] registered
> [    8.493708] bus: 'i2c': add driver aat2870
> [    8.496708] i2c-core: driver [aat2870] registered
> [    8.525703] device class 'scsi_host': registering
> [    8.543701] bus: 'scsi': registered
> [    8.546700] device class 'scsi_device': registering
> [    8.561698] SCSI subsystem initialized
> [    8.589694] device class 'ata_link': registering
> [    8.596693] device class 'ata_port': registering
> [    8.601692] device class 'ata_device': registering
> [    8.612690] libata version 3.00 loaded.
> [    8.615690] device class 'pcmcia_socket': registering
> [    8.627688] bus: 'serio': registered
> [    8.639686] bus: 'gameport': registered
> [    8.642686] device class 'input': registering
> [    8.656683] bus: 'platform': add driver i2c-gpio
> [    8.665682] device class 'hwmon': registering
> [    8.682680] bus: 'mmc': registered
> [    8.684679] device class 'mmc_host': registering
> [    8.699677] bus: 'sdio': registered
> [    8.701677] device class 'leds': registering
> [    8.707676] device class 'devfreq': registering
> [    8.722673] device class 'net': registering
> [    8.806661] device: 'lo': device_add
> [    8.820659] PM: Adding info for No Bus:lo
> [    8.857653] irda_init()
> [    8.870651] NET: Registered protocol family 23
> [    8.880649] NET: Registered protocol family 8
> [    8.882649] NET: Registered protocol family 20
> [    8.886649] device class 'atm': registering
> [    8.889648] device class 'rfkill': registering
> [    8.893647] device: 'rfkill': device_add
> [    8.899647] PM: Adding info for No Bus:rfkill
> [    8.912645] Switching to clocksource pit
> [   34.164568] device class 'mem': registering
> [   34.166544] device: 'mem': device_add
> [   34.171543] PM: Adding info for No Bus:mem
> [   34.176549] device: 'kmem': device_add
> [   34.180541] PM: Adding info for No Bus:kmem
> [   34.183556] device: 'null': device_add
> [   34.187548] PM: Adding info for No Bus:null
> [   34.191554] device: 'zero': device_add
> [   34.195542] PM: Adding info for No Bus:zero
> [   34.199569] device: 'full': device_add
> [   34.203538] PM: Adding info for No Bus:full
> [   34.206552] device: 'random': device_add
> [   34.210540] PM: Adding info for No Bus:random
> [   34.213546] device: 'urandom': device_add
> [   34.217538] PM: Adding info for No Bus:urandom
> [   34.220515] device: 'kmsg': device_add
> [   34.225527] PM: Adding info for No Bus:kmsg
> [   34.227517] device: 'oldmem': device_add
> [   34.232533] PM: Adding info for No Bus:oldmem
> [   34.236548] device: 'tty': device_add
> [   34.241530] PM: Adding info for No Bus:tty
> [   34.246556] device: 'console': device_add
> [   34.250530] PM: Adding info for No Bus:console
> [   34.254535] device: 'tty0': device_add
> [   34.259526] PM: Adding info for No Bus:tty0
> [   34.262534] device class 'vc': registering
> [   34.266529] device: 'vcs': device_add
> [   34.270526] PM: Adding info for No Bus:vcs
> [   34.274538] device: 'vcsa': device_add
> [   34.278526] PM: Adding info for No Bus:vcsa
> [   34.282528] device: 'vcs1': device_add
> [   34.286526] PM: Adding info for No Bus:vcs1
> [   34.289521] device: 'vcsa1': device_add
> [   34.293519] PM: Adding info for No Bus:vcsa1
> [   34.299526] device: 'tty1': device_add
> [   34.303520] PM: Adding info for No Bus:tty1
> [   34.306530] device: 'tty2': device_add
> [   34.311528] PM: Adding info for No Bus:tty2
> [   34.314533] device: 'tty3': device_add
> [   34.318524] PM: Adding info for No Bus:tty3
> [   34.321562] device: 'tty4': device_add
> [   34.325531] PM: Adding info for No Bus:tty4
> [   34.328525] device: 'tty5': device_add
> [   34.332511] PM: Adding info for No Bus:tty5
> [   34.335530] device: 'tty6': device_add
> [   34.340511] PM: Adding info for No Bus:tty6
> [   34.342498] device: 'tty7': device_add
> [   34.347523] PM: Adding info for No Bus:tty7
> [   34.350535] device: 'tty8': device_add
> [   34.354515] PM: Adding info for No Bus:tty8
> [   34.357527] device: 'tty9': device_add
> [   34.361518] PM: Adding info for No Bus:tty9
> [   34.364520] device: 'tty10': device_add
> [   34.368514] PM: Adding info for No Bus:tty10
> [   34.371517] device: 'tty11': device_add
> [   34.375523] PM: Adding info for No Bus:tty11
> [   34.378486] device: 'tty12': device_add
> [   34.382509] PM: Adding info for No Bus:tty12
> [   34.386520] device: 'tty13': device_add
> [   34.390528] PM: Adding info for No Bus:tty13
> [   34.393510] device: 'tty14': device_add
> [   34.398514] PM: Adding info for No Bus:tty14
> [   34.400494] device: 'tty15': device_add
> [   34.405529] PM: Adding info for No Bus:tty15
> [   34.408509] device: 'tty16': device_add
> [   34.412507] PM: Adding info for No Bus:tty16
> [   34.415519] device: 'tty17': device_add
> [   34.419499] PM: Adding info for No Bus:tty17
> [   34.422511] device: 'tty18': device_add
> [   34.427494] PM: Adding info for No Bus:tty18
> [   34.430506] device: 'tty19': device_add
> [   34.434501] PM: Adding info for No Bus:tty19
> [   34.437518] device: 'tty20': device_add
> [   34.441518] PM: Adding info for No Bus:tty20
> [   34.443502] device: 'tty21': device_add
> [   34.449506] PM: Adding info for No Bus:tty21
> [   34.452915] device: 'tty22': device_add
> [   34.452915] PM: Adding info for No Bus:tty22
> [   34.453589] device: 'tty23': device_add
> [   34.453589] PM: Adding info for No Bus:tty23
> [   34.453589] device: 'tty24': device_add
> [   34.454965] PM: Adding info for No Bus:tty24
> [   34.454965] device: 'tty25': device_add
> [   34.454965] PM: Adding info for No Bus:tty25
> [   34.454965] device: 'tty26': device_add
> [   34.494865] PM: Adding info for No Bus:tty26
> [   34.496492] device: 'tty27': device_add
> [   34.500485] PM: Adding info for No Bus:tty27
> [   34.503491] device: 'tty28': device_add
> [   34.507491] PM: Adding info for No Bus:tty28
> [   34.511508] device: 'tty29': device_add
> [   34.515489] PM: Adding info for No Bus:tty29
> [   34.518500] device: 'tty30': device_add
> [   34.522490] PM: Adding info for No Bus:tty30
> [   34.525489] device: 'tty31': device_add
> [   34.529502] PM: Adding info for No Bus:tty31
> [   34.532486] device: 'tty32': device_add
> [   34.536490] PM: Adding info for No Bus:tty32
> [   34.539487] device: 'tty33': device_add
> [   34.543487] PM: Adding info for No Bus:tty33
> [   34.546466] device: 'tty34': device_add
> [   34.551485] PM: Adding info for No Bus:tty34
> [   34.554486] device: 'tty35': device_add
> [   34.558496] PM: Adding info for No Bus:tty35
> [   34.561494] device: 'tty36': device_add
> [   34.565481] PM: Adding info for No Bus:tty36
> [   34.569487] device: 'tty37': device_add
> [   34.573488] PM: Adding info for No Bus:tty37
> [   34.576483] device: 'tty38': device_add
> [   34.580477] PM: Adding info for No Bus:tty38
> [   34.583486] device: 'tty39': device_add
> [   34.587482] PM: Adding info for No Bus:tty39
> [   34.589484] device: 'tty40': device_add
> [   34.593484] PM: Adding info for No Bus:tty40
> [   34.596486] device: 'tty41': device_add
> [   34.600474] PM: Adding info for No Bus:tty41
> [   34.603455] device: 'tty42': device_add
> [   34.608492] PM: Adding info for No Bus:tty42
> [   34.611495] device: 'tty43': device_add
> [   34.615487] PM: Adding info for No Bus:tty43
> [   34.618484] device: 'tty44': device_add
> [   34.622468] PM: Adding info for No Bus:tty44
> [   34.626484] device: 'tty45': device_add
> [   34.630469] PM: Adding info for No Bus:tty45
> [   34.633490] device: 'tty46': device_add
> [   34.637489] PM: Adding info for No Bus:tty46
> [   34.640455] device: 'tty47': device_add
> [   34.645473] PM: Adding info for No Bus:tty47
> [   34.647453] device: 'tty48': device_add
> [   34.652466] PM: Adding info for No Bus:tty48
> [   34.655468] device: 'tty49': device_add
> [   34.659479] PM: Adding info for No Bus:tty49
> [   34.662469] device: 'tty50': device_add
> [   34.667465] PM: Adding info for No Bus:tty50
> [   34.670473] device: 'tty51': device_add
> [   34.674480] PM: Adding info for No Bus:tty51
> [   34.677468] device: 'tty52': device_add
> [   34.681469] PM: Adding info for No Bus:tty52
> [   34.684509] device: 'tty53': device_add
> [   34.689471] PM: Adding info for No Bus:tty53
> [   34.691449] device: 'tty54': device_add
> [   34.696469] PM: Adding info for No Bus:tty54
> [   34.699484] device: 'tty55': device_add
> [   34.703466] PM: Adding info for No Bus:tty55
> [   34.706485] device: 'tty56': device_add
> [   34.710474] PM: Adding info for No Bus:tty56
> [   34.712461] device: 'tty57': device_add
> [   34.716462] PM: Adding info for No Bus:tty57
> [   34.719466] device: 'tty58': device_add
> [   34.724459] PM: Adding info for No Bus:tty58
> [   34.726439] device: 'tty59': device_add
> [   34.731454] PM: Adding info for No Bus:tty59
> [   34.733488] device: 'tty60': device_add
> [   34.737460] PM: Adding info for No Bus:tty60
> [   34.741464] device: 'tty61': device_add
> [   34.745476] PM: Adding info for No Bus:tty61
> [   34.748484] device: 'tty62': device_add
> [   34.752456] PM: Adding info for No Bus:tty62
> [   34.755461] device: 'tty63': device_add
> [   34.759454] PM: Adding info for No Bus:tty63
> [   34.774458] device class 'firmware': registering
> [   34.778457] device class 'thermal': registering
> [   34.785450] bus: 'ssb': registered
> [   34.790452] bus: 'bcma': registered
> [   34.795451] NET: Registered protocol family 1
> [   34.866473] Unpacking initramfs...
> [   79.950867] [sched_delayed] sched: RT throttling activated
> [  262.632921] Freeing initrd memory: 25284k freed
> [  263.050852] Registering platform device 'rtc_cmos'. Parent at platform
> [  263.051859] device: 'rtc_cmos': device_add
> [  263.053837] bus: 'platform': add device rtc_cmos
> [  263.057861] PM: Adding info for platform:rtc_cmos
> [  263.064876] platform rtc_cmos: registered platform RTC device (no PNP device found)
> [  263.076867] device class 'cpuid': registering
> [  263.080856] device: 'cpu0': device_add
> [  263.084856] PM: Adding info for No Bus:cpu0
> [  263.089850] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
> [  263.096860] device: 'apm_bios': device_add
> [  263.105909] PM: Adding info for No Bus:apm_bios
> [  263.111847] Registering platform device 'pcspkr'. Parent at platform
> [  263.113840] device: 'pcspkr': device_add
> [  263.115826] bus: 'platform': add device pcspkr
> [  263.118856] PM: Adding info for platform:pcspkr
> [  263.171010] bus: 'clocksource': registered
> [  263.173822] device: 'clocksource': device_add
> [  263.179878] PM: Adding info for No Bus:clocksource
> [  263.180836] device: 'clocksource0': device_add
> [  263.186880] bus: 'clocksource': add device clocksource0
> [  263.189848] PM: Adding info for clocksource:clocksource0
> [  263.207860] bus: 'platform': add driver alarmtimer
> [  263.212859] Registering platform device 'alarmtimer'. Parent at platform
> [  263.214107] device: 'alarmtimer': device_add
> [  263.215882] bus: 'platform': add device alarmtimer
> [  263.219863] PM: Adding info for platform:alarmtimer
> [  263.223879] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
> [  263.225868] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
> [  263.229859] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
> [  263.232840] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
> [  263.243838] bus: 'rttest': registered
> [  263.246133] device: 'rttest': device_add
> [  263.249840] PM: Adding info for No Bus:rttest
> [  263.255840] device: 'rttest0': device_add
> [  263.259848] bus: 'rttest': add device rttest0
> [  263.262862] PM: Adding info for rttest:rttest0
> [  263.269836] device: 'rttest1': device_add
> [  263.271814] bus: 'rttest': add device rttest1
> [  263.275836] PM: Adding info for rttest:rttest1
> [  263.282871] device: 'rttest2': device_add
> [  263.285827] bus: 'rttest': add device rttest2
> [  263.289829] PM: Adding info for rttest:rttest2
> [  263.295870] device: 'rttest3': device_add
> [  263.298870] bus: 'rttest': add device rttest3
> [  263.302846] PM: Adding info for rttest:rttest3
> [  263.309035] device: 'rttest4': device_add
> [  263.311811] bus: 'rttest': add device rttest4
> [  263.315830] PM: Adding info for rttest:rttest4
> [  263.323833] device: 'rttest5': device_add
> [  263.326839] bus: 'rttest': add device rttest5
> [  263.329826] PM: Adding info for rttest:rttest5
> [  263.336859] device: 'rttest6': device_add
> [  263.339841] bus: 'rttest': add device rttest6
> [  263.343836] PM: Adding info for rttest:rttest6
> [  263.350833] device: 'rttest7': device_add
> [  263.352844] bus: 'rttest': add device rttest7
> [  263.356842] PM: Adding info for rttest:rttest7
> [  263.360841] Initializing RT-Tester: OK
> [  263.405831] bus: 'event_source': registered
> [  263.407849] device: 'breakpoint': device_add
> [  263.410042] bus: 'event_source': add device breakpoint
> [  263.413825] PM: Adding info for event_source:breakpoint
> [  263.419840] device: 'tracepoint': device_add
> [  263.421803] bus: 'event_source': add device tracepoint
> [  263.426820] PM: Adding info for event_source:tracepoint
> [  263.429836] device: 'software': device_add
> [  263.432822] bus: 'event_source': add device software
> [  263.436815] PM: Adding info for event_source:software
> [  263.474805] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [  264.076699] VFS: Disk quotas dquot_6.5.2
> [  264.087701] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [  264.390909] ROMFS MTD (C) 2007 Red Hat, Inc.
> [  264.426666] device: 'autofs': device_add
> [  264.440937] PM: Adding info for No Bus:autofs
> [  264.453942] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> [  264.646624] OCFS2 1.5.0
> [  264.677637] OCFS2 DLMFS 1.5.0
> [  264.692836] OCFS2 User DLM kernel interface loaded
> [  264.693863] OCFS2 Node Manager 1.5.0
> [  264.779822] msgmni has been set to 460
> [  265.254533] device class 'bsg': registering
> [  265.261560] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
> [  265.264579] io scheduler noop registered (default)
> [  265.267542] io scheduler deadline registered
> [  265.270519] start plist test
> [  265.335745] end plist test
> [  265.341748] list_sort_test: start testing list_sort()
> [  265.730771] bus: 'platform': add driver basic-mmio-gpio
> [  265.756751] bus: 'platform': add driver hgafb
> [  265.774780] Registering platform device 'hgafb.0'. Parent at platform
> [  265.776742] device: 'hgafb.0': device_add
> [  265.782747] bus: 'platform': add device hgafb.0
> [  265.798741] PM: Adding info for platform:hgafb.0
> [  265.807744] bus: 'platform': driver_probe_device: matched device hgafb.0 with driver hgafb
> [  265.808969] bus: 'platform': really_probe: probing driver hgafb with device hgafb.0
> [  265.824812] hgafb: HGA card not detected.
> [  265.824812] hgafb: probe of hgafb.0 failed with error -22
> [  265.837721] bus: 'platform': add driver tmio-fb
> [  265.859699] bus: 'platform': add driver broadsheetfb
> [  265.860820] bus: 'platform': add driver auo_k1901fb
> [  265.861940] bus: 'platform': add driver s1d13xxxfb
> [  265.861940] bus: 'virtio': add driver virtio_balloon
> [  265.861940] device: 'ptyp0': device_add
> [  265.864615] PM: Adding info for No Bus:ptyp0
> [  265.864615] device: 'ptyp1': device_add
> [  265.864615] PM: Adding info for No Bus:ptyp1
> [  265.864615] device: 'ptyp2': device_add
> [  265.884734] PM: Adding info for No Bus:ptyp2
> [  265.897715] device: 'ptyp3': device_add
> [  265.916723] PM: Adding info for No Bus:ptyp3
> [  265.925729] device: 'ptyp4': device_add
> [  265.935771] PM: Adding info for No Bus:ptyp4
> [  265.937534] device: 'ptyp5': device_add
> [  265.944688] PM: Adding info for No Bus:ptyp5
> [  265.948449] device: 'ptyp6': device_add
> [  265.955448] PM: Adding info for No Bus:ptyp6
> [  265.958450] device: 'ptyp7': device_add
> [  265.963471] PM: Adding info for No Bus:ptyp7
> [  265.968434] device: 'ptyp8': device_add
> [  265.975436] PM: Adding info for No Bus:ptyp8
> [  265.978494] device: 'ptyp9': device_add
> [  265.987439] PM: Adding info for No Bus:ptyp9
> [  265.990436] device: 'ptypa': device_add
> [  265.996479] PM: Adding info for No Bus:ptypa
> [  266.000442] device: 'ptypb': device_add
> [  266.005419] PM: Adding info for No Bus:ptypb
> [  266.007417] device: 'ptypc': device_add
> [  266.011667] PM: Adding info for No Bus:ptypc
> [  266.011667] device: 'ptypd': device_add
> [  266.011667] PM: Adding info for No Bus:ptypd
> [  266.011667] device: 'ptype': device_add
> [  266.012619] PM: Adding info for No Bus:ptype
> [  266.012619] device: 'ptypf': device_add
> [  266.068767] PM: Adding info for No Bus:ptypf
> [  266.218747] device: 'ptyq0': device_add
> [  266.437619] PM: Adding info for No Bus:ptyq0
> [  266.485703] device: 'ptyq1': device_add
> [  266.660611] PM: Adding info for No Bus:ptyq1
> [  266.766661] device: 'ptyq2': device_add
> [  266.932636] PM: Adding info for No Bus:ptyq2
> [  267.000633] device: 'ptyq3': device_add
> [  267.181600] PM: Adding info for No Bus:ptyq3
> [  267.333584] device: 'ptyq4': device_add
> [  267.580542] PM: Adding info for No Bus:ptyq4
> [  267.711524] device: 'ptyq5': device_add
> [  268.652379] PM: Adding info for No Bus:ptyq5
> [  268.801351] device: 'ptyq6': device_add
> [  269.153945] PM: Adding info for No Bus:ptyq6
> [  269.155923] device: 'ptyq7': device_add
> [  269.449252] PM: Adding info for No Bus:ptyq7
> [  269.736216] device: 'ptyq8': device_add
> [  270.639970] PM: Adding info for No Bus:ptyq8
> [  270.649012] device: 'ptyq9': device_add
> [  270.663877] PM: Adding info for No Bus:ptyq9
> [  270.670956] device: 'ptyqa': device_add
> [  270.670956] PM: Adding info for No Bus:ptyqa
> [  270.674157] device: 'ptyqb': device_add
> [  270.782968] PM: Adding info for No Bus:ptyqb
> [  270.826866] device: 'ptyqc': device_add
> [  270.836879] PM: Adding info for No Bus:ptyqc
> [  270.841876] device: 'ptyqd': device_add
> [  270.853676] PM: Adding info for No Bus:ptyqd
> [  270.856684] device: 'ptyqe': device_add
> [  270.862677] PM: Adding info for No Bus:ptyqe
> [  270.866674] device: 'ptyqf': device_add
> [  270.871674] PM: Adding info for No Bus:ptyqf
> [  270.874680] device: 'ptyr0': device_add
> [  270.879671] PM: Adding info for No Bus:ptyr0
> [  270.883675] device: 'ptyr1': device_add
> [  270.888666] PM: Adding info for No Bus:ptyr1
> [  270.891675] device: 'ptyr2': device_add
> [  270.896666] PM: Adding info for No Bus:ptyr2
> [  270.899658] device: 'ptyr3': device_add
> [  270.904669] PM: Adding info for No Bus:ptyr3
> [  270.908666] device: 'ptyr4': device_add
> [  270.912673] PM: Adding info for No Bus:ptyr4
> [  270.915665] device: 'ptyr5': device_add
> [  270.920695] PM: Adding info for No Bus:ptyr5
> [  270.923668] device: 'ptyr6': device_add
> [  270.928662] PM: Adding info for No Bus:ptyr6
> [  270.931679] device: 'ptyr7': device_add
> [  270.936670] PM: Adding info for No Bus:ptyr7
> [  270.939658] device: 'ptyr8': device_add
> [  270.944671] PM: Adding info for No Bus:ptyr8
> [  270.947651] device: 'ptyr9': device_add
> [  270.952663] PM: Adding info for No Bus:ptyr9
> [  270.955654] device: 'ptyra': device_add
> [  270.961654] PM: Adding info for No Bus:ptyra
> [  270.964693] device: 'ptyrb': device_add
> [  270.968660] PM: Adding info for No Bus:ptyrb
> [  270.972662] device: 'ptyrc': device_add
> [  270.977650] PM: Adding info for No Bus:ptyrc
> [  270.980659] device: 'ptyrd': device_add
> [  270.986651] PM: Adding info for No Bus:ptyrd
> [  270.989657] device: 'ptyre': device_add
> [  270.994649] PM: Adding info for No Bus:ptyre
> [  270.997675] device: 'ptyrf': device_add
> [  271.002657] PM: Adding info for No Bus:ptyrf
> [  271.006683] device: 'ptys0': device_add
> [  271.010649] PM: Adding info for No Bus:ptys0
> [  271.014655] device: 'ptys1': device_add
> [  271.018653] PM: Adding info for No Bus:ptys1
> [  271.022652] device: 'ptys2': device_add
> [  271.027651] PM: Adding info for No Bus:ptys2
> [  271.030649] device: 'ptys3': device_add
> [  271.035642] PM: Adding info for No Bus:ptys3
> [  271.038687] device: 'ptys4': device_add
> [  271.043642] PM: Adding info for No Bus:ptys4
> [  271.046642] device: 'ptys5': device_add
> [  271.050646] PM: Adding info for No Bus:ptys5
> [  271.054644] device: 'ptys6': device_add
> [  271.059641] PM: Adding info for No Bus:ptys6
> [  271.062642] device: 'ptys7': device_add
> [  271.067634] PM: Adding info for No Bus:ptys7
> [  271.070653] device: 'ptys8': device_add
> [  271.075645] PM: Adding info for No Bus:ptys8
> [  271.078633] device: 'ptys9': device_add
> [  271.084645] PM: Adding info for No Bus:ptys9
> [  271.087635] device: 'ptysa': device_add
> [  271.091650] PM: Adding info for No Bus:ptysa
> [  271.096637] device: 'ptysb': device_add
> [  271.101635] PM: Adding info for No Bus:ptysb
> [  271.104648] device: 'ptysc': device_add
> [  271.109642] PM: Adding info for No Bus:ptysc
> [  271.112633] device: 'ptysd': device_add
> [  271.117648] PM: Adding info for No Bus:ptysd
> [  271.120658] device: 'ptyse': device_add
> [  271.125627] PM: Adding info for No Bus:ptyse
> [  271.128651] device: 'ptysf': device_add
> [  271.133630] PM: Adding info for No Bus:ptysf
> [  271.136608] device: 'ptyt0': device_add
> [  271.141631] PM: Adding info for No Bus:ptyt0
> [  271.144623] device: 'ptyt1': device_add
> [  271.149628] PM: Adding info for No Bus:ptyt1
> [  271.152648] device: 'ptyt2': device_add
> [  271.157638] PM: Adding info for No Bus:ptyt2
> [  271.160628] device: 'ptyt3': device_add
> [  271.166641] PM: Adding info for No Bus:ptyt3
> [  271.169638] device: 'ptyt4': device_add
> [  271.174633] PM: Adding info for No Bus:ptyt4
> [  271.177645] device: 'ptyt5': device_add
> [  271.182626] PM: Adding info for No Bus:ptyt5
> [  271.185616] device: 'ptyt6': device_add
> [  271.190633] PM: Adding info for No Bus:ptyt6
> [  271.194622] device: 'ptyt7': device_add
> [  271.199620] PM: Adding info for No Bus:ptyt7
> [  271.202641] device: 'ptyt8': device_add
> [  271.207634] PM: Adding info for No Bus:ptyt8
> [  271.209622] device: 'ptyt9': device_add
> [  271.214628] PM: Adding info for No Bus:ptyt9
> [  271.217625] device: 'ptyta': device_add
> [  271.222618] PM: Adding info for No Bus:ptyta
> [  271.225631] device: 'ptytb': device_add
> [  271.230616] PM: Adding info for No Bus:ptytb
> [  271.233636] device: 'ptytc': device_add
> [  271.239624] PM: Adding info for No Bus:ptytc
> [  271.242628] device: 'ptytd': device_add
> [  271.247622] PM: Adding info for No Bus:ptytd
> [  271.250607] device: 'ptyte': device_add
> [  271.253609] PM: Adding info for No Bus:ptyte
> [  271.257612] device: 'ptytf': device_add
> [  271.261636] PM: Adding info for No Bus:ptytf
> [  271.263625] device: 'ptyu0': device_add
> [  271.268614] PM: Adding info for No Bus:ptyu0
> [  271.271631] device: 'ptyu1': device_add
> [  271.276616] PM: Adding info for No Bus:ptyu1
> [  271.279612] device: 'ptyu2': device_add
> [  271.285607] PM: Adding info for No Bus:ptyu2
> [  271.288608] device: 'ptyu3': device_add
> [  271.293606] PM: Adding info for No Bus:ptyu3
> [  271.296606] device: 'ptyu4': device_add
> [  271.301602] PM: Adding info for No Bus:ptyu4
> [  271.304604] device: 'ptyu5': device_add
> [  271.309608] PM: Adding info for No Bus:ptyu5
> [  271.312619] device: 'ptyu6': device_add
> [  271.317608] PM: Adding info for No Bus:ptyu6
> [  271.320600] device: 'ptyu7': device_add
> [  271.325601] PM: Adding info for No Bus:ptyu7
> [  271.328611] device: 'ptyu8': device_add
> [  271.334595] PM: Adding info for No Bus:ptyu8
> [  271.337600] device: 'ptyu9': device_add
> [  271.342600] PM: Adding info for No Bus:ptyu9
> [  271.345601] device: 'ptyua': device_add
> [  271.350599] PM: Adding info for No Bus:ptyua
> [  271.353616] device: 'ptyub': device_add
> [  271.360619] PM: Adding info for No Bus:ptyub
> [  271.363616] device: 'ptyuc': device_add
> [  271.369601] PM: Adding info for No Bus:ptyuc
> [  271.372571] device: 'ptyud': device_add
> [  271.378589] PM: Adding info for No Bus:ptyud
> [  271.381609] device: 'ptyue': device_add
> [  271.386590] PM: Adding info for No Bus:ptyue
> [  271.390610] device: 'ptyuf': device_add
> [  271.394592] PM: Adding info for No Bus:ptyuf
> [  271.398597] device: 'ptyv0': device_add
> [  271.402592] PM: Adding info for No Bus:ptyv0
> [  271.406592] device: 'ptyv1': device_add
> [  271.411594] PM: Adding info for No Bus:ptyv1
> [  271.414591] device: 'ptyv2': device_add
> [  271.420582] PM: Adding info for No Bus:ptyv2
> [  271.423611] device: 'ptyv3': device_add
> [  271.428585] PM: Adding info for No Bus:ptyv3
> [  271.431614] device: 'ptyv4': device_add
> [  271.436582] PM: Adding info for No Bus:ptyv4
> [  271.439587] device: 'ptyv5': device_add
> [  271.444587] PM: Adding info for No Bus:ptyv5
> [  271.446586] device: 'ptyv6': device_add
> [  271.451578] PM: Adding info for No Bus:ptyv6
> [  271.454594] device: 'ptyv7': device_add
> [  271.459582] PM: Adding info for No Bus:ptyv7
> [  271.462586] device: 'ptyv8': device_add
> [  271.467588] PM: Adding info for No Bus:ptyv8
> [  271.470580] device: 'ptyv9': device_add
> [  271.475585] PM: Adding info for No Bus:ptyv9
> [  271.479578] device: 'ptyva': device_add
> [  271.483588] PM: Adding info for No Bus:ptyva
> [  271.487578] device: 'ptyvb': device_add
> [  271.492589] PM: Adding info for No Bus:ptyvb
> [  271.496581] device: 'ptyvc': device_add
> [  271.501568] PM: Adding info for No Bus:ptyvc
> [  271.503553] device: 'ptyvd': device_add
> [  271.509563] PM: Adding info for No Bus:ptyvd
> [  271.512570] device: 'ptyve': device_add
> [  271.517577] PM: Adding info for No Bus:ptyve
> [  271.520602] device: 'ptyvf': device_add
> [  271.525574] PM: Adding info for No Bus:ptyvf
> [  271.528602] device: 'ptyw0': device_add
> [  271.534569] PM: Adding info for No Bus:ptyw0
> [  271.537574] device: 'ptyw1': device_add
> [  271.542620] PM: Adding info for No Bus:ptyw1
> [  271.545694] device: 'ptyw2': device_add
> [  271.545694] PM: Adding info for No Bus:ptyw2
> [  271.545694] device: 'ptyw3': device_add
> [  271.580564] PM: Adding info for No Bus:ptyw3
> [  271.582580] device: 'ptyw4': device_add
> [  271.587557] PM: Adding info for No Bus:ptyw4
> [  271.590554] device: 'ptyw5': device_add
> [  271.594556] PM: Adding info for No Bus:ptyw5
> [  271.599550] device: 'ptyw6': device_add
> [  271.603552] PM: Adding info for No Bus:ptyw6
> [  271.607558] device: 'ptyw7': device_add
> [  271.611583] PM: Adding info for No Bus:ptyw7
> [  271.615567] device: 'ptyw8': device_add
> [  271.619561] PM: Adding info for No Bus:ptyw8
> [  271.622550] device: 'ptyw9': device_add
> [  271.628571] PM: Adding info for No Bus:ptyw9
> [  271.632557] device: 'ptywa': device_add
> [  271.636558] PM: Adding info for No Bus:ptywa
> [  271.640552] device: 'ptywb': device_add
> [  271.645553] PM: Adding info for No Bus:ptywb
> [  271.648604] device: 'ptywc': device_add
> [  271.653554] PM: Adding info for No Bus:ptywc
> [  271.656550] device: 'ptywd': device_add
> [  271.661557] PM: Adding info for No Bus:ptywd
> [  271.664549] device: 'ptywe': device_add
> [  271.670552] PM: Adding info for No Bus:ptywe
> [  271.672553] device: 'ptywf': device_add
> [  271.677551] PM: Adding info for No Bus:ptywf
> [  271.680553] device: 'ptyx0': device_add
> [  271.684546] PM: Adding info for No Bus:ptyx0
> [  271.686544] device: 'ptyx1': device_add
> [  271.690546] PM: Adding info for No Bus:ptyx1
> [  271.693526] device: 'ptyx2': device_add
> [  271.698551] PM: Adding info for No Bus:ptyx2
> [  271.701554] device: 'ptyx3': device_add
> [  271.706553] PM: Adding info for No Bus:ptyx3
> [  271.710553] device: 'ptyx4': device_add
> [  271.714561] PM: Adding info for No Bus:ptyx4
> [  271.717532] device: 'ptyx5': device_add
> [  271.722546] PM: Adding info for No Bus:ptyx5
> [  271.725557] device: 'ptyx6': device_add
> [  271.730537] PM: Adding info for No Bus:ptyx6
> [  271.733540] device: 'ptyx7': device_add
> [  271.739544] PM: Adding info for No Bus:ptyx7
> [  271.742535] device: 'ptyx8': device_add
> [  271.746548] PM: Adding info for No Bus:ptyx8
> [  271.750538] device: 'ptyx9': device_add
> [  271.754559] PM: Adding info for No Bus:ptyx9
> [  271.757538] device: 'ptyxa': device_add
> [  271.762536] PM: Adding info for No Bus:ptyxa
> [  271.765562] device: 'ptyxb': device_add
> [  271.770543] PM: Adding info for No Bus:ptyxb
> [  271.773553] device: 'ptyxc': device_add
> [  271.778539] PM: Adding info for No Bus:ptyxc
> [  271.781533] device: 'ptyxd': device_add
> [  271.786540] PM: Adding info for No Bus:ptyxd
> [  271.789531] device: 'ptyxe': device_add
> [  271.794533] PM: Adding info for No Bus:ptyxe
> [  271.797534] device: 'ptyxf': device_add
> [  271.802529] PM: Adding info for No Bus:ptyxf
> [  271.805551] device: 'ptyy0': device_add
> [  271.811533] PM: Adding info for No Bus:ptyy0
> [  271.814533] device: 'ptyy1': device_add
> [  271.819522] PM: Adding info for No Bus:ptyy1
> [  271.822540] device: 'ptyy2': device_add
> [  271.827529] PM: Adding info for No Bus:ptyy2
> [  271.830525] device: 'ptyy3': device_add
> [  271.835521] PM: Adding info for No Bus:ptyy3
> [  271.838519] device: 'ptyy4': device_add
> [  271.841744] PM: Adding info for No Bus:ptyy4
> [  271.844502] device: 'ptyy5': device_add
> [  271.845322] PM: Adding info for No Bus:ptyy5
> [  271.845322] device: 'ptyy6': device_add
> [  271.849528] PM: Adding info for No Bus:ptyy6
> [  271.852510] device: 'ptyy7': device_add
> [  271.857523] PM: Adding info for No Bus:ptyy7
> [  271.860512] device: 'ptyy8': device_add
> [  271.865512] PM: Adding info for No Bus:ptyy8
> [  271.868509] device: 'ptyy9': device_add
> [  271.872511] PM: Adding info for No Bus:ptyy9
> [  271.876524] device: 'ptyya': device_add
> [  271.881532] PM: Adding info for No Bus:ptyya
> [  271.884512] device: 'ptyyb': device_add
> [  271.889521] PM: Adding info for No Bus:ptyyb
> [  271.893524] device: 'ptyyc': device_add
> [  271.897517] PM: Adding info for No Bus:ptyyc
> [  271.901513] device: 'ptyyd': device_add
> [  271.905513] PM: Adding info for No Bus:ptyyd
> [  271.908510] device: 'ptyye': device_add
> [  271.913531] PM: Adding info for No Bus:ptyye
> [  271.917507] device: 'ptyyf': device_add
> [  271.922513] PM: Adding info for No Bus:ptyyf
> [  271.925510] device: 'ptyz0': device_add
> [  271.929509] PM: Adding info for No Bus:ptyz0
> [  271.932510] device: 'ptyz1': device_add
> [  271.937517] PM: Adding info for No Bus:ptyz1
> [  271.940484] device: 'ptyz2': device_add
> [  271.945527] PM: Adding info for No Bus:ptyz2
> [  271.948513] device: 'ptyz3': device_add
> [  271.953513] PM: Adding info for No Bus:ptyz3
> [  271.956510] device: 'ptyz4': device_add
> [  271.961500] PM: Adding info for No Bus:ptyz4
> [  271.964509] device: 'ptyz5': device_add
> [  271.969517] PM: Adding info for No Bus:ptyz5
> [  271.972528] device: 'ptyz6': device_add
> [  271.977503] PM: Adding info for No Bus:ptyz6
> [  271.980509] device: 'ptyz7': device_add
> [  271.984499] PM: Adding info for No Bus:ptyz7
> [  271.988505] device: 'ptyz8': device_add
> [  271.992495] PM: Adding info for No Bus:ptyz8
> [  271.995509] device: 'ptyz9': device_add
> [  272.000508] PM: Adding info for No Bus:ptyz9
> [  272.004523] device: 'ptyza': device_add
> [  272.008499] PM: Adding info for No Bus:ptyza
> [  272.012496] device: 'ptyzb': device_add
> [  272.016500] PM: Adding info for No Bus:ptyzb
> [  272.019497] device: 'ptyzc': device_add
> [  272.024500] PM: Adding info for No Bus:ptyzc
> [  272.027489] device: 'ptyzd': device_add
> [  272.032503] PM: Adding info for No Bus:ptyzd
> [  272.035496] device: 'ptyze': device_add
> [  272.041493] PM: Adding info for No Bus:ptyze
> [  272.044487] device: 'ptyzf': device_add
> [  272.050495] PM: Adding info for No Bus:ptyzf
> [  272.054510] device: 'ptya0': device_add
> [  272.058500] PM: Adding info for No Bus:ptya0
> [  272.061482] device: 'ptya1': device_add
> [  272.066501] PM: Adding info for No Bus:ptya1
> [  272.069506] device: 'ptya2': device_add
> [  272.074506] PM: Adding info for No Bus:ptya2
> [  272.077487] device: 'ptya3': device_add
> [  272.082488] PM: Adding info for No Bus:ptya3
> [  272.085494] device: 'ptya4': device_add
> [  272.091488] PM: Adding info for No Bus:ptya4
> [  272.094505] device: 'ptya5': device_add
> [  272.099492] PM: Adding info for No Bus:ptya5
> [  272.102496] device: 'ptya6': device_add
> [  272.107497] PM: Adding info for No Bus:ptya6
> [  272.110506] device: 'ptya7': device_add
> [  272.115482] PM: Adding info for No Bus:ptya7
> [  272.118492] device: 'ptya8': device_add
> [  272.122478] PM: Adding info for No Bus:ptya8
> [  272.125501] device: 'ptya9': device_add
> [  272.130494] PM: Adding info for No Bus:ptya9
> [  272.133500] device: 'ptyaa': device_add
> [  272.138487] PM: Adding info for No Bus:ptyaa
> [  272.141477] device: 'ptyab': device_add
> [  272.145476] PM: Adding info for No Bus:ptyab
> [  272.149484] device: 'ptyac': device_add
> [  272.153479] PM: Adding info for No Bus:ptyac
> [  272.156483] device: 'ptyad': device_add
> [  272.161474] PM: Adding info for No Bus:ptyad
> [  272.165503] device: 'ptyae': device_add
> [  272.169479] PM: Adding info for No Bus:ptyae
> [  272.173485] device: 'ptyaf': device_add
> [  272.177485] PM: Adding info for No Bus:ptyaf
> [  272.181477] device: 'ptyb0': device_add
> [  272.185478] PM: Adding info for No Bus:ptyb0
> [  272.188487] device: 'ptyb1': device_add
> [  272.193467] PM: Adding info for No Bus:ptyb1
> [  272.196473] device: 'ptyb2': device_add
> [  272.200470] PM: Adding info for No Bus:ptyb2
> [  272.203492] device: 'ptyb3': device_add
> [  272.208480] PM: Adding info for No Bus:ptyb3
> [  272.211486] device: 'ptyb4': device_add
> [  272.216465] PM: Adding info for No Bus:ptyb4
> [  272.220480] device: 'ptyb5': device_add
> [  272.224465] PM: Adding info for No Bus:ptyb5
> [  272.228471] device: 'ptyb6': device_add
> [  272.232474] PM: Adding info for No Bus:ptyb6
> [  272.235484] device: 'ptyb7': device_add
> [  272.240476] PM: Adding info for No Bus:ptyb7
> [  272.243480] device: 'ptyb8': device_add
> [  272.247488] PM: Adding info for No Bus:ptyb8
> [  272.251470] device: 'ptyb9': device_add
> [  272.255466] PM: Adding info for No Bus:ptyb9
> [  272.258472] device: 'ptyba': device_add
> [  272.263477] PM: Adding info for No Bus:ptyba
> [  272.266471] device: 'ptybb': device_add
> [  272.272467] PM: Adding info for No Bus:ptybb
> [  272.275476] device: 'ptybc': device_add
> [  272.280473] PM: Adding info for No Bus:ptybc
> [  272.283473] device: 'ptybd': device_add
> [  272.287482] PM: Adding info for No Bus:ptybd
> [  272.290481] device: 'ptybe': device_add
> [  272.295472] PM: Adding info for No Bus:ptybe
> [  272.297474] device: 'ptybf': device_add
> [  272.302476] PM: Adding info for No Bus:ptybf
> [  272.305470] device: 'ptyc0': device_add
> [  272.310468] PM: Adding info for No Bus:ptyc0
> [  272.313469] device: 'ptyc1': device_add
> [  272.318473] PM: Adding info for No Bus:ptyc1
> [  272.321470] device: 'ptyc2': device_add
> [  272.325465] PM: Adding info for No Bus:ptyc2
> [  272.328463] device: 'ptyc3': device_add
> [  272.333465] PM: Adding info for No Bus:ptyc3
> [  272.337492] device: 'ptyc4': device_add
> [  272.341467] PM: Adding info for No Bus:ptyc4
> [  272.359455] device: 'ptyc5': device_add
> [  272.376460] PM: Adding info for No Bus:ptyc5
> [  272.378444] device: 'ptyc6': device_add
> [  272.382488] PM: Adding info for No Bus:ptyc6
> [  272.385445] device: 'ptyc7': device_add
> [  272.390474] PM: Adding info for No Bus:ptyc7
> [  272.393482] device: 'ptyc8': device_add
> [  272.397463] PM: Adding info for No Bus:ptyc8
> [  272.401464] device: 'ptyc9': device_add
> [  272.405454] PM: Adding info for No Bus:ptyc9
> [  272.409709] device: 'ptyca': device_add
> [  272.410555] PM: Adding info for No Bus:ptyca
> [  272.410555] device: 'ptycb': device_add
> [  272.410555] PM: Adding info for No Bus:ptycb
> [  272.410555] device: 'ptycc': device_add
> [  272.415626] PM: Adding info for No Bus:ptycc
> [  272.415626] device: 'ptycd': device_add
> [  272.842325] PM: Adding info for No Bus:ptycd
> [  272.853853] device: 'ptyce': device_add
> [  272.857626] PM: Adding info for No Bus:ptyce
> [  272.868808] device: 'ptycf': device_add
> [  272.878430] PM: Adding info for No Bus:ptycf
> [  272.881687] device: 'ptyd0': device_add
> [  272.883755] PM: Adding info for No Bus:ptyd0
> [  272.885697] device: 'ptyd1': device_add
> [  272.887687] PM: Adding info for No Bus:ptyd1
> [  272.889675] device: 'ptyd2': device_add
> [  272.894687] PM: Adding info for No Bus:ptyd2
> [  272.894687] device: 'ptyd3': device_add
> [  272.899700] PM: Adding info for No Bus:ptyd3
> [  272.900648] device: 'ptyd4': device_add
> [  272.941617] PM: Adding info for No Bus:ptyd4
> [  272.944388] device: 'ptyd5': device_add
> [  272.949387] PM: Adding info for No Bus:ptyd5
> [  272.952385] device: 'ptyd6': device_add
> [  272.957542] PM: Adding info for No Bus:ptyd6
> [  272.960375] device: 'ptyd7': device_add
> [  272.964388] PM: Adding info for No Bus:ptyd7
> [  272.967530] device: 'ptyd8': device_add
> [  272.972386] PM: Adding info for No Bus:ptyd8
> [  272.975373] device: 'ptyd9': device_add
> [  272.980365] PM: Adding info for No Bus:ptyd9
> [  272.983372] device: 'ptyda': device_add
> [  272.987546] PM: Adding info for No Bus:ptyda
> [  272.990345] device: 'ptydb': device_add
> [  272.995373] PM: Adding info for No Bus:ptydb
> [  272.998371] device: 'ptydc': device_add
> [  273.004613] PM: Adding info for No Bus:ptydc
> [  273.007556] device: 'ptydd': device_add
> [  273.012387] PM: Adding info for No Bus:ptydd
> [  273.015542] device: 'ptyde': device_add
> [  273.020379] PM: Adding info for No Bus:ptyde
> [  273.024465] device: 'ptydf': device_add
> [  273.039620] PM: Adding info for No Bus:ptydf
> [  273.046599] device: 'ptye0': device_add
> [  273.060616] PM: Adding info for No Bus:ptye0
> [  273.067709] device: 'ptye1': device_add
> [  273.073743] PM: Adding info for No Bus:ptye1
> [  273.074749] device: 'ptye2': device_add
> [  273.075743] PM: Adding info for No Bus:ptye2
> [  273.118571] device: 'ptye3': device_add
> [  273.123667] PM: Adding info for No Bus:ptye3
> [  273.126349] device: 'ptye4': device_add
> [  273.130364] PM: Adding info for No Bus:ptye4
> [  273.133347] device: 'ptye5': device_add
> [  273.138364] PM: Adding info for No Bus:ptye5
> [  273.141521] device: 'ptye6': device_add
> [  273.146350] PM: Adding info for No Bus:ptye6
> [  273.149356] device: 'ptye7': device_add
> [  273.154353] PM: Adding info for No Bus:ptye7
> [  273.157340] device: 'ptye8': device_add
> [  273.161344] PM: Adding info for No Bus:ptye8
> [  273.164354] device: 'ptye9': device_add
> [  273.170347] PM: Adding info for No Bus:ptye9
> [  273.173344] device: 'ptyea': device_add
> [  273.177343] PM: Adding info for No Bus:ptyea
> [  273.181341] device: 'ptyeb': device_add
> [  273.185338] PM: Adding info for No Bus:ptyeb
> [  273.189342] device: 'ptyec': device_add
> [  273.193343] PM: Adding info for No Bus:ptyec
> [  273.196344] device: 'ptyed': device_add
> [  273.200364] PM: Adding info for No Bus:ptyed
> [  273.204343] device: 'ptyee': device_add
> [  273.208499] PM: Adding info for No Bus:ptyee
> [  273.212342] device: 'ptyef': device_add
> [  273.216342] PM: Adding info for No Bus:ptyef
> [  273.218701] device: 'ttyp0': device_add
> [  273.219697] PM: Adding info for No Bus:ttyp0
> [  273.219697] device: 'ttyp1': device_add
> [  273.241361] PM: Adding info for No Bus:ttyp1
> [  273.247538] device: 'ttyp2': device_add
> [  273.258533] PM: Adding info for No Bus:ttyp2
> [  273.265309] device: 'ttyp3': device_add
> [  273.270331] PM: Adding info for No Bus:ttyp3
> [  273.273342] device: 'ttyp4': device_add
> [  273.277350] PM: Adding info for No Bus:ttyp4
> [  273.280324] device: 'ttyp5': device_add
> [  273.285355] PM: Adding info for No Bus:ttyp5
> [  273.288335] device: 'ttyp6': device_add
> [  273.293331] PM: Adding info for No Bus:ttyp6
> [  273.296368] device: 'ttyp7': device_add
> [  273.301361] PM: Adding info for No Bus:ttyp7
> [  273.304343] device: 'ttyp8': device_add
> [  273.309362] PM: Adding info for No Bus:ttyp8
> [  273.314312] device: 'ttyp9': device_add
> [  273.319334] PM: Adding info for No Bus:ttyp9
> [  273.322315] device: 'ttypa': device_add
> [  273.327340] PM: Adding info for No Bus:ttypa
> [  273.330313] device: 'ttypb': device_add
> [  273.334323] PM: Adding info for No Bus:ttypb
> [  273.338320] device: 'ttypc': device_add
> [  273.342321] PM: Adding info for No Bus:ttypc
> [  273.345351] device: 'ttypd': device_add
> [  273.350326] PM: Adding info for No Bus:ttypd
> [  273.353326] device: 'ttype': device_add
> [  273.357324] PM: Adding info for No Bus:ttype
> [  273.361351] device: 'ttypf': device_add
> [  273.366356] PM: Adding info for No Bus:ttypf
> [  273.369332] device: 'ttyq0': device_add
> [  273.373329] PM: Adding info for No Bus:ttyq0
> [  273.376328] device: 'ttyq1': device_add
> [  273.381328] PM: Adding info for No Bus:ttyq1
> [  273.384330] device: 'ttyq2': device_add
> [  273.389312] PM: Adding info for No Bus:ttyq2
> [  273.391289] device: 'ttyq3': device_add
> [  273.396346] PM: Adding info for No Bus:ttyq3
> [  273.399342] device: 'ttyq4': device_add
> [  273.405326] PM: Adding info for No Bus:ttyq4
> [  273.408309] device: 'ttyq5': device_add
> [  273.412302] PM: Adding info for No Bus:ttyq5
> [  273.415307] device: 'ttyq6': device_add
> [  273.420318] PM: Adding info for No Bus:ttyq6
> [  273.423303] device: 'ttyq7': device_add
> [  273.427299] PM: Adding info for No Bus:ttyq7
> [  273.431307] device: 'ttyq8': device_add
> [  273.435302] PM: Adding info for No Bus:ttyq8
> [  273.438324] device: 'ttyq9': device_add
> [  273.443339] PM: Adding info for No Bus:ttyq9
> [  273.448280] device: 'ttyqa': device_add
> [  273.452458] PM: Adding info for No Bus:ttyqa
> [  273.455289] device: 'ttyqb': device_add
> [  273.461298] PM: Adding info for No Bus:ttyqb
> [  273.464322] device: 'ttyqc': device_add
> [  273.469322] PM: Adding info for No Bus:ttyqc
> [  273.472280] device: 'ttyqd': device_add
> [  273.477309] PM: Adding info for No Bus:ttyqd
> [  273.480300] device: 'ttyqe': device_add
> [  273.486352] PM: Adding info for No Bus:ttyqe
> [  273.489320] device: 'ttyqf': device_add
> [  273.493305] PM: Adding info for No Bus:ttyqf
> [  273.496516] device: 'ttyr0': device_add
> [  273.501289] PM: Adding info for No Bus:ttyr0
> [  273.504312] device: 'ttyr1': device_add
> [  273.509313] PM: Adding info for No Bus:ttyr1
> [  273.512314] device: 'ttyr2': device_add
> [  273.517283] PM: Adding info for No Bus:ttyr2
> [  273.520296] device: 'ttyr3': device_add
> [  273.524283] PM: Adding info for No Bus:ttyr3
> [  273.528333] device: 'ttyr4': device_add
> [  273.533321] PM: Adding info for No Bus:ttyr4
> [  273.536453] device: 'ttyr5': device_add
> [  273.541297] PM: Adding info for No Bus:ttyr5
> [  273.543271] device: 'ttyr6': device_add
> [  273.548289] PM: Adding info for No Bus:ttyr6
> [  273.551286] device: 'ttyr7': device_add
> [  273.556450] PM: Adding info for No Bus:ttyr7
> [  273.559280] device: 'ttyr8': device_add
> [  273.563315] PM: Adding info for No Bus:ttyr8
> [  273.566302] device: 'ttyr9': device_add
> [  273.570317] PM: Adding info for No Bus:ttyr9
> [  273.572286] device: 'ttyra': device_add
> [  273.577297] PM: Adding info for No Bus:ttyra
> [  273.580293] device: 'ttyrb': device_add
> [  273.584458] PM: Adding info for No Bus:ttyrb
> [  273.588289] device: 'ttyrc': device_add
> [  273.592304] PM: Adding info for No Bus:ttyrc
> [  273.595277] device: 'ttyrd': device_add
> [  273.598348] PM: Adding info for No Bus:ttyrd
> [  273.598348] device: 'ttyre': device_add
> [  273.598348] PM: Adding info for No Bus:ttyre
> [  273.599703] device: 'ttyrf': device_add
> [  273.599703] PM: Adding info for No Bus:ttyrf
> [  273.599703] device: 'ttys0': device_add
> [  274.036574] PM: Adding info for No Bus:ttys0
> [  274.069449] device: 'ttys1': device_add
> [  274.124312] PM: Adding info for No Bus:ttys1
> [  274.198646] device: 'ttys2': device_add
> [  274.198646] PM: Adding info for No Bus:ttys2
> [  274.198646] device: 'ttys3': device_add
> [  274.198646] PM: Adding info for No Bus:ttys3
> [  274.220221] device: 'ttys4': device_add
> [  274.226469] PM: Adding info for No Bus:ttys4
> [  274.229445] device: 'ttys5': device_add
> [  274.234173] PM: Adding info for No Bus:ttys5
> [  274.239212] device: 'ttys6': device_add
> [  274.244174] PM: Adding info for No Bus:ttys6
> [  274.248315] device: 'ttys7': device_add
> [  274.254183] PM: Adding info for No Bus:ttys7
> [  274.258335] device: 'ttys8': device_add
> [  274.263185] PM: Adding info for No Bus:ttys8
> [  274.267373] device: 'ttys9': device_add
> [  274.268279] PM: Adding info for No Bus:ttys9
> [  274.274259] device: 'ttysa': device_add
> [  274.287423] PM: Adding info for No Bus:ttysa
> [  274.290504] device: 'ttysb': device_add
> [  274.290504] PM: Adding info for No Bus:ttysb
> [  274.291657] device: 'ttysc': device_add
> [  274.291657] PM: Adding info for No Bus:ttysc
> [  274.291657] device: 'ttysd': device_add
> [  274.291657] PM: Adding info for No Bus:ttysd
> [  274.291657] device: 'ttyse': device_add
> [  274.299298] PM: Adding info for No Bus:ttyse
> [  274.303493] device: 'ttysf': device_add
> [  274.307170] PM: Adding info for No Bus:ttysf
> [  274.311252] device: 'ttyt0': device_add
> [  274.316178] PM: Adding info for No Bus:ttyt0
> [  274.320187] device: 'ttyt1': device_add
> [  274.326474] PM: Adding info for No Bus:ttyt1
> [  274.329172] device: 'ttyt2': device_add
> [  274.334164] PM: Adding info for No Bus:ttyt2
> [  274.337512] device: 'ttyt3': device_add
> [  274.344167] PM: Adding info for No Bus:ttyt3
> [  274.347180] device: 'ttyt4': device_add
> [  274.353178] PM: Adding info for No Bus:ttyt4
> [  274.356129] device: 'ttyt5': device_add
> [  274.358448] PM: Adding info for No Bus:ttyt5
> [  274.359903] device: 'ttyt6': device_add
> [  274.359903] PM: Adding info for No Bus:ttyt6
> [  274.359903] device: 'ttyt7': device_add
> [  274.379373] PM: Adding info for No Bus:ttyt7
> [  274.383136] device: 'ttyt8': device_add
> [  274.389200] PM: Adding info for No Bus:ttyt8
> [  274.393162] device: 'ttyt9': device_add
> [  274.397158] PM: Adding info for No Bus:ttyt9
> [  274.401157] device: 'ttyta': device_add
> [  274.405135] PM: Adding info for No Bus:ttyta
> [  274.408161] device: 'ttytb': device_add
> [  274.412131] PM: Adding info for No Bus:ttytb
> [  274.416124] device: 'ttytc': device_add
> [  274.420125] PM: Adding info for No Bus:ttytc
> [  274.423123] device: 'ttytd': device_add
> [  274.427128] PM: Adding info for No Bus:ttytd
> [  274.431128] device: 'ttyte': device_add
> [  274.435128] PM: Adding info for No Bus:ttyte
> [  274.438128] device: 'ttytf': device_add
> [  274.442132] PM: Adding info for No Bus:ttytf
> [  274.445121] device: 'ttyu0': device_add
> [  274.450121] PM: Adding info for No Bus:ttyu0
> [  274.453125] device: 'ttyu1': device_add
> [  274.457133] PM: Adding info for No Bus:ttyu1
> [  274.460135] device: 'ttyu2': device_add
> [  274.464121] PM: Adding info for No Bus:ttyu2
> [  274.467111] device: 'ttyu3': device_add
> [  274.473119] PM: Adding info for No Bus:ttyu3
> [  274.477127] device: 'ttyu4': device_add
> [  274.482122] PM: Adding info for No Bus:ttyu4
> [  274.485128] device: 'ttyu5': device_add
> [  274.489116] PM: Adding info for No Bus:ttyu5
> [  274.493120] device: 'ttyu6': device_add
> [  274.497134] PM: Adding info for No Bus:ttyu6
> [  274.500163] device: 'ttyu7': device_add
> [  274.505118] PM: Adding info for No Bus:ttyu7
> [  274.508122] device: 'ttyu8': device_add
> [  274.512120] PM: Adding info for No Bus:ttyu8
> [  274.515134] device: 'ttyu9': device_add
> [  274.519116] PM: Adding info for No Bus:ttyu9
> [  274.522107] device: 'ttyua': device_add
> [  274.526110] PM: Adding info for No Bus:ttyua
> [  274.529094] device: 'ttyub': device_add
> [  274.534110] PM: Adding info for No Bus:ttyub
> [  274.537120] device: 'ttyuc': device_add
> [  274.541121] PM: Adding info for No Bus:ttyuc
> [  274.545127] device: 'ttyud': device_add
> [  274.549112] PM: Adding info for No Bus:ttyud
> [  274.552112] device: 'ttyue': device_add
> [  274.556123] PM: Adding info for No Bus:ttyue
> [  274.559121] device: 'ttyuf': device_add
> [  274.563104] PM: Adding info for No Bus:ttyuf
> [  274.566104] device: 'ttyv0': device_add
> [  274.571108] PM: Adding info for No Bus:ttyv0
> [  274.576111] device: 'ttyv1': device_add
> [  274.580111] PM: Adding info for No Bus:ttyv1
> [  274.583109] device: 'ttyv2': device_add
> [  274.588122] PM: Adding info for No Bus:ttyv2
> [  274.591110] device: 'ttyv3': device_add
> [  274.595107] PM: Adding info for No Bus:ttyv3
> [  274.598105] device: 'ttyv4': device_add
> [  274.603107] PM: Adding info for No Bus:ttyv4
> [  274.606102] device: 'ttyv5': device_add
> [  274.610101] PM: Adding info for No Bus:ttyv5
> [  274.613106] device: 'ttyv6': device_add
> [  274.617102] PM: Adding info for No Bus:ttyv6
> [  274.620075] device: 'ttyv7': device_add
> [  274.625102] PM: Adding info for No Bus:ttyv7
> [  274.628097] device: 'ttyv8': device_add
> [  274.633201] PM: Adding info for No Bus:ttyv8
> [  274.636094] device: 'ttyv9': device_add
> [  274.641097] PM: Adding info for No Bus:ttyv9
> [  274.644098] device: 'ttyva': device_add
> [  274.648099] PM: Adding info for No Bus:ttyva
> [  274.651086] device: 'ttyvb': device_add
> [  274.656098] PM: Adding info for No Bus:ttyvb
> [  274.659093] device: 'ttyvc': device_add
> [  274.665099] PM: Adding info for No Bus:ttyvc
> [  274.668095] device: 'ttyvd': device_add
> [  274.673088] PM: Adding info for No Bus:ttyvd
> [  274.675069] device: 'ttyve': device_add
> [  274.680090] PM: Adding info for No Bus:ttyve
> [  274.683097] device: 'ttyvf': device_add
> [  274.686313] PM: Adding info for No Bus:ttyvf
> [  274.689066] device: 'ttyw0': device_add
> [  274.694086] PM: Adding info for No Bus:ttyw0
> [  274.697112] device: 'ttyw1': device_add
> [  274.702090] PM: Adding info for No Bus:ttyw1
> [  274.705082] device: 'ttyw2': device_add
> [  274.709098] PM: Adding info for No Bus:ttyw2
> [  274.712103] device: 'ttyw3': device_add
> [  274.717092] PM: Adding info for No Bus:ttyw3
> [  274.720101] device: 'ttyw4': device_add
> [  274.724088] PM: Adding info for No Bus:ttyw4
> [  274.727099] device: 'ttyw5': device_add
> [  274.733086] PM: Adding info for No Bus:ttyw5
> [  274.736106] device: 'ttyw6': device_add
> [  274.740078] PM: Adding info for No Bus:ttyw6
> [  274.743105] device: 'ttyw7': device_add
> [  274.748089] PM: Adding info for No Bus:ttyw7
> [  274.751090] device: 'ttyw8': device_add
> [  274.755077] PM: Adding info for No Bus:ttyw8
> [  274.758083] device: 'ttyw9': device_add
> [  274.763080] PM: Adding info for No Bus:ttyw9
> [  274.766087] device: 'ttywa': device_add
> [  274.770080] PM: Adding info for No Bus:ttywa
> [  274.773073] device: 'ttywb': device_add
> [  274.778068] PM: Adding info for No Bus:ttywb
> [  274.782082] device: 'ttywc': device_add
> [  274.787075] PM: Adding info for No Bus:ttywc
> [  274.790085] device: 'ttywd': device_add
> [  274.794069] PM: Adding info for No Bus:ttywd
> [  274.797079] device: 'ttywe': device_add
> [  274.802068] PM: Adding info for No Bus:ttywe
> [  274.805076] device: 'ttywf': device_add
> [  274.809066] PM: Adding info for No Bus:ttywf
> [  274.812048] device: 'ttyx0': device_add
> [  274.817077] PM: Adding info for No Bus:ttyx0
> [  274.820080] device: 'ttyx1': device_add
> [  274.824076] PM: Adding info for No Bus:ttyx1
> [  274.827046] device: 'ttyx2': device_add
> [  274.832072] PM: Adding info for No Bus:ttyx2
> [  274.834072] device: 'ttyx3': device_add
> [  274.839066] PM: Adding info for No Bus:ttyx3
> [  274.842068] device: 'ttyx4': device_add
> [  274.846069] PM: Adding info for No Bus:ttyx4
> [  274.849066] device: 'ttyx5': device_add
> [  274.855069] PM: Adding info for No Bus:ttyx5
> [  274.858062] device: 'ttyx6': device_add
> [  274.862059] PM: Adding info for No Bus:ttyx6
> [  274.865052] device: 'ttyx7': device_add
> [  274.870068] PM: Adding info for No Bus:ttyx7
> [  274.873062] device: 'ttyx8': device_add
> [  274.877061] PM: Adding info for No Bus:ttyx8
> [  274.880061] device: 'ttyx9': device_add
> [  274.884061] PM: Adding info for No Bus:ttyx9
> [  274.888058] device: 'ttyxa': device_add
> [  274.892053] PM: Adding info for No Bus:ttyxa
> [  274.895060] device: 'ttyxb': device_add
> [  274.899059] PM: Adding info for No Bus:ttyxb
> [  274.904059] device: 'ttyxc': device_add
> [  274.908065] PM: Adding info for No Bus:ttyxc
> [  274.912061] device: 'ttyxd': device_add
> [  274.916061] PM: Adding info for No Bus:ttyxd
> [  274.919060] device: 'ttyxe': device_add
> [  274.923054] PM: Adding info for No Bus:ttyxe
> [  274.927059] device: 'ttyxf': device_add
> [  274.931049] PM: Adding info for No Bus:ttyxf
> [  274.934044] device: 'ttyy0': device_add
> [  274.939048] PM: Adding info for No Bus:ttyy0
> [  274.943056] device: 'ttyy1': device_add
> [  274.947047] PM: Adding info for No Bus:ttyy1
> [  274.951071] device: 'ttyy2': device_add
> [  274.955056] PM: Adding info for No Bus:ttyy2
> [  274.958051] device: 'ttyy3': device_add
> [  274.963044] PM: Adding info for No Bus:ttyy3
> [  274.966055] device: 'ttyy4': device_add
> [  274.970048] PM: Adding info for No Bus:ttyy4
> [  274.973043] device: 'ttyy5': device_add
> [  274.978047] PM: Adding info for No Bus:ttyy5
> [  274.981067] device: 'ttyy6': device_add
> [  274.985043] PM: Adding info for No Bus:ttyy6
> [  274.989058] device: 'ttyy7': device_add
> [  274.993056] PM: Adding info for No Bus:ttyy7
> [  274.997057] device: 'ttyy8': device_add
> [  275.001060] PM: Adding info for No Bus:ttyy8
> [  275.004035] device: 'ttyy9': device_add
> [  275.009036] PM: Adding info for No Bus:ttyy9
> [  275.012052] device: 'ttyya': device_add
> [  275.016039] PM: Adding info for No Bus:ttyya
> [  275.019047] device: 'ttyyb': device_add
> [  275.024042] PM: Adding info for No Bus:ttyyb
> [  275.027037] device: 'ttyyc': device_add
> [  275.032030] PM: Adding info for No Bus:ttyyc
> [  275.035036] device: 'ttyyd': device_add
> [  275.039044] PM: Adding info for No Bus:ttyyd
> [  275.042036] device: 'ttyye': device_add
> [  275.047039] PM: Adding info for No Bus:ttyye
> [  275.050034] device: 'ttyyf': device_add
> [  275.054038] PM: Adding info for No Bus:ttyyf
> [  275.057038] device: 'ttyz0': device_add
> [  275.061034] PM: Adding info for No Bus:ttyz0
> [  275.064010] device: 'ttyz1': device_add
> [  275.069025] PM: Adding info for No Bus:ttyz1
> [  275.072040] device: 'ttyz2': device_add
> [  275.076054] PM: Adding info for No Bus:ttyz2
> [  275.079031] device: 'ttyz3': device_add
> [  275.083034] PM: Adding info for No Bus:ttyz3
> [  275.086042] device: 'ttyz4': device_add
> [  275.090028] PM: Adding info for No Bus:ttyz4
> [  275.091171] device: 'ttyz5': device_add
> [  275.091171] PM: Adding info for No Bus:ttyz5
> [  275.094373] device: 'ttyz6': device_add
> [  275.113130] PM: Adding info for No Bus:ttyz6
> [  275.113130] device: 'ttyz7': device_add
> [  275.115397] PM: Adding info for No Bus:ttyz7
> [  275.115397] device: 'ttyz8': device_add
> [  275.115397] PM: Adding info for No Bus:ttyz8
> [  275.120365] device: 'ttyz9': device_add
> [  275.129013] PM: Adding info for No Bus:ttyz9
> [  275.132045] device: 'ttyza': device_add
> [  275.136013] PM: Adding info for No Bus:ttyza
> [  275.138008] device: 'ttyzb': device_add
> [  275.142019] PM: Adding info for No Bus:ttyzb
> [  275.145017] device: 'ttyzc': device_add
> [  275.149030] PM: Adding info for No Bus:ttyzc
> [  275.152023] device: 'ttyzd': device_add
> [  275.157026] PM: Adding info for No Bus:ttyzd
> [  275.160015] device: 'ttyze': device_add
> [  275.164016] PM: Adding info for No Bus:ttyze
> [  275.167040] device: 'ttyzf': device_add
> [  275.171023] PM: Adding info for No Bus:ttyzf
> [  275.174026] device: 'ttya0': device_add
> [  275.180005] PM: Adding info for No Bus:ttya0
> [  275.183014] device: 'ttya1': device_add
> [  275.187063] PM: Adding info for No Bus:ttya1
> [  275.190016] device: 'ttya2': device_add
> [  275.194013] PM: Adding info for No Bus:ttya2
> [  275.198011] device: 'ttya3': device_add
> [  275.202008] PM: Adding info for No Bus:ttya3
> [  275.205034] device: 'ttya4': device_add
> [  275.209016] PM: Adding info for No Bus:ttya4
> [  275.212014] device: 'ttya5': device_add
> [  275.217005] PM: Adding info for No Bus:ttya5
> [  275.218984] device: 'ttya6': device_add
> [  275.224004] PM: Adding info for No Bus:ttya6
> [  275.227006] device: 'ttya7': device_add
> [  275.231004] PM: Adding info for No Bus:ttya7
> [  275.234015] device: 'ttya8': device_add
> [  275.237019] PM: Adding info for No Bus:ttya8
> [  275.237019] device: 'ttya9': device_add
> [  275.240290] PM: Adding info for No Bus:ttya9
> [  275.240290] device: 'ttyaa': device_add
> [  275.241217] PM: Adding info for No Bus:ttyaa
> [  275.248227] device: 'ttyab': device_add
> [  275.257212] PM: Adding info for No Bus:ttyab
> [  275.262283] device: 'ttyac': device_add
> [  275.270074] PM: Adding info for No Bus:ttyac
> [  275.274257] device: 'ttyad': device_add
> [  275.277990] PM: Adding info for No Bus:ttyad
> [  275.280994] device: 'ttyae': device_add
> [  275.284993] PM: Adding info for No Bus:ttyae
> [  275.287992] device: 'ttyaf': device_add
> [  275.291992] PM: Adding info for No Bus:ttyaf
> [  275.295006] device: 'ttyb0': device_add
> [  275.298998] PM: Adding info for No Bus:ttyb0
> [  275.301996] device: 'ttyb1': device_add
> [  275.305991] PM: Adding info for No Bus:ttyb1
> [  275.308993] device: 'ttyb2': device_add
> [  275.313008] PM: Adding info for No Bus:ttyb2
> [  275.316007] device: 'ttyb3': device_add
> [  275.320004] PM: Adding info for No Bus:ttyb3
> [  275.323006] device: 'ttyb4': device_add
> [  275.327986] PM: Adding info for No Bus:ttyb4
> [  275.329968] device: 'ttyb5': device_add
> [  275.333993] PM: Adding info for No Bus:ttyb5
> [  275.336972] device: 'ttyb6': device_add
> [  275.341984] PM: Adding info for No Bus:ttyb6
> [  275.343984] device: 'ttyb7': device_add
> [  275.343984] PM: Adding info for No Bus:ttyb7
> [  275.345471] device: 'ttyb8': device_add
> [  275.345471] PM: Adding info for No Bus:ttyb8
> [  275.347974] device: 'ttyb9': device_add
> [  275.352979] PM: Adding info for No Bus:ttyb9
> [  275.354959] device: 'ttyba': device_add
> [  275.359977] PM: Adding info for No Bus:ttyba
> [  275.362974] device: 'ttybb': device_add
> [  275.365971] PM: Adding info for No Bus:ttybb
> [  275.368004] device: 'ttybc': device_add
> [  275.371989] PM: Adding info for No Bus:ttybc
> [  275.374993] device: 'ttybd': device_add
> [  275.378978] PM: Adding info for No Bus:ttybd
> [  275.381986] device: 'ttybe': device_add
> [  275.385981] PM: Adding info for No Bus:ttybe
> [  275.388984] device: 'ttybf': device_add
> [  275.392979] PM: Adding info for No Bus:ttybf
> [  275.396517] device: 'ttyc0': device_add
> [  275.396517] PM: Adding info for No Bus:ttyc0
> [  275.396517] device: 'ttyc1': device_add
> [  275.396517] PM: Adding info for No Bus:ttyc1
> [  275.396517] device: 'ttyc2': device_add
> [  275.406973] PM: Adding info for No Bus:ttyc2
> [  275.409980] device: 'ttyc3': device_add
> [  275.414977] PM: Adding info for No Bus:ttyc3
> [  275.417972] device: 'ttyc4': device_add
> [  275.421975] PM: Adding info for No Bus:ttyc4
> [  275.424976] device: 'ttyc5': device_add
> [  275.428979] PM: Adding info for No Bus:ttyc5
> [  275.431955] device: 'ttyc6': device_add
> [  275.436972] PM: Adding info for No Bus:ttyc6
> [  275.439976] device: 'ttyc7': device_add
> [  275.443973] PM: Adding info for No Bus:ttyc7
> [  275.446975] device: 'ttyc8': device_add
> [  275.450972] PM: Adding info for No Bus:ttyc8
> [  275.453987] device: 'ttyc9': device_add
> [  275.457968] PM: Adding info for No Bus:ttyc9
> [  275.460977] device: 'ttyca': device_add
> [  275.464964] PM: Adding info for No Bus:ttyca
> [  275.467993] device: 'ttycb': device_add
> [  275.472979] PM: Adding info for No Bus:ttycb
> [  275.476011] device: 'ttycc': device_add
> [  275.479975] PM: Adding info for No Bus:ttycc
> [  275.481953] device: 'ttycd': device_add
> [  275.486973] PM: Adding info for No Bus:ttycd
> [  275.489971] device: 'ttyce': device_add
> [  275.492966] PM: Adding info for No Bus:ttyce
> [  275.492966] device: 'ttycf': device_add
> [  275.492966] PM: Adding info for No Bus:ttycf
> [  275.492966] device: 'ttyd0': device_add
> [  275.492966] PM: Adding info for No Bus:ttyd0
> [  275.498192] device: 'ttyd1': device_add
> [  275.499452] PM: Adding info for No Bus:ttyd1
> [  275.499452] device: 'ttyd2': device_add
> [  275.515205] PM: Adding info for No Bus:ttyd2
> [  275.535349] device: 'ttyd3': device_add
> [  275.558183] PM: Adding info for No Bus:ttyd3
> [  275.571338] device: 'ttyd4': device_add
> [  275.593188] PM: Adding info for No Bus:ttyd4
> [  275.598191] device: 'ttyd5': device_add
> [  275.672320] PM: Adding info for No Bus:ttyd5
> [  275.701316] device: 'ttyd6': device_add
> [  275.776258] PM: Adding info for No Bus:ttyd6
> [  275.807309] device: 'ttyd7': device_add
> [  275.878299] PM: Adding info for No Bus:ttyd7
> [  275.996259] device: 'ttyd8': device_add
> [  276.094266] PM: Adding info for No Bus:ttyd8
> [  276.132270] device: 'ttyd9': device_add
> [  276.202238] PM: Adding info for No Bus:ttyd9
> [  276.238240] device: 'ttyda': device_add
> [  276.273023] PM: Adding info for No Bus:ttyda
> [  276.278903] device: 'ttydb': device_add
> [  276.286052] PM: Adding info for No Bus:ttydb
> [  276.291059] device: 'ttydc': device_add
> [  276.307199] PM: Adding info for No Bus:ttydc
> [  276.358224] device: 'ttydd': device_add
> [  276.455204] PM: Adding info for No Bus:ttydd
> [  276.494189] device: 'ttyde': device_add
> [  276.628190] PM: Adding info for No Bus:ttyde
> [  276.677176] device: 'ttydf': device_add
> [  276.770144] PM: Adding info for No Bus:ttydf
> [  276.840134] device: 'ttye0': device_add
> [  276.960115] PM: Adding info for No Bus:ttye0
> [  277.007735] device: 'ttye1': device_add
> [  277.145086] PM: Adding info for No Bus:ttye1
> [  277.190083] device: 'ttye2': device_add
> [  277.257701] PM: Adding info for No Bus:ttye2
> [  277.259703] device: 'ttye3': device_add
> [  277.264716] PM: Adding info for No Bus:ttye3
> [  277.267708] device: 'ttye4': device_add
> [  277.273697] PM: Adding info for No Bus:ttye4
> [  277.276695] device: 'ttye5': device_add
> [  277.280696] PM: Adding info for No Bus:ttye5
> [  277.284698] device: 'ttye6': device_add
> [  277.288693] PM: Adding info for No Bus:ttye6
> [  277.291669] device: 'ttye7': device_add
> [  277.295696] PM: Adding info for No Bus:ttye7
> [  277.297674] device: 'ttye8': device_add
> [  277.303696] PM: Adding info for No Bus:ttye8
> [  277.306713] device: 'ttye9': device_add
> [  277.313702] PM: Adding info for No Bus:ttye9
> [  277.316690] device: 'ttyea': device_add
> [  277.321735] PM: Adding info for No Bus:ttyea
> [  277.324708] device: 'ttyeb': device_add
> [  277.328698] PM: Adding info for No Bus:ttyeb
> [  277.332678] device: 'ttyec': device_add
> [  277.337678] PM: Adding info for No Bus:ttyec
> [  277.339666] device: 'ttyed': device_add
> [  277.344687] PM: Adding info for No Bus:ttyed
> [  277.346692] device: 'ttyee': device_add
> [  277.351677] PM: Adding info for No Bus:ttyee
> [  277.354688] device: 'ttyef': device_add
> [  277.358689] PM: Adding info for No Bus:ttyef
> [  277.364684] device: 'ptmx': device_add
> [  277.369690] PM: Adding info for No Bus:ptmx
> [  277.372706] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [  277.375680] Registering platform device 'serial8250'. Parent at platform
> [  277.377050] device: 'serial8250': device_add
> [  277.379665] bus: 'platform': add device serial8250
> [  277.383674] PM: Adding info for platform:serial8250
> [  277.393695] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [  277.396909] device: 'ttyS0': device_add
> [  277.405682] PM: Adding info for No Bus:ttyS0
> [  277.414697] device: 'ttyS1': device_add
> [  277.420676] PM: Adding info for No Bus:ttyS1
> [  277.427970] device: 'ttyS2': device_add
> [  277.434670] PM: Adding info for No Bus:ttyS2
> [  277.440732] device: 'ttyS3': device_add
> [  277.446693] PM: Adding info for No Bus:ttyS3
> [  277.451701] bus: 'platform': add driver serial8250
> [  277.455698] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
> [  277.456975] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
> [  277.459714] driver: 'serial8250': driver_bound: bound to device 'serial8250'
> [  277.462695] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
> [  277.465677] bus: 'platform': add driver dw-apb-uart
> [  277.469675] enter max3107 init
> [  277.471009] bus: 'spi': add driver max3107
> [  277.477668] device class 'virtio-ports': registering
> [  277.481669] bus: 'virtio': add driver virtio_console
> [  277.485679] device: 'rtc': device_add
> [  277.490659] PM: Adding info for No Bus:rtc
> [  277.494663] Real Time Clock Driver v1.12b
> [  277.496649] device: 'nvram': device_add
> [  277.501675] PM: Adding info for No Bus:nvram
> [  277.505684] Non-volatile memory driver v1.3
> [  277.507645] Registering platform device 'pc8736x_gpio.0'. Parent at platform
> [  277.509011] device: 'pc8736x_gpio.0': device_add
> [  277.509652] bus: 'platform': add device pc8736x_gpio.0
> [  277.513666] PM: Adding info for platform:pc8736x_gpio.0
> [  277.517697] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
> [  277.518952] platform pc8736x_gpio.0: no device found
> [  277.519869] PM: Removing info for platform:pc8736x_gpio.0
> [  277.531725] bus: 'platform': remove device pc8736x_gpio.0
> [  277.535670] nsc_gpio initializing
> [  277.538671] smapi::smapi_init, ERROR invalid usSmapiID
> [  277.541018] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
> [  277.542987] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
> [  277.544014] mwave: mwavedd::mwave_init: Error: Failed to initialize
> [  277.544679] bus: 'platform': add driver tpm_atmel
> [  277.550657] bus: 'platform': remove driver tpm_atmel
> [  277.553667] driver: 'tpm_atmel': driver_release
> [  277.556661] device class 'drm': registering
> [  277.562675] [drm] Initialized drm 1.1.0 20060810
> [  277.564636] bus: 'platform': add driver parport_pc
> [  277.567658] Registering platform device 'parport_pc.956'. Parent at platform
> [  277.569645] device: 'parport_pc.956': device_add
> [  277.571650] bus: 'platform': add device parport_pc.956
> [  277.575652] PM: Adding info for platform:parport_pc.956
> [  277.579673] bus: 'platform': driver_probe_device: matched device parport_pc.956 with driver parport_pc
> [  277.581047] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.956
> [  277.582640] driver: 'parport_pc.956': driver_bound: bound to device 'parport_pc'
> [  277.584012] bus: 'platform': really_probe: bound device parport_pc.956 to driver parport_pc
> [  277.591682] PM: Removing info for platform:parport_pc.956
> [  277.596653] bus: 'platform': remove device parport_pc.956
> [  277.603642] Registering platform device 'parport_pc.888'. Parent at platform
> [  277.604661] device: 'parport_pc.888': device_add
> [  277.606630] bus: 'platform': add device parport_pc.888
> [  277.611672] PM: Adding info for platform:parport_pc.888
> [  277.614652] bus: 'platform': driver_probe_device: matched device parport_pc.888 with driver parport_pc
> [  277.616638] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.888
> [  277.617893] driver: 'parport_pc.888': driver_bound: bound to device 'parport_pc'
> [  277.619915] bus: 'platform': really_probe: bound device parport_pc.888 to driver parport_pc
> [  277.622654] parport0: PC-style at 0x378 [PCSPP,TRISTATE]
> [  277.628682] parport0: irq 0 detected
> [  278.036821] Registering platform device 'parport_pc.632'. Parent at platform
> [  278.038884] device: 'parport_pc.632': device_add
> [  278.043861] bus: 'platform': add device parport_pc.632
> [  278.077928] PM: Adding info for platform:parport_pc.632
> [  278.119909] bus: 'platform': driver_probe_device: matched device parport_pc.632 with driver parport_pc
> [  278.128926] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.632
> [  278.150916] driver: 'parport_pc.632': driver_bound: bound to device 'parport_pc'
> [  278.160913] bus: 'platform': really_probe: bound device parport_pc.632 to driver parport_pc
> [  278.202912] PM: Removing info for platform:parport_pc.632
> [  278.322895] bus: 'platform': remove device parport_pc.632
> [  278.361867] bus: 'platform': add driver ax88796-pp
> [  278.431900] bus: 'i2c': add driver ad_dpot
> [  278.468930] i2c-core: driver [ad_dpot] registered
> [  278.479882] bus: 'spi': add driver bmp085
> [  278.517872] bus: 'i2c': add driver apds990x
> [  278.548856] i2c-core: driver [apds990x] registered
> [  278.560885] bus: 'i2c': add driver isl29003
> [  278.607889] i2c-core: driver [isl29003] using legacy suspend method
> [  278.615891] i2c-core: driver [isl29003] using legacy resume method
> [  278.622876] i2c-core: driver [isl29003] registered
> [  278.643891] bus: 'i2c': add driver isl29020
> [  278.690866] i2c-core: driver [isl29020] registered
> [  278.710853] bus: 'spi': add driver dac7512
> [  278.732825] bus: 'i2c': add driver hmc6352
> [  278.833815] i2c-core: driver [hmc6352] registered
> [  278.844841] bus: 'spi': add driver at25
> [  278.892827] bus: 'spi': add driver lis3lv02d_spi
> [  278.946836] bus: 'i2c': add driver fsa9480
> [  278.988819] i2c-core: driver [fsa9480] using legacy suspend method
> [  278.993785] i2c-core: driver [fsa9480] using legacy resume method
> [  278.999820] i2c-core: driver [fsa9480] registered
> [  279.013818] bus: 'platform': add driver sm501
> [  279.189799] bus: 'i2c': add driver wm8994
> [  279.240778] i2c-core: driver [wm8994] registered
> [  279.251825] Uniform Multi-Platform E-IDE driver
> [  279.323795] bus: 'ide': registered
> [  279.333775] device class 'ide_port': registering
> [  279.401779] ide-cd driver 5.00
> [  279.410756] bus: 'ide': add driver ide-cdrom
> [  279.473753] device class 'ide_tape': registering
> [  279.515744] bus: 'ide': add driver ide-tape
> [  279.564728] bus: 'platform': add driver pata_platform
> [  279.624724] device class 'raid_devices': registering
> [  279.675720] device class 'spi_transport': registering
> [  279.721718] device class 'spi_host': registering
> [  279.729669] device class 'fc_host': registering
> [  279.742667] device class 'fc_vports': registering
> [  279.751706] device class 'fc_remote_ports': registering
> [  279.755428] device class 'fc_transport': registering
> [  279.771704] device class 'sas_host': registering
> [  279.838701] device class 'sas_phy': registering
> [  279.887694] device class 'sas_port': registering
> [  279.926694] device class 'sas_device': registering
> [  279.979677] device class 'sas_end_device': registering
> [  280.015663] device class 'sas_expander': registering
> [  280.218636] bus: 'scsi': add driver sr
> [  280.280634] device class 'scsi_generic': registering
> [  280.449582] bus: 'platform': add driver arasan_cf
> [  280.504597] bus: 'platform': add driver sata_mv
> [  281.950165] Rounding down aligned max_sectors from 4294967295 to 8388600
> [  281.975230] device: 'tcm_loop_0': device_add
> [  281.979982] PM: Adding info for No Bus:tcm_loop_0
> [  281.984974] bus: 'tcm_loop_bus': registered
> [  281.986966] bus: 'tcm_loop_bus': add driver tcm_loop
> [  282.106177] device: 'spi42': device_add
> [  282.106177] PM: Adding info for No Bus:spi42
> [  282.120256] parport_pc parport_pc.888: master is unqueued, this is deprecated
> [  282.157219] device: 'spi42.1': device_add
> [  282.167283] bus: 'spi': add device spi42.1
> [  282.185293] PM: Adding info for spi:spi42.1
> [  282.206363] parport0: AVR Butterfly
> [  282.206835] bus: 'platform': add driver spi_gpio
> [  282.206835] bus: 'hsi': add driver hsi_char
> [  282.206835] HSI/SSI char device loaded
> [  282.206835] w83977af_init()
> [  282.206835] w83977af_open()
> [  282.206835] w83977af_probe()
> [  282.211285] w83977af_probe(), Wrong chip version
> [  282.213280] w83977af_probe()
> [  282.215487] w83977af_probe(), Wrong chip version
> [  282.230259] bus: 'platform': add driver smsc-ircc2
> [  282.243232] bus: 'platform': remove driver smsc-ircc2
> [  282.250021] driver: 'smsc-ircc2': driver_release
> [  282.259999] Registering platform device 'i8042'. Parent at platform
> [  282.261260] device: 'i8042': device_add
> [  282.263115] bus: 'platform': add device i8042
> [  282.266946] PM: Adding info for platform:i8042
> [  282.271936] bus: 'platform': add driver i8042
> [  282.273922] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
> [  282.275328] bus: 'platform': really_probe: probing driver i8042 with device i8042
> [  282.299942] serio: i8042 KBD port at 0x60,0x64 irq 1
> [  282.306955] serio: i8042 AUX port at 0x60,0x64 irq 12
> [  282.311963] device: 'serio0': device_add
> [  282.314155] driver: 'i8042': driver_bound: bound to device 'i8042'
> [  282.315942] bus: 'platform': really_probe: bound device i8042 to driver i8042
> [  282.320961] bus: 'serio': add device serio0
> [  282.329972] parport0: cannot grant exclusive access for device parkbd
> [  282.334950] PM: Adding info for serio:serio0
> [  282.347939] device: 'mice': device_add
> [  282.350992] device: 'serio1': device_add
> [  282.354942] bus: 'serio': add device serio1
> [  282.376178] PM: Adding info for serio:serio1
> [  282.379163] PM: Adding info for No Bus:mice
> [  282.391295] mousedev: PS/2 mouse device common for all mice
> [  282.392941] bus: 'i2c': add driver adp5588_keys
> [  282.399087] i2c-core: driver [adp5588_keys] registered
> [  282.400260] bus: 'i2c': add driver adp5589_keys
> [  282.404109] i2c-core: driver [adp5589_keys] registered
> [  282.406123] bus: 'serio': add driver atkbd
> [  282.416256] bus: 'serio': add driver lkkbd
> [  282.422176] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
> [  282.429117] bus: 'serio': really_probe: probing driver atkbd with device serio0
> [  282.434255] bus: 'platform': add driver matrix-keypad
> [  282.446995] bus: 'serio': add driver newtonkbd
> [  282.464939] bus: 'serio': add driver stowaway
> [  282.468913] bus: 'serio': add driver sunkbd
> [  282.476911] bus: 'platform': add driver tc3589x-keypad
> [  282.483922] bus: 'platform': add driver twl4030_keypad
> [  282.492904] bus: 'serio': add driver xtkbd
> [  282.499906] bus: 'i2c': add driver ad714x_captouch
> [  282.507909] i2c-core: driver [ad714x_captouch] registered
> [  282.513943] bus: 'spi': add driver ad714x_captouch
> [  282.525916] bus: 'i2c': add driver adxl34x
> [  282.529945] device: 'input0': device_add
> [  282.531922] i2c-core: driver [adxl34x] registered
> [  282.534892] bus: 'spi': add driver adxl34x
> [  282.546939] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
> [  282.548240] bus: 'i2c': add driver bma150
> [  282.555917] i2c-core: driver [bma150] registered
> [  282.559931] PM: Adding info for No Bus:input0
> [  282.562899] bus: 'i2c': add driver gp2ap002a00f
> [  282.569898] i2c-core: driver [gp2ap002a00f] registered
> [  282.575954] bus: 'platform': add driver gpio-tilt-polled
> [  282.578908] bus: 'i2c': add driver kxtj9
> [  282.585903] i2c-core: driver [kxtj9] registered
> [  282.587894] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [  282.594137] bus: 'platform': add driver mc13783-pwrbutton
> [  282.596899] bus: 'i2c': add driver mpu3050
> [  282.604889] i2c-core: driver [mpu3050] registered
> [  282.607898] device: 'uinput': device_add
> [  282.615946] evbug: Connected device: input0 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
> [  282.620895] PM: Adding info for No Bus:uinput
> [  282.623949] driver: 'serio0': driver_bound: bound to device 'atkbd'
> [  282.627892] bus: 'i2c': add driver smbus_alert
> [  282.629951] bus: 'serio': really_probe: bound device serio0 to driver atkbd
> [  282.631903] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
> [  282.634889] i2c-core: driver [smbus_alert] registered
> [  282.637110] bus: 'serio': really_probe: probing driver atkbd with device serio1
> [  282.642139] i2c /dev entries driver
> [  282.644893] device class 'i2c-dev': registering
> [  282.652887] bus: 'platform': add driver i2c-pca-platform
> [  282.655929] atkbd: probe of serio1 rejects match -19
> [  282.660900] bus: 'platform': add driver simtec-i2c
> [  282.667871] i2c-parport: adapter type unspecified
> [  282.670158] i2c-parport-light: adapter type unspecified
> [  282.672237] bus: 'platform': add driver i2c-mux-gpio
> [  282.674895] bus: 'i2c': add driver w83792d
> [  282.677875] i2c-core: driver [w83792d] registered
> [  282.680056] bus: 'i2c': add driver w83791d
> [  282.682889] i2c-core: driver [w83791d] registered
> [  282.683900] bus: 'i2c': add driver adm1021
> [  282.686882] i2c-core: driver [adm1021] registered
> [  282.689190] bus: 'i2c': add driver adm1025
> [  282.692885] i2c-core: driver [adm1025] registered
> [  282.694873] bus: 'i2c': add driver adm1031
> [  282.697885] i2c-core: driver [adm1031] registered
> [  282.700888] bus: 'i2c': add driver ads7828
> [  282.703876] i2c-core: driver [ads7828] registered
> [  282.705920] bus: 'spi': add driver ads7871
> [  282.709877] bus: 'i2c': add driver adt7475
> [  282.712880] i2c-core: driver [adt7475] registered
> [  282.714875] applesmc: supported laptop not found!
> [  282.717140] applesmc: driver init failed (ret=-19)!
> [  282.719100] bus: 'i2c': add driver jc42
> [  282.721874] i2c-core: driver [jc42] registered
> [  282.724204] bus: 'i2c': add driver lm63
> [  282.727886] i2c-core: driver [lm63] registered
> [  282.729876] bus: 'i2c': add driver lm75
> [  282.732867] i2c-core: driver [lm75] registered
> [  282.734931] bus: 'i2c': add driver lm78
> [  282.737884] i2c-core: driver [lm78] registered
> [  282.740180] bus: 'i2c': add driver lm83
> [  282.742870] i2c-core: driver [lm83] registered
> [  282.745854] bus: 'i2c': add driver lm87
> [  282.748864] i2c-core: driver [lm87] registered
> [  282.750864] bus: 'i2c': add driver lm90
> [  282.753876] i2c-core: driver [lm90] registered
> [  282.756240] bus: 'i2c': add driver ltc4151
> [  282.759878] i2c-core: driver [ltc4151] registered
> [  282.761869] bus: 'spi': add driver max1111
> [  282.765866] bus: 'i2c': add driver smsc47m192
> [  282.768869] i2c-core: driver [smsc47m192] registered
> [  282.771872] bus: 'platform': add driver wm8350-hwmon
> [  282.775897] bus: 'mmc': add driver mmcblk
> [  282.784866] bus: 'memstick': registered
> [  282.786896] device class 'memstick_host': registering
> [  282.788876] bus: 'i2c': add driver BD2802
> [  282.791883] i2c-core: driver [BD2802] registered
> [  282.794850] bus: 'i2c': add driver lm3530-led
> [  282.797859] i2c-core: driver [lm3530-led] registered
> [  282.799899] bus: 'platform': add driver leds-gpio
> [  282.803853] bus: 'i2c': add driver lp3944
> [  282.806878] i2c-core: driver [lp3944] registered
> [  282.809852] bus: 'i2c': add driver lp5521
> [  282.812855] i2c-core: driver [lp5521] registered
> [  282.815051] bus: 'platform': add driver leds-ot200
> [  282.818853] bus: 'i2c': add driver leds-pca955x
> [  282.821163] i2c-core: driver [leds-pca955x] registered
> [  282.821163] bus: 'i2c': add driver leds-pca9633
> [  282.821163] i2c-core: driver [leds-pca9633] registered
> [  282.822857] bus: 'platform': add driver wm8350-led
> [  282.825795] bus: 'spi': add driver dac124s085
> [  282.825795] Registering platform device 'dell_rbu'. Parent at platform
> [  282.825795] device: 'dell_rbu': device_add
> [  282.825795] bus: 'platform': add device dell_rbu
> [  282.825795] PM: Adding info for platform:dell_rbu
> [  282.838851] bus: 'platform': add driver dcdbas
> [  282.842359] Registering platform device 'dcdbas'. Parent at platform
> [  282.842359] device: 'dcdbas': device_add
> [  282.842359] bus: 'platform': add device dcdbas
> [  282.846868] PM: Adding info for platform:dcdbas
> [  282.850855] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
> [  282.852837] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
> [  282.857850] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [  282.859842] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
> [  282.862097] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
> [  282.863853] bus: 'i2c': add driver olpc_dcon
> [  282.866840] i2c-core: driver [olpc_dcon] using legacy suspend method
> [  282.868031] i2c-core: driver [olpc_dcon] using legacy resume method
> [  282.870088] i2c-core: driver [olpc_dcon] registered
> [  282.871860] zram: num_devices not specified. Using default: 1
> [  282.872889] zram: Creating 1 devices ...
> [  282.883844] device: '254:0': device_add
> [  282.888857] PM: Adding info for No Bus:254:0
> [  282.894860] device: 'zram0': device_add
> [  282.901848] PM: Adding info for No Bus:zram0
> [  282.917850] bus: 'i2c': add driver synaptics_rmi4_i2c
> [  282.921852] i2c-core: driver [synaptics_rmi4_i2c] registered
> [  282.924091] Linux telephony interface: v1.00
> [  282.926849] bus: 'platform': add driver xo1-rfkill
> [  282.930842] bus: 'platform': add driver olpc-ec
> [  282.934847] device class 'extcon': registering
> [  282.937847] bus: 'platform': add driver extcon-gpio
> [  282.950850] netem: version 1.3
> [  282.952830] u32 classifier
> [  282.954837]     input device check on
> [  282.956179]     Actions configured
> [  282.965840] NET: Registered protocol family 15
> [  282.985853] device: 'irlan0': device_add
> [  283.003836] PM: Adding info for No Bus:irlan0
> [  283.020834] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
> [  283.044842] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
> [  283.049825] NET: Registered protocol family 12
> [  283.056828] NET: Registered protocol family 35
> [  283.063831] 8021q: 802.1Q VLAN Support v1.8
> [  283.076846] 9pnet: Installing 9P2000 support
> [  283.091830] batman_adv: B.A.T.M.A.N. advanced 2012.3.0 (compatibility version 14) loaded
> [  283.093810] openvswitch: Open vSwitch switching datapath
> [  283.115804] 
> [  283.115804] printing PIC contents
> [  283.117085] ... PIC  IMR: eff8
> [  283.117085] ... PIC  IRR: 0011
> [  283.118290] ... PIC  ISR: 0000
> [  283.120055] ... PIC ELCR: 0c00
> [  283.121809] Using IPI Shortcut mode
> [  283.127813] device: 'cpu_dma_latency': device_add
> [  283.132816] PM: Adding info for No Bus:cpu_dma_latency
> [  283.135820] device: 'network_latency': device_add
> [  283.140832] PM: Adding info for No Bus:network_latency
> [  283.144850] device: 'network_throughput': device_add
> [  283.149818] PM: Adding info for No Bus:network_throughput
> [  283.157134] dmaengine: __dma_request_channel: fail ((null))
> [  283.170108] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [  283.171133] EDD information not available.
> [  283.184801] ### of_selftest(): No testcase data in device tree; not running tests
> [  283.234829] Freeing unused kernel memory: 400k freed
> [  293.123508] CPA self-test:
> [  293.156399]  4k 3069 large 61 gb 0 x 3130[c0000000-cfffc000] miss 0
> [  321.719166]  4k 65533 large 0 gb 0 x 65533[c0000000-cfffc000] miss 0
> [  326.089755] ------------[ cut here ]------------
> [  326.089755] WARNING: at /c/kernel-tests/src/linux/kernel/lockdep.c:3493 check_flags+0xaa/0x190()
> [  326.089755] Hardware name: Bochs
> [  326.089755] Pid: 8, comm: rcu_kthread Not tainted 3.6.0-rc1 #3
> [  326.089755] Call Trace:
> [  326.089755]  [<c102e02a>] warn_slowpath_common+0x7a/0xa0
> [  326.089755]  [<c10732aa>] ? check_flags+0xaa/0x190
> [  326.089755]  [<c10732aa>] ? check_flags+0xaa/0x190
> [  326.089755]  [<c102e0ed>] warn_slowpath_null+0x1d/0x20
> [  326.089755]  [<c10732aa>] check_flags+0xaa/0x190
> [  326.089755]  [<c10743f4>] lock_is_held+0x34/0xb0
> [  326.089755]  [<c105ebc1>] __might_sleep+0x31/0x1a0
> [  326.089755]  [<c107c0fa>] ? debug_rt_mutex_init+0x1a/0x30
> [  326.089755]  [<c1637f0a>] rt_mutex_lock+0x1a/0x40
> [  326.089755]  [<c108e62a>] rcu_kthread+0xea/0x1a0
> [  326.089755]  [<c108e540>] ? __rcu_process_callbacks+0xd0/0xd0
> [  326.089755]  [<c104f7b7>] kthread+0x67/0x70
> [  326.089755]  [<c104f750>] ? insert_kthread_work+0x80/0x80
> [  326.089755]  [<c163999a>] kernel_thread_helper+0x6/0xd
> [  326.089755] ---[ end trace c73785c318dc0a8f ]---
> [  326.089755] possible reason: unannotated irqs-on.
> [  326.089755] irq event stamp: 440724
> [  326.089755] hardirqs last  enabled at (440723): [<c1638e76>] restore_all_notrace+0x0/0x18
> [  326.089755] hardirqs last disabled at (440724): [<c1076b75>] debug_check_no_locks_freed+0x35/0x160
> [  326.089755] softirqs last  enabled at (440722): [<c10367c7>] __do_softirq+0x2b7/0x370
> [  326.089755] softirqs last disabled at (440715): [<c1003b14>] do_softirq+0x64/0xd0
> [  327.331183]  4k 65533 large 0 gb 0 x 65533[c0000000-cfffc000] miss 0
> [  327.339297] ok.

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.6.0-rc1 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> # CONFIG_NEED_DMA_MAP_STATE is not set
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_GENERIC_GPIO=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
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
> # CONFIG_ZONE_DMA32 is not set
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_32_LAZY_GS=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_HAVE_IRQ_WORK=y
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> # CONFIG_EXPERIMENTAL is not set
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> # CONFIG_KERNEL_GZIP is not set
> CONFIG_KERNEL_BZIP2=y
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> # CONFIG_FHANDLE is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_GENERIC_HARDIRQS=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_KTIME_SCALAR=y
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
> # CONFIG_HIGH_RES_TIMERS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TINY_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_RCU_BOOST=y
> CONFIG_RCU_BOOST_PRIO=1
> CONFIG_RCU_BOOST_DELAY=500
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_CGROUPS=y
> # CONFIG_CGROUP_DEBUG is not set
> CONFIG_CGROUP_FREEZER=y
> # CONFIG_CGROUP_DEVICE is not set
> CONFIG_CPUSETS=y
> # CONFIG_PROC_PID_CPUSET is not set
> CONFIG_CGROUP_CPUACCT=y
> CONFIG_RESOURCE_COUNTERS=y
> # CONFIG_MEMCG is not set
> # CONFIG_CGROUP_PERF is not set
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_BLK_CGROUP=y
> CONFIG_DEBUG_BLK_CGROUP=y
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> CONFIG_IPC_NS=y
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> CONFIG_SCHED_AUTOGROUP=y
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> # CONFIG_SYSCTL_SYSCALL is not set
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
> CONFIG_PERF_USE_VMALLOC=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> CONFIG_DEBUG_PERF_USE_VMALLOC=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> # CONFIG_OPROFILE is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> CONFIG_JUMP_LABEL=y
> CONFIG_UPROBES=y
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP_FILTER=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> # CONFIG_MODULES is not set
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> CONFIG_BLK_DEV_BSG=y
> # CONFIG_BLK_DEV_BSGLIB is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> # CONFIG_IOSCHED_CFQ is not set
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_NOOP=y
> CONFIG_DEFAULT_IOSCHED="noop"
> # CONFIG_INLINE_SPIN_TRYLOCK is not set
> # CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK is not set
> # CONFIG_INLINE_SPIN_LOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_READ_TRYLOCK is not set
> # CONFIG_INLINE_READ_LOCK is not set
> # CONFIG_INLINE_READ_LOCK_BH is not set
> # CONFIG_INLINE_READ_LOCK_IRQ is not set
> # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_READ_UNLOCK is not set
> # CONFIG_INLINE_READ_UNLOCK_BH is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQ is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_WRITE_TRYLOCK is not set
> # CONFIG_INLINE_WRITE_LOCK is not set
> # CONFIG_INLINE_WRITE_LOCK_BH is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_WRITE_UNLOCK is not set
> # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> # CONFIG_MUTEX_SPIN_ON_OWNER is not set
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> # CONFIG_SMP is not set
> CONFIG_X86_MPPARSE=y
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_X86_32_IRIS is not set
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> CONFIG_PARAVIRT_GUEST=y
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> # CONFIG_XEN_PRIVILEGED_GUEST is not set
> CONFIG_KVM_CLOCK=y
> CONFIG_KVM_GUEST=y
> # CONFIG_LGUEST_GUEST is not set
> CONFIG_PARAVIRT=y
> CONFIG_PARAVIRT_CLOCK=y
> # CONFIG_PARAVIRT_DEBUG is not set
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> CONFIG_M686=y
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_INTERNODE_CACHE_SHIFT=5
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=5
> CONFIG_X86_XADD=y
> CONFIG_X86_PPRO_FENCE=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> # CONFIG_IOMMU_HELPER is not set
> CONFIG_NR_CPUS=1
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_UP_APIC=y
> CONFIG_X86_UP_IOAPIC=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> # CONFIG_X86_MCE is not set
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> CONFIG_X86_REBOOTFIXUPS=y
> # CONFIG_MICROCODE is not set
> # CONFIG_X86_MSR is not set
> CONFIG_X86_CPUID=y
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> # CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
> # CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=999999
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_TRANSPARENT_HUGEPAGE=y
> CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
> # CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> # CONFIG_HIGHPTE is not set
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MATH_EMULATION=y
> CONFIG_MTRR=y
> # CONFIG_MTRR_SANITIZER is not set
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> CONFIG_ARCH_RANDOM=y
> CONFIG_SECCOMP=y
> # CONFIG_CC_STACKPROTECTOR is not set
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> # CONFIG_SCHED_HRTICK is not set
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_X86_NEED_RELOCS=y
> CONFIG_PHYSICAL_ALIGN=0x1000000
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_PM_SLEEP=y
> # CONFIG_PM_AUTOSLEEP is not set
> CONFIG_PM_WAKELOCKS=y
> CONFIG_PM_WAKELOCKS_LIMIT=100
> # CONFIG_PM_WAKELOCKS_GC is not set
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> # CONFIG_PM_ADVANCED_DEBUG is not set
> CONFIG_PM_SLEEP_DEBUG=y
> # CONFIG_PM_TRACE_RTC is not set
> # CONFIG_SFI is not set
> CONFIG_X86_APM_BOOT=y
> CONFIG_APM=y
> # CONFIG_APM_IGNORE_USER_SUSPEND is not set
> # CONFIG_APM_DO_ENABLE is not set
> # CONFIG_APM_CPU_IDLE is not set
> CONFIG_APM_DISPLAY_BLANK=y
> CONFIG_APM_ALLOW_INTS=y
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> # CONFIG_CPU_IDLE is not set
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> 
> #
> # Bus options (PCI etc.)
> #
> # CONFIG_PCI is not set
> # CONFIG_ARCH_SUPPORTS_MSI is not set
> CONFIG_PCI_LABEL=y
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> # CONFIG_SCx200 is not set
> CONFIG_OLPC=y
> CONFIG_ALIX=y
> # CONFIG_NET5501 is not set
> CONFIG_GEOS=y
> CONFIG_PCCARD=y
> # CONFIG_PCMCIA is not set
> 
> #
> # PC-card bridges
> #
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_HAVE_AOUT=y
> # CONFIG_BINFMT_AOUT is not set
> CONFIG_BINFMT_MISC=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_HAVE_TEXT_POKE_SMP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> # CONFIG_PACKET is not set
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_NET_KEY=y
> # CONFIG_INET is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETFILTER is not set
> CONFIG_ATM=y
> # CONFIG_ATM_LANE is not set
> CONFIG_STP=y
> CONFIG_BRIDGE=y
> CONFIG_VLAN_8021Q=y
> # CONFIG_VLAN_8021Q_GVRP is not set
> CONFIG_DECNET=y
> CONFIG_LLC=y
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> CONFIG_PHONET=y
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> # CONFIG_NET_SCH_CBQ is not set
> # CONFIG_NET_SCH_HTB is not set
> CONFIG_NET_SCH_HFSC=y
> CONFIG_NET_SCH_ATM=y
> CONFIG_NET_SCH_PRIO=y
> CONFIG_NET_SCH_MULTIQ=y
> CONFIG_NET_SCH_RED=y
> # CONFIG_NET_SCH_SFB is not set
> CONFIG_NET_SCH_SFQ=y
> # CONFIG_NET_SCH_TEQL is not set
> CONFIG_NET_SCH_TBF=y
> # CONFIG_NET_SCH_GRED is not set
> CONFIG_NET_SCH_DSMARK=y
> CONFIG_NET_SCH_NETEM=y
> CONFIG_NET_SCH_DRR=y
> CONFIG_NET_SCH_MQPRIO=y
> CONFIG_NET_SCH_CHOKE=y
> CONFIG_NET_SCH_QFQ=y
> # CONFIG_NET_SCH_CODEL is not set
> CONFIG_NET_SCH_FQ_CODEL=y
> # CONFIG_NET_SCH_INGRESS is not set
> # CONFIG_NET_SCH_PLUG is not set
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> # CONFIG_NET_CLS_BASIC is not set
> CONFIG_NET_CLS_TCINDEX=y
> CONFIG_NET_CLS_FW=y
> CONFIG_NET_CLS_U32=y
> # CONFIG_CLS_U32_PERF is not set
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=y
> # CONFIG_NET_CLS_RSVP6 is not set
> CONFIG_NET_CLS_FLOW=y
> CONFIG_NET_CLS_CGROUP=y
> # CONFIG_NET_EMATCH is not set
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=y
> # CONFIG_NET_ACT_GACT is not set
> # CONFIG_NET_ACT_MIRRED is not set
> CONFIG_NET_ACT_NAT=y
> # CONFIG_NET_ACT_PEDIT is not set
> # CONFIG_NET_ACT_SIMP is not set
> CONFIG_NET_ACT_SKBEDIT=y
> CONFIG_NET_CLS_IND=y
> CONFIG_NET_SCH_FIFO=y
> # CONFIG_DCB is not set
> CONFIG_BATMAN_ADV=y
> # CONFIG_BATMAN_ADV_DEBUG is not set
> CONFIG_OPENVSWITCH=y
> # CONFIG_NETPRIO_CGROUP is not set
> CONFIG_BQL=y
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> CONFIG_HAMRADIO=y
> 
> #
> # Packet Radio protocols
> #
> # CONFIG_AX25 is not set
> # CONFIG_CAN is not set
> CONFIG_IRDA=y
> 
> #
> # IrDA protocols
> #
> CONFIG_IRLAN=y
> # CONFIG_IRCOMM is not set
> # CONFIG_IRDA_ULTRA is not set
> 
> #
> # IrDA options
> #
> # CONFIG_IRDA_CACHE_LAST_LSAP is not set
> CONFIG_IRDA_FAST_RR=y
> CONFIG_IRDA_DEBUG=y
> 
> #
> # Infrared-port device drivers
> #
> 
> #
> # SIR device drivers
> #
> # CONFIG_IRTTY_SIR is not set
> 
> #
> # Dongle support
> #
> 
> #
> # FIR device drivers
> #
> # CONFIG_NSC_FIR is not set
> CONFIG_WINBOND_FIR=y
> CONFIG_SMC_IRCC_FIR=y
> # CONFIG_VIA_FIR is not set
> # CONFIG_BT is not set
> # CONFIG_WIRELESS is not set
> # CONFIG_WIMAX is not set
> CONFIG_RFKILL=y
> CONFIG_RFKILL_INPUT=y
> CONFIG_NET_9P=y
> # CONFIG_NET_9P_VIRTIO is not set
> CONFIG_NET_9P_DEBUG=y
> # CONFIG_CAIF is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_DEBUG_DRIVER=y
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_SPI=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> CONFIG_OF=y
> 
> #
> # Device Tree and Open Firmware support
> #
> CONFIG_PROC_DEVICETREE=y
> CONFIG_OF_SELFTEST=y
> CONFIG_OF_PROMTREE=y
> CONFIG_OF_ADDRESS=y
> CONFIG_OF_IRQ=y
> CONFIG_OF_DEVICE=y
> CONFIG_OF_I2C=y
> CONFIG_PARPORT=y
> CONFIG_PARPORT_PC=y
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=y
> CONFIG_PARPORT_1284=y
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> # CONFIG_BLK_DEV_LOOP is not set
> 
> #
> # DRBD disabled because PROC_FS, INET or CONNECTOR not selected
> #
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_HD is not set
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> CONFIG_AD525X_DPOT=y
> CONFIG_AD525X_DPOT_I2C=y
> # CONFIG_AD525X_DPOT_SPI is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_APDS9802ALS is not set
> CONFIG_ISL29003=y
> CONFIG_ISL29020=y
> # CONFIG_SENSORS_TSL2550 is not set
> # CONFIG_SENSORS_BH1780 is not set
> # CONFIG_SENSORS_BH1770 is not set
> CONFIG_SENSORS_APDS990X=y
> CONFIG_HMC6352=y
> CONFIG_TI_DAC7512=y
> CONFIG_VMWARE_BALLOON=y
> CONFIG_BMP085=y
> # CONFIG_BMP085_I2C is not set
> CONFIG_BMP085_SPI=y
> CONFIG_USB_SWITCH_FSA9480=y
> 
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_AT24 is not set
> CONFIG_EEPROM_AT25=y
> # CONFIG_EEPROM_LEGACY is not set
> # CONFIG_EEPROM_93CX6 is not set
> # CONFIG_EEPROM_93XX46 is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> CONFIG_SENSORS_LIS3_SPI=y
> # CONFIG_SENSORS_LIS3_I2C is not set
> 
> #
> # Altera FPGA firmware download module
> #
> # CONFIG_ALTERA_STAPL is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_ATAPI=y
> CONFIG_BLK_DEV_IDE_SATA=y
> # CONFIG_IDE_GD is not set
> CONFIG_BLK_DEV_IDECD=y
> CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
> CONFIG_BLK_DEV_IDETAPE=y
> # CONFIG_IDE_TASK_IOCTL is not set
> CONFIG_IDE_PROC_FS=y
> 
> #
> # IDE chipset support/bugfixes
> #
> # CONFIG_IDE_GENERIC is not set
> CONFIG_BLK_DEV_PLATFORM=y
> # CONFIG_BLK_DEV_CMD640 is not set
> # CONFIG_BLK_DEV_IDEDMA is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=y
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_NETLINK=y
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> # CONFIG_BLK_DEV_SD is not set
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=y
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> CONFIG_CHR_DEV_SG=y
> # CONFIG_CHR_DEV_SCH is not set
> CONFIG_SCSI_MULTI_LUN=y
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> # CONFIG_SCSI_SCAN_ASYNC is not set
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=y
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> # CONFIG_SCSI_SAS_ATA is not set
> # CONFIG_SCSI_SAS_HOST_SMP is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> # CONFIG_SCSI_LOWLEVEL is not set
> CONFIG_SCSI_DH=y
> # CONFIG_SCSI_DH_RDAC is not set
> # CONFIG_SCSI_DH_HP_SW is not set
> # CONFIG_SCSI_DH_EMC is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> # CONFIG_ATA_VERBOSE_ERROR is not set
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI_PLATFORM is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> CONFIG_SATA_MV=y
> 
> #
> # PATA SFF controllers with BMDMA
> #
> CONFIG_PATA_ARASAN_CF=y
> 
> #
> # PIO-only SFF controllers
> #
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_MD is not set
> CONFIG_TARGET_CORE=y
> CONFIG_TCM_IBLOCK=y
> # CONFIG_TCM_FILEIO is not set
> CONFIG_TCM_PSCSI=y
> CONFIG_LOOPBACK_TARGET=y
> # CONFIG_ISCSI_TARGET is not set
> CONFIG_MACINTOSH_DRIVERS=y
> # CONFIG_MAC_EMUMOUSEBTN is not set
> # CONFIG_NETDEVICES is not set
> # CONFIG_ISDN is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> CONFIG_INPUT_POLLDEV=y
> # CONFIG_INPUT_SPARSEKMAP is not set
> CONFIG_INPUT_MATRIXKMAP=y
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=y
> # CONFIG_INPUT_EVDEV is not set
> CONFIG_INPUT_EVBUG=y
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ADP5588=y
> CONFIG_KEYBOARD_ADP5589=y
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> CONFIG_KEYBOARD_LKKBD=y
> # CONFIG_KEYBOARD_GPIO is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> CONFIG_KEYBOARD_MATRIX=y
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> CONFIG_KEYBOARD_NEWTON=y
> # CONFIG_KEYBOARD_OPENCORES is not set
> CONFIG_KEYBOARD_STOWAWAY=y
> CONFIG_KEYBOARD_SUNKBD=y
> # CONFIG_KEYBOARD_OMAP4 is not set
> CONFIG_KEYBOARD_TC3589X=y
> CONFIG_KEYBOARD_TWL4030=y
> CONFIG_KEYBOARD_XTKBD=y
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_AD714X=y
> CONFIG_INPUT_AD714X_I2C=y
> CONFIG_INPUT_AD714X_SPI=y
> CONFIG_INPUT_BMA150=y
> # CONFIG_INPUT_PCSPKR is not set
> CONFIG_INPUT_MC13783_PWRBUTTON=y
> # CONFIG_INPUT_MMA8450 is not set
> CONFIG_INPUT_MPU3050=y
> CONFIG_INPUT_APANEL=y
> CONFIG_INPUT_GP2A=y
> CONFIG_INPUT_GPIO_TILT_POLLED=y
> # CONFIG_INPUT_WISTRON_BTNS is not set
> CONFIG_INPUT_KXTJ9=y
> CONFIG_INPUT_KXTJ9_POLLED_MODE=y
> # CONFIG_INPUT_TWL4030_PWRBUTTON is not set
> # CONFIG_INPUT_TWL4030_VIBRA is not set
> CONFIG_INPUT_UINPUT=y
> # CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
> # CONFIG_INPUT_PCAP is not set
> CONFIG_INPUT_ADXL34X=y
> CONFIG_INPUT_ADXL34X_I2C=y
> CONFIG_INPUT_ADXL34X_SPI=y
> CONFIG_INPUT_CMA3000=y
> # CONFIG_INPUT_CMA3000_I2C is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_CT82C710 is not set
> CONFIG_SERIO_PARKBD=y
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_SERIO_PS2MULT is not set
> CONFIG_GAMEPORT=y
> CONFIG_GAMEPORT_NS558=y
> # CONFIG_GAMEPORT_L4 is not set
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_VT_CONSOLE_SLEEP=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_TRACE_ROUTER is not set
> CONFIG_TRACE_SINK=y
> CONFIG_DEVKMEM=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> CONFIG_SERIAL_8250_DW=y
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MAX3100 is not set
> CONFIG_SERIAL_MAX3107=y
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_OF_PLATFORM is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_XILINX_PS_UART is not set
> # CONFIG_PRINTER is not set
> # CONFIG_PPDEV is not set
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_HW_RANDOM is not set
> CONFIG_NVRAM=y
> CONFIG_RTC=y
> # CONFIG_R3964 is not set
> CONFIG_MWAVE=y
> CONFIG_PC8736x_GPIO=y
> CONFIG_NSC_GPIO=y
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HANGCHECK_TIMER is not set
> CONFIG_TCG_TPM=y
> # CONFIG_TCG_TIS is not set
> # CONFIG_TCG_NSC is not set
> CONFIG_TCG_ATMEL=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_COMPAT is not set
> CONFIG_I2C_CHARDEV=y
> CONFIG_I2C_MUX=y
> 
> #
> # Multiplexer I2C Chip support
> #
> CONFIG_I2C_MUX_GPIO=y
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
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_GPIO=y
> CONFIG_I2C_PCA_PLATFORM=y
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=y
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT=y
> CONFIG_I2C_PARPORT_LIGHT=y
> 
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_I2C_DEBUG_CORE=y
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
> CONFIG_SPI_GPIO=y
> # CONFIG_SPI_OC_TINY is not set
> # CONFIG_SPI_PXA2XX_PCI is not set
> # CONFIG_SPI_XCOMM is not set
> CONFIG_SPI_DESIGNWARE=y
> 
> #
> # SPI Protocol Masters
> #
> # CONFIG_SPI_TLE62X0 is not set
> CONFIG_HSI=y
> CONFIG_HSI_BOARDINFO=y
> 
> #
> # HSI clients
> #
> CONFIG_HSI_CHAR=y
> 
> #
> # PPS support
> #
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> 
> #
> # Enable Device Drivers -> PPS to see the PTP clock options.
> #
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_OF_GPIO=y
> CONFIG_DEBUG_GPIO=y
> CONFIG_GPIO_GENERIC=y
> 
> #
> # Memory mapped GPIO drivers:
> #
> CONFIG_GPIO_GENERIC_PLATFORM=y
> CONFIG_GPIO_IT8761E=y
> 
> #
> # I2C GPIO expanders:
> #
> # CONFIG_GPIO_MAX7300 is not set
> CONFIG_GPIO_MAX732X=y
> # CONFIG_GPIO_MAX732X_IRQ is not set
> # CONFIG_GPIO_PCA953X is not set
> CONFIG_GPIO_PCF857X=y
> # CONFIG_GPIO_SX150X is not set
> CONFIG_GPIO_TC3589X=y
> # CONFIG_GPIO_TWL4030 is not set
> # CONFIG_GPIO_WM8350 is not set
> # CONFIG_GPIO_WM8994 is not set
> # CONFIG_GPIO_ADP5588 is not set
> 
> #
> # PCI GPIO expanders:
> #
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MAX7301 is not set
> CONFIG_GPIO_MCP23S08=y
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
> # CONFIG_GPIO_TPS65910 is not set
> # CONFIG_W1 is not set
> # CONFIG_POWER_SUPPLY is not set
> CONFIG_POWER_AVS=y
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_ADM1021=y
> CONFIG_SENSORS_ADM1025=y
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> CONFIG_SENSORS_ADM1031=y
> # CONFIG_SENSORS_ADM9240 is not set
> CONFIG_SENSORS_ADT7475=y
> # CONFIG_SENSORS_ASC7621 is not set
> # CONFIG_SENSORS_DS620 is not set
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_FSCHMD is not set
> # CONFIG_SENSORS_G760A is not set
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> # CONFIG_SENSORS_GPIO_FAN is not set
> # CONFIG_SENSORS_IT87 is not set
> CONFIG_SENSORS_JC42=y
> CONFIG_SENSORS_LM63=y
> # CONFIG_SENSORS_LM70 is not set
> # CONFIG_SENSORS_LM73 is not set
> CONFIG_SENSORS_LM75=y
> # CONFIG_SENSORS_LM77 is not set
> CONFIG_SENSORS_LM78=y
> # CONFIG_SENSORS_LM80 is not set
> CONFIG_SENSORS_LM83=y
> # CONFIG_SENSORS_LM85 is not set
> CONFIG_SENSORS_LM87=y
> CONFIG_SENSORS_LM90=y
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> CONFIG_SENSORS_LTC4151=y
> # CONFIG_SENSORS_LM95241 is not set
> CONFIG_SENSORS_MAX1111=y
> # CONFIG_SENSORS_MAX16065 is not set
> # CONFIG_SENSORS_MAX1619 is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_SENSORS_SHT15 is not set
> # CONFIG_SENSORS_SHT21 is not set
> # CONFIG_SENSORS_EMC1403 is not set
> # CONFIG_SENSORS_EMC2103 is not set
> # CONFIG_SENSORS_EMC6W201 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> CONFIG_SENSORS_SMSC47M192=y
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> # CONFIG_SENSORS_ADS1015 is not set
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_ADS7871=y
> # CONFIG_SENSORS_THMC50 is not set
> CONFIG_SENSORS_VIA_CPUTEMP=y
> CONFIG_SENSORS_VT1211=y
> # CONFIG_SENSORS_W83781D is not set
> CONFIG_SENSORS_W83791D=y
> CONFIG_SENSORS_W83792D=y
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> CONFIG_SENSORS_WM8350=y
> CONFIG_SENSORS_APPLESMC=y
> # CONFIG_SENSORS_MC13783_ADC is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=y
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> CONFIG_SSB_SDIOHOST=y
> CONFIG_SSB_DEBUG=y
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_DRIVER_GMAC_CMN=y
> CONFIG_BCMA_DEBUG=y
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> # CONFIG_MFD_88PM860X is not set
> # CONFIG_MFD_88PM800 is not set
> # CONFIG_MFD_88PM805 is not set
> CONFIG_MFD_SM501=y
> CONFIG_MFD_SM501_GPIO=y
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_HTC_I2CPLD is not set
> # CONFIG_MFD_LM3533 is not set
> # CONFIG_TPS6105X is not set
> CONFIG_TPS65010=y
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TPS65217 is not set
> CONFIG_MFD_TPS65910=y
> # CONFIG_MFD_TPS65912_I2C is not set
> # CONFIG_MFD_TPS65912_SPI is not set
> CONFIG_TWL4030_CORE=y
> # CONFIG_TWL4030_MADC is not set
> # CONFIG_MFD_TWL4030_AUDIO is not set
> # CONFIG_TWL6030_PWM is not set
> # CONFIG_TWL6040_CORE is not set
> # CONFIG_MFD_STMPE is not set
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> CONFIG_PMIC_DA903X=y
> # CONFIG_MFD_DA9052_SPI is not set
> # CONFIG_MFD_DA9052_I2C is not set
> # CONFIG_PMIC_ADP5520 is not set
> # CONFIG_MFD_MAX77686 is not set
> # CONFIG_MFD_MAX77693 is not set
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> CONFIG_MFD_MAX8998=y
> # CONFIG_MFD_SEC_CORE is not set
> # CONFIG_MFD_ARIZONA_I2C is not set
> # CONFIG_MFD_ARIZONA_SPI is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM831X_I2C is not set
> # CONFIG_MFD_WM831X_SPI is not set
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> CONFIG_MFD_WM8994=y
> # CONFIG_MFD_PCF50633 is not set
> CONFIG_MFD_MC13783=y
> CONFIG_MFD_MC13XXX=y
> CONFIG_MFD_MC13XXX_SPI=y
> # CONFIG_MFD_MC13XXX_I2C is not set
> # CONFIG_ABX500_CORE is not set
> CONFIG_EZX_PCAP=y
> # CONFIG_MFD_WL1273_CORE is not set
> CONFIG_MFD_TPS65090=y
> CONFIG_MFD_AAT2870_CORE=y
> # CONFIG_MFD_RC5T583 is not set
> # CONFIG_MFD_PALMAS is not set
> # CONFIG_REGULATOR is not set
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> CONFIG_DRM=y
> # CONFIG_VGASTATE is not set
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> # CONFIG_FB_DDC is not set
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> CONFIG_FB_FOREIGN_ENDIAN=y
> # CONFIG_FB_BOTH_ENDIAN is not set
> # CONFIG_FB_BIG_ENDIAN is not set
> CONFIG_FB_LITTLE_ENDIAN=y
> CONFIG_FB_SYS_FOPS=y
> # CONFIG_FB_WMT_GE_ROPS is not set
> CONFIG_FB_DEFERRED_IO=y
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=y
> # CONFIG_FB_TILEBLITTING is not set
> 
> #
> # Frame buffer hardware drivers
> #
> CONFIG_FB_ARC=y
> # CONFIG_FB_VGA16 is not set
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_N411 is not set
> CONFIG_FB_HGA=y
> CONFIG_FB_S1D13XXX=y
> CONFIG_FB_TMIO=y
> # CONFIG_FB_TMIO_ACCELL is not set
> # CONFIG_FB_SM501 is not set
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_FB_METRONOME is not set
> CONFIG_FB_BROADSHEET=y
> CONFIG_FB_AUO_K190X=y
> # CONFIG_FB_AUO_K1900 is not set
> CONFIG_FB_AUO_K1901=y
> CONFIG_EXYNOS_VIDEO=y
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> CONFIG_DUMMY_CONSOLE=y
> # CONFIG_FRAMEBUFFER_CONSOLE is not set
> CONFIG_LOGO=y
> # CONFIG_LOGO_LINUX_MONO is not set
> CONFIG_LOGO_LINUX_VGA16=y
> CONFIG_LOGO_LINUX_CLUT224=y
> # CONFIG_SOUND is not set
> 
> #
> # HID support
> #
> # CONFIG_HID is not set
> # CONFIG_USB_ARCH_HAS_OHCI is not set
> # CONFIG_USB_ARCH_HAS_EHCI is not set
> # CONFIG_USB_ARCH_HAS_XHCI is not set
> CONFIG_USB_SUPPORT=y
> # CONFIG_USB_ARCH_HAS_HCD is not set
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> # CONFIG_USB_GADGET is not set
> 
> #
> # OTG and related infrastructure
> #
> CONFIG_MMC=y
> # CONFIG_MMC_DEBUG is not set
> CONFIG_MMC_UNSAFE_RESUME=y
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=y
> CONFIG_MMC_BLOCK_MINORS=8
> CONFIG_MMC_BLOCK_BOUNCE=y
> # CONFIG_SDIO_UART is not set
> # CONFIG_MMC_TEST is not set
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> # CONFIG_MMC_SDHCI is not set
> # CONFIG_MMC_WBSD is not set
> CONFIG_MEMSTICK=y
> CONFIG_MEMSTICK_DEBUG=y
> 
> #
> # MemoryStick drivers
> #
> # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
> # CONFIG_MSPRO_BLOCK is not set
> 
> #
> # MemoryStick Host Controller Drivers
> #
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_LM3530=y
> CONFIG_LEDS_GPIO=y
> CONFIG_LEDS_LP3944=y
> CONFIG_LEDS_LP5521=y
> # CONFIG_LEDS_LP5523 is not set
> # CONFIG_LEDS_CLEVO_MAIL is not set
> CONFIG_LEDS_PCA955X=y
> CONFIG_LEDS_PCA9633=y
> CONFIG_LEDS_WM8350=y
> # CONFIG_LEDS_DA903X is not set
> CONFIG_LEDS_DAC124S085=y
> CONFIG_LEDS_BD2802=y
> # CONFIG_LEDS_LT3593 is not set
> # CONFIG_LEDS_MC13783 is not set
> # CONFIG_LEDS_TCA6507 is not set
> # CONFIG_LEDS_LM3556 is not set
> CONFIG_LEDS_OT200=y
> # CONFIG_LEDS_BLINKM is not set
> # CONFIG_LEDS_TRIGGERS is not set
> 
> #
> # LED Triggers
> #
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_EDAC is not set
> # CONFIG_RTC_CLASS is not set
> CONFIG_DMADEVICES=y
> CONFIG_DMADEVICES_DEBUG=y
> # CONFIG_DMADEVICES_VDEBUG is not set
> 
> #
> # DMA Devices
> #
> # CONFIG_TIMB_DMA is not set
> CONFIG_DMA_ENGINE=y
> 
> #
> # DMA Clients
> #
> # CONFIG_NET_DMA is not set
> # CONFIG_ASYNC_TX_DMA is not set
> CONFIG_DMATEST=y
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> CONFIG_VIRTIO=y
> CONFIG_VIRTIO_RING=y
> 
> #
> # Virtio drivers
> #
> CONFIG_VIRTIO_BALLOON=y
> 
> #
> # Microsoft Hyper-V guest support
> #
> CONFIG_STAGING=y
> # CONFIG_ECHO is not set
> CONFIG_FB_OLPC_DCON=y
> # CONFIG_PANEL is not set
> CONFIG_ZRAM=y
> CONFIG_ZRAM_DEBUG=y
> CONFIG_ZSMALLOC=y
> # CONFIG_FT1000 is not set
> 
> #
> # Speakup console speech
> #
> # CONFIG_SPEAKUP is not set
> # CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
> CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
> CONFIG_STAGING_MEDIA=y
> 
> #
> # Android
> #
> # CONFIG_ANDROID is not set
> CONFIG_PHONE=y
> # CONFIG_IPACK_BUS is not set
> # CONFIG_WIMAX_GDM72XX is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_AMILO_RFKILL is not set
> # CONFIG_SENSORS_HDAPS is not set
> CONFIG_XO1_RFKILL=y
> # CONFIG_SAMSUNG_LAPTOP is not set
> # CONFIG_SAMSUNG_Q10 is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> CONFIG_IOMMU_SUPPORT=y
> CONFIG_OF_IOMMU=y
> 
> #
> # Remoteproc drivers (EXPERIMENTAL)
> #
> 
> #
> # Rpmsg drivers (EXPERIMENTAL)
> #
> # CONFIG_VIRT_DRIVERS is not set
> CONFIG_PM_DEVFREQ=y
> 
> #
> # DEVFREQ Governors
> #
> # CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
> # CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
> # CONFIG_DEVFREQ_GOV_POWERSAVE is not set
> # CONFIG_DEVFREQ_GOV_USERSPACE is not set
> 
> #
> # DEVFREQ Drivers
> #
> CONFIG_EXTCON=y
> 
> #
> # Extcon Device Drivers
> #
> CONFIG_EXTCON_GPIO=y
> # CONFIG_MEMORY is not set
> # CONFIG_IIO is not set
> # CONFIG_PWM is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=y
> CONFIG_EDD_OFF=y
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=y
> # CONFIG_DMIID is not set
> # CONFIG_DMI_SYSFS is not set
> CONFIG_ISCSI_IBFT_FIND=y
> CONFIG_GOOGLE_FIRMWARE=y
> 
> #
> # Google Firmware Drivers
> #
> # CONFIG_GOOGLE_MEMCONSOLE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> # CONFIG_EXT2_FS_POSIX_ACL is not set
> # CONFIG_EXT2_FS_SECURITY is not set
> CONFIG_EXT2_FS_XIP=y
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
> # CONFIG_EXT3_FS_XATTR is not set
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_FS_XATTR=y
> # CONFIG_EXT4_FS_POSIX_ACL is not set
> CONFIG_EXT4_FS_SECURITY=y
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_FS_XIP=y
> CONFIG_JBD=y
> CONFIG_JBD_DEBUG=y
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_PROC_INFO is not set
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> CONFIG_REISERFS_FS_SECURITY=y
> # CONFIG_JFS_FS is not set
> CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> # CONFIG_GFS2_FS is not set
> CONFIG_OCFS2_FS=y
> # CONFIG_OCFS2_FS_O2CB is not set
> # CONFIG_OCFS2_FS_STATS is not set
> # CONFIG_OCFS2_DEBUG_MASKLOG is not set
> CONFIG_OCFS2_DEBUG_FS=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> # CONFIG_INOTIFY_USER is not set
> CONFIG_FANOTIFY=y
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> # CONFIG_PRINT_QUOTA_WARNING is not set
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> CONFIG_QFMT_V1=y
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS4_FS=y
> # CONFIG_FUSE_FS is not set
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> # CONFIG_UDF_FS is not set
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> # CONFIG_VFAT_FS is not set
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> # CONFIG_NTFS_FS is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_VMCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> # CONFIG_TMPFS is not set
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> # CONFIG_HFSPLUS_FS is not set
> CONFIG_CRAMFS=y
> # CONFIG_SQUASHFS is not set
> CONFIG_VXFS_FS=y
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> CONFIG_HPFS_FS=y
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_QNX6FS_FS is not set
> CONFIG_ROMFS_FS=y
> CONFIG_ROMFS_BACKED_BY_BLOCK=y
> CONFIG_ROMFS_ON_BLOCK=y
> # CONFIG_PSTORE is not set
> # CONFIG_SYSV_FS is not set
> CONFIG_UFS_FS=y
> # CONFIG_UFS_DEBUG is not set
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> # CONFIG_NLS_CODEPAGE_437 is not set
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> CONFIG_NLS_CODEPAGE_855=y
> CONFIG_NLS_CODEPAGE_857=y
> CONFIG_NLS_CODEPAGE_860=y
> # CONFIG_NLS_CODEPAGE_861 is not set
> CONFIG_NLS_CODEPAGE_862=y
> # CONFIG_NLS_CODEPAGE_863 is not set
> CONFIG_NLS_CODEPAGE_864=y
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> CONFIG_NLS_CODEPAGE_932=y
> CONFIG_NLS_CODEPAGE_949=y
> # CONFIG_NLS_CODEPAGE_874 is not set
> CONFIG_NLS_ISO8859_8=y
> # CONFIG_NLS_CODEPAGE_1250 is not set
> CONFIG_NLS_CODEPAGE_1251=y
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> CONFIG_NLS_ISO8859_6=y
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> # CONFIG_NLS_ISO8859_15 is not set
> CONFIG_NLS_KOI8_R=y
> CONFIG_NLS_KOI8_U=y
> CONFIG_NLS_MAC_ROMAN=y
> # CONFIG_NLS_MAC_CELTIC is not set
> CONFIG_NLS_MAC_CENTEURO=y
> CONFIG_NLS_MAC_CROATIAN=y
> # CONFIG_NLS_MAC_CYRILLIC is not set
> # CONFIG_NLS_MAC_GAELIC is not set
> # CONFIG_NLS_MAC_GREEK is not set
> # CONFIG_NLS_MAC_ICELAND is not set
> CONFIG_NLS_MAC_INUIT=y
> CONFIG_NLS_MAC_ROMANIAN=y
> # CONFIG_NLS_MAC_TURKISH is not set
> CONFIG_NLS_UTF8=y
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=1024
> # CONFIG_MAGIC_SYSRQ is not set
> # CONFIG_STRIP_ASM_SYMS is not set
> CONFIG_READABLE_ASM=y
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_SHIRQ=y
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_HARDLOCKUP_DETECTOR is not set
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> # CONFIG_DETECT_HUNG_TASK is not set
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHEDSTATS is not set
> CONFIG_TIMER_STATS=y
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_SLUB_STATS is not set
> # CONFIG_DEBUG_PREEMPT is not set
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_RT_MUTEX_TESTER=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_PROVE_RCU=y
> CONFIG_PROVE_RCU_REPEATEDLY=y
> CONFIG_SPARSE_RCU_POINTER=y
> CONFIG_LOCKDEP=y
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_HIGHMEM=y
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_INFO is not set
> CONFIG_DEBUG_VM=y
> CONFIG_DEBUG_VIRTUAL=y
> CONFIG_DEBUG_WRITECOUNT=y
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_LIST is not set
> CONFIG_TEST_LIST_SORT=y
> CONFIG_DEBUG_SG=y
> # CONFIG_DEBUG_NOTIFIERS is not set
> CONFIG_DEBUG_CREDENTIALS=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_DEBUG_BLOCK_EXT_DEVT=y
> CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
> # CONFIG_LKDTM is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> CONFIG_FAULT_INJECTION=y
> # CONFIG_FAILSLAB is not set
> CONFIG_FAIL_PAGE_ALLOC=y
> CONFIG_FAIL_MAKE_REQUEST=y
> # CONFIG_FAIL_IO_TIMEOUT is not set
> # CONFIG_FAIL_MMC_REQUEST is not set
> # CONFIG_FAULT_INJECTION_DEBUG_FS is not set
> # CONFIG_LATENCYTOP is not set
> # CONFIG_DEBUG_PAGEALLOC is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> # CONFIG_FUNCTION_TRACER is not set
> CONFIG_IRQSOFF_TRACER=y
> CONFIG_PREEMPT_TRACER=y
> CONFIG_SCHED_TRACER=y
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> # CONFIG_STACK_TRACER is not set
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_UPROBE_EVENT=y
> CONFIG_PROBE_EVENTS=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> CONFIG_RING_BUFFER_BENCHMARK=y
> CONFIG_DYNAMIC_DEBUG=y
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_KMEMCHECK is not set
> CONFIG_TEST_KSTRTOX=y
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_DEBUG_STACKOVERFLOW=y
> CONFIG_X86_PTDUMP=y
> # CONFIG_DEBUG_RODATA is not set
> CONFIG_DOUBLEFAULT=y
> CONFIG_DEBUG_TLBFLUSH=y
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> CONFIG_IO_DELAY_0XED=y
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=1
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> CONFIG_CPA_DEBUG=y
> CONFIG_OPTIMIZE_INLINING=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> 
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITY is not set
> CONFIG_SECURITYFS=y
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
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
> CONFIG_CRYPTO_USER=y
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> # CONFIG_CRYPTO_NULL is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> # CONFIG_CRYPTO_CRYPTD is not set
> CONFIG_CRYPTO_AUTHENC=y
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
> # CONFIG_CRYPTO_CBC is not set
> CONFIG_CRYPTO_CTR=y
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=y
> # CONFIG_CRYPTO_LRW is not set
> # CONFIG_CRYPTO_PCBC is not set
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_HMAC is not set
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_GHASH=y
> # CONFIG_CRYPTO_MD4 is not set
> # CONFIG_CRYPTO_MD5 is not set
> CONFIG_CRYPTO_MICHAEL_MIC=y
> CONFIG_CRYPTO_RMD128=y
> # CONFIG_CRYPTO_RMD160 is not set
> CONFIG_CRYPTO_RMD256=y
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> CONFIG_CRYPTO_WP512=y
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_ARC4=y
> # CONFIG_CRYPTO_BLOWFISH is not set
> CONFIG_CRYPTO_CAMELLIA=y
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=y
> CONFIG_CRYPTO_KHAZAD=y
> # CONFIG_CRYPTO_SEED is not set
> CONFIG_CRYPTO_SERPENT=y
> # CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> # CONFIG_CRYPTO_TWOFISH_586 is not set
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
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_HW=y
> # CONFIG_CRYPTO_DEV_PADLOCK is not set
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> # CONFIG_CRC_T10DIF is not set
> # CONFIG_CRC_ITU_T is not set
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> # CONFIG_CRC32_SLICEBY8 is not set
> CONFIG_CRC32_SLICEBY4=y
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> # CONFIG_CRC7 is not set
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
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> # CONFIG_AVERAGE is not set
> # CONFIG_CORDIC is not set
> # CONFIG_DDR is not set


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2HQOIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:08:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:32527 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab2HQOHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:07:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,785,1336374000"; 
   d="scan'208";a="203539467"
Date: Fri, 17 Aug 2012 22:07:19 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: lockdep warning on rt_mutex_lock()
Message-ID: <20120817140719.GA701@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20120817134328.GB2872@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Paul,

This should be easier to reproduce. It still does not always happen,
but did happen in many test boxes.

/bin/sh: /proc/self/fd/9: No such file or directory
[   13.889219] ------------[ cut here ]------------
[   13.889945] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3493 check_flags+0x131/0x320()
[   13.891200] Pid: 8, comm: rcu_kthread Not tainted 3.6.0-rc1-00002-g0c8f7ca #617
[   13.892531] Call Trace:
[   13.893008]  [<ffffffff8112de21>] ? check_flags+0x131/0x320
[   13.894050]  [<ffffffff8109c78d>] warn_slowpath_common+0xad/0xf0
[   13.895166]  [<ffffffff8109c8f5>] warn_slowpath_null+0x25/0x30
[   13.896241]  [<ffffffff8112de21>] check_flags+0x131/0x320
[   13.897266]  [<ffffffff8112fd10>] lock_is_held+0x70/0x140
[   13.898327]  [<ffffffff8110eb9b>] __might_sleep+0x5b/0x3a0
[   13.899165]  [<ffffffff8180ded7>] rt_mutex_lock+0x27/0x50
[   13.899165]  [<ffffffff811573f4>] rcu_boost+0x144/0x270
[   13.899165]  [<ffffffff810f03ad>] ? finish_wait+0x8d/0xd0
[   13.899165]  [<ffffffff8180ee37>] ? _raw_spin_unlock_irqrestore+0x107/0x150
[   13.899165]  [<ffffffff810f03ad>] ? finish_wait+0x8d/0xd0
[   13.899165]  [<ffffffff8115791d>] rcu_kthread+0x15d/0x2c0
[   13.899165]  [<ffffffff810f0510>] ? abort_exclusive_wait+0x120/0x120
[   13.899165]  [<ffffffff811577c0>] ? __rcu_process_callbacks+0x2a0/0x2a0
[   13.899165]  [<ffffffff811577c0>] ? __rcu_process_callbacks+0x2a0/0x2a0
[   13.899165]  [<ffffffff810ee89f>] kthread+0xef/0x100
[   13.899165]  [<ffffffff81812004>] kernel_thread_helper+0x4/0x10
[   13.899165]  [<ffffffff81810870>] ? retint_restore_args+0x13/0x13
[   13.899165]  [<ffffffff810ee7b0>] ? insert_kthread_work+0x1a0/0x1a0
[   13.899165]  [<ffffffff81812000>] ? gs_change+0x13/0x13

Thanks,
Fengguang

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm-fat-3493-2012-08-07-11-33-30

[    0.000000] Linux version 3.6.0-rc1-00002-g0c8f7ca (kbuild@snb) (gcc version 4.7.1 (Debian 4.7.1-5) ) #617 PREEMPT Tue Aug 7 11:24:59 CST 2012
[    0.000000] Command line: trinity=3m hung_task_panic=1 branch=leds/for-next log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-08-07-11-25-25-leds:for-next:0c8f7ca-0c8f7ca-x86_64-randconfig-s015-3-fat BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-s015/0c8f7ca/vmlinuz-3.6.0-rc1-00002-g0c8f7ca
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffcfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffd000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffbc000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffd max_arch_pfn = 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70106, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f8860-0x000f886f] mapped at [ffff8800000f8860]
[    0.000000]   mpc: f8870-f898c
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffcfff]
[    0.000000]  [mem 0x00000000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffcfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffcfff @ [mem 0x0e854000-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128136(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] kvm-clock: Using msrs 12 and 11
[    0.000000] kvm-clock: cpu 0, msr 0:205ad41, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d400000-ffff88000d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffcfff]
[    0.000000] On node 0 totalpages: 65420
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 60477 pages, LIFO batch:15
[    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: f8870-f898c
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 01
[    0.000000] Processors: 1
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64390
[    0.000000] Kernel command line: trinity=3m hung_task_panic=1 branch=leds/for-next log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-08-07-11-25-25-leds:for-next:0c8f7ca-0c8f7ca-x86_64-randconfig-s015-3-fat BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-s015/0c8f7ca/vmlinuz-3.6.0-rc1-00002-g0c8f7ca
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 187536k/262132k available (8266k kernel code, 452k absent, 74144k reserved, 15165k data, 580k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:48 16
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
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] tsc: Detected 3200.098 MHz processor
[    0.010000] Calibrating delay loop (skipped) preset value.. 6400.19 BogoMIPS (lpj=32000980)
[    0.010000] pid_max: default: 4096 minimum: 301
[    0.010000] Mount-cache hash table entries: 256
[    0.010000] Disabled fast string operations
[    0.010000] mce: CPU supports 10 MCE banks
[    0.010000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010000] tlb_flushall_shift is 0x6
[    0.010000] CPU: Intel Common KVM processor stepping 01
[    0.012195] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.014618] Testing tracer nop: PASSED
[    0.015186] Getting VERSION: 50014
[    0.015624] Getting VERSION: 50014
[    0.016107] Getting ID: 0
[    0.016458] Getting ID: ff000000
[    0.016893] Getting LVT0: 8700
[    0.017282] Getting LVT1: 8400
[    0.017743] enabled ExtINT on CPU#0
[    0.019516] ENABLING IO-APIC IRQs
[    0.020030] init IO_APIC IRQs
[    0.020448]  apic 2 pin 0 not connected
[    0.020975] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.022011] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.023097] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.024130] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.025178] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.026239] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.027313] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.028344] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.029427] IOAPIC[0]: Set routing entry (2-9 -> 0x41 -> IRQ 33 Mode:1 Active:0 Dest:1)
[    0.030072] IOAPIC[0]: Set routing entry (2-10 -> 0x51 -> IRQ 34 Mode:1 Active:0 Dest:1)
[    0.031102] IOAPIC[0]: Set routing entry (2-11 -> 0x61 -> IRQ 35 Mode:1 Active:0 Dest:1)
[    0.032173] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.033212] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.034222] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.035260] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.036266]  apic 2 pin 16 not connected
[    0.036755]  apic 2 pin 17 not connected
[    0.037233]  apic 2 pin 18 not connected
[    0.037727]  apic 2 pin 19 not connected
[    0.038214]  apic 2 pin 20 not connected
[    0.038698]  apic 2 pin 21 not connected
[    0.039195]  apic 2 pin 22 not connected
[    0.040021]  apic 2 pin 23 not connected
[    0.040689] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.041649] Using local APIC timer interrupts.
[    0.041649] calibrating APIC timer ...
[    0.050000] ... lapic delta = 6250343
[    0.050000] ..... delta 6250343
[    0.050000] ..... mult: 268450187
[    0.050000] ..... calibration result: 10000548
[    0.050000] ..... CPU clock speed is 3200.2905 MHz.
[    0.050000] ..... host bus clock speed is 1000.0548 MHz.
[    0.050000] ... verify APIC timer
[    0.165982] ... jiffies delta = 10
[    0.166708] ... jiffies result ok
[    0.170000] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.170000] RTC time:  3:33:12, date: 08/07/12
[    0.170000] NET: Registered protocol family 16
[    0.177224] bio: create slab <bio-0> at 0
[    0.178942] SCSI subsystem initialized
[    0.179800] libata version 3.00 loaded.
[    0.190585] Switching to clocksource kvm-clock
[    0.193580] Warning: could not register all branches stats
[    0.194736] Warning: could not register annotated branches stats
[    0.345738] NET: Registered protocol family 1
[    0.347556] Unpacking initramfs...
[    2.844593] Freeing initrd memory: 23656k freed
[    2.878534] DMA-API: preallocated 32768 debug entries
[    2.879523] DMA-API: debugging enabled by kernel config
[    2.880889] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    2.882551] Machine check injector initialized
[    2.884234] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    2.886052] cryptomgr_test (16) used greatest stack depth: 6272 bytes left
[    2.887670] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    2.890635] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/1 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    2.896606] Testing tracer irqsoff: PASSED
[    2.897633] Testing tracer preemptoff: PASSED
[    2.899090] Testing tracer preemptirqsoff: PASSED
[    2.900304] Testing tracer branch: PASSED
[    3.031652] VFS: Disk quotas dquot_6.5.2
[    3.032660] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.042151] GFS2 installed
[    3.043200] alg: No test for cipher_null (cipher_null-generic)
[    3.044543] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    3.045852] alg: No test for digest_null (digest_null-generic)
[    3.047142] alg: No test for compress_null (compress_null-generic)
[    3.049071] cryptomgr_test (38) used greatest stack depth: 5776 bytes left
[    3.057952] cryptomgr_test (57) used greatest stack depth: 5712 bytes left
[    3.061098] alg: No test for stdrng (krng)
[    3.092432] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    3.094481] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    3.095858] io scheduler noop registered
[    3.096589] io scheduler deadline registered
[    3.097657] io scheduler cfq registered (default)
[    3.098523] start plist test
[    3.109530] end plist test
[    3.110057] list_sort_test: start testing list_sort()
[    3.143262] crc32: CRC_LE_BITS = 1, CRC_BE BITS = 1
[    3.144167] crc32: self tests passed, processed 225944 bytes in 17575657 nsec
[    3.158996] crc32c: CRC_LE_BITS = 1
[    3.159718] crc32c: self tests passed, processed 225944 bytes in 8883176 nsec
[    3.161231] XENFS: not registering filesystem on non-xen platform
[    3.249692] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.276253] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.280683] Non-volatile memory driver v1.3
[    3.281518] smapi::smapi_init, ERROR invalid usSmapiID
[    3.282456] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    3.284352] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    3.285643] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    3.286791] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    3.288356] Hangcheck: Using getrawmonotonic().
[    3.290692] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    3.291911] osst :I: Tape driver with OnStream support version 0.99.4
[    3.291911] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    3.296630] Rounding down aligned max_sectors from 4294967295 to 8388600
[    3.299579] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.301007] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.302681] mousedev: PS/2 mouse device common for all mice
[    3.305326] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    3.307748] mk712: device not present
[    3.309031] Driver for 1-wire Dallas network protocol.
[    3.310102] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.311376] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[    3.313256] applesmc: supported laptop not found!
[    3.314108] applesmc: driver init failed (ret=-19)!
[    3.315063] pc87360: PC8736x not detected, module not inserted
[    3.316140] acquirewdt: WDT driver for Acquire single board computer initialising
[    3.317788] acquirewdt: I/O address 0x0043 already in use
[    3.319587] acquirewdt: probe of acquirewdt failed with error -5
[    3.320775] sc1200wdt: build 20020303
[    3.321454] sc1200wdt: io parameter must be specified
[    3.322349] pc87413_wdt: Version 1.1 at io 0x2E
[    3.323593] pc87413_wdt: initialized. timeout=1 min
[    3.324536] pc87413_wdt: cannot request SWC region at 0xffff
[    3.326332] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
[    3.329073] smsc37b787_wdt: Timeout set to 60 second(s)
[    3.330019] smsc37b787_wdt: Watchdog initialized and sleeping (nowayout=0)...
[    3.331280] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
[    3.333277] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
[    3.334647] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
[    3.335858] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    3.336972] w83697hf_wdt: watchdog not found at address 0x2e
[    3.337999] w83697hf_wdt: No W83697HF/HG could be found
[    3.340350] w83877f_wdt: I/O address 0x03f0 already in use
[    3.341370] w83977f_wdt: driver v1.00
[    3.342050] w83977f_wdt: I/O address 0x03f0 already in use
[    3.343386] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[    3.344843] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[    3.346569] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[    3.348572] EDAC MC: Ver: 3.0.0
[    3.349742] cpuidle: using governor ladder
[    3.351281] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    3.352683] hdaps: supported laptop not found!
[    3.353735] hdaps: driver init failed (ret=-19)!
[    3.355486] 
[    3.355486] printing PIC contents
[    3.356365] ... PIC  IMR: fffb
[    3.356937] ... PIC  IRR: 1013
[    3.357522] ... PIC  ISR: 0000
[    3.358081] ... PIC ELCR: 0c00
[    3.359104] printing local APIC contents on CPU#0/0:
[    3.360016] ... APIC ID:      00000000 (0)
[    3.360782] ... APIC VERSION: 00050014
[    3.361495] ... APIC TASKPRI: 00000000 (00)
[    3.362255] ... APIC PROCPRI: 00000000
[    3.363173] ... APIC LDR: 01000000
[    3.363805] ... APIC DFR: ffffffff
[    3.364430] ... APIC SPIV: 000001ff
[    3.365062] ... APIC ISR field:
[    3.365666] 0000000000000000000000000000000000000000000000000000000000000000
[    3.367199] ... APIC TMR field:
[    3.367787] 0000000000000000000000000000000000000000000000000000000000000000
[    3.368682] ... APIC IRR field:
[    3.368682] 0000000000000000000000000000000000000000000000000000000000008000
[    3.368682] ... APIC ESR: 00000000
[    3.368682] ... APIC ICR: 00000831
[    3.368682] ... APIC ICR2: 01000000
[    3.368682] ... APIC LVTT: 000200ef
[    3.368682] ... APIC LVTPC: 00010000
[    3.368682] ... APIC LVT0: 00010700
[    3.368682] ... APIC LVT1: 00000400
[    3.368682] ... APIC LVTERR: 000000fe
[    3.368682] ... APIC TMICT: 0009898a
[    3.368682] ... APIC TMCCT: 0000f4cd
[    3.368682] ... APIC TDCR: 00000003
[    3.368682] 
[    3.380222] number of MP IRQ sources: 20.
[    3.380967] number of IO-APIC #2 registers: 24.
[    3.381798] testing the IO APIC.......................
[    3.382741] IO APIC #2......
[    3.383504] .... register #00: 00000000
[    3.384187] .......    : physical APIC id: 00
[    3.384974] .......    : Delivery Type: 0
[    3.385706] .......    : LTS          : 0
[    3.386422] .... register #01: 00170011
[    3.387140] .......     : max redirection entries: 17
[    3.388062] .......     : PRQ implemented: 0
[    3.389907] .......     : IO APIC version: 11
[    3.390711] .... register #02: 00000000
[    3.391415] .......     : arbitration: 00
[    3.392136] .... IRQ redirection table:
[    3.393067]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    3.394071]  00 00  1    0    0   0   0    0    0    00
[    3.395069]  01 01  0    0    0   0   0    1    1    31
[    3.396066]  02 01  0    0    0   0   0    1    1    30
[    3.397050]  03 01  0    0    0   0   0    1    1    33
[    3.398037]  04 01  1    0    0   0   0    1    1    34
[    3.399141]  05 01  0    0    0   0   0    1    1    35
[    3.400184]  06 01  0    0    0   0   0    1    1    36
[    3.401166]  07 01  0    0    0   0   0    1    1    37
[    3.402183]  08 01  0    0    0   0   0    1    1    38
[    3.403414]  09 01  1    1    0   0   0    1    1    41
[    3.404411]  0a 01  1    1    0   0   0    1    1    51
[    3.405392]  0b 01  1    1    0   0   0    1    1    61
[    3.406384]  0c 01  0    0    0   0   0    1    1    3C
[    3.407409]  0d 01  0    0    0   0   0    1    1    3D
[    3.408393]  0e 01  0    0    0   0   0    1    1    3E
[    3.409957]  0f 01  0    0    0   0   0    1    1    3F
[    3.410944]  10 00  1    0    0   0   0    0    0    00
[    3.411957]  11 00  1    0    0   0   0    0    0    00
[    3.413174]  12 00  1    0    0   0   0    0    0    00
[    3.414168]  13 00  1    0    0   0   0    0    0    00
[    3.415155]  14 00  1    0    0   0   0    0    0    00
[    3.416140]  15 00  1    0    0   0   0    0    0    00
[    3.417127]  16 00  1    0    0   0   0    0    0    00
[    3.418107]  17 00  1    0    0   0   0    0    0    00
[    3.420177] IRQ to pin mappings:
[    3.420796] IRQ0 -> 0:2
[    3.421313] IRQ1 -> 0:1
[    3.421848] IRQ3 -> 0:3
[    3.422367] IRQ4 -> 0:4
[    3.423125] IRQ5 -> 0:5
[    3.423665] IRQ6 -> 0:6
[    3.424182] IRQ7 -> 0:7
[    3.424708] IRQ8 -> 0:8
[    3.425221] IRQ12 -> 0:12
[    3.425778] IRQ13 -> 0:13
[    3.426318] IRQ14 -> 0:14
[    3.426873] IRQ15 -> 0:15
[    3.427420] IRQ33 -> 0:9
[    3.427951] IRQ34 -> 0:10
[    3.428506] IRQ35 -> 0:11
[    3.429197] .................................... done.
[    3.430858] Running tests on trace events:
[    3.431625] Testing event kfree_skb: OK
[    3.449835] Testing event consume_skb: OK
[    3.469903] Testing event skb_copy_datagram_iovec: OK
[    3.490418] Testing event net_dev_xmit: OK
[    3.509379] Testing event net_dev_queue: OK
[    3.529332] Testing event netif_receive_skb: OK
[    3.549327] Testing event netif_rx: OK
[    3.570857] Testing event napi_poll: OK
[    3.589449] Testing event sock_rcvqueue_full: OK
[    3.609352] Testing event sock_exceed_buf_limit: OK
[    3.629349] Testing event udp_fail_queue_rcv_skb: OK
[    3.649541] Testing event mc_event: OK
[    3.669558] Testing event scsi_dispatch_cmd_start: OK
[    3.690663] Testing event scsi_dispatch_cmd_error: OK
[    3.709329] Testing event scsi_dispatch_cmd_done: OK
[    3.729989] Testing event scsi_dispatch_cmd_timeout: OK
[    3.749352] Testing event scsi_eh_wakeup: OK
[    3.770129] Testing event mix_pool_bytes: OK
[    3.790214] Testing event mix_pool_bytes_nolock: OK
[    3.809347] Testing event credit_entropy_bits: OK
[    3.829343] Testing event get_random_bytes: OK
[    3.849347] Testing event extract_entropy: OK
[    3.871349] Testing event extract_entropy_user: OK
[    3.889462] Testing event gpio_direction: OK
[    3.910046] Testing event gpio_value: OK
[    3.930319] Testing event block_rq_abort: OK
[    3.950508] Testing event block_rq_requeue: OK
[    3.970205] Testing event block_rq_complete: OK
[    3.989765] Testing event block_rq_insert: OK
[    4.009987] Testing event block_rq_issue: OK
[    4.030989] Testing event block_bio_bounce: OK
[    4.050472] Testing event block_bio_complete: OK
[    4.069451] Testing event block_bio_backmerge: OK
[    4.089815] Testing event block_bio_frontmerge: OK
[    4.110743] Testing event block_bio_queue: OK
[    4.130084] Testing event block_getrq: OK
[    4.149914] Testing event block_sleeprq: OK
[    4.169880] Testing event block_plug: OK
[    4.190389] Testing event block_unplug: OK
[    4.210079] Testing event block_split: OK
[    4.230061] Testing event block_bio_remap: OK
[    4.249951] Testing event block_rq_remap: OK
[    4.270407] Testing event gfs2_glock_state_change: OK
[    4.290625] Testing event gfs2_glock_put: OK
[    4.309876] Testing event gfs2_demote_rq: OK
[    4.329758] Testing event gfs2_promote: OK
[    4.350402] Testing event gfs2_glock_queue: OK
[    4.370133] Testing event gfs2_glock_lock_time: OK
[    4.389698] Testing event gfs2_pin: OK
[    4.410275] Testing event gfs2_log_flush: OK
[    4.430554] Testing event gfs2_log_blocks: OK
[    4.450063] Testing event gfs2_ail_flush: OK
[    4.470520] Testing event gfs2_bmap: OK
[    4.489995] Testing event gfs2_block_alloc: OK
[    4.510775] Testing event gfs2_rs: OK
[    4.530233] Testing event jbd2_checkpoint: OK
[    4.549926] Testing event jbd2_start_commit: OK
[    4.570637] Testing event jbd2_commit_locking: OK
[    4.590804] Testing event jbd2_commit_flushing: OK
[    4.610722] Testing event jbd2_commit_logging: OK
[    4.630349] Testing event jbd2_drop_transaction: OK
[    4.649923] Testing event jbd2_end_commit: OK
[    4.670100] Testing event jbd2_submit_inode_data: OK
[    4.689947] Testing event jbd2_run_stats: OK
[    4.710219] Testing event jbd2_checkpoint_stats: OK
[    4.730086] Testing event jbd2_update_log_tail: OK
[    4.750215] Testing event jbd2_write_superblock: OK
[    4.770341] Testing event ext4_free_inode: OK
[    4.789640] Testing event ext4_request_inode: OK
[    4.810484] Testing event ext4_allocate_inode: OK
[    4.829597] Testing event ext4_evict_inode: OK
[    4.852133] Testing event ext4_drop_inode: OK
[    4.870175] Testing event ext4_mark_inode_dirty: OK
[    4.890405] Testing event ext4_begin_ordered_truncate: OK
[    4.910787] Testing event ext4_write_begin: OK
[    4.929915] Testing event ext4_da_write_begin: OK
[    4.951003] Testing event ext4_ordered_write_end: OK
[    4.969475] Testing event ext4_writeback_write_end: OK
[    4.990156] Testing event ext4_journalled_write_end: OK
[    5.010062] Testing event ext4_da_write_end: OK
[    5.031704] Testing event ext4_da_writepages: OK
[    5.050645] Testing event ext4_da_write_pages: OK
[    5.069691] Testing event ext4_da_writepages_result: OK
[    5.089976] Testing event ext4_writepage: OK
[    5.109497] Testing event ext4_readpage: OK
[    5.130860] Testing event ext4_releasepage: OK
[    5.149731] Testing event ext4_invalidatepage: OK
[    5.171415] Testing event ext4_discard_blocks: OK
[    5.190061] Testing event ext4_mb_new_inode_pa: OK
[    5.210085] Testing event ext4_mb_new_group_pa: OK
[    5.230205] Testing event ext4_mb_release_inode_pa: OK
[    5.250633] Testing event ext4_mb_release_group_pa: OK
[    5.270098] Testing event ext4_discard_preallocations: OK
[    5.290416] Testing event ext4_mb_discard_preallocations: OK
[    5.310774] Testing event ext4_request_blocks: OK
[    5.330803] Testing event ext4_allocate_blocks: OK
[    5.350724] Testing event ext4_free_blocks: OK
[    5.369633] Testing event ext4_sync_file_enter: OK
[    5.389909] Testing event ext4_sync_file_exit: OK
[    5.410825] Testing event ext4_sync_fs: OK
[    5.431345] Testing event ext4_alloc_da_blocks: OK
[    5.450127] Testing event ext4_mballoc_alloc: OK
[    5.470178] Testing event ext4_mballoc_prealloc: OK
[    5.489941] Testing event ext4_mballoc_discard: OK
[    5.510188] Testing event ext4_mballoc_free: OK
[    5.531486] Testing event ext4_forget: OK
[    5.559731] Testing event ext4_da_update_reserve_space: OK
[    5.590258] Testing event ext4_da_reserve_space: OK
[    5.610391] Testing event ext4_da_release_space: OK
[    5.630490] Testing event ext4_mb_bitmap_load: OK
[    5.650140] Testing event ext4_mb_buddy_bitmap_load: OK
[    5.670742] Testing event ext4_read_block_bitmap_load: OK
[    5.690451] Testing event ext4_load_inode_bitmap: OK
[    5.710090] Testing event ext4_direct_IO_enter: OK
[    5.731503] Testing event ext4_direct_IO_exit: OK
[    5.751162] Testing event ext4_fallocate_enter: OK
[    5.770374] Testing event ext4_fallocate_exit: OK
[    5.789908] Testing event ext4_unlink_enter: OK
[    5.809869] Testing event ext4_unlink_exit: OK
[    5.831291] Testing event ext4_truncate_enter: OK
[    5.850052] Testing event ext4_truncate_exit: OK
[    5.869964] Testing event ext4_ext_convert_to_initialized_enter: OK
[    5.890179] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[    5.909943] Testing event ext4_ext_map_blocks_enter: OK
[    5.929946] Testing event ext4_ind_map_blocks_enter: OK
[    5.949897] Testing event ext4_ext_map_blocks_exit: OK
[    5.970027] Testing event ext4_ind_map_blocks_exit: OK
[    5.990126] Testing event ext4_ext_load_extent: OK
[    6.010399] Testing event ext4_load_inode: OK
[    6.029559] Testing event ext4_journal_start: OK
[    6.049768] Testing event ext4_trim_extent: OK
[    6.070328] Testing event ext4_trim_all_free: OK
[    6.089850] Testing event ext4_ext_handle_uninitialized_extents: OK
[    6.110206] Testing event ext4_get_implied_cluster_alloc_exit: OK
[    6.130230] Testing event ext4_ext_put_in_cache: OK
[    6.150321] Testing event ext4_ext_in_cache: OK
[    6.170543] Testing event ext4_find_delalloc_range: OK
[    6.190525] Testing event ext4_get_reserved_cluster_alloc: OK
[    6.209885] Testing event ext4_ext_show_extent: OK
[    6.229887] Testing event ext4_remove_blocks: OK
[    6.250431] Testing event ext4_ext_rm_leaf: OK
[    6.270030] Testing event ext4_ext_rm_idx: OK
[    6.290243] Testing event ext4_ext_remove_space: OK
[    6.310977] Testing event ext4_ext_remove_space_done: OK
[    6.331234] Testing event writeback_nothread: OK
[    6.349761] Testing event writeback_queue: OK
[    6.370531] Testing event writeback_exec: OK
[    6.390040] Testing event writeback_start: OK
[    6.409775] Testing event writeback_written: OK
[    6.430939] Testing event writeback_wait: OK
[    6.451039] Testing event writeback_pages_written: OK
[    6.469668] Testing event writeback_nowork: OK
[    6.489831] Testing event writeback_wake_background: OK
[    6.509989] Testing event writeback_wake_thread: OK
[    6.530205] Testing event writeback_wake_forker_thread: OK
[    6.550492] Testing event writeback_bdi_register: OK
[    6.569557] Testing event writeback_bdi_unregister: OK
[    6.591563] Testing event writeback_thread_start: OK
[    6.610422] Testing event writeback_thread_stop: OK
[    6.631273] Testing event wbc_writepage: OK
[    6.650353] Testing event writeback_queue_io: OK
[    6.670299] Testing event global_dirty_state: OK
[    6.689778] Testing event bdi_dirty_ratelimit: OK
[    6.710713] Testing event balance_dirty_pages: OK
[    6.731622] Testing event writeback_sb_inodes_requeue: OK
[    6.750332] Testing event writeback_congestion_wait: OK
[    6.769870] Testing event writeback_wait_iff_congested: OK
[    6.790066] Testing event writeback_single_inode: OK
[    6.810315] Testing event mm_compaction_isolate_migratepages: OK
[    6.830044] Testing event mm_compaction_isolate_freepages: OK
[    6.850006] Testing event mm_compaction_migratepages: OK
[    6.870712] Testing event kmalloc: OK
[    6.889846] Testing event kmem_cache_alloc: OK
[    6.910212] Testing event kmalloc_node: OK
[    6.931299] Testing event kmem_cache_alloc_node: OK
[    6.949814] Testing event kfree: OK
[    6.970538] Testing event kmem_cache_free: OK
[    6.990070] Testing event mm_page_free: OK
[    7.010000] Testing event mm_page_free_batched: OK
[    7.029743] Testing event mm_page_alloc: OK
[    7.050510] Testing event mm_page_alloc_zone_locked: OK
[    7.070711] Testing event mm_page_pcpu_drain: OK
[    7.089807] Testing event mm_page_alloc_extfrag: OK
[    7.109832] Testing event mm_vmscan_kswapd_sleep: OK
[    7.130451] Testing event mm_vmscan_kswapd_wake: OK
[    7.150626] Testing event mm_vmscan_wakeup_kswapd: OK
[    7.170538] Testing event mm_vmscan_direct_reclaim_begin: OK
[    7.190140] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    7.211759] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    7.230217] Testing event mm_vmscan_direct_reclaim_end: OK
[    7.250157] Testing event mm_vmscan_memcg_reclaim_end: OK
[    7.270461] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    7.290129] Testing event mm_shrink_slab_start: OK
[    7.310215] Testing event mm_shrink_slab_end: OK
[    7.329713] Testing event mm_vmscan_lru_isolate: OK
[    7.350612] Testing event mm_vmscan_memcg_isolate: OK
[    7.371444] Testing event mm_vmscan_writepage: OK
[    7.389841] Testing event mm_vmscan_lru_shrink_inactive: OK
[    7.410053] Testing event oom_score_adj_update: OK
[    7.430057] Testing event rpm_suspend: OK
[    7.450567] Testing event rpm_resume: OK
[    7.470214] Testing event rpm_idle: OK
[    7.491224] Testing event rpm_return_int: OK
[    7.511365] Testing event cpu_idle: OK
[    7.530281] Testing event cpu_frequency: OK
[    7.552410] Testing event machine_suspend: OK
[    7.570031] Testing event wakeup_source_activate: OK
[    7.590784] Testing event wakeup_source_deactivate: OK
[    7.610560] Testing event power_start: OK
[    7.630558] Testing event power_frequency: OK
[    7.652528] Testing event power_end: OK
[    7.670807] Testing event clock_enable: OK
[    7.689985] Testing event clock_disable: OK
[    7.710519] Testing event clock_set_rate: OK
[    7.730577] Testing event power_domain_target: OK
[    7.749840] Testing event ftrace_test_filter: OK
[    7.771285] Testing event lock_acquire: OK
[    7.790447] Testing event lock_release: OK
[    7.810812] Testing event lock_contended: OK
[    7.831268] Testing event lock_acquired: OK
[    7.851069] Testing event sched_kthread_stop: OK
[    7.870645] Testing event sched_kthread_stop_ret: OK
[    7.889857] Testing event sched_wakeup: OK
[    7.911697] Testing event sched_wakeup_new: OK
[    7.929678] Testing event sched_switch: OK
[    7.949671] Testing event sched_migrate_task: OK
[    7.969598] Testing event sched_process_free: OK
[    7.989594] Testing event sched_process_exit: OK
[    8.009609] Testing event sched_wait_task: OK
[    8.029588] Testing event sched_process_wait: OK
[    8.049594] Testing event sched_process_fork: OK
[    8.069601] Testing event sched_process_exec: OK
[    8.089600] Testing event sched_stat_wait: OK
[    8.109591] Testing event sched_stat_sleep: OK
[    8.129594] Testing event sched_stat_iowait: OK
[    8.149596] Testing event sched_stat_blocked: OK
[    8.169596] Testing event sched_stat_runtime: OK
[    8.189619] Testing event sched_pi_setprio: OK
[    8.209612] Testing event rcu_utilization: OK
[    8.229599] Testing event workqueue_queue_work: OK
[    8.249608] Testing event workqueue_activate_work: OK
[    8.269619] Testing event workqueue_execute_start: OK
[    8.289624] Testing event workqueue_execute_end: OK
[    8.309620] Testing event signal_generate: OK
[    8.329621] Testing event signal_deliver: OK
[    8.349624] Testing event timer_init: OK
[    8.369635] Testing event timer_start: OK
[    8.389671] Testing event timer_expire_entry: OK
[    8.409643] Testing event timer_expire_exit: OK
[    8.429645] Testing event timer_cancel: OK
[    8.449653] Testing event hrtimer_init: OK
[    8.469633] Testing event hrtimer_start: OK
[    8.489635] Testing event hrtimer_expire_entry: OK
[    8.509639] Testing event hrtimer_expire_exit: OK
[    8.529635] Testing event hrtimer_cancel: OK
[    8.549653] Testing event itimer_state: OK
[    8.569647] Testing event itimer_expire: OK
[    8.589650] Testing event irq_handler_entry: OK
[    8.609652] Testing event irq_handler_exit: OK
[    8.629652] Testing event softirq_entry: OK
[    8.649648] Testing event softirq_exit: OK
[    8.669623] Testing event softirq_raise: OK
[    8.689807] Testing event console: OK
[    8.709763] Testing event task_newtask: OK
[    8.729798] Testing event task_rename: OK
[    8.749617] Testing event mce_record: OK
[    8.769616] Testing event sys_enter: OK
[    8.789638] Testing event sys_exit: OK
[    8.809632] Testing event emulate_vsyscall: OK
[    8.829625] Testing event xen_mc_batch: OK
[    8.849778] Testing event xen_mc_issue: OK
[    8.869730] Testing event xen_mc_entry: OK
[    8.889737] Testing event xen_mc_entry_alloc: OK
[    8.909633] Testing event xen_mc_callback: OK
[    8.929629] Testing event xen_mc_flush_reason: OK
[    8.949640] Testing event xen_mc_flush: OK
[    8.969632] Testing event xen_mc_extend_args: OK
[    8.989657] Testing event xen_mmu_set_pte: OK
[    9.009653] Testing event xen_mmu_set_pte_atomic: OK
[    9.029638] Testing event xen_mmu_set_domain_pte: OK
[    9.049637] Testing event xen_mmu_set_pte_at: OK
[    9.069640] Testing event xen_mmu_pte_clear: OK
[    9.089636] Testing event xen_mmu_set_pmd: OK
[    9.110902] Testing event xen_mmu_pmd_clear: OK
[    9.129607] Testing event xen_mmu_set_pud: OK
[    9.149632] Testing event xen_mmu_set_pgd: OK
[    9.169629] Testing event xen_mmu_pud_clear: OK
[    9.189626] Testing event xen_mmu_pgd_clear: OK
[    9.209622] Testing event xen_mmu_ptep_modify_prot_start: OK
[    9.229655] Testing event xen_mmu_ptep_modify_prot_commit: OK
[    9.249636] Testing event xen_mmu_alloc_ptpage: OK
[    9.269651] Testing event xen_mmu_release_ptpage: OK
[    9.289654] Testing event xen_mmu_pgd_pin: OK
[    9.309641] Testing event xen_mmu_pgd_unpin: OK
[    9.329641] Testing event xen_mmu_flush_tlb: OK
[    9.349645] Testing event xen_mmu_flush_tlb_single: OK
[    9.369644] Testing event xen_mmu_flush_tlb_others: OK
[    9.389647] Testing event xen_mmu_write_cr3: OK
[    9.409644] Testing event xen_cpu_write_ldt_entry: OK
[    9.429647] Testing event xen_cpu_write_idt_entry: OK
[    9.449645] Testing event xen_cpu_load_idt: OK
[    9.469647] Testing event xen_cpu_write_gdt_entry: OK
[    9.489661] Testing event xen_cpu_set_ldt: OK
[    9.509652] Running tests on trace event systems:
[    9.510537] Testing event system skb: OK
[    9.529923] Testing event system net: OK
[    9.549936] Testing event system napi: OK
[    9.569742] Testing event system sock: OK
[    9.589808] Testing event system udp: OK
[    9.609733] Testing event system ras: OK
[    9.629744] Testing event system scsi: OK
[    9.650000] Testing event system random: OK
[    9.670063] Testing event system gpio: OK
[    9.689869] Testing event system block: OK
[    9.710875] Testing event system gfs2: OK
[    9.730732] Testing event system jbd2: OK
[    9.750563] Testing event system ext4: OK
[    9.773841] Testing event system writeback: OK
[    9.790637] Testing event system compaction: OK
[    9.809573] Testing event system kmem: OK
[    9.830561] Testing event system vmscan: OK
[    9.850882] Testing event system oom: OK
[    9.869844] Testing event system rpm: OK
[    9.889926] Testing event system power: OK
[    9.910637] Testing event system test: OK
[    9.929822] Testing event system lock: OK
[    9.950226] Testing event system sched: OK
[    9.970826] Testing event system rcu: OK
[    9.989842] Testing event system workqueue: OK
[   10.010044] Testing event system signal: OK
[   10.029854] Testing event system timer: OK
[   10.050658] Testing event system irq: OK
[   10.070156] Testing event system printk: OK
[   10.089759] Testing event system task: OK
[   10.109827] Testing event system mce: OK
[   10.129715] Testing event system raw_syscalls: OK
[   10.149780] Testing event system vsyscall: OK
[   10.169701] Testing event system syscalls: OK
[   10.192641] Testing event system xen: OK
[   10.212707] Running tests on all trace events:
[   10.213633] Testing all events: OK
[   10.337077] Testing ftrace filter: OK
[   10.342209]   Magic number: 8:880:562
[   10.342681] tty ptya8: hash matches
[   10.347120] Freeing unused kernel memory: 580k freed
[   10.348175] Write protecting the kernel read-only data: 16384k
[   10.367984] Freeing unused kernel memory: 1940k freed
[   10.383805] Freeing unused kernel memory: 1620k freed
[   10.411493] hostname (409) used greatest stack depth: 5416 bytes left
[   10.445188] mount (410) used greatest stack depth: 5344 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   13.889219] ------------[ cut here ]------------
[   13.889945] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3493 check_flags+0x131/0x320()
[   13.891200] Pid: 8, comm: rcu_kthread Not tainted 3.6.0-rc1-00002-g0c8f7ca #617
[   13.892531] Call Trace:
[   13.893008]  [<ffffffff8112de21>] ? check_flags+0x131/0x320
[   13.894050]  [<ffffffff8109c78d>] warn_slowpath_common+0xad/0xf0
[   13.895166]  [<ffffffff8109c8f5>] warn_slowpath_null+0x25/0x30
[   13.896241]  [<ffffffff8112de21>] check_flags+0x131/0x320
[   13.897266]  [<ffffffff8112fd10>] lock_is_held+0x70/0x140
[   13.898327]  [<ffffffff8110eb9b>] __might_sleep+0x5b/0x3a0
[   13.899165]  [<ffffffff8180ded7>] rt_mutex_lock+0x27/0x50
[   13.899165]  [<ffffffff811573f4>] rcu_boost+0x144/0x270
[   13.899165]  [<ffffffff810f03ad>] ? finish_wait+0x8d/0xd0
[   13.899165]  [<ffffffff8180ee37>] ? _raw_spin_unlock_irqrestore+0x107/0x150
[   13.899165]  [<ffffffff810f03ad>] ? finish_wait+0x8d/0xd0
[   13.899165]  [<ffffffff8115791d>] rcu_kthread+0x15d/0x2c0
[   13.899165]  [<ffffffff810f0510>] ? abort_exclusive_wait+0x120/0x120
[   13.899165]  [<ffffffff811577c0>] ? __rcu_process_callbacks+0x2a0/0x2a0
[   13.899165]  [<ffffffff811577c0>] ? __rcu_process_callbacks+0x2a0/0x2a0
[   13.899165]  [<ffffffff810ee89f>] kthread+0xef/0x100
[   13.899165]  [<ffffffff81812004>] kernel_thread_helper+0x4/0x10
[   13.899165]  [<ffffffff81810870>] ? retint_restore_args+0x13/0x13
[   13.899165]  [<ffffffff810ee7b0>] ? insert_kthread_work+0x1a0/0x1a0
[   13.899165]  [<ffffffff81812000>] ? gs_change+0x13/0x13
[   13.899165] ---[ end trace c622fe724ee61da2 ]---
[   13.899165] possible reason: unannotated irqs-on.
[   13.899165] irq event stamp: 276676
[   13.899165] hardirqs last  enabled at (276675): [<ffffffff8180edd5>] _raw_spin_unlock_irqrestore+0xa5/0x150
[   13.899165] hardirqs last disabled at (276676): [<ffffffff81132960>] debug_check_no_locks_freed+0x80/0x2b0
[   13.899165] softirqs last  enabled at (276654): [<ffffffff8115779e>] __rcu_process_callbacks+0x27e/0x2a0
[   13.899165] softirqs last disabled at (276644): [<ffffffff81157722>] __rcu_process_callbacks+0x202/0x2a0

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc1-00002-g0c8f7ca"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.6.0-rc1 Kernel Configuration
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
# CONFIG_GENERIC_ISA_DMA is not set
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
# CONFIG_ARCH_MAY_HAVE_PC_FDC is not set
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_BROKEN_ON_SMP=y
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
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_FHANDLE=y
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# RCU Subsystem
#
CONFIG_TINY_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_HOTPLUG is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

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
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_XEN=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
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
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#

#
# Bus options (PCI etc.)
#
# CONFIG_PCI is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
# CONFIG_ISA_DMA_API is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_PHONET is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
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
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_VMWARE_BALLOON is not set

#
# EEPROM support
#
# CONFIG_EEPROM_93CX6 is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set

#
# Altera FPGA firmware download module
#
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_XILINX_PS_UART=y
CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
# CONFIG_HVC_XEN is not set
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#

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
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y

#
# I2C GPIO expanders:
#

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_XEN_WDT is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
CONFIG_ABX500_CORE=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set
# CONFIG_USB_ARCH_HAS_OHCI is not set
# CONFIG_USB_ARCH_HAS_EHCI is not set
# CONFIG_USB_ARCH_HAS_XHCI is not set
CONFIG_USB_SUPPORT=y
# CONFIG_USB_ARCH_HAS_HCD is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_TIMB_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_BALLOON=y

#
# Microsoft Hyper-V guest support
#

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XENFS=y
# CONFIG_XEN_COMPAT_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=y
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_XEN_PRIVCMD=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_SENSORS_HDAPS=y
# CONFIG_SAMSUNG_Q10 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
# CONFIG_IIO_BUFFER is not set
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Analog to digital converters
#

#
# Amplifiers
#

#
# Light sensors
#

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital to analog converters
#
# CONFIG_PWM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

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
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
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
# CONFIG_FUNCTION_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
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
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y

--IS0zKkzwUGydFO0o--

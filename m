Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab2GMIqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:46:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:59432 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517Ab2GMIqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:46:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121904416"
Date: Fri, 13 Jul 2012 16:46:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: show_uevent() and general protection fault
Message-ID: <20120713084616.GA20037@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20120713083140.GA19738@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is another kconfig, produced a bit different call trace, however
also related to sysfs_read_file().

[   14.619411] warning: process `trinity-child0' used the deprecated sysctl system call with 
[   32.792672] trinity-child0 (129): Using mlock ulimits for SHM_HUGETLB is deprecated
[   55.093218] BUG: unable to handle kernel paging request at 00007f4fa44392a0
[   55.093948] IP: [<ffffffff81456703>] strnlen+0x23/0x80
[   55.093948] PGD 0 
[   55.093948] Oops: 0000 [#1] 
[   55.093948] CPU 0 
[   55.093948] Pid: 145, comm: trinity-child0 Not tainted 3.5.0-rc1+ #4 Bochs Bochs
[   55.093948] RIP: 0010:[<ffffffff81456703>]  [<ffffffff81456703>] strnlen+0x23/0x80
[   55.093948] RSP: 0018:ffff88000ed65d38  EFLAGS: 00010206
[   55.093948] RAX: ffff88000ed65e38 RBX: ffff88000edb2000 RCX: 000000000000c0e4
[   55.093948] RDX: 00007f4fa44392a0 RSI: ffffffffffffffff RDI: 00007f4fa44392a0
[   55.093948] RBP: ffff88000ed65d38 R08: 000000000000ffff R09: 000000000000ffff
[   55.093948] R10: 0000000000000000 R11: ffff88000ed58560 R12: 00007f4fa44392a0
[   55.093948] R13: ffff88008edb1fff R14: 000000000000ffff R15: 0000000000000000
[   55.093948] FS:  00007ffb40b54700(0000) GS:ffffffff821b7000(0000) knlGS:0000000000000000
[   55.093948] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   55.093948] CR2: 00007f4fa44392a0 CR3: 000000000ed59000 CR4: 00000000000006b0
[   55.093948] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   55.093948] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   55.093948] Process trinity-child0 (pid: 145, threadinfo ffff88000ed64000, task ffff88000ed58000)
[   55.093948] Stack:
[   55.093948]  ffff88000ed65d78 ffffffff814587fc ffffffff821e9960 ffffffff82142ce5
[   55.093948]  ffff88008edb1fff ffff88000ed65e10 ffffffff82142ce5 ffff88000edb2000
[   55.093948]  ffff88000ed65df8 ffffffff81459763 ffff88000ed65da8 ffff88000ed58000
[   55.093948] Call Trace:
[   55.093948]  [<ffffffff814587fc>] string.isra.4+0x4c/0x120
[   55.093948]  [<ffffffff81459763>] vsnprintf+0x313/0x890
[   55.093948]  [<ffffffff810c0a3a>] ? param_attr_show+0x3a/0xb0
[   55.093948]  [<ffffffff8145a248>] sprintf+0x48/0x50
[   55.093948]  [<ffffffff810c0c41>] param_get_charp+0x21/0x30
[   55.093948]  [<ffffffff810c0a50>] param_attr_show+0x50/0xb0
[   55.093948]  [<ffffffff810c0778>] module_attr_show+0x28/0x40
[   55.093948]  [<ffffffff811d5300>] sysfs_read_file+0x120/0x280
[   55.093948]  [<ffffffff81163b4f>] vfs_read+0xff/0x210
[   55.093948]  [<ffffffff8116401d>] sys_read+0x5d/0xc0
[   55.093948]  [<ffffffff81bd2177>] system_call_fastpath+0x16/0x1b
[   55.093948] Code: 5d c3 66 0f 1f 44 00 00 55 48 83 05 b7 ea b2 01 01 48 85 f6 48 89 e5 74 58 48 8b 0d b0 ea b2 01 48 83 c1 01 48 89 0d a5 ea b2 01 <80> 3f 00 74 41 48 8b 05 a1 ea b2 01 48 8d 50 01 48 01 c6 48 89 
[   55.093948] RIP  [<ffffffff81456703>] strnlen+0x23/0x80
[   55.093948]  RSP <ffff88000ed65d38>
[   55.093948] CR2: 00007f4fa44392a0

Thanks,
Fengguang

--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm-bens-3448-2012-07-12-04-59-30

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc1+ (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #4 Thu Jul 12 04:53:10 CST 2012
[    0.000000] Command line: trinity=10m tree=scsi:for-next auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-07-12-04-53-40-block-scsi.for-next-b90d6e7-ff1ff9d-x86_64-randconfig-block9-1-bens BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-block9/ff1ff9dbf6f124d0154457a3a8f604e821f801be/vmlinuz-3.5.0-rc1+
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffcfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffd000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffbc000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffd max_arch_pfn = 0x400000000
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
[    0.000000] early log buf free: 128372(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] kvm-clock: Using msrs 12 and 11
[    0.000000] kvm-clock: cpu 0, msr 0:21c73c1, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffcfff]
[    0.000000] On node 0 totalpages: 65420
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 60597 pages, LIFO batch:15
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
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64518
[    0.000000] Kernel command line: trinity=10m tree=scsi:for-next auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-07-12-04-53-40-block-scsi.for-next-b90d6e7-ff1ff9d-x86_64-randconfig-block9-1-bens BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-block9/ff1ff9dbf6f124d0154457a3a8f604e821f801be/vmlinuz-3.5.0-rc1+
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 190396k/262132k available (12111k kernel code, 452k absent, 71284k reserved, 10239k data, 1024k init)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] Detected 2666.366 MHz processor.
[    0.002999] Calibrating delay loop (skipped) preset value.. 5332.73 BogoMIPS (lpj=2666366)
[    0.004007] pid_max: default: 4096 minimum: 301
[    0.006054] Security Framework initialized
[    0.007041] Yama: becoming mindful.
[    0.008030] Mount-cache hash table entries: 256
[    0.010339] Initializing cgroup subsys debug
[    0.011009] Initializing cgroup subsys cpuacct
[    0.012007] Initializing cgroup subsys devices
[    0.014014] Initializing cgroup subsys freezer
[    0.015008] Initializing cgroup subsys net_prio
[    0.016133] CPU: GenuineIntel Common KVM processor stepping 01
[    0.026913] Performance Events: Getting VERSION: 50014
[    0.028015] Getting VERSION: 50014
[    0.029014] Getting ID: 0
[    0.030014] Getting ID: ff000000
[    0.031014] Getting LVT0: 8700
[    0.032010] Getting LVT1: 8400
[    0.033165] enabled ExtINT on CPU#0
[    0.036251] ENABLING IO-APIC IRQs
[    0.037010] init IO_APIC IRQs
[    0.038005]  apic 2 pin 0 not connected
[    0.039021] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.041034] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.043034] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.046028] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.048027] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.051027] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.053027] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.055026] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.058035] IOAPIC[0]: Set routing entry (2-9 -> 0x29 -> IRQ 33 Mode:1 Active:0 Dest:1)
[    0.060024] IOAPIC[0]: Set routing entry (2-10 -> 0x41 -> IRQ 34 Mode:1 Active:0 Dest:1)
[    0.063025] IOAPIC[0]: Set routing entry (2-11 -> 0x49 -> IRQ 35 Mode:1 Active:0 Dest:1)
[    0.065022] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.067026] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.070026] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.072023] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.075022]  apic 2 pin 16 not connected
[    0.075996]  apic 2 pin 17 not connected
[    0.076996]  apic 2 pin 18 not connected
[    0.077996]  apic 2 pin 19 not connected
[    0.078996]  apic 2 pin 20 not connected
[    0.080996]  apic 2 pin 21 not connected
[    0.081996]  apic 2 pin 22 not connected
[    0.082996]  apic 2 pin 23 not connected
[    0.084171] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.084996] Using local APIC timer interrupts.
[    0.084996] calibrating APIC timer ...
[    0.086992] ... lapic delta = 6121701
[    0.086992] ..... delta 6121701
[    0.086992] ..... mult: 262965026
[    0.086992] ..... calibration result: 979472
[    0.086992] ..... CPU clock speed is 2611.0926 MHz.
[    0.086992] ..... host bus clock speed is 979.0472 MHz.
[    0.086992] ... verify APIC timer
[    0.196446] ... jiffies delta = 98
[    0.196981] ... jiffies result ok
[    0.198391] initlevel:0=early, 3 registered initcalls
[    0.200425] initlevel:1=core, 19 registered initcalls
[    0.203154] NET: Registered protocol family 16
[    0.204012] initlevel:2=postcore, 14 registered initcalls
[    0.207475] i2c-core: driver [dummy] registered
[    0.208986] initlevel:3=arch, 6 registered initcalls
[    0.211546] PCI: Using configuration type 1 for base access
[    0.212991] initlevel:4=subsys, 71 registered initcalls
[    0.219822] bio: create slab <bio-0> at 0
[    0.221148] i2c-core: driver [mcp230xx] registered
[    0.222986] i2c-core: driver [pca953x] registered
[    0.224984] i2c-core: driver [pcf857x] registered
[    0.225998] i2c-core: driver [sx150x] registered
[    0.228074] vgaarb: loaded
[    0.229038] i2c-core: driver [wm831x] registered
[    0.230997] i2c-core: driver [wm8350] registered
[    0.232977] tps65010: version 2 May 2005
[    0.233982] i2c-core: driver [tps65010] registered
[    0.235996] i2c-core: driver [tps65010] unregistered
[    0.248988] i2c-core: driver [tps65010] registered
[    0.249981] i2c-core: driver [tps65010] unregistered
[    0.262982] i2c-core: driver [tps65010] registered
[    0.263979] i2c-core: driver [tps65010] unregistered
[    0.265981] tps65010: no chip?
[    0.266985] i2c-core: driver [tps65910] registered
[    0.268984] i2c-core: driver [tps65912] registered
[    0.270989] i2c-core: driver [mc13xxx] registered
[    0.272989] i2c-core: driver [da903x] registered
[    0.274990] i2c-core: driver [da9052] registered
[    0.275983] i2c-core: driver [max8997] registered
[    0.277977] i2c-core: driver [max8998] registered
[    0.279982] i2c-core: driver [ab3100] registered
[    0.281983] i2c-core: driver [rc5t583] registered
[    0.282982] i2c-core: driver [lm3533] registered
[    0.285164] SCSI subsystem initialized
[    0.287013] libata version 3.00 loaded.
[    0.288975] usbcore: registered new interface driver usbfs
[    0.290991] usbcore: registered new interface driver hub
[    0.293006] usbcore: registered new device driver usb
[    0.295084] PCI: Probing PCI hardware
[    0.295981] PCI: root bus 00: using default resources
[    0.297968] PCI: Probing PCI hardware (bus 00)
[    0.300030] PCI host bridge to bus 0000:00
[    0.300971] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.302968] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    0.305072] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.307662] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.310202] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.313127] pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
[    0.315406] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.318696] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.319984] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.322280] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.328106] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
[    0.334078] pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
[    0.353007] pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ffff pref]
[    0.355992] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.358180] pci 0000:00:03.0: reg 10: [mem 0xf2020000-0xf203ffff]
[    0.361039] pci 0000:00:03.0: reg 14: [io  0xc040-0xc07f]
[    0.363612] pci 0000:00:03.0: reg 30: [mem 0xf2040000-0xf2047fff pref]
[    0.365314] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.368054] pci 0000:00:04.0: reg 10: [io  0xc080-0xc0bf]
[    0.370086] pci 0000:00:04.0: reg 14: [mem 0xf2048000-0xf2048fff]
[    0.373709] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.375192] pci 0000:00:05.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.377089] pci 0000:00:05.0: reg 14: [mem 0xf2049000-0xf2049fff]
[    0.381074] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.383195] pci 0000:00:06.0: reg 10: [io  0xc100-0xc13f]
[    0.385080] pci 0000:00:06.0: reg 14: [mem 0xf204a000-0xf204afff]
[    0.388307] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.390180] pci 0000:00:07.0: reg 10: [io  0xc140-0xc17f]
[    0.392978] pci 0000:00:07.0: reg 14: [mem 0xf204b000-0xf204bfff]
[    0.396460] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.398978] pci 0000:00:08.0: reg 10: [io  0xc180-0xc1bf]
[    0.401076] pci 0000:00:08.0: reg 14: [mem 0xf204c000-0xf204cfff]
[    0.404744] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.406181] pci 0000:00:09.0: reg 10: [io  0xc1c0-0xc1ff]
[    0.408078] pci 0000:00:09.0: reg 14: [mem 0xf204d000-0xf204dfff]
[    0.411988] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.414110] pci 0000:00:0a.0: reg 10: [mem 0xf204e000-0xf204e00f]
[    0.418666] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.421087] pci 0000:00:01.0: PIIX/ICH IRQ router [8086:7000]
[    0.422972] PCI: pci_cache_line_size set to 64 bytes
[    0.425508] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    0.426955] e820: reserve RAM buffer [mem 0x0fffd000-0x0fffffff]
[    0.430266] NET: Registered protocol family 23
[    0.431989] Bluetooth: Core ver 2.16
[    0.433052] NET: Registered protocol family 31
[    0.434946] Bluetooth: HCI device and connection manager initialized
[    0.436960] Bluetooth: HCI socket layer initialized
[    0.438962] Bluetooth: L2CAP socket layer initialized
[    0.440970] Bluetooth: SCO socket layer initialized
[    0.442966] NET: Registered protocol family 8
[    0.444950] NET: Registered protocol family 20
[    0.445976] NetLabel: Initializing
[    0.446952] NetLabel:  domain hash size = 128
[    0.448943] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.451023] NetLabel:  unlabeled traffic allowed by default
[    0.452944] initlevel:5=fs, 18 registered initcalls
[    0.456264] Switching to clocksource kvm-clock
[    0.458150] FS-Cache: Loaded
[    0.459294] CacheFiles: Loaded
[    0.461015] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.463171] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    0.465571] NET: Registered protocol family 2
[    0.467299] IP route cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.470148] TCP established hash table entries: 8192 (order: 5, 131072 bytes)
[    0.472953] TCP bind hash table entries: 8192 (order: 7, 524288 bytes)
[    0.476289] TCP: Hash tables configured (established 8192 bind 8192)
[    0.478705] TCP: reno registered
[    0.479954] UDP hash table entries: 128 (order: 2, 20480 bytes)
[    0.482199] UDP-Lite hash table entries: 128 (order: 2, 20480 bytes)
[    0.484617] NET: Registered protocol family 1
[    0.486254] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.488448] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.490604] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.493021] pci 0000:00:02.0: Boot video device
[    0.494893] PCI: CLS 0 bytes, default 64
[    0.496584] Unpacking initramfs...
[    1.461723] Freeing initrd memory: 23656k freed
[    1.500624] initlevel:6=device, 783 registered initcalls
[    1.508181] has_svm: not amd
[    1.509333] kvm: no hardware support
[    1.510844] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    1.514151] cryptomgr_test (16) used greatest stack depth: 6544 bytes left
[    1.517013] cryptomgr_test (19) used greatest stack depth: 6232 bytes left
[    1.521937] cryptomgr_test (40) used greatest stack depth: 5720 bytes left
[    1.524628] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.527669] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.530105] VFS: Disk quotas dquot_6.5.2
[    1.531564] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.534379] QNX4 filesystem 0.2.3 registered.
[    1.536058] QNX6 filesystem 1.0.0 registered.
[    1.537794] NILFS version 2 loaded
[    1.539074] BeFS version: 0.9.3
[    1.540259] OCFS2 1.5.0
[    1.541268] ocfs2 stack glue: unable to register sysctl
[    1.543053] OCFS2 DLMFS 1.5.0
[    1.544198] OCFS2 User DLM kernel interface loaded
[    1.545994] OCFS2 Node Manager 1.5.0
[    1.547867] msgmni has been set to 418
[    1.551971] alg: No test for stdrng (krng)
[    1.558504] NET: Registered protocol family 38
[    1.560254] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.563042] io scheduler noop registered
[    1.564481] io scheduler deadline registered (default)
[    1.566216] start plist test
[    1.568521] end plist test
[    1.569495] list_sort_test: start testing list_sort()
[    1.572344] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    1.574175] crc32: self tests passed, processed 225944 bytes in 251786 nsec
[    1.577018] crc32c: CRC_LE_BITS = 32
[    1.578340] crc32c: self tests passed, processed 225944 bytes in 123689 nsec
[    1.580989] xz_dec_test: module loaded
[    1.582375] xz_dec_test: Create a device node with 'mknod xz_dec_test c 251 0' and write .xz files to it.
[    1.586386] vmlfb: initializing
[    1.587744] usbcore: registered new interface driver udlfb
[    1.589978] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.617825] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.620412] enter max3107 init
[    1.621654] Cyclades driver 2.6
[    1.622949] MOXA Intellio family driver version 6.0k
[    1.627984] Initializing Nozomi driver 2.1d
[    1.629720] Non-volatile memory driver v1.3
[    1.631429] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    1.633387] smapi::smapi_init, ERROR invalid usSmapiID
[    1.635340] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    1.638840] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    1.641205] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.643463] ipmi message handler version 39.2
[    1.645071] ipmi device interface
[    1.646350] IPMI System Interface driver.
[    1.647845] ipmi_si: Adding default-specified kcs state machine
[    1.649971] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    1.653553] ipmi_si: Interface detection failed
[    1.655252] ipmi_si: Adding default-specified smic state machine
[    1.657468] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    1.661260] ipmi_si: Interface detection failed
[    1.662957] ipmi_si: Adding default-specified bt state machine
[    1.665028] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    1.668399] ipmi_si: Interface detection failed
[    1.670084] ipmi_si: Unable to find any System Interface(s)
[    1.672126] IPMI Watchdog: driver initialized
[    1.673700] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.422736] FDC 0 is a S82078B
[    2.424264] Compaq SMART2 Driver (v 2.6.0)
[    2.425939] MM: desc_per_page = 128
[    2.427698] nbd: registered device at major 43
[    2.431488] rbd: loaded rbd (rados block device)
[    2.433314] lkdtm: No crash points registered, enable through debugfs
[    2.435779] Phantom Linux Driver, version n0.9.8, init OK
[    2.437893] i2c-core: driver [apds990x] registered
[    2.439683] i2c-core: driver [isl29020] registered
[    2.441458] i2c-core: driver [tsl2550] using legacy suspend method
[    2.443701] i2c-core: driver [tsl2550] using legacy resume method
[    2.445922] i2c-core: driver [tsl2550] registered
[    2.447739] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    2.450391] i2c-core: driver [hmc6352] registered
[    2.452108] i2c-core: driver [at24] registered
[    2.453751] i2c-core: driver [eeprom] registered
[    2.455461] i2c-core: driver [max6875] registered
[    2.457260] i2c-core: driver [twl6040] registered
[    2.459063] i2c-core: driver [adp5520] registered
[    2.461525] Loading iSCSI transport class v2.0-870.
[    2.464411] hp_sw: device handler registered
[    2.466004] alua: device handler registered
[    2.468460] Rounding down aligned max_sectors from 4294967295 to 8388600
[    2.471843] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
[    2.474612] device id = 2440
[    2.475706] device id = 2480
[    2.476809] device id = 24c0
[    2.477926] device id = 24d0
[    2.479005] device id = 25a1
[    2.480073] device id = 2670
[    2.481199] physmap-flash.0: failed to claim resource 0
[    2.483163] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.485455] slram: not enough parameters.
[    2.487009] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.489726] pmc551: not detected
[    2.491379] HSI/SSI char device loaded
[    2.492777] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    2.494642] AX.25: 6pack driver, Revision: 0.3.0
[    2.496371] AX.25: bpqether driver version 004
[    2.498003] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    2.498003] baycom_ser_fdx: version 0.10
[    2.502292] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    2.504385] hdlcdrv: version 0.8
[    2.505592] usbcore: registered new interface driver stir4200
[    2.509051] usbcore: registered new interface driver mcs7780
[    2.511193] I2O subsystem v1.325
[    2.512421] i2o: max drivers = 8
[    2.514088] I2O Bus Adapter OSM v1.317
[    2.515471] I2O Block Device OSM v1.325
[    2.517006] Fusion MPT base driver 3.04.20
[    2.518509] Copyright (c) 1999-2008 LSI Corporation
[    2.520331] Fusion MPT SPI Host driver 3.04.20
[    2.522019] Fusion MPT FC Host driver 3.04.20
[    2.523670] Fusion MPT SAS Host driver 3.04.20
[    2.525759] usbcore: registered new interface driver hwa-rc
[    2.527805] usbcore: registered new interface driver i1480-dfu-usb
[    2.530137] usbcore: registered new interface driver hwa-hc
[    2.532324] usbcore: registered new interface driver wusb-cbaf
[    2.534557] usbcore: registered new interface driver cdc_acm
[    2.536747] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    2.539679] usbcore: registered new interface driver usblp
[    2.541714] usbcore: registered new interface driver usbtmc
[    2.543774] usbcore: registered new interface driver uas
[    2.545737] Initializing USB Mass Storage driver...
[    2.547555] usbcore: registered new interface driver usb-storage
[    2.549741] USB Mass Storage support registered.
[    2.551455] usbcore: registered new interface driver ums-isd200
[    2.553616] usbcore: registered new interface driver ums-sddr09
[    2.555784] usbcore: registered new interface driver ums-usbat
[    2.558008] usbcore: registered new interface driver mdc800
[    2.560116] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[    2.563037] usbcore: registered new interface driver microtekX6
[    2.565354] usbcore: registered new interface driver usbserial
[    2.567668] usbcore: registered new interface driver usbserial_generic
[    2.570195] USB Serial support registered for generic
[    2.572144] usbserial: USB Serial Driver core
[    2.573845] usbcore: registered new interface driver ark3116
[    2.576025] USB Serial support registered for ark3116
[    2.577962] usbcore: registered new interface driver belkin_sa
[    2.580208] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    2.583287] usbcore: registered new interface driver ch341
[    2.585297] USB Serial support registered for ch341-uart
[    2.587258] usbcore: registered new interface driver cp210x
[    2.589310] USB Serial support registered for cp210x
[    2.591155] usbcore: registered new interface driver cyberjack
[    2.593307] USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    2.596051] usbcore: registered new interface driver cypress_m8
[    2.598246] USB Serial support registered for DeLorme Earthmate USB
[    2.600532] USB Serial support registered for HID->COM RS232 Adapter
[    2.602899] USB Serial support registered for Nokia CA-42 V2 Adapter
[    2.605307] usbcore: registered new interface driver io_edgeport
[    2.607551] USB Serial support registered for Edgeport 2 port adapter
[    2.609906] USB Serial support registered for Edgeport 4 port adapter
[    2.612264] USB Serial support registered for Edgeport 8 port adapter
[    2.614613] USB Serial support registered for EPiC device
[    2.616618] usbcore: registered new interface driver io_ti
[    2.618635] USB Serial support registered for Edgeport TI 1 port adapter
[    2.621104] USB Serial support registered for Edgeport TI 2 port adapter
[    2.623560] usbcore: registered new interface driver empeg
[    2.625582] USB Serial support registered for empeg
[    2.627472] usbcore: registered new interface driver ftdi_sio
[    2.629660] USB Serial support registered for FTDI USB Serial Device
[    2.632046] ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
[    2.634194] usbcore: registered new interface driver garmin_gps
[    2.636372] USB Serial support registered for Garmin GPS usb/tty
[    2.638588] usbcore: registered new interface driver hp4x
[    2.640579] USB Serial support registered for hp4X
[    2.642362] usbcore: registered new interface driver ir_usb
[    2.644402] USB Serial support registered for IR Dongle
[    2.646318] ir_usb: v0.5:USB IR Dongle driver
[    2.647905] usbcore: registered new interface driver keyspan_pda
[    2.650129] USB Serial support registered for Keyspan PDA
[    2.652161] USB Serial support registered for Keyspan PDA - (prerenumeration)
[    2.654833] USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
[    2.657842] usbcore: registered new interface driver mct_u232
[    2.659958] USB Serial support registered for MCT U232
[    2.661855] usbcore: registered new interface driver metro_usb
[    2.664012] USB Serial support registered for Metrologic USB to Serial
[    2.666402] usbcore: registered new interface driver mos7720
[    2.668473] USB Serial support registered for Moschip 2 port adapter
[    2.670807] usbcore: registered new interface driver navman
[    2.672842] USB Serial support registered for navman
[    2.674684] usbcore: registered new interface driver option
[    2.676778] USB Serial support registered for GSM modem (1-port)
[    2.679054] usbcore: registered new interface driver oti6858
[    2.681186] USB Serial support registered for oti6858
[    2.683052] safe_serial: v0.1:USB Safe Encapsulated Serial
[    2.685073] usbcore: registered new interface driver safe_serial
[    2.687327] USB Serial support registered for safe_serial
[    2.689324] usbcore: registered new interface driver siemens_mpi
[    2.691521] USB Serial support registered for siemens_mpi
[    2.693506] usbcore: registered new interface driver sierra
[    2.695540] USB Serial support registered for Sierra USB modem
[    2.697692] usbcore: registered new interface driver ssu100
[    2.699762] USB Serial support registered for Quatech SSU-100 USB to Serial Driver
[    2.702614] usbcore: registered new interface driver symbolserial
[    2.704916] USB Serial support registered for symbol
[    2.706752] usbcore: registered new interface driver ti_usb_3410_5052
[    2.709115] USB Serial support registered for TI USB 3410 1 port adapter
[    2.711564] USB Serial support registered for TI USB 5052 2 port adapter
[    2.714032] ti_usb_3410_5052: v0.10:TI USB 3410/5052 Serial Driver
[    2.716327] usbcore: registered new interface driver visor
[    2.718361] USB Serial support registered for Handspring Visor / Palm OS
[    2.720800] USB Serial support registered for Sony Clie 5.0
[    2.722844] USB Serial support registered for Sony Clie 3.5
[    2.724965] usbcore: registered new interface driver vivopay_serial
[    2.727358] USB Serial support registered for vivopay-serial
[    2.729474] usbcore: registered new interface driver cypress_cy7c63
[    2.731760] usbcore: registered new interface driver cytherm
[    2.733838] usbcore: registered new interface driver emi26 - firmware loader
[    2.736435] usbcore: registered new interface driver emi62 - firmware loader
[    2.739028] usbcore: registered new interface driver usblcd
[    2.741076] usbcore: registered new interface driver ldusb
[    2.743119] usbcore: registered new interface driver legousbtower
[    2.745351] usbcore: registered new interface driver usbtest
[    2.747485] usbcore: registered new interface driver trancevibrator
[    2.749858] usbcore: registered new interface driver usbsevseg
[    2.752099] i2c-core: driver [isp1301] registered
[    2.753837] usbcore: registered new interface driver cxacru
[    2.755884] xusbatm: malformed module parameters
[    2.757697] dummy_hcd dummy_hcd: USB Host+Gadget Emulator, driver 02 May 2005
[    2.760327] dummy_hcd dummy_hcd: Dummy host controller
[    2.762258] dummy_hcd dummy_hcd: new USB bus registered, assigned bus number 1
[    2.764917] usb usb1: default language 0x0409
[    2.766529] usb usb1: udev 1, busnum 1, minor = 0
[    2.768266] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.770730] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.773398] usb usb1: Product: Dummy host controller
[    2.775292] usb usb1: Manufacturer: Linux 3.5.0-rc1+ dummy_hcd
[    2.777544] usb usb1: SerialNumber: dummy_hcd
[    2.779249] usb usb1: usb_probe_device
[    2.780688] usb usb1: configuration #1 chosen from 1 choice
[    2.782756] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    2.784900] hub 1-0:1.0: usb_probe_interface
[    2.786499] hub 1-0:1.0: usb_probe_interface - got id
[    2.788367] hub 1-0:1.0: USB hub found
[    2.790161] hub 1-0:1.0: 1 port detected
[    2.791600] hub 1-0:1.0: standalone hub
[    2.793011] hub 1-0:1.0: individual port power switching
[    2.794937] hub 1-0:1.0: global over-current protection
[    2.796855] hub 1-0:1.0: Single TT
[    2.798175] hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
[    2.800554] hub 1-0:1.0: power on to power good time: 0ms
[    2.802608] hub 1-0:1.0: local power source is good
[    2.804421] hub 1-0:1.0: no over-current condition exists
[    2.806398] hub 1-0:1.0: enabling power on all ports
[    2.808515] udc dummy_udc: registering UDC driver [g_mass_storage]
[    2.810785]  gadget: adding config #1 'Linux File-Backed Storage'/ffffffff82422180
[    2.813964]  gadget: Mass Storage Function, version: 2009/09/11
[    2.816137]  gadget: Number of LUNs=1
[    2.817482]  lun0: LUN: removable file: (no medium)
[    2.819280]  gadget: I/O thread pid: 88
[    2.820701]  gadget: adding 'Mass Storage Function'/ffff8800092127c8 to config 'Linux File-Backed Storage'/ffffffff82422180
[    2.824819]  gadget: cfg 1/ffffffff82422180 speeds: super high full
[    2.827167]  gadget:   interface 0 = Mass Storage Function/ffff8800092127c8
[    2.829690]  gadget: Mass Storage Gadget, version: 2009/09/11
[    2.831787]  gadget: userspace failed to provide iSerialNumber
[    2.833918]  gadget: g_mass_storage ready
[    2.835418] dummy_udc dummy_udc: binding gadget driver 'g_mass_storage'
[    2.837861] dummy_udc dummy_udc: This device can perform faster if you connect it to a super-speed port...
[    2.841351] dummy_hcd dummy_hcd: port status 0x00010101 has changes
[    2.845109] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.846973] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.849105] mousedev: PS/2 mouse device common for all mice
[    2.852066] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.856371] rtc (null): alarm rollover: day
[    2.858092] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    2.860540] rtc0: alarms up to one day, 114 bytes nvram
[    2.862515] i2c-core: driver [rtc-ds1672] registered
[    2.864367] i2c-core: driver [rtc-em3027] registered
[    2.866203] i2c-core: driver [rtc-fm3130] registered
[    2.868116] i2c-core: driver [rtc-isl1208] registered
[    2.869980] i2c-core: driver [rtc-isl12022] registered
[    2.871981] i2c-core: driver [rtc-pcf8563] registered
[    2.873906] i2c-core: driver [pcf8583] registered
[    2.875724] i2c-core: driver [rtc-rs5c372] registered
[    2.877594] i2c-core: driver [rtc-rv3029c2] registered
[    2.879489] i2c-core: driver [rtc-s35390a] registered
[    2.881383] i2c-core: driver [rtc-x1205] registered
[    2.883354] piix4_smbus 0000:00:01.3: Using Interrupt 9 for SMBus.
[    2.885647] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[    2.888454] i2c i2c-0: adapter [SMBus PIIX4 adapter at b100] registered
[    2.890869] i2c i2c-0: found normal entry for adapter 0, addr 0x50
[    2.893226] i2c i2c-0: Transaction (pre): CNT=04, CMD=00, ADD=a1, DAT0=00, DAT1=00
[    2.902605] i2c i2c-0: Transaction (post): CNT=04, CMD=00, ADD=a1, DAT0=00, DAT1=00
[    2.905426] i2c i2c-0: Creating eeprom at 0x50
[    2.907125] eeprom 0-0050: probe
[    2.908333] i2c i2c-0: client [eeprom] registered with bus id 0-0050
[    2.910667] i2c i2c-0: found normal entry for adapter 0, addr 0x51
[    2.912975] i2c i2c-0: Transaction (pre): CNT=04, CMD=00, ADD=a3, DAT0=00, DAT1=00
[    2.917564] i2c i2c-0: Transaction (post): CNT=04, CMD=00, ADD=a3, DAT0=00, DAT1=00
[    2.920426] i2c i2c-0: Creating eeprom at 0x51
[    2.922142] eeprom 0-0051: probe
[    2.923413] i2c i2c-0: client [eeprom] registered with bus id 0-0051
[    2.925747] i2c i2c-0: found normal entry for adapter 0, addr 0x52
[    2.928131] i2c i2c-0: Transaction (pre): CNT=04, CMD=00, ADD=a5, DAT0=00, DAT1=00
[    2.931023] dummy_hcd dummy_hcd: port status 0x00010101 has changes
[    2.933330] hub 1-0:1.0: port 1: status 0101 change 0001
[    2.935361] i2c i2c-0: Transaction (post): CNT=04, CMD=00, ADD=a5, DAT0=00, DAT1=00
[    2.938135] i2c i2c-0: Creating eeprom at 0x52
[    2.939779] eeprom 0-0052: probe
[    2.940997] i2c i2c-0: client [eeprom] registered with bus id 0-0052
[    2.943329] i2c i2c-0: found normal entry for adapter 0, addr 0x53
[    2.945731] i2c i2c-0: Transaction (pre): CNT=04, CMD=00, ADD=a7, DAT0=00, DAT1=00
[    2.949890] i2c i2c-0: Transaction (post): CNT=04, CMD=00, ADD=a7, DAT0=00, DAT1=00
[    2.952677] i2c i2c-0: Creating eeprom at 0x53
[    2.954364] eeprom 0-0053: probe
[    2.955571] i2c i2c-0: client [eeprom] registered with bus id 0-0053
[    2.957954] i2c i2c-0: found normal entry for adapter 0, addr 0x54
[    2.960275] i2c i2c-0: Transaction (pre): CNT=04, CMD=00, ADD=a9, DAT0=00, DAT1=00
[    2.964583] i2c i2c-0: Transaction (post): CNT=04, CMD=00, ADD=a9, DAT0=00, DAT1=00
[    2.967364] i2c i2c-0: Creating eeprom at 0x54
[    2.969098] eeprom 0-0054: probe
[    2.970343] i2c i2c-0: client [eeprom] registered with bus id 0-0054
[    2.972737] i2c i2c-0: found normal entry for adapter 0, addr 0x55
[    2.975075] i2c i2c-0: Transaction (pre): CNT=04, CMD=00, ADD=ab, DAT0=00, DAT1=00
[    2.979278] i2c i2c-0: Transaction (post): CNT=04, CMD=00, ADD=ab, DAT0=00, DAT1=00
[    2.982065] i2c i2c-0: Creating eeprom at 0x55
[    2.983737] eeprom 0-0055: probe
[    2.984937] i2c i2c-0: client [eeprom] registered with bus id 0-0055
[    2.987264] i2c i2c-0: found normal entry for adapter 0, addr 0x56
[    2.989608] i2c i2c-0: Transaction (pre): CNT=04, CMD=00, ADD=ad, DAT0=00, DAT1=00
[    2.993973] i2c i2c-0: Transaction (post): CNT=04, CMD=00, ADD=ad, DAT0=00, DAT1=00
[    2.996862] i2c i2c-0: Creating eeprom at 0x56
[    2.998531] eeprom 0-0056: probe
[    2.999733] i2c i2c-0: client [eeprom] registered with bus id 0-0056
[    3.002054] i2c i2c-0: found normal entry for adapter 0, addr 0x57
[    3.004370] i2c i2c-0: Transaction (pre): CNT=04, CMD=00, ADD=af, DAT0=00, DAT1=00
[    3.008664] i2c i2c-0: Transaction (post): CNT=04, CMD=00, ADD=af, DAT0=00, DAT1=00
[    3.011446] i2c i2c-0: Creating eeprom at 0x57
[    3.013132] eeprom 0-0057: probe
[    3.014393] i2c i2c-0: Transaction (pre): CNT=08, CMD=80, ADD=af, DAT0=00, DAT1=00
[    3.018462] i2c i2c-0: Transaction (post): CNT=08, CMD=80, ADD=af, DAT0=00, DAT1=00
[    3.021409] i2c i2c-0: Transaction (pre): CNT=08, CMD=81, ADD=af, DAT0=00, DAT1=00
[    3.025325] i2c i2c-0: Transaction (post): CNT=08, CMD=81, ADD=af, DAT0=00, DAT1=00
[    3.028186] i2c i2c-0: Transaction (pre): CNT=08, CMD=82, ADD=af, DAT0=00, DAT1=00
[    3.032175] i2c i2c-0: Transaction (post): CNT=08, CMD=82, ADD=af, DAT0=00, DAT1=00
[    3.035008] i2c i2c-0: Transaction (pre): CNT=08, CMD=83, ADD=af, DAT0=00, DAT1=00
[    3.039041] i2c i2c-0: Transaction (post): CNT=08, CMD=83, ADD=af, DAT0=00, DAT1=00
[    3.041840] i2c i2c-0: client [eeprom] registered with bus id 0-0057
[    3.044382] usbcore: registered new interface driver i2c-tiny-usb
[    3.047182] lirc_dev: IR Remote Control driver registered, major 244 
[    3.049620] IR NEC protocol handler initialized
[    3.051294] IR RC5(x) protocol handler initialized
[    3.053069] IR RC6 protocol handler initialized
[    3.054730] IR JVC protocol handler initialized
[    3.056407] IR Sony protocol handler initialized
[    3.058110] IR RC5 (streamzap) protocol handler initialized
[    3.060148] IR SANYO protocol handler initialized
[    3.061875] IR MCE Keyboard/mouse protocol handler initialized
[    3.063996] IR LIRC bridge handler initialized
[    3.065648] Driver for 1-wire Dallas network protocol.
[    3.067638] i2c-core: driver [ds2482] registered
[    3.069399] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.071749] i2c-core: driver [max17040] using legacy suspend method
[    3.074045] i2c-core: driver [max17040] using legacy resume method
[    3.076304] i2c-core: driver [max17040] registered
[    3.078078] i2c-core: driver [asb100] registered
[    3.079843] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.082182] i2c i2c-0: Transaction (pre): CNT=00, CMD=83, ADD=5a, DAT0=00, DAT1=00
[    3.084946] hub 1-0:1.0: state 7 ports 1 chg 0002 evt 0000
[    3.086981] hub 1-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    3.089374] i2c i2c-0: Transaction (post): CNT=00, CMD=83, ADD=5a, DAT0=00, DAT1=00
[    3.092306] i2c i2c-0: Transaction (pre): CNT=08, CMD=4e, ADD=5b, DAT0=00, DAT1=00
[    3.096827] i2c i2c-0: Transaction (post): CNT=08, CMD=4e, ADD=5b, DAT0=ff, DAT1=00
[    3.099695] i2c i2c-0: Transaction (pre): CNT=08, CMD=4f, ADD=5b, DAT0=ff, DAT1=00
[    3.103684] i2c i2c-0: Transaction (post): CNT=08, CMD=4f, ADD=5b, DAT0=ff, DAT1=00
[    3.106552] i2c i2c-0: Transaction (pre): CNT=08, CMD=4e, ADD=5b, DAT0=ff, DAT1=00
[    3.110541] i2c i2c-0: Transaction (post): CNT=08, CMD=4e, ADD=5b, DAT0=ff, DAT1=00
[    3.113413] i2c i2c-0: Transaction (pre): CNT=08, CMD=4e, ADD=5a, DAT0=f8, DAT1=00
[    3.117402] i2c i2c-0: Transaction (post): CNT=08, CMD=4e, ADD=5a, DAT0=f8, DAT1=00
[    3.120325] i2c i2c-0: Transaction (pre): CNT=08, CMD=58, ADD=5b, DAT0=f8, DAT1=00
[    3.125801] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input1
[    3.129318] i2c i2c-0: Transaction (post): CNT=08, CMD=58, ADD=5b, DAT0=ff, DAT1=00
[    3.132164] i2c i2c-0: Transaction (pre): CNT=08, CMD=4f, ADD=5b, DAT0=ff, DAT1=00
[    3.136011] i2c i2c-0: Transaction (post): CNT=08, CMD=4f, ADD=5b, DAT0=ff, DAT1=00
[    3.138916] i2c-core: driver [w83792d] registered
[    3.140713] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    3.143156] i2c i2c-0: Transaction (pre): CNT=00, CMD=4f, ADD=58, DAT0=ff, DAT1=00
[    3.145969]  gadget: resume
[    3.147012] dummy_hcd dummy_hcd: port status 0x00100503 has changes
[    3.149378] i2c i2c-0: Transaction (post): CNT=00, CMD=4f, ADD=58, DAT0=ff, DAT1=00
[    3.152234] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=00
[    3.156581] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=00
[    3.159372] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.161683] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=00
[    3.166379] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=00
[    3.169309] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=00
[    3.173237] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=00
[    3.176017] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.178349] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=00
[    3.183031] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=00
[    3.185866] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=00
[    3.189893] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=00
[    3.192767] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[    3.195089] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5e, DAT0=ff, DAT1=00
[    3.199684] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5e, DAT0=ff, DAT1=00
[    3.202609] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5f, DAT0=ff, DAT1=00
[    3.206540] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5f, DAT0=ff, DAT1=00
[    3.209355] i2c-core: driver [w83793] registered
[    3.211064] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    3.213434] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=00
[    3.216321] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    3.218830] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=00
[    3.221686] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=59, DAT0=ff, DAT1=00
[    3.226136] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=59, DAT0=ff, DAT1=00
[    3.228995] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=59, DAT0=ff, DAT1=00
[    3.232990] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=59, DAT0=ff, DAT1=00
[    3.235777] w83793: Detection failed at check vendor id
[    3.237750] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.240145] i2c i2c-0: Transaction (pre): CNT=00, CMD=0d, ADD=5a, DAT0=ff, DAT1=00
[    3.244743] i2c i2c-0: Transaction (post): CNT=00, CMD=0d, ADD=5a, DAT0=ff, DAT1=00
[    3.247600] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=5b, DAT0=ff, DAT1=00
[    3.251602] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=5b, DAT0=ff, DAT1=00
[    3.254457] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=5b, DAT0=ff, DAT1=00
[    3.258463] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=5b, DAT0=ff, DAT1=00
[    3.261340] w83793: Detection failed at check vendor id
[    3.263318] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.265696] i2c i2c-0: Transaction (pre): CNT=00, CMD=0d, ADD=5c, DAT0=ff, DAT1=00
[    3.270213] i2c i2c-0: Transaction (post): CNT=00, CMD=0d, ADD=5c, DAT0=ff, DAT1=00
[    3.273069] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=5d, DAT0=ff, DAT1=00
[    3.277080] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=5d, DAT0=ff, DAT1=00
[    3.279916] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=5d, DAT0=ff, DAT1=00
[    3.282678]  gadget: resume
[    3.283725] dummy_hcd dummy_hcd: port status 0x00100503 has changes
[    3.286147] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=5d, DAT0=ff, DAT1=00
[    3.289008] w83793: Detection failed at check vendor id
[    3.291000] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[    3.293315] i2c i2c-0: Transaction (pre): CNT=00, CMD=0d, ADD=5e, DAT0=ff, DAT1=00
[    3.297641] i2c i2c-0: Transaction (post): CNT=00, CMD=0d, ADD=5e, DAT0=ff, DAT1=00
[    3.300510] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=5f, DAT0=ff, DAT1=00
[    3.304498] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=5f, DAT0=ff, DAT1=00
[    3.307331] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=5f, DAT0=ff, DAT1=00
[    3.311362] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=5f, DAT0=ff, DAT1=00
[    3.314251] w83793: Detection failed at check vendor id
[    3.316185] i2c-core: driver [w83791d] registered
[    3.317894] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    3.320272] i2c i2c-0: Transaction (pre): CNT=00, CMD=0d, ADD=58, DAT0=ff, DAT1=00
[    3.325079] i2c i2c-0: Transaction (post): CNT=00, CMD=0d, ADD=58, DAT0=ff, DAT1=00
[    3.327925] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=00
[    3.331927] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=00
[    3.334784] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.337179] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=00
[    3.341734] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=00
[    3.344516] dummy_udc dummy_udc: set_address = 2
[    3.346294] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=00
[    3.350540] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=00
[    3.353319] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.355625] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=00
[    3.360342] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=00
[    3.363274] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=00
[    3.367204] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=00
[    3.370004] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[    3.372340] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5e, DAT0=ff, DAT1=00
[    3.376994] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5e, DAT0=ff, DAT1=00
[    3.379827] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5f, DAT0=ff, DAT1=00
[    3.382801] usb 1-1: default language 0x0409
[    3.384506] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5f, DAT0=ff, DAT1=00
[    3.387408] i2c-core: driver [ad7418] registered
[    3.389137] i2c-core: driver [adm1021] registered
[    3.390859] i2c i2c-0: found normal entry for adapter 0, addr 0x18
[    3.393185] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=30, DAT0=ff, DAT1=00
[    3.397564] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=30, DAT0=ff, DAT1=00
[    3.400421] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=31, DAT0=ff, DAT1=00
[    3.403188] usb 1-1: udev 2, busnum 1, minor = 1
[    3.404889] usb 1-1: New USB device found, idVendor=0525, idProduct=a4a5
[    3.407397] usb 1-1: New USB device strings: Mfr=2, Product=3, SerialNumber=0
[    3.410139] usb 1-1: Product: Mass Storage Gadget
[    3.411912] usb 1-1: Manufacturer: Linux 3.5.0-rc1+ with dummy_udc
[    3.414259] usb 1-1: usb_probe_device
[    3.415599] usb 1-1: configuration #1 chosen from 1 choice
[    3.417683] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=31, DAT0=ff, DAT1=00
[    3.420466]  gadget: high-speed config #1: Linux File-Backed Storage
[    3.421460]  gadget: set_config: interface 0 (Mass Storage Function) requested delayed status
[    3.421460]  gadget: delayed_status count 1
[    3.427470] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=31, DAT0=ff, DAT1=00
[    3.430257] dummy_udc dummy_udc: enabled ep-a (ep1in-bulk) maxpacket 512 stream disabled
[    3.433285] dummy_udc dummy_udc: enabled ep-b (ep2out-bulk) maxpacket 512 stream disabled
[    3.436333]  gadget: usb_composite_setup_continue
[    3.438074]  gadget: usb_composite_setup_continue: Completing delayed status
[    3.440743] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=31, DAT0=ff, DAT1=00
[    3.443607] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=31, DAT0=ff, DAT1=00
[    3.446392] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    3.448563] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=31, DAT0=ff, DAT1=00
[    3.451361] adm1021: detect failed, chip not detected!
[    3.453228] i2c i2c-0: found normal entry for adapter 0, addr 0x19
[    3.455579] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=32, DAT0=ff, DAT1=00
[    3.458463] uas 1-1:1.0: usb_probe_interface
[    3.460083] uas 1-1:1.0: usb_probe_interface - got id
[    3.461968] usb-storage 1-1:1.0: usb_probe_interface
[    3.463798] usb-storage 1-1:1.0: usb_probe_interface - got id
[    3.466016] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=32, DAT0=ff, DAT1=00
[    3.468864] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=33, DAT0=ff, DAT1=00
[    3.471783] usb-storage 1-1:1.0: Quirks match for vid 0525 pid a4a5: 10000
[    3.474390] scsi0 : usb-storage 1-1:1.0
[    3.476564] hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0002
[    3.478710] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=33, DAT0=ff, DAT1=00
[    3.481664] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=33, DAT0=ff, DAT1=00
[    3.485722] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=33, DAT0=ff, DAT1=00
[    3.488560] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=33, DAT0=ff, DAT1=00
[    3.492578] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=33, DAT0=ff, DAT1=00
[    3.495371] adm1021: detect failed, chip not detected!
[    3.497257] i2c i2c-0: found normal entry for adapter 0, addr 0x1a
[    3.499621] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=34, DAT0=ff, DAT1=00
[    3.504339] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=34, DAT0=ff, DAT1=00
[    3.507274] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=35, DAT0=ff, DAT1=00
[    3.511189] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=35, DAT0=ff, DAT1=00
[    3.514029] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=35, DAT0=ff, DAT1=00
[    3.518049] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=35, DAT0=ff, DAT1=00
[    3.520914] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=35, DAT0=ff, DAT1=00
[    3.524903] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=35, DAT0=ff, DAT1=00
[    3.527693] adm1021: detect failed, chip not detected!
[    3.529631] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[    3.532084] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=52, DAT0=ff, DAT1=00
[    3.536660] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=52, DAT0=ff, DAT1=00
[    3.539486] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=53, DAT0=ff, DAT1=00
[    3.543518] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=53, DAT0=ff, DAT1=00
[    3.546374] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=53, DAT0=ff, DAT1=00
[    3.550373] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=53, DAT0=ff, DAT1=00
[    3.553257] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=53, DAT0=ff, DAT1=00
[    3.557236] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=53, DAT0=ff, DAT1=00
[    3.560040] adm1021: detect failed, chip not detected!
[    3.561940] i2c i2c-0: found normal entry for adapter 0, addr 0x2a
[    3.564270] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=54, DAT0=ff, DAT1=00
[    3.568986] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=54, DAT0=ff, DAT1=00
[    3.571824] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=55, DAT0=ff, DAT1=00
[    3.575845] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=55, DAT0=ff, DAT1=00
[    3.578764] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=55, DAT0=ff, DAT1=00
[    3.583681] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=55, DAT0=ff, DAT1=00
[    3.586536] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=55, DAT0=ff, DAT1=00
[    3.590540] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=55, DAT0=ff, DAT1=00
[    3.593345] adm1021: detect failed, chip not detected!
[    3.595178] i2c i2c-0: found normal entry for adapter 0, addr 0x2b
[    3.597409] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=56, DAT0=ff, DAT1=00
[    3.601314] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=56, DAT0=ff, DAT1=00
[    3.604170] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=57, DAT0=ff, DAT1=00
[    3.608174] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=57, DAT0=ff, DAT1=00
[    3.610944] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=57, DAT0=ff, DAT1=00
[    3.615027] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=57, DAT0=ff, DAT1=00
[    3.617781] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=57, DAT0=ff, DAT1=00
[    3.621882] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=57, DAT0=ff, DAT1=00
[    3.624569] adm1021: detect failed, chip not detected!
[    3.626430] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    3.628742] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=98, DAT0=ff, DAT1=00
[    3.632657] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=98, DAT0=ff, DAT1=00
[    3.635419] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=99, DAT0=ff, DAT1=00
[    3.639515] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=99, DAT0=ff, DAT1=00
[    3.642286] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=99, DAT0=ff, DAT1=00
[    3.646372] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=99, DAT0=ff, DAT1=00
[    3.649133] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=99, DAT0=ff, DAT1=00
[    3.653235] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=99, DAT0=ff, DAT1=00
[    3.655978] adm1021: detect failed, chip not detected!
[    3.657806] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    3.660067] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=9a, DAT0=ff, DAT1=00
[    3.664005] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=9a, DAT0=ff, DAT1=00
[    3.666761] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=9b, DAT0=ff, DAT1=00
[    3.670862] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=9b, DAT0=ff, DAT1=00
[    3.673623] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=9b, DAT0=ff, DAT1=00
[    3.677724] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=9b, DAT0=ff, DAT1=00
[    3.680606] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=9b, DAT0=ff, DAT1=00
[    3.684577] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=9b, DAT0=ff, DAT1=00
[    3.687277] adm1021: detect failed, chip not detected!
[    3.689118] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[    3.691367] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=9c, DAT0=ff, DAT1=00
[    3.695351] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=9c, DAT0=ff, DAT1=00
[    3.698109] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=9d, DAT0=ff, DAT1=00
[    3.702215] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=9d, DAT0=ff, DAT1=00
[    3.704985] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=9d, DAT0=ff, DAT1=00
[    3.709069] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=9d, DAT0=ff, DAT1=00
[    3.711886] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=9d, DAT0=ff, DAT1=00
[    3.715924] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=9d, DAT0=ff, DAT1=00
[    3.718609] adm1021: detect failed, chip not detected!
[    3.720454] i2c-core: driver [adm1025] registered
[    3.722130] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    3.724434] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=58, DAT0=ff, DAT1=00
[    3.728658] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=58, DAT0=ff, DAT1=00
[    3.731416] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=00
[    3.735516] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=00
[    3.738259] i2c i2c-0: ADM1025 detection failed at 0x2c
[    3.740201] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.742477] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=00
[    3.746289] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=00
[    3.749125] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=00
[    3.753156] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=00
[    3.755864] i2c i2c-0: ADM1025 detection failed at 0x2d
[    3.757731] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.760009] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=00
[    3.763924] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=00
[    3.766691] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=00
[    3.770781] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=00
[    3.773544] i2c i2c-0: ADM1025 detection failed at 0x2e
[    3.775485] i2c-core: driver [adm1026] registered
[    3.777178] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    3.779409] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=00
[    3.783515] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=00
[    3.786286] i2c i2c-0: Transaction (pre): CNT=08, CMD=16, ADD=59, DAT0=ff, DAT1=00
[    3.790372] i2c i2c-0: Transaction (post): CNT=08, CMD=16, ADD=59, DAT0=ff, DAT1=00
[    3.793123] i2c i2c-0: Transaction (pre): CNT=08, CMD=17, ADD=59, DAT0=ff, DAT1=00
[    3.797232] i2c i2c-0: Transaction (post): CNT=08, CMD=17, ADD=59, DAT0=ff, DAT1=00
[    3.800031] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and VERSTEP: 0xff
[    3.802872] i2c i2c-0: Autodetecting device at 0,0x2c...
[    3.804755] i2c i2c-0: Autodetection failed
[    3.806259] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    3.808507] i2c i2c-0: Transaction (pre): CNT=00, CMD=17, ADD=5a, DAT0=ff, DAT1=00
[    3.812901] i2c i2c-0: Transaction (post): CNT=00, CMD=17, ADD=5a, DAT0=ff, DAT1=00
[    3.815642] i2c i2c-0: Transaction (pre): CNT=08, CMD=16, ADD=5b, DAT0=ff, DAT1=00
[    3.819760] i2c i2c-0: Transaction (post): CNT=08, CMD=16, ADD=5b, DAT0=ff, DAT1=00
[    3.822616] i2c i2c-0: Transaction (pre): CNT=08, CMD=17, ADD=5b, DAT0=ff, DAT1=00
[    3.826615] i2c i2c-0: Transaction (post): CNT=08, CMD=17, ADD=5b, DAT0=ff, DAT1=00
[    3.829353] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and VERSTEP: 0xff
[    3.832174] i2c i2c-0: Autodetecting device at 0,0x2d...
[    3.834054] i2c i2c-0: Autodetection failed
[    3.835558] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.837793] i2c i2c-0: Transaction (pre): CNT=00, CMD=17, ADD=5c, DAT0=ff, DAT1=00
[    3.842291] i2c i2c-0: Transaction (post): CNT=00, CMD=17, ADD=5c, DAT0=ff, DAT1=00
[    3.845067] i2c i2c-0: Transaction (pre): CNT=08, CMD=16, ADD=5d, DAT0=ff, DAT1=00
[    3.849156] i2c i2c-0: Transaction (post): CNT=08, CMD=16, ADD=5d, DAT0=ff, DAT1=00
[    3.851914] i2c i2c-0: Transaction (pre): CNT=08, CMD=17, ADD=5d, DAT0=ff, DAT1=00
[    3.856005] i2c i2c-0: Transaction (post): CNT=08, CMD=17, ADD=5d, DAT0=ff, DAT1=00
[    3.858701] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and VERSTEP: 0xff
[    3.861561] i2c i2c-0: Autodetecting device at 0,0x2e...
[    3.863447] i2c i2c-0: Autodetection failed
[    3.864963] i2c-core: driver [ads1015] registered
[    3.866637] i2c-core: driver [adt7411] registered
[    3.868319] i2c i2c-0: found normal entry for adapter 0, addr 0x48
[    3.870587] i2c i2c-0: Transaction (pre): CNT=00, CMD=17, ADD=90, DAT0=ff, DAT1=00
[    3.874617] i2c i2c-0: Transaction (post): CNT=00, CMD=17, ADD=90, DAT0=ff, DAT1=00
[    3.877375] i2c i2c-0: Transaction (pre): CNT=08, CMD=4e, ADD=91, DAT0=ff, DAT1=00
[    3.881472] i2c i2c-0: Transaction (post): CNT=08, CMD=4e, ADD=91, DAT0=ff, DAT1=00
[    3.884173]  (null): Wrong manufacturer ID. Got 255, expected 65
[    3.886305] i2c i2c-0: found normal entry for adapter 0, addr 0x4a
[    3.888492] i2c i2c-0: Transaction (pre): CNT=00, CMD=4e, ADD=94, DAT0=ff, DAT1=00
[    3.892247] i2c i2c-0: Transaction (post): CNT=00, CMD=4e, ADD=94, DAT0=ff, DAT1=00
[    3.895007] i2c i2c-0: Transaction (pre): CNT=08, CMD=4e, ADD=95, DAT0=ff, DAT1=00
[    3.899111] i2c i2c-0: Transaction (post): CNT=08, CMD=4e, ADD=95, DAT0=ff, DAT1=00
[    3.901822]  (null): Wrong manufacturer ID. Got 255, expected 65
[    3.903948] i2c i2c-0: found normal entry for adapter 0, addr 0x4b
[    3.906185] i2c i2c-0: Transaction (pre): CNT=00, CMD=4e, ADD=96, DAT0=ff, DAT1=00
[    3.910861] i2c i2c-0: Transaction (post): CNT=00, CMD=4e, ADD=96, DAT0=ff, DAT1=00
[    3.913595] i2c i2c-0: Transaction (pre): CNT=08, CMD=4e, ADD=97, DAT0=ff, DAT1=00
[    3.917718] i2c i2c-0: Transaction (post): CNT=08, CMD=4e, ADD=97, DAT0=ff, DAT1=00
[    3.920647]  (null): Wrong manufacturer ID. Got 255, expected 65
[    3.922920] i2c-core: driver [adt7470] registered
[    3.924714] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    3.927030] i2c i2c-0: Transaction (pre): CNT=00, CMD=4e, ADD=58, DAT0=ff, DAT1=00
[    3.931430] i2c i2c-0: Transaction (post): CNT=00, CMD=4e, ADD=58, DAT0=ff, DAT1=00
[    3.934202] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=00
[    3.938288] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=00
[    3.941060] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    3.943380] i2c i2c-0: Transaction (pre): CNT=00, CMD=3e, ADD=5c, DAT0=ff, DAT1=00
[    3.948087] i2c i2c-0: Transaction (post): CNT=00, CMD=3e, ADD=5c, DAT0=ff, DAT1=00
[    3.951063] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=5d, DAT0=ff, DAT1=00
[    3.954942] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=5d, DAT0=ff, DAT1=00
[    3.957735] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[    3.960048] i2c i2c-0: Transaction (pre): CNT=00, CMD=3e, ADD=5e, DAT0=ff, DAT1=00
[    3.964736] i2c i2c-0: Transaction (post): CNT=00, CMD=3e, ADD=5e, DAT0=ff, DAT1=00
[    3.967608] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=5f, DAT0=ff, DAT1=00
[    3.971601] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=5f, DAT0=ff, DAT1=00
[    3.974471] i2c-core: driver [ds620] registered
[    3.976140] i2c-core: driver [ds1621] registered
[    3.977832] i2c i2c-0: found normal entry for adapter 0, addr 0x48
[    3.980164] i2c i2c-0: Transaction (pre): CNT=00, CMD=3e, ADD=90, DAT0=ff, DAT1=00
[    3.984278] i2c i2c-0: Transaction (post): CNT=00, CMD=3e, ADD=90, DAT0=ff, DAT1=00
[    3.987057] i2c i2c-0: Transaction (pre): CNT=08, CMD=ac, ADD=91, DAT0=ff, DAT1=00
[    3.991144] i2c i2c-0: Transaction (post): CNT=08, CMD=ac, ADD=91, DAT0=ff, DAT1=00
[    3.993876] i2c i2c-0: found normal entry for adapter 0, addr 0x49
[    3.996182] i2c i2c-0: Transaction (pre): CNT=00, CMD=ac, ADD=92, DAT0=ff, DAT1=00
[    4.000932] i2c i2c-0: Transaction (post): CNT=00, CMD=ac, ADD=92, DAT0=ff, DAT1=00
[    4.003686] i2c i2c-0: Transaction (pre): CNT=08, CMD=ac, ADD=93, DAT0=ff, DAT1=00
[    4.007788] i2c i2c-0: Transaction (post): CNT=08, CMD=ac, ADD=93, DAT0=ff, DAT1=00
[    4.010566] i2c i2c-0: found normal entry for adapter 0, addr 0x4a
[    4.013562] i2c i2c-0: Transaction (pre): CNT=00, CMD=ac, ADD=94, DAT0=ff, DAT1=00
[    4.018386] i2c i2c-0: Transaction (post): CNT=00, CMD=ac, ADD=94, DAT0=ff, DAT1=00
[    4.021419] i2c i2c-0: Transaction (pre): CNT=08, CMD=ac, ADD=95, DAT0=ff, DAT1=00
[    4.026228] i2c i2c-0: Transaction (post): CNT=08, CMD=ac, ADD=95, DAT0=ff, DAT1=00
[    4.029765] i2c i2c-0: found normal entry for adapter 0, addr 0x4b
[    4.032573] i2c i2c-0: Transaction (pre): CNT=00, CMD=ac, ADD=96, DAT0=ff, DAT1=00
[    4.037984] i2c i2c-0: Transaction (post): CNT=00, CMD=ac, ADD=96, DAT0=ff, DAT1=00
[    4.041452] i2c i2c-0: Transaction (pre): CNT=08, CMD=ac, ADD=97, DAT0=ff, DAT1=00
[    4.045806] i2c i2c-0: Transaction (post): CNT=08, CMD=ac, ADD=97, DAT0=ff, DAT1=00
[    4.049000] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    4.051637] i2c i2c-0: Transaction (pre): CNT=00, CMD=ac, ADD=98, DAT0=ff, DAT1=00
[    4.056580] i2c i2c-0: Transaction (post): CNT=00, CMD=ac, ADD=98, DAT0=ff, DAT1=00
[    4.059677] i2c i2c-0: Transaction (pre): CNT=08, CMD=ac, ADD=99, DAT0=ff, DAT1=00
[    4.064416] i2c i2c-0: Transaction (post): CNT=08, CMD=ac, ADD=99, DAT0=ff, DAT1=00
[    4.067415] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    4.070968] i2c i2c-0: Transaction (pre): CNT=00, CMD=ac, ADD=9a, DAT0=ff, DAT1=00
[    4.076178] i2c i2c-0: Transaction (post): CNT=00, CMD=ac, ADD=9a, DAT0=ff, DAT1=00
[    4.079447] i2c i2c-0: Transaction (pre): CNT=08, CMD=ac, ADD=9b, DAT0=ff, DAT1=00
[    4.084012] i2c i2c-0: Transaction (post): CNT=08, CMD=ac, ADD=9b, DAT0=ff, DAT1=00
[    4.087014] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[    4.089567] i2c i2c-0: Transaction (pre): CNT=00, CMD=ac, ADD=9c, DAT0=ff, DAT1=00
[    4.094105] i2c i2c-0: Transaction (post): CNT=00, CMD=ac, ADD=9c, DAT0=ff, DAT1=00
[    4.097575] i2c i2c-0: Transaction (pre): CNT=08, CMD=ac, ADD=9d, DAT0=ff, DAT1=00
[    4.102624] i2c i2c-0: Transaction (post): CNT=08, CMD=ac, ADD=9d, DAT0=ff, DAT1=00
[    4.105935] i2c i2c-0: found normal entry for adapter 0, addr 0x4f
[    4.108521] i2c i2c-0: Transaction (pre): CNT=00, CMD=ac, ADD=9e, DAT0=ff, DAT1=00
[    4.113397] i2c i2c-0: Transaction (post): CNT=00, CMD=ac, ADD=9e, DAT0=ff, DAT1=00
[    4.116445] i2c i2c-0: Transaction (pre): CNT=08, CMD=ac, ADD=9f, DAT0=ff, DAT1=00
[    4.122217] i2c i2c-0: Transaction (post): CNT=08, CMD=ac, ADD=9f, DAT0=ff, DAT1=00
[    4.125501] i2c-core: driver [emc1403] registered
[    4.127476] i2c i2c-0: found normal entry for adapter 0, addr 0x18
[    4.130215] i2c i2c-0: Transaction (pre): CNT=00, CMD=ac, ADD=30, DAT0=ff, DAT1=00
[    4.134960] i2c i2c-0: Transaction (post): CNT=00, CMD=ac, ADD=30, DAT0=ff, DAT1=00
[    4.138031] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=31, DAT0=ff, DAT1=00
[    4.142887] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=31, DAT0=ff, DAT1=00
[    4.146265] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[    4.148943] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=52, DAT0=ff, DAT1=00
[    4.153563] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=52, DAT0=ff, DAT1=00
[    4.156606] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=53, DAT0=ff, DAT1=00
[    4.161397] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=53, DAT0=ff, DAT1=00
[    4.164493] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    4.167870] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=98, DAT0=ff, DAT1=00
[    4.173156] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=98, DAT0=ff, DAT1=00
[    4.176449] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=99, DAT0=ff, DAT1=00
[    4.180998] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=99, DAT0=ff, DAT1=00
[    4.184071] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    4.186681] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=9a, DAT0=ff, DAT1=00
[    4.191875] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=9a, DAT0=ff, DAT1=00
[    4.195319] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=9b, DAT0=ff, DAT1=00
[    4.200584] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=9b, DAT0=ff, DAT1=00
[    4.203941] i2c-core: driver [emc6w201] registered
[    4.206010] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.208565] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=58, DAT0=ff, DAT1=00
[    4.213315] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=58, DAT0=ff, DAT1=00
[    4.217420] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=00
[    4.222136] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=00
[    4.225416] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.227260] i2c i2c-0: Transaction (pre): CNT=00, CMD=3e, ADD=5a, DAT0=ff, DAT1=00
[    4.231922] i2c i2c-0: Transaction (post): CNT=00, CMD=3e, ADD=5a, DAT0=ff, DAT1=00
[    4.234891] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=5b, DAT0=ff, DAT1=00
[    4.239741] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=5b, DAT0=ff, DAT1=00
[    4.242454] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.244741] i2c i2c-0: Transaction (pre): CNT=00, CMD=3e, ADD=5c, DAT0=ff, DAT1=00
[    4.248555] i2c i2c-0: Transaction (post): CNT=00, CMD=3e, ADD=5c, DAT0=ff, DAT1=00
[    4.251431] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=5d, DAT0=ff, DAT1=00
[    4.255414] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=5d, DAT0=ff, DAT1=00
[    4.258535] f71882fg: Not a Fintek device
[    4.260238] f71882fg: Not a Fintek device
[    4.261848] i2c-core: driver [fschmd] registered
[    4.263601] i2c i2c-0: found normal entry for adapter 0, addr 0x73
[    4.265739] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=e7, DAT0=ff, DAT1=00
[    4.270109] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=e7, DAT0=ff, DAT1=00
[    4.272875] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=e7, DAT0=ff, DAT1=00
[    4.276971] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=e7, DAT0=ff, DAT1=00
[    4.279757] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=e7, DAT0=ff, DAT1=00
[    4.283821] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=e7, DAT0=ff, DAT1=00
[    4.286718] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=e7, DAT0=ff, DAT1=00
[    4.290678] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=e7, DAT0=ff, DAT1=00
[    4.293427] i2c-core: driver [g760a] registered
[    4.295094] i2c-core: driver [gl520sm] registered
[    4.296797] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.299060] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=58, DAT0=ff, DAT1=00
[    4.303411] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=58, DAT0=ff, DAT1=00
[    4.306239] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=59, DAT0=ff, DAT1=00
[    4.310269] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=59, DAT0=ff, DAT1=00
[    4.313142]  (null): Unknown chip type, skipping
[    4.314807] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.317098] i2c i2c-0: Transaction (pre): CNT=00, CMD=00, ADD=5a, DAT0=ff, DAT1=00
[    4.321044] i2c i2c-0: Transaction (post): CNT=00, CMD=00, ADD=5a, DAT0=ff, DAT1=00
[    4.323810] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=5b, DAT0=ff, DAT1=00
[    4.327900] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=5b, DAT0=ff, DAT1=00
[    4.330663]  (null): Unknown chip type, skipping
[    4.332584] i2c-core: driver [lineage_pem] registered
[    4.334454] i2c-core: driver [lm73] registered
[    4.336078] i2c i2c-0: found normal entry for adapter 0, addr 0x48
[    4.338328] i2c i2c-0: Transaction (pre): CNT=00, CMD=00, ADD=90, DAT0=ff, DAT1=00
[    4.342598] i2c i2c-0: Transaction (post): CNT=00, CMD=00, ADD=90, DAT0=ff, DAT1=00
[    4.345471] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=91, DAT0=ff, DAT1=00
[    4.349453] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=91, DAT0=ff, DAT1=00
[    4.352243] i2c i2c-0: found normal entry for adapter 0, addr 0x49
[    4.354615] i2c i2c-0: Transaction (pre): CNT=00, CMD=04, ADD=92, DAT0=ff, DAT1=00
[    4.359248] i2c i2c-0: Transaction (post): CNT=00, CMD=04, ADD=92, DAT0=ff, DAT1=00
[    4.362093] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=93, DAT0=ff, DAT1=00
[    4.366109] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=93, DAT0=ff, DAT1=00
[    4.368900] i2c i2c-0: found normal entry for adapter 0, addr 0x4a
[    4.371224] i2c i2c-0: Transaction (pre): CNT=00, CMD=04, ADD=94, DAT0=ff, DAT1=00
[    4.375901] i2c i2c-0: Transaction (post): CNT=00, CMD=04, ADD=94, DAT0=ff, DAT1=00
[    4.378803] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=95, DAT0=ff, DAT1=00
[    4.382757] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=95, DAT0=ff, DAT1=00
[    4.385549] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    4.387864] i2c i2c-0: Transaction (pre): CNT=00, CMD=04, ADD=98, DAT0=ff, DAT1=00
[    4.392554] i2c i2c-0: Transaction (post): CNT=00, CMD=04, ADD=98, DAT0=ff, DAT1=00
[    4.395410] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=99, DAT0=ff, DAT1=00
[    4.399413] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=99, DAT0=ff, DAT1=00
[    4.402255] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    4.404569] i2c i2c-0: Transaction (pre): CNT=00, CMD=04, ADD=9a, DAT0=ff, DAT1=00
[    4.409187] i2c i2c-0: Transaction (post): CNT=00, CMD=04, ADD=9a, DAT0=ff, DAT1=00
[    4.411961] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=9b, DAT0=ff, DAT1=00
[    4.416044] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=9b, DAT0=ff, DAT1=00
[    4.418773] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[    4.421035] i2c i2c-0: Transaction (pre): CNT=00, CMD=04, ADD=9c, DAT0=ff, DAT1=00
[    4.424862] i2c i2c-0: Transaction (post): CNT=00, CMD=04, ADD=9c, DAT0=ff, DAT1=00
[    4.427661] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=9d, DAT0=ff, DAT1=00
[    4.431721] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=9d, DAT0=ff, DAT1=00
[    4.434456] i2c-core: driver [lm75] registered
[    4.436062] i2c i2c-0: found normal entry for adapter 0, addr 0x48
[    4.438322] i2c i2c-0: Transaction (pre): CNT=00, CMD=04, ADD=90, DAT0=ff, DAT1=00
[    4.442492] i2c i2c-0: Transaction (post): CNT=00, CMD=04, ADD=90, DAT0=ff, DAT1=00
[    4.445253] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=91, DAT0=ff, DAT1=00
[    4.449350] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=91, DAT0=ff, DAT1=00
[    4.452096] i2c i2c-0: found normal entry for adapter 0, addr 0x49
[    4.454418] i2c i2c-0: Transaction (pre): CNT=00, CMD=01, ADD=92, DAT0=ff, DAT1=00
[    4.459145] i2c i2c-0: Transaction (post): CNT=00, CMD=01, ADD=92, DAT0=ff, DAT1=00
[    4.462031] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=93, DAT0=ff, DAT1=00
[    4.466004] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=93, DAT0=ff, DAT1=00
[    4.468695] i2c i2c-0: found normal entry for adapter 0, addr 0x4a
[    4.470952] i2c i2c-0: Transaction (pre): CNT=00, CMD=01, ADD=94, DAT0=ff, DAT1=00
[    4.474819] i2c i2c-0: Transaction (post): CNT=00, CMD=01, ADD=94, DAT0=ff, DAT1=00
[    4.477650] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=95, DAT0=ff, DAT1=00
[    4.481676] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=95, DAT0=ff, DAT1=00
[    4.484362] i2c i2c-0: found normal entry for adapter 0, addr 0x4b
[    4.486611] i2c i2c-0: Transaction (pre): CNT=00, CMD=01, ADD=96, DAT0=ff, DAT1=00
[    4.490492] i2c i2c-0: Transaction (post): CNT=00, CMD=01, ADD=96, DAT0=ff, DAT1=00
[    4.493388] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=97, DAT0=ff, DAT1=00
[    4.497350] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=97, DAT0=ff, DAT1=00
[    4.500061] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    4.502360] i2c i2c-0: Transaction (pre): CNT=00, CMD=01, ADD=98, DAT0=ff, DAT1=00
[    4.507145] i2c i2c-0: Transaction (post): CNT=00, CMD=01, ADD=98, DAT0=ff, DAT1=00
[    4.509896] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=99, DAT0=ff, DAT1=00
[    4.514005] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=99, DAT0=ff, DAT1=00
[    4.516701] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    4.518940] i2c i2c-0: Transaction (pre): CNT=00, CMD=01, ADD=9a, DAT0=ff, DAT1=00
[    4.522817] i2c i2c-0: Transaction (post): CNT=00, CMD=01, ADD=9a, DAT0=ff, DAT1=00
[    4.525570] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=9b, DAT0=ff, DAT1=00
[    4.529679] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=9b, DAT0=ff, DAT1=00
[    4.532460] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[    4.534722] i2c i2c-0: Transaction (pre): CNT=00, CMD=01, ADD=9c, DAT0=ff, DAT1=00
[    4.538491] i2c i2c-0: Transaction (post): CNT=00, CMD=01, ADD=9c, DAT0=ff, DAT1=00
[    4.541261] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=9d, DAT0=ff, DAT1=00
[    4.545348] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=9d, DAT0=ff, DAT1=00
[    4.548041] i2c i2c-0: found normal entry for adapter 0, addr 0x4f
[    4.550266] i2c i2c-0: Transaction (pre): CNT=00, CMD=01, ADD=9e, DAT0=ff, DAT1=00
[    4.555148] i2c i2c-0: Transaction (post): CNT=00, CMD=01, ADD=9e, DAT0=ff, DAT1=00
[    4.557952] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=9f, DAT0=ff, DAT1=00
[    4.562005] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=9f, DAT0=ff, DAT1=00
[    4.564728] i2c-core: driver [lm78] registered
[    4.566330] i2c i2c-0: found normal entry for adapter 0, addr 0x28
[    4.568581] i2c i2c-0: Transaction (pre): CNT=00, CMD=01, ADD=50, DAT0=ff, DAT1=00
[    4.572777] i2c i2c-0: Transaction (post): CNT=00, CMD=01, ADD=50, DAT0=ff, DAT1=00
[    4.575539] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=51, DAT0=ff, DAT1=00
[    4.579640] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=51, DAT0=ff, DAT1=00
[    4.582460] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[    4.584711] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=52, DAT0=ff, DAT1=00
[    4.589432] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=52, DAT0=ff, DAT1=00
[    4.592206] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=53, DAT0=ff, DAT1=00
[    4.596286] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=53, DAT0=ff, DAT1=00
[    4.598990] i2c i2c-0: found normal entry for adapter 0, addr 0x2a
[    4.601251] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=54, DAT0=ff, DAT1=00
[    4.605108] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=54, DAT0=ff, DAT1=00
[    4.607885] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=55, DAT0=ff, DAT1=00
[    4.611969] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=55, DAT0=ff, DAT1=00
[    4.614843] i2c i2c-0: found normal entry for adapter 0, addr 0x2b
[    4.617105] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=56, DAT0=ff, DAT1=00
[    4.621779] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=56, DAT0=ff, DAT1=00
[    4.624538] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=57, DAT0=ff, DAT1=00
[    4.628636] scsi 0:0:0:0: Direct-Access     Linux    File-CD Gadget   0302 PQ: 0 ANSI: 2
[    4.631674] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=57, DAT0=ff, DAT1=00
[    4.634370] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.636639] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=00
[    4.640530] scsi_scan_0 (93) used greatest stack depth: 5440 bytes left
[    4.643082] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=00
[    4.645853] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=00
[    4.648566]  gadget: sending command-failure status
[    4.650412] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=00
[    4.653197] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.655499] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=00
[    4.659974] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=00
[    4.662731] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=00
[    4.666753]  gadget: sending command-failure status
[    4.668544] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=00
[    4.671222] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.673575] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=00
[    4.677603] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=00
[    4.680390] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=00
[    4.684390]  gadget: sending command-failure status
[    4.686202] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=00
[    4.688941] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[    4.691180] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5e, DAT0=ff, DAT1=00
[    4.695229] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5e, DAT0=ff, DAT1=00
[    4.697993] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5f, DAT0=ff, DAT1=00
[    4.701051] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    4.703221] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5f, DAT0=ff, DAT1=00
[    4.705988] i2c-core: driver [lm87] registered
[    4.707559] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.709839] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=00
[    4.712544]  gadget: sending command-failure status
[    4.714369] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=00
[    4.717145] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=00
[    4.721683] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=00
[    4.724458] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.726784] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=00
[    4.731470] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=00
[    4.734405] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=00
[    4.738326] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=00
[    4.741037] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.743264] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=00
[    4.747144] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=00
[    4.749982] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=00
[    4.754008] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=00
[    4.756718] i2c-core: driver [lm92] registered
[    4.758328] i2c i2c-0: found normal entry for adapter 0, addr 0x48
[    4.760573] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=90, DAT0=ff, DAT1=00
[    4.764776] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=90, DAT0=ff, DAT1=00
[    4.767529] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=91, DAT0=ff, DAT1=00
[    4.771633] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=91, DAT0=ff, DAT1=00
[    4.774470] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=91, DAT0=ff, DAT1=00
[    4.778489] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=91, DAT0=ff, DAT1=ff
[    4.781377] i2c i2c-0: Transaction (pre): CNT=0c, CMD=04, ADD=91, DAT0=ff, DAT1=ff
[    4.785348] i2c i2c-0: Transaction (post): CNT=0c, CMD=04, ADD=91, DAT0=ff, DAT1=ff
[    4.788138] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=91, DAT0=ff, DAT1=ff
[    4.792203] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=91, DAT0=ff, DAT1=ff
[    4.795089] i2c i2c-0: Transaction (pre): CNT=0c, CMD=05, ADD=91, DAT0=ff, DAT1=ff
[    4.799059] i2c i2c-0: Transaction (post): CNT=0c, CMD=05, ADD=91, DAT0=ff, DAT1=ff
[    4.801917] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=91, DAT0=ff, DAT1=ff
[    4.805917] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=91, DAT0=ff, DAT1=ff
[    4.808644] i2c i2c-0: found normal entry for adapter 0, addr 0x49
[    4.810912] i2c i2c-0: Transaction (pre): CNT=00, CMD=07, ADD=92, DAT0=ff, DAT1=ff
[    4.814734] i2c i2c-0: Transaction (post): CNT=00, CMD=07, ADD=92, DAT0=ff, DAT1=ff
[    4.817484] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=93, DAT0=ff, DAT1=ff
[    4.821593] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=93, DAT0=ff, DAT1=ff
[    4.824561] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=93, DAT0=ff, DAT1=ff
[    4.828448] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=93, DAT0=ff, DAT1=ff
[    4.831230] i2c i2c-0: Transaction (pre): CNT=0c, CMD=04, ADD=93, DAT0=ff, DAT1=ff
[    4.835306] i2c i2c-0: Transaction (post): CNT=0c, CMD=04, ADD=93, DAT0=ff, DAT1=ff
[    4.838080] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=93, DAT0=ff, DAT1=ff
[    4.842162] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=93, DAT0=ff, DAT1=ff
[    4.844981] i2c i2c-0: Transaction (pre): CNT=0c, CMD=05, ADD=93, DAT0=ff, DAT1=ff
[    4.849031] i2c i2c-0: Transaction (post): CNT=0c, CMD=05, ADD=93, DAT0=ff, DAT1=ff
[    4.851805] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=93, DAT0=ff, DAT1=ff
[    4.855876] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=93, DAT0=ff, DAT1=ff
[    4.858606] i2c i2c-0: found normal entry for adapter 0, addr 0x4a
[    4.860864] i2c i2c-0: Transaction (pre): CNT=00, CMD=07, ADD=94, DAT0=ff, DAT1=ff
[    4.864693] i2c i2c-0: Transaction (post): CNT=00, CMD=07, ADD=94, DAT0=ff, DAT1=ff
[    4.867447] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=95, DAT0=ff, DAT1=ff
[    4.871562] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=95, DAT0=ff, DAT1=ff
[    4.874407] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=95, DAT0=ff, DAT1=ff
[    4.878407] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=95, DAT0=ff, DAT1=ff
[    4.881177] i2c i2c-0: Transaction (pre): CNT=0c, CMD=04, ADD=95, DAT0=ff, DAT1=ff
[    4.885264] i2c i2c-0: Transaction (post): CNT=0c, CMD=04, ADD=95, DAT0=ff, DAT1=ff
[    4.888066] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=95, DAT0=ff, DAT1=ff
[    4.892120] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=95, DAT0=ff, DAT1=ff
[    4.894979] i2c i2c-0: Transaction (pre): CNT=0c, CMD=05, ADD=95, DAT0=ff, DAT1=ff
[    4.898987] i2c i2c-0: Transaction (post): CNT=0c, CMD=05, ADD=95, DAT0=ff, DAT1=ff
[    4.901755] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=95, DAT0=ff, DAT1=ff
[    4.905836] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=95, DAT0=ff, DAT1=ff
[    4.908569] i2c i2c-0: found normal entry for adapter 0, addr 0x4b
[    4.910808] i2c i2c-0: Transaction (pre): CNT=00, CMD=07, ADD=96, DAT0=ff, DAT1=ff
[    4.915634] i2c i2c-0: Transaction (post): CNT=00, CMD=07, ADD=96, DAT0=ff, DAT1=ff
[    4.918397] i2c i2c-0: Transaction (pre): CNT=08, CMD=01, ADD=97, DAT0=ff, DAT1=ff
[    4.922492] i2c i2c-0: Transaction (post): CNT=08, CMD=01, ADD=97, DAT0=ff, DAT1=ff
[    4.925270] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=97, DAT0=ff, DAT1=ff
[    4.929346] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=97, DAT0=ff, DAT1=ff
[    4.932157] i2c i2c-0: Transaction (pre): CNT=0c, CMD=04, ADD=97, DAT0=ff, DAT1=ff
[    4.936204] i2c i2c-0: Transaction (post): CNT=0c, CMD=04, ADD=97, DAT0=ff, DAT1=ff
[    4.938982] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=97, DAT0=ff, DAT1=ff
[    4.943067] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=97, DAT0=ff, DAT1=ff
[    4.945934] i2c i2c-0: Transaction (pre): CNT=0c, CMD=05, ADD=97, DAT0=ff, DAT1=ff
[    4.949916] i2c i2c-0: Transaction (post): CNT=0c, CMD=05, ADD=97, DAT0=ff, DAT1=ff
[    4.952693] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=97, DAT0=ff, DAT1=ff
[    4.956775] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=97, DAT0=ff, DAT1=ff
[    4.959509] i2c-core: driver [lm93] registered
[    4.961110] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.963341] i2c i2c-0: Transaction (pre): CNT=00, CMD=07, ADD=58, DAT0=ff, DAT1=ff
[    4.967555] i2c i2c-0: Transaction (post): CNT=00, CMD=07, ADD=58, DAT0=ff, DAT1=ff
[    4.970395] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=ff
[    4.974407] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=ff
[    4.977118] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    4.979234] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.981497] i2c i2c-0: Transaction (pre): CNT=00, CMD=3e, ADD=5a, DAT0=ff, DAT1=ff
[    4.986161] i2c i2c-0: Transaction (post): CNT=00, CMD=3e, ADD=5a, DAT0=ff, DAT1=ff
[    4.988935] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=5b, DAT0=ff, DAT1=ff
[    4.993031] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=5b, DAT0=ff, DAT1=ff
[    4.995794] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    4.997951] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    5.000195] i2c i2c-0: Transaction (pre): CNT=00, CMD=3e, ADD=5c, DAT0=ff, DAT1=ff
[    5.004772] i2c i2c-0: Transaction (post): CNT=00, CMD=3e, ADD=5c, DAT0=ff, DAT1=ff
[    5.007534] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=5d, DAT0=ff, DAT1=ff
[    5.011630] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=5d, DAT0=ff, DAT1=ff
[    5.014313] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    5.016426] i2c-core: driver [lm95241] registered
[    5.018148] i2c i2c-0: found normal entry for adapter 0, addr 0x19
[    5.020459] i2c i2c-0: Transaction (pre): CNT=00, CMD=3e, ADD=32, DAT0=ff, DAT1=ff
[    5.024364] i2c i2c-0: Transaction (post): CNT=00, CMD=3e, ADD=32, DAT0=ff, DAT1=ff
[    5.027130] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=33, DAT0=ff, DAT1=ff
[    5.031224] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=33, DAT0=ff, DAT1=ff
[    5.033967] i2c i2c-0: found normal entry for adapter 0, addr 0x2a
[    5.036159] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=54, DAT0=ff, DAT1=ff
[    5.039989] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=54, DAT0=ff, DAT1=ff
[    5.042791] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=55, DAT0=ff, DAT1=ff
[    5.046837] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=55, DAT0=ff, DAT1=ff
[    5.049523] i2c i2c-0: found normal entry for adapter 0, addr 0x2b
[    5.051507] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=56, DAT0=ff, DAT1=ff
[    5.055653] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=56, DAT0=ff, DAT1=ff
[    5.058369] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=57, DAT0=ff, DAT1=ff
[    5.062511] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=57, DAT0=ff, DAT1=ff
[    5.065226] i2c-core: driver [lm95245] registered
[    5.066939] i2c i2c-0: found normal entry for adapter 0, addr 0x18
[    5.069232] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=30, DAT0=ff, DAT1=ff
[    5.073285] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=30, DAT0=ff, DAT1=ff
[    5.075805] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=31, DAT0=ff, DAT1=ff
[    5.080145] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=31, DAT0=ff, DAT1=ff
[    5.082869] i2c i2c-0: found normal entry for adapter 0, addr 0x19
[    5.085135] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=32, DAT0=ff, DAT1=ff
[    5.088965] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=32, DAT0=ff, DAT1=ff
[    5.091756] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=33, DAT0=ff, DAT1=ff
[    5.095818] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=33, DAT0=ff, DAT1=ff
[    5.098550] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[    5.100807] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=52, DAT0=ff, DAT1=ff
[    5.104633] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=52, DAT0=ff, DAT1=ff
[    5.107384] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=53, DAT0=ff, DAT1=ff
[    5.111488] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=53, DAT0=ff, DAT1=ff
[    5.114171] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    5.116430] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=98, DAT0=ff, DAT1=ff
[    5.120313] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=98, DAT0=ff, DAT1=ff
[    5.123231] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=99, DAT0=ff, DAT1=ff
[    5.127164] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=99, DAT0=ff, DAT1=ff
[    5.129878] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    5.132157] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=9a, DAT0=ff, DAT1=ff
[    5.135986] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=9a, DAT0=ff, DAT1=ff
[    5.138732] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=9b, DAT0=ff, DAT1=ff
[    5.142839] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=9b, DAT0=ff, DAT1=ff
[    5.145628] i2c-core: driver [ltc4151] registered
[    5.147314] i2c-core: driver [ltc4261] registered
[    5.149026] i2c-core: driver [max1619] registered
[    5.150694] i2c i2c-0: found normal entry for adapter 0, addr 0x18
[    5.153012] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=30, DAT0=ff, DAT1=ff
[    5.157529] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=30, DAT0=ff, DAT1=ff
[    5.160283] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=31, DAT0=ff, DAT1=ff
[    5.164385] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=31, DAT0=ff, DAT1=ff
[    5.167207] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=31, DAT0=ff, DAT1=ff
[    5.171244] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=31, DAT0=ff, DAT1=ff
[    5.174010] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=31, DAT0=ff, DAT1=ff
[    5.178102] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=31, DAT0=ff, DAT1=ff
[    5.180816] i2c i2c-0: MAX1619 detection failed at 0x18
[    5.182797] i2c i2c-0: found normal entry for adapter 0, addr 0x19
[    5.185051] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=32, DAT0=ff, DAT1=ff
[    5.188875] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=32, DAT0=ff, DAT1=ff
[    5.191732] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=33, DAT0=ff, DAT1=ff
[    5.195731] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=33, DAT0=ff, DAT1=ff
[    5.198493] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=33, DAT0=ff, DAT1=ff
[    5.202591] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=33, DAT0=ff, DAT1=ff
[    5.205365] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=33, DAT0=ff, DAT1=ff
[    5.209448] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=33, DAT0=ff, DAT1=ff
[    5.212155] i2c i2c-0: MAX1619 detection failed at 0x19
[    5.214160] i2c i2c-0: found normal entry for adapter 0, addr 0x1a
[    5.216458] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=34, DAT0=ff, DAT1=ff
[    5.221203] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=34, DAT0=ff, DAT1=ff
[    5.223968] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=35, DAT0=ff, DAT1=ff
[    5.228060] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=35, DAT0=ff, DAT1=ff
[    5.230840] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=35, DAT0=ff, DAT1=ff
[    5.234917] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=35, DAT0=ff, DAT1=ff
[    5.237685] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=35, DAT0=ff, DAT1=ff
[    5.241775] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=35, DAT0=ff, DAT1=ff
[    5.244657] i2c i2c-0: MAX1619 detection failed at 0x1a
[    5.246497] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[    5.248757] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=52, DAT0=ff, DAT1=ff
[    5.252550] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=52, DAT0=ff, DAT1=ff
[    5.255303] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=53, DAT0=ff, DAT1=ff
[    5.259405] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=53, DAT0=ff, DAT1=ff
[    5.262159] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=53, DAT0=ff, DAT1=ff
[    5.266265] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=53, DAT0=ff, DAT1=ff
[    5.269101] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=53, DAT0=ff, DAT1=ff
[    5.273122] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=53, DAT0=ff, DAT1=ff
[    5.275846] i2c i2c-0: MAX1619 detection failed at 0x29
[    5.277720] i2c i2c-0: found normal entry for adapter 0, addr 0x2a
[    5.279978] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=54, DAT0=ff, DAT1=ff
[    5.283896] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=54, DAT0=ff, DAT1=ff
[    5.286646] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=55, DAT0=ff, DAT1=ff
[    5.290759] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=55, DAT0=ff, DAT1=ff
[    5.293582] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=55, DAT0=ff, DAT1=ff
[    5.297611] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=55, DAT0=ff, DAT1=ff
[    5.300371] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=55, DAT0=ff, DAT1=ff
[    5.304466] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=55, DAT0=ff, DAT1=ff
[    5.307163] i2c i2c-0: MAX1619 detection failed at 0x2a
[    5.309025] i2c i2c-0: found normal entry for adapter 0, addr 0x2b
[    5.311263] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=56, DAT0=ff, DAT1=ff
[    5.315248] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=56, DAT0=ff, DAT1=ff
[    5.318113] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=57, DAT0=ff, DAT1=ff
[    5.322106] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=57, DAT0=ff, DAT1=ff
[    5.324880] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=57, DAT0=ff, DAT1=ff
[    5.328964] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=57, DAT0=ff, DAT1=ff
[    5.331711] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=57, DAT0=ff, DAT1=ff
[    5.335816] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=57, DAT0=ff, DAT1=ff
[    5.338575] i2c i2c-0: MAX1619 detection failed at 0x2b
[    5.340491] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    5.342788] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=98, DAT0=ff, DAT1=ff
[    5.346589] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=98, DAT0=ff, DAT1=ff
[    5.349330] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=99, DAT0=ff, DAT1=ff
[    5.353446] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=99, DAT0=ff, DAT1=ff
[    5.356200] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=99, DAT0=ff, DAT1=ff
[    5.360303] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=99, DAT0=ff, DAT1=ff
[    5.363241] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=99, DAT0=ff, DAT1=ff
[    5.367160] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=99, DAT0=ff, DAT1=ff
[    5.369866] i2c i2c-0: MAX1619 detection failed at 0x4c
[    5.371743] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    5.374013] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=9a, DAT0=ff, DAT1=ff
[    5.377935] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=9a, DAT0=ff, DAT1=ff
[    5.380693] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=9b, DAT0=ff, DAT1=ff
[    5.384791] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=9b, DAT0=ff, DAT1=ff
[    5.387586] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=9b, DAT0=ff, DAT1=ff
[    5.391650] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=9b, DAT0=ff, DAT1=ff
[    5.394522] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=9b, DAT0=ff, DAT1=ff
[    5.398507] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=9b, DAT0=ff, DAT1=ff
[    5.401224] i2c i2c-0: MAX1619 detection failed at 0x4d
[    5.403094] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[    5.405354] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=9c, DAT0=ff, DAT1=ff
[    5.409281] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=9c, DAT0=ff, DAT1=ff
[    5.412042] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=9d, DAT0=ff, DAT1=ff
[    5.416143] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=9d, DAT0=ff, DAT1=ff
[    5.418929] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=9d, DAT0=ff, DAT1=ff
[    5.423004] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=9d, DAT0=ff, DAT1=ff
[    5.425903] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=9d, DAT0=ff, DAT1=ff
[    5.429853] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=9d, DAT0=ff, DAT1=ff
[    5.432548] i2c i2c-0: MAX1619 detection failed at 0x4e
[    5.434433] i2c-core: driver [max6642] registered
[    5.436132] i2c i2c-0: found normal entry for adapter 0, addr 0x48
[    5.438431] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=90, DAT0=ff, DAT1=ff
[    5.442588] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=90, DAT0=ff, DAT1=ff
[    5.445352] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=91, DAT0=ff, DAT1=ff
[    5.449446] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=91, DAT0=ff, DAT1=ff
[    5.452168] i2c i2c-0: found normal entry for adapter 0, addr 0x49
[    5.454524] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=92, DAT0=ff, DAT1=ff
[    5.458265] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=92, DAT0=ff, DAT1=ff
[    5.461028] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=93, DAT0=ff, DAT1=ff
[    5.465123] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=93, DAT0=ff, DAT1=ff
[    5.467847] i2c i2c-0: found normal entry for adapter 0, addr 0x4a
[    5.470111] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=94, DAT0=ff, DAT1=ff
[    5.473935] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=94, DAT0=ff, DAT1=ff
[    5.476712] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=95, DAT0=ff, DAT1=ff
[    5.480793] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=95, DAT0=ff, DAT1=ff
[    5.483574] i2c i2c-0: found normal entry for adapter 0, addr 0x4b
[    5.485832] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=96, DAT0=ff, DAT1=ff
[    5.490587] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=96, DAT0=ff, DAT1=ff
[    5.493330] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=97, DAT0=ff, DAT1=ff
[    5.497444] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=97, DAT0=ff, DAT1=ff
[    5.500162] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[    5.502394] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=98, DAT0=ff, DAT1=ff
[    5.506260] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=98, DAT0=ff, DAT1=ff
[    5.509014] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=99, DAT0=ff, DAT1=ff
[    5.513121] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=99, DAT0=ff, DAT1=ff
[    5.515938] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[    5.518199] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=9a, DAT0=ff, DAT1=ff
[    5.522915] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=9a, DAT0=ff, DAT1=ff
[    5.525688] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=9b, DAT0=ff, DAT1=ff
[    5.529769] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=9b, DAT0=ff, DAT1=ff
[    5.532444] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[    5.534699] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=9c, DAT0=ff, DAT1=ff
[    5.538594] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=9c, DAT0=ff, DAT1=ff
[    5.541454] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=9d, DAT0=ff, DAT1=ff
[    5.545464] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=9d, DAT0=ff, DAT1=ff
[    5.548278] i2c i2c-0: found normal entry for adapter 0, addr 0x4f
[    5.550633] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=9e, DAT0=ff, DAT1=ff
[    5.555246] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=9e, DAT0=ff, DAT1=ff
[    5.558129] i2c i2c-0: Transaction (pre): CNT=08, CMD=fe, ADD=9f, DAT0=ff, DAT1=ff
[    5.562096] i2c i2c-0: Transaction (post): CNT=08, CMD=fe, ADD=9f, DAT0=ff, DAT1=ff
[    5.564914] pc87360: PC8736x not detected, module not inserted
[    5.567101] sch56xx_common: Unsupported device id: 0xff
[    5.568999] sch56xx_common: Unsupported device id: 0xff
[    5.570943] i2c-core: driver [sht21] registered
[    5.572569] i2c-core: driver [smm665] registered
[    5.574361] i2c-core: driver [thmc50] registered
[    5.576024] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[    5.578261] i2c i2c-0: Transaction (pre): CNT=00, CMD=fe, ADD=58, DAT0=ff, DAT1=ff
[    5.582675] i2c i2c-0: Transaction (post): CNT=00, CMD=fe, ADD=58, DAT0=ff, DAT1=ff
[    5.585396] thmc50: Probing for THMC50 at 0x2C on bus 0
[    5.587317] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=ff
[    5.591485] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=ff
[    5.594264] i2c i2c-0: Transaction (pre): CNT=08, CMD=3f, ADD=59, DAT0=ff, DAT1=ff
[    5.598341] i2c i2c-0: Transaction (post): CNT=08, CMD=3f, ADD=59, DAT0=ff, DAT1=ff
[    5.601086] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=ff
[    5.605201] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=ff
[    5.607997] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[    5.610256] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=ff
[    5.614023] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=ff
[    5.616713] thmc50: Probing for THMC50 at 0x2D on bus 0
[    5.618650] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=5b, DAT0=ff, DAT1=ff
[    5.622830] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=5b, DAT0=ff, DAT1=ff
[    5.625578] i2c i2c-0: Transaction (pre): CNT=08, CMD=3f, ADD=5b, DAT0=ff, DAT1=ff
[    5.629688] i2c i2c-0: Transaction (post): CNT=08, CMD=3f, ADD=5b, DAT0=ff, DAT1=ff
[    5.632544] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=ff
[    5.636546] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=ff
[    5.639257] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    5.641519] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=ff
[    5.645362] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=ff
[    5.648041] thmc50: Probing for THMC50 at 0x2E on bus 0
[    5.649951] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=5d, DAT0=ff, DAT1=ff
[    5.654182] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=5d, DAT0=ff, DAT1=ff
[    5.657059] i2c i2c-0: Transaction (pre): CNT=08, CMD=3f, ADD=5d, DAT0=ff, DAT1=ff
[    5.661046] i2c i2c-0: Transaction (post): CNT=08, CMD=3f, ADD=5d, DAT0=ff, DAT1=ff
[    5.663967] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=ff
[    5.667891] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=ff
[    5.670613] i2c-core: driver [tmp102] registered
[    5.672400] i2c-core: driver [w83l785ts] registered
[    5.674150] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[    5.676396] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=ff
[    5.680634] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=ff
[    5.683414] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=ff
[    5.687484] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=ff
[    5.690189] i2c i2c-0: w83l785ts: Read 0xff from register 0x40.
[    5.692315] i2c i2c-0: W83L785TS-S detection failed at 0x2e
[    5.694422] i2c-core: driver [max16064] registered
[    5.696145] i2c-core: driver [max34440] registered
[    5.697877] i2c-core: driver [max8688] registered
[    5.699576] i2c-core: driver [ucd9000] registered
[    5.701271] i2c-core: driver [ucd9200] registered
[    5.703000] i2c-core: driver [zl6100] registered
[    5.704797] usbcore: registered new interface driver pcwd_usb
[    5.706891] acquirewdt: WDT driver for Acquire single board computer initialising
[    5.709605] acquirewdt: I/O address 0x0043 already in use
[    5.711522] acquirewdt: probe of acquirewdt failed with error -5
[    5.713662] advantechwdt: WDT driver for Advantech single board computer initialising
[    5.716512] advantechwdt: initialized. timeout=60 sec (nowayout=0)
[    5.718717] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    5.720629] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    5.722815] eurotechwdt: can't misc_register on minor=130
[    5.724837] ib700wdt: WDT driver for IB700 single board computer initialising
[    5.727442] ib700wdt: START method I/O 443 is not available
[    5.729485] ib700wdt: probe of ib700wdt failed with error -5
[    5.731563] sc1200wdt: build 20020303
[    5.732886] sc1200wdt: io parameter must be specified
[    5.734688] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    5.736598] sbc8360: failed to register misc device
[    5.738357] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
[    5.741759] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
[    5.744383] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
[    5.746741] w83977f_wdt: driver v1.00
[    5.748053] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[    5.750384] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    5.752594] machzwd: no ZF-Logic found
[    5.753976] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
[    5.756444] Bluetooth: Virtual HCI driver ver 1.3
[    5.758167] Bluetooth: HCI UART driver ver 2.2
[    5.759770] Bluetooth: HCI H4 protocol initialized
[    5.761502] usbcore: registered new interface driver bfusb
[    5.763473] usbcore: registered new interface driver btusb
[    5.765721] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/1.1.2.2/1.1.2.2
[    5.768579] CAPI 2.0 started up with major 68 (middleware)
[    5.770596] dss1_divert module successfully installed
[    5.772422] cpuidle: using governor ladder
[    5.774480] i2c-core: driver [BD2802] registered
[    5.776304] i2c-core: driver [lp3944] registered
[    5.778116] i2c-core: driver [lp5523] registered
[    5.779984] i2c-core: driver [leds-tca6507] registered
[    5.781985] i2c-core: driver [leds-pca955x] registered
[    5.784119] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    5.786937] usbcore: registered new interface driver usbhid
[    5.788903] usbhid: USB HID core driver
[    5.790775] usbcore: registered new interface driver asus-oled
[    5.792849] usbcore: registered new interface driver tranzport
[    5.794913] usbcore: registered new interface driver alphatrack
[    5.797026] usbcore: registered new interface driver serqt_usb2
[    5.799143] USB Serial support registered for Quatech USB to Serial Driver
[    5.801973] i2c-core: driver [ad799x] registered
[    5.803794] i2c-core: driver [adt7410] registered
[    5.805521] i2c-core: driver [ad7150] registered
[    5.807226] i2c-core: driver [ad5380] registered
[    5.808797] i2c-core: driver [ad5933] registered
[    5.810471] i2c-core: driver [tsl2563] registered
[    5.812168] i2c-core: driver [isl29018] registered
[    5.813875] i2c-core: driver [isl29028] registered
[    5.815709] i2c-core: driver [tsl2583] registered
[    5.817441] i2c-core: driver [ak8975] registered
[    5.819094] i2c-core: driver [hmc5843] registered
[    5.820793] i2c-core: driver [ade7854] registered
[    5.822545] zram: num_devices not specified. Using default: 1
[    5.824646] zram: Creating 1 devices ...
[    5.826649] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    5.828969] Copyright 2010. Beceem Communications Inc
[    5.830817] usbcore: registered new interface driver usbbcm
[    5.832695] usbcore: registered new interface driver ft1000usb
[    5.835528] logger: created 256K log 'log_main'
[    5.837406] logger: created 256K log 'log_events'
[    5.839383] logger: created 256K log 'log_radio'
[    5.841124] logger: created 256K log 'log_system'
[    5.842875] Linux telephony interface: v1.00
[    5.844569] ixj driver initialized.
[    5.845926] ozwpan ozwpan: Ozmo Devices WPAN
[    5.847476] ozwpan ozwpan: new USB bus registered, assigned bus number 2
[    5.849933] usb usb2: default language 0x0409
[    5.851608] usb usb2: udev 1, busnum 2, minor = 128
[    5.853534] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.856020] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.858395] usb usb2: Product: Ozmo Devices WPAN
[    5.860054] usb usb2: Manufacturer: Linux 3.5.0-rc1+ Ozmo WPAN
[    5.862126] usb usb2: SerialNumber: ozwpan
[    5.863689] usb usb2: usb_probe_device
[    5.865059] usb usb2: configuration #1 chosen from 1 choice
[    5.867036] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    5.868792] hub 2-0:1.0: usb_probe_interface
[    5.870040] hub 2-0:1.0: usb_probe_interface - got id
[    5.871487] hub 2-0:1.0: USB hub found
[    5.873016] hub 2-0:1.0: 8 ports detected
[    5.874408] hub 2-0:1.0: standalone hub
[    5.875878] hub 2-0:1.0: individual port power switching
[    5.877928] hub 2-0:1.0: global over-current protection
[    5.879506] hub 2-0:1.0: power on to power good time: 0ms
[    5.881060] hub 2-0:1.0: 200mA bus power budget for each child
[    5.882720] hub 2-0:1.0: local power source is good
[    5.884219] hub 2-0:1.0: no over-current condition exists
[    5.886307] hub 2-0:1.0: enabling power on all ports
[    5.888866] NET: Registered protocol family 26
[    5.890696] IPv4 over IPv4 tunneling driver
[    5.892898] gre: GRE over IPv4 demultiplexor driver
[    5.894900] ip_gre: GRE over IPv4 tunneling driver
[    5.897724] TCP: westwood registered
[    5.899207] TCP: highspeed registered
[    5.900687] TCP: vegas registered
[    5.902020] TCP: veno registered
[    5.903333] TCP: scalable registered
[    5.904872] TCP: illinois registered
[    5.906372] NET: Registered protocol family 17
[    5.908296] NET: Registered protocol family 15
[    5.910041] NET: Registered protocol family 4
[    5.911781] NET: Registered protocol family 9
[    5.913476] X.25 for Linux Version 0.2
[    5.916310] NET: Registered protocol family 6
[    5.917916] NET: Registered protocol family 3
[    5.919911] Bluetooth: RFCOMM TTY layer initialized
[    5.921891] Bluetooth: RFCOMM socket layer initialized
[    5.923738] Bluetooth: RFCOMM ver 1.11
[    5.925168] lec:lane_module_init: lec.c: initialized
[    5.927061] l2tp_core: L2TP core driver, V2.0
[    5.928848] 8021q: 802.1Q VLAN Support v1.8
[    5.930747] DCCP: Activated CCID 2 (TCP-like)
[    5.932854] sctp: Hash tables configured (established 1170 bind 1024)
[    5.935152] 9pnet: Installing 9P2000 support
[    5.936823] Key type dns_resolver registered
[    5.938571] Key type ceph registered
[    5.939873] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
[    5.942096] openvswitch: Open vSwitch switching datapath
[    5.944082] initlevel:7=late, 27 registered initcalls
[    5.946207] 
[    5.946207] printing PIC contents
[    5.947907] ... PIC  IMR: fffb
[    5.948894] ... PIC  IRR: 1053
[    5.950245] ... PIC  ISR: 0000
[    5.951467] ... PIC ELCR: 0c00
[    5.952707] printing local APIC contents on CPU#0/0:
[    5.953686] ... APIC ID:      00000000 (0)
[    5.953686] ... APIC VERSION: 00050014
[    5.953686] ... APIC TASKPRI: 00000000 (00)
[    5.953686] ... APIC PROCPRI: 00000000
[    5.953686] ... APIC LDR: 01000000
[    5.953686] ... APIC DFR: ffffffff
[    5.953686] ... APIC SPIV: 000001ff
[    5.953686] ... APIC ISR field:
[    5.953686] 0000000000000000000000000000000000000000000000000000000000000000
[    5.953686] ... APIC TMR field:
[    5.953686] 0000000000000000000000000000000000000000000000000000000000000000
[    5.953686] ... APIC IRR field:
[    5.953686] 0000000000000000000000000000000000000000000000000000000000008000
[    5.953686] ... APIC ESR: 00000000
[    5.953686] ... APIC ICR: 00000831
[    5.953686] ... APIC ICR2: 01000000
[    5.953686] ... APIC LVTT: 000200ef
[    5.953686] ... APIC LVTPC: 00010000
[    5.953686] ... APIC LVT0: 00010700
[    5.953686] ... APIC LVT1: 00000400
[    5.953686] ... APIC LVTERR: 000000fe
[    5.953686] ... APIC TMICT: 0000ef21
[    5.953686] ... APIC TMCCT: 000016c6
[    5.953686] ... APIC TDCR: 00000003
[    5.953686] 
[    5.990217] number of MP IRQ sources: 20.
[    5.991639] number of IO-APIC #2 registers: 24.
[    5.993280] testing the IO APIC.......................
[    5.995174] 
[    5.995700] IO APIC #2......
[    5.996738] .... register #00: 00000000
[    5.998152] .......    : physical APIC id: 00
[    5.999899] .......    : Delivery Type: 0
[    6.001499] .......    : LTS          : 0
[    6.003062] .... register #01: 00170011
[    6.004538] .......     : max redirection entries: 17
[    6.006509] .......     : PRQ implemented: 0
[    6.008071] .......     : IO APIC version: 11
[    6.009557] .... register #02: 00000000
[    6.010869] .......     : arbitration: 00
[    6.012280] .... IRQ redirection table:
[    6.013662]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    6.015690]  00 00  1    0    0   0   0    0    0    00
[    6.017594]  01 01  0    0    0   0   0    1    1    31
[    6.019504]  02 01  0    0    0   0   0    1    1    30
[    6.021402]  03 01  0    0    0   0   0    1    1    33
[    6.023296]  04 01  1    0    0   0   0    1    1    34
[    6.025224]  05 01  0    0    0   0   0    1    1    35
[    6.027249]  06 01  0    0    0   0   0    1    1    36
[    6.029365]  07 01  0    0    0   0   0    1    1    37
[    6.031457]  08 01  0    0    0   0   0    1    1    38
[    6.033469]  09 01  1    1    0   0   0    1    1    29
[    6.035171]  0a 01  1    1    0   0   0    1    1    41
[    6.037007]  0b 01  1    1    0   0   0    1    1    49
[    6.038856]  0c 01  0    0    0   0   0    1    1    3C
[    6.040743]  0d 01  0    0    0   0   0    1    1    3D
[    6.042625]  0e 01  0    0    0   0   0    1    1    3E
[    6.044516]  0f 01  0    0    0   0   0    1    1    3F
[    6.046387]  10 00  1    0    0   0   0    0    0    00
[    6.048278]  11 00  1    0    0   0   0    0    0    00
[    6.050162]  12 00  1    0    0   0   0    0    0    00
[    6.052100]  13 00  1    0    0   0   0    0    0    00
[    6.054154]  14 00  1    0    0   0   0    0    0    00
[    6.056197]  15 00  1    0    0   0   0    0    0    00
[    6.058127]  16 00  1    0    0   0   0    0    0    00
[    6.060056]  17 00  1    0    0   0   0    0    0    00
[    6.061811] IRQ to pin mappings:
[    6.062972] IRQ0 -> 0:2
[    6.063857] IRQ1 -> 0:1
[    6.064757] IRQ3 -> 0:3
[    6.065650] IRQ4 -> 0:4
[    6.066586] IRQ5 -> 0:5
[    6.067493] IRQ6 -> 0:6
[    6.068381] IRQ7 -> 0:7
[    6.069275] IRQ8 -> 0:8
[    6.070179] IRQ12 -> 0:12
[    6.071153] IRQ13 -> 0:13
[    6.072143] IRQ14 -> 0:14
[    6.073085] IRQ15 -> 0:15
[    6.074043] IRQ33 -> 0:9
[    6.074960] IRQ34 -> 0:10
[    6.075939] IRQ35 -> 0:11
[    6.076933] .................................... done.
[    6.079852] registered taskstats version 1
[    6.082394] hub 2-0:1.0: state 7 ports 8 chg 0000 evt 0000
[    6.084880] Key type trusted registered
[    6.086237] IMA: No TPM chip found, activating TPM-bypass!
[    6.089932] i2c-core: driver [wl1273-fm] registered
[    6.091830] rtc_cmos rtc_cmos: setting system clock to 2012-07-11 20:58:37 UTC (1342040317)
[    6.094811] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.096976] EDD information not available.
[    6.103463] Freeing unused kernel memory: 1024k freed
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[    8.062080] hub 2-0:1.0: hub_suspend
[    8.063499] usb usb2: bus auto-suspend, wakeup 1
[   14.619411] warning: process `trinity-child0' used the deprecated sysctl system call with 
[   32.792672] trinity-child0 (129): Using mlock ulimits for SHM_HUGETLB is deprecated
[   55.093218] BUG: unable to handle kernel paging request at 00007f4fa44392a0
[   55.093948] IP: [<ffffffff81456703>] strnlen+0x23/0x80
[   55.093948] PGD 0 
[   55.093948] Oops: 0000 [#1] 
[   55.093948] CPU 0 
[   55.093948] Pid: 145, comm: trinity-child0 Not tainted 3.5.0-rc1+ #4 Bochs Bochs
[   55.093948] RIP: 0010:[<ffffffff81456703>]  [<ffffffff81456703>] strnlen+0x23/0x80
[   55.093948] RSP: 0018:ffff88000ed65d38  EFLAGS: 00010206
[   55.093948] RAX: ffff88000ed65e38 RBX: ffff88000edb2000 RCX: 000000000000c0e4
[   55.093948] RDX: 00007f4fa44392a0 RSI: ffffffffffffffff RDI: 00007f4fa44392a0
[   55.093948] RBP: ffff88000ed65d38 R08: 000000000000ffff R09: 000000000000ffff
[   55.093948] R10: 0000000000000000 R11: ffff88000ed58560 R12: 00007f4fa44392a0
[   55.093948] R13: ffff88008edb1fff R14: 000000000000ffff R15: 0000000000000000
[   55.093948] FS:  00007ffb40b54700(0000) GS:ffffffff821b7000(0000) knlGS:0000000000000000
[   55.093948] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   55.093948] CR2: 00007f4fa44392a0 CR3: 000000000ed59000 CR4: 00000000000006b0
[   55.093948] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   55.093948] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   55.093948] Process trinity-child0 (pid: 145, threadinfo ffff88000ed64000, task ffff88000ed58000)
[   55.093948] Stack:
[   55.093948]  ffff88000ed65d78 ffffffff814587fc ffffffff821e9960 ffffffff82142ce5
[   55.093948]  ffff88008edb1fff ffff88000ed65e10 ffffffff82142ce5 ffff88000edb2000
[   55.093948]  ffff88000ed65df8 ffffffff81459763 ffff88000ed65da8 ffff88000ed58000
[   55.093948] Call Trace:
[   55.093948]  [<ffffffff814587fc>] string.isra.4+0x4c/0x120
[   55.093948]  [<ffffffff81459763>] vsnprintf+0x313/0x890
[   55.093948]  [<ffffffff810c0a3a>] ? param_attr_show+0x3a/0xb0
[   55.093948]  [<ffffffff8145a248>] sprintf+0x48/0x50
[   55.093948]  [<ffffffff810c0c41>] param_get_charp+0x21/0x30
[   55.093948]  [<ffffffff810c0a50>] param_attr_show+0x50/0xb0
[   55.093948]  [<ffffffff810c0778>] module_attr_show+0x28/0x40
[   55.093948]  [<ffffffff811d5300>] sysfs_read_file+0x120/0x280
[   55.093948]  [<ffffffff81163b4f>] vfs_read+0xff/0x210
[   55.093948]  [<ffffffff8116401d>] sys_read+0x5d/0xc0
[   55.093948]  [<ffffffff81bd2177>] system_call_fastpath+0x16/0x1b
[   55.093948] Code: 5d c3 66 0f 1f 44 00 00 55 48 83 05 b7 ea b2 01 01 48 85 f6 48 89 e5 74 58 48 8b 0d b0 ea b2 01 48 83 c1 01 48 89 0d a5 ea b2 01 <80> 3f 00 74 41 48 8b 05 a1 ea b2 01 48 8d 50 01 48 01 c6 48 89 
[   55.093948] RIP  [<ffffffff81456703>] strnlen+0x23/0x80
[   55.093948]  RSP <ffff88000ed65d38>
[   55.093948] CR2: 00007f4fa44392a0
[   55.177879] ---[ end trace 898e930b987f1322 ]---
[   55.181491] trinity-child0 (145) used greatest stack depth: 4792 bytes left

--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.5.0-rc1+"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.5.0-rc1 Kernel Configuration
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
CONFIG_GENERIC_GPIO=y
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
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
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
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_HOTPLUG is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

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
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
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
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_XEN=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
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
# CONFIG_SPARSEMEM_VMEMMAP is not set
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
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
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
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_ACPI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_XEN_PCIDEV_FRONTEND is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
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
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IPGRE=y
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=y
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=y
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_VEGAS is not set
CONFIG_DEFAULT_VENO=y
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="veno"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_YAM is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
# CONFIG_BT_CMTP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
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
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_CFI_INTELEXT is not set
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_XEN_BLKDEV_FRONTEND is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_SPI is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
# CONFIG_I2O_SCSI is not set
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
CONFIG_ISDN_AUDIO=y
# CONFIG_ISDN_TTY_FAX is not set
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
# CONFIG_ISDN_DRV_LOOP is not set
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=y
CONFIG_ISDN_CAPI_CAPIDRV=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
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
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_NOZOMI=y
CONFIG_ISI=y
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX3107=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=y
CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
# CONFIG_HVC_XEN is not set
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_INTEL_MID=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

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
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_ADP5520 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_TPS65910=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y
# CONFIG_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DA9052_WATCHDOG is not set
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_WM8350_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
CONFIG_EUROTECH_WDT=y
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=y
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=y
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_XEN_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_MFD_LM3533=y
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_S5M_CORE is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CONTROLLER is not set
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
CONFIG_RC_CORE=y
CONFIG_LIRC=y
CONFIG_RC_MAP=y
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
CONFIG_IR_LIRC_CODEC=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_RC_LOOPBACK is not set
# CONFIG_IR_GPIO_CIR is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_DRM is not set
CONFIG_STUB_POULSBO=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
CONFIG_HID_GENERIC=y
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
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
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_HCD_DEBUGGING=y
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
CONFIG_USB_UAS=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=y
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=y
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=y
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=y
# CONFIG_USB_SERIAL_ZIO is not set
CONFIG_USB_SERIAL_SSU100=y
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_ISP1301=y
CONFIG_USB_ATM=y
# CONFIG_USB_SPEEDTOUCH is not set
CONFIG_USB_CXACRU=y
# CONFIG_USB_UEAGLEATM is not set
CONFIG_USB_XUSBATM=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_MV_UDC=y
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_GADGET_SUPERSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_FILE_STORAGE is not set
CONFIG_USB_MASS_STORAGE=y
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
# CONFIG_RTC_DRV_M41T94 is not set
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=y
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DA9052 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_AB3100=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
# CONFIG_XEN_DEV_EVTCHN is not set
# CONFIG_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_GNTDEV=y
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PRIVCMD=y
CONFIG_STAGING=y
CONFIG_SLICOSS=y
# CONFIG_USBIP_CORE is not set
CONFIG_ECHO=y
CONFIG_ASUS_OLED=y
# CONFIG_RTS_PSTOR is not set
CONFIG_RTS5139=y
# CONFIG_RTS5139_DEBUG is not set
CONFIG_TRANZPORT=y
CONFIG_USB_SERIAL_QUATECH2=y
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#
# CONFIG_IIO_ST_HWMON is not set
CONFIG_IIO_SW_RING=y

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
CONFIG_ADIS16203=y
CONFIG_ADIS16204=y
CONFIG_ADIS16209=y
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=y
CONFIG_KXSD9=y
CONFIG_LIS3L02DQ=y
CONFIG_LIS3L02DQ_BUF_KFIFO=y
# CONFIG_LIS3L02DQ_BUF_RING_SW is not set
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7298=y
# CONFIG_AD7606 is not set
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y
# CONFIG_AD7476 is not set
CONFIG_AD7887=y
# CONFIG_AD7780 is not set
CONFIG_AD7793=y
CONFIG_AD7816=y
# CONFIG_AD7192 is not set
# CONFIG_ADT7310 is not set
CONFIG_ADT7410=y
# CONFIG_AD7280 is not set
# CONFIG_MAX1363 is not set

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
# CONFIG_AD7152 is not set
# CONFIG_AD7746 is not set

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
CONFIG_AD5380=y
# CONFIG_AD5421 is not set
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5446=y
# CONFIG_AD5504 is not set
CONFIG_AD5764=y
CONFIG_AD5791=y
# CONFIG_AD5686 is not set
# CONFIG_MAX517 is not set

#
# Direct Digital Synthesis
#
# CONFIG_AD5930 is not set
CONFIG_AD9832=y
# CONFIG_AD9834 is not set
# CONFIG_AD9850 is not set
CONFIG_AD9852=y
# CONFIG_AD9910 is not set
CONFIG_AD9951=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16130=y
CONFIG_ADIS16260=y
CONFIG_ADXRS450=y

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL2583=y
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_AK8975=y
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
CONFIG_ADE7754=y
# CONFIG_ADE7758 is not set
CONFIG_ADE7759=y
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
CONFIG_ADE7854_SPI=y

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
# CONFIG_AD2S1200 is not set
CONFIG_AD2S1210=y

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_GPIO_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_ZRAM=y
# CONFIG_ZRAM_DEBUG is not set
CONFIG_ZCACHE=y
CONFIG_ZSMALLOC=y
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
CONFIG_FT1000_USB=y

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_LIRC_STAGING is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
CONFIG_ANDROID_INTF_ALARM_DEV=y
CONFIG_PHONE=y
CONFIG_PHONE_IXJ=y
CONFIG_USB_WPAN_HCD=y
# CONFIG_IPACK_BUS is not set
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_DELL_LAPTOP=y
# CONFIG_SENSORS_HDAPS is not set
CONFIG_IBM_RTL=y
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_SAMSUNG_Q10=y

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
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Analog to digital converters
#

#
# Amplifiers
#
CONFIG_AD8366=y
# CONFIG_VME_BUS is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set

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
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_LKDTM=y
# CONFIG_FAULT_INJECTION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_IOMMU_DEBUG is not set
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_AMD=y
CONFIG_VHOST_NET=y
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y

--AhhlLboLdkugWU4S--

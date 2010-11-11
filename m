Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0KKKGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:06:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:14739 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab0KKKGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:06:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,182,1288594800"; 
   d="scan'208";a="347403014"
Date: Thu, 11 Nov 2010 18:06:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
Message-ID: <20101111100628.GA24728@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I run into this kernel panic since 2.6.27-rc1.  2.6.36 boots OK.
It's not yet fixed in 2.6.37-rc1-next-20101110. I can conveniently
test any debug patches.

Thanks,
Fengguang
---

2.6.37-rc1-next-20101110 boot log

[    0.000000] console [ttyS0] enabled, bootconsole disabled
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
[    0.000000] allocated 62914560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2667.089 MHz processor.
[    0.000027] Calibrating delay loop (skipped), value calculated using timer frequency.. 5334.17 BogoMIPS (lpj=10668356)
[    0.010966] pid_max: default: 32768 minimum: 301
[    0.018185] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.028551] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.036643] Mount-cache hash table entries: 256
[    0.042349] Initializing cgroup subsys debug
[    0.046736] Initializing cgroup subsys ns
[    0.050863] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.059901] Initializing cgroup subsys cpuacct
[    0.064470] Initializing cgroup subsys memory
[    0.069011] Initializing cgroup subsys devices
[    0.073575] Initializing cgroup subsys freezer
[    0.078138] Initializing cgroup subsys blkio
[    0.082636] CPU: Physical Processor ID: 0
[    0.086766] CPU: Processor Core ID: 0
[    0.090552] mce: CPU supports 9 MCE banks
[    0.094689] CPU0: Thermal monitoring enabled (TM1)
[    0.099608] using mwait in idle threads.
[    0.103646] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.111097] ... version:                3
[    0.115219] ... bit width:              48
[    0.119430] ... generic registers:      4
[    0.123553] ... value mask:             0000ffffffffffff
[    0.128976] ... max period:             000000007fffffff
[    0.134404] ... fixed-purpose events:   3
[    0.138524] ... event mask:             000000070000000f
[    0.145296] ACPI: Core revision 20101013
[    0.170670] ftrace: allocating 33384 entries in 131 pages
[    0.186718] Setting APIC routing to flat
[    0.191387] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.237083] CPU0: Genuine Intel(R) CPU             000  @ 2.67GHz stepping 04
[    0.352402] lockdep: fixing up alternatives.
[    0.357038] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.474876]  #2lockdep: fixing up alternatives.
[    0.590491]  #3lockdep: fixing up alternatives.
[    0.706213]  #4lockdep: fixing up alternatives.
[    0.821901]  Ok.
[    0.823855] Booting Node   1, Processors  #5lockdep: fixing up alternatives.
[    0.941664]  Ok.
[    0.943629] Booting Node   0, Processors  #6lockdep: fixing up alternatives.
[    1.061332]  Ok.
[    1.063294] Booting Node   1, Processors  #7 Ok.
[    1.177674] Brought up 8 CPUs
[    1.180753] Total of 8 processors activated (42667.62 BogoMIPS).
[    1.186932] Testing NMI watchdog ... OK.
[    6.759552] BUG: NMI Watchdog detected LOCKUP on CPU0, ip ffffffff810a8dc5, registers:
[    6.767701] CPU 0
[    6.769581] Modules linked in:
[    6.773108]
[    6.774713] Pid: 1, comm: swapper Not tainted 2.6.37-rc1-next-20101110+ #25 X8DTN/X8DTN
[    6.782880] RIP: 0010:[<ffffffff810a8dc5>]  [<ffffffff810a8dc5>] find_busiest_group+0x575/0x11f0
[    6.791890] RSP: 0018:ffff8800b33958b0  EFLAGS: 00000002
[    6.797306] RAX: 0000000000000000 RBX: ffff8800b3395b1c RCX: 0000000000000000
[    6.804535] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
[    6.811771] RBP: ffff8800b3395a50 R08: 0000000000000000 R09: ffff8800bac0e400
[    6.819007] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000001d2e80
[    6.826243] R13: 0000000000000000 R14: 00000000001d2e80 R15: 00000000001d2e80
[    6.833478] FS:  0000000000000000(0000) GS:ffff8800ba400000(0000) knlGS:0000000000000000
[    6.841731] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.847574] CR2: 0000000000000000 CR3: 00000000022c5000 CR4: 00000000000006f0
[    6.854804] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.862039] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.869274] Process swapper (pid: 1, threadinfo ffff8800b3394000, task ffff8801b9688000)
[    6.877526] Stack:
[    6.879645]  0000000000000001 ffff8800b33959f0 ffff8800b33959c0 ffff8801bfdd2e80
[    6.887457]  0000000000000007 0000000000000000 00000000001d2e80 ffff8800b3395b10
[    6.895270]  0001ffff82d44a90 0000000000000002 ffff8800ba40e0a0 00000000ffffffff
[    6.903086] Call Trace:
[    6.905646]  [<ffffffff810af1df>] load_balance+0xdf/0xa60
[    6.911146]  [<ffffffff81e28e43>] ? schedule+0xdb3/0xee0
[    6.916559]  [<ffffffff81e28f59>] schedule+0xec9/0xee0
[    6.921805]  [<ffffffff81e299cc>] schedule_timeout+0x30c/0x450
[    6.927734]  [<ffffffff81104f9b>] ? trace_hardirqs_off+0x1b/0x30
[    6.933839]  [<ffffffff810f456d>] ? local_clock+0x9d/0xb0
[    6.939342]  [<ffffffff81e2e3ec>] ? _raw_spin_unlock_irq+0x4c/0x70
[    6.945621]  [<ffffffff81e292f5>] wait_for_common+0x185/0x220
[    6.951472]  [<ffffffff810b0b60>] ? default_wake_function+0x0/0x30
[    6.957749]  [<ffffffff81e294e4>] wait_for_completion+0x24/0x30
[    6.963773]  [<ffffffff810e9f82>] kthread_create+0xc2/0x160
[    6.969445]  [<ffffffff810e2210>] ? rescuer_thread+0x0/0x2a0
[    6.975210]  [<ffffffff810a043f>] ? complete+0x2f/0x80
[    6.980448]  [<ffffffff8120d741>] ? kmem_cache_alloc_trace+0x181/0x230
[    6.987071]  [<ffffffff810e1e66>] __alloc_workqueue_key+0x436/0x7e0
[    6.993443]  [<ffffffff82665ea8>] cpuset_init_smp+0x5d/0x82
[    6.999120]  [<ffffffff826443fe>] kernel_init+0x1e7/0x337
[    7.004619]  [<ffffffff81051964>] kernel_thread_helper+0x4/0x10
[    7.010642]  [<ffffffff81e2e9d0>] ? restore_args+0x0/0x30
[    7.016140]  [<ffffffff82644217>] ? kernel_init+0x0/0x337
[    7.021638]  [<ffffffff81051960>] ? kernel_thread_helper+0x0/0x10
[    7.027826] Code: fe ff ff 83 7a 50 01 0f 84 59 03 00 00 48 89 7d c0 48 ff 05 c6 13 70 01 48 39 cf 76 0e c7 45 cc 01 00 00 00 48 ff 05 bb 13 70 01 <45> 84 c0 0f 85 c3 03 00 00 48 01 b5 10 ff ff ff 48 8b b5 d8 fe
[    7.050824] ---[ end trace 4eaa2a86a8e2da22 ]---
[    7.055548] Kernel panic - not syncing: Non maskable interrupt
[    7.061481] Pid: 1, comm: swapper Tainted: G      D     2.6.37-rc1-next-20101110+ #25
[    7.069468] Call Trace:
[    7.072019]  <NMI>  [<ffffffff81e27bd8>] panic+0xad/0x260
[    7.077581]  [<ffffffff81e2e4ad>] ? _raw_spin_unlock_irqrestore+0x9d/0xb0
[    7.084468]  [<ffffffff81e30172>] die_nmi+0x182/0x1a0
[    7.089627]  [<ffffffff81e30d8a>] nmi_watchdog_tick+0x1ea/0x290
[    7.095644]  [<ffffffff81e2f600>] do_nmi+0x230/0x450
[    7.100707]  [<ffffffff81e2ef00>] nmi+0x20/0x39
[    7.105342]  [<ffffffff810a8dc5>] ? find_busiest_group+0x575/0x11f0
[    7.111704]  <<EOE>>  [<ffffffff810af1df>] load_balance+0xdf/0xa60
[    7.118048]  [<ffffffff81e28e43>] ? schedule+0xdb3/0xee0
[    7.123461]  [<ffffffff81e28f59>] schedule+0xec9/0xee0
[    7.128700]  [<ffffffff81e299cc>] schedule_timeout+0x30c/0x450
[    7.134629]  [<ffffffff81104f9b>] ? trace_hardirqs_off+0x1b/0x30
[    7.140732]  [<ffffffff810f456d>] ? local_clock+0x9d/0xb0
[    7.146230]  [<ffffffff81e2e3ec>] ? _raw_spin_unlock_irq+0x4c/0x70
[    7.152508]  [<ffffffff81e292f5>] wait_for_common+0x185/0x220
[    7.158358]  [<ffffffff810b0b60>] ? default_wake_function+0x0/0x30
[    7.164636]  [<ffffffff81e294e4>] wait_for_completion+0x24/0x30
[    7.170658]  [<ffffffff810e9f82>] kthread_create+0xc2/0x160
[    7.176329]  [<ffffffff810e2210>] ? rescuer_thread+0x0/0x2a0
[    7.182086]  [<ffffffff810a043f>] ? complete+0x2f/0x80
[    7.187325]  [<ffffffff8120d741>] ? kmem_cache_alloc_trace+0x181/0x230
[    7.193951]  [<ffffffff810e1e66>] __alloc_workqueue_key+0x436/0x7e0
[    7.200321]  [<ffffffff82665ea8>] cpuset_init_smp+0x5d/0x82
[    7.205997]  [<ffffffff826443fe>] kernel_init+0x1e7/0x337
[    7.211495]  [<ffffffff81051964>] kernel_thread_helper+0x4/0x10
[    7.217513]  [<ffffffff81e2e9d0>] ? restore_args+0x0/0x30
[    7.223008]  [<ffffffff82644217>] ? kernel_init+0x0/0x337
[    7.228507]  [<ffffffff81051960>] ? kernel_thread_helper+0x0/0x10
[    8.259523] Rebooting in 10 seconds..


Here is the good 2.6.36 boot log:

[    0.000000] console [ttyS0] enabled, bootconsole disabled
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
[    0.000000] allocated 62914560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2666.946 MHz processor.
[    0.000029] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.89 BogoMIPS (lpj=10667784)
[    0.010968] pid_max: default: 32768 minimum: 301
[    0.018136] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.028447] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.036551] Mount-cache hash table entries: 256
[    0.042259] Initializing cgroup subsys debug
[    0.046651] Initializing cgroup subsys ns
[    0.050778] Initializing cgroup subsys cpuacct
[    0.055343] Initializing cgroup subsys memory
[    0.059890] Initializing cgroup subsys devices
[    0.064455] Initializing cgroup subsys freezer
[    0.069018] Initializing cgroup subsys blkio
[    0.073528] CPU: Physical Processor ID: 0
[    0.077654] CPU: Processor Core ID: 0
[    0.081442] mce: CPU supports 9 MCE banks
[    0.085577] CPU0: Thermal monitoring enabled (TM1)
[    0.090499] using mwait in idle threads.
[    0.094535] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.102000] ... version:                3
[    0.106127] ... bit width:              48
[    0.110336] ... generic registers:      4
[    0.114460] ... value mask:             0000ffffffffffff
[    0.119881] ... max period:             000000007fffffff
[    0.125301] ... fixed-purpose events:   3
[    0.129422] ... event mask:             000000070000000f
[    0.136074] ACPI: Core revision 20100702
[    0.161808] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.167675] ftrace: allocating 29164 entries in 115 pages
[    0.182378] Setting APIC routing to flat
[    0.187034] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.232735] CPU0: Genuine Intel(R) CPU             000  @ 2.67GHz stepping 04
[    0.348469] lockdep: fixing up alternatives.
[    0.353108] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.470839]  #2lockdep: fixing up alternatives.
[    0.586551]  #3lockdep: fixing up alternatives.
[    0.702194]  #4lockdep: fixing up alternatives.
[    0.818000]  Ok.
[    0.819963] Booting Node   1, Processors  #5lockdep: fixing up alternatives.
[    0.937624]  Ok.
[    0.939585] Booting Node   0, Processors  #6lockdep: fixing up alternatives.
[    1.057346]  Ok.
[    1.059310] Booting Node   1, Processors  #7 Ok.
[    1.173738] Brought up 8 CPUs
[    1.176823] Total of 8 processors activated (42667.31 BogoMIPS).
[    1.183001] Testing NMI watchdog ... OK.
[    1.272210] kworker/u:0 used greatest stack depth: 4920 bytes left
[    1.290096] gcov: version magic: 0x3430352a
[    1.297860] Time:  8:51:30  Date: 11/11/10
[    1.302290] NET: Registered protocol family 16
[    1.309755] ACPI: bus type pci registered
[    1.314719] dca service started, version 1.12.1
[    1.319649] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    1.330713] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    1.443250] PCI: Using configuration type 1 for base access
[    1.519850] bio: create slab <bio-0> at 0
[    1.551305] ACPI: Executed 1 blocks of module-level executable AML code
[    1.582808] ACPI: SSDT 00000000bf453018 01054 (v01    AMI      IST 00000001 MSFT 03000001)
[    1.596150] ACPI: Dynamic OEM Table Load:
[    1.600405] ACPI: SSDT (null) 01054 (v01    AMI      IST 00000001 MSFT 03000001)
[    1.616040] ACPI: Interpreter enabled
[    1.619825] ACPI: (supports S0 S4 S5)
[    1.623901] ACPI: Using IOAPIC for interrupt routing
[    1.635732] ACPI: BIOS _OSI(Linux) query ignored
[    1.697410] ACPI: No dock devices found.
[    1.701458] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.711760] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.718939] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.725677] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.732409] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.739899] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
[    1.753330] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    1.761428] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    1.768682] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
[    1.776434] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
[    1.784191] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[    1.792924] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    1.798396] pci 0000:00:02.0: PCI bridge to [bus 03-03]
[    1.804352] pci 0000:00:03.0: PCI bridge to [bus 04-04]
[    1.809791] pci 0000:00:04.0: PCI bridge to [bus 05-05]
[    1.815234] pci 0000:00:05.0: PCI bridge to [bus 06-06]
[    1.820691] pci 0000:00:06.0: PCI bridge to [bus 07-07]
[    1.826130] pci 0000:00:07.0: PCI bridge to [bus 08-08]
[    1.831569] pci 0000:00:08.0: PCI bridge to [bus 09-09]
[    1.837062] pci 0000:0a:00.0: PXH quirk detected; SHPC device MSI disabled
[    1.844228] pci 0000:0a:00.2: PXH quirk detected; SHPC device MSI disabled
[    1.851354] pci 0000:00:09.0: PCI bridge to [bus 0a-0c]
[    1.856855] pci 0000:0a:00.0: PCI bridge to [bus 0b-0b]
[    1.862559] pci 0000:0a:00.2: PCI bridge to [bus 0c-0c]
[    1.868024] pci 0000:00:0a.0: PCI bridge to [bus 0d-0d]
[    1.873705] pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
[    1.879431] pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
[    1.885114] pci 0000:00:1e.0: PCI bridge to [bus 10-10] (subtractive decode)
[    2.024362] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    2.032342] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 *11 12 14 15)
[    2.040330] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
[    2.048296] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    2.056241] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    2.064457] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    2.072675] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    2.080841] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
[    2.089860] vgaarb: device added: PCI:0000:10:01.0,decodes=io+mem,owns=io+mem,locks=none
[    2.098129] vgaarb: loaded
[    2.101687] SCSI subsystem initialized
[    2.106854] usbcore: registered new interface driver usbfs
[    2.112671] usbcore: registered new interface driver hub
[    2.118423] usbcore: registered new device driver usb
[    2.125736] ACPI: WMI: Mapper loaded
[    2.129713] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    2.136186] PCI: Using ACPI for IRQ routing
[    2.140585] pci 0000:00:16.0: no compatible bridge window for [mem 0xfffff1c000-0xfffff1ffff 64bit]
[    2.149803] pci 0000:00:16.1: no compatible bridge window for [mem 0xfffff18000-0xfffff1bfff 64bit]
[    2.159032] pci 0000:00:16.2: no compatible bridge window for [mem 0xfffff14000-0xfffff17fff 64bit]
[    2.168259] pci 0000:00:16.3: no compatible bridge window for [mem 0xfffff10000-0xfffff13fff 64bit]
[    2.177484] pci 0000:00:16.4: no compatible bridge window for [mem 0xfffff0c000-0xfffff0ffff 64bit]
[    2.186709] pci 0000:00:16.5: no compatible bridge window for [mem 0xfffff08000-0xfffff0bfff 64bit]
[    2.195933] pci 0000:00:16.6: no compatible bridge window for [mem 0xfffff04000-0xfffff07fff 64bit]
[    2.205158] pci 0000:00:16.7: no compatible bridge window for [mem 0xfffff00000-0xfffff03fff 64bit]
[    2.214452] pci 0000:00:1f.3: no compatible bridge window for [mem 0xfffff20000-0xfffff200ff 64bit]
[    2.225177] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    2.232342] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    2.237951] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    2.274033] Switching to clocksource tsc
[    2.329251] pnp: PnP ACPI init
[    2.332481] ACPI: bus type pnp registered
[    2.350652] pnp: PnP ACPI: found 14 devices
[    2.354960] ACPI: ACPI bus type pnp unregistered
[    2.359725] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    2.366466] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    2.373204] system 00:01: [mem 0xfe000000-0xfe9fffff] has been reserved
[    2.379936] system 00:01: [mem 0xfea00000-0xfea0001f] has been reserved
[    2.386675] system 00:01: [mem 0xfeb00000-0xfebfffff] has been reserved
[    2.393410] system 00:01: [mem 0xfed00400-0xfed3ffff] could not be reserved
[    2.400485] system 00:01: [mem 0xfed45000-0xfedfffff] has been reserved
[    2.407247] system 00:02: [io  0x0290-0x029f] has been reserved
[    2.413299] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    2.419349] system 00:0c: [io  0x0400-0x047f] has been reserved
[    2.425378] system 00:0c: [io  0x1180-0x119f] has been reserved
[    2.431414] system 00:0c: [io  0x0500-0x057f] could not be reserved
[    2.437793] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.444522] system 00:0c: [mem 0xfec00000-0xfecfffff] could not be reserved
[    2.451591] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    2.486165] pci 0000:00:1c.0: BAR 9: assigned [mem 0xd0000000-0xd01fffff 64bit pref]
[    2.494102] pci 0000:00:1c.4: BAR 9: assigned [mem 0xd0200000-0xd03fffff 64bit pref]
[    2.502032] pci 0000:00:16.0: BAR 0: assigned [mem 0xd0400000-0xd0403fff 64bit]
[    2.509534] pci 0000:00:16.0: BAR 0: set to [mem 0xd0400000-0xd0403fff 64bit] (PCI address [0xd0400000-0xd0403fff]
[    2.520061] pci 0000:00:16.1: BAR 0: assigned [mem 0xd0404000-0xd0407fff 64bit]
[    2.527567] pci 0000:00:16.1: BAR 0: set to [mem 0xd0404000-0xd0407fff 64bit] (PCI address [0xd0404000-0xd0407fff]
[    2.538093] pci 0000:00:16.2: BAR 0: assigned [mem 0xd0408000-0xd040bfff 64bit]
[    2.545638] pci 0000:00:16.2: BAR 0: set to [mem 0xd0408000-0xd040bfff 64bit] (PCI address [0xd0408000-0xd040bfff]
[    2.556160] pci 0000:00:16.3: BAR 0: assigned [mem 0xd040c000-0xd040ffff 64bit]
[    2.563665] pci 0000:00:16.3: BAR 0: set to [mem 0xd040c000-0xd040ffff 64bit] (PCI address [0xd040c000-0xd040ffff]
[    2.574193] pci 0000:00:16.4: BAR 0: assigned [mem 0xd0410000-0xd0413fff 64bit]
[    2.581700] pci 0000:00:16.4: BAR 0: set to [mem 0xd0410000-0xd0413fff 64bit] (PCI address [0xd0410000-0xd0413fff]
[    2.592224] pci 0000:00:16.5: BAR 0: assigned [mem 0xd0414000-0xd0417fff 64bit]
[    2.599728] pci 0000:00:16.5: BAR 0: set to [mem 0xd0414000-0xd0417fff 64bit] (PCI address [0xd0414000-0xd0417fff]
[    2.610256] pci 0000:00:16.6: BAR 0: assigned [mem 0xd0418000-0xd041bfff 64bit]
[    2.617759] pci 0000:00:16.6: BAR 0: set to [mem 0xd0418000-0xd041bfff 64bit] (PCI address [0xd0418000-0xd041bfff]
[    2.628287] pci 0000:00:16.7: BAR 0: assigned [mem 0xd041c000-0xd041ffff 64bit]
[    2.635783] pci 0000:00:16.7: BAR 0: set to [mem 0xd041c000-0xd041ffff 64bit] (PCI address [0xd041c000-0xd041ffff]
[    2.646310] pci 0000:00:1f.3: BAR 0: assigned [mem 0xd0420000-0xd04200ff 64bit]
[    2.653809] pci 0000:00:1f.3: BAR 0: set to [mem 0xd0420000-0xd04200ff 64bit] (PCI address [0xd0420000-0xd04200ff]
[    2.664331] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    2.669680] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    2.675902] pci 0000:00:01.0:   bridge window [mem 0xfb900000-0xfbafffff]
[    2.682815] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    2.689035] pci 0000:00:02.0: PCI bridge to [bus 03-03]
[    2.694381] pci 0000:00:02.0:   bridge window [io  disabled]
[    2.700165] pci 0000:00:02.0:   bridge window [mem disabled]
[    2.705946] pci 0000:00:02.0:   bridge window [mem pref disabled]
[    2.712167] pci 0000:00:03.0: PCI bridge to [bus 04-04]
[    2.717516] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    2.723739] pci 0000:00:03.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    2.730653] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    2.736872] pci 0000:00:04.0: PCI bridge to [bus 05-05]
[    2.742217] pci 0000:00:04.0:   bridge window [io  disabled]
[    2.748005] pci 0000:00:04.0:   bridge window [mem disabled]
[    2.753792] pci 0000:00:04.0:   bridge window [mem pref disabled]
[    2.760012] pci 0000:00:05.0: PCI bridge to [bus 06-06]
[    2.765359] pci 0000:00:05.0:   bridge window [io  disabled]
[    2.771143] pci 0000:00:05.0:   bridge window [mem disabled]
[    2.776924] pci 0000:00:05.0:   bridge window [mem pref disabled]
[    2.783146] pci 0000:00:06.0: PCI bridge to [bus 07-07]
[    2.788491] pci 0000:00:06.0:   bridge window [io  disabled]
[    2.794278] pci 0000:00:06.0:   bridge window [mem disabled]
[    2.800065] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    2.806289] pci 0000:00:07.0: PCI bridge to [bus 08-08]
[    2.811635] pci 0000:00:07.0:   bridge window [io  disabled]
[    2.817417] pci 0000:00:07.0:   bridge window [mem disabled]
[    2.823197] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    2.829419] pci 0000:00:08.0: PCI bridge to [bus 09-09]
[    2.834766] pci 0000:00:08.0:   bridge window [io  disabled]
[    2.840548] pci 0000:00:08.0:   bridge window [mem disabled]
[    2.847915] pci 0000:00:08.0:   bridge window [mem pref disabled]
[    2.854134] pci 0000:0a:00.0: PCI bridge to [bus 0b-0b]
[    2.859481] pci 0000:0a:00.0:   bridge window [io  disabled]
[    2.865264] pci 0000:0a:00.0:   bridge window [mem disabled]
[    2.871043] pci 0000:0a:00.0:   bridge window [mem pref disabled]
[    2.877268] pci 0000:0a:00.2: PCI bridge to [bus 0c-0c]
[    2.882616] pci 0000:0a:00.2:   bridge window [io  0xc000-0xcfff]
[    2.888844] pci 0000:0a:00.2:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    2.895751] pci 0000:0a:00.2:   bridge window [mem pref disabled]
[    2.901971] pci 0000:00:09.0: PCI bridge to [bus 0a-0c]
[    2.907322] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    2.913545] pci 0000:00:09.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    2.920457] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    2.926680] pci 0000:00:0a.0: PCI bridge to [bus 0d-0d]
[    2.932024] pci 0000:00:0a.0:   bridge window [io  disabled]
[    2.937808] pci 0000:00:0a.0:   bridge window [mem disabled]
[    2.943587] pci 0000:00:0a.0:   bridge window [mem pref disabled]
[    2.949811] pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
[    2.955160] pci 0000:00:1c.0:   bridge window [io  0xb000-0xbfff]
[    2.961382] pci 0000:00:1c.0:   bridge window [mem 0xfb600000-0xfb8fffff]
[    2.968287] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff 64bit pref]
[    2.976213] pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
[    2.981559] pci 0000:00:1c.4:   bridge window [io  0xa000-0xafff]
[    2.987783] pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    2.994696] pci 0000:00:1c.4:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
[    3.002628] pci 0000:00:1e.0: PCI bridge to [bus 10-10]
[    3.007976] pci 0000:00:1e.0:   bridge window [io  0x9000-0x9fff]
[    3.014200] pci 0000:00:1e.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
[    3.021115] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    3.029093] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.035935] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.042780] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.049628] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.056473] pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.063320] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.070168] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.077011] pci 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.083862] pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.090738] pci 0000:00:0a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.097599] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.104441] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.111449] NET: Registered protocol family 2
[    3.117599] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    3.128497] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.138916] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    3.154155] TCP: Hash tables configured (established 524288 bind 65536)
[    3.160915] TCP reno registered
[    3.164372] UDP hash table entries: 4096 (order: 7, 655360 bytes)
[    3.171824] UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes)
[    3.179829] NET: Registered protocol family 1
[    3.184801] RPC: Registered udp transport module.
[    3.189631] RPC: Registered tcp transport module.
[    3.194460] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.795961] pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    6.395952] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    6.403326] pci 0000:04:00.0: Disabling L0s
[    6.407696] pci 0000:04:00.1: Disabling L0s
[    6.412458] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    6.419015] Placing 64MB software IO TLB between ffff8800077dd000 - ffff88000b7dd000
[    6.426930] software IO TLB at phys 0x77dd000 - 0xb7dd000
[    6.447280] Machine check injector initialized
[    6.458329] microcode: CPU0 sig=0x106a4, pf=0x1, revision=0x7
[    6.464224] microcode: CPU1 sig=0x106a4, pf=0x1, revision=0x7
[    6.470088] microcode: CPU2 sig=0x106a4, pf=0x1, revision=0x7
[    6.475957] microcode: CPU3 sig=0x106a4, pf=0x1, revision=0x7
[    6.481834] microcode: CPU4 sig=0x106a4, pf=0x1, revision=0x7
[    6.487764] microcode: CPU5 sig=0x106a4, pf=0x1, revision=0x7
[    6.493660] microcode: CPU6 sig=0x106a4, pf=0x1, revision=0x7
[    6.499544] microcode: CPU7 sig=0x106a4, pf=0x1, revision=0x7
[    6.505683] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    6.514656] Scanning for low memory corruption every 60 seconds
[    6.525156] Initializing RT-Tester: OK
[    6.529349] audit: initializing netlink socket (disabled)
[    6.534923] type=2000 audit(1289465493.140:1): initialized
[    6.675807] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    6.713175] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    6.720893] fuse init (API version 7.15)
[    6.726014] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    6.740865] Btrfs loaded
[    6.743543] msgmni has been set to 11842
[    6.751724] io scheduler noop registered
[    6.755775] io scheduler deadline registered
[    6.760541] io scheduler cfq registered (default)
[    6.768089] pcieport 0000:00:01.0: ACPI _OSC control granted for 0x1c
[    6.777264] pcieport 0000:00:02.0: ACPI _OSC control granted for 0x1c
[    6.786270] pcieport 0000:00:03.0: ACPI _OSC control granted for 0x1c
[    6.795349] pcieport 0000:00:04.0: ACPI _OSC control granted for 0x1c
[    6.804427] pcieport 0000:00:05.0: ACPI _OSC control granted for 0x1c
[    6.813448] pcieport 0000:00:06.0: ACPI _OSC control granted for 0x1c
[    6.822480] pcieport 0000:00:07.0: ACPI _OSC control granted for 0x1c
[    6.831583] pcieport 0000:00:08.0: ACPI _OSC control granted for 0x1c
[    6.840949] pcieport 0000:00:09.0: ACPI _OSC control granted for 0x1c
[    6.849993] pcieport 0000:00:0a.0: ACPI _OSC control granted for 0x1c
[    6.859271] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1c
[    6.868337] pcieport 0000:00:1c.4: ACPI _OSC control granted for 0x1c
[    6.877452] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.885377] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    6.893974] ACPI: Sleep Button [SLPB]
[    6.898101] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    6.906672] ACPI: Power Button [PWRB]
[    6.910866] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    6.918453] ACPI: Power Button [PWRF]
[    7.113538] Initializing Nozomi driver 2.1d (build date: Nov 11 2010 08:01:19)
[    7.123289] Non-volatile memory driver v1.3
[    7.128719] Linux agpgart interface v0.103
[    7.133285] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    7.142439] Hangcheck: Using getrawmonotonic().
[    7.147400] [drm] Initialized drm 1.1.0 20060810
[    7.152148] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    7.159828] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    7.186938] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.213841] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    7.242813] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.269926] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   10.282277] floppy0: no floppy controllers found
[   10.298739] brd: module loaded
[   10.307319] loop: module loaded
[   10.311902] Loading iSCSI transport class v2.0-870.
[   10.319039] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   10.326291] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[   10.334660] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ccc ems sxs
[   10.382167] scsi0 : ahci
[   10.385756] scsi1 : ahci
[   10.389173] scsi2 : ahci
[   10.392600] scsi3 : ahci
[   10.396010] scsi4 : ahci
[   10.399424] scsi5 : ahci
[   10.403664] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 100
[   10.412106] ata2: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00180 irq 100
[   10.419761] ata3: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00200 irq 100
[   10.427418] ata4: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00280 irq 100
[   10.435077] ata5: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00300 irq 100
[   10.442735] ata6: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 100
[   10.462408] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[   10.469581] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   10.475773] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[   10.481810] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[   10.488240] Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
[   10.494987] Copyright (c) 2007-2009 Intel Corporation.
[   10.500321] igb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.708480] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[   10.715474] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:30:48:c6:8a:aa
[   10.722801] igb 0000:01:00.0: eth0: PBA No: 0010ff-0ff
[   10.728058] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   10.735923] igb 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   10.769084] ata5: SATA link down (SStatus 0 SControl 300)
[   10.769087] ata3: SATA link down (SStatus 0 SControl 300)
[   10.769166] ata2: SATA link down (SStatus 0 SControl 300)
[   10.769175] ata4: SATA link down (SStatus 0 SControl 300)
[   10.936188] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[   10.943178] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:c6:8a:ab
[   10.950503] igb 0000:01:00.1: eth1: PBA No: 0010ff-0ff
[   10.955753] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   10.963789] Intel(R) Virtual Function Network Driver - version 1.0.0-k0
[   10.970514] Copyright (c) 2009 Intel Corporation.
[   10.975686] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 2.0.84-k2
[   10.985266] ixgbe: Copyright (c) 1999-2010 Intel Corporation.
[   10.991259] ixgbe 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.085810] ixgbe 0000:04:00.0: Multiqueue Enabled: Rx Queue count = 8, Tx Queue count = 8
[   11.094321] ixgbe 0000:04:00.0: (PCI Express:2.5Gb/s:Width x8) 00:1b:21:29:17:d5
[   11.102026] ixgbe 0000:04:00.0: MAC: 1, PHY: 5, PBA No: e27462-006
[   11.112079] ixgbe 0000:04:00.0: Intel(R) 10 Gigabit Network Connection
[   11.118811] ixgbe 0000:04:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   11.172109] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   11.180411] ata1.00: ATA-8: ST3500320NS, SN05, max UDMA/133
[   11.186106] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   11.195415] ata1.00: configured for UDMA/133
[   11.200490] scsi 0:0:0:0: Direct-Access     ATA      ST3500320NS      SN05 PQ: 0 ANSI: 5
[   11.210551] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   11.218438] sd 0:0:0:0: [sda] Write Protect is off
[   11.223439] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.227870] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   11.254763]  sda: sda1 sda2 sda3
[   11.260356] sd 0:0:0:0: [sda] Attached SCSI disk
[   11.305356] ata6.00: ATAPI: SlimtypeDVD A  DS8A1P, CX17, max UDMA/33
[   11.311828] ata6.00: applying bridge limits
[   11.328648] ata6.00: configured for UDMA/33
[   11.413147] scsi 5:0:0:0: CD-ROM            Slimtype DVD A  DS8A1P    CX17 PQ: 0 ANSI: 5
[   12.199011] ixgbe 0000:04:00.1: Multiqueue Enabled: Rx Queue count = 8, Tx Queue count = 8
[   12.207518] ixgbe 0000:04:00.1: (PCI Express:2.5Gb/s:Width x8) 00:1b:21:29:17:d4
[   12.215222] ixgbe 0000:04:00.1: MAC: 1, PHY: 5, PBA No: e27462-006
[   12.225034] ixgbe 0000:04:00.1: Intel(R) 10 Gigabit Network Connection
[   12.231932] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   12.239187] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   12.245927] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   12.251449] Copyright (c) 2007 Atheros Corporation.
[   12.257346] jme: JMicron JMC2XX ethernet driver version 1.0.6
[   12.263868] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   12.271200] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   12.277420] e100: Copyright(c) 1999-2006 Intel Corporation
[   12.283163] e100 0000:0c:01.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
[   12.316095] e100 0000:0c:01.0: eth4: addr 0xfbd20000, irq 48, MAC addr 00:02:b3:b7:a9:b0
[   12.325938] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   12.333832] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.1.3 (June 24, 2010)
[   12.341764] sky2: driver version 1.28
[   12.350834] usbcore: registered new interface driver catc
[   12.356362] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[   12.362693] usbcore: registered new interface driver kaweth
[   12.368392] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[   12.376344] usbcore: registered new interface driver pegasus
[   12.382125] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[   12.389452] usbcore: registered new interface driver rtl8150
[   12.395549] usbcore: registered new interface driver asix
[   12.401364] usbcore: registered new interface driver cdc_ether
[   12.407607] usbcore: registered new interface driver cdc_eem
[   12.413672] usbcore: registered new interface driver dm9601
[   12.419668] usbcore: registered new interface driver smsc75xx
[   12.425853] usbcore: registered new interface driver smsc95xx
[   12.432006] usbcore: registered new interface driver gl620a
[   12.438004] usbcore: registered new interface driver net1080
[   12.444070] usbcore: registered new interface driver plusb
[   12.449922] usbcore: registered new interface driver rndis_host
[   12.456245] usbcore: registered new interface driver cdc_subset
[   12.462582] usbcore: registered new interface driver zaurus
[   12.468593] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   12.476466] usbcore: registered new interface driver int51x1
[   12.482543] usbcore: registered new interface driver ipheth
[   12.488534] usbcore: registered new interface driver sierra_net
[   12.494581] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   12.501743] winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[   12.501745]   http://www.scyld.com/network/drivers.html
[   12.516463] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[   12.523809] netconsole: local port 6665
[   12.527777] netconsole: local IP 10.0.0.0
[   12.531920] netconsole: interface 'eth0'
[   12.535973] netconsole: remote port 6666
[   12.540027] netconsole: remote IP 10.239.51.110
[   12.544689] netconsole: remote ethernet address 00:30:48:fe:19:94
[   12.550907] netconsole: device eth0 not up yet, forcing it
[   14.783453] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.36 (wfg@bee) (gcc version 4.5.0 (GCC) ) #9 SMP Thu Nov 11 08:03:59 CST 2010
[    0.000000] Command line: ip=::::wfg-ne02::dhcp netconsole=@:/eth0,6666@10.239.51.110/00:30:48:fe:19:94 panic=10 nmi_watchdog=panic,lapic unknown_nmi_panic=1 load_ramdisk=2 prompt_ramdisk=0 console=tty0 console=ttyS0,115200 earlyprintk=vga nfsroot=10.239.51.240:/nfsroot/wfg,tcp,v3,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-2.6.36
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf341000 (usable)
[    0.000000]  BIOS-e820: 00000000bf341000 - 00000000bf3c2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf3c2000 - 00000000bf3c3000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf3c3000 - 00000000bf3d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf3d4000 - 00000000bf3d5000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf3d5000 - 00000000bf3e6000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf3e6000 - 00000000bf3e9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf3e9000 - 00000000bf447000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf447000 - 00000000bf452000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf452000 - 00000000bf45d000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf45d000 - 00000000bf47b000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf47b000 - 00000000bf67e000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf67e000 - 00000000bf800000 (usable)
[    0.000000]  BIOS-e820: 00000000c0000000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] bootconsole [earlyvga0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] last_pfn = 0x1c0000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009d800 (usable)
[    0.000000]  modified: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf341000 (usable)
[    0.000000]  modified: 00000000bf341000 - 00000000bf3c2000 (ACPI NVS)
[    0.000000]  modified: 00000000bf3c2000 - 00000000bf3c3000 (ACPI data)
[    0.000000]  modified: 00000000bf3c3000 - 00000000bf3d4000 (reserved)
[    0.000000]  modified: 00000000bf3d4000 - 00000000bf3d5000 (ACPI NVS)
[    0.000000]  modified: 00000000bf3d5000 - 00000000bf3e6000 (reserved)
[    0.000000]  modified: 00000000bf3e6000 - 00000000bf3e9000 (ACPI NVS)
[    0.000000]  modified: 00000000bf3e9000 - 00000000bf447000 (reserved)
[    0.000000]  modified: 00000000bf447000 - 00000000bf452000 (ACPI data)
[    0.000000]  modified: 00000000bf452000 - 00000000bf45d000 (ACPI NVS)
[    0.000000]  modified: 00000000bf45d000 - 00000000bf47b000 (reserved)
[    0.000000]  modified: 00000000bf47b000 - 00000000bf67e000 (ACPI NVS)
[    0.000000]  modified: 00000000bf67e000 - 00000000bf800000 (usable)
[    0.000000]  modified: 00000000c0000000 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] found SMP MP-table at [ffff8800000fdf20] fdf20
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
[    0.000000] init_memory_mapping: 0000000100000000-00000001c0000000
[    0.000000] ACPI: RSDP 00000000000f03f0 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000bf450e18 0007C (v01 ALASKA    A M I 06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000bf44fd98 000F4 (v04 ALASKA    A M I 06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20100702/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xBF459F40/0x00000000BF45AE40, using 32 (20100702/tbfadt-486)
[    0.000000] ACPI: DSDT 00000000bf448018 069B4 (v01 ALASKA    A M I 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf459f40 00040
[    0.000000] ACPI: APIC 00000000bf44fc18 000E4 (v02 ALASKA    A M I 06222004 MSFT 00010013)
[    0.000000] ACPI: MCFG 00000000bf451f18 0003C (v01 A M I  OEMMCFG  06222004 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf447c18 003B0 (v01 A M I  AMI SRAT 00000000 AMI. 00000000)
[    0.000000] ACPI: SLIT 00000000bf451e98 00030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 00000000bf451e18 00038 (v01 A M I  ICH7HPET 06222004 AMI. 00000003)
[    0.000000] ACPI: EINJ 00000000bf44fa98 00130 (v01    AMI AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 00000000bf3c2c98 00210 (v01  AMIER AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 00000000bf3c2f18 000A8 (v01    AMI AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 00000000bf451d98 00030 (v01    AMI AMI BERT 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bf450d18 000C0 (v01 A M I   OEMDMAR 00000001 INTL 00000001)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] ACPI: [SRAT:0x00] ignored 8 entries of 16 found
[    0.000000] SRAT: Node 0 PXM 0 0-c0000000
[    0.000000] SRAT: Node 1 PXM 1 100000000-1c0000000
[    0.000000] Initmem setup node 0 0000000000000000-00000000c0000000
[    0.000000]   NODE_DATA [00000000038ed000 - 00000000038f1fff]
[    0.000000] Initmem setup node 1 0000000100000000-00000001c0000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001c0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bf341
[    0.000000]     0: 0x000bf67e -> 0x000bf800
[    0.000000]     1: 0x00100000 -> 0x001c0000
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 8/0x1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x03] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 9/0x3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x05] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 10/0x5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x07] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 11/0x7 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x11] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 12/0x11 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x13] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 13/0x13 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x15] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 14/0x15 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x17] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 15/0x17 ignored.
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] 16 Processors exceeds NR_CPUS limit of 8
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf341000 - 00000000bf3c2000
[    0.000000] PM: Registered nosave memory: 00000000bf3c2000 - 00000000bf3c3000
[    0.000000] PM: Registered nosave memory: 00000000bf3c3000 - 00000000bf3d4000
[    0.000000] PM: Registered nosave memory: 00000000bf3d4000 - 00000000bf3d5000
[    0.000000] PM: Registered nosave memory: 00000000bf3d5000 - 00000000bf3e6000
[    0.000000] PM: Registered nosave memory: 00000000bf3e6000 - 00000000bf3e9000
[    0.000000] PM: Registered nosave memory: 00000000bf3e9000 - 00000000bf447000
[    0.000000] PM: Registered nosave memory: 00000000bf447000 - 00000000bf452000
[    0.000000] PM: Registered nosave memory: 00000000bf452000 - 00000000bf45d000
[    0.000000] PM: Registered nosave memory: 00000000bf45d000 - 00000000bf47b000
[    0.000000] PM: Registered nosave memory: 00000000bf47b000 - 00000000bf67e000
[    0.000000] PM: Registered nosave memory: 00000000bf800000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ed1c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:2
[    0.000000] PERCPU: Embedded 477 pages/cpu @ffff880006c00000 s1921984 r8192 d23616 u2097152
[    0.000000] pcpu-alloc: s1921984 r8192 d23616 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 6 [1] 5 [1] 7
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 1548396
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ip=::::wfg-ne02::dhcp netconsole=@:/eth0,6666@10.239.51.110/00:30:48:fe:19:94 panic=10 nmi_watchdog=panic,lapic unknown_nmi_panic=1 load_ramdisk=2 prompt_ramdisk=0 console=tty0 console=ttyS0,115200 earlyprintk=vga nfsroot=10.239.51.240:/nfsroot/wfg,tcp,v3,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-2.6.36
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Subtract (74 early reservations)
[    0.000000]   #1 [0001000000 - 00032e8be0]   TEXT DATA BSS
[    0.000000]   #2 [00032e9000 - 00032e921c]             BRK
[    0.000000]   #3 [00000fdf30 - 0000100000]   BIOS reserved
[    0.000000]   #4 [00000fdf20 - 00000fdf30]    MP-table mpf
[    0.000000]   #5 [000009d800 - 00000fda10]   BIOS reserved
[    0.000000]   #6 [00000fde84 - 00000fdf20]   BIOS reserved
[    0.000000]   #7 [00000fda10 - 00000fde84]    MP-table mpc
[    0.000000]   #8 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #9 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #10 [0000100000 - 00006fe000]         PGTABLE
[    0.000000]   #11 [00032ea000 - 00038ed000]         PGTABLE
[    0.000000]   #12 [0000016000 - 0000016030]       ACPI SLIT
[    0.000000]   #13 [00038ed000 - 00038f2000]       NODE_DATA
[    0.000000]   #14 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #15 [00038f2000 - 00038f3000]         BOOTMEM
[    0.000000]   #16 [0000016040 - 0000016280]         BOOTMEM
[    0.000000]   #17 [0100005000 - 0100005240]         BOOTMEM
[    0.000000]   #18 [00040f3000 - 00040f4000]         BOOTMEM
[    0.000000]   #19 [00040f4000 - 00040f5000]         BOOTMEM
[    0.000000]   #20 [0004200000 - 0006c00000]        MEMMAP 0
[    0.000000]   #21 [0100200000 - 0102c00000]        MEMMAP 1
[    0.000000]   #22 [00038f3000 - 0003943000]         BOOTMEM
[    0.000000]   #23 [0003943000 - 0003993000]         BOOTMEM
[    0.000000]   #24 [0100005240 - 0100055240]         BOOTMEM
[    0.000000]   #25 [0003993000 - 0003994000]         BOOTMEM
[    0.000000]   #26 [00032e8c00 - 00032e8c41]         BOOTMEM
[    0.000000]   #27 [00032e8c80 - 00032e8d49]         BOOTMEM
[    0.000000]   #28 [00032e9240 - 00032e96d8]         BOOTMEM
[    0.000000]   #29 [00032e8d80 - 00032e8de8]         BOOTMEM
[    0.000000]   #30 [00032e8e00 - 00032e8e68]         BOOTMEM
[    0.000000]   #31 [00032e8e80 - 00032e8ee8]         BOOTMEM
[    0.000000]   #32 [00032e8f00 - 00032e8f68]         BOOTMEM
[    0.000000]   #33 [00032e8f80 - 00032e8fe8]         BOOTMEM
[    0.000000]   #34 [00032e9700 - 00032e9768]         BOOTMEM
[    0.000000]   #35 [00032e9780 - 00032e97e8]         BOOTMEM
[    0.000000]   #36 [00032e9800 - 00032e9868]         BOOTMEM
[    0.000000]   #37 [00032e9880 - 00032e98e8]         BOOTMEM
[    0.000000]   #38 [00032e9900 - 00032e9968]         BOOTMEM
[    0.000000]   #39 [00032e9980 - 00032e99e8]         BOOTMEM
[    0.000000]   #40 [00032e9a00 - 00032e9a68]         BOOTMEM
[    0.000000]   #41 [00032e9a80 - 00032e9ae8]         BOOTMEM
[    0.000000]   #42 [00032e9b00 - 00032e9b68]         BOOTMEM
[    0.000000]   #43 [00032e9b80 - 00032e9be8]         BOOTMEM
[    0.000000]   #44 [00032e9c00 - 00032e9c68]         BOOTMEM
[    0.000000]   #45 [00032e9c80 - 00032e9ce8]         BOOTMEM
[    0.000000]   #46 [00032e9d00 - 00032e9d68]         BOOTMEM
[    0.000000]   #47 [00032e9d80 - 00032e9de8]         BOOTMEM
[    0.000000]   #48 [00032e9e00 - 00032e9e68]         BOOTMEM
[    0.000000]   #49 [00032e9e80 - 00032e9ea0]         BOOTMEM
[    0.000000]   #50 [00032e9ec0 - 00032e9ee0]         BOOTMEM
[    0.000000]   #51 [00032e9f00 - 00032e9f20]         BOOTMEM
[    0.000000]   #52 [0003994000 - 000399413f]         BOOTMEM
[    0.000000]   #53 [0003994140 - 000399427f]         BOOTMEM
[    0.000000]   #54 [0006c00000 - 0006ddd000]         BOOTMEM
[    0.000000]   #55 [0006e00000 - 0006fdd000]         BOOTMEM
[    0.000000]   #56 [0007000000 - 00071dd000]         BOOTMEM
[    0.000000]   #57 [0007200000 - 00073dd000]         BOOTMEM
[    0.000000]   #58 [0007400000 - 00075dd000]         BOOTMEM
[    0.000000]   #59 [0007600000 - 00077dd000]         BOOTMEM
[    0.000000]   #60 [0102c00000 - 0102ddd000]         BOOTMEM
[    0.000000]   #61 [0102e00000 - 0102fdd000]         BOOTMEM
[    0.000000]   #62 [00032e9f40 - 00032e9f50]         BOOTMEM
[    0.000000]   #63 [00032e9f80 - 00032e9f90]         BOOTMEM
[    0.000000]   #64 [00032e9fc0 - 00032e9fe0]         BOOTMEM
[    0.000000]   #65 [0003996280 - 00039962c0]         BOOTMEM
[    0.000000]   #66 [00039962c0 - 0003996410]         BOOTMEM
[    0.000000]   #67 [0003996440 - 00039964c0]         BOOTMEM
[    0.000000]   #68 [00039964c0 - 0003996540]         BOOTMEM
[    0.000000]   #69 [0003996540 - 000399e540]         BOOTMEM
[    0.000000]   #70 [00077dd000 - 000b7dd000]         BOOTMEM
[    0.000000]   #71 [000399e540 - 00039be540]         BOOTMEM
[    0.000000]   #72 [00039be540 - 00039fe540]         BOOTMEM
[    0.000000]   #73 [0000017a80 - 000001fa80]         BOOTMEM
[    0.000000] Memory: 6063120k/7340032k available (12393k kernel code, 1060544k absent, 216368k reserved, 5477k data, 2836k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000]  Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:1560
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled, bootconsole disabled
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
[    0.000000] allocated 62914560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2666.946 MHz processor.
[    0.000029] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.89 BogoMIPS (lpj=10667784)
[    0.010968] pid_max: default: 32768 minimum: 301
[    0.018136] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.028447] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.036551] Mount-cache hash table entries: 256
[    0.042259] Initializing cgroup subsys debug
[    0.046651] Initializing cgroup subsys ns
[    0.050778] Initializing cgroup subsys cpuacct
[    0.055343] Initializing cgroup subsys memory
[    0.059890] Initializing cgroup subsys devices
[    0.064455] Initializing cgroup subsys freezer
[    0.069018] Initializing cgroup subsys blkio
[    0.073528] CPU: Physical Processor ID: 0
[    0.077654] CPU: Processor Core ID: 0
[    0.081442] mce: CPU supports 9 MCE banks
[    0.085577] CPU0: Thermal monitoring enabled (TM1)
[    0.090499] using mwait in idle threads.
[    0.094535] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.102000] ... version:                3
[    0.106127] ... bit width:              48
[    0.110336] ... generic registers:      4
[    0.114460] ... value mask:             0000ffffffffffff
[    0.119881] ... max period:             000000007fffffff
[    0.125301] ... fixed-purpose events:   3
[    0.129422] ... event mask:             000000070000000f
[    0.136074] ACPI: Core revision 20100702
[    0.161808] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.167675] ftrace: allocating 29164 entries in 115 pages
[    0.182378] Setting APIC routing to flat
[    0.187034] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.232735] CPU0: Genuine Intel(R) CPU             000  @ 2.67GHz stepping 04
[    0.348469] lockdep: fixing up alternatives.
[    0.353108] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.470839]  #2lockdep: fixing up alternatives.
[    0.586551]  #3lockdep: fixing up alternatives.
[    0.702194]  #4lockdep: fixing up alternatives.
[    0.818000]  Ok.
[    0.819963] Booting Node   1, Processors  #5lockdep: fixing up alternatives.
[    0.937624]  Ok.
[    0.939585] Booting Node   0, Processors  #6lockdep: fixing up alternatives.
[    1.057346]  Ok.
[    1.059310] Booting Node   1, Processors  #7 Ok.
[    1.173738] Brought up 8 CPUs
[    1.176823] Total of 8 processors activated (42667.31 BogoMIPS).
[    1.183001] Testing NMI watchdog ... OK.
[    1.272210] kworker/u:0 used greatest stack depth: 4920 bytes left
[    1.290096] gcov: version magic: 0x3430352a
[    1.297860] Time:  8:51:30  Date: 11/11/10
[    1.302290] NET: Registered protocol family 16
[    1.309755] ACPI: bus type pci registered
[    1.314719] dca service started, version 1.12.1
[    1.319649] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    1.330713] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    1.443250] PCI: Using configuration type 1 for base access
[    1.519850] bio: create slab <bio-0> at 0
[    1.551305] ACPI: Executed 1 blocks of module-level executable AML code
[    1.582808] ACPI: SSDT 00000000bf453018 01054 (v01    AMI      IST 00000001 MSFT 03000001)
[    1.596150] ACPI: Dynamic OEM Table Load:
[    1.600405] ACPI: SSDT (null) 01054 (v01    AMI      IST 00000001 MSFT 03000001)
[    1.616040] ACPI: Interpreter enabled
[    1.619825] ACPI: (supports S0 S4 S5)
[    1.623901] ACPI: Using IOAPIC for interrupt routing
[    1.635732] ACPI: BIOS _OSI(Linux) query ignored
[    1.697410] ACPI: No dock devices found.
[    1.701458] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.711760] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.718939] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.725677] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.732409] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.739899] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
[    1.753330] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    1.761428] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    1.768682] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
[    1.776434] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
[    1.784191] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[    1.792924] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    1.798396] pci 0000:00:02.0: PCI bridge to [bus 03-03]
[    1.804352] pci 0000:00:03.0: PCI bridge to [bus 04-04]
[    1.809791] pci 0000:00:04.0: PCI bridge to [bus 05-05]
[    1.815234] pci 0000:00:05.0: PCI bridge to [bus 06-06]
[    1.820691] pci 0000:00:06.0: PCI bridge to [bus 07-07]
[    1.826130] pci 0000:00:07.0: PCI bridge to [bus 08-08]
[    1.831569] pci 0000:00:08.0: PCI bridge to [bus 09-09]
[    1.837062] pci 0000:0a:00.0: PXH quirk detected; SHPC device MSI disabled
[    1.844228] pci 0000:0a:00.2: PXH quirk detected; SHPC device MSI disabled
[    1.851354] pci 0000:00:09.0: PCI bridge to [bus 0a-0c]
[    1.856855] pci 0000:0a:00.0: PCI bridge to [bus 0b-0b]
[    1.862559] pci 0000:0a:00.2: PCI bridge to [bus 0c-0c]
[    1.868024] pci 0000:00:0a.0: PCI bridge to [bus 0d-0d]
[    1.873705] pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
[    1.879431] pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
[    1.885114] pci 0000:00:1e.0: PCI bridge to [bus 10-10] (subtractive decode)
[    2.024362] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    2.032342] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 *11 12 14 15)
[    2.040330] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
[    2.048296] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    2.056241] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    2.064457] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    2.072675] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    2.080841] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
[    2.089860] vgaarb: device added: PCI:0000:10:01.0,decodes=io+mem,owns=io+mem,locks=none
[    2.098129] vgaarb: loaded
[    2.101687] SCSI subsystem initialized
[    2.106854] usbcore: registered new interface driver usbfs
[    2.112671] usbcore: registered new interface driver hub
[    2.118423] usbcore: registered new device driver usb
[    2.125736] ACPI: WMI: Mapper loaded
[    2.129713] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    2.136186] PCI: Using ACPI for IRQ routing
[    2.140585] pci 0000:00:16.0: no compatible bridge window for [mem 0xfffff1c000-0xfffff1ffff 64bit]
[    2.149803] pci 0000:00:16.1: no compatible bridge window for [mem 0xfffff18000-0xfffff1bfff 64bit]
[    2.159032] pci 0000:00:16.2: no compatible bridge window for [mem 0xfffff14000-0xfffff17fff 64bit]
[    2.168259] pci 0000:00:16.3: no compatible bridge window for [mem 0xfffff10000-0xfffff13fff 64bit]
[    2.177484] pci 0000:00:16.4: no compatible bridge window for [mem 0xfffff0c000-0xfffff0ffff 64bit]
[    2.186709] pci 0000:00:16.5: no compatible bridge window for [mem 0xfffff08000-0xfffff0bfff 64bit]
[    2.195933] pci 0000:00:16.6: no compatible bridge window for [mem 0xfffff04000-0xfffff07fff 64bit]
[    2.205158] pci 0000:00:16.7: no compatible bridge window for [mem 0xfffff00000-0xfffff03fff 64bit]
[    2.214452] pci 0000:00:1f.3: no compatible bridge window for [mem 0xfffff20000-0xfffff200ff 64bit]
[    2.225177] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    2.232342] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    2.237951] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    2.274033] Switching to clocksource tsc
[    2.329251] pnp: PnP ACPI init
[    2.332481] ACPI: bus type pnp registered
[    2.350652] pnp: PnP ACPI: found 14 devices
[    2.354960] ACPI: ACPI bus type pnp unregistered
[    2.359725] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    2.366466] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    2.373204] system 00:01: [mem 0xfe000000-0xfe9fffff] has been reserved
[    2.379936] system 00:01: [mem 0xfea00000-0xfea0001f] has been reserved
[    2.386675] system 00:01: [mem 0xfeb00000-0xfebfffff] has been reserved
[    2.393410] system 00:01: [mem 0xfed00400-0xfed3ffff] could not be reserved
[    2.400485] system 00:01: [mem 0xfed45000-0xfedfffff] has been reserved
[    2.407247] system 00:02: [io  0x0290-0x029f] has been reserved
[    2.413299] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    2.419349] system 00:0c: [io  0x0400-0x047f] has been reserved
[    2.425378] system 00:0c: [io  0x1180-0x119f] has been reserved
[    2.431414] system 00:0c: [io  0x0500-0x057f] could not be reserved
[    2.437793] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.444522] system 00:0c: [mem 0xfec00000-0xfecfffff] could not be reserved
[    2.451591] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    2.486165] pci 0000:00:1c.0: BAR 9: assigned [mem 0xd0000000-0xd01fffff 64bit pref]
[    2.494102] pci 0000:00:1c.4: BAR 9: assigned [mem 0xd0200000-0xd03fffff 64bit pref]
[    2.502032] pci 0000:00:16.0: BAR 0: assigned [mem 0xd0400000-0xd0403fff 64bit]
[    2.509534] pci 0000:00:16.0: BAR 0: set to [mem 0xd0400000-0xd0403fff 64bit] (PCI address [0xd0400000-0xd0403fff]
[    2.520061] pci 0000:00:16.1: BAR 0: assigned [mem 0xd0404000-0xd0407fff 64bit]
[    2.527567] pci 0000:00:16.1: BAR 0: set to [mem 0xd0404000-0xd0407fff 64bit] (PCI address [0xd0404000-0xd0407fff]
[    2.538093] pci 0000:00:16.2: BAR 0: assigned [mem 0xd0408000-0xd040bfff 64bit]
[    2.545638] pci 0000:00:16.2: BAR 0: set to [mem 0xd0408000-0xd040bfff 64bit] (PCI address [0xd0408000-0xd040bfff]
[    2.556160] pci 0000:00:16.3: BAR 0: assigned [mem 0xd040c000-0xd040ffff 64bit]
[    2.563665] pci 0000:00:16.3: BAR 0: set to [mem 0xd040c000-0xd040ffff 64bit] (PCI address [0xd040c000-0xd040ffff]
[    2.574193] pci 0000:00:16.4: BAR 0: assigned [mem 0xd0410000-0xd0413fff 64bit]
[    2.581700] pci 0000:00:16.4: BAR 0: set to [mem 0xd0410000-0xd0413fff 64bit] (PCI address [0xd0410000-0xd0413fff]
[    2.592224] pci 0000:00:16.5: BAR 0: assigned [mem 0xd0414000-0xd0417fff 64bit]
[    2.599728] pci 0000:00:16.5: BAR 0: set to [mem 0xd0414000-0xd0417fff 64bit] (PCI address [0xd0414000-0xd0417fff]
[    2.610256] pci 0000:00:16.6: BAR 0: assigned [mem 0xd0418000-0xd041bfff 64bit]
[    2.617759] pci 0000:00:16.6: BAR 0: set to [mem 0xd0418000-0xd041bfff 64bit] (PCI address [0xd0418000-0xd041bfff]
[    2.628287] pci 0000:00:16.7: BAR 0: assigned [mem 0xd041c000-0xd041ffff 64bit]
[    2.635783] pci 0000:00:16.7: BAR 0: set to [mem 0xd041c000-0xd041ffff 64bit] (PCI address [0xd041c000-0xd041ffff]
[    2.646310] pci 0000:00:1f.3: BAR 0: assigned [mem 0xd0420000-0xd04200ff 64bit]
[    2.653809] pci 0000:00:1f.3: BAR 0: set to [mem 0xd0420000-0xd04200ff 64bit] (PCI address [0xd0420000-0xd04200ff]
[    2.664331] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    2.669680] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    2.675902] pci 0000:00:01.0:   bridge window [mem 0xfb900000-0xfbafffff]
[    2.682815] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    2.689035] pci 0000:00:02.0: PCI bridge to [bus 03-03]
[    2.694381] pci 0000:00:02.0:   bridge window [io  disabled]
[    2.700165] pci 0000:00:02.0:   bridge window [mem disabled]
[    2.705946] pci 0000:00:02.0:   bridge window [mem pref disabled]
[    2.712167] pci 0000:00:03.0: PCI bridge to [bus 04-04]
[    2.717516] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    2.723739] pci 0000:00:03.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    2.730653] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    2.736872] pci 0000:00:04.0: PCI bridge to [bus 05-05]
[    2.742217] pci 0000:00:04.0:   bridge window [io  disabled]
[    2.748005] pci 0000:00:04.0:   bridge window [mem disabled]
[    2.753792] pci 0000:00:04.0:   bridge window [mem pref disabled]
[    2.760012] pci 0000:00:05.0: PCI bridge to [bus 06-06]
[    2.765359] pci 0000:00:05.0:   bridge window [io  disabled]
[    2.771143] pci 0000:00:05.0:   bridge window [mem disabled]
[    2.776924] pci 0000:00:05.0:   bridge window [mem pref disabled]
[    2.783146] pci 0000:00:06.0: PCI bridge to [bus 07-07]
[    2.788491] pci 0000:00:06.0:   bridge window [io  disabled]
[    2.794278] pci 0000:00:06.0:   bridge window [mem disabled]
[    2.800065] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    2.806289] pci 0000:00:07.0: PCI bridge to [bus 08-08]
[    2.811635] pci 0000:00:07.0:   bridge window [io  disabled]
[    2.817417] pci 0000:00:07.0:   bridge window [mem disabled]
[    2.823197] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    2.829419] pci 0000:00:08.0: PCI bridge to [bus 09-09]
[    2.834766] pci 0000:00:08.0:   bridge window [io  disabled]
[    2.840548] pci 0000:00:08.0:   bridge window [mem disabled]
[    2.847915] pci 0000:00:08.0:   bridge window [mem pref disabled]
[    2.854134] pci 0000:0a:00.0: PCI bridge to [bus 0b-0b]
[    2.859481] pci 0000:0a:00.0:   bridge window [io  disabled]
[    2.865264] pci 0000:0a:00.0:   bridge window [mem disabled]
[    2.871043] pci 0000:0a:00.0:   bridge window [mem pref disabled]
[    2.877268] pci 0000:0a:00.2: PCI bridge to [bus 0c-0c]
[    2.882616] pci 0000:0a:00.2:   bridge window [io  0xc000-0xcfff]
[    2.888844] pci 0000:0a:00.2:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    2.895751] pci 0000:0a:00.2:   bridge window [mem pref disabled]
[    2.901971] pci 0000:00:09.0: PCI bridge to [bus 0a-0c]
[    2.907322] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    2.913545] pci 0000:00:09.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    2.920457] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    2.926680] pci 0000:00:0a.0: PCI bridge to [bus 0d-0d]
[    2.932024] pci 0000:00:0a.0:   bridge window [io  disabled]
[    2.937808] pci 0000:00:0a.0:   bridge window [mem disabled]
[    2.943587] pci 0000:00:0a.0:   bridge window [mem pref disabled]
[    2.949811] pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
[    2.955160] pci 0000:00:1c.0:   bridge window [io  0xb000-0xbfff]
[    2.961382] pci 0000:00:1c.0:   bridge window [mem 0xfb600000-0xfb8fffff]
[    2.968287] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff 64bit pref]
[    2.976213] pci 0000:00:1c.4: PCI bridge to [bus 0f-0f]
[    2.981559] pci 0000:00:1c.4:   bridge window [io  0xa000-0xafff]
[    2.987783] pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    2.994696] pci 0000:00:1c.4:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
[    3.002628] pci 0000:00:1e.0: PCI bridge to [bus 10-10]
[    3.007976] pci 0000:00:1e.0:   bridge window [io  0x9000-0x9fff]
[    3.014200] pci 0000:00:1e.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
[    3.021115] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    3.029093] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.035935] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.042780] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.049628] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.056473] pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.063320] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.070168] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.077011] pci 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.083862] pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.090738] pci 0000:00:0a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.097599] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.104441] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.111449] NET: Registered protocol family 2
[    3.117599] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    3.128497] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.138916] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    3.154155] TCP: Hash tables configured (established 524288 bind 65536)
[    3.160915] TCP reno registered
[    3.164372] UDP hash table entries: 4096 (order: 7, 655360 bytes)
[    3.171824] UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes)
[    3.179829] NET: Registered protocol family 1
[    3.184801] RPC: Registered udp transport module.
[    3.189631] RPC: Registered tcp transport module.
[    3.194460] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.795961] pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    6.395952] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    6.403326] pci 0000:04:00.0: Disabling L0s
[    6.407696] pci 0000:04:00.1: Disabling L0s
[    6.412458] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    6.419015] Placing 64MB software IO TLB between ffff8800077dd000 - ffff88000b7dd000
[    6.426930] software IO TLB at phys 0x77dd000 - 0xb7dd000
[    6.447280] Machine check injector initialized
[    6.458329] microcode: CPU0 sig=0x106a4, pf=0x1, revision=0x7
[    6.464224] microcode: CPU1 sig=0x106a4, pf=0x1, revision=0x7
[    6.470088] microcode: CPU2 sig=0x106a4, pf=0x1, revision=0x7
[    6.475957] microcode: CPU3 sig=0x106a4, pf=0x1, revision=0x7
[    6.481834] microcode: CPU4 sig=0x106a4, pf=0x1, revision=0x7
[    6.487764] microcode: CPU5 sig=0x106a4, pf=0x1, revision=0x7
[    6.493660] microcode: CPU6 sig=0x106a4, pf=0x1, revision=0x7
[    6.499544] microcode: CPU7 sig=0x106a4, pf=0x1, revision=0x7
[    6.505683] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    6.514656] Scanning for low memory corruption every 60 seconds
[    6.525156] Initializing RT-Tester: OK
[    6.529349] audit: initializing netlink socket (disabled)
[    6.534923] type=2000 audit(1289465493.140:1): initialized
[    6.675807] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    6.713175] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    6.720893] fuse init (API version 7.15)
[    6.726014] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    6.740865] Btrfs loaded
[    6.743543] msgmni has been set to 11842
[    6.751724] io scheduler noop registered
[    6.755775] io scheduler deadline registered
[    6.760541] io scheduler cfq registered (default)
[    6.768089] pcieport 0000:00:01.0: ACPI _OSC control granted for 0x1c
[    6.777264] pcieport 0000:00:02.0: ACPI _OSC control granted for 0x1c
[    6.786270] pcieport 0000:00:03.0: ACPI _OSC control granted for 0x1c
[    6.795349] pcieport 0000:00:04.0: ACPI _OSC control granted for 0x1c
[    6.804427] pcieport 0000:00:05.0: ACPI _OSC control granted for 0x1c
[    6.813448] pcieport 0000:00:06.0: ACPI _OSC control granted for 0x1c
[    6.822480] pcieport 0000:00:07.0: ACPI _OSC control granted for 0x1c
[    6.831583] pcieport 0000:00:08.0: ACPI _OSC control granted for 0x1c
[    6.840949] pcieport 0000:00:09.0: ACPI _OSC control granted for 0x1c
[    6.849993] pcieport 0000:00:0a.0: ACPI _OSC control granted for 0x1c
[    6.859271] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1c
[    6.868337] pcieport 0000:00:1c.4: ACPI _OSC control granted for 0x1c
[    6.877452] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.885377] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    6.893974] ACPI: Sleep Button [SLPB]
[    6.898101] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    6.906672] ACPI: Power Button [PWRB]
[    6.910866] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    6.918453] ACPI: Power Button [PWRF]
[    7.113538] Initializing Nozomi driver 2.1d (build date: Nov 11 2010 08:01:19)
[    7.123289] Non-volatile memory driver v1.3
[    7.128719] Linux agpgart interface v0.103
[    7.133285] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    7.142439] Hangcheck: Using getrawmonotonic().
[    7.147400] [drm] Initialized drm 1.1.0 20060810
[    7.152148] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    7.159828] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    7.186938] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.213841] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    7.242813] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.269926] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   10.282277] floppy0: no floppy controllers found
[   10.298739] brd: module loaded
[   10.307319] loop: module loaded
[   10.311902] Loading iSCSI transport class v2.0-870.
[   10.319039] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   10.326291] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[   10.334660] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ccc ems sxs
[   10.382167] scsi0 : ahci
[   10.385756] scsi1 : ahci
[   10.389173] scsi2 : ahci
[   10.392600] scsi3 : ahci
[   10.396010] scsi4 : ahci
[   10.399424] scsi5 : ahci
[   10.403664] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 100
[   10.412106] ata2: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00180 irq 100
[   10.419761] ata3: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00200 irq 100
[   10.427418] ata4: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00280 irq 100
[   10.435077] ata5: SATA max UDMA/133 abar m2048@0xfbf00000 port 0xfbf00300 irq 100
[   10.442735] ata6: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 100
[   10.462408] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[   10.469581] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   10.475773] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[   10.481810] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[   10.488240] Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
[   10.494987] Copyright (c) 2007-2009 Intel Corporation.
[   10.500321] igb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.708480] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[   10.715474] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:30:48:c6:8a:aa
[   10.722801] igb 0000:01:00.0: eth0: PBA No: 0010ff-0ff
[   10.728058] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   10.735923] igb 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   10.769084] ata5: SATA link down (SStatus 0 SControl 300)
[   10.769087] ata3: SATA link down (SStatus 0 SControl 300)
[   10.769166] ata2: SATA link down (SStatus 0 SControl 300)
[   10.769175] ata4: SATA link down (SStatus 0 SControl 300)
[   10.936188] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[   10.943178] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:c6:8a:ab
[   10.950503] igb 0000:01:00.1: eth1: PBA No: 0010ff-0ff
[   10.955753] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   10.963789] Intel(R) Virtual Function Network Driver - version 1.0.0-k0
[   10.970514] Copyright (c) 2009 Intel Corporation.
[   10.975686] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 2.0.84-k2
[   10.985266] ixgbe: Copyright (c) 1999-2010 Intel Corporation.
[   10.991259] ixgbe 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.085810] ixgbe 0000:04:00.0: Multiqueue Enabled: Rx Queue count = 8, Tx Queue count = 8
[   11.094321] ixgbe 0000:04:00.0: (PCI Express:2.5Gb/s:Width x8) 00:1b:21:29:17:d5
[   11.102026] ixgbe 0000:04:00.0: MAC: 1, PHY: 5, PBA No: e27462-006
[   11.112079] ixgbe 0000:04:00.0: Intel(R) 10 Gigabit Network Connection
[   11.118811] ixgbe 0000:04:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   11.172109] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   11.180411] ata1.00: ATA-8: ST3500320NS, SN05, max UDMA/133
[   11.186106] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   11.195415] ata1.00: configured for UDMA/133
[   11.200490] scsi 0:0:0:0: Direct-Access     ATA      ST3500320NS      SN05 PQ: 0 ANSI: 5
[   11.210551] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   11.218438] sd 0:0:0:0: [sda] Write Protect is off
[   11.223439] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.227870] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   11.254763]  sda: sda1 sda2 sda3
[   11.260356] sd 0:0:0:0: [sda] Attached SCSI disk
[   11.305356] ata6.00: ATAPI: SlimtypeDVD A  DS8A1P, CX17, max UDMA/33
[   11.311828] ata6.00: applying bridge limits
[   11.328648] ata6.00: configured for UDMA/33
[   11.413147] scsi 5:0:0:0: CD-ROM            Slimtype DVD A  DS8A1P    CX17 PQ: 0 ANSI: 5
[   12.199011] ixgbe 0000:04:00.1: Multiqueue Enabled: Rx Queue count = 8, Tx Queue count = 8
[   12.207518] ixgbe 0000:04:00.1: (PCI Express:2.5Gb/s:Width x8) 00:1b:21:29:17:d4
[   12.215222] ixgbe 0000:04:00.1: MAC: 1, PHY: 5, PBA No: e27462-006
[   12.225034] ixgbe 0000:04:00.1: Intel(R) 10 Gigabit Network Connection
[   12.231932] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   12.239187] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   12.245927] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   12.251449] Copyright (c) 2007 Atheros Corporation.
[   12.257346] jme: JMicron JMC2XX ethernet driver version 1.0.6
[   12.263868] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   12.271200] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   12.277420] e100: Copyright(c) 1999-2006 Intel Corporation
[   12.283163] e100 0000:0c:01.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
[   12.316095] e100 0000:0c:01.0: eth4: addr 0xfbd20000, irq 48, MAC addr 00:02:b3:b7:a9:b0
[   12.325938] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   12.333832] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.1.3 (June 24, 2010)
[   12.341764] sky2: driver version 1.28
[   12.350834] usbcore: registered new interface driver catc
[   12.356362] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[   12.362693] usbcore: registered new interface driver kaweth
[   12.368392] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[   12.376344] usbcore: registered new interface driver pegasus
[   12.382125] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[   12.389452] usbcore: registered new interface driver rtl8150
[   12.395549] usbcore: registered new interface driver asix
[   12.401364] usbcore: registered new interface driver cdc_ether
[   12.407607] usbcore: registered new interface driver cdc_eem
[   12.413672] usbcore: registered new interface driver dm9601
[   12.419668] usbcore: registered new interface driver smsc75xx
[   12.425853] usbcore: registered new interface driver smsc95xx
[   12.432006] usbcore: registered new interface driver gl620a
[   12.438004] usbcore: registered new interface driver net1080
[   12.444070] usbcore: registered new interface driver plusb
[   12.449922] usbcore: registered new interface driver rndis_host
[   12.456245] usbcore: registered new interface driver cdc_subset
[   12.462582] usbcore: registered new interface driver zaurus
[   12.468593] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   12.476466] usbcore: registered new interface driver int51x1
[   12.482543] usbcore: registered new interface driver ipheth
[   12.488534] usbcore: registered new interface driver sierra_net
[   12.494581] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   12.501743] winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[   12.501745]   http://www.scyld.com/network/drivers.html
[   12.516463] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[   12.523809] netconsole: local port 6665
[   12.527777] netconsole: local IP 10.0.0.0
[   12.531920] netconsole: interface 'eth0'
[   12.535973] netconsole: remote port 6666
[   12.540027] netconsole: remote IP 10.239.51.110
[   12.544689] netconsole: remote ethernet address 00:30:48:fe:19:94
[   12.550907] netconsole: device eth0 not up yet, forcing it
[   14.783453] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   19.081479] console [netcon0] enabled
[   19.085278] netconsole: network logging started
[   19.092026] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   19.098805] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   19.106103] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   19.111829] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   19.119490] ehci_hcd 0000:00:1a.7: debug port 1
[   19.128131] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbf02000
[   19.148050] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   19.154237] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   19.161143] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.168543] usb usb1: Product: EHCI Host Controller
[   19.173540] usb usb1: Manufacturer: Linux 2.6.36 ehci_hcd
[   19.179055] usb usb1: SerialNumber: 0000:00:1a.7
[   19.184932] hub 1-0:1.0: USB hub found
[   19.188887] hub 1-0:1.0: 6 ports detected
[   19.193653] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   19.200943] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   19.206315] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   19.213952] ehci_hcd 0000:00:1d.7: debug port 1
[   19.222533] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbf01000
[   19.243791] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   19.249808] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   19.256714] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.264118] usb usb2: Product: EHCI Host Controller
[   19.269112] usb usb2: Manufacturer: Linux 2.6.36 ehci_hcd
[   19.274628] usb usb2: SerialNumber: 0000:00:1d.7
[   19.280118] hub 2-0:1.0: USB hub found
[   19.284009] hub 2-0:1.0: 6 ports detected
[   19.288766] uhci_hcd: USB Universal Host Controller Interface driver
[   19.295653] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   19.303114] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   19.303147] hub 1-0:1.0: over-current change on port 4
[   19.313744] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   19.321327] uhci_hcd 0000:00:1a.0: detected 2 ports
[   19.326393] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0c0
[   19.332406] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   19.339310] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.346716] usb usb3: Product: UHCI Host Controller
[   19.351720] usb usb3: Manufacturer: Linux 2.6.36 uhci_hcd
[   19.357236] usb usb3: SerialNumber: 0000:00:1a.0
[   19.362677] hub 3-0:1.0: USB hub found
[   19.366574] hub 3-0:1.0: 2 ports detected
[   19.371096] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   19.378366] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   19.383748] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
[   19.391481] uhci_hcd 0000:00:1a.2: detected 2 ports
[   19.396587] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000f0a0
[   19.402592] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   19.403364] hub 1-0:1.0: over-current change on port 6
[   19.414746] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.422147] usb usb4: Product: UHCI Host Controller
[   19.427152] usb usb4: Manufacturer: Linux 2.6.36 uhci_hcd
[   19.432667] usb usb4: SerialNumber: 0000:00:1a.2
[   19.438201] hub 4-0:1.0: USB hub found
[   19.442103] hub 4-0:1.0: 2 ports detected
[   19.446641] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   19.453913] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   19.459288] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   19.466872] uhci_hcd 0000:00:1d.0: detected 2 ports
[   19.471908] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[   19.477898] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   19.484807] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.492290] usb usb5: Product: UHCI Host Controller
[   19.497300] usb usb5: Manufacturer: Linux 2.6.36 uhci_hcd
[   19.502816] usb usb5: SerialNumber: 0000:00:1d.0
[   19.508291] hub 5-0:1.0: USB hub found
[   19.512190] hub 5-0:1.0: 2 ports detected
[   19.516695] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   19.523964] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   19.529341] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   19.536926] uhci_hcd 0000:00:1d.1: detected 2 ports
[   19.541960] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[   19.547989] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   19.554896] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.562300] usb usb6: Product: UHCI Host Controller
[   19.567303] usb usb6: Manufacturer: Linux 2.6.36 uhci_hcd
[   19.572818] usb usb6: SerialNumber: 0000:00:1d.1
[   19.578288] hub 6-0:1.0: USB hub found
[   19.582186] hub 6-0:1.0: 2 ports detected
[   19.586699] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   19.593967] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   19.599339] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   19.606991] uhci_hcd 0000:00:1d.2: detected 2 ports
[   19.612033] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[   19.618099] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   19.625014] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.632413] usb usb7: Product: UHCI Host Controller
[   19.637408] usb usb7: Manufacturer: Linux 2.6.36 uhci_hcd
[   19.642924] usb usb7: SerialNumber: 0000:00:1d.2
[   19.648402] hub 7-0:1.0: USB hub found
[   19.652297] hub 7-0:1.0: 2 ports detected
[   19.657088] Initializing USB Mass Storage driver...
[   19.662418] usbcore: registered new interface driver usb-storage
[   19.668551] USB Mass Storage support registered.
[   19.673747] usbcore: registered new interface driver libusual
[   19.679891] usbcore: registered new interface driver ums-alauda
[   19.686291] usbcore: registered new interface driver ums-cypress
[   19.692716] usbcore: registered new interface driver ums-datafab
[   19.699127] usbcore: registered new interface driver ums-freecom
[   19.705541] usbcore: registered new interface driver ums-isd200
[   19.711861] usbcore: registered new interface driver ums-jumpshot
[   19.718575] usbcore: registered new interface driver ums-karma
[   19.724852] usbcore: registered new interface driver ums-onetouch
[   19.731343] usbcore: registered new interface driver ums-sddr09
[   19.737672] usbcore: registered new interface driver ums-sddr55
[   19.743996] usbcore: registered new interface driver ums-usbat
[   19.750587] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   19.760981] serio: i8042 KBD port at 0x60,0x64 irq 1
[   19.766114] serio: i8042 AUX port at 0x60,0x64 irq 12
[   19.772540] mice: PS/2 mouse device common for all mice
[   19.780615] rtc_cmos 00:08: RTC can wake from S4
[   19.785816] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[   19.792082] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[   19.799127] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   19.805533] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[   19.812996] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   19.819132] iTCO_vendor_support: vendor-support=0
[   19.823955] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   19.826339] usb 5-1: new full speed USB device using uhci_hcd and address 2
[   19.845846] cpuidle: using governor ladder
[   19.867650] cpuidle: using governor menu
[   19.871729] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   19.877819] ioatdma 0000:00:16.0: can't derive routing for PCI INT A
[   19.884320] ioatdma 0000:00:16.0: PCI INT A: no GSI
[   19.893662] igb 0000:01:00.0: DCA enabled
[   19.898249] igb 0000:01:00.1: DCA enabled
[   19.902487] ioatdma 0000:00:16.1: can't derive routing for PCI INT B
[   19.908956] ioatdma 0000:00:16.1: PCI INT B: no GSI
[   19.916924] ioatdma 0000:00:16.2: can't derive routing for PCI INT C
[   19.923394] ioatdma 0000:00:16.2: PCI INT C: no GSI
[   19.930525] ioatdma 0000:00:16.3: can't derive routing for PCI INT D
[   19.937014] ioatdma 0000:00:16.3: PCI INT D: no GSI
[   19.944272] ioatdma 0000:00:16.4: can't derive routing for PCI INT A
[   19.950763] ioatdma 0000:00:16.4: PCI INT A: no GSI
[   19.957775] ioatdma 0000:00:16.5: can't derive routing for PCI INT B
[   19.964256] ioatdma 0000:00:16.5: PCI INT B: no GSI
[   19.971721] ioatdma 0000:00:16.6: can't derive routing for PCI INT C
[   19.975607] usb 5-1: New USB device found, idVendor=0557, idProduct=8021
[   19.975609] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   19.978997] hub 5-1:1.0: USB hub found
[   19.980610] hub 5-1:1.0: 4 ports detected
[   20.000287] ioatdma 0000:00:16.6: PCI INT C: no GSI
[   20.007412] ioatdma 0000:00:16.7: can't derive routing for PCI INT D
[   20.013901] ioatdma 0000:00:16.7: PCI INT D: no GSI
[   20.022312] usbcore: registered new interface driver hiddev
[   20.028311] usbcore: registered new interface driver usbhid
[   20.034023] usbhid: USB HID core driver
[   20.039530] dell-wmi: No known WMI GUID found
[   20.044020] acer-wmi: Acer Laptop ACPI-WMI Extras
[   20.048852] acer-wmi: No or unsupported WMI interface, unable to load
[   20.057302] usbcore: registered new interface driver snd-usb-audio
[   20.063905] usbcore: registered new interface driver snd-ua101
[   20.070181] usbcore: registered new interface driver snd-usb-usx2y
[   20.076785] usbcore: registered new interface driver snd-usb-us122l
[   20.083476] usbcore: registered new interface driver snd-usb-caiaq
[   20.089787] ALSA device list:
[   20.092868]   No soundcards found.
[   20.096926] oprofile: using NMI interrupt.
[   20.101217] netem: version 1.2
[   20.106201] TCP bic registered
[   20.109370] TCP cubic registered
[   20.112729] TCP westwood registered
[   20.116343] TCP highspeed registered
[   20.120042] TCP hybla registered
[   20.123396] TCP htcp registered
[   20.126666] TCP vegas registered
[   20.131604] TCP veno registered
[   20.134875] TCP scalable registered
[   20.138488] TCP lp registered
[   20.141584] TCP yeah registered
[   20.144838] TCP illinois registered
[   20.148460] Initializing XFRM netlink socket
[   20.152890] NET: Registered protocol family 17
[   20.157599] NET: Registered protocol family 15
[   20.173733] registered taskstats version 1
[   20.179492]   Magic number: 2:44:877
[   20.183273] tty ptyx1: hash matches
[   20.187059] rtc_cmos 00:08: setting system clock to 2010-11-11 08:51:48 UTC (1289465508)
[   20.262851] usb 5-1.1: new low speed USB device using uhci_hcd and address 3
[   20.451365] usb 5-1.1: New USB device found, idVendor=0557, idProduct=2261
[   20.458366] usb 5-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   20.465856] usb 5-1.1: Product: CS1716A V1.0.098
[   20.470591] usb 5-1.1: Manufacturer: ATEN International Co. Ltd
[   20.508183] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.0/input/input3
[   20.521334] generic-usb 0003:0557:2261.0001: input: USB HID v1.00 Keyboard [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.1/input0
[   20.568543] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.1/input/input4
[   20.581404] generic-usb 0003:0557:2261.0002: input: USB HID v1.00 Device [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.1/input1
[   20.613658] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.2/input/input5
[   20.626932] generic-usb 0003:0557:2261.0003: input: USB HID v1.10 Mouse [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.1/input2
[   21.925083] Sending DHCP requests ., OK
[   21.949010] IP-Config: Got DHCP answer from 192.168.1.209, my address is 192.168.1.31
[   23.476053] IP-Config: Complete:
[   23.479185]      device=eth0, addr=192.168.1.31, mask=255.255.255.0, gw=192.168.1.1,
[   23.487332]      host=lkp-ne02, domain=tsp.org, nis-domain=(none),
[   23.493701]      bootserver=192.168.1.209, rootserver=10.239.51.240, rootpath=
[   23.502734] Looking up port of RPC 100003/3 on 10.239.51.240
[   23.515863] Looking up port of RPC 100005/3 on 10.239.51.240
[   23.541304] VFS: Mounted root (nfs filesystem) on device 0:15.
[   23.547503] debug: unmapping init memory ffffffff82175000..ffffffff8243a000
INIT: version 2.86 booting

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2BBNwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:52:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54840 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab2BBNwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:52:16 -0500
Date: Thu, 2 Feb 2012 14:51:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
Message-ID: <20120202135154.GA10315@elte.hu>
References: <20120128160925.275163704@goodmis.org>
 <20120130144857.GA22013@elte.hu>
 <1327936060.22710.165.camel@gandalf.stny.rr.com>
 <20120131194813.GA12074@elte.hu>
 <1328072925.5882.57.camel@gandalf.stny.rr.com>
 <20120201080539.GA11770@elte.hu>
 <1328109697.5882.65.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328109697.5882.65.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2012-02-01 at 09:05 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > It would be better to make this a regular commit, this kind of 
> > diagnostics obviously makes sense. That way i could pull in your 
> > updated branch for more testing.
> 
> 
> Ingo,
> 
> I added the below patch on top of my previous pull request. If 
> you run this on the box that failed, it should give us a 
> little more info.

Ok, here's the new debug output:

[    0.000000] Unexpected op at enqueue_task_fair+0xab/0x1fb [ffffffff81078a8d] (0f 1f 44 00 00) arch/x86/kernel/jump_label.c:74
PANIC: early exception 06 rip 10:ffffffff81a1d5f5 error 0 cr2 f06f53

(below is the full bootlog.)

Thanks,

	Ingo

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-rc2-tip+ (mingo@earth5) (gcc version 4.7.0 20120112 (Red Hat 4.7.0-0.6) (GCC) ) #171448 SMP Thu Feb 2 13:22:44 CET 2012
[    0.000000] Command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=1 panic=1 3
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000f5680] f5680
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009d000] 9d000 size 8192
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 1fdfe000-20000000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000003fff0000
[    0.000000] Initmem setup node 0 0000000000000000-000000003fff0000
[    0.000000]   NODE_DATA [000000003ffe1000 - 000000003ffeffff]
[    0.000000]  [ffffea0000000000-ffffea0000ffffff] PMD -> [ffff88003e600000-ffff88003f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262015
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 2 pages reserved
[    0.000000]   DMA zone: 3917 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 4032 pages used for memmap
[    0.000000]   DMA32 zone: 254000 pages, LIFO batch:31
[    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000] MPTABLE: OEM ID: OEM00000
[    0.000000] MPTABLE: Product ID: PROD00000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88003fc00000 s78224 r0 d24176 u1048576
[    0.000000] pcpu-alloc: s78224 r0 d24176 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 257917
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=1 panic=1 3
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] Unexpected op at enqueue_task_fair+0xab/0x1fb [ffffffff81078a8d] (0f 1f 44 00 00) arch/x86/kernel/jump_label.c:74
PANIC: early exception 06 rip 10:ffffffff81a1d5f5 error 0 cr2 f06f53
[    0.000000] Pid: 0, comm: swapper Not tainted 3.3.0-rc2-tip+ #171448
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81a1d5f5>] ? bug_at+0x45/0x47
[    0.000000]  [<ffffffff81078a8d>] ? enqueue_task_fair+0xab/0x1fb
[    0.000000]  [<ffffffff8200619e>] early_idt_handler+0x5e/0x71
[    0.000000]  [<ffffffff81a1d5f5>] ? bug_at+0x45/0x47
[    0.000000]  [<ffffffff81a1d5f5>] ? bug_at+0x45/0x47
[    0.000000]  [<ffffffff81025ad0>] __jump_label_transform+0xc8/0x169
[    0.000000]  [<ffffffff820088dc>] arch_jump_label_transform_static+0x6a/0x6f
[    0.000000]  [<ffffffff8201b4ff>] jump_label_init+0x69/0x91
[    0.000000]  [<ffffffff82006970>] start_kernel+0x1b5/0x349
[    0.000000]  [<ffffffff82006277>] x86_64_start_reservations+0x7e/0x82
[    0.000000]  [<ffffffff820063c1>] x86_64_start_kernel+0x146/0x153
[    0.000000] RIP bug_at+0x45/0x47

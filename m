Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2ABPMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 10:12:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45690 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab2ABPMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 10:12:22 -0500
Date: Mon, 2 Jan 2012 16:10:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
Message-ID: <20120102151019.GA1875@elte.hu>
References: <20111221123624.193898256@goodmis.org>
 <20120101180949.GA25066@elte.hu>
 <20120102105856.GA6661@elte.hu>
 <20120102134856.GA32673@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120102134856.GA32673@elte.hu>
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


As a next step i've merged in your 'fixes' tree as well, and the 
crashes are occuring with a lot higher frequency.

I just got a softlockup one to the serial console - attached 
below.

Thanks,

	Ingo

[....]
[   51.921290] geodewdt: probe of geodewdt rejects match -19
[   51.921302] initcall geodewdt_init+0x0/0x81 returned 0 after 847 usecs
[   51.921307] calling  sc520_wdt_init+0x0/0xec @ 1
[   51.921367] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[   76.736054] BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:1]
[   76.736056] Modules linked in:
[   76.736059] irq event stamp: 2966956
[   76.736062] hardirqs last  enabled at (2966955): [<ffffffff83154b74>] restore_args+0x0/0x30
[   76.736069] hardirqs last disabled at (2966956): [<ffffffff8315c86e>] apic_timer_interrupt+0x6e/0x80
[   76.736076] softirqs last  enabled at (2966954): [<ffffffff8109c2a8>] __do_softirq+0x20e/0x268
[   76.736081] softirqs last disabled at (2966945): [<ffffffff8315d26c>] call_softirq+0x1c/0x30
[   76.736087] CPU 0 
[   76.736089] Modules linked in:
[   76.736092] 
[   76.736096] Pid: 1, comm: swapper/0 Tainted: G        W    3.2.0-rc7-tip-02040-g8039fe3-dirty #166565 System manufacturer System Product Name/A8N-E
[   76.736102] RIP: 0010:[<ffffffff810e985c>]  [<ffffffff810e985c>] generic_exec_single+0x7c/0x95
[   76.736110] RSP: 0018:ffff88003d32bca0  EFLAGS: 00000202
[   76.736113] RAX: 0000000000000086 RBX: ffffffff83154b74 RCX: 0000000c16c17557
[   76.736116] RDX: 0000000000000013 RSI: 0000000000000001 RDI: 0000000000000286
[   76.736119] RBP: ffff88003d32bce0 R08: 0000000000000000 R09: 0000000000000000
[   76.736122] R10: ffff88003d3308b8 R11: ffff88003d3308b8 R12: ffff88003d32bc18
[   76.736125] R13: 3ffffffffffffffe R14: ffff88003d32a000 R15: 0000000000000000
[   76.736128] FS:  0000000000000000(0000) GS:ffff88003e200000(0000) knlGS:0000000000000000
[   76.736132] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   76.736134] CR2: 0000000000f06f53 CR3: 0000000004820000 CR4: 00000000000007f0
[   76.736138] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   76.736141] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   76.736144] Process swapper/0 (pid: 1, threadinfo ffff88003d32a000, task ffff88003d330000)
[   76.736147] Stack:
[   76.736148]  0000000000000286 ffff88003e5d69c0 ffff88003d32bcd0 0000000000000001
[   76.736154]  ffffffff81076881 0000000000000001 0000000000000000 ffff88003d32bcf8
[   76.736159]  ffff88003d32bd50 ffffffff810e999d ffff88003d3308b8 ffff88003e5d69c0
[   76.736165] Call Trace:
[   76.736170]  [<ffffffff81076881>] ? leave_mm+0x50/0x50
[   76.736175]  [<ffffffff810e999d>] smp_call_function_single+0x128/0x14c
[   76.736180]  [<ffffffff81076881>] ? leave_mm+0x50/0x50
[   76.736184]  [<ffffffff81076881>] ? leave_mm+0x50/0x50
[   76.736188]  [<ffffffff810e9abb>] smp_call_function_many+0xfa/0x1e9
[   76.736193]  [<ffffffff810e9be2>] smp_call_function+0x38/0x42
[   76.736199]  [<ffffffff81179f10>] ? find_vmap_area+0x4d/0x55
[   76.736203]  [<ffffffff81076881>] ? leave_mm+0x50/0x50
[   76.736208]  [<ffffffff810e9c16>] on_each_cpu+0x2a/0x7f
[   76.736212]  [<ffffffff81076b98>] flush_tlb_all+0x1c/0x20
[   76.736217]  [<ffffffff8117bf27>] remove_vm_area+0x79/0x9e
[   76.736223]  [<ffffffff810723af>] iounmap.part.2+0x89/0xa2
[   76.736227]  [<ffffffff8514b9ca>] ? geodewdt_init+0x81/0x81
[   76.736232]  [<ffffffff810723fd>] iounmap+0x35/0x37
[   76.736236]  [<ffffffff8514baaf>] sc520_wdt_init+0xe5/0xec
[   76.736241]  [<ffffffff81002089>] do_one_initcall+0x57/0x13a
[   76.736247]  [<ffffffff850d5d17>] kernel_init+0xea/0x164
[   76.736253]  [<ffffffff8315d174>] kernel_thread_helper+0x4/0x10
[   76.736258]  [<ffffffff83154b74>] ? retint_restore_args+0x13/0x13
[   76.736263]  [<ffffffff850d5c2d>] ? start_kernel+0x3ff/0x3ff
[   76.736268]  [<ffffffff8315d170>] ? gs_change+0x13/0x13
[   76.736270] Code: da e8 e2 7f 61 00 48 8b 45 c0 4c 89 f7 48 89 c6 e8 9c af 06 02 48 39 5d c8 75 09 44 89 ef ff 15 eb 60 75 03 45 85 ff 75 04 eb 0a <f3> 90 41 f6 44 24 20 01 75 f6 48 83 c4 18 5b 41 5c 41 5d 41 5e 
[   76.736316] Call Trace:
[   76.736320]  [<ffffffff81076881>] ? leave_mm+0x50/0x50
[   76.736324]  [<ffffffff810e999d>] smp_call_function_single+0x128/0x14c
[   76.736329]  [<ffffffff81076881>] ? leave_mm+0x50/0x50
[   76.736333]  [<ffffffff81076881>] ? leave_mm+0x50/0x50
[   76.736337]  [<ffffffff810e9abb>] smp_call_function_many+0xfa/0x1e9
[   76.736342]  [<ffffffff810e9be2>] smp_call_function+0x38/0x42
[   76.736346]  [<ffffffff81179f10>] ? find_vmap_area+0x4d/0x55
[   76.736350]  [<ffffffff81076881>] ? leave_mm+0x50/0x50
[   76.736355]  [<ffffffff810e9c16>] on_each_cpu+0x2a/0x7f
[   76.736359]  [<ffffffff81076b98>] flush_tlb_all+0x1c/0x20
[   76.736363]  [<ffffffff8117bf27>] remove_vm_area+0x79/0x9e
[   76.736368]  [<ffffffff810723af>] iounmap.part.2+0x89/0xa2
[   76.736372]  [<ffffffff8514b9ca>] ? geodewdt_init+0x81/0x81
[   76.736376]  [<ffffffff810723fd>] iounmap+0x35/0x37
[   76.736380]  [<ffffffff8514baaf>] sc520_wdt_init+0xe5/0xec
[   76.736384]  [<ffffffff81002089>] do_one_initcall+0x57/0x13a
[   76.736389]  [<ffffffff850d5d17>] kernel_init+0xea/0x164
[   76.736394]  [<ffffffff8315d174>] kernel_thread_helper+0x4/0x10
[   76.736399]  [<ffffffff83154b74>] ? retint_restore_args+0x13/0x13
[   76.736404]  [<ffffffff850d5c2d>] ? start_kernel+0x3ff/0x3ff
[   76.736408]  [<ffffffff8315d170>] ? gs_change+0x13/0x13
[   76.736412] Kernel panic - not syncing: softlockup: hung tasks
[   76.736415] Pid: 1, comm: swapper/0 Tainted: G        W    3.2.0-rc7-tip-02040-g8039fe3-dirty #166565
[   76.736418] Call Trace:
[   76.736420]  <IRQ>  [<ffffffff8308df39>] panic+0xa0/0x1c5
[   76.736430]  [<ffffffff81116bc0>] watchdog_timer_fn+0x12b/0x14d
[   76.736436]  [<ffffffff810ba965>] __run_hrtimer+0xeb/0x1dc
[   76.736441]  [<ffffffff81116a95>] ? __touch_watchdog+0x25/0x25
[   76.736445]  [<ffffffff810bb227>] hrtimer_interrupt+0xe0/0x1aa
[   76.736451]  [<ffffffff8315dbac>] smp_apic_timer_interrupt+0x77/0x8a
[   76.736456]  [<ffffffff8315c873>] apic_timer_interrupt+0x73/0x80
[   76.736458]  <EOI>  [<ffffffff83154b74>] ? retint_restore_args+0x13/0x13
[   76.736466]  [<ffffffff810e985c>] ? generic_exec_single+0x7c/0x95
[   76.736471]  [<ffffffff81076881>] ? leave_mm+0x50/0x50
[   76.736475]  [<ffffffff810e999d>] smp_call_function_single+0x128/0x14c
[   76.736480]  [<ffffffff81076881>] ? leave_mm+0x50/0x50

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2FUBmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:42:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40233 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2FUBmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:42:17 -0400
MIME-Version: 1.0
Date: Wed, 20 Jun 2012 20:42:17 -0500
Message-ID: <CAF_e0cbZTD1iRX1=ZPpkH5pwDSMGOyWC=_swDgLu=N+hY=g5wg@mail.gmail.com>
Subject: howto troubleshoot 'kernel paging request' oops
From: Richard Langly <richard.ringo.langly@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a problem that I have been unable to trouble-shoot in my
kernel module for going on a few weeks now and running out of ideas.
I'm developing a networking KM and testing on two VM guests. The KM's
on both guests seem to run fine as I transfer a simple messages from
one node to the other.

So after sending from one guest, and receiving it on the second guest,
the VM'd kernel instances just idle, I leave them running as I
continue my work. I have /var/log/messages being tailed via netconsole
to my host OS. And here's where the problem begins ... usually about 2
minutes after I send a msg and the VM just idles, the following output
appears in /var/log/messages. I'm having difficulty tracing any of
this as the traceback doesn't "seem" to originate w/ my KM (though I
know my KM's must be at fault as it would never happen unless I load
and run them). So this oops only appears several minutes after the run
on both the sending and the receiving machine using my KM's.

Any advice/suggestions much appreciated.


---
[  217.952082] BUG: unable to handle kernel paging request at 000000011e0fc6c0
[  217.953026] IP: [<ffffffff814e0d73>] nf_nat_cleanup_conntrack+0x4a/0x71
[  217.953026] PGD 1e564067 PUD 0
[  217.953026] Oops: 0002 [#1] SMP
[  217.953026] CPU 0
[  217.953026] Modules linked in: testkm1(O) testkm2(O)
[  217.953026]
[  217.953026] Pid: 0, comm: swapper/0 Tainted: G           O
3.2.1-gentoo-r2 #2 Bochs Bochs
[  217.953026] RIP: 0010:[<ffffffff814e0d73>]  [<ffffffff814e0d73>]
nf_nat_cleanup_conntrack+0x4a/0x71
[  217.953026] RSP: 0018:ffff88001fa03d70  EFLAGS: 00010246
[  217.953026] RAX: 0000000000000000 RBX: ffff88001e1367f8 RCX: ffffffff81053f1f
[  217.953026] RDX: 000000011e0fc6c0 RSI: 0000000000000006 RDI: ffffffff81c79bd8
[  217.953026] RBP: ffff88001fa03d80 R08: ffff88001fa0d980 R09: 0000000000000001
[  217.953026] R10: ffff88001fa03f08 R11: ffff88001fa0d900 R12: ffff88001e1367e1
[  217.953026] R13: ffff88001e082138 R14: ffff88001fa03e90 R15: ffffffff81a01fd8
[  217.953026] FS:  0000000000000000(0000) GS:ffff88001fa00000(0000)
knlGS:0000000000000000
[  217.953026] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  217.953026] CR2: 000000011e0fc6c0 CR3: 000000001f748000 CR4: 00000000000006f0
[  217.953026] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  217.953026] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  217.953026] Process swapper/0 (pid: 0, threadinfo ffffffff81a00000,
task ffffffff81a0d020)
[  217.953026] Stack:
[  217.953026]  ffff88001fa12bc0 ffffffff81c77dc8 ffff88001fa03db0
ffffffff81498e3f
[  217.953026]  7fffffffffffffff ffff88001e082138 ffffffff81c76280
0000000000000100
[  217.953026]  ffff88001fa03dd0 ffffffff814945db ffff88001e082138
ffffffff81c76280
[  217.953026] Call Trace:
[  217.953026]  <IRQ>
[  217.953026]  [<ffffffff81498e3f>] __nf_ct_ext_destroy+0x3b/0x53
[  217.953026]  [<ffffffff814945db>] nf_conntrack_free+0x20/0x4f
[  217.953026]  [<ffffffff814946b2>] destroy_conntrack+0xa8/0xad
[  217.953026]  [<ffffffff8149122c>] nf_conntrack_destroy+0x16/0x18
[  217.953026]  [<ffffffff81493a5a>] nf_ct_put+0x18/0x1a
[  217.953026]  [<ffffffff81494a64>] death_by_timeout+0x22/0x26
[  217.953026]  [<ffffffff8107aba4>] run_timer_softirq+0x1c6/0x295
[  217.953026]  [<ffffffff81494a42>] ? nf_ct_delete_from_lists+0x89/0x89
[  217.953026]  [<ffffffff81090013>] ? ktime_get+0x59/0x93
[  217.953026]  [<ffffffff81073b6f>] __do_softirq+0xc8/0x1a4
[  217.953026]  [<ffffffff8108c3e1>] ? hrtimer_interrupt+0x10d/0x19f
[  217.953026]  [<ffffffff815b6b2c>] call_softirq+0x1c/0x30
[  217.953026]  [<ffffffff81035a99>] do_softirq+0x41/0x7e
[  217.953026]  [<ffffffff81073932>] irq_exit+0x44/0xb4
[  217.953026]  [<ffffffff8104c4b9>] smp_apic_timer_interrupt+0x86/0x94
[  217.953026]  [<ffffffff815b539e>] apic_timer_interrupt+0x6e/0x80
[  217.953026]  <EOI>
[  217.953026]  [<ffffffff810535c4>] ? native_safe_halt+0x6/0x8
[  217.953026]  [<ffffffff8103b460>] default_idle+0x4b/0x85
[  217.953026]  [<ffffffff81033dd4>] cpu_idle+0x6e/0xa5
[  217.953026]  [<ffffffff8158edd9>] rest_init+0x6d/0x6f
[  217.953026]  [<ffffffff81aa9bcc>] start_kernel+0x350/0x35b
[  217.953026]  [<ffffffff81aa92b1>] x86_64_start_reservations+0xb8/0xbc
[  217.953026]  [<ffffffff81aa93b6>] x86_64_start_kernel+0x101/0x110
[  217.953026] Code: c2 85 d2 74 49 0f b6 58 11 48 01 c3 74 40 48 83
7b 20 00 74 39 48 c7 c7 d8 9b c7 81 e8 0c d6 0c 00 48 8b 03 48 8b 53
08 48 85 c0 <48> 89 02 74 04 48 89 50 08 48 bf 00 02 20 00 00 00 ad de
48 89
[  217.953026] RIP  [<ffffffff814e0d73>] nf_nat_cleanup_conntrack+0x4a/0x71
[  217.953026]  RSP <ffff88001fa03d70>
[  217.953026] CR2: 000000011e0fc6c0
[  218.039169] ---[ end trace c8420f05dc384e8a ]---
[  218.040439] Kernel panic - not syncing: Fatal exception in interrupt
[  218.042159] Pid: 0, comm: swapper/0 Tainted: G      D    O 3.2.1-gentoo-r2 #2
[  218.044068] Call Trace:
[  218.044717]  <IRQ>  [<ffffffff815ac249>] panic+0x8c/0x19e
[  218.046245]  [<ffffffff815af0a4>] oops_end+0xb1/0xc1
[  218.047590]  [<ffffffff81057b76>] no_context+0x202/0x211
[  218.049023]  [<ffffffff81053f1f>] ? pvclock_clocksource_read+0x4b/0xb4
[  218.050765]  [<ffffffff81057d3e>] __bad_area_nosemaphore+0x1b9/0x1d9
[  218.052471]  [<ffffffff81053592>] ? kvm_clock_read+0x19/0x1b
[  218.053992]  [<ffffffff81057d6c>] bad_area_nosemaphore+0xe/0x10
[  218.055580]  [<ffffffff815b1205>] do_page_fault+0x1c1/0x389
[  218.057077]  [<ffffffff81053f1f>] ? pvclock_clocksource_read+0x4b/0xb4
[  218.058822]  [<ffffffff81053592>] ? kvm_clock_read+0x19/0x1b
[  218.060383]  [<ffffffff81069c68>] ? enqueue_task_fair+0x2ab/0x414
[  218.061992]  [<ffffffff815b0c49>] do_async_page_fault+0x49/0x6b
[  218.063607]  [<ffffffff815ae7b5>] async_page_fault+0x25/0x30
[  218.065132]  [<ffffffff81053f1f>] ? pvclock_clocksource_read+0x4b/0xb4
[  218.066874]  [<ffffffff814e0d73>] ? nf_nat_cleanup_conntrack+0x4a/0x71
[  218.068696]  [<ffffffff81498e3f>] __nf_ct_ext_destroy+0x3b/0x53
[  218.070290]  [<ffffffff814945db>] nf_conntrack_free+0x20/0x4f
[  218.071831]  [<ffffffff814946b2>] destroy_conntrack+0xa8/0xad
[  218.073378]  [<ffffffff8149122c>] nf_conntrack_destroy+0x16/0x18
[  218.074995]  [<ffffffff81493a5a>] nf_ct_put+0x18/0x1a
[  218.076357]  [<ffffffff81494a64>] death_by_timeout+0x22/0x26
[  218.077889]  [<ffffffff8107aba4>] run_timer_softirq+0x1c6/0x295
[  218.079475]  [<ffffffff81494a42>] ? nf_ct_delete_from_lists+0x89/0x89
[  218.081202]  [<ffffffff81090013>] ? ktime_get+0x59/0x93
[  218.082611]  [<ffffffff81073b6f>] __do_softirq+0xc8/0x1a4
[  218.084060]  [<ffffffff8108c3e1>] ? hrtimer_interrupt+0x10d/0x19f
[  218.085698]  [<ffffffff815b6b2c>] call_softirq+0x1c/0x30
[  218.087121]  [<ffffffff81035a99>] do_softirq+0x41/0x7e
[  218.088503]  [<ffffffff81073932>] irq_exit+0x44/0xb4
[  218.089879]  [<ffffffff8104c4b9>] smp_apic_timer_interrupt+0x86/0x94
[  218.091591]  [<ffffffff815b539e>] apic_timer_interrupt+0x6e/0x80
[  218.093218]  <EOI>  [<ffffffff810535c4>] ? native_safe_halt+0x6/0x8
[  218.094945]  [<ffffffff8103b460>] default_idle+0x4b/0x85
[  218.096378]  [<ffffffff81033dd4>] cpu_idle+0x6e/0xa5
[  218.097719]  [<ffffffff8158edd9>] rest_init+0x6d/0x6f
[  218.099099]  [<ffffffff81aa9bcc>] start_kernel+0x350/0x35b
[  218.100575]  [<ffffffff81aa92b1>] x86_64_start_reservations+0xb8/0xbc
[  218.102320]  [<ffffffff81aa93b6>] x86_64_start_kernel+0x101/0x110

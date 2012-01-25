Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2AYVOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:14:44 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:50460 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2AYVOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:14:43 -0500
Message-ID: <4F2070B9.2000104@numascale.com>
Date: Wed, 25 Jan 2012 22:14:33 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
References: <4F1FCF02.9060209@numascale-asia.com> <20120125140029.GA2534@linux.vnet.ibm.com> <4F200F4D.5000201@numascale.com> <20120125181441.GD2849@linux.vnet.ibm.com>
In-Reply-To: <20120125181441.GD2849@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/2012 19:14, Paul E. McKenney wrote:
[]
> 
> So, it would be very interesting to add the values rdp->mynode->gpnum
> and rdp->mynode->completed to your list, perhaps labeling them something
> like "rng" and "rnc" respectively.
> 

I added them to the printout. This time I ran with NR_CPUS=512 so there's only two levels but we see more qsmask bits set on the root node :

[  738.329672] CPU 48, treason uncloaked, rsp @ ffffffff81a1cd80 (rcu_sched), gpnum=10568, completed=10567, n_force_qs=69, n_force_qs_lh=0, n_force_qs_ngp=0, rnp @ ffffffff81a1cd80, qsmask=0x1f
[  738.330137]   0 ffff8803f840d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=66 ql=1 qs=..W. b=10 ci=158068 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  12 ffff880bd040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=1 ri=0 ql=0 qs=.... b=10 ci=715 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  24 ffff8813d040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=0 ql=0 qs=.... b=10 ci=484 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  36 ffff881bd040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=1 ri=0 ql=0 qs=.... b=10 ci=369 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  48 ffff8823d040d660 c=10567 g=10567 pq=1 pgp=10567 qp=0 of=0 ri=0 ql=28 qs=.RWD b=10 ci=9292 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  60 ffff882bd040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=1 ql=0 qs=.... b=10 ci=32 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  72 ffff8833d040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=0 ql=0 qs=.... b=10 ci=43 co=0 ca=0 rng=10568 rnc=10567
[  738.330137] ------------[ cut here ]------------
[  738.330137] WARNING: at kernel/rcutree_plugin.h:1011 rcu_preempt_check_blocked_tasks+0x27/0x30()
[  738.330137] Hardware name: H8QI6
[  738.330137] Modules linked in: rcutorture
[  738.330137] Pid: 4611, comm: rcu_torture_rea Not tainted 3.2.1-numaconnect10+ #68
[  738.330137] Call Trace:
[  738.330137]  <IRQ>  [<ffffffff810bb327>] ? rcu_preempt_check_blocked_tasks+0x27/0x30
[  738.330137]  [<ffffffff8106f47b>] warn_slowpath_common+0x8b/0xc0
[  738.330137]  [<ffffffff8106f4c5>] warn_slowpath_null+0x15/0x20
[  738.330137]  [<ffffffff810bb327>] rcu_preempt_check_blocked_tasks+0x27/0x30
[  738.330137]  [<ffffffff810bb43d>] rcu_start_gp+0x10d/0x1b0
[  738.330137]  [<ffffffff810bc04b>] __rcu_process_callbacks+0x8b/0xd0
[  738.330137]  [<ffffffff810bc8b0>] rcu_process_callbacks+0x20/0x40
[  738.330137]  [<ffffffff810757fd>] __do_softirq+0x9d/0x140
[  738.330137]  [<ffffffffa0001510>] ? rcu_torture_shuffle+0x80/0x80 [rcutorture]
[  738.330137]  [<ffffffff815d982c>] call_softirq+0x1c/0x30
[  738.330137]  [<ffffffff8103451a>] do_softirq+0x4a/0x80
[  738.330137]  [<ffffffff81075b73>] irq_exit+0x43/0x60
[  738.330137]  [<ffffffff8104aee5>] smp_apic_timer_interrupt+0x45/0x60
[  738.330137]  [<ffffffffa0001c60>] ? rcu_sync_torture_deferred_free+0xd0/0xd0 [rcutorture]
[  738.330137]  [<ffffffff815d834b>] apic_timer_interrupt+0x6b/0x70
[  738.330137]  <EOI>  [<ffffffff815d4d79>] ? __schedule+0x349/0x710
[  738.330137]  [<ffffffff810618d5>] ? update_curr+0x85/0xd0
[  738.330137]  [<ffffffff8107b816>] ? lock_timer_base+0x36/0x70
[  738.330137]  [<ffffffff8107ba92>] ? mod_timer+0xf2/0x1d0
[  738.330137]  [<ffffffffa0001510>] ? rcu_torture_shuffle+0x80/0x80 [rcutorture]
[  738.330137]  [<ffffffff815d541a>] schedule+0x3a/0x60
[  738.330137]  [<ffffffffa0001640>] rcu_torture_reader+0x130/0x230 [rcutorture]
[  738.330137]  [<ffffffffa0001dc0>] ? rcu_torture_writer+0x160/0x160 [rcutorture]
[  738.330137]  [<ffffffffa0001510>] ? rcu_torture_shuffle+0x80/0x80 [rcutorture]
[  738.330137]  [<ffffffff8108a716>] kthread+0x96/0xa0
[  738.330137]  [<ffffffff815d9734>] kernel_thread_helper+0x4/0x10
[  738.330137]  [<ffffffff8108a680>] ? kthread_stop+0x70/0x70
[  738.330137]  [<ffffffff815d9730>] ? gs_change+0xb/0xb
[  738.330137] ---[ end trace e8e520cce35c7626 ]---
[  738.330137] CPU 48, treason uncloaked, rsp @ ffffffff81a1cd80 (rcu_sched), gpnum=10568, completed=10567, n_force_qs=70, n_force_qs_lh=250, n_force_qs_ngp=0, rnp @ ffffffff81a1d180, qsmask=0x1
[  738.330137]   0 ffff8803f840d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=67 ql=1 qs=..W. b=10 ci=158068 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  12 ffff880bd040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=1 ri=1 ql=1 qs=N... b=10 ci=715 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  24 ffff8813d040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=1 ql=1 qs=N... b=10 ci=484 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  36 ffff881bd040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=1 ri=1 ql=1 qs=N... b=10 ci=369 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  48 ffff8823d040d660 c=10567 g=10567 pq=1 pgp=10567 qp=0 of=0 ri=0 ql=28 qs=.RWD b=10 ci=9292 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  60 ffff882bd040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=1 ql=0 qs=.... b=10 ci=32 co=0 ca=0 rng=10568 rnc=10567
[  738.330137]  72 ffff8833d040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=0 ql=0 qs=.... b=10 ci=43 co=0 ca=0 rng=10568 rnc=10567

Kind regards,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2HGSF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:05:58 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57190 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767Ab2HGSF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:05:57 -0400
Date: Tue, 7 Aug 2012 22:49:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: john stultz <johnstul@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: rcu stalls seen with numasched_v2 patches applied.
Message-ID: <20120807171859.GB3850@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120807123305.GA7137@linux.vnet.ibm.com>
 <1344347568.27828.122.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1344347568.27828.122.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080718-7182-0000-0000-00000233EE58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-08-07 15:52:48]:

> On Tue, 2012-08-07 at 18:03 +0530, Srikar Dronamraju wrote:
> > Hi, 
> > 
> >  INFO: rcu_sched self-detected stall on CPU { 7}  (t=105182911 jiffies)
> >  Pid: 5173, comm: qpidd Tainted: G        W    3.5.0numasched_v2_020812+ #1
> >  Call Trace:
> >  <IRQ>  [<ffffffff810d4c7e>] rcu_check_callbacks+0x18e/0x650
> >  [<ffffffff81060918>] update_process_times+0x48/0x90
> >  [<ffffffff810a2a7e>] tick_sched_timer+0x6e/0xe0
> >  [<ffffffff810789a5>] __run_hrtimer+0x75/0x1a0
> >  [<ffffffff810a2a10>] ? tick_setup_sched_timer+0x100/0x100
> >  [<ffffffff810591cf>] ? __do_softirq+0x13f/0x240
> >  [<ffffffff81078d56>] hrtimer_interrupt+0xf6/0x240
> >  [<ffffffff814f0179>] smp_apic_timer_interrupt+0x69/0x99
> >  [<ffffffff814ef14a>] apic_timer_interrupt+0x6a/0x70
> >  <EOI>  [<ffffffff814e64b2>] ? _raw_spin_unlock_irqrestore+0x12/0x20
> >  [<ffffffff81082552>] sched_setnode+0x82/0xf0
> >  [<ffffffff8108bd38>] task_numa_work+0x1e8/0x240
> >  [<ffffffff81070c6c>] task_work_run+0x6c/0x80
> >  [<ffffffff81013984>] do_notify_resume+0x94/0xa0
> >  [<ffffffff814e6a6c>] retint_signal+0x48/0x8c
> 
> I haven't seen anything like that (obviously), but the one thing you can
> try is undo the optimization Oleg suggested and use a separate
> callback_head for the task_work and not reuse task_struct::rcu.
> 

Are you referring to this the commit 158e1645e (trim task_work: get rid of hlist)

I am also able to reproduce this on another 8 node machine too.

Just to update, I had to revert commit: b9403130a5  sched/cleanups: Add
load balance cpumask pointer to 'struct lb_env' so that your patches
apply cleanly. (I dont think this should have caused any problem.. but)

-- 
Thanks and Regards
Srikar


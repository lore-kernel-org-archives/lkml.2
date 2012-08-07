Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2HGMea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:34:30 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45559 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2HGMe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:34:29 -0400
Date: Tue, 7 Aug 2012 18:03:05 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, john stultz <johnstul@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: rcu stalls seen with numasched_v2 patches applied.
Message-ID: <20120807123305.GA7137@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080712-7606-0000-0000-0000029B0AC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I saw this while I was running the 2nd August -tip kernel +  Peter's
numasched patches.

Top showed load average to be 240, there was one cpu (cpu 7) which
showed 100% while all other cpus were idle.  The system showed some
sluggishness. Before I saw this I ran Andrea's autonuma benchmark couple
of times.

I am not sure if this is an already reported issue/known issue.

 INFO: rcu_sched self-detected stall on CPU { 7}  (t=105182911 jiffies)
 Pid: 5173, comm: qpidd Tainted: G        W    3.5.0numasched_v2_020812+ #1
 Call Trace:
 <IRQ>  [<ffffffff810d4c7e>] rcu_check_callbacks+0x18e/0x650
 [<ffffffff81060918>] update_process_times+0x48/0x90
 [<ffffffff810a2a7e>] tick_sched_timer+0x6e/0xe0
 [<ffffffff810789a5>] __run_hrtimer+0x75/0x1a0
 [<ffffffff810a2a10>] ? tick_setup_sched_timer+0x100/0x100
 [<ffffffff810591cf>] ? __do_softirq+0x13f/0x240
 [<ffffffff81078d56>] hrtimer_interrupt+0xf6/0x240
 [<ffffffff814f0179>] smp_apic_timer_interrupt+0x69/0x99
 [<ffffffff814ef14a>] apic_timer_interrupt+0x6a/0x70
 <EOI>  [<ffffffff814e64b2>] ? _raw_spin_unlock_irqrestore+0x12/0x20
 [<ffffffff81082552>] sched_setnode+0x82/0xf0
 [<ffffffff8108bd38>] task_numa_work+0x1e8/0x240
 [<ffffffff81070c6c>] task_work_run+0x6c/0x80
 [<ffffffff81013984>] do_notify_resume+0x94/0xa0
 [<ffffffff814e6a6c>] retint_signal+0x48/0x8c
 INFO: rcu_sched self-detected stall on CPU { 7}  (t=105362914 jiffies)
 Pid: 5173, comm: qpidd Tainted: G        W    3.5.0numasched_v2_020812+ #1
 Call Trace:
 <IRQ>  [<ffffffff810d4c7e>] rcu_check_callbacks+0x18e/0x650
 [<ffffffff81060918>] update_process_times+0x48/0x90
 [<ffffffff810a2a7e>] tick_sched_timer+0x6e/0xe0
 [<ffffffff810789a5>] __run_hrtimer+0x75/0x1a0
 [<ffffffff810a2a10>] ? tick_setup_sched_timer+0x100/0x100
 [<ffffffff810591cf>] ? __do_softirq+0x13f/0x240
 [<ffffffff81078d56>] hrtimer_interrupt+0xf6/0x240
 [<ffffffff814f0179>] smp_apic_timer_interrupt+0x69/0x99
 [<ffffffff814ef14a>] apic_timer_interrupt+0x6a/0x70
 <EOI>  [<ffffffff81082562>] ? sched_setnode+0x92/0xf0
 [<ffffffff81082552>] ? sched_setnode+0x82/0xf0
 [<ffffffff8108bd38>] task_numa_work+0x1e8/0x240
 [<ffffffff81070c6c>] task_work_run+0x6c/0x80
 [<ffffffff81013984>] do_notify_resume+0x94/0xa0
 [<ffffffff814e6a6c>] retint_signal+0x48/0x8c
 INFO: rcu_sched self-detected stall on CPU { 7}  (t=105542917 jiffies)
 Pid: 5173, comm: qpidd Tainted: G        W    3.5.0numasched_v2_020812+ #1
 Call Trace:
 <IRQ>  [<ffffffff810d4c7e>] rcu_check_callbacks+0x18e/0x650
 [<ffffffff81060918>] update_process_times+0x48/0x90
 [<ffffffff810a2a7e>] tick_sched_timer+0x6e/0xe0
 [<ffffffff810789a5>] __run_hrtimer+0x75/0x1a0
 [<ffffffff810a2a10>] ? tick_setup_sched_timer+0x100/0x100
 [<ffffffff810591cf>] ? __do_softirq+0x13f/0x240
 [<ffffffff81078d56>] hrtimer_interrupt+0xf6/0x240
 [<ffffffff814f0179>] smp_apic_timer_interrupt+0x69/0x99
 [<ffffffff814ef14a>] apic_timer_interrupt+0x6a/0x70
 <EOI>  [<ffffffff814e64b2>] ? _raw_spin_unlock_irqrestore+0x12/0x20
 [<ffffffff81082552>] sched_setnode+0x82/0xf0
 [<ffffffff8108bd38>] task_numa_work+0x1e8/0x240
 [<ffffffff81070c6c>] task_work_run+0x6c/0x80
 [<ffffffff81013984>] do_notify_resume+0x94/0xa0
 [<ffffffff814e6a6c>] retint_signal+0x48/0x8c


<these messages keep repeating>

I saw this on a 2 node 24 cpu machine. 

If I am able to reproduce this again, I plan to test these without the
numasched patches applied.

-- 
Thanks and Regards
Srikar Dronamraju


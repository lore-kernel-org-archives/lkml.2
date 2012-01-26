Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2AZPEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:04:47 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:32939 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab2AZPEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:04:46 -0500
Message-ID: <4F216B85.7010208@numascale.com>
Date: Thu, 26 Jan 2012 16:04:37 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
References: <4F1FCF02.9060209@numascale-asia.com> <20120125140029.GA2534@linux.vnet.ibm.com> <4F200F4D.5000201@numascale.com> <20120125181441.GD2849@linux.vnet.ibm.com> <4F2070B9.2000104@numascale.com> <20120125213450.GJ2849@linux.vnet.ibm.com> <4F2086DA.4040203@numascale.com> <20120126015843.GN2849@linux.vnet.ibm.com>
In-Reply-To: <20120126015843.GN2849@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

On 1/26/2012 02:58, Paul E. McKenney wrote:
> On Wed, Jan 25, 2012 at 11:48:58PM +0100, Steffen Persvold wrote:
[]
>
> This looks like it will produce useful information, but I am not seeing
> output from it below.
>
> 							Thanx, Paul
>
>> This run it was CPU24 that triggered the issue :
>>

This line is the printout for the root level :

>> [  231.572688] CPU 24, treason uncloaked, rsp @ ffffffff81a1cd80 (rcu_sched), rnp @ ffffffff81a1cd80(r) qsmask=0x1f, c=5132 g=5132 nc=5132 ng=5133 sc=5132 sg=5133 mc=5132 mg=5133

(this is the WARN_ON printout) :
>> [  231.576167] ------------[ cut here ]------------
>> [  231.576167] WARNING: at kernel/rcutree_plugin.h:1011 rcu_preempt_check_blocked_tasks+0x27/0x30()
>> [  231.576167] Hardware name: H8QI6
>> [  231.576167] Modules linked in: rcutorture
>> [  231.576167] Pid: 4603, comm: rcu_torture_rea Not tainted 3.2.1-numaconnect10+ #77
>> [  231.576167] Call Trace:
>> [  231.576167]<IRQ>   [<ffffffff810bb217>] ? rcu_preempt_check_blocked_tasks+0x27/0x30
>> [  231.576167]  [<ffffffff8106f47b>] warn_slowpath_common+0x8b/0xc0
>> [  231.576167]  [<ffffffff8106f4c5>] warn_slowpath_null+0x15/0x20
>> [  231.576167]  [<ffffffff810bb217>] rcu_preempt_check_blocked_tasks+0x27/0x30
>> [  231.576167]  [<ffffffff810bb330>] rcu_start_gp+0x110/0x1b0
>> [  231.576167]  [<ffffffff810bbf3b>] __rcu_process_callbacks+0x8b/0xd0
>> [  231.576167]  [<ffffffff810bc7a0>] rcu_process_callbacks+0x20/0x40
>> [  231.576167]  [<ffffffff8107580d>] __do_softirq+0x9d/0x140
>> [  231.576167]  [<ffffffff815d982c>] call_softirq+0x1c/0x30
>> [  231.576167]  [<ffffffff8103451a>] do_softirq+0x4a/0x80
>> [  231.576167]  [<ffffffff81075b83>] irq_exit+0x43/0x60
>> [  231.576167]  [<ffffffff8104aed5>] smp_apic_timer_interrupt+0x45/0x60
>> [  231.576167]  [<ffffffff815d834b>] apic_timer_interrupt+0x6b/0x70
>> [  231.576167]<EOI>   [<ffffffff81067aa9>] ? finish_task_switch+0x59/0xc0
>> [  231.576167]  [<ffffffff815d4d37>] __schedule+0x337/0x710
>> [  231.576167]  [<ffffffff81090425>] ? sched_clock_local+0x15/0x80
>> [  231.576167]  [<ffffffff8107b826>] ? lock_timer_base+0x36/0x70
>> [  231.576167]  [<ffffffff8107baa2>] ? mod_timer+0xf2/0x1d0
>> [  231.576167]  [<ffffffffa0001510>] ? rcu_torture_shuffle+0x80/0x80 [rcutorture]
>> [  231.576167]  [<ffffffff815d53ea>] schedule+0x3a/0x60
>> [  231.576167]  [<ffffffffa0001640>] rcu_torture_reader+0x130/0x230 [rcutorture]
>> [  231.576167]  [<ffffffffa0001dc0>] ? rcu_torture_writer+0x160/0x160 [rcutorture]
>> [  231.576167]  [<ffffffffa0001510>] ? rcu_torture_shuffle+0x80/0x80 [rcutorture]
>> [  231.576167]  [<ffffffff8108a726>] kthread+0x96/0xa0
>> [  231.576167]  [<ffffffff815d9734>] kernel_thread_helper+0x4/0x10
>> [  231.576167]  [<ffffffff8108a690>] ? kthread_stop+0x70/0x70
>> [  231.576167]  [<ffffffff815d9730>] ? gs_change+0xb/0xb
>> [  231.576167] ---[ end trace 828c8d7afbd02d1b ]---
>>

I didn't include the leaf node printout, but the counters were 
indentical to the root printout (with the exception of the rnp address 
and qsmask of course).

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold

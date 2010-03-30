Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab0C3Jna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 05:43:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51521 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab0C3Jn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 05:43:28 -0400
Message-ID: <4BB1C7C5.5070700@cn.fujitsu.com>
Date: Tue, 30 Mar 2010 17:43:33 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: don't call rcu_preempt_note_context_switch() in
 rcu_check_callbacks()
References: <4BB014DF.9030905@cn.fujitsu.com> <20100329044236.GB2343@linux.vnet.ibm.com>
In-Reply-To: <20100329044236.GB2343@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Mon, Mar 29, 2010 at 10:47:59AM +0800, Lai Jiangshan wrote:
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 7bit
>>
>>
>> Even though in user mode or idle mode, rcu_check_callbacks() is not
>> context switch, so we don't call rcu_preempt_note_context_switch()
>> in rcu_check_callbacks().
>>
>> Though there is no harm that calls rcu_preempt_note_context_switch()
>> in rcu_check_callbacks(), but it is waste.
>>
>> rcu_check_callbacks()
>>   rcu_sched_qs()
>>     rcu_preempt_note_context_switch()
>>        Now, ->rcu_read_lock_nesting == 0, so we just calls
>>        rcu_preempt_qs(), but, rcu_preempt_check_callbacks()
>>        will call it again and set the ->rcu_read_unlock_special
>>        correct again.
>>
>> So let rcu_preempt_check_callbacks() handle things for us.
> 
> Nice!!!
> 
> But how about naming the new function that invokes
> rcu_preempt_note_context_switch() something like
> rcu_sched_note_context_switch(), and then leaving the
> name of rcu_sched_qs() the same (rather than changing
> it to __rcu_sched_qs(), as below)?
> 
> This way, the names clearly call out what the function
> is doing.
> 

If I understand right, it will become this:

schedule() / run_ksoftirqd() / rcu_needs_cpu()
  rcu_sched_note_context_switch()
    rcu_sched_qs()
    rcu_preempt_note_context_switch()

Right?



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088Ab2HJDK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:10:59 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55509 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2HJDK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:10:58 -0400
Message-ID: <50247BA4.7060504@linux.vnet.ibm.com>
Date: Fri, 10 Aug 2012 11:10:28 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: remove useless code in yield_to
References: <4F13EFBE.1030002@linux.vnet.ibm.com> <1326707503.2442.219.camel@twins> <4F14DEAE.60702@linux.vnet.ibm.com> <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com> <4F14E54E.80904@linux.vnet.ibm.com> <1327506934.2614.87.camel@laptop> <20120126100429.GA3853@elte.hu> <4F21FC69.6040402@linux.vnet.ibm.com> <4F222B2B.6010602@gmail.com> <4F24E804.5090808@linux.vnet.ibm.com> <20120129163328.GC23408@elte.hu> <4F260BFE.2070503@linux.vnet.ibm.com> <4F260DAE.4000008@gmail.com> <4F262ED9.7040003@linux.vnet.ibm.com> <4FF2925A.9060005@linux.vnet.ibm.com> <50247A97.4000905@linux.vnet.ibm.com>
In-Reply-To: <50247A97.4000905@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12081003-0260-0000-0000-000001A7BA4B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 11:05 AM, Michael Wang wrote:
> On 07/03/2012 02:34 PM, Michael Wang wrote:
>> From: Michael Wang <wangyun@linux.vnet.ibm.com>
>>
>> it's impossible to enter else branch if we have set skip_clock_update
>> in task_yield_fair(), as yield_to_task_fair() will directly return
>> true after invoke task_yield_fair().
> 
> Could I get some conclusion on this patch? Should we clean up that peace
> of code or leave it there?
s /peace/piece and cc mike...
> 
> Regards,
> Michael Wang
> 
>>
>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
>> ---
>>  kernel/sched/core.c |    7 -------
>>  1 files changed, 0 insertions(+), 7 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 9bb7d28..77c14aa 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -4737,13 +4737,6 @@ again:
>>  		 */
>>  		if (preempt && rq != p_rq)
>>  			resched_task(p_rq->curr);
>> -	} else {
>> -		/*
>> -		 * We might have set it in task_yield_fair(), but are
>> -		 * not going to schedule(), so don't want to skip
>> -		 * the next update.
>> -		 */
>> -		rq->skip_clock_update = 0;
>>  	}
>>
>>  out:
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


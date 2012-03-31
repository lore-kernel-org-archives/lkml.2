Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2CaHxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 03:53:20 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33363 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2CaHxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 03:53:17 -0400
Message-ID: <4F76B7B9.5080709@linux.vnet.ibm.com>
Date: Sat, 31 Mar 2012 13:22:25 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, mingo@kernel.org,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>, vapier@gentoo.org,
        rusty@rustcorp.com.au
Subject: Re: sched: WARNING: at include/linux/cpumask.h:108 select_fallback_rq+0x241/0x280()
References: <CA+1xoqcf6qJOouKXGEHsjWSBJdA7qtMnuVopq+hoHS+TX8fvSg@mail.gmail.com> <CA+1xoqcJAwgTgQG=nZPsH_SLkPFkGt2rUiVWGn5SO5JOAC1RAA@mail.gmail.com> <4F75BED4.9050005@linux.vnet.ibm.com> <1333118719.2960.27.camel@laptop>
In-Reply-To: <1333118719.2960.27.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12033021-6102-0000-0000-000001255076
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 08:15 PM, Peter Zijlstra wrote:

> On Fri, 2012-03-30 at 19:40 +0530, Srivatsa S. Bhat wrote:
> 
>> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> Subject: sched: Fix incorrect usage of for_each_cpu_mask() in select_fallback_rq()
>>
>> The function for_each_cpu_mask() expects a *pointer* to struct cpumask
>> as its second argument, whereas select_fallback_rq() passes the value
>> itself. And moreover, for_each_cpu_mask() has been marked as obselete
>> in include/linux/cpumask.h. So move to the more appropriate for_each_cpu()
>> variant.
> 
> Gah.. so why did it compile to begin with!?


One of the perils of using macros instead of true function calls :-(


Regards,
Srivatsa S. Bhat

> 
>> Reported-by: Sasha Levin <levinsasha928@gmail.com>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  kernel/sched/core.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index e3ed0ec..e85046d 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1270,7 +1270,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
>>  	int dest_cpu;
>>  
>>  	/* Look for allowed, online CPU in same node. */
>> -	for_each_cpu_mask(dest_cpu, *nodemask) {
>> +	for_each_cpu(dest_cpu, nodemask) {
>>  		if (!cpu_online(dest_cpu))
>>  			continue;
>>  		if (!cpu_active(dest_cpu))
>> @@ -1281,7 +1281,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
>>  
>>  	for (;;) {
>>  		/* Any allowed, online CPU? */
>> -		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
>> +		for_each_cpu(dest_cpu, tsk_cpus_allowed(p)) {
>>  			if (!cpu_online(dest_cpu))
>>  				continue;
>>  			if (!cpu_active(dest_cpu))
>>
>>
> 
> 
> 


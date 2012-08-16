Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab2HPIFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:05:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35864 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab2HPIFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:05:46 -0400
MIME-Version: 1.0
In-Reply-To: <502C7DC7.8010601@intel.com>
References: <5028F12C.7080405@intel.com>
	<CADZ9YHhB_1ZeZM3WOFiz0kcx1ZR9iFO_R=Mst_w=QKXOi4Z9OQ@mail.gmail.com>
	<502C7DC7.8010601@intel.com>
Date: Thu, 16 Aug 2012 14:05:45 +0600
Message-ID: <CADZ9YHg8g+tvHxq9acEXM5SpxHzjPwsgdbrAucdWb+k_x9uoPg@mail.gmail.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in scheduler
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/12, Alex Shi <alex.shi@intel.com> wrote:
> On 08/15/2012 10:24 PM, Rakib Mullick wrote:
>
>> On 8/13/12, Alex Shi <alex.shi@intel.com> wrote:
>>> Since there is no power saving consideration in scheduler CFS, I has a
>>> very rough idea for enabling a new power saving schema in CFS.
>>>
>>> It bases on the following assumption:
>>> 1, If there are many task crowd in system, just let few domain cpus
>>> running and let other cpus idle can not save power. Let all cpu take the
>>> load, finish tasks early, and then get into idle. will save more power
>>> and have better user experience.
>>>
>> This assumption indirectly point towards the scheme when performance
>> is enabled, isn't it? Cause you're trying to spread the load equally
>> amongst all the CPUs.
>
>
> It is.
>
Okay, then what would be the default mechanism? Performance or
powersavings ? Your proposal deals with performance and power saving,
but there should be a default mechanism too, what that default
mechanism would be? Shouldn't  performance be the default one and
discard checking for performance?

>>
>>>
>>> select_task_rq_fair()
>>> {
>
> 	int powersaving = 0;
>
>>> 	for_each_domain(cpu, tmp) {
>>> 		if (policy == power && tmp_has_capacity &&
>>> 			 tmp->flags & sd_flag) {
>>> 			sd = tmp;
>>> 			//It is fine to got cpu in the domain
>
> 			powersaving = 1;
>
>>> 			break;
>>> 		}
>>> 	}
>>>
>>> 	while(sd) {
>  		if (policy == power && powersaving == 1)
>>> 			find_busiest_and_capable_group()
>>
>> I'm not sure what find_busiest_and_capable_group() would really be, it
>> seems it'll find the busiest and capable group, but isn't it a
>> conflict with the first assumption you proposed on your proposal?
>
>
> This pseudo code missed a power saving workable flag , adding it into
> above code should solved your concern.
>
I think I should take a look at this one when it'll be prepared for RFC.

Thanks,
Rakib.

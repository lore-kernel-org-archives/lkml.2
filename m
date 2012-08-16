Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2HPE54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 00:57:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:61002 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab2HPE5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 00:57:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,776,1336374000"; 
   d="scan'208";a="134839801"
Message-ID: <502C7DC7.8010601@intel.com>
Date: Thu, 16 Aug 2012 12:57:43 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <CADZ9YHhB_1ZeZM3WOFiz0kcx1ZR9iFO_R=Mst_w=QKXOi4Z9OQ@mail.gmail.com>
In-Reply-To: <CADZ9YHhB_1ZeZM3WOFiz0kcx1ZR9iFO_R=Mst_w=QKXOi4Z9OQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 10:24 PM, Rakib Mullick wrote:

> On 8/13/12, Alex Shi <alex.shi@intel.com> wrote:
>> Since there is no power saving consideration in scheduler CFS, I has a
>> very rough idea for enabling a new power saving schema in CFS.
>>
>> It bases on the following assumption:
>> 1, If there are many task crowd in system, just let few domain cpus
>> running and let other cpus idle can not save power. Let all cpu take the
>> load, finish tasks early, and then get into idle. will save more power
>> and have better user experience.
>>
> This assumption indirectly point towards the scheme when performance
> is enabled, isn't it? Cause you're trying to spread the load equally
> amongst all the CPUs.


It is.

> 
>>
>> select_task_rq_fair()
>> {

	int powersaving = 0;

>> 	for_each_domain(cpu, tmp) {
>> 		if (policy == power && tmp_has_capacity &&
>> 			 tmp->flags & sd_flag) {
>> 			sd = tmp;
>> 			//It is fine to got cpu in the domain

			powersaving = 1;

>> 			break;
>> 		}
>> 	}
>>
>> 	while(sd) {
 		if (policy == power && powersaving == 1)
>> 			find_busiest_and_capable_group()
> 
> I'm not sure what find_busiest_and_capable_group() would really be, it
> seems it'll find the busiest and capable group, but isn't it a
> conflict with the first assumption you proposed on your proposal?


This pseudo code missed a power saving workable flag , adding it into
above code should solved your concern.

> 
> Thanks,
> Rakib.



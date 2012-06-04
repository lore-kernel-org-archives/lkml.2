Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596Ab2FDNsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:48:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:63916 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab2FDNsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:48:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="147808745"
Message-ID: <4FCCBC97.8060101@linux.intel.com>
Date: Mon, 04 Jun 2012 06:48:07 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>  <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com> <1338817519.28282.54.camel@twins>
In-Reply-To: <1338817519.28282.54.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/2012 6:45 AM, Peter Zijlstra wrote:
> On Mon, 2012-06-04 at 06:13 -0700, Arjan van de Ven wrote:
>> On 6/4/2012 3:32 AM, Peter Zijlstra wrote:
>>> On Mon, 2012-06-04 at 14:24 +0400, Vladimir Davydov wrote:
>>>> rq->cpuload strongly depends on cgroup hierarchy. For example, if hundreds of
>>>> tasks are running inside cpu:/test cgroup, the sum of cpuload over all cpus
>>>> won't exceed 1024 (by default). That makes the cpuidle menu governor take wrong
>>>> decisions, which can negatively affect overall performance.
>>>>
>>>> To cope this, use nr_running last seen in __update_cpu_load() instead of
>>>> cpuload for calculating performance multiplier.
>>>
>>> What is cpuidle trying to do?
>>
>> what it is doing is trying to use "cpuload" as proxy for performance
>> sensitivity. The higher the load, the longer the idle period (predicted)
>> needs to be, for cpuidle to be willing to tolerate the latency of deeper
>> C states.
> 
> Well, both are complete crap of course.. load has no relation to busy
> what so ever anyway.

it's not about busy, it's about performance sensitive.
it's not a super nice proxy, no argument, but it's one of the few long
term ones we have.


> But what you're saying is that its trying to correlate latency with
> load, higher loaded systems should receive less latency spikes. Why does
> this make sense at all?

higher loaded systems are assumed to be more sensitive to performance
loss, and thus the cpuidle code will be more conservative in adding
performance loss (via the exit latency) on such systems.

> 
> Or are we simply trying to guestimate the idle period and got confused?
> Neither nr_running nor cpu_load have anything to do with how busy we
> are.

no this has nothing to do with the guestimation.

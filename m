Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456Ab2J0Dgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 23:36:39 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:51542 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934411Ab2J0Dgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 23:36:38 -0400
Message-ID: <508B56A7.1010501@linux.vnet.ibm.com>
Date: Sat, 27 Oct 2012 09:06:07 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, svaidy@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, venki@google.com, robin.randhawa@arm.com,
        linaro-dev@lists.linaro.org, mjg59@srcf.ucam.org,
        viresh.kumar@linaro.org, akpm@linux-foundation.org,
        amit.kucheria@linaro.org, deepthi@linux.vnet.ibm.com,
        paul.mckenney@linaro.org, arjan@linux.intel.com,
        paulmck@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, tglx@linutronix.de, Arvind.Chauhan@arm.com,
        pjt@google.com, Morten.Rasmussen@arm.com,
        linux-arm-kernel@lists.infradead.org, suresh.b.siddha@intel.com
Subject: Re: [RFC PATCH 00/13] sched: Integrating Per-entity-load-tracking
 with the core scheduler
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com> <1351180603.12171.31.camel@twins> <50898118.1050402@linux.vnet.ibm.com> <1351254553.16863.52.camel@twins> <20121026130715.GB9886@gmail.com>
In-Reply-To: <20121026130715.GB9886@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12102703-3864-0000-0000-000005416173
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 06:37 PM, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
>> [...]
>>
>> So a sane series would introduce maybe two functions: 
>> cpu_load() and task_load() and use those where we now use 
>> rq->load.weight and p->se.load.weight for load balancing 
>> purposes. Implement these functions using those two 
>> expression. So effectively this patch is a NOP.
>>
>> Secondly, switch these two functions over to the per-task 
>> based averages.
>>
>> Tada! all done. The load balancer will then try and equalize 
>> effective load instead of instant load.
>>
>> It will do the 3x10% vs 100% thing correctly with just those 
>> two patches. Simply because it will report a lower cpu-load 
>> for the 3x10% case than it will for the 100% case, no need to 
>> go fudge about in the load-balance internals.
>>
>> Once you've got this correctly done, you can go change 
>> balancing to better utilize the new metric, like use the 
>> effective load instead of nr_running against the capacity and 
>> things like that. But for every such change you want to be 
>> very careful and run all the benchmarks you can find -- in 
>> fact you want to do that after the 2nd patch too.
> 
> If anyone posted that simple two-patch series that switches over 
> to the new load metrics I'd be happy to test the performance of 
> those.
> 
> Having two parallel load metrics is really not something that we 
> should tolerate for too long.
> 
> Thanks,
> 
> 	Ingo
> 
Right Ingo.I will incorporate this approach and post out very soon.

Thank you

Regards
Preeti


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab1GSWjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:39:19 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:7185 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1GSWjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:39:18 -0400
Message-ID: <4E2607A1.2090604@hp.com>
Date: Tue, 19 Jul 2011 16:39:29 -0600
From: Terry Loftin <terry.loftin@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Bob Montgomery <bob.montgomery@hp.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 2/2] sched: Fix "divide error: 0000" in find_busiest_group
References: <4E25F009.1040309@hp.com> <1311110290.2617.3.camel@laptop>	 <4E26036E.1070903@hp.com> <1311114795.2617.10.camel@laptop>
In-Reply-To: <1311114795.2617.10.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/19/2011 04:33 PM, Peter Zijlstra wrote:
> On Tue, 2011-07-19 at 16:21 -0600, Terry Loftin wrote:
>>> So you're running on a platform (unspecified) where we use a raw
>>> sched_clock() that is buggy. Again, you're fixing symptoms not causes. 
>>>
>> This x86_64.  This is the actual cause, unless the rq->clock
>> value should never roll, in which case, the clock roll is the
>> actual cause and you can disregard these patches.
> 
> Its supposed to roll over on the full 64bit, and I think x86_64 only
> suffers this if you have sched_clock_stable set to 1.
> 
> So I think the correct fix is disabling that logic for now. John Stultz
> was working on some patches to fix __cycles_2_ns().
> 
> Something like the below perhaps.
OK - this would also avoid the problem I came across.  Thank you
for your time.

-T
> 
> ---
>  arch/x86/kernel/cpu/intel.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 1edf5ba..dba0482 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -91,8 +91,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>  	if (c->x86_power & (1 << 8)) {
>  		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
>  		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
> -		if (!check_tsc_unstable())
> -			sched_clock_stable = 1;
>  	}
>  
>  	/*
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2L0UCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 15:02:09 -0500
Received: from mail.digium.com ([216.207.245.2]:47512 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab2L0UCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 15:02:07 -0500
X-Greylist: delayed 1580 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2012 15:02:07 EST
Date: Thu, 27 Dec 2012 13:23:37 -0600
From: Shaun Ruffell <sruffell@digium.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/perf_events: build fix
Message-ID: <20121227192337.GB14257@digium.com>
References: <50AFB24002000078000AAE8A@nat28.tlf.novell.com>
 <20121227192106.GA14257@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121227192106.GA14257@digium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[forgot to copy lkml]

Hi Jan,

On Fri, Nov 23, 2012 at 04:28:32PM +0000, Jan Beulich wrote:
> At least some older gcc versions dislike mixing constant and non-const
> data in the same section ("... causes a section type confict"). Newer
> gcc simply emits the section as writable (which isn't what we want, but
> also is not a big problem as it gets discarded post-init anyway).
> 
> Also get the Knight's Corner definitions in sync.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  arch/x86/kernel/cpu/perf_event_knc.c |    4 ++--
>  arch/x86/kernel/cpu/perf_event_p6.c  |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> --- 3.7-rc6/arch/x86/kernel/cpu/perf_event_knc.c
> +++ 3.7-rc6-x86-perf-initconst/arch/x86/kernel/cpu/perf_event_knc.c
> @@ -17,7 +17,7 @@ static const u64 knc_perfmon_event_map[]
>    [PERF_COUNT_HW_BRANCH_MISSES]		= 0x002b,
>  };
>  
> -static __initconst u64 knc_hw_cache_event_ids
> +static const u64 __initconst knc_hw_cache_event_ids
>  				[PERF_COUNT_HW_CACHE_MAX]
>  				[PERF_COUNT_HW_CACHE_OP_MAX]
>  				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
> @@ -284,7 +284,7 @@ static struct attribute *intel_knc_forma
>  	NULL,
>  };
>  
> -static __initconst struct x86_pmu knc_pmu = {
> +static const struct x86_pmu knc_pmu __initconst = {
>  	.name			= "knc",
>  	.handle_irq		= knc_pmu_handle_irq,
>  	.disable_all		= knc_pmu_disable_all,
> --- 3.7-rc6/arch/x86/kernel/cpu/perf_event_p6.c
> +++ 3.7-rc6-x86-perf-initconst/arch/x86/kernel/cpu/perf_event_p6.c
> @@ -19,7 +19,7 @@ static const u64 p6_perfmon_event_map[]
>  
>  };
>  
> -static __initconst u64 p6_hw_cache_event_ids
> +static const u64 __initconst p6_hw_cache_event_ids
>  				[PERF_COUNT_HW_CACHE_MAX]
>  				[PERF_COUNT_HW_CACHE_OP_MAX]
>  				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
> 
> 
> 
> --

I was testing out 3.8-rc1 when I ran into the same problem resolved
by this patch when building with gcc (GCC) 4.1.2 20080704 (Red Hat
4.1.2-51)

Were you given a reason why this shouldn't be needed?

It looks like the build error was introduced by (e09df47 "perf/x86:
Update/fix generic events on P6 PMU") which is in v3.7 as well.

Thanks,
Shaun

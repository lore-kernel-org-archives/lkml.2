Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0H0NqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:46:13 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:34010 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab0H0NqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:46:09 -0400
X-SpamScore: -13
X-BigFish: VPS-13(ze80izbb2cK1432N98dNzz1202hzz8275dhz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
X-WSS-ID: 0L7TCRN-01-1XC-02
X-M-MSG: 
Date: Fri, 27 Aug 2010 15:43:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 2/4] sh: Accessor functions for the sh_pmu state
Message-ID: <20100827134301.GL22783@erda.amd.com>
References: <cover.1282848651.git.matt@console-pimps.org>
 <f259830dbccb084d27d127676b979d9cb502e36f.1282848651.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f259830dbccb084d27d127676b979d9cb502e36f.1282848651.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.08.10 15:09:17, Matt Fleming wrote:
> Introduce some accessor functions for getting at the name and number of
> counters of the current sh_pmu instance.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>
> ---
>  arch/sh/include/asm/perf_event.h |    2 ++
>  arch/sh/kernel/perf_event.c      |   13 +++++++++++++
>  2 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/sh/include/asm/perf_event.h b/arch/sh/include/asm/perf_event.h
> index 3d0c9f3..5b7fa84 100644
> --- a/arch/sh/include/asm/perf_event.h
> +++ b/arch/sh/include/asm/perf_event.h
> @@ -25,6 +25,8 @@ struct sh_pmu {
>  extern int register_sh_pmu(struct sh_pmu *);
>  extern int reserve_pmc_hardware(void);
>  extern void release_pmc_hardware(void);
> +extern int sh_pmu_num_events(void);
> +extern const char *sh_pmu_name(void);
>  
>  static inline void set_perf_event_pending(void)
>  {
> diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
> index 7a3dc35..086f788 100644
> --- a/arch/sh/kernel/perf_event.c
> +++ b/arch/sh/kernel/perf_event.c
> @@ -60,6 +60,19 @@ static inline int sh_pmu_initialized(void)
>  }
>  
>  /*
> + * Return the number of events for the current sh_pmu.
> + */
> +int sh_pmu_num_events(void)
> +{
> +	return sh_pmu->num_events;
> +}
> +
> +const char *sh_pmu_name(void)
> +{
> +	return sh_pmu->name;
> +}
> +
> +/*

This probably needs EXPORT_SYMBOLS*(), but not really sure. Have you
compiled oprofile as module?

This accessor functions should be generic for all architectures.

-Robert

>   * Release the PMU if this is the last perf_event.
>   */
>  static void hw_perf_event_destroy(struct perf_event *event)
> -- 
> 1.7.1
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


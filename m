Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab1IIBiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:38:12 -0400
Received: from ozlabs.org ([203.10.76.45]:35492 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757661Ab1IIBiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:38:10 -0400
From: Michael Neuling <michael.neuling@au1.ibm.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf events, powerpc: Add POWER7 stalled-cycles-frontend/backend events
In-reply-to: <4E5C6A7D.2010909@linux.vnet.ibm.com>
References: <4E5C6A7D.2010909@linux.vnet.ibm.com>
Comments: In-reply-to Anshuman Khandual <khandual@linux.vnet.ibm.com>
   message dated "Tue, 30 Aug 2011 10:13:41 +0530."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Fri, 09 Sep 2011 11:38:09 +1000
Message-ID: <25545.1315532289@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> perf events, powerpc: Add POWER7 stalled-cycles-frontend/backend events
> 
> 	Extent the POWER7 PMU driver with definitions
> 	for generic front-end and back-end stall events.

Anshuman,

Can you explain what these P7 events actually are and how they relate to
Ingo's original comment on this in
8f62242246351b5a4bc0c1f00c0c7003edea128a

    Both events limit performance: most front end stalls tend to be
    caused by branch misprediction or instruction fetch cachemisses,
    backend stalls can be caused by various resource shortages or
    inefficient instruction scheduling.

> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> 
> diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
> index 593740f..e5d2844 100644
> --- a/arch/powerpc/kernel/power7-pmu.c
> +++ b/arch/powerpc/kernel/power7-pmu.c
> @@ -297,6 +297,8 @@ static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
>  
>  static int power7_generic_events[] = {
>  	[PERF_COUNT_HW_CPU_CYCLES] = 0x1e,
> +	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x100f8, /* GCT_NOSLOT_CYC */

eg. Is this Global Completion Table (GCT) empty?

> +	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x4000a,  /* CMPLU_STALL */

eg. Is this instruction completion stall?

Mikey

>  	[PERF_COUNT_HW_INSTRUCTIONS] = 2,
>  	[PERF_COUNT_HW_CACHE_REFERENCES] = 0xc880,	/* LD_REF_L1_LSU*/
>  	[PERF_COUNT_HW_CACHE_MISSES] = 0x400f0,		/* LD_MISS_L1	*/
> 
> -- 
> Anshuman Khandual 
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

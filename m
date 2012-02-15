Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab2BOJSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:18:54 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:57344 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab2BOJSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:18:50 -0500
Message-ID: <4F3B786C.2080809@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 14:48:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/12] arch/arm: remove references to cpu_*_map.
References: <1329281884.28702.rusty@rustcorp.com.au>
In-Reply-To: <1329281884.28702.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12021423-0260-0000-0000-0000008B1164
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 10:28 AM, Rusty Russell wrote:

> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> This has been obsolescent for a while; time for the final push.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> ---

[...]

> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -359,7 +359,7 @@ void __init smp_prepare_cpus(unsigned in
>  		 * re-initialize the map in platform_smp_prepare_cpus() if
>  		 * present != possible (e.g. physical hotplug).
>  		 */
> -		init_cpu_present(&cpu_possible_map);
> +		init_cpu_present(cpu_possible_mask);
>  
>  		/*
>  		 * Initialise the SCU if there are more than one CPU
> @@ -577,8 +577,9 @@ void smp_send_stop(void)
>  	unsigned long timeout;
>  
>  	if (num_online_cpus() > 1) {
> -		cpumask_t mask = cpu_online_map;
> -		cpu_clear(smp_processor_id(), mask);
> +		struct cpumask mask;
> +		cpumask_copy(&mask, cpu_online_mask);
> +		cpumask_clear_cpu(&mask, smp_processor_id());
>  


This should be the other way around:
		cpumask_clear_cpu(smp_processor_id(), &mask);

>  		smp_cross_call(&mask, IPI_CPU_STOP);
>  	}
> 


Regards,
Srivatsa S. Bhat


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab1ADSEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:04:05 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:45107 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab1ADSED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:04:03 -0500
Message-ID: <4D23610C.1060009@ti.com>
Date: Tue, 04 Jan 2011 12:03:56 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: jean.pihet@newoldbits.com
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, trenn@suse.de,
        linux-omap@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        linux-perf-users@vger.kernel.org, rjw@sisk.pl,
        Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 2/3] perf: add OMAP support for the new power events
References: <1294136263-24020-1-git-send-email-j-pihet@ti.com> <1294136263-24020-3-git-send-email-j-pihet@ti.com>
In-Reply-To: <1294136263-24020-3-git-send-email-j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jean.pihet@newoldbits.com had written, on 01/04/2011 04:17 AM, the 
following:
[..]
> diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
> index 0ec8a04..0ee0b0e 100644
> --- a/arch/arm/mach-omap2/pm34xx.c
> +++ b/arch/arm/mach-omap2/pm34xx.c
> @@ -29,6 +29,7 @@
>  #include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/console.h>
> +#include <trace/events/power.h>
>  
>  #include <plat/sram.h>
>  #include <plat/clockdomain.h>
> @@ -506,8 +507,14 @@ static void omap3_pm_idle(void)
>  	if (omap_irq_pending() || need_resched())
>  		goto out;
>  
> +	trace_power_start(POWER_CSTATE, 1, smp_processor_id());
> +	trace_cpu_idle(1, smp_processor_id());
> +
>  	omap_sram_idle();
>  
> +	trace_power_end(smp_processor_id());
> +	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());

Dumb question: it just tells me which C state was attempted - not if 
actually succeeded in hitting it rt? Does'nt this give us a false data?

[..]
> diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
> index fc62fb5..7cbb09b 100644
> --- a/arch/arm/plat-omap/clock.c
> +++ b/arch/arm/plat-omap/clock.c
(from an offline discussion on a related topic): Would it also be nice 
to hook on mach-omap2/clock.c points as well to hook on indirect changes?
[..]

-- 
Regards,
Nishanth Menon

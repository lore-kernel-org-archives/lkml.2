Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1HJOhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:37:37 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:57149 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752896Ab1HJOhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:37:35 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+3bXNL+6neoDkluEJWp6sV
Date: Wed, 10 Aug 2011 07:37:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Hemant Pedanekar <hemantp@ti.com>
Cc: linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] omap: timer: Set dmtimer used as clocksource in
 autoreload mode
Message-ID: <20110810143732.GN1939@atomide.com>
References: <1312982375-11848-1-git-send-email-hemantp@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312982375-11848-1-git-send-email-hemantp@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hemant Pedanekar <hemantp@ti.com> [110810 06:14]:
> If CONFIG_OMAP_32K_TIMER is not selected and dmtimer is used as clocksource, the
> timer stops counting once overflow occurs as it was not set in autoreload mode.
> This results into timekeeping failure: for example, 'sleep 1' at the shell after
> the timer counter overflow would hang.
> 
> This patch sets up autoreload when starting the clocksource timer which fixes
> the above issue.

Thanks for updating this, will apply into fixes.

Tony


> 
> Signed-off-by: Hemant Pedanekar <hemantp@ti.com>
> ---
>  arch/arm/mach-omap2/timer.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index e964072..cf1de7d 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -293,7 +293,8 @@ static void __init omap2_gp_clocksource_init(int gptimer_id,
>  	pr_info("OMAP clocksource: GPTIMER%d at %lu Hz\n",
>  		gptimer_id, clksrc.rate);
>  
> -	__omap_dm_timer_load_start(clksrc.io_base, OMAP_TIMER_CTRL_ST, 0, 1);
> +	__omap_dm_timer_load_start(clksrc.io_base,
> +			OMAP_TIMER_CTRL_ST | OMAP_TIMER_CTRL_AR, 0, 1);
>  	init_sched_clock(&cd, dmtimer_update_sched_clock, 32, clksrc.rate);
>  
>  	if (clocksource_register_hz(&clocksource_gpt, clksrc.rate))
> -- 
> 1.7.3.5
> 

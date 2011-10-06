Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab1JFUSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 16:18:36 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60535 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755497Ab1JFUSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 16:18:35 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18gZr4CBS6PQvaf7CYsLU6f
Date: Thu, 6 Oct 2011 13:18:27 -0700
From: Tony Lindgren <tony@atomide.com>
To: =?utf-8?Q?V=C3=ADctor_Manuel_J=C3=A1quez?= Leal 
	<vjaquez@igalia.com>
Cc: Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Timo Teras <timo.teras@solidboot.com>,
        Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH v2] omap: dmtimer: convert printk to pr_err / WARN
Message-ID: <20111006201827.GT6324@atomide.com>
References: <1317898106-1891-1-git-send-email-vjaquez@igalia.com>
 <1317922204-12512-1-git-send-email-vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1317922204-12512-1-git-send-email-vjaquez@igalia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Víctor Manuel Jáquez Leal <vjaquez@igalia.com> [111006 09:56]:
> Convert a printk(KERN_ERR) message in the driver to pr_err(), and
> use WARN() instead of a custom log message with a stack dump.
> 
> Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>

Looks like this won't apply with the changes we have queued up,
care to refresh this against linux-omap master branch (or dmtimer
branch)?

Regards,

Tony

> ---
>  arch/arm/plat-omap/dmtimer.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
> index ee9f6eb..dead0f3 100644
> --- a/arch/arm/plat-omap/dmtimer.c
> +++ b/arch/arm/plat-omap/dmtimer.c
> @@ -322,7 +322,7 @@ static void omap_dm_timer_wait_for_reset(struct omap_dm_timer *timer)
>  	while (!(omap_dm_timer_read_reg(timer, OMAP_TIMER_SYS_STAT_REG) & 1)) {
>  		c++;
>  		if (c > 100000) {
> -			printk(KERN_ERR "Timer failed to reset\n");
> +			pr_err("Timer failed to reset\n");
>  			return;
>  		}
>  	}
> @@ -397,9 +397,7 @@ struct omap_dm_timer *omap_dm_timer_request_specific(int id)
>  	spin_lock_irqsave(&dm_timer_lock, flags);
>  	if (id <= 0 || id > dm_timer_count || dm_timers[id-1].reserved) {
>  		spin_unlock_irqrestore(&dm_timer_lock, flags);
> -		printk("BUG: warning at %s:%d/%s(): unable to get timer %d\n",
> -		       __FILE__, __LINE__, __func__, id);
> -		dump_stack();
> +		WARN(1, "unable to get timer %d\n", id);
>  		return NULL;
>  	}
>  
> -- 
> 1.7.6.3
> 

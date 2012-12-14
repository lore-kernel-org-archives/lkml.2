Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab2LNSxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:53:44 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:17277 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932106Ab2LNSxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:53:43 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+GJkuGu82GUDSKC1S1vrKf
Date: Fri, 14 Dec 2012 10:53:41 -0800
From: Tony Lindgren <tony@atomide.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] arch/arm/mach-omap2/dpll3xxx.c: drop if around
 WARN_ON
Message-ID: <20121214185340.GJ4989@atomide.com>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
 <1351974625-10282-7-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351974625-10282-7-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Julia Lawall <Julia.Lawall@lip6.fr> [121103 13:32]:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Just use WARN_ON rather than an if containing only WARN_ON(1).

Thanks applying this one into omap-for-v3.8/fixes-for-merge-window.

Regards,

Tony
 
> A simplified version of the semantic patch that makes this transformation
> is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> - if (e) WARN_ON(1);
> + WARN_ON(e);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  arch/arm/mach-omap2/dpll3xxx.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xxx.c
> index eacf51f..ed855b0 100644
> --- a/arch/arm/mach-omap2/dpll3xxx.c
> +++ b/arch/arm/mach-omap2/dpll3xxx.c
> @@ -478,8 +478,7 @@ int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
>  		if (!soc_is_am33xx() && !cpu_is_omap44xx() && !cpu_is_omap3630()) {
>  			freqsel = _omap3_dpll_compute_freqsel(clk,
>  						dd->last_rounded_n);
> -			if (!freqsel)
> -				WARN_ON(1);
> +			WARN_ON(!freqsel);
>  		}
>  
>  		pr_debug("clock: %s: set rate: locking rate to %lu.\n",
> 

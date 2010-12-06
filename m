Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0LFXwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:52:14 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50412 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0LFXwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:52:12 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ECKDxlKgKAnhzZL1OYWgm
Date: Mon, 6 Dec 2010 15:51:58 -0800
From: Tony Lindgren <tony@atomide.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: plat-omap: counter_32k: use IS_ERR() instead of
 NULL check
Message-ID: <20101206235158.GU8345@atomide.com>
References: <1290791163-21190-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290791163-21190-1-git-send-email-segoon@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vasiliy Kulikov <segoon@openwall.com> [101126 08:56]:
> clk_get() returns ERR_PTR() on error, not NULL.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Cannot compile this driver, so it is not tested at all.

Thanks will merge this.

Tony

> 
>  arch/arm/plat-omap/counter_32k.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/counter_32k.c b/arch/arm/plat-omap/counter_32k.c
> index 155fe43..c1e0d00 100644
> --- a/arch/arm/plat-omap/counter_32k.c
> +++ b/arch/arm/plat-omap/counter_32k.c
> @@ -164,7 +164,7 @@ static int __init omap_init_clocksource_32k(void)
>  			return -ENODEV;
>  
>  		sync_32k_ick = clk_get(NULL, "omap_32ksync_ick");
> -		if (sync_32k_ick)
> +		if (!IS_ERR(sync_32k_ick))
>  			clk_enable(sync_32k_ick);
>  
>  		clocksource_32k.mult = clocksource_hz2mult(32768,
> -- 
> 1.7.0.4
> 

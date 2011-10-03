Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab1JCRxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:53:20 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27398 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756159Ab1JCRxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:53:11 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Vaevie31SgXLwHb8wK314
Date: Mon, 3 Oct 2011 10:53:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/30] ARM: omap: enable building omap2 without
 omap2420/2430
Message-ID: <20111003175308.GR6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317566760-25681-6-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [111002 07:13]:
> Kconfig allows selecting CONFIG_OMAP2 but no specific SOC, the options
> being omap2420 and omap2430, but that leads to a build error when
> omap3 or omap4 are also enabled and the MULTI_OMAP2 symbol is
> undefined.
> 
> This adds another clause to plat/multi.h, mainly to allow all
> possible randconfig combinations to build cleanly.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/plat-omap/include/plat/multi.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/include/plat/multi.h b/arch/arm/plat-omap/include/plat/multi.h
> index 999ffba..fb7f196 100644
> --- a/arch/arm/plat-omap/include/plat/multi.h
> +++ b/arch/arm/plat-omap/include/plat/multi.h
> @@ -82,6 +82,11 @@
>  #  define OMAP_NAME omap2430
>  # endif
>  #endif
> +#ifdef CONFIG_ARCH_OMAP2
> +# ifndef OMAP_NAME
> +#  define OMAP_NAME omap2
> +# endif
> +#endif
>  #ifdef CONFIG_ARCH_OMAP3
>  # ifdef OMAP_NAME
>  #  undef  MULTI_OMAP2
> -- 
> 1.7.5.4
> 

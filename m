Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2CWR2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:28:50 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:25992 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab2CWR2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:28:49 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18dYHQxhCtnBB1vROpJfRp6
Date: Fri, 23 Mar 2012 10:28:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: mathieu.poirier@linaro.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 7/9] omap2plus: ensure that one of omap2/3/4 is selected
Message-ID: <20120323172845.GC9859@atomide.com>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
 <1332522836-29517-8-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332522836-29517-8-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> [120323 10:16]:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Random configurations can fail if none of the omap families
> in mach-omap2 is selected. This patch automatically selects
> omap2 if the user has not made any other choice.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/Kconfig |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 0279e9e..b244e80 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -55,6 +55,16 @@ config ARCH_OMAP4
>  	select USB_ARCH_HAS_EHCI
>  	select ARM_CPU_SUSPEND if PM
>  
> +config ARCH_OMAP2_AUTO
> +	bool
> +	depends on !ARCH_OMAP3 && !ARCH_OMAP4
> +	select ARCH_OMAP2
> +	default y
> +	help
> +	  At least one of OMAP2/OMAP3/OMAP4 needs to be enabled, this
> +	  selects OMAP2 if nothing else gets selected, to avoid non-building
> +	  configurations.
> +
>  comment "OMAP Core Type"
>  	depends on ARCH_OMAP2

Hmm yeah omap2 makes the smallest build, so randconfig builds
faster than it would for omap3 or 4.

But isn't there now still a chance that randconfig does not
select ARCH_OMAP2_AUTO either?

Regards,

Tony

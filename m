Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2IQR2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:28:54 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:31878 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755861Ab2IQR2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:28:52 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+xBbDBOZL0/nrnvISyWzYq
Date: Mon, 17 Sep 2012 10:28:49 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <mporter@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>
Subject: Re: [PATCH v2 2/2] ARM: OMAP2+: Enable pinctrl dummy states
Message-ID: <20120917172849.GQ4521@atomide.com>
References: <1347902538-21208-1-git-send-email-mporter@ti.com>
 <1347902538-21208-3-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347902538-21208-3-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <mporter@ti.com> [120917 10:21]:
> Enable pinctrl dummy states for all OMAP platforms that don't
> populate DT. This allows drivers to be converted to pinctrl
> and not generate new warnings on platforms that do not provide
> pinctrl data. These platforms already have pinmuxes configured
> before the drivers probe.

Thanks this should do the trick until we've converted to use DT.
I'll queue this for the upcoming merge window.

Regards,

Tony
 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/mach-omap2/devices.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 1efa984..6ef4010 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -17,6 +17,7 @@
>  #include <linux/err.h>
>  #include <linux/slab.h>
>  #include <linux/of.h>
> +#include <linux/pinctrl/machine.h>
>  #include <linux/platform_data/omap4-keypad.h>
>  
>  #include <asm/mach-types.h>
> @@ -628,6 +629,10 @@ static inline void omap_init_vout(void) {}
>  
>  static int __init omap2_init_devices(void)
>  {
> +	/* Enable dummy states for those platforms without pinctrl support */
> +	if (!of_have_populated_dt())
> +		pinctrl_provide_dummies();
> +
>  	/*
>  	 * please keep these calls, and their implementations above,
>  	 * in alphabetical order so they're easier to sort through.
> -- 
> 1.7.9.5
> 

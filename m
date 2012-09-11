Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2IKSDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:03:11 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48398 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753183Ab2IKSDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:03:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/K302g6y9Dn9dSCKw/0qkH
Date: Tue, 11 Sep 2012 11:03:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <mporter@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>
Subject: Re: [PATCH 2/2] ARM: OMAP2+: Enable pinctrl dummy states
Message-ID: <20120911180306.GI23092@atomide.com>
References: <1347385599-27558-1-git-send-email-mporter@ti.com>
 <1347385599-27558-3-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347385599-27558-3-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <mporter@ti.com> [120911 10:46]:
> Enable pinctrl dummy states for all OMAP platforms. This allows
> drivers to be converted to pinctrl while still running on
> platforms that do not provide pinctrl data.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/mach-omap2/devices.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index c00c689..577cd04 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -17,6 +17,7 @@
>  #include <linux/err.h>
>  #include <linux/slab.h>
>  #include <linux/of.h>
> +#include <linux/pinctrl/machine.h>
>  #include <linux/platform_data/omap4-keypad.h>
>  
>  #include <mach/hardware.h>
> @@ -631,6 +632,9 @@ static inline void omap_init_vout(void) {}
>  
>  static int __init omap2_init_devices(void)
>  {
> +	/* Enable dummy states for those platforms without pinctrl support */
> +	pinctrl_provide_dummies();
> +
>  	/*
>  	 * please keep these calls, and their implementations above,
>  	 * in alphabetical order so they're easier to sort through.

Hmm I think this may need to be board specific. And may need to
be board specific and depend on unpopulated device tree?

For board-generic.c we always want to see the warnings. And some boards
insist on doing all the muxing only in the bootloader.

Regards,

Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0HKSx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:53:29 -0400
Received: from mail.logicpd.com ([66.162.60.3]:2159 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755139Ab0HKSx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:53:28 -0400
Content-class: urn:content-classes:message
Subject: RE: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM andTORPEDO development kits
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Wed, 11 Aug 2010 13:53:18 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <77A0A4DB5BF2A44283E5522C27234AC6021C82D5@EDPRSRV011.logicpd.com>
In-Reply-To: <20100811175450.GA17425@merkur.ravnborg.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM andTORPEDO development kits
Thread-Index: Acs5flFtXI7zB9UvRwGCe+XKlaBnEAAB1r7Q
From: "Jacob Tanenbaum" <Jacob.Tanenbaum@logicpd.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rmk@arm.linux.org.uk>,
        <tony@atomide.com>
X-OriginalArrivalTime: 11 Aug 2010 18:53:27.0438 (UTC) FILETIME=[7BBA02E0:01CB3986]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Sam Ravnborg [mailto:sam@ravnborg.org] 
Sent: Wednesday, August 11, 2010 1:55 PM
To: Jacob Tanenbaum
Cc: linux@arm.linux.org.uk; linux-omap@vger.kernel.org;
linux-kernel@vger.kernel.org; rmk@arm.linux.org.uk; tony@atomide.com
Subject: Re: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM
andTORPEDO development kits

Hi Jacob.

Some quick comments.

	Sam

> diff --git a/arch/arm/configs/omap3_defconfig
b/arch/arm/configs/omap3_defconfig
> index 5db9a6b..f510dfd 100644
> --- a/arch/arm/configs/omap3_defconfig
> +++ b/arch/arm/configs/omap3_defconfig
> @@ -37,6 +37,8 @@ CONFIG_MACH_OMAP_2430SDP=y
>  CONFIG_MACH_OMAP3_BEAGLE=y
>  CONFIG_MACH_DEVKIT8000=y
>  CONFIG_MACH_OMAP_LDP=y
> +CONFIG_MACH_OMAP3530_LV_SOM=y
> +CONFIG_MACH_OMAP3_TORPEDO=y
>  CONFIG_MACH_OVERO=y
>  CONFIG_MACH_OMAP3EVM=y
>  CONFIG_MACH_OMAP3517EVM=y

Are the omap3_defconfig supposed to enable all omap board variants?
Otherwise leave this change out.

This is the default defconfig that enables most of the options
available, we are just adding our boards to the standard omap3_defconfig


> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index b48bacf..42e7d4a 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -135,6 +135,14 @@ config MACH_OMAP_LDP
>  	default y
>  	select OMAP_PACKAGE_CBB
>  
> +config MACH_OMAP3530_LV_SOM
> +	bool "OMAP3 Logic 3530 LV SOM board"
> +	depends on ARCH_OMAP3
> +
> +config MACH_OMAP3_TORPEDO
> +	bool "OMAP3 Logic 35x Torpedo board"
> +	depends on ARCH_OMAP3
> +

Some help would be beneficial.
URL's to product descriptions etc could be included there.
You may alos consider telling people this is a TI deriviate etc.

Will fix

> +static void __init omap3logic_init_irq(void)
> +{
> +	omap_board_config = omap3logic_config;
> +	omap_board_config_size = ARRAY_SIZE(omap3logic_config);
> +	omap2_init_common_hw(mt46h32m32lf6_sdrc_params,
> +				mt46h32m32lf6_sdrc_params);
> +	omap_init_irq();
> +#ifdef CONFIG_OMAP_32K_TIMER
> +	omap2_gp_clockevent_set_gptimer(12);
> +#endif

Fix this on the called site. There is zero reason
to sprinkle all user of omap2_gp_clockevent_set_gptimer()
with ifdef/endif.

Will fix

> +	/* Ensure SDRC pins are mux'd for self-refresh */
> +/*	omap_cfg_reg(H16_34XX_SDRC_CKE0);
> +	omap_cfg_reg(H17_34XX_SDRC_CKE1);
> +	omap_cfg_reg(SDRC_CKE0);
> +	omap_cfg_reg(SDRC_CKE1); */

Why do we have code that is not in use?

Taken out in the 4th patch made a mistake in rebasing 
Will fix

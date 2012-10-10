Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab2JJTEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:04:11 -0400
Received: from 7.mo3.mail-out.ovh.net ([46.105.57.200]:36734 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757055Ab2JJTEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:04:07 -0400
Date: Wed, 10 Oct 2012 21:01:44 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 3/6] ARM: ux500: Add support for ST-Ericsson's u9540 SoC
Message-ID: <20121010190144.GS12801@game.jcrosoft.org>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
 <1349882335-6786-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349882335-6786-4-git-send-email-lee.jones@linaro.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14313565517828238335
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrudelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrudelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:18 Wed 10 Oct     , Lee Jones wrote:
> First level board support for the u9540.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/cpu-db8500.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
> index 3d8e321..6b7f970 100644
> --- a/arch/arm/mach-ux500/cpu-db8500.c
> +++ b/arch/arm/mach-ux500/cpu-db8500.c
> @@ -17,6 +17,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/mfd/abx500/ab8500.h>
> +#include <linux/mfd/dbx500-prcmu.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/regulator/machine.h>
> @@ -319,6 +320,8 @@ static void __init u8500_init_machine(void)
>  		snowball_pinmaps_init();
>  	else if (of_machine_is_compatible("st-ericsson,hrefv60+"))
>  		hrefv60_pinmaps_init();
> +	else if (of_machine_is_compatible("st-ericsson,u9540")) {}
> +		/* TODO: Add u9540 pinmaps. */
do you via DT no here
>  
>  	/* TODO: Export SoC, USB, cpu-freq and DMA40 */
>  	parent = u8500_of_init_devices();
> @@ -331,6 +334,7 @@ static const char * u8500_dt_board_compat[] = {
>  	"calaosystems,snowball-a9500",
>  	"st-ericsson,hrefv60+",
>  	"st-ericsson,mop500",
> +	"st-ericsson,u9540",
stop to add more compatible sue a more generic one
>  	NULL,
>  };
>  
> @@ -345,4 +349,14 @@ DT_MACHINE_START(U8500_DT, "ST-Ericsson U8500 platform (Device Tree Support)")
>  	.dt_compat      = u8500_dt_board_compat,
>  MACHINE_END
>  
> +DT_MACHINE_START(U9540_DT, "ST-Ericsson 9540 platform (Device Tree Support)")
> +	.map_io		= u8500_map_io,
> +	.init_irq	= ux500_init_irq,
> +	.timer		= &ux500_timer,
> +	.handle_irq	= gic_handle_irq,
> +	.init_machine	= u8500_init_machine,
> +	.init_late	= NULL,
> +	.dt_compat      = u8500_dt_board_compat,
> +MACHINE_END
really?
no need drop it for a more generic on

Best Regards,
J.

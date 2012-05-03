Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab2ECTgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:36:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52059 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418Ab2ECTgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:36:49 -0400
Message-ID: <4FA2DE4B.3070606@gmail.com>
Date: Thu, 03 May 2012 14:36:43 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: a.zummo@towertech.it, grant.likely@secretlab.ca,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH RESEND v5] rtc: Add device tree support for LPC32xx
References: <1336073581-25667-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1336073581-25667-1-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 02:33 PM, Roland Stigge wrote:
> This patch adds device tree support for rtc-lpc32xx.c
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
> 
> Applies to v3.4-rc5
> 
> Changes since v4:
> * Reduced "compatible" strings to just the first one
> 
>  Documentation/devicetree/bindings/rtc/lpc32xx-rtc.txt |   15 +++++++++++++++
>  drivers/rtc/rtc-lpc32xx.c                             |   12 +++++++++++-
>  2 files changed, 26 insertions(+), 1 deletion(-)
> 
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/rtc/lpc32xx-rtc.txt
> @@ -0,0 +1,15 @@
> +* NXP LPC32xx SoC Real Time Clock controller
> +
> +Required properties:
> +- compatible: must be "nxp,lpc3220-rtc"
> +- reg: physical base address of the controller and length of memory mapped
> +  region.
> +- interrupts: The RTC interrupt
> +
> +Example:
> +
> +	rtc@40024000 {
> +		compatible = "nxp,lpc3220-rtc";
> +		reg = <0x40024000 0x1000>;
> +		interrupts = <52 0>;
> +	};
> --- linux-2.6.orig/drivers/rtc/rtc-lpc32xx.c
> +++ linux-2.6/drivers/rtc/rtc-lpc32xx.c
> @@ -19,6 +19,7 @@
>  #include <linux/rtc.h>
>  #include <linux/slab.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  
>  /*
>   * Clock and Power control register offsets
> @@ -386,13 +387,22 @@ static const struct dev_pm_ops lpc32xx_r
>  #define LPC32XX_RTC_PM_OPS NULL
>  #endif
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id lpc32xx_rtc_match[] = {
> +	{ .compatible = "nxp,lpc3220-rtc" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, lpc32xx_rtc_match);
> +#endif
> +
>  static struct platform_driver lpc32xx_rtc_driver = {
>  	.probe		= lpc32xx_rtc_probe,
>  	.remove		= __devexit_p(lpc32xx_rtc_remove),
>  	.driver = {
>  		.name	= RTC_NAME,
>  		.owner	= THIS_MODULE,
> -		.pm	= LPC32XX_RTC_PM_OPS
> +		.pm	= LPC32XX_RTC_PM_OPS,
> +		.of_match_table = of_match_ptr(lpc32xx_rtc_match),
>  	},
>  };
>  
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss


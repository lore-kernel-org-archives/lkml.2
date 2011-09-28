Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1I1ScJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:32:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46567 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab1I1ScH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:32:07 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/8Gc0S+19kTpgoqbljCgtc
Date: Wed, 28 Sep 2011 11:31:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kyle Manna <kyle@kylemanna.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Keerthy <j-keerthy@ti.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] arm: BeagleBoard: add support for the
 twl4030-madc
Message-ID: <20110928183157.GC6324@atomide.com>
References: <CANOLnOPB=wFMPwqGbu9ufh__iM7TquUx3-o95R=gyJcae+gENg@mail.gmail.com>
 <1313119995-15382-1-git-send-email-kyle@kylemanna.com>
 <1313119995-15382-5-git-send-email-kyle@kylemanna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313119995-15382-5-git-send-email-kyle@kylemanna.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kyle Manna <kyle@kylemanna.com> [110811 20:01]:
> Signed-off-by: Kyle Manna <kyle@kylemanna.com>

Missing description, but with that corrected:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/board-omap3beagle.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
> index 3ae16b4..9cc9fa9 100644
> --- a/arch/arm/mach-omap2/board-omap3beagle.c
> +++ b/arch/arm/mach-omap2/board-omap3beagle.c
> @@ -378,7 +378,8 @@ static struct i2c_board_info __initdata beagle_i2c_eeprom[] = {
>  static int __init omap3_beagle_i2c_init(void)
>  {
>  	omap3_pmic_get_config(&beagle_twldata,
> -			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_AUDIO,
> +			TWL_COMMON_PDATA_USB | TWL_COMMON_PDATA_MADC |
> +			TWL_COMMON_PDATA_AUDIO,
>  			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
>  
>  	beagle_twldata.vpll2->constraints.name = "VDVI";
> @@ -456,9 +457,15 @@ static void __init omap3_beagle_init_irq(void)
>  	omap3_init_irq();
>  }
>  
> +static struct platform_device madc_hwmon = {
> +	.name	= "twl4030_madc_hwmon",
> +	.id	= -1,
> +};
> +
>  static struct platform_device *omap3_beagle_devices[] __initdata = {
>  	&leds_gpio,
>  	&keys_gpio,
> +	&madc_hwmon,
>  };
>  
>  static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
> -- 
> 1.7.4.1
> 

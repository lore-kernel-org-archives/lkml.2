Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0GNKHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 06:07:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:40481 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab0GNKHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 06:07:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,201,1278313200"; 
   d="scan'208";a="300018170"
Date: Wed, 14 Jul 2010 12:07:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Hemanth V <hemanthv@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [RFC] [PATCH] mfd: Support  for TWL6030 PWM
Message-ID: <20100714100713.GC2771@sortiz-mobl>
References: <56025.10.24.255.17.1278591051.squirrel@dbdmail.itg.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56025.10.24.255.17.1278591051.squirrel@dbdmail.itg.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemanth,

On Thu, Jul 08, 2010 at 05:40:51PM +0530, Hemanth V wrote:
> From 2c6efcebf2790a4c968309360cfc3559b6d9c110 Mon Sep 17 00:00:00 2001
> From: Hemanth V <hemanthv@ti.com>
> Date: Thu, 8 Jul 2010 17:04:06 +0530
> Subject: [PATCH] Add support for TWL6030 PWM
> 
> TWL6030 supports PWM (Pulse Width Modulator) which is used
> to control charging LED. PWM allows for controlling brightness.
> This patch implements the APIs required by leds-pwm driver.
> 
> Signed-off-by: Hemanth V <hemanthv@ti.com>
> ---
>  drivers/mfd/Kconfig       |    9 +++
>  drivers/mfd/Makefile      |    3 +-
>  drivers/mfd/twl6030-pwm.c |  163 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 174 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/mfd/twl6030-pwm.c
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index c7c11ef..4459fe5 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -162,6 +162,15 @@ config TWL6030_GPADC
>  	  Say yes here if you want support for the TWL6030 General Purpose
>  	  A/D Convertor.
> 
> +config TWL6030_PWM
> +	tristate "TWL6030 PWM (Pulse Width Modulator) Support"
> +	depends on TWL4030_CORE
> +	select HAVE_PWM
> +	default n
> +	help
> +	  Say yes here if you want support for TWL6030 PWM.
> +	  This is used to control charging LED brightness.
> +
>  config MFD_TMIO
>  	bool
>  	default n
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 204a974..e697101 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -34,6 +34,7 @@ obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
>  obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
>  obj-$(CONFIG_TWL4030_CODEC)	+= twl4030-codec.o
>  obj-$(CONFIG_TWL6030_GPADC)	+= twl6030-gpadc.o
I don't have this one on my tree, so the patch didnt apply cleanly.
I fixed it up though, so the patch is applied.


> +obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o
> 
>  obj-$(CONFIG_MFD_MC13783)	+= mc13783-core.o
> 
> @@ -63,4 +64,4 @@ obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
>  obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
>  obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
>  obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
> -obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
> \ No newline at end of file
> +obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
Unrelated change, please avoid that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

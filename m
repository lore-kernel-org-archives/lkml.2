Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1IVWE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:04:29 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:41642 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955Ab1IVWE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:04:26 -0400
From: Kevin Hilman <khilman@ti.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, linux@arm.linux.org.uk,
        sameo@linux.intel.com, tony@atomide.com, christian.gmeiner@gmail.com,
        santosh.shilimkar@ti.com, premi@ti.com, david.woodhouse@intel.com
Subject: Re: [PATCH v3 3/3] OMAP3: Remove auto-selection of PMICs
Organization: Texas Instruments, Inc.
References: <1316698155-954-1-git-send-email-abhilash.kv@ti.com>
	<1316698155-954-2-git-send-email-abhilash.kv@ti.com>
	<1316698155-954-3-git-send-email-abhilash.kv@ti.com>
	<1316698155-954-4-git-send-email-abhilash.kv@ti.com>
Date: Thu, 22 Sep 2011 15:04:21 -0700
In-Reply-To: <1316698155-954-4-git-send-email-abhilash.kv@ti.com> (Abhilash
	K. V.'s message of "Thu, 22 Sep 2011 18:59:15 +0530")
Message-ID: <877h50qlne.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhilash K V <abhilash.kv@ti.com> writes:

> The current implementation almost assumes that only

almost?  ;)

> TWL4030/TWL5030/TWl6030 are (or can be) used with the
> OMAP processors. This is, however, not true.
>
> This patch removes the automatic selection of the PMIC
> from Kconfig.
> All currently used PMICs are now added to omap2plus_defconfig;

I don't think adding them to omap2plus_defconfig is right either, as
those will get stripped out the next time that file is (re)generated.

> any new PMIC that gets supported in future could now be
> enabled here rather than by changing Kconfig for
> ARCH_OMAP2PLUS_TYPICAL

IMO, the right fix is to have the board Kconfig entries select the PMIC
being used on those boards.  That is the only solution that will scale,
and also work when using 'make randconfig'.

Kevin

>
> Signed-off-by: Sanjeev Premi <premi@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
>  arch/arm/configs/omap2plus_defconfig |    3 +++
>  arch/arm/mach-omap2/Kconfig          |    3 ---
>  drivers/mfd/Kconfig                  |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
> index d5f00d7..076b131 100644
> --- a/arch/arm/configs/omap2plus_defconfig
> +++ b/arch/arm/configs/omap2plus_defconfig
> @@ -130,6 +130,9 @@ CONFIG_POWER_SUPPLY=y
>  CONFIG_WATCHDOG=y
>  CONFIG_OMAP_WATCHDOG=y
>  CONFIG_TWL4030_WATCHDOG=y
> +CONFIG_MENELAUS=y
> +CONFIG_TWL4030_CORE=y
> +CONFIG_TWL4030_POWER=y
>  CONFIG_REGULATOR_TWL4030=y
>  CONFIG_REGULATOR_TPS65023=y
>  CONFIG_REGULATOR_TPS6507X=y
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 7edf802..d40f6d2 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -15,9 +15,6 @@ config ARCH_OMAP2PLUS_TYPICAL
>  	select I2C
>  	select I2C_OMAP
>  	select MFD_SUPPORT
> -	select MENELAUS if ARCH_OMAP2
> -	select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
> -	select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
>  	help
>  	  Compile a kernel suitable for booting most boards
>  
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 21574bd..72e15c8 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -238,7 +238,7 @@ config TWL4030_MADC
>  
>  config TWL4030_POWER
>  	bool "Support power resources on TWL4030 family chips"
> -	depends on TWL4030_CORE && ARM
> +	depends on TWL4030_CORE
>  	help
>  	  Say yes here if you want to use the power resources on the
>  	  TWL4030 family chips.  Most of these resources are regulators,

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761970Ab2COVPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:15:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47636 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab2COVPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:15:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: jean.pihet@newoldbits.com
Subject: Re: [PATCH 10/10] ARM: OMAP: SmartReflex: Move smartreflex driver to drivers/
Date: Thu, 15 Mar 2012 22:19:22 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <j-pihet@ti.com>
References: <1331829845-9526-1-git-send-email-j-pihet@ti.com> <1331829845-9526-11-git-send-email-j-pihet@ti.com>
In-Reply-To: <1331829845-9526-11-git-send-email-j-pihet@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201203152219.22985.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 15, 2012, jean.pihet@newoldbits.com wrote:
> From: Jean Pihet <j-pihet@ti.com>
> 
> After a clean-up of the interfaces the OMAP IP driver and class
> support code is now a generic driver.
> Move it to drivers/power/avs/.
> 
> The build is controlled by the following Kconfig options:
>  . CONFIG_POWER_AVS: general knob for Adaptive Voltage Scaling support,
>  . CONFIG_POWER_AVS_OMAP: AVS support on OMAP containing the version 1
>     or version 2 of the SmartReflex IP,
>  . CONFIG_POWER_AVS_OMAP_CLASS3: Class 3 implementation of Smartreflex.
> 
> Signed-off-by: Jean Pihet <j-pihet@ti.com>
> ---
[...]
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index e429008..e4a8fd2 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -41,3 +41,5 @@ obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
>  obj-$(CONFIG_CHARGER_MANAGER)	+= charger-manager.o
>  obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
>  obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
> +
> +obj-$(CONFIG_POWER_AVS)		+= avs/
> diff --git a/drivers/power/avs/Kconfig b/drivers/power/avs/Kconfig
> new file mode 100644
> index 0000000..35b21c4
> --- /dev/null
> +++ b/drivers/power/avs/Kconfig
> @@ -0,0 +1,45 @@
> +menuconfig POWER_AVS
> +	tristate "Adaptive Voltage Scaling class support"
> +	help
> +	  AVS is a power management technique which finely controls the
> +	  operating voltage of a device in order to optimize (i.e. reduce)
> +	  its power consumption.
> +	  At a given operating point the voltage is adapted depending on
> +	  static factors (chip manufacturing process) and dynamic factors
> +	  (temperature depending performance).
> +	  AVS is also called SmartReflex on OMAP devices.
> +
> +	  Say Y here to enable Adaptive Voltage Scaling class support.
> +
> +if POWER_AVS
> +
> +config POWER_AVS_OMAP

I think it would be better to keep this and the next one in the OMAP
arch Kconfig.

> +	bool "AVS support for the OMAP IP versions 1&2"
> +	depends on (ARCH_OMAP3 || ARCH_OMAP4) && PM
> +	help
> +	  Say Y to enable AVS support on OMAP containing the version 1 or
> +	  version 2 of the SmartReflex IP.
> +	  V1 is the 65nm version used in OMAP3430.
> +	  V2 is the update for the 45nm version of the IP used in OMAP3630
> +	  and OMAP4430
> +
> +	  Please note, that by default SmartReflex is only
> +	  initialized and not enabled. To enable the automatic voltage
> +	  compensation for vdd mpu and vdd core from user space,
> +	  user must write 1 to
> +		/debug/smartreflex/sr_<X>/autocomp,
> +	  where X is mpu_iva or core for OMAP3.
> +	  Optionally autocompensation can be enabled in the kernel
> +	  by default during system init via the enable_on_init flag
> +	  which an be passed as platform data to the smartreflex driver.
> +
> +config POWER_AVS_OMAP_CLASS3
> +	bool "Class 3 mode of Smartreflex Implementation"
> +	depends on POWER_AVS_OMAP && TWL4030_CORE
> +	help
> +	  Say Y to enable Class 3 implementation of Smartreflex
> +
> +	  Class 3 implementation of Smartreflex employs continuous hardware
> +	  voltage calibration.
> +
> +endif # POWER_AVS

Thanks,
Rafael

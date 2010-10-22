Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab0JVTmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:42:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32998 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab0JVTmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:42:17 -0400
Date: Fri, 22 Oct 2010 21:42:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nguyen Dinh-R00091 <R00091@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
        bryan.wu@canonical.com, amit.kucheria@canonical.com
Subject: Re: [PATCHv5 2/3] ARM: imx: Add gpio-keys to plat-mxc
Message-ID: <20101022194215.GB8554@pengutronix.de>
References: <1287766575-4092-1-git-send-email-Dinh.Nguyen@freescale.com> <1287766575-4092-2-git-send-email-Dinh.Nguyen@freescale.com> <20101022182812.GA8554@pengutronix.de> <86A0E76937111F4C92FABEC0A2098851051D6090@az33exm21>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86A0E76937111F4C92FABEC0A2098851051D6090@az33exm21>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dinh,

On Fri, Oct 22, 2010 at 11:58:16AM -0700, Nguyen Dinh-R00091 wrote:
> >-----Original Message-----
> >From: Uwe Kleine-König [mailto:u.kleine-koenig@pengutronix.de]
> >Sent: Friday, October 22, 2010 1:28 PM
> >To: Nguyen Dinh-R00091
> >Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk;
> >s.hauer@pengutronix.de; valentin.longchamp@epfl.ch; daniel@caiaq.de; grant.likely@secretlab.ca;
> >bryan.wu@canonical.com; amit.kucheria@canonical.com
> >Subject: Re: [PATCHv5 2/3] ARM: imx: Add gpio-keys to plat-mxc
> >
> >On Fri, Oct 22, 2010 at 11:56:14AM -0500, Dinh.Nguyen@freescale.com wrote:
> >> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> >>
> >> Add imx_add_gpio_keys function to add gpio-keys in plat-mxc
> >>
> >> This patch is based on Sascha Hauer's imx/linux-2.6 for-rmk tree.
> >(This information isn't interesting once the patch is in git, so it can
> >better go after the tripple-dash below.)
> >
> >> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> >Patch 1 depends on this one, so you should swap their order.
> >
> >> ---
> >>  arch/arm/plat-mxc/devices/Kconfig               |    4 +++
> >>  arch/arm/plat-mxc/devices/Makefile              |    1 +
> >>  arch/arm/plat-mxc/devices/platform-gpio_keys.c  |   27 +++++++++++++++++++++++
> >>  arch/arm/plat-mxc/include/mach/devices-common.h |    4 +++
> >>  arch/arm/plat-mxc/include/mach/iomux-mx51.h     |    2 +-
> >>  5 files changed, 37 insertions(+), 1 deletions(-)
> >>  create mode 100644 arch/arm/plat-mxc/devices/platform-gpio_keys.c
> >>
> >> diff --git a/arch/arm/plat-mxc/devices/Kconfig b/arch/arm/plat-mxc/devices/Kconfig
> >> index 4047994..f4772e7 100644
> >> --- a/arch/arm/plat-mxc/devices/Kconfig
> >> +++ b/arch/arm/plat-mxc/devices/Kconfig
> >> @@ -9,6 +9,10 @@ config IMX_HAVE_PLATFORM_FLEXCAN
> >>  	select HAVE_CAN_FLEXCAN
> >>  	bool
> >>
> >> +config IMX_HAVE_PLATFORM_GPIO_KEYS
> >> +	bool
> >> +	default y if ARCH_MX51
> >> +
> >>  config IMX_HAVE_PLATFORM_IMX_I2C
> >>  	bool
> >>
> >> diff --git a/arch/arm/plat-mxc/devices/Makefile b/arch/arm/plat-mxc/devices/Makefile
> >> index 0a3c1f0..45aefeb 100644
> >> --- a/arch/arm/plat-mxc/devices/Makefile
> >> +++ b/arch/arm/plat-mxc/devices/Makefile
> >> @@ -1,6 +1,7 @@
> >>  obj-$(CONFIG_IMX_HAVE_PLATFORM_ESDHC) += platform-esdhc.o
> >>  obj-$(CONFIG_IMX_HAVE_PLATFORM_FEC) += platform-fec.o
> >>  obj-$(CONFIG_IMX_HAVE_PLATFORM_FLEXCAN) += platform-flexcan.o
> >> +obj-$(CONFIG_IMX_HAVE_PLATFORM_GPIO_KEYS) += platform-gpio_keys.o
> >>  obj-y += platform-imx-dma.o
> >>  obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX_I2C) += platform-imx-i2c.o
> >>  obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX_SSI) += platform-imx-ssi.o
> >> diff --git a/arch/arm/plat-mxc/devices/platform-gpio_keys.c b/arch/arm/plat-mxc/devices/platform-
> >gpio_keys.c
> >> new file mode 100644
> >> index 0000000..1c53a53
> >> --- /dev/null
> >> +++ b/arch/arm/plat-mxc/devices/platform-gpio_keys.c
> >> @@ -0,0 +1,27 @@
> >> +/*
> >> + * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
> >> + *
> >> + * This program is free software; you can redistribute it and/or
> >> + * modify it under the terms of the GNU General Public License
> >> + * as published by the Free Software Foundation; either version 2
> >> + * of the License, or (at your option) any later version.
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public License
> >> + * along with this program; if not, write to the Free Software
> >> + * Foundation, Inc., 51 Franklin Street, Fifth Floor,
> >> + * Boston, MA  02110-1301, USA.
> >> + */
> >> +#include <asm/sizes.h>
> >> +#include <mach/hardware.h>
> >> +#include <mach/devices-common.h>
> >> +
> >> +struct platform_device *__init imx_add_gpio_keys(
> >> +		const struct gpio_keys_platform_data *pdata)
> >> +{
> >> +	return imx_add_platform_device("gpio-keys", -1, NULL,
> >> +		 0, pdata, sizeof(*pdata));
> >> +}
> >> diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-
> >mxc/include/mach/devices-common.h
> >> index 86d7575..8c6896f 100644
> >> --- a/arch/arm/plat-mxc/include/mach/devices-common.h
> >> +++ b/arch/arm/plat-mxc/include/mach/devices-common.h
> >> @@ -29,6 +29,10 @@ struct platform_device *__init imx_add_flexcan(int id,
> >>  		resource_size_t irq,
> >>  		const struct flexcan_platform_data *pdata);
> >>
> >> +#include <linux/gpio_keys.h>
> >> +struct platform_device *__init imx_add_gpio_keys(
> >> +		const struct gpio_keys_platform_data *pdata);
> >> +
> >>  #include <mach/i2c.h>
> >>  struct imx_imx_i2c_data {
> >>  	int id;
> >> diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-
> >mx51.h
> >> index e46b1c2..7ae27e8 100644
> >> --- a/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> >> +++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> >> @@ -114,7 +114,7 @@ typedef enum iomux_config {
> >>  #define MX51_PAD_EIM_A24__GPIO_2_18             IOMUX_PAD(0x450, 0x0bc, 1, 0x0,   0, NO_PAD_CTRL)
> >>  #define MX51_PAD_EIM_A25__GPIO_2_19             IOMUX_PAD(0x454, 0x0c0, 1, 0x0,   0, NO_PAD_CTRL)
> >>  #define MX51_PAD_EIM_A26__GPIO_2_20             IOMUX_PAD(0x458, 0x0c4, 1, 0x0,   0, NO_PAD_CTRL)
> >> -#define MX51_PAD_EIM_A27__GPIO_2_21             IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,   0, NO_PAD_CTRL)
> >> +#define MX51_PAD_EIM_A27__GPIO_2_21             IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,   0,
> >MX51_GPIO_PAD_CTRL | PAD_CTL_PUS_100K_UP)
> >I share the concerns of Arnaud.  MX51_GPIO_PAD_CTRL looks OK,
> >PAD_CTL_PUS_100K_UP does not.
> 
> How do you suggest I define this pin for Babbage board only? Do I add to iomux-mx51.h
> #define MX51_BABBAGE_PAD_EIM_A27__GPIO_2_21             IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,   0,MX51_GPIO_PAD_CTRL | PAD_CTL_PUS_100K_UP) ?
> 
> Or do I define the pin in the board file with a 100K_UP? Like how eukrea_mbimxsd-baseboard.c did for MBIMXSD_GPIO_3_31?
I'd suggest something local to your machine file.  Unfortunately I don't
see an easy way to reuse the generic MX51_PAD_EIM_A27__GPIO_2_21 to
define your local symbol.  So I think something like you wrote above
should be fine.

Too bad that

	#define MX51_BABBAGE_PAD_EIM_A27__GPIO_2_21 (MX51_PAD_EIM_A27__GPIO_2_21 | PAD_CTL_PUS_100K_UP)

doesn't work.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

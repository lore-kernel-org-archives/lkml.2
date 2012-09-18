Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab2IRNDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:03:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40469 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab2IRNDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <1347973228-29839-2-git-send-email-stigge@antcom.de>
References: <1347973228-29839-1-git-send-email-stigge@antcom.de>
	<1347973228-29839-2-git-send-email-stigge@antcom.de>
Date: Tue, 18 Sep 2012 10:03:23 -0300
Message-ID: <CAAAP30HhoQjJNEr_Qj1Yx2xBA4JikzS_NAtGYoX6uYR6ryiS0g@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: LPC32xx: Platform update for devicetree
 completion of spi-pl022
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-arm-kernel@lists.infradead.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 10:00 AM, Roland Stigge <stigge@antcom.de> wrote:
> spi-pl022 got a further update to its devicetree support, completing properties
> such that no platform data is necessary anymore. This patch adjusts phy3250.c
> accordingly: The supplied platform data is deleted. However, OF_DEV_AUXDATA()
> are still necessary due to device naming ("dev:ssp0").
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

> --
> I will do a git pull request for arm-soc.git when the respective change in
> spi-pl022.c is merged.
>
> --- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
> +++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
> @@ -27,7 +27,6 @@
>  #include <linux/gpio.h>
>  #include <linux/amba/bus.h>
>  #include <linux/amba/clcd.h>
> -#include <linux/amba/pl022.h>
>  #include <linux/amba/pl08x.h>
>  #include <linux/amba/mmci.h>
>  #include <linux/of.h>
> @@ -156,21 +155,6 @@ static struct clcd_board lpc32xx_clcd_da
>         .remove         = lpc32xx_clcd_remove,
>  };
>
> -/*
> - * AMBA SSP (SPI)
> - */
> -static struct pl022_ssp_controller lpc32xx_ssp0_data = {
> -       .bus_id                 = 0,
> -       .num_chipselect         = 1,
> -       .enable_dma             = 0,
> -};
> -
> -static struct pl022_ssp_controller lpc32xx_ssp1_data = {
> -       .bus_id                 = 1,
> -       .num_chipselect         = 1,
> -       .enable_dma             = 0,
> -};
> -
>  static struct pl08x_channel_data pl08x_slave_channels[] = {
>         {
>                 .bus_id = "nand-slc",
> @@ -232,8 +216,8 @@ static struct lpc32xx_mlc_platform_data
>  };
>
>  static const struct of_dev_auxdata lpc32xx_auxdata_lookup[] __initconst = {
> -       OF_DEV_AUXDATA("arm,pl022", 0x20084000, "dev:ssp0", &lpc32xx_ssp0_data),
> -       OF_DEV_AUXDATA("arm,pl022", 0x2008C000, "dev:ssp1", &lpc32xx_ssp1_data),
> +       OF_DEV_AUXDATA("arm,pl022", 0x20084000, "dev:ssp0", NULL),
> +       OF_DEV_AUXDATA("arm,pl022", 0x2008C000, "dev:ssp1", NULL),
>         OF_DEV_AUXDATA("arm,pl110", 0x31040000, "dev:clcd", &lpc32xx_clcd_data),
>         OF_DEV_AUXDATA("arm,pl080", 0x31000000, "pl08xdmac", &pl08x_pd),
>         OF_DEV_AUXDATA("arm,pl18x", 0x20098000, "20098000.sd",

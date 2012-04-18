Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab2DRGCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:02:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60758 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2DRGCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:02:46 -0400
Date: Wed, 18 Apr 2012 08:02:30 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, axel.lin@gmail.com,
        broonie@opensource.wolfsonmicro.com, marek.vasut@gmail.com,
        devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 8/8] ARM: LPC32xx: Device tree support
Message-ID: <20120418060230.GC17506@avionic-0098.adnet.avionic-design.de>
References: <1334682507-15055-1-git-send-email-stigge@antcom.de>
 <1334682507-15055-9-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <1334682507-15055-9-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:fYt/qYb7k/GzZV3ddieR/BlILq0XiVNj3R7R3YoAyqo
 SO5vxfvzD8AejZSHIIff50D5PWw/ZC+Gp0BLNFHLhuouuGZeIH
 K48ajJ00aQpz4joJc5X/7Qp1hKtVDmICRiQa7+oLknEcocDj4W
 V4Rdy0c97tEIX9Ec+VWzyFzZoify6aqUEY+Anh6QtLMIuIpj83
 eJhWvH1flo27BZ2T22a4L3fwpFbix8DOQloBW2fYXaypcOhAkr
 heWUBxu0x5+AgJvDdFdfNOfMtpGYwoLYLrSUZu5lEtzY5z3ymr
 b3uAK9PDF2lgafMSA+LuOVZRvizgbdtllpZsbUe9UneD7daOTb
 MvisX8EPASh2T/tyOmovbs9g2qRsXuYs6nJbrLOJB26RY8cJXA
 eOtfNWd/G4tkM1Gor34u9VcDx6UmHwNJOE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Roland Stigge wrote:
> This patch does the actual device tree switch for the LPC32xx SoC.
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>=20
> ---
>=20
> Applies to v3.4-rc3
>=20
>  Documentation/devicetree/bindings/arm/lpc32xx-mic.txt |   38 +++
>  Documentation/devicetree/bindings/arm/lpc32xx.txt     |    8=20
>  arch/arm/Kconfig                                      |    1=20
>  arch/arm/mach-lpc32xx/Kconfig                         |   26 --
>  arch/arm/mach-lpc32xx/clock.c                         |   77 +++----
>  arch/arm/mach-lpc32xx/common.c                        |  192 -----------=
-------
>  arch/arm/mach-lpc32xx/common.h                        |   14 -
>  arch/arm/mach-lpc32xx/irq.c                           |   78 +++++--

Could this perhaps be split into another patch. Basically this is a
conversion to IRQ domain *and* device tree support. But maybe it isn't worth
the effort.

>  arch/arm/mach-lpc32xx/phy3250.c                       |  146 +++++------=
--

While at it, this should probably be renamed board-dt.c or something similar
since it is no longer phy3250 specific.

[...]
> --- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
> +++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
[...]
> -static void __init phy3250_board_init(void)
> +static void __init lpc3250_machine_init(void)
>  {
>  	u32 tmp;
> -	int i;
> -
> -	lpc32xx_gpio_init();
> -
> -	/* Register GPIOs used on this board */
> -	if (gpio_request(SPI0_CS_GPIO, "spi0 cs"))
> -		printk(KERN_ERR "Error requesting gpio %u",
> -			SPI0_CS_GPIO);
> -	else if (gpio_direction_output(SPI0_CS_GPIO, 1))
> -		printk(KERN_ERR "Error setting gpio %u to output",
> -			SPI0_CS_GPIO);
> -
> -	/* Setup network interface for RMII mode */
> -	tmp =3D __raw_readl(LPC32XX_CLKPWR_MACCLK_CTRL);
> -	tmp &=3D ~LPC32XX_CLKPWR_MACCTRL_PINS_MSK;
> -	tmp |=3D LPC32XX_CLKPWR_MACCTRL_USE_RMII_PINS;
> -	__raw_writel(tmp, LPC32XX_CLKPWR_MACCLK_CTRL);
> =20
>  	/* Setup SLC NAND controller muxing */
>  	__raw_writel(LPC32XX_CLKPWR_NANDCLK_SEL_SLC,
> @@ -300,6 +265,12 @@ static void __init phy3250_board_init(vo
>  	tmp |=3D LPC32XX_CLKPWR_LCDCTRL_LCDTYPE_TFT16;
>  	__raw_writel(tmp, LPC32XX_CLKPWR_LCDCLK_CTRL);
> =20
> +	/* Set up USB power */
> +	tmp =3D __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
> +	tmp |=3D LPC32XX_CLKPWR_USBCTRL_HCLK_EN |
> +		LPC32XX_CLKPWR_USBCTRL_USBI2C_EN;
> +	__raw_writel(tmp, LPC32XX_CLKPWR_USB_CTRL);
> +
>  	/* Set up I2C pull levels */
>  	tmp =3D __raw_readl(LPC32XX_CLKPWR_I2C_CLK_CTRL);
>  	tmp |=3D LPC32XX_CLKPWR_I2CCLK_USBI2CHI_DRIVE |
> @@ -321,33 +292,35 @@ static void __init phy3250_board_init(vo
>  	/*
>  	 * AMBA peripheral clocks need to be enabled prior to AMBA device
>  	 * detection or a data fault will occur, so enable the clocks
> -	 * here. However, we don't want to enable them if the peripheral
> -	 * isn't included in the image
> +	 * here.
>  	 */
> -#ifdef CONFIG_FB_ARMCLCD
>  	tmp =3D __raw_readl(LPC32XX_CLKPWR_LCDCLK_CTRL);
>  	__raw_writel((tmp | LPC32XX_CLKPWR_LCDCTRL_CLK_EN),
>  		LPC32XX_CLKPWR_LCDCLK_CTRL);
> -#endif
> -#ifdef CONFIG_SPI_PL022
> +
>  	tmp =3D __raw_readl(LPC32XX_CLKPWR_SSP_CLK_CTRL);
>  	__raw_writel((tmp | LPC32XX_CLKPWR_SSPCTRL_SSPCLK0_EN),
>  		LPC32XX_CLKPWR_SSP_CLK_CTRL);
> -#endif
> =20
> -	platform_add_devices(phy3250_devs, ARRAY_SIZE(phy3250_devs));
> -	for (i =3D 0; i < ARRAY_SIZE(amba_devs); i++) {
> -		struct amba_device *d =3D amba_devs[i];
> -		amba_device_register(d, &iomem_resource);
> -	}
> +	tmp =3D __raw_readl(LPC32XX_CLKPWR_DMA_CLK_CTRL);
> +	__raw_writel((tmp | LPC32XX_CLKPWR_DMACLKCTRL_CLK_EN),
> +		     LPC32XX_CLKPWR_DMA_CLK_CTRL);
>  	/* Test clock needed for UDA1380 initial init */
>  	__raw_writel(LPC32XX_CLKPWR_TESTCLK2_SEL_MOSC |
>  		LPC32XX_CLKPWR_TESTCLK_TESTCLK2_EN,
>  		LPC32XX_CLKPWR_TEST_CLK_SEL);

A lot of these seem to be gratuitous here. Can control of these clocks not =
be
exposed via the clock framework? That would allow the controllers to only
activate them when actually needed. This could also be done in follow up
patches, though.

[...]
> +	/* Register GPIOs used on this board */
> +	if (gpio_request(SPI0_CS_GPIO, "spi0 cs"))
> +		printk(KERN_ERR "Error requesting gpio %u",
> +			SPI0_CS_GPIO);
> +	else if (gpio_direction_output(SPI0_CS_GPIO, 1))
> +		printk(KERN_ERR "Error setting gpio %u to output",
> +			SPI0_CS_GPIO);

This should be initialized based on data from the device tree.

Thierry

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk+OWPYACgkQZ+BJyKLjJp/MWACdFhPSh17GmEERW4BNDdWvFfLA
GrsAnRETISc3gmQY01E3ttqlnFnOsQE8
=njKo
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--

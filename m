Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab2ISOly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:41:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57703 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2ISOlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:41:53 -0400
Message-ID: <5059D994.6050606@pengutronix.de>
Date: Wed, 19 Sep 2012 16:41:24 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: Re: [PATCH 1/4] usb: phy: add a new driver for usb3 phy
References: <1348054229-27362-1-git-send-email-kishon@ti.com> <1348054229-27362-2-git-send-email-kishon@ti.com>
In-Reply-To: <1348054229-27362-2-git-send-email-kishon@ti.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAB6B69E50CF0911C0ADC06D2"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAB6B69E50CF0911C0ADC06D2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/19/2012 01:30 PM, Kishon Vijay Abraham I wrote:
> Added a driver for usb3 phy that handles the interaction between usb ph=
y
> device and dwc3 controller.
>=20
> This also includes device tree support for usb3 phy driver and
> the documentation with device tree binding information is updated.
>=20
> Currently writing to control module register is taken care in this
> driver which will be removed once the control module driver is in place=
=2E
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Moiz Sonasath <m-sonasath@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/usb-phy.txt |   18 +
>  drivers/usb/phy/Kconfig                           |    9 +
>  drivers/usb/phy/Makefile                          |    1 +
>  drivers/usb/phy/omap-usb3.c                       |  369 +++++++++++++=
++++++++
>  include/linux/usb/omap_usb.h                      |   72 ++++
>  5 files changed, 469 insertions(+)
>  create mode 100644 drivers/usb/phy/omap-usb3.c
>=20
> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Docume=
ntation/devicetree/bindings/usb/usb-phy.txt
> index 80d4148..7c5fd89 100644
> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> @@ -15,3 +15,21 @@ usb2phy@4a0ad080 {
>  	reg =3D <0x4a0ad080 0x58>,
>  	      <0x4a002300 0x4>;
>  };
> +
> +OMAP USB3 PHY
> +
> +Required properties:
> + - compatible: Should be "ti,omap-usb3"
> + - reg : Address and length of the register set for the device. Also
> +add the address of control module phy power register until a driver fo=
r
> +control module is added
> +
> +This is usually a subnode of ocp2scp to which it is connected.
> +
> +usb3phy@4a084400 {
> +	compatible =3D "ti,omap-usb3";
> +	reg =3D <0x0x4a084400 0x80>,
> +	      <0x4a084800 0x64>,
> +	      <0x4a084c00 0x40>,
> +	      <0x4a002370 0x4>;
> +};
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index 63c339b..353dc0c 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -13,6 +13,15 @@ config OMAP_USB2
>  	  The USB OTG controller communicates with the comparator using this
>  	  driver.
> =20
> +config OMAP_USB3
> +	tristate "OMAP USB3 PHY Driver"
> +	select USB_OTG_UTILS
> +	help
> +	  Enable this to support the USB3 PHY that is part of SOC. This
> +	  driver takes care of all the PHY functionality apart from comparato=
r.
> +	  The USB OTG controller communicates with the comparator using this
> +	  driver.
> +
>  config USB_ISP1301
>  	tristate "NXP ISP1301 USB transceiver support"
>  	depends on USB || USB_GADGET
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index b069f29..973b1e6 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -5,6 +5,7 @@
>  ccflags-$(CONFIG_USB_DEBUG) :=3D -DDEBUG
> =20
>  obj-$(CONFIG_OMAP_USB2)			+=3D omap-usb2.o
> +obj-$(CONFIG_OMAP_USB3)			+=3D omap-usb3.o
>  obj-$(CONFIG_USB_ISP1301)		+=3D isp1301.o
>  obj-$(CONFIG_MV_U3D_PHY)		+=3D mv_u3d_phy.o
>  obj-$(CONFIG_USB_EHCI_TEGRA)	+=3D tegra_usb_phy.o
> diff --git a/drivers/usb/phy/omap-usb3.c b/drivers/usb/phy/omap-usb3.c
> new file mode 100644
> index 0000000..4dc84ca
> --- /dev/null
> +++ b/drivers/usb/phy/omap-usb3.c
> @@ -0,0 +1,369 @@
> +/*
> + * omap-usb3 - USB PHY, talking to dwc3 controller in OMAP.
> + *
> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.c=
om
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/usb/omap_usb.h>
> +#include <linux/of.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/delay.h>
> +
> +static struct usb_dpll_params omap_usb3_dpll_params[NUM_SYS_CLKS] =3D =
{
> +	{1250, 5, 4, 20, 0},		/* 12 MHz */
> +	{3125, 20, 4, 20, 0},		/* 16.8 MHz */
> +	{1172, 8, 4, 20, 65537},	/* 19.2 MHz */
> +	{1250, 12, 4, 20, 0},		/* 26 MHz */
> +	{3125, 47, 4, 20, 92843},	/* 38.4 MHz */
> +};
> +
> +/**
> + * omap5_usb_phy_power - power on/off the serializer using control mod=
ule
> + * @phy: struct omap_usb *
> + * @on: 0 to off and 1 to on based on powering on or off the PHY
> + *
> + * omap_usb3 can call this API to power on or off the PHY.
> + */
> +static int omap5_usb_phy_power(struct omap_usb *phy, bool on)
> +{
> +	u32 val;
> +	unsigned long rate;
> +	struct clk *sys_clk;
> +
> +	sys_clk =3D clk_get(NULL, "sys_clkin");

Where's the corresponding clk_put()?

> +	if (IS_ERR(sys_clk)) {
> +		pr_err("%s: unable to get sys_clkin\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	rate =3D clk_get_rate(sys_clk);
> +	rate =3D rate/1000000;
> +
> +	val =3D readl(phy->control_dev);
> +
> +	if (on) {
> +		val &=3D ~(USB_PWRCTL_CLK_CMD_MASK | USB_PWRCTL_CLK_FREQ_MASK);
> +		val |=3D USB3_PHY_TX_RX_POWERON << USB_PWRCTL_CLK_CMD_SHIFT;
> +		val |=3D rate << USB_PWRCTL_CLK_FREQ_SHIFT;
> +	} else {
> +		val &=3D ~USB_PWRCTL_CLK_CMD_MASK;
> +		val |=3D USB3_PHY_TX_RX_POWEROFF << USB_PWRCTL_CLK_CMD_SHIFT;
> +	}
> +
> +	writel(val, phy->control_dev);
> +
> +	return 0;
> +}
> +
> +static int omap_usb3_suspend(struct usb_phy *x, int suspend)
> +{
> +	struct omap_usb *phy =3D phy_to_omapusb(x);
> +	int	val, ret;
> +	int timeout =3D PLL_IDLE_TIME;
> +
> +	if (suspend && !phy->is_suspended) {
> +		val =3D omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
> +		val |=3D PLL_IDLE;
> +		omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
> +
> +		do {
> +			val =3D omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
> +			if (val & PLL_TICOPWDN)
> +				break;
> +			udelay(1);
> +		} while (--timeout);
> +
> +		omap5_usb_phy_power(phy, 0);
> +		pm_runtime_put_sync(phy->dev);
> +
> +		phy->is_suspended	=3D 1;
> +	} else if (!suspend && phy->is_suspended) {
> +		phy->is_suspended	=3D 0;
> +		ret =3D pm_runtime_get_sync(phy->dev);
> +		if (ret < 0) {
> +			dev_err(phy->dev, "get_sync failed with err %d\n",
> +									ret);
> +			return ret;
> +		}
> +
> +		val =3D omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
> +		val &=3D ~PLL_IDLE;
> +		omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
> +
> +		do {
> +			val =3D omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
> +			if (!(val & PLL_TICOPWDN))
> +				break;
> +			udelay(1);
> +		} while (--timeout);
> +	}
> +
> +	return 0;
> +}
> +
> +static inline enum sys_clk_rate __get_sys_clk_index(unsigned long rate=
)
> +{
> +	switch (rate) {
> +	case 12000000:
> +		return CLK_RATE_12MHZ;
> +	case 16800000:
> +		return CLK_RATE_16MHZ;
> +	case 19200000:
> +		return CLK_RATE_19MHZ;
> +	case 26000000:
> +		return CLK_RATE_26MHZ;
> +	case 38400000:
> +		return CLK_RATE_38MHZ;
> +	default:
> +		return CLK_RATE_UNDEFINED;
> +	}
> +}
> +
> +static void omap_usb_dpll_relock(struct omap_usb *phy)
> +{
> +	u32		val;
> +	unsigned long	timeout;
> +
> +	omap_usb_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
> +
> +	timeout =3D jiffies + msecs_to_jiffies(20);
> +	do {
> +		val =3D omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
> +		if (val & PLL_LOCK)
> +			break;
> +	} while (!WARN_ON(time_after(jiffies, timeout)));
> +}
> +
> +static int omap_usb_dpll_lock(struct omap_usb *phy)
> +{
> +	u32			val;
> +	struct clk		*sys_clk;
> +	unsigned long		rate;
> +	enum sys_clk_rate	clk_index;
> +
> +	sys_clk	=3D clk_get(NULL, "sys_clkin");

Where's the corresponding clk_put()?

> +	if (IS_ERR(sys_clk)) {
> +		pr_err("unable to get sys_clkin\n");
> +		return PTR_ERR(sys_clk);
> +	}
> +
> +	rate		=3D clk_get_rate(sys_clk);
> +	clk_index	=3D __get_sys_clk_index(rate);
> +
> +	if (clk_index =3D=3D CLK_RATE_UNDEFINED) {
> +		pr_err("dpll cannot be locked for sys clk freq:%luHz\n", rate);
> +		return -EINVAL;
> +	}
> +
> +	val =3D omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
> +	val &=3D ~PLL_REGN_MASK;
> +	val |=3D omap_usb3_dpll_params[clk_index].n << PLL_REGN_SHIFT;
> +	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
> +
> +	val =3D omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
> +	val &=3D ~PLL_SELFREQDCO_MASK;
> +	val |=3D omap_usb3_dpll_params[clk_index].freq << PLL_SELFREQDCO_SHIF=
T;
> +	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
> +
> +	val =3D omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
> +	val &=3D ~PLL_REGM_MASK;
> +	val |=3D omap_usb3_dpll_params[clk_index].m << PLL_REGM_SHIFT;
> +	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
> +
> +	val =3D omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION4);
> +	val &=3D ~PLL_REGM_F_MASK;
> +	val |=3D omap_usb3_dpll_params[clk_index].mf << PLL_REGM_F_SHIFT;
> +	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION4, val);
> +
> +	val =3D omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION3);
> +	val &=3D ~PLL_SD_MASK;
> +	val |=3D omap_usb3_dpll_params[clk_index].sd << PLL_SD_SHIFT;
> +	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION3, val);
> +
> +	omap_usb_dpll_relock(phy);
> +
> +	return 0;
> +}
> +
> +static int omap_usb3_init(struct usb_phy *x)
> +{
> +	struct omap_usb	*phy =3D phy_to_omapusb(x);
> +
> +	omap_usb_dpll_lock(phy);
> +	omap5_usb_phy_power(phy, 1);
> +
> +	return 0;
> +}
> +
> +static int __devinit omap_usb3_probe(struct platform_device *pdev)
> +{
> +	struct omap_usb			*phy;
> +	struct resource			*res;
> +
> +	phy =3D devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		dev_err(&pdev->dev, "unable to alloc mem for OMAP USB3 PHY\n");
> +		return -ENOMEM;
> +	}
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +	if (!res) {
> +		dev_err(&pdev->dev, "unable to get base address of pll_ctrl\n");
> +		return -ENODEV;
> +	}
> +
> +	phy->pll_ctrl_base =3D devm_request_and_ioremap(&pdev->dev, res);
> +	if (!phy->pll_ctrl_base) {
> +		dev_err(&pdev->dev, "ioremap of pll_ctrl failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 3);
> +	if (!res) {
> +		dev_err(&pdev->dev,
> +			"unable to get address of control phy power\n");
> +		return -ENODEV;
> +	}
> +
> +	phy->control_dev =3D devm_request_and_ioremap(&pdev->dev, res);
> +	if (!phy->control_dev) {
> +		dev_err(&pdev->dev, "ioremap of control_dev failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	phy->dev		=3D &pdev->dev;
> +
> +	phy->phy.dev		=3D phy->dev;
> +	phy->phy.label		=3D "omap-usb3";
> +	phy->phy.init		=3D omap_usb3_init;
> +	phy->phy.set_suspend	=3D omap_usb3_suspend;
> +
> +	phy->is_suspended	=3D 1;
> +	omap5_usb_phy_power(phy, 0);
> +
> +	phy->wkupclk =3D devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
> +	if (IS_ERR(phy->wkupclk)) {
> +		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
> +		return PTR_ERR(phy->wkupclk);
> +	}
> +	clk_prepare(phy->wkupclk);
> +
> +	phy->optclk =3D devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
> +	if (IS_ERR(phy->optclk)) {
> +		dev_err(&pdev->dev, "unable to get usb_otg_ss_refclk960m\n");
> +		return PTR_ERR(phy->optclk);
> +	}
> +	clk_prepare(phy->optclk);

Are these clocks only needed on the PM usecase?

> +
> +	usb_add_phy(&phy->phy, USB_PHY_TYPE_USB3);

Just to be sure and avoid race conditions, I would first set the drvdata.=


> +
> +	platform_set_drvdata(pdev, phy);
> +
> +	pm_runtime_enable(phy->dev);
> +
> +	return 0;
> +}
> +
> +static int __devexit omap_usb3_remove(struct platform_device *pdev)
> +{
> +	struct omap_usb *phy =3D platform_get_drvdata(pdev);
> +
> +	clk_unprepare(phy->wkupclk);
> +	clk_unprepare(phy->optclk);
> +	usb_remove_phy(&phy->phy);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_RUNTIME
> +
> +static int omap_usb3_runtime_suspend(struct device *dev)
> +{
> +	struct platform_device	*pdev =3D to_platform_device(dev);
> +	struct omap_usb	*phy =3D platform_get_drvdata(pdev);
> +
> +	clk_disable(phy->wkupclk);
> +	clk_disable(phy->optclk);
> +
> +	return 0;
> +}
> +
> +static int omap_usb3_runtime_resume(struct device *dev)
> +{
> +	u32 ret =3D 0;
> +	struct platform_device	*pdev =3D to_platform_device(dev);
> +	struct omap_usb	*phy =3D platform_get_drvdata(pdev);
> +
> +	ret =3D clk_enable(phy->optclk);
> +	if (ret) {
> +		dev_err(phy->dev, "Failed to enable optclk %d\n", ret);
> +		goto err1;
> +	}
> +
> +	ret =3D clk_enable(phy->wkupclk);
> +	if (ret) {
> +		dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
> +		goto err2;
> +	}
> +
> +	return 0;
> +
> +err2:
> +	clk_disable(phy->optclk);
> +
> +err1:
> +	return ret;
> +}
> +
> +static const struct dev_pm_ops omap_usb3_pm_ops =3D {
> +	SET_RUNTIME_PM_OPS(omap_usb3_runtime_suspend, omap_usb3_runtime_resum=
e,
> +		NULL)
> +};
> +
> +#define DEV_PM_OPS     (&omap_usb3_pm_ops)
> +#else
> +#define DEV_PM_OPS     NULL
> +#endif
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id omap_usb3_id_table[] =3D {
> +	{ .compatible =3D "ti,omap-usb3" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, omap_usb3_id_table);
> +#endif
> +
> +static struct platform_driver omap_usb3_driver =3D {
> +	.probe		=3D omap_usb3_probe,
> +	.remove		=3D __devexit_p(omap_usb3_remove),
> +	.driver		=3D {
> +		.name	=3D "omap-usb3",
> +		.owner	=3D THIS_MODULE,
> +		.pm	=3D DEV_PM_OPS,
> +		.of_match_table =3D of_match_ptr(omap_usb3_id_table),
> +	},
> +};
> +
> +module_platform_driver(omap_usb3_driver);
> +
> +MODULE_ALIAS("platform: omap_usb3");
> +MODULE_AUTHOR("Texas Instruments Inc.");
> +MODULE_DESCRIPTION("OMAP USB3 phy driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/usb/omap_usb.h b/include/linux/usb/omap_usb.=
h
> index 0ea17f8..01ed008 100644
> --- a/include/linux/usb/omap_usb.h
> +++ b/include/linux/usb/omap_usb.h
> @@ -19,19 +19,80 @@
>  #ifndef __DRIVERS_OMAP_USB2_H
>  #define __DRIVERS_OMAP_USB2_H
> =20
> +#include <linux/io.h>
>  #include <linux/usb/otg.h>

Are these structs, enums and defines needed outside of the omap-usb3.c
file? If not it's better to move these into this file.

> =20
> +struct usb_dpll_params {
> +	u16	m;
> +	u8	n;
> +	u8	freq:3;
> +	u8	sd;
> +	u32	mf;
> +};
> +
> +enum sys_clk_rate {
> +	CLK_RATE_UNDEFINED =3D -1,
> +	CLK_RATE_12MHZ,
> +	CLK_RATE_16MHZ,
> +	CLK_RATE_19MHZ,
> +	CLK_RATE_26MHZ,
> +	CLK_RATE_38MHZ
> +};
> +
> +#define	NUM_SYS_CLKS		5
> +#define	PLL_STATUS		0x00000004
> +#define	PLL_GO			0x00000008
> +#define	PLL_CONFIGURATION1	0x0000000C
> +#define	PLL_CONFIGURATION2	0x00000010
> +#define	PLL_CONFIGURATION3	0x00000014
> +#define	PLL_CONFIGURATION4	0x00000020
> +
> +#define	PLL_REGM_MASK		0x001FFE00
> +#define	PLL_REGM_SHIFT		0x9
> +#define	PLL_REGM_F_MASK		0x0003FFFF
> +#define	PLL_REGM_F_SHIFT	0x0
> +#define	PLL_REGN_MASK		0x000001FE
> +#define	PLL_REGN_SHIFT		0x1
> +#define	PLL_SELFREQDCO_MASK	0x0000000E
> +#define	PLL_SELFREQDCO_SHIFT	0x1
> +#define	PLL_SD_MASK		0x0003FC00
> +#define	PLL_SD_SHIFT		0x9
> +#define	SET_PLL_GO		0x1
> +#define	PLL_TICOPWDN		0x10000
> +#define	PLL_LOCK		0x2
> +#define	PLL_IDLE		0x1
> +
> +/*
> + * This is an Empirical value that works, need to confirm the actual
> + * value required for the USB3PHY_PLL_CONFIGURATION2.PLL_IDLE status
> + * to be correctly reflected in the USB3PHY_PLL_STATUS register.
> + */
> +# define PLL_IDLE_TIME  100;
> +
>  struct omap_usb {
>  	struct usb_phy		phy;
>  	struct phy_companion	*comparator;
> +	void __iomem		*pll_ctrl_base;
>  	struct device		*dev;
>  	u32 __iomem		*control_dev;
>  	struct clk		*wkupclk;
> +	struct clk		*optclk;
>  	u8			is_suspended:1;
>  };
> =20
>  #define	PHY_PD	0x1
> =20
> +#define	CONTROL_PHY_POWER_USB		0x00000370
> +
> +#define	USB_PWRCTL_CLK_CMD_MASK		0x003FC000
> +#define	USB_PWRCTL_CLK_CMD_SHIFT	0xE
> +
> +#define	USB_PWRCTL_CLK_FREQ_MASK	0xFFC00000
> +#define	USB_PWRCTL_CLK_FREQ_SHIFT	0x16
> +
> +#define	USB3_PHY_TX_RX_POWERON		0x3
> +#define	USB3_PHY_TX_RX_POWEROFF		0x0
> +
>  #define	phy_to_omapusb(x)	container_of((x), struct omap_usb, phy)
> =20
>  #if defined(CONFIG_OMAP_USB2) || defined(CONFIG_OMAP_USB2_MODULE)
> @@ -43,4 +104,15 @@ static inline int omap_usb2_set_comparator(struct p=
hy_companion *comparator)
>  }
>  #endif
> =20
> +static inline u32 omap_usb_readl(const void __iomem *addr, unsigned of=
fset)
> +{
> +	return __raw_readl(addr + offset);
> +}
> +
> +static inline void omap_usb_writel(const void __iomem *addr, unsigned =
offset,
> +								u32 data)
> +{
> +	__raw_writel(data, addr + offset);
> +}
> +
>  #endif /* __DRIVERS_OMAP_USB_H */
>=20
regards,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigAB6B69E50CF0911C0ADC06D2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBZ2ZcACgkQjTAFq1RaXHMlSQCdHxOy/HCK/XBVm/Xfb4Elc5qg
Q1cAoIYbPSGY95IkEpma9OnAv3HUo4ZT
=wFqo
-----END PGP SIGNATURE-----

--------------enigAB6B69E50CF0911C0ADC06D2--

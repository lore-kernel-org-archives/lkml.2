Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2GJGtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:49:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57794 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab2GJGtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:49:08 -0400
Date: Tue, 10 Jul 2012 08:48:53 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] pwm: add lpc32xx pwm support
Message-ID: <20120710064853.GA28840@avionic-0098.adnet.avionic-design.de>
References: <1341862074-9240-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <1341862074-9240-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:nJ91GymIgqZrmoBsjL2IduPzXpBPs20CuCZPCwIY96S
 pCsmJGgXZOfW43+CMpkGfRpOlIkGr2rucJnmew9jipy5kZmtIu
 JjAQAfNl38Km117Ju7tSukv7Rn2a/FpYyeAhlIi9p27kdKfROe
 lN1rsRQy87DM0jcCHax251gF1th2o84F2A+bA+Qef/m0593+is
 oiqrv1By95ymke7LVpPzYhd+B0NZXaqJdJ8RIHHCJzcVUXjxAH
 4ExF0/ywQzZnZTF4/eSgPXw8vTJRoRj3BSZod7DAXwvuUaGRwG
 /x2jM8d8oRt5yXvvnbAybOeJ3ZrBQbcPsnIbShJ5SXNCyKO9Ya
 /14v3Cljxo/buXqUjOPX1ZqUyKogzOve1cu7dwgTCwkWhPE3gM
 ar/cKYfiYXK00jg53wYIyFmkBdaWs70tYlgMFpZ94fxBuJn9bV
 Je5FQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2012 at 04:27:54PM -0300, Alexandre Pereira da Silva wrote:
> Add lpc32xx soc pwm driver.
>=20
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> ---
>  .../devicetree/bindings/pwm/lpc32xx-pwm.txt        |   12 ++
>  drivers/pwm/Kconfig                                |   11 ++
>  drivers/pwm/Makefile                               |    1 +
>  drivers/pwm/pwm-lpc32xx.c                          |  151 ++++++++++++++=
++++++
>  4 files changed, 175 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
>  create mode 100644 drivers/pwm/pwm-lpc32xx.c

Hi Alexandre,

overall this looks good, just some comments inline. I'd very much
appreciate an Acked-by from Roland on this.

> diff --git a/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt b/Docu=
mentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
> new file mode 100644
> index 0000000..fb7b3d5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
> @@ -0,0 +1,12 @@
> +LPC32XX PWM controller
> +
> +Required properties:
> +- compatible: should be "nxp,lpc3220-pwm"

Does the compatible have to be lpc3220-pwm? Can't it be lpc32xx-pwm to
match the driver and binding names?

> +- reg: physical base address and length of the controller's registers
> +
> +Example:
> +
> +pwm: pwm@80064000 {
> +	compatible =3D "nxp,lpc3220-pwm";
> +	reg =3D <0x80064000 2000>;

You probably want to specify the size as 0x2000 as well.

> +};
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 0b2800f..34086b1 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -28,6 +28,17 @@ config PWM_IMX
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-imx.
> =20
> +config PWM_LPC32XX
> +	tristate "LPC32XX PWM support"
> +	depends on ARCH_LPC32XX
> +	help
> +	  Generic PWM framework driver for LPC32XX. The LPC32XX soc has two
> +	  pwm channels.

Can we keep the spelling consistent here? It should be "PWM" and "SoC".
It'd be nice if you could fix that up in the commit message as well.

> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-lpc32xx.
> +
> +
>  config PWM_MXS
>  	tristate "Freescale MXS PWM support"
>  	depends on ARCH_MXS && OF
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index cec2500..5459702 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -1,6 +1,7 @@
>  obj-$(CONFIG_PWM)		+=3D core.o
>  obj-$(CONFIG_PWM_BFIN)		+=3D pwm-bfin.o
>  obj-$(CONFIG_PWM_IMX)		+=3D pwm-imx.o
> +obj-$(CONFIG_PWM_LPC32XX)	+=3D pwm-lpc32xx.o
>  obj-$(CONFIG_PWM_MXS)		+=3D pwm-mxs.o
>  obj-$(CONFIG_PWM_PXA)		+=3D pwm-pxa.o
>  obj-$(CONFIG_PWM_SAMSUNG)	+=3D pwm-samsung.o
> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
> new file mode 100644
> index 0000000..c7fa126
> --- /dev/null
> +++ b/drivers/pwm/pwm-lpc32xx.c
> @@ -0,0 +1,151 @@
> +/*
> + * Copyright 2012 Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/slab.h>
> +
> +struct lpc32xx_pwm_chip {
> +	struct pwm_chip chip;
> +	struct device *dev;

Can you drop this field? You initialize it, but it is never used
subsequently in the driver.

> +	struct clk *clk;
> +	void __iomem *base;
> +};
> +
> +#define PWM_ENABLE (1<<31)
> +#define PWM_RELOADV(x)	(((x) & 0xFF)<<8)
> +#define PWM_DUTY(x)	((x) & 0xFF)

There should be spaces around <<.

> +
> +#define to_lpc32xx_pwm_chip(_chip) \
> +	container_of(_chip, struct lpc32xx_pwm_chip, chip)
> +
> +static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *=
pwm,
> +			  int duty_ns, int period_ns)

The alignment looks wrong here. It seems like you aligned properly
before adding the "static".

> +{
> +	struct lpc32xx_pwm_chip *lpc32xx =3D to_lpc32xx_pwm_chip(chip);
> +	unsigned long long c;
> +	int period_cycles, duty_cycles;
> +
> +	c =3D clk_get_rate(lpc32xx->clk)/256;

Spaces around /.

> +	c =3D c * period_ns;
> +	do_div(c, NSEC_PER_SEC);
> +
> +	/* Handle high and low extremes */
> +	if (c =3D=3D 0)
> +		c =3D 1;
> +	if (c > 255)
> +		c =3D 0; /* 0 set division by 256 */
> +	period_cycles =3D c;
> +
> +	c =3D 256*duty_ns;

Spaces around *.

> +	do_div(c, period_ns);
> +	duty_cycles =3D c;
> +
> +	writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
> +		lpc32xx->base);
> +
> +	return 0;
> +}
> +
> +static int lpc32xx_pwm_enable(struct pwm_chip *chip, struct pwm_device *=
pwm)
> +{
> +	struct lpc32xx_pwm_chip *lpc32xx =3D to_lpc32xx_pwm_chip(chip);
> +
> +	clk_enable(lpc32xx->clk);
> +	return 0;
> +}
> +
> +static void lpc32xx_pwm_disable(struct pwm_chip *chip, struct pwm_device=
 *pwm)
> +{
> +	struct lpc32xx_pwm_chip *lpc32xx =3D to_lpc32xx_pwm_chip(chip);
> +
> +	writel(0, lpc32xx->base);
> +	clk_disable(lpc32xx->clk);
> +}
> +
> +static const struct pwm_ops lpc32xx_pwm_ops =3D {
> +	.config =3D lpc32xx_pwm_config,
> +	.enable =3D lpc32xx_pwm_enable,
> +	.disable =3D lpc32xx_pwm_disable,
> +	.owner =3D THIS_MODULE,
> +};
> +
> +static int lpc32xx_pwm_probe(struct platform_device *pdev)
> +{
> +	struct lpc32xx_pwm_chip *lpc32xx;
> +	struct resource *res;
> +	int ret;
> +
> +	lpc32xx =3D devm_kzalloc(&pdev->dev, sizeof(*lpc32xx), GFP_KERNEL);
> +	if (!lpc32xx)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);

You should probably check for res !=3D NULL.

> +	lpc32xx->base =3D devm_request_and_ioremap(&pdev->dev, res);
> +	if (!lpc32xx->base)
> +		return -EADDRNOTAVAIL;
> +
> +	lpc32xx->clk =3D devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(lpc32xx->clk))
> +		return PTR_ERR(lpc32xx->clk);
> +
> +	lpc32xx->chip.dev =3D &pdev->dev;
> +	lpc32xx->chip.ops =3D &lpc32xx_pwm_ops;
> +	lpc32xx->chip.npwm =3D 1;

The Kconfig help text says that the lpc32xx PWM controller has two
channels. Why is npwm set to 1 here?

> +
> +	ret =3D pwmchip_add(&lpc32xx->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add pwm chip %d\n", ret);

You should probably separate the error code, to make it obvious what it
is. Otherwise one might mistake this as an index. While at it, please
make PWM uppercase.

> +		return ret;
> +	}
> +
> +	lpc32xx->dev =3D &pdev->dev;

As I mentioned above, this is unused so it can probably be dropped.

> +	platform_set_drvdata(pdev, lpc32xx);
> +
> +	return 0;
> +}
> +
> +static int __devexit lpc32xx_pwm_remove(struct platform_device *pdev)
> +{
> +	struct lpc32xx_pwm_chip *lpc32xx =3D platform_get_drvdata(pdev);
> +
> +	pwmchip_remove(&lpc32xx->chip);

You should propagate potential errors from pwmchip_remove(). There are
situations where it can actually fail.

Thierry

> +
> +	return 0;
> +}
> +
> +static struct of_device_id lpc32xx_pwm_dt_ids[] =3D {
> +	{ .compatible =3D "nxp,lpc3220-pwm", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, lpc32xx_pwm_dt_ids);
> +
> +static struct platform_driver lpc32xx_pwm_driver =3D {
> +	.driver =3D {
> +		.name =3D "lpc32xx-pwm",
> +		.of_match_table =3D of_match_ptr(lpc32xx_pwm_dt_ids),
> +	},
> +	.probe =3D lpc32xx_pwm_probe,
> +	.remove =3D __devexit_p(lpc32xx_pwm_remove),
> +};
> +module_platform_driver(lpc32xx_pwm_driver);
> +
> +MODULE_ALIAS("platform:lpc32xx-pwm");
> +MODULE_AUTHOR("Alexandre Pereira da Silva <aletes.xgr@gmail.com>");
> +MODULE_DESCRIPTION("LPC32XX PWM Driver");
> +MODULE_LICENSE("GPL v2");
> --=20
> 1.7.10
>=20
>=20
>=20

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP+9BVAAoJEN0jrNd/PrOhSp4P/j3kP4a+OR6sYHA1yQzYFC/d
TNcFBd+bjnBsl5ROMdrnTeafqO9FR9l/tstEEIRuz6iaqKsnvI2wLicKOplbi4ls
JDaZd3wYqXCfwE4mHewPn/J2HIQX/8+Qi+osA3NDQZmOug2/L+mpqarSZYmb4Neq
oKAQsR4kaLKy9Xoa+H+l+6/9qizpYWXeWi24KkDfUsYGN1wCbxcM7bXhVztbFSKS
NnDhpFhZ1LrAZSmPnOP44A9VKVU5oMymX9e8/WikY9XrSy61A9nkCRXyKU1xB7L6
OevldmXPMVza0NNrRz77OR5Bes5T0rdSqKP/P0gjKIIQ8XRkEl5kulvaD209XQKs
f1nCZcuANdzDTfzn7Q4kUiwvmipSri1jHl5TRhK8efLfByr8Ey7mz+Izao7PjG83
ydqltwJHhdnsUSWXySVDi111W81olQKO+WoRLrIC+rE8sco/qyhxhedFzg6HMVwA
wxUDq8N5lQsKp0WqXvNx2TmMuMaE++X09Vd8qfxgQLskg4af+cPxgM0td38Pu7z3
9STyQx0PfXnT9QxC7l7o/HkhoN0fX4XF7L6+lYJ3fYRwfSx4pOVuJNFIvoPKUHuW
ERIzhYsG1y82NZCqbjFMq0QmofWERStkwwidnfcTHiaMMC2y/pm73DKSZAXru5eO
KbALJN6u/uaN0HsrjE3S
=KJKd
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--

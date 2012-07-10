Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab2GJMTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:19:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab2GJMTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:19:16 -0400
Date: Tue, 10 Jul 2012 14:19:10 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] pwm: add lpc32xx pwm support
Message-ID: <20120710121910.GA8959@avionic-0098.adnet.avionic-design.de>
References: <1341921212-11953-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <1341921212-11953-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:aG1hu+1cE3HJURWSA5S2xHT6j23/LdT8qjphZLKjY7F
 5oQiXigcXdOreZVCkJ7IC+/5GqCJsFSAkiqsYmWWsdARmDiQSM
 RY2rCXPhjTL2QyvhWmdBxAWModhR3h1QBPB6zIZuvZzgeAVMLe
 nWriWzPtsu0ULZ6zQj3kpiGlhcUa9l/UaH6iXjjY25llM/sVB7
 vS6IHWBfq7aTiLUxxWSrfT2wAXKAAjusOZZXPCO0X/wYNmFbGx
 /XersdFG6rWVLjkxCturql/ePF1sEF5bEdKTT/qqY5ylXpoAat
 4+z40O9kNwhcRId+Ukgx/g20r5quD3y6CWYAS7pmSJcuTetT7b
 Ww083VG3sT+Gpnh/52QxqPuF+kyXsWoWZBspdji5bIsGcJhO3a
 1+OLO757MAqTBFcWXQJ9iaZJU7hPuwszao=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2012 at 08:53:32AM -0300, Alexandre Pereira da Silva wrote:
> Add lpc32xx soc pwm driver.

The subject and this still need fixing (soc -> SOC, pwm -> PWM).

> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> ---
> Changes since v1:
> * Style fixes
> * Better error handling
> * Improved Kconfig and DT descriptions
>=20
>  .../devicetree/bindings/pwm/lpc32xx-pwm.txt        |   17 +++
>  drivers/pwm/Kconfig                                |   11 ++
>  drivers/pwm/Makefile                               |    1 +
>  drivers/pwm/pwm-lpc32xx.c                          |  150 ++++++++++++++=
++++++
>  4 files changed, 179 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
>  create mode 100644 drivers/pwm/pwm-lpc32xx.c
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt b/Docu=
mentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
> new file mode 100644
> index 0000000..e7720e3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
> @@ -0,0 +1,17 @@
> +LPC32XX PWM controller
> +
> +Required properties:
> +- compatible: should be "nxp,lpc3220-pwm"
> +- reg: physical base address and length of the controller's registers
> +
> +Examples:
> +
> +pwm1: pwm@0x4005C000 {
> +	compatible =3D "nxp,lpc3220-pwm";
> +	reg =3D <0x4005C000 0x4>;
> +};
> +
> +pwm2: pwm@0x4005C004 {
> +	compatible =3D "nxp,lpc3220-pwm";
> +	reg =3D <0x4005C004 0x4>;
> +};

The PWM framework can support chips with multiple PWM devices. The
LPC32xx seems to fit this model quite nicely, so you should instead
instantiate one device and set npwm to 2.

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 0b2800f..ec2ac70 100644
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
> +	  Generic PWM framework driver for LPC32XX. The LPC32XX SOC has two
> +	  PWM controllers.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-lpc32xx.
> +
> +

There's a gratuitous blank line here, please remove.

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
> index 0000000..d79f4f9
> --- /dev/null
> +++ b/drivers/pwm/pwm-lpc32xx.c
> @@ -0,0 +1,150 @@
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
> +	struct clk *clk;
> +	void __iomem *base;
> +};
> +
> +#define PWM_ENABLE	(1 << 31)
> +#define PWM_RELOADV(x)	(((x) & 0xFF) << 8)
> +#define PWM_DUTY(x)	((x) & 0xFF)
> +
> +#define to_lpc32xx_pwm_chip(_chip) \
> +	container_of(_chip, struct lpc32xx_pwm_chip, chip)
> +
> +static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *=
pwm,
> +			      int duty_ns, int period_ns)
> +{
> +	struct lpc32xx_pwm_chip *lpc32xx =3D to_lpc32xx_pwm_chip(chip);
> +	unsigned long long c;
> +	int period_cycles, duty_cycles;
> +
> +	c =3D clk_get_rate(lpc32xx->clk) / 256;
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
> +	c =3D 256 * duty_ns;
> +	do_div(c, period_ns);
> +	duty_cycles =3D c;
> +
> +	writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
> +		lpc32xx->base);
> +
> +	return 0;
> +}

When you convert to having more than one PWM device per chip, you can
use pwm->hwpwm to distinguish between them. For this case this should be
a trivial as:

	writel(..., lpc32xx->base + (pwm->hwpwm << 2));

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
> +	if (!res)
> +		return -EINVAL;
> +
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

This should be set to 2.

Thierry

> +	ret =3D pwmchip_add(&lpc32xx->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add PWM chip, error %d\n", ret);
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, lpc32xx);
> +
> +	return 0;
> +}
> +
> +static int __devexit lpc32xx_pwm_remove(struct platform_device *pdev)
> +{
> +	struct lpc32xx_pwm_chip *lpc32xx =3D platform_get_drvdata(pdev);
> +
> +	return pwmchip_remove(&lpc32xx->chip);
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

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP/B29AAoJEN0jrNd/PrOh29sQAJBb7Dvwzvt0rNUVMqLUC071
MuB1lio7xYz4nn5YkPZIRZOPn4xoIYwLNEbkSJjU8w416uzc/tiz5faHNQ+pC47d
WgviFDoVtl0LDgNa6c7GsmA00wkYlYv/gGpvH2MSNZx6DslQLN3QaO6WEh0eX3Ik
LMuCf7DyIToHkFZTjuCBKgHzCIDut9sQef9qitNRLLGTuOK9stOd/LNu8RWVaxvc
Gy1USWpBZUXxhcFLzXCgMISuh8j1MM02t5DhUZ7BqCsMG3pcQg/BcPHd4Sz0p0bD
1nZATOmVPEQyG5pz0ll3qlrIf/dZIh3PIZ+lomnpK0w9eqwgXPktusim3qXceQom
fyVmMCMvbLDb7xwlBQHxXGdTG54XmEH5+wD9uYbHS2BnjA7OP8vOU/NN5IqI1FgJ
W0BC/KUEd/FhzSoxlBs/3aEmH8BYnlMQmrvngllRgo+WO6sgirW35U3XZpkds/8v
mj73VDFIv5g3KHgfgmwlw5AOLOiGWymDM7wd3hvDdcCeHBf/1AqgGgYA85G0K0N2
rmEfYpd2xxe7Esfi4jKFR7wtEoSj18SI6hWAl9BwzRqjwgTgPhjGDLTUEBgznSq4
9jjuQai0/yQM2USQZXBjKdKWKiYHv0c8jbNNLEkHNiBHH509RRNMq0aSmHMcOUvN
valkLoplgwDylwqQS9zS
=VDYI
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--

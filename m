Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2JRMI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 08:08:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2JRMI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 08:08:28 -0400
Date: Thu, 18 Oct 2012 14:08:20 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: spear--sw-devel@lists.codex.cro.st.com, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] pwm: add spear pwm driver support
Message-ID: <20121018120820.GA17980@avionic-0098.mockup.avionic-design.de>
References: <1350559712-8514-1-git-send-email-shiraz.hashim@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <1350559712-8514-1-git-send-email-shiraz.hashim@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:iDEmjUOlwOR9H1GcvsA+KCTBB4NiU96muDPTM3ekMLa
 dm7PrmvZmwUsDXdO0DkjDErwd1GiqwZ4fBPeMyAlqQx2x8A1ol
 QTKNxjTTavZ+fdRJVMedQIB1LSN5YNwc/V2x0h6jHaahUNMLfu
 iClhmrY59fgbzVdKfaN89KiW52Krtk8VZi7WNuey8zN8+Yr1Tz
 A9IrhzX64oGuNlUh3m7jZhBLIPURaerB6ba8iIgwoPYC7q+dm7
 maTaFIGENl3dJb63Uhd/EuNx3DtBLt/wOxY80nih3CcWqtk/pa
 WMCej+zGDDqN0adfnQrrvZ/YSjdZtv7KyGcleRCHrlkqJNe/Kz
 DeAyivvDKeM5zfv1bvXjJ0YOHENab/u4AxtyFDdil+4dR4/Fsb
 rhWy2GMqnOGv4sAuNpSUfI6gpZiQFwTSGo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 18, 2012 at 04:58:32PM +0530, Shiraz Hashim wrote:
> Add support for pwm devices present on SPEAr platforms.  These pwm
> devices support 4 channel output with programmable duty cycle and
> frequency.
>=20
> More details on these pwm devices can be obtained from relevant chapter
> of reference manual, present at following[1] location.

Please make sure to spell PWM consistently. It should be in all
uppercase in text. Lowercase should only be used in variable names or
the patch subject prefix. See other commit messages for examples. The
same applies to the rest of this patch, which seems to use a random mix
of both.

And maybe this shouldn't say "Add support for pwm devices" but rather
"Add support for PWM chips..." and "These PWM chips support..."

>=20
> 1. http://www.st.com/internet/mcu/product/251211.jsp
>=20
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Vipin Kumar <vipin.kumar@st.com>
> ---
>  .../devicetree/bindings/pwm/st-spear-pwm.txt       |   19 ++
>  drivers/pwm/Kconfig                                |   10 +
>  drivers/pwm/Makefile                               |    1 +
>  drivers/pwm/pwm-spear.c                            |  287 ++++++++++++++=
++++++
>  4 files changed, 317 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/st-spear-pwm.txt
>  create mode 100644 drivers/pwm/pwm-spear.c
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/st-spear-pwm.txt b/Doc=
umentation/devicetree/bindings/pwm/st-spear-pwm.txt
> new file mode 100644
> index 0000000..b3dd1a0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/st-spear-pwm.txt

I think this should either be "spear-pwm.txt" to mirror the driver name,
or, to follow the Tegra example, "st,spear-pwm.txt" to mirror the
compatible property.

> @@ -0,0 +1,19 @@
> +=3D=3D ST SPEAr SoC PWM controller =3D=3D
> +
> +Required properties:
> +- compatible: should be one of:
> +  - "st,spear-pwm"
> +  - "st,spear13xx-pwm"
> +- reg: physical base address and length of the controller's registers
> +- #pwm-cells: number of cells used to specify PWM which is fixed to 2 on=
 SPEAr. The

I think you can break the "The" to the next line to make it fit within
the 80 character limit.

> +  first cell specifies the per-chip index of the PWM to use and the seco=
nd
> +  cell is the duty cycle in nanoseconds.

This should be "period in nanoseconds". I know this is wrong in the
binding documentation for other drivers but I've recently committed a
patch that fixes it.

> +
> +Example:
> +
> +        pwm: pwm@a8000000 {
> +            compatible =3D"st,spear-pwm";
> +            reg =3D <0xa8000000 0x1000>;
> +            #pwm-cells =3D <2>;
> +            status =3D "disabled";
> +        };
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index ed81720..3ff3e6f 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -112,6 +112,16 @@ config PWM_SAMSUNG
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-samsung.
> =20
> +config PWM_SPEAR
> +	tristate "STMicroelectronics SPEAR PWM support"

You've spelled this "SPEAr" above and below, why not keep that spelling
here as well?

> +	depends on PLAT_SPEAR
> +	help
> +	  Generic PWM framework driver for the PWM controller on ST
> +	  SPEAr SoCs.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-spear.
> +
>  config PWM_TEGRA
>  	tristate "NVIDIA Tegra PWM support"
>  	depends on ARCH_TEGRA
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index acfe482..6512786 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -9,6 +9,7 @@ obj-$(CONFIG_PWM_PUV3)		+=3D pwm-puv3.o
>  obj-$(CONFIG_PWM_PXA)		+=3D pwm-pxa.o
>  obj-$(CONFIG_PWM_SAMSUNG)	+=3D pwm-samsung.o
>  obj-$(CONFIG_PWM_TEGRA)		+=3D pwm-tegra.o
> +obj-$(CONFIG_PWM_SPEAR)		+=3D pwm-spear.o
>  obj-$(CONFIG_PWM_TIECAP)	+=3D pwm-tiecap.o
>  obj-$(CONFIG_PWM_TIEHRPWM)	+=3D pwm-tiehrpwm.o
>  obj-$(CONFIG_PWM_TWL6030)	+=3D pwm-twl6030.o
> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> new file mode 100644
> index 0000000..814395b
> --- /dev/null
> +++ b/drivers/pwm/pwm-spear.c
> @@ -0,0 +1,287 @@
> +/*
> + * ST Microelectronics SPEAr Pulse Width Modulator driver
> + *
> + * Copyright (C) 2012 ST Microelectronics
> + * Shiraz Hashim <shiraz.hashim@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/kernel.h>
> +#include <linux/math64.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/slab.h>
> +
> +/* PWM registers and bits definitions */
> +#define PWMCR			0x00	/* Control Register */
> +#define PWMDCR			0x04	/* Duty Cycle Register */
> +#define PWMPCR			0x08	/* Period Register */
> +/* Following only available on 13xx SoCs */
> +#define PWMMCR			0x3C	/* Master Control Register */
> +
> +#define PWM_ENABLE		0x1
> +
> +#define MIN_PRESCALE		0x00
> +#define MAX_PRESCALE		0x3FFF
> +#define PRESCALE_SHIFT		2
> +
> +#define MIN_DUTY		0x0001
> +#define MAX_DUTY		0xFFFF
> +
> +#define MIN_PERIOD		0x0001
> +#define MAX_PERIOD		0xFFFF

Would it make sense to perhaps group the bitfields with the matching
register definitions to make their use more obvious. Also I prefer
lowercase hexadecimal digits, but that's pure bikeshedding.

> +
> +#define NUM_PWM			4
> +
> +/**
> + * struct pwm: struct representing pwm ip
> + *
> + * mmio_base: base address of pwm
> + * clk: pointer to clk structure of pwm ip
> + * chip: linux pwm chip representation
> + * dev: pointer to device structure of pwm
> + */

This is not proper kerneldoc. Also the structure is called
spear_pwm_chip below, while the comment says "struct pwm".

> +struct spear_pwm_chip {
> +	void __iomem *mmio_base;
> +	struct clk *clk;
> +	struct pwm_chip	chip;
> +	struct device *dev;
> +};
> +
> +static inline struct spear_pwm_chip *to_spear_pwm_chip(struct pwm_chip *=
chip)
> +{
> +	return container_of(chip, struct spear_pwm_chip, chip);
> +}
> +
> +static inline u32 spear_pwm_readl(struct spear_pwm_chip *chip, unsigned =
int num,
> +		unsigned long offset)

I personally like it better to have function arguments aligned, like so:

static inline u32 spear_pwm_readl(struct spear_pwm_chip *chip, unsigned int=
 num,
				  unsigned long offset)

Note, those are as many 8-spaces tabs with only spaces to align them
properly. But again, pure bikeshedding and I won't force the issue.

> +{
> +	return readl_relaxed(chip->mmio_base + (num << 4) + offset);
> +}
> +
> +static inline void spear_pwm_writel(struct spear_pwm_chip *chip,
> +		unsigned int num, unsigned long offset, unsigned long val)
> +{
> +	writel_relaxed(val, chip->mmio_base + (num << 4) + offset);
> +}
> +
> +/*
> + * period_ns =3D 10^9 * (PRESCALE + 1) * PV / PWM_CLK_RATE
> + * duty_ns =3D 10^9 * (PRESCALE + 1) * DC / PWM_CLK_RATE
> + *
> + * PV =3D (PWM_CLK_RATE * period_ns)/ (10^9 * (PRESCALE + 1))
> + * DC =3D (PWM_CLK_RATE * duty_ns)/ (10^9 * (PRESCALE + 1))
> + */
> +int spear_pwm_config(struct pwm_chip *pwm, struct pwm_device *pwmd, int =
duty_ns,

If you call the pwm variable chip, there's no need to introduce the
somewhat confusing pwmd. The same goes for the other callbacks below.

> +		int period_ns)
> +{
> +	struct spear_pwm_chip *pc =3D to_spear_pwm_chip(pwm);
> +	u64 val, div, clk_rate;
> +	unsigned long prescale =3D MIN_PRESCALE, pv, dc;
> +	int ret =3D -EINVAL;
> +
> +	if (period_ns =3D=3D 0 || duty_ns > period_ns)
> +		goto err;

No need to check for these cases, they are already handled by the core.

> +
> +	/*
> +	 * Find pv, dc and prescale to suit duty_ns and period_ns. This is done
> +	 * according to formulas provided above this routine.
> +	 */

Maybe you should move the formulas into this comment. That puts them
more closely to where they are referred to.

> +	clk_rate =3D clk_get_rate(pc->clk);
> +	while (1) {
> +		div =3D 1000000000;
> +		div *=3D 1 + prescale;
> +		val =3D clk_rate * period_ns;
> +		pv =3D div64_u64(val, div);
> +		val =3D clk_rate * duty_ns;
> +		dc =3D div64_u64(val, div);
> +
> +		/* if duty_ns and period_ns are not acheivable then return */

"achievable"

> +		if (!pv || !dc || pv < MIN_PERIOD || dc < MIN_DUTY)
> +			goto err;
> +
> +		/*
> +		 * if pv and dc have crossed their upper limit, then increase
> +		 * prescale and recalculate pv and dc.
> +		 */
> +		if ((pv > MAX_PERIOD) || (dc > MAX_DUTY)) {

The inner parentheses are not required.

> +			prescale++;
> +			if (prescale > MAX_PRESCALE)

Maybe condense into "if (++prescale > MAX_PRESCALE)"?

> +				goto err;
> +			continue;
> +		}
> +		break;
> +	}
> +
> +	/*
> +	 * NOTE: the clock to PWM has to be enabled first before writing to the
> +	 * registers.
> +	 */
> +	ret =3D clk_prepare_enable(pc->clk);
> +	if (ret)
> +		goto err;
> +
> +	spear_pwm_writel(pc, pwmd->hwpwm, PWMCR, prescale << PRESCALE_SHIFT);
> +	spear_pwm_writel(pc, pwmd->hwpwm, PWMDCR, dc);
> +	spear_pwm_writel(pc, pwmd->hwpwm, PWMPCR, pv);
> +	clk_disable_unprepare(pc->clk);
> +
> +	return 0;
> +err:
> +	dev_err(pc->dev, "pwm config fail\n");

You might want to output an error code here. But I don't think it is
even necessary. Users of the PWM API are supposed to handle errors from
pwm_config() properly, so this will in most cases just output a
duplicate error message. Also, if you get rid of the message you can do
away with the gotos and the label as well.

> +	return ret;
> +}
> +
> +static int spear_pwm_enable(struct pwm_chip *pwm, struct pwm_device *pwm=
d)
> +{
> +	struct spear_pwm_chip *pc =3D to_spear_pwm_chip(pwm);
> +	int rc =3D 0;
> +	u32 val;
> +
> +	rc =3D clk_prepare_enable(pc->clk);
> +	if (rc < 0)
> +		return rc;
> +
> +	val =3D spear_pwm_readl(pc, pwmd->hwpwm, PWMCR);
> +	val |=3D PWM_ENABLE;
> +	spear_pwm_writel(pc, pwmd->hwpwm, PWMCR, val);
> +
> +	return 0;
> +}
> +
> +static void spear_pwm_disable(struct pwm_chip *pwm, struct pwm_device *p=
wmd)
> +{
> +	struct spear_pwm_chip *pc =3D to_spear_pwm_chip(pwm);
> +	u32 val;
> +
> +	val =3D spear_pwm_readl(pc, pwmd->hwpwm, PWMCR);
> +	val &=3D ~PWM_ENABLE;
> +	spear_pwm_writel(pc, pwmd->hwpwm, PWMCR, val);
> +
> +	clk_disable_unprepare(pc->clk);
> +}
> +
> +static const struct pwm_ops spear_pwm_ops =3D {
> +	.config =3D spear_pwm_config,
> +	.enable =3D spear_pwm_enable,
> +	.disable =3D spear_pwm_disable,
> +	.owner =3D THIS_MODULE,
> +};
> +
> +static int __devinit spear_pwm_probe(struct platform_device *pdev)

__devinit will go away sometime soon, so please don't use it in new
code.

> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct spear_pwm_chip *pc;
> +	struct resource *r;
> +	int ret;
> +	u32 val;
> +
> +	pc =3D devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
> +	if (!pc) {
> +		dev_err(&pdev->dev, "failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	pc->dev =3D &pdev->dev;
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!r) {
> +		dev_err(&pdev->dev, "no memory resources defined\n");
> +		return -ENODEV;
> +	}
> +
> +	pc->mmio_base =3D devm_request_and_ioremap(&pdev->dev, r);
> +	if (!pc->mmio_base)
> +		return -EADDRNOTAVAIL;
> +
> +	platform_set_drvdata(pdev, pc);
> +
> +	pc->clk =3D devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(pc->clk))
> +		return PTR_ERR(pc->clk);
> +
> +	pc->chip.dev =3D &pdev->dev;
> +	pc->chip.ops =3D &spear_pwm_ops;
> +	pc->chip.base =3D -1;
> +	pc->chip.npwm =3D NUM_PWM;
> +
> +	ret =3D pwmchip_add(&pc->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (np && of_device_is_compatible(np, "st,spear13xx-pwm")) {
> +		ret =3D clk_prepare_enable(pc->clk);
> +		if (ret < 0)
> +			return pwmchip_remove(&pc->chip);
> +
> +		/* Following enables PWM device, channels would still be
> +		 * enabled individually through their control register
> +		 **/

This is not a proper multi-line comment.

> +		val =3D readl(pc->mmio_base + PWMMCR);
> +		val |=3D PWM_ENABLE;
> +		writel(val, pc->mmio_base + PWMMCR);
> +
> +		clk_disable_unprepare(pc->clk);
> +	}
> +
> +	return 0;
> +}
> +
> +static int __devexit spear_pwm_remove(struct platform_device *pdev)

__devexit can be dropped as well.

> +{
> +	struct spear_pwm_chip *pc =3D platform_get_drvdata(pdev);
> +	int i;
> +
> +	if (WARN_ON(!pc))
> +		return -ENODEV;
> +
> +	for (i =3D 0; i < NUM_PWM; i++) {
> +		struct pwm_device *pwmd =3D &pc->chip.pwms[i];

Again, the canonical name for this would be just plain "pwm".

> +
> +		if (!test_bit(PWMF_ENABLED, &pwmd->flags))
> +			if (clk_prepare_enable(pc->clk) < 0)
> +				continue;
> +
> +		spear_pwm_writel(pc, i, PWMCR, 0);
> +		clk_disable_unprepare(pc->clk);
> +	}
> +
> +	return pwmchip_remove(&pc->chip);
> +}
> +
> +#ifdef CONFIG_OF
> +static struct of_device_id spear_pwm_of_match[] =3D {
> +	{ .compatible =3D "st,spear-pwm" },
> +	{ .compatible =3D "st,spear13xx-pwm" },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, spear_pwm_of_match);
> +#endif

Is there a reason to make this conditional? It looks like SPEAr has
moved to OF, so this will always be enabled anyway, won't it?

> +
> +static struct platform_driver spear_pwm_driver =3D {
> +	.driver =3D {
> +		.name =3D "spear-pwm",
> +		.of_match_table =3D of_match_ptr(spear_pwm_of_match),

Same here. If SPEAr is always OF, then of_match_ptr is useless.

> +	},
> +	.probe =3D spear_pwm_probe,
> +	.remove =3D __devexit_p(spear_pwm_remove),

__devexit_p is also superfluous.

> +};
> +
> +module_platform_driver(spear_pwm_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Shiraz Hashim <shiraz.hashim@st.com>");
> +MODULE_AUTHOR("Viresh Kumar <viresh.kumar@linaro.com>");

I don't think this works: the second entry will replace the first. Have
you verified that both authors appear in the output of modinfo?

> +MODULE_ALIAS("platform:st-pwm");

Should this not rather be "platform:spear-pwm"?

Thierry

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQf/E0AAoJEN0jrNd/PrOhhewQAKGklqCVKYrLl1AltyJSal+k
tc93jsGBx4O8IKVqAfbyNUDTyjFo+OaUt2bimCW4m0NjFUE8QKO7YC0vywO0tEYp
aD9Ql/qyGTZ6jsIkOsEaaMGt2UI8NVY2FYt66Io41+HL8ZXpiQr5jgImK/ARxtX3
viyO+ph5owLFjApOp3Uj1mSGZVy2A1NKvCWsF8JF7oRMJejHmAJUNlgUPOWyd4UL
KgeHaV2qQKIMyzOYRcNTvl5/okTO4r7n6gGWOyMogp/xmb7dzLNVUgWWnrBkeSq2
JmtncKGIFqTNqEdHF8zvpybmfLSfVGTXbYwKp8t4wDkM/AKaGD/3dynl3L3f1CZV
MiyAeGBV0waLQWA8LZ1Vt2ME6dvJacTT4ADiKtY1HDc6CFih25TRGq+VHRhWfpNf
UxK7OnqwFuqbDz3ZYCrOh51+48E0ZQQJeF7bCRW6FSBGE+cRGDsFXP6WW7S2SBex
X60e1twR+VxGVS/TimjfT1SL7Gu3aY4BbKv8OxzitKhDkw5bWOvoA9Ysl/aqY/yP
BUVY7YluKsUPXa7Oo6pRDtMgs5OBduRAATi0hHai5NYABQ2o+vELVpuwbGniQAUF
VCzOFiVi35isQ6Q8+9vONBp86X/9gyVxbP+wHXu2XNDoeMVX8svqE1mQzAM7DAR9
FYERcp/YPVGhqP6NuQ1r
=kieh
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--

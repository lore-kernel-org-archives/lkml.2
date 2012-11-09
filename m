Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab2KIHaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 02:30:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62947 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab2KIHaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 02:30:14 -0500
Date: Fri, 9 Nov 2012 08:29:57 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com
Subject: Re: [PATCH v2 01/10] PWMSS: Add PWM Subsystem driver for
 parent<->child relationship
Message-ID: <20121109072957.GA21991@avionic-0098.mockup.avionic-design.de>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
 <1352361197-27442-2-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1352361197-27442-2-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VVJBxlSt1076k8HvGal80BMUEB+EbS1lfiiCaYa0g9t
 CJC63CqUSQRv/TGYj36dSKNyNQzbA8Dve+IlXalbIfGZMaWPaj
 6fb96EFEUvSIPn4blMMvFCXVsBn8PwI2c4qTyBmkacQ2LDRmBi
 PMgdREbSuI0N4ZyxaiN/IcnlcdxHTvhxjwrzLTSzfkelnqdPAS
 yYWUYWolbdThTmtoJ+rhu5TijWvJUqmWJtFrCmPAVsxyRXYymp
 KNBWl2lA6fxrAZmnku/1YxYgAPI7szH11jE3fGvS7+vRztNkZ1
 +xNseJlpkfTyQ5/U1k876cDEozjwxjiN/C+E7q+JEA/x/D9IOc
 aFysZGtnys+9874+mEFBBSsvsKUpaVgN4qlPp5GmphGwGogjHF
 uYnerNd1Xms2Wuai6z0E1u0Avu2dmCJ3/g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 08, 2012 at 01:23:08PM +0530, Philip, Avinash wrote:
> diff --git a/Documentation/devicetree/bindings/pwm/tipwmss.txt b/Document=
ation/devicetree/bindings/pwm/tipwmss.txt
> new file mode 100644
> index 0000000..b6c2814
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/tipwmss.txt
> @@ -0,0 +1,30 @@
[...]
> +Also child nodes should also populated under PWMSS DT node.
> +Example:

Maybe put an blank line between these two lines for readability?

> +pwmss0: pwmss@48300000 {
> +	compatible =3D "ti,am33xx-pwmss";
> +	reg =3D <0x48300000 0x10
> +		0x48300100 0x80
> +		0x48300180 0x80
> +		0x48300200 0x80>;

I don't think you should list the register spaces of the children here.
=46rom what I understand, all regions listed in the reg property are
supposed to be requested by the corresponding driver and therefore
cannot be used by any other device.

> +	ti,hwmods =3D "epwmss0";
> +	#address-cells =3D <1>;
> +	#size-cells =3D <1>;
> +	status =3D "disabled";
> +	ranges;

I think to represent which memory regions go to the children, you should
put them in this ranges property, which would then look like this:

	ranges =3D <0x48300100 0x48300100 0x80   /* ECAP */
		  0x48300180 0x48300180 0x80   /* EQEP */
		  0x48300200 0x48300200 0x80>; /* EHRPWM */

> +
> +	/* child nodes go here */
> +};

Maybe you should actually list a full set of children here?

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 6e556c7..384a346 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -136,6 +136,7 @@ config PWM_TEGRA
>  config  PWM_TIECAP
>  	tristate "ECAP PWM support"
>  	depends on SOC_AM33XX
> +	select PWM_TIPWMSS
>  	help
>  	  PWM driver support for the ECAP APWM controller found on AM33XX
>  	  TI SOC
> @@ -146,6 +147,7 @@ config  PWM_TIECAP
>  config  PWM_TIEHRPWM
>  	tristate "EHRPWM PWM support"
>  	depends on SOC_AM33XX
> +	select PWM_TIPWMSS
>  	help
>  	  PWM driver support for the EHRPWM controller found on AM33XX
>  	  TI SOC
> @@ -153,6 +155,15 @@ config  PWM_TIEHRPWM
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-tiehrpwm.
> =20
> +config  PWM_TIPWMSS
> +	tristate "TI PWM Subsytem parent support"
> +	depends on SOC_AM33XX && (PWM_TIEHRPWM || PWM_TIECAP)

Since you select the symbol from the PWM_TIECAP and PWM_TIEHRPWM symbols
there is no need to depend on them, right? Oh, but maybe that's to make
sure the symbol is deselected automatically if neither user is selected.

Perhaps this should actually be a hidden symbol (i.e. leave away the
prompt string in the tristate option) since it's purely a dependency and
not useful of its own.

> +	help
> +	  PWM Subsystem driver support for AM33xx SOC.
> +
> +	  PWM submodules require PWM config space access from submodule
> +	  drivers and require common parent driver support.
> +
>  config PWM_TWL6030
>  	tristate "TWL6030 PWM support"
>  	depends on TWL4030_CORE
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index 3b3f4c9..55f6fb2 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -12,5 +12,6 @@ obj-$(CONFIG_PWM_SPEAR)		+=3D pwm-spear.o
>  obj-$(CONFIG_PWM_TEGRA)		+=3D pwm-tegra.o
>  obj-$(CONFIG_PWM_TIECAP)	+=3D pwm-tiecap.o
>  obj-$(CONFIG_PWM_TIEHRPWM)	+=3D pwm-tiehrpwm.o
> +obj-$(CONFIG_PWM_TIPWMSS)	+=3D tipwmss.o

This should have a pwm- prefix as well.

>  obj-$(CONFIG_PWM_TWL6030)	+=3D pwm-twl6030.o
>  obj-$(CONFIG_PWM_VT8500)	+=3D pwm-vt8500.o
> diff --git a/drivers/pwm/tipwmss.c b/drivers/pwm/tipwmss.c
> new file mode 100644
> index 0000000..c188348
> --- /dev/null
> +++ b/drivers/pwm/tipwmss.c
> @@ -0,0 +1,142 @@
[...]
> +#include "tipwmss.h"
> +
> +#define PWMSS_CLKCONFIG		0x8	/* Clock gaitng reg, for PWM submodules */

"gating"

> +#define PWMSS_CLKSTATUS		0xc	/* Clock gating status reg */
> +
> +struct pwmss_info {
> +	void __iomem	*mmio_base;
> +	struct mutex	pwmss_lock;
> +	u16				pwmss_clkconfig;

The indentation looks weird on this last field.

> +};
> +
> +u16 pwmss_submodule_state_change(struct device *dev, int set)
> +{
> +	struct pwmss_info *info =3D dev_get_drvdata(dev);
> +	u16 val;
> +
> +	val =3D readw(info->mmio_base + PWMSS_CLKCONFIG);
> +	val |=3D set;
> +	mutex_lock(&info->pwmss_lock);
> +	writew(val , info->mmio_base + PWMSS_CLKCONFIG);
> +	mutex_unlock(&info->pwmss_lock);

The mutex needs to span the whole read-modify-write sequence, not just
the write.

Also, how do you clear this state?

> +	return readw(info->mmio_base + PWMSS_CLKSTATUS);
> +}
> +EXPORT_SYMBOL(pwmss_submodule_state_change);
> +
> +static const struct of_device_id pwmss_of_match[] =3D {
> +	{
> +		.compatible	=3D "ti,am33xx-pwmss",
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, pwmss_of_match);
> +
> +static int __devinit pwmss_probe(struct platform_device *pdev)

__dev* annotation usage is deprecated, you should drop it.

> +{
> +	int ret;
> +	struct resource *r;
> +	struct pwmss_info *info;
> +	struct device_node *node =3D pdev->dev.of_node;
> +
> +	info =3D devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
> +	if (!info) {
> +		dev_err(&pdev->dev, "failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	mutex_init(&info->pwmss_lock);
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);

Blank line between those two lines?

> +	if (!r) {
> +		dev_err(&pdev->dev, "no memory resource defined\n");
> +		return -ENODEV;
> +	}
> +
> +	info->mmio_base =3D devm_request_and_ioremap(&pdev->dev, r);
> +	if (!info->mmio_base)
> +		return -EADDRNOTAVAIL;
> +
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_get_sync(&pdev->dev);
> +	platform_set_drvdata(pdev, info);
> +
> +	/* Populate all the child nodes here... */
> +	ret =3D of_platform_populate(node, NULL, NULL, &pdev->dev);
> +	if (ret)
> +		dev_warn(&pdev->dev, "Doesn't have any child node\n");

This reads oddly compared to the other error messages, maybe something
like "no children found" or similar would be more consistent.

> +
> +	return ret;

Then again, since you return of_platform_populate()'s error code here,
you may just want to skip the above warning since the driver probe won't
succeed anyway. Or if you really want to give a hint as to why loading
failed, maybe it would be better to make it an error message instead.

There is one little problem with registering the children here, which is
that if you build the drivers as modules, because once the pwm-tipwmss
module is unloaded, reloading it will fail since it will try to create
the children again.

AFAICT there are two solutions to this: a) do not allow the pwm-tipwmss
code to be built as a module and b) have of_platform_populate() called
by the architecture initialization code. Both are relatively easy to
implement. a) can be done by making the PWM_TIPWMSS symbol bool instead
of tristate, and b) can be done by adding "simple-bus" to the end of the
compatible list in the DT.

> +}
> +
> +static int __devexit pwmss_remove(struct platform_device *pdev)

Again, no need for __devexit anymore.

> +{
> +	struct pwmss_info *info =3D platform_get_drvdata(pdev);
> +
> +	pm_runtime_put_sync(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +	mutex_destroy(&info->pwmss_lock);
> +	return 0;
> +}
> +
> +static int pwmss_suspend(struct device *dev)
> +{
> +	struct pwmss_info *info =3D dev_get_drvdata(dev);
> +
> +	info->pwmss_clkconfig =3D readw(info->mmio_base + PWMSS_CLKCONFIG);
> +	pm_runtime_put_sync(dev);
> +	return 0;
> +}
> +
> +static int pwmss_resume(struct device *dev)
> +{
> +	struct pwmss_info *info =3D dev_get_drvdata(dev);
> +
> +	pm_runtime_get_sync(dev);
> +	writew(info->pwmss_clkconfig, info->mmio_base + PWMSS_CLKCONFIG);
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops pwmss_pm_ops =3D {
> +	.suspend	=3D pwmss_suspend,
> +	.resume		=3D pwmss_resume,
> +};

Shouldn't these functions be conditionalized on CONFIG_PM_SLEEP? And
maybe you want to use the SIMPLE_DEV_PM_OPS macro here.

> +
> +static struct platform_driver pwmss_driver =3D {
> +	.driver	=3D {
> +		.name	=3D "pwmss",
> +		.owner	=3D THIS_MODULE,
> +		.pm	=3D &pwmss_pm_ops,
> +		.of_match_table	=3D of_match_ptr(pwmss_of_match),

You already define the pwmss_of_match table unconditionally, so you
don't need the of_match_ptr() either.

> +	},
> +	.probe	=3D pwmss_probe,
> +	.remove	=3D __devexit_p(pwmss_remove),

__devexit_p() can go away.

> +};
> +
> +module_platform_driver(pwmss_driver);
> +
> +MODULE_DESCRIPTION("pwmss driver");

This description could be better.

> +MODULE_AUTHOR("Texas Instruments");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/pwm/tipwmss.h b/drivers/pwm/tipwmss.h
> new file mode 100644
> index 0000000..f9cb2e2
> --- /dev/null
> +++ b/drivers/pwm/tipwmss.h

I think this should also get the pwm- prefix for consistency with the
source file.

> @@ -0,0 +1,30 @@
> +/*
> + * TI PWM Subsystem driver
> + *
> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __TIPWMSS_H
> +#define __TIPWMSS_H
> +
> +#ifdef CONFIG_PWM_TIPWMSS
> +extern u16 pwmss_submodule_state_change(struct device *dev, int set);
> +#else
> +static inline u16 pwmss_submodule_state_change(struct device *dev, int s=
et)
> +{
> +	/* return success status value */
> +	return 0xFFFF;
> +}
> +#endif
> +#endif	/* __TIPWMSS_H */

Is it really necessary to provide a !PWM_TIPWMSS version of this
function? All users that want to use it can select it and get the
correct version, right?

Thierry

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnLD1AAoJEN0jrNd/PrOhyI8QAKjfV2g37Uknrlg3ncFJ4ZcR
7CeMgBJzWlGQwh58t/mVxFraOIwLixGc6N6926bw/q4xLx1DyWmxpe/OT85+SEvp
WKxQe5raXEy6ZJIUkwomd+ERklLPvzCq5o6UKwn63rvcaSeCS5Zu7p0l+b+FmG2i
FQJQ/ezt/EU1ify748Ta6IeDWAMc1BAmCejPEPz3N9KgAz0Y9s/dPNgpv4RbyS9G
B2dd1oEzAE2fbzclUa5hB2YY732ilKzFc6sFUY77B45Np7hoxpEiEqiQMAkSBY/c
7O5qoMSbYcbNwVM1EKwPIOHYdXuL74YLy/7ZQNAuLYA9YMTZfygbc2rpcoxK/Yzo
N3mzTeXhZHk1UOt/ZdEc3Vfopm9Om7J/P1YfyN47rR4fW2oTIaJWmi5s6Rt0z7ix
pGySycI5zlY9ie/eQleUrS3JiN7//aJHkYJlanSlicsCoRLpCc6mK7ZRsJaa15sk
8JiXvxgXMDdt0PU0Bd00UzIAAdGgA71SfBu/WTF03amqIwSwlwzBaVX9929e+YH7
bfh7Rku/ckE0Z6zi2c588c//vvig/OrAK6FsL45gXQd9FIvUGZMgbsezFKtP16Ts
cDwwuPgGVA653giaWJMiG0/3i/mOKTWAJqwXi4bReY1La38xAPwNHXort64RYbKF
+x1hMMw1UQE56/5g5YCE
=mht8
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--

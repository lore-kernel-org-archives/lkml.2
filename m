Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173Ab2KIHwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 02:52:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2KIHw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 02:52:29 -0500
Date: Fri, 9 Nov 2012 08:52:19 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 04/10] pwm: pwm-tiecap: Add device-tree binding
 support for APWM driver
Message-ID: <20121109075219.GA22224@avionic-0098.mockup.avionic-design.de>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
 <1352361197-27442-5-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <1352361197-27442-5-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:mj2skRrFwOm5T3YYHcifqznMGG7b1aIp9urrRNDzI4K
 y1XN+MJaZikAoyWbxvPuqOsIisqBEkr0tge0huv9IyFq7/horn
 Y5q4LNUAWiC19oMJdcHpJW6Cx1NHwXvgJKe913oAvXhXUF6vEb
 udnILzxkzgWbRWWTWQ9k94NNypk4HCTyQL4T837xp/qFoogAOB
 +QSWlBh8fhCn3MEUWS5doxdNzrD9CA4jGStoEgbfEhuBYqaodC
 +jFeACIhW9anccf1wz/c+jTvXIaZ9GPXWAv6qIsBlvinVCW2hK
 H44XGKIVRhgjJVooR2UszFa9WnS5CQLlP1ttQdwKv8monR+pEQ
 J2k9eQ7PSsP6Ii7FOr9wnPOq3p7k/Nwcma3+zgoJ8WPFHXibwt
 9ci1qf3k7fdQl+HduVNWHmPwTDoEN1A0Z4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 08, 2012 at 01:23:11PM +0530, Philip, Avinash wrote:
> This patch
> 1. Add support for device-tree binding for ECAP APWM driver.
> 2. Set size of pwm-cells set to 3 to support PWM channel number, PWM
>    period & polarity configuration from device tree.
> 3. Add enable/disable clock gating in PWM subsystem common config space.
> 4. When here set .owner member in platform_driver structure to
>    THIS_MODULE.
>=20
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> Cc:	Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> ---
> Changes since v1:
> 	- Add separate patch for pinctrl support
> 	- Add conditional check for PWM subsystem clock enable.
> 	- Combined with HWMOD changes & DT bindings.
> 	- Remove the custom of xlate support.
>=20
> :000000 100644 0000000... fe24cac... A	Documentation/devicetree/bindings/=
pwm/pwm-tiecap.txt
> :100644 100644 d6d4cf0... 0d43266... M	drivers/pwm/pwm-tiecap.c
>  .../devicetree/bindings/pwm/pwm-tiecap.txt         |   22 +++++++++
>  drivers/pwm/pwm-tiecap.c                           |   48 ++++++++++++++=
+++++-
>  2 files changed, 69 insertions(+), 1 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt b/Docum=
entation/devicetree/bindings/pwm/pwm-tiecap.txt
> new file mode 100644
> index 0000000..fe24cac
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
> @@ -0,0 +1,22 @@
> +TI SOC ECAP based APWM controller
> +
> +Required properties:
> +- compatible: Must be "ti,am33xx-ecap"
> +- #pwm-cells: Should be 3. Number of cells being used to specify PWM pro=
perty.
> +  First cell specifies the per-chip index of the PWM to use, the second
> +  cell is the period cycle in nanoseconds and bit 0 in the third cell is

I think this should be "period in nanoseconds". I haven't heard "period
cycle" before.

> +  used to encode the polarity of PWM output.

Maybe you should explicitly say how this is encoded.

> +- reg: physical base address and size of the registers map.
> +
> +Optional properties:
> +- ti,hwmods: Name of the hwmod associated to the ECAP:
> +  "ecap<x>", <x> being the 0-based instance number from the HW spec
> +
> +Example:
> +
> +ecap0: ecap@0 {
> +	compatible =3D "ti,am33xx-ecap";
> +	#pwm-cells =3D <3>;
> +	reg =3D <0x48300100 0x80>;
> +	ti,hwmods =3D "ecap0";
> +};
> diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
> index d6d4cf0..0d43266 100644
> --- a/drivers/pwm/pwm-tiecap.c
> +++ b/drivers/pwm/pwm-tiecap.c
> @@ -25,6 +25,9 @@
>  #include <linux/clk.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pwm.h>
> +#include <linux/of_device.h>
> +
> +#include "tipwmss.h"
> =20
>  /* ECAP registers and bits definitions */
>  #define CAP1			0x08
> @@ -37,6 +40,13 @@
>  #define ECCTL2_SYNC_SEL_DISA	(BIT(7) | BIT(6))
>  #define ECCTL2_TSCTR_FREERUN	BIT(4)
> =20
> +#define ECAPCLK_EN			BIT(0)
> +#define ECAPCLK_STOP_REQ	BIT(1)

This one doesn't seem to align with the rest. Also, why is bit 0 called
_EN and bit 1 _STOP_REQ? Couldn't they be made more consistent, i.e.
_START and _STOP? Or _ENABLE and _DISABLE?

> +
> +#define ECAPCLK_EN_ACK		BIT(0)
> +
> +#define PWM_CELL_SIZE		3

You don't need a define for this.

> +
>  struct ecap_pwm_chip {
>  	struct pwm_chip	chip;
>  	unsigned int	clk_rate;
> @@ -184,6 +194,16 @@ static const struct pwm_ops ecap_pwm_ops =3D {
>  	.owner		=3D THIS_MODULE,
>  };
> =20
> +#ifdef CONFIG_OF
> +static const struct of_device_id ecap_of_match[] =3D {
> +	{
> +		.compatible	=3D "ti,am33xx-ecap",
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, ecap_of_match);
> +#endif
> +

I'm not sure if I remember correctly, but wasn't AM33xx support supposed
to be DT only? In that case you don't need the CONFIG_OF guards.

>  static int __devinit ecap_pwm_probe(struct platform_device *pdev)

__devinit can go away.

>  {
>  	int ret;
> @@ -211,6 +231,7 @@ static int __devinit ecap_pwm_probe(struct platform_d=
evice *pdev)
> =20
>  	pc->chip.dev =3D &pdev->dev;
>  	pc->chip.ops =3D &ecap_pwm_ops;
> +	pc->chip.of_pwm_n_cells =3D PWM_CELL_SIZE;
>  	pc->chip.base =3D -1;
>  	pc->chip.npwm =3D 1;
> =20
> @@ -231,14 +252,37 @@ static int __devinit ecap_pwm_probe(struct platform=
_device *pdev)
>  	}
> =20
>  	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_get_sync(&pdev->dev);

Maybe put a blank line after this for readability.

> +	if (!(pwmss_submodule_state_change(pdev->dev.parent, ECAPCLK_EN) &
> +				ECAPCLK_EN_ACK)) {

This is very hard to read, can you split this up into something like the
following please?

	status =3D pwmss_submodule_state_change(pdev->dev.parent, ECAPCLK_EN);
	if (!(status & ECAPCLK_EN_ACK)) {
		...
	}

> +		dev_err(&pdev->dev, "PWMSS config space clock enable failure\n");
> +		ret =3D -EINVAL;
> +		goto pwmss_clk_failure;
> +	}
> +	pm_runtime_put_sync(&pdev->dev);

Another blank line between the two above would be good.

> +
>  	platform_set_drvdata(pdev, pc);
>  	return 0;
> +
> +pwmss_clk_failure:
> +	pm_runtime_put_sync(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +	pwmchip_remove(&pc->chip);
> +	return ret;
>  }
> =20
>  static int __devexit ecap_pwm_remove(struct platform_device *pdev)

No __devexit please.

>  {
>  	struct ecap_pwm_chip *pc =3D platform_get_drvdata(pdev);
> =20
> +	pm_runtime_get_sync(&pdev->dev);
> +	/*
> +	 * Due to hardware misbehaviour, acknowledge of the stop_req
> +	 * is missing. Hence checking of the status bit skipped.
> +	 */
> +	pwmss_submodule_state_change(pdev->dev.parent, ECAPCLK_STOP_REQ);
> +	pm_runtime_put_sync(&pdev->dev);
> +
>  	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
>  	return pwmchip_remove(&pc->chip);
> @@ -246,7 +290,9 @@ static int __devexit ecap_pwm_remove(struct platform_=
device *pdev)
> =20
>  static struct platform_driver ecap_pwm_driver =3D {
>  	.driver =3D {
> -		.name =3D "ecap",
> +		.name	=3D "ecap",
> +		.owner	=3D THIS_MODULE,
> +		.of_match_table =3D of_match_ptr(ecap_of_match),

Here as well, if AM33xx is DT-only, then the of_match_ptr() can be
dropped.

>  	},
>  	.probe =3D ecap_pwm_probe,
>  	.remove =3D __devexit_p(ecap_pwm_remove),

No __devexit_p() please.

Thierry

--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnLYzAAoJEN0jrNd/PrOhfg0P/1eqOl7vyXecM/q2Kui1gCun
s3hGnJMKudAO4IZXx/aU7gzbZr1lgoP62g0jF5p2lPsbQygrR0fuVKwnv+O0Mqdt
TmjmnOBMAsxoQa4w8Ka6dMlkLKrgCta/POcWaXu0DMmc9WcEf1EkLtxNqEYag6QC
Pw80Koe5nlPs+eku8sdeAKXA2CM2UjkZY4ROmwjxO12NV5hjHWpBoFCZmHnVx2I1
t1Rd3YLRf2yYEF+0A33Wdhs7jQkyThXVqoksWfrJr7XrErSMDNITE1HAOmQFfMLN
BxRZEeZHYsa3lN3KbfiJBkLJL0auxbKg/rEWAEpIyV+Bx7gEacdwG0BLmKPpt/eN
Vdk10oGnW8DmEiWL0Lld4ggvvvkJw9ByCruwiTSV9PM7Lr2TFXqu1NiYkB/I+N4V
d/sNJjF0Ijy1LRsdVSYHEZsPdzmPP2WMclDiuRBgvkKPvoxeZ+eajUO5ew8HhJtW
duiTWsDKSAXT0OFdI75sX5ArRjEHX8Aqd4CNBB6grvtaY+P4bK9a3+gBLet1FxLR
5vsfR2i8u0jsN0uIarMvDXNgsqNPIZ7FkeRqZw+MYLhRQwVQ+9lla8XVVLeJTBVU
gyyhz0xUABa1kJQm07i2f6voZGYm3w8NgSKxs8PNcqq7EWtGl6EbLaEGFNL2j2rK
2x+F31jTK8js0Wc+nhjc
=YojD
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--

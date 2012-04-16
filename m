Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab2DPGQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:16:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52253 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2DPGQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:16:50 -0400
Date: Mon, 16 Apr 2012 08:16:45 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, axel.lin@gmail.com,
        broonie@opensource.wolfsonmicro.com, marek.vasut@gmail.com,
        devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH 2/4] input: Device tree support for LPC32xx touchscreen
Message-ID: <20120416061645.GC3037@avionic-0098.adnet.avionic-design.de>
References: <1334400790-10892-1-git-send-email-stigge@antcom.de>
 <1334400790-10892-3-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Content-Disposition: inline
In-Reply-To: <1334400790-10892-3-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3WIUWCrE9+VMitfR2GDVtF2oi5KNftqYQ3mL/SnGUKd
 pwAwAeMOXtviZcoRvQXO5UXzmcfzb39hs2Mt2o2FnuOmOu4nfb
 4Rmf7zuUy24ty4VEhNur7yTl3GRBO9dMIqJR2mIPk892Hn06tt
 jhFqJUl9NRbhWRGrOEJdot2qDn3D1sVxjr7X6h4xJRi5hyadSd
 UCpQXZBjKbdDurMB9EWhchXapSB/n9yb7iHs9Wm9qQJitj6xXv
 tjBFSTUbLHPh/MjU01EuMMaPa5yM5z79wcUGD/vV/8TzicV1rL
 gl2I1mhg+ojUWmtk8XbXO2dY/9J7/50tmtEllXmBtb8d+VwOBw
 uG3E4YLULGZK8NYVSuEJFqxg/XX/ahobOIrc+RPPWvEkvzS5xp
 X/FgZcDfIegyTez+MWx6+SeL/Zjlbmcvus=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Roland Stigge wrote:
> This patch adds device tree support for the LPC32xx SoC's touchscreen
> controller.
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>=20
> ---
>=20
>  Applies to v3.4-rc2
>=20
>  Documentation/devicetree/bindings/input/touchscreen/lpc32xx-tsc.txt |   =
16 ++++++++++
>  drivers/input/touchscreen/lpc32xx_ts.c                              |   =
10 ++++++
>  2 files changed, 26 insertions(+)
>=20
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/input/touchscreen/lpc32xx=
-tsc.txt
> @@ -0,0 +1,16 @@
> +* NXP LPC32xx SoC Touchscreen Controller (TSC)
> +
> +Required properties:
> +- compatible: must be "nxp,lpc32xx-tsc"
> +- reg: physical base address of the controller and length of memory mapp=
ed
> +  region.
> +- interrupts: The TSC/ADC interrupt
> +
> +Example:
> +
> +	tsc@40048000 {
> +		compatible =3D "nxp,lpc32xx-tsc";
> +		reg =3D <0x40048000 0x1000>;
> +		interrupt-parent =3D <&mic>;
> +		interrupts =3D <39 0>;
> +	};
> --- linux-2.6.orig/drivers/input/touchscreen/lpc32xx_ts.c
> +++ linux-2.6/drivers/input/touchscreen/lpc32xx_ts.c
> @@ -22,6 +22,7 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#include <linux/of.h>
> =20
>  /*
>   * Touchscreen controller register offsets
> @@ -383,6 +384,14 @@ static const struct dev_pm_ops lpc32xx_t
>  #define LPC32XX_TS_PM_OPS NULL
>  #endif
> =20
> +#ifdef CONFIG_OF
> +static struct of_device_id lpc32xx_tsc_of_match[] =3D {
> +	{ .compatible =3D "nxp,lpc32xx-tsc", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, lpc32xx_tsc_of_match);
> +#endif
> +
>  static struct platform_driver lpc32xx_ts_driver =3D {
>  	.probe		=3D lpc32xx_ts_probe,
>  	.remove		=3D __devexit_p(lpc32xx_ts_remove),
> @@ -390,6 +399,7 @@ static struct platform_driver lpc32xx_ts
>  		.name	=3D MOD_NAME,
>  		.owner	=3D THIS_MODULE,
>  		.pm	=3D LPC32XX_TS_PM_OPS,
> +		.of_match_table =3D of_match_ptr(lpc32xx_tsc_of_match),
>  	},
>  };
>  module_platform_driver(lpc32xx_ts_driver);

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk+LuU0ACgkQZ+BJyKLjJp+bxACgpabDqIJ7xq0FVSJNmK0TVh6q
hiYAnibjqB0K+qx+dP8L/4fYVcUQxRUv
=krJM
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--

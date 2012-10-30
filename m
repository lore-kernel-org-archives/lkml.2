Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661Ab2J3S7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:59:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39622 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934221Ab2J3S7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:59:35 -0400
Date: Tue, 30 Oct 2012 20:53:03 +0200
From: Felipe Balbi <balbi@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Tony Lindgren <tony@atomide.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>
Subject: Re: [PATCH] i2c: pinctrl-ify i2c-omap.c
Message-ID: <20121030185303.GD4804@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351698930-3797-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tNQTSEo8WG/FKZ8E"
Content-Disposition: inline
In-Reply-To: <1351698930-3797-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tNQTSEo8WG/FKZ8E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 31, 2012 at 05:55:30PM +0200, Pantelis Antoniou wrote:
> Enable pinctrl for i2c-omap.
>=20
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/i2c/busses/i2c-omap.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index db31eae..4c38aa0 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -44,6 +44,8 @@
>  #include <linux/i2c-omap.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pm_qos.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/err.h>
> =20
>  /* I2C controller revisions */
>  #define OMAP_I2C_OMAP1_REV_2		0x20
> @@ -1064,6 +1066,7 @@ omap_i2c_probe(struct platform_device *pdev)
>  	const struct of_device_id *match;
>  	int irq;
>  	int r;
> +	struct pinctrl *pinctrl;
> =20
>  	/* NOTE: driver uses the static register mapping */
>  	mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -1202,6 +1205,13 @@ omap_i2c_probe(struct platform_device *pdev)
> =20
>  	of_i2c_register_devices(adap);
> =20
> +	pinctrl =3D devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl))
> +		dev_warn(dev->dev, "unable to select pin group\n");

if we continue anyway, should this be dev_warn() ? Would you consider
dev_dbg() instead ?

> +	dev_info(dev->dev, "bus %d rev%d.%d.%d at %d kHz\n", adap->nr,
> +		 dev->dtrev, dev->rev >> 4, dev->rev & 0xf, dev->speed);

this dev_info() doesn't look like it's part of $subject. Care to, at
least, add a reasoning for adding this to commit log ?

--=20
balbi

--tNQTSEo8WG/FKZ8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkCIPAAoJEIaOsuA1yqREqDIQAIhOBrnoILrEBDhusah/8kdn
Zsbr/BhO9NqA939KbgBBhEv71qEQ20NmlduA8YhiZvS+IwKF/KtkFZeGTZzhAb0c
/p2Wp3OBWNIbdCC++OVKQGPydFbS2O6BdeI12wt0eTvm7QLnM9KAEUxw949SYvOQ
Vh1SOGwmDPWDZbm7fQtTE3rt8yOhbhEz3djWrXCTMnYtPYvT8Gi24iQ0EDhqycAF
Av52Fe6iCIPjTB3tGCUB0KE+0TwQH5Gde0oRXUnKPXSpz8HmHxgbToPat6uJd1zt
vOQB84YnL8+ED8Ezelj6ejx2QjPbEmLwuEBo85on3+gVw2XFTZo3nV+lpVuWX6v1
/+/gsR3Evnzg9kdU57FY964UQiuSD2tSaQHoRQ2iMwEJbHRhUiBzTj6xL3G4MIBT
MVcuvPCOTjth6ADV/No5HUMpxn7q9x8BqFPdAGaC7sZ7BTom9b7ALrteUTrCUT74
BAeYFTblkVnFDTgbCqwZIZZI2i6k+imrszI/QhMFqmBqNnAucEGuVKH72wdPZI2f
CDo9KXiIB/zgLHgh1L4YvMeIgxscVGsWKIf6ML/FCbFhfF492Ewq9CJtf6Ii2KOp
h9C10D7qMs0j9Y1xIxj3sND9HEHqLIw324yRkv8yo/gnhAlGi3UkxWVtGS+enmEv
u1W86IWGWydzhkTPisEM
=/oGd
-----END PGP SIGNATURE-----

--tNQTSEo8WG/FKZ8E--

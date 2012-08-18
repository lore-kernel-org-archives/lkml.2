Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2HRJtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:49:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51568 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2HRJtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:49:05 -0400
Date: Sat, 18 Aug 2012 11:48:46 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Daniel Kurtz <djkurtz@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-i801: Add device tree support
Message-ID: <20120818094846.GA24812@pengutronix.de>
References: <1344409609-1904-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <1344409609-1904-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 08, 2012 at 09:06:47AM +0200, Thierry Reding wrote:
> This commit adds support for probing slave devices parsed from the
> device tree.
>=20
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

How are the devicetree nodes of the slaves connected to this PCI device
which should not have a node itself?

> ---
>  drivers/i2c/busses/i2c-i801.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index 6f00785..b5311cf 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -80,6 +80,7 @@
>  #include <linux/slab.h>
>  #include <linux/wait.h>
>  #include <linux/err.h>
> +#include <linux/of_i2c.h>
> =20
>  #if defined CONFIG_I2C_MUX || defined CONFIG_I2C_MUX_MODULE
>  #include <linux/gpio.h>
> @@ -1238,6 +1239,7 @@ static int __devinit i801_probe(struct pci_dev *dev,
>  		goto exit_free_irq;
>  	}
> =20
> +	of_i2c_register_devices(&priv->adapter);
>  	i801_probe_optional_slaves(priv);
>  	/* We ignore errors - multiplexing is optional */
>  	i801_add_mux(priv);
> --=20
> 1.7.11.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAvZP4ACgkQD27XaX1/VRtWxgCdHbmNbhg+KgbEozHPinxRX+m1
HtYAn3m13SZziDWTjr+VuJZmQdcJBfCG
=PrmQ
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--

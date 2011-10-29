Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab1J2G6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 02:58:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55932 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab1J2G6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 02:58:22 -0400
Date: Sat, 29 Oct 2011 08:58:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpio: pca953x: remove unneeded check for chip type
Message-ID: <20111029065820.GA2111@pengutronix.de>
References: <1318599120-413-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <1318599120-413-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 14, 2011 at 03:31:59PM +0200, Wolfram Sang wrote:
> We can assume our own device_id table is correct, so remove checking if
> the chip type is valid. (The check was bogus anyway: If it found an
> invalid entry, it returned with 0!) This is in preparation for further
> cleanups.
>=20
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Ping for this mini-series.

> ---
>  drivers/gpio/gpio-pca953x.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index c43b8ff..45de6a4 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -673,10 +673,8 @@ static int __devinit pca953x_probe(struct i2c_client=
 *client,
> =20
>  	if (chip->chip_type =3D=3D PCA953X_TYPE)
>  		device_pca953x_init(chip, invert);
> -	else if (chip->chip_type =3D=3D PCA957X_TYPE)
> -		device_pca957x_init(chip, invert);
>  	else
> -		goto out_failed;
> +		device_pca957x_init(chip, invert);
> =20
>  	ret =3D pca953x_irq_setup(chip, id, irq_base);
>  	if (ret)
> --=20
> 1.7.6.3
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6rpAwACgkQD27XaX1/VRtIPACgocwjHyS8sKZP5KChJwXBRl5V
jrkAnA3JptioQwWJf7c4WTQLVd/F6w+r
=lTSq
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--

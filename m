Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433Ab2EaUyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:54:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42756 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab2EaUyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:54:53 -0400
Message-ID: <4FC7DA93.1080905@pengutronix.de>
Date: Thu, 31 May 2012 22:54:43 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] can: cc770: Fix likely misuse of | for &
References: <cover.1338408931.git.joe@perches.com> <6c251b03dc626215cf696e894ac1cdda530f38d9.1338408931.git.joe@perches.com>
In-Reply-To: <6c251b03dc626215cf696e894ac1cdda530f38d9.1338408931.git.joe@perches.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig63DDF846AE003BF88EFAFA75"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig63DDF846AE003BF88EFAFA75
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/30/2012 10:25 PM, Joe Perches wrote:
> Using | with a constant is always true.
> Likely this should have be &.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

Sounds reasonable. And there are no in tree users of the platform driver
that this fix could break.

commited to linux-can,
Marc

> ---
>  drivers/net/can/cc770/cc770_platform.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/can/cc770/cc770_platform.c b/drivers/net/can/c=
c770/cc770_platform.c
> index 53115ee..688371c 100644
> --- a/drivers/net/can/cc770/cc770_platform.c
> +++ b/drivers/net/can/cc770/cc770_platform.c
> @@ -154,7 +154,7 @@ static int __devinit cc770_get_platform_data(struct=
 platform_device *pdev,
>  	struct cc770_platform_data *pdata =3D pdev->dev.platform_data;
> =20
>  	priv->can.clock.freq =3D pdata->osc_freq;
> -	if (priv->cpu_interface | CPUIF_DSC)
> +	if (priv->cpu_interface & CPUIF_DSC)
>  		priv->can.clock.freq /=3D 2;
>  	priv->clkout =3D pdata->cor;
>  	priv->bus_config =3D pdata->bcr;


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig63DDF846AE003BF88EFAFA75
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/H2pgACgkQjTAFq1RaXHNAqwCeIgt27xgLy0AE5WyKEfeNK/EY
HSEAnRX1XvklF/b1VuIeKLJ0dithQs8H
=G9+R
-----END PGP SIGNATURE-----

--------------enig63DDF846AE003BF88EFAFA75--

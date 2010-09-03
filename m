Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0ICVf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:35:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36770 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab0ICVf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:35:28 -0400
Date: Fri, 3 Sep 2010 23:35:24 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Luotao Fu <l.fu@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: stmpe-ts - return -ENOMEM if memory
	allocation fail
Message-ID: <20100903213524.GA32515@pengutronix.de>
References: <1283477451.5439.6.camel@mola> <1283477533.5439.8.camel@mola>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1283477533.5439.8.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 03, 2010 at 09:32:13AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Basically correct. Should be simpler to just use

	int ret =3D -ENOMEM;

though.

> ---
>  drivers/input/touchscreen/stmpe-ts.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchsc=
reen/stmpe-ts.c
> index 0339d1d..e715b27 100644
> --- a/drivers/input/touchscreen/stmpe-ts.c
> +++ b/drivers/input/touchscreen/stmpe-ts.c
> @@ -276,12 +276,16 @@ static int __devinit stmpe_input_probe(struct platf=
orm_device *pdev)
>  		return ts_irq;
> =20
>  	ts =3D kzalloc(sizeof(*ts), GFP_KERNEL);
> -	if (!ts)
> +	if (!ts) {
> +		ret =3D -ENOMEM;
>  		goto err_out;
> +	}
> =20
>  	idev =3D input_allocate_device();
> -	if (!idev)
> +	if (!idev) {
> +		ret =3D -ENOMEM;
>  		goto err_free_ts;
> +	}
> =20
>  	platform_set_drvdata(pdev, ts);
>  	ts->stmpe =3D stmpe;
> --=20
> 1.7.2
>=20
>=20
>=20
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkyBahwACgkQD27XaX1/VRuSPgCffsSyfWHCiazjZmXWw7fS7Hbk
IQ8An0QM0culSodkZ9KEmoeRqCsHgQux
=OaGn
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--

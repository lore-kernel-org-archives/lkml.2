Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920Ab0IEFVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 01:21:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40515 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0IEFVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 01:21:07 -0400
Date: Sun, 5 Sep 2010 07:21:01 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luotao Fu <l.fu@pengutronix.de>, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Input: stmpe-ts - return -ENOMEM if memory
	allocation fail
Message-ID: <20100905052101.GA5797@pengutronix.de>
References: <1283656244.8339.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <1283656244.8339.3.camel@phoenix>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 05, 2010 at 11:10:44AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

> ---
> Change since v1:
> remove unneeded initialization of 'ret' variable
>=20
>  drivers/input/touchscreen/stmpe-ts.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchsc=
reen/stmpe-ts.c
> index 656148e..06869e4 100644
> --- a/drivers/input/touchscreen/stmpe-ts.c
> +++ b/drivers/input/touchscreen/stmpe-ts.c
> @@ -268,7 +268,7 @@ static int __devinit stmpe_input_probe(struct platfor=
m_device *pdev)
>  	struct stmpe_touch *ts;
>  	struct input_dev *idev;
>  	struct stmpe_ts_platform_data *ts_pdata =3D NULL;
> -	int ret =3D 0;
> +	int ret;
>  	int ts_irq;
> =20
>  	ts_irq =3D platform_get_irq_byname(pdev, "FIFO_TH");
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
> 1.7.0.4
>=20
>=20
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkyDKL0ACgkQD27XaX1/VRuGIQCgyXJGBJkZajcnbSPQJGEXXXCk
I8cAoJqyTUILR7Rj9eToKyF3AmgP9tzD
=8fpY
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--

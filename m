Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2KLR06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:26:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38954 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2KLR05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:26:57 -0500
Date: Mon, 12 Nov 2012 18:26:51 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/7] I2c-nomadik: Fix the usage of
 wait_for_completion_timeout
Message-ID: <20121112172651.GC15159@pengutronix.de>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oTHb8nViIGeoXxdp"
Content-Disposition: inline
In-Reply-To: <1352222317.15558.1584.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 07, 2012 at 01:18:37AM +0800, Chuansheng Liu wrote:
>=20
> The return value of wait_for_completion_timeout() is always
> >=3D 0 with unsigned int type.
>=20
> So the condition "ret < 0" or "ret >=3D 0" is pointless.
>=20
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>

You forgot to add the i2c-list, so I nearly overlooked this patch.
Luckily I haven't, so applied to for-next, thanks! Did you use a script
to find all occurences? Would be nice to know. Also, please take care of
the subject line. "I2c" is misspelled.

@Linus: I am not pushing out today, so if you want to add acks or so...

Thanks,

   Wolfram

> ---
>  drivers/i2c/busses/i2c-nomadik.c |   14 --------------
>  1 files changed, 0 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-no=
madik.c
> index 02c3115..8b2ffcf 100644
> --- a/drivers/i2c/busses/i2c-nomadik.c
> +++ b/drivers/i2c/busses/i2c-nomadik.c
> @@ -435,13 +435,6 @@ static int read_i2c(struct nmk_i2c_dev *dev, u16 fla=
gs)
>  	timeout =3D wait_for_completion_timeout(
>  		&dev->xfer_complete, dev->adap.timeout);
> =20
> -	if (timeout < 0) {
> -		dev_err(&dev->adev->dev,
> -			"wait_for_completion_timeout "
> -			"returned %d waiting for event\n", timeout);
> -		status =3D timeout;
> -	}
> -
>  	if (timeout =3D=3D 0) {
>  		/* Controller timed out */
>  		dev_err(&dev->adev->dev, "read from slave 0x%x timed out\n",
> @@ -523,13 +516,6 @@ static int write_i2c(struct nmk_i2c_dev *dev, u16 fl=
ags)
>  	timeout =3D wait_for_completion_timeout(
>  		&dev->xfer_complete, dev->adap.timeout);
> =20
> -	if (timeout < 0) {
> -		dev_err(&dev->adev->dev,
> -			"wait_for_completion_timeout "
> -			"returned %d waiting for event\n", timeout);
> -		status =3D timeout;
> -	}
> -
>  	if (timeout =3D=3D 0) {
>  		/* Controller timed out */
>  		dev_err(&dev->adev->dev, "write to slave 0x%x timed out\n",
> --=20
> 1.7.0.4
>=20
>=20
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlChMVsACgkQD27XaX1/VRtDIwCdFfdtHU61a7GFWDUdUx7lt796
0O0An1GUvpUavoBtbfseJuDaHtHcGVNk
=xgyQ
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--

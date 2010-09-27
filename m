Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab0I0LDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 07:03:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41944 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab0I0LC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 07:02:59 -0400
Date: Mon, 27 Sep 2010 13:02:48 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Bernhard Walle <walle@corscience.de>
Cc: khali@linux-fr.org, ddaney@caviumnetworks.com, rade.bozic.ext@nsn.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] MIPS: I2C: Return -ETIMEDOUT in octeon_i2c_wait() on
 timeout
Message-ID: <20100927110248.GF2664@pengutronix.de>
References: <1285584916-21317-1-git-send-email-walle@corscience.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pql/uPZNXIm1JCle"
Content-Disposition: inline
In-Reply-To: <1285584916-21317-1-git-send-email-walle@corscience.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pql/uPZNXIm1JCle
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 27, 2010 at 12:55:16PM +0200, Bernhard Walle wrote:
> It doesn't make sense to set result to -ETIMEDOUT but return 0 (success)
> afterwards. Since there's code in octeon_i2c_start() to handle the
> error, it should be called.
>=20
> Signed-off-by: Bernhard Walle <walle@corscience.de>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

but next time you should cc Ben Dooks to pick it up (i2c for embedded).

> ---
>  drivers/i2c/busses/i2c-octeon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-oct=
eon.c
> index 0e9f85d..56dbe54 100644
> --- a/drivers/i2c/busses/i2c-octeon.c
> +++ b/drivers/i2c/busses/i2c-octeon.c
> @@ -218,7 +218,7 @@ static int octeon_i2c_wait(struct octeon_i2c *i2c)
>  		return result;
>  	} else if (result =3D=3D 0) {
>  		dev_dbg(i2c->dev, "%s: timeout\n", __func__);
> -		result =3D -ETIMEDOUT;
> +		return -ETIMEDOUT;
>  	}
> =20
>  	return 0;
> --=20
> 1.7.0.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Pql/uPZNXIm1JCle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkygedgACgkQD27XaX1/VRvwhQCfdKq1+ZaqD0cjLiSUVp/Ub3ze
nokAnRjOVSrndD/pL60bK0Lh430LDEHt
=oBIc
-----END PGP SIGNATURE-----

--Pql/uPZNXIm1JCle--

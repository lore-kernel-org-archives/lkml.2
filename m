Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2FKS32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:29:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37171 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2FKS31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:29:27 -0400
Date: Mon, 11 Jun 2012 20:29:25 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: m.szyprowski@samsung.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] i2c-s3c2410: Fix pointer type passed to of_match_node()
Message-ID: <20120611182925.GJ3887@pengutronix.de>
References: <1338370985-6950-1-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ed/6oDxOLijJh8b0"
Content-Disposition: inline
In-Reply-To: <1338370985-6950-1-git-send-email-k.lewandowsk@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ed/6oDxOLijJh8b0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 30, 2012 at 11:43:05AM +0200, Karol Lewandowski wrote:
> This commit fixes warning introduced in 27452498a ("i2c-s3c2410: Rework
> device type handling"):
>=20
>   drivers/i2c/busses/i2c-s3c2410.c: In function 's3c24xx_get_device_quirk=
s':
>   drivers/i2c/busses/i2c-s3c2410.c:125: warning: passing argument 1 of 'o=
f_match_node' from incompatible pointer type
>   include/linux/of.h:245: note: expected 'const struct of_device_id *' bu=
t argument is of type 'const struct of_device_id (*)[4]'
>=20
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Ah, now I understand why my build-test didn't spot the warning.
What config can I use to test CONFIG_OF with s3c?

> ---
>  drivers/i2c/busses/i2c-s3c2410.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3=
c2410.c
> index fa0b134..286e596 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -122,7 +122,7 @@ static inline unsigned int s3c24xx_get_device_quirks(=
struct platform_device *pde
>  {
>  	if (pdev->dev.of_node) {
>  		const struct of_device_id *match;
> -		match =3D of_match_node(&s3c24xx_i2c_match, pdev->dev.of_node);
> +		match =3D of_match_node(s3c24xx_i2c_match, pdev->dev.of_node);
>  		return (unsigned int)match->data;
>  	}
> =20
> --=20
> 1.7.10
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ed/6oDxOLijJh8b0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/WOQUACgkQD27XaX1/VRtvNACgmVRyz9ma0H9gCE28UEwaRxMx
it8An015MCnUc+aeSPA+u8ucROqRrJ0O
=eIgS
-----END PGP SIGNATURE-----

--ed/6oDxOLijJh8b0--

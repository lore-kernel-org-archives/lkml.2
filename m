Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0K2KNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:13:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35911 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab0K2KNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:13:40 -0500
Message-ID: <4CF37CC6.2070609@pengutronix.de>
Date: Mon, 29 Nov 2010 11:13:26 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-iop3xx: add iomem annotation
References: <1290960420-7484-1-git-send-email-aaro.koskinen@iki.fi>
In-Reply-To: <1290960420-7484-1-git-send-email-aaro.koskinen@iki.fi>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAF09687D09A09E90E35223AA"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAF09687D09A09E90E35223AA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/28/2010 05:07 PM, Aaro Koskinen wrote:
> Eliminate unnecessary casts and the following sparse warnings:
>=20
> 	drivers/i2c/busses/i2c-iop3xx.c:65:9: warning: incorrect type in argum=
ent 1 (different base types)
> 	drivers/i2c/busses/i2c-iop3xx.c:65:9:    expected void const volatile =
[noderef] <asn:2>*<noident>
> 	drivers/i2c/busses/i2c-iop3xx.c:65:9:    got unsigned int
>=20
> 	[ the previous warning is repeated 18 times ]
>=20
> 	drivers/i2c/busses/i2c-iop3xx.c:456:33: warning: cast removes address =
space of expression
>=20
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>

looks good, but use void  __iomem * in struct i2c_algo_iop3xx_data.

cheers, Marc
> ---
>  drivers/i2c/busses/i2c-iop3xx.c |    6 +++---
>  drivers/i2c/busses/i2c-iop3xx.h |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-i=
op3xx.c
> index 112c61f..f09c931 100644
> --- a/drivers/i2c/busses/i2c-iop3xx.c
> +++ b/drivers/i2c/busses/i2c-iop3xx.c
> @@ -409,7 +409,7 @@ iop3xx_i2c_remove(struct platform_device *pdev)
>  		IOP3XX_ICR_RXFULL_IE | IOP3XX_ICR_TXEMPTY_IE);
>  	__raw_writel(cr, adapter_data->ioaddr + CR_OFFSET);
> =20
> -	iounmap((void __iomem*)adapter_data->ioaddr);
> +	iounmap(adapter_data->ioaddr);
>  	release_mem_region(res->start, IOP3XX_I2C_IO_SIZE);
>  	kfree(adapter_data);
>  	kfree(padapter);
> @@ -453,7 +453,7 @@ iop3xx_i2c_probe(struct platform_device *pdev)
>  	/* set the adapter enumeration # */
>  	adapter_data->id =3D i2c_id++;
> =20
> -	adapter_data->ioaddr =3D (u32)ioremap(res->start, IOP3XX_I2C_IO_SIZE)=
;
> +	adapter_data->ioaddr =3D ioremap(res->start, IOP3XX_I2C_IO_SIZE);
>  	if (!adapter_data->ioaddr) {
>  		ret =3D -ENOMEM;
>  		goto release_region;
> @@ -498,7 +498,7 @@ iop3xx_i2c_probe(struct platform_device *pdev)
>  	return 0;
> =20
>  unmap:
> -	iounmap((void __iomem*)adapter_data->ioaddr);
> +	iounmap(adapter_data->ioaddr);
> =20
>  release_region:
>  	release_mem_region(res->start, IOP3XX_I2C_IO_SIZE);
> diff --git a/drivers/i2c/busses/i2c-iop3xx.h b/drivers/i2c/busses/i2c-i=
op3xx.h
> index 8485861..a63b9f1 100644
> --- a/drivers/i2c/busses/i2c-iop3xx.h
> +++ b/drivers/i2c/busses/i2c-iop3xx.h
> @@ -97,7 +97,7 @@
>  #define	IOP3XX_I2C_IO_SIZE	0x18
> =20
>  struct i2c_algo_iop3xx_data {
> -	u32 ioaddr;
> +	char __iomem *ioaddr;

Use void __iomem *, please.

>  	wait_queue_head_t waitq;
>  	spinlock_t lock;
>  	u32 SR_enabled, SR_received;

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigAF09687D09A09E90E35223AA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzzfMkACgkQjTAFq1RaXHPJ1QCeM3G2/ZlH4g3H02HSSesoVGij
xlwAnicSG2NyAGldM8pqqznd0lHqHU4h
=Rj61
-----END PGP SIGNATURE-----

--------------enigAF09687D09A09E90E35223AA--

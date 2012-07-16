Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab2GPHeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:34:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47391 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2GPHeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:34:24 -0400
Message-ID: <5003C3F1.4050900@pengutronix.de>
Date: Mon, 16 Jul 2012 09:34:09 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Wolfgang Grandegger <wg@grandegger.com>, kernel-janitors@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] drivers/net/can/softing/softing_main.c: ensure a
 consistent return value in error case
References: <1342284188-19176-1-git-send-email-Julia.Lawall@lip6.fr> <1342284188-19176-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1342284188-19176-3-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAF96439C739D419C3A81270C"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAF96439C739D419C3A81270C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/14/2012 06:43 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Typically, the return value desired for the failure of a function with =
an
> integer return value is a negative integer.  In these cases, the return=

> value is sometimes a negative integer and sometimes 0, due to a subsequ=
ent
> initialization of the return variable within the loop.
>=20
> A simplified version of the semantic match that finds this problem is:
> (http://coccinelle.lip6.fr/)
>=20
> //<smpl>
> @r exists@
> identifier ret;
> position p;
> constant C;
> expression e1,e3,e4;
> statement S;
> @@
>=20
> ret =3D -C
> ... when !=3D ret =3D e3
>     when any
> if@p (...) S
> ... when any
> if (\(ret !=3D 0\|ret < 0\|ret > 0\) || ...) { ... return ...; }
> ... when !=3D ret =3D e3
>     when any
> *if@p (...)
> {
>   ... when !=3D ret =3D e4
>   return ret;
> }
> //</smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks, applied to can-next

Marc
>=20
> ---
>  drivers/net/can/softing/softing_main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/s=
ofting/softing_main.c
> index a7c77c7..f2a221e 100644
> --- a/drivers/net/can/softing/softing_main.c
> +++ b/drivers/net/can/softing/softing_main.c
> @@ -826,12 +826,12 @@ static __devinit int softing_pdev_probe(struct pl=
atform_device *pdev)
>  		goto sysfs_failed;
>  	}
> =20
> -	ret =3D -ENOMEM;
>  	for (j =3D 0; j < ARRAY_SIZE(card->net); ++j) {
>  		card->net[j] =3D netdev =3D
>  			softing_netdev_create(card, card->id.chip[j]);
>  		if (!netdev) {
>  			dev_alert(&pdev->dev, "failed to make can[%i]", j);
> +			ret =3D -ENOMEM;
>  			goto netdev_failed;
>  		}
>  		priv =3D netdev_priv(card->net[j]);
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-can" in=

> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigAF96439C739D419C3A81270C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlADw/gACgkQjTAFq1RaXHOKygCgjV0oes2BDhZgZqhuzuxfd1+h
IoQAnRJSCuaiAIuG6wVp9ZfOzXtutsIT
=maqG
-----END PGP SIGNATURE-----

--------------enigAF96439C739D419C3A81270C--

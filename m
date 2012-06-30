Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab2F3Tpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 15:45:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2F3Tph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 15:45:37 -0400
Date: Sat, 30 Jun 2012 21:45:28 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexey Charkov <alchark@gmail.com>
Subject: Re: [PATCH 4/4] pwm: Convert pwm-vt8500 to use devm_* APIs
Message-ID: <20120630194528.GA24411@avionic-0098.mockup.avionic-design.de>
References: <1340976628.4752.0.camel@phoenix>
 <1340976785.4752.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <1340976785.4752.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:5kgaZwpCJJF7gomp5IbFLdEWVel46zl/Ktwy8hWryPd
 Xd0NC/saREb7XOEuaKkW/ThcpPKhpwvUGlMF1WunfvOZ+g2BsK
 Eg/ythuqfzL1+SVSTtjrCLNRcbAN4agk9804rG+YUJunBVZEoV
 9QdwWSBI8KzbiCbBb90UCMES4iEbYE8dSuEf/VifuZ3BVVCs70
 puf9W5K9TB+x5yrl71SIv7cImfnEP8FX/Eqm4m0lahRACvWs3z
 1p7W/XzExW4StIEuF++d7WTi/BLbFmvYcYyF0R9862zGxq+Z5O
 qcqV/ZsumUux+jUZInCfqr/PaIj8VwocRnCVa/fqZQ6zkJ7X2m
 Ca/hlSesY9GJxZ95wXvTuap61HvFZlAkHg8XplmQYngyQz/qt4
 Upip28G/NqipPqEshAha+77NI0/A7B7bIr0tY9LnpwPuqL8gA3
 rSLQi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 29, 2012 at 09:33:05PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pwm/pwm-vt8500.c |   45 ++++++++--------------------------------=
-----
>  1 file changed, 8 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
[...]
> @@ -127,44 +127,24 @@ static int __devinit pwm_probe(struct platform_devi=
ce *pdev)
>  	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (r =3D=3D NULL) {
>  		dev_err(&pdev->dev, "no memory resource defined\n");
> -		ret =3D -ENODEV;
> -		goto err_free;
> -	}
> -
> -	r =3D request_mem_region(r->start, resource_size(r), pdev->name);
> -	if (r =3D=3D NULL) {
> -		dev_err(&pdev->dev, "failed to request memory resource\n");
> -		ret =3D -EBUSY;
> -		goto err_free;
> +		return -ENODEV;
>  	}
> =20
> -	chip->base =3D ioremap(r->start, resource_size(r));
> -	if (chip->base =3D=3D NULL) {
> -		dev_err(&pdev->dev, "failed to ioremap() registers\n");
> -		ret =3D -ENODEV;
> -		goto err_free_mem;
> -	}
> +	chip->base =3D devm_request_and_ioremap(&pdev->dev, r);
> +	if (chip->base =3D=3D NULL)
> +		return -ENODEV;

EADDRNOTAVAIL as well.

> @@ -172,16 +152,7 @@ static int __devexit pwm_remove(struct platform_devi=
ce *pdev)
>  		return -ENODEV;
> =20
>  	err =3D pwmchip_remove(&chip->chip);
> -	if (err < 0)
> -		return err;
> -
> -	iounmap(chip->base);
> -
> -	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(r->start, resource_size(r));
> -
> -	kfree(chip);
> -	return 0;
> +	return err;

And merge these two remaining lines.

Thierry

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP71dYAAoJEN0jrNd/PrOhFXgP/3pKLKck28HHZTcofLcs7LFJ
iu5c7Z6n1sBpe5H+v8MoGqvYh6m1MniLf1SxirpbusatJVjU4/ji2eypRwfW6+We
JvW3q9DS2Izl/0NcCfzVUGQd5PpZ6EpqWfaUCd6uc3OA89ZRzQWO8C88omxKoouN
CM/0HzW76hv+xW1kLHJEwushOufrNCAgeR+i3a/m7Z4xWdDIQofPywx9V35hMNBm
OVEnEV/02DsmM4YzcAkD+7+MFVREr0Vi0lXq+wxS+vXIZtO7MSs39FLKSBH0B1oa
4g+AOk+LdWPJUVWn9RqnOJt/vEdbyikDNoAj9kPRdaAJYjmM0I9+++Ar6lmm+ADV
4+h/zoF6XCY9d9DwsJwdwAI2Wu40VzVXkS3UyAeghGC0yztGG7jGWaJVYLZ42zLI
lQ9eXbQLPZkyxosGKGNMEm23JX9ashhu7fBaUPQ0Vqv7VPvCgveWCTma4qFCPeDQ
Y8e/73gLk/34BZWOhmUDrU4yHVLWgtrKKsMEox+lCCdTdeByUv7suUGLY0C7kvuG
7SI3fs8xweNgn4laNaR/3cZgQvYfR6CWNNdJKRHLXtgSCU0Sj9AqHgEEMs9rFh+e
+n/rdMZHtZ2T1MW6IdtAn6NhhJpr6UfJ0HVW3FWEjuTKSPdRjSZt5TXqy9iu5OzO
Libu0ndoZHDXQYyWvkPS
=A5Iq
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--

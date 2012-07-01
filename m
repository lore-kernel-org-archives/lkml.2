Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2GAHgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 03:36:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59342 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2GAHgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 03:36:50 -0400
Date: Sun, 1 Jul 2012 09:36:41 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH v2 2/3] pwm: Convert pwm-pxa to use devm_* APIs
Message-ID: <20120701073641.GA17790@avionic-0098.adnet.avionic-design.de>
References: <1341102443.3712.0.camel@phoenix>
 <1341102507.3712.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <1341102507.3712.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:pJC0zh+BJKHgBYmwI7twyBKIEF6fqOyCXUYVGpTa/ME
 +/Drb+hxzjghJEleHm7Krb72w2poYIBtUp7TTUjLH/Wxu6fgxV
 1Z9hE4yhkn9MWIh0XWsV9pYp16xMple6h+2zomRWhUlhOQFiC3
 azB2tEViZ/undWjiO3a+Hn6i9l4SbkVWCiXWzu8eyQfyqrSAlx
 llMhQ1uxHrvmSwzkueGwhk70kcXCoW9vvblEMjJG4gH+O9dhMh
 8JA/8cIPKzM2yXuR1KsuwzOd+4iP7ls0sAlg4ND2z7lU9T8kH8
 Rd75oX0uuqxnKhPtv46bG5PN+NQtIBMDFgmifnsfZnFwEvPmGZ
 L4JFUYrrIlzZXmimVE2DTRYqWX2JHEMYISL904JjZ2+rXFn1ym
 wAfrbfhmAZoqNzDYF7+koJj2QgBUGiJaI8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 01, 2012 at 08:28:27AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pwm/pwm-pxa.c |   52 +++++++++++--------------------------------=
------
>  1 file changed, 11 insertions(+), 41 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
[...]
> @@ -192,35 +180,17 @@ static int __devinit pwm_probe(struct platform_devi=
ce *pdev)
> =20
>  	platform_set_drvdata(pdev, pwm);
>  	return 0;
> -
> -err_free_mem:
> -	release_mem_region(r->start, resource_size(r));
> -err_free_clk:
> -	clk_put(pwm->clk);
> -err_free:
> -	kfree(pwm);
> -	return ret;
>  }
> =20
>  static int __devexit pwm_remove(struct platform_device *pdev)
>  {
>  	struct pxa_pwm_chip *chip;
> -	struct resource *r;
> =20
>  	chip =3D platform_get_drvdata(pdev);
>  	if (chip =3D=3D NULL)
>  		return -ENODEV;
> =20
> -	pwmchip_remove(&chip->chip);
> -
> -	iounmap(chip->mmio_base);
> -
> -	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(r->start, resource_size(r));
> -
> -	clk_put(chip->clk);
> -	kfree(chip);
> -	return 0;
> +	return pwmchip_remove(&chip->chip);

What I meant was that this driver didn't return an error on failure of
pwmchip_remove() before so incorporating this change is unrelated to
this patch. Either make it a separate patch (preferably) or at least
mention it in the commit message.

Thierry

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP7/4JAAoJEN0jrNd/PrOh8WIP/ifs2oCRdjn0VFo3N2Mr3HCF
//HOdVMQKmdaHRRXgNQh1EomAA0q08nTlZbRTbqcGDrDsc0ohMG66OQrqp0WYSey
R2XBmnyM6OIfvqQDphdEF3MjzO7rLipnM0zIKf797nZ3HT/DOMY0jzubVDgCCUut
Z36uwFPXC4xu5m247tqYdj+5haU4YXXosmLGAZxd59xf6EnCj0oODU1w1KV/6nNh
jc6H1YpmObnaGsYrQkw1gq0NZWg0NLd54uXMsgelMJAYh3MfsV/aUS+pfQk/+Hif
3+wq+VAMAt+iq9R0RyjduKKXIGfE+mXHz5esR42JABOyvjx47HDjElDKZYoGh4Di
4/fc9YWkdh2wkw11CWvbYexmfn5VXr2VEpECeWtPdbBMKaO7JQ+05a7280ymgBeD
Zw2LjnYbzketFpyoHBPnoIhPEdGAg+w2GIKm2j14QoCF0ceXXmG8+1fgHH3C/n0P
XgotPLjxACu1EhkDTxht3iFwMkyiSxdzCvYmlGVv3gXxrxJ632hG/GB8i12/8SlI
mJiH1orsmKHfAO4viR1HcmGmUT211BWRHSEwMPDJpOzlRheTjSvFL8QdxZ47ZM7A
MWVnkRVNjgrQZd0JqqecNkN70Vf0ck5WcXxVjga8JmSlLjIvsQaq2zB/tNM0Gh49
Ybp6IEVUca2Tx32/FUG7
=6+wg
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--

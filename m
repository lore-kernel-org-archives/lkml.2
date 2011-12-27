Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1L0IWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 03:22:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42957 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1L0IWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 03:22:10 -0500
Message-ID: <1324974236.1165.43.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/2] drivers/mtd/maps/lantiq-flash.c: drop iounmap for
 devm_ allocated data
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <julia@diku.dk>
Cc: David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 27 Dec 2011 10:23:56 +0200
In-Reply-To: <1324921081-13161-2-git-send-email-julia@diku.dk>
References: <1324921081-13161-2-git-send-email-julia@diku.dk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-2TZQfsQjRjvrGma/qK/z"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2TZQfsQjRjvrGma/qK/z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-12-26 at 18:38 +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>=20
> Data allocated with devm_ioremap or devm_ioremap_nocache should not be
> freed using iounmap, because doing so causes a dangling pointer, and a
> subsequent double free.
>=20
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @r@
> expression x;
> @@
> (
>  x =3D devm_ioremap(...)
> |
>  x =3D devm_ioremap_nocache(...)
> )
>=20
> @@
> expression r.x;
> @@
> * iounmap(x)
> // </smpl>

Thanks Julia,

surely this semantic patch script is worth adding to scripts/coccinelle?
Are you going to take care of this?

>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>
>=20
> ---
>  drivers/mtd/maps/lantiq-flash.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>=20
> diff --git a/drivers/mtd/maps/lantiq-flash.c b/drivers/mtd/maps/lantiq-fl=
ash.c
> index 4f10e27..7b889de 100644
> --- a/drivers/mtd/maps/lantiq-flash.c
> +++ b/drivers/mtd/maps/lantiq-flash.c
> @@ -159,7 +159,7 @@ ltq_mtd_probe(struct platform_device *pdev)
>  	if (!ltq_mtd->mtd) {
>  		dev_err(&pdev->dev, "probing failed\n");
>  		err =3D -ENXIO;
> -		goto err_unmap;
> +		goto err_free;
>  	}

Pushed to l2-mtd-2.6.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-2TZQfsQjRjvrGma/qK/z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO+YCdAAoJECmIfjd9wqK0G7YP+gI+o6z25nl4ROlhH4+KkQXx
6LamIGEq+TWAjsTIZb/kAjaNtI7ZxQ5EnmTrdn4RjWw4YvrUXPadG4DYZ521lMLY
6dgStsekEKV3Q5Bs4cXFfWPDouAoJdkhjSsFr5sH0VxtEXr/YppWQdPpujpxJlG0
K8ywEQfbQLhWYWHf8OYi9O4+YKo+Ur9tSqMPc+0AXTtu0aAnHwNJFZ6AUF338+uc
TUZ98RDp1HyCVNBIhOinGXeFjHqOZRaNSRRt8v65P+LeNKn+nKf7AZaHXsTTwBC4
OkwSvZtM9qYKwYribDZpbBVTgNA2PRrxSL7Q3Iiahjib7ck29GPuQTkEdWwBkZc+
Djy9dCD1ZDG25VlF77BwKkSBx1jiRvEeL5wsT4M+Z7HFItgf1m5Vmdxxf4BzClPa
V94MLUIUYZizuU1FtPM0rhMLUgLJX5+Uvvbh3SclD5trw+5WpBDOtamsjN8iJhIW
fswXdRvpPsAZt67sZXOT8bt3CH7G0ZmfW1yxF7e/hthcno0jGcSSaaX2BKcwvShs
1N4faVREhQTy1+dptRVpm1npGomBS55UUqQnx0fzzLcDKVNvohuDeA5v0TdrnDC1
yeWjvZKAjcs8l0m+yuxUAPQ9urNKfFtR1DDzy7OrXahwYz8bpvp6rtxx9uwlHatt
700zv6DShlZ5cokBcJQ3
=13wt
-----END PGP SIGNATURE-----

--=-2TZQfsQjRjvrGma/qK/z--


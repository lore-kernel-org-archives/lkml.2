Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1KVJVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:21:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55122 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab1KVJVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:21:25 -0500
Message-ID: <4ECB6992.5020804@pengutronix.de>
Date: Tue, 22 Nov 2011 10:21:22 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regmap: Fix build failure with CONFIG_DEBUG_FS=n
References: <1321950260-22193-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1321950260-22193-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAA4D66FA59F4F3AA5C74EF2A"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAA4D66FA59F4F3AA5C74EF2A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/22/2011 09:24 AM, Uwe Kleine-K=C3=B6nig wrote:
> This fixes:
>=20
> 	drivers/base/regmap/regcache-rbtree.c: In function 'regcache_rbtree_in=
it':
> 	drivers/base/regmap/regcache-rbtree.c:197: error: 'struct regmap' has =
no member named 'debugfs'
> 	drivers/base/regmap/regcache-rbtree.c:197: error: 'rbtree_fops' undecl=
ared (first use in this function)
> 	drivers/base/regmap/regcache-rbtree.c:197: error: (Each undeclared ide=
ntifier is reported only once
> 	drivers/base/regmap/regcache-rbtree.c:197: error: for each function it=
 appears in.)
>=20
> which was introduced by commit
>=20
> 	bad2ab4 (regmap: Provide debugfs dump of the rbtree cache data)
>=20
> currently in next-20111122.
>=20
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/base/regmap/regcache-rbtree.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regma=
p/regcache-rbtree.c
> index 7767cbb..270ad65 100644
> --- a/drivers/base/regmap/regcache-rbtree.c
> +++ b/drivers/base/regmap/regcache-rbtree.c
> @@ -194,7 +194,9 @@ static int regcache_rbtree_init(struct regmap *map)=

>  			goto err;
>  	}
> =20
> +#ifdef CONFIG_DEBUG_FS
>  	debugfs_create_file("rbtree", 0400, map->debugfs, map, &rbtree_fops);=

> +#endif

What about introducing a debugfs_create_file() noop if debug-fs is not
compiled in?

Marc

> =20
>  	return 0;
> =20


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigAA4D66FA59F4F3AA5C74EF2A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7LaZIACgkQjTAFq1RaXHOxZACfb3Sh6UbvLUlh4oQzmQbgOh7S
b9oAn03bvD9YuQ0eWlxAz4VCUR+c86z7
=2vzn
-----END PGP SIGNATURE-----

--------------enigAA4D66FA59F4F3AA5C74EF2A--

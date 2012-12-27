Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2L0RDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 12:03:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44713 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab2L0RDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 12:03:32 -0500
Message-ID: <1356627803.17740.11.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] [stable-resend] regulator: core: if voltage scaling
 fails, restore original voltage values
From: Ben Hutchings <ben@decadent.org.uk>
To: Paolo Pisati <paolo.pisati@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 27 Dec 2012 18:03:23 +0100
In-Reply-To: <1355786618-12691-1-git-send-email-paolo.pisati@canonical.com>
References: <20121217154512.GI4985@opensource.wolfsonmicro.com>
	 <1355786618-12691-1-git-send-email-paolo.pisati@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-OcfZUkz0IlhetDlK3WXS"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.219.247
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OcfZUkz0IlhetDlK3WXS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-12-18 at 00:23 +0100, Paolo Pisati wrote:
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
> Tested-by: Robert Nelson <robertcnelson@gmail.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Since this is not in Linus's tree, it is too early to request it be
applied to stable trees.  If it has gone into Mark's tree without the
'cc: stable' then it is probably too late to add that.  You'll need to
send a request after Linus has merged it.

Ben.

> ---
>  drivers/regulator/core.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index e872c8b..c347fd0 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -2250,6 +2250,7 @@ int regulator_set_voltage(struct regulator *regulat=
or, int min_uV, int max_uV)
>  {
>  	struct regulator_dev *rdev =3D regulator->rdev;
>  	int ret =3D 0;
> +	int old_min_uV, old_max_uV;
> =20
>  	mutex_lock(&rdev->mutex);
> =20
> @@ -2271,18 +2272,29 @@ int regulator_set_voltage(struct regulator *regul=
ator, int min_uV, int max_uV)
>  	ret =3D regulator_check_voltage(rdev, &min_uV, &max_uV);
>  	if (ret < 0)
>  		goto out;
> +=09
> +	/* restore original values in case of error */
> +	old_min_uV =3D regulator->min_uV;
> +	old_max_uV =3D regulator->max_uV;
>  	regulator->min_uV =3D min_uV;
>  	regulator->max_uV =3D max_uV;
> =20
>  	ret =3D regulator_check_consumers(rdev, &min_uV, &max_uV);
>  	if (ret < 0)
> -		goto out;
> +		goto out2;
> =20
>  	ret =3D _regulator_do_set_voltage(rdev, min_uV, max_uV);
> -
> +	if (ret < 0)
> +		goto out2;
> +=09
>  out:
>  	mutex_unlock(&rdev->mutex);
>  	return ret;
> +out2:
> +	regulator->min_uV =3D old_min_uV;
> +	regulator->max_uV =3D old_max_uV;
> +	mutex_unlock(&rdev->mutex);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(regulator_set_voltage);
> =20

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-OcfZUkz0IlhetDlK3WXS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUNx/W+e/yOyVhhEJAQq+OQ//ScAwDPaoQJXNRW8Qdo0x/WPQ22HdPjdy
rP8z54QQPyGY25q5jL4MoblgD8uH7hPi5C/PxWjbdTyFfMKUsJq6PVsk4NR61kMl
s63PROy4ojjz5SyarqkjFOXErYi8QfcTBh3ERiVxnDLUGbYguGnRfvNIgiM4/esb
zOnOiujGze3VFLTeFrpBtIllxsmCYgkk6vsYQbyANtcqPJ26ImolZFuLqfjZwM5j
EFtT4lqre0+SWQpHUHdW9VW6VZn3V5RNUMRJM7s3hXy6PK6JW9/NkG5KPFWofcza
zrJT4NNrLYAk5ryndD9MFRJG6q7Ey1azhWTmsQM0SADkTHShObTZf2xcxjNy/R9P
Rsjkg+ZU/7l+TPcAIsuirCyjbUIHCFS8g5leCNq7HIoDTUfPh8TaKRQZ98aAQIOC
nU4NA95GQGoHQafTQlB3dr/yP2YsMGb5ME879z1qoZion7NucGgXpTYIJl91R3HY
SM9se8ROabzjvYKH8O58LBrIKYEljruQqXEOvCqK86CxFvCDvQd8FxukIWKL5XI6
olj2B12FG8InybOBsfPOdSK0QvhIcdFTwNSsYGyUhtmtl5rIa1v38X/1SLMM21qr
OND5+wj3l1IyRR6d2rsGJ+Dt5B/cPtHEITNWTDlRnZcY6A1LbqJalmSQ0B8gbZnB
ljM4oA77hy8=
=405L
-----END PGP SIGNATURE-----

--=-OcfZUkz0IlhetDlK3WXS--

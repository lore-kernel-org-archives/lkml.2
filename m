Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab2FONVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 09:21:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60511 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345Ab2FONVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 09:21:33 -0400
Date: Fri, 15 Jun 2012 14:21:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: Re: [PATCH v2] regulator: add new regulator driver for lp872x
Message-ID: <20120615132130.GH4482@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FB5C6@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Epv4kl9IRBfg3rk"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FB5C6@DQHE02.ent.ti.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Epv4kl9IRBfg3rk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 15, 2012 at 08:46:34AM +0000, Kim, Milo wrote:
> This driver supports TI/National Semiconductor LP8720, LP8725 PMIC.

Overall looks very good, just a few fairly minor things below but
nothing substantial.

>=20
> patch v2
> --------

See Documentation/SubmittingPatches for how to format stuff like this -
put it after the ---

> +	if (chip =3D=3D LP8720) {
> +		mask =3D LP8720_TIMESTEP_M;
> +		shift =3D LP8720_TIMESTEP_S;
> +		time_usec =3D &lp8720_time_usec[0];
> +		size =3D ARRAY_SIZE(lp8720_time_usec);
> +	} else if (chip =3D=3D LP8725) {
> +		mask =3D LP8725_TIMESTEP_M;
> +		shift =3D LP8725_TIMESTEP_S;
> +		time_usec =3D &lp8725_time_usec[0];
> +		size =3D ARRAY_SIZE(lp8725_time_usec);
> +	} else {
> +		return -EINVAL;
> +	}

This should be a switch statement.

> +static int lp8725_buck_set_current_limit(struct regulator_dev *rdev,
> +					int min_uA, int max_uA)
> +{
> +	struct lp872x *lp =3D rdev_get_drvdata(rdev);
> +	enum lp872x_regulator_id buck =3D rdev_get_id(rdev);
> +	int i, max =3D ARRAY_SIZE(lp8725_buck_uA);
> +	u8 addr, val;
> +
> +	if (buck =3D=3D LP8725_ID_BUCK1)
> +		addr =3D LP8725_BUCK1_VOUT2;
> +	else if (buck =3D=3D LP8725_ID_BUCK2)
> +		addr =3D LP8725_BUCK2_VOUT2;
> +	else
> +		return -EINVAL;

Again, switch statement.

> +static const struct regmap_config lp872x_regmap_config =3D {
> +	.reg_bits =3D 8,
> +	.val_bits =3D 8,
> +	.max_register =3D MAX_REGISTERS,
> +};

Probably worth enabling cache here, it'll cut out read/modify/write
cycles which will improve the performance as the reads should be free.
Not essential but worth considering.

--4Epv4kl9IRBfg3rk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2za9AAoJEBus8iNuMP3deIMP/R31kkybq+jvymkjZNngSiUF
Hon95WCsbuA5fyLrgA5+YFFuIwRbFZHWYIn2/+UN8H3YtqmCSTYe838t1I6rpvvp
LJlFp6gslpoB2oNO2Bb/mbo2l8F4r2vg56+FDlQ82E9Tz5+zIPkkdqMkzX7RZkLp
qE3b+6rQG6qE7ze00N85c7puDRnXvCg3PiyfbpcDiUuQoNjhi9+kRtEb3/8v6zl2
UIY7V+6cUhR865LKN2SmbYgpeVAabmIYbyzVPsb4tN5Vwcd9/5qCYGTAmNz8onbS
2EIbh9P77tBcJeHn3hlvhRO0iadmBA4hoMA7uOWyWH93SFBUXQBsesEzu1D0jnEy
CCklywV+Y0/WHuKaoTPZFGuppp878CyB2txK4H0k9jvx83wZGYV1F0YE1tQL2dff
9WI01VMmpsxA3cyhL/ncz0v0s2Wfx+Pn4ZEWGeFYHbt/HP+uZLmCHxuHEOJcOEQv
AjKlZlw+lXdL7ZMoWdCIiQumoxDc8UP32shIAvi8qFb2dVpt5ncWBpQhRek+YuEJ
27/1JwQP4odr1U66o/5wMjfWJurpjHBzGLrd4m3pXI5TNvE03LTPuMk0dvJqy8AA
iwugzOpjz6avjf5vLB2TET4U0vloLdFkC+LWE0aRFVWlVLFAZW+1qt2z7F6zEjuJ
vnq99ovPzcEuTlOfs5in
=VRlv
-----END PGP SIGNATURE-----

--4Epv4kl9IRBfg3rk--

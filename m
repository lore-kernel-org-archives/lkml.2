Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2E3R0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:26:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52966 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177Ab2E3R0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:26:54 -0400
Date: Wed, 30 May 2012 18:26:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v5] regulator: MAX77686: Add Maxim 77686 regulator driver
Message-ID: <20120530172652.GS9947@opensource.wolfsonmicro.com>
References: <1338258051-3155-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ffBYM5qgR8HH9Mta"
Content-Disposition: inline
In-Reply-To: <1338258051-3155-1-git-send-email-jonghwa3.lee@samsung.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ffBYM5qgR8HH9Mta
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 29, 2012 at 11:20:51AM +0900, Jonghwa Lee wrote:
> Add driver for support max77686 regulator.
> MAX77686 provides LDOs[1~26] and BUCKs[1~9]. It support to set or get the
> volatege of regulator on max77686 chip with using regmap.
>=20
> v5
> - Remove unnecessary initializing and variable.
>=20

Don't put stuff like this in the changelog, it's useless noise in git.
Include it after the cut as documented in SubmittingPatches.

> +#ifdef CONFIG_COMMON_CLK
> +	struct clk clk32khz_ap;
> +	struct clk clk32khz_cp;
> +	struct clk clk32khz_pmic;
> +#endif

This should be a clock driver in drivers/clock.

> +static int max77686_set_voltage_time_sel(struct regulator_dev *rdev,
> +			unsigned int old_selector, unsigned int new_selector)
> +{
> +	struct max77686_data *max77686 =3D rdev_get_drvdata(rdev);
> +	int rid =3D rdev_get_id(rdev);
> +
> +	switch (rid) {
> +	case MAX77686_BUCK2 ... MAX77686_BUCK4:
> +		return (DIV_ROUND_UP(rdev->desc->uV_step
> +			* abs(new_selector - old_selector),
> +			max77686->ramp_delay * 1000));
> +	}
> +	/* Unconditionally 100 mV/us */
> +	return (DIV_ROUND_UP(rdev->desc->uV_step
> +		 * abs(new_selector - old_selector), 100000));
> +}

Just do separate functions.  The above is pretty illegible.

> +	max77686->ramp_delay =3D MAX77686_RAMP_RATE; /* Set 0x3 for RAMP */
> +	regmap_update_bits(max77686->iodev->regmap,
> +					 MAX77686_REG_BUCK2CTRL1, 0xC0, 0xC0);
> +	regmap_update_bits(max77686->iodev->regmap,
> +					 MAX77686_REG_BUCK3CTRL1, 0xC0, 0xC0);
> +	regmap_update_bits(max77686->iodev->regmap,
> +					 MAX77686_REG_BUCK4CTRL1, 0xC0, 0xC0);

This still appears to not be referencing the ramp rate that's being set?

--ffBYM5qgR8HH9Mta
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxlf/AAoJEBus8iNuMP3djQEP/1IaYjs8S4uZ5I1mZ/ltmUkc
s2PSY20dIMUGo9Ue2sXCygYcFlZhCGT5kPAzTynqeTHGYwPeY0GPuIDcicy52oF4
Vv9U9mZ/7fPiyHPaflG2HBQFllWwRk44yX58eIRW65rxleBoB1/XxdyCTTPxGRiD
xQVKrhvmI1Zm/HqRMYM2QbgUNYqouFzRWeLdUzx9OZVpTq8gDxDjRQE45PC4OwZo
KWbhyqa5fSImPFFCcH+4NzVqDBPWa+eP5ABXWMbhwxk98HpoT85zgmLpVN6KYK+C
vX+vWYTJ6m7vmFWrmE9SPvOFU5w76bw8iEcoqTohz97IRHPyzlGJ5LpCZ1ltXpb5
jZ1m6U19TZAYZ+jswpD6KszH2SXpFl7HCjA9JI4g3QI70OJnBzHRmKIJNOusqJR4
RlG50sw8e/fbsj7K+ZSLrAxo/bPjpyG95psdDwDHIDkdXE/aJrDQA18ZWo+pQcol
z+ouKhRuMeiaNZSKVwgjo/jNNhjVx6eXUllLyKO1gpB6ppfTpJDYJq0nuQLsX+6Y
ora2/Uzn6aFatnYS2I6F4/Y4VdcpC7xtpF+GrOSoqczlvKaEodcei91mtZinC5Ma
C6vzmMePQzFGGLWsnFSjLTBOxnhjF7onAlQggW6Gj8CyIAl/eSLOf3hE1yzK2lVA
nbi1H/Kes99CJOoUP862
=23ZT
-----END PGP SIGNATURE-----

--ffBYM5qgR8HH9Mta--

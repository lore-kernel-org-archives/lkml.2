Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2HVQCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:02:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43344 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766Ab2HVQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:02:43 -0400
Date: Wed, 22 Aug 2012 17:02:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        shawn.guo@linaro.org, kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sameo@linux.intel.com, lrg@ti.com,
        richard.zhao@freescale.com, devicetree-discuss@lists.ozlabs.org,
        swarren@wwwdotorg.org, paul.liu@linaro.org
Subject: Re: [PATCH 1/7] mfd: add imx syscon driver based on regmap
Message-ID: <20120822160241.GR7995@opensource.wolfsonmicro.com>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-2-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q56cwELb5ReCVVQh"
Content-Disposition: inline
In-Reply-To: <1345619928-15446-2-git-send-email-b29396@freescale.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q56cwELb5ReCVVQh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 22, 2012 at 03:18:42PM +0800, Dong Aisheng wrote:

> From: Dong Aisheng <dong.aisheng@linaro.org>

> Add regmap based imx syscon driver.

Nice to see more regmap-mmio usage!

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

=66rom a regmap point of view.

> +int imx_syscon_write(struct device_node *np, u32 reg, u32 val)
> +{
> +	struct device *dev;
> +	struct imx_syscon *syscon;
> +	int ret =3D 0;
> +
> +	dev =3D driver_find_device(&imx_syscon_driver.driver, NULL, np,
> +				 imx_syscon_match);
> +	if (!dev)
> +		return -EPROBE_DEFER;
> +
> +	syscon =3D dev_get_drvdata(dev);
> +	ret =3D regmap_write(syscon->regmap, reg, val);

It'd be good to provide a way of retrieving the regmap so that drivers
for subsystems with generic regmap code could use the framework features
(regulator is one example that I just mentioned in my other mail).

--q56cwELb5ReCVVQh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNQKaAAoJEFJkBDiqVpZ49UgP+wWOKBCk9UOj5BNa76qKuj2K
jinGoe/x7e9g7IF4Ni42PiVw2QyP/4aTist9vHB1tqK956K1Xvlhzets8PG+nL6P
4Omflw/X8JEqCNxZB2N5kXHZd7F9fM6uiJtVh+zFFbI4JIAFTu0gNiAJl1PfP4pJ
atSq1Fwn9FMCPog4mHTR0kvkrlBP1gDohe+1lfWnclP0FHSg5Ty2osYbsAqmas7J
ccW3YWL+qEQwhfIDrZS65+t0+ujebtpv293m+GqgvA51gOBpSIuFiRQQhX2WvogX
6xJfPlVDKtZBmw5XMgIh51sQsw341JbRjTGXaZNvcjt7zJEoUw9NFI8IPA3H6AIP
sevpVo3JUvE1pvPLZupKLgL1ZPoMrIWgF+HCEmwMTUAuOfLNCCWIs34Pyx2B9AMc
QoJOcB2n3BodxXlhZVnC+QRRQV+OYje33kei1cEP3ndlV8qFFAeOKUyITdjt4zgc
Fif8Ykizm7m6L0t2n5yhe9N1tl5ZRDKqhTk1jXFrZxqvgWaKjb0dEWN2jDLGOJ0Q
I6CXcdcXSVLVhBgOHwvi/tOFFaAAH/pSxwopiwwWoPmkedSuGCuzjx90mt+AvkXX
v4/jiZCSrhe961omGOGt8vcvGU98wpgLtlqzDFsh5Kkrlxa/PDSOWK6SvU826oQH
EXke92GKkMSmRUm8qHH3
=/a7A
-----END PGP SIGNATURE-----

--q56cwELb5ReCVVQh--

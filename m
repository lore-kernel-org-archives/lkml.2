Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab2FRMpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:45:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33136 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086Ab2FRMpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:45:16 -0400
Date: Mon, 18 Jun 2012 13:45:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Message-ID: <20120618124513.GM3974@opensource.wolfsonmicro.com>
References: <1339558031.26190.4.camel@phoenix>
 <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
 <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13E9D84D9@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tDYGg60iReQ7u8wj"
Content-Disposition: inline
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13E9D84D9@DBDE01.ent.ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tDYGg60iReQ7u8wj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 12:39:38PM +0000, AnilKumar, Chimata wrote:

> +	if (config->regmap)
> +		rdev->regmap = config->regmap;
> +	else
> +		rdev->regmap = dev_get_regmap(dev->parent, NULL);

No, this would be broken.  We're specifically using the device we got
passed in.  In this case the fact that the regmap is on the MFD means
that the driver does need to explicitly set the regmap.  Or we should
have this be a multi-stage series of checks:

	if (config->regmap)
		rdev->regmap = config->regmap;
	else if (dev_get_regmap(dev, NULL))
		rdev->regmap = dev_get_regmap(dev, NULL);
	else if (dev->parent)
		rdev->regmap = dev_get_regmap(dev->parent, NULL);

which should cover the MFD case if there's no regmap on the child
without having to go through all the drivers doing it by hand.

--tDYGg60iReQ7u8wj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3yLTAAoJEBus8iNuMP3duesP/3wqybqxTjNaVq0Mn40azvrI
Rk/MV20w5HTGCHGTzPH9xnBhsToSjLZr7aJnnFUx189q6CQB6MD5wRgcWpLKh8XE
Wi8H001zoT1ZFOvquLsk9ptU6LdERXmgeCl1aIGgTzfYPSiyRNT7IO5gDHU51Gac
L5XfkwOx36Ny4rGpex6/QCPpyNX2DWC4j4HuawepINOqyr0J2OL/U6tic5TG8xaR
Wz+FUjBBO0FmF7sBGnqHKfamDoMdEhMcyIIzV8vmctL7pSiPSWOEUGnuwYZ3SmJl
wFPSwdTp2hMnwbhenhAI7aSf/VCq1YpdhFrifRN7A7En3yIg1hVkYtATfBPrtm8z
sI0xAamgKSSkP7UTFZh8G0UjgeUAgxpGzcPk7PV7Zmo2L9clRZ9QYw51aj5ZcMdG
nHeejUn4D3l8J6UD5cTL8VJhsab45EUD6zUVQCiydYg+OTv6Zhx+kYwOmr2gLYis
/sJTpbr7Nm54F5cCW4IBAjFRgDDnYdBeuw/LFwbqvlf20dnZaZBjLasROmssSZVL
GINKM0wkzz270hnJ5BpT3oHaRIvCV8ChoUI5Ua+viSokA9F6NC+XsHVD6C/Y6QVX
+fnIi01Ebq7oE7q1ce1FFmZ3/pA7xXoSv0GEdN3pd1zKkH7YwaAIRoq5FzI/toKo
2b6SqxgQtaBD9Fqpf+Ds
=jDsT
-----END PGP SIGNATURE-----

--tDYGg60iReQ7u8wj--

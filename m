Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab2CHSWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:22:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42114 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614Ab2CHSWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:22:15 -0500
Date: Thu, 8 Mar 2012 18:22:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: da7210: Update for using I2C regmap
Message-ID: <20120308182212.GY3638@opensource.wolfsonmicro.com>
References: <1331213696.17383.7.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yKkvi6mMqAM+MlBZ"
Content-Disposition: inline
In-Reply-To: <1331213696.17383.7.camel@matrix>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yKkvi6mMqAM+MlBZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 08, 2012 at 07:04:56PM +0530, Ashish Chavan wrote:
> Current DA7210 driver has I2C support using older register cache
> methods. This patch updates it for latest regmap framework.

I've applied this but please fix the minor issues below incrementally.

> +static struct reg_default da7210_reg_defaults[] = {
> +	{ 0x00, 0x00 },

If any of these registers don't exist they should be removed from the
defaults table, looking at the register defines in the header the
registers between 0x2c and 0x83 should be removed along with register 0.

Similarly, registers that are volatile should not have defaults
specified.

> +	/* unlock */
> +	regmap_write(da7210->regmap, DA7210_A_HID_UNLOCK,	0x8B);
> +	regmap_write(da7210->regmap, DA7210_A_TEST_UNLOCK,	0xB4);
> +	regmap_write(da7210->regmap, DA7210_A_PLL1,		0x01);
> +	regmap_write(da7210->regmap, DA7210_A_CP_MODE,		0x7C);
> +	/* re-lock */
> +	regmap_write(da7210->regmap, DA7210_A_HID_UNLOCK,	0x00);
> +	regmap_write(da7210->regmap, DA7210_A_TEST_UNLOCK,	0x00);

This sequence should be changed to use a regmap patch.  This will fix an
issue you currently have with suspend and resume where the updates are
not reapplied if the device is powered off over suspend.

--yKkvi6mMqAM+MlBZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWPhRAAoJEBus8iNuMP3dV8QP/jj7LNlOZ2sbg8cg0wXqU5B/
C4Ge8cxbFY/+5Mlu9ADp9+Ceu9ggxjIfL0eRMpxFESNH8hTUYTi/Vu0iWQPKeAyc
zXmi4SXaYoFSt6qwPz5DwIFwXAKjCXQ9qyf1BNFdixxr4e+Z1ch4upy1zZOVRO90
zAUEiK1G1hi0ZKj4p5ImOiWlZ2XRhM/Vkmx3rDRqiSYyA8Q/UbPPsP2dxBywZ//f
3CMyIbLs6j8K3iVgwA91OAj4+wD5m/OVh6+0xBOSa0nNdCQtGKRB053rXOqyeZ1E
b7ZAbEQBRLnMW3edSVkQ7XqfNVAksN7ma/Lp7UB+zAE9hO6hzDq3ntnl9dX2LSDS
pzCweywyi1xYfopS/BKB5nV0bJN/JaIz3zW7zLET5ybV5kTIfFiDo4vk4G0iRnm7
dcVaerSNCagGPWyn0ZQtJPRFYit7Wmqm91v66xo1FkEqWZa3p+KtjwO9OtN6iukB
SK/KtGIjE9TnFiXnQjibW8HhdgPYIq7/9uAwgljwlfAh5MirIv+lLwXCcucyDC7C
/aySRxcdJv0Z3BfstLPqVe+tZ6HrqaWe2nv5S5irq3yHNYpEslnWZ0QWm+a+XQ8w
GIdtityen8OASz66IihhNG/7kJdMVpWb30XN0ySnNtbPmn8kAle2ArtVmPcZIiY+
b0l6l2mlEXzDQMZf+SCS
=qnIU
-----END PGP SIGNATURE-----

--yKkvi6mMqAM+MlBZ--

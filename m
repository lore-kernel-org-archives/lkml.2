Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab2CUP4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:56:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55834 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788Ab2CUP4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:56:38 -0400
Date: Wed, 21 Mar 2012 15:56:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: da7210: Add support for spi regmap
Message-ID: <20120321155635.GE3226@opensource.wolfsonmicro.com>
References: <1332345170.21744.10.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kA1LkgxZ0NN7Mz3A"
Content-Disposition: inline
In-Reply-To: <1332345170.21744.10.camel@matrix>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kA1LkgxZ0NN7Mz3A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 21, 2012 at 09:22:50PM +0530, Ashish Chavan wrote:

> +#if defined(CONFIG_SPI_MASTER)
> +	/* Dummy read to give two pulses over nCS */
> +	regmap_read(da7210->regmap, DA7210_STATUS, &val);
> +	regmap_read(da7210->regmap, DA7210_STATUS, &val);
> +	regmap_read(da7210->regmap, DA7210_STATUS, &val);
> +#endif

This ifdef stuff should all be runtime configured based on the bus type,
unless the cost of the reads is considered immaterial in which case it
should be unconditional.

> +#if defined(CONFIG_SPI_MASTER)
> +	snd_soc_write(codec, 0x00, 0x80);
> +#endif

Hrm?

>  	/* unlock */
>  	regmap_write(da7210->regmap, DA7210_A_HID_UNLOCK,	0x8B);
> @@ -1035,6 +1056,10 @@ static int da7210_probe(struct snd_soc_codec *codec)
>  	regmap_write(da7210->regmap, DA7210_A_HID_UNLOCK,	0x00);
>  	regmap_write(da7210->regmap, DA7210_A_TEST_UNLOCK,	0x00);

I also note that you've not yet updated this to use a regmap patch as
was previously requested.

> +#if defined(CONFIG_SPI_MASTER)
> +static int __devinit da7210_spi_probe(struct spi_device *spi)
> +{
> +	struct da7210_priv *da7210;
> +	int ret;
> +
> +	da7210 = kzalloc(sizeof(struct da7210_priv), GFP_KERNEL);
> +	if (!da7210)
> +		return -ENOMEM;

devm_kzalloc().

> +	da7210_regmap.read_flag_mask = 0x01;
> +	da7210_regmap.write_flag_mask = 0x00;

Just have a second, static, regmap variable.  The regmap should be
declared const.

> +	da7210->regmap = regmap_init_spi(spi, &da7210_regmap);

devm_regmap_init_spi() (will come in in the merge window).

> +static struct spi_driver da7210_spi_driver = {
> +	.driver = {
> +		.name = "da7210-codec",

No -codec.

--kA1LkgxZ0NN7Mz3A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPafosAAoJEBus8iNuMP3dD8IP/33tE8Trbvwiq1TQVyd4DBUZ
KrRux/vH7nR42sKUx6mtDILRzslfeqDgUbVQCrukCHUcSVBxsi9bue4N+9L+2+P4
XL+5CtKA5R25gGwjxLZbFrBpgu2IR5er1zwu0njP7FeUI+K46uSQyiC+sQsX+k72
FCCL0GsXZxbcJiNw1WTT6qJrmRr0KN5zYLHVgbDPyO+j3tL0Yvz6KLgpaxW4A1hL
Tt+tC8LmI04pVt9gsRqrXzwwjzC2j0f1fejLCwxcokgRa2t0lHYkjjtchSKVnqLY
XJaL7Rs6yZokcM/70sF3kIg2XYFt1o2tkb5Rc3IvDpMA2xcbmFogWLj0lOcn7aVG
6gx5NGyjg3Ot7Sxnbqp3EiD7SfAPxZtuX1T6sqkShDWYUbGVFRQLO3jj+KfpEBLt
IBadUr4oII/qHTyAzDJn9/CHXssIpGwZCgQkuqfsPqsMp9aaU2dyHOXcfLKGlVjw
SJruYWVfEYS9dUu5wZKlI/7SCbmpQdlQBRiLrsMVaaewkjK6RKFHaRmB9iZmagWm
Pf6/O+XdJ4ouimHQggoS+y4RcrnFPBOuB2amj9bB5hGmWquaHLunLa27lQT6muDA
kVSB6Jg9ysnDxfQzIayIV1s0u6QQVZI1qzWADyt8gcWBP2rVFxbjGYGFovQnj9Br
FhW8Ut5n9Pkr55kpbyIW
=UZgT
-----END PGP SIGNATURE-----

--kA1LkgxZ0NN7Mz3A--

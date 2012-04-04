Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab2DDTzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:55:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39620 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932515Ab2DDTzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:55:37 -0400
Date: Wed, 4 Apr 2012 20:55:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        stefan.nilsson@unixphere.com
Subject: Re: [PATCHv3 3/3] misc: add support for bmp18x chips to the bmp085
 driver
Message-ID: <20120404195532.GB10787@opensource.wolfsonmicro.com>
References: <1333568759-13536-1-git-send-email-eric.andersson@unixphere.com>
 <1333568759-13536-4-git-send-email-eric.andersson@unixphere.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <1333568759-13536-4-git-send-email-eric.andersson@unixphere.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 04, 2012 at 09:45:59PM +0200, Eric Andersson wrote:

> +static int __devinit bmp085_i2c_probe(struct i2c_client *client,
> +				      const struct i2c_device_id *id)
> +{
> +	struct regmap *regmap = regmap_init_i2c(client, &bmp085_regmap_config);
> +
> +	if (!regmap) {

Should be IS_ERR() - regmap uses PTR_ERR() and for error return values.
I'd also consider devm_regmap_init_i2c() (introduced in the merge
window) which saves you bothering to free it later on...

> +		dev_err(&client->dev, "Failed to init regmap!\n");
> +		return -ENOMEM;
> +	}
> +
> +	return bmp085_probe(&client->dev, regmap);

...right now it gets leaked so this would also fix an error.

> +static const struct of_device_id bmp085_of_match[] = {
> +	{ .compatible = "bosch-sensortec,bmp085", },

Traditionally the stock ticker symbol would be used.

> +	status = regmap_bulk_read(data->regmap, BMP085_CONVERSION_REGISTER_MSB,
> +				 (u8 *)&tmp, sizeof(tmp));

Should be no need for the cast, the destination array argument is a
pointer to void.

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfKbkAAoJEBus8iNuMP3dY9gP/25ElwRJFSlKCmS47HKhdK5X
ytM60tfRMscPfJ1LnptNsnNOr4aicAPFkl1oAdfjyl+I9IvV9seB0hSQr9OPvQwU
WStTf5FkPR3fVvNAzYBlskP71E5arPQZsOXqWO+npD9ZUB3jdXjFXP9FYsXccQTV
Na7d3tTu14ODMbXPqOVK5NwdCDPkfGEHadb1hENc6qh8+DaOigFIo5yNrfUCv4pI
MDPETTS6K8qHgBhVSL66Flv5DpzvBPrUbsCYEhqL9vhUAxL7vY/aaJ1sGxzyczLv
0bgsavGtoOe6kTFMav5UhsOWr1YqGs7xpLy4WcKJpG5UwPgYccRZ4D5c7FWJLyrV
eGhxc9IbC1CoqoXdQ3FNWhv1cA8WPm2k8QLQIQY3F+bpjhh86npcIyjBhF9U3M+K
l4cVgQUw8Ox5JsfsPRL/XINSYekQ3JgzhSdnwKaRhVjxpa/OCF+JHmdvAJqYWlzK
8dlEpcceqqq7RdFDS29SQT7cQaS3zWucsdrZmgYt0Aa+v3YMz9kOMMZ8YzW2/veg
MSRp4AR3x+6va1Cdb0Y26L9hUVUWfCS8YIIiIDOnJ6leW7RhM2a7afO4hT+IEAQx
9JyAU0NCZgGTjCD4w4pghsNK2/cqJc57wHYPlIfjs091WxGA5EvlKqQPq2Pv/dA2
nEf/WpZXIV1J9Dj5JDrb
=ulxq
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--

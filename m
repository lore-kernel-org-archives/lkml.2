Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2ENJTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:19:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49086 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034Ab2ENJTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:19:21 -0400
Date: Mon, 14 May 2012 10:19:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] MFD: MAX77693: add MAX77693 MFD driver
Message-ID: <20120514091917.GJ31985@opensource.wolfsonmicro.com>
References: <1336972830-15169-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fjX3cMESU3XgGmZ"
Content-Disposition: inline
In-Reply-To: <1336972830-15169-1-git-send-email-cw00.choi@samsung.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fjX3cMESU3XgGmZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 02:20:30PM +0900, Chanwoo Choi wrote:

> Signef-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Typo :)

> +int max77693_read_reg(struct regmap *map, u8 reg, u8 *dest)
> +{
> +	unsigned int val;
> +	int ret;
> +
> +	ret = regmap_read(map, reg, &val);
> +	val &= 0xff;
> +	*dest = val;

Should be no need for the val &= 0xff - if there is there's a bug we
ought to fix in regmap.

> +int max77693_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask)
> +{
> +	unsigned int old_val, new_val;
> +	int ret;
> +
> +	ret = regmap_read(map, reg, &old_val);
> +	old_val &= 0xff;
> +	new_val = (val & mask) | (old_val & (~mask));
> +	ret = regmap_write(map, reg, new_val);

This should be using regmap_update_bits(), the current code is buggy as
it does not lock which means that multiple simultaneous updaters could
conflict with each other.

> +static struct regmap_config max77693_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,

Defining max_register would let you see the register map in debugfs but
this is optional.

> +	max77693->regmap = regmap_init_i2c(i2c, &max77693_regmap_config);
> +	if (IS_ERR(max77693->regmap)) {

devm_regmap_init_i2c().

--2fjX3cMESU3XgGmZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsM4GAAoJEBus8iNuMP3dWJ4P/1Kw5je1QqFgbw+0AnRZFdQi
UBXRYB1UJMNXBg53qI7/AmpG6vnmOa6pk/O8//DW9e14sqSd8JCKJWeiulA6wV9Z
8W669eJ7I5XO65yJC7mimqf6Qz5+Q5GcDWCV0HYX0UsWmLznBg6hhIquReFcc5kQ
DUQv6vWp0b1gxZwMFKSPkUfZ4AZCixrzrNzgLuy/LTcy+8dn85ZlznqHqJlgdd3m
BNaWnnRKhNkZlLLD0btJse1kLY5ciujQS/sa/fmh32VYGXPoWLI4QSswBLXiaORU
ff0vd420ekjZpLvte+UQub7H4LOdC8uJZ8LGukQYX0Fqra30DqqSUV6bxwNISPey
q01oG52gXRMb4xjlaAorSa/f1RMZgc1zIYg7SDU4YkGwWRT0nKGnNAgvmTk/6b5K
oYJSuh580CuQxFipM5H6DLGHIs4LrzWLXhlXl6q3+MO2GVyq51xMT+1VYrAUjiTx
hDiPSZpcIPa3QVJ39l4W/dGw5V931M0hFVUTqQWaJUHgfi/E1Dn1096/vZR69ank
OvbwwKg1fJ0HFY9qSOz6uTA8MmivvxNlYWJ4avzsbHVwbtkkTXpTe8D62Cchke/V
LYWvN/C45oWyE+hShjuvbkjFRK4EvaefueF58FCIn48lxAbXI32+HbBTO9SWVIhA
OSfdglKyJlTTq2Bm1mUS
=56xB
-----END PGP SIGNATURE-----

--2fjX3cMESU3XgGmZ--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2ETP4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 11:56:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36946 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab2ETP4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 11:56:20 -0400
Date: Sun, 20 May 2012 16:56:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Oritz <sameo@linux.intel.com>, Liam Girdwood <trg@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>
Subject: Re: [PATCH 2/3] regulator: MAX77686: Add Maxim 77686 regulator driver
Message-ID: <20120520155616.GB9337@opensource.wolfsonmicro.com>
References: <1337333539-18371-1-git-send-email-jonghwa3.lee@samsung.com>
 <1337333539-18371-3-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <1337333539-18371-3-git-send-email-jonghwa3.lee@samsung.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 18, 2012 at 06:32:18PM +0900, Jonghwa Lee wrote:

> Add driver for support max77686 regulator.
> MAX77686 provides LDOs[1~26] and BUCKs[1~9]. It support to set or get the
> volatege of regulator on max77686 chip with using regmap.

Looks mostly good, a few things below but they're all pretty
minor/straghtforward.

> +/* LDO3 ~ 5, 9 ~ 14, 16 ~ 26 (uV) */
> +static const struct voltage_map_desc ldo_voltage_map_desc = {
> +	.min = 800000,	.max = 3950000,	.step = 50000,	.n_bits = 6,
> +};

Should convert all these to use regulator_map_voltage_linear() and
regulator_{get,set}_voltage_vsel().

> +	ret = regmap_read(max77686->iodev->regmap, reg, &val);
> +
> +	if (ret)
> +		return ret;

> +	printk(PMIC_DEBUG "id=%d, ret=%d, val=%x, mask=%x, pattern=%x\n",
> +		 rdev_get_id(rdev), (val & mask) == pattern,
> +		 val, mask, pattern);

dev_dbg() or just remove this (and similarly for the other similar logs).

> +	{
> +		.name	= "EN32KHz AP",
> +		.id	= MAX77686_EN32KHZ_AP,
> +		.ops	= &max77686_fixedvolt_ops,
> +		.type	= REGULATOR_VOLTAGE,
> +		.owner	= THIS_MODULE,
> +	}, {
> +		.name	= "EN32KHz CP",
> +		.id	= MAX77686_EN32KHZ_CP,
> +		.ops	= &max77686_fixedvolt_ops,
> +		.type	= REGULATOR_VOLTAGE,
> +		.owner	= THIS_MODULE,
> +	}, {
> +		.name	= "EN32KHz PMIC",
> +		.id	= MAX77686_P32KH,
> +		.ops	= &max77686_fixedvolt_ops,
> +		.type	= REGULATOR_VOLTAGE,
> +		.owner	= THIS_MODULE,
> +	},

These should be managed via the clock API now we have one.

> +	if (!pdata)
> +		dev_err(pdev->dev.parent, "No platform init data supplied.\n");

Should be able to carry on without this and register the regulators to
allow for diagnostics and powering off unused regulators when we have
full constraints.

> +	size = sizeof(struct regulator_dev *) * MAX77686_REGULATORS;
> +	max77686->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
> +	if (!max77686->rdev) {
> +		devm_kfree(&pdev->dev, max77686);

Shouldn't need to devm_kfree(), the major point is that this will happen
automatically.

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuRQaAAoJEBus8iNuMP3dWP0P/2b+ZfN+sbPnju7qLFqyyt6m
hQAggzhwpTD95THOj0vhy8iozif8qU91sLh5JSQU3XN2+Pd8mAzFOzqrRkv/LuPj
Uwa83KSBetlcD1/cyNVWeyHKZsQ89AzWvBDf1jpbiHIlTUL1JYSS6mt6C1uxhKMc
rXQvgYuN/wTtBL0zq2AwCEJGzUwpRYzPhj9DYbvDwQ5a358vao701jkXiRbWcx6V
PINlpARl7riRRNQGXJzEsZOsSEpuvyDc6626dW/LOxTsXohgHwr7MSpLsJo+eXoi
sqbUodSwz44ui+3NfN+V/ThcqnKnnw+xynR9b+wbJiynjSzyQ8kA1v8zGb9b3F5/
AcxnrCs8heVH6bG3aOe8Td5+1cNo2knQuBE5PQhrA+dY9V36aaDvkVK9LxFWI7cS
pTHToEqSpguAr8b3UkibRGLuDWFHwJl+rbXu0Stjc+SJLwiHUfx4CitZJidbizCM
YeNWQ2ySUbXlLwZ72GCt4pQFve0qp9vHIsjA+N5OZCHfdZlwxc/+mnNkAK+pRsi2
Hs9LnYs/W6L2UKThZbLeVannL6A3g4kRzta2VQj2/18AEhhc6M4TLCOgcsEitK6v
bqlVW2z7y3qLzz6KyC5fCtxbpPQXQ4UDc3AxBu/ZRI/qcdpB1pFGQW0cOt4yOgHE
EiYflWJ9F/gMnKOoDe2q
=locA
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--

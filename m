Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2ETKAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 06:00:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46690 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782Ab2ETKAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 06:00:19 -0400
Date: Sun, 20 May 2012 11:00:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH v2 2/2] regulator: Add support for MAX77686.
Message-ID: <20120520100015.GC20652@opensource.wolfsonmicro.com>
References: <1337261967-26004-1-git-send-email-yadi.brar@samsung.com>
 <1337261967-26004-3-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
Content-Disposition: inline
In-Reply-To: <1337261967-26004-3-git-send-email-yadi.brar@samsung.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2012 at 07:09:27PM +0530, Yadwinder Singh Brar wrote:

Looks mostly good.  A couple of fairly small things:

> +static int max77686_get_voltage_sel(struct regulator_dev *rdev)
> +{

This looks like it should be regulator_get_voltage_sel_regmap().

> +static int max77686_set_voltage_sel(struct regulator_dev *rdev,
> +					unsigned sel)
> +{

This looks like it should be regulator_set_voltage_sel_regmap().

> +	max77686->ramp_delay = pdata->ramp_delay - 1;
> +	max77686_update_reg(i2c, MAX77686_REG_BUCK2CTRL1,
> +		RAMP_VALUE, RAMP_MASK);
> +	max77686_update_reg(i2c, MAX77686_REG_BUCK3CTRL1,
> +		RAMP_VALUE, RAMP_MASK);
> +	max77686_update_reg(i2c, MAX77686_REG_BUCK4CTRL1,
> +		RAMP_VALUE, RAMP_MASK);

This code is unclear because RAMP_VALUE looks like a constant that has
nothing to do with ramp_delay when in fact it's actually this:

> +#define RAMP_VALUE (max77686->ramp_delay << 6)

which isn't constant - this is why I queried this last time.  Just
remove the define and write this out directly.  The way the code is
written at the minute it looks like ramp_delay is just stored and not
referred to unless you go searching around the rest of the driver.

--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuMBOAAoJEBus8iNuMP3d738P/1qxAQHycb5hE5qBSc1TzcXb
ZIGlT5TWxb0u+xDq2QbDgsqJWcwO576OlGaxhEKpflFqguJDJORaGKhWJXW+f+bm
Lt6Q49JE76NX+sUdwn7JXa3G07KDqzHu9i722/juOUpILoNFrwRzL3rSUID+Qn1F
mYrnKtWZZejqtXQ3h/6B0b+bxy03HbC2EBcoDbmyY5/3JPxFTYJC069+Nh1p3Sv/
tIXuBdn2ShgQcgsKC25rVAihRvwpU5BPYGmSxG14A2PgeoKH20/XkAlPyURv6ize
CjOghnjJRwwRO4ESbDN11Eb4UYjZF29PKbr6VwCxYMQ2z5OiDJOSjFrbvSmKqyuf
DInT5oodESo6sy+BoPOZXEeHQkHJoBODcEVBu7M5UAai1JBG6ALEWaezJAqI6dKb
Wf0O/QSORQ5Gptq10jRt7HF6ez5VWP7+FfRwIdEhdhRV7q+UnLfYPMJpAOoCJkHX
Sv7/ZCyot05wtKKrDPZ27xrA61EJqG6lOUirNsfrqIkvFJOZAETLqPxunnUnPFP4
wSC/5ZMnmhXM25TqdQ5sCycTmO8H+K3u3yVEWKJxjlZiO300Jtrv9iA6Ta7ckoQ6
iQ/sBKI64WQz+1kqN78V4ZKS2G6AgMLaDqShT4jKtdrbwjelPajrSq1KiDrNhSm9
ci/aN6kl2R/KLTiaZDn3
=gDAk
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--

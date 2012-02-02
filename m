Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2BBMsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:48:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56663 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797Ab2BBMsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:48:31 -0500
Date: Thu, 2 Feb 2012 12:48:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 2/7] MFD: twl6040: Convert to i2c driver, and separate it
 from twl core
Message-ID: <20120202124828.GI7428@opensource.wolfsonmicro.com>
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
 <1328185019-29575-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lqaZmxkhekPBfBzr"
Content-Disposition: inline
In-Reply-To: <1328185019-29575-3-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lqaZmxkhekPBfBzr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 02, 2012 at 02:16:54PM +0200, Peter Ujfalusi wrote:

> +static int twl6040_i2c_read(struct i2c_client *i2c, u8 *value, u8 reg)
> +{
> +	struct i2c_msg msg[2];
> +	int ret;

May as well convert to regmap while you're at it, saves some code and
will get you access to the regmap features - you have to make updates in
all the relevant places anyway.  We should be pushing to remove use of
the ASoC level code for register cache and whatnot to cut down on code
duplication (especially for MFDs where it has a few issues interacting
with the MFD) and this seems like a good opportunity.

The calling convention here seems a bit weird too, you've got value then
register but normally we have register then value for I2C/SPI devices.
Except when we don't :(

> -module_platform_driver(twl6040_driver);
> +static int __devinit twl6040_init(void)
> +{
> +	return i2c_add_driver(&twl6040_driver);
> +}
> +module_init(twl6040_init);
> +
> +static void __devexit twl6040_exit(void)
> +{
> +	i2c_del_driver(&twl6040_driver);
> +}
> +
> +module_exit(twl6040_exit);

There's module_i2c_driver() in mainline as of the last merge window.

--lqaZmxkhekPBfBzr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKoYWAAoJEBus8iNuMP3dkiAP/0NnSs+t33Pckw9USyUb1Qup
eTZVQmiVS33bLIIWHHs0lxV3TNURQjJsGEQp5g3gJ/MVPwhNh2eVNrxV7N0a8v6z
lOc9Bl998OT71NRiE9It472BPSsWI4+kRkqpDyLeP1I8WQSJm7HKouBDcIq+zdAT
tbCy0VpBpfs5URpaPCbqZKNeS9mWrgjknJlJKxCfz9l82g6TsPU09HJ5GZvhR8jU
jufX3iWP5EyZXJAMn5qUl44uPTPZHZzVleEvMTKe5IoQC6ldofhg6hCJG9//KElw
lp4GfwPI5t0EDreUbGlJZoiDURKRvaeCiSRe2q89ye2frCJp4UPOaYhGRZPAG2JV
ICfMy9PAXv0EDJP0yeU9FMSs6CPYshRkkHVhYUWf1z1BGb46zr+eBCU9rWiAPAwH
kvbq7D4ByrGio6LPxBU33P5oN1GFfYME4EacwZhwoEHRLyLBitzE/ZNZ5P3mmK1z
migq4HmRv1GdpbezaYgEGPLawfxkZq6CfwDJclPIhRpj5Iov7n8x2Os/9RcdiDtP
ysb+IB6GgjM8LOIina/yp9xt7bfr1XcvI0j95MA3vMVK9Zf1A9hzDQuuZ/Sd9aA4
mQtYrCFsJtjzgZmaFeRYN/Tx8Huz3e+RxFrqzU+/vyZar+3GfSRrhSg2jpRTSp5r
XkXLfpHAnIMApKp2nN73
=vrEi
-----END PGP SIGNATURE-----

--lqaZmxkhekPBfBzr--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2LSJLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 04:11:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45202 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945Ab2LSJL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:11:29 -0500
Date: Wed, 19 Dec 2012 09:11:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: lrg@ti.com, perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: dapm: Fix the unpaired runtime_get/put cases
Message-ID: <20121219091127.GL4985@opensource.wolfsonmicro.com>
References: <1355913397.17896.10.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KjSGHOmKKB2VUiQn"
Content-Disposition: inline
In-Reply-To: <1355913397.17896.10.camel@cliu38-desktop-build>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KjSGHOmKKB2VUiQn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 19, 2012 at 06:36:37PM +0800, Chuansheng Liu wrote:

> But some devices has been set to STANDY bias directly during device probing,
> such as cs42l73_probe():
> cs42l73_set_bias_level(codec, SND_SOC_BIAS_STANDBY);

> Then it will cause runtime_get() not be called but laterly runtime_put() will
> be called. Also found some other uppaired cases.

This is just a bug in the driver, if it's idle_bias_off then it really
should be starting in _OFF or at the very least starting actually in
_STANDBY (including taking the runtime reference) rather than partially
in _STANDBY.

> So here add new flag get_runtime, and the logic will be:
> 1/ when device is from off to non-off bias, runtime_get() will be called if not yet;
> 2/ When device is off bias, runtime_put() will be called if runtime_get() has
>    been called;

This is really not a good idea at all, it's just adding new special
cases and making the code more obscure.

--KjSGHOmKKB2VUiQn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0YPTAAoJELSic+t+oim9hqMP/2l1ssTb35Vs8asi4E3anOMy
iOs6WNQ6mk7hhDeJrfv4RXLO8+u40c7N9jE1RluGjollfBfyhvjrME5LlVFc2M8P
ADEqt8x1IcZMPBMphYo8qPn6PdoQEwKWZSmS3XICC03NuYSQTR8v08hVWHdWAKZ+
tXYD0ucmUwr3MtZbT2OXOlsi+YIujTdW/XU3ysB8GbrEwUSl5FA+ErlkXQBTE5mX
XvYmix+UpmBSpgStCjJ17ZLJS55uswGHNLRD2Ic9PPpX97ruoiLQtb5HWPf3qCOI
PeAXHFBVHbnkab55v9+joAYwCuvEikO2D3xsXaxCPaApzlNRrJdpnn3y5Vcdu8lK
U7dSQIM21h1UP2hBbV4qj/2Qq+5oCvAr7tz8Ypuy0ngxe3CMYvwTQj6By9reuVy9
ekHvG0q3xW0T8mzDik0RN8xzFhI/pqcJ1uXGANhtkG1NnvyZIGCLRogA2XsOPfdN
Kc3utWmdY5ljAHqLe4rijnsN6sssykU9zOfnB3Nk+3IoBb1j8TCsteJcam+gIS4l
28h2sDV1A3d94o97ZTaz+QqDehj8g+HkWPWeAecaJI8ZAEmKI2D5cuH9vxhORAAX
WRI5ZJWKOaCIqkdGA2oZqVgymCdAtyRmw94ZtgBVfmKP+q+2NGroVcsAZZRv8+eX
dVE3wVpSGF2r8vl4NpLa
=mott
-----END PGP SIGNATURE-----

--KjSGHOmKKB2VUiQn--

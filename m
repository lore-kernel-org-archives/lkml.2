Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2GZLvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:51:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40267 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251Ab2GZLvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:51:03 -0400
Date: Thu, 26 Jul 2012 12:50:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 20/21] ASoC: codecs: Enable AB8500 CODEC for Device Tree
Message-ID: <20120726115055.GD3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-21-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UvwuEPigQXXfOf7G"
Content-Disposition: inline
In-Reply-To: <1343298534-13611-21-git-send-email-lee.jones@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UvwuEPigQXXfOf7G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 11:28:53AM +0100, Lee Jones wrote:

>  drivers/mfd/ab8500-core.c               |    1 +
>  include/linux/mfd/abx500/ab8500-codec.h |    6 ++-
>  sound/soc/codecs/ab8500-codec.c         |   79 +++++++++++++++++++++++++++++++
>  3 files changed, 84 insertions(+), 2 deletions(-)

Yet again no binding documentation....

>  	{
>  		.name = "ab8500-codec",
> +		.of_compatible = "stericsson,ab8500-codec",
>  	},

Why are we doing this?  The MFD cells are a totally Linux specific
thing, there's no reason to represent them in the device tree unless
they're in some way reusable and the "ab8500-codec" name suggests that's
unlikely.  Just put the properties on the parent node and instantiate
the MFD cell as normal.

> +	/* Has a non-standard Vamic been requested? */
> +	if(of_get_property(np, "stericsson,amic1a-bias-vamic2", NULL))

Coding style.

> +	if (!of_property_read_u32(np, "stericsson,earpeice-cmv", &value)) {
> +		switch (value) {
> +		case 950 :
> +			codec->ear_cmv = EAR_CMV_0_95V;
> +			break;
> +		case 1100 :
> +			codec->ear_cmv = EAR_CMV_1_10V;
> +			break;
> +		case 1270 :
> +			codec->ear_cmv = EAR_CMV_1_27V;
> +			break;
> +		case 1580 :
> +			codec->ear_cmv = EAR_CMV_1_58V;
> +			break;
> +		default :
> +			codec->ear_cmv = EAR_CMV_UNKNOWN;
> +			dev_err(dev, "Unsuitable earpiece voltage found in DT\n");

The platform data code picks a default, can't the DT code do the same?

--UvwuEPigQXXfOf7G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQES8YAAoJEBus8iNuMP3dwT0P/0QsSbEgelm7n6tociwR5ajK
p0T8qOAzbVHeg3n3C4ZSEXlE5X57NtwN0LzGJ6GPthhORRXZ1crPpkpGmFrJb+X5
JZr1bQ4xWc3LV7JkoPr9YFe4VcuqKgDXZqU2WtxsL4x0lMid4yDn0Y/zGn0VnRbe
yW8cIiW87AOEcVlSALPc53W3EGCIOCJfpV+AX+RDbv2I5FqssLOAUg85a0E9bgiE
TSwr4XQb/oQGJK8OeaBmU+sXx+qiKuPN8QsID0FQjrDwX5jkoAb5YUU0SqQCmmkZ
Tkry956vHmpxdZKKZlFoj6IbZLHaZTYckDkgKi3XsDZ0Z1CFH+Ho20X3dIBfQuZj
qnO59SB46kmFSv+8690lNUl6g2wR6unN0Y+CHONBrmM07GevJ480cJXb/ftFttuP
TkG/Y6MZQa5vcBe3qYGhHvAQGkf3epxX4O8SvSh6/4Ap32EvIgMwLmXPsoa4En+O
MqdWsOF5xbpTV3qEvDbnP/9EPjEF/RVqGtVE6A2krAPg+FDwU1pXZAPqxsM4gcOt
uBuI3+9NPI5WP2XjA1cxYB5nM8Ah0addFoJVmz2tv9/d6HsfSZ5BONx+WY6Ow6up
W7ue4OgppScNn9K01dipYp0LoRrKlHs2P65/cOe3va8plz26pH+xlblMCVxKihkB
cGf0vVd+vAIgfFcgNDQk
=TwLY
-----END PGP SIGNATURE-----

--UvwuEPigQXXfOf7G--

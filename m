Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab2CALRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:17:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47982 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757529Ab2CALRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:17:47 -0500
Date: Thu, 1 Mar 2012 11:17:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v5 2/2] Regulator: Add Anatop regulator driver
Message-ID: <20120301111744.GC3124@opensource.wolfsonmicro.com>
References: <1328734286-30091-1-git-send-email-paul.liu@linaro.org>
 <1330593052-15184-1-git-send-email-paul.liu@linaro.org>
 <1330593052-15184-2-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Content-Disposition: inline
In-Reply-To: <1330593052-15184-2-git-send-email-paul.liu@linaro.org>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 01, 2012 at 05:10:52PM +0800, Ying-Chun Liu (PaulLiu) wrote:

> +	if (IS_ERR(rdev)) {
> +		dev_err(&pdev->dev, "failed to register %s\n",
> +			rdesc->name);
> +		kfree(rdesc->name);
> +		return PTR_ERR(rdev);
> +	}
> +
> +	return 0;
> +}
> +
> +int anatop_regulator_remove(struct platform_device *pdev)
> +{
> +	struct regulator_dev *rdev = platform_get_drvdata(pdev);
> +	regulator_unregister(rdev);
> +	return 0;

Looks mostly good but this leaks rdesc->name which was allocated with
kstrdup() in the probe() function.

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPT1rJAAoJEBus8iNuMP3dPD0P/2iDzqHOvLalOGtBg1oo/Lsf
IW3X2YtfGLE2Nm4vSdKrEfVHe7Z9GPviMATT3MlZY1DKlSEEZiCWw5fFS49wmH5Z
EEaonu/ijmDtcl2OjcKISnAtWiZCcuJzsl16OSarlZcM/YKBFPAtawdXbKUWn8SH
L9uGs5iWXU8dW+oGBhzRFoSJ3RW6xNBwAaQR4hL3iCU5hV784jfpTiBHiHftj1hm
xYmiXzGp7eL1mNeG2quBzcQpIxzgidW5LZR6suk5/Ycb8H90kX6QJiLFVZg2MuxO
NHTZ7KoGOVDfGsZ3ejd2yYgBlxvGlcf4PCVCYknkB4amCxGTJ0vqWKEii8cJljoX
HHZZeICPuc3/9bInInwi5weaVQGic/F0WmJx0WmKz4KqaGmEL5CEt8medH8Bdiag
2DTF5ShAF7I0i+Mk1CUyxFhNOyoCLVQeVguCWNve9NcKEcYileUunzRmza8GoD6j
JayOlpPUhj9F6Z26/z1JPJB2fNtJXNjCHOU9tr4bIy/VRep5ZnYOgfacTUe36Wal
i7aShLEysOLtKcmuHWMVujvcvv4C4YkLOwOJNltmXKplOyIkBg4RbpqrXzZRH1AJ
Ls4ejNVGCaY6zoR1nCfhaSXXFovP0iMUQwmXbUz7kVr57wk4HysgxgyMsKEQf+R+
2AA/2WbNp2gxDL0aw/2r
=Ewm2
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--

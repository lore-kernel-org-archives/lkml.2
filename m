Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578Ab2FUWwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:52:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45132 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760482Ab2FUWwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:52:36 -0400
Date: Thu, 21 Jun 2012 23:52:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120621225231.GB4037@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <201206211717.46142.arnd@arndb.de>
 <4FE35A78.60003@wwwdotorg.org>
 <201206212103.29517.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mBuDz+cd8w/hvK2v"
Content-Disposition: inline
In-Reply-To: <201206212103.29517.arnd@arndb.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mBuDz+cd8w/hvK2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 21, 2012 at 09:03:29PM +0000, Arnd Bergmann wrote:

> The board specific settings on the other hand are about what to
> put into those registers and what voltage to use. From all I can
> tell, those settings belong into the node that actually uses the
> regulator, not the node that defines it.

This doesn't work.  Each regulator may be used by multiple consumers,
the configuration is for the supply as a whole not for an individual
user.  The main service the API is providing is arbitration between
multiple consumers and the physical capabilities of the board.

Due to the fact that the binding of the device has to be done by the
board you'd need to replace the regulator-compatible value with a
phandle pointing to whatever nodes the .dtsi defines (and which would
need to include some string as well so we can bind code to it).  And of
course if anyone wants to use the device on a non-DT architecture we'd
need to replicate everything in code anyway.

--mBuDz+cd8w/hvK2v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP46WoAAoJEBus8iNuMP3dK+IP/3SSfLIKAiMuCb0sbxgMMXqS
fVtfNSjNOQSWCratur6ma2TOS3nbwtIHk6x3E31t/V85rGZ/uOzFP6EdwaJh9f0B
NTB/xtd7MVWmm2XRWNfnGGqTcq4ZXXL1HImTm1J+oI1q6KgMvmIja63fO9Zh1GQP
jNmPvNIzejEPIZmcW8Px4sP4G6BQ8KNo03PIAk+0IFcsZqIYuV0aG3h3VOKVbFXn
Cli8T2DHybxlgw80MpE2FeLVooNdxtHqM0L2VCAcDoXqGUu9cWjVuX9VeQDi83cg
jfwnKw9p9D23VRIeGJlUpDrGYmSWoBkJiPC9QWDg4tDg0XtqTYuySaqFz5IBnVp7
gTN62VCIVD1ABd1eNKKhoMz6HyVnMP3gTTsp729CcWkbq2QqxFn1fzyJt1pSJV/D
tOjsp/shAZNu9AHZmiNSbR/oK1tWqo61V7+54mweHsjXMWnrK2mSnaUoD2qCVysK
cTK7aWKi3mq+HiG+NUqs0+HMj01dYeJS333A0YGKNLXJ7NPgOv0rVwwvRArfpVD+
Zd2eUxLq/oKMaYy0gOjZUhnDKh/+m7zZriLYrHxiPgOQ/FgpSGQLYuWruokYpgDk
Q2VKT9/pA76EXL+DzJ6EU5hbuP0wwc8dCZ7RhYRRHyYTtAescls5sF71YkGXUIGB
nycXNjzuWOJ6xrlmBt2E
=lzOV
-----END PGP SIGNATURE-----

--mBuDz+cd8w/hvK2v--

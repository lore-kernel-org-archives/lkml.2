Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab2GASXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:23:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37570 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755476Ab2GASXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:23:03 -0400
Date: Sun, 1 Jul 2012 19:23:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH v2] regulator: fixed: support deferred probe for DT GPIOs
Message-ID: <20120701182300.GE28922@opensource.wolfsonmicro.com>
References: <1340987595-11288-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4YaMMRm3dfitt/ta"
Content-Disposition: inline
In-Reply-To: <1340987595-11288-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4YaMMRm3dfitt/ta
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 29, 2012 at 10:33:15AM -0600, Stephen Warren wrote:

> of_get_named_gpio() needs the driver hosting the GPIO that the DT
> property references to have been probed. Detect this specific failure,
> and defer the probe of the whole regulator until this API can complete.

I've applied this but...

> +	/*
> +	 * of_get_named_gpio() currently returns ENODEV rather than
> +	 * EPROBE_DEFER. This code attempts to be compatible with both
> +	 * for now; the ENODEV check can be removed once the API is fixed.

...this just seems rubbish, why aren't we just fixing the device tree
code and why are we doing this at the device tree level rather than as a
general gpiolib thing?

--4YaMMRm3dfitt/ta
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8JV+AAoJEBus8iNuMP3dEnsQAJTdXRngXoFqFY6kXb77HDhJ
fTPZps3mCRprop38VyltH1W4roVRGkp1g/djKIS5UpjOFWNTYDQGZbua8P+bZvcR
mNfIweLH0l30UtKEj9FJ5GwXENcLTqcPYO5EcWtjXWux5/EmIY/QWRBjIX/DyYsK
dtm3ecaD5HU2Vp12b+Nl932QjYnQVRCOwdw10D4XgDMIdMSxUReDBsLw+sL2wHVM
oRcEf+xwOgV7XqXWv+1V+v1aCLlWOEOK9agdTPKi1Xof6VVLvAUeH0JwOFm8Qet9
PuxzjQ/8yadvI83zASqjQq5XrrP1AAKABpIitdCMDqxqrbqggdZrMJt7bvsALFjk
FWwjK9sfTg1j+YJ6UQcOlDe3J6Cm7wD/teJ9x17noWjq4t2fta70jSAKQh9y3uu4
yof9kR49AtDU1CoWpDuhT0kwLIlYUY/QweLhR9bHcNT74cbQj7QXKpX+Fg5RqqyA
5q1Df2fuPTdq7cTnTu0JLJy86HBn9lsBV2nfSXTjZjmpnMNC7qLNzNrWT+FUceSL
7U7XJD546huuHq37Apj2MECgjiNGoj7ENGXLf3YW6JNms0PWqhMzobcs4EvQT7/J
dxw7Jx6184qO2FA5pOETz1bWjuzzx0GUqzhJHv88LwwXEmS7YGG0QBB1o0FQAcQa
tNbSTM1r/ajXDr1HnQia
=yrw1
-----END PGP SIGNATURE-----

--4YaMMRm3dfitt/ta--

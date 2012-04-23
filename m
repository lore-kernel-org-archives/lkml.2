Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2DWSBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:01:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54485 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637Ab2DWSBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:01:44 -0400
Date: Mon, 23 Apr 2012 19:01:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
Message-ID: <20120423180140.GR8318@opensource.wolfsonmicro.com>
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>
 <20120423101804.GA8318@opensource.wolfsonmicro.com>
 <4F953455.3080002@stericsson.com>
 <20120423110522.GB8318@opensource.wolfsonmicro.com>
 <4F95495D.4050508@stericsson.com>
 <20120423122555.GM8318@opensource.wolfsonmicro.com>
 <4F954ED6.2040201@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E1BPhOSoTthPQdPL"
Content-Disposition: inline
In-Reply-To: <4F954ED6.2040201@stericsson.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E1BPhOSoTthPQdPL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 23, 2012 at 02:45:10PM +0200, Ulf Hansson wrote:

> A typical mmc host driver is when finished it's probe routine,
> trigger of a so called mmc_rescan work which is taking care of
> detecting and initializing the eMMC card. It is a quite complicated
> procedure which preferably not to be handled from the host driver's
> probe function.

> If the platform already have booted from the eMMC card, the card is
> already powered an initialized from a bootloader. Cutting the power
> without first notifying the card by sending commands to it, must be
> prevented and also violates the eMMC specification. In the end, it
> will mean that the detect and initialization procedure fails.

Can the driver use is_enabled() in the probe routine to check the
current status during probe and hand off appropriately?  The issue here
seems like it's the fact that the driver isn't managing to bootstrapping
of its state well.

Worst case seems to be that the card will be briefly powered during boot
then turned off again after enumeration which doesn't seem like the end
of the world to me.

--E1BPhOSoTthPQdPL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlZj9AAoJEBus8iNuMP3dVxAP/iWVMZTKFJ7H65Rfe78kF12Y
b5Mhx42z+M/+YXS+0OUaEPMqkge7kFbjCZ/WKC7himtxuSk990nL+eXWI+zkP7FB
mjxxxBwVV60YS/h5HfU0Za/g4YFLCUSLzLFHwRsReGHvNQB8LE5YPczPgO0Zmsc6
K72vtiObXr6V/s6XMw+75+W9Z4c/cuaoybBVbSXkt4nM/7cJXMBDyum2eyXzaTcR
Brh7Ql0az9pOSltQ1sJWK8yQytCFROCUrvu5QOz+H08my0UHcMScXyx3Gf6xIqnA
LXbHDZxuJvPSw956sSBfPfGZl4fZBLuKjNd/B1PDnJJj1kmOUN+ccZRJy0AutUV9
D6ryaAnx9/lYsQk313j7tQudb95gzRXGrsLyzuuou+wGeZr40250Qu5dcv9yNV49
uKyOtYTfwFbCkN6QytnMt1c1OekL9K79wMpOcFSW+qvNqyt5g8tpmZBRcpHNw36P
vX+WXGjcREAf1xQMT0cwwqMUS5XHE+3aHhNOP9cA8NpigC6zPGF9UqXm0ezC35at
0+/4ojga2/8FbJeugbjSe3BpXCHXdFR8ZbeVuaumQtzNa7zwV//BXzE470C3M0EC
p8dh+AlsdhoNLkyicGesS8ekhbB6LhOGSlbQmerapXcGlroLAdPtsdfipzHMuqif
vAILggygmrc/uFzxZCK7
=606i
-----END PGP SIGNATURE-----

--E1BPhOSoTthPQdPL--

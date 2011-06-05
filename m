Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1FEG44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 02:56:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48454 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab1FEG4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 02:56:46 -0400
Date: Sun, 5 Jun 2011 08:56:39 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cbouatmailru@gmail.com, cjb@laptop.org,
        grant.likely@secretlab.ca, arnd@arndb.de, sfr@canb.auug.org.au,
        patches@linaro.org, Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] mmc: sdhci: change sdhci-pltfm into a module
Message-ID: <20110605065638.GA30268@pengutronix.de>
References: <20110601130431.59f4f0d4.sfr@canb.auug.org.au>
 <1306983470-18588-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <1306983470-18588-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 02, 2011 at 10:57:50AM +0800, Shawn Guo wrote:
> From: Shawn Guo <shawn.guo@freescale.com>
>=20
> There are a couple of problems left from the sdhci pltfm and OF
> consolidation changes.
>=20
> * When building more than one sdhci-pltfm based drivers in the same
>   image, linker will give multiple definition error on the sdhci-pltfm
>   helper functions.  For example right now, building sdhci-of-esdhc
>   and sdhci-of-hlwd together is a valid combination from Kconfig view.
>=20
> * With the current build method, there is error with building the
>   drivers as module, but module installation fails with modprobe.
>=20
> The patch fixes above problems by changing sdhci-pltfm into a module.
> To avoid EXPORT_SYMBOL on so many big endian IO accessors, it moves
> these accessors into sdhci-pltfm.h as the 'static inline' functions.
> As a result, sdhci.h needs to be included in sdhci-pltfm.h, and in
> turn can be removed from individual drivers which already include
> sdhci-pltfm.h.
>=20
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

I am a bit confused how to review this patch and patch 1/4 from Shawn's
original series. As Chris does rebase his mmc-next anyway, does it make sen=
se
to squash this into the old ones to prevent the broken inbetween state?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3rKKYACgkQD27XaX1/VRvyuwCgxE/tKTg/JuKDrd5G/4ZOlBf6
EwoAn0FtSGBH97xgcggNI5oQmUUbsa3E
=tOLJ
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--

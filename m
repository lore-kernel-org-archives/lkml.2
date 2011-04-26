Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab1DZNUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:20:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39733 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab1DZNUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:20:44 -0400
Date: Tue, 26 Apr 2011 15:20:34 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, linaro-dev@lists.linaro.org,
        sameo@linux.intel.com, patches@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] consolidate sdhci pltfm & OF drivers and get them
 self registered
Message-ID: <20110426132034.GB2446@pengutronix.de>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <20110419102031.GA4164@pengutronix.de>
 <20110421074818.GC4024@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <20110421074818.GC4024@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

> > The approach seems sensible, so have a look at my (mostly minor)
> > comments inside the patches. However, there is one bigger piece missing.
> > You converted all the drivers which had a seperate source-file and
> > hooked into sdhci-pltfm.c. However, those are only those users which
> > need additional code to work around the quirks. There are also users
> > which can take the plain pltfm-driver with a properly set
> > platform_data (check the thread "[PATCH] mmc: add SDHCI driver for STM
> > platforms (V2)" for an example). Those have to be converted, too.
>=20
> Even those drivers need pltfm-<something>.c to accommodate the
> platform_data, right?  I think sdhci-dove.c (sitting on mainline) is
> also such an example.  So if I'm not mistaken, I did take care of the
> drivers which can take the current plain pltfm-sdhci driver.

I stand corrected. I assumed the STM platforms did hit mainline
meanwhile, but they did not. There really doesn't seem to be one user of
sdhci-pltfm without using workarounds. (will make sdhc v3 make it better
or worse? I get fears...) So, everything OK with your series.

> > Now the discussion could be if every of those users gets its own
> > pltfm-<something>.c or if we create something similat to
> > sdhci-pltfm-generic, which can also be setup with platform_data like the
> > old driver (/me likes the latter a bit more. If we don't change the name
> > of the driver (not talking about the sourcefile) and keep it
> > "sdhci-pltfm", then you wouldn't need to change all those users if you
> > ensured it behaves the same.
> >=20
> Since there are already pltfm-<something>.c to hold platform_data for
> those users anyway, it's not an argument here.

sdhci-dove needs to overload readw/readl. If there is a user not
needings such, i.e. only plain quirks (or even nothing, what a dream!),
then a generic driver might be worthwhile. Can wait until we see such a
user, though.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk22xqIACgkQD27XaX1/VRsR0gCfRgIYjL9bbkjWlK1gBIcyWmc8
M/8AnRsKHefIc4HUrjsQMyA/Pw2g4z/2
=ww1+
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--

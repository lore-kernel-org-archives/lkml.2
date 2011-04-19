Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1DSKUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:20:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51348 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab1DSKUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:20:30 -0400
Date: Tue, 19 Apr 2011 12:20:31 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 0/5] consolidate sdhci pltfm & OF drivers and get them
 self registered
Message-ID: <20110419102031.GA4164@pengutronix.de>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

On Fri, Mar 25, 2011 at 04:48:46PM +0800, Shawn Guo wrote:
> Here are what the patch set does.
>=20
> * Remove .probe and .remove hooks from sdhci-pltfm.c and make it be
>   a pure common helper function providers.
> * Add .probe and .remove hooks for sdhci pltfm drivers sdhci-cns3xxx,
>   sdhci-dove, sdhci-tegra, and sdhci-esdhc-imx to make them self
>   registered with calling helper functions created above.
> * Migrate the use of sdhci_of_host and sdhci_of_data to
>   sdhci_pltfm_host and sdhci_pltfm_data, so that OF version host and
>   data structure works can be saved, and pltfm version works for both
>   cases.
> * Add OF common helper stuff into sdhci-pltfm.c, and make OF version
>   sdhci drivers sdhci-of-esdhc and sdhci-of-hlwd become self
>   registered as well, so that sdhci-of-core.c and sdhci-of.h can be
>   removed.
> * Consolidate the OF and pltfm esdhc drivers into one with sharing
>   the same pair of .probe and .remove hooks.  As a result,
>   sdhci-esdhc-imx.c and sdhci-of-esdhc.c go away, while
>   sdhci-esdhc.c comes in and works for both MPCxxx and i.MX.
> * Eliminate include/linux/mmc/sdhci-pltfm.h with moving stuff into
>   drivers/mmc/host/sdhci-pltfm.h.
>=20
> And the benefits we gain from the changes are:
>=20
> * Get the sdhci device driver follow the Linux trend that driver
>   makes the registration by its own.
> * sdhci-pltfm.c becomes simple and clean as it only has common helper
>   stuff there now.
> * All sdhci device specific things are going back its own driver.
> * The dt and non-dt drivers are consolidated to use the same pair of
>   .probe and .remove hooks.
> * SDHCI driver for Freescale eSDHC controller found on both MPCxxx
>   and i.MX platforms is consolidated to use the same one .probe
>   function.
>=20
> The patch set works against the tree below, and was only tested on
> i.mx51 babbage board, all other targets were build tested.
>=20
>   git://git.secretlab.ca/git/linux-2.6.git devicetree/test
>=20
> Comments are welcomed and appreciated.

First of all, thanks _a lot_ for doing this! Many people have promised
to do such an approach, but you finally made it!

Sorry for the long delay in reviewing it, I didn't want to rush a review
so I needed some time for it which I didn't have much in the last weeks.
Let's hope my battery will have enough power on my flight back to
Germany ;) So, this is for now a purely "visual" review. I hope I can
check V2 on real hardware then.

The approach seems sensible, so have a look at my (mostly minor)
comments inside the patches. However, there is one bigger piece missing.
You converted all the drivers which had a seperate source-file and
hooked into sdhci-pltfm.c. However, those are only those users which
need additional code to work around the quirks. There are also users
which can take the plain pltfm-driver with a properly set
platform_data (check the thread "[PATCH] mmc: add SDHCI driver for STM
platforms (V2)" for an example). Those have to be converted, too.
Now the discussion could be if every of those users gets its own
pltfm-<something>.c or if we create something similat to
sdhci-pltfm-generic, which can also be setup with platform_data like the
old driver (/me likes the latter a bit more. If we don't change the name
of the driver (not talking about the sourcefile) and keep it
"sdhci-pltfm", then you wouldn't need to change all those users if you
ensured it behaves the same.

Also, I think the next version of this series should have all makers of
a sdhci-pltfm user CCed so we give them a chance to report breakage. Or
donate acks or tested-by.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2tYe8ACgkQD27XaX1/VRsCRgCgkp+BmJJsLsKllKL0OI/BnO9F
PRkAn1BpnXBv1exnkJFlqFAPe5O2Yt8w
=GSqA
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--

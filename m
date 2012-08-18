Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2HRMBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 08:01:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34657 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219Ab2HRMBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 08:01:41 -0400
Date: Sat, 18 Aug 2012 13:01:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, khali@linux-fr.org,
        swarren@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: Fix ifdefs for suspend mode
Message-ID: <20120818120138.GD21888@opensource.wolfsonmicro.com>
References: <1343655187-18282-1-git-send-email-ldewangan@nvidia.com>
 <20120818070732.GA24639@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
Content-Disposition: inline
In-Reply-To: <20120818070732.GA24639@pengutronix.de>
X-Cookie: There was a phone call for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 18, 2012 at 09:07:32AM +0200, Wolfram Sang wrote:
> On Mon, Jul 30, 2012 at 07:03:07PM +0530, Laxman Dewangan wrote:
> > CONFIG_PM covers runtime only PM.

> I am a bit confused by this description. CONFIG_PM_RUNTIME covers
> runtime PM, no?

The issue is that CONFIG_PM doesn't actually enable any of the PM
callbacks, it only allows you to enable CONFIG_PM_SLEEP and
CONFIG_PM_RUNTIME.  This means that if you use CONFIG_PM to protect your
system sleep callbacks they may end up unreferenced if only runtime PM
is enabled.

Personally I'd rather just uncondtionally enable PM rather than faff
around with all these ifdefs...

--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQL4QbAAoJEFJkBDiqVpZ46fgP/0yCYbdqxmC9w27xts5RG3ZL
UIv7Kl/dTQLcuj0JSrlXUpLNc7DrZnmlCDoa2jVnEifkUae/KkCUAfc+LrQ5rmg3
6qbKNwfCNWlPBHUN7TPRhzKNAi10vGxy9tWlxERJrSMqamRapzkadY1vfEEnuQDS
IBratNP7eT0gfGqVyNTvXFvDSgRyHb8RzSP0kRuRfn7azeqjq/hnCTENbX9N341x
ID+auG12uvhWwtGscRb4iHN0a+RJPJhLRwneKIPcRtaSK4KQa2gpeEdstPXYgm1u
VwneDN5P5GtPdTNCtOaJ9op/2tQCUk9nEIdurv1s3B6z24zZ1XMOynkOa7Vblx5+
LTUEM7XddkWWTYFcILkY16gwlXrHPqKKTcOo8bxx944aRckdsVU02DQrVjMDlwqR
R5ACsNOK8pHntZjFTY3q+Djm7bL2Jb1xzsK94iSoWAlzm2PLiK8TiEeVED0NZ2PG
WJBbZ2OxVYdlCM0yzWtx8CRivZeJ4/yUZ/ZDCY70+kx6ypNbMufvDXwLFXeo2WIm
lqDs33wpm8z4YvoasW3M09JZIJiKFBz2UN1A04tdtcqUd9z5zUfi+8oV3gMhMks6
zmisF+pvGwt51MCyvbJmUDA0ArAOC3j19H97pREriEGO11ZqNgxkUMI1THh8/hL2
YYFeTm7UQXdsUKHHUObL
=iAGn
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab2FTXPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:15:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60601 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636Ab2FTXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:15:50 -0400
Date: Thu, 21 Jun 2012 00:15:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org, swarren@wwwdotorg.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120620231546.GB4037@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <201206201924.09618.arnd@arndb.de>
 <20120620194609.GA4037@opensource.wolfsonmicro.com>
 <201206202040.52291.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <201206202040.52291.arnd@arndb.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 08:40:52PM +0000, Arnd Bergmann wrote:

> But that sounds more like what the "reg" property does than what
> the "compatible" property does for other devices. In other words, you
> want to know which instance you are describing, not what kind of
> object it is.

No, it's describing the kind of object.  This stuff is for devices which
throw a bunch of irregular regulators down on a chip with no particular
similarity with each other.

> For a "compatible" property, I would expect two objects that have
> the same register-level interface but are responsible for different
> physical objects to have the same "compatible" values, but here
> you specifically need distinct "regulator-compatible" values.

There's nothing stopping a driver drilling down deeper with other data
once it's worked out what it's talking about, if it wants to read an
additional id value or base register that's absolutely fine and probably
even a good idea.  The problem is that for a lot of hardware there's
just a bunch of random irregular devices.

> It makes much more sense now, so please let's make sure that explanation
> ends up in the changelog.

To be honest I just don't care, the old code hasn't been around for long
enough or widely adopted enough for anyone to care and it's just more
brain cycles gone.

> * What is the difference between "regulator-name" and
> "regulator-compatible"? Those are the same most of the time
> in the patches, so can't we just make sure they are always the
> same, and drop the confusingly named "regulator-compatible" one?

As the binding documentation says the former is a display name for use
so people can tell what the software is talking about, for example the
name the supply has in the schematic.  It's completely up to the user
and the regulator driver can't use it for anything except printing so it
needs something else to help it figure out what it's working with.

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4lmcAAoJEBus8iNuMP3dZLsP/0xUaKATocQynuWA32+80mPb
fy2rzkM3XKQBCFug7GVvTuy/VtDkcu5f8XwnVMppRqz/MNEK5KmnroL2FZRRa0kC
oVCdB9gnHUxTv+YIALXhvYsLlaH7Fclhz5NdpWJv9hFAtMf44MPYnzUbdIv12gs9
FuF0KFTTCciLmqpaumKCIu9qaxMFMZlegO+BemfC04XmzLGOqUBTt2fNvQQhUC18
gOlaZ+Zry5G03Dx7OgXXc6IO+Y9ZD8b2miFasFsF+XJ/2JGR/HI0enTQ2tXgoUkl
EbYf9+6DJLxWHCJQwrNc0AHUf8FqXaZV3zKamKZeF2jE2QIiyZLv6W8JEexXhHq0
hG+ZhMpEefnboGdP9eA5+zwzgNZ7y+VEUv7qQ1DefY7x1LhUt1hrb0ImTy1Bc3Yt
HVKUo1gbovYggx5HJpifFgTVk9/H+Fnv1MSReIx/XJANh/WBwGkPYuSp+A/FD4ai
iQM8z0yjNU0GFU9qJ4/y6xuQDMN44Ll3UqfjQtvi70lvmti5mQKYwLIYs3+uiwm6
uvyhAnB3eCr4bWscjW5+zYiFwWT7C8/u1jb6gZJSTJTmsZdVO8mtRQkhNdi0iECY
9LSrz4T0KWrdJcVFV/bOLTHbEhISr08zGJfphFrn4Kc0dg2IBWuBLWCQ/kW3T1+o
Ib5MDD+qMwyxDfKQR9KJ
=ILu2
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710Ab2FUQPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 12:15:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49971 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759615Ab2FUQPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 12:15:03 -0400
Date: Thu, 21 Jun 2012 17:14:59 +0100
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
Message-ID: <20120621161459.GY4037@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <4FE23A1B.2000809@wwwdotorg.org>
 <20120620233507.GC4037@opensource.wolfsonmicro.com>
 <201206211450.35713.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eUqGrSc0O7wKBRnC"
Content-Disposition: inline
In-Reply-To: <201206211450.35713.arnd@arndb.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eUqGrSc0O7wKBRnC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 21, 2012 at 02:50:35PM +0000, Arnd Bergmann wrote:

> It seems that the drivers that are changed to use this could also try to
> describe the individual regulators completely, by moving the contents
> of e.g. ab8500_regulator_info into the device tree, but having the string
> identifier with an in-kernel table makes sense when there is only one
> such table.

I'm not that big a fan of moving all the data into device tree as it
means that you need even more parsing code and you need to update the
device trees for every board out there every time you want to add
support for a new feature which doesn't seem like a win.  Right now with
the DT kept in the kernel it's not so bad but if we ever do start
distributing it separately it becomes more of an issue.

I'm also not sure if the tooling works well for allowing people to
include standard DTs for chips and add new properties to nodes for the
board specific configuration, though I think I've seen a few things
which suggested that was dealt with reasonably well.

It also means that the driver becomes useless on non-DT systems; while
for something like ab85xx which is specific to a SoC that's not a
problem it's a serious drawback for devices which may be used on other
architectures (or older ARM systems for that matter).  I'm quite worried
by this tendency to try to just dump all our data structures into DT -
it's similar to the issues with some of the MFDs just wanting to drop in
the current Linux subdivision of the device even though that's often
just reflecting our current internal structures which do change even
without worrying about other OSs.

--eUqGrSc0O7wKBRnC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP40h8AAoJEBus8iNuMP3dl74P/3MbtY6Q2+XCRYzG8ea95n3D
fP05hJCS+fMgoPWMn5vkHx95scxBuvIy9fXPp95n4NqhuP9sreojE5YEGHwuMPzx
tOmg9h5ToHAK6NF5WI5F6lEhCvZ2f4HFXvi019XqZ4PN8nw3J4RQdqGlHUT7goEm
gCeezpJ7YAreAsSpw9oVhCE3/UrBa7QEJgqXe48V0aQFoD2JTHCbHWbW6wtsGESn
jJ0iVN6iRt7u1h1q+wHKqpfwR+bXIl50KBEOCu8GTNMZ0FkZJb586laMh7GyYQuE
kVAxj/tMredEtsV0Bh/3TEOZDF6y3Bhrui0y4mHyLj2VySrDFmGYL2eOAFF+xicO
YcerSXHhYYsFGM0B2Wl2ND+JjgmCxVyYxXf/gBZixPih2TamBWpEXO+ECojQtGo0
gLQ2psS/DZnif5MrFVWOcxloRR78AUd1IEKw3UGPXNm0CkQvznorMqVee4RWm4Wa
v0tOeZzRCT8nicUnc3YKvL1bZXjZWb0z7Myr1hiZGgXwxI95zbkcGGaleLTpweeO
yyBoIZZ6eS0JnJ6lVpZ17mY79MxRQTA+trVImwG2UmPnNhtKXW5KMj0YN5psPES8
BaHmOPOho38SZJrPCndLTStBHGPG4CweR1XHxtUSZXYfMvLd038bxqzo61ipJN+w
chI2UDG6tXzoSZA5rAeE
=e0mj
-----END PGP SIGNATURE-----

--eUqGrSc0O7wKBRnC--

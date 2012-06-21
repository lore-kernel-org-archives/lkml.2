Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab2FUF7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 01:59:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32974 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034Ab2FUF7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 01:59:21 -0400
Date: Thu, 21 Jun 2012 15:59:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>,
        "Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: linux-next: build failure after merge of the final tree
 (wireless-next tree related)
Message-Id: <20120621155911.713748370d898a113e054693@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Jun_2012_15_59_11_+1000_XayzL6eZeGWPNZfs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jun_2012_15_59_11_+1000_XayzL6eZeGWPNZfs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c: In function 'brcmf_sdio=
_dump_console':
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3085:3: error: implicit =
declaration of function 'vzalloc' [-Werror=3Dimplicit-function-declaration]
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3085:10: warning: assign=
ment makes pointer from integer without a cast [enabled by default]
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3113:2: error: implicit =
declaration of function 'vfree' [-Werror=3Dimplicit-function-declaration]

Caused by commit 4fc0d0160d59 ("brcmfmac: introduce checkdied debugfs
functionality") from the wireless-next tree. Forgot to include vmalloc.h ?

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Jun_2012_15_59_11_+1000_XayzL6eZeGWPNZfs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4rgvAAoJEECxmPOUX5FEPrAQAKgVdTQHfERIya+I+dGh6Req
CoG40ZQno1qF68NN2LYNNo+8nt5c8jyobw4ynOn/jpG8yZYr5gOqMWBmsJ1hG+Oe
t9W+kgRWTQN34fXH2mfvn5h8rZrs+AmkCESlUkitqgK/obYC99jDy9EU43TEcIct
scXy9G50XEsuM5nQ7Abar5UEBXV6Gd7OgZUpZT2FHv1pHW6nV0ypvYfTHPnFolaU
Wt0st/oat3LlhEsoJgAu7FX4N9ow0aqIWMeox9YgnA1AVgvx40xn/yBzgLh2NYst
1WPxt2Psc4uw6aUgLRzwlC9csuFksUaSIgrfm6HZp1VdxBObqR53+LmKwBOKjc45
zY+CkMjGI+1N+scmMUtkeLY+iQheMWKfmSImB26zEnNs/7NLJlVLDZ4WO1LfFdZ4
f/FfARjuY+VbJRbIVoAocpv9Mf5zGY67TW7nEtciYWEyT+4gunAQEwa/vh6+3u/P
kSWBMgn6Pv7LWeLv6o9ToaNCp5DOTVzxUW0zh8mv75Ee/CHfWIROCj7OcKTTKHsi
yHz8G4/WfVv7YKmj9U5ssLuE7fTlOoAt1fRJ2xUnv2YamcedPDxI68HJNoz64M6G
zAyacLnCD3vDCTNCPzQUe9tZdD4jTg3PJgZwjwnug0Uc4Kk2jVqj04MFajCHZtAT
W4sl1cAbwRZwCeFcMBUh
=QDf5
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jun_2012_15_59_11_+1000_XayzL6eZeGWPNZfs--

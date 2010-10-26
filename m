Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab0JZI4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:56:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58418 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752092Ab0JZI4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:56:05 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX19guU5dHhJgUdN8B0b2dKLUrhB86c/1r/N4lVSBIJ
	B3K/9T3U+TqXr+
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] Staging: batman-adv: Remove useless braces
Date: Tue, 26 Oct 2010 10:56:00 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-686; KDE/4.4.5; i686; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, gregkh@suse.de
References: <1288042994-27761-1-git-send-email-sven.eckelmann@gmx.de> <AANLkTimiMAeonjLpnuJNpeQhtdLmp+z1uqyjVfZbFmcr@mail.gmail.com>
In-Reply-To: <AANLkTimiMAeonjLpnuJNpeQhtdLmp+z1uqyjVfZbFmcr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2578595.81rSPqqHPI";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201010261056.06445.sven.eckelmann@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2578595.81rSPqqHPI
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Tuesday 26 October 2010 10:04:31 Andy Shevchenko wrote:
> It's odd.
>=20
> I've checked it before submission:
>=20
> andy@fs-test:~/prj/linux-2.6(mine)$ git show
> 77099f0afe94928b5b0066a7efa5fa9f81696b54 | scripts/checkpatch.pl -
> total: 0 errors, 0 warnings, 177 lines checked
>=20
> Your patch has no obvious style problems and is ready for submission.

The problem seems to be that checkpatch doesn't check the generated file
(because it can't), but only the lines you changed. Those braces aren't on
lines you changed and thus they will not be checked.

But also checkpatch is sometimes a little bit "odd" when it comes to file t=
ype
detection (maybe more a user problem than a checkpatch problem)...

$ git show 77099f0afe94928b5b0066a7efa5fa9f81696b54:drivers/staging/batman-=
adv/vis.c| scripts/checkpatch.pl -f -
total: 0 errors, 0 warnings, 0 checks, 895 lines checked

Your patch has no obvious style problems and is ready for submission.
$ git show 77099f0afe94928b5b0066a7efa5fa9f81696b54:drivers/staging/batman-=
adv/vis.c > test.c
$ scripts/checkpatch.pl -f test.c                                          =
                                           =20
WARNING: braces {} are not necessary for any arm of this statement
#136: FILE: test.c:136:
+               if (entry->primary)
[...]
+               else {
[...]

total: 0 errors, 1 warnings, 895 lines checked

test.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


When you call it test instead of test.c then it wouldn't find the problem
either.

Best regards,
	Sven

--nextPart2578595.81rSPqqHPI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJMxpehAAoJEF2HCgfBJntGQG8QAJPTZy7veT0tUE1K0EWhV/ff
e6OINkwGgEsR/ks9unxVw/kHmNJ024qebw2j3x7a+TSg40RwkSg+FDLwZYWQCYO0
iklBUgD/xB1nfuM8se7ETYUgO8Yb/+g+X6+b0jCPlvAhlko5f7qBfmUpYnckuJs+
Kc9AA+PQH1xPJVE5dDAXOSPefplm4vQqyFKdOEYJubtSCkDHhdu7vKPKJek2k8W/
39xGPfsTiYWxBVFRdWpIrs0YTEO1ZkU0AbXFjTyWPiEV3iZx94PdXEBLFhVJHk+g
yUE9QnTWhQTZmwWxYydNyVLoia0ZEbHNZfWlHE9rej76XL9EL8ivf+qSXfEuIOEn
ZUF3DydBBzV4Fj4/Fzn2cQeGGoyAuBZKJaAB3gFOMq0T++4dlMYTXbEQf/YZVOq3
p6FuczAG0RCQv5kMNGj1nUbbtd5hYegUntEg94rywYsYq5HBXNfYnwbmoGWY8nbK
8lPphCa7W1PN2mW9NwGyMCb/E7SxyMtbkzXgVsWl1ky1zBCQD3Jrx3kdWCxVauLx
EalDDxzLWg60YARGpD70k+ES2YYxdJ5BjKfi1dXUrLlT1yCfWudARJSK/jVwndIX
+Ncf6cFiMA3xxtPQf8eZYwZG/3IlyCzGc4ISBbRs7wDQRAIUQQ1TayXFopYr84Al
63K4RgojtxZEU9W6UTcW
=Kloh
-----END PGP SIGNATURE-----

--nextPart2578595.81rSPqqHPI--

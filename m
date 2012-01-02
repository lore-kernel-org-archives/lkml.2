Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab2ABCo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 21:44:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44409 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069Ab2ABCox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 21:44:53 -0500
Message-ID: <1325472276.13595.200.camel@deadeye>
Subject: Circular dependency between <linux/kernel.h> and <asm/bug.h> on ARM
From: Ben Hutchings <ben@decadent.org.uk>
To: Simon Glass <sjg@chromium.org>, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jan 2012 02:44:36 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-frFonc8knBtj8+a56sT2"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-frFonc8knBtj8+a56sT2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Commit 87e040b6456fd3416a1f6831c1eedaef5c0a94ff ("ARM: 7017/1: Use
generic BUG() handler") makes BUG() use BUILD_BUG_ON().  However,
BUILD_BUG_ON() is not defined in <linux/bug.h> but in <linux/kernel.h>.

arch/include/asm/bug.h does not include <linux/kernel.h> and *cannot* do
so because the latter already includes <asm/bug.h>.

Maybe BUILD_BUG_ON() should be moved out to a header of its own, or else
this particular use should be moved to some other file.  This needs to
be fixed somehow, as it obviously leads to build failures, e.g.:

https://buildd.debian.org/status/fetch.php?pkg=3Dlinux-2.6&arch=3Darmel&ver=
=3D3.2~rc7-1~experimental.1&stamp=3D1325142904

Ben.

--=20
Ben Hutchings
All the simple programs have been written, and all the good names taken.

--=-frFonc8knBtj8+a56sT2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATwEaFOe/yOyVhhEJAQpSFA//V9QKdwkwzj6lhWMiYgF0281uecaTMfKh
al3i0UFZ4dOlLY/nAdHOtKe/U46dZFqtDA2Hu06ojMbM5PYex690wyxVTKwke/Pc
LH9cEfktI3+MaAdP5e72cMTDt9+WCqJRCxIZmfzgSbaybwfHy3iSYL19cgNbwEak
1sG8oPR4+v02rM9upUqh0QPTWXs3oSXJJ4GxCypGS06RpxWXezmOn8gHAB+Lvhxr
ITP/+ByYhw2UtNd4UWNZlE7eoqhuF5zJ27iyhHxX3RqxlK08f6cqy12ylsO72aHM
ss+XdaGYWewK/ykhxLSUyIL3xnWYP6RlPUAMcIg0QJOT+jsOuVaAZw3CvAQX08Vi
8wYO1gHOR7rRGl5V4KS2aiFQtq1w9tp2RQ7e1Ks8bJUDgZ2fB7BFg021DAS1wAgK
ho7HlMGEfTAk/TlFbG2DHj8q6IpwpG2pJCYAT/cKJKJWoC1MlTEO0CoeBpYXMaL1
Zyat9ssuqOq9HlAT+ByK9wUEQY2H90rs/1aBYEwyigdAx1/Wx4dvTLewGup2ti/U
FmlQzKIvMh+kTgaw2SGPm7V38GxwOuMZLNfbFN/60fyP/A4+ODFL+WImRslHXsFe
vkQr6/tv/pL8VFBy7hV9CGFfuYb7pggT4mW2Wq0Y1wU2ceb7ic+ZVueV/IsSpM/+
EkGSYuNVQ0M=
=5cv6
-----END PGP SIGNATURE-----

--=-frFonc8knBtj8+a56sT2--

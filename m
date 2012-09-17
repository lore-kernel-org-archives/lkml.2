Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2IQLtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:49:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40642 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab2IQLti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:49:38 -0400
Date: Mon, 17 Sep 2012 21:49:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Fries <david@fries.net>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20120917214929.c41984a57b061048b857e876@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_21_49_29_+1000_zBg7eDwY30C0m=2t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_21_49_29_+1000_zBg7eDwY30C0m=2t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

drivers/rtc/class.c: In function 'rtc_init':
drivers/rtc/class.c:261:23: error: 'rtc_suspend' undeclared (first use in t=
his function)
drivers/rtc/class.c:261:23: note: each undeclared identifier is reported on=
ly once for each function it appears in
drivers/rtc/class.c:262:22: error: 'rtc_resume' undeclared (first use in th=
is function)

Caused by commit "rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix"
from the akpm tree.

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 17 Sep 2012 21:43:56 +1000
Subject: [PATCH] rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-2

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/rtc/class.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index ca58ea9..f8a0aab 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -34,8 +34,9 @@ static void rtc_device_release(struct device *dev)
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
 /* Result of the last RTC to system clock attempt. */
 int rtc_hctosys_ret =3D -ENODEV;
+#endif
=20
-#ifdef CONFIG_PM
+#if defined(CONFIG_PM) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
 /*
  * On suspend(), measure the delta between one RTC and the
  * system's wall clock; restore it on resume().
@@ -129,7 +130,6 @@ static int rtc_resume(struct device *dev)
 #define rtc_suspend	NULL
 #define rtc_resume	NULL
 #endif
-#endif
=20
=20
 /**
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Sep_2012_21_49_29_+1000_zBg7eDwY30C0m=2t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVw5JAAoJEECxmPOUX5FEwMYP/3ShBW3bnOoFH7PAry5fCcEC
xDRWVYlFB6cGdbN6a40Y50HWc8DUS/w4BekKQOL9WdfpIWg6evsSXvUr1m4DSA0j
VTgHI7FcP0zc/XMOpFPvvBkKkFBiBcGzWAlTkHmXarHFpzjcHUtGtLhTrLbqSI0X
Gv12sWyi64B1dmc/oz5EfnZ4E5MJpCuZmxeHQDzXTsywHFopBoQKfCtQVb3GQsJb
ZxaZ50QTnnC9nVzToTYtUMCfEYdkC7L55NK3Ge6rOcKIEFevJoc4derisNhWKOhf
T0z5UHA2+unjpsHb6pB0UB9iOsjx5WYNo/To2LJ86gKItHuT9Pxa8wdVwwN5fx23
6z3gTTKASRyLJuL0mAirsEzeHK7mqsKTGm65u79CZqZ9ulSm1vzROYfLe1nJ2EOb
L0bq19JVQ9TMYLS0FYiEl6rU4+k55Ph+FdyVlDkYK/cb7G2P4puUaNefQLJ4WCQt
sYrG2IOAgsQSgux2vT5RQMFsAFPkfX+gGXKyx5mgqVteiOvM2ONu0XXIUh6KIXwI
cd9vtSf+dTjj65k4Cf6osx/6v12sdWrSOSy32fisHr7AOUN795rtc8EoV/ML8xS0
CtGWtMIw6Faa7Tg/jIDfVeMa45646rg5ZpVgJ3JJET0Bdrpyk4yTn80o6CihiQwU
+8SwYawElN+kDry804dF
=yF26
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_21_49_29_+1000_zBg7eDwY30C0m=2t--

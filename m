Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2CMGvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:51:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39612 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2CMGvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:51:52 -0400
Date: Tue, 13 Mar 2012 17:51:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Philip A. Prindeville" <philipp@redfish-solutions.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the drivers-x86 tree with the tip tree
Message-Id: <20120313175141.1cf39f1991bcf776ee8c00ae@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_17_51_41_+1100_BVX0W37wWYKXI6wU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_17_51_41_+1100_BVX0W37wWYKXI6wU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

Today's linux-next merge of the drivers-x86 tree got a conflicts in
arch/x86/Kconfig and arch/x86/platform/geode/Makefile between commit
da4e3302949f ("x86/geode/net5501: Add platform driver for Soekris
Engineering net5501") from the tip tree and commit b2a2f19ad3db ("geos:
Platform driver for Geos and Geos2 single-board computers") from the
drivers-x86 tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/Kconfig
index 36d459e,3a38c4c..0000000
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@@ -2146,12 -2133,13 +2146,19 @@@ config ALI
 =20
  	  Note: You have to set alix.force=3D1 for boards with Award BIOS.
 =20
 +config NET5501
 +	bool "Soekris Engineering net5501 System Support (LEDS, GPIO, etc)"
 +	select GPIOLIB
 +	---help---
 +	  This option enables system support for the Soekris Engineering net5501.
 +
+ config GEOS
+ 	bool "Traverse Technologies GEOS System Support (LEDS, GPIO, etc)"
+ 	select GPIOLIB
+ 	depends on DMI
+ 	---help---
+ 	  This option enables system support for the Traverse Technologies GEOS.
+=20
  endif # X86_32
 =20
  config AMD_NB
diff --cc arch/x86/platform/geode/Makefile
index 246b788,d8ba564..0000000
--- a/arch/x86/platform/geode/Makefile
+++ b/arch/x86/platform/geode/Makefile
@@@ -1,2 -1,2 +1,3 @@@
  obj-$(CONFIG_ALIX)		+=3D alix.o
 +obj-$(CONFIG_NET5501)		+=3D net5501.o
+ obj-$(CONFIG_GEOS)		+=3D geos.o

--Signature=_Tue__13_Mar_2012_17_51_41_+1100_BVX0W37wWYKXI6wU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXu59AAoJEECxmPOUX5FEkYgP/jem9pmZ/y0h1q95YXZVdTpo
9y5oA5JTE/bhX+YIxSrs/2viYhK6sXfZwPrZORuiJdihcTL6tgbOgq0SYMgW6DjA
qCqp8wNvCTLkvCgSDUbzgdK/RVTcZHoOHyUl+Sv5suPEdSLhtiPQlGOmEkOTMyqU
hAoTtSZfNlA0Q08y5RF0+Mfgs0KEqRZt0qtqzaNMhMbF+73CqPUQB4wH1Ox1zv03
Dhh6Wg/9ruTb8Zq2ajRT2sawDbPSwLycBnzktTcWjhHN/Xat70j69f8nPK5rpZNo
K0B0kr7ic1BJPPKM6Fj53HkMZmn5fIY7nl2JKqW9Azi+xy5ZK98lzCrss2IbQSPy
Rx6xY3ej00zlt4YwnmI9rBQbhI1ChdWyBf1f9gG38sEBJmVcWzW2VCYJbfiOOO59
cRQ1fMGDMlF8PjEBp0FUp4+zOXqfzAVlqUi9SFJwZWk08X97R9YPOTDSN9KqRyxF
lNucWwMWsGfS/HnCDaEXXF83plBJ3HizIuzdRznRDcJwzm6DWVsqovxT9W7CvAhT
BFXxDdkl4ClheUuHVSUPkenlMLkOfAzUvLDtnBKZXOn1IYQIsmIiiJgvidOeplp5
5mE5R3X1GFZ4wqtw8rLWcT+sFWVfrP6143SVTx4HQWn4WKzJ8Lbm3Cnb8gt+OqZm
myGL+QXklqceUjN7mCqo
=EXop
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_17_51_41_+1100_BVX0W37wWYKXI6wU--

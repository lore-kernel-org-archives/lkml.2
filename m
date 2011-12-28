Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab1L1FlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 00:41:03 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:55361 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1L1Fk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 00:40:59 -0500
Date: Wed, 28 Dec 2011 16:40:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the driver-core tree with the arm tree
Message-Id: <20111228164052.7357f637a6bece1ef8068da6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_16_40_52_+1100_YWDYFWzq/GJrI2Pd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_16_40_52_+1100_YWDYFWzq/GJrI2Pd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
arch/arm/plat-samsung/include/plat/cpu.h between commit b024043b6d0d
("ARM: 7245/1: S3C64XX: introduce arch/arm/mach-s3c64xx/common.[ch]")
from the arm tree and commit 4a858cfc9af8 ("arm: convert sysdev_class to
a regular subsystem") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-samsung/include/plat/cpu.h
index abbdadb,0122a22..0000000
--- a/arch/arm/plat-samsung/include/plat/cpu.h
+++ b/arch/arm/plat-samsung/include/plat/cpu.h
@@@ -181,20 -183,22 +181,20 @@@ extern struct syscore_ops s3c2410_pm_sy
  extern struct syscore_ops s3c2412_pm_syscore_ops;
  extern struct syscore_ops s3c2416_pm_syscore_ops;
  extern struct syscore_ops s3c244x_pm_syscore_ops;
 -extern struct syscore_ops s3c64xx_irq_syscore_ops;
 =20
- /* system device classes */
-=20
- extern struct sysdev_class s3c2410_sysclass;
- extern struct sysdev_class s3c2410a_sysclass;
- extern struct sysdev_class s3c2412_sysclass;
- extern struct sysdev_class s3c2416_sysclass;
- extern struct sysdev_class s3c2440_sysclass;
- extern struct sysdev_class s3c2442_sysclass;
- extern struct sysdev_class s3c2443_sysclass;
- extern struct sysdev_class s3c6410_sysclass;
- extern struct sysdev_class s5p64x0_sysclass;
- extern struct sysdev_class s5pv210_sysclass;
- extern struct sysdev_class exynos4_sysclass;
+ /* system device subsystems */
+=20
+ extern struct bus_type s3c2410_subsys;
+ extern struct bus_type s3c2410a_subsys;
+ extern struct bus_type s3c2412_subsys;
+ extern struct bus_type s3c2416_subsys;
+ extern struct bus_type s3c2440_subsys;
+ extern struct bus_type s3c2442_subsys;
+ extern struct bus_type s3c2443_subsys;
+ extern struct bus_type s3c6410_subsys;
 -extern struct bus_type s3c64xx_subsys;
+ extern struct bus_type s5p64x0_subsys;
+ extern struct bus_type s5pv210_subsys;
+ extern struct bus_type exynos4_subsys;
 =20
  extern void (*s5pc1xx_idle)(void);
 =20

--Signature=_Wed__28_Dec_2011_16_40_52_+1100_YWDYFWzq/GJrI2Pd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+qvkAAoJEECxmPOUX5FENjkP/jT3Zf3aUgx8RUkBKsKgEtur
6HdHZv5ohHh0ZUO8y+WhxxvhPGybdHy09q9sJAXFOw+rBGGvMtTdngjv7Smf8+ow
a5HXmHvSCJTme0ZMRr7LdoPSMSe7lBUVUP/oGe9K04+6kABf5l/1SSIAzSRzCjKY
hF0y/qIDZ39/DT431w3YoOCbAZ++epPFP5rNDz3N6QRVDddr/NoMpa0H/Gcb7qVa
2vq75H/Uy/7VqgmRRd+cmgJTPuwLgGc4nZVnNMWrZYphCkAAYvfegxlOXpCwAoJ9
5PTOrnPRbb/GC92Se5MNWXG9bFetidoKaDBIJKqiUsCvoLqizl+sGcSc/dFXyENS
nMoZloNsBxpLKidwFWNIAhT2a+UBEUFrJuHp2JoA8q1PtKq4/AH3iOtPqTMAzvhO
2o8mqbdzmt3NeeojpQZ8oc2ZjW/6cAAe34xeYAJKMph7dTi8RgnnQMq0Gb5wDjfW
aeEQoJK0uDscZbjY5n0FGF9n8OPa3wsb4wdq9G7hi6sW1yV2U0iBjAX2plRtu/1d
NDIYk9SFNIbJ/lenDGWkvKHBuExOey7J3reAnC9l82RQMw23/+gItUZ40VAvkx3K
b8Ypa+Ju6KRnPihwlCY+cl6ryRtZwDqNDYXRWDkleg7eWoiTTym2ZrjTJm8AaSCT
v64AUjcbKe6cHs2rHgBN
=H9tz
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_16_40_52_+1100_YWDYFWzq/GJrI2Pd--

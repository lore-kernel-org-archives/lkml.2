Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750825Ab1L1FAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 00:00:54 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:41998 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab1L1FAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 00:00:53 -0500
Date: Wed, 28 Dec 2011 16:00:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the driver-core tree with the s5p tree
Message-Id: <20111228160045.21ef706d279fef338ac5d7e0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_16_00_45_+1100_tu2XW6czd5IMYjoK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_16_00_45_+1100_tu2XW6czd5IMYjoK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
arch/arm/mach-exynos/cpu.c between commit f983575aa90c ("ARM: EXYNOS:
Enable conversion of GIC dt irq specifier to linux virq") from the s5p
tree and commit 4a858cfc9af8 ("arm: convert sysdev_class to a regular
subsystem") from the driver-core tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/cpu.c
index 0e3f42b,d4c41f3..0000000
--- a/arch/arm/mach-exynos/cpu.c
+++ b/arch/arm/mach-exynos/cpu.c
@@@ -9,9 -9,7 +9,9 @@@
  */
 =20
  #include <linux/sched.h>
- #include <linux/sysdev.h>
+ #include <linux/device.h>
 +#include <linux/of.h>
 +#include <linux/of_irq.h>
 =20
  #include <asm/mach/map.h>
  #include <asm/mach/irq.h>

--Signature=_Wed__28_Dec_2011_16_00_45_+1100_tu2XW6czd5IMYjoK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+qJ9AAoJEECxmPOUX5FE1bwP/2zjEdvckR6/XryMEVwMD80V
DjzRPDR5jeH6+CcDb8iVzJszpx2HX0GmEh7PXwyKrMUh8RA0KowNphvwGbev+3lR
zSG9RPrBbD+XtRmDsF93pgUS5Pbc/ZK5Zc1v55NRBqWWL8VbZur0Mt8UpYfESDPH
ULdGaUZjzA7Wt3M8zQXkXh0VEwqJlU/d06WvnzIIcdHTmetjMtvsBmu9kJyxPt/a
kURCx60OUXwRHZdjPhj8vFI4za7XMcqm6nLz4ZN1001kqHaIcykiFREXxbYPJfGS
oon/TDA46JUARIJFrDmR2e4gyp3anPr1ZJg4Y9u9Xx/tGu6TmmnoXNfvYowJBPe1
qktFjV8CAl8PLTUSaqQ3Xj/KZ0Z+flUO/0IfKAoJv2g6OP/JPVOxm2hWgAQAixNf
JhRQ2q7PfeJ8YZBj1/4GZtAuwlOLvrKYJGCTLvoABJDahx5gHldm36fZV7RtbqG6
jreso+ADOjCabTf2O3HHJPfTGQY8/ed509DX2DYzdlg+eLQeTBi1CxEF1Qsj7yG8
29SJPki6dgUub+NKxfK1kbIsE8TMvXtHcErD2IvXDvAec4VrPU8yFa48HkUySec3
RBYfXi0embyg52V6opbx2DIbApcf+h+ncRska0LrSfb0pSXS00w1PIfz5HnJ8inc
AORki6wXgIuYral+ZTuN
=Bemd
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_16_00_45_+1100_tu2XW6czd5IMYjoK--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2IXJPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:15:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56047 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2IXJPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:15:12 -0400
Date: Mon, 24 Sep 2012 19:15:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: linux-next: manual merge of the arm-soc tree with the fbdev tree
Message-Id: <20120924191508.6100b0603d2642c1e7a36679@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_15_08_+1000_3grHwFrw7HYV=6AS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_15_08_+1000_3grHwFrw7HYV=6AS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in arch/arm/mac=
h-s3c64xx/mach-mini6410.c between commit 5a213a55c6d3 ("include/video: move=
 fimd register headers from platform to include/video") from the fbdev tree=
 and commit 436d42c61c3e ("ARM: samsung: move platform_data definitions") f=
rom the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c64xx/mach-mini6410.c
index 96ebcc5,09311cc..0000000
--- a/arch/arm/mach-s3c64xx/mach-mini6410.c
+++ b/arch/arm/mach-s3c64xx/mach-mini6410.c
@@@ -38,12 -38,12 +38,12 @@@
  #include <plat/cpu.h>
  #include <plat/devs.h>
  #include <plat/fb.h>
- #include <plat/nand.h>
+ #include <linux/platform_data/mtd-nand-s3c2410.h>
  #include <plat/regs-serial.h>
- #include <plat/ts.h>
+ #include <linux/platform_data/touchscreen-s3c2410.h>
 -#include <plat/regs-fb-v4.h>
 =20
  #include <video/platform_lcd.h>
 +#include <video/samsung_fimd.h>
 =20
  #include "common.h"
 =20

--Signature=_Mon__24_Sep_2012_19_15_08_+1000_3grHwFrw7HYV=6AS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYCScAAoJEECxmPOUX5FEOFoP/3PWBwFkMKXOOQ5eZk5BtKVS
eR4yeDichFtUFVFTKmjo31wPr6h6qkB5b+mpIQCgg+aLpTp/zgkBt9jlU/G3YIHa
pHgYEiSeb3R3L56G0WlIh9xfLQm4GjkTtxZH34TbJ5ghO4Bh++wgcegufD8DEH8y
jdwDg68Ugu0FU2N0rB+gCy+xYHSGYYY4IU+LyBw7O/fwPh61zKMBOR36rtpLVjqS
7ULBRzflWMcKec40g4b/up7QFBcSetBeZd3n+0Fr+8Heruy1veNRUmaRMbo/UGP4
187W4XLpcoYg7jgSZGe6yQhQdv7Ams700heWsoNhtR/U6pF5Q21NRQxpXFAFYlyG
mEhibkPMRCJyVtnv6cfMREuTNVzBB+fdX4F77q6tQq73m6AK5+khNAQcv5UMVswb
TypAMigNFNAAurnvSjIS9FnRq5GWq03rmKLJq0z1J1wz6lqZlqWlQvVk6zsvF20r
CGbphS927/7X68VOPze0+K51oqGYJ15P4AGFtVNI1r/00cZVNtOGCg+KEG7faRFN
8dVlRkDN4VLks6MbuLud2I93Cl9dbfm1renDX4KFdDI6awC9rT3kQ4HmvCDj0cSE
siUvHAuGnHsamMbTyNEJA/nIat3pLdEg0qZgpZP5YxnBjR1/srjj4SqUr+/AOHP2
cMrIDIfk2F+JtcRl7FzT
=L4mg
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_15_08_+1000_3grHwFrw7HYV=6AS--

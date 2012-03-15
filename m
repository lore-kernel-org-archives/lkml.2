Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab2COHGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 03:06:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60764 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab2COHGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 03:06:32 -0400
Date: Thu, 15 Mar 2012 18:06:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk@arm.linux.org.uk>, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120315180630.61dab9c2b41da3b823c9ac94@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_18_06_30_+1100_PnqvIgXWY2T1acn="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_18_06_30_+1100_PnqvIgXWY2T1acn=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/setup-sh7377.c between commit 250a27237e0e ("ARM:
shmobile: remove NR_IRQS") from the arm tree and commit bfc46f3ef838
("ARM: mach-shmobile: sh7377 map_io and init_early update") from the
arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/setup-sh7377.c
index 747ed8e,9f14609..0000000
--- a/arch/arm/mach-shmobile/setup-sh7377.c
+++ b/arch/arm/mach-shmobile/setup-sh7377.c
@@@ -30,9 -30,28 +30,29 @@@
  #include <linux/sh_intc.h>
  #include <linux/sh_timer.h>
  #include <mach/hardware.h>
 +#include <mach/irqs.h>
+ #include <mach/common.h>
+ #include <asm/mach/map.h>
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>
+ #include <asm/mach/time.h>
+=20
+ static struct map_desc sh7377_io_desc[] __initdata =3D {
+ 	/* create a 1:1 entity map for 0xe6xxxxxx
+ 	 * used by CPGA, INTC and PFC.
+ 	 */
+ 	{
+ 		.virtual	=3D 0xe6000000,
+ 		.pfn		=3D __phys_to_pfn(0xe6000000),
+ 		.length		=3D 256 << 20,
+ 		.type		=3D MT_DEVICE_NONSHARED
+ 	},
+ };
+=20
+ void __init sh7377_map_io(void)
+ {
+ 	iotable_init(sh7377_io_desc, ARRAY_SIZE(sh7377_io_desc));
+ }
 =20
  /* SCIFA0 */
  static struct plat_sci_port scif0_platform_data =3D {

--Signature=_Thu__15_Mar_2012_18_06_30_+1100_PnqvIgXWY2T1acn=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYZT2AAoJEECxmPOUX5FEsAkQAIsabxw8cs4YA9YZ+Es3dyQw
fGUbp6Ae6uGNg+UFxzeWKmKR+Gfnq3+RC/wVgHm77zcuit0xbDZBhNPrHiWtYlI6
lmaQaHy68m1/fAkumCpu6D9PwPWtZg8TQu3BcDDvztP6THQKn/gMTVg5O0RgA+Ku
DBVCZBw2tIec9fBS1vQpGsKFZAKEdIustv0vtEmMnXAzXYNO6Hc3vh0zaD/1V/rj
PG5T/L/AoIrGtibhRPmqTMLoGBkwpG8UqMaEyV3jgVBZ49NWu6kO6Ty7cVwrYhm7
E5XSYc6kpqB3G6fr4lun7ipQ4eEj6XqRBd6kVQTCRR9X0GkWgOkLEWksXimlyEj6
fbzXrTW2sOFF4VdcYQuhcdgiEAfwBCkX2Bfnv7UnY3lS2zJl6O3Pw0EcctcDVjID
8Vyz8slowvZJCrNnG4cDf+7fBgNKc91sDTpg5x8wLTVEI6Su7nZS02gfou40kCLT
JdLfUtnhJCpLdunSxUtNvd/B44RmpxpGuwHkTBJyX2N6FANFxt/MfaBMQaCVcBub
1VyEfw9qo4E/xGFQMAYT6lolUiiav3DR0cnpUbudYSew/yt2lJ+QORAtXb5h8ImR
l6Y+nyp10ITr5QUhJCvRT2dTafw9UPP3ZagEViXf+TNy1PcNFsIFXoFGYnGHzrDU
MJapQoer35hr2+lT5mAz
=RYoy
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_18_06_30_+1100_PnqvIgXWY2T1acn=--

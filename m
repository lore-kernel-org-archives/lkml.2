Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab2COHGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 03:06:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47684 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2COHGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 03:06:31 -0400
Date: Thu, 15 Mar 2012 18:06:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk@arm.linux.org.uk>, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120315180623.ba48c5a9765ac8e4a0a17c41@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_18_06_23_+1100_NriNLdBY9R7xjXTm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_18_06_23_+1100_NriNLdBY9R7xjXTm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/setup-sh7367.c between commit 250a27237e0e ("ARM:
shmobile: remove NR_IRQS") from the arm tree and commit 237caf9e6b0c
("ARM: mach-shmobile: sh7367 map_io and init_early update") from the
arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/setup-sh7367.c
index 8e848198,a51e1a1..0000000
--- a/arch/arm/mach-shmobile/setup-sh7367.c
+++ b/arch/arm/mach-shmobile/setup-sh7367.c
@@@ -29,9 -29,28 +29,29 @@@
  #include <linux/serial_sci.h>
  #include <linux/sh_timer.h>
  #include <mach/hardware.h>
 +#include <mach/irqs.h>
+ #include <mach/common.h>
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>
+ #include <asm/mach/map.h>
+ #include <asm/mach/time.h>
+=20
+ static struct map_desc sh7367_io_desc[] __initdata =3D {
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
+ void __init sh7367_map_io(void)
+ {
+ 	iotable_init(sh7367_io_desc, ARRAY_SIZE(sh7367_io_desc));
+ }
 =20
  /* SCIFA0 */
  static struct plat_sci_port scif0_platform_data =3D {

--Signature=_Thu__15_Mar_2012_18_06_23_+1100_NriNLdBY9R7xjXTm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYZTvAAoJEECxmPOUX5FEdQsP/1ZWI/5pvwPACcOckyHEcEhC
bNw8COsxDgDuNv0pJymyN7tR1vibLH9GRyXkUbeEh/W8L8BUmxIpFmANHJKLrsy2
v8HmALPFPPylGZukNf2RFjKM3dRaiKQNg6FshMW3v3HniY/VugUyDG/XN0TiuiYQ
BQFDNGF1952JXdn7tJZGAxOIsMRgX3pX2qNh9nr01kZVWMKL1gb1vTY8ntRhUiEa
GKGhej4TU3FNGzrohJWQ7BcwNbOrfuciEuw02cKR+q5LhwEDs/gf1OHHkivB8Ior
YsA1c5uw0FAwp+GeiKAPzUqKII8y/y0YQRtySyHdzsB4OvOBXxz2WNVRxYy1Nrh/
fKoAa8hmur/PXBcuC2NgBWSkasDxaOOfmXhzpgozYlag0mR6W2eqTnpv/+ixCIrn
Hx8TuH5JBXmQQfG6cOabbaBU66l7HloX+rfQUjddbgZxPt/1qZAt4RaoSSHtVenR
FPviMwHoe3o5itv/sVT8mPuf3m9hu8iRyIiBCpc3ZaC7PaI3WZ5S3iIArpnDz0Y9
qhaRThNE0saWZ/qQWpJdGrL4xPHDpVrq7X4J/1gesFwSiMnsCYSOa9p4zEDZmrbv
jVWBJ1WWyKri3lFvz9izpn0fkpYDiu6wX7dXHCoGd8A77vjhXtYHrGDaBLV64iH4
Ak95+d9IIv6CiHEUpZN9
=Cuyw
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_18_06_23_+1100_NriNLdBY9R7xjXTm--

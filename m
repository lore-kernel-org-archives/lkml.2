Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2COG4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 02:56:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34490 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab2COG4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:56:46 -0400
Date: Thu, 15 Mar 2012 17:56:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk@arm.linux.org.uk>, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120315175628.ca8afd4482712e1043212416@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_17_56_28_+1100_FNkYoAc1rgJKe1c="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_17_56_28_+1100_FNkYoAc1rgJKe1c=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/setup-r8a7740.c between commit 250a27237e0e ("ARM:
shmobile: remove NR_IRQS") from the arm tree and commit d3ab7221489f
("ARM: mach-shmobile: r8a7740 map_io and init_early update") from the
arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/setup-r8a7740.c
index fa15d81,74e5234..0000000
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@@ -25,9 -25,41 +25,42 @@@
  #include <linux/serial_sci.h>
  #include <linux/sh_timer.h>
  #include <mach/r8a7740.h>
 +#include <mach/irqs.h>
+ #include <mach/common.h>
  #include <asm/mach-types.h>
+ #include <asm/mach/map.h>
  #include <asm/mach/arch.h>
+ #include <asm/mach/time.h>
+=20
+ static struct map_desc r8a7740_io_desc[] __initdata =3D {
+ 	 /*
+ 	  * for CPGA/INTC/PFC
+ 	  * 0xe6000000-0xefffffff -> 0xe6000000-0xefffffff
+ 	  */
+ 	{
+ 		.virtual	=3D 0xe6000000,
+ 		.pfn		=3D __phys_to_pfn(0xe6000000),
+ 		.length		=3D 160 << 20,
+ 		.type		=3D MT_DEVICE_NONSHARED
+ 	},
+ #ifdef CONFIG_CACHE_L2X0
+ 	/*
+ 	 * for l2x0_init()
+ 	 * 0xf0100000-0xf0101000 -> 0xf0002000-0xf0003000
+ 	 */
+ 	{
+ 		.virtual	=3D 0xf0002000,
+ 		.pfn		=3D __phys_to_pfn(0xf0100000),
+ 		.length		=3D PAGE_SIZE,
+ 		.type		=3D MT_DEVICE_NONSHARED
+ 	},
+ #endif
+ };
+=20
+ void __init r8a7740_map_io(void)
+ {
+ 	iotable_init(r8a7740_io_desc, ARRAY_SIZE(r8a7740_io_desc));
+ }
 =20
  /* SCIFA0 */
  static struct plat_sci_port scif0_platform_data =3D {

--Signature=_Thu__15_Mar_2012_17_56_28_+1100_FNkYoAc1rgJKe1c=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYZKcAAoJEECxmPOUX5FExQcQAIm7sd5Q1egQMPKyI6ysyhhc
N8ZPDWj5GCrA7MfeXhAJXUyxB8bYNZ3IEtV3MzoiijDt//hdM9jtLphrN3nsjENn
U55cBopd6WpVZI0KXBJb2Lh8CludlRE3MjSrcCcy9AWFhCIK1S6Z9FEsbvwo85iP
TW5igSp4rZv/zhKXRK3IKjlh5t2U8IxBMXcE9/ioMxYK0kVVJYILllUzRrlGSFzi
Grgk5OIvJ9l873Fk0Pm5ju1pjczO5cMqAmDEHHMfqSjmJirStogdYx5USmUtueZA
bqhZo+yk24rZ8ArHXEe0LWU16ocn9wOxr9R47W88AHHNqvA+MHulLoDrzdzVKw/e
fGfehQ+jcFZZNUNGUPVsbmjT9gUfMqF/jyjhNuqaQSGyfZBhwwypddMUN3odeUj/
QFTnuDzrPeS+PNSSwLxTONEiwAAV6uKGUtUJTpwVUvvr8gK5Z3EdRf48fJe4woJo
z4wMDxjg2k0JH4U6swW5+zLxdvFZoGNpe+h9gwMyCJsFiNozLuPxd5BS4uo6Q7Wb
lZfwtDgz4a77BZ/dEFGe9n6fqwcK3EY9D73x3WrJKECUulVucDN/L4AGn3bVUDtI
FUcntFkWmuephrwosJdmH1DOv8pk7LaxqPrmeuOvCa6l2UEviQFPh3TXigHmTQsk
6rVqjWEO+kWx86GGmhen
=EYVt
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_17_56_28_+1100_FNkYoAc1rgJKe1c=--

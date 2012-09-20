Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2ITGDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:03:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33480 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2ITGDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:03:31 -0400
Date: Thu, 20 Sep 2012 16:03:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120920160314.b3ea668fc0766224c24bf276@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Sep_2012_16_03_14_+1000_g2jXex_u/iVR9wS8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Sep_2012_16_03_14_+1000_g2jXex_u/iVR9wS8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-integrator/integrator_cp.c between commit 73efd53012af
("ARM: 7519/1: integrator: convert platform devices to Device Tree") from
the arm tree and commit b7a3f8db07c1 ("ARM: integrator: use __iomem
pointers for MMIO") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-integrator/integrator_cp.c
index f51363e,3df5fc3..0000000
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@@ -55,7 -52,14 +55,7 @@@
 =20
  #define INTCP_PA_CLCD_BASE		0xc0000000
 =20
- #define INTCP_VA_CTRL_BASE		IO_ADDRESS(INTEGRATOR_CP_CTL_BASE)
 -#define INTCP_VA_CIC_BASE		__io_address(INTEGRATOR_HDR_BASE + 0x40)
 -#define INTCP_VA_PIC_BASE		__io_address(INTEGRATOR_IC_BASE)
 -#define INTCP_VA_SIC_BASE		__io_address(INTEGRATOR_CP_SIC_BASE)
 -
 -#define INTCP_ETH_SIZE			0x10
 -
+ #define INTCP_VA_CTRL_BASE		__io_address(INTEGRATOR_CP_CTL_BASE)
  #define INTCP_FLASHPROG			0x04
  #define CINTEGRATOR_FLASHPROG_FLVPPEN	(1 << 0)
  #define CINTEGRATOR_FLASHPROG_FLWREN	(1 << 1)

--Signature=_Thu__20_Sep_2012_16_03_14_+1000_g2jXex_u/iVR9wS8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWrGiAAoJEECxmPOUX5FEQagP/3G7PdyMhYBnEXYXfeyGnKEo
hpKRUJ6JfIKw/NCta9ytzFaQPQo0T/ENszM18jVLOMb+0Ol4Mr9H9uS4hfWPVuk5
v4JKbQnWR4JzqDRm05V2j+3tgCqUpbslBxnocD3iusJqHpVxcFINAMHQPiKbCwQT
PORV+V87riPh6P2EOfdNxzpQwn7Mkf0kT9cA9kPnzILD06aD/78bUuOBTeXLFn1a
yQBZcUEuFnfSJGJUk/Eit7k9pqMs5n8aCECJtejV+ow4PCGGdzuwVzRqrGBCNx1N
EzsG0kPOPnTTW70VrIskXDC8zXIIfjZAHIjxF9Xy+pc7XydOrr6na/Yu1syqS87a
YZDen0BNDqLmYEyiFH5P/Sr0vFjtbkO2iwVBzrbvczLoy6IcEcjRmqUQ+rne7o3e
zJKPGHvsLONiXmTgNpug0oUadk0JPOEFJnX7rf19BL7ySdA1/EFiatTjFXyyW/uV
JUWjpTI5CxEEoVb3YDD/6ryq5pW50/5DbzITr2ALwZ9uJZWl9sdJmivIpsaKhB0I
+m+KBwd5M+20Y9dJ2sBLo3tTOTSrH0Cyr0p7Q9sYkmrDJu8T8lwy6OcVSgDlRcdH
5CbqiQuCQw+21M/z7Yyylr4lVYuO5EzqwYCtXV2gPujpC2eIINtyK922v44rBeP/
3asFr0O9GTRi4BwCP2lV
=0qYs
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Sep_2012_16_03_14_+1000_g2jXex_u/iVR9wS8--

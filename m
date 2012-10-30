Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab2J3EGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 00:06:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53149 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2J3EGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 00:06:42 -0400
Date: Tue, 30 Oct 2012 15:06:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the clk tree with the arm-soc tree
Message-Id: <20121030150627.ac1f6a3f75231ea49edf7b98@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__30_Oct_2012_15_06_27_+1100_DsXIhWfsiWj5NieN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Oct_2012_15_06_27_+1100_DsXIhWfsiWj5NieN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
arch/arm/include/asm/hardware/sp810.h between commit 0891642cf117 ("ARM:
vexpress: Start using new Versatile Express infrastructure") from the
arm-soc tree and commit 05e3659135a4 ("clk: Common clocks implementation
for Versatile Express") from the clk tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/hardware/sp810.h
index 2cdcf44,afd7e91..0000000
--- a/arch/arm/include/asm/hardware/sp810.h
+++ b/arch/arm/include/asm/hardware/sp810.h
@@@ -50,6 -50,14 +50,8 @@@
  #define SCPCELLID2		0xFF8
  #define SCPCELLID3		0xFFC
 =20
 -#define SCCTRL_TIMEREN0SEL_REFCLK	(0 << 15)
 -#define SCCTRL_TIMEREN0SEL_TIMCLK	(1 << 15)
 -
 -#define SCCTRL_TIMEREN1SEL_REFCLK	(0 << 17)
 -#define SCCTRL_TIMEREN1SEL_TIMCLK	(1 << 17)
 -
+ #define SCCTRL_TIMERENnSEL_SHIFT(n)	(15 + ((n) * 2))
+=20
  static inline void sysctl_soft_reset(void __iomem *base)
  {
  	/* switch to slow mode */

--Signature=_Tue__30_Oct_2012_15_06_27_+1100_DsXIhWfsiWj5NieN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQj1JDAAoJEECxmPOUX5FEAioP/jgBWYOrOQzgXGjwY7W+hVg/
cejTc2KtwSHqOsn3jA0vS37DHlNyae4SyJ0/GAxYZXQZ6bzRetsuKD8G58zPH+D9
3s9ctT20yA+BzcI/kS/JiU0vfFgewKT5VJhLm9pwYB7C4LWPwh/ZoFHcZi5+6Npu
KBC/DbgjpxS8JNb3SvCUfh9HMXcrggqWQyn9XahtvMbdt08Arxa8cg12XasRuJNn
E8FQ03KX41rI2sNIFyDkVS8VhWNiNoHVH7OhSaUfTxPoq792zlokr6qtpWuESOfd
WquLNMyJT/cLlTz2lLGjHK+fEvlo8gDkYzQFF7Nv0bH4Lgj1GS7XiZ8NOpVFRojT
Fp9h6bk3csNCuNRt8McCq9ruaUK0zr3DJIqE6fC3f+neuQD4JVt47vjS0wnaGK6V
JWt+OvXUp/XABS6POOhqkZt5ZTELlOIJvotLU8BSj6leVhrbXME3xZKKepMXIdmv
CH1Aq8G5zCqnDxuGbjQL6nI1FATK817oKAFjaDcvDzw2cVBF/Hkf+kgH8nD/LSck
UCeJNDiZbpiFxn5SRVqpDbMQQmMChR0yiGT60+/3t56yFet5cgxUBcpXslvJvMzl
k1w/qQwD2P30rmN1NiqV/66XgopqwQQn2I8QjuY+m95i89Ig+1lRJiAlCP0uVQwu
f/mUBNdW67wXuhuTTLmL
=kV2f
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Oct_2012_15_06_27_+1100_DsXIhWfsiWj5NieN--

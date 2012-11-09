Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2KICbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:31:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44156 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab2KICbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:31:21 -0500
Date: Fri, 9 Nov 2012 13:31:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the pinctrl tree
Message-Id: <20121109133111.1070c1062889461152713978@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Nov_2012_13_31_11_+1100_Y5tZ2doQtlq6sfWf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Nov_2012_13_31_11_+1100_Y5tZ2doQtlq6sfWf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/pinctrl/pinctrl-nomadik.c between commit 241e51ebd3b2
("pinctrl/nomadik: make independent of prcmu driver") from the pinctrl
tree and commit 44e47ccf8ab6 ("Merge branch 'next/multiplatform' into
for-next") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pinctrl/pinctrl-nomadik.c
index 33c614e,3ad23fb..0000000
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@@ -30,10 -30,23 +30,9 @@@
  #include <linux/pinctrl/pinconf.h>
  /* Since we request GPIOs from ourself */
  #include <linux/pinctrl/consumer.h>
 -/*
 - * For the U8500 archs, use the PRCMU register interface, for the older
 - * Nomadik, provide some stubs. The functions using these will only be
 - * called on the U8500 series.
 - */
 -#ifdef CONFIG_ARCH_U8500
 -#include <linux/mfd/dbx500-prcmu.h>
 -#else
 -static inline u32 prcmu_read(unsigned int reg) {
 -	return 0;
 -}
 -static inline void prcmu_write(unsigned int reg, u32 value) {}
 -static inline void prcmu_write_masked(unsigned int reg, u32 mask, u32 val=
ue) {}
 -#endif
  #include <linux/platform_data/pinctrl-nomadik.h>
-=20
  #include <asm/mach/irq.h>
-=20
+ #include <mach/irqs.h>
  #include "pinctrl-nomadik.h"
 =20
  /*

--Signature=_Fri__9_Nov_2012_13_31_11_+1100_Y5tZ2doQtlq6sfWf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQnGrvAAoJEECxmPOUX5FEvPAP/26bG2Cfnu9U1KB0AJnXbRT9
jOGA1JcSUO7UKPFKOJDT3Y5A2WQmj3miwkYP3/jrHuz2sIg1jIDtzsmkh6SVsIIo
fM9TqD4VeR53Z2vVllkXvX/GdtiS32Rn5YZP+DHL6JcJnCzf9lacUNBAqsxCVWwz
V9nsw/M890SpJh1vbz9e/SNlQPJiG8a/1sa//3x2cSXCOznTkgAwsQu7WhRunK71
lroxLTFbTGdITcPCefpkryMP26FwFdQHm9gxZy5wrlLhc/fLK2zV+QyXO948kU36
96fqnQFmDIO3jJuleNWsm6toxarvbL7I0F8hQsEHsogWNvZeX2/kE1BJptxd/oKy
37zxgWOVlurtWUHXYrpRoQ+cCkLcotE58p1YmdesplC87QvuI6N4baogaXP6DERA
BFLrebY8kHrTySlbr1m6/zBtX1wM62uKb2nV8c2yIuhnYXRWM2zgLCPCABboHv8A
1Imq35IWq1LxNt+kmkY/b/5iuh+ZZOHvYW/hxBKm7RKvJg6J9pVjgo9TWQFkzzKu
l064Y3EtX3wSEoxN/AbT1cDFp7SXH17ncFZSZsR3sTBc6dkRvw+PyQzaLZ4yU+FA
1ixG+lJZPHansgc4+zmTOx+jVSBlyaKQY4hf1tmkCSOKa011Ol37x+VeXU6wj7k8
0xCXw+8SlmmaCvv3iAgU
=tzOI
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Nov_2012_13_31_11_+1100_Y5tZ2doQtlq6sfWf--

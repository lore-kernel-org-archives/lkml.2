Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2KZKcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:32:05 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53744 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab2KZKcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:32:02 -0500
Date: Mon, 26 Nov 2012 21:31:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20121126213152.60b52e19d7fc84ce94c356c3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_21_31_52_+1100_gvha+WRsLlIg7w5k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_21_31_52_+1100_gvha+WRsLlIg7w5k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/tty/serial/atmel_serial.c between commit 95e629b761ce
("ARM/AVR32: get rid of serial_at91.h") from the arm tree and commit
bcd2360c1ff9 ("arm: at91: move platfarm_data to
include/linux/platform_data/atmel.h") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/atmel_serial.c
index 1a8a271,5660ec2..0000000
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@@ -39,13 -39,13 +39,12 @@@
  #include <linux/atmel_pdc.h>
  #include <linux/atmel_serial.h>
  #include <linux/uaccess.h>
 +#include <linux/pinctrl/consumer.h>
+ #include <linux/platform_data/atmel.h>
 =20
  #include <asm/io.h>
  #include <asm/ioctls.h>
 =20
- #include <mach/board.h>
-=20
 -#include <asm/mach/serial_at91.h>
 -
  #ifdef CONFIG_ARM
  #include <mach/cpu.h>
  #include <asm/gpio.h>

--Signature=_Mon__26_Nov_2012_21_31_52_+1100_gvha+WRsLlIg7w5k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs0UYAAoJEECxmPOUX5FE/0QP/RzBU4spRgnkpzns0pYOUE+T
2jWfHZIGkzjKcSKcbQSHKeDRqhxway1CUKQpoTKOuKQOFiVBufWj9vXG+Qt0ZAdk
QImZ6TMT2tgQHO5K8HyaL4tVLXAhOgn2q+9vg2ywqJ/JTtQZ0msTAEV+lp9ujtpU
tnhZbo7Iek/7XdKUJb0o84ZBtWGFQSG8ry9Rg4TExjkJauqSBN3d2ZCGTpQov3fA
vvLfXNoecZSqeiVuzID8Sw+5+4dqAfaFvG21VSFE2ICycfJeXqsBB/S94+YRsC2z
PpYDUFi0PwGS+WS7SKJ99TbW9E0Qi53n4Qts117Drs4MKBrRFpXaKlqAvuLYa9TK
rEBzAlQs4qXH+EknHewYutk16gpbQwTBY6nSjqT5zB5J81xcyBy32yAiNLYuDUMn
N4F2YuZIVxO5zhhoN9TtwqtPULCxPCyPCH2VJOpb/R42GM1qSNmKeAmYQ3yELEoB
zvH2/VoHLOznd+wGJye5lzXNudT2+7Pa9CU+aTQpWu2Lyxr6dv3JB68TlhpyRkHX
Me+zrGYKCMiovePEJRRfZbnJ9Pxd0prutaQLIKBUplDQTK02keEssfUji9X5c4CB
bVLUk5CR2cM+qzHEqWguHLHdnckad3EqvMrcU1pqLxez4ntCuRG47joxvM3wHT5/
1DuqSvfHb/xlwdeB1eNc
=Udak
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_21_31_52_+1100_gvha+WRsLlIg7w5k--

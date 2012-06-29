Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2F2Hsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 03:48:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51643 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab2F2Hsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 03:48:40 -0400
Date: Fri, 29 Jun 2012 17:48:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: build failure after merge of the final tree (pwm tree
 related)
Message-Id: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Jun_2012_17_48_26_+1000_w/dHaXOFN+KffdMm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jun_2012_17_48_26_+1000_w/dHaXOFN+KffdMm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mfd/built-in.o: In function `__crc_pwm_free':
(*ABS*+0x15ee601): multiple definition of `__crc_pwm_free'
drivers/mfd/built-in.o: In function `.pwm_free':
(.text+0x187a0): multiple definition of `.pwm_free'
drivers/pwm/built-in.o:(.text+0x740): first defined here
drivers/mfd/built-in.o: In function `__crc_pwm_request':
(*ABS*+0xaee34e3d): multiple definition of `__crc_pwm_request'
drivers/mfd/built-in.o: In function `__crc_pwm_enable':
(*ABS*+0xd83c7949): multiple definition of `__crc_pwm_enable'
drivers/mfd/built-in.o: In function `.pwm_enable':
(.text+0x18800): multiple definition of `.pwm_enable'
drivers/pwm/built-in.o:(.text+0xbc): first defined here
drivers/mfd/built-in.o: In function `.pwm_request':
(.text+0x1858c): multiple definition of `.pwm_request'
drivers/pwm/built-in.o:(.text+0x1178): first defined here
drivers/mfd/built-in.o: In function `pwm_config':
(.opd+0x2970): multiple definition of `pwm_config'
drivers/pwm/built-in.o:(.opd+0x0): first defined here
drivers/mfd/built-in.o: In function `pwm_free':
(.opd+0x29b8): multiple definition of `pwm_free'
drivers/pwm/built-in.o:(.opd+0xf0): first defined here
drivers/mfd/built-in.o: In function `pwm_request':
(.opd+0x2988): multiple definition of `pwm_request'
drivers/pwm/built-in.o:(.opd+0x180): first defined here
drivers/mfd/built-in.o: In function `__crc_pwm_disable':
(*ABS*+0xa4ee3c79): multiple definition of `__crc_pwm_disable'
drivers/mfd/built-in.o: In function `.pwm_disable':
(.text+0x186b8): multiple definition of `.pwm_disable'
drivers/pwm/built-in.o:(.text+0x198): first defined here
drivers/mfd/built-in.o: In function `pwm_enable':
(.opd+0x29d0): multiple definition of `pwm_enable'
drivers/pwm/built-in.o:(.opd+0x18): first defined here
drivers/mfd/built-in.o: In function `.pwm_config':
(.text+0x184a4): multiple definition of `.pwm_config'
drivers/pwm/built-in.o:(.text+0x0): first defined here
drivers/mfd/built-in.o: In function `pwm_disable':
(.opd+0x29a0): multiple definition of `pwm_disable'
drivers/pwm/built-in.o:(.opd+0x30): first defined here
drivers/mfd/built-in.o: In function `__crc_pwm_config':
(*ABS*+0xdeebfb06): multiple definition of `__crc_pwm_config'

Caused by commit 0c2498f16608 ("pwm: Add PWM framework support").  There
are (e.g.) definitions of pwm_free in arch/mips/jz4740/pwm.c,
arch/unicore32/kernel/pwm.c, drivers/mfd/twl6030-pwm.c,
drivers/misc/ab8500-pwm.c and now drivers/pwm/core.c.   Four of these are
EXPORTed.

I have just left this broken for today - please investigate a solution
quickly.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__29_Jun_2012_17_48_26_+1000_w/dHaXOFN+KffdMm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP7V3KAAoJEECxmPOUX5FEbBoP/2fajGkIlnKPOzhk68Z+NDaz
J3WRom8htUOqSaC5GTRqneaC0ioGy8gFvBOVpoWA2y+h7b5i/09Ot0lLVRcOuz7Z
52oYDNm7Qypd3PXVoQoqej3bTtzPvGiSp+s0x6JYJ5Di5iklDmJujceXPO6tuTKo
41XYR76q+2gjtFjocYEh652zjBNDeboAGNL0x/g8BX4gH0Ta0+fYXsbKKDsmKwyF
zEdCCWknQj3AVw/0KI5UYiAmd3oCrzxc+pPc5rHrG1d4VADiLcWSEzzTr0JIslHO
FbR/SVlQjlnS43mp53aq4np6rrMhn+xPXT8CdzGE5ERCJdo/vbHghpX4iNftmN5J
7d2XjjnkF3Ehv3Xi+FlutS0z1ofNXdp0c43+XFC9OePkNjKA+myWr14Ped4NJLjT
0hNLwlLXTx57DcMZf/lDopHlUjd3w5J2C0cwzGzfYaNaIDUl1crxSuwP0QOsjUDi
kKQnxoPPMIvEUgVrmiNeBPrXawKV5Oy954dy3V3ycDMizkwU/HKTmTA+FU74e/OS
CoYwgutc/KkVZy8pbrkhj9hNU1lls4o/lslVb5gUNwjO9egN/JhMC0tIrFHeuEXX
vGBZ0glEJaClyxh24/GOCB4V8zs1Sc67cPa/4Ltx2r99ign9kIx8cLAdjFuvBFPW
GOrGSLYP3MiesP7qutg+
=InrN
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jun_2012_17_48_26_+1000_w/dHaXOFN+KffdMm--

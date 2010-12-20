Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0LTIVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 03:21:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52724 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab0LTIVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 03:21:30 -0500
Date: Mon, 20 Dec 2010 19:21:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the final tree (mfd tree
 related)
Message-Id: <20101220192121.47767525.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Dec_2010_19_21_21_+1100_kx=k5I_TgZRlC8e0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Dec_2010_19_21_21_+1100_kx=k5I_TgZRlC8e0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mfd/built-in.o: In function `__crc_pwm_free':
(*ABS*+0x24ba6d1e): multiple definition of `__crc_pwm_free'
drivers/mfd/built-in.o: In function `.pwm_free':
(.text+0x1a2bc): multiple definition of `.pwm_free'
drivers/misc/built-in.o:(.text+0x32e40): first defined here
drivers/mfd/built-in.o: In function `__crc_pwm_request':
(*ABS*+0xc1f4ec93): multiple definition of `__crc_pwm_request'
drivers/mfd/built-in.o: In function `__crc_pwm_enable':
(*ABS*+0x9d09808d): multiple definition of `__crc_pwm_enable'
drivers/mfd/built-in.o: In function `.pwm_enable':
(.text+0x1a348): multiple definition of `.pwm_enable'
drivers/misc/built-in.o:(.text+0x32eac): first defined here
drivers/mfd/built-in.o: In function `.pwm_request':
(.text+0x19ff4): multiple definition of `.pwm_request'
drivers/misc/built-in.o:(.text+0x32c80): first defined here
drivers/mfd/built-in.o: In function `pwm_config':
(.opd+0x1e48): multiple definition of `pwm_config'
drivers/misc/built-in.o:(.opd+0x4158): first defined here
drivers/mfd/built-in.o: In function `pwm_free':
(.opd+0x1e90): multiple definition of `pwm_free'
drivers/misc/built-in.o:(.opd+0x4128): first defined here
drivers/mfd/built-in.o: In function `pwm_request':
(.opd+0x1e60): multiple definition of `pwm_request'
drivers/misc/built-in.o:(.opd+0x40b0): first defined here
drivers/mfd/built-in.o: In function `__crc_pwm_disable':
(*ABS*+0xb0493b18): multiple definition of `__crc_pwm_disable'
drivers/mfd/built-in.o: In function `.pwm_disable':
(.text+0x1a1a4): multiple definition of `.pwm_disable'
drivers/misc/built-in.o:(.text+0x32d70): first defined here
drivers/mfd/built-in.o: In function `pwm_enable':
(.opd+0x1ea8): multiple definition of `pwm_enable'
drivers/misc/built-in.o:(.opd+0x4140): first defined here
drivers/mfd/built-in.o: In function `.pwm_config':
(.text+0x19ec8): multiple definition of `.pwm_config'
drivers/misc/built-in.o:(.text+0x32f8c): first defined here
drivers/mfd/built-in.o: In function `pwm_disable':
(.opd+0x1e78): multiple definition of `pwm_disable'
drivers/misc/built-in.o:(.opd+0x4110): first defined here
drivers/mfd/built-in.o: In function `__crc_pwm_config':
(*ABS*+0xc23f5b9): multiple definition of `__crc_pwm_config'

Probably caused by commit 665ba7cafa19e2e2596ace30edc75ebec882e82d ("mfd:
Remove ARCH_U8500 dependency from AB8500") which allowed this driver to
be built in on PowerPC ...

Some of the above symbols are global in more than one place in our code ...

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Dec_2010_19_21_21_+1100_kx=k5I_TgZRlC8e0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNDxIBAAoJEDMEi1NhKgbsvKIH/1vf1Ce9tehJLFeJ0xTdq5H7
vIY8phkO485Ju7s+t8imcV2Z+49OPxC0xcAoIo+9ixqvP19pOEQvagfKkuyLofKc
FFGGsLLg6IyMNfdpZue/yRye7V57SR5Yxnt2ymLIwR2F4u8MGrRhiNOgXxDiq5Pn
YdyLyLyVdbdnkeHuQGXcPSX5SwW6XeJ5kXZVBBupxAqqG/TDpShEpx3podU7uhJw
y9XQ0nJc9kaFfGdFh84xjhkzR/CVpxsWt//cJ8ytYZGIk5NaOyMEerx+cNyOYllX
lbkm4ul2UZaM/43zhhYJpasIygV2/m7tqHuA3O0t6Wbdu5wMYKsRs0Qb4unr9s0=
=WH1c
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Dec_2010_19_21_21_+1100_kx=k5I_TgZRlC8e0--

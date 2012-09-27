Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2I0FtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:49:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52303 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab2I0FtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:49:09 -0400
Date: Thu, 27 Sep 2012 15:48:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120927154851.4ec680a2d4a9c4999db5b39d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Sep_2012_15_48_51_+1000_X5aUXIhAnvdbMO8K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Sep_2012_15_48_51_+1000_X5aUXIhAnvdbMO8K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/include/asm/timex.h between commit 56942fec06ef ("ARM: 7538/1:
delay: add registration mechanism for delay timer sources") from the arm
tree and commit 387798b37c8d ("ARM: initial multiplatform support") from
the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/timex.h
index 9acc135,963342a..0000000
--- a/arch/arm/include/asm/timex.h
+++ b/arch/arm/include/asm/timex.h
@@@ -12,9 -12,19 +12,13 @@@
  #ifndef _ASMARM_TIMEX_H
  #define _ASMARM_TIMEX_H
 =20
 -#include <asm/arch_timer.h>
+ #ifdef CONFIG_ARCH_MULTIPLATFORM
+ #define CLOCK_TICK_RATE 1000000
+ #else
  #include <mach/timex.h>
+ #endif
 =20
  typedef unsigned long cycles_t;
 -
 -#ifdef ARCH_HAS_READ_CURRENT_TIMER
  #define get_cycles()	({ cycles_t c; read_current_timer(&c) ? 0 : c; })
 -#else
 -#define get_cycles()	(0)
 -#endif
 =20
  #endif

--Signature=_Thu__27_Sep_2012_15_48_51_+1000_X5aUXIhAnvdbMO8K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQY+jDAAoJEECxmPOUX5FEd2kQAKLgsC1195OrBM9J9KN8gzsG
TNnwCCjO/WJuTb++qrcAYboWOZL5vAPLq7Jw1Zk4hhMBn4EU0SQzJKyMvuUnTtQN
wQXsdtRb4QfmVwBdOucfmfXqpmi13N+SbpmR+8ZR5icifgX7jyaJSX4nXsQNBYUj
R1xpD/ZNM9bJ+qEUUy0njSNJ/W/OKQY8VaQzisS3gEfuQqS3Kunkrt6b0pzxDY/a
n5m8HRdY1ntKoQABmExEgsSWarg/syTT1amEgIJ0LoLo/mQcnzAJeTDrUB1HgRol
iZWRpXHinAANAeO1k+VMBp3EObXajNIVeTxJSuKGmTAMsdCjN54hT9AGM0VxkMFp
ZxDgBuFwx4axsf3nOAdyBqrVB5PRQv8C+BUQ4FnYKYb3LNjFs1ff5drKSYX0Bk/K
iV+z1oACzGfPP9g3VroWDCx1KwvEdn5FPjy1QdqyJMSbNpzN6iBWpL8vWWrIDa7f
xtxKLPfHbJcq4z/oT9g6NRGBaCaClmBqgkjPKaTDUQw1TXLwkhywurRBq55OUgMa
10+WD3RINLvL2wHj3jtOOScyCdCOa6XYPtSd5zpJ/WXU3AeMHNuIDHne+QbkjBbV
Soz8gmkD1Y25JKubOpVAJbteYH+u9kegNL0OGyD/gqNxQP5gQ9EZxFer5K7rldoG
LdH9GOuzjEy2QTeR0XvO
=jnSU
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Sep_2012_15_48_51_+1000_X5aUXIhAnvdbMO8K--

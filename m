Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2JDExA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 00:53:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59908 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2JDEw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 00:52:58 -0400
Date: Thu, 4 Oct 2012 14:52:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the signal tree with the modules and
 arm-soc trees
Message-Id: <20121004145241.fac039e78a15bb614cbd6da0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_14_52_41_+1000_EfaZ_XutxHVkkbku"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_14_52_41_+1000_EfaZ_XutxHVkkbku
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got conflicts in
arch/avr32/include/asm/Kbuild, arch/cris/include/asm/Kbuild,
arch/frv/include/asm/Kbuild, arch/h8300/include/asm/Kbuild,
arch/ia64/include/asm/Kbuild, arch/m32r/include/asm/Kbuild,
arch/microblaze/include/asm/Kbuild, arch/mn10300/include/asm/Kbuild and
arch/xtensa/include/asm/Kbuild between commit e7a570ff7dff ("asm-generic:
Add default clkdev.h") from the arm-soc tree, commit 786d35d45cc4 ("Make
most arch asm/module.h files use asm-generic/module.h") from the modules
tree and commit ddd03a1f7591 ("get rid of generic instances of
asm/exec.h") from the signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/avr32/include/asm/Kbuild
index e3ba7bc,aa47fff..0000000
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@@ -1,5 -1,4 +1,6 @@@
  include include/asm-generic/Kbuild.asm
 =20
 +generic-y	+=3D clkdev.h
+ generic-y	+=3D exec.h
 +
  header-y	+=3D cachectl.h
diff --cc arch/cris/include/asm/Kbuild
index 6900bbf,b68ad4b..0000000
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@@ -8,5 -8,4 +8,6 @@@ header-y +=3D etraxgpio.
  header-y +=3D rs485.h
  header-y +=3D sync_serial.h
 =20
 +generic-y +=3D module.h
 +generic-y +=3D clkdev.h
+ generic-y +=3D exec.h
diff --cc arch/frv/include/asm/Kbuild
index 13cd044,32c1646..0000000
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@@ -2,4 -2,4 +2,6 @@@ include include/asm-generic/Kbuild.as
 =20
  header-y +=3D registers.h
  header-y +=3D termios.h
++
 +generic-y +=3D clkdev.h
+ generic-y +=3D exec.h
diff --cc arch/h8300/include/asm/Kbuild
index 98477e9,3a2af1a..0000000
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@@ -1,4 -1,2 +1,5 @@@
  include include/asm-generic/Kbuild.asm
 +
 +generic-y	+=3D module.h
 +generic-y	+=3D clkdev.h
+ generic-y +=3D exec.h
diff --cc arch/ia64/include/asm/Kbuild
index 58f3d14,98efd48..0000000
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@@ -13,4 -13,4 +13,6 @@@ header-y +=3D ptrace_offsets.
  header-y +=3D rse.h
  header-y +=3D ucontext.h
  header-y +=3D ustack.h
++
 +generic-y +=3D clkdev.h
+ generic-y +=3D exec.h
diff --cc arch/m32r/include/asm/Kbuild
index 98477e9,7083403..0000000
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@@ -1,4 -1,3 +1,5 @@@
  include include/asm-generic/Kbuild.asm
 =20
 +generic-y	+=3D module.h
 +generic-y	+=3D clkdev.h
+ generic-y +=3D exec.h
diff --cc arch/microblaze/include/asm/Kbuild
index 48510f6,5a0e72b..0000000
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@@ -1,4 -1,4 +1,6 @@@
  include include/asm-generic/Kbuild.asm
 =20
  header-y  +=3D elf.h
++
 +generic-y +=3D clkdev.h
+ generic-y +=3D exec.h
diff --cc arch/mn10300/include/asm/Kbuild
index 0d20f55,7083403..0000000
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@@ -1,3 -1,3 +1,4 @@@
  include include/asm-generic/Kbuild.asm
 =20
 +generic-y +=3D clkdev.h
+ generic-y +=3D exec.h
diff --cc arch/xtensa/include/asm/Kbuild
index 0d20f55,7083403..0000000
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@@ -1,3 -1,3 +1,4 @@@
  include include/asm-generic/Kbuild.asm
 =20
 +generic-y +=3D clkdev.h
+ generic-y +=3D exec.h

--Signature=_Thu__4_Oct_2012_14_52_41_+1000_EfaZ_XutxHVkkbku
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbRYZAAoJEECxmPOUX5FElGMP/i2KDca+skxroUGPVu7+Rm0X
QuGy288v5m7rwQM8RKGF5ZJcT4CNnFtrgjRqvrJUXRtXocssYjiJ0v4WhNnUTxAL
R8nCXwXKmLN3MZrNtCc7Ze45f2i+sITGf19E+mtnfbpkk8E9rYpySqGlmvHuN5CG
FYWXrys/GufeivGvYv2+2w+KmRKV3Ggj9WSN7YVMoLZlMtTy+7SBw2esKwQaLu95
m5BXah0/VVisDXj2NJSznQPbYYedUZBD6Anpm67k2J1lI10h0t7iLiZz61TYo3QG
+hROFCpaJGSWEftHJzSOKLdhvr7v7RKPhO8XgqrGhXSjE7h+hBa5Ow1evDyTCJt2
Sb92ErHb2FjUHJuVf98+5+fePmuIuASJYTeL+x+xvGp8220UOjV4fRprLBB0QViW
z5cQzZXGEr92Ybcx+M+3yaXOk/jENsYY4KYHSTCK6wchrTAbxLfK2X+tecG5jqq3
iNwmiw0BPUO2PoUH7/o98/N83iPRlTLxQyBt6Y2PhZIhfGi8BZ7Gs6r378DU+Zro
L5Ymf91uvCBqT5sBRBrinaeu+C3JxHxtfhxk1GlL59J9yU4+l9x6B3TthcmRvpMF
B+bZYEgOgDk6LkPgC9lBArUNBmPA2S9b+O1OZUc1A3OVJrBcoAmHhNBEqWt3LLkx
KFHdNIaiJN+JI+Fgs8mj
=Jk50
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_14_52_41_+1000_EfaZ_XutxHVkkbku--

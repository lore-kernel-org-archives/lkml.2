Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab0HKDiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 23:38:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34845 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932427Ab0HKDiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 23:38:20 -0400
Date: Wed, 11 Aug 2010 13:38:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Fomenko <ext-alexey.fomenko@nokia.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Michal Marek <mmarek@suse.cz>,
        Trevor Keith <tsrk@tsrk.net>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20100811133812.2b594551.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Aug_2010_13_38_12_+1000_qba66bv3HGSl.knC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Aug_2010_13_38_12_+1000_qba66bv3HGSl.knC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

*** glibc detected *** scripts/mod/modpost: munmap_chunk(): invalid pointer=
: 0x00000000004095fc ***
=3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
/lib/libc.so.6(+0x71b16)[0x2b4f000b6b16]
scripts/mod/modpost[0x40284e]
scripts/mod/modpost[0x403aee]
scripts/mod/modpost[0x40446e]
/lib/libc.so.6(__libc_start_main+0xfd)[0x2b4f00063c4d]
scripts/mod/modpost[0x401219]
=3D=3D=3D=3D=3D=3D=3D Memory map: =3D=3D=3D=3D=3D=3D=3D=3D
00400000-0040e000 r-xp 00000000 08:11 30327842                           /s=
cratch/sfr/powerpc_allyesconfig/scripts/mod/modpost
0060d000-0060e000 rw-p 0000d000 08:11 30327842                           /s=
cratch/sfr/powerpc_allyesconfig/scripts/mod/modpost
0060e000-00611000 rw-p 00000000 00:00 0=20
006cf000-006f0000 rw-p 00000000 00:00 0                                  [h=
eap]
2b4effe25000-2b4effe43000 r-xp 00000000 08:01 483871                     /l=
ib/ld-2.11.2.so
2b4effe43000-2b4effe45000 rw-p 00000000 00:00 0=20
2b4effe45000-2b4efff9e000 rw-p 00000000 08:11 30334167                   /s=
cratch/sfr/powerpc_allyesconfig/arch/powerpc/kernel/built-in.o
2b4f00042000-2b4f00043000 r--p 0001d000 08:01 483871                     /l=
ib/ld-2.11.2.so
2b4f00043000-2b4f00044000 rw-p 0001e000 08:01 483871                     /l=
ib/ld-2.11.2.so
2b4f00044000-2b4f00045000 rw-p 00000000 00:00 0=20
2b4f00045000-2b4f0019d000 r-xp 00000000 08:01 483859                     /l=
ib/libc-2.11.2.so
2b4f0019d000-2b4f0039c000 ---p 00158000 08:01 483859                     /l=
ib/libc-2.11.2.so
2b4f0039c000-2b4f003a0000 r--p 00157000 08:01 483859                     /l=
ib/libc-2.11.2.so
2b4f003a0000-2b4f003a1000 rw-p 0015b000 08:01 483859                     /l=
ib/libc-2.11.2.so
2b4f003a1000-2b4f003a8000 rw-p 00000000 00:00 0=20
2b4f003a8000-2b4f003be000 r-xp 00000000 08:01 482546                     /l=
ib/libgcc_s.so.1
2b4f003be000-2b4f005bd000 ---p 00016000 08:01 482546                     /l=
ib/libgcc_s.so.1
2b4f005bd000-2b4f005be000 rw-p 00015000 08:01 482546                     /l=
ib/libgcc_s.so.1
7fffe11d6000-7fffe11f8000 rw-p 00000000 00:00 0                          [s=
tack]
7fffe11ff000-7fffe1200000 r-xp 00000000 00:00 0                          [v=
dso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [v=
syscall]
/bin/sh: line 1:  5229 Aborted                 scripts/mod/modpost arch/pow=
erpc/kernel/built-in.o

I got this error a few times during that build and during the sparc64
defconfig build as well.

This was an x86_64 hosted build using libc 2.11.2 from Debian (so eglibc
based), gcc 4.4.4 and binutils 2.20.1-system.20100303.

The only patch new to linux-next since yesterday that affects scripts/mod
is commit 37ed19d5cce35a40d3913cf9aa208ce9f60db3d7
("scripts/mod/modpost.c: fix memory leak") from Linus' tree.

I have reverted that commit in linux-next for today as that makes the
error go away.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Aug_2010_13_38_12_+1000_qba66bv3HGSl.knC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMYhskAAoJEDMEi1NhKgbsCAEIAIfgeQeb6aKd3vNk+OUa6Diz
MtT8YcJoPf1b86wHuqi6uTK2ducb0hz19le76VmuqVxiX7d9IhEkOMh6q+8Hdij0
HALmBLV9SmaTqFWum56oOrzTYp7H8RizJse9cq6BwYy3adJzWIjipUJf0sCXNbJH
AUg+pK+0w6EIPmqpMPDsyqzjlvNZDqALgLdVvkyGWq4+FDOZboIo+np3whxgivdZ
SExttGoiMo1s4ZNLRKBi6miYCPU4tvBMcKH2ASReZQIotrOBlk2GqYjJ/WyCYlKp
4YDZnB3sW1GZi54rU0m6narG1Dtltf3JWXuHCKnMHjipUd2m2jFiaWwO59CZwUk=
=fkDy
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Aug_2010_13_38_12_+1000_qba66bv3HGSl.knC--

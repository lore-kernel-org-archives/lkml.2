Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab2JDAfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:35:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38050 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167Ab2JDAfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:35:17 -0400
Date: Thu, 4 Oct 2012 10:35:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        David Daney <david.daney@cavium.com>
Subject: linux-next: manual merge of the mips tree with Linus' tree
Message-Id: <20121004103508.b47c06bc737ceaf6aa1a4e25@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_10_35_08_+1000_iO6N99Tc9SAL8UhP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_10_35_08_+1000_iO6N99Tc9SAL8UhP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

Today's linux-next merge of the mips tree got a conflict in
arch/mips/include/asm/octeon/octeon-model.h between commit a1ce39288e6f
("UAPI: (Scripted) Convert #include "..." to #include <path/...> in
kernel system headers") from the  tree and commit 5cf02e5554a4 ("MIPS:
OCTEON: Add detection of cnf71xx parts") from the mips tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/include/asm/octeon/octeon-model.h
index 23b895c,93398f6..0000000
--- a/arch/mips/include/asm/octeon/octeon-model.h
+++ b/arch/mips/include/asm/octeon/octeon-model.h
@@@ -313,6 -323,14 +323,14 @@@ static inline int __octeon_is_model_run
  const char *octeon_model_get_string(uint32_t chip_id);
  const char *octeon_model_get_string_buffer(uint32_t chip_id, char *buffer=
);
 =20
+ /*
+  * Return the octeon family, i.e., ProcessorID of the PrID register.
+  */
+ static inline uint32_t cvmx_get_octeon_family(void)
+ {
+ 	return cvmx_get_proc_id() & OCTEON_FAMILY_MASK;
+ }
+=20
 -#include "octeon-feature.h"
 +#include <asm/octeon/octeon-feature.h>
 =20
  #endif /* __OCTEON_MODEL_H__ */

--Signature=_Thu__4_Oct_2012_10_35_08_+1000_iO6N99Tc9SAL8UhP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbNm8AAoJEECxmPOUX5FEc/4QAIMfdJIe50GxopTTt+y3onxR
fjk+BBCeT/Ux8cmgyuUucyy24u+yyA8PJT4O1De8GN5tqVS2ux4y42qPt506T0/C
/HzSJQK4XZKfRkC4TwrCct8rbR++BkANUJ9yVr2w3p24WHZezmtPn8vxD+/ciGkm
OosT3UuaT3+xeta6ovVJXDh9GJFvxZOWqRd73PJiURZCZGnHDO98buDc/EmAhqKD
e9qcqbBkbmbwf3nMX/HVMR9CizXyBC/tXyavV5/2JMbbzJSRXjDvk+vlfMcWG+ht
P9XDEs/P2EDOXZ24MXV8O5VvijvJQC9QUTjS7hPselH0Qtty0WggHoDk4lvOYzze
zLulMSYdssH1k4GZx6R+xOe31jMAXuDPE5DI7g5oWyJ3OEH2p7j4BTiQf0JxW8yI
GfAs9ttopoNu5LbumQtIIHMtOSgD1CPOnnfN12xr5+GVL8elvz+FxH/h+Jv1UOEA
yiUTwhcTvKQpXur52fT9GAFARiSDR/gsuKQuKnv0he6Erwm/tEynM6zX2vIjB7nA
1PPk93izC+BsGdHFFnH3m3pCUswRcIBkxrxE35IBc03leuRDaeAY2yO74VOSD1ZR
mAMgQSBmjxJ4i78C01ih3cNTLqGyo+4qfCjko9UbvmtafeB1btn3RcoM3a7Wm8ru
bGvtQrdb3d4jDHq0g7qi
=A1Yb
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_10_35_08_+1000_iO6N99Tc9SAL8UhP--

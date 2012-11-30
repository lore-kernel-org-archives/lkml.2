Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2K3FrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:47:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56319 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2K3FrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:47:10 -0500
Date: Fri, 30 Nov 2012 16:46:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: linux-next: manual merge of the signal tree with the ftrace tree
Message-Id: <20121130164658.c9ceafc2eeba30ac6747285e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Nov_2012_16_46_58_+1100_WhssEJm.FpaN5u9v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Nov_2012_16_46_58_+1100_WhssEJm.FpaN5u9v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/microblaze/include/asm/Kbuild between commit 8cbd9cc62540
("tracing,x86: Add a TSC trace_clock") from the ftrace tree and commit
24465a40ba45 ("take sys_fork/sys_vfork/sys_clone prototypes to
linux/syscalls.h") from the signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/microblaze/include/asm/Kbuild
index c5d7670,88a758a..0000000
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@@ -1,4 -1,6 +1,5 @@@
 -include include/asm-generic/Kbuild.asm
 =20
 -header-y  +=3D elf.h
  generic-y +=3D clkdev.h
  generic-y +=3D exec.h
 +generic-y +=3D trace_clock.h
+ generic-y +=3D syscalls.h

--Signature=_Fri__30_Nov_2012_16_46_58_+1100_WhssEJm.FpaN5u9v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQuEhSAAoJEECxmPOUX5FEkW0P/R1ugmNeEo1GQAkYBYjIYTWV
IDdMdJQJEYMDBHN7B589VYPOWBb6S9m0r7vsXVU9F+HMpAr4Ch9wmC3g9F4AaqKX
NrzjWOH/fQo9SivmU7MLOB49NTZpfmSz5DKMqIn61r6gXYtGwsUDrSY8yN33rE5l
ntw5Ez0INB4Zxikt2tbxxxchJ3lofEodCO3rmtWnbKALvaRbtSGdmqlnzmhQNygj
m1bAg9hzDGLhmYDAOctF+OKajhyDY8pXVrfoHaephAnwflH0E/a11C/CdEvyNJXF
L8+ft6UJXxLJwqmnnklNx1+yJdCTWsiZ8FKPYmnUkPE+m0vrxqT6Olj9PbKglI+v
jf/i7trkT0JH3A0JhodYq0jjOGhYi6qapnvLjyQ1avlIYIRErO2N382P7F4ZJAKo
qkeEx7L6N6WVl4oOl2ayOkH6+XI9GmG3wiq9fdvqT0cvLtoa7YrUwr3x3tvGb1t5
qbWFIh24mcQc9mGgsE4q7nMu3wDTL33i3wHtWkE7IGY0zc5YKMwZQi/qRs+dIIvD
p0tzf/tHjCgN/XEG9FCx4SepX2eNY15jpQLDNTATL+wclXAxqpiCMVlsbZo4zOrI
CQRixv+QsMWTqYcWLvSYRXe5DinWaaotkBF4YzYQGoQthxPM+IdkCC4U7VeSDp7E
u9H4kXF9VAWD2hDr0d7G
=cMhs
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Nov_2012_16_46_58_+1100_WhssEJm.FpaN5u9v--

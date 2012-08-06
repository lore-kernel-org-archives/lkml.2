Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2HFBXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:23:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45343 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2HFBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:23:36 -0400
Date: Mon, 6 Aug 2012 11:23:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the rr tree with the s390 tree
Message-Id: <20120806112328.6d5b5e21c37b753a2013b05b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Aug_2012_11_23_28_+1000_PRJpI6N/d=V52fId"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Aug_2012_11_23_28_+1000_PRJpI6N/d=V52fId
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/s390/Kconfig between commit 867c2dcb369b ("s390/seccomp: add support
for system call filtering using BPF") from the s390 tree and commit
d673c23ca730 ("Make most arch asm/module.h files use
asm-generic/module.h") from the rr tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/Kconfig
index 107610e,11cc724..0000000
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@@ -124,7 -123,8 +124,9 @@@ config S39
  	select GENERIC_TIME_VSYSCALL
  	select GENERIC_CLOCKEVENTS
  	select KTIME_SCALAR if 32BIT
 +	select HAVE_ARCH_SECCOMP_FILTER
+ 	select HAVE_MOD_ARCH_SPECIFIC
+ 	select MODULES_USE_ELF_RELA
 =20
  config SCHED_OMIT_FRAME_POINTER
  	def_bool y

--Signature=_Mon__6_Aug_2012_11_23_28_+1000_PRJpI6N/d=V52fId
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQHxyQAAoJEECxmPOUX5FExnAP/icBXnyoHq8KmkftDdu+ShZc
Wbrb0iIGLJkkPPkLl7WGsgrDfykQBvlwe5/hXFQ9BLZWD96Hn7RWTtS9E8MIdzgJ
JZZf/WChqeWiSiCgVI84SlqyCVDqr1daKtwYIjYzAUNYjD7Jv+TNrbYDjbYeffsT
O4JtS+qd1w1wWKUdL6j+GL2Rex5skbrgQXTq7MRPAFKQnL9/IY/AZv9tRsAxnB32
VVukCSd/aEcx8mekuYKareRPdcePMAt0KwW0hUHzQtvFMSfgV+8HRSWyCiMJxHkK
gYyll7zASAJGK5nJmRz+ny2RmOUvCwBimfBuK1yIrEHiIM1Qd6rR51eFPqz60Mi1
QiIYocjBsXqM+dVs80m5iJDvJN4w7VYFVpW6z4zkegHg7TIVh8JxGBMrCq4VEr2e
fM9w3OOHdTf5MeN3T+ZWTdzJPDi3uG1F9weg0NBM+T5GScGu2z/NpAm1VT26yj4c
UGoZ+RRKRfOHWDcEgWEYRycg+eTucKukMb08ACiIsdO//WKC85YIAZ8i+IM0Heh3
X0xeKgNJK1jp37wWVY1p+IhcitN8X2xLwI/tR6AwhLgw7aqbPFTG7byR1Je7vx2O
EWLtsI1ZuodYg8WzGwstWnDGF1s3cYS7fFYxjd8JWQ6AmhHrvvWB3cB6/TmSh2Sa
l4vSo9RzIVki4loAJo53
=TGZM
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Aug_2012_11_23_28_+1000_PRJpI6N/d=V52fId--

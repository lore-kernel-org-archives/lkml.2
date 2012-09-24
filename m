Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2IXMYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:24:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53380 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2IXMYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:24:23 -0400
Date: Mon, 24 Sep 2012 22:24:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wade Farnsworth <wade_farnsworth@mentor.com>,
        Steven Walter <stevenrwalter@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the signal tree with the arm tree
Message-Id: <20120924222415.80bb88f62c547dfc09e6ddc7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_22_24_15_+1000_sRqI.UrvdN=88EoO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_22_24_15_+1000_sRqI.UrvdN=88EoO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/arm/include/asm/thread_info.h between commit 1f66e06fb641 ("ARM:
7524/1: support syscall tracing") from the arm tree and commit
8ecd548d5fff ("sanitize tsk_is_polling()") from the signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/thread_info.h
index f71cdab,b2d6b41..0000000
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@@ -150,8 -148,6 +150,7 @@@ extern int vfp_restore_user_hwstate(str
  #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
  #define TIF_SYSCALL_TRACE	8
  #define TIF_SYSCALL_AUDIT	9
 +#define TIF_SYSCALL_TRACEPOINT	10
- #define TIF_POLLING_NRFLAG	16
  #define TIF_USING_IWMMXT	17
  #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
  #define TIF_RESTORE_SIGMASK	20
@@@ -163,8 -159,6 +162,7 @@@
  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
  #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 +#define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
- #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
  #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
  #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 =20

--Signature=_Mon__24_Sep_2012_22_24_15_+1000_sRqI.UrvdN=88EoO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYFDvAAoJEECxmPOUX5FE3BEP/iDpsTZy6D21GotIvOkDHcYb
QehOxWV+AmhEqxoTMl0ulJNJan/AfHt6UQ+pz7NlmGZXmTW6lBNloNnC2D3/QeZH
dykugyNT8dx5N2bNMFExRu9j3cE3q3yx1sG+62e0dinXJfZUkLab02pFLVxjErOt
q8FZJy++rF7PmQquFk0NcovHTfiRuWittSd1WzQqchp1FSbMDAoNRAlLXia2Q19o
qM/TNr1T+t6959ILgzKoGX1+fM/o12liOc747xUohrY2ItuEKmzxeLx9UHiDTpMT
DsvCkDoqpM2G5paRDluBLn145n0w+lQHGVfIljEbqkaz6XJn76WOZqJ7CXaQ/WzC
IDtvnOoBYVI1UsAhXdnzR0d97MwbIq3LvFdcB6c552enMvoUzIpAOGfYGG9gzvZC
vbhTLGxZNlohCSoXQuxCOe4iDLRE/0CF1leW54sNXBUO3/yG/gds3fSyTE7+2pNj
uhwWv1X+fMv+ZWDvA/U5eEN+0CRvEWC6DJqYVFgwSAOJxmUkw/Ha/bpG0TZPiv8m
PYHUEegxSRFb9zwKL5E8zPUDXGcf4USC5yZ1uLCNquW+UuYmWzgPYaWvXcKpQ6nw
nMqmIC9PcLA2bBiXGaBrbMi9b2nIlU1GDA5rAEDDnLjxudZ4qWyLB0MewwHhun7S
Jz/XL+zfJsDuc1s/19zJ
=VU3u
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_22_24_15_+1000_sRqI.UrvdN=88EoO--

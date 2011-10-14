Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1JNHH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 03:07:28 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:56381 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab1JNHH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 03:07:27 -0400
Date: Fri, 14 Oct 2011 18:07:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: linux-next: build failure after merge of the final tree (sparc,
 ptrace trees related)
Message-Id: <20111014180714.e11e15fd35dfaca839c6421e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Oct_2011_18_07_14_+1100_PoOCDQntuJjmze__"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Oct_2011_18_07_14_+1100_PoOCDQntuJjmze__
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

arch/sparc/kernel/signal_64.c: In function 'handle_signal':
arch/sparc/kernel/signal_64.c:482:11: error: unused variable 'blocked' [-We=
rror=3Dunused-variable]

Caused by my merge of commits faddf598f0ba ("sparc: Use
set_current_blocked()") form the sparc tree and 383fe35697e4 ("sparc: Use
set_current_blocked() and block_sigmask()") from the ptrace tree.

I have added the following merge fix patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 14 Oct 2011 17:58:53 +1100
Subject: [PATCH] sparc: fix mismerge of signal*.c

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/kernel/signal32.c  |    1 -
 arch/sparc/kernel/signal_32.c |    1 -
 arch/sparc/kernel/signal_64.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index 74a5dde..22b7c6a 100644
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -776,7 +776,6 @@ static inline int handle_signal32(unsigned long signr, =
struct k_sigaction *ka,
 				  siginfo_t *info,
 				  sigset_t *oldset, struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int err;
=20
 	if (ka->sa.sa_flags & SA_SIGINFO)
diff --git a/arch/sparc/kernel/signal_32.c b/arch/sparc/kernel/signal_32.c
index 9e005b6..b3a2229 100644
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -465,7 +465,6 @@ static inline int
 handle_signal(unsigned long signr, struct k_sigaction *ka,
 	      siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int err;
=20
 	if (ka->sa.sa_flags & SA_SIGINFO)
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index 26560e9..27332cd 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -479,7 +479,6 @@ static inline int handle_signal(unsigned long signr, st=
ruct k_sigaction *ka,
 				siginfo_t *info,
 				sigset_t *oldset, struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int err;
=20
 	err =3D setup_rt_frame(ka, regs, signr, oldset,
--=20
1.7.7

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Oct_2011_18_07_14_+1100_PoOCDQntuJjmze__
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOl9+iAAoJEECxmPOUX5FEQ34P/2GWJxJL7z2fmUn+dutQ0mZw
vVlBTI84cCTHmYYcG+aK9dzI1C/D1uyXOS89PixOVQT5x3lzOOraQlTlm21djOm4
ijTgbdVw10ZhKyMaAKi33MtINmHIdqbEn4Kd2RNL1uYCXOMq2K2rN4eheJjEzPaN
K/0J+ZNsiYiuWNcb5glA3Yfv6VPDs5a4eZWFjk9PemVvY45i0HXWa43XoMC6CJBS
o2VKrGxUuTraHDiJmOGfHNiZ0R01z65RCrForogwwruKh+IUe8PQdzlsZe1FPBH6
gs8EBpswk8CWZR8pYxnYw2WwM9S07ks1Frw728G4JpGTJqljWGtGM5KkM9Kr1UI/
RXBZ2b2p3GPHuO8bmJPMKs7Sljovpf6cDUzg63kluuh/lTh62+dt8st24oW5al+/
3MZxKRrRLQm0oruVwdWSP6xMYco7feZCcX3kPqHyt65HXqxgjFbkNMipiUePFk/6
aLJ5LCpcDanloeLtKqfPUMZMJIApJMLUnnR9osHM8M0L2BExs7KCcrOk9tnT7ulq
qnlSRWgM6hAycdESyVdVDxrXIDSE3MaMZPxv1yyDEE8NeGtOd68CieCrQ3f3htow
n8eeuhsvMjE+YtX0mXA5X+FfuU3q2eOqa97HA/SWdJaLeYlIW2boljplym3vMFjj
HxUST2eQIxehxwLGtx2A
=y+i5
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Oct_2011_18_07_14_+1100_PoOCDQntuJjmze__--

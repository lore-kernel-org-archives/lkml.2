Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419Ab2C3DcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 23:32:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60149 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759599Ab2C3DcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 23:32:11 -0400
Date: Fri, 30 Mar 2012 14:31:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the final tree (Linus'
 tree related)
Message-Id: <20120330143156.6c55bd32d207a074f65d1b16@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Mar_2012_14_31_56_+1100_c3+KDgQNGkIa3.hO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Mar_2012_14_31_56_+1100_c3+KDgQNGkIa3.hO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

kernel/signal.c: In function 'ptrace_stop':
kernel/signal.c:1860:3: error: implicit declaration of function 'synchroniz=
e_user_stack' [-Werror=3Dimplicit-function-declaration]

Presumably caused by commit d550bbd40c0e ("Disintegrate asm/system.h for
Sparc").

I added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 30 Mar 2012 14:26:24 +1100
Subject: [PATCH] sparc: fix fallout from system.h split

Fixes this build error:

kernel/signal.c: In function 'ptrace_stop':
kernel/signal.c:1860:3: error: implicit declaration of function 'synchroniz=
e_user_stack' [-Werror=3Dimplicit-function-declaration]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/include/asm/ptrace.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/sparc/include/asm/ptrace.h b/arch/sparc/include/asm/ptrac=
e.h
index ef8c7c0..8112096 100644
--- a/arch/sparc/include/asm/ptrace.h
+++ b/arch/sparc/include/asm/ptrace.h
@@ -165,6 +165,7 @@ struct sparc_stackf {
 #ifdef __KERNEL__
=20
 #include <linux/threads.h>
+#include <asm/switch_to.h>
=20
 static inline int pt_regs_trap_type(struct pt_regs *regs)
 {
@@ -241,6 +242,8 @@ extern unsigned long profile_pc(struct pt_regs *);
=20
 #ifdef __KERNEL__
=20
+#include <asm/switch_to.h>
+
 static inline bool pt_regs_is_syscall(struct pt_regs *regs)
 {
 	return (regs->psr & PSR_SYSCALL);
--=20
1.7.9.5

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__30_Mar_2012_14_31_56_+1100_c3+KDgQNGkIa3.hO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPdSksAAoJEECxmPOUX5FEyYoP/ihkYpSm777dEaO2KfMAkemC
03vKvhmG1V2KUNzogQYjFy0bUhOhHdb/SQb2eFeEDYMcCfL+SywGm4yWG6IKeiQt
siNVRiLjntLGexgKoeLSkz2RUqB0TOxWZXB/ugxhzL7lf5OrkeW4Z7Co6l9f3if+
4MBUj5gmamHwEU4NfCQElsqhgf06lS3DdhNvBrG3ql0X042wKMLVNnD2w/ROC6XO
pTJ9ZuKhNX8Aw/IdwN1xhu4nh8l3fyaF8nHCJ5TK5Un0glJQ5rIbN3rvgwGymowz
+QRXxl9gQq54r68xkcnbxL29HgMi5dvHeQArLrf71vJAob/gmvZzWFmG94+suyg7
++UsWo7sDH865RT/jfobC3VeGWXZ/mHiH1hjxAufB0h2Rkgat1kSrpr79uz6JWwZ
ZX/n0FaE9vMUMAVO85Oedb9grk2oJv6ewT6BPHfwN6ChWdcnbm4dfK0qK0pSva+7
9U40ev5X0sxSs+r8kfRmf1PYJ9FwOcULRhxe0NmcWhgd4Sx4SUVayzPFgOtMQbtB
N/vPQQ6e2KktBF5NQ5CJT4xicnBPcb2yNZH6GMDRIKzT6lvOJocimhMkBxtRCV37
pC5PG1Js+RIV1aZ/p5WvKVb9yMgGIEbZ2M2/0xBd/dkNdA701B5hTozSOO1SKp9s
P4NkUz6AArMtQ0JcAYAK
=MMoX
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Mar_2012_14_31_56_+1100_c3+KDgQNGkIa3.hO--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2ENEv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 00:51:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47805 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2ENEv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 00:51:28 -0400
Date: Mon, 14 May 2012 14:51:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the tip tree with the sparc-next tree
Message-Id: <20120514145114.bc3e8b95da9478486ac0a13e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_14_51_14_+1000_hYU4rKGhMEkWc953"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_14_51_14_+1000_hYU4rKGhMEkWc953
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/sparc/include/asm/thread_info_32.h between commit e7b7e0c35655
("sparc32: drop btfixup for alloc_thread_info_node/free_thread_info")
from the sparc-next tree and commit f5e10287367d ("task_allocator: Use
config switches instead of magic defines") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/sparc/include/asm/thread_info_32.h
index 74316de,b29498d..0000000
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@@ -80,10 -80,11 +80,8 @@@ register struct thread_info *current_th
   */
  #define THREAD_INFO_ORDER  1
 =20
- #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-=20
 -BTFIXUPDEF_CALL(struct thread_info *, alloc_thread_info_node, int)
 -#define alloc_thread_info_node(tsk, node) BTFIXUP_CALL(alloc_thread_info_=
node)(node)
 -
 -BTFIXUPDEF_CALL(void, free_thread_info, struct thread_info *)
 -#define free_thread_info(ti) BTFIXUP_CALL(free_thread_info)(ti)
 +struct thread_info * alloc_thread_info_node(struct task_struct *tsk, int =
node);
 +void free_thread_info(struct thread_info *);
 =20
  #endif /* __ASSEMBLY__ */
 =20

--Signature=_Mon__14_May_2012_14_51_14_+1000_hYU4rKGhMEkWc953
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsI9CAAoJEECxmPOUX5FEe8UQAJjKaczsPaBfbuMp7OqEXCRv
8KV5em3qoa9J11+YIcORbYbckuaoPIHmBEkvtLXYGkudkcSCo5oR74RTFmdYCKgd
v1JbK9yn7KF9NX5qOGLgZZB7lBoy9WuHxgn+x8sfZtIg8HSocZi3WFid3rb39bOk
N6a9IAg91hpcmCOcf1B/Oe7WKdPc0Tobg8rcv0Pgfxict5ImYnyYq/VsB8J892/p
L1kc6Blbdu6EKQDNivfyJdaI+BH9/SJDlIpdbYMDl1RkUl7s6x//tt6phD9f1nUp
LrSrb2xc6QfMn/YsBH3dhKZJQSw2LgXjZsycU1dUqKicAk4Wob7zLpWW6bVGgSgm
8ve1A1M2tH6kmdUWQENRxuy7Rwlvn0GjAuDFUHK5lk6TpR4RrbXhtk3cPsLARcT6
Ge7qeW7vZV+/Tq+cC9NR5j8vw/rTaAWdnJO9zm9shyXFhSWLLwubu/5HQsjoqaR8
UrNGfs9GtSYJOv/Y3+kreZsDZ03stGKh2ltwwK9zzb/9p48xi0Z4JjJ8TBXCT7uV
frBkObpMXfneYSAr5da5L7cmDmx1i9/0Gb0NoWD2Bm2H204sjdo+jP7qOW85iDCI
dc4Ec4eCGY/O+1NlRKnKYetaoc1oYxzbawrLjiKhz/WAuKGnGbyDBj26ZEeK342d
m7/k/a2mTRrCUy7vjA19
=vHHJ
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_14_51_14_+1000_hYU4rKGhMEkWc953--

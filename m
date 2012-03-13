Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2CMAI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:08:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36869 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2CMAIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:08:55 -0400
Date: Tue, 13 Mar 2012 11:08:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: linux-next: manual merge of the arm tree with Linus' tree
Message-Id: <20120313110840.7b444deb6b1bb902c15f3cdf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_11_08_40_+1100_N4JspxvGd9h6W1vq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_11_08_40_+1100_N4JspxvGd9h6W1vq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
kernel/sched/core.c between commit 8c79a045fd59 ("sched/events: Revert
trace_sched_stat_sleeptime()") from Linus' tree and commit 1cf00341547a
("sched: Introduce the finish_arch_post_lock_switch() scheduler hook")
from the arm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sched/core.c
index b342f57,ea13a09..0000000
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@@ -1932,6 -1932,8 +1932,7 @@@ static void finish_task_switch(struct r
  	local_irq_enable();
  #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
  	finish_lock_switch(rq, prev);
+ 	finish_arch_post_lock_switch();
 -	trace_sched_stat_sleeptime(current, rq->clock);
 =20
  	fire_sched_in_preempt_notifiers(current);
  	if (mm)

--Signature=_Tue__13_Mar_2012_11_08_40_+1100_N4JspxvGd9h6W1vq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXpAIAAoJEECxmPOUX5FEgFwQAKVZl4jlO6BQ72O8mCCKNIZO
oeE1TZUryRXKMtisK/X+CocznS9kxgmPSR9gXl897ZADQaTdTf5eQuz15jL8r0EK
KKHqduBJ8i0sBWSKNTM1cxm51izAnrm6AGgi9X83m1R8nuJps9XTqk/QyoxtvHm7
wMJGFkQmk7fgKAO6FUI4gcKh7FG0vgbS7UCPWw3LOkD7NDlAZ7/bK7lT/bb3tsTb
Jy+KteqB1H4DCZsQmfADf10pSUVmvZSL6fR/rsUm0kWXMCuBeaEtvBtRhL/pQx3p
BXCsisqxp2Hdrw880wbcGLSx3ErgfMerYDFDlxku61FwMsAHBNS3akJgAV/JxU8/
v/cxWWQ2pSAB13Aj/2DmTJhQKtFfgM2SH9e5Fdq5is4T5LHjcIE+FG4QLxi9y1KW
fBJYz2GGf5+/nHpB45Pc7CarucMIFHLZDUlOGZSgt5KO4wf3YYATDSdXf5SdMpTA
yZRBdsahrxEreyPQBnDnO1s7//cRp27rZxrf8shq76Vga1vA70BVVUiv54TXnLmX
rgFcNTC+XhGzpG01wYPt2Yp6Nwm+QsE4DPXnpEWb73am4ADb6IymzQ13q3LurkLL
XYt2131ltI0YQGQTggZu82qButf9qwEY5khOarHM7vUw9YVrkY1ZFUty4LHblPjF
1aspd/lQC14tg1r+9gf0
=kF0M
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_11_08_40_+1100_N4JspxvGd9h6W1vq--

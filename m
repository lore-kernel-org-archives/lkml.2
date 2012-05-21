Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2EUIEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:04:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53900 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2EUIEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:04:34 -0400
Date: Mon, 21 May 2012 18:04:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120521180425.50ca4c5e02a869e4887696d7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_18_04_25_+1000_X85+DZjIHuu63Y3k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_18_04_25_+1000_X85+DZjIHuu63Y3k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in kernel/fork.c
between commit 0ea86208345b ("sched, mm: Rework sched_{fork,exec} node
assignment") from the tip tree and commit "task_work_add: generic
process-context callbacks" from the akpm tree.

Context changes.  I fixed it up (I think - see below) and can carry the
fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/fork.c
index 5642958,b33046e..0000000
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@@ -1419,6 -1420,8 +1419,7 @@@ static struct task_struct *copy_process
  	 * We dont wake it up yet.
  	 */
  	p->group_leader =3D p;
 -	INIT_LIST_HEAD(&p->thread_group);
+ 	INIT_HLIST_HEAD(&p->task_works);
 =20
  	/* Now that the task is set up, run cgroup callbacks if
  	 * necessary. We need to run them before the task is visible

--Signature=_Mon__21_May_2012_18_04_25_+1000_X85+DZjIHuu63Y3k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPufcJAAoJEECxmPOUX5FEAGkP/0XYv9aD5+9p5CELEWgK6p+X
LWvJkuif4jL5gPqVvygzkfLJjcAC2MalieXMa9nYAlxDPZ/83dMj55FdGBuNB5FM
KxfzCXCtMqAIbbJ2MJgjyPhPcOyJCADzlniCwWfaiiU95xuUsAlEtSEMc384dP0R
kcZEbqHuD1z2/SMgSpbD+ZK/cBaxFvsP0f3O2dgUDyV4uuNT47B4oh7C4MTemQ3b
4l4QCwi2FjX+M3bD2E5+jMWpU+D7NVL5v2HANrLRnz+4cHchfbUdwuSrSepc1HfA
CdF8tJwwQh5ZeS5VV+7fAZu+1Y7Nt1Vkrv6V/AUmEwz60MHRifeR5kbD1AVOq6FT
jtmnwvfpSaZu3J5q4zZaUOYoAOqsNtKarPcYCG3uh3yOh+xi9hP/ZDAgUv9haM9P
AffvPCdg16mIXaRMRg22sFwbRhszeu4lkgBrYYab6smjCjwsiLLpfmcYtF9QZOhF
LF8yLAgT1GW1gGFXlrdCudCG6IAAQcw86rrAEOjEWM12CLVBIhNkI8n8ijUV6LBB
mL2Mhr/NlU3Xue6d76ihmER67TZoG5WvRdJSCSGiYWDoA8c20WZj4FXo1ZuGu29H
I6cJED6H70xxNDEm7fX9EcIKs4i8TS2BXkPnzjr02PKL+bdTa2UpjzMoipwHKaXy
/48sICmurBeWDERwZaPu
=dN5K
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_18_04_25_+1000_X85+DZjIHuu63Y3k--

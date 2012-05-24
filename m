Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2EXFwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 01:52:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41631 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2EXFwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 01:52:03 -0400
Date: Thu, 24 May 2012 15:51:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the signal tree with the tip tree
Message-Id: <20120524155151.0a119f3e4ac73a353b11322f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_May_2012_15_51_51_+1000_3A7JYvKSvWBYZ5Pm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_May_2012_15_51_51_+1000_3A7JYvKSvWBYZ5Pm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
kernel/fork.c between commit 0ea86208345b (sched, mm: Rework sched_
{fork,exec} node assignment"") from the tip tree and commit 4d82c317564d
("task_work_add: generic process-context callbacks") from the signal tree.

I fixed it up (as discussed - see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/fork.c
index 5f7d197,1a1faaf..0000000
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@@ -1419,6 -1409,8 +1419,7 @@@ static struct task_struct *copy_process
  	 * We dont wake it up yet.
  	 */
  	p->group_leader =3D p;
 -	INIT_LIST_HEAD(&p->thread_group);
+ 	INIT_HLIST_HEAD(&p->task_works);
 =20
  	/* Now that the task is set up, run cgroup callbacks if
  	 * necessary. We need to run them before the task is visible

--Signature=_Thu__24_May_2012_15_51_51_+1000_3A7JYvKSvWBYZ5Pm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvcx3AAoJEECxmPOUX5FENLcP+wU05qwZgqRZbzd6FpgzWsqp
n4i7CIiGm2PvtPuJT5XPJ1W6DJGH+5wuLCznOxCKis7HAaf1HoAfKndKwjutD62X
m5xyemtfSWJ3GuRXivpsEuraR0+dsglMJl0mzZhQPL/c+WEv/whpnh1GtYf+9cN8
7RxyA8tEl0Yrsx4ZWKhPuByN9SxNsw52VROZlFOQYh3FnoUbFLe0ICsILaC0npRb
trrsx7k6rXd5Ls+02w4L+ASmnHH2/S091URskI7LAtQ+th5Kg3NgXceMn72DQ60j
AwguiOtrDW/GtCEzcDf9VFVqpzsFpN5iHZnC+uY6CpYwq4fQKHX8UAudNr39gBAD
8novyqy4zYB38ACW6r91+i8uIOWY1dqe2tUVc84hT8wnfnLOf2bFcQVUOCtb7A88
Ltn1rv+NDGYrEh6nRfVfVhVjF5ThPa+iNjvmw9n/hwW99GTdFcwlzD7/fiQgw6MH
Q1DWDm8powAirFXpn0vuzt1ORSmm8SsvebTETpQbtGbmR0wxBbWcl0yAUTsodI0k
K3/fPoyPBRowInJWBEpGNSBUFaWBQa1CBaZKZQFaSMoLt9yUKGL+BWEMrB4v++JB
e6xBEqvTV4PZOkl02AYHW/Pu+IQ0ZDcyLbMZK+75g5I6NBSD1URAnEgkL5DQW+zD
yipBq53Wi0QnzVIg10id
=3ZCu
-----END PGP SIGNATURE-----

--Signature=_Thu__24_May_2012_15_51_51_+1000_3A7JYvKSvWBYZ5Pm--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2HVE1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:27:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33203 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2HVE1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:27:33 -0400
Date: Wed, 22 Aug 2012 14:27:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the rcu tree with the tip tree
Message-Id: <20120822142722.1132127ef7d8a6214b7b2b32@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Aug_2012_14_27_22_+1000_tYuUeqWYXpE261Ep"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Aug_2012_14_27_22_+1000_tYuUeqWYXpE261Ep
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the rcu tree got a conflict in
kernel/rcutree_plugin.h between commit 62ab7072476a ("rcu: Use
smp_hotplug_thread facility for RCUs per-CPU kthread") from the tip tree
and commit 8732d57a8ce0 ("rcu: Provide OOM handler to motivate lazy RCU
callbacks") from the rcu tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/rcutree_plugin.h
index c1961ae,c3e3fc4..0000000
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@@ -25,7 -25,7 +25,8 @@@
   */
 =20
  #include <linux/delay.h>
 +#include <linux/smpboot.h>
+ #include <linux/oom.h>
 =20
  #define RCU_KTHREAD_PRIO 1
 =20

--Signature=_Wed__22_Aug_2012_14_27_22_+1000_tYuUeqWYXpE261Ep
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNF+qAAoJEECxmPOUX5FEL/UP/R9c5CHeaIOQ3SZbJu6b7u3l
Ykk4gte3TXB5LVN8cM46JEMVXQ4KAhOmHZT5ibBzjdqWg5M4C+WJtoQ4JLhGH3yt
edTxzG7b0dfBPEm+FfS/lxNXVQU/zyq0j9R8PnHIL4vKsoqc1Q/bucbsf5b7UnS+
nLFHRENPn1W3dbKruKFy7/5x/JeGr5Lwg21YBPhR5a/6R40J2T06uIuWWv1yo8PQ
CornQcwgYcPmUCqu5fxtK38xesgSFaud0PlH3HhsNxzeeNQmDz8J9muD70UP2MWD
f0ijAA8MvpOobTDnB1qo3InDxKLOA7FSReNpeYUbyLNnlRr8x4lPXCoURs+wLJqX
73txgk5kFbCSa5SgEYBt24GeGRcP9jAaa3FHdQVcpYmdb8yzfLT8YZ78skEybE87
TZGIjgYIklK1cyP65O2bc4yAjApYsOIJrsVAOxearmuQR1B8mwGwMFi2XjbG5Ihv
VxvscrNTCC9Z08Tpxu8kRAzGrlDSPdq+6TJzCH43f6wIIgpW3E7zJ9OknQizjHWC
Fwjo3M2I+IdEWfyjuQqAYZhkrjxgSZi5MboBWWjVglq+wzxLgoaZEy9NjtKspGxO
K9zV7a5TCaDmw/STFiZDkwGU0WKGqPZJm1eX8Wliav14xabY4NNONYEYi/ZJQFYP
c5q3B/bbjPRu49iNKjGh
=K3LU
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Aug_2012_14_27_22_+1000_tYuUeqWYXpE261Ep--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2JAOW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:22:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53355 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2JAOWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:22:54 -0400
Date: Tue, 2 Oct 2012 00:22:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20121002002246.4005fd43bb055ad32fd1d660@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_00_22_46_+1000_rLw7nbs6aqp2emJM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_00_22_46_+1000_rLw7nbs6aqp2emJM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/mempolicy.c between commit e9d5bc24d665 ("mm/mpol: Make mempolicy
home-node aware") from the tip tree and commit "mempolicy: fix a memory
corruption by refcount imbalance in alloc_pages_vma()" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/mempolicy.c
index 6e2cd87,3c23d89..0000000
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@@ -1603,7 -1587,8 +1603,8 @@@ asmlinkage long compat_sys_mbind(compat
  struct mempolicy *get_vma_policy(struct task_struct *task,
  		struct vm_area_struct *vma, unsigned long addr)
  {
 -	struct mempolicy *pol =3D task->mempolicy;
 +	struct mempolicy *pol =3D get_task_policy(task);
+ 	int got_ref;
 =20
  	if (vma) {
  		if (vma->vm_ops && vma->vm_ops->get_policy) {

--Signature=_Tue__2_Oct_2012_00_22_46_+1000_rLw7nbs6aqp2emJM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQaac2AAoJEECxmPOUX5FE7wgP/1PSMfULT6llp1Pa4zp7sim0
/znWVOx+K+/9mzjc7EDQe262GFmxPpm4xta5f2eKoQS30gZVUqTJ4HZtTeb+6yMH
aHubU+7KdaDdjdMYF7I+AJ+Iuo+KwOyb+qWOCxB9cXuuaY1tYsCMy45VY3Ud6/xQ
31eBhUcyoli3GOTMyFUvbWH4IQnjusaiCFEtod7UYvXesMwa/RmFdk90YGUfxlXp
BojssnETJo0SARj5NESSeK+bZeU565k8TCSMsUjJo2ZpSDGjN5qIosXZuLx5JxST
qNQUs8fuGCgN5XHEvalnkUvp8Ent0moKsfHopo+N82ITXMXJXgWXRZlDJ9QcnSaq
EYvE5x65DTrrfya2QYASpjjs/0XfW1Jjpi73ATX1xcVQO6Zvy4UaTVnxf7+eXBVp
tyXZO/yTX7HLEMNp9gR3zLgbu65ahzP4wQrOPDINR8L8xtjrkn4pBSQzTzfUvsZm
5KhvKlnkAk4xJbnCos/0BjHQE6zB37OzILmtdTnnNxzUWoMv18lJZTJdEDOI3TdN
UMZ75hXCS1DAoHYGaz2+wbQd2L+lEN8P3y/QYr6NZtY6+ej/BgVkP1xTydoVx1vk
eX5pWJcC7jtTjrMHRqgf3z/JIESjtAEOHZ67iLQT46FPRCbPKzxtAzXlMDGhf4Lm
e4HlqhAxfzp7ERg3ZOd5
=TltM
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_00_22_46_+1000_rLw7nbs6aqp2emJM--

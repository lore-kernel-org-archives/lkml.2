Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2EUIX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:23:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41568 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2EUIXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:23:55 -0400
Date: Mon, 21 May 2012 18:23:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120521182343.fc69799fecb065de6192bb06@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_18_23_43_+1000_BEbVYcF54GU_+R6w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_18_23_43_+1000_BEbVYcF54GU_+R6w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/proc/base.c between commit 30a08bf2d31d ("proc: move fd symlink i_mode
calculations into tid_fd_revalidate()") from the  tree and commit "proc:
pass "fd" by value in /proc/*/{fd,fdinfo} code" from the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/proc/base.c
index 2308157,c560fc8..0000000
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@@ -1847,7 -1835,9 +1847,7 @@@ static const struct dentry_operations t
  static struct dentry *proc_fd_instantiate(struct inode *dir,
  	struct dentry *dentry, struct task_struct *task, const void *ptr)
  {
- 	unsigned fd =3D *(const unsigned *)ptr;
+ 	unsigned fd =3D (unsigned long)ptr;
 -	struct file *file;
 -	struct files_struct *files;
   	struct inode *inode;
   	struct proc_inode *ei;
  	struct dentry *error =3D ERR_PTR(-ENOENT);

--Signature=_Mon__21_May_2012_18_23_43_+1000_BEbVYcF54GU_+R6w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPufuQAAoJEECxmPOUX5FE2NIP/3vbeiRUApFImv+7yQvLD7mL
X/uY5wBMlRcSbdWkCPRkWfU3hN+1NHVijTuw2NRwU88wILVD86cVXIYA7fSAia8Y
TurE8YJuMoTS/ItCIpET5yMV7x/w4jfAqXpzojQNAMjFceBN8ns8dAQ/5u/8L68S
m+sDPziMJkJ913wC0kDqGGbLUwDZMS6hzNoHASA7ljQzIPmY6ZZpLiFeibOtSIn4
UA752KXzrUDyV9/Gn7CZBCfpdHDkAz2a0rqrSDx5HP18v2M6k4D1vwDODLA6Rbo3
GuGh9MOXptcO9EnQKYnebmcVra/GGxNv/Ind+ATN+xm+pDQInyNzGSx1/yVoq2XC
j/2+QFk1njoso3+6J5ZOyf6xWUu/LoBHYM5LJGd5neg8xuW4UgCvSV0rWu5s1Zeh
l2yPkzL/kHOq872/IDkxRSMrJCFvxGr5aR/ocF2WFkQsQiM743WhazF/G6yHhP+x
olWlCWfupLZzIj4Z/t14WihBWKRU9rQWduZPE3AertZ2ibHTo6Kvp+uoU7QVpeTe
EWK0r1F3Nnnsmz66ijJOwWHBQYko/HPoP4RZBpQhA2FAxJ8lWJmL8nTf3oa7r96Q
fBcu5T98F7n4AvXLpiwCbXeIAoONT1k3R21zqhRoDjkTlnZUzCsHopxN505k7K50
eVQ+504Lc7h91HBMjtie
=Dthi
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_18_23_43_+1000_BEbVYcF54GU_+R6w--

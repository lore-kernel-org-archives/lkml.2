Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0EVKBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 06:01:39 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:49569 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab0EVKBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 06:01:35 -0400
Date: Sat, 22 May 2010 12:01:30 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 8/8] fs/affs: Use ERR_CAST
Message-ID: <Pine.LNX.4.64.1005221201150.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use ERR_CAST(x) rather than ERR_PTR(PTR_ERR(x)).  The former makes more
clear what is the purpose of the operation, which otherwise looks like a
no-op.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T x;
identifier f;
@@

T f (...) { <+...
- ERR_PTR(PTR_ERR(x))
+ x
 ...+> }

@@
expression x;
@@

- ERR_PTR(PTR_ERR(x))
+ ERR_CAST(x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/affs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/fs/affs/namei.c b/fs/affs/namei.c
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -224,7 +224,7 @@ affs_lookup(struct inode *dir, struct de
 		affs_brelse(bh);
 		inode = affs_iget(sb, ino);
 		if (IS_ERR(inode))
-			return ERR_PTR(PTR_ERR(inode));
+			return ERR_CAST(inode);
 	}
 	dentry->d_op = AFFS_SB(sb)->s_flags & SF_INTL ? &affs_intl_dentry_operations : &affs_dentry_operations;
 	d_add(dentry, inode);

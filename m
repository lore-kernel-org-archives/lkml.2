Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0EVKAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 06:00:47 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:53866 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab0EVKAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 06:00:43 -0400
Date: Sat, 22 May 2010 12:00:21 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Artem Bityutskiy <dedekind1@gmail.com>,
       Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/8] fs/ubifs: Use ERR_CAST
Message-ID: <Pine.LNX.4.64.1005221200050.13021@ask.diku.dk>
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
 fs/ubifs/lpt.c        |   14 +++++++-------
 fs/ubifs/lpt_commit.c |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -u -p a/fs/ubifs/lpt.c b/fs/ubifs/lpt.c
--- a/fs/ubifs/lpt.c
+++ b/fs/ubifs/lpt.c
@@ -1457,13 +1457,13 @@ struct ubifs_lprops *ubifs_lpt_lookup(st
 		shft -= UBIFS_LPT_FANOUT_SHIFT;
 		nnode = ubifs_get_nnode(c, nnode, iip);
 		if (IS_ERR(nnode))
-			return ERR_PTR(PTR_ERR(nnode));
+			return ERR_CAST(nnode);
 	}
 	iip = ((i >> shft) & (UBIFS_LPT_FANOUT - 1));
 	shft -= UBIFS_LPT_FANOUT_SHIFT;
 	pnode = ubifs_get_pnode(c, nnode, iip);
 	if (IS_ERR(pnode))
-		return ERR_PTR(PTR_ERR(pnode));
+		return ERR_CAST(pnode);
 	iip = (i & (UBIFS_LPT_FANOUT - 1));
 	dbg_lp("LEB %d, free %d, dirty %d, flags %d", lnum,
 	       pnode->lprops[iip].free, pnode->lprops[iip].dirty,
@@ -1586,7 +1586,7 @@ struct ubifs_lprops *ubifs_lpt_lookup_di
 	nnode = c->nroot;
 	nnode = dirty_cow_nnode(c, nnode);
 	if (IS_ERR(nnode))
-		return ERR_PTR(PTR_ERR(nnode));
+		return ERR_CAST(nnode);
 	i = lnum - c->main_first;
 	shft = c->lpt_hght * UBIFS_LPT_FANOUT_SHIFT;
 	for (h = 1; h < c->lpt_hght; h++) {
@@ -1594,19 +1594,19 @@ struct ubifs_lprops *ubifs_lpt_lookup_di
 		shft -= UBIFS_LPT_FANOUT_SHIFT;
 		nnode = ubifs_get_nnode(c, nnode, iip);
 		if (IS_ERR(nnode))
-			return ERR_PTR(PTR_ERR(nnode));
+			return ERR_CAST(nnode);
 		nnode = dirty_cow_nnode(c, nnode);
 		if (IS_ERR(nnode))
-			return ERR_PTR(PTR_ERR(nnode));
+			return ERR_CAST(nnode);
 	}
 	iip = ((i >> shft) & (UBIFS_LPT_FANOUT - 1));
 	shft -= UBIFS_LPT_FANOUT_SHIFT;
 	pnode = ubifs_get_pnode(c, nnode, iip);
 	if (IS_ERR(pnode))
-		return ERR_PTR(PTR_ERR(pnode));
+		return ERR_CAST(pnode);
 	pnode = dirty_cow_pnode(c, pnode);
 	if (IS_ERR(pnode))
-		return ERR_PTR(PTR_ERR(pnode));
+		return ERR_CAST(pnode);
 	iip = (i & (UBIFS_LPT_FANOUT - 1));
 	dbg_lp("LEB %d, free %d, dirty %d, flags %d", lnum,
 	       pnode->lprops[iip].free, pnode->lprops[iip].dirty,
diff -u -p a/fs/ubifs/lpt_commit.c b/fs/ubifs/lpt_commit.c
--- a/fs/ubifs/lpt_commit.c
+++ b/fs/ubifs/lpt_commit.c
@@ -646,7 +646,7 @@ static struct ubifs_pnode *pnode_lookup(
 		shft -= UBIFS_LPT_FANOUT_SHIFT;
 		nnode = ubifs_get_nnode(c, nnode, iip);
 		if (IS_ERR(nnode))
-			return ERR_PTR(PTR_ERR(nnode));
+			return ERR_CAST(nnode);
 	}
 	iip = ((i >> shft) & (UBIFS_LPT_FANOUT - 1));
 	return ubifs_get_pnode(c, nnode, iip);

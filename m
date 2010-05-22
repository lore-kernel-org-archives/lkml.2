Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0EVKBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 06:01:05 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:49559 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab0EVKBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 06:01:01 -0400
Date: Sat, 22 May 2010 12:00:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 6/8] mm: Use ERR_CAST
Message-ID: <Pine.LNX.4.64.1005221200380.13021@ask.diku.dk>
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
 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/mm/vmalloc.c b/mm/vmalloc.c
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -732,7 +732,7 @@ static struct vmap_block *new_vmap_block
 					node, gfp_mask);
 	if (unlikely(IS_ERR(va))) {
 		kfree(vb);
-		return ERR_PTR(PTR_ERR(va));
+		return ERR_CAST(va);
 	}
 
 	err = radix_tree_preload(gfp_mask);

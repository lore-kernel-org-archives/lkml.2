Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1AZPFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:05:39 -0500
Received: from mail09.linbit.com ([212.69.161.110]:50535 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1AZPFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:05:38 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2011 10:05:38 EST
From: Andreas Gruenbacher <agruen@linbit.com>
Organization: LINBIT
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Export the augmented rbtree helper functions
Date: Wed, 26 Jan 2011 15:55:36 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.36-rc7+; KDE/4.3.5; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101261555.36259.agruen@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The augmented rbtree helper functions are not exported to modules right now.  
Could this please still be fixed in 2.6.38?

(We have started using augmented rbtrees in the upcoming version of drbd.)

Thanks,
Andreas

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
---
 lib/rbtree.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 4693f79..a16be19 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -315,6 +315,7 @@ void rb_augment_insert(struct rb_node *node, rb_augment_f 
func, void *data)
 
 	rb_augment_path(node, func, data);
 }
+EXPORT_SYMBOL(rb_augment_insert);
 
 /*
  * before removing the node, find the deepest node on the rebalance path
@@ -340,6 +341,7 @@ struct rb_node *rb_augment_erase_begin(struct rb_node 
*node)
 
 	return deepest;
 }
+EXPORT_SYMBOL(rb_augment_erase_begin);
 
 /*
  * after removal, update the tree to account for the removed entry
@@ -350,6 +352,7 @@ void rb_augment_erase_end(struct rb_node *node, 
rb_augment_f func, void *data)
 	if (node)
 		rb_augment_path(node, func, data);
 }
+EXPORT_SYMBOL(rb_augment_erase_end);
 
 /*
  * This function returns the first node (in sort order) of the tree.

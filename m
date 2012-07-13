Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730Ab2GMAdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 20:33:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759342Ab2GMAdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 20:33:12 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH v2 12/12] rbtree: coding style adjustments
Date: Thu, 12 Jul 2012 17:31:57 -0700
Message-Id: <1342139517-3451-13-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342139517-3451-1-git-send-email-walken@google.com>
References: <1342139517-3451-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set comment and indentation style to be consistent with linux coding style
and the rest of the file, as suggested by Peter Zijlstra

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |   42 +++++++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index a38e473..0892670 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -363,8 +363,7 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		child = node->rb_right;
 	else if (!node->rb_right)
 		child = node->rb_left;
-	else
-	{
+	else {
 		struct rb_node *old = node, *left;
 
 		node = node->rb_right;
@@ -406,17 +405,15 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 
 	if (child)
 		rb_set_parent(child, parent);
-	if (parent)
-	{
+	if (parent) {
 		if (parent->rb_left == node)
 			parent->rb_left = child;
 		else
 			parent->rb_right = child;
-	}
-	else
+	} else
 		root->rb_node = child;
 
- color:
+color:
 	if (color == RB_BLACK)
 		__rb_erase_color(child, parent, root);
 }
@@ -529,8 +526,10 @@ struct rb_node *rb_next(const struct rb_node *node)
 	if (RB_EMPTY_NODE(node))
 		return NULL;
 
-	/* If we have a right-hand child, go down and then left as far
-	   as we can. */
+	/*
+	 * If we have a right-hand child, go down and then left as far
+	 * as we can.
+	 */
 	if (node->rb_right) {
 		node = node->rb_right; 
 		while (node->rb_left)
@@ -538,12 +537,13 @@ struct rb_node *rb_next(const struct rb_node *node)
 		return (struct rb_node *)node;
 	}
 
-	/* No right-hand children.  Everything down and left is
-	   smaller than us, so any 'next' node must be in the general
-	   direction of our parent. Go up the tree; any time the
-	   ancestor is a right-hand child of its parent, keep going
-	   up. First time it's a left-hand child of its parent, said
-	   parent is our 'next' node. */
+	/*
+	 * No right-hand children. Everything down and left is smaller than us,
+	 * so any 'next' node must be in the general direction of our parent.
+	 * Go up the tree; any time the ancestor is a right-hand child of its
+	 * parent, keep going up. First time it's a left-hand child of its
+	 * parent, said parent is our 'next' node.
+	 */
 	while ((parent = rb_parent(node)) && node == parent->rb_right)
 		node = parent;
 
@@ -558,8 +558,10 @@ struct rb_node *rb_prev(const struct rb_node *node)
 	if (RB_EMPTY_NODE(node))
 		return NULL;
 
-	/* If we have a left-hand child, go down and then right as far
-	   as we can. */
+	/*
+	 * If we have a left-hand child, go down and then right as far
+	 * as we can.
+	 */
 	if (node->rb_left) {
 		node = node->rb_left; 
 		while (node->rb_right)
@@ -567,8 +569,10 @@ struct rb_node *rb_prev(const struct rb_node *node)
 		return (struct rb_node *)node;
 	}
 
-	/* No left-hand children. Go up till we find an ancestor which
-	   is a right-hand child of its parent */
+	/*
+	 * No left-hand children. Go up till we find an ancestor which
+	 * is a right-hand child of its parent.
+	 */
 	while ((parent = rb_parent(node)) && node == parent->rb_left)
 		node = parent;
 
-- 
1.7.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab1GXIYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 04:24:18 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:45873 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1GXIYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 04:24:13 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl,
        Sasha Levin <levinsasha928@gmail.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH resend] Documentation: Update augmented rbtree documentation
Date: Sun, 24 Jul 2011 11:23:20 +0300
Message-Id: <1311495800-864-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current documentation referred to the old method
of handling augmented trees. Update documentation
to correspond with the changes done in commit
b945d6b2554d550fe95caadc61e521c0ad71fb9c.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---

Resending this patch again as it looks like it was forgotten.

 Documentation/rbtree.txt |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index 19f8278..8d32d85 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -196,15 +196,20 @@ Support for Augmented rbtrees
 Augmented rbtree is an rbtree with "some" additional data stored in each node.
 This data can be used to augment some new functionality to rbtree.
 Augmented rbtree is an optional feature built on top of basic rbtree
-infrastructure. rbtree user who wants this feature will have an augment
-callback function in rb_root initialized.
-
-This callback function will be called from rbtree core routines whenever
-a node has a change in one or both of its children. It is the responsibility
-of the callback function to recalculate the additional data that is in the
-rb node using new children information. Note that if this new additional
-data affects the parent node's additional data, then callback function has
-to handle it and do the recursive updates.
+infrastructure. An rbtree user who wants this feature will have to call the
+augmentation functions with the user provided augmentation callback
+when inserting and erasing nodes.
+
+On insertion, the user must call rb_augment_insert() once the new node is in
+place. This will cause the augmentation function callback to be called for
+each node between the new node and the root which has been affected by the
+insertion.
+
+When erasing a node, the user must call rb_augment_erase_begin() first to
+retrieve the deepest node on the rebalance path. Then, after erasing the
+original node, the user must call rb_augment_erase_end() with the deepest
+node found earlier. This will cause the augmentation function to be called
+for each affected node between the deepest node and the root.
 
 
 Interval tree is an example of augmented rb tree. Reference -
-- 
1.7.6


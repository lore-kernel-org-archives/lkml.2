Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1EPJ60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:58:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63172 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1EPJ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BIkPeEEyXh5yohPwfn853+ZYnD5iGB7cF79e/VqdiKaQEZasYrhW7EWHm5uNir2lWf
         XJQ882ea3VbsINQQhbM/FkNTqPsG1JPMVsoQ+SnwInF4hljgILX4mlWJ6wQWxPuzJxko
         heTMXbMc34ppu+upAYRyppsU7iYcSOmdB0g8U=
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Documentation: Update augmented rbtree documentation
Date: Mon, 16 May 2011 12:56:42 +0300
Message-Id: <1305539802-12509-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.5.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current documentation referred to the old method
of handling augmented trees. Update documentation
to correspond with the changes done in commit
b945d6b2554d550fe95caadc61e521c0ad71fb9c.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 Documentation/rbtree.txt |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index 19f8278..b847598 100644
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
+infrastructure. rbtree user who wants this feature will have to call the
+augmentation functions with the user provided augmentation callback
+when inserting and erasing nodes.
+
+On insertion, The user must call rb_augment_insert() once the new node is in
+place. This will cause the augmentation function callback to be called for
+each node between the new node and the root which have been affected by the
+insertion.
+
+When erasing a node, The user must call rb_augment_erase_begin() first to
+retrieve the deepest node on the rebalance path. Then, After erasing the
+original node, the user must call rb_augment_erase_end() with the deepest
+node found earlier. This will cause the augmentation function to be called
+for each affected node between the deepest node and the root.
 
 
 Interval tree is an example of augmented rb tree. Reference -
-- 
1.7.5.rc3


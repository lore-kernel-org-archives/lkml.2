Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab2IDQ22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:28:28 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49056 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757396Ab2IDQ2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:28:25 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 2/3] Documentation/rbtree.txt: Remove bogus description of rb_entry()
Date: Tue,  4 Sep 2012 17:28:09 +0100
Message-Id: <1346776090-4631-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346776090-4631-1-git-send-email-abbotti@mev.co.uk>
References: <1346776090-4631-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In two places, the document mentions that individual members of the
containing structure of the struct rb_node may be accessed by a macro
call such as rb_entry(node, type, member).  This is bogus, so remove the
offending text.

The example code used to amplify this bogosity, but that was fixed in a
patch by Wang Tinggong back in May/June 2009.  However, the example code
uses rb_entry() to access the containing structure whereas the preceding
paragraph (now) only mentions container_of(), so change the example to
match the preceding text.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 Documentation/rbtree.txt | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index d4a31e0..47a8cb5 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -64,8 +64,7 @@ Data nodes in an rbtree tree are structures containing a struct rb_node member:
   };
 
 When dealing with a pointer to the embedded struct rb_node, the containing data
-structure may be accessed with the standard container_of() macro.  In addition,
-individual members may be accessed directly via rb_entry(node, type, member).
+structure may be accessed with the standard container_of() macro.
 
 At the root of each rbtree is an rb_root structure, which is initialized to be
 empty via:
@@ -181,14 +180,13 @@ NULL when there are no more nodes left.
 
 The iterator functions return a pointer to the embedded struct rb_node, from
 which the containing data structure may be accessed with the container_of()
-macro, and individual members may be accessed directly via
-rb_entry(node, type, member).
+macro.
 
 Example:
 
   struct rb_node *node;
   for (node = rb_first(&mytree); node; node = rb_next(node))
-	printk("key=%s\n", rb_entry(node, struct mytype, node)->keystring);
+	printk("key=%s\n", container_of(node, struct mytype, node)->keystring);
 
 Support for Augmented rbtrees
 -----------------------------
-- 
1.7.12


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab0GTPvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:51:41 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42177 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab0GTPuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:50:52 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 20 Jul 2010 17:51:24 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 1/4] lib: rbtree: rb_root_init() function added
In-reply-to: <cover.1279639238.git.m.nazarewicz@samsung.com>
To: linux-mm@kvack.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a rb_root_init() function which initialises a rb_root
structure as a red-black tree with at most one element.  The
rationale is that using rb_root_init(root, node) is more
straightforward and cleaner then first initialising and
empty tree followed by an insert operation.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/rbtree.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 7066acb..5b6dc66 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -130,6 +130,17 @@ static inline void rb_set_color(struct rb_node *rb, int color)
 }
 
 #define RB_ROOT	(struct rb_root) { NULL, }
+
+static inline void rb_root_init(struct rb_root *root, struct rb_node *node)
+{
+	root->rb_node = node;
+	if (node) {
+		node->rb_parent_color = RB_BLACK; /* black, no parent */
+		node->rb_left  = NULL;
+		node->rb_right = NULL;
+	}
+}
+
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
 
 #define RB_EMPTY_ROOT(root)	((root)->rb_node == NULL)
-- 
1.7.1


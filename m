Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442Ab0HFNUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 09:20:49 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14489 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab0HFNUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 09:20:46 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 06 Aug 2010 15:22:07 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH/RFCv3 1/6] lib: rbtree: rb_root_init() function added
In-reply-to: <cover.1281100495.git.m.nazarewicz@samsung.com>
To: linux-mm@kvack.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Jonathan Corbet <corbet@lwn.net>, Pawel Osciak <p.osciak@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, jaeryul.oh@samsung.com,
        kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <743102607e2c5fb20e3c0676fadbcb93d501a78e.1281100495.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1281100495.git.m.nazarewicz@samsung.com>
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


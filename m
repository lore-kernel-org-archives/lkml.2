Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab0ELViL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:38:11 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36566 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067Ab0ELVdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:33:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH RFC tip/core/rcu 15/23] radix-tree: __rcu annotations
Date: Wed, 12 May 2010 14:33:34 -0700
Message-Id: <1273700022-16523-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
---
 include/linux/radix-tree.h |    4 +++-
 lib/radix-tree.c           |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 55ca73c..d801044 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -47,6 +47,8 @@ static inline void *radix_tree_indirect_to_ptr(void *ptr)
 {
 	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
 }
+#define radix_tree_indirect_to_ptr(ptr) \
+	radix_tree_indirect_to_ptr((void __force *)(ptr))
 
 static inline int radix_tree_is_indirect_ptr(void *ptr)
 {
@@ -61,7 +63,7 @@ static inline int radix_tree_is_indirect_ptr(void *ptr)
 struct radix_tree_root {
 	unsigned int		height;
 	gfp_t			gfp_mask;
-	struct radix_tree_node	*rnode;
+	struct radix_tree_node	__rcu *rnode;
 };
 
 #define RADIX_TREE_INIT(mask)	{					\
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 2a087e0..08f86cc 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -49,7 +49,7 @@ struct radix_tree_node {
 	unsigned int	height;		/* Height from the bottom */
 	unsigned int	count;
 	struct rcu_head	rcu_head;
-	void		*slots[RADIX_TREE_MAP_SIZE];
+	void __rcu	*slots[RADIX_TREE_MAP_SIZE];
 	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
 };
 
-- 
1.7.0.6


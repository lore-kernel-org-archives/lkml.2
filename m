Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab1AYRW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:22:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:47040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1AYRW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/29] perf callchain: Don't give arbitrary gender to callchain tree nodes
Date: Tue, 25 Jan 2011 15:21:43 -0200
Message-Id: <1295976112-2796-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Some little callchain tree nodes shyly asked me if they can have
sisters.

How cute!

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294977121-5700-5-git-send-email-fweisbec@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c |    8 ++++----
 tools/perf/util/callchain.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 5b3f09d..f8c66d1 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -26,10 +26,10 @@ bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event)
 }
 
 #define chain_for_each_child(child, parent)	\
-	list_for_each_entry(child, &parent->children, brothers)
+	list_for_each_entry(child, &parent->children, siblings)
 
 #define chain_for_each_child_safe(child, next, parent)	\
-	list_for_each_entry_safe(child, next, &parent->children, brothers)
+	list_for_each_entry_safe(child, next, &parent->children, siblings)
 
 static void
 rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
@@ -189,7 +189,7 @@ create_child(struct callchain_node *parent, bool inherit_children)
 		chain_for_each_child(next, new)
 			next->parent = new;
 	}
-	list_add_tail(&new->brothers, &parent->children);
+	list_add_tail(&new->siblings, &parent->children);
 
 	return new;
 }
@@ -419,7 +419,7 @@ merge_chain_branch(struct callchain_cursor *cursor,
 		if (err)
 			break;
 
-		list_del(&child->brothers);
+		list_del(&child->siblings);
 		free(child);
 	}
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 2bb5403..6713725 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -16,7 +16,7 @@ enum chain_mode {
 
 struct callchain_node {
 	struct callchain_node	*parent;
-	struct list_head	brothers;
+	struct list_head	siblings;
 	struct list_head	children;
 	struct list_head	val;
 	struct rb_node		rb_node; /* to sort nodes in an rbtree */
@@ -72,7 +72,7 @@ struct callchain_cursor {
 
 static inline void callchain_init(struct callchain_root *root)
 {
-	INIT_LIST_HEAD(&root->node.brothers);
+	INIT_LIST_HEAD(&root->node.siblings);
 	INIT_LIST_HEAD(&root->node.children);
 	INIT_LIST_HEAD(&root->node.val);
 
-- 
1.6.2.5


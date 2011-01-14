Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab1ANDwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:52:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab1ANDwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:52:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=npqvDFId7WeJ+z8k9l8vPFHbFWpJNHK1lWxyxB88VdhkfMqtGrSSDBJW8SwFiWLzFt
         PuwJwKhX3HqvclsSQj1tNEoXsc1z/MSYpCdct1FxPr3ds0joHTVsvQmZAX51ow6dQSwe
         kDCBR2d9RbtfRqbKxmdCVN3X9UQ6/JLfYlK+4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/4] perf: Don't give arbitrary gender to callchain tree nodes
Date: Fri, 14 Jan 2011 04:52:01 +0100
Message-Id: <1294977121-5700-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1294977121-5700-1-git-send-email-fweisbec@gmail.com>
References: <1294977121-5700-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some little callchain tree nodes shyly asked me if they can have
sisters.

How cute!

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
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
1.7.3.2


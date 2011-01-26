Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1AZHVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:21:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:53305 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab1AZHVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:21:53 -0500
Date: Wed, 26 Jan 2011 07:21:29 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1294977121-5700-5-git-send-email-fweisbec@gmail.com>
References: <1294977121-5700-5-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain: Don't give arbitrary gender to callchain tree nodes
Message-ID: <tip-529363b76929beb85b81439c61063130af046a21@git.kernel.org>
Git-Commit-ID: 529363b76929beb85b81439c61063130af046a21
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:21:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  529363b76929beb85b81439c61063130af046a21
Gitweb:     http://git.kernel.org/tip/529363b76929beb85b81439c61063130af046a21
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 14 Jan 2011 04:52:01 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:31 -0200

perf callchain: Don't give arbitrary gender to callchain tree nodes

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
 

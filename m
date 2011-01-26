Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1AZHVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:21:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:53269 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab1AZHVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:21:10 -0500
Date: Wed, 26 Jan 2011 07:20:42 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1294977121-5700-3-git-send-email-fweisbec@gmail.com>
References: <1294977121-5700-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain: Rename cumul_hits into callchain_cumul_hits
Message-ID: <tip-f08c3154ac439c4b5762a40107d84e839e08fbc5@git.kernel.org>
Git-Commit-ID: f08c3154ac439c4b5762a40107d84e839e08fbc5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:20:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f08c3154ac439c4b5762a40107d84e839e08fbc5
Gitweb:     http://git.kernel.org/tip/f08c3154ac439c4b5762a40107d84e839e08fbc5
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 14 Jan 2011 04:51:59 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:31 -0200

perf callchain: Rename cumul_hits into callchain_cumul_hits

That makes the callchain API naming more consistent and
reduce potential naming clashes.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294977121-5700-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c         |   10 +++++-----
 tools/perf/util/callchain.h         |    2 +-
 tools/perf/util/hist.c              |    2 +-
 tools/perf/util/ui/browsers/hists.c |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 53a49e0..4c6360f 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -38,14 +38,14 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct callchain_node *rnode;
-	u64 chain_cumul = cumul_hits(chain);
+	u64 chain_cumul = callchain_cumul_hits(chain);
 
 	while (*p) {
 		u64 rnode_cumul;
 
 		parent = *p;
 		rnode = rb_entry(parent, struct callchain_node, rb_node);
-		rnode_cumul = cumul_hits(rnode);
+		rnode_cumul = callchain_cumul_hits(rnode);
 
 		switch (mode) {
 		case CHAIN_FLAT:
@@ -104,7 +104,7 @@ static void __sort_chain_graph_abs(struct callchain_node *node,
 
 	chain_for_each_child(child, node) {
 		__sort_chain_graph_abs(child, min_hit);
-		if (cumul_hits(child) >= min_hit)
+		if (callchain_cumul_hits(child) >= min_hit)
 			rb_insert_callchain(&node->rb_root, child,
 					    CHAIN_GRAPH_ABS);
 	}
@@ -129,7 +129,7 @@ static void __sort_chain_graph_rel(struct callchain_node *node,
 
 	chain_for_each_child(child, node) {
 		__sort_chain_graph_rel(child, min_percent);
-		if (cumul_hits(child) >= min_hit)
+		if (callchain_cumul_hits(child) >= min_hit)
 			rb_insert_callchain(&node->rb_root, child,
 					    CHAIN_GRAPH_REL);
 	}
@@ -270,7 +270,7 @@ split_add_child(struct callchain_node *parent,
 	/* split the hits */
 	new->hit = parent->hit;
 	new->children_hit = parent->children_hit;
-	parent->children_hit = cumul_hits(new);
+	parent->children_hit = callchain_cumul_hits(new);
 	new->val_nr = parent->val_nr - idx_local;
 	parent->val_nr = idx_local;
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index d74a19a..07f71e3 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -82,7 +82,7 @@ static inline void callchain_init(struct callchain_root *root)
 	root->max_depth = 0;
 }
 
-static inline u64 cumul_hits(struct callchain_node *node)
+static inline u64 callchain_cumul_hits(struct callchain_node *node)
 {
 	return node->hit + node->children_hit;
 }
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index a438a06..02ed318 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -430,7 +430,7 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 		u64 cumul;
 
 		child = rb_entry(node, struct callchain_node, rb_node);
-		cumul = cumul_hits(child);
+		cumul = callchain_cumul_hits(child);
 		remaining -= cumul;
 
 		/*
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 60c463c..8642823 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -377,7 +377,7 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
 	while (node) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
 		struct rb_node *next = rb_next(node);
-		u64 cumul = cumul_hits(child);
+		u64 cumul = callchain_cumul_hits(child);
 		struct callchain_list *chain;
 		char folded_sign = ' ';
 		int first = true;

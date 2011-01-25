Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1AYRWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:22:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48523 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab1AYRWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/29] perf callchain: Rename register_callchain_param into callchain_register_param
Date: Tue, 25 Jan 2011 15:21:42 -0200
Message-Id: <1295976112-2796-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

To make the callchain API naming more consistent.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294977121-5700-4-git-send-email-fweisbec@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    4 ++--
 tools/perf/util/callchain.c |    2 +-
 tools/perf/util/callchain.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c95599a..f6a4349 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -221,7 +221,7 @@ static int perf_session__setup_sample_type(struct perf_session *self)
 	} else if (!dont_use_callchains && callchain_param.mode != CHAIN_NONE &&
 		   !symbol_conf.use_callchain) {
 			symbol_conf.use_callchain = true;
-			if (register_callchain_param(&callchain_param) < 0) {
+			if (callchain_register_param(&callchain_param) < 0) {
 				fprintf(stderr, "Can't register callchain"
 						" params\n");
 				return -EINVAL;
@@ -423,7 +423,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 	if (tok2)
 		callchain_param.print_limit = strtod(tok2, &endptr);
 setup:
-	if (register_callchain_param(&callchain_param) < 0) {
+	if (callchain_register_param(&callchain_param) < 0) {
 		fprintf(stderr, "Can't register callchain params\n");
 		return -1;
 	}
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 4c6360f..5b3f09d 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -143,7 +143,7 @@ sort_chain_graph_rel(struct rb_root *rb_root, struct callchain_root *chain_root,
 	rb_root->rb_node = chain_root->node.rb_root.rb_node;
 }
 
-int register_callchain_param(struct callchain_param *param)
+int callchain_register_param(struct callchain_param *param)
 {
 	switch (param->mode) {
 	case CHAIN_GRAPH_ABS:
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 07f71e3..2bb5403 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -87,7 +87,7 @@ static inline u64 callchain_cumul_hits(struct callchain_node *node)
 	return node->hit + node->children_hit;
 }
 
-int register_callchain_param(struct callchain_param *param);
+int callchain_register_param(struct callchain_param *param);
 int callchain_append(struct callchain_root *root,
 		     struct callchain_cursor *cursor,
 		     u64 period);
-- 
1.6.2.5


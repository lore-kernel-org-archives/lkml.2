Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab1ANDwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:52:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51164 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab1ANDwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:52:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UAv8NdSLlQ+7qbsu4RzLfo+9rDKhAhOlmxA19GTiD9O/6KW9nWmAlNjHDSjUDso97L
         HznZiRDoPi1CN2G+jKUF5nEbF+9pu1L1dSkedclRPNp9zLsGSg/Vgg3ucKiO77ZOLXRZ
         12gk4u90AetF/4kQcJbPb/wLS1EouC9FhY1gg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/4] perf: Rename register_callchain_param into callchain_register_param
Date: Fri, 14 Jan 2011 04:52:00 +0100
Message-Id: <1294977121-5700-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1294977121-5700-1-git-send-email-fweisbec@gmail.com>
References: <1294977121-5700-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make the callchain API naming more consistent.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-report.c |    4 ++--
 tools/perf/util/callchain.c |    2 +-
 tools/perf/util/callchain.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6451869..609f88f 100644
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
1.7.3.2


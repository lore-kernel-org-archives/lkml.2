Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1AZHVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:21:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:53284 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab1AZHVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:21:34 -0500
Date: Wed, 26 Jan 2011 07:21:06 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1294977121-5700-4-git-send-email-fweisbec@gmail.com>
References: <1294977121-5700-4-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain: Rename register_callchain_param into callchain_register_param
Message-ID: <tip-16537f1355017a285b904bfb6bf767464293e69c@git.kernel.org>
Git-Commit-ID: 16537f1355017a285b904bfb6bf767464293e69c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:21:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16537f1355017a285b904bfb6bf767464293e69c
Gitweb:     http://git.kernel.org/tip/16537f1355017a285b904bfb6bf767464293e69c
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 14 Jan 2011 04:52:00 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:31 -0200

perf callchain: Rename register_callchain_param into callchain_register_param

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

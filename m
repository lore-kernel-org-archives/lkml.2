Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2GJMx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:53:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49407 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2GJMxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:53:25 -0400
MIME-Version: 1.0
Date: Tue, 10 Jul 2012 20:53:24 +0800
Message-ID: <CACV3sb+eAdjM4YJ5_jcpSSgtdM2A=BnLROig3xOONQTfbyzfCA@mail.gmail.com>
Subject: [PATCH] perf: fix perf-report display ip string incorrectly
From: Jovi Zhang <bookjovi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bfc2eb1ac844b6d5f64e36eb01464a1cfba39663 Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Wed, 11 Jul 2012 04:32:15 +0800
Subject: [PATCH] perf: fix perf-report display ip string incorrectly

This patch fix perf ui browser cannot display ip string correctly
when using perf-report.

"char ipstr[BITS_PER_LONG / 4 + 1]" cannot reserve enough space
for ip string, for example string 0x80049ede need 13 bytes,
so change it to "BITS_PER_LONG / 4 + 3".

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 tools/perf/ui/browsers/hists.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 53f6697..a17c9c7 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -386,6 +386,8 @@ static char *callchain_list__sym_name(struct
callchain_list *cl,

 #define LEVEL_OFFSET_STEP 3

+#define IPSTR_LEN (BITS_PER_LONG / 4 + 3)
+
 static int hist_browser__show_callchain_node_rb_tree(struct
hist_browser *browser,
 						     struct callchain_node *chain_node,
 						     u64 total, int level,
@@ -416,7 +418,7 @@ static int
hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 		remaining -= cumul;

 		list_for_each_entry(chain, &child->val, list) {
-			char ipstr[BITS_PER_LONG / 4 + 1], *alloc_str;
+			char ipstr[IPSTR_LEN], *alloc_str;
 			const char *str;
 			int color;
 			bool was_first = first;
@@ -492,7 +494,7 @@ static int
hist_browser__show_callchain_node(struct hist_browser *browser,
 	char folded_sign = ' ';

 	list_for_each_entry(chain, &node->val, list) {
-		char ipstr[BITS_PER_LONG / 4 + 1], *s;
+		char ipstr[IPSTR_LEN], *s;
 		int color;

 		folded_sign = callchain_list__folded(chain);
-- 
1.7.9.7

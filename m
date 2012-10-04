Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2JDMzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:55:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2JDMvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:51:40 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/20] perf hists: Move he->stat.nr_events initialization to a template
Date: Thu,  4 Oct 2012 21:49:42 +0900
Message-Id: <1349354994-17853-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since it is set to 1 for a new hist entry, no need to set to
separately.  Move it to a template entry.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 3197f3f50018..02476cb3167d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -223,7 +223,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 	if (he != NULL) {
 		*he = *template;
-		he->stat.nr_events = 1;
+
 		if (he->ms.map)
 			he->ms.map->referenced = true;
 		if (symbol_conf.use_callchain)
@@ -323,6 +323,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.level	= al->level,
 		.stat = {
 			.period	= period,
+			.nr_events = 1,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
@@ -348,6 +349,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.level	= al->level,
 		.stat = {
 			.period	= period,
+			.nr_events = 1,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
-- 
1.7.9.2


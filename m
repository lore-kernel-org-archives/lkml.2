Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2IMHcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:32:33 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46467 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab2IMH1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:04 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-f1-50518ac65cdd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 03/15] perf hists: Move he->stat.nr_events initialization to a template
Date: Thu, 13 Sep 2012 16:19:59 +0900
Message-Id: <1347520811-28150-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since it is set to 1 for a new hist entry, no need to set to
separately.  Move it to a template entry.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index ab3d11491991..ef39e6714cbb 100644
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
@@ -347,6 +348,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.level	= al->level,
 		.stat = {
 			.period	= period,
+			.nr_events = 1,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
-- 
1.7.11.4


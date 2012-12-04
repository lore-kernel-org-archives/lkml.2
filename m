Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2LDEor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 23:44:47 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51198 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2LDEop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 23:44:45 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-00-50bd7fbcb314
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf hists: Exchange order of comparing items when collapsing hists
Date: Tue,  4 Dec 2012 13:44:23 +0900
Message-Id: <1354596265-9901-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354596265-9901-1-git-send-email-namhyung@kernel.org>
References: <1354596265-9901-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When comparing entries for collapsing put the given entry first, and
then the iterated entry.  This is not the case of hist_entry__cmp()
when called if given sort keys don't require collapsing.  So change
the order for the sake of consistency.  It will be required for
matching and/or linking multiple hist entries.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 82df1b26f0d4..161c35e7ed0e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -433,7 +433,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node_in);
 
-		cmp = hist_entry__collapse(iter, he);
+		cmp = hist_entry__collapse(he, iter);
 
 		if (!cmp) {
 			he_stat__add_stat(&iter->stat, &he->stat);
-- 
1.7.11.7


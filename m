Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab2K2Gnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:43:51 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57376 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab2K2GjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:08 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-c3-50b70309eae1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 07/18] perf hists: Exchange order of comparing items when collapsing hists
Date: Thu, 29 Nov 2012 15:38:35 +0900
Message-Id: <1354171126-14387-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When comparing entries for collapsing put the given entry first, and
then the iterated entry.  This is for the sake of consistency and will
be required by the event group report.

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


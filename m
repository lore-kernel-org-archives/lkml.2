Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab2K2Gon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:44:43 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63188 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab2K2GjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:07 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-b9-50b70309118f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 05/18] perf tools: Fix typo on hist__entry_add_pair
Date: Thu, 29 Nov 2012 15:38:33 +0900
Message-Id: <1354171126-14387-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Fix a misplaced underscore.  In this case, 'hist_entry' is the name of
data structure and we usually put double underscores between data
structure and actual function name.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 4 ++--
 tools/perf/util/sort.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cb17e2a8c6ed..d2bc05cd1708 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -785,7 +785,7 @@ void hists__match(struct hists *leader, struct hists *other)
 		pair = hists__find_entry(other, pos);
 
 		if (pair)
-			hist__entry_add_pair(pos, pair);
+			hist_entry__add_pair(pos, pair);
 	}
 }
 
@@ -806,7 +806,7 @@ int hists__link(struct hists *leader, struct hists *other)
 			pair = hists__add_dummy_entry(leader, pos);
 			if (pair == NULL)
 				return -1;
-			hist__entry_add_pair(pair, pos);
+			hist_entry__add_pair(pair, pos);
 		}
 	}
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b4e8c3ba559d..91ae2744e7d5 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -118,7 +118,7 @@ static inline struct hist_entry *hist_entry__next_pair(struct hist_entry *he)
 	return NULL;
 }
 
-static inline void hist__entry_add_pair(struct hist_entry *he,
+static inline void hist_entry__add_pair(struct hist_entry *he,
 					struct hist_entry *pair)
 {
 	list_add_tail(&he->pairs.head, &pair->pairs.node);
-- 
1.7.11.7


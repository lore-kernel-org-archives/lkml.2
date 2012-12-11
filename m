Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2LKWsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:48:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43840 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab2LKWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/37] perf hists: Fix typo on hist__entry_add_pair
Date: Tue, 11 Dec 2012 19:47:57 -0300
Message-Id: <1355266103-17238-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Fix a misplaced underscore.  In this case, 'hist_entry' is the name of
data structure and we usually put double underscores between data
structure and actual function name.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8jdq8g6kl6v54hkexrfwsy72@git.kernel.org
[ committer note: put it in front of the patch queue where it came from ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    4 ++--
 tools/perf/util/sort.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cb17e2a..d2bc05c 100644
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
index b4e8c3b..91ae274 100644
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
1.7.9.2.358.g22243


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2L0JMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:12:46 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45445 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2L0JMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:12:32 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-19-50dc10fc7875
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/10] perf sort: Clean up sort__first_dimension setting
Date: Thu, 27 Dec 2012 18:11:45 +0900
Message-Id: <1356599507-14226-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It doesn't need to compare to every sort key names since the index
already has the required information.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9f827e25a2b5..a5e732a03bda 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -515,30 +515,8 @@ int sort_dimension__add(const char *tok)
 		if (sd->entry->se_collapse)
 			sort__need_collapse = 1;
 
-		if (list_empty(&hist_entry__sort_list)) {
-			if (!strcmp(sd->name, "pid"))
-				sort__first_dimension = SORT_PID;
-			else if (!strcmp(sd->name, "comm"))
-				sort__first_dimension = SORT_COMM;
-			else if (!strcmp(sd->name, "dso"))
-				sort__first_dimension = SORT_DSO;
-			else if (!strcmp(sd->name, "symbol"))
-				sort__first_dimension = SORT_SYM;
-			else if (!strcmp(sd->name, "parent"))
-				sort__first_dimension = SORT_PARENT;
-			else if (!strcmp(sd->name, "cpu"))
-				sort__first_dimension = SORT_CPU;
-			else if (!strcmp(sd->name, "symbol_from"))
-				sort__first_dimension = SORT_SYM_FROM;
-			else if (!strcmp(sd->name, "symbol_to"))
-				sort__first_dimension = SORT_SYM_TO;
-			else if (!strcmp(sd->name, "dso_from"))
-				sort__first_dimension = SORT_DSO_FROM;
-			else if (!strcmp(sd->name, "dso_to"))
-				sort__first_dimension = SORT_DSO_TO;
-			else if (!strcmp(sd->name, "mispredict"))
-				sort__first_dimension = SORT_MISPREDICT;
-		}
+		if (list_empty(&hist_entry__sort_list))
+			sort__first_dimension = i;
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
 		sd->taken = 1;
-- 
1.7.11.7


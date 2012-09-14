Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab2INImn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:42:43 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46074 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2INImf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:42:35 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-bb-5052edf8d71a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/3] perf tools: Add sort__has_sym
Date: Fri, 14 Sep 2012 17:35:27 +0900
Message-Id: <1347611729-16994-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The sort__has_sym variable is for checking whether the sort_list
includes 'symbol' as a sort key.  It will be used for later patch.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 5 +++++
 tools/perf/util/sort.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 0981bc7a2917..b5b1b9211960 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -8,6 +8,7 @@ const char	default_sort_order[] = "comm,dso,symbol";
 const char	*sort_order = default_sort_order;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
+int		sort__has_sym = 0;
 int		sort__branch_mode = -1; /* -1 = means not set */
 
 enum sort_type	sort__first_dimension;
@@ -511,6 +512,10 @@ int sort_dimension__add(const char *tok)
 				return -EINVAL;
 			}
 			sort__has_parent = 1;
+		} else if (sd->entry == &sort_sym ||
+			   sd->entry == &sort_sym_from ||
+			   sd->entry == &sort_sym_to) {
+			sort__has_sym = 1;
 		}
 
 		if (sd->taken)
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index e459c981b039..12d634792de5 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -31,6 +31,7 @@ extern const char *parent_pattern;
 extern const char default_sort_order[];
 extern int sort__need_collapse;
 extern int sort__has_parent;
+extern int sort__has_sym;
 extern int sort__branch_mode;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
-- 
1.7.11.4


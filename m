Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2IQRXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:23:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57909 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab2IQRSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/18] perf tools: Add sort__has_sym
Date: Mon, 17 Sep 2012 14:18:01 -0300
Message-Id: <1347902292-14536-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The sort__has_sym variable is for checking whether the sort_list
includes 'symbol' as a sort key.  It will be used for later patch.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347611729-16994-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c |    5 +++++
 tools/perf/util/sort.h |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 0981bc7..b5b1b92 100644
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
index e459c98..12d6347 100644
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
1.7.1


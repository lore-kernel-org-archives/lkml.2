Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab2IFPs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:48:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758581Ab2IFPsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:48:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 02/12] perf tools: Replace sort's standalone field_sep with symbol_conf.field_sep
Date: Thu,  6 Sep 2012 17:46:56 +0200
Message-Id: <1346946426-13496-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The repsep_snprintf function was still using standalone field_sep,
which not even set anymore.

Replacing it with 'symbol_conf.field_sep'.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/sort.c | 6 ++----
 tools/perf/util/sort.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 0f5a0a4..7a2fbd8 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -12,8 +12,6 @@ int		sort__branch_mode = -1; /* -1 = means not set */
 
 enum sort_type	sort__first_dimension;
 
-char * field_sep;
-
 LIST_HEAD(hist_entry__sort_list);
 
 static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
@@ -23,11 +21,11 @@ static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
 
 	va_start(ap, fmt);
 	n = vsnprintf(bf, size, fmt, ap);
-	if (field_sep && n > 0) {
+	if (symbol_conf.field_sep && n > 0) {
 		char *sep = bf;
 
 		while (1) {
-			sep = strchr(sep, *field_sep);
+			sep = strchr(sep, *symbol_conf.field_sep);
 			if (sep == NULL)
 				break;
 			*sep = '.';
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index e724b26..e459c98 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -32,7 +32,6 @@ extern const char default_sort_order[];
 extern int sort__need_collapse;
 extern int sort__has_parent;
 extern int sort__branch_mode;
-extern char *field_sep;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
 extern struct sort_entry sort_sym;
-- 
1.7.11.4


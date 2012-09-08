Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2IHLnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:43:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2IHLnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:43:12 -0400
Date: Sat, 8 Sep 2012 04:42:43 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-0ca0c130419a4aa05d28fbecc5d360f051944251@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1346946426-13496-3-git-send-email-jolsa@redhat.com>
References: <1346946426-13496-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Replace sort'
 s standalone field_sep with symbol_conf.field_sep
Git-Commit-ID: 0ca0c130419a4aa05d28fbecc5d360f051944251
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 08 Sep 2012 04:42:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ca0c130419a4aa05d28fbecc5d360f051944251
Gitweb:     http://git.kernel.org/tip/0ca0c130419a4aa05d28fbecc5d360f051944251
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 6 Sep 2012 17:46:56 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Sep 2012 21:50:11 -0300

perf tools: Replace sort's standalone field_sep with symbol_conf.field_sep

The repsep_snprintf function was still using standalone field_sep, which
not even set anymore.

Replacing it with 'symbol_conf.field_sep'.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346946426-13496-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c |    6 ++----
 tools/perf/util/sort.h |    1 -
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

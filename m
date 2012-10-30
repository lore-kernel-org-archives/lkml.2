Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab2J3MCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:02:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40839 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab2J3MC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:02:29 -0400
Date: Tue, 30 Oct 2012 05:01:58 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-b2aff5f615793fa4c1313d82635b83cd7de8d9fd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351372712-21104-4-git-send-email-jolsa@redhat.com>
References: <1351372712-21104-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move hex2u64 into util object
Git-Commit-ID: b2aff5f615793fa4c1313d82635b83cd7de8d9fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:02:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2aff5f615793fa4c1313d82635b83cd7de8d9fd
Gitweb:     http://git.kernel.org/tip/b2aff5f615793fa4c1313d82635b83cd7de8d9fd
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 27 Oct 2012 23:18:30 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Oct 2012 11:36:02 -0200

perf tools: Move hex2u64 into util object

Moving hex2u64 function into util object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351372712-21104-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   33 ---------------------------------
 tools/perf/util/symbol.h |    1 -
 tools/perf/util/util.c   |   33 +++++++++++++++++++++++++++++++++
 tools/perf/util/util.h   |    1 +
 4 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e36e8c2..08b8257 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2050,39 +2050,6 @@ int machines__create_kernel_maps(struct rb_root *machines, pid_t pid)
 	return machine__create_kernel_maps(machine);
 }
 
-static int hex(char ch)
-{
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
-	return -1;
-}
-
-/*
- * While we find nice hex chars, build a long_val.
- * Return number of chars processed.
- */
-int hex2u64(const char *ptr, u64 *long_val)
-{
-	const char *p = ptr;
-	*long_val = 0;
-
-	while (*p) {
-		const int hex_val = hex(*p);
-
-		if (hex_val < 0)
-			break;
-
-		*long_val = (*long_val << 4) | hex_val;
-		p++;
-	}
-
-	return p - ptr;
-}
-
 char *strxfrchar(char *s, char from, char to)
 {
 	char *p = s;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 6eb7d3b..bc34dc1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -40,7 +40,6 @@ static inline char *bfd_demangle(void __maybe_unused *v,
 #endif
 #endif
 
-int hex2u64(const char *ptr, u64 *val);
 char *strxfrchar(char *s, char from, char to);
 
 /*
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 637b5cc..5906e84 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -166,6 +166,39 @@ size_t hex_width(u64 v)
 	return n;
 }
 
+static int hex(char ch)
+{
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+
+/*
+ * While we find nice hex chars, build a long_val.
+ * Return number of chars processed.
+ */
+int hex2u64(const char *ptr, u64 *long_val)
+{
+	const char *p = ptr;
+	*long_val = 0;
+
+	while (*p) {
+		const int hex_val = hex(*p);
+
+		if (hex_val < 0)
+			break;
+
+		*long_val = (*long_val << 4) | hex_val;
+		p++;
+	}
+
+	return p - ptr;
+}
+
 /* Obtain a backtrace and print it to stdout. */
 #ifdef BACKTRACE_SUPPORT
 void dump_stack(void)
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 0d85209..d6c22c5 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -262,6 +262,7 @@ bool is_power_of_2(unsigned long n)
 }
 
 size_t hex_width(u64 v);
+int hex2u64(const char *ptr, u64 *val);
 
 char *rtrim(char *s);
 

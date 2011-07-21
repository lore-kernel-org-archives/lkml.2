Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab1GUKEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:04:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:55986 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab1GUKEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:04:22 -0400
Date: Thu, 21 Jul 2011 10:03:51 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-bad03ae476214d9d66bb96be02b630385936f788@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110627072715.6528.10677.stgit@fedora15>
References: <20110627072715.6528.10677.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Move strtailcmp to string.c
Git-Commit-ID: bad03ae476214d9d66bb96be02b630385936f788
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:03:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bad03ae476214d9d66bb96be02b630385936f788
Gitweb:     http://git.kernel.org/tip/bad03ae476214d9d66bb96be02b630385936f788
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 27 Jun 2011 16:27:15 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 15 Jul 2011 16:00:47 -0400

perf probe: Move strtailcmp to string.c

Since strtailcmp() is enough generic, it should be defined in string.c.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/20110627072715.6528.10677.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/probe-finder.c |   15 ---------------
 tools/perf/util/string.c       |   19 +++++++++++++++++++
 tools/perf/util/util.h         |    1 +
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 7b78904..459ebe8 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -43,21 +43,6 @@
 /* Kprobe tracer basic type is up to u64 */
 #define MAX_BASIC_TYPE_BITS	64
 
-/*
- * Compare the tail of two strings.
- * Return 0 if whole of either string is same as another's tail part.
- */
-static int strtailcmp(const char *s1, const char *s2)
-{
-	int i1 = strlen(s1);
-	int i2 = strlen(s2);
-	while (--i1 >= 0 && --i2 >= 0) {
-		if (s1[i1] != s2[i2])
-			return s1[i1] - s2[i2];
-	}
-	return 0;
-}
-
 /* Line number list operations */
 
 /* Add a line to line number list */
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index b9a985d..d583638 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -294,3 +294,22 @@ bool strlazymatch(const char *str, const char *pat)
 {
 	return __match_glob(str, pat, true);
 }
+
+/**
+ * strtailcmp - Compare the tail of two strings
+ * @s1: 1st string to be compared
+ * @s2: 2nd string to be compared
+ *
+ * Return 0 if whole of either string is same as another's tail part.
+ */
+int strtailcmp(const char *s1, const char *s2)
+{
+	int i1 = strlen(s1);
+	int i2 = strlen(s2);
+	while (--i1 >= 0 && --i2 >= 0) {
+		if (s1[i1] != s2[i2])
+			return s1[i1] - s2[i2];
+	}
+	return 0;
+}
+
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index fc78428..0128906 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -238,6 +238,7 @@ char **argv_split(const char *str, int *argcp);
 void argv_free(char **argv);
 bool strglobmatch(const char *str, const char *pat);
 bool strlazymatch(const char *str, const char *pat);
+int strtailcmp(const char *s1, const char *s2);
 unsigned long convert_unit(unsigned long value, char *unit);
 int readn(int fd, void *buf, size_t size);
 

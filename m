Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab1C3JdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:33:08 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41668 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab1C3JdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:33:02 -0400
X-AuditID: b753bd60-a50bbba000004916-75-4d92f8cc3ba0
X-AuditID: b753bd60-a50bbba000004916-75-4d92f8cc3ba0
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  07/12] [CLEANUP]perf probe: Move strtailcmp to string.c
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 30 Mar 2011 18:26:17 +0900
Message-ID: <20110330092617.2132.23607.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since strtailcmp() is enough generic, it should be defined in string.c.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/util/probe-finder.c |   15 ---------------
 tools/perf/util/string.c       |   19 +++++++++++++++++++
 tools/perf/util/util.h         |    1 +
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index f6535d1..e258eb3 100644
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
index 8fc0bd3..f2da85c 100644
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
 


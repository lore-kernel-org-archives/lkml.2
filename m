Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1GPLZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:25:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1GPLW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:59 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=XmfyknDbjnIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=h3sCQ_blAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=lkXS5wFa-qtCbEOw92wA:9 a=qNarISWaI0BIPJAmuw8A:7 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=dowx1zmaLagA:10 a=fNChW5oJl9MA:10 a=jeBq3FmKZ4MA:10 a=y8P_g_uqTfhlJ3YI:21 a=r8Yxzw6cmNQXPpeF:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112255.272729011@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 15/20] perf probe: Move strtailcmp to string.c
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0015-perf-probe-Move-strtailcmp-to-string.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
 
-- 
1.7.5.4



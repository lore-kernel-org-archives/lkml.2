Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab2J0VUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:20:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2J0VSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:18:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] perf tool: Move strxfrchar into string object
Date: Sat, 27 Oct 2012 23:18:31 +0200
Message-Id: <1351372712-21104-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351372712-21104-1-git-send-email-jolsa@redhat.com>
References: <1351372712-21104-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving strxfrchar function into string object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/string.c | 18 ++++++++++++++++++
 tools/perf/util/symbol.c | 10 ----------
 tools/perf/util/symbol.h |  2 --
 tools/perf/util/util.h   |  1 +
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 3217059..346707d 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -314,6 +314,24 @@ int strtailcmp(const char *s1, const char *s2)
 }
 
 /**
+ * strxfrchar - Locate and replace character in @s
+ * @s:    The string to be searched/changed.
+ * @from: Source character to be replaced.
+ * @to:   Destination character.
+ *
+ * Return pointer to the changed string.
+ */
+char *strxfrchar(char *s, char from, char to)
+{
+	char *p = s;
+
+	while ((p = strchr(p, from)) != NULL)
+		*p++ = to;
+
+	return s;
+}
+
+/**
  * rtrim - Removes trailing whitespace from @s.
  * @s: The string to be stripped.
  *
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 08b8257..d3b1ecc 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2050,16 +2050,6 @@ int machines__create_kernel_maps(struct rb_root *machines, pid_t pid)
 	return machine__create_kernel_maps(machine);
 }
 
-char *strxfrchar(char *s, char from, char to)
-{
-	char *p = s;
-
-	while ((p = strchr(p, from)) != NULL)
-		*p++ = to;
-
-	return s;
-}
-
 int machines__create_guest_kernel_maps(struct rb_root *machines)
 {
 	int ret = 0;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index bc34dc1..45d3df8 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -40,8 +40,6 @@ static inline char *bfd_demangle(void __maybe_unused *v,
 #endif
 #endif
 
-char *strxfrchar(char *s, char from, char to);
-
 /*
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
  * for newer versions we can use mmap to reduce memory usage:
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index d6c22c5..c233091 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -240,6 +240,7 @@ void argv_free(char **argv);
 bool strglobmatch(const char *str, const char *pat);
 bool strlazymatch(const char *str, const char *pat);
 int strtailcmp(const char *s1, const char *s2);
+char *strxfrchar(char *s, char from, char to);
 unsigned long convert_unit(unsigned long value, char *unit);
 int readn(int fd, void *buf, size_t size);
 
-- 
1.7.11.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab2J3MD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:03:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40858 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab2J3MD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:03:28 -0400
Date: Tue, 30 Oct 2012 05:02:57 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-ea36c46be69c6e49c877971c4b3b3876b24b6082@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351372712-21104-5-git-send-email-jolsa@redhat.com>
References: <1351372712-21104-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move strxfrchar into string object
Git-Commit-ID: ea36c46be69c6e49c877971c4b3b3876b24b6082
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:03:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea36c46be69c6e49c877971c4b3b3876b24b6082
Gitweb:     http://git.kernel.org/tip/ea36c46be69c6e49c877971c4b3b3876b24b6082
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 27 Oct 2012 23:18:31 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Oct 2012 11:36:28 -0200

perf tools: Move strxfrchar into string object

Moving strxfrchar function into string object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351372712-21104-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/string.c |   18 ++++++++++++++++++
 tools/perf/util/symbol.c |   10 ----------
 tools/perf/util/symbol.h |    2 --
 tools/perf/util/util.h   |    1 +
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
 

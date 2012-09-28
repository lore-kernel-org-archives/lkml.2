Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab2I1Jkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:40:43 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47736 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab2I1JkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:40:24 -0400
X-AuditID: 9c930197-b7b6dae000000e70-77-5065708323b9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 12/12] perf tools: Convert to HAVE_STRLCPY
Date: Fri, 28 Sep 2012 18:32:08 +0900
Message-Id: <1348824728-14025-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For similar reason of previous patches, convert NO_STRLCPY to positive
HAVE_STRLCPY.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile     | 8 +++-----
 tools/perf/util/cache.h | 2 +-
 tools/perf/util/path.c  | 2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1cef38262bea..94ebe9dcd270 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -744,11 +744,9 @@ ifeq ($(NO_PERF_REGS),0)
 	BASIC_CFLAGS += -DHAVE_PERF_REGS
 endif
 
-ifdef NO_STRLCPY
-	BASIC_CFLAGS += -DNO_STRLCPY
-else
-	ifneq ($(call try-cc,$(SOURCE_STRLCPY),),y)
-		BASIC_CFLAGS += -DNO_STRLCPY
+ifndef NO_STRLCPY
+	ifeq ($(call try-cc,$(SOURCE_STRLCPY),),y)
+		BASIC_CFLAGS += -DHAVE_STRLCPY
 	endif
 endif
 
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 07aec06e4443..2bd51370ad28 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -107,7 +107,7 @@ extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2
 extern char *perf_pathdup(const char *fmt, ...)
 	__attribute__((format (printf, 1, 2)));
 
-#ifdef NO_STRLCPY
+#ifndef HAVE_STRLCPY
 extern size_t strlcpy(char *dest, const char *src, size_t size);
 #endif
 
diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
index bd7497711424..a8c49548ca48 100644
--- a/tools/perf/util/path.c
+++ b/tools/perf/util/path.c
@@ -22,7 +22,7 @@ static const char *get_perf_dir(void)
 	return ".";
 }
 
-#ifdef NO_STRLCPY
+#ifndef HAVE_STRLCPY
 size_t strlcpy(char *dest, const char *src, size_t size)
 {
 	size_t ret = strlen(src);
-- 
1.7.11.4


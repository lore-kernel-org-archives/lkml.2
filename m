Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab2JDSU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:20:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:39744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab2JDSJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/42] perf tools: Convert to HAVE_STRLCPY
Date: Thu,  4 Oct 2012 15:08:08 -0300
Message-Id: <1349374122-27806-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For similar reason of previous patches, convert NO_STRLCPY to positive
HAVE_STRLCPY.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348824728-14025-13-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile     |    8 +++-----
 tools/perf/util/cache.h |    2 +-
 tools/perf/util/path.c  |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 31a07f9..5216ade 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -743,11 +743,9 @@ ifeq ($(NO_PERF_REGS),0)
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
index 07aec06..2bd5137 100644
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
index bd74977..a8c4954 100644
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
1.7.1


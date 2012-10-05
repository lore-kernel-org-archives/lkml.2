Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2JEIf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:35:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60709 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2JEIfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:35:54 -0400
Date: Fri, 5 Oct 2012 01:35:37 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-d6e66832a710c0e6d1376e8d39ee108636a177e7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1348824728-14025-13-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-13-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Convert to HAVE_STRLCPY
Git-Commit-ID: d6e66832a710c0e6d1376e8d39ee108636a177e7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:35:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6e66832a710c0e6d1376e8d39ee108636a177e7
Gitweb:     http://git.kernel.org/tip/d6e66832a710c0e6d1376e8d39ee108636a177e7
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 28 Sep 2012 18:32:08 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:24 -0300

perf tools: Convert to HAVE_STRLCPY

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

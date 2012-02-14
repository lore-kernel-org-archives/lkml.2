Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab2BNBx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:53:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:45739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336Ab2BNBxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:53:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/16] perf tools: Implement islower/isupper macro into util.h
Date: Mon, 13 Feb 2012 23:52:47 -0200
Message-Id: <1329184375-27911-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1329184375-27911-1-git-send-email-acme@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The util.h header provides various ctype macros but lacks those two.

Add them.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328836217-9118-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7917b09..0f99f394 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -199,6 +199,8 @@ static inline int has_extension(const char *filename, const char *ext)
 #undef isalpha
 #undef isprint
 #undef isalnum
+#undef islower
+#undef isupper
 #undef tolower
 #undef toupper
 
@@ -219,6 +221,8 @@ extern unsigned char sane_ctype[256];
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
 #define isprint(x) sane_istest(x,GIT_PRINT)
+#define islower(x) (sane_istest(x,GIT_ALPHA) && sane_istest(x,0x20))
+#define isupper(x) (sane_istest(x,GIT_ALPHA) && !sane_istest(x,0x20))
 #define tolower(x) sane_case((unsigned char)(x), 0x20)
 #define toupper(x) sane_case((unsigned char)(x), 0)
 
-- 
1.7.9.123.g65da0


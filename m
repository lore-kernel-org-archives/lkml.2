Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab2BJAzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:55:13 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48912 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab2BJAzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:55:09 -0500
X-AuditID: 9c930179-b7cf1ae000000e40-d9-4f346aeb0a92
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] perf tools: Implement islower/isupper macro into util.h
Date: Fri, 10 Feb 2012 10:10:15 +0900
Message-Id: <1328836217-9118-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The util.h provides various ctype macros but lacks those two.
Add them.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/util.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 232d17ef3e60..2ea0dae542c6 100644
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
1.7.9


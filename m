Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab2GBGZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 02:25:00 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56367 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab2GBGY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 02:24:59 -0400
X-AuditID: 9c930179-b7cceae000004195-52-4ff13eb9342b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] perf target: Ignore return value of strerror_r() explicitly
Date: Mon,  2 Jul 2012 15:20:14 +0900
Message-Id: <1341210014-10113-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since glibc 2.16 added the warn_unused_result (wur) attribute
to the function, we should check the return value or ignore it
explicitly.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/target.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 1064d5b148ad..18080ca9ceec 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -111,7 +111,8 @@ int perf_target__strerror(struct perf_target *target, int errnum,
 	const char *msg;
 
 	if (errnum >= 0) {
-		strerror_r(errnum, buf, buflen);
+		/* make glibc (>= 2.16) happy */
+		(void)strerror_r(errnum, buf, buflen);
 		return 0;
 	}
 
-- 
1.7.10.2


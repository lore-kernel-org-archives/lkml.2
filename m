Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab2IYC24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 22:28:56 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57277 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2IYC2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 22:28:55 -0400
X-AuditID: 9c930179-b7bfcae0000020b4-ce-506116e58ef5
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] perf test: Fix build failure
Date: Tue, 25 Sep 2012 11:20:28 +0900
Message-Id: <1348539628-3821-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit 6a6cd11d4e57 ("perf test: Add test for the sched tracepoint
format fields") added following build error:

  CC builtin-test.o
builtin-test.c: In function ‘perf_evsel__test_field’:
builtin-test.c:1216:6: error: variable ‘ret’ set but not used [-Werror=unused-but-set-variable]
builtin-test.c: In function ‘perf_evsel__tp_sched_test’:
builtin-test.c:1242:6: error: variable ‘ret’ set but not used [-Werror=unused-but-set-variable]
cc1: all warnings being treated as errors
make: *** [builtin-test.o] Error 1

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 32caf13cfe01..78b47a75a7c9 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1233,7 +1233,7 @@ static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
 		ret = -1;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int perf_evsel__tp_sched_test(void)
@@ -1286,7 +1286,7 @@ static int perf_evsel__tp_sched_test(void)
 	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
 		ret = -1;
 
-	return 0;
+	return ret;
 }
 
 static struct test {
-- 
1.7.11.4


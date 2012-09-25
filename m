Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2IYOhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:37:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51167 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab2IYOhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:37:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf test: Fix build failure
Date: Tue, 25 Sep 2012 11:37:18 -0300
Message-Id: <1348583839-4264-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348583839-4264-1-git-send-email-acme@infradead.org>
References: <1348583839-4264-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348539628-3821-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 32caf13..78b47a7 100644
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
1.7.1


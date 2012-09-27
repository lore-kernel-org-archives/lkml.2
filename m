Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab2I0Fut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:50:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54396 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab2I0Fur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:50:47 -0400
Date: Wed, 26 Sep 2012 22:50:29 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-af9da88f14cbe6882b13492b59b3363682427b4d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1348539628-3821-1-git-send-email-namhyung@kernel.org>
References: <1348539628-3821-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Fix build failure
Git-Commit-ID: af9da88f14cbe6882b13492b59b3363682427b4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:50:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af9da88f14cbe6882b13492b59b3363682427b4d
Gitweb:     http://git.kernel.org/tip/af9da88f14cbe6882b13492b59b3363682427b4d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 25 Sep 2012 11:20:28 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 25 Sep 2012 07:45:59 -0300

perf test: Fix build failure

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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2IYIVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:21:42 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:55273 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2IYIVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:21:40 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20fix=20compilation=20error=20of=20perf/core?=
Date: Tue, 25 Sep 2012 16:21:25 +0800
Message-Id: <1348561285-25587-1-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12092508-8372-0000-0000-000003D64EC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Hao <haodong@linux.vnet.ibm.com>

The newest branch of perf/core should have compilation error!
Error log includes:

builtin-test.c: In function ‘perf_evsel__test_field’:
builtin-test.c:1216:6: error:
 variable ‘ret’ set but not used [-Werror=unused-but-set-variable]
builtin-test.c: In function ‘perf_evsel__tp_sched_test’:
builtin-test.c:1242:6: error:
 variable ‘ret’ set but not used [-Werror=unused-but-set-variable]
cc1: all warnings being treated as errors
make: *** [builtin-test.o] Error 1
---------------------------------------------------------------------
Fix it by replacing return value from 0 to ret.
Then this branch can be compiled successfully.

Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
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
1.7.2.5


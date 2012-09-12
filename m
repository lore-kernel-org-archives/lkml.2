Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab2ILCSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 22:18:14 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44338 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab2ILCSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 22:18:13 -0400
X-AuditID: 9c93016f-b7bffae000003557-90-504ff0e1fd59
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/2] perf test: Fixup for the die() removal
Date: Wed, 12 Sep 2012 11:11:05 +0900
Message-Id: <1347415866-303-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit 32c7f7383a09 ("perf test: Remove die() calls") replaced
die() call to pr_debug + return -1, but it should be pr_err otherwise
it'll not show up unless -v option is given.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index d33143efefce..4aed1553db56 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1026,15 +1026,15 @@ static int __test__rdpmc(void)
 
 	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
 	if (fd < 0) {
-		pr_debug("Error: sys_perf_event_open() syscall returned "
-			 "with %d (%s)\n", fd, strerror(errno));
+		pr_err("Error: sys_perf_event_open() syscall returned "
+		       "with %d (%s)\n", fd, strerror(errno));
 		return -1;
 	}
 
 	addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
 	if (addr == (void *)(-1)) {
-		pr_debug("Error: mmap() syscall returned with (%s)\n",
-			 strerror(errno));
+		pr_err("Error: mmap() syscall returned with (%s)\n",
+		       strerror(errno));
 		goto out_close;
 	}
 
-- 
1.7.11.4


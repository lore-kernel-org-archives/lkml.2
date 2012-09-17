Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2IQRXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:23:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57914 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab2IQRSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/18] perf test: Fixup for the die() removal
Date: Mon, 17 Sep 2012 14:17:56 -0300
Message-Id: <1347902292-14536-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit 32c7f7383a09 ("perf test: Remove die() calls") replaced die()
call to pr_debug + return -1, but it should be pr_err otherwise it'll
not show up unless -v option is given.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347415866-303-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index d33143e..4aed155 100644
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
1.7.1


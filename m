Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0CYW7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:59:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab0CYW7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:59:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] perf record: zero mmap_array[][][] fixing segfault
Date: Thu, 25 Mar 2010 19:59:01 -0300
Message-Id: <1269557941-15617-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269557941-15617-1-git-send-email-acme@infradead.org>
References: <1269557941-15617-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index bb5b23d..60ecdd3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -751,7 +751,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	for (i = 0; i < MAX_NR_CPUS; i++) {
 		for (j = 0; j < MAX_COUNTERS; j++) {
 			fd[i][j] = malloc(sizeof(int)*thread_num);
-			mmap_array[i][j] = malloc(
+			mmap_array[i][j] = zalloc(
 				sizeof(struct mmap_data)*thread_num);
 			if (!fd[i][j] || !mmap_array[i][j])
 				return -ENOMEM;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5f3ac9f..4abdd9b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1371,7 +1371,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	for (i = 0; i < MAX_NR_CPUS; i++) {
 		for (j = 0; j < MAX_COUNTERS; j++) {
 			fd[i][j] = malloc(sizeof(int)*thread_num);
-			mmap_array[i][j] = malloc(
+			mmap_array[i][j] = zalloc(
 				sizeof(struct mmap_data)*thread_num);
 			if (!fd[i][j] || !mmap_array[i][j])
 				return -ENOMEM;
-- 
1.6.2.5


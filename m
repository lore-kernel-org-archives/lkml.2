Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0CZM6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:58:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:57691 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab0CZM6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:58:40 -0400
Date: Fri, 26 Mar 2010 12:57:59 GMT
From: "tip-bot for Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, yanmin_zhang@linux.intel.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, stable@kernel.org,
       yanmin_zhang@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1269557941-15617-6-git-send-email-acme@infradead.org>
References: <1269557941-15617-6-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Zero out mmap_array to fix segfault
Message-ID: <tip-5a10317483f606106395814ee2fdaa2f1256a3b3@git.kernel.org>
Git-Commit-ID: 5a10317483f606106395814ee2fdaa2f1256a3b3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Mar 2010 12:58:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a10317483f606106395814ee2fdaa2f1256a3b3
Gitweb:     http://git.kernel.org/tip/5a10317483f606106395814ee2fdaa2f1256a3b3
Author:     Zhang, Yanmin <yanmin_zhang@linux.intel.com>
AuthorDate: Thu, 25 Mar 2010 19:59:01 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Mar 2010 08:52:59 +0100

perf record: Zero out mmap_array to fix segfault

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1269557941-15617-6-git-send-email-acme@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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

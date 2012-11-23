Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161017Ab2KWIHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:07:48 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:59217 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161003Ab2KWIHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:07:46 -0500
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: acme@ghostprotocols.net, mingo@kernel.org, mtosatti@redhat.com
Cc: dhowells@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, dsahern@gmail.com,
        haodong@linux.vnet.ibm.com
Subject: [PATCH] perf: fix compilation error on 64bit CPU
Date: Fri, 23 Nov 2012 16:07:29 +0800
Message-Id: <1353658049-9838-1-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.5
x-cbid: 12112308-0342-0000-0000-0000037B0944
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Hao <haodong@linux.vnet.ibm.com>

Fixed compilation error was caught on Red Hat 4.7.0-6 (GCC).

Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
---
 tools/perf/tests/attr.c | 20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 25638a9..bbbc972 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -67,7 +67,7 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 	FILE *file;
 	char path[PATH_MAX];
 
-	snprintf(path, PATH_MAX, "%s/event-%d-%llu-%d", dir,
+	snprintf(path, PATH_MAX, "%s/event-%d-%" PRIu64 "-%d", dir,
 		 attr->type, attr->config, fd);
 
 	file = fopen(path, "w+");
@@ -76,7 +76,7 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 		return -1;
 	}
 
-	if (fprintf(file, "[event-%d-%llu-%d]\n",
+	if (fprintf(file, "[event-%d-%" PRIu64 "-%d]\n",
 		    attr->type, attr->config, fd) < 0) {
 		perror("test attr - failed to write event file");
 		fclose(file);
@@ -93,10 +93,10 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 	/* struct perf_event_attr */
 	WRITE_ASS(type,   PRIu32);
 	WRITE_ASS(size,   PRIu32);
-	WRITE_ASS(config,  "llu");
-	WRITE_ASS(sample_period, "llu");
-	WRITE_ASS(sample_type,   "llu");
-	WRITE_ASS(read_format,   "llu");
+	WRITE_ASS(config, PRIu64);
+	WRITE_ASS(sample_period, PRIu64);
+	WRITE_ASS(sample_type,   PRIu64);
+	WRITE_ASS(read_format,   PRIu64);
 	WRITE_ASS(disabled,       "d");
 	WRITE_ASS(inherit,        "d");
 	WRITE_ASS(pinned,         "d");
@@ -121,10 +121,10 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 	WRITE_ASS(exclude_callchain_user, "d");
 	WRITE_ASS(wakeup_events, PRIu32);
 	WRITE_ASS(bp_type, PRIu32);
-	WRITE_ASS(config1, "llu");
-	WRITE_ASS(config2, "llu");
-	WRITE_ASS(branch_sample_type, "llu");
-	WRITE_ASS(sample_regs_user,   "llu");
+	WRITE_ASS(config1, PRIu64);
+	WRITE_ASS(config2, PRIu64);
+	WRITE_ASS(branch_sample_type, PRIu64);
+	WRITE_ASS(sample_regs_user,   PRIu64);
 	WRITE_ASS(sample_stack_user,  PRIu32);
 
 	fclose(file);
-- 
1.7.11.2


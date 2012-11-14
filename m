Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2KNH0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:26:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2KNH0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:26:54 -0500
Date: Tue, 13 Nov 2012 23:26:11 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-89f552d684925ef9f1dca8b4b2b18fb981dc3d8c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1352130579-13451-3-git-send-email-jolsa@redhat.com>
References: <1352130579-13451-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Factor attr tests WRITE_ASS macro
Git-Commit-ID: 89f552d684925ef9f1dca8b4b2b18fb981dc3d8c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:26:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89f552d684925ef9f1dca8b4b2b18fb981dc3d8c
Gitweb:     http://git.kernel.org/tip/89f552d684925ef9f1dca8b4b2b18fb981dc3d8c
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 5 Nov 2012 16:49:37 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:03:59 -0300

perf tests: Factor attr tests WRITE_ASS macro

Changing WRITE_ASS macro per Namhyung's comments, so the main usage case
takes only attr field name and format string.

Suggested-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352130579-13451-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.c |   89 ++++++++++++++++++++++++-----------------------
 1 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index aacad82..1389d69 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -44,7 +44,7 @@ void test_attr__init(void)
 
 #define BUFSIZE 1024
 
-#define WRITE_ASS(str, fmt, data)					\
+#define __WRITE_ASS(str, fmt, data)					\
 do {									\
 	char buf[BUFSIZE];						\
 	size_t size;							\
@@ -58,6 +58,8 @@ do {									\
 									\
 } while (0)
 
+#define WRITE_ASS(field, fmt) __WRITE_ASS(field, fmt, attr->field)
+
 static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 		       int fd, int group_fd, unsigned long flags)
 {
@@ -81,51 +83,50 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 	}
 
 	/* syscall arguments */
-	WRITE_ASS(fd,       "d", fd);
-	WRITE_ASS(group_fd, "d", group_fd);
-	WRITE_ASS(cpu,      "d", cpu);
-	WRITE_ASS(pid,      "d", pid);
-	WRITE_ASS(flags,   "lu", flags);
+	__WRITE_ASS(fd,       "d", fd);
+	__WRITE_ASS(group_fd, "d", group_fd);
+	__WRITE_ASS(cpu,      "d", cpu);
+	__WRITE_ASS(pid,      "d", pid);
+	__WRITE_ASS(flags,   "lu", flags);
 
 	/* struct perf_event_attr */
-	WRITE_ASS(type,   PRIu32,  attr->type);
-	WRITE_ASS(size,   PRIu32,  attr->size);
-	WRITE_ASS(config,  "llu",  attr->config);
-	WRITE_ASS(sample_period, "llu", attr->sample_period);
-	WRITE_ASS(sample_type,   "llu", attr->sample_type);
-	WRITE_ASS(read_format,   "llu", attr->read_format);
-	WRITE_ASS(disabled,       "d", attr->disabled);
-	WRITE_ASS(inherit,        "d", attr->inherit);
-	WRITE_ASS(pinned,         "d", attr->pinned);
-	WRITE_ASS(exclusive,      "d", attr->exclusive);
-	WRITE_ASS(exclude_user,   "d", attr->exclude_user);
-	WRITE_ASS(exclude_kernel, "d", attr->exclude_kernel);
-	WRITE_ASS(exclude_hv,     "d", attr->exclude_hv);
-	WRITE_ASS(exclude_idle,   "d", attr->exclude_idle);
-	WRITE_ASS(mmap,           "d", attr->mmap);
-	WRITE_ASS(comm,           "d", attr->comm);
-	WRITE_ASS(freq,           "d", attr->freq);
-	WRITE_ASS(inherit_stat,   "d", attr->inherit_stat);
-	WRITE_ASS(enable_on_exec, "d", attr->enable_on_exec);
-	WRITE_ASS(task,           "d", attr->task);
-	WRITE_ASS(watermask,      "d", attr->watermark);
-	WRITE_ASS(precise_ip,     "d", attr->precise_ip);
-	WRITE_ASS(mmap_data,      "d", attr->mmap_data);
-	WRITE_ASS(sample_id_all,  "d", attr->sample_id_all);
-	WRITE_ASS(exclude_host,   "d", attr->exclude_host);
-	WRITE_ASS(exclude_guest,  "d", attr->exclude_guest);
-	WRITE_ASS(exclude_callchain_kernel, "d",
-		  attr->exclude_callchain_kernel);
-	WRITE_ASS(exclude_callchain_user, "d",
-		  attr->exclude_callchain_user);
-	WRITE_ASS(wakeup_events, PRIu32, attr->wakeup_events);
-	WRITE_ASS(bp_type, PRIu32, attr->bp_type);
-	WRITE_ASS(config1, "llu", attr->config1);
-	WRITE_ASS(config2, "llu", attr->config2);
-	WRITE_ASS(branch_sample_type, "llu", attr->branch_sample_type);
-	WRITE_ASS(sample_regs_user,   "llu", attr->sample_regs_user);
-	WRITE_ASS(sample_stack_user,  PRIu32, attr->sample_stack_user);
-	WRITE_ASS(optional, "d", 0);
+	WRITE_ASS(type,   PRIu32);
+	WRITE_ASS(size,   PRIu32);
+	WRITE_ASS(config,  "llu");
+	WRITE_ASS(sample_period, "llu");
+	WRITE_ASS(sample_type,   "llu");
+	WRITE_ASS(read_format,   "llu");
+	WRITE_ASS(disabled,       "d");
+	WRITE_ASS(inherit,        "d");
+	WRITE_ASS(pinned,         "d");
+	WRITE_ASS(exclusive,      "d");
+	WRITE_ASS(exclude_user,   "d");
+	WRITE_ASS(exclude_kernel, "d");
+	WRITE_ASS(exclude_hv,     "d");
+	WRITE_ASS(exclude_idle,   "d");
+	WRITE_ASS(mmap,           "d");
+	WRITE_ASS(comm,           "d");
+	WRITE_ASS(freq,           "d");
+	WRITE_ASS(inherit_stat,   "d");
+	WRITE_ASS(enable_on_exec, "d");
+	WRITE_ASS(task,           "d");
+	WRITE_ASS(watermask,      "d");
+	WRITE_ASS(precise_ip,     "d");
+	WRITE_ASS(mmap_data,      "d");
+	WRITE_ASS(sample_id_all,  "d");
+	WRITE_ASS(exclude_host,   "d");
+	WRITE_ASS(exclude_guest,  "d");
+	WRITE_ASS(exclude_callchain_kernel, "d");
+	WRITE_ASS(exclude_callchain_user, "d");
+	WRITE_ASS(wakeup_events, PRIu32);
+	WRITE_ASS(bp_type, PRIu32);
+	WRITE_ASS(config1, "llu");
+	WRITE_ASS(config2, "llu");
+	WRITE_ASS(branch_sample_type, "llu");
+	WRITE_ASS(sample_regs_user,   "llu");
+	WRITE_ASS(sample_stack_user,  PRIu32);
+
+	__WRITE_ASS(optional, "d", 0);
 
 	fclose(file);
 	return 0;

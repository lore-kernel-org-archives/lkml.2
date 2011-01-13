Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab1AMOLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:11:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:46620 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884Ab1AMOLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:11:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf sched: Fix list of events, dropping unsupported ':r' modifier
Date: Thu, 13 Jan 2011 12:11:15 -0200
Message-Id: <1294927876-23553-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294927876-23553-1-git-send-email-acme@infradead.org>
References: <1294927876-23553-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

Looks to me like the :r modifier is not supported anymore, so remove it from
the list of events.

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
LKML-Reference: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index abd4b84..29e7ffd 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1843,15 +1843,15 @@ static const char *record_args[] = {
 	"-f",
 	"-m", "1024",
 	"-c", "1",
-	"-e", "sched:sched_switch:r",
-	"-e", "sched:sched_stat_wait:r",
-	"-e", "sched:sched_stat_sleep:r",
-	"-e", "sched:sched_stat_iowait:r",
-	"-e", "sched:sched_stat_runtime:r",
-	"-e", "sched:sched_process_exit:r",
-	"-e", "sched:sched_process_fork:r",
-	"-e", "sched:sched_wakeup:r",
-	"-e", "sched:sched_migrate_task:r",
+	"-e", "sched:sched_switch",
+	"-e", "sched:sched_stat_wait",
+	"-e", "sched:sched_stat_sleep",
+	"-e", "sched:sched_stat_iowait",
+	"-e", "sched:sched_stat_runtime",
+	"-e", "sched:sched_process_exit",
+	"-e", "sched:sched_process_fork",
+	"-e", "sched:sched_wakeup",
+	"-e", "sched:sched_migrate_task",
 };
 
 static int __cmd_record(int argc, const char **argv)
-- 
1.6.2.5


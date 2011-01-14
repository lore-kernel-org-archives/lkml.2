Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab1ANH0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:26:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:60491 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1ANH0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:26:12 -0500
Date: Fri, 14 Jan 2011 07:25:17 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, robert.richter@amd.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, robert.richter@amd.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf sched: Fix list of events, dropping unsupported ':r' modifier
Message-ID: <tip-9710118bd4e7f3406865171cb9b9c94547c1c2f9@git.kernel.org>
Git-Commit-ID: 9710118bd4e7f3406865171cb9b9c94547c1c2f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 14 Jan 2011 07:25:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9710118bd4e7f3406865171cb9b9c94547c1c2f9
Gitweb:     http://git.kernel.org/tip/9710118bd4e7f3406865171cb9b9c94547c1c2f9
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 12 Jan 2011 10:29:05 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 13 Jan 2011 11:25:49 -0200

perf sched: Fix list of events, dropping unsupported ':r' modifier

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

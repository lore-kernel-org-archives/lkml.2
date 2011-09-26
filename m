Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1IZPzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:55:31 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23792 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab1IZPza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:55:30 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, avagin@openvz.org
Subject: [PATCH 4/4] events: sched_stat_template saves call chains of a target task
Date: Mon, 26 Sep 2011 19:55:35 +0400
Message-Id: <1317052535-1765247-5-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's more useful, because

sched:sched_stat_iowait:
Before we can see that block layer notifies that i/o request completed.
Now we can see which code wanted to read/write data.

sched:sched_stat_sleep:
Before we can see that delayed_work_timer_fn wakes up a task.
Now we see where a task sleeps.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/trace/events/sched.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index f633478..7468c7a 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -296,6 +296,7 @@ DECLARE_EVENT_CLASS(sched_stat_template,
 		__entry->delay	= delay;
 	)
 	TP_perf_assign(
+		__perf_task(tsk);
 		__perf_count(delay);
 	),
 
-- 
1.7.1


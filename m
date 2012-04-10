Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960Ab2DJPnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:43:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46026 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2DJPnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:43:01 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frank Rowand <frank.rowand@am.sony.com>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH] sched: Removed redundant set_current_state in "yield"
Date: Tue, 10 Apr 2012 21:15:33 +0530
Message-Id: <1334072733-2614-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant setting current task state to TASK_RUNNING.

During yield process will always remains in TASK_RUNNING state. 

Process state of  yielded process will not change from TASK_RUNNING, so it does not 
make sense setting the process state again to TASK_RUNNING (TASK_RUNNING -> TASK_RUNNING).

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 kernel/sched/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4603b9d..c2a357d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4624,7 +4624,6 @@ EXPORT_SYMBOL(__cond_resched_softirq);
  */
 void __sched yield(void)
 {
-	set_current_state(TASK_RUNNING);
 	sys_sched_yield();
 }
 EXPORT_SYMBOL(yield);
-- 
1.7.3.4


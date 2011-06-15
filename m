Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1FOJuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:50:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:55107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab1FOJuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:50:37 -0400
Date: Wed, 15 Jun 2011 09:50:25 GMT
From: tip-bot for Hillf Danton <dhillf@gmail.com>
Message-ID: <tip-8dd0de8be31b4b966d17750a0b10df2f575c91ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dhillf@gmail.com, rostedt@goodmis.org, yong.zhang0@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhillf@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <20110614223657.450239027@goodmis.org>
References: <20110614223657.450239027@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix need_resched() when checking peempt
Git-Commit-ID: 8dd0de8be31b4b966d17750a0b10df2f575c91ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Jun 2011 09:50:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8dd0de8be31b4b966d17750a0b10df2f575c91ac
Gitweb:     http://git.kernel.org/tip/8dd0de8be31b4b966d17750a0b10df2f575c91ac
Author:     Hillf Danton <dhillf@gmail.com>
AuthorDate: Tue, 14 Jun 2011 18:36:24 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Jun 2011 09:50:32 +0200

sched: Fix need_resched() when checking peempt

The RT preempt check tests the wrong task if NEED_RESCHED is
set. It currently checks the local CPU task. It is supposed to
check the task that is running on the runqueue we are about to
wake another task on.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20110614223657.450239027@goodmis.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 88725c9..9b8d5dc 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1096,7 +1096,7 @@ static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int flag
 	 * to move current somewhere else, making room for our non-migratable
 	 * task.
 	 */
-	if (p->prio == rq->curr->prio && !need_resched())
+	if (p->prio == rq->curr->prio && !test_tsk_need_resched(rq->curr))
 		check_preempt_equal_prio(rq, p);
 #endif
 }

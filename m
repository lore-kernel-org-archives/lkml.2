Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1HNP77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:59:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:51225 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1HNP7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:59:55 -0400
Date: Sun, 14 Aug 2011 15:59:36 GMT
From: tip-bot for Hillf Danton <dhillf@gmail.com>
Message-ID: <tip-67d955383ab2ef8866c494c14156a4f3d29e441c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, dhillf@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, yong.zhang0@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, dhillf@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com>
References: <BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove noop in next_prio()
Git-Commit-ID: 67d955383ab2ef8866c494c14156a4f3d29e441c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:59:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67d955383ab2ef8866c494c14156a4f3d29e441c
Gitweb:     http://git.kernel.org/tip/67d955383ab2ef8866c494c14156a4f3d29e441c
Author:     Hillf Danton <dhillf@gmail.com>
AuthorDate: Thu, 16 Jun 2011 21:55:18 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:00:45 +0200

sched: Remove noop in next_prio()

When computing the next priority for a given run-queue, the check for
RT priority of the task determined by the pick_next_highest_task_rt()
function could be removed, since only RT tasks are returned by the
function.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 97540f0..e2698c0 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -704,7 +704,7 @@ static inline int next_prio(struct rq *rq)
 {
 	struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);
 
-	if (next && rt_prio(next->prio))
+	if (next)
 		return next->prio;
 	else
 		return MAX_RT_PRIO;

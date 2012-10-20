Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526Ab2JTBTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:19:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36428 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759513Ab2JTBTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:19:45 -0400
Date: Fri, 19 Oct 2012 18:19:24 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-9744d7978477bddc141284876b6544f3d8f7dbd8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched: Fix !CONFIG_SCHED_NUMA account_numa_enqueue
 () variant
Git-Commit-ID: 9744d7978477bddc141284876b6544f3d8f7dbd8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 18:19:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9744d7978477bddc141284876b6544f3d8f7dbd8
Gitweb:     http://git.kernel.org/tip/9744d7978477bddc141284876b6544f3d8f7dbd8
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sat, 20 Oct 2012 02:22:53 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 20 Oct 2012 03:12:17 +0200

sched: Fix !CONFIG_SCHED_NUMA account_numa_enqueue() variant

This build warning:

  kernel/sched/fair.c:1015:1: warning: no return statement in function returning non-void

Triggers because the dummy account_numa_enqueue() should return the
rq's task list.

It's not possible to trigger this bug runtime, nevertheless fix the
warning.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/n/tip-qauskiJfwddwtkf5pivzht5U@git.kernel.org
---
 kernel/sched/fair.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e93032d..a66a1b6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -967,6 +967,7 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 #else
 static struct list_head *account_numa_enqueue(struct rq *rq, struct task_struct *p)
 {
+	return NULL;
 }
 
 static void account_numa_dequeue(struct rq *rq, struct task_struct *p)

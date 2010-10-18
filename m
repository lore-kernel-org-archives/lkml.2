Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab0JRTXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:23:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:35183 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879Ab0JRTXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:23:32 -0400
Date: Mon, 18 Oct 2010 19:23:02 GMT
From: tip-bot for Nikhil Rao <ncrao@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ncrao@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ncrao@google.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1287173550-30365-2-git-send-email-ncrao@google.com>
References: <1287173550-30365-2-git-send-email-ncrao@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Do not consider SCHED_IDLE tasks to be cache hot
Message-ID: <tip-ef8002f6848236de5adc613063ebeabddea8a6fb@git.kernel.org>
Git-Commit-ID: ef8002f6848236de5adc613063ebeabddea8a6fb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:23:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef8002f6848236de5adc613063ebeabddea8a6fb
Gitweb:     http://git.kernel.org/tip/ef8002f6848236de5adc613063ebeabddea8a6fb
Author:     Nikhil Rao <ncrao@google.com>
AuthorDate: Wed, 13 Oct 2010 12:09:35 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 20:52:15 +0200

sched: Do not consider SCHED_IDLE tasks to be cache hot

This patch adds a check in task_hot to return if the task has SCHED_IDLE
policy. SCHED_IDLE tasks have very low weight, and when run with regular
workloads, are typically scheduled many milliseconds apart. There is no
need to consider these tasks hot for load balancing.

Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1287173550-30365-2-git-send-email-ncrao@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 728081a..771b518 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2025,6 +2025,9 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
+	if (unlikely(p->policy == SCHED_IDLE))
+		return 0;
+
 	/*
 	 * Buddy candidates are cache hot:
 	 */

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab1BJMaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:30:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:33729 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427Ab1BJMYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:24:54 -0500
From: stable-bot for Nikhil Rao <ncrao@google.com>
Date: Thu, 10 Feb 2011 10:23:25 +0100
Subject: [PATCH 09/28] sched: Do not consider SCHED_IDLE tasks to be cache
 hot
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340643.5512.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: ef8002f6848236de5adc613063ebeabddea8a6fb upstream
Author: Nikhil Rao <ncrao@google.com>
AuthorDate: Wed Oct 13 12:09:35 2010 -0700

This patch adds a check in task_hot to return if the task has SCHED_IDLE
policy. SCHED_IDLE tasks have very low weight, and when run with regular
workloads, are typically scheduled many milliseconds apart. There is no
need to consider these tasks hot for load balancing.

Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1287173550-30365-2-git-send-email-ncrao@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 87e3b2b..0a1fb24 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2014,6 +2014,9 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
+	if (unlikely(p->policy == SCHED_IDLE))
+		return 0;
+
 	/*
 	 * Buddy candidates are cache hot:
 	 */
-- 
1.7.4



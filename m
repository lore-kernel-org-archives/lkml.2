Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355Ab0I1AaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:30:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:63250 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891Ab0I1AaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:30:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=BboorWmt2lXW5t56L0EIMkOxYlg6sMp80rvZTlooBmDiI5VHOLPpzW5XsX1o8JIjh
	7JtfbyZrEEOjWHItCWufA==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH 3/3] sched: do not consider SCHED_IDLE tasks to be cache hot
Date: Mon, 27 Sep 2010 17:29:58 -0700
Message-Id: <1285633798-26886-4-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285633798-26886-1-git-send-email-ncrao@google.com>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a check in task_hot to return if the task has SCHED_IDLE
policy. SCHED_IDLE tasks have very low weight, and when run with regular
weight tasks, are typically scheduled many milliseconds apart. There is no
benefit from considering SCHED_IDLE tasks cache hot for load balancing.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ed09d4f..874efde 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2003,6 +2003,9 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
+	if (p->policy == SCHED_IDLE)
+		return 0;
+
 	/*
 	 * Buddy candidates are cache hot:
 	 */
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0JMTKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 15:10:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34294 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab0JMTKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 15:10:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=ktQUG28wAoxmvQ0qgckqqlo7cuw3X/xG7BMRif3dg8lrzd361hrImLz7f3S3Iev58
	xfKU5A6jZ9Q+2hnYJKbQA==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [PATCH 1/4] sched: do not consider SCHED_IDLE tasks to be cache hot
Date: Wed, 13 Oct 2010 12:09:35 -0700
Message-Id: <1286996978-7007-2-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286996978-7007-1-git-send-email-ncrao@google.com>
References: <1286996978-7007-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a check in task_hot to return if the task has SCHED_IDLE
policy. SCHED_IDLE tasks have very low weight, and when run with regular
workloads, are typically scheduled many milliseconds apart. There is no
need to consider these tasks hot for load balancing.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dc85ceb..6a9bdeb 100644
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


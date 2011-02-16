Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab1BPB5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:57:05 -0500
Received: from kroah.org ([198.145.64.141]:49282 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758572Ab1BPBvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:03 2011
Message-Id: <20110216014703.645328150@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nikhil Rao <ncrao@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Subject: [094/115] sched: Do not consider SCHED_IDLE tasks to be cache hot
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: ef8002f6848236de5adc613063ebeabddea8a6fb upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2014,6 +2014,9 @@ task_hot(struct task_struct *p, u64 now,
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
+	if (unlikely(p->policy == SCHED_IDLE))
+		return 0;
+
 	/*
 	 * Buddy candidates are cache hot:
 	 */



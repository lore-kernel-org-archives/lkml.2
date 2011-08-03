Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab1HCSAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:00:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab1HCSAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:00:06 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] watchdog: NUMA affine kthreads
Date: Wed,  3 Aug 2011 13:59:04 -0400
Message-Id: <1312394344-18815-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

watchdog kthreads can use kthread_create_on_node() to NUMA affine their
stack and task_struct.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 36491cd..14cabcd 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -438,7 +438,8 @@ static int watchdog_enable(int cpu)
 
 	/* create the watchdog thread */
 	if (!p) {
-		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
+		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu),
+					   "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
 			if (!err) {
-- 
1.7.6


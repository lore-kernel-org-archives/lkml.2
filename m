Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2FFNQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:16:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34328 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab2FFNP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:15:59 -0400
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 21:15:58 +0800
Message-ID: <CAJd=RBARsg8ukY7KtK87nTXq3ZJLOw_aSNj6dMwFm339Lv4HJg@mail.gmail.com>
Subject: [patch] BFS 421: cleanup by removing migration_req
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now it is harder to find lines for removal, but I am glad to clean up here
and there like a chef in work.


--- a/kernel/sched/bfs.c	Wed Jun  6 19:56:42 2012
+++ b/kernel/sched/bfs.c	Wed Jun  6 19:58:02 2012
@@ -1125,6 +1125,7 @@ static inline void take_task(int cpu, st
 {
 #ifdef CONFIG_SCHEDSTATS
 #ifdef CONFIG_SMP
+	//do ttwu stat outside grq lock, urgent?
 	if (p->wakeup_cpu == -1)
 		goto skip;

@@ -1219,11 +1220,6 @@ inline int task_curr(const struct task_s
 }

 #ifdef CONFIG_SMP
-struct migration_req {
-	struct task_struct *task;
-	int dest_cpu;
-};
-
 /*
  * wait_task_inactive - wait for a thread to unschedule.
  *
--

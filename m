Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2FML7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:59:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43270 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab2FML7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:59:24 -0400
MIME-Version: 1.0
Date: Wed, 13 Jun 2012 19:59:23 +0800
Message-ID: <CAJd=RBBtHWW1oWWU_xb6mrj_idikZepucCJuno4cJ4Yf5vrsnQ@mail.gmail.com>
Subject: [patch] BFS 421: cleanup by removing __account_system_time
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used, so lets do cleanup.

--- a/kernel/sched/bfs.c	Tue Jun 12 20:11:04 2012
+++ b/kernel/sched/bfs.c	Wed Jun 13 19:55:24 2012
@@ -2601,28 +2601,6 @@ static void account_guest_time(struct ta
 	}
 }

-/*
- * Account system cpu time to a process and desired cpustat field
- * @p: the process that the cpu time gets accounted to
- * @cputime: the cpu time spent in kernel space since the last update
- * @cputime_scaled: cputime scaled by cpu frequency
- * @target_cputime64: pointer to cpustat field that has to be updated
- */
-static inline
-void __account_system_time(struct task_struct *p, cputime_t cputime,
-			cputime_t cputime_scaled, cputime64_t *target_cputime64)
-{
-	/* Add system time to process. */
-	p->stime += (__force u64)cputime;
-	p->stimescaled += (__force u64)cputime_scaled;
-	account_group_system_time(p, cputime);
-
-	/* Add system time to cpustat. */
-	*target_cputime64 += (__force u64)cputime;
-
-	/* Account for system time used */
-	acct_update_integrals(p);
-}

 /*
  * Account system cpu time to a process.
--

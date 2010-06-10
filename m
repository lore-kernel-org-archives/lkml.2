Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab0FJXLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:11:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab0FJXL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:11:28 -0400
Date: Fri, 11 Jun 2010 01:09:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] sched: task_tick_rt: remove the obsolete ->signal !=
	NULL check
Message-ID: <20100610230948.GA25911@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the obsolete ->signal != NULL check in watchdog().
Since ea6d290c ->signal can't be NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/sched_rt.c |    3 ---
 1 file changed, 3 deletions(-)

--- 35-rc2/kernel/sched_rt.c~2_WD_DONT_CK_SIGNAL	2010-06-11 00:47:34.000000000 +0200
+++ 35-rc2/kernel/sched_rt.c	2010-06-11 01:07:25.000000000 +0200
@@ -1663,9 +1663,6 @@ static void watchdog(struct rq *rq, stru
 {
 	unsigned long soft, hard;
 
-	if (!p->signal)
-		return;
-
 	/* max may change after cur was read, this will be fixed next tick */
 	soft = task_rlimit(p, RLIMIT_RTTIME);
 	hard = task_rlimit_max(p, RLIMIT_RTTIME);


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2BPJiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:38:10 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38833 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2BPJiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:38:07 -0500
From: yad.naveen@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Cc: Naveen Yadav <yad.naveen@gmail.com>
Subject: [PATCH] futex: fix uninitialized warning
Date: Thu, 16 Feb 2012 15:15:21 +0530
Message-Id: <4f3cce7d.443a440a.2f15.ffffe7ff@mx.google.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <yad.naveen@gmail.com>
References: <yad.naveen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Yadav <yad.naveen@gmail.com>


Signed-off-by: Naveen Yadav <yad.naveen@gmail.com>
---
 kernel/futex.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6487e4c..fdb93b0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1588,7 +1588,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
 	struct task_struct *oldowner = pi_state->owner;
-	u32 uval, curval, newval;
+	u32 uval, uninitialized_var(curval), newval;
 	int ret;
 
 	/* Owner died? */
@@ -2493,7 +2493,7 @@ err_unlock:
  */
 int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
 {
-	u32 uval, nval, mval;
+	u32 uval, uninitialized_var(nval), mval;
 
 retry:
 	if (get_user(uval, uaddr))
-- 
1.7.8.4


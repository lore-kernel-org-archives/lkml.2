Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab0E0FyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:54:10 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:41504 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab0E0FyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:54:08 -0400
Date: Thu, 27 May 2010 01:53:50 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: x86@kernel.org, linux-pm@lists.linux-foundation.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Milton Miller <miltonm@bga.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH-v2 5/8] sched: clarify commment for TS_POLLING
In-reply-to: <4a831611847e8965ed5f3328e52fe8758115b951.1274926772.git.len.brown@intel.com>
Message-id: <alpine.LFD.2.00.1005270152460.8496@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
 <4a831611847e8965ed5f3328e52fe8758115b951.1274926772.git.len.brown@intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>


TS_POLLING set tells the scheduler an idle_task will poll
need_resched() to look for work.

TS_POLLING clear tells resched_task() and wake_up_idle_cpu()
that the remote CPU's idle_task is now sleeping in idle,
and thus requires a reschedule interrupt notice work.

Update the description of TS_POLLING to reflect how it works.
"idle task polling need_resched, skip sending interrupt"

Wordsmithing-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/thread_info.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e0d2890..8121869 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -241,8 +241,8 @@ static inline struct thread_info *current_thread_info(void)
 #define TS_USEDFPU		0x0001	/* FPU was used by this task
 					   this quantum (SMP) */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
-#define TS_POLLING		0x0004	/* true if in idle loop
-					   and not sleeping */
+#define TS_POLLING		0x0004	/* idle task polling need_resched,
+					   skip sending interrupt */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
 #define TS_XSAVE		0x0010	/* Use xsave/xrstor */
 
-- 
1.6.0.6



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0E0Cnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 22:43:46 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:46025 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933141Ab0E0Cmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 22:42:53 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 5/8] sched: clarify commment for TS_POLLING
Date: Wed, 26 May 2010 22:42:28 -0400
Message-id: <4a831611847e8965ed5f3328e52fe8758115b951.1274926772.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-reply-to: <1274928151-30919-1-git-send-email-lenb@kernel.org>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
In-reply-to: <e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
References: <e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

TS_POLLING set tells the scheduler a task will poll
need_resched() to look for work.

TS_POLLING clear tells resched_task() and wake_up_idle_cpu()
that the remote CPU is sleeping in idle, and thus requires
a reschedule interrupt to wake them to notice work.

Update the description of TS_POLLING to reflect how it works.
"cleared when sleeping in idle, requiring reschedule interrupt"

Signed-off-by: Len Brown <len.brown@intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/thread_info.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e0d2890..0a14da2 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -241,8 +241,8 @@ static inline struct thread_info *current_thread_info(void)
 #define TS_USEDFPU		0x0001	/* FPU was used by this task
 					   this quantum (SMP) */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
-#define TS_POLLING		0x0004	/* true if in idle loop
-					   and not sleeping */
+#define TS_POLLING		0x0004	/* clear when sleeping in idle
+					   requiring reschedule interrupt */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
 #define TS_XSAVE		0x0010	/* Use xsave/xrstor */
 
-- 
1.6.0.6


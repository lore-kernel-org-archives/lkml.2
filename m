Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0ITPWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:22:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab0ITPWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:22:12 -0400
Message-Id: <20100920151839.359805789@chello.nl>
User-Agent: quilt/0.47-1
Date: Mon, 20 Sep 2010 17:13:35 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Avi Kivity <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/2] kernel: remove PF_FLUSHER
References: <20100920151334.569154707@chello.nl>
Content-Disposition: inline; filename=pf-flags-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PF_FLUSHER is only ever set, not tested, remove it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/fs-writeback.c     |    2 +-
 include/linux/sched.h |    1 -
 mm/backing-dev.c      |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -782,7 +782,7 @@ int bdi_writeback_thread(void *data)
 	struct backing_dev_info *bdi = wb->bdi;
 	long pages_written;
 
-	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
+	current->flags |= PF_SWAPWRITE;
 	set_freezable();
 	wb->last_active = jiffies;
 
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1702,7 +1702,6 @@ extern void thread_group_times(struct ta
 #define PF_DUMPCORE	0x00000200	/* dumped core */
 #define PF_SIGNALED	0x00000400	/* killed by a signal */
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
-#define PF_FLUSHER	0x00001000	/* responsible for disk writeback */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
 #define PF_FREEZING	0x00004000	/* freeze in progress. do not account to load */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c
+++ linux-2.6/mm/backing-dev.c
@@ -360,7 +360,7 @@ static int bdi_forker_thread(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
 
-	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
+	current->flags |= PF_SWAPWRITE;
 	set_freezable();
 
 	/*



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1AWPRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:17:39 -0500
Received: from www.tglx.de ([62.245.132.106]:58705 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab1AWPRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:17:37 -0500
Message-Id: <20110123143837.506490608@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 23 Jan 2011 15:17:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 7/9] kthread: Replace deprecated spinlock initialization
References: <20110123143631.392446736@linutronix.de>
Content-Disposition: inline;
	filename=kthread-replace-deprecated-spinlock-initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCK is deprecated. Use the lockdep capable variant
instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kthread.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/kthread.h
===================================================================
--- linux-2.6.orig/include/linux/kthread.h
+++ linux-2.6/include/linux/kthread.h
@@ -64,7 +64,7 @@ struct kthread_work {
 };
 
 #define KTHREAD_WORKER_INIT(worker)	{				\
-	.lock = SPIN_LOCK_UNLOCKED,					\
+	.lock = __SPIN_LOCK_UNLOCKED((worker).lock),			\
 	.work_list = LIST_HEAD_INIT((worker).work_list),		\
 	}
 



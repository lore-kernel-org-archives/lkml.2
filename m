Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1AWPRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:17:42 -0500
Received: from www.tglx.de ([62.245.132.106]:58715 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1AWPRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:17:39 -0500
Message-Id: <20110123143837.600963390@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 23 Jan 2011 15:17:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 8/9] cred: Replace deprecated spinlock initialization
References: <20110123143631.392446736@linutronix.de>
Content-Disposition: inline;
	filename=cred-replace-deprecated-spinlock-initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCK is deprecated. Use the lockdep capable variant
instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/cred.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/cred.c
===================================================================
--- linux-2.6.orig/kernel/cred.c
+++ linux-2.6/kernel/cred.c
@@ -35,7 +35,7 @@ static struct kmem_cache *cred_jar;
 static struct thread_group_cred init_tgcred = {
 	.usage	= ATOMIC_INIT(2),
 	.tgid	= 0,
-	.lock	= SPIN_LOCK_UNLOCKED,
+	.lock	= __SPIN_LOCK_UNLOCKED(init_cred.tgcred.lock),
 };
 #endif
 



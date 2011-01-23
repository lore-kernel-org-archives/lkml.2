Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab1AWPRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:17:36 -0500
Received: from www.tglx.de ([62.245.132.106]:58692 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab1AWPRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:17:34 -0500
Message-Id: <20110123143837.411120754@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 23 Jan 2011 15:17:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Chris Zankel <chris@zankel.net>
Subject: [patch 6/9] xtensa: Replace deprecated spinlock initialization
References: <20110123143631.392446736@linutronix.de>
Content-Disposition: inline;
	filename=xtensa-replace-deprecated-spinlock-initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCK is deprecated. Use the lockdep capable variant
instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/include/asm/rwsem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/xtensa/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/rwsem.h
+++ linux-2.6/arch/xtensa/include/asm/rwsem.h
@@ -38,7 +38,7 @@ struct rw_semaphore {
 };
 
 #define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
+	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock),	\
 	  LIST_HEAD_INIT((name).wait_list) }
 
 #define DECLARE_RWSEM(name)		\



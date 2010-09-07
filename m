Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab0IGOi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:38:28 -0400
Received: from www.tglx.de ([62.245.132.106]:43673 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027Ab0IGOcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:32:41 -0400
Message-Id: <20100907125054.795929962@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:31:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [patch 01/30] semaphore: Add DEFINE_SEMAPHORE
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=mutex-semaphore.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The full cleanup of init_MUTEX[_LOCKED] and DECLARE_MUTEX has not been
done. Some of the users are real semaphores and we should name them as
such instead of confusing everyone with "MUTEX".

Provide the infrastructure to get finally rid of init_MUTEX[_LOCKED]
and DECLARE_MUTEX.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/semaphore.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/include/linux/semaphore.h
===================================================================
--- linux-2.6.orig/include/linux/semaphore.h
+++ linux-2.6/include/linux/semaphore.h
@@ -26,6 +26,9 @@ struct semaphore {
 	.wait_list	= LIST_HEAD_INIT((name).wait_list),		\
 }
 
+#define DEFINE_SEMAPHORE(name)	\
+	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
+
 #define DECLARE_MUTEX(name)	\
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
 



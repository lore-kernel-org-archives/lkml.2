Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0IHNL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:11:29 -0400
Received: from www.tglx.de ([62.245.132.106]:44417 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab0IHNL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:11:27 -0400
Date: Wed, 8 Sep 2010 15:11:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT pull] Preparatory patch for semaphore cleanup
Message-ID: <alpine.LFD.2.00.1009081507250.2477@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the semaphore-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git semaphore-for-linus

This patch just provides the DEFINE_SEMAPHORE macro which is required
for the various subsystem cleanups I sent out, so we can finally get
rid of init_MUTEX[_LOCKED] in 2.6.37.

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      semaphore: Add DEFINE_SEMAPHORE


 include/linux/semaphore.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 7415839..5310d27 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -26,6 +26,9 @@ struct semaphore {
 	.wait_list	= LIST_HEAD_INIT((name).wait_list),		\
 }
 
+#define DEFINE_SEMAPHORE(name)	\
+	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
+
 #define DECLARE_MUTEX(name)	\
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
 

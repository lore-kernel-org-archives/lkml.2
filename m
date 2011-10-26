Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab1JZPQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:16:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40923 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076Ab1JZPQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:16:41 -0400
Date: Wed, 26 Oct 2011 17:14:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups changes for v3.2
Message-ID: <20111026151458.GA27748@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

 Thanks,

	Ingo

------------------>
Andy Lutomirski (1):
      x86-64, unistd: Remove bogus __IGNORE_getcpu

Jesper Juhl (1):
      x86, cleanup: Remove unneeded version.h include from arch/x86/

Zhao Jin (1):
      x86, mm, trivial: Remove unnecessary get_order() in free_thread_info()


 arch/x86/include/asm/unistd_64.h |    1 -
 arch/x86/kernel/process.c        |    2 +-
 arch/x86/mm/mmio-mod.c           |    1 -
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index d92641c..940d720 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -624,7 +624,6 @@ __SYSCALL(__NR_vmsplice, sys_vmsplice)
 __SYSCALL(__NR_move_pages, sys_move_pages)
 #define __NR_utimensat				280
 __SYSCALL(__NR_utimensat, sys_utimensat)
-#define __IGNORE_getcpu		/* implemented as a vsyscall */
 #define __NR_epoll_pwait			281
 __SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
 #define __NR_signalfd				282
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e7e3b01..b9b3b1a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -49,7 +49,7 @@ void free_thread_xstate(struct task_struct *tsk)
 void free_thread_info(struct thread_info *ti)
 {
 	free_thread_xstate(ti->task);
-	free_pages((unsigned long)ti, get_order(THREAD_SIZE));
+	free_pages((unsigned long)ti, THREAD_ORDER);
 }
 
 void arch_task_cache_init(void)
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 67421f3..de54b9b 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/kallsyms.h>
 #include <asm/pgtable.h>
 #include <linux/mmiotrace.h>

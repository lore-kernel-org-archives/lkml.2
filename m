Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2EHMoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:44:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55157 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab2EHMon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:44:43 -0400
Date: Tue, 8 May 2012 05:44:33 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-c4e26890ff4cb4e85969b1e8565af4b046ce03b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        lennox.wu@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, lennox.wu@gmail.com
In-Reply-To: <20120505150142.123383955@linutronix.de>
References: <20120505150142.123383955@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] score: Use common threadinfo allocator
Git-Commit-ID: c4e26890ff4cb4e85969b1e8565af4b046ce03b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:44:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4e26890ff4cb4e85969b1e8565af4b046ce03b8
Gitweb:     http://git.kernel.org/tip/c4e26890ff4cb4e85969b1e8565af4b046ce03b8
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:46 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:46 +0200

score: Use common threadinfo allocator

No point in using kmalloc for allocating 2 pages.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Lennox Wu <lennox.wu@gmail.com>
Link: http://lkml.kernel.org/r/20120505150142.123383955@linutronix.de
---
 arch/score/include/asm/thread_info.h |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/score/include/asm/thread_info.h b/arch/score/include/asm/thread_info.h
index 2205c62..a18006e9 100644
--- a/arch/score/include/asm/thread_info.h
+++ b/arch/score/include/asm/thread_info.h
@@ -11,10 +11,9 @@
 #include <linux/const.h>
 
 /* thread information allocation */
-#define THREAD_SIZE_ORDER 	(1)
-#define THREAD_SIZE 		(PAGE_SIZE << THREAD_SIZE_ORDER)
-#define THREAD_MASK 		(THREAD_SIZE - _AC(1,UL))
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+#define THREAD_SIZE_ORDER	(1)
+#define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
+#define THREAD_MASK		(THREAD_SIZE - _AC(1,UL))
 
 #ifndef __ASSEMBLY__
 
@@ -71,9 +70,6 @@ struct thread_info {
 register struct thread_info *__current_thread_info __asm__("r28");
 #define current_thread_info()	__current_thread_info
 
-#define alloc_thread_info_node(tsk, node) kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#define free_thread_info(info) kfree(info)
-
 #endif /* !__ASSEMBLY__ */
 
 #define PREEMPT_ACTIVE		0x10000000

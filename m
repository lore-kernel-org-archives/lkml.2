Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2EHMgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:36:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55012 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab2EHMgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:36:22 -0400
Date: Tue, 8 May 2012 05:36:09 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-7b8fe0570a65486e77823d5fcec9998c2aae9970@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, msalter@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, msalter@redhat.com
In-Reply-To: <20120505150141.621728944@linutronix.de>
References: <20120505150141.621728944@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] c6x: Use common threadinfo allocator
Git-Commit-ID: 7b8fe0570a65486e77823d5fcec9998c2aae9970
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:36:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b8fe0570a65486e77823d5fcec9998c2aae9970
Gitweb:     http://git.kernel.org/tip/7b8fe0570a65486e77823d5fcec9998c2aae9970
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:42 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:44 +0200

c6x: Use common threadinfo allocator

There is no functional difference. __get_free_pages() ends up calling
alloc_pages_node().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Salter <msalter@redhat.com>
Link: http://lkml.kernel.org/r/20120505150141.621728944@linutronix.de
---
 arch/c6x/include/asm/thread_info.h |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/c6x/include/asm/thread_info.h b/arch/c6x/include/asm/thread_info.h
index fd99148..1710bcb 100644
--- a/arch/c6x/include/asm/thread_info.h
+++ b/arch/c6x/include/asm/thread_info.h
@@ -20,11 +20,11 @@
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SIZE		4096
 #define THREAD_SHIFT		12
-#define THREAD_ORDER		0
+#define THREAD_SIZE_ORDER	0
 #else
 #define THREAD_SIZE		8192
 #define THREAD_SHIFT		13
-#define THREAD_ORDER		1
+#define THREAD_SIZE_ORDER	1
 #endif
 
 #define THREAD_START_SP		(THREAD_SIZE - 8)
@@ -80,19 +80,6 @@ struct thread_info *current_thread_info(void)
 	return ti;
 }
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
-#else
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK)
-#endif
-
-#define alloc_thread_info_node(tsk, node)	\
-	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
-
-#define free_thread_info(ti)	free_pages((unsigned long) (ti), THREAD_ORDER)
 #define get_thread_info(ti)	get_task_struct((ti)->task)
 #define put_thread_info(ti)	put_task_struct((ti)->task)
 #endif /* __ASSEMBLY__ */

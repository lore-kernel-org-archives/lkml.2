Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2EHMjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:39:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55078 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2EHMjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:39:54 -0400
Date: Tue, 8 May 2012 05:39:31 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-e6e9c540d5d177e7a40d8b40a3b2386bdefbe5da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        takata@linux-m32r.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, takata@linux-m32r.org
In-Reply-To: <20120505150141.875430830@linutronix.de>
References: <20120505150141.875430830@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] m32r: Use common threadinfo allocator
Git-Commit-ID: e6e9c540d5d177e7a40d8b40a3b2386bdefbe5da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:39:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6e9c540d5d177e7a40d8b40a3b2386bdefbe5da
Gitweb:     http://git.kernel.org/tip/e6e9c540d5d177e7a40d8b40a3b2386bdefbe5da
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:45 +0200

m32r: Use common threadinfo allocator

No reason why m32r needs to use kmalloc to allocate 2 pages instead of
using the core allocator.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Link: http://lkml.kernel.org/r/20120505150141.875430830@linutronix.de
---
 arch/m32r/include/asm/thread_info.h |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/m32r/include/asm/thread_info.h b/arch/m32r/include/asm/thread_info.h
index bf8fa3c..c083f60 100644
--- a/arch/m32r/include/asm/thread_info.h
+++ b/arch/m32r/include/asm/thread_info.h
@@ -55,8 +55,8 @@ struct thread_info {
 
 #define PREEMPT_ACTIVE		0x10000000
 
-#define THREAD_SIZE (PAGE_SIZE << 1)
-
+#define THREAD_SIZE		(PAGE_SIZE << 1)
+#define THREAD_SIZE_ORDER	1
 /*
  * macros/functions for gaining access to the thread information structure
  */
@@ -92,19 +92,6 @@ static inline struct thread_info *current_thread_info(void)
 	return ti;
 }
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info_node(tsk, node)			\
-		kzalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#else
-#define alloc_thread_info_node(tsk, node)			\
-		kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#endif
-
-#define free_thread_info(info) kfree(info)
-
 #define TI_FLAG_FAULT_CODE_SHIFT	28
 
 static inline void set_thread_fault_code(unsigned int val)

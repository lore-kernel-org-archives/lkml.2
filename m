Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab2EHMpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:45:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55179 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2EHMpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:45:34 -0400
Date: Tue, 8 May 2012 05:45:23 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-66bb4cda55477efeb1be5c2cbd3785a69b088a8a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20120505150142.252861878@linutronix.de>
References: <20120505150142.252861878@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] sparc: Use common threadinfo allocator
Git-Commit-ID: 66bb4cda55477efeb1be5c2cbd3785a69b088a8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:45:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66bb4cda55477efeb1be5c2cbd3785a69b088a8a
Gitweb:     http://git.kernel.org/tip/66bb4cda55477efeb1be5c2cbd3785a69b088a8a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:47 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:46 +0200

sparc: Use common threadinfo allocator

Exaclty the same as the core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20120505150142.252861878@linutronix.de
---
 arch/sparc/include/asm/thread_info_64.h |   25 ++-----------------------
 1 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index 01d057f..7f0981b 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -138,32 +138,11 @@ register struct thread_info *current_thread_info_reg asm("g6");
 
 /* thread information allocation */
 #if PAGE_SHIFT == 13
-#define __THREAD_INFO_ORDER	1
+#define THREAD_SIZE_ORDER	1
 #else /* PAGE_SHIFT == 13 */
-#define __THREAD_INFO_ORDER	0
+#define THREAD_SIZE_ORDER	0
 #endif /* PAGE_SHIFT == 13 */
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_ZERO)
-#else
-#define THREAD_FLAGS (GFP_KERNEL)
-#endif
-
-#define alloc_thread_info_node(tsk, node)				\
-({									\
-	struct page *page = alloc_pages_node(node, THREAD_FLAGS,	\
-					     __THREAD_INFO_ORDER);	\
-	struct thread_info *ret;					\
-									\
-	ret = page ? page_address(page) : NULL;				\
-	ret;								\
-})
-
-#define free_thread_info(ti) \
-	free_pages((unsigned long)(ti),__THREAD_INFO_ORDER)
-
 #define __thread_flag_byte_ptr(ti)	\
 	((unsigned char *)(&((ti)->flags)))
 #define __cur_thread_flag_byte_ptr	__thread_flag_byte_ptr(current_thread_info())

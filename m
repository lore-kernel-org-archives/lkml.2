Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab2EHMl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:41:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55110 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab2EHMl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:41:26 -0400
Date: Tue, 8 May 2012 05:41:12 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-3194f61de93d4d4fbc2f2ddb25aeded6f9cebaeb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20120505150141.936950979@linutronix.de>
References: <20120505150141.936950979@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] mips: Use common threadinfo allocator
Git-Commit-ID: 3194f61de93d4d4fbc2f2ddb25aeded6f9cebaeb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:41:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3194f61de93d4d4fbc2f2ddb25aeded6f9cebaeb
Gitweb:     http://git.kernel.org/tip/3194f61de93d4d4fbc2f2ddb25aeded6f9cebaeb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:45 +0200

mips: Use common threadinfo allocator

No point in using kmalloc for allocating 0, 1 resp. 2 pages for
threadinfo.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Link: http://lkml.kernel.org/r/20120505150141.936950979@linutronix.de
---
 arch/mips/include/asm/thread_info.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 0d85d8e..e2eca7d 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -85,18 +85,6 @@ register struct thread_info *__current_thread_info __asm__("$28");
 
 #define STACK_WARN	(THREAD_SIZE / 8)
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info_node(tsk, node) \
-		kzalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#else
-#define alloc_thread_info_node(tsk, node) \
-		kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#endif
-
-#define free_thread_info(info) kfree(info)
-
 #endif /* !__ASSEMBLY__ */
 
 #define PREEMPT_ACTIVE		0x10000000

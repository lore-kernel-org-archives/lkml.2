Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab2EHMix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:38:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55069 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2EHMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:38:52 -0400
Date: Tue, 8 May 2012 05:38:42 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-c64872cd0dd5892f4d6f3605ffca36d13e63443d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <20120505150141.751600045@linutronix.de>
References: <20120505150141.751600045@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] frv: Use common threadinfo allocator
Git-Commit-ID: c64872cd0dd5892f4d6f3605ffca36d13e63443d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:38:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c64872cd0dd5892f4d6f3605ffca36d13e63443d
Gitweb:     http://git.kernel.org/tip/c64872cd0dd5892f4d6f3605ffca36d13e63443d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:43 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:44 +0200

frv: Use common threadinfo allocator

The core now has a threadinfo allocator which uses a kmemcache when
THREAD_SIZE < PAGE_SIZE.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20120505150141.751600045@linutronix.de

---
 arch/frv/include/asm/thread_info.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
index aaea388..54ab13a 100644
--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -80,19 +80,6 @@ register struct thread_info *__current_thread_info asm("gr15");
 
 #define current_thread_info() ({ __current_thread_info; })
 
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
-#define free_thread_info(info)	kfree(info)
-
 #endif /* __ASSEMBLY__ */
 
 /*

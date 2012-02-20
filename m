Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab2BTAPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:15:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57267 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2BTAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:15:46 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 15/30] x32: Add a thread flag for x32 processes
Date: Sun, 19 Feb 2012 16:07:53 -0800
Message-Id: <1329696488-16970-16-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:15:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

An x32 process is *almost* the same thing as a 64-bit process with a
32-bit address limit, but there are a few minor differences -- in
particular core dumps are 32 bits and signal handling is different.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/thread_info.h |    2 ++
 arch/x86/kernel/process_64.c       |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index d1803a4..912e935 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -96,6 +96,7 @@ struct thread_info {
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
 #define TIF_ADDR32		29	/* 32-bit address space on 64 bits */
+#define TIF_X32			30	/* 32-bit native x86-64 binary */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -118,6 +119,7 @@ struct thread_info {
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_ADDR32		(1 << TIF_ADDR32)
+#define _TIF_X32		(1 << TIF_X32)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 0e900d0..5fe2fba 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -509,6 +509,7 @@ void set_personality_64bit(void)
 	/* Make sure to be in 64bit mode */
 	clear_thread_flag(TIF_IA32);
 	clear_thread_flag(TIF_ADDR32);
+	clear_thread_flag(TIF_X32);
 
 	/* Ensure the corresponding mm is not marked. */
 	if (current->mm)
@@ -528,6 +529,7 @@ void set_personality_ia32(void)
 	/* Make sure to be in 32bit mode */
 	set_thread_flag(TIF_IA32);
 	set_thread_flag(TIF_ADDR32);
+	clear_thread_flag(TIF_X32);
 	current->personality |= force_personality32;
 
 	/* Mark the associated mm as containing 32-bit tasks. */
-- 
1.7.6.5


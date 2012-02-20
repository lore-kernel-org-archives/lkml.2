Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2BTAPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:15:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2BTAPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:15:20 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 14/30] x86-64: Add prototype for old_rsp to a header file
Date: Sun, 19 Feb 2012 16:07:52 -0800
Message-Id: <1329696488-16970-15-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:15:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. J. Lu" <hjl.tools@gmail.com>

So far this has only been used in process_64.c, but the x32 code will
need it in additional code.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/processor.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 9f748b5..e34f951 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -948,6 +948,12 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 
 #define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)
 extern unsigned long KSTK_ESP(struct task_struct *task);
+
+/*
+ * User space RSP while inside the SYSCALL fast path
+ */
+DECLARE_PER_CPU(unsigned long, old_rsp);
+
 #endif /* CONFIG_X86_64 */
 
 extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
-- 
1.7.6.5


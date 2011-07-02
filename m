Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1GBQ34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:29:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52746 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1GBQ3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:29:53 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/6] x86: Save stack pointer in perf live regs savings
Date: Sat,  2 Jul 2011 18:29:39 +0200
Message-Id: <1309624184-9790-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prepare for fetching the stack pointer from the
regs when possible in dump_trace() instead of taking the
local one, save the current stack pointer in perf live regs saving.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/include/asm/perf_event.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index d9d4dae..094fb30 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -152,6 +152,11 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 	(regs)->bp = caller_frame_pointer();			\
 	(regs)->cs = __KERNEL_CS;				\
 	regs->flags = 0;					\
+	asm volatile(						\
+		_ASM_MOV "%%"_ASM_SP ", %0\n"			\
+		: "=m" ((regs)->sp)				\
+		:: "memory"					\
+	);							\
 }
 
 #else
-- 
1.7.5.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1GaVgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 17:36:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:38974 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab1GaVgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 17:36:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sh: Fix conflicting definitions of ptrace_triggered
Date: Sun, 31 Jul 2011 17:36:35 -0400
Message-Id: <1312148195-32658-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extra nmi argument is causing this compile fail:

  CC      arch/sh/kernel/ptrace_32.o
arch/sh/kernel/ptrace_32.c:66:6: error: conflicting types for 'ptrace_triggered'
arch/sh/include/asm/ptrace.h:126:13: note: previous declaration of 'ptrace_triggered' was here
make[3]: *** [arch/sh/kernel/ptrace_32.o] Error 1

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/sh/include/asm/ptrace.h b/arch/sh/include/asm/ptrace.h
index b97baf8..2d3679b 100644
--- a/arch/sh/include/asm/ptrace.h
+++ b/arch/sh/include/asm/ptrace.h
@@ -123,7 +123,7 @@ static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
 struct perf_event;
 struct perf_sample_data;
 
-extern void ptrace_triggered(struct perf_event *bp, int nmi,
+extern void ptrace_triggered(struct perf_event *bp,
 		      struct perf_sample_data *data, struct pt_regs *regs);
 
 #define task_pt_regs(task) \
-- 
1.7.6


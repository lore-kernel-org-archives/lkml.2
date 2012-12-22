Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab2LVFVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 00:21:19 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:39805 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab2LVFVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 00:21:18 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH 2/3] arch/tile: Implement user_stack_pointer
Date: Sat, 22 Dec 2012 00:21:11 -0500
Message-Id: <1356153672-17545-2-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1356153672-17545-1-git-send-email-simon.marchi@polymtl.ca>
References: <1356153672-17545-1-git-send-email-simon.marchi@polymtl.ca>
X-Poly-FromMTA: ([132.207.72.18]) at Sat, 22 Dec 2012 05:21:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is needed when we turn on HAVE_ARCH_TRACEHOOK.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 arch/tile/include/asm/ptrace.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
index 5ce052e..4be42fb 100644
--- a/arch/tile/include/asm/ptrace.h
+++ b/arch/tile/include/asm/ptrace.h
@@ -80,6 +80,11 @@ struct task_struct;
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code);
 
+static inline unsigned long user_stack_pointer(struct pt_regs *regs)
+{
+	return regs->sp;
+}
+
 #ifdef __tilegx__
 /* We need this since sigval_t has a user pointer in it, for GETSIGINFO etc. */
 #define __ARCH_WANT_COMPAT_SYS_PTRACE
-- 
1.7.1


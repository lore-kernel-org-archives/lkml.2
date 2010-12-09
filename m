Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0LII06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:26:58 -0500
Received: from smtp.duncanthrax.net ([89.31.1.170]:41710 "EHLO
	smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab0LII0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:26:55 -0500
From: svens@stackframe.org
To: hans-christian.egtvedt@atmel.com
Cc: linux-kernel@vger.kernel.org, svens@stackframe.org
Subject: [PATCH] AVR32: Fix sys_execve breakage
Date: Thu,  9 Dec 2010 09:26:41 +0100
Message-Id: <1291883201-7903-2-git-send-email-svens@stackframe.org>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291874601.2794.5.camel@hcegtvedt>
References: <1291874601.2794.5.camel@hcegtvedt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Schnelle <svens@stackframe.org>

Signed-off-by: Sven Schnelle <svens@stackframe.org>
---
 arch/avr32/include/asm/syscalls.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/include/asm/syscalls.h b/arch/avr32/include/asm/syscalls.h
index ab608b7..1440368 100644
--- a/arch/avr32/include/asm/syscalls.h
+++ b/arch/avr32/include/asm/syscalls.h
@@ -21,8 +21,10 @@ asmlinkage int sys_clone(unsigned long, unsigned long,
 			 unsigned long, unsigned long,
 			 struct pt_regs *);
 asmlinkage int sys_vfork(struct pt_regs *);
-asmlinkage int sys_execve(const char __user *, char __user *__user *,
-			  char __user *__user *, struct pt_regs *);
+asmlinkage int sys_execve(const char __user *ufilename,
+			  const char __user *const __user *uargv,
+			  const char __user *const __user *uenvp,
+			  struct pt_regs *regs);
 
 /* kernel/signal.c */
 asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
-- 
1.7.2.3


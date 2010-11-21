Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab0KUXq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 18:46:58 -0500
Received: from smtp.duncanthrax.net ([89.31.1.170]:37844 "EHLO
	smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab0KUXqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 18:46:48 -0500
From: Sven Schnelle <svens@stackframe.org>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, Sven Schnelle <svens@stackframe.org>
Subject: [PATCH 1/2] AVR32: Fix sys_execve breakage
Date: Mon, 22 Nov 2010 00:28:06 +0100
Message-Id: <1290382087-3849-2-git-send-email-svens@stackframe.org>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290382087-3849-1-git-send-email-svens@stackframe.org>
References: <1290382087-3849-1-git-send-email-svens@stackframe.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d7627467b7a8dd6944885290a03a07ceb28c10eb change sys_execve()
arch/avr32, but the version in syscalls.h is still the old one.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
---
 arch/avr32/include/asm/syscalls.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/include/asm/syscalls.h b/arch/avr32/include/asm/syscalls.h
index ab608b7..dd69aa0 100644
--- a/arch/avr32/include/asm/syscalls.h
+++ b/arch/avr32/include/asm/syscalls.h
@@ -24,6 +24,11 @@ asmlinkage int sys_vfork(struct pt_regs *);
 asmlinkage int sys_execve(const char __user *, char __user *__user *,
 			  char __user *__user *, struct pt_regs *);
 
+asmlinkage int sys_execve(const char __user *ufilename,
+			  const char __user *const __user *uargv,
+			  const char __user *const __user *uenvp,
+			  struct pt_regs *regs);
+
 /* kernel/signal.c */
 asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
 			       struct pt_regs *);
-- 
1.7.2.3


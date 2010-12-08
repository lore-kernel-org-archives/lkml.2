Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab0LHXTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:19:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45962 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755937Ab0LHXTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:19:37 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+X2X0hUmWXsXTaVwM90+Qz13rHoqsweVTJ8Cw8MQ
	WiIxDHl3/CzPDA
From: Peter Huewe <peterhuewe@gmx.de>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] avr32: Fix build failure conflicting types for 'sys_execve'
Date: Thu,  9 Dec 2010 00:19:33 +0100
Message-Id: <1291850373-6955-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build failure[1] for the avr32 architecture which seems
to be introduced by commit d7627467b7a8
"Make do_execve() take a const filename pointer"

The commit changes the definition in arch/avr32/kernel/process.c but
forgot to change it here.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
This build failure exists in linus' tree - added stable@kernel.org to the cc list

KernelVersion: linux-next-20101208
References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/3607003/

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
1.7.2.2


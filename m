Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0LIVPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:15:39 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44617 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753798Ab0LIVPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:15:38 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+jg0FzgrijLw0WvOeg1PNjVMmtMIgBdRyA36l1xE
	PaOmtG/YB1blAr
From: Peter Huewe <peterhuewe@gmx.de>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH v2] avr32: Fix build failure conflicting types for 'sys_execve'
Date: Thu,  9 Dec 2010 22:15:28 +0100
Message-Id: <1291929328-30551-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20101209182132.GB24175@kroah.com>
References: <20101209182132.GB24175@kroah.com>
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
Cc: stable <stable@kernel.org>
---
KernelVersion: 20101209

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


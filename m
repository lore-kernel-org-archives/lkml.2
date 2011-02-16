Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab1BPAWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:22:23 -0500
Received: from kroah.org ([198.145.64.141]:49126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357Ab1BPAWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:39 2011
Message-Id: <20110216001439.848236431@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [148/272] avr32: use syscall prototypes from asm-generic instead of arch
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

commit 664cb7142ced8b827e92e1851d1ed2cae922f225 upstream.

This patch removes the redundant syscalls prototypes in the architecture
specific syscalls.h header file. These were identical with the ones in
asm-generic/syscalls.h.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Reported-by: Peter Huewe <PeterHuewe@gmx.de>
Reported-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/avr32/include/asm/syscalls.h |    9 ---------
 1 file changed, 9 deletions(-)

--- a/arch/avr32/include/asm/syscalls.h
+++ b/arch/avr32/include/asm/syscalls.h
@@ -16,18 +16,9 @@
 #include <linux/signal.h>
 
 /* kernel/process.c */
-asmlinkage int sys_fork(struct pt_regs *);
 asmlinkage int sys_clone(unsigned long, unsigned long,
 			 unsigned long, unsigned long,
 			 struct pt_regs *);
-asmlinkage int sys_vfork(struct pt_regs *);
-asmlinkage int sys_execve(const char __user *, char __user *__user *,
-			  char __user *__user *, struct pt_regs *);
-
-/* kernel/signal.c */
-asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
-			       struct pt_regs *);
-asmlinkage int sys_rt_sigreturn(struct pt_regs *);
 
 /* mm/cache.c */
 asmlinkage int sys_cacheflush(int, void __user *, size_t);



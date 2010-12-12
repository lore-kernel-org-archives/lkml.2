Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0LMAWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:22:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44862 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab0LLXpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:51 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: dhowells@redhat.com, iwamatsu@nigauri.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [52/223] SH: Add missing consts to sys_execve() declaration
Message-Id: <20101212234549.AA6CFB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: David Howells <dhowells@redhat.com>

commit d8b5fc01683c66060edc202d6bb5635365822181 upstream.

Add missing consts to the sys_execve() declaration which result in the
following error:

arch/sh/kernel/process_32.c:303: error: conflicting types for 'sys_execve'
/warthog/nfs/linux-2.6-fscache/arch/sh/include/asm/syscalls_32.h:24: error: previous declaration of 'sys_execve' was here

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/sh/include/asm/syscalls_32.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/sh/include/asm/syscalls_32.h
===================================================================
--- linux.orig/arch/sh/include/asm/syscalls_32.h
+++ linux/arch/sh/include/asm/syscalls_32.h
@@ -19,8 +19,8 @@ asmlinkage int sys_clone(unsigned long c
 asmlinkage int sys_vfork(unsigned long r4, unsigned long r5,
 			 unsigned long r6, unsigned long r7,
 			 struct pt_regs __regs);
-asmlinkage int sys_execve(char __user *ufilename, char __user * __user *uargv,
-			  char __user * __user *uenvp, unsigned long r7,
+asmlinkage int sys_execve(char __user *ufilename, const char __user * __user *uargv,
+			  const char __user * __user *uenvp, unsigned long r7,
 			  struct pt_regs __regs);
 asmlinkage int sys_sigsuspend(old_sigset_t mask, unsigned long r5,
 			      unsigned long r6, unsigned long r7,

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0HRRz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab0HRRz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:55:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix the declaration of sys_execve() in asm-generic/syscalls.h
To: tony.luck@gmail.com
Cc: torvalds@osdl.org, akpm@linux-foundation.org, xiyou.wangcong@gmail.com,
        ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 18 Aug 2010 18:55:33 +0100
Message-ID: <20100818175533.22912.89002.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the declaration of sys_execve() in asm-generic/syscalls.h to have various
consts applied to its pointers.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-generic/syscalls.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/syscalls.h b/include/asm-generic/syscalls.h
index df84e3b..d89dec8 100644
--- a/include/asm-generic/syscalls.h
+++ b/include/asm-generic/syscalls.h
@@ -23,8 +23,10 @@ asmlinkage long sys_vfork(struct pt_regs *regs);
 #endif
 
 #ifndef sys_execve
-asmlinkage long sys_execve(char __user *filename, char __user * __user *argv,
-			char __user * __user *envp, struct pt_regs *regs);
+asmlinkage long sys_execve(const char __user *filename,
+			   const char __user *const __user *argv,
+			   const char __user *const __user *envp,
+			   struct pt_regs *regs);
 #endif
 
 #ifndef sys_mmap2


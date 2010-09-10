Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0IJQKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:10:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab0IJQKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:10:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/17] SH: Add missing consts to sys_execve() declaration
To: linux-arch@vger.kernel.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 10 Sep 2010 17:10:33 +0100
Message-ID: <20100910161033.20226.24172.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100910161002.20226.27995.stgit@warthog.procyon.org.uk>
References: <20100910161002.20226.27995.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing consts to the sys_execve() declaration which result in the
following error:

arch/sh/kernel/process_32.c:303: error: conflicting types for 'sys_execve'
/warthog/nfs/linux-2.6-fscache/arch/sh/include/asm/syscalls_32.h:24: error: previous declaration of 'sys_execve' was here

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/sh/include/asm/syscalls_32.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/syscalls_32.h b/arch/sh/include/asm/syscalls_32.h
index be201fd..454538a 100644
--- a/arch/sh/include/asm/syscalls_32.h
+++ b/arch/sh/include/asm/syscalls_32.h
@@ -19,8 +19,10 @@ asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
 asmlinkage int sys_vfork(unsigned long r4, unsigned long r5,
 			 unsigned long r6, unsigned long r7,
 			 struct pt_regs __regs);
-asmlinkage int sys_execve(const char __user *ufilename, char __user * __user *uargv,
-			  char __user * __user *uenvp, unsigned long r7,
+asmlinkage int sys_execve(const char __user *ufilename,
+			  const char __user *const __user *uargv,
+			  const char __user *const __user *uenvp,
+			  unsigned long r7,
 			  struct pt_regs __regs);
 asmlinkage int sys_sigsuspend(old_sigset_t mask, unsigned long r5,
 			      unsigned long r6, unsigned long r7,


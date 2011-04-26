Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab1DZVP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:15:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:1363 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab1DZVPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="914749094"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: phil.edworthy@renesas.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [105/106] From: 2.6.35.y: Revert "SH: Add missing consts to sys_execve() declaration"
Message-Id: <20110426211428.234C53E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Date: Thu, 14 Apr 2011 16:11:35 +0100
Subject: 2.6.35.y: Revert "SH: Add missing consts to sys_execve() declaration"

This reverts commit 1219932ca26da2026e598590a3b7a2f36b3c3621
(commit d8b5fc01683c66060edc202d6bb5635365822181 upstream).

The reverted commit depends on an upstream commit that has not
been applied to 2.6.35.y (d7627467b7a8dd6944885290a03a07ceb28c10eb).

This fixes a build failure on all SH devices:

/arch/sh/kernel/process_32.c:299: error: conflicting types for 'sys_execve'
/arch/sh/include/asm/syscalls_32.h:22: note: previous declaration of 'sys_execve' was here

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/sh/include/asm/syscalls_32.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/arch/sh/include/asm/syscalls_32.h
===================================================================
--- linux-2.6.35.y.orig/arch/sh/include/asm/syscalls_32.h
+++ linux-2.6.35.y/arch/sh/include/asm/syscalls_32.h
@@ -19,8 +19,8 @@ asmlinkage int sys_clone(unsigned long c
 asmlinkage int sys_vfork(unsigned long r4, unsigned long r5,
 			 unsigned long r6, unsigned long r7,
 			 struct pt_regs __regs);
-asmlinkage int sys_execve(char __user *ufilename, const char __user * __user *uargv,
-			  const char __user * __user *uenvp, unsigned long r7,
+asmlinkage int sys_execve(char __user *ufilename, char __user * __user *uargv,
+			  char __user * __user *uenvp, unsigned long r7,
 			  struct pt_regs __regs);
 asmlinkage int sys_sigsuspend(old_sigset_t mask, unsigned long r5,
 			      unsigned long r6, unsigned long r7,

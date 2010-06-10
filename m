Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab0FJLOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:14:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39167 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0FJLKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:45 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: jason.wessel@windriver.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [8/23] KGDB: Remove set but unused newPC
Message-Id: <20100610111044.0E350B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm not fully sure this is the correct fix, maybe this
was a bug and newPC should really have a side effect.
Jason?

Found by gcc 4.6's new warnings

Cc: jason.wessel@windriver.com

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/kgdb.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.35-rc2-gcc/arch/x86/kernel/kgdb.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/arch/x86/kernel/kgdb.c
+++ linux-2.6.35-rc2-gcc/arch/x86/kernel/kgdb.c
@@ -458,7 +458,6 @@ int kgdb_arch_handle_exception(int e_vec
 {
 	unsigned long addr;
 	char *ptr;
-	int newPC;
 
 	switch (remcomInBuffer[0]) {
 	case 'c':
@@ -469,8 +468,6 @@ int kgdb_arch_handle_exception(int e_vec
 			linux_regs->ip = addr;
 	case 'D':
 	case 'k':
-		newPC = linux_regs->ip;
-
 		/* clear the trace bit */
 		linux_regs->flags &= ~X86_EFLAGS_TF;
 		atomic_set(&kgdb_cpu_doing_single_step, -1);

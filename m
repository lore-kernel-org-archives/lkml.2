Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2ECJCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:02:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:49882 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab2ECJCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:48 -0400
Message-Id: <20120503085033.967140188@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch V2 02/31] frv: Use core allocator for task_struct
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline;
 filename=frv-use-core-allocator-for-task-struct.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point having a copy of the core allocator.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/include/asm/thread_info.h |    2 --
 arch/frv/kernel/process.c          |   10 ----------
 2 files changed, 12 deletions(-)

Index: tip/arch/frv/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/frv/include/asm/thread_info.h
+++ tip/arch/frv/include/asm/thread_info.h
@@ -21,8 +21,6 @@
 
 #define THREAD_SIZE		8192
 
-#define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
-
 /*
  * low level task data that entry.S needs immediate access to
  * - this struct should fit entirely inside of one cache line
Index: tip/arch/frv/kernel/process.c
===================================================================
--- tip.orig/arch/frv/kernel/process.c
+++ tip/arch/frv/kernel/process.c
@@ -43,16 +43,6 @@ asmlinkage void ret_from_fork(void);
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-struct task_struct *alloc_task_struct_node(int node)
-{
-	return kmalloc_node(sizeof(task_struct), GFP_KERNEL, node);
-}
-
-void free_task_struct(struct task_struct *p)
-{
-	kfree(p);
-}
-
 static void core_sleep_idle(void)
 {
 #ifdef LED_DEBUG_SLEEP



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2E2Lp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 07:45:29 -0400
Received: from hedgehog.storkhole.cz ([90.183.218.18]:3442 "EHLO
	hedgehog.storkhole.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2E2Lp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 07:45:28 -0400
X-Greylist: delayed 965 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2012 07:45:28 EDT
From: Martin Pelikan <pelikan@storkhole.cz>
To: tglx@linutronix.de
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Martin Pelikan <pelikan@storkhole.cz>
Subject: [PATCH] Unbreak UM on newer GCCs.
Date: Tue, 29 May 2012 13:27:44 +0200
Message-Id: <1338290864-12461-1-git-send-email-pelikan@storkhole.cz>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/x86/um/sys_call_table_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/um/sys_call_table_32.c b/arch/x86/um/sys_call_table_32.c
index 416bd40..68d1dc9 100644
--- a/arch/x86/um/sys_call_table_32.c
+++ b/arch/x86/um/sys_call_table_32.c
@@ -39,9 +39,9 @@
 #undef __SYSCALL_I386
 #define __SYSCALL_I386(nr, sym, compat) [ nr ] = sym,
 
-typedef void (*sys_call_ptr_t)(void);
+typedef asmlinkage void (*sys_call_ptr_t)(void);
 
-extern void sys_ni_syscall(void);
+extern asmlinkage void sys_ni_syscall(void);
 
 const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
 	/*
-- 
1.7.8.6


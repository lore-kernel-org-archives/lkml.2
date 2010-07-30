Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646Ab0G3TST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:18:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:33854 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760624Ab0G3TSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:18:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
        Andi Kleen <ak@linux.intel.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 13/15] KGDB: Remove set but unused newPC
Date: Fri, 30 Jul 2010 14:17:34 -0500
Message-Id: <1280517456-1167-14-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
References: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 30 Jul 2010 19:17:50.0439 (UTC) FILETIME=[E6C93F70:01CB301B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Found by gcc 4.6's new warnings

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index bae8982..a8b8097 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -456,7 +456,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 {
 	unsigned long addr;
 	char *ptr;
-	int newPC;
 
 	switch (remcomInBuffer[0]) {
 	case 'c':
@@ -467,8 +466,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 			linux_regs->ip = addr;
 	case 'D':
 	case 'k':
-		newPC = linux_regs->ip;
-
 		/* clear the trace bit */
 		linux_regs->flags &= ~X86_EFLAGS_TF;
 		atomic_set(&kgdb_cpu_doing_single_step, -1);
-- 
1.6.4.rc1


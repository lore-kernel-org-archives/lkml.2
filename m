Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab0HEOop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:44:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:41200 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760663Ab0HEOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:42 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Andi Kleen <ak@linux.intel.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 13/17] KGDB: Remove set but unused newPC
Date: Thu,  5 Aug 2010 09:37:54 -0500
Message-Id: <1281019078-6636-14-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-13-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-7-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-8-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-9-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-10-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-11-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-12-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-13-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:21.0605 (UTC) FILETIME=[DA42BD50:01CB34AB]
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
1.6.3.3


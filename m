Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab0HEOkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:40:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:41215 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336Ab0HEOiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:50 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Dongdong Deng <dongdong.deng@windriver.com>, linux-mips@linux-mips.org
Subject: [PATCH 15/17] kgdb,mips: remove unused kgdb_cpu_doing_single_step operations
Date: Thu,  5 Aug 2010 09:37:56 -0500
Message-Id: <1281019078-6636-16-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-15-git-send-email-jason.wessel@windriver.com>
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
 <1281019078-6636-14-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-15-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:23.0449 (UTC) FILETIME=[DB5C1C90:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mips kgdb specific code does not support software or HW single
stepping so it should not implement

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org
---
 arch/mips/kernel/kgdb.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kernel/kgdb.c b/arch/mips/kernel/kgdb.c
index 5e76c2d..1f4e2fa 100644
--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -329,7 +329,7 @@ static struct notifier_block kgdb_notifier = {
 };
 
 /*
- * Handle the 's' and 'c' commands
+ * Handle the 'c' command
  */
 int kgdb_arch_handle_exception(int vector, int signo, int err_code,
 			       char *remcom_in_buffer, char *remcom_out_buffer,
@@ -337,20 +337,14 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
 {
 	char *ptr;
 	unsigned long address;
-	int cpu = smp_processor_id();
 
 	switch (remcom_in_buffer[0]) {
-	case 's':
 	case 'c':
 		/* handle the optional parameter */
 		ptr = &remcom_in_buffer[1];
 		if (kgdb_hex2long(&ptr, &address))
 			regs->cp0_epc = address;
 
-		atomic_set(&kgdb_cpu_doing_single_step, -1);
-		if (remcom_in_buffer[0] == 's')
-			atomic_set(&kgdb_cpu_doing_single_step, cpu);
-
 		return 0;
 	}
 
-- 
1.6.3.3


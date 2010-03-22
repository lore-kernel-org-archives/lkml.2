Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab0CVTSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:18:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:36512 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab0CVTSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:25 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 6/8] kgdbts,sh: Add in breakpoint pc offset for superh
Date: Mon, 22 Mar 2010 14:17:27 -0500
Message-Id: <1269285449-1424-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1269285449-1424-6-git-send-email-jason.wessel@windriver.com>
References: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-2-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-3-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-4-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-5-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-6-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Mar 2010 19:17:40.0768 (UTC) FILETIME=[57521200:01CAC9F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kgdb test suite mimics the behavior of gdb.  For the sh
architecture the pc must be decremented by 2 for software breakpoint.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---
 drivers/misc/kgdbts.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index fcb6ec1..7245023 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -295,6 +295,10 @@ static int check_and_rewind_pc(char *put_str, char *arg)
 	/* On x86 a breakpoint stop requires it to be decremented */
 	if (addr + 1 == kgdbts_regs.ip)
 		offset = -1;
+#elif defined(CONFIG_SUPERH)
+	/* On SUPERH a breakpoint stop requires it to be decremented */
+	if (addr + 2 == kgdbts_regs.pc)
+		offset = -2;
 #endif
 	if (strcmp(arg, "silent") &&
 		instruction_pointer(&kgdbts_regs) + offset != addr) {
@@ -305,6 +309,8 @@ static int check_and_rewind_pc(char *put_str, char *arg)
 #ifdef CONFIG_X86
 	/* On x86 adjust the instruction pointer if needed */
 	kgdbts_regs.ip += offset;
+#elif defined(CONFIG_SUPERH)
+	kgdbts_regs.pc += offset;
 #endif
 	return 0;
 }
-- 
1.6.4.rc1


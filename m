Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0DBSdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:33:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:57255 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab0DBSdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:33:01 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2/5] kgdbts,sh: Add in breakpoint pc offset for superh
Date: Fri,  2 Apr 2010 13:32:22 -0500
Message-Id: <1270233145-29335-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1270233145-29335-2-git-send-email-jason.wessel@windriver.com>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 02 Apr 2010 18:32:43.0584 (UTC) FILETIME=[E237B400:01CAD292]
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
1.6.3.1.9.g95405b


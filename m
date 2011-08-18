Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1HRTKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:10:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47559 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1HRTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:10:00 -0400
Date: Thu, 18 Aug 2011 20:09:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 66/91] um: sanitize paths in sys_call_table*
 includes
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7yZ-0007wi-RH@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/um/sys_call_table_32.S |    2 +-
 arch/x86/um/sys_call_table_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/um/sys_call_table_32.S b/arch/x86/um/sys_call_table_32.S
index de27407..c3431cf 100644
--- a/arch/x86/um/sys_call_table_32.S
+++ b/arch/x86/um/sys_call_table_32.S
@@ -22,7 +22,7 @@
 
 .section .rodata,"a"
 
-#include "../../x86/kernel/syscall_table_32.S"
+#include "../kernel/syscall_table_32.S"
 
 ENTRY(syscall_table_size)
 .long .-sys_call_table
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index f46de82..99522f7 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -58,7 +58,7 @@ extern void sys_ni_syscall(void);
  */
 
 sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
-#include "../../x86/include/asm/unistd_64.h"
+#include <asm/unistd_64.h>
 };
 
 int syscall_table_size = sizeof(sys_call_table);
-- 
1.7.2.5



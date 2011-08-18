Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1HRTID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:08:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47507 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab1HRTIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:08:00 -0400
Date: Thu, 18 Aug 2011 20:07:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 54/91] um: kill shared/tlb.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7wd-0007qe-PK@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/tlb.h |   13 -------------
 arch/um/kernel/process.c     |    2 +-
 arch/um/kernel/tlb.c         |    1 -
 3 files changed, 1 insertions(+), 15 deletions(-)
 delete mode 100644 arch/um/include/shared/tlb.h

diff --git a/arch/um/include/shared/tlb.h b/arch/um/include/shared/tlb.h
deleted file mode 100644
index 8a50ce1..0000000
--- a/arch/um/include/shared/tlb.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __TLB_H__
-#define __TLB_H__
-
-#include "um_mmu.h"
-
-extern void force_flush_all(void);
-
-#endif
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index fab4371..6f042e7 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -20,12 +20,12 @@
 #include <linux/threads.h>
 #include <asm/current.h>
 #include <asm/pgtable.h>
+#include <asm/mmu_context.h>
 #include <asm/uaccess.h>
 #include "as-layout.h"
 #include "kern_util.h"
 #include "os.h"
 #include "skas.h"
-#include "tlb.h"
 
 /*
  * This is a per-cpu array.  A processor only modifies its entry and it only
diff --git a/arch/um/kernel/tlb.c b/arch/um/kernel/tlb.c
index d1da8ac..11cadb2 100644
--- a/arch/um/kernel/tlb.c
+++ b/arch/um/kernel/tlb.c
@@ -11,7 +11,6 @@
 #include "mem_user.h"
 #include "os.h"
 #include "skas.h"
-#include "tlb.h"
 
 struct host_vm_change {
 	struct host_vm_op {
-- 
1.7.2.5



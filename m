Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1HRTGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:06:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47456 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1HRTGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:06:00 -0400
Date: Thu, 18 Aug 2011 20:05:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 42/91] um: merge kernel_offsets_*.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7uh-0007kR-Jk@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/sys-x86/shared/sysdep/kernel-offsets.h    |   26 +++++++++++++++++----
 arch/um/sys-x86/shared/sysdep/kernel-offsets_32.h |   21 -----------------
 arch/um/sys-x86/shared/sysdep/kernel-offsets_64.h |   23 ------------------
 3 files changed, 21 insertions(+), 49 deletions(-)
 delete mode 100644 arch/um/sys-x86/shared/sysdep/kernel-offsets_32.h
 delete mode 100644 arch/um/sys-x86/shared/sysdep/kernel-offsets_64.h

diff --git a/arch/um/sys-x86/shared/sysdep/kernel-offsets.h b/arch/um/sys-x86/shared/sysdep/kernel-offsets.h
index 346bc08..5868526 100644
--- a/arch/um/sys-x86/shared/sysdep/kernel-offsets.h
+++ b/arch/um/sys-x86/shared/sysdep/kernel-offsets.h
@@ -1,5 +1,21 @@
-#ifdef __i386__
-#include "kernel-offsets_32.h"
-#else
-#include "kernel-offsets_64.h"
-#endif
+#include <linux/stddef.h>
+#include <linux/sched.h>
+#include <linux/elf.h>
+#include <linux/crypto.h>
+#include <asm/mman.h>
+
+#define DEFINE(sym, val) \
+	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+
+#define STR(x) #x
+#define DEFINE_STR(sym, val) asm volatile("\n->" #sym " " STR(val) " " #val: : )
+
+#define BLANK() asm volatile("\n->" : : )
+
+#define OFFSET(sym, str, mem) \
+	DEFINE(sym, offsetof(struct str, mem));
+
+void foo(void)
+{
+#include <common-offsets.h>
+}
diff --git a/arch/um/sys-x86/shared/sysdep/kernel-offsets_32.h b/arch/um/sys-x86/shared/sysdep/kernel-offsets_32.h
deleted file mode 100644
index 5868526..0000000
--- a/arch/um/sys-x86/shared/sysdep/kernel-offsets_32.h
+++ /dev/null
@@ -1,21 +0,0 @@
-#include <linux/stddef.h>
-#include <linux/sched.h>
-#include <linux/elf.h>
-#include <linux/crypto.h>
-#include <asm/mman.h>
-
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define STR(x) #x
-#define DEFINE_STR(sym, val) asm volatile("\n->" #sym " " STR(val) " " #val: : )
-
-#define BLANK() asm volatile("\n->" : : )
-
-#define OFFSET(sym, str, mem) \
-	DEFINE(sym, offsetof(struct str, mem));
-
-void foo(void)
-{
-#include <common-offsets.h>
-}
diff --git a/arch/um/sys-x86/shared/sysdep/kernel-offsets_64.h b/arch/um/sys-x86/shared/sysdep/kernel-offsets_64.h
deleted file mode 100644
index a307237..0000000
--- a/arch/um/sys-x86/shared/sysdep/kernel-offsets_64.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#include <linux/stddef.h>
-#include <linux/sched.h>
-#include <linux/time.h>
-#include <linux/elf.h>
-#include <linux/crypto.h>
-#include <asm/page.h>
-#include <asm/mman.h>
-
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define DEFINE_STR1(x) #x
-#define DEFINE_STR(sym, val) asm volatile("\n->" #sym " " DEFINE_STR1(val) " " #val: : )
-
-#define BLANK() asm volatile("\n->" : : )
-
-#define OFFSET(sym, str, mem) \
-	DEFINE(sym, offsetof(struct str, mem));
-
-void foo(void)
-{
-#include <common-offsets.h>
-}
-- 
1.7.2.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1HRTJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:09:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47535 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab1HRTJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:09:20 -0400
Date: Thu, 18 Aug 2011 20:09:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 62/91] um: merge tls_{32,64}.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7xv-0007t6-QK@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/um/shared/sysdep/tls.h    |   38 +++++++++++++++++++++++++++++++++--
 arch/x86/um/shared/sysdep/tls_32.h |   32 ------------------------------
 arch/x86/um/shared/sysdep/tls_64.h |   29 ---------------------------
 3 files changed, 35 insertions(+), 64 deletions(-)
 delete mode 100644 arch/x86/um/shared/sysdep/tls_32.h
 delete mode 100644 arch/x86/um/shared/sysdep/tls_64.h

diff --git a/arch/x86/um/shared/sysdep/tls.h b/arch/x86/um/shared/sysdep/tls.h
index 4d8f752..db2ae9c 100644
--- a/arch/x86/um/shared/sysdep/tls.h
+++ b/arch/x86/um/shared/sysdep/tls.h
@@ -1,5 +1,37 @@
+#ifndef _SYSDEP_TLS_H
+#define _SYSDEP_TLS_H
+
+# ifndef __KERNEL__
+
+/* Change name to avoid conflicts with the original one from <asm/ldt.h>, which
+ * may be named user_desc (but in 2.4 and in header matching its API was named
+ * modify_ldt_ldt_s). */
+
+typedef struct um_dup_user_desc {
+	unsigned int  entry_number;
+	unsigned int  base_addr;
+	unsigned int  limit;
+	unsigned int  seg_32bit:1;
+	unsigned int  contents:2;
+	unsigned int  read_exec_only:1;
+	unsigned int  limit_in_pages:1;
+	unsigned int  seg_not_present:1;
+	unsigned int  useable:1;
+#ifdef __x86_64__
+	unsigned int  lm:1;
+#endif
+} user_desc_t;
+
+# else /* __KERNEL__ */
+
+#  include <ldt.h>
+typedef struct user_desc user_desc_t;
+
+# endif /* __KERNEL__ */
+
 #ifdef __i386__
-#include "tls_32.h"
-#else
-#include "tls_64.h"
+#define GDT_ENTRY_TLS_MIN_I386 6
+#define GDT_ENTRY_TLS_MIN_X86_64 12
 #endif
+
+#endif /* _SYSDEP_TLS_H */
diff --git a/arch/x86/um/shared/sysdep/tls_32.h b/arch/x86/um/shared/sysdep/tls_32.h
deleted file mode 100644
index 3455075..0000000
--- a/arch/x86/um/shared/sysdep/tls_32.h
+++ /dev/null
@@ -1,32 +0,0 @@
-#ifndef _SYSDEP_TLS_H
-#define _SYSDEP_TLS_H
-
-# ifndef __KERNEL__
-
-/* Change name to avoid conflicts with the original one from <asm/ldt.h>, which
- * may be named user_desc (but in 2.4 and in header matching its API was named
- * modify_ldt_ldt_s). */
-
-typedef struct um_dup_user_desc {
-	unsigned int  entry_number;
-	unsigned int  base_addr;
-	unsigned int  limit;
-	unsigned int  seg_32bit:1;
-	unsigned int  contents:2;
-	unsigned int  read_exec_only:1;
-	unsigned int  limit_in_pages:1;
-	unsigned int  seg_not_present:1;
-	unsigned int  useable:1;
-} user_desc_t;
-
-# else /* __KERNEL__ */
-
-#  include <ldt.h>
-typedef struct user_desc user_desc_t;
-
-# endif /* __KERNEL__ */
-
-#define GDT_ENTRY_TLS_MIN_I386 6
-#define GDT_ENTRY_TLS_MIN_X86_64 12
-
-#endif /* _SYSDEP_TLS_H */
diff --git a/arch/x86/um/shared/sysdep/tls_64.h b/arch/x86/um/shared/sysdep/tls_64.h
deleted file mode 100644
index 18c000d..0000000
--- a/arch/x86/um/shared/sysdep/tls_64.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef _SYSDEP_TLS_H
-#define _SYSDEP_TLS_H
-
-# ifndef __KERNEL__
-
-/* Change name to avoid conflicts with the original one from <asm/ldt.h>, which
- * may be named user_desc (but in 2.4 and in header matching its API was named
- * modify_ldt_ldt_s). */
-
-typedef struct um_dup_user_desc {
-	unsigned int  entry_number;
-	unsigned int  base_addr;
-	unsigned int  limit;
-	unsigned int  seg_32bit:1;
-	unsigned int  contents:2;
-	unsigned int  read_exec_only:1;
-	unsigned int  limit_in_pages:1;
-	unsigned int  seg_not_present:1;
-	unsigned int  useable:1;
-	unsigned int  lm:1;
-} user_desc_t;
-
-# else /* __KERNEL__ */
-
-#  include <ldt.h>
-typedef struct user_desc user_desc_t;
-
-# endif /* __KERNEL__ */
-#endif /* _SYSDEP_TLS_H */
-- 
1.7.2.5



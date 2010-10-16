Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0JPVoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 17:44:23 -0400
Received: from [69.28.251.93] ([69.28.251.93]:33769 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756612Ab0JPVoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 17:44:18 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 resend 7/9] MIPS: Move FIXADDR_TOP into spaces.h
Date: Sat, 16 Oct 2010 14:22:36 -0700
Message-Id: <fe1e89d51cb25a9b6343a3dea0e8ec08@localhost>
In-Reply-To: <17ebecce124618ddf83ec6fe8e526f93@localhost>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory maps and addressing quirks are normally defined in <spaces.h>.
There are already three targets that need to override FIXADDR_TOP, and
others exist.  This will be a cleaner approach than adding lots of
ifdefs in fixmap.h .

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/fixmap.h              |   10 +---------
 arch/mips/include/asm/mach-bcm63xx/spaces.h |   17 +++++++++++++++++
 arch/mips/include/asm/mach-generic/spaces.h |    4 ++++
 arch/mips/include/asm/mach-tx39xx/spaces.h  |   17 +++++++++++++++++
 arch/mips/include/asm/mach-tx49xx/spaces.h  |   17 +++++++++++++++++
 5 files changed, 56 insertions(+), 9 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-bcm63xx/spaces.h
 create mode 100644 arch/mips/include/asm/mach-tx39xx/spaces.h
 create mode 100644 arch/mips/include/asm/mach-tx49xx/spaces.h

diff --git a/arch/mips/include/asm/fixmap.h b/arch/mips/include/asm/fixmap.h
index 0b89b83..98bcc98 100644
--- a/arch/mips/include/asm/fixmap.h
+++ b/arch/mips/include/asm/fixmap.h
@@ -14,6 +14,7 @@
 #define _ASM_FIXMAP_H
 
 #include <asm/page.h>
+#include <spaces.h>
 #ifdef CONFIG_HIGHMEM
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
@@ -67,15 +68,6 @@ enum fixed_addresses {
  * the start of the fixmap, and leave one page empty
  * at the top of mem..
  */
-#ifdef CONFIG_BCM63XX
-#define FIXADDR_TOP     ((unsigned long)(long)(int)0xff000000)
-#else
-#if defined(CONFIG_CPU_TX39XX) || defined(CONFIG_CPU_TX49XX)
-#define FIXADDR_TOP	((unsigned long)(long)(int)(0xff000000 - 0x20000))
-#else
-#define FIXADDR_TOP	((unsigned long)(long)(int)0xfffe0000)
-#endif
-#endif
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
 
diff --git a/arch/mips/include/asm/mach-bcm63xx/spaces.h b/arch/mips/include/asm/mach-bcm63xx/spaces.h
new file mode 100644
index 0000000..61e750f
--- /dev/null
+++ b/arch/mips/include/asm/mach-bcm63xx/spaces.h
@@ -0,0 +1,17 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1994 - 1999, 2000, 03, 04 Ralf Baechle
+ * Copyright (C) 2000, 2002  Maciej W. Rozycki
+ * Copyright (C) 1990, 1999, 2000 Silicon Graphics, Inc.
+ */
+#ifndef _ASM_BCM63XX_SPACES_H
+#define _ASM_BCM63XX_SPACES_H
+
+#define FIXADDR_TOP		((unsigned long)(long)(int)0xff000000)
+
+#include <asm/mach-generic/spaces.h>
+
+#endif /* __ASM_BCM63XX_SPACES_H */
diff --git a/arch/mips/include/asm/mach-generic/spaces.h b/arch/mips/include/asm/mach-generic/spaces.h
index c9fa4b1..d7a9efd 100644
--- a/arch/mips/include/asm/mach-generic/spaces.h
+++ b/arch/mips/include/asm/mach-generic/spaces.h
@@ -82,4 +82,8 @@
 #define PAGE_OFFSET		(CAC_BASE + PHYS_OFFSET)
 #endif
 
+#ifndef FIXADDR_TOP
+#define FIXADDR_TOP		((unsigned long)(long)(int)0xfffe0000)
+#endif
+
 #endif /* __ASM_MACH_GENERIC_SPACES_H */
diff --git a/arch/mips/include/asm/mach-tx39xx/spaces.h b/arch/mips/include/asm/mach-tx39xx/spaces.h
new file mode 100644
index 0000000..151fe7a
--- /dev/null
+++ b/arch/mips/include/asm/mach-tx39xx/spaces.h
@@ -0,0 +1,17 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1994 - 1999, 2000, 03, 04 Ralf Baechle
+ * Copyright (C) 2000, 2002  Maciej W. Rozycki
+ * Copyright (C) 1990, 1999, 2000 Silicon Graphics, Inc.
+ */
+#ifndef _ASM_TX39XX_SPACES_H
+#define _ASM_TX39XX_SPACES_H
+
+#define FIXADDR_TOP		((unsigned long)(long)(int)0xfefe0000)
+
+#include <asm/mach-generic/spaces.h>
+
+#endif /* __ASM_TX39XX_SPACES_H */
diff --git a/arch/mips/include/asm/mach-tx49xx/spaces.h b/arch/mips/include/asm/mach-tx49xx/spaces.h
new file mode 100644
index 0000000..0cb10a6
--- /dev/null
+++ b/arch/mips/include/asm/mach-tx49xx/spaces.h
@@ -0,0 +1,17 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1994 - 1999, 2000, 03, 04 Ralf Baechle
+ * Copyright (C) 2000, 2002  Maciej W. Rozycki
+ * Copyright (C) 1990, 1999, 2000 Silicon Graphics, Inc.
+ */
+#ifndef _ASM_TX49XX_SPACES_H
+#define _ASM_TX49XX_SPACES_H
+
+#define FIXADDR_TOP		((unsigned long)(long)(int)0xfefe0000)
+
+#include <asm/mach-generic/spaces.h>
+
+#endif /* __ASM_TX49XX_SPACES_H */
-- 
1.7.0.4


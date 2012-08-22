Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab2HVTZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:25:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18851 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab2HVTZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:25:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6811"; a="225997325"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Subject: [PATCH/RESEND] Move most arches to asm-generic/current.h
Date: Wed, 22 Aug 2012 12:25:14 -0700
Message-Id: <1345663514-2642-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make get_current() into a static inline function in the
generic version of current.h so we match what almost every
architecture is doing. This allows us to move most of the arches
over to this generic header instead of redefining the same thing
over and over in each asm directory.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arch@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Marc Gauthier <marc@tensilica.com> [Xtensa]
Acked-by: David S. Miller <davem@davemloft.net> [Sparc]
Acked-by: Chris Metcalf <cmetcalf@tilera.com> [Tile]
Acked-by: David Howells <dhowells@redhat.com> [MN10300]
---

This stalled last round. Resending to collect more acks from arch
maintainers and rebased against linux-next-20120822.

Arnd, can this go through the asm-generic tree?

 arch/alpha/include/asm/Kbuild      |  2 ++
 arch/alpha/include/asm/current.h   |  9 ---------
 arch/arm/include/asm/current.h     |  9 +--------
 arch/avr32/include/asm/Kbuild      |  2 ++
 arch/avr32/include/asm/current.h   | 15 ---------------
 arch/cris/include/asm/Kbuild       |  2 ++
 arch/cris/include/asm/current.h    | 15 ---------------
 arch/h8300/include/asm/current.h   | 26 +-------------------------
 arch/m32r/include/asm/Kbuild       |  1 +
 arch/m32r/include/asm/current.h    | 15 ---------------
 arch/m68k/include/asm/current.h    | 18 ++----------------
 arch/mn10300/include/asm/current.h |  8 +-------
 arch/parisc/include/asm/Kbuild     |  2 ++
 arch/parisc/include/asm/current.h  | 15 ---------------
 arch/sparc/include/asm/current.h   | 16 +++-------------
 arch/tile/include/asm/current.h    | 10 +---------
 arch/xtensa/include/asm/current.h  | 11 +----------
 include/asm-generic/current.h      |  9 ++++++++-
 18 files changed, 27 insertions(+), 158 deletions(-)
 delete mode 100644 arch/alpha/include/asm/current.h
 delete mode 100644 arch/avr32/include/asm/current.h
 delete mode 100644 arch/cris/include/asm/current.h
 delete mode 100644 arch/m32r/include/asm/current.h
 delete mode 100644 arch/parisc/include/asm/current.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index e423def..37f1cac 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -1,5 +1,7 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y += current.h
+
 header-y += compiler.h
 header-y += console.h
 header-y += fpu.h
diff --git a/arch/alpha/include/asm/current.h b/arch/alpha/include/asm/current.h
deleted file mode 100644
index 094d285..0000000
--- a/arch/alpha/include/asm/current.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _ALPHA_CURRENT_H
-#define _ALPHA_CURRENT_H
-
-#include <linux/thread_info.h>
-
-#define get_current()	(current_thread_info()->task)
-#define current		get_current()
-
-#endif /* _ALPHA_CURRENT_H */
diff --git a/arch/arm/include/asm/current.h b/arch/arm/include/asm/current.h
index 75d21e2..7dd0eec 100644
--- a/arch/arm/include/asm/current.h
+++ b/arch/arm/include/asm/current.h
@@ -1,15 +1,8 @@
 #ifndef _ASMARM_CURRENT_H
 #define _ASMARM_CURRENT_H
 
-#include <linux/thread_info.h>
-
 static inline struct task_struct *get_current(void) __attribute_const__;
 
-static inline struct task_struct *get_current(void)
-{
-	return current_thread_info()->task;
-}
-
-#define current (get_current())
+#include <asm-generic/current.h>
 
 #endif /* _ASMARM_CURRENT_H */
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 3136628..851e4b0 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -1,3 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y	+= current.h
+
 header-y	+= cachectl.h
diff --git a/arch/avr32/include/asm/current.h b/arch/avr32/include/asm/current.h
deleted file mode 100644
index c7b0549..0000000
--- a/arch/avr32/include/asm/current.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef __ASM_AVR32_CURRENT_H
-#define __ASM_AVR32_CURRENT_H
-
-#include <linux/thread_info.h>
-
-struct task_struct;
-
-inline static struct task_struct * get_current(void)
-{
-	return current_thread_info()->task;
-}
-
-#define current get_current()
-
-#endif /* __ASM_AVR32_CURRENT_H */
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 28b690d..ed7b868 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -1,5 +1,7 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y += current.h
+
 header-y += arch-v10/
 header-y += arch-v32/
 
diff --git a/arch/cris/include/asm/current.h b/arch/cris/include/asm/current.h
deleted file mode 100644
index 5f5c0efd..0000000
--- a/arch/cris/include/asm/current.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _CRIS_CURRENT_H
-#define _CRIS_CURRENT_H
-
-#include <linux/thread_info.h>
-
-struct task_struct;
-
-static inline struct task_struct * get_current(void)
-{
-        return current_thread_info()->task;
-}
- 
-#define current get_current()
-
-#endif /* !(_CRIS_CURRENT_H) */
diff --git a/arch/h8300/include/asm/current.h b/arch/h8300/include/asm/current.h
index 57d74ee..4c51401 100644
--- a/arch/h8300/include/asm/current.h
+++ b/arch/h8300/include/asm/current.h
@@ -1,25 +1 @@
-#ifndef _H8300_CURRENT_H
-#define _H8300_CURRENT_H
-/*
- *	current.h
- *	(C) Copyright 2000, Lineo, David McCullough <davidm@lineo.com>
- *	(C) Copyright 2002, Greg Ungerer (gerg@snapgear.com)
- *
- *	rather than dedicate a register (as the m68k source does), we
- *	just keep a global,  we should probably just change it all to be
- *	current and lose _current_task.
- */
-
-#include <linux/thread_info.h>
-#include <asm/thread_info.h>
-
-struct task_struct;
-
-static inline struct task_struct *get_current(void)
-{
-	return(current_thread_info()->task);
-}
-
-#define	current	get_current()
-
-#endif /* _H8300_CURRENT_H */
+#include <asm-generic/current.h>
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 871382d..2d20ee0 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 generic-y	+= module.h
+generic-y	+= current.h
diff --git a/arch/m32r/include/asm/current.h b/arch/m32r/include/asm/current.h
deleted file mode 100644
index 7859d86..0000000
--- a/arch/m32r/include/asm/current.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _ASM_M32R_CURRENT_H
-#define _ASM_M32R_CURRENT_H
-
-#include <linux/thread_info.h>
-
-struct task_struct;
-
-static __inline__ struct task_struct *get_current(void)
-{
-	return current_thread_info()->task;
-}
-
-#define current	(get_current())
-
-#endif	/* _ASM_M32R_CURRENT_H */
diff --git a/arch/m68k/include/asm/current.h b/arch/m68k/include/asm/current.h
index 91fcc53..eb9ae55 100644
--- a/arch/m68k/include/asm/current.h
+++ b/arch/m68k/include/asm/current.h
@@ -7,22 +7,8 @@ register struct task_struct *current __asm__("%a2");
 
 #else
 
-/*
- *	Rather than dedicate a register (as the m68k source does), we
- *	just keep a global,  we should probably just change it all to be
- *	current and lose _current_task.
- */
-#include <linux/thread_info.h>
+#include <asm-generic/current.h>
 
-struct task_struct;
-
-static inline struct task_struct *get_current(void)
-{
-	return(current_thread_info()->task);
-}
-
-#define	current	get_current()
-
-#endif /* CONFNIG_MMU */
+#endif /* CONFIG_MMU */
 
 #endif /* !(_M68K_CURRENT_H) */
diff --git a/arch/mn10300/include/asm/current.h b/arch/mn10300/include/asm/current.h
index ca6027d..c1ee370 100644
--- a/arch/mn10300/include/asm/current.h
+++ b/arch/mn10300/include/asm/current.h
@@ -25,13 +25,7 @@ register struct task_struct *const current asm("e2") __attribute__((used));
 extern struct task_struct *__current;
 
 #else
-static inline __attribute__((const))
-struct task_struct *get_current(void)
-{
-	return current_thread_info()->task;
-}
-
-#define current get_current()
+#include <asm-generic/current.h>
 #endif
 
 #endif /* _ASM_CURRENT_H */
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 4383707..d702dac 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,4 +1,6 @@
 include include/asm-generic/Kbuild.asm
 
+generic-y += current.h
+
 header-y += pdc.h
 generic-y += word-at-a-time.h
diff --git a/arch/parisc/include/asm/current.h b/arch/parisc/include/asm/current.h
deleted file mode 100644
index 0fb9338..0000000
--- a/arch/parisc/include/asm/current.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _PARISC_CURRENT_H
-#define _PARISC_CURRENT_H
-
-#include <linux/thread_info.h>
-
-struct task_struct;
-
-static inline struct task_struct * get_current(void)
-{
-	return current_thread_info()->task;
-}
- 
-#define current get_current()
-
-#endif /* !(_PARISC_CURRENT_H) */
diff --git a/arch/sparc/include/asm/current.h b/arch/sparc/include/asm/current.h
index 10a0df5..023b330 100644
--- a/arch/sparc/include/asm/current.h
+++ b/arch/sparc/include/asm/current.h
@@ -11,24 +11,14 @@
 #ifndef _SPARC_CURRENT_H
 #define _SPARC_CURRENT_H
 
-#include <linux/thread_info.h>
-
 #ifdef CONFIG_SPARC64
+#include <linux/thread_info.h>
 register struct task_struct *current asm("g4");
 #endif
 
 #ifdef CONFIG_SPARC32
-/* We might want to consider using %g4 like sparc64 to shave a few cycles.
- *
- * Two stage process (inline + #define) for type-checking.
- * We also obfuscate get_current() to check if anyone used that by mistake.
- */
-struct task_struct;
-static inline struct task_struct *__get_current(void)
-{
-	return current_thread_info()->task;
-}
-#define current __get_current()
+/* We might want to consider using %g4 like sparc64 to shave a few cycles. */
+#include <asm-generic/current.h>
 #endif
 
 #endif /* !(_SPARC_CURRENT_H) */
diff --git a/arch/tile/include/asm/current.h b/arch/tile/include/asm/current.h
index da21acf..3fe65f7 100644
--- a/arch/tile/include/asm/current.h
+++ b/arch/tile/include/asm/current.h
@@ -15,15 +15,7 @@
 #ifndef _ASM_TILE_CURRENT_H
 #define _ASM_TILE_CURRENT_H
 
-#include <linux/thread_info.h>
-
-struct task_struct;
-
-static inline struct task_struct *get_current(void)
-{
-	return current_thread_info()->task;
-}
-#define current get_current()
+#include <asm-generic/current.h>
 
 /* Return a usable "task_struct" pointer even if the real one is corrupt. */
 struct task_struct *validate_current(void);
diff --git a/arch/xtensa/include/asm/current.h b/arch/xtensa/include/asm/current.h
index 8d1eb5d..8c98868 100644
--- a/arch/xtensa/include/asm/current.h
+++ b/arch/xtensa/include/asm/current.h
@@ -13,16 +13,7 @@
 
 #ifndef __ASSEMBLY__
 
-#include <linux/thread_info.h>
-
-struct task_struct;
-
-static inline struct task_struct *get_current(void)
-{
-	return current_thread_info()->task;
-}
-
-#define current get_current()
+#include <asm-generic/current.h>
 
 #else
 
diff --git a/include/asm-generic/current.h b/include/asm-generic/current.h
index 5e86f6a..bbfb795 100644
--- a/include/asm-generic/current.h
+++ b/include/asm-generic/current.h
@@ -1,9 +1,16 @@
 #ifndef __ASM_GENERIC_CURRENT_H
 #define __ASM_GENERIC_CURRENT_H
 
+#include <linux/compiler.h>
 #include <linux/thread_info.h>
 
-#define get_current() (current_thread_info()->task)
+struct task_struct;
+
+static __always_inline struct task_struct *get_current(void)
+{
+	return current_thread_info()->task;
+}
+
 #define current get_current()
 
 #endif /* __ASM_GENERIC_CURRENT_H */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


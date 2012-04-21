Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2DUJNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:13:11 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:47573 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab2DUJKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:21 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 07/17] ARM clps711x: Remove unused includes
Date: Sat, 21 Apr 2012 13:11:20 +0400
Message-Id: <1334999490-27177-8-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All necessary definitions now provides by mach/hardware.h

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/include/asm/hardware/ep7211.h            |    2 --
 arch/arm/mach-clps711x/common.c                   |    1 -
 arch/arm/mach-clps711x/include/mach/debug-macro.S |    1 -
 arch/arm/mach-clps711x/include/mach/entry-macro.S |    1 -
 arch/arm/mach-clps711x/include/mach/hardware.h    |   18 ++----------------
 arch/arm/mach-clps711x/include/mach/time.h        |    2 +-
 arch/arm/mach-clps711x/include/mach/uncompress.h  |    1 -
 arch/arm/mach-clps711x/p720t-leds.c               |    3 ---
 drivers/tty/serial/clps711x.c                     |    1 -
 drivers/video/clps711xfb.c                        |    1 -
 10 files changed, 3 insertions(+), 28 deletions(-)

diff --git a/arch/arm/include/asm/hardware/ep7211.h b/arch/arm/include/asm/hardware/ep7211.h
index ca4d198..0b09e38 100644
--- a/arch/arm/include/asm/hardware/ep7211.h
+++ b/arch/arm/include/asm/hardware/ep7211.h
@@ -23,8 +23,6 @@
 #ifndef __ASM_HARDWARE_EP7211_H
 #define __ASM_HARDWARE_EP7211_H
 
-#include <asm/hardware/clps7111.h>
-
 #define EP7211_PHYS_BASE	(0x80000000)
 
 /*
diff --git a/arch/arm/mach-clps711x/common.c b/arch/arm/mach-clps711x/common.c
index 3c5b5bb..3544433 100644
--- a/arch/arm/mach-clps711x/common.c
+++ b/arch/arm/mach-clps711x/common.c
@@ -36,7 +36,6 @@
 #include <asm/page.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
-#include <asm/hardware/clps7111.h>
 #include <asm/system_misc.h>
 
 /*
diff --git a/arch/arm/mach-clps711x/include/mach/debug-macro.S b/arch/arm/mach-clps711x/include/mach/debug-macro.S
index b802e8a..15a9036 100644
--- a/arch/arm/mach-clps711x/include/mach/debug-macro.S
+++ b/arch/arm/mach-clps711x/include/mach/debug-macro.S
@@ -12,7 +12,6 @@
 */
 
 #include <mach/hardware.h>
-#include <asm/hardware/clps7111.h>
 
 		.macro	addruart, rp, rv, tmp
 #ifndef CONFIG_DEBUG_CLPS711X_UART2
diff --git a/arch/arm/mach-clps711x/include/mach/entry-macro.S b/arch/arm/mach-clps711x/include/mach/entry-macro.S
index 125af59..4ff5e77 100644
--- a/arch/arm/mach-clps711x/include/mach/entry-macro.S
+++ b/arch/arm/mach-clps711x/include/mach/entry-macro.S
@@ -8,7 +8,6 @@
  * warranty of any kind, whether express or implied.
  */
 #include <mach/hardware.h>
-#include <asm/hardware/clps7111.h>
 
 		.macro	get_irqnr_preamble, base, tmp
 		.endm
diff --git a/arch/arm/mach-clps711x/include/mach/hardware.h b/arch/arm/mach-clps711x/include/mach/hardware.h
index f00e87a..fa9b8f2 100644
--- a/arch/arm/mach-clps711x/include/mach/hardware.h
+++ b/arch/arm/mach-clps711x/include/mach/hardware.h
@@ -22,10 +22,11 @@
 #ifndef __ASM_ARCH_HARDWARE_H
 #define __ASM_ARCH_HARDWARE_H
 
-
 #define CLPS7111_VIRT_BASE	0xff000000
 #define CLPS7111_BASE		CLPS7111_VIRT_BASE
 
+#include <asm/hardware/clps7111.h>
+
 /*
  * The physical addresses that the external chip select signals map to is
  * dependent on the setting of the nMEDCHG signal on EP7211 and EP7212
@@ -69,19 +70,8 @@
 #define SYSPLD_VIRT_BASE	0xfe000000
 #define SYSPLD_BASE		SYSPLD_VIRT_BASE
 
-#if  defined (CONFIG_ARCH_AUTCPU12)
-
-#include <asm/hardware/clps7111.h>
-#include <asm/hardware/ep7212.h>
-
-#endif
-
-
 #if defined (CONFIG_ARCH_CDB89712)
 
-#include <asm/hardware/clps7111.h>
-#include <asm/hardware/ep7212.h>
-
 /* static cdb89712_map_io() areas */
 #define REGISTER_START   0x80000000
 #define REGISTER_SIZE    0x4000
@@ -149,10 +139,6 @@
 
 #if defined (CONFIG_ARCH_CEIVA)
 
-#include <asm/hardware/clps7111.h>
-#include <asm/hardware/ep7212.h>
-
-
 /*
  * The two flash banks are wired to chip selects 0 and 1. This is the mapping
  * for them.
diff --git a/arch/arm/mach-clps711x/include/mach/time.h b/arch/arm/mach-clps711x/include/mach/time.h
index 61fef91..5f65865 100644
--- a/arch/arm/mach-clps711x/include/mach/time.h
+++ b/arch/arm/mach-clps711x/include/mach/time.h
@@ -18,7 +18,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 #include <asm/leds.h>
-#include <asm/hardware/clps7111.h>
+#include <mach/hardware.h>
 
 extern void clps711x_setup_timer(void);
 
diff --git a/arch/arm/mach-clps711x/include/mach/uncompress.h b/arch/arm/mach-clps711x/include/mach/uncompress.h
index 35ed731..ac42332 100644
--- a/arch/arm/mach-clps711x/include/mach/uncompress.h
+++ b/arch/arm/mach-clps711x/include/mach/uncompress.h
@@ -18,7 +18,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 #include <mach/hardware.h>
-#include <asm/hardware/clps7111.h>
 
 #undef CLPS7111_BASE
 #define CLPS7111_BASE CLPS7111_PHYS_BASE
diff --git a/arch/arm/mach-clps711x/p720t-leds.c b/arch/arm/mach-clps711x/p720t-leds.c
index dd9a6cd..bbc449f 100644
--- a/arch/arm/mach-clps711x/p720t-leds.c
+++ b/arch/arm/mach-clps711x/p720t-leds.c
@@ -27,9 +27,6 @@
 #include <asm/leds.h>
 #include <asm/mach-types.h>
 
-#include <asm/hardware/clps7111.h>
-#include <asm/hardware/ep7212.h>
-
 static void p720t_leds_event(led_event_t ledevt)
 {
 	unsigned long flags;
diff --git a/drivers/tty/serial/clps711x.c b/drivers/tty/serial/clps711x.c
index 836fe273..d0f719f 100644
--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -40,7 +40,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/hardware/clps7111.h>
 
 #define UART_NR		2
 
diff --git a/drivers/video/clps711xfb.c b/drivers/video/clps711xfb.c
index 99b354b..f994c8b 100644
--- a/drivers/video/clps711xfb.c
+++ b/drivers/video/clps711xfb.c
@@ -33,7 +33,6 @@
 #include <asm/mach-types.h>
 #include <linux/uaccess.h>
 
-#include <asm/hardware/clps7111.h>
 #include <mach/syspld.h>
 
 struct fb_info	*cfb;
-- 
1.7.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab2IXSze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:55:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42227 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab2IXSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:55:31 -0400
From: selso <selso.liberado@gmail.com>
To: omar.ramirez@ti.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] The tidspbridge driver does not compile anymore (Some OMAP34XX CPU definitions are missing). I Added a header file for these definitions.
Date: Mon, 24 Sep 2012 20:54:53 +0200
Message-Id: <1348512893-1375-1-git-send-email-selso.liberado@gmail.com>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sli <sli@SLI-V420.(none)>


Signed-off-by: sli <sli@SLI-V420.(none)>
---
 drivers/staging/tidspbridge/core/dsp-clock.c       |    3 ++
 drivers/staging/tidspbridge/core/tiomap3430.c      |    4 ++
 drivers/staging/tidspbridge/core/wdt.c             |    2 +-
 .../tidspbridge/include/dspbridge/omap34xx.h       |   33 ++++++++++++++++++++
 4 files changed, 41 insertions(+), 1 deletions(-)
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/omap34xx.h

diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index 7d056bd..746fd52 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -18,6 +18,9 @@
 
 #include <linux/types.h>
 
+/*  ----------------------------------- CPU definitions */
+#include <dspbridge/omap34xx.h>
+
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 #include <plat/dmtimer.h>
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 7bf55c4..637bf63 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -19,6 +19,10 @@
 #include <linux/platform_data/dsp-omap.h>
 
 #include <linux/types.h>
+
+/*  ----------------------------------- CPU definitions */
+#include <dspbridge/omap34xx.h>
+
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 #include <linux/mm.h>
diff --git a/drivers/staging/tidspbridge/core/wdt.c b/drivers/staging/tidspbridge/core/wdt.c
index 453ef74..4cf1dd1 100644
--- a/drivers/staging/tidspbridge/core/wdt.c
+++ b/drivers/staging/tidspbridge/core/wdt.c
@@ -17,6 +17,7 @@
  */
 #include <linux/types.h>
 
+#include <dspbridge/omap34xx.h>
 #include <dspbridge/dbdefs.h>
 #include <dspbridge/dspdeh.h>
 #include <dspbridge/dev.h>
@@ -24,7 +25,6 @@
 #include <dspbridge/wdt.h>
 #include <dspbridge/host_os.h>
 
-
 #define INT_34XX_WDT3_IRQ 		(36 + NR_IRQS)
 
 static struct dsp_wdt_setting dsp_wdt;
diff --git a/drivers/staging/tidspbridge/include/dspbridge/omap34xx.h b/drivers/staging/tidspbridge/include/dspbridge/omap34xx.h
new file mode 100644
index 0000000..66a6fc8
--- /dev/null
+++ b/drivers/staging/tidspbridge/include/dspbridge/omap34xx.h
@@ -0,0 +1,32 @@
+/*
+ * This file contains some processor specific definitions of the TI OMAP34XX.
+ * Values are copied from mach-omap2 headers.
+ *
+ * Copyright (C) 2007 Texas Instruments.
+ * Copyright (C) 2007 Nokia Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __ASM_ARCH_OMAP34XX_H
+#define __ASM_ARCH_OMAP34XX_H
+
+#define L4_34XX_BASE		0x48000000
+#define L4_PER_34XX_BASE	0x49000000
+#define OMAP343X_SCM_BASE	0x48002000
+#define OMAP343X_CTRL_BASE	OMAP343X_SCM_BASE
+#define OMAP34XX_WDT3_BASE	(L4_PER_34XX_BASE + 0x30000)
+
+#endif /* __ASM_ARCH_OMAP34XX_H */
-- 
1.6.0.4


>From c95ae01f19010e547edf0a5c05484e5c479ca235 Mon Sep 17 00:00:00 2001
From: sli <sli@SLI-V420.(none)>
Date: Mon, 24 Sep 2012 20:13:52 +0200
Subject: [PATCH 2/2] style correction : delete whitespace


Signed-off-by: sli <sli@SLI-V420.(none)>
---
 .../tidspbridge/include/dspbridge/omap34xx.h       |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/omap34xx.h b/drivers/staging/tidspbridge/include/dspbridge/omap34xx.h
index 66a6fc8..053b61e 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/omap34xx.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/omap34xx.h
@@ -27,7 +27,7 @@
 #define L4_PER_34XX_BASE	0x49000000
 #define OMAP343X_SCM_BASE	0x48002000
 #define OMAP343X_CTRL_BASE	OMAP343X_SCM_BASE
-#define OMAP34XX_WDT3_BASE 	(L4_PER_34XX_BASE + 0x30000)
+#define OMAP34XX_WDT3_BASE	(L4_PER_34XX_BASE + 0x30000)
 
 #endif /* __ASM_ARCH_OMAP34XX_H */
 
-- 
1.6.0.4


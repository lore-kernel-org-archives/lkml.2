Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0IMDwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:52:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35778 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab0IMDv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:51:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=V0FLmoiQ1hzqkSqQQTm2X0hWIUOCyhmJvSUwQ4chsTZY7KLmqUV0fm6zLNplzh+Rpl
         HV8Fv/YRtzNNKsMs7yOvKoChhQA77tnEXalghugPbFewylxqIwG7NO5DIU+1YxUv4W89
         AJz6cvQlvQ2H6s3mRY6N05iACfbzDMs0/p7bc=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: eric.y.miao@gmail.com, marek.vasut@gmail.com, haojian.zhuang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        markb@marvell.com
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v2 1/3] ARM: pxa168: added support for Teton BGA platform
Date: Sun, 12 Sep 2010 23:51:34 -0400
Message-Id: <1284349896-14545-2-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284349896-14545-1-git-send-email-mark.brown314@gmail.com>
References: <1284349896-14545-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added board defintion, header, and debug UART support.

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 MAINTAINERS                                |    5 +++
 arch/arm/mach-mmp/Kconfig                  |    7 ++++
 arch/arm/mach-mmp/Makefile                 |    1 +
 arch/arm/mach-mmp/include/mach/teton_bga.h |   27 +++++++++++++++
 arch/arm/mach-mmp/teton_bga.c              |   50 ++++++++++++++++++++++++++++
 5 files changed, 90 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-mmp/include/mach/teton_bga.h
 create mode 100644 arch/arm/mach-mmp/teton_bga.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 433f353..d7a4481 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -967,6 +967,11 @@ M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
+ARM/TETON BGA MACHINE SUPPORT
+M:	Mark F. Brown <mark.brown314@gmail.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+
 ARM/THECUS N2100 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
index 6ab843e..0711d3b 100644
--- a/arch/arm/mach-mmp/Kconfig
+++ b/arch/arm/mach-mmp/Kconfig
@@ -57,6 +57,13 @@ config MACH_MARVELL_JASPER
 	  PXA910-based development board. Since MMP2 is compatible to
 	  ARMv6 architecture.
 
+config MACH_TETON_BGA
+	bool "Marvell's PXA168 Teton BGA Development Board"
+	select CPU_PXA168
+	help
+	  Say 'Y' here if you want to support the Marvell PXA168-based
+	  Teton BGA Development Board.
+
 endmenu
 
 config CPU_PXA168
diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
index 8b66d06..751cdbf 100644
--- a/arch/arm/mach-mmp/Makefile
+++ b/arch/arm/mach-mmp/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_MACH_TAVOREVB)	+= tavorevb.o
 obj-$(CONFIG_MACH_TTC_DKB)	+= ttc_dkb.o
 obj-$(CONFIG_MACH_FLINT)	+= flint.o
 obj-$(CONFIG_MACH_MARVELL_JASPER) += jasper.o
+obj-$(CONFIG_MACH_TETON_BGA)	+= teton_bga.o
diff --git a/arch/arm/mach-mmp/include/mach/teton_bga.h b/arch/arm/mach-mmp/include/mach/teton_bga.h
new file mode 100644
index 0000000..61a539b
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/teton_bga.h
@@ -0,0 +1,27 @@
+/*
+ *  linux/arch/arm/mach-mmp/include/mach/teton_bga.h
+ *
+ *  Support for the Marvell PXA168 Teton BGA Development Platform.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+#ifndef __ASM_MACH_TETON_BGA_H
+#define __ASM_MACH_TETON_BGA_H
+
+/* GPIOs */
+#define MMC_PWENA_GPIO		27
+#define USBHPENB_GPIO		55
+#define RTC_INT_GPIO		78
+#define LCD_VBLK_EN_GPIO	79
+#define LCD_DVDD_EN_GPIO	80
+#define RST_WIFI_GPIO		81
+#define CF_PWEN_GPIO		82
+#define USB_OC_GPIO		83
+#define PWM_GPIO		84
+#define USBHPENA_GPIO		85
+#define TS_INT_GPIO		86
+#define CIR_GPIO		108
+
+#endif /* __ASM_MACH_TETON_BGA_H */
diff --git a/arch/arm/mach-mmp/teton_bga.c b/arch/arm/mach-mmp/teton_bga.c
new file mode 100644
index 0000000..49b746b
--- /dev/null
+++ b/arch/arm/mach-mmp/teton_bga.c
@@ -0,0 +1,50 @@
+/*
+ *  linux/arch/arm/mach-mmp/teton_bga.c
+ *
+ *  Support for the Marvell PXA168 Teton BGA Development Platform.
+ *
+ *  Author: Mark F. Brown <mark.brown314@gmail.com>
+ *
+ *  This code is based on aspenite.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <mach/addr-map.h>
+#include <mach/mfp-pxa168.h>
+#include <mach/pxa168.h>
+#include <mach/teton_bga.h>
+
+#include "common.h"
+
+static unsigned long teton_bga_pin_config[] __initdata = {
+	/* UART1 */
+	GPIO107_UART1_TXD,
+	GPIO108_UART1_RXD,
+};
+
+static void __init teton_bga_init(void)
+{
+	mfp_config(ARRAY_AND_SIZE(teton_bga_pin_config));
+
+	/* on-chip devices */
+	pxa168_add_uart(1);
+}
+
+MACHINE_START(TETON_BGA, "PXA168-based Teton BGA Development Platform")
+	.phys_io        = APB_PHYS_BASE,
+	.io_pg_offst    = (APB_VIRT_BASE >> 18) & 0xfffc,
+	.map_io		= mmp_map_io,
+	.init_irq       = pxa168_init_irq,
+	.timer          = &pxa168_timer,
+	.init_machine   = teton_bga_init,
+MACHINE_END
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab2GRMHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:07:23 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:35813 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754170Ab2GRMHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:07:17 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/4] ARM: LPC32xx: Set system serial based on cpu unique id
Date: Wed, 18 Jul 2012 14:06:48 +0200
Message-Id: <1342613211-13190-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342613211-13190-1-git-send-email-stigge@antcom.de>
References: <1342613211-13190-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

LPC32xx SoC has a 128 bits unique id that can be used as a system
serial number, if none has been provided by atags or dt.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-lpc32xx/common.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/common.c
+++ linux-2.6/arch/arm/mach-lpc32xx/common.c
@@ -26,6 +26,7 @@
 #include <linux/io.h>
 
 #include <asm/mach/map.h>
+#include <asm/system_info.h>
 
 #include <mach/hardware.h>
 #include <mach/platform.h>
@@ -224,7 +225,7 @@ void lpc23xx_restart(char mode, const ch
 		;
 }
 
-static int __init lpc32xx_display_uid(void)
+static int __init lpc32xx_check_uid(void)
 {
 	u32 uid[4];
 
@@ -233,6 +234,11 @@ static int __init lpc32xx_display_uid(vo
 	printk(KERN_INFO "LPC32XX unique ID: %08x%08x%08x%08x\n",
 		uid[3], uid[2], uid[1], uid[0]);
 
+	if (!system_serial_low && !system_serial_high) {
+		system_serial_low = uid[0];
+		system_serial_high = uid[1];
+	}
+
 	return 1;
 }
-arch_initcall(lpc32xx_display_uid);
+arch_initcall(lpc32xx_check_uid);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2DRNjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:39:35 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:50628 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753551Ab2DRNh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:37:28 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, dan.carpenter@oracle.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v3 10/10] ARM: LPC32xx: Move common code to common.c
Date: Wed, 18 Apr 2012 15:36:15 +0200
Message-Id: <1334756176-25144-11-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334756176-25144-1-git-send-email-stigge@antcom.de>
References: <1334756176-25144-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves non-boardspecific LPC32xx code to common.c

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 arch/arm/mach-lpc32xx/common.c  |   14 ++++++++++++++
 arch/arm/mach-lpc32xx/phy3250.c |   13 -------------
 2 files changed, 14 insertions(+), 13 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/common.c
+++ linux-2.6/arch/arm/mach-lpc32xx/common.c
@@ -223,3 +223,17 @@ void lpc23xx_restart(char mode, const ch
 	while (1)
 		;
 }
+
+static int __init lpc32xx_display_uid(void)
+{
+	u32 uid[4];
+
+	lpc32xx_get_uid(uid);
+
+	printk(KERN_INFO "LPC32XX unique ID: %08x%08x%08x%08x\n",
+		uid[3], uid[2], uid[1], uid[0]);
+
+	return 1;
+}
+arch_initcall(lpc32xx_display_uid);
+
--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -322,19 +322,6 @@ static void __init lpc3250_machine_init(
 			SPI0_CS_GPIO);
 }
 
-static int __init lpc32xx_display_uid(void)
-{
-	u32 uid[4];
-
-	lpc32xx_get_uid(uid);
-
-	printk(KERN_INFO "LPC32XX unique ID: %08x%08x%08x%08x\n",
-		uid[3], uid[2], uid[1], uid[0]);
-
-	return 1;
-}
-arch_initcall(lpc32xx_display_uid);
-
 static char const *lpc32xx_dt_compat[] __initdata = {
 	"nxp,lpc32xx",
 	NULL

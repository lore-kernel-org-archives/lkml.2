Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1JBOtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:49:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60561 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1JBOrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/30] ARM: omap2+: fix omap_hdq_init compilation
Date: Sun,  2 Oct 2011 16:45:43 +0200
Message-Id: <1317566760-25681-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Sn4k9sXSe7SEJq5kaPhBFkzW2xK6bX/yVamTRsQfhzo
 8jntlU4GrjqkHzE8Fu8zm+lP/LKd8soLHwzx97IiUdjVoVZeoq
 rXTaczu3Yvr2zQeo4fHM/P1tGc50Vkp92WdHdZv+sXGPxQl0wk
 siiAnVFpKAX876rEUMGg1EWJs6pQ5KylQgYcJnIWyyUeyj5wBk
 Hn7JMyKxImefigDNORh6arThvDaYQaH08fBhdMiYFk8SP/C/R2
 xBJ7M1JrTEncgfG8nSVKar/Os53AufYber/QfmUW6CgJgxEGFH
 oFQfSrzx7QLys6MmgldwxlFQAF7POgo74fiJ6t0awHHdnBfZ+M
 LHOdxjZgJGwP8qYC0G4oehh8MZEBvf1dDIz1RsD4uKlzQMOhah
 fh2W4l59JBiIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of the device must depend on the hardware
we run on, not on the kernel configuration.

arch/arm/mach-omap2/devices.c:624:13: error: 'OMAP_HDQ_BASE' undeclared here (not in a function)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/devices.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 1077ad6..392f2b0 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -29,6 +29,7 @@
 #include <mach/gpio.h>
 #include <plat/mmc.h>
 #include <plat/dma.h>
+#include <plat/cpu.h>
 #include <plat/omap_hwmod.h>
 #include <plat/omap_device.h>
 #include <plat/omap4-keypad.h>
@@ -615,10 +616,8 @@ void __init omap242x_init_mmc(struct omap_mmc_platform_data **mmc_data)
 
 /*-------------------------------------------------------------------------*/
 
-#if defined(CONFIG_HDQ_MASTER_OMAP) || defined(CONFIG_HDQ_MASTER_OMAP_MODULE)
 #if defined(CONFIG_SOC_OMAP2430) || defined(CONFIG_SOC_OMAP3430)
 #define OMAP_HDQ_BASE	0x480B2000
-#endif
 static struct resource omap_hdq_resources[] = {
 	{
 		.start		= OMAP_HDQ_BASE,
@@ -641,10 +640,13 @@ static struct platform_device omap_hdq_dev = {
 };
 static inline void omap_hdq_init(void)
 {
-	(void) platform_device_register(&omap_hdq_dev);
+	if (cpu_is_omap2430() || cpu_is_omap3430())
+		(void) platform_device_register(&omap_hdq_dev);
 }
 #else
-static inline void omap_hdq_init(void) {}
+static inline void omap_hdq_init(void)
+{
+}
 #endif
 
 /*---------------------------------------------------------------------------*/
-- 
1.7.5.4


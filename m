Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab0L0SBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 13:01:10 -0500
Received: from mail.colab.de ([195.226.127.114]:39550 "EHLO mail.colab.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab0L0SBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 13:01:09 -0500
X-Greylist: delayed 678 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Dec 2010 13:01:08 EST
X-Spam-Flag: NO
X-Spam-Score: -2.676
From: Jochen Friedrich <jochen@scram.de>
To: linux-arm-kernel@lists.infradead.org, kristoffer.ericson@gmail.com
Cc: linux-kernel@vger.kernel.org, jochen@scram.de
Subject: [PATCH 2.6.37 RESEND] sa1100: Fix platform device registration
Date: Mon, 27 Dec 2010 18:49:30 +0100
Message-Id: <1293472170-14130-1-git-send-email-jochen@scram.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 7a5b4e16c880f8350d255dc188f81622905618c1, simpad devices don't
boot anymore, since platform devices are registered too early. Fix by moving
the registration from map_io to arch_initcall as done on other sa1100 boards.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
---
 arch/arm/mach-sa1100/simpad.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-sa1100/simpad.c b/arch/arm/mach-sa1100/simpad.c
index 27692d0..cfb7607 100644
--- a/arch/arm/mach-sa1100/simpad.c
+++ b/arch/arm/mach-sa1100/simpad.c
@@ -166,9 +166,6 @@ static void __init simpad_map_io(void)
 	PCFR = 0;
 	PSDR = 0;
 
-	sa11x0_register_mtd(&simpad_flash_data, simpad_flash_resources,
-			      ARRAY_SIZE(simpad_flash_resources));
-	sa11x0_register_mcp(&simpad_mcp_data);
 }
 
 static void simpad_power_off(void)
@@ -216,6 +213,10 @@ static int __init simpad_init(void)
 
 	pm_power_off = simpad_power_off;
 
+	sa11x0_register_mtd(&simpad_flash_data, simpad_flash_resources,
+			      ARRAY_SIZE(simpad_flash_resources));
+	sa11x0_register_mcp(&simpad_mcp_data);
+
 	ret = platform_add_devices(devices, ARRAY_SIZE(devices));
 	if(ret)
 		printk(KERN_WARNING "simpad: Unable to register mq200 framebuffer device");
-- 
1.7.2.3


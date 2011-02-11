Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab1BKOGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:06:25 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43257 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab1BKOGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:06:23 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Kevin Hilman <khilman@deeprootsystems.com> (supporter:TI DAVINCI
	MACHIN...,commit_signer:16/18=89%),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        Michael Williamson <michael.williamson@criticallink.com> (commit_signer:5/18=28%),
        Cyril Chemparathy <cyril@ti.com> (commit_signer:3/18=17%),
        Sergei Shtylyov <sshtylyov@ru.mvista.com> (commit_signer:3/18=17%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] davinci: changed SRAM allocator to shared ram.
Date: Fri, 11 Feb 2011 19:51:28 +0530
Message-Id: <1297434088-27995-1-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the sram allocator to allocate memory
from the DA8XX shared RAM.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 arch/arm/mach-davinci/da850.c              |    6 +++---
 arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 3443d97..8a4de97 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -711,7 +711,7 @@ static struct map_desc da850_io_desc[] = {
 	},
 	{
 		.virtual	= SRAM_VIRT,
-		.pfn		= __phys_to_pfn(DA8XX_ARM_RAM_BASE),
+		.pfn		= __phys_to_pfn(DA8XX_SHARED_RAM_BASE),
 		.length		= SZ_8K,
 		.type		= MT_DEVICE
 	},
@@ -1083,8 +1083,8 @@ static struct davinci_soc_info davinci_soc_info_da850 = {
 	.gpio_irq		= IRQ_DA8XX_GPIO0,
 	.serial_dev		= &da8xx_serial_device,
 	.emac_pdata		= &da8xx_emac_pdata,
-	.sram_dma		= DA8XX_ARM_RAM_BASE,
-	.sram_len		= SZ_8K,
+	.sram_dma		= DA8XX_SHARED_RAM_BASE,
+	.sram_len		= SZ_128K,
 	.reset_device		= &da8xx_wdt_device,
 };
 
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index cfcb223..c3c3339 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -70,6 +70,7 @@ extern unsigned int da850_max_speed;
 #define DA8XX_AEMIF_CTL_BASE	0x68000000
 #define DA8XX_DDR2_CTL_BASE	0xb0000000
 #define DA8XX_ARM_RAM_BASE	0xffff0000
+#define DA8XX_SHARED_RAM_BASE	0x80000000
 
 void __init da830_init(void);
 void __init da850_init(void);
-- 
1.7.2.3


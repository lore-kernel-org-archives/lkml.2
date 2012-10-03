Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2JCOzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:55:21 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47417 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab2JCOzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:55:14 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>
Subject: [PATCH v3 3/6] ARM: davinci: da850: changed SRAM allocator to shared ram.
Date: Wed,  3 Oct 2012 10:55:30 -0400
Message-Id: <1349276133-26408-4-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276133-26408-1-git-send-email-mporter@ti.com>
References: <1349276133-26408-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subhasish Ghosh <subhasish@mistralsolutions.com>

This patch modifies the sram allocator to allocate memory
from the DA8XX shared RAM.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
[rebased onto consolidated SRAM patches]
Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
[rebased to mainline as consolidated SRAM patches were dropped]
Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-davinci/da850.c              |    4 ++--
 arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index b4b324f..d8d69de 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -1081,8 +1081,8 @@ static struct davinci_soc_info davinci_soc_info_da850 = {
 	.gpio_irq		= IRQ_DA8XX_GPIO0,
 	.serial_dev		= &da8xx_serial_device,
 	.emac_pdata		= &da8xx_emac_pdata,
-	.sram_dma		= DA8XX_ARM_RAM_BASE,
-	.sram_len		= SZ_8K,
+	.sram_dma		= DA8XX_SHARED_RAM_BASE,
+	.sram_len		= SZ_128K,
 };
 
 void __init da850_init(void)
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index c9ee723..20553cf 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -68,6 +68,7 @@ extern unsigned int da850_max_speed;
 #define DA8XX_AEMIF_CS2_BASE	0x60000000
 #define DA8XX_AEMIF_CS3_BASE	0x62000000
 #define DA8XX_AEMIF_CTL_BASE	0x68000000
+#define DA8XX_SHARED_RAM_BASE	0x80000000
 #define DA8XX_ARM_RAM_BASE	0xffff0000
 
 void __init da830_init(void);
-- 
1.7.9.5


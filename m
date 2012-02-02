Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab2BBRbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50444 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932715Ab2BBRb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:26 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Charulatha V <charu@ti.com>
Subject: [PATCH v9 15/25] gpio/omap: fix bankwidth for OMAP7xx MPUIO
Date: Thu, 2 Feb 2012 23:00:41 +0530
Message-ID: <1328203851-20435-16-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charulatha V <charu@ti.com>

In all OMAP1 SoCs, the MPUIO bank width is 16 bits. But, in OMAP7xx,
it is wrongly initialised to 32. Fix this.

Signed-off-by: Charulatha V <charu@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/gpio7xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap1/gpio7xx.c b/arch/arm/mach-omap1/gpio7xx.c
index 433491c..4771d6b 100644
--- a/arch/arm/mach-omap1/gpio7xx.c
+++ b/arch/arm/mach-omap1/gpio7xx.c
@@ -52,8 +52,8 @@ static struct omap_gpio_reg_offs omap7xx_mpuio_regs = {
 
 static struct __initdata omap_gpio_platform_data omap7xx_mpu_gpio_config = {
 	.virtual_irq_start	= IH_MPUIO_BASE,
-	.bank_width		= 32,
 	.is_mpuio		= true,
+	.bank_width		= 16,
 	.bank_stride		= 2,
 	.regs                   = &omap7xx_mpuio_regs,
 };
-- 
1.7.0.4


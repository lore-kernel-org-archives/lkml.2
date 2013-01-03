Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3ACWkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:40:04 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:48789 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385Ab3ACWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:38:32 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH] omap: am33xx-hwmod: Fix wrongly terminated am33xx_usbss_mpu_irqs array
Date: Fri,  4 Jan 2013 00:32:22 +0200
Message-Id: <1357252342-6166-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQ array must be terminated by -1 and not by -1+OMAP_INTC_START
This led to having a resource list of 100s of IRQs.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
index 081c71e..e402303 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
@@ -2070,7 +2070,7 @@ static struct omap_hwmod_irq_info am33xx_usbss_mpu_irqs[] = {
 	{ .name = "usbss-irq", .irq = 17 + OMAP_INTC_START, },
 	{ .name = "musb0-irq", .irq = 18 + OMAP_INTC_START, },
 	{ .name = "musb1-irq", .irq = 19 + OMAP_INTC_START, },
-	{ .irq = -1 + OMAP_INTC_START, },
+	{ .irq = -1, },
 };
 
 static struct omap_hwmod am33xx_usbss_hwmod = {
-- 
1.7.12


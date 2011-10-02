Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1JBOrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:47:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1JBOqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 04/30] ARM: omap: add missing __devexit_p() annotations
Date: Sun,  2 Oct 2011 16:45:34 +0200
Message-Id: <1317566760-25681-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:I5uitiqpWJlYnGGk7qd6SOHnL/r+P3qi6bUoYaxJSZS
 gF1sShkLTpqsZHcT2qXWmpwiXx2FhdZcajpj6VkGX2meI7d+/v
 NL6k/YxIgUOBDlFM0kUIlwrKY6xqw8D48gLz9IkraJqQqNpSDK
 P4q5O7Rtd49pjm+nl9ibjITXPXe7ypMlehvaGFIiHUZE4jQkhg
 cT8FrDSYHUcvDiLXULxZ2FX2mjVfpOtiR9jUoYzaRLJQSEFuT4
 c21bEfimRGNzzHJpgnl/eyr101A9z0pEH0yZ5Uy10VMsTru45m
 V3OHTj1e1On/PHtK6QYIyxgE2YuQ0sAJBDZKUdsKJpwBfu1gca
 Lo0sxUGI/wPkvh0NQOIUmceGPnAY6zkU/PvdL5OY9rB+F58wB+
 5ZIeZRaXFTHJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers that refer to a __devexit function in an operations
structure need to annotate that pointer with __devexit_p so
replace it with a NULL pointer when the section gets discarded.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/smartreflex.c |    2 +-
 arch/arm/plat-omap/dma.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 34c01a7..67bc6ce 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -1002,7 +1002,7 @@ static int __devexit omap_sr_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver smartreflex_driver = {
-	.remove         = omap_sr_remove,
+	.remove         = __devexit_p(omap_sr_remove),
 	.driver		= {
 		.name	= "smartreflex",
 	},
diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index c22217c..f7150ba 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -2105,7 +2105,7 @@ static int __devexit omap_system_dma_remove(struct platform_device *pdev)
 
 static struct platform_driver omap_system_dma_driver = {
 	.probe		= omap_system_dma_probe,
-	.remove		= omap_system_dma_remove,
+	.remove		= __devexit_p(omap_system_dma_remove),
 	.driver		= {
 		.name	= "omap_dma_system"
 	},
-- 
1.7.5.4


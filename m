Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044Ab2INVjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:39:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64421 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214Ab2INVfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 23/24] video: da8xx-fb: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:51 +0200
Message-Id: <1347658492-11608-24-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:mckx0+7tqHmfiCd9VnFssDdR8zITPjtm/JfzsPZrgQk
 j+hHcjZ+DJ4BqPSKVSSmhugcwYc6p7eAqwHleaahn2gKPjuAqC
 xe1HwTREPkx43/mbjc24wyDI7PExK//vZvCTwXgpWnJM6wAAay
 p7L8dN3QEpNyzhgIotyHzf3pOyu+MHUDEiCge4UKMKjqqTz7qf
 tuQ6oFBXfrs1ubmoN+xCLI/SWfl7u8cIMZNcrQm5YWwhXFI5wV
 rfNHlwzpk9fJzZqPY0kWAK057NldAgVSH92mB8eMl1obPNNimv
 przUzVCVin7Ux8YA0PHxdI2YeR+9kAb6c7e3tSn5Q7fh9k4nqu
 RNu3LXt0GZU7AEQUckNEzYHO2b+CZdttuMQpGBrOfurVG2zxAQ
 RiQ2dcm/7MqUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/video/da8xx-fb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 7ae9d53..113d43a 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -131,7 +131,7 @@
 #define UPPER_MARGIN	32
 #define LOWER_MARGIN	32
 
-static resource_size_t da8xx_fb_reg_base;
+static void __iomem *da8xx_fb_reg_base;
 static struct resource *lcdc_regs;
 static unsigned int lcd_revision;
 static irq_handler_t lcdc_irq_handler;
@@ -951,7 +951,7 @@ static int __devexit fb_remove(struct platform_device *dev)
 		clk_disable(par->lcdc_clk);
 		clk_put(par->lcdc_clk);
 		framebuffer_release(info);
-		iounmap((void __iomem *)da8xx_fb_reg_base);
+		iounmap(da8xx_fb_reg_base);
 		release_mem_region(lcdc_regs->start, resource_size(lcdc_regs));
 
 	}
@@ -1171,7 +1171,7 @@ static int __devinit fb_probe(struct platform_device *device)
 	if (!lcdc_regs)
 		return -EBUSY;
 
-	da8xx_fb_reg_base = (resource_size_t)ioremap(lcdc_regs->start, len);
+	da8xx_fb_reg_base = ioremap(lcdc_regs->start, len);
 	if (!da8xx_fb_reg_base) {
 		ret = -EBUSY;
 		goto err_request_mem;
@@ -1392,7 +1392,7 @@ err_clk_put:
 	clk_put(fb_clk);
 
 err_ioremap:
-	iounmap((void __iomem *)da8xx_fb_reg_base);
+	iounmap(da8xx_fb_reg_base);
 
 err_request_mem:
 	release_mem_region(lcdc_regs->start, len);
-- 
1.7.10


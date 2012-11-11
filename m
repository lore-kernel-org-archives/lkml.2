Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2KKMye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:54:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56079 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab2KKMun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:43 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] SPI: spi-bcm63xx: use clk_{prepare_enable,disable_unprepare}
Date: Sun, 11 Nov 2012 13:50:39 +0100
Message-Id: <1352638249-29298-6-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proper clk_prepare/unprepare calls in preparation for switching
to the generic clock framework.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/spi/spi-bcm63xx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index a9f4049..69cb96a 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -431,7 +431,7 @@ static int __devinit bcm63xx_spi_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize hardware */
-	clk_enable(bs->clk);
+	clk_prepare_enable(bs->clk);
 	bcm_spi_writeb(bs, SPI_INTR_CLEAR_ALL, SPI_INT_STATUS);
 
 	/* register and we are done */
@@ -447,7 +447,7 @@ static int __devinit bcm63xx_spi_probe(struct platform_device *pdev)
 	return 0;
 
 out_clk_disable:
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 out_err:
 	platform_set_drvdata(pdev, NULL);
 	spi_master_put(master);
@@ -468,7 +468,7 @@ static int __devexit bcm63xx_spi_remove(struct platform_device *pdev)
 	bcm_spi_writeb(bs, 0, SPI_INT_MASK);
 
 	/* HW shutdown */
-	clk_disable(bs->clk);
+	clk_disable_unprepare(bs->clk);
 	clk_put(bs->clk);
 
 	platform_set_drvdata(pdev, 0);
-- 
1.7.2.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2KKMx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:53:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45333 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2KKMuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:44 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] bcm63xx-rng: use clk_{prepare_enable,disable_unprepare}
Date: Sun, 11 Nov 2012 13:50:40 +0100
Message-Id: <1352638249-29298-7-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proper clk_prepare/unprepare calls in preparation for switching to
the generic clock framework.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/char/hw_random/bcm63xx-rng.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_random/bcm63xx-rng.c
index aec6a42..3693f56 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -122,7 +122,7 @@ static int __devinit bcm63xx_rng_probe(struct platform_device *pdev)
 		goto out_free_rng;
 	}
 
-	clk_enable(clk);
+	clk_prepare_enable(clk);
 
 	ret = hwrng_register(rng);
 	if (ret) {
@@ -135,7 +135,7 @@ static int __devinit bcm63xx_rng_probe(struct platform_device *pdev)
 	return 0;
 
 out_clk_disable:
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 out_free_rng:
 	platform_set_drvdata(pdev, NULL);
 	kfree(rng);
@@ -151,7 +151,7 @@ static int __devexit bcm63xx_rng_remove(struct platform_device *pdev)
 	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
 
 	hwrng_unregister(rng);
-	clk_disable(priv->clk);
+	clk_disable_unprepare(priv->clk);
 	kfree(priv);
 	kfree(rng);
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.2.5


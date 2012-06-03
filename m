Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2FCTai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 15:30:38 -0400
Received: from gloria.sntech.de ([95.129.55.99]:47029 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab2FCTah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 15:30:37 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regulator: gpio-regulator: do not pass drvdata pointer as reference
Date: Sun, 3 Jun 2012 21:30:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: Liam Girdwood <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>
References: <201206032129.45414.heiko@sntech.de>
In-Reply-To: <201206032129.45414.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206032130.34509.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c172708d38a4 (regulator: core: Use a struct to pass in
regulator runtime configuration) added the drvdata pointer
only per reference to the new config array in the gpio-regulator.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/regulator/gpio-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 9997d7a..ebe2b5c 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -286,7 +286,7 @@ static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 
 	cfg.dev = &pdev->dev;
 	cfg.init_data = config->init_data;
-	cfg.driver_data = &drvdata;
+	cfg.driver_data = drvdata;
 
 	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
 	if (IS_ERR(drvdata->dev)) {
-- 
1.7.2.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2AaKij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:38:39 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:55055 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2AaKih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:38:37 -0500
From: Barry Song <Barry.Song@csr.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <workgroup.linux@csr.com>, <linux-mtd@lists.infradead.org>,
        Barry Song <Baohua.Song@csr.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erik Gilling <konkers@google.com>
Subject: [PATCH 2/3] GPIO: TEGRA: move to use platform_devm_request_and_ioremap() helper
Date: Tue, 31 Jan 2012 18:00:01 +0800
Message-ID: <1328004002-24646-3-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <Baohua.Song@csr.com>

Signed-off-by: Barry Song <Baohua.Song@csr.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Erik Gilling <konkers@google.com>
---
 drivers/gpio/gpio-tegra.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index bdc2937..118e367 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -355,13 +355,7 @@ static int __devinit tegra_gpio_probe(struct platform_device *pdev)
 		bank->irq = res->start;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Missing MEM resource\n");
-		return -ENODEV;
-	}
-
-	regs = devm_request_and_ioremap(&pdev->dev, res);
+	regs = platform_devm_request_and_ioremap(pdev, 0);
 	if (!regs) {
 		dev_err(&pdev->dev, "Couldn't ioremap regs\n");
 		return -ENODEV;
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog

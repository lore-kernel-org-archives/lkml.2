Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab2KLGqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 01:46:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48122 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2KLGqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 01:46:53 -0500
Message-ID: <1352702808.15066.5.camel@phoenix>
Subject: [PATCH 2/2] pinctrl: pxa3xx: Remove phy_base and phy_size from
 struct pxa3xx_pinmux_info
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 12 Nov 2012 14:46:48 +0800
In-Reply-To: <1352702750.15066.4.camel@phoenix>
References: <1352702750.15066.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are not used, remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-pxa3xx.c |    2 --
 drivers/pinctrl/pinctrl-pxa3xx.h |    2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-pxa3xx.c b/drivers/pinctrl/pinctrl-pxa3xx.c
index 43e3dd0..51f8a38 100644
--- a/drivers/pinctrl/pinctrl-pxa3xx.c
+++ b/drivers/pinctrl/pinctrl-pxa3xx.c
@@ -187,8 +187,6 @@ int pxa3xx_pinctrl_register(struct platform_device *pdev,
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENOENT;
-	info->phy_base = res->start;
-	info->phy_size = resource_size(res);
 	info->virt_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!info->virt_base)
 		return -ENOMEM;
diff --git a/drivers/pinctrl/pinctrl-pxa3xx.h b/drivers/pinctrl/pinctrl-pxa3xx.h
index 8135744..92fad08 100644
--- a/drivers/pinctrl/pinctrl-pxa3xx.h
+++ b/drivers/pinctrl/pinctrl-pxa3xx.h
@@ -60,8 +60,6 @@ struct pxa3xx_pinmux_info {
 	struct device *dev;
 	struct pinctrl_dev *pctrl;
 	enum pxa_cpu_type cputype;
-	unsigned int phy_base;
-	unsigned int phy_size;
 	void __iomem *virt_base;
 
 	struct pxa3xx_mfp_pin *mfp;
-- 
1.7.9.5




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab1CEKtE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:49:04 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:37588 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513Ab1CEKs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:48:59 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/5] mfd: free dangling irq in ab8500 gpadc probe error path
Date: Sat, 5 Mar 2011 11:46:27 +0100
Message-ID: <1299321987-6832-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Willerud <daniel.willerud@stericsson.com>

Signed-off-by: Daniel Willerud <daniel.willerud@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 178cbc5..b5b75b7 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -267,11 +267,13 @@ static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
 	if (IS_ERR(gpadc->regu)) {
 		ret = PTR_ERR(gpadc->regu);
 		dev_err(gpadc->dev, "failed to get vtvout LDO\n");
-		goto fail;
+		goto fail_irq;
 	}
 	list_add_tail(&gpadc->node, &ab8500_gpadc_list);
 	dev_dbg(gpadc->dev, "probe success\n");
 	return 0;
+fail_irq:
+	free_irq(gpadc->irq, gpadc);
 fail:
 	kfree(gpadc);
 	gpadc = NULL;
-- 
1.7.3.2


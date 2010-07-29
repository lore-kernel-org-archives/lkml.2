Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0G2IZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:25:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52920 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab0G2IZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FErUdcMP5cFYsT3R+Y7d1SSOWY8zfNCRMQlMNqskZT6IM4ldQz5Jy6TRaogPDycv3H
         HOZg4tCxvRpAc6qD8TVDUhIRt9+Vch85rvdvXk0XQ24mvFHrbp4JPtFUYWSEWzCZvpqC
         riL2nBqMy2l1nTfU9zYcGBOkcowKjQ84RleMw=
Subject: [PATCH 1/2] jz4740-adc/jz4740-hwmon: check kmalloc() result
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain
Date: Thu, 29 Jul 2010 16:25:53 +0800
Message-Id: <1280391953.21676.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kmalloc() fails, exit with -ENOMEM.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next.
 drivers/hwmon/jz4740-hwmon.c |    4 ++++
 drivers/mfd/jz4740-adc.c     |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
index 72a4335..1c8b3d9 100644
--- a/drivers/hwmon/jz4740-hwmon.c
+++ b/drivers/hwmon/jz4740-hwmon.c
@@ -107,6 +107,10 @@ static int __devinit jz4740_hwmon_probe(struct platform_device *pdev)
 	struct jz4740_hwmon *hwmon;
 
 	hwmon = kmalloc(sizeof(*hwmon), GFP_KERNEL);
+	if (!hwmon) {
+		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
+		return -ENOMEM;
+	}
 
 	hwmon->cell = pdev->dev.platform_data;
 
diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 7a844ae..2846d24 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -260,6 +260,10 @@ static int __devinit jz4740_adc_probe(struct platform_device *pdev)
 	int irq;
 
 	adc = kmalloc(sizeof(*adc), GFP_KERNEL);
+	if (!adc) {
+		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
+		return -ENOMEM;
+	}
 
 	adc->irq = platform_get_irq(pdev, 0);
 	if (adc->irq < 0) {
-- 
1.5.4.3




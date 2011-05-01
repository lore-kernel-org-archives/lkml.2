Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab1EAPfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:35:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51740 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab1EAPfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:35:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Sq5dZZF0X3k4vBMRdUrBnv77WpDNEzxT/hfaukZETLTU8k5rr38wCxjXPDNgvdkfbz
         wUTHamkAJo4kgZFeX9hIZCafWGlH7Y3gPk3aqjJxzGazVDmMF9/qx0IQSy73hPM35zRw
         y+CPGyzmejarU1CZSqqkLALRb0e31EOyMwPZc=
Subject: [PATCH] hwmon: twl4030-madc-hwmon: Return proper error if
 hwmon_device_register fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: J Keerthy <j-keerthy@ti.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 May 2011 23:34:55 +0800
Message-ID: <1304264095.2327.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/twl4030-madc-hwmon.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/twl4030-madc-hwmon.c b/drivers/hwmon/twl4030-madc-hwmon.c
index de58191..5724074 100644
--- a/drivers/hwmon/twl4030-madc-hwmon.c
+++ b/drivers/hwmon/twl4030-madc-hwmon.c
@@ -98,7 +98,6 @@ static const struct attribute_group twl4030_madc_group = {
 static int __devinit twl4030_madc_hwmon_probe(struct platform_device *pdev)
 {
 	int ret;
-	int status;
 	struct device *hwmon;
 
 	ret = sysfs_create_group(&pdev->dev.kobj, &twl4030_madc_group);
@@ -107,7 +106,7 @@ static int __devinit twl4030_madc_hwmon_probe(struct platform_device *pdev)
 	hwmon = hwmon_device_register(&pdev->dev);
 	if (IS_ERR(hwmon)) {
 		dev_err(&pdev->dev, "hwmon_device_register failed.\n");
-		status = PTR_ERR(hwmon);
+		ret = PTR_ERR(hwmon);
 		goto err_reg;
 	}
 
-- 
1.7.1




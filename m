Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0ELApw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:45:52 -0400
Received: from blue-ld-261.synserver.de ([217.119.54.83]:46197 "EHLO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754081Ab0ELApP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:45:15 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 1517
From: Lars-Peter Clausen <lars@metafoo.de>
To: rpurdie@rpsys.net
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/3] MFD: pcf50633: Register a pcf50633-backlight device in pcf50633 core driver.
Date: Wed, 12 May 2010 02:44:33 +0200
Message-Id: <1273625074-15312-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273625074-15312-1-git-send-email-lars@metafoo.de>
References: <1273625074-15312-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register a device newly added pcf50633-backlight driver as a child device in
the pcf50633 core driver.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/pcf50633-core.c       |    3 +++
 include/linux/mfd/pcf50633/core.h |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index e1ee046..704736e 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -305,6 +305,9 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 						&pcf->mbc_pdev);
 	pcf50633_client_dev_register(pcf, "pcf50633-adc",
 						&pcf->adc_pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-backlight",
+						&pcf->bl_pdev);
+
 
 	for (i = 0; i < PCF50633_NUM_REGULATORS; i++) {
 		struct platform_device *pdev;
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index 3398bd9..ad411a7 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -18,6 +18,7 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/power_supply.h>
+#include <linux/mfd/pcf50633/backlight.h>
 
 struct pcf50633;
 
@@ -43,6 +44,8 @@ struct pcf50633_platform_data {
 	void (*force_shutdown)(struct pcf50633 *);
 
 	u8 resumers[5];
+
+	struct pcf50633_bl_platform_data *backlight_data;
 };
 
 struct pcf50633_irq {
@@ -152,6 +155,7 @@ struct pcf50633 {
 	struct platform_device *mbc_pdev;
 	struct platform_device *adc_pdev;
 	struct platform_device *input_pdev;
+	struct platform_device *bl_pdev;
 	struct platform_device *regulator_pdev[PCF50633_NUM_REGULATORS];
 };
 
-- 
1.5.6.5


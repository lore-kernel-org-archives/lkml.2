Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab2GETgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:36:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41980 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757310Ab2GETfh (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 5 Jul 2012 15:35:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/6] mfd: arizona: Add missing WM5102 ifdefs
Date: Thu,  5 Jul 2012 20:35:31 +0100
Message-Id: <1341516933-16474-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

References to the WM5102 tables need to be guarded.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    3 ++-
 drivers/mfd/arizona-i2c.c  |    2 ++
 drivers/mfd/arizona-irq.c  |    2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 3a4ced2..4d249ed 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -368,6 +368,7 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 	arizona->rev &= ARIZONA_DEVICE_REVISION_MASK;
 
 	switch (reg) {
+#ifdef CONFIG_MFD_WM5102
 	case 0x5102:
 		type_name = "WM5102";
 		if (arizona->type != WM5102) {
@@ -377,7 +378,7 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 		}
 		ret = wm5102_patch(arizona);
 		break;
-
+#endif
 	default:
 		dev_err(arizona->dev, "Unknown device ID %x\n", reg);
 		goto err_reset;
diff --git a/drivers/mfd/arizona-i2c.c b/drivers/mfd/arizona-i2c.c
index 75fb110..fe19d11 100644
--- a/drivers/mfd/arizona-i2c.c
+++ b/drivers/mfd/arizona-i2c.c
@@ -30,9 +30,11 @@ static __devinit int arizona_i2c_probe(struct i2c_client *i2c,
 	int ret;
 
 	switch (id->driver_data) {
+#ifdef CONFIG_MFD_WM5102
 	case WM5102:
 		regmap_config = &wm5102_i2c_regmap;
 		break;
+#endif
 	default:
 		dev_err(&i2c->dev, "Unknown device type %ld\n",
 			id->driver_data);
diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 4c78940..17d20c0 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -158,10 +158,12 @@ int arizona_irq_init(struct arizona *arizona)
 	const struct regmap_irq_chip *aod, *irq;
 
 	switch (arizona->type) {
+#ifdef CONFIG_MFD_WM5102
 	case WM5102:
 		aod = &wm5102_aod;
 		irq = &wm5102_irq;
 		break;
+#endif
 	default:
 		BUG_ON("Unknown Arizona class device" == NULL);
 		return -EINVAL;
-- 
1.7.10


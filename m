Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2K2PEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 10:04:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33555 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2K2PEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 10:04:33 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] mfd: da9052-core: Fix interrupts reported to mfd child devices
Date: Thu, 29 Nov 2012 16:04:28 +0100
Message-Id: <1354201468-9219-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "mfd: da9052-core: Use regmap_irq_get_virq() and fix the probe"
replaces the irq_base with the da9052_map_irq function but doesn't
update the irq_base parameter to the mfd_add_devices call.
This causes child devices to try and request IRQs with just the internal
offset number.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/mfd/da9052-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index c96cdbc..0f12972 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -804,7 +804,7 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 		dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=%d\n", ret);
 
 	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
-			      ARRAY_SIZE(da9052_subdev_info), NULL, 0, NULL);
+			      ARRAY_SIZE(da9052_subdev_info), NULL, da9052_map_irq(da9052, 0), NULL);
 	if (ret) {
 		dev_err(da9052->dev, "mfd_add_devices failed: %d\n", ret);
 		goto err;
-- 
1.7.10.4


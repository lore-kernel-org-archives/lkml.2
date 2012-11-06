Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2KFHjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 02:39:15 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:44809 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314Ab2KFHjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 02:39:14 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 3/7] mfd: max8925: fix onkey driver irq base
Date: Tue,  6 Nov 2012 15:39:30 +0800
Message-Id: <1352187570-9803-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 06 Nov 2012 07:38:42.0261 (UTC) FILETIME=[BE95C050:01CDBBF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

update onkey driver's irq base, it should get from max8925,
but not save in a private value

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/input/misc/max8925_onkey.c |    3 ---
 drivers/mfd/max8925-core.c         |    2 +-
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/input/misc/max8925_onkey.c b/drivers/input/misc/max8925_onkey.c
index 0a12b74..6527789 100644
--- a/drivers/input/misc/max8925_onkey.c
+++ b/drivers/input/misc/max8925_onkey.c
@@ -100,9 +100,6 @@ static int __devinit max8925_onkey_probe(struct platform_device *pdev)
 	input->dev.parent = &pdev->dev;
 	input_set_capability(input, EV_KEY, KEY_POWER);
 
-	irq[0] += chip->irq_base;
-	irq[1] += chip->irq_base;
-
 	error = request_threaded_irq(irq[0], NULL, max8925_onkey_handler,
 				     IRQF_ONESHOT, "onkey-down", info);
 	if (error < 0) {
diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index b1eacae..37a372d 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -881,7 +881,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 
 	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
 			      ARRAY_SIZE(onkey_devs),
-			      NULL, 0, NULL);
+			      NULL, chip->irq_base, NULL);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to add onkey subdev\n");
 		goto out_dev;
-- 
1.7.0.4


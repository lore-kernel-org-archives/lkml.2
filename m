Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab2LCFkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 00:40:49 -0500
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:58114 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab2LCFks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 00:40:48 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, zhouqiao@marvell.com, sameo@linux.intel.com,
        cxie4@marvell.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] mfd: 88pm80x: move to regmap irq base implementation
Date: Mon,  3 Dec 2012 13:40:45 +0800
Message-Id: <1354513245-20775-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 03 Dec 2012 05:40:47.0412 (UTC) FILETIME=[BECCB740:01CDD118]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

get irq_base for mfd sub-device

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/mfd/88pm800.c       |    2 +-
 drivers/mfd/88pm805.c       |    1 +
 include/linux/mfd/88pm80x.h |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 73b2c9f..e1525ab 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -343,7 +343,7 @@ static int __devinit device_irq_init_800(struct pm80x_chip *chip)
 	ret =
 	    regmap_add_irq_chip(chip->regmap, chip->irq, flags, -1,
 				chip->regmap_irq_chip, &chip->irq_data);
-
+	chip->irq_base = regmap_irq_chip_get_base(chip->irq_data);
 out:
 	return ret;
 }
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 7878013..8c9e25a 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -168,6 +168,7 @@ static int __devinit device_irq_init_805(struct pm80x_chip *chip)
 	ret =
 	    regmap_add_irq_chip(chip->regmap, chip->irq, flags, -1,
 				chip->regmap_irq_chip, &chip->irq_data);
+	chip->irq_base = regmap_irq_chip_get_base(chip->irq_data);
 out:
 	return ret;
 }
diff --git a/include/linux/mfd/88pm80x.h b/include/linux/mfd/88pm80x.h
index a0ca0dc..904efb9 100644
--- a/include/linux/mfd/88pm80x.h
+++ b/include/linux/mfd/88pm80x.h
@@ -303,6 +303,7 @@ struct pm80x_chip {
 	int id;
 	int irq;
 	int irq_mode;
+	int irq_base;
 	unsigned long wu_flag;
 	spinlock_t lock;
 };
-- 
1.7.0.4


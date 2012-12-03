Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2LCIL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 03:11:29 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53000 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130Ab2LCIL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 03:11:28 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, zhouqiao@marvell.com, sameo@linux.intel.com,
        tianxf@marvell.com, cxie4@marvell.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: 88pm80x: fix no interrupt mask reg
Date: Mon,  3 Dec 2012 16:11:25 +0800
Message-Id: <1354522285-7563-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 03 Dec 2012 08:11:24.0741 (UTC) FILETIME=[C977AF50:01CDD12D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

1.88pm80x do not have interrupt mask registers and we use
interrupt enable register. So we need to set mask_invert flag.
2.add support for D0 version

Signed-off-by: Xiaofan Tian <tianxf@marvell.com>
Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/mfd/88pm800.c |    4 +++-
 drivers/mfd/88pm805.c |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index e1525ab..3fcc8dd 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -119,7 +119,8 @@ enum {
 	PM800_CHIP_A1  = 0x61,
 	PM800_CHIP_B0  = 0x62,
 	PM800_CHIP_C0  = 0x63,
-	PM800_CHIP_END = PM800_CHIP_C0,
+	PM800_CHIP_D0  = 0x64,
+	PM800_CHIP_END = PM800_CHIP_D0,
 
 	/* Make sure to update this to the last stepping */
 	PM8XXX_CHIP_END = PM800_CHIP_END
@@ -362,6 +363,7 @@ static struct regmap_irq_chip pm800_irq_chip = {
 	.status_base = PM800_INT_STATUS1,
 	.mask_base = PM800_INT_ENA_1,
 	.ack_base = PM800_INT_STATUS1,
+	.mask_invert = 1,
 };
 
 static int pm800_pages_init(struct pm80x_chip *chip)
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 8c9e25a..39a91bd 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -187,6 +187,7 @@ static struct regmap_irq_chip pm805_irq_chip = {
 	.status_base = PM805_INT_STATUS1,
 	.mask_base = PM805_INT_MASK1,
 	.ack_base = PM805_INT_STATUS1,
+	.mask_invert = 1,
 };
 
 static int __devinit device_805_init(struct pm80x_chip *chip)
-- 
1.7.0.4


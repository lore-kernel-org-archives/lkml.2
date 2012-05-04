Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2EDCcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 22:32:10 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:46471 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755609Ab2EDCcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 22:32:09 -0400
From: Chao Xie <chao.xie@marvell.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        haojian.zhuang@marvell.com
Cc: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 6/8] mfd: fix gpadc initialization
Date: Fri,  4 May 2012 10:34:22 +0800
Message-Id: <1336098862-30028-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 04 May 2012 02:31:12.0421 (UTC) FILETIME=[F8CA1550:01CD299D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpadc initialization failure is acceptable. It should not make
88pm860x initialization abort.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm860x-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 87bd5ba..bfd8323 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -846,7 +846,7 @@ static void __devinit device_8607_init(struct pm860x_chip *chip,
 
 	ret = device_gpadc_init(chip, pdata);
 	if (ret < 0)
-		goto out;
+		dev_info(chip->dev, "Failed to init gpadc\n");
 
 	ret = device_irq_init(chip, pdata);
 	if (ret < 0)
-- 
1.7.0.4


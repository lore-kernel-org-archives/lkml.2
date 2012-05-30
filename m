Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab2E3JnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:43:17 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58105 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430Ab2E3JnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:43:16 -0400
Date: Wed, 30 May 2012 11:43:05 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH] i2c-s3c2410: Fix pointer type passed to of_match_node()
To: w.sang@pengutronix.de
Cc: m.szyprowski@samsung.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1338370985-6950-1-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.10
Content-transfer-encoding: 7BIT
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes warning introduced in 27452498a ("i2c-s3c2410: Rework
device type handling"):

  drivers/i2c/busses/i2c-s3c2410.c: In function 's3c24xx_get_device_quirks':
  drivers/i2c/busses/i2c-s3c2410.c:125: warning: passing argument 1 of 'of_match_node' from incompatible pointer type
  include/linux/of.h:245: note: expected 'const struct of_device_id *' but argument is of type 'const struct of_device_id (*)[4]'

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/i2c/busses/i2c-s3c2410.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index fa0b134..286e596 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -122,7 +122,7 @@ static inline unsigned int s3c24xx_get_device_quirks(struct platform_device *pde
 {
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
-		match = of_match_node(&s3c24xx_i2c_match, pdev->dev.of_node);
+		match = of_match_node(s3c24xx_i2c_match, pdev->dev.of_node);
 		return (unsigned int)match->data;
 	}
 
-- 
1.7.10


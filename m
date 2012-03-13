Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab2CMQyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:54:51 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25339 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2CMQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:54:48 -0400
Date: Tue, 13 Mar 2012 17:54:37 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 1/3] i2c-s3c2410: Drop unused define
In-reply-to: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
To: ben-linux@fluff.org
Cc: thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1331657679-31302-2-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard of_match_ptr() to avoid defining variable unused
in non device tree builds.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/i2c/busses/i2c-s3c2410.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 737f721..85e3664 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1128,8 +1128,6 @@ static const struct of_device_id s3c24xx_i2c_match[] = {
 	{},
 };
 MODULE_DEVICE_TABLE(of, s3c24xx_i2c_match);
-#else
-#define s3c24xx_i2c_match NULL
 #endif
 
 static struct platform_driver s3c24xx_i2c_driver = {
@@ -1140,7 +1138,7 @@ static struct platform_driver s3c24xx_i2c_driver = {
 		.owner	= THIS_MODULE,
 		.name	= "s3c-i2c",
 		.pm	= S3C24XX_DEV_PM_OPS,
-		.of_match_table = s3c24xx_i2c_match,
+		.of_match_table = of_match_ptr(s3c24xx_i2c_match),
 	},
 };
 
-- 
1.7.9


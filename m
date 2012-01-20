Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2ATPMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:12:33 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:49637 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab2ATPM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:12:28 -0500
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH 1/2] mfd: Convert s5m core driver to use devm_kzalloc()
Date: Fri, 20 Jan 2012 16:09:11 +0900
Message-Id: <1327043352-25037-1-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert s5m core driver to use devm_kzalloc().

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/s5m-core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/s5m-core.c b/drivers/mfd/s5m-core.c
index e075c11..38bd353 100644
--- a/drivers/mfd/s5m-core.c
+++ b/drivers/mfd/s5m-core.c
@@ -77,7 +77,8 @@ static int s5m87xx_i2c_probe(struct i2c_client *i2c,
 	int ret = 0;
 	int error;
 
-	s5m87xx = kzalloc(sizeof(struct s5m87xx_dev), GFP_KERNEL);
+	s5m87xx = devm_kzalloc(&i2c->dev, sizeof(struct s5m87xx_dev),
+				GFP_KERNEL);
 	if (s5m87xx == NULL)
 		return -ENOMEM;
 
@@ -126,7 +127,6 @@ err:
 	s5m_irq_exit(s5m87xx);
 	i2c_unregister_device(s5m87xx->rtc);
 	regmap_exit(s5m87xx->regmap);
-	kfree(s5m87xx);
 	return ret;
 }
 
@@ -138,7 +138,6 @@ static int s5m87xx_i2c_remove(struct i2c_client *i2c)
 	s5m_irq_exit(s5m87xx);
 	i2c_unregister_device(s5m87xx->rtc);
 	regmap_exit(s5m87xx->regmap);
-	kfree(s5m87xx);
 	return 0;
 }
 
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab1HBEzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 00:55:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60549 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1HBEzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 00:55:06 -0400
Subject: [PATCH] regulator: Ensure enough enable time for max8649
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Aug 2011 12:54:56 +0800
Message-ID: <1312260896.6161.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integer division may truncate the result, thus max8649_enable_time() may return
slightly shorter enable time. This patch fixes it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8649.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 30eb9e5..1062cf9 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -221,7 +221,7 @@ static int max8649_enable_time(struct regulator_dev *rdev)
 	ret = (ret & MAX8649_RAMP_MASK) >> 5;
 	rate = (32 * 1000) >> ret;	/* uV/uS */
 
-	return (voltage / rate);
+	return DIV_ROUND_UP(voltage, rate);
 }
 
 static int max8649_set_mode(struct regulator_dev *rdev, unsigned int mode)
-- 
1.7.4.1




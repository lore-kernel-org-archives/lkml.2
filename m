Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1IZHRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:17:38 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33225 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725Ab1IZHRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:17:37 -0400
From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
To: khali@linux-fr.org, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, tomoya-linux@dsn.okisemi.com,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Subject: [PATCH] i2c-eg20t: modified the setting of transfer rate.
Date: Mon, 26 Sep 2011 16:16:23 +0900
Message-Id: <1317021383-11742-1-git-send-email-toshiharu-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modified the setting value of
I2C Bus Transfer Rate Setting Counter regisrer.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index ce1a32b..6b46892 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -242,7 +242,7 @@ static void pch_i2c_init(struct i2c_algo_pch_data *adap)
 	if (pch_clk > PCH_MAX_CLK)
 		pch_clk = 62500;
 
-	pch_i2cbc = (pch_clk + (pch_i2c_speed * 4)) / pch_i2c_speed * 8;
+	pch_i2cbc = (pch_clk + (pch_i2c_speed * 4)) / (pch_i2c_speed * 8);
 	/* Set transfer speed in I2CBC */
 	iowrite32(pch_i2cbc, p + PCH_I2CBC);
 
-- 
1.7.4.4


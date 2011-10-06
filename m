Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab1JFGxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:53:41 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:27146 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778Ab1JFGvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:51:41 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 3/7 v1] i2c-eg20t: Fix 10bit access issue
Date: Thu,  6 Oct 2011 15:56:27 +0900
Message-Id: <1317884192-10694-3-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1317884192-10694-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1317884192-10694-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Jeffrey (Sheng-Hui) Chu <jeffchu@broadcom.com>
Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index c5b9924..aa1705e 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -410,7 +410,7 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 	}
 
 	if (msgs->flags & I2C_M_TEN) {
-		addr_2_msb = ((addr & I2C_MSB_2B_MSK) >> 7);
+		addr_2_msb = ((addr & I2C_MSB_2B_MSK) >> 7) & 0x06;
 		iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
 		if (first)
 			pch_i2c_start(adap);
@@ -515,7 +515,6 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 	if (msgs->flags & I2C_M_TEN) {
 		addr_2_msb = (((addr & I2C_MSB_2B_MSK) >> 7) | (I2C_RD));
 		iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
-
 	} else {
 		/* 7 address bits + R/W bit */
 		addr = (((addr) << 1) | (I2C_RD));
-- 
1.7.4.4


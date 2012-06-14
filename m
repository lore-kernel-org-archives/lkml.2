Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2FNKXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:23:14 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:57892 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469Ab2FNKXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:23:09 -0400
From: Felipe Balbi <balbi@ti.com>
To: ben-linux@fluff.org
Cc: Tony Lindgren <tony@atomide.com>, w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 04/17] i2c: omap: simplify omap_i2c_ack_stat()
Date: Thu, 14 Jun 2012 13:20:37 +0300
Message-Id: <1339669250-9183-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339669250-9183-1-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stat & BIT(1) is the same as BIT(1), so let's
simplify things a bit by removing "stat &" from
all omap_i2c_ack_stat() calls.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 07ae391..fa9ddb6 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -774,8 +774,8 @@ static int errata_omap3_1p153(struct omap_i2c_dev *dev, u16 *stat, int *err)
 
 	while (--timeout && !(*stat & OMAP_I2C_STAT_XUDF)) {
 		if (*stat & (OMAP_I2C_STAT_NACK | OMAP_I2C_STAT_AL)) {
-			omap_i2c_ack_stat(dev, *stat & (OMAP_I2C_STAT_XRDY |
-							OMAP_I2C_STAT_XDR));
+			omap_i2c_ack_stat(dev, (OMAP_I2C_STAT_XRDY |
+					OMAP_I2C_STAT_XDR));
 			*err |= OMAP_I2C_STAT_XUDF;
 			return -ETIMEDOUT;
 		}
@@ -835,10 +835,11 @@ complete:
 		 */
 		if (stat & (OMAP_I2C_STAT_ARDY | OMAP_I2C_STAT_NACK |
 					OMAP_I2C_STAT_AL)) {
-			omap_i2c_ack_stat(dev, stat &
-				(OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR |
-				OMAP_I2C_STAT_XRDY | OMAP_I2C_STAT_XDR |
-				OMAP_I2C_STAT_ARDY));
+			omap_i2c_ack_stat(dev, (OMAP_I2C_STAT_RRDY |
+						OMAP_I2C_STAT_RDR |
+						OMAP_I2C_STAT_XRDY |
+						OMAP_I2C_STAT_XDR |
+						OMAP_I2C_STAT_ARDY));
 			omap_i2c_complete_cmd(dev, err);
 			return IRQ_HANDLED;
 		}
@@ -885,8 +886,8 @@ complete:
 					}
 				}
 			}
-			omap_i2c_ack_stat(dev,
-				stat & (OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR));
+			omap_i2c_ack_stat(dev, (OMAP_I2C_STAT_RRDY |
+						OMAP_I2C_STAT_RDR));
 			continue;
 		}
 
@@ -933,8 +934,8 @@ complete:
 
 				omap_i2c_write_reg(dev, OMAP_I2C_DATA_REG, w);
 			}
-			omap_i2c_ack_stat(dev,
-				stat & (OMAP_I2C_STAT_XRDY | OMAP_I2C_STAT_XDR));
+			omap_i2c_ack_stat(dev, (OMAP_I2C_STAT_XRDY |
+						OMAP_I2C_STAT_XDR));
 			continue;
 		}
 
-- 
1.7.10.4


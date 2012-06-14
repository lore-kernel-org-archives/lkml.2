Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2FNQ0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:26:38 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:51627 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352Ab2FNQ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:26:37 -0400
From: Felipe Balbi <balbi@ti.com>
To: ben-linux@fluff.org
Cc: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 01/17] i2c: omap: simplify num_bytes handling
Date: Thu, 14 Jun 2012 19:24:11 +0300
Message-Id: <1339691067-919-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339691067-919-1-git-send-email-balbi@ti.com>
References: <1339691067-919-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trivial patch, no functional changes

Signed-off-by: Felipe Balbi <balbi@ti.com>
Reviewed-by : Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 801df60..9b532cd 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -855,8 +855,7 @@ complete:
 							OMAP_I2C_BUFSTAT_REG)
 							>> 8) & 0x3F;
 			}
-			while (num_bytes) {
-				num_bytes--;
+			while (num_bytes--) {
 				w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
 				if (dev->buf_len) {
 					*dev->buf++ = w;
@@ -898,8 +897,7 @@ complete:
 							OMAP_I2C_BUFSTAT_REG)
 							& 0x3F;
 			}
-			while (num_bytes) {
-				num_bytes--;
+			while (num_bytes--) {
 				w = 0;
 				if (dev->buf_len) {
 					w = *dev->buf++;
-- 
1.7.10.4


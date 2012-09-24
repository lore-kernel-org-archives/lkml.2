Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2IXJsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:48:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58034 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2IXJsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:48:33 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        <a.zummo@towertech.it>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv2 1/7] rtc: Convert struct i2c_msg initialization to C99 format
Date: Mon, 24 Sep 2012 15:17:40 +0530
Message-ID: <1348480066-3132-2-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348480066-3132-1-git-send-email-shubhrajyoti@ti.com>
References: <1348480066-3132-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the struct i2c_msg initialization to C99 format. This makes
maintaining and editing the code simpler. Also helps once other fields
like transferred are added in future.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/rtc/rtc-ds1672.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-ds1672.c b/drivers/rtc/rtc-ds1672.c
index 7fa67d0..577dbae 100644
--- a/drivers/rtc/rtc-ds1672.c
+++ b/drivers/rtc/rtc-ds1672.c
@@ -37,8 +37,17 @@ static int ds1672_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 	unsigned char buf[4];
 
 	struct i2c_msg msgs[] = {
-		{client->addr, 0, 1, &addr},	/* setup read ptr */
-		{client->addr, I2C_M_RD, 4, buf},	/* read date */
+		{/* setup read ptr */
+			.addr = client->addr,
+			.len = 1,
+			.buf = &addr
+		},
+		{/* setup read ptr */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 4,
+			.buf = buf
+		},
 	};
 
 	/* read date registers */
@@ -99,8 +108,17 @@ static int ds1672_get_control(struct i2c_client *client, u8 *status)
 	unsigned char addr = DS1672_REG_CONTROL;
 
 	struct i2c_msg msgs[] = {
-		{client->addr, 0, 1, &addr},	/* setup read ptr */
-		{client->addr, I2C_M_RD, 1, status},	/* read control */
+		{/* setup read ptr */
+			.addr = client->addr,
+			.len = 1,
+			.buf = &addr
+		},
+		{/* read control */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = status
+		},
 	};
 
 	/* read control register */
-- 
1.7.5.4


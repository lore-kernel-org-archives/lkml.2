Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2IQN6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:58:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39550 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab2IQN6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:58:34 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 7/7] rtc: Convert struct i2c_msg initialization to C99 format
Date: Mon, 17 Sep 2012 19:28:14 +0530
Message-ID: <1347890294-28467-8-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347890294-28467-1-git-send-email-shubhrajyoti@ti.com>
References: <1347890294-28467-1-git-send-email-shubhrajyoti@ti.com>
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
 drivers/rtc/rtc-x1205.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index 403b3d4..4ddd9a6 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -97,8 +97,8 @@ static int x1205_get_datetime(struct i2c_client *client, struct rtc_time *tm,
 	int i;
 
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 2, dt_addr },	/* setup read ptr */
-		{ client->addr, I2C_M_RD, 8, buf },	/* read date */
+		{ .addr = client->addr, .flags = 0, .len = 2, .buf = dt_addr },	/* setup read ptr */
+		{ .addr = client->addr, .flags = I2C_M_RD, .len = 8, .buf = buf },	/* read date */
 	};
 
 	/* read date registers */
@@ -142,8 +142,8 @@ static int x1205_get_status(struct i2c_client *client, unsigned char *sr)
 	static unsigned char sr_addr[2] = { 0, X1205_REG_SR };
 
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 2, sr_addr },	/* setup read ptr */
-		{ client->addr, I2C_M_RD, 1, sr },	/* read status */
+		{ .addr = client->addr, .flags = 0, .len = 2, .buf = sr_addr },	/* setup read ptr */
+		{ .addr = client->addr, .flags = I2C_M_RD, .len = 1, .buf = sr },	/* read status */
 	};
 
 	/* read status register */
@@ -279,8 +279,8 @@ static int x1205_get_dtrim(struct i2c_client *client, int *trim)
 	static unsigned char dtr_addr[2] = { 0, X1205_REG_DTR };
 
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 2, dtr_addr },	/* setup read ptr */
-		{ client->addr, I2C_M_RD, 1, &dtr }, 	/* read dtr */
+		{ .addr = client->addr, .flags = 0, .len = 2, .buf = dtr_addr },	/* setup read ptr */
+		{ .addr = client->addr, .flags = I2C_M_RD, .len = 1, .buf = &dtr },	/* read dtr */
 	};
 
 	/* read dtr register */
@@ -311,8 +311,8 @@ static int x1205_get_atrim(struct i2c_client *client, int *trim)
 	static unsigned char atr_addr[2] = { 0, X1205_REG_ATR };
 
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 2, atr_addr },	/* setup read ptr */
-		{ client->addr, I2C_M_RD, 1, &atr }, 	/* read atr */
+		{ .addr = client->addr, .flags = 0, .len = 2, .buf = atr_addr },	/* setup read ptr */
+		{ .addr = client->addr, .flags = I2C_M_RD, .len = 1, .buf = &atr },	/* read atr */
 	};
 
 	/* read atr register */
@@ -381,8 +381,8 @@ static int x1205_validate_client(struct i2c_client *client)
 		unsigned char addr[2] = { 0, probe_zero_pattern[i] };
 
 		struct i2c_msg msgs[2] = {
-			{ client->addr, 0, 2, addr },
-			{ client->addr, I2C_M_RD, 1, &buf },
+			{ .addr = client->addr, .flags = 0, .len = 2, .buf = addr },
+			{ .addr = client->addr, .flags = I2C_M_RD, .len = 1, .buf = &buf },
 		};
 
 		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
@@ -409,8 +409,8 @@ static int x1205_validate_client(struct i2c_client *client)
 		unsigned char addr[2] = { 0, probe_limits_pattern[i].reg };
 
 		struct i2c_msg msgs[2] = {
-			{ client->addr, 0, 2, addr },
-			{ client->addr, I2C_M_RD, 1, &reg },
+			{ .addr = client->addr, .flags = 0, .len = 2, .buf = addr },
+			{ .addr = client->addr, .flags = I2C_M_RD, .len = 1, .buf = &reg },
 		};
 
 		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
@@ -444,8 +444,8 @@ static int x1205_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	static unsigned char int_addr[2] = { 0, X1205_REG_INT };
 	struct i2c_client *client = to_i2c_client(dev);
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 2, int_addr },        /* setup read ptr */
-		{ client->addr, I2C_M_RD, 1, &intreg },  /* read INT register */
+		{ .addr = client->addr, .flags = 0, .len = 2, .buf = int_addr },        /* setup read ptr */
+		{ .addr = client->addr, .flags = I2C_M_RD, .len = 1, .buf = &intreg },  /* read INT register */
 	};
 
 	/* read interrupt register and status register */
-- 
1.7.5.4


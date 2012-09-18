Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab2IRLov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:44:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41507 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792Ab2IRLos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:44:48 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 6/6] media: Convert struct i2c_msg initialization to C99 format
Date: Tue, 18 Sep 2012 17:14:32 +0530
Message-ID: <1347968672-10803-7-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347968672-10803-1-git-send-email-shubhrajyoti@ti.com>
References: <1347968672-10803-1-git-send-email-shubhrajyoti@ti.com>
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
 drivers/media/radio/si470x/radio-si470x-i2c.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index f867f04..e5024cf 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -98,8 +98,12 @@ int si470x_get_register(struct si470x_device *radio, int regnr)
 {
 	u16 buf[READ_REG_NUM];
 	struct i2c_msg msgs[1] = {
-		{ radio->client->addr, I2C_M_RD, sizeof(u16) * READ_REG_NUM,
-			(void *)buf },
+		{
+			.addr = radio->client->addr,
+			.flags = I2C_M_RD,
+			.len = sizeof(u16) * READ_REG_NUM,
+			.buf = (void *)buf
+		},
 	};
 
 	if (i2c_transfer(radio->client->adapter, msgs, 1) != 1)
@@ -119,8 +123,11 @@ int si470x_set_register(struct si470x_device *radio, int regnr)
 	int i;
 	u16 buf[WRITE_REG_NUM];
 	struct i2c_msg msgs[1] = {
-		{ radio->client->addr, 0, sizeof(u16) * WRITE_REG_NUM,
-			(void *)buf },
+		{
+			.addr = radio->client->addr,
+			.len = sizeof(u16) * WRITE_REG_NUM,
+			.buf = (void *)buf
+		},
 	};
 
 	for (i = 0; i < WRITE_REG_NUM; i++)
@@ -146,8 +153,12 @@ static int si470x_get_all_registers(struct si470x_device *radio)
 	int i;
 	u16 buf[READ_REG_NUM];
 	struct i2c_msg msgs[1] = {
-		{ radio->client->addr, I2C_M_RD, sizeof(u16) * READ_REG_NUM,
-			(void *)buf },
+		{
+			.addr = radio->client->addr,
+			.flags = I2C_M_RD,
+			.len = sizeof(u16) * READ_REG_NUM,
+			.buf = (void *)buf
+		},
 	};
 
 	if (i2c_transfer(radio->client->adapter, msgs, 1) != 1)
-- 
1.7.5.4


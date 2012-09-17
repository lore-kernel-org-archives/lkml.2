Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab2IQOSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:18:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52587 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab2IQOST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:18:19 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-input@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 1/2] input: Convert struct i2c_msg initialization to C99 format
Date: Mon, 17 Sep 2012 19:48:00 +0530
Message-ID: <1347891481-18086-2-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347891481-18086-1-git-send-email-shubhrajyoti@ti.com>
References: <1347891481-18086-1-git-send-email-shubhrajyoti@ti.com>
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
 drivers/input/joystick/as5011.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/joystick/as5011.c b/drivers/input/joystick/as5011.c
index c96653b..35302fb 100644
--- a/drivers/input/joystick/as5011.c
+++ b/drivers/input/joystick/as5011.c
@@ -85,7 +85,7 @@ static int as5011_i2c_write(struct i2c_client *client,
 {
 	uint8_t data[2] = { aregaddr, avalue };
 	struct i2c_msg msg = {
-		client->addr, I2C_M_IGNORE_NAK, 2, (uint8_t *)data
+		.addr = client->addr, .flags = I2C_M_IGNORE_NAK, .len = 2, .buf = (uint8_t *)data
 	};
 	int error;
 
@@ -98,8 +98,8 @@ static int as5011_i2c_read(struct i2c_client *client,
 {
 	uint8_t data[2] = { aregaddr };
 	struct i2c_msg msg_set[2] = {
-		{ client->addr, I2C_M_REV_DIR_ADDR, 1, (uint8_t *)data },
-		{ client->addr, I2C_M_RD | I2C_M_NOSTART, 1, (uint8_t *)data }
+		{ .addr = client->addr, .flags = I2C_M_REV_DIR_ADDR, .len = 1, .buf = (uint8_t *)data },
+		{ .addr = client->addr, .flags = I2C_M_RD | I2C_M_NOSTART, .len = 1, .buf = (uint8_t *)data }
 	};
 	int error;
 
-- 
1.7.5.4


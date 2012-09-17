Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab2IQPpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:45:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49056 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab2IQPpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:45:15 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] mfd: Convert struct i2c_msg initialization to C99 format
Date: Mon, 17 Sep 2012 21:14:58 +0530
Message-ID: <1347896698-20307-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the struct i2c_msg initialization to C99 format. This makes
maintaining and editing the code simpler. Also helps once other fields
like transferred are added in future.

Thanks to Julia Lawall <julia.lawall@lip6.fr>  for automating the conversion

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/mfd/88pm860x-i2c.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/88pm860x-i2c.c b/drivers/mfd/88pm860x-i2c.c
index b2cfdc4..de322b6 100644
--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -91,8 +91,18 @@ static int read_device(struct i2c_client *i2c, int reg,
 	unsigned char msgbuf0[I2C_SMBUS_BLOCK_MAX + 3];
 	unsigned char msgbuf1[I2C_SMBUS_BLOCK_MAX + 2];
 	struct i2c_adapter *adap = i2c->adapter;
-	struct i2c_msg msg[2] = {{i2c->addr, 0, 1, msgbuf0},
-				 {i2c->addr, I2C_M_RD, 0, msgbuf1},
+	struct i2c_msg msg[2] = {
+					{
+						.addr = i2c->addr,
+						.flags = 0,
+						.len = 1,
+						.buf = msgbuf0
+					},
+					{	.addr = i2c->addr,
+						.flags = I2C_M_RD,
+						.len = 0,
+						.buf = msgbuf1
+					},
 				};
 	int num = 1, ret = 0;
 
-- 
1.7.5.4


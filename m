Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab2IRLpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:45:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40540 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab2IRLoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:44:54 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 4/6] media: Convert struct i2c_msg initialization to C99 format
Date: Tue, 18 Sep 2012 17:14:30 +0530
Message-ID: <1347968672-10803-5-git-send-email-shubhrajyoti@ti.com>
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
 drivers/media/i2c/msp3400-driver.c |   40 ++++++++++++++++++++++++++++++-----
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index aeb22be..766305f 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -119,12 +119,31 @@ int msp_reset(struct i2c_client *client)
 	static u8 write[3]     = { I2C_MSP_DSP + 1, 0x00, 0x1e };
 	u8 read[2];
 	struct i2c_msg reset[2] = {
-		{ client->addr, I2C_M_IGNORE_NAK, 3, reset_off },
-		{ client->addr, I2C_M_IGNORE_NAK, 3, reset_on  },
+		{
+			.addr = client->addr,
+			.flags = I2C_M_IGNORE_NAK,
+			.len = 3,
+			.buf = reset_off
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_IGNORE_NAK,
+			.len = 3,
+			.buf = reset_on
+		},
 	};
 	struct i2c_msg test[2] = {
-		{ client->addr, 0,        3, write },
-		{ client->addr, I2C_M_RD, 2, read  },
+		{
+			.addr = client->addr,
+			.len = 3,
+			.buf = write
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 2,
+			.buf = read
+		},
 	};
 
 	v4l_dbg(3, msp_debug, client, "msp_reset\n");
@@ -143,8 +162,17 @@ static int msp_read(struct i2c_client *client, int dev, int addr)
 	u8 write[3];
 	u8 read[2];
 	struct i2c_msg msgs[2] = {
-		{ client->addr, 0,        3, write },
-		{ client->addr, I2C_M_RD, 2, read  }
+		{
+			.addr = client->addr,
+			.len = 3,
+			.buf = write
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 2,
+			.buf = read
+		}
 	};
 
 	write[0] = dev + 1;
-- 
1.7.5.4


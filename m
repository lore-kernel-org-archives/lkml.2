Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab2IQPYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:24:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40778 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793Ab2IQPXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:23:00 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 4/6] media: Convert struct i2c_msg initialization to C99 format
Date: Mon, 17 Sep 2012 20:52:31 +0530
Message-ID: <1347895353-18090-5-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347895353-18090-1-git-send-email-shubhrajyoti@ti.com>
References: <1347895353-18090-1-git-send-email-shubhrajyoti@ti.com>
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
 drivers/media/radio/radio-tea5764.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 6b1fae3..5dbe12e 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -151,8 +151,8 @@ int tea5764_i2c_read(struct tea5764_device *radio)
 	u16 *p = (u16 *) &radio->regs;
 
 	struct i2c_msg msgs[1] = {
-		{ radio->i2c_client->addr, I2C_M_RD, sizeof(radio->regs),
-			(void *)&radio->regs },
+		{ .addr = radio->i2c_client->addr, .flags = I2C_M_RD, .len = sizeof(radio->regs),
+			.buf = (void *)&radio->regs },
 	};
 	if (i2c_transfer(radio->i2c_client->adapter, msgs, 1) != 1)
 		return -EIO;
@@ -167,7 +167,7 @@ int tea5764_i2c_write(struct tea5764_device *radio)
 	struct tea5764_write_regs wr;
 	struct tea5764_regs *r = &radio->regs;
 	struct i2c_msg msgs[1] = {
-		{ radio->i2c_client->addr, 0, sizeof(wr), (void *) &wr },
+		{ .addr = radio->i2c_client->addr, .flags = 0, .len = sizeof(wr), .buf = (void *)&wr },
 	};
 	wr.intreg  = r->intreg & 0xff;
 	wr.frqset  = __cpu_to_be16(r->frqset);
-- 
1.7.5.4


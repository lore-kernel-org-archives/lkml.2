Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab2IQPzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:55:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36945 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab2IQPzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:55:41 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-fbdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] matroxfb: Convert struct i2c_msg initialization to C99 format
Date: Mon, 17 Sep 2012 21:25:24 +0530
Message-ID: <1347897325-20684-1-git-send-email-shubhrajyoti@ti.com>
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
the cocci file was posted
http://www.mail-archive.com/cocci@diku.dk/msg02753.html

 drivers/video/matrox/matroxfb_maven.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_maven.c b/drivers/video/matrox/matroxfb_maven.c
index 217678e..fb5c123 100644
--- a/drivers/video/matrox/matroxfb_maven.c
+++ b/drivers/video/matrox/matroxfb_maven.c
@@ -137,8 +137,19 @@ static int* get_ctrl_ptr(struct maven_data* md, int idx) {
 
 static int maven_get_reg(struct i2c_client* c, char reg) {
 	char dst;
-	struct i2c_msg msgs[] = {{ c->addr, I2C_M_REV_DIR_ADDR, sizeof(reg), &reg },
-				 { c->addr, I2C_M_RD | I2C_M_NOSTART, sizeof(dst), &dst }};
+	struct i2c_msg msgs[] = {{
+					.addr = c->addr,
+					.flags = I2C_M_REV_DIR_ADDR,
+					.len = sizeof(reg),
+					.buf = &reg
+				},
+				{
+					.addr = c->addr,
+					.flags = I2C_M_RD | I2C_M_NOSTART,
+					.len = sizeof(dst),
+					.buf = &dst
+				}
+	};
 	s32 err;
 
 	err = i2c_transfer(c->adapter, msgs, 2);
-- 
1.7.5.4


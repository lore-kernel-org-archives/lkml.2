Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2IYKeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:34:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35874 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab2IYKeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:34:09 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <a.zummo@towertech.it>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv2 6/7] rtc: Convert struct i2c_msg initialization to C99 format
Date: Tue, 25 Sep 2012 16:03:43 +0530
Message-ID: <1348569224-4096-7-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348569224-4096-1-git-send-email-shubhrajyoti@ti.com>
References: <1348569224-4096-1-git-send-email-shubhrajyoti@ti.com>
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
 drivers/rtc/rtc-isl1208.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index 0ea86ac..26c81f2 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -68,9 +68,17 @@ isl1208_i2c_read_regs(struct i2c_client *client, u8 reg, u8 buf[],
 {
 	u8 reg_addr[1] = { reg };
 	struct i2c_msg msgs[2] = {
-		{client->addr, 0, sizeof(reg_addr), reg_addr}
-		,
-		{client->addr, I2C_M_RD, len, buf}
+		{
+			.addr = client->addr,
+			.len = sizeof(reg_addr),
+			.buf = reg_addr
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = len,
+			.buf = buf
+		}
 	};
 	int ret;
 
@@ -90,7 +98,11 @@ isl1208_i2c_set_regs(struct i2c_client *client, u8 reg, u8 const buf[],
 {
 	u8 i2c_buf[ISL1208_REG_USR2 + 2];
 	struct i2c_msg msgs[1] = {
-		{client->addr, 0, len + 1, i2c_buf}
+		{
+			.addr = client->addr,
+			.len = len + 1,
+			.buf = i2c_buf
+		}
 	};
 	int ret;
 
-- 
1.7.5.4


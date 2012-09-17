Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2IQN7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:59:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34077 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab2IQN6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:58:35 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 6/7] rtc: Convert struct i2c_msg initialization to C99 format
Date: Mon, 17 Sep 2012 19:28:13 +0530
Message-ID: <1347890294-28467-7-git-send-email-shubhrajyoti@ti.com>
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
 drivers/rtc/rtc-s35390a.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index c9562ce..e8c835e 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -50,7 +50,7 @@ static int s35390a_set_reg(struct s35390a *s35390a, int reg, char *buf, int len)
 {
 	struct i2c_client *client = s35390a->client[reg];
 	struct i2c_msg msg[] = {
-		{ client->addr, 0, len, buf },
+		{ .addr = client->addr, .flags = 0, .len = len, .buf = buf },
 	};
 
 	if ((i2c_transfer(client->adapter, msg, 1)) != 1)
@@ -63,7 +63,7 @@ static int s35390a_get_reg(struct s35390a *s35390a, int reg, char *buf, int len)
 {
 	struct i2c_client *client = s35390a->client[reg];
 	struct i2c_msg msg[] = {
-		{ client->addr, I2C_M_RD, len, buf },
+		{ .addr = client->addr, .flags = I2C_M_RD, .len = len, .buf = buf },
 	};
 
 	if ((i2c_transfer(client->adapter, msg, 1)) != 1)
-- 
1.7.5.4


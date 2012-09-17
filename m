Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab2IQN6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:58:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34086 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab2IQN6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:58:39 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 4/7] rtc: Convert struct i2c_msg initialization to C99 format
Date: Mon, 17 Sep 2012 19:28:11 +0530
Message-ID: <1347890294-28467-5-git-send-email-shubhrajyoti@ti.com>
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
 drivers/rtc/rtc-pcf8563.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index c2fe426..7cc8092 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -78,8 +78,8 @@ static int pcf8563_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 	unsigned char buf[13] = { PCF8563_REG_ST1 };
 
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 1, buf },	/* setup read ptr */
-		{ client->addr, I2C_M_RD, 13, buf },	/* read status + date */
+		{ .addr = client->addr, .flags = 0, .len = 1, .buf = buf },	/* setup read ptr */
+		{ .addr = client->addr, .flags = I2C_M_RD, .len = 13, .buf = buf },	/* read status + date */
 	};
 
 	/* read registers */
-- 
1.7.5.4


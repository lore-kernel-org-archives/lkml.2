Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2IYKex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:34:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55400 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab2IYKes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:34:48 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <a.zummo@towertech.it>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv2 7/7] rtc: Convert struct i2c_msg initialization to C99 format
Date: Tue, 25 Sep 2012 16:03:44 +0530
Message-ID: <1348569224-4096-8-git-send-email-shubhrajyoti@ti.com>
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
 drivers/rtc/rtc-em3027.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-em3027.c b/drivers/rtc/rtc-em3027.c
index 0104ea7..f6c24ce 100644
--- a/drivers/rtc/rtc-em3027.c
+++ b/drivers/rtc/rtc-em3027.c
@@ -49,8 +49,17 @@ static int em3027_get_time(struct device *dev, struct rtc_time *tm)
 	unsigned char buf[7];
 
 	struct i2c_msg msgs[] = {
-		{client->addr, 0, 1, &addr},		/* setup read addr */
-		{client->addr, I2C_M_RD, 7, buf},	/* read time/date */
+		{/* setup read addr */
+			.addr = client->addr,
+			.len = 1,
+			.buf = &addr
+		},
+		{/* read time/date */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 7,
+			.buf = buf
+		},
 	};
 
 	/* read time/date registers */
@@ -76,7 +85,9 @@ static int em3027_set_time(struct device *dev, struct rtc_time *tm)
 	unsigned char buf[8];
 
 	struct i2c_msg msg = {
-		client->addr, 0, 8, buf,	/* write time/date */
+		.addr = client->addr,
+		.len = 8,
+		.buf = buf,	/* write time/date */
 	};
 
 	buf[0] = EM3027_REG_WATCH_SEC;
-- 
1.7.5.4


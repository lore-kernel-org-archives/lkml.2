Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2IYKeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:34:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35875 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703Ab2IYKeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:34:09 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <a.zummo@towertech.it>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv2 5/7] rtc: Convert struct i2c_msg initialization to C99 format
Date: Tue, 25 Sep 2012 16:03:42 +0530
Message-ID: <1348569224-4096-6-git-send-email-shubhrajyoti@ti.com>
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
 drivers/rtc/rtc-pcf8563.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index c2fe426..98e3a2b 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -78,8 +78,17 @@ static int pcf8563_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 	unsigned char buf[13] = { PCF8563_REG_ST1 };
 
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 1, buf },	/* setup read ptr */
-		{ client->addr, I2C_M_RD, 13, buf },	/* read status + date */
+		{/* setup read ptr */
+			.addr = client->addr,
+			.len = 1,
+			.buf = buf
+		},
+		{/* read status + date */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 13,
+			.buf = buf
+		},
 	};
 
 	/* read registers */
-- 
1.7.5.4


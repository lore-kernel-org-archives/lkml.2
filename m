Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab2IQN6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:58:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39549 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab2IQN6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:58:33 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 2/7] rtc: Convert struct i2c_msg initialization to C99 format
Date: Mon, 17 Sep 2012 19:28:09 +0530
Message-ID: <1347890294-28467-3-git-send-email-shubhrajyoti@ti.com>
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
 drivers/rtc/rtc-em3027.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-em3027.c b/drivers/rtc/rtc-em3027.c
index 0104ea7..373f7e5 100644
--- a/drivers/rtc/rtc-em3027.c
+++ b/drivers/rtc/rtc-em3027.c
@@ -49,8 +49,8 @@ static int em3027_get_time(struct device *dev, struct rtc_time *tm)
 	unsigned char buf[7];
 
 	struct i2c_msg msgs[] = {
-		{client->addr, 0, 1, &addr},		/* setup read addr */
-		{client->addr, I2C_M_RD, 7, buf},	/* read time/date */
+		{.addr = client->addr, .flags = 0, .len = 1, .buf = &addr},		/* setup read addr */
+		{.addr = client->addr, .flags = I2C_M_RD, .len = 7, .buf = buf},	/* read time/date */
 	};
 
 	/* read time/date registers */
@@ -76,7 +76,7 @@ static int em3027_set_time(struct device *dev, struct rtc_time *tm)
 	unsigned char buf[8];
 
 	struct i2c_msg msg = {
-		client->addr, 0, 8, buf,	/* write time/date */
+		.addr = client->addr, .flags = 0, .len = 8, .buf = buf,	/* write time/date */
 	};
 
 	buf[0] = EM3027_REG_WATCH_SEC;
-- 
1.7.5.4


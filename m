Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab2IQOSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:18:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35816 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab2IQOSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:18:21 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-input@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 2/2] input: Convert struct i2c_msg initialization to C99 format
Date: Mon, 17 Sep 2012 19:48:01 +0530
Message-ID: <1347891481-18086-3-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347891481-18086-1-git-send-email-shubhrajyoti@ti.com>
References: <1347891481-18086-1-git-send-email-shubhrajyoti@ti.com>
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
 drivers/input/touchscreen/cy8ctmg110_ts.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/cy8ctmg110_ts.c b/drivers/input/touchscreen/cy8ctmg110_ts.c
index 464f1bf..2ed0427 100644
--- a/drivers/input/touchscreen/cy8ctmg110_ts.c
+++ b/drivers/input/touchscreen/cy8ctmg110_ts.c
@@ -99,9 +99,9 @@ static int cy8ctmg110_read_regs(struct cy8ctmg110 *tsc,
 	int ret;
 	struct i2c_msg msg[2] = {
 		/* first write slave position to i2c devices */
-		{ client->addr, 0, 1, &cmd },
+		{ .addr = client->addr, .flags = 0, .len = 1, .buf = &cmd },
 		/* Second read data from position */
-		{ client->addr, I2C_M_RD, len, data }
+		{ .addr = client->addr, .flags = I2C_M_RD, .len = len, .buf = data }
 	};
 
 	ret = i2c_transfer(client->adapter, msg, 2);
-- 
1.7.5.4


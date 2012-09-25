Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2IYLdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:33:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38890 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab2IYLde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:33:34 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        <akpm@linux-foundation.org>, <a.zummo@towertech.it>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 4/7] rtc: Convert struct i2c_msg initialization to C99 format
Date: Tue, 25 Sep 2012 17:02:03 +0530
Message-ID: <1348572726-6940-5-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348572726-6940-1-git-send-email-shubhrajyoti@ti.com>
References: <1348572726-6940-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the struct i2c_msg initialization to C99 format. This makes
maintaining and editing the code simpler. Also helps once other fields
like transferred are added in future.
while at it also fix a checkpatch warn
WARNING: sizeof rs5c->buf should be sizeof(rs5c->buf)

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/rtc/rtc-rs5c372.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index fb4842c..76f565a 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -104,7 +104,12 @@ static int rs5c_get_regs(struct rs5c372 *rs5c)
 {
 	struct i2c_client	*client = rs5c->client;
 	struct i2c_msg		msgs[] = {
-		{ client->addr, I2C_M_RD, sizeof rs5c->buf, rs5c->buf },
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = sizeof(rs5c->buf),
+			.buf = rs5c->buf
+		},
 	};
 
 	/* This implements the third reading method from the datasheet, using
-- 
1.7.5.4


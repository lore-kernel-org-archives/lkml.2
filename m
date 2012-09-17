Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2IQN6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:58:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39548 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab2IQN6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:58:33 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 5/7] rtc: Convert struct i2c_msg initialization to C99 format
Date: Mon, 17 Sep 2012 19:28:12 +0530
Message-ID: <1347890294-28467-6-git-send-email-shubhrajyoti@ti.com>
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
 drivers/rtc/rtc-rs5c372.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index fb4842c..68e6332 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -104,7 +104,7 @@ static int rs5c_get_regs(struct rs5c372 *rs5c)
 {
 	struct i2c_client	*client = rs5c->client;
 	struct i2c_msg		msgs[] = {
-		{ client->addr, I2C_M_RD, sizeof rs5c->buf, rs5c->buf },
+		{ .addr = client->addr, .flags = I2C_M_RD, .len = sizeof rs5c->buf, .buf = rs5c->buf },
 	};
 
 	/* This implements the third reading method from the datasheet, using
-- 
1.7.5.4


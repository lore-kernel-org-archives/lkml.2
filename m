Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab2IRMW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:22:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52582 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939Ab2IRMWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:22:55 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv4 2/6] media: Convert struct i2c_msg initialization to C99 format
Date: Tue, 18 Sep 2012 17:52:32 +0530
Message-ID: <1347970956-11158-3-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347970956-11158-1-git-send-email-shubhrajyoti@ti.com>
References: <1347970956-11158-1-git-send-email-shubhrajyoti@ti.com>
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
 drivers/media/i2c/tvaudio.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index 321b315..f74a3f9 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -217,8 +217,17 @@ static int chip_read2(struct CHIPSTATE *chip, int subaddr)
 	unsigned char write[1];
 	unsigned char read[1];
 	struct i2c_msg msgs[2] = {
-		{ c->addr, 0,        1, write },
-		{ c->addr, I2C_M_RD, 1, read  }
+		{
+			.addr = c->addr,
+			.len = 1,
+			.buf = write
+		},
+		{
+			.addr = c->addr,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = read
+		}
 	};
 
 	write[0] = subaddr;
-- 
1.7.5.4


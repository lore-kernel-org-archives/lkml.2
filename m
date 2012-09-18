Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab2IRJws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:52:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36303 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757708Ab2IRJvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:51:05 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv2 2/6] media: Convert struct i2c_msg initialization to C99 format
Date: Tue, 18 Sep 2012 15:20:39 +0530
Message-ID: <1347961843-9376-3-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347961843-9376-1-git-send-email-shubhrajyoti@ti.com>
References: <1347961843-9376-1-git-send-email-shubhrajyoti@ti.com>
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
 drivers/media/i2c/tvaudio.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index 321b315..c9c1da3 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -217,8 +217,18 @@ static int chip_read2(struct CHIPSTATE *chip, int subaddr)
 	unsigned char write[1];
 	unsigned char read[1];
 	struct i2c_msg msgs[2] = {
-		{ c->addr, 0,        1, write },
-		{ c->addr, I2C_M_RD, 1, read  }
+		{
+			.addr = c->addr,
+			.flags = 0,
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


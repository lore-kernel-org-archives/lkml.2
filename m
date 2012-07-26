Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2GZQnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:43:43 -0400
Received: from mail.tpi.com ([70.99.223.143]:1880 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab2GZQnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:43:42 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] cx25840: Declare MODULE_FIRMWARE usage
Date: Thu, 26 Jul 2012 10:44:19 -0600
Message-Id: <1343321059-124171-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/video/cx25840/cx25840-firmware.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-firmware.c b/drivers/media/video/cx25840/cx25840-firmware.c
index 8150200..b3169f9 100644
--- a/drivers/media/video/cx25840/cx25840-firmware.c
+++ b/drivers/media/video/cx25840/cx25840-firmware.c
@@ -61,6 +61,10 @@ static void end_fw_load(struct i2c_client *client)
 	cx25840_write(client, 0x803, 0x03);
 }
 
+#define CX2388x_FIRMWARE "v4l-cx23885-avcore-01.fw"
+#define CX231xx_FIRMWARE "v4l-cx231xx-avcore-01.fw"
+#define CX25840_FIRMWARE "v4l-cx25840.fw"
+
 static const char *get_fw_name(struct i2c_client *client)
 {
 	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
@@ -68,10 +72,10 @@ static const char *get_fw_name(struct i2c_client *client)
 	if (firmware[0])
 		return firmware;
 	if (is_cx2388x(state))
-		return "v4l-cx23885-avcore-01.fw";
+		return CX2388x_FIRMWARE;
 	if (is_cx231xx(state))
-		return "v4l-cx231xx-avcore-01.fw";
-	return "v4l-cx25840.fw";
+		return CX231xx_FIRMWARE;
+	return CX25840_FIRMWARE;
 }
 
 static int check_fw_load(struct i2c_client *client, int size)
@@ -164,3 +168,8 @@ int cx25840_loadfw(struct i2c_client *client)
 
 	return check_fw_load(client, size);
 }
+
+MODULE_FIRMWARE(CX2388x_FIRMWARE);
+MODULE_FIRMWARE(CX231xx_FIRMWARE);
+MODULE_FIRMWARE(CX25840_FIRMWARE);
+
-- 
1.7.9.5


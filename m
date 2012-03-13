Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab2CMMIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:08:41 -0400
Received: from mail-gx0-f202.google.com ([209.85.161.202]:51938 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2CMMEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:04:31 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 10/20] Input: atmel_mxt_ts - dump each message on just 1 line
Date: Tue, 13 Mar 2012 20:04:13 +0800
Message-Id: <1331640263-18935-11-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helps ensure all bytes for a single message together in the system log.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 309761a..ac8c50a 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -325,16 +325,12 @@ static bool mxt_object_writable(unsigned int type)
 }
 
 static void mxt_dump_message(struct device *dev,
-				  struct mxt_message *message)
+			     struct mxt_message *message)
 {
-	dev_dbg(dev, "reportid:\t0x%x\n", message->reportid);
-	dev_dbg(dev, "message1:\t0x%x\n", message->message[0]);
-	dev_dbg(dev, "message2:\t0x%x\n", message->message[1]);
-	dev_dbg(dev, "message3:\t0x%x\n", message->message[2]);
-	dev_dbg(dev, "message4:\t0x%x\n", message->message[3]);
-	dev_dbg(dev, "message5:\t0x%x\n", message->message[4]);
-	dev_dbg(dev, "message6:\t0x%x\n", message->message[5]);
-	dev_dbg(dev, "message7:\t0x%x\n", message->message[6]);
+	dev_dbg(dev, "reportid: %u\tmessage: %02x %02x %02x %02x %02x %02x %02x\n",
+		message->reportid, message->message[0], message->message[1],
+		message->message[2], message->message[3], message->message[4],
+		message->message[5], message->message[6]);
 }
 
 static int mxt_check_bootloader(struct i2c_client *client,
-- 
1.7.7.3


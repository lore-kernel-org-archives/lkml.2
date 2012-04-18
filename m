Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2DRNYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:24:38 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58338 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2DRNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:22:04 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 06/14 v3] Input: atmel_mxt_ts - dump each message on just 1 line
Date: Wed, 18 Apr 2012 21:21:51 +0800
Message-Id: <1334755319-21365-7-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helps ensure all bytes for a single message together in the system log.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
Acked-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 26dee8b..21957d0 100644
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


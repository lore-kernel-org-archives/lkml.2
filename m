Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2DRNWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:22:12 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:62894 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab2DRNWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:22:03 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 05/14 v3] Input: atmel_mxt_ts - do not read extra (checksum) byte
Date: Wed, 18 Apr 2012 21:21:50 +0800
Message-Id: <1334755319-21365-6-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atmel_mxt devices will send a checksum byte at the end of a message if
the MSB of the object address is set.
However, since this driver does not set this bit, the checksum byte
isn't actually sent, so don't even try to read it.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 1d0639d..26dee8b 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -236,7 +236,6 @@ struct mxt_object {
 struct mxt_message {
 	u8 reportid;
 	u8 message[7];
-	u8 checksum;
 };
 
 struct mxt_finger {
@@ -336,7 +335,6 @@ static void mxt_dump_message(struct device *dev,
 	dev_dbg(dev, "message5:\t0x%x\n", message->message[4]);
 	dev_dbg(dev, "message6:\t0x%x\n", message->message[5]);
 	dev_dbg(dev, "message7:\t0x%x\n", message->message[6]);
-	dev_dbg(dev, "checksum:\t0x%x\n", message->checksum);
 }
 
 static int mxt_check_bootloader(struct i2c_client *client,
-- 
1.7.7.3


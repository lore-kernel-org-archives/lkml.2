Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2CMMGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:06:05 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44393 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2CMMEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:04:32 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 09/20] Input: atmel_mxt_ts - do not read extra (checksum) byte
Date: Tue, 13 Mar 2012 20:04:12 +0800
Message-Id: <1331640263-18935-10-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't sent, nor checked anyway, so don't bother reading it.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index c422fad..309761a 100644
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


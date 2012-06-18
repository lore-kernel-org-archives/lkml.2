Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2FREJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:09:15 -0400
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:63437 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911Ab2FREIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:08:50 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 18/22 v4] Input: atmel_mxt_ts - add detail to touchevent debug message
Date: Mon, 18 Jun 2012 12:08:38 +0800
Message-Id: <1339992522-22073-19-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the debug message:
 * print inidividual status bits
 * print the pressure value
 * use '%u' for unsigned quantities

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 02ff914..d71ecf0 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -195,6 +195,7 @@
 #define MXT_BOOT_STATUS_MASK	0x3f
 
 /* Touch status */
+#define MXT_UNGRIP		(1 << 0)
 #define MXT_SUPPRESS		(1 << 1)
 #define MXT_AMP			(1 << 2)
 #define MXT_VECTOR		(1 << 3)
@@ -524,9 +525,19 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	area = message->message[4];
 	pressure = message->message[5];
 
-	dev_dbg(dev, "[%d] %s x: %d, y: %d, area: %d\n", id,
-		status & MXT_MOVE ? "moved" : "pressed",
-		x, y, area);
+	dev_dbg(dev,
+		"[%u] %c%c%c%c%c%c%c%c x: %5u y: %5u area: %3u amp: %3u\n",
+		id,
+		(status & MXT_DETECT) ? 'D' : '.',
+		(status & MXT_PRESS) ? 'P' : '.',
+		(status & MXT_RELEASE) ? 'R' : '.',
+		(status & MXT_MOVE) ? 'M' : '.',
+		(status & MXT_VECTOR) ? 'V' : '.',
+		(status & MXT_AMP) ? 'A' : '.',
+		(status & MXT_SUPPRESS) ? 'S' : '.',
+		(status & MXT_UNGRIP) ? 'U' : '.',
+		x, y, area, pressure);
+
 	input_mt_slot(input_dev, id);
 	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
 				   status & MXT_DETECT);
-- 
1.7.7.3


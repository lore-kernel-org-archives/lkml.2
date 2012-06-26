Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab2FZG6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:58:19 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59326 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457Ab2FZG5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:57:21 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 17/21 v5] Input: atmel_mxt_ts - add detail to touchevent debug message
Date: Tue, 26 Jun 2012 14:57:05 +0800
Message-Id: <1340693829-18665-18-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
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
index c4e6747..7b042e5 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -195,6 +195,7 @@
 #define MXT_BOOT_STATUS_MASK	0x3f
 
 /* Touch status */
+#define MXT_UNGRIP		(1 << 0)
 #define MXT_SUPPRESS		(1 << 1)
 #define MXT_AMP			(1 << 2)
 #define MXT_VECTOR		(1 << 3)
@@ -530,9 +531,19 @@ static void mxt_input_touchevent(struct mxt_data *data,
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


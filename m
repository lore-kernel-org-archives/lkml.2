Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab0KIM6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:58:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60582 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0KIM6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:58:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZQna/kMpfpuL+zEr7TI63fqvUez7WQ3GQnz+e6UzTzH/aMf2vNQbpQjlvrIkix/kbS
         OHNeeY705v6ox+pJ/MPfvoX5oLQIuCyXkfUQ6KV1bYLg7f6mfB/XwN2t4OlrjHIDFFhv
         1tauYNGP+ocQ1yNUsCj7zKPsP9qMXJn5/VthU=
From: Marek Belisko <marek.belisko@gmail.com>
To: Vincent Sanders <support@simtec.co.uk>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] input: touchscreen: s3c2410: Add ABS_PRESSURE event sending.
Date: Tue,  9 Nov 2010 14:00:16 +0100
Message-Id: <1289307616-10336-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add sending of event ABS_PRESSURE for
s3c24xx touchscreen.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/input/touchscreen/s3c2410_ts.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/s3c2410_ts.c b/drivers/input/touchscreen/s3c2410_ts.c
index 8feb7f3..a937105 100644
--- a/drivers/input/touchscreen/s3c2410_ts.c
+++ b/drivers/input/touchscreen/s3c2410_ts.c
@@ -126,6 +126,7 @@ static void touch_timer_fire(unsigned long data)
 			input_report_abs(ts.input, ABS_Y, ts.yp);
 
 			input_report_key(ts.input, BTN_TOUCH, 1);
+			input_report_abs(ts.input, ABS_PRESSURE, 1);
 			input_sync(ts.input);
 
 			ts.xp = 0;
@@ -140,6 +141,7 @@ static void touch_timer_fire(unsigned long data)
 		ts.count = 0;
 
 		input_report_key(ts.input, BTN_TOUCH, 0);
+		input_report_abs(ts.input, ABS_PRESSURE, 0);
 		input_sync(ts.input);
 
 		writel(WAIT4INT | INT_DOWN, ts.io + S3C2410_ADCTSC);
@@ -314,10 +316,12 @@ static int __devinit s3c2410ts_probe(struct platform_device *pdev)
 	}
 
 	ts.input = input_dev;
-	ts.input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	ts.input->evbit[0] = BIT_MASK(EV_SYN) | BIT_MASK(EV_KEY) |
+				BIT_MASK(EV_ABS);
 	ts.input->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(ts.input, ABS_X, 0, 0x3FF, 0, 0);
 	input_set_abs_params(ts.input, ABS_Y, 0, 0x3FF, 0, 0);
+	input_set_abs_params(ts.input, ABS_PRESSURE, 0, 1, 0, 0);
 
 	ts.input->name = "S3C24XX TouchScreen";
 	ts.input->id.bustype = BUS_HOST;
-- 
1.7.1


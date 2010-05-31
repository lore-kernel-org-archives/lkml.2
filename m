Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab0EaRw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:52:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60478 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754942Ab0EaRwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:52:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] input: Tone down logging from S3C touchscreen driver
Date: Mon, 31 May 2010 18:52:51 +0100
Message-Id: <1275328371-32066-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The S3C touchscreen driver is logging at LOG_INFO on every stylus up
event which spams the console needlessly.  Reduce the priority of the
message to debug level for some peace and quiet.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/input/touchscreen/s3c2410_ts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/s3c2410_ts.c b/drivers/input/touchscreen/s3c2410_ts.c
index ac5d0f9..6085d12 100644
--- a/drivers/input/touchscreen/s3c2410_ts.c
+++ b/drivers/input/touchscreen/s3c2410_ts.c
@@ -173,7 +173,7 @@ static irqreturn_t stylus_irq(int irq, void *dev_id)
 	if (down)
 		s3c_adc_start(ts.client, 0, 1 << ts.shift);
 	else
-		dev_info(ts.dev, "%s: count=%d\n", __func__, ts.count);
+		dev_dbg(ts.dev, "%s: count=%d\n", __func__, ts.count);
 
 	if (ts.features & FEAT_PEN_IRQ) {
 		/* Clear pen down/up interrupt */
-- 
1.7.1


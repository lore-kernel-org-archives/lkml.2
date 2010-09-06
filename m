Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab0IFGBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 02:01:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51410 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0IFGBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 02:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rAFSebtxhN89xGEncPywdOHRuhiSDfqqVOCG8z1pJv7Lgwh2LPRja2GI1pWl3V7y6u
         x/DGN8TD39TXxUbOUHBjMvMQiMhUaZGMipNpza5VHnHQ/dMvJ7B8eGhHn39Pd2p+5sGp
         ukhCE3FFWQoAO8eDfcQgguu08H14pfiHlzjI4=
Subject: [PATCH] regulator: wm8350-regulator - fix the logic of checking
	REGULATOR_MODE_STANDBY mode
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain
Date: Mon, 06 Sep 2010 14:06:07 +0800
Message-Id: <1283753167.19378.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In wm8350_dcdc_set_mode(), we set DCx_SLEEP bit of WM8350_DCDC_SLEEP_OPTIONS
register for REGULATOR_MODE_STANDBY mode.
( DCx_SLEEP bits: 0: Normal DC-DC operation 1: Select LDO mode )

In wm8350_dcdc_get_mode(), current logic to determinate
REGULATOR_MODE_STANDBY mode is just reverse.
( sleep is set should mean REGULATOR_MODE_STANDBY mode. )

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 0e6ed7d..fe4b8a8 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1129,7 +1129,7 @@ static unsigned int wm8350_dcdc_get_mode(struct regulator_dev *rdev)
 			mode = REGULATOR_MODE_NORMAL;
 	} else if (!active && !sleep)
 		mode = REGULATOR_MODE_IDLE;
-	else if (!sleep)
+	else if (sleep)
 		mode = REGULATOR_MODE_STANDBY;
 
 	return mode;
-- 
1.7.2




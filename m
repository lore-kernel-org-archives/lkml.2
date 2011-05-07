Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1EGVCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 17:02:46 -0400
Received: from mail.df.lth.se ([194.47.250.12]:16232 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632Ab1EGVCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 17:02:45 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Johan Palsson <johan.palsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3] mfd/ab8500-gpadc: corrected the name and bitmask for BTempPullUp
Date: Sun,  8 May 2011 00:55:43 +0200
Message-Id: <1304808943-12770-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Palsson <johan.palsson@stericsson.com>

The bitmask for enabling the BatTemp pull-up was wrong and
is corrected. The name is also changed to be inline with
the AB8500 register description

Signed-off-by: Johan Palsson <johan.palsson@stericsson.com>
Reviewed-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 82708c1..f16afb2 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -57,7 +57,7 @@
 #define SW_AVG_16			0x60
 #define ADC_SW_CONV			0x04
 #define EN_ICHAR			0x80
-#define BATTEMP_PULLUP			0x04
+#define BTEMP_PULL_UP			0x08
 #define EN_BUF				0x40
 #define DIS_ZERO			0x00
 #define GPADC_BUSY			0x01
@@ -306,8 +306,8 @@ int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 			ret = abx500_mask_and_set_register_interruptible(
 				gpadc->dev,
 				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-				EN_BUF | BATTEMP_PULLUP,
-				EN_BUF | BATTEMP_PULLUP);
+				EN_BUF | BTEMP_PULL_UP,
+				EN_BUF | BTEMP_PULL_UP);
 
 		 /*
 		  * Delay might be needed for ABB8500 cut 3.0, if not, remove
-- 
1.7.5


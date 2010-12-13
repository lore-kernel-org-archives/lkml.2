Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0LMEEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 23:04:08 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:58864 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754985Ab0LMEEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 23:04:06 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, Sundar Iyer <sundar.iyer@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v2 7/8] mfd/tc3589x: undo gpio module reset during chip init
Date: Mon, 13 Dec 2010 09:33:17 +0530
Message-ID: <1292212998-13066-8-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
References: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip putting the GPIO module into a reset during the chip init.  This makes
sure to preserve any existing GPIO configurations done by pre-kernel boot code.

Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/mfd/tc3589x.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 708349a..f000d2e 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -231,12 +231,15 @@ static int tc3589x_chip_init(struct tc3589x *tc3589x)
 
 	dev_info(tc3589x->dev, "manufacturer: %#x, version: %#x\n", manf, ver);
 
-	/* Put everything except the IRQ module into reset */
+	/*
+	 * Put everything except the IRQ module into reset;
+	 * also spare the GPIO module for any pin initialization
+	 * done during pre-kernel boot
+	 */
 	ret = tc3589x_reg_write(tc3589x, TC3589x_RSTCTRL,
 				TC3589x_RSTCTRL_TIMRST
 				| TC3589x_RSTCTRL_ROTRST
-				| TC3589x_RSTCTRL_KBDRST
-				| TC3589x_RSTCTRL_GPIRST);
+				| TC3589x_RSTCTRL_KBDRST);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.2.dirty


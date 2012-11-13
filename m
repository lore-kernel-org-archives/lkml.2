Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab2KMJik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:38:40 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44752 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab2KMJij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:38:39 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dtor@mail.ru>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] input: twl4030-pwrbutton: Change TWL4030_MODULE_PM_MASTER to TWL_MODULE_PM_MASTER
Date: Tue, 13 Nov 2012 10:38:28 +0100
Message-ID: <1352799508-22212-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To facilitate upcoming cleanup in twl stack.
No functional changes.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/input/misc/twl4030-pwrbutton.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index b3dd96d..27c2bc8 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -39,8 +39,7 @@ static irqreturn_t powerbutton_irq(int irq, void *_pwr)
 	int err;
 	u8 value;
 
-	err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
-				STS_HW_CONDITIONS);
+	err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &value, STS_HW_CONDITIONS);
 	if (!err)  {
 		pm_wakeup_event(pwr->dev.parent, 0);
 		input_report_key(pwr, KEY_POWER, value & PWR_PWRON_IRQ);
-- 
1.8.0


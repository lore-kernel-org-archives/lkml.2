Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab2IYQPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:15:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57024 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086Ab2IYQOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:22 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 55/57] power: ab8500_charger: Add UsbLineCtrl2 reference
Date: Tue, 25 Sep 2012 10:12:52 -0600
Message-Id: <1348589574-25655-56-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

When the state of USB Charge detection is changed then the calls
use a define for another register in other bank. This change
creates a new define for the correct register and removes the
magic numbers that are present.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>

Conflicts:

	drivers/power/ab8500_charger.c
---
 drivers/power/ab8500_charger.c       |   11 +++++------
 include/linux/mfd/abx500/ab8500-bm.h |    1 +
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 7f8f362..afb4fda 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -51,6 +51,7 @@
 #define VBUS_DET_DBNC1			0x01
 #define OTP_ENABLE_WD			0x01
 #define DROP_COUNT_RESET		0x01
+#define USB_CH_DET			0x01
 
 #define MAIN_CH_INPUT_CURR_SHIFT	4
 #define VBUS_IN_CURR_LIM_SHIFT		4
@@ -2287,9 +2288,8 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 					USB_CH_ENA, USB_CH_ENA);
 			/*Enable charger detection*/
 			abx500_mask_and_set_register_interruptible(di->dev,
-						AB8500_USB,
-						AB8500_MCH_IPT_CURLVL_REG,
-						0x01, 0x01);
+					AB8500_USB, AB8500_USB_LINE_CTRL2_REG,
+					USB_CH_DET, USB_CH_DET);
 			di->invalid_charger_detect_state = 1;
 			/*exit and wait for new link status interrupt.*/
 			return;
@@ -2300,9 +2300,8 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 				"Invalid charger detected, state= 1\n");
 			/*Stop charger detection*/
 			abx500_mask_and_set_register_interruptible(di->dev,
-						AB8500_USB,
-						AB8500_MCH_IPT_CURLVL_REG,
-						0x01, 0x00);
+					AB8500_USB, AB8500_USB_LINE_CTRL2_REG,
+					USB_CH_DET, 0x00);
 			/*Check link status*/
 			if (is_ab8500(di->parent))
 				ret = abx500_get_register_interruptible(di->dev,
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 721bd6d..6b69ad5 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -23,6 +23,7 @@
  * Bank : 0x5
  */
 #define AB8500_USB_LINE_STAT_REG	0x80
+#define AB8500_USB_LINE_CTRL2_REG	0x82
 #define AB8500_USB_LINK1_STAT_REG	0x94
 
 /*
-- 
1.7.5.4


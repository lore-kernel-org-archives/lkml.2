Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab1AUN0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:26:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42554 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753002Ab1AUN0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:26:50 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmciro.com>
Subject: [PATCH v2] mfd: Support configuration of WM831x /IRQ output in CMOS mode
Date: Fri, 21 Jan 2011 13:26:46 +0000
Message-Id: <1295616406-3061-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmciro.com>

Provide platform data allowing the system to set the /IRQ pin into
CMOS mode rather than the default open drain. The default value of
this platform data reflects the default hardware configuration so
there should be no change to existing users.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmciro.com>
---
 drivers/mfd/wm831x-irq.c         |    8 ++++++++
 include/linux/mfd/wm831x/pdata.h |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 2691648..90ad3fa 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -520,6 +520,14 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 		return 0;
 	}
 
+	if (pdata->irq_cmos)
+		i = 0;
+	else
+		i = WM831X_IRQ_OD;
+
+	wm831x_set_bits(wm831x, WM831X_IRQ_CONFIG,
+			WM831X_IRQ_OD, i);
+
 	/* Try to flag /IRQ as a wake source; there are a number of
 	 * unconditional wake sources in the PMIC so this isn't
 	 * conditional but we don't actually care *too* much if it
diff --git a/include/linux/mfd/wm831x/pdata.h b/include/linux/mfd/wm831x/pdata.h
index fd322ac..1ae8499 100644
--- a/include/linux/mfd/wm831x/pdata.h
+++ b/include/linux/mfd/wm831x/pdata.h
@@ -108,6 +108,9 @@ struct wm831x_pdata {
 	/** Called after subdevices are set up */
 	int (*post_init)(struct wm831x *wm831x);
 
+	/** Put the /IRQ line into CMOS mode */
+	bool irq_cmos;
+
 	int irq_base;
 	int gpio_base;
 	struct wm831x_backlight_pdata *backlight;
-- 
1.7.2.3


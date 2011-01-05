Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab1AER5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:57:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37128 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751257Ab1AER5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:57:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Flag WM831x /IRQ as a wake source
Date: Wed,  5 Jan 2011 17:56:01 +0000
Message-Id: <1294250161-10307-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x can generate wake events, some unconditionally, so flag
the primary IRQ as a wake source in order to help the CPU treat the
/IRQ signal appropriately.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index ee88f6a..f7192d4 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -517,6 +517,17 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 		return 0;
 	}
 
+	/* Try to flag /IRQ as a wake source; there are a number of
+	 * unconditional wake sources in the PMIC so this isn't
+	 * conditional but we don't actually care *too* much if it
+	 * fails.
+	 */
+	ret = enable_irq_wake(irq);
+	if (ret != 0) {
+		dev_warn(wm831x->dev, "Can't enable IRQ as wake source: %d\n",
+			 ret);
+	}
+
 	wm831x->irq = irq;
 	wm831x->irq_base = pdata->irq_base;
 
-- 
1.7.2.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab1ANNi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 08:38:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59958 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757147Ab1ANNiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:38:23 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Leave acknowledgement of WM831x touchscreen IRQs to the driver
Date: Fri, 14 Jan 2011 13:38:16 +0000
Message-Id: <1295012296-21716-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x touchscreen interrupts need acknowledgement even when using
direct signals to the CPU (which don't go through the core) so leave
the acknowledgement up to the touchscreen driver for simplicity.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 0d3cda4..2f26f80 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -481,6 +481,9 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 	}
 
 out:
+	/* Touchscreen interrupts are handled specially in the driver */
+	status_regs[0] &= ~(WM831X_TCHDATA_EINT | WM831X_TCHPD_EINT);
+
 	for (i = 0; i < ARRAY_SIZE(status_regs); i++) {
 		if (status_regs[i])
 			wm831x_reg_write(wm831x, WM831X_INTERRUPT_STATUS_1 + i,
-- 
1.7.2.3


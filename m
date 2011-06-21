Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab1FUXXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:23:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35816 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752125Ab1FUXXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:23:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Fix off by one in WM831x IRQ code
Date: Wed, 22 Jun 2011 00:23:08 +0100
Message-Id: <1308698588-16988-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

The GPIO IRQs aren't the first IRQs defined, we need to subtract the base
for the GPIOs as well to use them for array indexes.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 1808deb..6c3408c 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -408,6 +408,11 @@ static int wm831x_irq_set_type(struct irq_data *data, unsigned int type)
 			return -EINVAL;
 	}
 
+	/* Rebase the IRQ into the GPIO range so we've got a sensible array
+	 * index.
+	 */
+	irq -= WM831X_IRQ_GPIO_1;
+
 	/* We set the high bit to flag that we need an update; don't
 	 * do the update here as we can be called with the bus lock
 	 * held.
-- 
1.7.5.4


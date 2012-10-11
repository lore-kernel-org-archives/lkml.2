Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab2JKLzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:55:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47007 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab2JKLzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:55:41 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <peter.ujfalusi@ti.com>
Subject: [PATCH 2/6] MFD: twl6040: Remove unused parameter for twl6040_power_up_completion()
Date: Thu, 11 Oct 2012 13:55:29 +0200
Message-ID: <1349956533-6374-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
References: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

naudint parameter has not been used, remove it.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index b220aa2..a46d987 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -218,8 +218,7 @@ static irqreturn_t twl6040_naudint_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int twl6040_power_up_completion(struct twl6040 *twl6040,
-				       int naudint)
+static int twl6040_power_up_completion(struct twl6040 *twl6040)
 {
 	int time_left;
 	u8 intid;
@@ -241,7 +240,6 @@ static int twl6040_power_up_completion(struct twl6040 *twl6040,
 int twl6040_power(struct twl6040 *twl6040, int on)
 {
 	int audpwron = twl6040->audpwron;
-	int naudint = twl6040->irq;
 	int ret = 0;
 
 	mutex_lock(&twl6040->mutex);
@@ -255,7 +253,7 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 			/* use AUDPWRON line */
 			gpio_set_value(audpwron, 1);
 			/* wait for power-up completion */
-			ret = twl6040_power_up_completion(twl6040, naudint);
+			ret = twl6040_power_up_completion(twl6040);
 			if (ret) {
 				dev_err(twl6040->dev,
 					"automatic power-up failed\n");
-- 
1.7.12


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2GPJu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:50:26 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:41500 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580Ab2GPJuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:50:05 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 2/2] MFD: twl6040: Add support for twl6041
Date: Mon, 16 Jul 2012 11:49:44 +0200
Message-Id: <1342432184-12046-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1342432184-12046-1-git-send-email-peter.ujfalusi@ti.com>
References: <1342432184-12046-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The delta between twl6040 and twl6041 is small, the main difference is in
the number of GPOs (3 on twl6040, 1 on twl6041).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 Documentation/devicetree/bindings/mfd/twl6040.txt |    2 +-
 drivers/mfd/twl6040-core.c                        |    1 +
 include/linux/mfd/twl6040.h                       |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/twl6040.txt b/Documentation/devicetree/bindings/mfd/twl6040.txt
index bc67c6f..c855240 100644
--- a/Documentation/devicetree/bindings/mfd/twl6040.txt
+++ b/Documentation/devicetree/bindings/mfd/twl6040.txt
@@ -6,7 +6,7 @@ They are connected ot the host processor via i2c for commands, McPDM for audio
 data and commands.
 
 Required properties:
-- compatible : Must be "ti,twl6040";
+- compatible : "ti,twl6040" for twl6040, "ti,twl6041" for twl6041
 - reg: must be 0x4b for i2c address
 - interrupts: twl6040 has one interrupt line connecteded to the main SoC
 - interrupt-parent: The parent interrupt controller
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 4ded9e7..8b4c03b 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -696,6 +696,7 @@ static int __devexit twl6040_remove(struct i2c_client *client)
 
 static const struct i2c_device_id twl6040_i2c_id[] = {
 	{ "twl6040", 0, },
+	{ "twl6041", 0, },
 	{ },
 };
 MODULE_DEVICE_TABLE(i2c, twl6040_i2c_id);
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index e002097..761c99c 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -163,6 +163,7 @@
 #define TWL6040_REV_ES1_0		0x00
 #define TWL6040_REV_ES1_1		0x01 /* Rev ES1.1 and ES1.2 */
 #define TWL6040_REV_ES1_3		0x02
+#define TWL6041_REV_ES2_0		0x10
 
 #define TWL6040_IRQ_TH			0
 #define TWL6040_IRQ_PLUG		1
-- 
1.7.8.6


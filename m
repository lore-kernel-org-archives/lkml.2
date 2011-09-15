Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786Ab1IONBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:01:50 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:60925 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933682Ab1IOM75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:59:57 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
Subject: [PATCH 3/8] MFD: twl6040: function to query the vibra status for clients
Date: Thu, 15 Sep 2011 15:59:16 +0300
Message-Id: <1316091561-30899-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the client only interested, if any of the vibra channels enabled, or
if any of the channels are set to receive audio data via PDM.

This function targets mainly the vibra driver, so it can check if it is
allowed to execute effects ot not.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c  |   12 ++++++++++++
 include/linux/mfd/twl6040.h |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 75987c8..268f80f 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -444,6 +444,18 @@ unsigned int twl6040_get_sysclk(struct twl6040 *twl6040)
 }
 EXPORT_SYMBOL(twl6040_get_sysclk);
 
+/* Get the combined status of the vibra control register */
+int twl6040_get_vibralr_status(struct twl6040 *twl6040)
+{
+	u8 status;
+
+	status = twl6040->vibra_ctrl_cache[0] | twl6040->vibra_ctrl_cache[1];
+	status &= (TWL6040_VIBENA | TWL6040_VIBSEL);
+
+	return status;
+}
+EXPORT_SYMBOL(twl6040_get_vibralr_status);
+
 static struct resource twl6040_vibra_rsrc[] = {
 	{
 		.flags = IORESOURCE_IRQ,
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 3ec9591..2463c261 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -210,10 +210,13 @@ int twl6040_get_pll(struct twl6040 *twl6040);
 unsigned int twl6040_get_sysclk(struct twl6040 *twl6040);
 int twl6040_irq_init(struct twl6040 *twl6040);
 void twl6040_irq_exit(struct twl6040 *twl6040);
+/* Get the combined status of the vibra control register */
+int twl6040_get_vibralr_status(struct twl6040 *twl6040);
 
 static inline int twl6040_get_revid(struct twl6040 *twl6040)
 {
 	return twl6040->rev;
 }
 
+
 #endif  /* End of __TWL6040_CODEC_H__ */
-- 
1.7.6.1


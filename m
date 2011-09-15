Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1IOMkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:40:40 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:41600 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933504Ab1IOMkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:13 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 02/17] MFD: twl6040: Add accessor for revision ID
Date: Thu, 15 Sep 2011 15:39:24 +0300
Message-Id: <1316090379-30760-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For client driver to use, if they need chip resvision information.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c  |    2 +-
 include/linux/mfd/twl6040.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index b0519e6..51c3b47 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -491,7 +491,7 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	}
 
 	/* ERRATA: Automatic power-up is not possible in ES1.0 */
-	if (twl6040->rev == TWL6040_REV_ES1_0)
+	if (twl6040_get_revid(twl6040) == TWL6040_REV_ES1_0)
 		twl6040->audpwron = -EINVAL;
 
 	/* codec interrupt */
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 4c806f6..cb3b822 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -225,4 +225,9 @@ unsigned int twl6040_get_sysclk(struct twl6040 *twl6040);
 int twl6040_irq_init(struct twl6040 *twl6040);
 void twl6040_irq_exit(struct twl6040 *twl6040);
 
+static inline int twl6040_get_revid(struct twl6040 *twl6040)
+{
+	return twl6040->rev;
+}
+
 #endif  /* End of __TWL6040_CODEC_H__ */
-- 
1.7.6.1


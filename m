Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1IBPEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:04:15 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33200 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907Ab1IBPDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:03:39 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] MFD: twl6040: Add accessor for revision ID
Date: Fri,  2 Sep 2011 18:03:03 +0300
Message-Id: <1314975785-25081-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314975785-25081-1-git-send-email-peter.ujfalusi@ti.com>
References: <1314975785-25081-1-git-send-email-peter.ujfalusi@ti.com>
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


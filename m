Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab2J2LCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:02:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59472 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758543Ab2J2LCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:02:35 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] MFD: twl-core: Register twl4030-madc child only for twl4030 class
Date: Mon, 29 Oct 2012 12:02:31 +0100
Message-ID: <1351508551-30772-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl4030-madc driver can only handle twl4030 class MADC. The newer revisions
of twl does not have MADC, instead they have different IP called GPADC which
is not backward compatible.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
Hi Samuel,

When building the kernel to support OMAP3/4/5 we should only register the MADC
driver when we boot it on OMAP3 since twl60xx does not have MADC.

Regards,
Peter

 drivers/mfd/twl-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 4ae6423..2624668 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -646,7 +646,8 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 			return PTR_ERR(child);
 	}
 
-	if (IS_ENABLED(CONFIG_TWL4030_MADC) && pdata->madc) {
+	if (IS_ENABLED(CONFIG_TWL4030_MADC) && pdata->madc &&
+	    twl_class_is_4030()) {
 		child = add_child(2, "twl4030_madc",
 				pdata->madc, sizeof(*pdata->madc),
 				true, irq_base + MADC_INTR_OFFSET, 0);
-- 
1.7.12.4


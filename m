Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2BCLFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 06:05:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41030 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755938Ab2BCLFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 06:05:41 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Balaji T K <balajitk@ti.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: twl-core: Don't specify regulator consumers by struct device
Date: Fri,  3 Feb 2012 11:05:37 +0000
Message-Id: <1328267137-4816-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been deprecated for considerable time now and support has been
removed from the regulator API. dev_name should be used instead.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

I'll apply this to the regulator tree as it's thrown up issues due to
the removal of dev from regulator_consumer_supply - please let me know
if this is an issue, I can back it out easily enough.

 drivers/mfd/twl-core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index e04e04dd..8dcf70f 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -751,9 +751,9 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 
 		/* we need to connect regulators to this transceiver */
 		if (twl_has_regulator() && child) {
-			usb1v5.dev = child;
-			usb1v8.dev = child;
-			usb3v1.dev = child;
+			usb1v5.dev_name = dev_name(child);
+			usb1v8.dev_name = dev_name(child);
+			usb3v1.dev_name = dev_name(child);
 		}
 	}
 	if (twl_has_usb() && pdata->usb && twl_class_is_6030()) {
@@ -799,7 +799,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 			return PTR_ERR(child);
 		/* we need to connect regulators to this transceiver */
 		if (twl_has_regulator() && child)
-			usb3v3.dev = child;
+			usb3v3.dev_name = dev_name(child);
 	} else if (twl_has_regulator() && twl_class_is_6030()) {
 		if (features & TWL6025_SUBCLASS)
 			child = add_regulator(TWL6025_REG_LDOUSB,
-- 
1.7.9.rc1


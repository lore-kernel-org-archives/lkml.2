Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab1D0Jtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:49:47 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:52796 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab1D0Jtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:49:43 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 4/4] USB: TWL6025 allow different regulator name
Date: Wed, 27 Apr 2011 10:39:51 +0100
Message-Id: <1303897191-14792-5-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The twl6025 uses a different regulator for USB than the 6030 so select
the correct regulator name depending on the subclass of device.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/usb/otg/twl6030-usb.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
index 6e920de..3d82419 100644
--- a/drivers/usb/otg/twl6030-usb.c
+++ b/drivers/usb/otg/twl6030-usb.c
@@ -190,6 +190,12 @@ static int twl6030_phy_suspend(struct otg_transceiver *x, int suspend)
 
 static int twl6030_usb_ldo_init(struct twl6030_usb *twl)
 {
+	char *regulator_name;
+
+	if (twl_features() & TWL6025_SUBCLASS)
+		regulator_name = "ldousb";
+	else
+		regulator_name = "vusb";
 
 	/* Set to OTG_REV 1.3 and turn on the ID_WAKEUP_COMP */
 	twl6030_writeb(twl, TWL6030_MODULE_ID0 , 0x1, TWL6030_BACKUP_REG);
@@ -200,7 +206,7 @@ static int twl6030_usb_ldo_init(struct twl6030_usb *twl)
 	/* Program MISC2 register and set bit VUSB_IN_VBAT */
 	twl6030_writeb(twl, TWL6030_MODULE_ID0 , 0x10, TWL6030_MISC2);
 
-	twl->usb3v3 = regulator_get(twl->dev, "vusb");
+	twl->usb3v3 = regulator_get(twl->dev, regulator_name);
 	if (IS_ERR(twl->usb3v3))
 		return -ENODEV;
 
-- 
1.7.4.1


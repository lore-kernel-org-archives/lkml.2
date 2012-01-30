Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab2A3XNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:13:01 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:49114 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab2A3XMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:12:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEAB4jJ09bdWOb/2dsb2JhbABDr1yBcwEFViMQPxI5AxsGAYgRuGOLKgYBCwkIFBeDM14VDQKDSQSVGoVWjHw
X-IronPort-AV: E=Sophos;i="4.71,592,1320620400"; 
   d="scan'208";a="945795224"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2 8/8] staging: tidspbridge: use the driver name string
Date: Tue, 31 Jan 2012 00:12:24 +0100
Message-Id: <c68bb2140bc5a5e793b58b66b521050a2d543572.1327964066.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <cover.1327964066.git.vjaquez@igalia.com>
References: <cover.1327964066.git.vjaquez@igalia.com>
In-Reply-To: <cover.1327964066.git.vjaquez@igalia.com>
References: <cover.1327964066.git.vjaquez@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of assign it to a global variable which is not used anymore.
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 5f810b6..93fc862 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -52,7 +52,6 @@
 #endif
 
 /*  ----------------------------------- Globals */
-#define DRIVER_NAME  "DspBridge"
 #define DSPBRIDGE_VERSION	"0.3"
 s32 dsp_debug;
 
@@ -121,8 +120,6 @@ MODULE_AUTHOR("Texas Instruments");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DSPBRIDGE_VERSION);
 
-static char *driver_name = DRIVER_NAME;
-
 /*
  * This function is called when an application opens handle to the
  * bridge driver.
@@ -490,7 +487,7 @@ static int __devinit omap34_xx_bridge_probe(struct platform_device *pdev)
 		goto err1;
 
 	/* use 2.6 device model */
-	err = alloc_chrdev_region(&dev, 0, 1, driver_name);
+	err = alloc_chrdev_region(&dev, 0, 1, "DspBridge");
 	if (err) {
 		pr_err("%s: Can't get major %d\n", __func__, driver_major);
 		goto err1;
-- 
1.7.8.3


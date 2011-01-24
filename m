Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab1AXF4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 00:56:12 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:39854 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1AXF4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 00:56:11 -0500
From: Thomas Chou <thomas@wytron.com.tw>
To: Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        linux-input@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>,
        Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH v2] altera_ps2: Add devicetree support
Date: Mon, 24 Jan 2011 13:58:13 +0800
Message-Id: <1295848693-28472-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110117220415.GB17963@angua.secretlab.ca>
References: <20110117220415.GB17963@angua.secretlab.ca>
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Walter Goossens <waltergoossens@home.nl>

Signed-off-by: Walter Goossens <waltergoossens@home.nl>
Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
v2 use const and add compat version.

 drivers/input/serio/altera_ps2.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
index 7998560..63325ee 100644
--- a/drivers/input/serio/altera_ps2.c
+++ b/drivers/input/serio/altera_ps2.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 
 #define DRV_NAME "altera_ps2"
 
@@ -173,6 +174,12 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id altera_ps2_match[] = {
+	{ .compatible = "altr,ps2-1.0", },
+	{},
+}
+MODULE_DEVICE_TABLE(of, altera_ps2_match);
+
 /*
  * Our device driver structure
  */
@@ -182,6 +189,7 @@ static struct platform_driver altera_ps2_driver = {
 	.driver	= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = altera_ps2_match,
 	},
 };
 
@@ -189,13 +197,12 @@ static int __init altera_ps2_init(void)
 {
 	return platform_driver_register(&altera_ps2_driver);
 }
+module_init(altera_ps2_init);
 
 static void __exit altera_ps2_exit(void)
 {
 	platform_driver_unregister(&altera_ps2_driver);
 }
-
-module_init(altera_ps2_init);
 module_exit(altera_ps2_exit);
 
 MODULE_DESCRIPTION("Altera University Program PS2 controller driver");
-- 
1.7.3.4


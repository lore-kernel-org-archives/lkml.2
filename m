Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1AQG1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 01:27:38 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:60322 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1AQG1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 01:27:37 -0500
From: Thomas Chou <thomas@wytron.com.tw>
To: Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        linux-input@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>,
        Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH] alter_ps2: Add devicetree support
Date: Mon, 17 Jan 2011 14:29:20 +0800
Message-Id: <1295245760-4566-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4D040D1C.2020705@home.nl>
References: <4D040D1C.2020705@home.nl>
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
 drivers/input/serio/altera_ps2.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
index 7998560..93054a1 100644
--- a/drivers/input/serio/altera_ps2.c
+++ b/drivers/input/serio/altera_ps2.c
@@ -19,6 +19,9 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#ifdef CONFIG_OF
+#include <linux/of.h>
+#endif
 
 #define DRV_NAME "altera_ps2"
 
@@ -173,6 +176,16 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id altera_ps2_match[] = {
+	{ 
+		.compatible = "altera,altera_ps2",
+	},
+	{},
+}
+MODULE_DEVICE_TABLE(of, altera_jtaguart_match);
+#endif /* CONFIG_OF */
+
 /*
  * Our device driver structure
  */
@@ -182,6 +195,9 @@ static struct platform_driver altera_ps2_driver = {
 	.driver	= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
+#ifdef CONFIG_OF
+		.of_match_table = altera_ps2_match,
+#endif
 	},
 };
 
-- 
1.7.3.4


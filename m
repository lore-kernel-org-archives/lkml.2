Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab2IRSNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:13:33 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:56256 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082Ab2IRSMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:12:07 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Tony Lindgren <tony@atomide.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 2/3] OMAP i2c: pinctrl-ify i2c-omap.c
Date: Wed, 19 Sep 2012 19:07:20 +0300
Message-Id: <1348070841-23354-3-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348070841-23354-1-git-send-email-panto@antoniou-consulting.com>
References: <1348070841-23354-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for pinctrl mux settings in the OMAP I2C driver.
If no such pinctl bindings are found a warning message is printed.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/i2c/busses/i2c-omap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index b149e32..f722478 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -43,6 +43,8 @@
 #include <linux/slab.h>
 #include <linux/i2c-omap.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/err.h>
 
 /* I2C controller revisions */
 #define OMAP_I2C_OMAP1_REV_2		0x20
@@ -1057,6 +1059,7 @@ omap_i2c_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	int irq;
 	int r;
+	struct pinctrl *pinctrl;
 
 	/* NOTE: driver uses the static register mapping */
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1197,6 +1200,10 @@ omap_i2c_probe(struct platform_device *pdev)
 
 	of_i2c_register_devices(adap);
 
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(dev->dev, "pins are not configured from the driver\n");
+
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
 
-- 
1.7.12


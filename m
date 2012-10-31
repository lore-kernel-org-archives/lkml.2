Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123Ab2J3SMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:12:44 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59039 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965163Ab2J3SMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:41 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2012 14:12:40 EDT
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>
Subject: [PATCH] i2c: pinctrl-ify i2c-omap.c
Date: Wed, 31 Oct 2012 17:55:30 +0200
Message-Id: <1351698930-3797-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable pinctrl for i2c-omap.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/i2c/busses/i2c-omap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index db31eae..4c38aa0 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -44,6 +44,8 @@
 #include <linux/i2c-omap.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_qos.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/err.h>
 
 /* I2C controller revisions */
 #define OMAP_I2C_OMAP1_REV_2		0x20
@@ -1064,6 +1066,7 @@ omap_i2c_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	int irq;
 	int r;
+	struct pinctrl *pinctrl;
 
 	/* NOTE: driver uses the static register mapping */
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1202,6 +1205,13 @@ omap_i2c_probe(struct platform_device *pdev)
 
 	of_i2c_register_devices(adap);
 
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(dev->dev, "unable to select pin group\n");
+
+	dev_info(dev->dev, "bus %d rev%d.%d.%d at %d kHz\n", adap->nr,
+		 dev->dtrev, dev->rev >> 4, dev->rev & 0xf, dev->speed);
+
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
 
-- 
1.7.12


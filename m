Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2GRNU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:20:59 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:33232 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752928Ab2GRNU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:20:56 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 2/2] drivers/rtc/rtc-pcf8563.c: add device tree support.
Date: Wed, 18 Jul 2012 09:20:04 -0400
Message-Id: <1342617604-19516-2-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1342617604-19516-1-git-send-email-nbowler@elliptictech.com>
References: <1342617604-19516-1-git-send-email-nbowler@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the of_match_table for this driver so that devices can be described
in the device tree.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 drivers/rtc/rtc-pcf8563.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 24a9d6a..c2fe426 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -19,6 +19,7 @@
 #include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/of.h>
 
 #define DRV_VERSION "0.4.3"
 
@@ -285,10 +286,19 @@ static const struct i2c_device_id pcf8563_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, pcf8563_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id pcf8563_of_match[] __devinitconst = {
+	{ .compatible = "nxp,pcf8563" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, pcf8563_of_match);
+#endif
+
 static struct i2c_driver pcf8563_driver = {
 	.driver		= {
 		.name	= "rtc-pcf8563",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(pcf8563_of_match),
 	},
 	.probe		= pcf8563_probe,
 	.remove		= pcf8563_remove,
-- 
1.7.8.6



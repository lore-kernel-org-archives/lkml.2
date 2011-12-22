Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1LVO7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:59:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:32839 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab1LVO7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:59:12 -0500
From: Benoit Cousson <b-cousson@ti.com>
To: <rob.herring@calxeda.com>, <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux-i2c@vger.kernel.org>, <sameo@linux.intel.com>,
        <ben-linux@fluff.org>, Benoit Cousson <b-cousson@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH v4 04/12] rtc: rtc-twl: Add DT support for RTC inside twl4030/twl6030
Date: Thu, 22 Dec 2011 15:56:38 +0100
Message-ID: <1324565806-31142-5-git-send-email-b-cousson@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
References: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the DT support for the TI rtc-twl present in the twl4030
and twl6030 devices.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 Documentation/devicetree/bindings/rtc/twl-rtc.txt |   12 ++++++++++++
 drivers/rtc/rtc-twl.c                             |   10 ++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/twl-rtc.txt

diff --git a/Documentation/devicetree/bindings/rtc/twl-rtc.txt b/Documentation/devicetree/bindings/rtc/twl-rtc.txt
new file mode 100644
index 0000000..596e0c9
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/twl-rtc.txt
@@ -0,0 +1,12 @@
+* TI twl RTC
+
+The TWL family (twl4030/6030) contains a RTC.
+
+Required properties:
+- compatible : Should be twl4030-rtc
+
+Examples:
+
+rtc@0 {
+    compatible = "ti,twl4030-rtc";
+};
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 20687d5..d43b4f6 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -550,6 +550,11 @@ static int twl_rtc_resume(struct platform_device *pdev)
 #define twl_rtc_resume  NULL
 #endif
 
+static const struct of_device_id twl_rtc_of_match[] = {
+	{.compatible = "ti,twl4030-rtc", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, twl_rtc_of_match);
 MODULE_ALIAS("platform:twl_rtc");
 
 static struct platform_driver twl4030rtc_driver = {
@@ -559,8 +564,9 @@ static struct platform_driver twl4030rtc_driver = {
 	.suspend	= twl_rtc_suspend,
 	.resume		= twl_rtc_resume,
 	.driver		= {
-		.owner	= THIS_MODULE,
-		.name	= "twl_rtc",
+		.owner		= THIS_MODULE,
+		.name		= "twl_rtc",
+		.of_match_table = twl_rtc_of_match,
 	},
 };
 
-- 
1.7.0.4


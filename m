Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2KZVlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:41:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53995 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab2KZVls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:41:48 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <wim@iguana.be>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <linux-keystone@list.ti.com>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH] watchdog: davinci_wdt: add OF support
Date: Mon, 26 Nov 2012 16:41:35 -0500
Message-ID: <1353966095-23331-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds OF support for davinci_wdt driver.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 .../devicetree/bindings/watchdog/davinci-wdt.txt   |   12 ++++++++++++
 drivers/watchdog/davinci_wdt.c                     |    7 +++++++
 2 files changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/davinci-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
new file mode 100644
index 0000000..75558cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
@@ -0,0 +1,12 @@
+DaVinci Watchdog Timer (WDT) Controller
+
+Required properties:
+- compatible : Should be "ti,davinci-wdt"
+- reg : Should contain WDT registers location and length
+
+Examples:
+
+wdt: wdt@2320000 {
+	compatible = "ti,davinci-wdt";
+	reg = <0x02320000 0x80>;
+};
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index eb44b03..c73e166 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -262,10 +262,17 @@ static int __devexit davinci_wdt_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id davinci_wdt_of_match[] = {
+	{ .compatible = "ti,davinci-wdt", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, davinci_wdt_of_match);
+
 static struct platform_driver platform_wdt_driver = {
 	.driver = {
 		.name = "watchdog",
 		.owner	= THIS_MODULE,
+		.of_match_table = davinci_wdt_of_match,
 	},
 	.probe = davinci_wdt_probe,
 	.remove = __devexit_p(davinci_wdt_remove),
-- 
1.7.9.5


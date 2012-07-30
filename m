Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2G3Qfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:35:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64310 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab2G3Qfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:35:47 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        David Brown <davidb@codeaurora.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH 1/1] ARM: dove: DT support for sdhci-dove
Date: Mon, 30 Jul 2012 18:35:34 +0200
Message-Id: <1343666134-21205-1-git-send-email-sebastian.hesselbarth@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support and binding documentiation for
sdhci-dove.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Chris Ball <cjb@laptop.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: David Brown <davidb@codeaurora.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mmc@vger.kernel.org

---
 Documentation/devicetree/bindings/mmc/sdhci-dove.txt |   12 ++++++++++++
 drivers/mmc/host/sdhci-dove.c                        |    8 ++++++++
 2 files changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-dove.txt

diff --git a/Documentation/devicetree/bindings/mmc/sdhci-dove.txt b/Documentation/devicetree/bindings/mmc/sdhci-dove.txt
new file mode 100644
index 0000000..3dd42552
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/sdhci-dove.txt
@@ -0,0 +1,12 @@
+* Marvell sdhci-dove controller
+
+Required properties:
+- compatible: Should be "marvell,dove-sdhci".
+
+Example:
+
+sdio0: sdio@92000 {
+	compatible = "marvell,dove-sdhci";
+	reg = <0x92000 0x100>;
+	interrupts = <35>, <37>;
+};
diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
index a6e53a1..90140eb 100644
--- a/drivers/mmc/host/sdhci-dove.c
+++ b/drivers/mmc/host/sdhci-dove.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/mmc/host.h>
+#include <linux/of.h>
 
 #include "sdhci-pltfm.h"
 
@@ -126,11 +127,18 @@ static int __devexit sdhci_dove_remove(struct platform_device *pdev)
 	return sdhci_pltfm_unregister(pdev);
 }
 
+static const struct of_device_id sdhci_dove_of_match_table[] __devinitdata = {
+	{ .compatible = "marvell,dove-sdhci", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, sdhci_dove_of_match_table);
+
 static struct platform_driver sdhci_dove_driver = {
 	.driver		= {
 		.name	= "sdhci-dove",
 		.owner	= THIS_MODULE,
 		.pm	= SDHCI_PLTFM_PMOPS,
+		.of_match_table = of_match_ptr(sdhci_dove_of_match_table),
 	},
 	.probe		= sdhci_dove_probe,
 	.remove		= __devexit_p(sdhci_dove_remove),
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1JJQnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:43:52 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:19780 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1JJQnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:43:50 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH V2 4/4] ARM: at91/dma: DMA controller registering with DT support
Date: Mon, 10 Oct 2011 18:43:41 +0200
Message-Id: <1318265021-4562-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <e292fbb24a98b7cfda8ea83364956a50e1cb120f.1318264339.git.nicolas.ferre@atmel.com>
References: <e292fbb24a98b7cfda8ea83364956a50e1cb120f.1318264339.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree support on at91sam9g45 family SoC. Only call
platform_device_register() if no compatible dma-controller
node is found in device tree.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
V2: use compatible string to match device.

 arch/arm/mach-at91/at91sam9g45_devices.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 9390ae6..2120055 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -64,7 +64,13 @@ static struct platform_device at_hdmac_device = {
 
 void __init at91_add_device_hdmac(void)
 {
-	platform_device_register(&at_hdmac_device);
+	struct device_node *np = of_find_node_by_name(NULL, "dma-controller");
+
+	if (np && of_device_is_compatible(np, "atmel,at91sam9g45-dma")) {
+		of_node_put(np);
+	} else {
+		platform_device_register(&at_hdmac_device);
+	}
 }
 #else
 void __init at91_add_device_hdmac(void) {}
-- 
1.7.5.4


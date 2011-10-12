Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1JLQ52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:57:28 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:59041 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1JLQ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:57:26 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3 4/4] ARM: at91/dma: DMA controller registering with DT support
Date: Wed, 12 Oct 2011 18:57:14 +0200
Message-Id: <8d71a02275bc252b3841bf9f0e2e17a16df6deda.1318438197.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318438634-11826-1-git-send-email-nicolas.ferre@atmel.com>
References: <1318438634-11826-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <f91f267b82ac0f0459c11a7bdf3ab0ea8758656a.1318438197.git.nicolas.ferre@atmel.com>
References: <f91f267b82ac0f0459c11a7bdf3ab0ea8758656a.1318438197.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree support on at91sam9g45 family SoC. Only call
platform_device_register() if no dma-controller node is
found in device tree.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index c9b897f..b9888c5 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -64,7 +64,13 @@ static struct platform_device at_hdmac_device = {
 
 void __init at91_add_device_hdmac(void)
 {
-	platform_device_register(&at_hdmac_device);
+	struct device_node *of_node =
+		of_find_node_by_name(NULL, "dma-controller");
+
+	if (of_node)
+		of_node_put(of_node);
+	else
+		platform_device_register(&at_hdmac_device);
 }
 #else
 void __init at91_add_device_hdmac(void) {}
-- 
1.7.5.4


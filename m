Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab2JRN0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:26:12 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61187 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab2JRN0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:26:07 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC PATCH v3 12/16] mmc: omap_hsmmc: add generic DMA request support to the DT binding
Date: Thu, 18 Oct 2012 09:26:51 -0400
Message-Id: <1350566815-409-13-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350566815-409-1-git-send-email-mporter@ti.com>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The binding definition is based on the generic DMA request binding.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   25 +++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
index be76a23..d1b8932 100644
--- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
+++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
@@ -19,8 +19,28 @@ ti,dual-volt: boolean, supports dual voltage cards
 "supply-name" examples are "vmmc", "vmmc_aux" etc
 ti,non-removable: non-removable slot (like eMMC)
 ti,needs-special-reset: Requires a special softreset sequence
+dmas: DMA controller phandle and DMA request value ordered pair
+One tx and one rx pair is required.
+dma-names: DMA request names. These strings correspond 1:1 with
+the ordered pairs in dmas. The RX request must be "rx" and the
+TX request must be "tx".
+
+Examples:
+
+[hwmod populated DMA resources]
+
+	mmc1: mmc@0x4809c000 {
+		compatible = "ti,omap4-hsmmc";
+		reg = <0x4809c000 0x400>;
+		ti,hwmods = "mmc1";
+		ti,dual-volt;
+		bus-width = <4>;
+		vmmc-supply = <&vmmc>; /* phandle to regulator node */
+		ti,non-removable;
+	};
+
+[generic DMA request binding]
 
-Example:
 	mmc1: mmc@0x4809c000 {
 		compatible = "ti,omap4-hsmmc";
 		reg = <0x4809c000 0x400>;
@@ -29,4 +49,7 @@ Example:
 		bus-width = <4>;
 		vmmc-supply = <&vmmc>; /* phandle to regulator node */
 		ti,non-removable;
+		dmas = <&edma 24
+			&edma 25>;
+		dma-names = "tx", "rx";
 	};
-- 
1.7.9.5


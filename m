Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2JRN3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:29:14 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33242 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab2JRNZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:25:57 -0400
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
Subject: [RFC PATCH v3 07/16] dmaengine: edma: Add TI EDMA device tree binding
Date: Thu, 18 Oct 2012 09:26:46 -0400
Message-Id: <1350566815-409-8-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350566815-409-1-git-send-email-mporter@ti.com>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The binding definition is based on the generic DMA controller
binding.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 Documentation/devicetree/bindings/dma/ti-edma.txt |   51 +++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt

diff --git a/Documentation/devicetree/bindings/dma/ti-edma.txt b/Documentation/devicetree/bindings/dma/ti-edma.txt
new file mode 100644
index 0000000..3344345
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/ti-edma.txt
@@ -0,0 +1,51 @@
+TI EDMA
+
+Required properties:
+- compatible : "ti,edma3"
+- ti,hwmods: Name of the hwmods associated to the EDMA
+- ti,edma-regions: Number of regions
+- ti,edma-slots: Number of slots
+- ti,edma-queue-tc-map: List of transfer control to queue mappings
+- ti,edma-queue-priority-map: List of queue priority mappings
+- ti,edma-default-queue: Default queue value
+
+Optional properties:
+- ti,edma-reserved-channels: List of reserved channel regions
+- ti,edma-reserved-slots: List of reserved slot regions
+- ti,edma-xbar-event-map: Crossbar event to channel map
+
+Example:
+
+edma: edma@49000000 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	reg = <0x49000000 0x10000>;
+	interrupt-parent = <&intc>;
+	interrupts = <12 13 14>;
+	compatible = "ti,edma3";
+	ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
+	#dma-cells = <1>;
+	dma-channels = <64>;
+	ti,edma-regions = <4>;
+	ti,edma-slots = <256>;
+	ti,edma-reserved-channels = <0  2
+				     14 2
+				     26 6
+				     48 4
+				     56 8>;
+	ti,edma-reserved-slots = <0  2
+				  14 2
+				  26 6
+				  48 4
+				  56 8
+				  64 127>;
+	ti,edma-queue-tc-map = <0 0
+				1 1
+				2 2>;
+	ti,edma-queue-priority-map = <0 0
+				      1 1
+				      2 2>;
+	ti,edma-default-queue = <0>;
+	ti,edma-xbar-event-map = <1 12
+				  2 13>;
+};
-- 
1.7.9.5


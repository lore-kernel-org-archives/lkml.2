Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2ISKdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 06:33:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40566 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab2ISKdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 06:33:24 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <kishon@ti.com>, <arnd@arndb.de>,
        <balbi@ti.com>, <b-cousson@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/2] ARM: dts: omap: add *reg* property for ocp2scp
Date: Wed, 19 Sep 2012 16:02:51 +0530
Message-ID: <1348050772-27819-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348050772-27819-1-git-send-email-kishon@ti.com>
References: <1348050772-27819-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*reg* property for ocp2scp was previously obtained from ti,hwmods property.
But that is now explicitly added to the dt node. Also updated the
documentation with *reg* info.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/bus/omap-ocp2scp.txt       |   14 ++++++++++++++
 arch/arm/boot/dts/omap4.dtsi                       |    3 ++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt b/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
index d2fe064..1d5f203 100644
--- a/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
+++ b/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
@@ -2,9 +2,23 @@
 
 properties:
 - compatible : Should be "ti,omap-ocp2scp"
+- reg : Address and length of the register set for the device
 - #address-cells, #size-cells : Must be present if the device has sub-nodes
 - ranges : the child address space are mapped 1:1 onto the parent address space
 - ti,hwmods : must be "ocp2scp_usb_phy"
 
 Sub-nodes:
 All the devices connected to ocp2scp are described using sub-node to ocp2scp
+
+ocp2scp@4a0ad000 {
+	compatible = "ti,omap-ocp2scp";
+	reg = <0x4a0ad000 0x1f>;
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+	ti,hwmods = "ocp2scp_usb_phy";
+	subnode1 {
+	};
+	subnode2 {
+	};
+};
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 8a780b2..4fbb9dc 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -296,8 +296,9 @@
 			ti,hwmods = "dmic";
 		};
 
-		ocp2scp {
+		ocp2scp@4a0ad000 {
 			compatible = "ti,omap-ocp2scp";
+			reg = <0x4a0ad000 0x1f>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
-- 
1.7.9.5


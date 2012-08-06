Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab2HFNXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:23:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35862 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab2HFNXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:23:35 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <tony@atomide.com>, <rnayak@ti.com>,
        <hvaibhav@ti.com>, <kishon@ti.com>, <peter.ujfalusi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: [PATCH 4/4] arm/dts: omap: Add usb_otg and glue data
Date: Mon, 6 Aug 2012 18:53:15 +0530
Message-ID: <1344259395-4559-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344259395-4559-1-git-send-email-kishon@ti.com>
References: <1344259395-4559-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add usb otg data node in omap4/omap3 device tree file. Also update
the node with board specific setting in omapx-<board>.dts file.

Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap3-beagle.dts |    6 ++++++
 arch/arm/boot/dts/omap3-evm.dts    |    6 ++++++
 arch/arm/boot/dts/omap3.dtsi       |    8 ++++++++
 arch/arm/boot/dts/omap4-panda.dts  |    6 ++++++
 arch/arm/boot/dts/omap4-sdp.dts    |    6 ++++++
 arch/arm/boot/dts/omap4.dtsi       |    8 ++++++++
 6 files changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index cdcb98c..6d6a7a4 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -67,3 +67,9 @@
 &mmc3 {
 	status = "disabled";
 };
+
+&usb_otg_hs {
+	interface_type = <0>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/arch/arm/boot/dts/omap3-evm.dts b/arch/arm/boot/dts/omap3-evm.dts
index f349ee9..c4ac75e 100644
--- a/arch/arm/boot/dts/omap3-evm.dts
+++ b/arch/arm/boot/dts/omap3-evm.dts
@@ -46,3 +46,9 @@
 		reg = <0x5c>;
 	};
 };
+
+&usb_otg_hs {
+	interface_type = <0>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 8109471..2501416 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -220,5 +220,13 @@
 			compatible = "ti,omap3-wdt";
 			ti,hwmods = "wd_timer2";
 		};
+
+		usb_otg_hs: usb_otg_hs {
+			compatible = "ti,omap3-musb";
+			ti,hwmods = "usb_otg_hs";
+			multipoint = <1>;
+			num_eps = <16>;
+			ram_bits = <12>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index 2999eba..8cded95 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -130,3 +130,9 @@
 &twlusb {
 	usb-supply = <&vusb>;
 };
+
+&usb_otg_hs {
+	interface_type = <1>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index d8290c0..24f4bfd 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -230,3 +230,9 @@
 &twlusb {
 	usb-supply = <&vusb>;
 };
+
+&usb_otg_hs {
+	interface_type = <1>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index d774733..a855d13 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -308,5 +308,13 @@
 				      <0x4a002300 0x1>;
 			};
 		};
+
+		usb_otg_hs: usb_otg_hs {
+			compatible = "ti,omap4-musb";
+			ti,hwmods = "usb_otg_hs";
+			multipoint = <1>;
+			num_eps = <16>;
+			ram_bits = <12>;
+		};
 	};
 };
-- 
1.7.9.5


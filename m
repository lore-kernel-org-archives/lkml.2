Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2GRKnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:43:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47696 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2GRKkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:40:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v4 10/11] arm/dts: omap: Add usb_otg and glue data
Date: Wed, 18 Jul 2012 16:08:41 +0530
Message-ID: <1342607922-11554-11-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342607922-11554-1-git-send-email-kishon@ti.com>
References: <1342607922-11554-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add usb otg data node in omap4/omap3 device tree file. Also update
the node with board specific setting in omapx-<board>.dts file.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap3-beagle.dts |    6 ++++++
 arch/arm/boot/dts/omap3-evm.dts    |    6 ++++++
 arch/arm/boot/dts/omap3.dtsi       |    8 ++++++++
 arch/arm/boot/dts/omap4-panda.dts  |    6 ++++++
 arch/arm/boot/dts/omap4-sdp.dts    |    6 ++++++
 arch/arm/boot/dts/omap4.dtsi       |    8 ++++++++
 6 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index 5b4506c..f3d7076 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -67,3 +67,9 @@
 &mmc3 {
 	status = "disable";
 };
+
+&usb_otg_hs {
+	interface_type = <0>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/arch/arm/boot/dts/omap3-evm.dts b/arch/arm/boot/dts/omap3-evm.dts
index 2eee16e..8963b3d 100644
--- a/arch/arm/boot/dts/omap3-evm.dts
+++ b/arch/arm/boot/dts/omap3-evm.dts
@@ -18,3 +18,9 @@
 		reg = <0x80000000 0x10000000>; /* 256 MB */
 	};
 };
+
+&usb_otg_hs {
+	interface_type = <0>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 99474fa..f2694c9 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -215,5 +215,13 @@
 			compatible = "ti,omap3-hsmmc";
 			ti,hwmods = "mmc3";
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
index 7052422..dd19370 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -93,3 +93,9 @@
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
index 6326d7c..0fc10d4 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -162,3 +162,9 @@
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
index 15f1890..3a6c3fa 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -285,5 +285,13 @@
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
1.7.5.4


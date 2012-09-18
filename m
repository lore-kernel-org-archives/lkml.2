Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2IRIvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:51:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2IRIvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:51:19 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: Describe interrupt-controller binding
Date: Tue, 18 Sep 2012 10:51:14 +0200
Message-Id: <1347958274-19425-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:PU3PVbcnvJZrUrQImCpmSS750vpMglE8T8EqWCyw+Vi
 PSWvD15BqwG8Hwg42oXNPVpyqIM9poiN0DZXkXwfhKDwE6PDvH
 gZCBAKrzVBf+enMBDRH254VQJtbclI7NZwF7cr1g0MUfdzev1N
 UOQdfGrLeh2jXH7K6XcKioaiceUVnFx2n1xd3Hgxl+tmoTjGav
 xL5X0n/Ch7U8zdLWDjg/PNIbHmBWHwcqeisTU5QkGpitGEg7fy
 NQ1+EcQi8o1KskG3B2t6ZdDMpkBwbI9/Exjx54DpaEABA5hwRa
 8MIMlnLDQintH9tO0mXylwMa7sCctuQFzK+3cg2atmF4c0JrP1
 hwJgTttnfjZL3i4vWDVSNrnhu+O7aS+mzHugrayQT7YbseplpN
 12CGmwouJYHt/M1JpfGO5o2mhWCo+lIwfLpagfIKjgTTBInaT8
 Mavvc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to use GPIO controllers as interrupt controllers, they need to
be marked with the DT interrupt-controller property. This commit adds
some documentation about this to the general GPIO binding document.

Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 Documentation/devicetree/bindings/gpio/gpio.txt | 33 +++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index 4e16ba4..8d125b0 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -75,4 +75,37 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
 		gpio-controller;
 	};
 
+If the GPIO controller supports the generation of interrupts, it should
+also contain an empty "interrupt-controller" property as well as an
+"#interrupt-cells" property. This is required in order for other nodes
+to use the GPIO controller as their interrupt parent.
 
+If #interrupt-cells is 1, the single cell is used to specify the number
+of the GPIO that is to be used as an interrupt.
+
+If #interrupt-cells is 2, the first cell is used to specify the number
+of the GPIO that is to be used as an interrupt, whereas the second cell
+is used to specify any of the following flags:
+  - bits[3:0] trigger type and level flags
+      1 = low-to-high edge triggered
+      2 = high-to-low edge triggered
+      4 = active high level-sensitive
+      8 = active low level-sensitive
+
+Example:
+
+	gpioext: gpio-controller@41 {
+		compatible = "ad,gpio-adnp";
+		reg = <0x41>;
+
+		interrupt-parent = <&gpio>;
+		interrupts = <160 1>;
+
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+
+		nr-gpios = <64>;
+	};
-- 
1.7.12


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab2K2FvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:51:19 -0500
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:41078 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922Ab2K2FvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:51:18 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, rob@landley.net, linux-doc@vger.kernel.org,
        sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] Documentation: add docs for max8925 dt
Date: Thu, 29 Nov 2012 13:52:39 +0800
Message-Id: <1354168359-19459-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 29 Nov 2012 05:51:05.0015 (UTC) FILETIME=[85447470:01CDCDF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

add docs for dt of max8925-mfd, max8925-backlight, and
max8925-battery

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 Documentation/devicetree/bindings/mfd/max8925.txt  |   64 ++++++++++++++++++++
 .../bindings/power_supply/max8925_batter.txt       |   18 ++++++
 .../bindings/video/backlight/max8925-backlight.txt |   10 +++
 3 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max8925.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/max8925_batter.txt
 create mode 100644 Documentation/devicetree/bindings/video/backlight/max8925-backlight.txt

diff --git a/Documentation/devicetree/bindings/mfd/max8925.txt b/Documentation/devicetree/bindings/mfd/max8925.txt
new file mode 100644
index 0000000..13bb62b
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max8925.txt
@@ -0,0 +1,64 @@
+* Maxim max8925 Power Management IC
+
+Required parent device properties:
+- compatible : "maxim,max8925"
+- reg : the I2C slave address for the max8925 chip
+- interrupts : IRQ line for the max8925 chip
+- interrupt-controller: describes the max8925 as an interrupt
+  controller (has its own domain)
+- #interrupt-cells : should be 1.
+	- The cell is the max8925 local IRQ number
+
+Optional parent device properties:
+- tsc-irq: there are 2 IRQ lines for max8925, one is indicated in
+  interrupts property, the other is indicated here.
+
+max8925 consists of a large and varied group of sub-devices:
+
+Device			 Supply Names	 Description
+------			 ------------	 -----------
+max8925-onkey		:		: On key
+max8925-rtc		:		: RTC
+max8925-regulator	:		: Regulators
+max8925-backlight	:		: Backlight
+max8925-touch		:		: Touchscreen
+max8925-power		:		: Charger
+
+Example:
+
+	pmic: max8925@3c {
+		compatible = "maxim,max8925";
+		reg = <0x3c>;
+		interrupts = <1>;
+		interrupt-parent = <&intcmux4>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		tsc-irq = <0>;
+
+		regulators {
+			SDV1 {
+				regulator-min-microvolt = <637500>;
+				regulator-max-microvolt = <1425000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			
+			LDO1 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			
+		};
+		backlight {
+			max8925-dual-string = <0>;
+		};
+		charger {
+			batt-detect = <0>;
+			topoff-threshold = <1>;
+			fast-charge = <7>;
+			no-temp-support = <0>;
+			no-insert-detect = <0>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/power_supply/max8925_batter.txt b/Documentation/devicetree/bindings/power_supply/max8925_batter.txt
new file mode 100644
index 0000000..d7e3e0c
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/max8925_batter.txt
@@ -0,0 +1,18 @@
+max8925-battery bindings
+~~~~~~~~~~~~~~~~
+
+Optional properties :
+ - batt-detect: whether support battery detect
+ - topoff-threshold: set charging current in topoff mode
+ - fast-charge: set charging current in fast mode
+ - no-temp-support: whether support temperature protection detect
+ - no-insert-detect: whether support insert detect
+
+Example:
+	charger {
+		batt-detect = <0>;
+		topoff-threshold = <1>;
+		fast-charge = <7>;
+		no-temp-support = <0>;
+		no-insert-detect = <0>;
+	};
diff --git a/Documentation/devicetree/bindings/video/backlight/max8925-backlight.txt b/Documentation/devicetree/bindings/video/backlight/max8925-backlight.txt
new file mode 100644
index 0000000..d692db3
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/backlight/max8925-backlight.txt
@@ -0,0 +1,10 @@
+88pm860x-backlight bindings
+
+Optional properties:
+  - max8925-dual-string: whether support dual string
+
+Example:
+
+	backlights {
+		max8925-dual-string = <0>;
+	};
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422957Ab2LFJ66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:58:58 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55532 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2LFJ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:58:56 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] devicetree/bindings: Move gpio-leds binding into leds directory
Date: Thu,  6 Dec 2012 09:58:50 +0000
Message-Id: <1354787930-10931-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merely reorganizing documentation. No functional changes. It makes more
sense for the gpio-leds binding to be grouped with other led bindings
than with gpio drivers.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Posting for reference. I've applied this to my tree already

g.

 Documentation/devicetree/bindings/gpio/led.txt     |   52 --------------------
 .../devicetree/bindings/leds/leds-gpio.txt         |   52 ++++++++++++++++++++
 2 files changed, 52 insertions(+), 52 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/gpio/led.txt
 create mode 100644 Documentation/devicetree/bindings/leds/leds-gpio.txt

diff --git a/Documentation/devicetree/bindings/gpio/led.txt b/Documentation/devicetree/bindings/gpio/led.txt
deleted file mode 100644
index df1b308..0000000
--- a/Documentation/devicetree/bindings/gpio/led.txt
+++ /dev/null
@@ -1,52 +0,0 @@
-LEDs connected to GPIO lines
-
-Required properties:
-- compatible : should be "gpio-leds".
-
-Each LED is represented as a sub-node of the gpio-leds device.  Each
-node's name represents the name of the corresponding LED.
-
-LED sub-node properties:
-- gpios :  Should specify the LED's GPIO, see "gpios property" in
-  Documentation/devicetree/bindings/gpio/gpio.txt.  Active low LEDs should be
-  indicated using flags in the GPIO specifier.
-- label :  (optional)
-  see Documentation/devicetree/bindings/leds/common.txt
-- linux,default-trigger :  (optional)
-  see Documentation/devicetree/bindings/leds/common.txt
-- default-state:  (optional) The initial state of the LED.  Valid
-  values are "on", "off", and "keep".  If the LED is already on or off
-  and the default-state property is set the to same value, then no
-  glitch should be produced where the LED momentarily turns off (or
-  on).  The "keep" setting will keep the LED at whatever its current
-  state is, without producing a glitch.  The default is off if this
-  property is not present.
-
-Examples:
-
-leds {
-	compatible = "gpio-leds";
-	hdd {
-		label = "IDE Activity";
-		gpios = <&mcu_pio 0 1>; /* Active low */
-		linux,default-trigger = "ide-disk";
-	};
-
-	fault {
-		gpios = <&mcu_pio 1 0>;
-		/* Keep LED on if BIOS detected hardware fault */
-		default-state = "keep";
-	};
-};
-
-run-control {
-	compatible = "gpio-leds";
-	red {
-		gpios = <&mpc8572 6 0>;
-		default-state = "off";
-	};
-	green {
-		gpios = <&mpc8572 7 0>;
-		default-state = "on";
-	};
-};
diff --git a/Documentation/devicetree/bindings/leds/leds-gpio.txt b/Documentation/devicetree/bindings/leds/leds-gpio.txt
new file mode 100644
index 0000000..df1b308
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-gpio.txt
@@ -0,0 +1,52 @@
+LEDs connected to GPIO lines
+
+Required properties:
+- compatible : should be "gpio-leds".
+
+Each LED is represented as a sub-node of the gpio-leds device.  Each
+node's name represents the name of the corresponding LED.
+
+LED sub-node properties:
+- gpios :  Should specify the LED's GPIO, see "gpios property" in
+  Documentation/devicetree/bindings/gpio/gpio.txt.  Active low LEDs should be
+  indicated using flags in the GPIO specifier.
+- label :  (optional)
+  see Documentation/devicetree/bindings/leds/common.txt
+- linux,default-trigger :  (optional)
+  see Documentation/devicetree/bindings/leds/common.txt
+- default-state:  (optional) The initial state of the LED.  Valid
+  values are "on", "off", and "keep".  If the LED is already on or off
+  and the default-state property is set the to same value, then no
+  glitch should be produced where the LED momentarily turns off (or
+  on).  The "keep" setting will keep the LED at whatever its current
+  state is, without producing a glitch.  The default is off if this
+  property is not present.
+
+Examples:
+
+leds {
+	compatible = "gpio-leds";
+	hdd {
+		label = "IDE Activity";
+		gpios = <&mcu_pio 0 1>; /* Active low */
+		linux,default-trigger = "ide-disk";
+	};
+
+	fault {
+		gpios = <&mcu_pio 1 0>;
+		/* Keep LED on if BIOS detected hardware fault */
+		default-state = "keep";
+	};
+};
+
+run-control {
+	compatible = "gpio-leds";
+	red {
+		gpios = <&mpc8572 6 0>;
+		default-state = "off";
+	};
+	green {
+		gpios = <&mpc8572 7 0>;
+		default-state = "on";
+	};
+};
-- 
1.7.10.4


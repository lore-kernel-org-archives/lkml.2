Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab2KOVwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:52:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55008 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2KOVwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:52:02 -0500
From: Marek Belisko <marek.belisko@open-nandra.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] Documentation: Move common leds properties description to separate file.
Date: Thu, 15 Nov 2012 22:51:56 +0100
Message-Id: <1353016316-6966-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 Documentation/devicetree/bindings/gpio/led.txt    |   14 ++++--------
 Documentation/devicetree/bindings/leds/common.txt |   24 +++++++++++++++++++++
 2 files changed, 28 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/common.txt

diff --git a/Documentation/devicetree/bindings/gpio/led.txt b/Documentation/devicetree/bindings/gpio/led.txt
index edc83c1..df1b308 100644
--- a/Documentation/devicetree/bindings/gpio/led.txt
+++ b/Documentation/devicetree/bindings/gpio/led.txt
@@ -10,16 +10,10 @@ LED sub-node properties:
 - gpios :  Should specify the LED's GPIO, see "gpios property" in
   Documentation/devicetree/bindings/gpio/gpio.txt.  Active low LEDs should be
   indicated using flags in the GPIO specifier.
-- label :  (optional) The label for this LED.  If omitted, the label is
-  taken from the node name (excluding the unit address).
-- linux,default-trigger :  (optional) This parameter, if present, is a
-  string defining the trigger assigned to the LED.  Current triggers are:
-    "backlight" - LED will act as a back-light, controlled by the framebuffer
-		  system
-    "default-on" - LED will turn on, but see "default-state" below
-    "heartbeat" - LED "double" flashes at a load average based rate
-    "ide-disk" - LED indicates disk activity
-    "timer" - LED flashes at a fixed, configurable rate
+- label :  (optional)
+  see Documentation/devicetree/bindings/leds/common.txt
+- linux,default-trigger :  (optional)
+  see Documentation/devicetree/bindings/leds/common.txt
 - default-state:  (optional) The initial state of the LED.  Valid
   values are "on", "off", and "keep".  If the LED is already on or off
   and the default-state property is set the to same value, then no
diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
new file mode 100644
index 0000000..0654693
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/common.txt
@@ -0,0 +1,24 @@
+Common leds properties.
+
+Optional properties for child nodes:
+- label : The label for this LED.  If omitted, the label is
+  taken from the node name (excluding the unit address).
+
+- linux,default-trigger :  This parameter, if present, is a
+    string defining the trigger assigned to the LED.  Current triggers are:
+     "backlight" - LED will act as a back-light, controlled by the framebuffer
+		   system
+     "default-on" - LED will turn on (but for leds-gpio see "default-state"
+		    property in Documentation/devicetree/bindings/gpio/led.txt)
+     "heartbeat" - LED "double" flashes at a load average based rate
+     "ide-disk" - LED indicates disk activity
+     "timer" - LED flashes at a fixed, configurable rate
+
+Examples:
+
+system-status {
+	label = "Status";
+	linux,default-trigger = "heartbeat";
+	...
+};
+
-- 
1.7.10.4


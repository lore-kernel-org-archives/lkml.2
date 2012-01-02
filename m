Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2ABPOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 10:14:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43791 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2ABPOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 10:14:18 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, robherring2@gmail.com,
        broonie@opensource.wolfsonmicro.com, Jamie Iles <jamie@jamieiles.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCHv4 1/4] of: document common interrupt controller details
Date: Mon,  2 Jan 2012 15:14:05 +0000
Message-Id: <1325517248-32032-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's common for interrupt controllers to need to encode interrupt
trigger types and the Linux specific types seem common.  Document these
in a centralized place so that they don't get reinvented each time a new
controller is added.

Suggested-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 Documentation/devicetree/bindings/arm/gic.txt    |    8 ++------
 Documentation/devicetree/bindings/interrupts.txt |   17 +++++++++++++++++
 2 files changed, 19 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupts.txt

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index 9b4b82a..d13f7ce 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -24,12 +24,8 @@ Main node required properties:
   SPI interrupts are in the range [0-987].  PPI interrupts are in the
   range [0-15].
 
-  The 3rd cell is the flags, encoded as follows:
-	bits[3:0] trigger type and level flags.
-		1 = low-to-high edge triggered
-		2 = high-to-low edge triggered
-		4 = active high level-sensitive
-		8 = active low level-sensitive
+  The 3rd cell is the flags, encoded as the trigger masks from
+  Documentation/devicetree/bindings/interrupts.txt and:
 	bits[15:8] PPI interrupt cpu mask.  Each bit corresponds to each of
 	the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
 	the interrupt is wired to that CPU.  Only valid for PPI interrupts.
diff --git a/Documentation/devicetree/bindings/interrupts.txt b/Documentation/devicetree/bindings/interrupts.txt
new file mode 100644
index 0000000..1545941
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupts.txt
@@ -0,0 +1,17 @@
+Common Interrupt Binding Details
+
+For controllers that need to encode trigger types and senses, where possible
+it is encouraged to use the following encoding (a direct mapping of the
+IRQF_TRIGGER_* constants in include/linux/interrupt.h):
+
+	bits[3:0] trigger type and level flags.
+		1 = low-to-high edge triggered
+		2 = high-to-low edge triggered
+		4 = active high level-sensitive
+		8 = active low level-sensitive
+
+For example, an interrupt may be encoded as (with #interrupt-cells = <2>):
+
+	interrupts = <4 0x3>;
+
+to have interrupt 4 raise an interrupt on both edges of the input.
-- 
1.7.5.4


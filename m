Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2IJIll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:41:41 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63133 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab2IJIkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:40:20 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 7/9] ARM: mvebu: Add pinctrl support to Armada XP SoCs
Date: Mon, 10 Sep 2012 10:39:44 +0200
Message-Id: <1347266386-16229-8-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

This commits adds the necessary device tree information to define the
compatible property for the pinctrl driver instance of Armada XP SoCs.

Until now, the device tree representation considered the Armada XP as
a single SoC. But in fact, there are three different SoCs in the
Armada XP families, with different number of CPU cores, different
number of Ethernet interfaces... and different number of muxable pins
or functions. We therefore introduce three armada-xp-mv78xx0.dtsi for
the three SoCs of the Armada XP family. The current armada-xp-db.dts
evaluation board uses the MV78460 variant of the SoC.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
v3:
- put specific variant into DT "model"

Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Lior Amsalem <alior@marvell.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/boot/dts/armada-xp-mv78230.dtsi |   27 +++++++++++++++++++++++++++
 arch/arm/boot/dts/armada-xp-mv78260.dtsi |   27 +++++++++++++++++++++++++++
 arch/arm/boot/dts/armada-xp-mv78460.dtsi |   27 +++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)
 create mode 100644 arch/arm/boot/dts/armada-xp-mv78230.dtsi
 create mode 100644 arch/arm/boot/dts/armada-xp-mv78260.dtsi
 create mode 100644 arch/arm/boot/dts/armada-xp-mv78460.dtsi

diff --git a/arch/arm/boot/dts/armada-xp-mv78230.dtsi b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
new file mode 100644
index 0000000..8bdcd43
--- /dev/null
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -0,0 +1,27 @@
+/*
+ * Device Tree Include file for Marvell Armada XP family SoC
+ *
+ * Copyright (C) 2012 Marvell
+ *
+ * Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ * Contains definitions specific to the Armada XP MV78230 SoC that are not
+ * common to all Armada XP SoCs.
+ */
+
+/include/ "armada-xp.dtsi"
+
+/ {
+	model = "Marvell Armada XP MV78230 SoC";
+	compatible = "marvell,armadaxp-mv78230", "marvell,armadaxp", "marvell,armada-370-xp";
+
+	soc {
+		pinctrl@d0018000 {
+			compatible = "marvell,mv78230-pinctrl";
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/armada-xp-mv78260.dtsi b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
new file mode 100644
index 0000000..e5c108b
--- /dev/null
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -0,0 +1,27 @@
+/*
+ * Device Tree Include file for Marvell Armada XP family SoC
+ *
+ * Copyright (C) 2012 Marvell
+ *
+ * Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ * Contains definitions specific to the Armada XP MV78260 SoC that are not
+ * common to all Armada XP SoCs.
+ */
+
+/include/ "armada-xp.dtsi"
+
+/ {
+	model = "Marvell Armada XP MV78260 SoC";
+	compatible = "marvell,armadaxp-mv78260", "marvell,armadaxp", "marvell,armada-370-xp";
+
+	soc {
+		pinctrl@d0018000 {
+			compatible = "marvell,mv78260-pinctrl";
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/armada-xp-mv78460.dtsi b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
new file mode 100644
index 0000000..22e7fdd
--- /dev/null
+++ b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
@@ -0,0 +1,27 @@
+/*
+ * Device Tree Include file for Marvell Armada XP family SoC
+ *
+ * Copyright (C) 2012 Marvell
+ *
+ * Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ * Contains definitions specific to the Armada XP MV78460 SoC that are not
+ * common to all Armada XP SoCs.
+ */
+
+/include/ "armada-xp.dtsi"
+
+/ {
+	model = "Marvell Armada XP MV78460 SoC";
+	compatible = "marvell,armadaxp-mv78460", "marvell,armadaxp", "marvell,armada-370-xp";
+
+	soc {
+		pinctrl@d0018000 {
+			compatible = "marvell,mv78460-pinctrl";
+		};
+	};
+ };
-- 
1.7.10.4


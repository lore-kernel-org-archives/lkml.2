Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1LVO7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:59:03 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:32820 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab1LVO6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:58:52 -0500
From: Benoit Cousson <b-cousson@ti.com>
To: <rob.herring@calxeda.com>, <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux-i2c@vger.kernel.org>, <sameo@linux.intel.com>,
        <ben-linux@fluff.org>, Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH v4 09/12] arm/dts: omap4-panda: Add twl6030 and i2c EEPROM
Date: Thu, 22 Dec 2011 15:56:43 +0100
Message-ID: <1324565806-31142-10-git-send-email-b-cousson@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
References: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update pandaboard dts file with required clock frequencies
for the i2c client devices existing on pandaboard.

Add the twl6030 node in i2c1 controller.

This is the minimal support needed to boot OMAP4 boards
without any crash.
The support for all the features included in this MFD will be
added later.

Add a generic i2c EEPROM entry.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/boot/dts/omap4-panda.dts |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index 9755ad5..29646dc 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -18,3 +18,37 @@
 		reg = <0x80000000 0x40000000>; /* 1 GB */
 	};
 };
+
+&i2c1 {
+	clock-frequency = <400000>;
+
+	twl: twl@48 {
+		reg = <0x48>;
+		/* SPI = 0, IRQ# = 7, 4 = active high level-sensitive */
+		interrupts = <0 7 4>; /* IRQ_SYS_1N cascaded to gic */
+		interrupt-parent = <&gic>;
+	};
+};
+
+/include/ "twl6030.dtsi"
+
+&i2c2 {
+	clock-frequency = <400000>;
+};
+
+&i2c3 {
+	clock-frequency = <100000>;
+
+	/*
+	 * Display monitor features are burnt in their EEPROM as EDID data.
+	 * The EEPROM is connected as I2C slave device.
+	 */
+	eeprom@50 {
+		compatible = "ti,eeprom";
+		reg = <0x50>;
+	};
+};
+
+&i2c4 {
+	clock-frequency = <400000>;
+};
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1LVPAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:00:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41461 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab1LVO6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:58:55 -0500
From: Benoit Cousson <b-cousson@ti.com>
To: <rob.herring@calxeda.com>, <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux-i2c@vger.kernel.org>, <sameo@linux.intel.com>,
        <ben-linux@fluff.org>, Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH v4 10/12] arm/dts: omap4-sdp: Add twl6030, i2c3 and i2c4 devices
Date: Thu, 22 Dec 2011 15:56:44 +0100
Message-ID: <1324565806-31142-11-git-send-email-b-cousson@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
References: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update DTS file with required clock frequencies
for the i2c client devices existing on sdp4430.

Add the twl6030 node inside the i2c1 controller node.
This is the minimal support needed to boot OMAP4 boards
without any crash.
The support for all the features included in this MFD will be
added later.

Add the RTC submodule inside the twl node.

Add tmp105 temperature sensor in i2c3
Add bh1780 Ambient Light Sensor in i2c3
Add hmc5843 3-Axis Digital Compass in i2c4

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/boot/dts/omap4-sdp.dts |   53 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 63c6b2b..17e829a 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -18,3 +18,56 @@
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
+	reg = <0x48072000 0x100>, <0x48072100 0x100>, <0x48072200 0x100>;
+};
+
+&i2c3 {
+	clock-frequency = <400000>;
+
+	/*
+	 * Temperature Sensor
+	 * http://www.ti.com/lit/ds/symlink/tmp105.pdf
+	 */
+	tmp105@48 {
+		compatible = "ti,tmp105";
+		reg = <0x48>;
+	};
+
+	/*
+	 * Ambient Light Sensor
+	 * http://www.rohm.com/products/databook/sensor/pdf/bh1780gli-e.pdf
+	 */
+	bh1780@29 {
+		compatible = "rohm,bh1780";
+		reg = <0x29>;
+	};
+};
+
+&i2c4 {
+	clock-frequency = <400000>;
+
+	/*
+	 * 3-Axis Digital Compass
+	 * http://www.sparkfun.com/datasheets/Sensors/Magneto/HMC5843.pdf
+	 */
+	hmc5843@1e {
+		compatible = "honeywell,hmc5843";
+		reg = <0x1e>;
+	};
+};
-- 
1.7.0.4


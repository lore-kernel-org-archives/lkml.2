Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059Ab2FHODQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:03:16 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45054 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757708Ab2FHOCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:02:39 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Russell King <linux@arm.linux.org.uk>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: [PATCH 4/7] arm/dts: omap4-sdp: Add support for twl6040
Date: Fri,  8 Jun 2012 17:02:02 +0300
Message-Id: <1339164125-32534-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
References: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The twl6040 provides the audio and vibra support on OMAP4 SDP boards.
It is connected to i2c1 bus with 0x4b address.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/omap4-sdp.dts |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 4b51611..f09d1f5 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -99,6 +99,31 @@
 		interrupts = <0 7 4>; /* IRQ_SYS_1N cascaded to gic */
 		interrupt-parent = <&gic>;
 	};
+
+	twl6040: twl@4b {
+		compatible = "ti,twl6040";
+		reg = <0x4b>;
+		/* SPI = 0, IRQ# = 119, 4 = active high level-sensitive */
+		interrupts = <0 119 4>; /* IRQ_SYS_2N cascaded to gic */
+		interrupt-parent = <&gic>;
+		ti,audpwron-gpio = <&gpio4 31 0>;  /* gpio line 127 */
+
+		vio-supply = <&v1v8>;
+		v2v1-supply = <&v2v1>;
+		enable-active-high;
+
+		/* regulators for vibra motor */
+		vddvibl-supply = <&vbat>;
+		vddvibr-supply = <&vbat>;
+
+		vibra {
+			/* Vibra driver, motor resistance parameters */
+			ti,vibldrv-res = <8>;
+			ti,vibrdrv-res = <3>;
+			ti,viblmotor-res = <10>;
+			ti,vibrmotor-res = <10>;
+		};
+	};
 };
 
 /include/ "twl6030.dtsi"
-- 
1.7.8.6


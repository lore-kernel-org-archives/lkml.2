Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab2FHODO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:03:14 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:43924 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757637Ab2FHOCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:02:39 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Russell King <linux@arm.linux.org.uk>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: [PATCH 6/7] arm/dts: omap4-panda: Audio support for PandaBoard 4430
Date: Fri,  8 Jun 2012 17:02:04 +0300
Message-Id: <1339164125-32534-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
References: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PandaBoard uses twl6040 connected via McPDM for audio.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/omap4-panda.dts |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index 1efe0c5..f57f5e8 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -32,6 +32,30 @@
 			linux,default-trigger = "mmc0";
 		};
 	};
+
+	sound: sound {
+		compatible = "ti,abe-twl6040";
+		ti,model = "PandaBoard";
+
+		ti,mclk-freq = <38400000>;
+
+		ti,mcpdm = <&mcpdm>;
+
+		ti,twl6040 = <&twl6040>;
+
+		/* Audio routing */
+		ti,audio-routing =
+			"Headset Stereophone", "HSOL",
+			"Headset Stereophone", "HSOR",
+			"Ext Spk", "HFL",
+			"Ext Spk", "HFR",
+			"Line Out", "AUXL",
+			"Line Out", "AUXR",
+			"HSMIC", "Headset Mic",
+			"Headset Mic", "Headset Mic Bias",
+			"AFML", "Line In",
+			"AFMR", "Line In";
+	};
 };
 
 &i2c1 {
@@ -43,6 +67,19 @@
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
+	};
 };
 
 /include/ "twl6030.dtsi"
-- 
1.7.8.6


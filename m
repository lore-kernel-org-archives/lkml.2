Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab2FHOEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:04:37 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:57695 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933363Ab2FHOCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:02:34 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Russell King <linux@arm.linux.org.uk>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: [PATCH 5/7] arm/dts: omap4-sdp: Enable audio support via device tree
Date: Fri,  8 Jun 2012 17:02:03 +0300
Message-Id: <1339164125-32534-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
References: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OMAP4 SDP the audio setup includes the twl6040 codec and digital
microphones.

Since OMAP4 SDP is a reference board it has all possible audio interfaces
connected. This information is passed via the ti,audio-routing
property.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/omap4-sdp.dts |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index f09d1f5..964f8ec 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -88,6 +88,41 @@
 			gpios = <&gpio5 11 0>; /* 139 */
 		};
 	};
+
+	sound {
+		compatible = "ti,abe-twl6040";
+		ti,model = "SDP4430";
+
+		ti,jack-detection = <1>;
+		ti,mclk-freq = <38400000>;
+
+		ti,mcpdm = <&mcpdm>;
+		ti,dmic = <&dmic>;
+
+		ti,twl6040 = <&twl6040>;
+
+		/* Audio routing */
+		ti,audio-routing =
+			"Headset Stereophone", "HSOL",
+			"Headset Stereophone", "HSOR",
+			"Earphone Spk", "EP",
+			"Ext Spk", "HFL",
+			"Ext Spk", "HFR",
+			"Line Out", "AUXL",
+			"Line Out", "AUXR",
+			"Vibrator", "VIBRAL",
+			"Vibrator", "VIBRAR",
+			"HSMIC", "Headset Mic",
+			"Headset Mic", "Headset Mic Bias",
+			"MAINMIC", "Main Handset Mic",
+			"Main Handset Mic", "Main Mic Bias",
+			"SUBMIC", "Sub Handset Mic",
+			"Sub Handset Mic", "Main Mic Bias",
+			"AFML", "Line In",
+			"AFMR", "Line In",
+			"DMic", "Digital Mic",
+			"Digital Mic", "Digital Mic1 Bias";
+	};
 };
 
 &i2c1 {
-- 
1.7.8.6


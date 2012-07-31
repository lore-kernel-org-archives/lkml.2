Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab2GaNkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:40:25 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58080 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab2GaNjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:39:52 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/19] Documentation: Define the MSP Driver Device Tree bindings
Date: Tue, 31 Jul 2012 14:39:12 +0100
Message-Id: <1343741953-17828-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the required documentation for the new Device Tree
bindings pertaining to the MSP CPU-side DAI Driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/sound/ux500-msp.txt        |   43 ++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/ux500-msp.txt

diff --git a/Documentation/devicetree/bindings/sound/ux500-msp.txt b/Documentation/devicetree/bindings/sound/ux500-msp.txt
new file mode 100644
index 0000000..5b883cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/ux500-msp.txt
@@ -0,0 +1,43 @@
+* ux500 MSP (CPU-side Digital Audio Interface)
+
+Required properties:
+ - compatible       :"stericsson,ux500-msp-i2s"
+ - reg              : Physical base address and length of the device's registers.
+
+Optional properties:
+ - interrupts       : The interrupt outputs from the device.
+ - interrupt-parent : The parent interrupt controller.
+ - <name>-supply    : Phandle to the regulator <name> supply
+
+Example:
+
+	sound {
+		compatible = "stericsson,snd-soc-mop500";
+
+		stericsson,platform-pcm-dma = <&pcm>;
+		stericsson,cpu-dai = <&msp1 &msp3>;
+		stericsson,audio-codec = <&codec>;
+	};
+
+	pcm: ux500-pcm {
+		compatible = "stericsson,ux500-pcm";
+	};
+
+	msp1: msp@80124000 {
+		compatible = "stericsson,ux500-msp-i2s";
+		reg = <0x80124000 0x1000>;
+		interrupts = <0 62 0x4>;
+		v-ape-supply = <&db8500_vape_reg>;
+	};
+
+	msp3: msp@80125000 {
+		compatible = "stericsson,ux500-msp-i2s";
+		reg = <0x80125000 0x1000>;
+		interrupts = <0 62 0x4>;
+		v-ape-supply = <&db8500_vape_reg>;
+	};
+
+	codec: ab8500-codec {
+		compatible = "stericsson,ab8500-codec";
+		stericsson,earpeice-cmv = <950>; /* Units in mV. */
+	};
-- 
1.7.9.5


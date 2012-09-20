Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab2ITMJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:09:45 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64625 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2ITMJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:09:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 7/7] Documentation: Define the MSP Driver Device Tree bindings
Date: Thu, 20 Sep 2012 14:09:16 +0200
Message-Id: <1348142956-1872-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348142956-1872-1-git-send-email-lee.jones@linaro.org>
References: <1348142956-1872-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the required documentation for the new Device Tree
bindings pertaining to the MSP CPU-side DAI Driver.

Acked-by: Ola Lilja <ola.o.lilja@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/sound/ux500-msp.txt        |   43 ++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/ux500-msp.txt

diff --git a/Documentation/devicetree/bindings/sound/ux500-msp.txt b/Documentation/devicetree/bindings/sound/ux500-msp.txt
new file mode 100644
index 0000000..99acd9c
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
+ - interrupts       : The interrupt output from the device.
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2HBMND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:13:03 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38333 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2HBMNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:13:01 -0400
Date: Thu, 2 Aug 2012 13:12:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 17/19] Documentation: Define the MOP500 Audio Machine
 Driver Device Tree bindings
Message-ID: <20120802121255.GA22201@gmail.com>
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
 <1343741953-17828-18-git-send-email-lee.jones@linaro.org>
 <20120731135337.GM4468@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731135337.GM4468@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>
Date: Tue, 31 Jul 2012 11:56:51 +0100
Subject: [PATCH 1/1] Documentation: Define the MOP500 Audio Machine Driver
 Device Tree bindings

Here we add the required documentation for the new Device Tree
bindings pertaining to the MOP500 Audio Machine driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/sound/ux500-mop500.txt     |   39 ++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/ux500-mop500.txt

diff --git a/Documentation/devicetree/bindings/sound/ux500-mop500.txt b/Documentation/devicetree/bindings/sound/ux500-mop500.txt
new file mode 100644
index 0000000..48e071c
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/ux500-mop500.txt
@@ -0,0 +1,39 @@
+* MOP500 Audio Machine Driver
+
+This node is responsible for linking together all ux500 Audio Driver components.
+
+Required properties:
+ - compatible              : "stericsson,snd-soc-mop500"
+
+Non-standard properties:
+ - stericsson,cpu-dai      : Phandle to the CPU-side DAI
+ - stericsson,audio-codec  : Phandle to the Audio CODEC
+ - stericsson,card-name    : Over-ride default card name
+
+Example:
+
+	sound {
+		compatible = "stericsson,snd-soc-mop500";
+
+		stericsson,cpu-dai = <&msp1 &msp3>;
+		stericsson,audio-codec = <&codec>;
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

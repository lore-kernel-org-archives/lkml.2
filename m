Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab1LTRaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 12:30:00 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:33132
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138Ab1LTR3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 12:29:41 -0500
X-SpamScore: 2
X-BigFish: VS2(zcb8kz154dMzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <cjb@laptop.org>, <w.sang@pengutronix.de>
Subject: [RFC PATCH v3 4/5] ARM: imx6q: using pinmux subsystem
Date: Wed, 21 Dec 2011 01:40:39 +0800
Message-ID: <1324402840-32451-5-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1324402840-32451-1-git-send-email-b29396@freescale.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shanw.guo@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
---
ChangeLog v2->v3:
- Add phandle for pinmux mappings
- follow DT convention to use dash '-' for property name

ChangeLog v1->v2:
- Add basic binding for pinmux pins
---
 arch/arm/boot/dts/imx6q-sabreauto.dts |   32 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/imx6q.dtsi          |    1 +
 arch/arm/mach-imx/Kconfig             |    1 +
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-sabreauto.dts b/arch/arm/boot/dts/imx6q-sabreauto.dts
index 072974e..c3e9070 100644
--- a/arch/arm/boot/dts/imx6q-sabreauto.dts
+++ b/arch/arm/boot/dts/imx6q-sabreauto.dts
@@ -25,7 +25,39 @@
 		reg = <0x10000000 0x80000000>;
 	};
 
+	pinmux: imx6q-sabreauto-map {
+		map-sd4 {
+			map-name = "usdhc4";
+			ctrl-dev-name = "20e0000.iomuxc";
+			function = "sd4";
+			dev-name = "219c000.usdhc";
+		};
+	};
+
 	soc {
+		aips-bus@02000000 { /* AIPS1 */
+			iomuxc@020e0000 {
+				fsl,pinmux-map = <&pinmux>;
+				pinmux-uart4 {
+					func-name = "uart4";
+					grp-name = "uart4grp";
+					grp-pins = <107 108>;
+					num-pins = <2>;
+					grp-mux = <4 4>;
+					num-mux = <2>;
+				};
+
+				pinmux-sd4 {
+					func-name = "sd4";
+					grp-name = "sd4grp";
+					grp-pins = <170 171 180 181 182 183 184 185 186 187>;
+					num-pins = <10>;
+					grp-mux = <0 0 1 1 1 1 1 1 1 1>;
+					num-mux = <10>;
+				};
+			};
+		};
+
 		aips-bus@02100000 { /* AIPS2 */
 			enet@02188000 {
 				phy-mode = "rgmii";
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 7dda599..42499bb 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -386,6 +386,7 @@
 			};
 
 			iomuxc@020e0000 {
+				compatible = "fsl,imx6q-iomuxc";
 				reg = <0x020e0000 0x4000>;
 			};
 
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 5f7f9c2..d6a88fe 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -615,6 +615,7 @@ config SOC_IMX6Q
 	select HAVE_IMX_GPC
 	select HAVE_IMX_MMDC
 	select HAVE_IMX_SRC
+	select PINCTRL
 	select USE_OF
 
 	help
-- 
1.7.0.4



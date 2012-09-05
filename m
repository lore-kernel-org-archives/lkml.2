Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2IENft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:35:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54807 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2IENfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:35:46 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 8/8] ARM i.MX53: Add pwm support
Date: Wed,  5 Sep 2012 15:35:27 +0200
Message-Id: <1346852127-25226-9-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346852127-25226-1-git-send-email-s.hauer@pengutronix.de>
References: <1346852127-25226-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/boot/dts/imx53.dtsi        |   14 ++++++++++++++
 arch/arm/mach-imx/clk-imx51-imx53.c |    4 ++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index cd37165..18b9fc3 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -189,6 +189,20 @@
 				status = "disabled";
 			};
 
+			pwm1: pwm@53fb4000 {
+				#pwm-cells = <2>;
+				compatible = "fsl,imx53-pwm", "fsl,imx27-pwm";
+				reg = <0x53fb4000 0x4000>;
+				interrupts = <61>;
+			};
+
+			pwm2: pwm@53fb8000 {
+				#pwm-cells = <2>;
+				compatible = "fsl,imx53-pwm", "fsl,imx27-pwm";
+				reg = <0x53fb8000 0x4000>;
+				interrupts = <94>;
+			};
+
 			uart1: serial@53fbc000 {
 				compatible = "fsl,imx53-uart", "fsl,imx21-uart";
 				reg = <0x53fbc000 0x4000>;
diff --git a/arch/arm/mach-imx/clk-imx51-imx53.c b/arch/arm/mach-imx/clk-imx51-imx53.c
index 4bdcaa9..b522411 100644
--- a/arch/arm/mach-imx/clk-imx51-imx53.c
+++ b/arch/arm/mach-imx/clk-imx51-imx53.c
@@ -455,6 +455,10 @@ int __init mx53_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
 	clk_register_clkdev(clk[ssi1_ipg_gate], NULL, "63fcc000.ssi");
 	clk_register_clkdev(clk[ssi2_ipg_gate], NULL, "50014000.ssi");
 	clk_register_clkdev(clk[ssi3_ipg_gate], NULL, "63fd0000.ssi");
+	clk_register_clkdev(clk[pwm1_ipg_gate], "ipg", "53fb4000.pwm");
+	clk_register_clkdev(clk[pwm1_hf_gate], "per", "53fb4000.pwm");
+	clk_register_clkdev(clk[pwm2_ipg_gate], "ipg", "53fb8000.pwm");
+	clk_register_clkdev(clk[pwm2_hf_gate], "per", "53fb8000.pwm");
 
 	/* set SDHC root clock to 200MHZ*/
 	clk_set_rate(clk[esdhc_a_podf], 200000000);
-- 
1.7.10.4


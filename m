Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3AFRfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 12:35:22 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:38280 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab3AFRfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 12:35:18 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 3/3] arm: mvebu: enable gpio expander over i2c on Mirabox platform
Date: Sun,  6 Jan 2013 18:34:48 +0100
Message-Id: <1357493688-25061-4-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357493688-25061-1-git-send-email-gregory.clement@free-electrons.com>
References: <1357493688-25061-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Globalscale Mirabox platform can be connected to the JTAG/GPIO box
through the Multi-IO port. The GPIO box use the NXP PCA9505 I/O port
expansion IC to provide 40-bit parallel input/output GPIOs. This patch
enable the use of this expander on the Mirabox.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-370-mirabox.dts |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370-mirabox.dts b/arch/arm/boot/dts/armada-370-mirabox.dts
index 3b40713..d9b32d3 100644
--- a/arch/arm/boot/dts/armada-370-mirabox.dts
+++ b/arch/arm/boot/dts/armada-370-mirabox.dts
@@ -52,5 +52,15 @@
 			phy = <&phy1>;
 			phy-mode = "rgmii-id";
 		};
+		i2c@d0011000 {
+			status = "okay";
+			clock-frequency = <100000>;
+			pca9505: pca9505@25 {
+				compatible = "nxp,pca9505";
+				gpio-controller;
+				#gpio-cells = <2>;
+				reg = <0x25>;
+			};
+		};
 	};
 };
-- 
1.7.9.5


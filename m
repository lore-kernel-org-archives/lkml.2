Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422879Ab2JYJ5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:57:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64446 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965589Ab2JYJ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:57:29 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/8] ARM: ux500: Add node for the MMC GPIO regulator
Date: Thu, 25 Oct 2012 10:57:08 +0100
Message-Id: <1351159031-25391-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351159031-25391-1-git-send-email-lee.jones@linaro.org>
References: <1351159031-25391-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a very simple mechanism to change and SDI's voltage which
consists of toggling some GPIOs. This scenario can be better handled
if we convert it to a GPIO regulator. This patch provides one which
can be read from Device Tree.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 07a085b..536df5d 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -614,5 +614,19 @@
 			ranges = <0 0x50000000 0x4000000>;
 			status = "disabled";
 		};
+
+		vmmci: regulator-gpio {
+			compatible = "regulator-gpio";
+
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2600000>;
+			regulator-name = "mmci-reg";
+			regulator-type = "voltage";
+
+			gpios = <&tc3589x_gpio 18 0x4>;
+			gpio-enable = <&tc3589x_gpio 17 0x4>;
+			states = <1800000 0x1
+				  2900000 0x0>;
+		};
 	};
 };
-- 
1.7.9.5


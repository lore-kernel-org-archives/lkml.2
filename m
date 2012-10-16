Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab2JPICr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:02:47 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40228 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab2JPICn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:02:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/1] Documentation: Describe Device Tree bindings for GPIO Regulator driver
Date: Tue, 16 Oct 2012 09:02:33 +0100
Message-Id: <1350374553-12678-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we specify all non-standard bindings which can be used when
requesting the use of an GPIO controlled regulator from Device Tree.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../bindings/regulator/gpio-regulator.txt          |   36 ++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/gpio-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
new file mode 100644
index 0000000..3703be2
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
@@ -0,0 +1,36 @@
+GPIO controlled regulators
+
+Required properties:
+- compatible		: Must be "regulator-gpio".
+
+Optional properties:
+- gpio-enable		: GPIO to use to enable/disable the regulator.
+- gpios			: GPIO group used to control voltage.
+- states		: Selection of available voltages and GPIO configs.
+- startup-delay-us	: Startup time in microseconds.
+- enable-active-high	: Polarity of GPIO is active high (default is low).
+
+Any property defined as part of the core regulator binding defined in
+regulator.txt can also be used.
+
+Example:
+
+	mmciv: gpio-regulator {
+		compatible = "regulator-gpio";
+
+		regulator-name = "mmci-gpio-supply";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <2600000>;
+		regulator-boot-on;
+
+		gpio-enable = <&gpio0 23 0x4>;
+		gpios = <&gpio0 24 0x4
+			 &gpio0 25 0x4>;
+		states = <1800000 0x3
+			  2200000 0x2
+			  2600000 0x1
+			  2900000 0x0>;
+
+		startup-delay-us = <100000>;
+		enable-active-high;
+	};
-- 
1.7.9.5


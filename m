Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2JONRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:17:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61108 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2JONRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:17:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/2] Documentation: Describe Device Tree bindings for GPIO Regulator driver
Date: Mon, 15 Oct 2012 14:17:00 +0100
Message-Id: <1350307020-5910-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350307020-5910-1-git-send-email-lee.jones@linaro.org>
References: <1350307020-5910-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we specify all non-standard bindings which can be used when
requesting the use of an GPIO controlled regulator from Device Tree.

Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../bindings/regulator/gpio-regulator.txt          |   25 ++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/gpio-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
new file mode 100644
index 0000000..5f77ee0
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
@@ -0,0 +1,25 @@
+GPIO controlled regulators
+
+Required properties:
+- compatible            : Must be "regulator-gpio".
+
+Optional properties:
+- gpio-enable           : GPIO to use to enable/disable the regulator.
+- startup-delay-us      : Startup time in microseconds.
+- enable-active-high    : Polarity of GPIO is active high (default is low).
+
+Any property defined as part of the core regulator binding defined in
+regulator.txt can also be used.
+
+Example:
+
+	mmciv: gpio-regulator {
+		compatible = "regulator-gpio";
+		regulator-name = "mmci-gpio-supply";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <2600000>;
+		gpio = <&gpio0 24 0x4>;
+		startup-delay-us = <100000>;
+		enable-active-high;
+		regulator-boot-on;
+	};
-- 
1.7.9.5


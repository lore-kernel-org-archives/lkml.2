Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab2JOO6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:58:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51888 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2JOO6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:58:18 -0400
Date: Mon, 15 Oct 2012 15:58:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 2/2] Documentation: Describe Device Tree bindings for
 GPIO Regulator driver
Message-ID: <20121015145811.GA7662@gmail.com>
References: <1350307020-5910-1-git-send-email-lee.jones@linaro.org>
 <1350307020-5910-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350307020-5910-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Lee Jones <lee.jones@linaro.org>
Date:   Mon Oct 15 13:12:08 2012 +0100

    Documentation: Describe Device Tree bindings for GPIO Regulator driver
    
    Here we specify all non-standard bindings which can be used when
    requesting the use of an GPIO controlled regulator from Device Tree.
    
    Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
new file mode 100644
index 0000000..a7cdb6e
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
@@ -0,0 +1,36 @@
+GPIO controlled regulators
+
+Required properties:
+- compatible            : Must be "regulator-gpio".
+
+Optional properties:
+- gpio-enable           : GPIO to use to enable/disable the regulator.
+- gpios           	: GPIO group used to control voltage.
+- states		: Selection of available voltages and GPIO configs.
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
+
+		regulator-name = "mmci-gpio-supply";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <2600000>;
+
+		gpio-enable = <&gpio0 23 0x4
+		gpios = <&gpio0 24 0x4
+			 &gpio0 25 0x4>;
+		states = <1800000 0x3
+			  2200000 0x2
+			  2600000 0x1
+			  2900000 0x0>;
+
+		startup-delay-us = <100000>;
+		enable-active-high;
+		regulator-boot-on;
+	};

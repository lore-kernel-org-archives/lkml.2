Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2JEPcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:32:16 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab2JEPcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:32:09 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 06/10] Documentation: Describe bindings for STMPE Multi-Functional Device driver
Date: Fri,  5 Oct 2012 16:31:42 +0100
Message-Id: <1349451107-8009-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
References: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the required documentation for the STMPE Multi-Functional
Device (MFD) Device Tree bindings. It describes all of the bindings
currently supported by the driver.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mfd/stmpe.txt |   25 +++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/stmpe.txt

diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
new file mode 100644
index 0000000..8f0aeda
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/stmpe.txt
@@ -0,0 +1,25 @@
+* STMPE Multi-Functional Device
+
+Required properties:
+ - compatible                   : "st,stmpe[811|1601|2401|2403]"
+ - reg                          : I2C address of the device
+
+Optional properties:
+ - interrupts                   : The interrupt outputs from the controller
+ - interrupt-controller         : Marks the device node as an interrupt controller
+ - interrupt-parent             : Specifies which IRQ controller we're connected to
+ - i2c-client-wake              : Marks the input device as wakable
+ - st,autosleep-timeout         : Valid entries (ms); 4, 16, 32, 64, 128, 256, 512 and 1024
+
+Example:
+
+	stmpe1601: stmpe1601@40 {
+		compatible = "st,stmpe1601";
+		reg = <0x40>;
+		interrupts = <26 0x4>;
+		interrupt-parent = <&gpio6>;
+		interrupt-controller;
+
+		i2c-client-wake;
+		st,autosleep-timeout = <1024>;
+	};
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2JBIN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:13:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59838 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab2JBINm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:13:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 06/10] Documentation: Detail permitted DT properties for the BU21013 Touch Screen
Date: Tue,  2 Oct 2012 09:13:19 +0100
Message-Id: <1349165603-24401-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we apply required documentation for the Rohm BU21013 Touch
Screen driver which describe available properties and how to use
them.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../bindings/input/touchscreen/bu21013.txt         |   28 ++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/bu21013.txt

diff --git a/Documentation/devicetree/bindings/input/touchscreen/bu21013.txt b/Documentation/devicetree/bindings/input/touchscreen/bu21013.txt
new file mode 100644
index 0000000..51edc75
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/touchscreen/bu21013.txt
@@ -0,0 +1,28 @@
+* Rohm BU21013 Touch Screen
+
+Required properties:
+ - compatible           : "stericsson,bu21013_tp"
+ - reg                  :  I2C device address
+
+Optional properties:
+touch-gpio              : GPIO pin registering a touch event
+<supply_name>-supply	: Phandle to a regulator supply
+stericsson,touch-max-x 	: Maximum outward permitted limit in the X axis
+stericsson,touch-max-y	: Maximum outward permitted limit in the Y axis
+stericsson,flip-x	: Flip touch coordinates on the X axis
+stericsson,flip-y	: Flip touch coordinates on the Y axis
+
+Example:
+
+	i2c@80110000 {
+		bu21013_tp@0x5c {
+			compatible = "bu21013_tp";
+			reg = <0x5c>;
+			touch-gpio = <&gpio2 20 0x4>;
+			avdd-supply = <&ab8500_ldo_aux1_reg>;
+
+			stericsson,touch-max-x = <384>;
+			stericsson,touch-max-y = <704>;
+			stricsson,flip-y;
+		};
+	};
-- 
1.7.9.5


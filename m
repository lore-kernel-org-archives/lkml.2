Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2FMQI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:08:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60092 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2FMQI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:08:27 -0400
Message-ID: <4FD8BAF8.10806@linaro.org>
Date: Wed, 13 Jun 2012 17:08:24 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Subject: [PATCH 3/3] Documentation: Device Tree binding information for i2c-nomadik
 driver
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-10-git-send-email-lee.jones@linaro.org> <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
In-Reply-To: <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>
Date: Wed, 13 Jun 2012 17:00:02 +0100
Subject: [PATCH 3/3] Documentation: Device Tree binding information for
 i2c-nomadik driver

This document describes each of the non-standard Device Tree bindings
used in the Nomadik I2C driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/i2c/nomadik.txt |   33 +++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/nomadik.txt

diff --git a/Documentation/devicetree/bindings/i2c/nomadik.txt b/Documentation/devicetree/bindings/i2c/nomadik.txt
new file mode 100644
index 0000000..18cea18
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/nomadik.txt
@@ -0,0 +1,33 @@
+I2C for Nomadik based systems
+
+Required (non-standard) properties:
+ - Nil
+
+Recommended (non-standard) properties:
+ - clock-frequency : Maximum bus clock frequency for the device
+ - stericsson,slsu : Data line delay
+ - stericsson,tft : Tx FIFO threshold
+ - stericsson,rft : Rx FIFO threshold
+ - stericsson,timeout : Slave response timeout(ms)
+ - stericsson,i2c_freq_mode_fast : I2C fast mode (omit for standard mode)
+
+Optional (non-standard) properties:
+ - Nil
+
+Example :
+
+i2c@80004000 {
+        compatible = "stericsson,db8500-i2c", "st,nomadik-i2c";
+        reg = <0x80004000 0x1000>;
+        interrupts = <0 21 0x4>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+        v-i2c-supply = <&db8500_vape_reg>;
+
+        clock-frequency = <100000>;
+        stericsson,slsu = <0xe>;
+        stericsson,tft = <1>;
+        stericsson,rft = <8>;
+        stericsson,timeout = <200>;
+        stericsson,i2c_freq_mode_fast;
+};
-- 
1.7.9.5

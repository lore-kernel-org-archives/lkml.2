Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1BPNBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:01:24 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42185 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab1BPNBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:01:21 -0500
X-Sasl-enc: UGOpGlCwQ/EjXoRJmsOFvFBO9c2zgR3kCfWRvGV30vaW 1297861280
Message-ID: <4D5BCAD0.4080204@ladisch.de>
Date: Wed, 16 Feb 2011 14:02:08 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] hwmon: (jc42) more helpful documentation
References: <4D5BCA87.7010204@ladisch.de>
In-Reply-To: <4D5BCA87.7010204@ladisch.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation lists standard numbers and chip names in excruciating
detail, but that's all it does.  To help mere mortals in deciding
whether to enable this driver, mention what this sensor is for and in
which systems it might be found.

Also add a link to the actual JC 42.4 specification.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 Documentation/hwmon/jc42 |    9 +++++++--
 drivers/hwmon/Kconfig    |   11 ++++++-----
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -455,13 +455,14 @@ config SENSORS_JZ4740
 	  called jz4740-hwmon.
 
 config SENSORS_JC42
-	tristate "JEDEC JC42.4 compliant temperature sensors"
+	tristate "JEDEC JC42.4 compliant memory module temperature sensors"
 	depends on I2C
 	help
-	  If you say yes here you get support for Jedec JC42.4 compliant
-	  temperature sensors. Support will include, but not be limited to,
-	  ADT7408, CAT34TS02,, CAT6095, MAX6604, MCP9805, MCP98242, MCP98243,
-	  MCP9843, SE97, SE98, STTS424, TSE2002B3, and TS3000B3.
+	  If you say yes here, you get support for JEDEC JC42.4 compliant
+	  temperature sensors, which are used on many DDR3 memory modules for
+	  mobile devices and servers.  Support will include, but not be limited
+	  to, ADT7408, CAT34TS02, CAT6095, MAX6604, MCP9805, MCP98242, MCP98243,
+	  MCP9843, SE97, SE98, STTS424(E), TSE2002B3, and TS3000B3.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called jc42.
--- a/Documentation/hwmon/jc42
+++ b/Documentation/hwmon/jc42
@@ -51,7 +51,8 @@ Supported chips:
   * JEDEC JC 42.4 compliant temperature sensor chips
     Prefix: 'jc42'
     Addresses scanned: I2C 0x18 - 0x1f
-    Datasheet: -
+    Datasheet:
+	http://www.jedec.org/sites/default/files/docs/4_01_04R19.pdf
 
 Author:
 	Guenter Roeck <guenter.roeck@ericsson.com>
@@ -60,7 +61,11 @@ Author:
 Description
 -----------
 
-This driver implements support for JEDEC JC 42.4 compliant temperature sensors.
+This driver implements support for JEDEC JC 42.4 compliant temperature sensors,
+which are used on many DDR3 memory modules for mobile devices and servers. Some
+systems use the sensor to prevent memory overheating by automatically throttling
+the memory controller.
+
 The driver auto-detects the chips listed above, but can be manually instantiated
 to support other JC 42.4 compliant chips.
 

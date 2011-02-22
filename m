Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1BVWWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:22:18 -0500
Received: from kroah.org ([198.145.64.141]:32934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab1BVWWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:42 2011
Message-Id: <20110222221842.010477201@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [50/70] hwmon: (jc42) more helpful documentation
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit d5622f5b6c4671d1588ccc9056705366d4eb312a upstream.

The documentation lists standard numbers and chip names in excruciating
detail, but that's all it does.  To help mere mortals in deciding
whether to enable this driver, mention what this sensor is for and in
which systems it might be found.

Also add a link to the actual JC 42.4 specification.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/hwmon/jc42 |    9 +++++++--
 drivers/hwmon/Kconfig    |   11 ++++++-----
 2 files changed, 13 insertions(+), 7 deletions(-)

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
 
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -445,13 +445,14 @@ config SENSORS_JZ4740
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



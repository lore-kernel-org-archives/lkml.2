Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031944Ab2CITy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:54:27 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36444 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031932Ab2CITyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:54:22 -0500
Message-Id: <20120309190219.779017987@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [ 60/68] hwmon: (jc42) Add support for ST Microelectronics STTS2002 and STTS3000
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 4de86126a712ba83fa038d277c8282f7ed466a4b upstream.

These are fully compatible with Jedec JC 42.4 as far as I can see.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/hwmon/jc42 |    6 ++++++
 drivers/hwmon/Kconfig    |    3 ++-
 drivers/hwmon/jc42.c     |   10 ++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

--- a/Documentation/hwmon/jc42
+++ b/Documentation/hwmon/jc42
@@ -48,6 +48,12 @@ Supported chips:
     Datasheets:
 	http://www.st.com/stonline/products/literature/ds/13447/stts424.pdf
 	http://www.st.com/stonline/products/literature/ds/13448/stts424e02.pdf
+  * ST Microelectronics STTS2002, STTS3000
+    Prefix: 'stts2002', 'stts3000'
+    Addresses scanned: I2C 0x18 - 0x1f
+    Datasheets:
+	http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LITERATURE/DATASHEET/CD00225278.pdf
+	http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LITERATURE/DATA_BRIEF/CD00270920.pdf
   * JEDEC JC 42.4 compliant temperature sensor chips
     Prefix: 'jc42'
     Addresses scanned: I2C 0x18 - 0x1f
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -475,7 +475,8 @@ config SENSORS_JC42
 	  temperature sensors, which are used on many DDR3 memory modules for
 	  mobile devices and servers.  Support will include, but not be limited
 	  to, ADT7408, CAT34TS02, CAT6095, MAX6604, MCP9805, MCP98242, MCP98243,
-	  MCP9843, SE97, SE98, STTS424(E), TSE2002B3, and TS3000B3.
+	  MCP9843, SE97, SE98, STTS424(E), STTS2002, STTS3000, TSE2002B3, and
+	  TS3000B3.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called jc42.
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -113,6 +113,12 @@ static const unsigned short normal_i2c[]
 #define STTS424E_DEVID		0x0000
 #define STTS424E_DEVID_MASK	0xfffe
 
+#define STTS2002_DEVID		0x0300
+#define STTS2002_DEVID_MASK	0xffff
+
+#define STTS3000_DEVID		0x0200
+#define STTS3000_DEVID_MASK	0xffff
+
 static u16 jc42_hysteresis[] = { 0, 1500, 3000, 6000 };
 
 struct jc42_chips {
@@ -133,6 +139,8 @@ static struct jc42_chips jc42_chips[] =
 	{ NXP_MANID, SE98_DEVID, SE98_DEVID_MASK },
 	{ STM_MANID, STTS424_DEVID, STTS424_DEVID_MASK },
 	{ STM_MANID, STTS424E_DEVID, STTS424E_DEVID_MASK },
+	{ STM_MANID, STTS2002_DEVID, STTS2002_DEVID_MASK },
+	{ STM_MANID, STTS3000_DEVID, STTS3000_DEVID_MASK },
 };
 
 /* Each client has this additional data */
@@ -173,6 +181,8 @@ static const struct i2c_device_id jc42_i
 	{ "se97b", 0 },
 	{ "se98", 0 },
 	{ "stts424", 0 },
+	{ "stts2002", 0 },
+	{ "stts3000", 0 },
 	{ "tse2002b3", 0 },
 	{ "ts3000b3", 0 },
 	{ }



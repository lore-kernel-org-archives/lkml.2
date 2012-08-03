Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2HCPgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:36:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53340 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab2HCPgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:36:47 -0400
From: =?UTF-8?q?Amaury=20Decr=C3=AAme?= <amaury.decreme@gmail.com>
To: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        rob@landley.net
Cc: jeffrey.t.kirsher@intel.com, akpm@linux-foundation.org,
        davem@davemloft.net, gregkh@linuxfoundation.org, joe@perches.com,
        ralf@linux-mips.org, dirk.brandewie@gmail.com,
        jayachandranc@netlogicmicro.com, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Amaury=20Decr=C3=AAme?= <amaury.decreme@gmail.com>
Subject: [PATCH v2 2/2] I2C: SIS964: Bus driver - other files
Date: Fri,  3 Aug 2012 17:35:45 +0200
Message-Id: <1344008145-14579-3-git-send-email-amaury.decreme@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344008145-14579-1-git-send-email-amaury.decreme@gmail.com>
References: <1344008145-14579-1-git-send-email-amaury.decreme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains:
	- Documentation for i2c-sis964
	- Kconfig, Makefile, Maintainers

Signed-off-by: Amaury Decrême <amaury.decreme@gmail.com>
---
 Documentation/i2c/busses/i2c-sis964 |   36 +++++++++++++++++++++++++++++++++++
 MAINTAINERS                         |    7 ++++++
 drivers/i2c/busses/Kconfig          |   12 ++++++++++-
 drivers/i2c/busses/Makefile         |    1 +
 4 files changed, 55 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/i2c/busses/i2c-sis964

diff --git a/Documentation/i2c/busses/i2c-sis964 b/Documentation/i2c/busses/i2c-sis964
new file mode 100644
index 0000000..9cc9846
--- /dev/null
+++ b/Documentation/i2c/busses/i2c-sis964
@@ -0,0 +1,36 @@
+Kernel driver i2c-sis964
+
+Supported adapters:
+  * Silicon Integrated Systems Corp (SiS)
+	964 chipset (Datasheet by SiS)
+  * Possible other SiS chipsets with the same registers and clocks
+
+Author:	Amaury Decrême <amaury.decreme@gmail.com>
+
+Module Parameters
+-----------------
+
+* force = [1|0] 	Forcibly enable the SIS964. DANGEROUS!
+			This can be interesting for chipsets not named
+			above to check if it works for you chipset.
+
+* low_clock = [1|0] 	Set Host Master Clock to 28KHz (defaut 56Khz)
+
+Description
+-----------
+
+This SMBus driver works for motherboards with the SiS964 chipset.
+Despite its name, SIS964 is not compatible with the SIS96X family.
+
+If you see something like this:
+
+00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS964 [MuTIOL Media IO]
+
+in your 'lspci' output , then this driver is for your chipset.
+
+Thank You
+---------
+Alexander Malysh <amalysh@web.de>
+Mark M. Hoffman <mhoffman@lightlink.com>
+Who have worked on i2c-sis630 used to fork i2c-sis964
+
diff --git a/MAINTAINERS b/MAINTAINERS
index 94b823f..9a26e94 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6238,6 +6238,13 @@ S:	Maintained
 F:	Documentation/i2c/busses/i2c-sis96x
 F:	drivers/i2c/busses/i2c-sis96x.c
 
+SIS 964 I2C/SMBUS DRIVER
+M:     "Amaury Decrême" <amaury.decreme@gmail.com>
+L:     linux-i2c@vger.kernel.org
+S:     Maintained
+F:     Documentation/i2c/busses/i2c-sis96i4
+F:     drivers/i2c/busses/i2c-sis964.c
+
 SIS FRAMEBUFFER DRIVER
 M:	Thomas Winischhofer <thomas@winischhofer.net>
 W:	http://www.winischhofer.net/linuxsisvga.shtml
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index b4aaa1b..4fc68a2 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -194,7 +194,7 @@ config I2C_SIS630
 	  will be called i2c-sis630.
 
 config I2C_SIS96X
-	tristate "SiS 96x"
+	tristate "SiS 96x (except SiS964)"
 	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the SiS
@@ -211,6 +211,16 @@ config I2C_SIS96X
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-sis96x.
 
+config I2C_SIS964
+	tristate "SiS 964"
+	depends on PCI && EXPERIMENTAL
+	help
+	  If you say yes to this option, support will be included for the SiS
+	  964 SMBus (a subset of I2C) interfaces.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-sis964.
+
 config I2C_VIA
 	tristate "VIA VT82C586B"
 	depends on PCI && EXPERIMENTAL
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index ce3c2be..b985bc8 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_I2C_NFORCE2_S4985)	+= i2c-nforce2-s4985.o
 obj-$(CONFIG_I2C_PIIX4)		+= i2c-piix4.o
 obj-$(CONFIG_I2C_SIS5595)	+= i2c-sis5595.o
 obj-$(CONFIG_I2C_SIS630)	+= i2c-sis630.o
+obj-$(CONFIG_I2C_SIS964)	+= i2c-sis964.o
 obj-$(CONFIG_I2C_SIS96X)	+= i2c-sis96x.o
 obj-$(CONFIG_I2C_VIA)		+= i2c-via.o
 obj-$(CONFIG_I2C_VIAPRO)	+= i2c-viapro.o
-- 
1.7.8.6


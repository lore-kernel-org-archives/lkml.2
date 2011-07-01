Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1GAFhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:37:24 -0400
Received: from mobile-166-190-108-096.mycingular.net ([166.190.108.96]:38470
	"EHLO brontomerus.synaptics.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752743Ab1GAFhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:37:12 -0400
X-Greylist: delayed 920 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jul 2011 01:37:06 EDT
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 4/9] input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Thu, 30 Jun 2011 22:19:11 -0700
Message-Id: <1309497556-7344-5-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309497556-7344-1-git-send-email-cheiny@synaptics.com>
References: <1309497556-7344-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for Synaptics touchscreens using RMI4 protocol.

Please see the email 0/9 for a description of this patch.

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
Signed-off-by: William Manson <wmanson@synaptics.com>
Signed-off-by: Allie Xiong <axiong@synaptics.com>
Signed-off-by: Peichen Chang <peichen.chang@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

---

diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 718bcc8..8a517a4 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -41,6 +41,8 @@ obj-$(CONFIG_TOUCHSCREEN_QT602240)	+= qt602240_ts.o
 obj-$(CONFIG_TOUCHSCREEN_S3C2410)	+= s3c2410_ts.o
 obj-$(CONFIG_TOUCHSCREEN_ST1232)	+= st1232.o
 obj-$(CONFIG_TOUCHSCREEN_STMPE)		+= stmpe-ts.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_RMI4_I2C)	+=  rmi_bus.o rmi_sensor.o rmi_function.o rmi_f01.o rmi_f05.o rmi_f11.o rmi_f19.o rmi_f34.o rmi_i2c.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_RMI4_SPI)	+=  rmi_bus.o rmi_sensor.o rmi_function.o rmi_f01.o rmi_f05.o rmi_f11.o rmi_f19.o rmi_f34.o rmi_spi.o
 obj-$(CONFIG_TOUCHSCREEN_TNETV107X)	+= tnetv107x-ts.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 61834ae..2b2f6dc 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -362,6 +362,36 @@ config TOUCHSCREEN_MIGOR
 	  To compile this driver as a module, choose M here: the
 	  module will be called migor_ts.
 
+config TOUCHSCREEN_SYNAPTICS_RMI4_I2C
+	tristate "Synaptics RMI4 I2C touchscreens"
+	depends on I2C
+	help
+	  Say Y here if you have a Synaptics RMI4 I2C touchscreen connected to
+	  your system. This enables support for Synaptics RMI4 over I2C based
+	  touchscreens.
+
+	  If unsure, say N.
+
+	  To compile this driver as a set of modules, choose M here: the
+	  modules will be called rmi_core, rmi_app_touchpad, rmi_phys_i2c.
+
+config TOUCHSCREEN_SYNAPTICS_RMI4_SPI
+	tristate "Synaptics RMI4 SPI touchscreens"
+	depends on SPI
+	help
+	  Say Y here if you have a Synaptics RMI4 SPI touchscreen connected to
+	  your system. This enables support for Synaptics RMI4 over SPI based
+	  touchscreens.
+
+	  If unsure, say N.
+
+	  To compile this driver as a set of modules, choose M here: the
+	  modules will be called rmi_core, rmi_app_touchpad, rmi_phys_spi.
+
+config SYNA_MULTI_TOUCH
+	bool "Synaptics pointing using multi-touch events"
+	depends on TOUCHSCREEN_SYNAPTICS_RMI4_I2C || TOUCHSCREEN_SYNAPTICS_RMI4_SPI
+
 config TOUCHSCREEN_TNETV107X
 	tristate "TI TNETV107X touchscreen support"
 	depends on ARCH_DAVINCI_TNETV107X
diff --git a/Documentation/input/synaptics-rmi4.txt b/Documentation/input/synaptics-rmi4.txt
new file mode 100644
index 0000000..80bbdcd
--- /dev/null
+++ b/Documentation/input/synaptics-rmi4.txt
@@ -0,0 +1,172 @@
+RMI4 Touchscreen Driver (rmi-ts)
+--------------------------------
+     Copyright (c) 2007 - 2011, Synaptics Incorporated
+
+This driver adds support for touchscreens and touchpads that use the RMI4
+register based protocol as documented here:
+    http://www.synaptics.com/sites/default/files/511-000136-01_revD.pdf
+
+Currently supported RMI4 functions are
+    F01 - Device Control
+    F11 - 2D multifinger
+    F19 - Capacitive Buttons
+    F34 - Reflash
+
+Physical protocols supported are I2C and SPI.
+
+///////////////////////////////////////////////////
+
+Structure of the driver
+
+   +-------+ +-------+    +-------+ +--------+
+   | Fn34  | | Fn11  |    |  Fn19 | |  Fn11  |   RMI4 Functions
+   *---|---+ +--|----+    +----|--+ +----|---*
+       |        |              |         |
+       |        |              |         |
+   +----------------+      +----------------+
+   | Sensor0        |      |  Sensor1       |    Sensors
+   +----------------+      +----------------+
+           |                      |
+           |                      |
+   +----------------------------------------+
+   |                RMI4 Bus                |    RMI Bus
+   *--|-----|------|--------------|---------*
+      |     |      |              |
+      |     |      |              |
+   +-----+-----+-------+--------------------+
+   | I2C | SPI | SMBus |         etc.       |    Physical Layer
+   +-----+-----+-------+--------------------+
+
+As seen in the ASCII art above, the driver is broken into four layers.
+
+The lowest layer (Physical Layer) provides access to the hardware bus for
+communications with the RMI4 devices themselves.  Implemented by modules
+such as rmi_i2c.c and rmi_spi.c, this layer provides a uniform API for
+reading and writing data to and from the RMI4 device(s).  Future support
+for additional hardware such as SMBus or CanBus is anticipated, but not
+currently scheduled.
+
+The RMI4 devices are presented as devices on the RMI bus (/sys/bus/rmi).  This
+allows us to use standard kernel driver mechanisms to match sensor drivers to
+physical devices, rather than having to write and maintain our own matching
+mechanism.  The RMI bus is implemented in rmi_bus.c.
+
+The sensor driver layer implements those operations that are associated with
+the RMI4 device, but not associated with any specific RMI4 function.  For
+example, it handles interrupts on the ATTN line, controls polling of the
+devices (when the ATTN line is not present), dispatches IRQ notifications
+between function drivers, and so on.  Sensor instances are matched to the
+devices on the RMI bus using standard kernel driver discovery and pairing
+mechanisms.  The sensor driver is implemented in rmi_sensor.c.
+
+At the top layer, RMI4 functions are handled as individual modules (rmi_f01.c,
+rmi_f11.c, and so on), in keeping with the overall RMI4 philosophy that
+the operation specific functions (aside from things such as IRQ notification)
+should be independent of one another.  This simplifies maintenance of
+individual functions, as well as making it much easier to add new function
+implementations.
+
+NOTE: At this time the function drivers are matched to sensor devices using
+a custom ad hoc mechanism in rmi_sensor.c.  A future rev of the driver will
+use standard kernel mechanisms for this, at which point a number of header
+files and public symbols will be retired.  It is strongly recommended that
+you DO NOT write code that depends on symbols defined in the individual
+function header files (rmi_f01.h, rmi_f11.h, and so on).
+
+
+///////////////////////////////////////////////////
+
+Supported functions
+
+RMI Function 01
+---------------
+
+TODO: Write this.
+
+
+RMI Function 11
+---------------
+
+TODO: Write more.
+
+F11 provides a number of built in transformation on the reported coordinates.
+These can be configured at build time via platform_data, or at run time via sysfs.
+The available transformations are:
+    swap - exchange X & Y axes
+    flip - invert X and/or Y axes
+    offset - adjust X and/or Y axis coordinates by a fix value
+    clip - constrain reported coordinates to a specified range
+Any specified transformations are applied in the same order as they are listed
+above: swap is done first, then flip, the offset, then clip.
+
+swap - this is a boolean parameter.  If set to true, the X and Y coordinates will
+be swapped before reporting. Swapping is done before any other transformation,
+which lets you specify the remaining transformations in a way that is compatible
+with the position of the sensor in the device in its default orientation.
+
+flip - this is a pair of boolean parameters that indicate whether the position
+or motion along either axis (or both) should be "flipped" before being passed to
+the input subsystem.  For relative motion, flipping is done by reversing the
+sign on the reported delta and clipping the resulting value to fit in a signed
+byte.  For absolute positions, the flipped value is computed as follows for X
+(Y is computed similarly):
+    Xflipped = Xmax - Xreported
+The flip transformation (if present) is applied after swap, but before offset
+or clip.
+
+offset - this is a pair of signed integer values (offsetX, offsetY) that will
+be added to the reported position before it is passed to the input subsystem.
+This can be used to translate the reported finger position with respect to the
+device touch suface.  An example of a situation where offset is used would be
+a touchscreen where the touch sensor is larger than the display, and the origin
+of the touch sensor is not coincident with the origin of the display.  Offset
+is applied after swap and flip transformations, but before clip.
+
+clip - this is a 4-tuple of unsigned integer values, indicating the minimum and
+maximum values that should be reported on each axis respectively, specified as
+    minX maxX minY maxY
+If a reported coordinate lies outside the [min..max] range, it will be clipped
+to the nearest boundary.  For example:
+    newX = max(min(maxX, reportedX), minX);
+Note that finger positions outside the clipping region are still reported as
+present - the position is merely clipped to the nearest boundary of the clipping
+region.
+
+
+
+RMI Function 19
+---------------
+
+TODO: Write this.
+
+
+RMI Function 34
+---------------
+
+TODO: Write this.
+
+
+///////////////////////////////////////////////////
+
+Configuring the driver
+
+General Configuration
+---------------------
+
+TODO: Describe how to configure when built as a kernel module.
+
+TODO: Describe how to configure when built as a loadable module.
+
+TODO: Describe how to manipulate configuration via /sys/bus/rmi.
+
+
+Configuring I2C
+---------------
+
+TODO: Write this.
+
+
+Configuring SPI
+---------------
+
+TODO: Write this.

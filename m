Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab1IAOVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:21:16 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:38783 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595Ab1IAOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:21:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH v2 3/4] TTY: serial, fix includes in some drivers
Date: Thu,  1 Sep 2011 16:20:57 +0200
Message-Id: <1314886857-28309-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314818699-10873-3-git-send-email-jslaby@suse.cz>
References: <1314818699-10873-3-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/tty_flip.h is included in linux/serial_core.h. But this may (and
will) change in the future. Then we would get build errors such as:
.../tty/serial/max3107.c: In function ‘put_data_to_circ_buf’:
.../tty/serial/max3107.c:149:2: error: implicit declaration of function ‘tty_insert_flip_string’

So fix all the drviers which call tty flip buffer helpers to really
include linux/tty_flip.h. And also make sure that those include
linux/tty.h when operating with struct tty_struct.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/apbuart.c                |    1 +
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |    1 +
 drivers/tty/serial/dz.c                     |    1 +
 drivers/tty/serial/ioc3_serial.c            |    1 +
 drivers/tty/serial/ioc4_serial.c            |    1 +
 drivers/tty/serial/m32r_sio.c               |    1 +
 drivers/tty/serial/max3100.c                |    2 ++
 drivers/tty/serial/max3107.c                |    2 ++
 drivers/tty/serial/mpc52xx_uart.c           |    1 +
 drivers/tty/serial/msm_serial_hs.c          |    2 ++
 drivers/tty/serial/mux.c                    |    2 ++
 drivers/tty/serial/nwpserial.c              |    1 +
 drivers/tty/serial/pch_uart.c               |    2 ++
 drivers/tty/serial/sb1250-duart.c           |    1 +
 drivers/tty/serial/serial_ks8695.c          |    1 +
 drivers/tty/serial/serial_txx9.c            |    2 ++
 drivers/tty/serial/sn_console.c             |    1 +
 drivers/tty/serial/timbuart.c               |    2 ++
 drivers/tty/serial/uartlite.c               |    1 +
 drivers/tty/serial/ucc_uart.c               |    4 +++-
 drivers/tty/serial/xilinx_uartps.c          |    4 +++-
 drivers/tty/serial/zs.c                     |    1 +
 22 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/apbuart.c b/drivers/tty/serial/apbuart.c
index 19a9436..77554fd 100644
--- a/drivers/tty/serial/apbuart.c
+++ b/drivers/tty/serial/apbuart.c
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/serial.h>
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index 9488da7..b418947 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -31,6 +31,7 @@
 
 #include <linux/module.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/serial.h>
diff --git a/drivers/tty/serial/dz.c b/drivers/tty/serial/dz.c
index ddc487a..e3699a8 100644
--- a/drivers/tty/serial/dz.c
+++ b/drivers/tty/serial/dz.c
@@ -47,6 +47,7 @@
 #include <linux/serial_core.h>
 #include <linux/sysrq.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 
 #include <linux/atomic.h>
 #include <asm/bootinfo.h>
diff --git a/drivers/tty/serial/ioc3_serial.c b/drivers/tty/serial/ioc3_serial.c
index ee43efc..758ff310 100644
--- a/drivers/tty/serial/ioc3_serial.c
+++ b/drivers/tty/serial/ioc3_serial.c
@@ -13,6 +13,7 @@
  */
 #include <linux/errno.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/serial.h>
 #include <linux/circ_buf.h>
 #include <linux/serial_reg.h>
diff --git a/drivers/tty/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
index fcfe826..6b36c15 100644
--- a/drivers/tty/serial/ioc4_serial.c
+++ b/drivers/tty/serial/ioc4_serial.c
@@ -14,6 +14,7 @@
  */
 #include <linux/errno.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/serial.h>
 #include <linux/serialP.h>
 #include <linux/circ_buf.h>
diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
index 8e07517..0801893 100644
--- a/drivers/tty/serial/m32r_sio.c
+++ b/drivers/tty/serial/m32r_sio.c
@@ -32,6 +32,7 @@
 
 #include <linux/module.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/console.h>
diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index 541fe79..8a6cc8c 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -48,6 +48,8 @@
 #include <linux/serial.h>
 #include <linux/spi/spi.h>
 #include <linux/freezer.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
 
 #include <linux/serial_max3100.h>
 
diff --git a/drivers/tty/serial/max3107.c b/drivers/tty/serial/max3107.c
index a50f406..7827000 100644
--- a/drivers/tty/serial/max3107.c
+++ b/drivers/tty/serial/max3107.c
@@ -31,6 +31,8 @@
 #include <linux/device.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/freezer.h>
diff --git a/drivers/tty/serial/mpc52xx_uart.c b/drivers/tty/serial/mpc52xx_uart.c
index a0bcd8a..c395520 100644
--- a/drivers/tty/serial/mpc52xx_uart.c
+++ b/drivers/tty/serial/mpc52xx_uart.c
@@ -34,6 +34,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/serial.h>
 #include <linux/sysrq.h>
 #include <linux/console.h>
diff --git a/drivers/tty/serial/msm_serial_hs.c b/drivers/tty/serial/msm_serial_hs.c
index 624701f..60c6eb8 100644
--- a/drivers/tty/serial/msm_serial_hs.c
+++ b/drivers/tty/serial/msm_serial_hs.c
@@ -30,6 +30,8 @@
 
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff --git a/drivers/tty/serial/mux.c b/drivers/tty/serial/mux.c
index 9711e06..06f6aef 100644
--- a/drivers/tty/serial/mux.c
+++ b/drivers/tty/serial/mux.c
@@ -21,6 +21,8 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/serial.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/console.h>
 #include <linux/delay.h> /* for udelay */
 #include <linux/device.h>
diff --git a/drivers/tty/serial/nwpserial.c b/drivers/tty/serial/nwpserial.c
index 4fcea03..a7fb418 100644
--- a/drivers/tty/serial/nwpserial.c
+++ b/drivers/tty/serial/nwpserial.c
@@ -15,6 +15,7 @@
 #include <linux/serial_reg.h>
 #include <linux/serial_core.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/irqreturn.h>
 #include <linux/mutex.h>
 #include <linux/export.h>
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index b46218d..21febef 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -20,6 +20,8 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/serial_core.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/dmi.h>
diff --git a/drivers/tty/serial/sb1250-duart.c b/drivers/tty/serial/sb1250-duart.c
index 6bc2e3f..0be8a2f 100644
--- a/drivers/tty/serial/sb1250-duart.c
+++ b/drivers/tty/serial/sb1250-duart.c
@@ -37,6 +37,7 @@
 #include <linux/spinlock.h>
 #include <linux/sysrq.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/types.h>
 
 #include <linux/atomic.h>
diff --git a/drivers/tty/serial/serial_ks8695.c b/drivers/tty/serial/serial_ks8695.c
index 2430319..5551f7a 100644
--- a/drivers/tty/serial/serial_ks8695.c
+++ b/drivers/tty/serial/serial_ks8695.c
@@ -13,6 +13,7 @@
  */
 #include <linux/module.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/serial.h>
diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index 8e3fc19..34bd345 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -28,6 +28,8 @@
 #include <linux/pci.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
 
 #include <asm/io.h>
 
diff --git a/drivers/tty/serial/sn_console.c b/drivers/tty/serial/sn_console.c
index 377ae74..7320507 100644
--- a/drivers/tty/serial/sn_console.c
+++ b/drivers/tty/serial/sn_console.c
@@ -39,6 +39,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/serial.h>
 #include <linux/console.h>
 #include <linux/module.h>
diff --git a/drivers/tty/serial/timbuart.c b/drivers/tty/serial/timbuart.c
index e213535..e76c8b7 100644
--- a/drivers/tty/serial/timbuart.c
+++ b/drivers/tty/serial/timbuart.c
@@ -23,6 +23,8 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/serial_core.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/ioport.h>
diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 8af1ed8..b908615 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -15,6 +15,7 @@
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index 9af9f08..cea8918 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -20,8 +20,10 @@
 
 #include <linux/module.h>
 #include <linux/serial.h>
-#include <linux/slab.h>
 #include <linux/serial_core.h>
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/io.h>
 #include <linux/of_platform.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 5d043de..b627363 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -12,9 +12,11 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/console.h>
-#include <linux/serial.h>
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/of.h>
diff --git a/drivers/tty/serial/zs.c b/drivers/tty/serial/zs.c
index 0aebd71..b7455b5 100644
--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -63,6 +63,7 @@
 #include <linux/spinlock.h>
 #include <linux/sysrq.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/types.h>
 
 #include <linux/atomic.h>
-- 
1.7.6.1



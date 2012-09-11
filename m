Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab2IKNEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:04:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab2IKNEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:04:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>, Nicolas Pitre <nico@fluxnic.net>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 14/16] ARM: orion: move platform_data definitions
Date: Tue, 11 Sep 2012 15:02:37 +0200
Message-Id: <1347368559-31329-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368559-31329-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368559-31329-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:XEPkcZqIFPsCpmKrBgzOe59xXPDNHYxGC4qm6vTBpUv
 4u9K+9Phs5QYMtx73BZnfQbiWsL1JW8xW0H0ewaAUo11yfvcMN
 3oQ8R46lF/FUvR8DGzJrdYIBEO9MFUxEpPrl7Xon989pgt6/HA
 Kxl3nE1huSEH/dHl32B2nlgV3NqOMkkEvwQkfaAC2w9HbQLbJU
 gRJrRBfVabkH9l4bcwas5vrTaDhIQBZ2IQZSZE78jof6VeIye4
 /nhPiJBMQONOquD11FqBqxKj6oO4/Z7RNI/avoUrZCfQveXfnx
 7IqQbskzXsUUF+7Fv+rf391UP1zevtdTzqO/LFVbYtt4TldNtm
 Z7DDS5OjtU1BKNeH8blLJmgce8szqwreJxdGahKT6kzefEIlGs
 CmcuZlGteSLNB9ClQW7I+U8U8CwWIlzPLU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the orion include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Chris Ball <cjb@laptop.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
---
 arch/arm/mach-dove/common.c                                  |    2 +-
 arch/arm/mach-kirkwood/board-dreamplug.c                     |    2 +-
 arch/arm/mach-kirkwood/board-goflexnet.c                     |    2 +-
 arch/arm/mach-kirkwood/common.c                              |   10 +++++-----
 arch/arm/mach-kirkwood/d2net_v2-setup.c                      |    2 +-
 arch/arm/mach-kirkwood/db88f6281-bp-setup.c                  |    2 +-
 arch/arm/mach-kirkwood/dockstar-setup.c                      |    2 +-
 arch/arm/mach-kirkwood/guruplug-setup.c                      |    2 +-
 arch/arm/mach-kirkwood/netspace_v2-setup.c                   |    2 +-
 arch/arm/mach-kirkwood/netxbig_v2-setup.c                    |    2 +-
 arch/arm/mach-kirkwood/openrd-setup.c                        |    2 +-
 arch/arm/mach-kirkwood/rd88f6281-setup.c                     |    2 +-
 arch/arm/mach-kirkwood/sheevaplug-setup.c                    |    2 +-
 arch/arm/mach-mv78xx0/common.c                               |    4 ++--
 arch/arm/mach-orion5x/common.c                               |    4 ++--
 arch/arm/mach-orion5x/db88f5281-setup.c                      |    2 +-
 arch/arm/mach-orion5x/kurobox_pro-setup.c                    |    2 +-
 arch/arm/plat-orion/common.c                                 |    4 ++--
 drivers/dma/mv_xor.c                                         |    2 +-
 drivers/leds/leds-netxbig.c                                  |    2 +-
 drivers/leds/leds-ns2.c                                      |    2 +-
 drivers/mmc/host/mvsdio.c                                    |    2 +-
 drivers/mtd/nand/orion_nand.c                                |    2 +-
 drivers/usb/host/ehci-orion.c                                |    2 +-
 .../audio.h => include/linux/platform_data/asoc-kirkwood.h   |    0
 .../mv_xor.h => include/linux/platform_data/dma-mv_xor.h     |    0
 .../linux/platform_data/leds-kirkwood-netxbig.h              |    0
 .../linux/platform_data/leds-kirkwood-ns2.h                  |    0
 .../mvsdio.h => include/linux/platform_data/mmc-mvsdio.h     |    0
 .../linux/platform_data/mtd-orion_nand.h                     |    0
 .../linux/platform_data/usb-ehci-orion.h                     |    0
 sound/soc/kirkwood/kirkwood-i2s.c                            |    2 +-
 sound/soc/kirkwood/kirkwood-openrd.c                         |    2 +-
 sound/soc/kirkwood/kirkwood-t5325.c                          |    2 +-
 34 files changed, 34 insertions(+), 34 deletions(-)
 rename arch/arm/plat-orion/include/plat/audio.h => include/linux/platform_data/asoc-kirkwood.h (100%)
 rename arch/arm/plat-orion/include/plat/mv_xor.h => include/linux/platform_data/dma-mv_xor.h (100%)
 rename arch/arm/mach-kirkwood/include/mach/leds-netxbig.h => include/linux/platform_data/leds-kirkwood-netxbig.h (100%)
 rename arch/arm/mach-kirkwood/include/mach/leds-ns2.h => include/linux/platform_data/leds-kirkwood-ns2.h (100%)
 rename arch/arm/plat-orion/include/plat/mvsdio.h => include/linux/platform_data/mmc-mvsdio.h (100%)
 rename arch/arm/plat-orion/include/plat/orion_nand.h => include/linux/platform_data/mtd-orion_nand.h (100%)
 rename arch/arm/plat-orion/include/plat/ehci-orion.h => include/linux/platform_data/usb-ehci-orion.h (100%)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 4db5de5..29d63fa 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -28,7 +28,7 @@
 #include <asm/mach/arch.h>
 #include <linux/irq.h>
 #include <plat/time.h>
-#include <plat/ehci-orion.h>
+#include <linux/platform_data/usb-ehci-orion.h>
 #include <plat/common.h>
 #include <plat/addr-map.h>
 #include "common.h"
diff --git a/arch/arm/mach-kirkwood/board-dreamplug.c b/arch/arm/mach-kirkwood/board-dreamplug.c
index aeb234d..20af53a 100644
--- a/arch/arm/mach-kirkwood/board-dreamplug.c
+++ b/arch/arm/mach-kirkwood/board-dreamplug.c
@@ -30,7 +30,7 @@
 #include <asm/mach/map.h>
 #include <mach/kirkwood.h>
 #include <mach/bridge-regs.h>
-#include <plat/mvsdio.h>
+#include <linux/platform_data/mmc-mvsdio.h>
 #include "common.h"
 #include "mpp.h"
 
diff --git a/arch/arm/mach-kirkwood/board-goflexnet.c b/arch/arm/mach-kirkwood/board-goflexnet.c
index 413e2c8..001ca8c 100644
--- a/arch/arm/mach-kirkwood/board-goflexnet.c
+++ b/arch/arm/mach-kirkwood/board-goflexnet.c
@@ -32,7 +32,7 @@
 #include <asm/mach/map.h>
 #include <mach/kirkwood.h>
 #include <mach/bridge-regs.h>
-#include <plat/mvsdio.h>
+#include <linux/platform_data/mmc-mvsdio.h>
 #include "common.h"
 #include "mpp.h"
 
diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index c4b64ad..bd5ea69 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -26,15 +26,15 @@
 #include <asm/mach/time.h>
 #include <mach/kirkwood.h>
 #include <mach/bridge-regs.h>
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-kirkwood.h>
 #include <plat/cache-feroceon-l2.h>
-#include <plat/mvsdio.h>
-#include <plat/orion_nand.h>
-#include <plat/ehci-orion.h>
+#include <linux/platform_data/mmc-mvsdio.h>
+#include <linux/platform_data/mtd-orion_nand.h>
+#include <linux/platform_data/usb-ehci-orion.h>
 #include <plat/common.h>
 #include <plat/time.h>
 #include <plat/addr-map.h>
-#include <plat/mv_xor.h>
+#include <linux/platform_data/dma-mv_xor.h>
 #include "common.h"
 
 /*****************************************************************************
diff --git a/arch/arm/mach-kirkwood/d2net_v2-setup.c b/arch/arm/mach-kirkwood/d2net_v2-setup.c
index 6e1bac9..2c1a453 100644
--- a/arch/arm/mach-kirkwood/d2net_v2-setup.c
+++ b/arch/arm/mach-kirkwood/d2net_v2-setup.c
@@ -32,7 +32,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/kirkwood.h>
-#include <mach/leds-ns2.h>
+#include <linux/platform_data/leds-kirkwood-ns2.h>
 #include "common.h"
 #include "mpp.h"
 #include "lacie_v2-common.h"
diff --git a/arch/arm/mach-kirkwood/db88f6281-bp-setup.c b/arch/arm/mach-kirkwood/db88f6281-bp-setup.c
index d933593..044a631c 100644
--- a/arch/arm/mach-kirkwood/db88f6281-bp-setup.c
+++ b/arch/arm/mach-kirkwood/db88f6281-bp-setup.c
@@ -17,7 +17,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/kirkwood.h>
-#include <plat/mvsdio.h>
+#include <linux/platform_data/mmc-mvsdio.h>
 #include "common.h"
 #include "mpp.h"
 
diff --git a/arch/arm/mach-kirkwood/dockstar-setup.c b/arch/arm/mach-kirkwood/dockstar-setup.c
index 61d9a55..23dcb19 100644
--- a/arch/arm/mach-kirkwood/dockstar-setup.c
+++ b/arch/arm/mach-kirkwood/dockstar-setup.c
@@ -19,7 +19,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/kirkwood.h>
-#include <plat/mvsdio.h>
+#include <linux/platform_data/mmc-mvsdio.h>
 #include "common.h"
 #include "mpp.h"
 
diff --git a/arch/arm/mach-kirkwood/guruplug-setup.c b/arch/arm/mach-kirkwood/guruplug-setup.c
index bdaed38..7cb55f9 100644
--- a/arch/arm/mach-kirkwood/guruplug-setup.c
+++ b/arch/arm/mach-kirkwood/guruplug-setup.c
@@ -19,7 +19,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/kirkwood.h>
-#include <plat/mvsdio.h>
+#include <linux/platform_data/mmc-mvsdio.h>
 #include "common.h"
 #include "mpp.h"
 
diff --git a/arch/arm/mach-kirkwood/netspace_v2-setup.c b/arch/arm/mach-kirkwood/netspace_v2-setup.c
index e6bba01..88b0788 100644
--- a/arch/arm/mach-kirkwood/netspace_v2-setup.c
+++ b/arch/arm/mach-kirkwood/netspace_v2-setup.c
@@ -34,7 +34,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/kirkwood.h>
-#include <mach/leds-ns2.h>
+#include <linux/platform_data/leds-kirkwood-ns2.h>
 #include "common.h"
 #include "mpp.h"
 #include "lacie_v2-common.h"
diff --git a/arch/arm/mach-kirkwood/netxbig_v2-setup.c b/arch/arm/mach-kirkwood/netxbig_v2-setup.c
index 31ae8de..a3b0914 100644
--- a/arch/arm/mach-kirkwood/netxbig_v2-setup.c
+++ b/arch/arm/mach-kirkwood/netxbig_v2-setup.c
@@ -32,7 +32,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/kirkwood.h>
-#include <mach/leds-netxbig.h>
+#include <linux/platform_data/leds-kirkwood-netxbig.h>
 #include "common.h"
 #include "mpp.h"
 #include "lacie_v2-common.h"
diff --git a/arch/arm/mach-kirkwood/openrd-setup.c b/arch/arm/mach-kirkwood/openrd-setup.c
index 7e99c3f..134ef50 100644
--- a/arch/arm/mach-kirkwood/openrd-setup.c
+++ b/arch/arm/mach-kirkwood/openrd-setup.c
@@ -20,7 +20,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/kirkwood.h>
-#include <plat/mvsdio.h>
+#include <linux/platform_data/mmc-mvsdio.h>
 #include "common.h"
 #include "mpp.h"
 
diff --git a/arch/arm/mach-kirkwood/rd88f6281-setup.c b/arch/arm/mach-kirkwood/rd88f6281-setup.c
index ef92207..9717101 100644
--- a/arch/arm/mach-kirkwood/rd88f6281-setup.c
+++ b/arch/arm/mach-kirkwood/rd88f6281-setup.c
@@ -20,7 +20,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/kirkwood.h>
-#include <plat/mvsdio.h>
+#include <linux/platform_data/mmc-mvsdio.h>
 #include "common.h"
 #include "mpp.h"
 
diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/sheevaplug-setup.c
index 4ea70e5f..28d0aba 100644
--- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
+++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
@@ -19,7 +19,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/kirkwood.h>
-#include <plat/mvsdio.h>
+#include <linux/platform_data/mmc-mvsdio.h>
 #include "common.h"
 #include "mpp.h"
 
diff --git a/arch/arm/mach-mv78xx0/common.c b/arch/arm/mach-mv78xx0/common.c
index b4c53b8..26de7f4 100644
--- a/arch/arm/mach-mv78xx0/common.c
+++ b/arch/arm/mach-mv78xx0/common.c
@@ -20,8 +20,8 @@
 #include <mach/mv78xx0.h>
 #include <mach/bridge-regs.h>
 #include <plat/cache-feroceon-l2.h>
-#include <plat/ehci-orion.h>
-#include <plat/orion_nand.h>
+#include <linux/platform_data/usb-ehci-orion.h>
+#include <linux/platform_data/mtd-orion_nand.h>
 #include <plat/time.h>
 #include <plat/common.h>
 #include <plat/addr-map.h>
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 9148b22..ca67e82 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -30,8 +30,8 @@
 #include <mach/bridge-regs.h>
 #include <mach/hardware.h>
 #include <mach/orion5x.h>
-#include <plat/orion_nand.h>
-#include <plat/ehci-orion.h>
+#include <linux/platform_data/mtd-orion_nand.h>
+#include <linux/platform_data/usb-ehci-orion.h>
 #include <plat/time.h>
 #include <plat/common.h>
 #include <plat/addr-map.h>
diff --git a/arch/arm/mach-orion5x/db88f5281-setup.c b/arch/arm/mach-orion5x/db88f5281-setup.c
index 49a3fd6..41fe2b1 100644
--- a/arch/arm/mach-orion5x/db88f5281-setup.c
+++ b/arch/arm/mach-orion5x/db88f5281-setup.c
@@ -24,7 +24,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/pci.h>
 #include <mach/orion5x.h>
-#include <plat/orion_nand.h>
+#include <linux/platform_data/mtd-orion_nand.h>
 #include "common.h"
 #include "mpp.h"
 
diff --git a/arch/arm/mach-orion5x/kurobox_pro-setup.c b/arch/arm/mach-orion5x/kurobox_pro-setup.c
index 1e458ef..f1ae10a 100644
--- a/arch/arm/mach-orion5x/kurobox_pro-setup.c
+++ b/arch/arm/mach-orion5x/kurobox_pro-setup.c
@@ -24,7 +24,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/pci.h>
 #include <mach/orion5x.h>
-#include <plat/orion_nand.h>
+#include <linux/platform_data/mtd-orion_nand.h>
 #include "common.h"
 #include "mpp.h"
 
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index d245a87..9148eb0 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -19,8 +19,8 @@
 #include <linux/mv643xx_eth.h>
 #include <linux/mv643xx_i2c.h>
 #include <net/dsa.h>
-#include <plat/mv_xor.h>
-#include <plat/ehci-orion.h>
+#include <linux/platform_data/dma-mv_xor.h>
+#include <linux/platform_data/usb-ehci-orion.h>
 #include <mach/bridge-regs.h>
 
 /* Create a clkdev entry for a given device/clk */
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 0b12e68..e362e2b 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -26,7 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/memory.h>
 #include <linux/clk.h>
-#include <plat/mv_xor.h>
+#include <linux/platform_data/dma-mv_xor.h>
 
 #include "dmaengine.h"
 #include "mv_xor.h"
diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index e37618e..461bbf9 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -28,7 +28,7 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/leds.h>
-#include <mach/leds-netxbig.h>
+#include <linux/platform_data/leds-kirkwood-netxbig.h>
 
 /*
  * GPIO extension bus.
diff --git a/drivers/leds/leds-ns2.c b/drivers/leds/leds-ns2.c
index 10528da..d176ec8 100644
--- a/drivers/leds/leds-ns2.c
+++ b/drivers/leds/leds-ns2.c
@@ -29,7 +29,7 @@
 #include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/module.h>
-#include <mach/leds-ns2.h>
+#include <linux/platform_data/leds-kirkwood-ns2.h>
 
 /*
  * The Network Space v2 dual-GPIO LED is wired to a CPLD and can blink in
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index a61cb5f..de4c20b 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -25,7 +25,7 @@
 
 #include <asm/sizes.h>
 #include <asm/unaligned.h>
-#include <plat/mvsdio.h>
+#include <linux/platform_data/mmc-mvsdio.h>
 
 #include "mvsdio.h"
 
diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index fc5a868..131b58a 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -22,7 +22,7 @@
 #include <asm/io.h>
 #include <asm/sizes.h>
 #include <mach/hardware.h>
-#include <plat/orion_nand.h>
+#include <linux/platform_data/mtd-orion_nand.h>
 
 static void orion_nand_cmd_ctrl(struct mtd_info *mtd, int cmd, unsigned int ctrl)
 {
diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 8892d36..8e7eca6 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -13,7 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/mbus.h>
 #include <linux/clk.h>
-#include <plat/ehci-orion.h>
+#include <linux/platform_data/usb-ehci-orion.h>
 
 #define rdl(off)	__raw_readl(hcd->regs + (off))
 #define wrl(off, val)	__raw_writel((val), hcd->regs + (off))
diff --git a/arch/arm/plat-orion/include/plat/audio.h b/include/linux/platform_data/asoc-kirkwood.h
similarity index 100%
rename from arch/arm/plat-orion/include/plat/audio.h
rename to include/linux/platform_data/asoc-kirkwood.h
diff --git a/arch/arm/plat-orion/include/plat/mv_xor.h b/include/linux/platform_data/dma-mv_xor.h
similarity index 100%
rename from arch/arm/plat-orion/include/plat/mv_xor.h
rename to include/linux/platform_data/dma-mv_xor.h
diff --git a/arch/arm/mach-kirkwood/include/mach/leds-netxbig.h b/include/linux/platform_data/leds-kirkwood-netxbig.h
similarity index 100%
rename from arch/arm/mach-kirkwood/include/mach/leds-netxbig.h
rename to include/linux/platform_data/leds-kirkwood-netxbig.h
diff --git a/arch/arm/mach-kirkwood/include/mach/leds-ns2.h b/include/linux/platform_data/leds-kirkwood-ns2.h
similarity index 100%
rename from arch/arm/mach-kirkwood/include/mach/leds-ns2.h
rename to include/linux/platform_data/leds-kirkwood-ns2.h
diff --git a/arch/arm/plat-orion/include/plat/mvsdio.h b/include/linux/platform_data/mmc-mvsdio.h
similarity index 100%
rename from arch/arm/plat-orion/include/plat/mvsdio.h
rename to include/linux/platform_data/mmc-mvsdio.h
diff --git a/arch/arm/plat-orion/include/plat/orion_nand.h b/include/linux/platform_data/mtd-orion_nand.h
similarity index 100%
rename from arch/arm/plat-orion/include/plat/orion_nand.h
rename to include/linux/platform_data/mtd-orion_nand.h
diff --git a/arch/arm/plat-orion/include/plat/ehci-orion.h b/include/linux/platform_data/usb-ehci-orion.h
similarity index 100%
rename from arch/arm/plat-orion/include/plat/ehci-orion.h
rename to include/linux/platform_data/usb-ehci-orion.h
diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 7646dd7..542538d 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -21,7 +21,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-kirkwood.h>
 #include "kirkwood.h"
 
 #define DRV_NAME	"kirkwood-i2s"
diff --git a/sound/soc/kirkwood/kirkwood-openrd.c b/sound/soc/kirkwood/kirkwood-openrd.c
index 80bd59c..c28540a 100644
--- a/sound/soc/kirkwood/kirkwood-openrd.c
+++ b/sound/soc/kirkwood/kirkwood-openrd.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <sound/soc.h>
 #include <mach/kirkwood.h>
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-kirkwood.h>
 #include <asm/mach-types.h>
 #include "../codecs/cs42l51.h"
 
diff --git a/sound/soc/kirkwood/kirkwood-t5325.c b/sound/soc/kirkwood/kirkwood-t5325.c
index f898363..c67bbc5 100644
--- a/sound/soc/kirkwood/kirkwood-t5325.c
+++ b/sound/soc/kirkwood/kirkwood-t5325.c
@@ -16,7 +16,7 @@
 #include <linux/slab.h>
 #include <sound/soc.h>
 #include <mach/kirkwood.h>
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-kirkwood.h>
 #include <asm/mach-types.h>
 #include "../codecs/alc5623.h"
 
-- 
1.7.10


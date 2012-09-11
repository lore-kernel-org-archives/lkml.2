Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2IKNA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:00:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2IKNAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:00:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH 12/16] ARM: nomadik: move platform_data definitions
Date: Tue, 11 Sep 2012 14:59:46 +0200
Message-Id: <1347368390-31252-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368390-31252-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:meW9WweLajCELJ/4vFo1AtPS703thfrJ/356zoHXBkB
 FQN70qj9IB++Nh6r1XnJI9l+W76jMOLSfLQL00+MaTgcshMmH8
 oyt6i6nmHSOwpP13R0kVDUVH0zPuj55A0sb9w7ADbfT9kQmK0T
 MhNtjaoioxUL6WVX1wirVtlbrk5jEm3xfvTJ3DKJ2BVlHUso+E
 j6F1XAA/IcarAAfh5jnkn73pX0qfTSFDZmabTzHP3m8HdTTDTx
 QdtfQzxtLWJW059fZSsF91wxslA24U/bzVrKlrNwahWm+gQX4t
 DagNwyIlmGRR+xIdxd0MaKLzujfTgbmwGee/vm0DkPp8FndgFw
 60VcKXrk2/mYmfE2gRmsycbyUivnry29PXiS9Jtr+kQZjZ7Dul
 D0qWaEnAK1bY6akuzNoH1N24w0ruWoCpNU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the nomadik include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andreas Westin <andreas.westin@stericsson.com>
---
 arch/arm/mach-nomadik/board-nhk8815.c                                |    2 +-
 arch/arm/mach-u300/core.c                                            |    2 +-
 arch/arm/mach-ux500/board-mop500.c                                   |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c                                     |    2 +-
 arch/arm/mach-ux500/devices-common.h                                 |    2 +-
 arch/arm/mach-ux500/usb.c                                            |    2 +-
 drivers/crypto/ux500/cryp/cryp_core.c                                |    2 +-
 drivers/crypto/ux500/hash/hash_core.c                                |    2 +-
 drivers/input/keyboard/nomadik-ske-keypad.c                          |    2 +-
 drivers/mtd/nand/nomadik_nand.c                                      |    2 +-
 drivers/pinctrl/pinctrl-coh901.c                                     |    2 +-
 drivers/usb/musb/ux500_dma.c                                         |    2 +-
 .../include/mach => include/linux/platform_data}/crypto-ux500.h      |    0
 .../plat/ske.h => include/linux/platform_data/keypad-nomadik-ske.h   |    0
 .../mach/nand.h => include/linux/platform_data/mtd-nomadik-nand.h    |    0
 .../mach/gpio-u300.h => include/linux/platform_data/pinctrl-coh901.h |    0
 .../mach/usb.h => include/linux/platform_data/usb-musb-ux500.h       |    0
 17 files changed, 12 insertions(+), 12 deletions(-)
 rename {arch/arm/mach-ux500/include/mach => include/linux/platform_data}/crypto-ux500.h (100%)
 rename arch/arm/plat-nomadik/include/plat/ske.h => include/linux/platform_data/keypad-nomadik-ske.h (100%)
 rename arch/arm/mach-nomadik/include/mach/nand.h => include/linux/platform_data/mtd-nomadik-nand.h (100%)
 rename arch/arm/mach-u300/include/mach/gpio-u300.h => include/linux/platform_data/pinctrl-coh901.h (100%)
 rename arch/arm/mach-ux500/include/mach/usb.h => include/linux/platform_data/usb-musb-ux500.h (100%)

diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index f4535a7..381c080 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -34,7 +34,7 @@
 #include <plat/gpio-nomadik.h>
 #include <plat/mtu.h>
 
-#include <mach/nand.h>
+#include <linux/platform_data/mtd-nomadik-nand.h>
 #include <mach/fsmc.h>
 
 #include "cpu-8815.h"
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 03acf18..62adfe7 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -43,7 +43,7 @@
 #include <mach/hardware.h>
 #include <mach/syscon.h>
 #include <mach/dma_channels.h>
-#include <mach/gpio-u300.h>
+#include <linux/platform_data/pinctrl-coh901.h>
 
 #include "spi.h"
 #include "i2c.h"
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 8674a89..38854d4 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -48,7 +48,7 @@
 #include <mach/setup.h>
 #include <mach/devices.h>
 #include <mach/irqs.h>
-#include <mach/crypto-ux500.h>
+#include <linux/platform_data/crypto-ux500.h>
 
 #include "ste-dma40-db8500.h"
 #include "devices-db8500.h"
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index db3c52d..1bef4c3 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -24,7 +24,7 @@
 #include <mach/hardware.h>
 #include <mach/setup.h>
 #include <mach/devices.h>
-#include <mach/usb.h>
+#include <linux/platform_data/usb-musb-ux500.h>
 #include <mach/db8500-regs.h>
 
 #include "devices-db8500.h"
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index ecdd838..7fbf0ba 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -13,7 +13,7 @@
 #include <linux/sys_soc.h>
 #include <linux/amba/bus.h>
 #include <linux/platform_data/i2c-nomadik.h>
-#include <mach/crypto-ux500.h>
+#include <linux/platform_data/crypto-ux500.h>
 
 struct spi_master_cntlr;
 
diff --git a/arch/arm/mach-ux500/usb.c b/arch/arm/mach-ux500/usb.c
index a74af38..145482e 100644
--- a/arch/arm/mach-ux500/usb.c
+++ b/arch/arm/mach-ux500/usb.c
@@ -10,7 +10,7 @@
 
 #include <plat/ste_dma40.h>
 #include <mach/hardware.h>
-#include <mach/usb.h>
+#include <linux/platform_data/usb-musb-ux500.h>
 
 #define MUSB_DMA40_RX_CH { \
 		.mode = STEDMA40_MODE_LOGICAL, \
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 1c307e1..ef17e38 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -32,7 +32,7 @@
 
 #include <plat/ste_dma40.h>
 
-#include <mach/crypto-ux500.h>
+#include <linux/platform_data/crypto-ux500.h>
 #include <mach/hardware.h>
 
 #include "cryp_p.h"
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 08d5032..0876507 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -31,7 +31,7 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/algapi.h>
 
-#include <mach/crypto-ux500.h>
+#include <linux/platform_data/crypto-ux500.h>
 #include <mach/hardware.h>
 
 #include "hash_alg.h"
diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
index a880e74..49f5fa6 100644
--- a/drivers/input/keyboard/nomadik-ske-keypad.c
+++ b/drivers/input/keyboard/nomadik-ske-keypad.c
@@ -20,7 +20,7 @@
 #include <linux/clk.h>
 #include <linux/module.h>
 
-#include <plat/ske.h>
+#include <linux/platform_data/keypad-nomadik-ske.h>
 
 /* SKE_CR bits */
 #define SKE_KPMLT	(0x1 << 6)
diff --git a/drivers/mtd/nand/nomadik_nand.c b/drivers/mtd/nand/nomadik_nand.c
index a86aa81..9ee0c4e 100644
--- a/drivers/mtd/nand/nomadik_nand.c
+++ b/drivers/mtd/nand/nomadik_nand.c
@@ -31,7 +31,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include <mach/nand.h>
+#include <linux/platform_data/mtd-nomadik-nand.h>
 #include <mach/fsmc.h>
 
 #include <mtd/mtd-abi.h>
diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index cc0f00d..b7f41e9 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/pinctrl/pinconf-generic.h>
-#include <mach/gpio-u300.h>
+#include <linux/platform_data/pinctrl-coh901.h>
 #include "pinctrl-coh901.h"
 
 /*
diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index d05c7fb..f82246d 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -30,7 +30,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/pfn.h>
-#include <mach/usb.h>
+#include <linux/platform_data/usb-musb-ux500.h>
 #include "musb_core.h"
 
 struct ux500_dma_channel {
diff --git a/arch/arm/mach-ux500/include/mach/crypto-ux500.h b/include/linux/platform_data/crypto-ux500.h
similarity index 100%
rename from arch/arm/mach-ux500/include/mach/crypto-ux500.h
rename to include/linux/platform_data/crypto-ux500.h
diff --git a/arch/arm/plat-nomadik/include/plat/ske.h b/include/linux/platform_data/keypad-nomadik-ske.h
similarity index 100%
rename from arch/arm/plat-nomadik/include/plat/ske.h
rename to include/linux/platform_data/keypad-nomadik-ske.h
diff --git a/arch/arm/mach-nomadik/include/mach/nand.h b/include/linux/platform_data/mtd-nomadik-nand.h
similarity index 100%
rename from arch/arm/mach-nomadik/include/mach/nand.h
rename to include/linux/platform_data/mtd-nomadik-nand.h
diff --git a/arch/arm/mach-u300/include/mach/gpio-u300.h b/include/linux/platform_data/pinctrl-coh901.h
similarity index 100%
rename from arch/arm/mach-u300/include/mach/gpio-u300.h
rename to include/linux/platform_data/pinctrl-coh901.h
diff --git a/arch/arm/mach-ux500/include/mach/usb.h b/include/linux/platform_data/usb-musb-ux500.h
similarity index 100%
rename from arch/arm/mach-ux500/include/mach/usb.h
rename to include/linux/platform_data/usb-musb-ux500.h
-- 
1.7.10


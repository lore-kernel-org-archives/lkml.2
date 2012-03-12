Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2CLRNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:13:45 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:46297 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab2CLRNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:13:17 -0400
From: Martyn Welch <martyn.welch@ge.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Martyn Welch <martyn.welch@ge.com>
Subject: [PATCH v3 3/4] powerpc: Move GE PIC drivers
Date: Mon, 12 Mar 2012 17:12:59 +0000
Message-Id: <1331572380-1064-4-git-send-email-martyn.welch@ge.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>
References: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the GE PIC drivers to allow these to be used by non-86xx boards.

Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

v2: Move GPIO and PIC drivers to sysdev/ge/ rather than platforms/.

v3: Now just PIC driver. GPIO driver going to drivers/gpio.

 arch/powerpc/platforms/86xx/Kconfig                |    4 ----
 arch/powerpc/platforms/86xx/Makefile               |    1 -
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |    2 +-
 arch/powerpc/platforms/86xx/gef_sbc310.c           |    2 +-
 arch/powerpc/platforms/86xx/gef_sbc610.c           |    2 +-
 arch/powerpc/sysdev/Kconfig                        |    4 ++++
 arch/powerpc/sysdev/Makefile                       |    2 ++
 arch/powerpc/sysdev/ge/Makefile                    |    1 +
 .../86xx/gef_pic.c => sysdev/ge/ge_pic.c}          |    2 +-
 .../86xx/gef_pic.h => sysdev/ge/ge_pic.h}          |    0
 10 files changed, 11 insertions(+), 9 deletions(-)
 create mode 100644 arch/powerpc/sysdev/ge/Makefile
 rename arch/powerpc/{platforms/86xx/gef_pic.c => sysdev/ge/ge_pic.c} (99%)
 rename arch/powerpc/{platforms/86xx/gef_pic.h => sysdev/ge/ge_pic.h} (100%)

diff --git a/arch/powerpc/platforms/86xx/Kconfig b/arch/powerpc/platforms/86xx/Kconfig
index abe2c4f..7a6279e 100644
--- a/arch/powerpc/platforms/86xx/Kconfig
+++ b/arch/powerpc/platforms/86xx/Kconfig
@@ -64,10 +64,6 @@ config GEF_SBC610
 	help
 	  This option enables support for the GE SBC610.
 
-config GE_FPGA
-	bool
-	default n
-
 endif
 
 config MPC8641
diff --git a/arch/powerpc/platforms/86xx/Makefile b/arch/powerpc/platforms/86xx/Makefile
index 1ee6ca8..ede815d 100644
--- a/arch/powerpc/platforms/86xx/Makefile
+++ b/arch/powerpc/platforms/86xx/Makefile
@@ -7,7 +7,6 @@ obj-$(CONFIG_SMP)		+= mpc86xx_smp.o
 obj-$(CONFIG_MPC8641_HPCN)	+= mpc86xx_hpcn.o
 obj-$(CONFIG_SBC8641D)		+= sbc8641d.o
 obj-$(CONFIG_MPC8610_HPCD)	+= mpc8610_hpcd.o
-obj-$(CONFIG_GE_FPGA)		+= gef_pic.o
 obj-$(CONFIG_GEF_SBC610)	+= gef_sbc610.o
 obj-$(CONFIG_GEF_SBC310)	+= gef_sbc310.o
 obj-$(CONFIG_GEF_PPC9A)		+= gef_ppc9a.o
diff --git a/arch/powerpc/platforms/86xx/gef_ppc9a.c b/arch/powerpc/platforms/86xx/gef_ppc9a.c
index 60ce07e..ed58b6c 100644
--- a/arch/powerpc/platforms/86xx/gef_ppc9a.c
+++ b/arch/powerpc/platforms/86xx/gef_ppc9a.c
@@ -37,9 +37,9 @@
 
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
+#include <sysdev/ge/ge_pic.h>
 
 #include "mpc86xx.h"
-#include "gef_pic.h"
 
 #undef DEBUG
 
diff --git a/arch/powerpc/platforms/86xx/gef_sbc310.c b/arch/powerpc/platforms/86xx/gef_sbc310.c
index 3ecee25..710db69 100644
--- a/arch/powerpc/platforms/86xx/gef_sbc310.c
+++ b/arch/powerpc/platforms/86xx/gef_sbc310.c
@@ -37,9 +37,9 @@
 
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
+#include <sysdev/ge/ge_pic.h>
 
 #include "mpc86xx.h"
-#include "gef_pic.h"
 
 #undef DEBUG
 
diff --git a/arch/powerpc/platforms/86xx/gef_sbc610.c b/arch/powerpc/platforms/86xx/gef_sbc610.c
index 5090d60..4a13d2f 100644
--- a/arch/powerpc/platforms/86xx/gef_sbc610.c
+++ b/arch/powerpc/platforms/86xx/gef_sbc610.c
@@ -37,9 +37,9 @@
 
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
+#include <sysdev/ge/ge_pic.h>
 
 #include "mpc86xx.h"
-#include "gef_pic.h"
 
 #undef DEBUG
 
diff --git a/arch/powerpc/sysdev/Kconfig b/arch/powerpc/sysdev/Kconfig
index 7b4df37..a84fecf 100644
--- a/arch/powerpc/sysdev/Kconfig
+++ b/arch/powerpc/sysdev/Kconfig
@@ -29,3 +29,7 @@ config SCOM_DEBUGFS
 	bool "Expose SCOM controllers via debugfs"
 	depends on PPC_SCOM
 	default n
+
+config GE_FPGA
+	bool
+	default n
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index 5e37b47..f80ff9f 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -65,3 +65,5 @@ obj-$(CONFIG_PPC_SCOM)		+= scom.o
 subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
 obj-$(CONFIG_PPC_XICS)		+= xics/
+
+obj-$(CONFIG_GE_FPGA)		+= ge/
diff --git a/arch/powerpc/sysdev/ge/Makefile b/arch/powerpc/sysdev/ge/Makefile
new file mode 100644
index 0000000..8731ffc
--- /dev/null
+++ b/arch/powerpc/sysdev/ge/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_GE_FPGA)		+= ge_pic.o
diff --git a/arch/powerpc/platforms/86xx/gef_pic.c b/arch/powerpc/sysdev/ge/ge_pic.c
similarity index 99%
rename from arch/powerpc/platforms/86xx/gef_pic.c
rename to arch/powerpc/sysdev/ge/ge_pic.c
index 94594e5..002a562 100644
--- a/arch/powerpc/platforms/86xx/gef_pic.c
+++ b/arch/powerpc/sysdev/ge/ge_pic.c
@@ -22,7 +22,7 @@
 #include <asm/prom.h>
 #include <asm/irq.h>
 
-#include "gef_pic.h"
+#include "ge_pic.h"
 
 #define DEBUG
 #undef DEBUG
diff --git a/arch/powerpc/platforms/86xx/gef_pic.h b/arch/powerpc/sysdev/ge/ge_pic.h
similarity index 100%
rename from arch/powerpc/platforms/86xx/gef_pic.h
rename to arch/powerpc/sysdev/ge/ge_pic.h
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab2KUC1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:27:49 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2KUC11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:27:27 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 40/42] sh-pfc: Move sh_pfc.h from include/linux/ to driver directory
Date: Wed, 21 Nov 2012 03:27:41 +0100
Message-Id: <1353464863-10281-41-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header file isn't used by arch code anymore. Make it private to the
driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/pinctrl/sh-pfc/core.c        |    1 -
 drivers/pinctrl/sh-pfc/core.h        |    3 +-
 drivers/pinctrl/sh-pfc/gpio.c        |    1 -
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c |    3 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7779.c |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7203.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7264.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7269.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7367.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7372.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7377.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7720.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7722.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7723.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7724.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7757.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7785.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7786.c  |    3 +-
 drivers/pinctrl/sh-pfc/pfc-shx3.c    |    3 +-
 drivers/pinctrl/sh-pfc/pinctrl.c     |    1 -
 drivers/pinctrl/sh-pfc/sh_pfc.h      |  195 ++++++++++++++++++++++++++++++++++
 include/linux/sh_pfc.h               |  195 ----------------------------------
 24 files changed, 233 insertions(+), 217 deletions(-)
 create mode 100644 drivers/pinctrl/sh-pfc/sh_pfc.h
 delete mode 100644 include/linux/sh_pfc.h

diff --git a/drivers/pinctrl/sh-pfc/core.c b/drivers/pinctrl/sh-pfc/core.c
index 748206f..05ce6c0 100644
--- a/drivers/pinctrl/sh-pfc/core.c
+++ b/drivers/pinctrl/sh-pfc/core.c
@@ -19,7 +19,6 @@
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/sh_pfc.h>
 #include <linux/slab.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/platform_device.h>
diff --git a/drivers/pinctrl/sh-pfc/core.h b/drivers/pinctrl/sh-pfc/core.h
index ee123de..cd38cfe 100644
--- a/drivers/pinctrl/sh-pfc/core.h
+++ b/drivers/pinctrl/sh-pfc/core.h
@@ -11,9 +11,10 @@
 #define __SH_PFC_CORE_H__
 
 #include <linux/compiler.h>
-#include <linux/sh_pfc.h>
 #include <linux/types.h>
 
+#include "sh_pfc.h"
+
 struct pfc_window {
 	phys_addr_t phys;
 	void __iomem *virt;
diff --git a/drivers/pinctrl/sh-pfc/gpio.c b/drivers/pinctrl/sh-pfc/gpio.c
index 2a68c12..22df3fe 100644
--- a/drivers/pinctrl/sh-pfc/gpio.c
+++ b/drivers/pinctrl/sh-pfc/gpio.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pinctrl/consumer.h>
-#include <linux/sh_pfc.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7740.c b/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
index 0ab4cb6..214788c 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
@@ -19,10 +19,11 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <mach/r8a7740.h>
 #include <mach/irqs.h>
 
+#include "sh_pfc.h"
+
 #define CPU_ALL_PORT(fn, pfx, sfx)					\
 	PORT_10(fn, pfx, sfx),		PORT_90(fn, pfx, sfx),		\
 	PORT_10(fn, pfx##10, sfx),	PORT_90(fn, pfx##1, sfx),	\
diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7779.c b/drivers/pinctrl/sh-pfc/pfc-r8a7779.c
index 16c9e8c..2ab9ec1 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7779.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7779.c
@@ -19,9 +19,10 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <mach/r8a7779.h>
 
+#include "sh_pfc.h"
+
 #define CPU_32_PORT(fn, pfx, sfx)				\
 	PORT_10(fn, pfx, sfx), PORT_10(fn, pfx##1, sfx),	\
 	PORT_10(fn, pfx##2, sfx), PORT_1(fn, pfx##30, sfx),	\
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7203.c b/drivers/pinctrl/sh-pfc/pfc-sh7203.c
index 62bd173..01b425d 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7203.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7203.c
@@ -10,9 +10,10 @@
 
 #include <linux/kernel.h>
 #include <linux/gpio.h>
-#include <linux/sh_pfc.h>
 #include <cpu/sh7203.h>
 
+#include "sh_pfc.h"
+
 enum {
 	PINMUX_RESERVED = 0,
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7264.c b/drivers/pinctrl/sh-pfc/pfc-sh7264.c
index 66d7692..8270493 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7264.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7264.c
@@ -10,9 +10,10 @@
 
 #include <linux/kernel.h>
 #include <linux/gpio.h>
-#include <linux/sh_pfc.h>
 #include <cpu/sh7264.h>
 
+#include "sh_pfc.h"
+
 enum {
 	PINMUX_RESERVED = 0,
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7269.c b/drivers/pinctrl/sh-pfc/pfc-sh7269.c
index 80da98d..d25825b 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7269.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7269.c
@@ -11,9 +11,10 @@
 
 #include <linux/kernel.h>
 #include <linux/gpio.h>
-#include <linux/sh_pfc.h>
 #include <cpu/sh7269.h>
 
+#include "sh_pfc.h"
+
 enum {
 	PINMUX_RESERVED = 0,
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7367.c b/drivers/pinctrl/sh-pfc/pfc-sh7367.c
index e946513..b01444a 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7367.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7367.c
@@ -17,9 +17,10 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <mach/sh7367.h>
 
+#include "sh_pfc.h"
+
 #define CPU_ALL_PORT(fn, pfx, sfx)				\
 	PORT_10(fn, pfx, sfx), PORT_90(fn, pfx, sfx),		\
 	PORT_10(fn, pfx##10, sfx), PORT_90(fn, pfx##1, sfx),	\
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7372.c b/drivers/pinctrl/sh-pfc/pfc-sh7372.c
index a52fabe..d44e7f0 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7372.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7372.c
@@ -21,10 +21,11 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <mach/irqs.h>
 #include <mach/sh7372.h>
 
+#include "sh_pfc.h"
+
 #define CPU_ALL_PORT(fn, pfx, sfx) \
 	PORT_10(fn, pfx, sfx),		PORT_90(fn, pfx, sfx), \
 	PORT_10(fn, pfx##10, sfx),	PORT_10(fn, pfx##11, sfx), \
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7377.c b/drivers/pinctrl/sh-pfc/pfc-sh7377.c
index e6414a3..de6d49d 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7377.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7377.c
@@ -18,9 +18,10 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <mach/sh7377.h>
 
+#include "sh_pfc.h"
+
 #define CPU_ALL_PORT(fn, pfx, sfx)				\
 	PORT_10(fn, pfx, sfx), PORT_90(fn, pfx, sfx),		\
 	PORT_10(fn, pfx##10, sfx),				\
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
index 8a0eee9..709008e 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
@@ -19,10 +19,11 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <mach/sh73a0.h>
 #include <mach/irqs.h>
 
+#include "sh_pfc.h"
+
 #define CPU_ALL_PORT(fn, pfx, sfx)				\
 	PORT_10(fn, pfx,    sfx), PORT_10(fn, pfx##1, sfx),	\
 	PORT_10(fn, pfx##2, sfx), PORT_10(fn, pfx##3, sfx),	\
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7720.c b/drivers/pinctrl/sh-pfc/pfc-sh7720.c
index 20d0577..10872ed 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7720.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7720.c
@@ -10,9 +10,10 @@
 
 #include <linux/kernel.h>
 #include <linux/gpio.h>
-#include <linux/sh_pfc.h>
 #include <cpu/sh7720.h>
 
+#include "sh_pfc.h"
+
 enum {
 	PINMUX_RESERVED = 0,
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7722.c b/drivers/pinctrl/sh-pfc/pfc-sh7722.c
index f58f009..2de0929 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7722.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7722.c
@@ -1,9 +1,10 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
-#include <linux/sh_pfc.h>
 #include <cpu/sh7722.h>
 
+#include "sh_pfc.h"
+
 enum {
 	PINMUX_RESERVED = 0,
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7723.c b/drivers/pinctrl/sh-pfc/pfc-sh7723.c
index 0564099..7943a7a 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7723.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7723.c
@@ -10,9 +10,10 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <cpu/sh7723.h>
 
+#include "sh_pfc.h"
+
 enum {
 	PINMUX_RESERVED = 0,
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7724.c b/drivers/pinctrl/sh-pfc/pfc-sh7724.c
index 85b6253..1e3a6c2 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7724.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7724.c
@@ -15,9 +15,10 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <cpu/sh7724.h>
 
+#include "sh_pfc.h"
+
 enum {
 	PINMUX_RESERVED = 0,
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7734.c b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
index cbb5f4c..23d76d2 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7734.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
@@ -10,9 +10,10 @@
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <cpu/sh7734.h>
 
+#include "sh_pfc.h"
+
 #define CPU_32_PORT(fn, pfx, sfx)				\
 	PORT_10(fn, pfx, sfx), PORT_10(fn, pfx##1, sfx),	\
 	PORT_10(fn, pfx##2, sfx), PORT_1(fn, pfx##30, sfx),	\
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7757.c b/drivers/pinctrl/sh-pfc/pfc-sh7757.c
index 09433b3..07553e3 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7757.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7757.c
@@ -15,9 +15,10 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <cpu/sh7757.h>
 
+#include "sh_pfc.h"
+
 enum {
 	PINMUX_RESERVED = 0,
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7785.c b/drivers/pinctrl/sh-pfc/pfc-sh7785.c
index 23f2c31..3b1825d 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7785.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7785.c
@@ -10,9 +10,10 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <cpu/sh7785.h>
 
+#include "sh_pfc.h"
+
 enum {
 	PINMUX_RESERVED = 0,
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7786.c b/drivers/pinctrl/sh-pfc/pfc-sh7786.c
index 1d80461..15f1d5a 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7786.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7786.c
@@ -15,9 +15,10 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <cpu/sh7786.h>
 
+#include "sh_pfc.h"
+
 enum {
 	PINMUX_RESERVED = 0,
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-shx3.c b/drivers/pinctrl/sh-pfc/pfc-shx3.c
index e21eb24..c5af0cc 100644
--- a/drivers/pinctrl/sh-pfc/pfc-shx3.c
+++ b/drivers/pinctrl/sh-pfc/pfc-shx3.c
@@ -9,9 +9,10 @@
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <cpu/shx3.h>
 
+#include "sh_pfc.h"
+
 enum {
 	PINMUX_RESERVED = 0,
 
diff --git a/drivers/pinctrl/sh-pfc/pinctrl.c b/drivers/pinctrl/sh-pfc/pinctrl.c
index 7f3187a..0914f5c 100644
--- a/drivers/pinctrl/sh-pfc/pinctrl.c
+++ b/drivers/pinctrl/sh-pfc/pinctrl.c
@@ -14,7 +14,6 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/sh_pfc.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/pinctrl/consumer.h>
diff --git a/drivers/pinctrl/sh-pfc/sh_pfc.h b/drivers/pinctrl/sh-pfc/sh_pfc.h
new file mode 100644
index 0000000..13049c4
--- /dev/null
+++ b/drivers/pinctrl/sh-pfc/sh_pfc.h
@@ -0,0 +1,195 @@
+/*
+ * SuperH Pin Function Controller Support
+ *
+ * Copyright (c) 2008 Magnus Damm
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef __SH_PFC_H
+#define __SH_PFC_H
+
+#include <linux/stringify.h>
+#include <asm-generic/gpio.h>
+
+typedef unsigned short pinmux_enum_t;
+typedef unsigned short pinmux_flag_t;
+
+enum {
+	PINMUX_TYPE_NONE,
+
+	PINMUX_TYPE_FUNCTION,
+	PINMUX_TYPE_GPIO,
+	PINMUX_TYPE_OUTPUT,
+	PINMUX_TYPE_INPUT,
+	PINMUX_TYPE_INPUT_PULLUP,
+	PINMUX_TYPE_INPUT_PULLDOWN,
+
+	PINMUX_FLAG_TYPE,	/* must be last */
+};
+
+#define PINMUX_FLAG_DBIT_SHIFT      5
+#define PINMUX_FLAG_DBIT            (0x1f << PINMUX_FLAG_DBIT_SHIFT)
+#define PINMUX_FLAG_DREG_SHIFT      10
+#define PINMUX_FLAG_DREG            (0x3f << PINMUX_FLAG_DREG_SHIFT)
+
+struct pinmux_gpio {
+	pinmux_enum_t enum_id;
+	pinmux_flag_t flags;
+	const char *name;
+};
+
+#define PINMUX_GPIO(gpio, data_or_mark) \
+	[gpio] = { .name = __stringify(gpio), .enum_id = data_or_mark, .flags = PINMUX_TYPE_NONE }
+
+#define PINMUX_DATA(data_or_mark, ids...) data_or_mark, ids, 0
+
+struct pinmux_cfg_reg {
+	unsigned long reg, reg_width, field_width;
+	unsigned long *cnt;
+	pinmux_enum_t *enum_ids;
+	unsigned long *var_field_width;
+};
+
+#define PINMUX_CFG_REG(name, r, r_width, f_width) \
+	.reg = r, .reg_width = r_width, .field_width = f_width,		\
+	.cnt = (unsigned long [r_width / f_width]) {}, \
+	.enum_ids = (pinmux_enum_t [(r_width / f_width) * (1 << f_width)])
+
+#define PINMUX_CFG_REG_VAR(name, r, r_width, var_fw0, var_fwn...) \
+	.reg = r, .reg_width = r_width,	\
+	.cnt = (unsigned long [r_width]) {}, \
+	.var_field_width = (unsigned long [r_width]) { var_fw0, var_fwn, 0 }, \
+	.enum_ids = (pinmux_enum_t [])
+
+struct pinmux_data_reg {
+	unsigned long reg, reg_width, reg_shadow;
+	pinmux_enum_t *enum_ids;
+	void __iomem *mapped_reg;
+};
+
+#define PINMUX_DATA_REG(name, r, r_width) \
+	.reg = r, .reg_width = r_width,	\
+	.enum_ids = (pinmux_enum_t [r_width]) \
+
+struct pinmux_irq {
+	int irq;
+	pinmux_enum_t *enum_ids;
+};
+
+#define PINMUX_IRQ(irq_nr, ids...)			   \
+	{ .irq = irq_nr, .enum_ids = (pinmux_enum_t []) { ids, 0 } }	\
+
+struct pinmux_range {
+	pinmux_enum_t begin;
+	pinmux_enum_t end;
+	pinmux_enum_t force;
+};
+
+struct sh_pfc_soc_info {
+	char *name;
+	pinmux_enum_t reserved_id;
+	struct pinmux_range data;
+	struct pinmux_range input;
+	struct pinmux_range input_pd;
+	struct pinmux_range input_pu;
+	struct pinmux_range output;
+	struct pinmux_range mark;
+	struct pinmux_range function;
+
+	unsigned first_gpio, last_gpio;
+
+	struct pinmux_gpio *gpios;
+	struct pinmux_cfg_reg *cfg_regs;
+	struct pinmux_data_reg *data_regs;
+
+	pinmux_enum_t *gpio_data;
+	unsigned int gpio_data_size;
+
+	struct pinmux_irq *gpio_irq;
+	unsigned int gpio_irq_size;
+
+	unsigned long unlock_reg;
+};
+
+enum { GPIO_CFG_DRYRUN, GPIO_CFG_REQ, GPIO_CFG_FREE };
+
+/* helper macro for port */
+#define PORT_1(fn, pfx, sfx) fn(pfx, sfx)
+
+#define PORT_10(fn, pfx, sfx) \
+	PORT_1(fn, pfx##0, sfx), PORT_1(fn, pfx##1, sfx),	\
+	PORT_1(fn, pfx##2, sfx), PORT_1(fn, pfx##3, sfx),	\
+	PORT_1(fn, pfx##4, sfx), PORT_1(fn, pfx##5, sfx),	\
+	PORT_1(fn, pfx##6, sfx), PORT_1(fn, pfx##7, sfx),	\
+	PORT_1(fn, pfx##8, sfx), PORT_1(fn, pfx##9, sfx)
+
+#define PORT_90(fn, pfx, sfx) \
+	PORT_10(fn, pfx##1, sfx), PORT_10(fn, pfx##2, sfx),	\
+	PORT_10(fn, pfx##3, sfx), PORT_10(fn, pfx##4, sfx),	\
+	PORT_10(fn, pfx##5, sfx), PORT_10(fn, pfx##6, sfx),	\
+	PORT_10(fn, pfx##7, sfx), PORT_10(fn, pfx##8, sfx),	\
+	PORT_10(fn, pfx##9, sfx)
+
+#define _PORT_ALL(pfx, sfx) pfx##_##sfx
+#define _GPIO_PORT(pfx, sfx) PINMUX_GPIO(GPIO_PORT##pfx, PORT##pfx##_DATA)
+#define PORT_ALL(str)	CPU_ALL_PORT(_PORT_ALL, PORT, str)
+#define GPIO_PORT_ALL()	CPU_ALL_PORT(_GPIO_PORT, , unused)
+#define GPIO_FN(str) PINMUX_GPIO(GPIO_FN_##str, str##_MARK)
+
+/* helper macro for pinmux_enum_t */
+#define PORT_DATA_I(nr)	\
+	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_IN)
+
+#define PORT_DATA_I_PD(nr)	\
+	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0,	\
+		    PORT##nr##_IN, PORT##nr##_IN_PD)
+
+#define PORT_DATA_I_PU(nr)	\
+	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0,	\
+		    PORT##nr##_IN, PORT##nr##_IN_PU)
+
+#define PORT_DATA_I_PU_PD(nr)	\
+	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0,			\
+		    PORT##nr##_IN, PORT##nr##_IN_PD, PORT##nr##_IN_PU)
+
+#define PORT_DATA_O(nr)		\
+	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_OUT)
+
+#define PORT_DATA_IO(nr)	\
+	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_OUT,	\
+		    PORT##nr##_IN)
+
+#define PORT_DATA_IO_PD(nr)	\
+	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_OUT,	\
+		    PORT##nr##_IN, PORT##nr##_IN_PD)
+
+#define PORT_DATA_IO_PU(nr)	\
+	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_OUT,	\
+		    PORT##nr##_IN, PORT##nr##_IN_PU)
+
+#define PORT_DATA_IO_PU_PD(nr)	\
+	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_OUT,	\
+		    PORT##nr##_IN, PORT##nr##_IN_PD, PORT##nr##_IN_PU)
+
+/* helper macro for top 4 bits in PORTnCR */
+#define _PCRH(in, in_pd, in_pu, out)	\
+	0, (out), (in), 0,		\
+	0, 0, 0, 0,			\
+	0, 0, (in_pd), 0,		\
+	0, 0, (in_pu), 0
+
+#define PORTCR(nr, reg)							\
+	{								\
+		PINMUX_CFG_REG("PORT" nr "CR", reg, 8, 4) {		\
+			_PCRH(PORT##nr##_IN, PORT##nr##_IN_PD,		\
+			      PORT##nr##_IN_PU, PORT##nr##_OUT),	\
+				PORT##nr##_FN0, PORT##nr##_FN1,		\
+				PORT##nr##_FN2, PORT##nr##_FN3,		\
+				PORT##nr##_FN4, PORT##nr##_FN5,		\
+				PORT##nr##_FN6, PORT##nr##_FN7 }	\
+	}
+
+#endif /* __SH_PFC_H */
diff --git a/include/linux/sh_pfc.h b/include/linux/sh_pfc.h
deleted file mode 100644
index 13049c4..0000000
--- a/include/linux/sh_pfc.h
+++ /dev/null
@@ -1,195 +0,0 @@
-/*
- * SuperH Pin Function Controller Support
- *
- * Copyright (c) 2008 Magnus Damm
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef __SH_PFC_H
-#define __SH_PFC_H
-
-#include <linux/stringify.h>
-#include <asm-generic/gpio.h>
-
-typedef unsigned short pinmux_enum_t;
-typedef unsigned short pinmux_flag_t;
-
-enum {
-	PINMUX_TYPE_NONE,
-
-	PINMUX_TYPE_FUNCTION,
-	PINMUX_TYPE_GPIO,
-	PINMUX_TYPE_OUTPUT,
-	PINMUX_TYPE_INPUT,
-	PINMUX_TYPE_INPUT_PULLUP,
-	PINMUX_TYPE_INPUT_PULLDOWN,
-
-	PINMUX_FLAG_TYPE,	/* must be last */
-};
-
-#define PINMUX_FLAG_DBIT_SHIFT      5
-#define PINMUX_FLAG_DBIT            (0x1f << PINMUX_FLAG_DBIT_SHIFT)
-#define PINMUX_FLAG_DREG_SHIFT      10
-#define PINMUX_FLAG_DREG            (0x3f << PINMUX_FLAG_DREG_SHIFT)
-
-struct pinmux_gpio {
-	pinmux_enum_t enum_id;
-	pinmux_flag_t flags;
-	const char *name;
-};
-
-#define PINMUX_GPIO(gpio, data_or_mark) \
-	[gpio] = { .name = __stringify(gpio), .enum_id = data_or_mark, .flags = PINMUX_TYPE_NONE }
-
-#define PINMUX_DATA(data_or_mark, ids...) data_or_mark, ids, 0
-
-struct pinmux_cfg_reg {
-	unsigned long reg, reg_width, field_width;
-	unsigned long *cnt;
-	pinmux_enum_t *enum_ids;
-	unsigned long *var_field_width;
-};
-
-#define PINMUX_CFG_REG(name, r, r_width, f_width) \
-	.reg = r, .reg_width = r_width, .field_width = f_width,		\
-	.cnt = (unsigned long [r_width / f_width]) {}, \
-	.enum_ids = (pinmux_enum_t [(r_width / f_width) * (1 << f_width)])
-
-#define PINMUX_CFG_REG_VAR(name, r, r_width, var_fw0, var_fwn...) \
-	.reg = r, .reg_width = r_width,	\
-	.cnt = (unsigned long [r_width]) {}, \
-	.var_field_width = (unsigned long [r_width]) { var_fw0, var_fwn, 0 }, \
-	.enum_ids = (pinmux_enum_t [])
-
-struct pinmux_data_reg {
-	unsigned long reg, reg_width, reg_shadow;
-	pinmux_enum_t *enum_ids;
-	void __iomem *mapped_reg;
-};
-
-#define PINMUX_DATA_REG(name, r, r_width) \
-	.reg = r, .reg_width = r_width,	\
-	.enum_ids = (pinmux_enum_t [r_width]) \
-
-struct pinmux_irq {
-	int irq;
-	pinmux_enum_t *enum_ids;
-};
-
-#define PINMUX_IRQ(irq_nr, ids...)			   \
-	{ .irq = irq_nr, .enum_ids = (pinmux_enum_t []) { ids, 0 } }	\
-
-struct pinmux_range {
-	pinmux_enum_t begin;
-	pinmux_enum_t end;
-	pinmux_enum_t force;
-};
-
-struct sh_pfc_soc_info {
-	char *name;
-	pinmux_enum_t reserved_id;
-	struct pinmux_range data;
-	struct pinmux_range input;
-	struct pinmux_range input_pd;
-	struct pinmux_range input_pu;
-	struct pinmux_range output;
-	struct pinmux_range mark;
-	struct pinmux_range function;
-
-	unsigned first_gpio, last_gpio;
-
-	struct pinmux_gpio *gpios;
-	struct pinmux_cfg_reg *cfg_regs;
-	struct pinmux_data_reg *data_regs;
-
-	pinmux_enum_t *gpio_data;
-	unsigned int gpio_data_size;
-
-	struct pinmux_irq *gpio_irq;
-	unsigned int gpio_irq_size;
-
-	unsigned long unlock_reg;
-};
-
-enum { GPIO_CFG_DRYRUN, GPIO_CFG_REQ, GPIO_CFG_FREE };
-
-/* helper macro for port */
-#define PORT_1(fn, pfx, sfx) fn(pfx, sfx)
-
-#define PORT_10(fn, pfx, sfx) \
-	PORT_1(fn, pfx##0, sfx), PORT_1(fn, pfx##1, sfx),	\
-	PORT_1(fn, pfx##2, sfx), PORT_1(fn, pfx##3, sfx),	\
-	PORT_1(fn, pfx##4, sfx), PORT_1(fn, pfx##5, sfx),	\
-	PORT_1(fn, pfx##6, sfx), PORT_1(fn, pfx##7, sfx),	\
-	PORT_1(fn, pfx##8, sfx), PORT_1(fn, pfx##9, sfx)
-
-#define PORT_90(fn, pfx, sfx) \
-	PORT_10(fn, pfx##1, sfx), PORT_10(fn, pfx##2, sfx),	\
-	PORT_10(fn, pfx##3, sfx), PORT_10(fn, pfx##4, sfx),	\
-	PORT_10(fn, pfx##5, sfx), PORT_10(fn, pfx##6, sfx),	\
-	PORT_10(fn, pfx##7, sfx), PORT_10(fn, pfx##8, sfx),	\
-	PORT_10(fn, pfx##9, sfx)
-
-#define _PORT_ALL(pfx, sfx) pfx##_##sfx
-#define _GPIO_PORT(pfx, sfx) PINMUX_GPIO(GPIO_PORT##pfx, PORT##pfx##_DATA)
-#define PORT_ALL(str)	CPU_ALL_PORT(_PORT_ALL, PORT, str)
-#define GPIO_PORT_ALL()	CPU_ALL_PORT(_GPIO_PORT, , unused)
-#define GPIO_FN(str) PINMUX_GPIO(GPIO_FN_##str, str##_MARK)
-
-/* helper macro for pinmux_enum_t */
-#define PORT_DATA_I(nr)	\
-	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_IN)
-
-#define PORT_DATA_I_PD(nr)	\
-	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0,	\
-		    PORT##nr##_IN, PORT##nr##_IN_PD)
-
-#define PORT_DATA_I_PU(nr)	\
-	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0,	\
-		    PORT##nr##_IN, PORT##nr##_IN_PU)
-
-#define PORT_DATA_I_PU_PD(nr)	\
-	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0,			\
-		    PORT##nr##_IN, PORT##nr##_IN_PD, PORT##nr##_IN_PU)
-
-#define PORT_DATA_O(nr)		\
-	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_OUT)
-
-#define PORT_DATA_IO(nr)	\
-	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_OUT,	\
-		    PORT##nr##_IN)
-
-#define PORT_DATA_IO_PD(nr)	\
-	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_OUT,	\
-		    PORT##nr##_IN, PORT##nr##_IN_PD)
-
-#define PORT_DATA_IO_PU(nr)	\
-	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_OUT,	\
-		    PORT##nr##_IN, PORT##nr##_IN_PU)
-
-#define PORT_DATA_IO_PU_PD(nr)	\
-	PINMUX_DATA(PORT##nr##_DATA, PORT##nr##_FN0, PORT##nr##_OUT,	\
-		    PORT##nr##_IN, PORT##nr##_IN_PD, PORT##nr##_IN_PU)
-
-/* helper macro for top 4 bits in PORTnCR */
-#define _PCRH(in, in_pd, in_pu, out)	\
-	0, (out), (in), 0,		\
-	0, 0, 0, 0,			\
-	0, 0, (in_pd), 0,		\
-	0, 0, (in_pu), 0
-
-#define PORTCR(nr, reg)							\
-	{								\
-		PINMUX_CFG_REG("PORT" nr "CR", reg, 8, 4) {		\
-			_PCRH(PORT##nr##_IN, PORT##nr##_IN_PD,		\
-			      PORT##nr##_IN_PU, PORT##nr##_OUT),	\
-				PORT##nr##_FN0, PORT##nr##_FN1,		\
-				PORT##nr##_FN2, PORT##nr##_FN3,		\
-				PORT##nr##_FN4, PORT##nr##_FN5,		\
-				PORT##nr##_FN6, PORT##nr##_FN7 }	\
-	}
-
-#endif /* __SH_PFC_H */
-- 
1.7.8.6


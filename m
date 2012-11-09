Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2KIOWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:22:30 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:46817 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab2KIOUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:20:34 -0500
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 04/10] drivers/mfd/sta2x11-mfd: use defines for platform devices' names
Date: Fri,  9 Nov 2012 15:19:55 +0100
Message-Id: <1352470801-2418-5-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
References: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Since there are now many sta2x11-mfd platform devices, using defines
for their names looks like a better solution.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c       |   42 ++++++++++++++++++++-------------------
 include/linux/mfd/sta2x11-mfd.h |    8 ++++++++
 2 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 6d12ab4..8d38ef2 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -174,9 +174,9 @@ static void sta2x11_regmap_unlock(void *__lock)
 }
 
 static const char *sta2x11_mfd_names[sta2x11_n_mfd_plat_devs] = {
-	[sta2x11_sctl] = "sta2x11-sctl",
-	[sta2x11_apbreg] = "sta2x11-apbreg",
-	[sta2x11_apb_soc_regs] = "sta2x11-apb-soc-regs",
+	[sta2x11_sctl] = STA2X11_MFD_SCTL_NAME,
+	[sta2x11_apbreg] = STA2X11_MFD_APBREG_NAME,
+	[sta2x11_apb_soc_regs] = STA2X11_MFD_APB_SOC_REGS_NAME,
 };
 
 static bool sta2x11_sctl_writeable_reg(struct device *dev, unsigned int reg)
@@ -340,7 +340,7 @@ static int sta2x11_apb_soc_regs_probe(struct platform_device *dev)
 /* The three platform drivers */
 static struct platform_driver sta2x11_sctl_platform_driver = {
 	.driver = {
-		.name	= "sta2x11-sctl",
+		.name	= STA2X11_MFD_SCTL_NAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= sta2x11_sctl_probe,
@@ -354,7 +354,7 @@ static int __init sta2x11_sctl_init(void)
 
 static struct platform_driver sta2x11_platform_driver = {
 	.driver = {
-		.name	= "sta2x11-apbreg",
+		.name	= STA2X11_MFD_APBREG_NAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= sta2x11_apbreg_probe,
@@ -368,7 +368,7 @@ static int __init sta2x11_apbreg_init(void)
 
 static struct platform_driver sta2x11_apb_soc_regs_platform_driver = {
 	.driver = {
-		.name	= "sta2x11-apb-soc-regs",
+		.name	= STA2X11_MFD_APB_SOC_REGS_NAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= sta2x11_apb_soc_regs_probe,
@@ -409,38 +409,40 @@ enum mfd0_bar1_cells {
 
 static const __devinitconst struct resource gpio_resources[] = {
 	{
-		.name = "sta2x11_gpio", /* 4 consecutive cells, 1 driver */
+		/* 4 consecutive cells, 1 driver */
+		.name = STA2X11_MFD_GPIO_NAME,
 		.start = 0,
 		.end = (4 * 4096) - 1,
 		.flags = IORESOURCE_MEM,
 	}
 };
 static const __devinitconst struct resource sctl_resources[] = {
-	CELL_4K("sta2x11-sctl", STA2X11_SCTL),
+	CELL_4K(STA2X11_MFD_SCTL_NAME, STA2X11_SCTL),
 };
 static const __devinitconst struct resource scr_resources[] = {
-	CELL_4K("sta2x11-scr", STA2X11_SCR),
+	CELL_4K(STA2X11_MFD_SCR_NAME, STA2X11_SCR),
 };
 static const __devinitconst struct resource time_resources[] = {
-	CELL_4K("sta2x11-time", STA2X11_TIME),
+	CELL_4K(STA2X11_MFD_TIME_NAME, STA2X11_TIME),
 };
 
 static const __devinitconst struct resource apbreg_resources[] = {
-	CELL_4K("sta2x11-apbreg", STA2X11_APBREG),
+	CELL_4K(STA2X11_MFD_APBREG_NAME, STA2X11_APBREG),
 };
 
 #define DEV(_name, _r) \
 	{ .name = _name, .num_resources = ARRAY_SIZE(_r), .resources = _r, }
 
 static __devinitdata struct mfd_cell sta2x11_mfd0_bar0[] = {
-	DEV("sta2x11-gpio", gpio_resources), /* offset 0: we add pdata later */
-	DEV("sta2x11-sctl", sctl_resources),
-	DEV("sta2x11-scr", scr_resources),
-	DEV("sta2x11-time", time_resources),
+	/* offset 0: we add pdata later */
+	DEV(STA2X11_MFD_GPIO_NAME, gpio_resources),
+	DEV(STA2X11_MFD_SCTL_NAME, sctl_resources),
+	DEV(STA2X11_MFD_SCR_NAME,  scr_resources),
+	DEV(STA2X11_MFD_TIME_NAME, time_resources),
 };
 
 static __devinitdata struct mfd_cell sta2x11_mfd0_bar1[] = {
-	DEV("sta2x11-apbreg", apbreg_resources),
+	DEV(STA2X11_MFD_APBREG_NAME, apbreg_resources),
 };
 
 /* Mfd 1 devices */
@@ -456,19 +458,19 @@ enum mfd1_bar1_cells {
 };
 
 static const __devinitconst struct resource vic_resources[] = {
-	CELL_4K("sta2x11-vic", STA2X11_VIC),
+	CELL_4K(STA2X11_MFD_VIC_NAME, STA2X11_VIC),
 };
 
 static const __devinitconst struct resource apb_soc_regs_resources[] = {
-	CELL_4K("sta2x11-apb-soc-regs", STA2X11_APB_SOC_REGS),
+	CELL_4K(STA2X11_MFD_APB_SOC_REGS_NAME, STA2X11_APB_SOC_REGS),
 };
 
 static __devinitdata struct mfd_cell sta2x11_mfd1_bar0[] = {
-	DEV("sta2x11-vic", vic_resources),
+	DEV(STA2X11_MFD_VIC_NAME, vic_resources),
 };
 
 static __devinitdata struct mfd_cell sta2x11_mfd1_bar1[] = {
-	DEV("sta2x11-apb-soc-regs", apb_soc_regs_resources),
+	DEV(STA2X11_MFD_APB_SOC_REGS_NAME, apb_soc_regs_resources),
 };
 
 
diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index e813e5e..058de2b 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -37,6 +37,14 @@ enum sta2x11_mfd_plat_dev {
 	sta2x11_n_mfd_plat_devs,
 };
 
+#define STA2X11_MFD_SCTL_NAME	       "sta2x11-sctl"
+#define STA2X11_MFD_GPIO_NAME	       "sta2x11-gpio"
+#define STA2X11_MFD_SCR_NAME	       "sta2x11-scr"
+#define STA2X11_MFD_TIME_NAME	       "sta2x11-time"
+#define STA2X11_MFD_APBREG_NAME	       "sta2x11-apbreg"
+#define STA2X11_MFD_APB_SOC_REGS_NAME  "sta2x11-apb-soc-regs"
+#define STA2X11_MFD_VIC_NAME	       "sta2x11-vic"
+
 extern u32
 __sta2x11_mfd_mask(struct pci_dev *, u32, u32, u32, enum sta2x11_mfd_plat_dev);
 
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2FKA71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:59:27 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40548 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab2FKA6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:32 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 12/14] sta2x11-mfd : use defines for platform devices' names
Date: Mon, 11 Jun 2012 02:57:57 +0200
Message-Id: <1339376279-16753-13-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>


Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c |   42 ++++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index cc20a79..aca0bc7 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -238,9 +238,9 @@ static struct debugfs_regset32 *sta2x11_mfd_regset[sta2x11_n_mfd_plat_devs] = {
 };
 
 static const char *sta2x11_mfd_names[sta2x11_n_mfd_plat_devs] = {
-	[sta2x11_sctl] = "sta2x11-sctl",
-	[sta2x11_apbreg] = "sta2x11-apbreg",
-	[sta2x11_apb_soc_regs] = "sta2x11-apb-soc-regs",
+	[sta2x11_sctl] = STA2X11_MFD_SCTL_NAME,
+	[sta2x11_apbreg] = STA2X11_MFD_APBREG_NAME,
+	[sta2x11_apb_soc_regs] = STA2X11_MFD_APB_SOC_REGS_NAME,
 };
 
 /* Probe for the three platform devices */
@@ -296,7 +296,7 @@ static int sta2x11_apb_soc_regs_probe(struct platform_device *dev)
 /* The three platform drivers */
 static struct platform_driver sta2x11_sctl_platform_driver = {
 	.driver = {
-		.name	= "sta2x11-sctl",
+		.name	= STA2X11_MFD_SCTL_NAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= sta2x11_sctl_probe,
@@ -310,7 +310,7 @@ static int __init sta2x11_sctl_init(void)
 
 static struct platform_driver sta2x11_platform_driver = {
 	.driver = {
-		.name	= "sta2x11-apbreg",
+		.name	= STA2X11_MFD_APBREG_NAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= sta2x11_apbreg_probe,
@@ -324,7 +324,7 @@ static int __init sta2x11_apbreg_init(void)
 
 static struct platform_driver sta2x11_apb_soc_regs_platform_driver = {
 	.driver = {
-		.name	= "sta2x11-apb-soc-regs",
+		.name	= STA2X11_MFD_APB_SOC_REGS_NAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= sta2x11_apb_soc_regs_probe,
@@ -365,38 +365,40 @@ enum mfd0_bar1_cells {
 
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
@@ -412,19 +414,19 @@ enum mfd1_bar1_cells {
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
 
 
-- 
1.7.9.1


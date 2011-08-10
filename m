Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1HJJz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:55:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34277 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1HJJz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:55:26 -0400
X-AuditID: cbfee61b-b7c3dae000002cb8-0a-4e42558c5dff
Date: Wed, 10 Aug 2011 18:54:59 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] ARM:EXYNOS4: Add the missing clock of EXYNOS4210 to remove
 leakage power
To: Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, dg77.kim@samsung.com
Message-id: <4E425573.30408@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
X-OriginalArrivalTime: 10 Aug 2011 09:55:59.0090 (UTC)
 FILETIME=[B4939D20:01CC5743]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Singed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Singed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/clock.c                 |  295 +++++++++++++++++++++++++
 arch/arm/mach-exynos4/include/mach/regs-pmu.h |    6 +
 2 files changed, 301 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 arch/arm/mach-exynos4/clock.c

diff --git a/arch/arm/mach-exynos4/clock.c b/arch/arm/mach-exynos4/clock.c
old mode 100644
new mode 100755
index 851dea0..c49474a
--- a/arch/arm/mach-exynos4/clock.c
+++ b/arch/arm/mach-exynos4/clock.c
@@ -123,6 +123,36 @@ static int exynos4_clk_ip_perir_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(S5P_CLKGATE_IP_PERIR, clk, enable);
 }
 
+static int exynos4_clk_hdmiphy_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_HDMI_PHY_CONTROL, clk, enable);
+}
+
+static int exynos4_clk_dac_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_DAC_PHY_CONTROL, clk, enable);
+}
+
+static int exynos4_clk_ip_leftbus_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_IP_LEFTBUS, clk, enable);
+}
+
+static int exynos4_clk_ip_rightbus_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_IP_RIGHTBUS, clk, enable);
+}
+
+static int exynos4_clk_ip_g3d_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_IP_G3D, clk, enable);
+}
+
+static int exynos4_clk_ip_gps_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_IP_GPS, clk, enable);
+}
+
 /* Core list of CMU_CPU side */
 
 static struct clksrc_clk clk_mout_apll = {
@@ -385,6 +415,10 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 5),
 	}, {
+		.name		= "jpeg",
+		.enable		= exynos4_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 6),
+	}, {
 		.name		= "fimc",
 		.devname	= "exynos4-fimc.0",
 		.enable		= exynos4_clk_ip_cam_ctrl,
@@ -415,11 +449,49 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_lcd1_ctrl,
 		.ctrlbit	= (1 << 0),
 	}, {
+		.name		= "mie",
+		.devname	= "exynos4-mie.0",
+		.enable		= exynos4_clk_ip_lcd0_ctrl,
+		.ctrlbit	= (1 << 1),
+	}, {
+		.name		= "mie",
+		.devname	= "exynos4-mie.1",
+		.enable		= exynos4_clk_ip_lcd1_ctrl,
+		.ctrlbit	= (1 << 1),
+	}, {
+		.name		= "mdnie",
+		.devname	= "exynos4-mdnie.0",
+		.enable		= exynos4_clk_ip_lcd0_ctrl,
+		.ctrlbit	= (1 << 2),
+	}, {
+		.name		= "mdnie",
+		.devname	= "exynos4-mdnie.1",
+		.enable		= exynos4_clk_ip_lcd1_ctrl,
+		.ctrlbit	= (1 << 2),
+	}, {
+		.name		= "dsim",
+		.devname	= "exynos4-dsim.0",
+		.enable		= exynos4_clk_ip_lcd0_ctrl,
+		.ctrlbit	= (1 << 3),
+	}, {
+		.name		= "dsim",
+		.devname	= "exynos4-dsim.1",
+		.enable		= exynos4_clk_ip_lcd1_ctrl,
+		.ctrlbit	= (1 << 3),
+	}, {
+		.name		= "pciephy",
+		.enable		= exynos4_clk_ip_fsys_ctrl,
+		.ctrlbit	= (1 << 2),
+	}, {
 		.name		= "sataphy",
 		.parent		= &clk_aclk_133.clk,
 		.enable		= exynos4_clk_ip_fsys_ctrl,
 		.ctrlbit	= (1 << 3),
 	}, {
+		.name		= "tsi",
+		.enable		= exynos4_clk_ip_fsys_ctrl,
+		.ctrlbit	= (1 << 4),
+	}, {
 		.name		= "hsmmc",
 		.devname	= "s3c-sdhci.0",
 		.parent		= &clk_aclk_133.clk,
@@ -449,6 +521,51 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_fsys_ctrl,
 		.ctrlbit	= (1 << 9),
 	}, {
+		.name		= "srom",
+		.enable		= exynos4_clk_ip_fsys_ctrl,
+		.ctrlbit	= (1 << 11),
+	}, {
+		.name		= "pcie",
+		.enable		= exynos4_clk_ip_fsys_ctrl,
+		.ctrlbit	= (1 << 14),
+	}, {
+		.name		= "onenand",
+		.enable		= exynos4_clk_ip_fsys_ctrl,
+		.ctrlbit	= (1 << 15),
+	}, {
+		.name		= "nfcon",
+		.enable		= exynos4_clk_ip_fsys_ctrl,
+		.ctrlbit	= (1 << 16),
+	}, {
+		.name		= "vp",
+		.enable		= exynos4_clk_ip_tv_ctrl,
+		.ctrlbit	= (1 << 0),
+	}, {
+		.name		= "mixer",
+		.devname	= "s5p-mixer",
+		.enable		= exynos4_clk_ip_tv_ctrl,
+		.ctrlbit	= (1 << 1),
+	}, {
+		.name		= "dac",
+		.devname	= "s5p-sdo",
+		.enable		= exynos4_clk_ip_tv_ctrl,
+		.ctrlbit	= (1 << 2),
+	}, {
+		.name		= "hdmi",
+		.devname	= "exynos4-hdmi",
+		.enable		= exynos4_clk_ip_tv_ctrl,
+		.ctrlbit	= (1 << 3),
+	}, {
+		.name		= "hdmiphy",
+		.devname	= "exynos4-hdmi",
+		.enable		= exynos4_clk_hdmiphy_ctrl,
+		.ctrlbit	= (1 << 0),
+	}, {
+		.name		= "dacphy",
+		.devname	= "s5p-sdo",
+		.enable		= exynos4_clk_dac_ctrl,
+		.ctrlbit	= (1 << 0),
+	}, {
 		.name		= "sata",
 		.parent		= &clk_aclk_133.clk,
 		.enable		= exynos4_clk_ip_fsys_ctrl,
@@ -468,6 +585,10 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_peril_ctrl,
 		.ctrlbit	= (1 << 15),
 	}, {
+		.name		= "tmu_apbif",
+		.enable		= exynos4_clk_ip_perir_ctrl,
+		.ctrlbit	= (1 << 17),
+	}, {
 		.name		= "keypad",
 		.enable		= exynos4_clk_ip_perir_ctrl,
 		.ctrlbit	= (1 << 16),
@@ -481,6 +602,48 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_perir_ctrl,
 		.ctrlbit	= (1 << 14),
 	}, {
+		.name		= "seckey",
+		.enable		= exynos4_clk_ip_perir_ctrl,
+		.ctrlbit	= (1 << 12),
+	}, {
+		.name		= "hdmi_cec",
+		.enable		= exynos4_clk_ip_perir_ctrl,
+		.ctrlbit	= (1 << 11),
+	}, {
+		.name		= "tzpc",
+		.devname	= "exynos4-tzpc.5",
+		.enable		= exynos4_clk_ip_perir_ctrl,
+		.ctrlbit	= (1 << 10),
+	}, {
+		.name		= "tzpc",
+		.devname	= "exynos4-tzpc.4",
+		.enable		= exynos4_clk_ip_perir_ctrl,
+		.ctrlbit	= (1 << 9),
+	}, {
+		.name		= "tzpc",
+		.devname	= "exynos4-tzpc.3",
+		.enable		= exynos4_clk_ip_perir_ctrl,
+		.ctrlbit	= (1 << 8),
+	}, {
+		.name		= "tzpc",
+		.devname	= "exynos4-tzpc.2",
+		.enable		= exynos4_clk_ip_perir_ctrl,
+		.ctrlbit	= (1 << 7),
+	}, {
+		.name		= "tzpc",
+		.devname	= "exynos4-tzpc.1",
+		.enable		= exynos4_clk_ip_perir_ctrl,
+		.ctrlbit	= (1 << 6),
+	}, {
+		.name		= "tzpc",
+		.devname	= "exynos4-tzpc.0",
+		.enable		= exynos4_clk_ip_perir_ctrl,
+		.ctrlbit	= (1 << 5),
+	}, {
+		.name		= "chipid",
+		.enable		= exynos4_clk_ip_perir_ctrl,
+		.ctrlbit	= (1 << 0),
+	}, {
 		.name		= "usbhost",
 		.enable		= exynos4_clk_ip_fsys_ctrl ,
 		.ctrlbit	= (1 << 12),
@@ -528,6 +691,14 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_image_ctrl,
 		.ctrlbit	= (1 << 0),
 	}, {
+		.name		= "rotator",
+		.enable		= exynos4_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 1),
+	}, {
+		.name		= "mdma",
+		.enable		= exynos4_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 2),
+	}, {
 		.name		= "mfc",
 		.devname	= "s5p-mfc",
 		.enable		= exynos4_clk_ip_mfc_ctrl,
@@ -581,6 +752,46 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_peril_ctrl,
 		.ctrlbit	= (1 << 13),
 	}, {
+		.name		= "i2c",
+		.devname	= "s3c2440-hdmiphy-i2c",
+		.parent		= &clk_aclk_100.clk,
+		.enable		= exynos4_clk_ip_peril_ctrl,
+		.ctrlbit	= (1 << 14),
+	}, {
+		.name		= "adc",
+		.enable		= exynos4_clk_ip_peril_ctrl,
+		.ctrlbit	= (1 << 15),
+	}, {
+		.name		= "pcm",
+		.devname	= "samsung-pcm.0",
+		.enable		= exynos4_clk_ip_peril_ctrl,
+		.ctrlbit	= (1 << 22),
+	}, {
+		.name		= "pcm",
+		.devname	= "samsung-pcm.1",
+		.enable		= exynos4_clk_ip_peril_ctrl,
+		.ctrlbit	= (1 << 23),
+	}, {
+		.name		= "slimbus",
+		.enable		= exynos4_clk_ip_peril_ctrl,
+		.ctrlbit	= (1 << 25),
+	}, {
+		.name		= "spdif",
+		.enable		= exynos4_clk_ip_peril_ctrl,
+		.ctrlbit	= (1 << 26),
+	}, {
+		.name		= "modemif",
+		.enable		= exynos4_clk_ip_peril_ctrl,
+		.ctrlbit	= (1 << 28),
+	}, {
+		.name		= "gps",
+		.enable		= exynos4_clk_ip_gps_ctrl,
+		.ctrlbit	= (1 << 0),
+	}, {
+		.name		= "g3d",
+		.enable		= exynos4_clk_ip_g3d_ctrl,
+		.ctrlbit	= (1 << 0),
+	}, {
 		.name		= "SYSMMU_MDMA",
 		.enable		= exynos4_clk_ip_image_ctrl,
 		.ctrlbit	= (1 << 5),
@@ -625,6 +836,10 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_image_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
+		.name		= "SYSMMU_MDMA",
+		.enable		= exynos4_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 5),
+	}, {
 		.name		= "SYSMMU_TV",
 		.enable		= exynos4_clk_ip_tv_ctrl,
 		.ctrlbit	= (1 << 4),
@@ -636,6 +851,86 @@ static struct clk init_clocks_off[] = {
 		.name		= "SYSMMU_MFC_R",
 		.enable		= exynos4_clk_ip_mfc_ctrl,
 		.ctrlbit	= (1 << 2),
+	}, {
+		.name		= "PPMU_L",
+		.enable		= exynos4_clk_ip_leftbus_ctrl,
+		.ctrlbit	= (1 << 1),
+	}, {
+		.name		= "PPMU_R",
+		.enable		= exynos4_clk_ip_rightbus_ctrl,
+		.ctrlbit	= (1 << 1),
+	}, {
+		.name		= "PPMU_MFC_L",
+		.enable		= exynos4_clk_ip_mfc_ctrl,
+		.ctrlbit	= (1 << 3),
+	}, {
+		.name		= "PPMU_MFC_R",
+		.enable		= exynos4_clk_ip_mfc_ctrl,
+		.ctrlbit	= (1 << 4),
+	}, {
+		.name		= "PPMU_G3D",
+		.enable		= exynos4_clk_ip_g3d_ctrl,
+		.ctrlbit	= (1 << 1),
+	}, {
+		.name		= "PPMU_FIMD1",
+		.enable		= exynos4_clk_ip_lcd1_ctrl,
+		.ctrlbit	= (1 << 5),
+	}, {
+		.name		= "PPMU_FILE",
+		.enable		= exynos4_clk_ip_fsys_ctrl,
+		.ctrlbit	= (1 << 17),
+	}, {
+		.name		= "PPMU_IMAGE",
+		.enable		= exynos4_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 9),
+	}, {
+		.name		= "PPMU_CAMIF",
+		.enable		= exynos4_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 16),
+	}, {
+		.name		= "PPMU_TV",
+		.enable		= exynos4_clk_ip_tv_ctrl,
+		.ctrlbit	= (1 << 5),
+	}, {
+		.name		= "PPMU_LCD0",
+		.enable		= exynos4_clk_ip_lcd0_ctrl,
+		.ctrlbit	= (1 << 5),
+	}, {
+		.name		= "QE_FIMC",
+		.devname	= "exynos4-qefimc.0",
+		.enable		= exynos4_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 12),
+	}, {
+		.name		= "QE_FIMC",
+		.devname	= "exynos4-qefimc.1",
+		.enable		= exynos4_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 13),
+	}, {
+		.name		= "QE_FIMC",
+		.devname	= "exynos4-qefimc.2",
+		.enable		= exynos4_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 14),
+	}, {
+		.name		= "QE_FIMC",
+		.devname	= "exynos4-qefimc.3",
+		.enable		= exynos4_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 15),
+	}, {
+		.name		= "QE_G3D",
+		.enable		= exynos4_clk_ip_g3d_ctrl,
+		.ctrlbit	= (1 << 2),
+	}, {
+		.name		= "QE_G2D",
+		.enable		= exynos4_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 6),
+	}, {
+		.name		= "QE_ROTATOR",
+		.enable		= exynos4_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 7),
+	}, {
+		.name		= "QE_MDMA",
+		.enable		= exynos4_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 8),
 	}
 };
 
diff --git a/arch/arm/mach-exynos4/include/mach/regs-pmu.h b/arch/arm/mach-exynos4/include/mach/regs-pmu.h
index fa49bbb..faf9b98 100644
--- a/arch/arm/mach-exynos4/include/mach/regs-pmu.h
+++ b/arch/arm/mach-exynos4/include/mach/regs-pmu.h
@@ -33,9 +33,15 @@
 #define S5P_EINT_WAKEUP_MASK			S5P_PMUREG(0x0604)
 #define S5P_WAKEUP_MASK				S5P_PMUREG(0x0608)
 
+#define S5P_HDMI_PHY_CONTROL			S5P_PMUREG(0x0700)
+#define S5P_HDMI_PHY_ENABLE			(1 << 0)
+
 #define S5P_USBHOST_PHY_CONTROL			S5P_PMUREG(0x0708)
 #define S5P_USBHOST_PHY_ENABLE			(1 << 0)
 
+#define S5P_DAC_PHY_CONTROL			S5P_PMUREG(0x070C)
+#define S5P_DAC_PHY_ENABLE			(1 << 0)
+
 #define S5P_MIPI_DPHY_CONTROL(n)		S5P_PMUREG(0x0710 + (n) * 4)
 #define S5P_MIPI_DPHY_ENABLE			(1 << 0)
 #define S5P_MIPI_DPHY_SRESETN			(1 << 1)
-- 
1.7.0.4


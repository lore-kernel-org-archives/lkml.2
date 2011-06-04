Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab1FDLkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 07:40:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38501 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab1FDLke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 07:40:34 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, olof@lixom.net,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v3 4/5] ARM: mxc: migrate mach-imx gpio driver to gpio-mxc
Date: Sat,  4 Jun 2011 19:47:17 +0800
Message-Id: <1307188038-21225-5-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307188038-21225-1-git-send-email-shawn.guo@linaro.org>
References: <1307188038-21225-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It migrates mx1/mx21/mx25/mx27/mx31/mx35 gpio driver to
drivers/gpio/gpio-mxc.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Olof Johansson <olof@lixom.net>
---
 arch/arm/mach-imx/mach-apf9328.c            |    2 ++
 arch/arm/mach-imx/mach-armadillo5x0.c       |    2 ++
 arch/arm/mach-imx/mach-bug.c                |    2 ++
 arch/arm/mach-imx/mach-cpuimx27.c           |    2 ++
 arch/arm/mach-imx/mach-cpuimx35.c           |    2 ++
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c    |    2 ++
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c |    2 ++
 arch/arm/mach-imx/mach-imx27ipcam.c         |    2 ++
 arch/arm/mach-imx/mach-imx27lite.c          |    2 ++
 arch/arm/mach-imx/mach-kzm_arm11_01.c       |    2 ++
 arch/arm/mach-imx/mach-mx1ads.c             |    2 ++
 arch/arm/mach-imx/mach-mx21ads.c            |    2 ++
 arch/arm/mach-imx/mach-mx25_3ds.c           |    2 ++
 arch/arm/mach-imx/mach-mx27_3ds.c           |    2 ++
 arch/arm/mach-imx/mach-mx27ads.c            |    2 ++
 arch/arm/mach-imx/mach-mx31_3ds.c           |    2 ++
 arch/arm/mach-imx/mach-mx31ads.c            |    2 ++
 arch/arm/mach-imx/mach-mx31lilly.c          |    2 ++
 arch/arm/mach-imx/mach-mx31lite.c           |    2 ++
 arch/arm/mach-imx/mach-mx31moboard.c        |    2 ++
 arch/arm/mach-imx/mach-mx35_3ds.c           |    2 ++
 arch/arm/mach-imx/mach-mxt_td60.c           |    2 ++
 arch/arm/mach-imx/mach-pca100.c             |    2 ++
 arch/arm/mach-imx/mach-pcm037.c             |    2 ++
 arch/arm/mach-imx/mach-pcm038.c             |    2 ++
 arch/arm/mach-imx/mach-pcm043.c             |    2 ++
 arch/arm/mach-imx/mach-qong.c               |    2 ++
 arch/arm/mach-imx/mach-scb9328.c            |    2 ++
 arch/arm/mach-imx/mach-vpr200.c             |    2 ++
 arch/arm/mach-imx/mm-imx1.c                 |   17 ++++++++---------
 arch/arm/mach-imx/mm-imx21.c                |   21 ++++++++++-----------
 arch/arm/mach-imx/mm-imx25.c                |   16 +++++++---------
 arch/arm/mach-imx/mm-imx27.c                |   21 ++++++++++-----------
 arch/arm/mach-imx/mm-imx31.c                |   15 +++++++--------
 arch/arm/mach-imx/mm-imx35.c                |   15 +++++++--------
 arch/arm/plat-mxc/include/mach/common.h     |    6 ++++++
 36 files changed, 113 insertions(+), 56 deletions(-)

diff --git a/arch/arm/mach-imx/mach-apf9328.c b/arch/arm/mach-imx/mach-apf9328.c
index 15e45c8..59d2a3b 100644
--- a/arch/arm/mach-imx/mach-apf9328.c
+++ b/arch/arm/mach-imx/mach-apf9328.c
@@ -115,6 +115,8 @@ static struct platform_device *devices[] __initdata = {
 
 static void __init apf9328_init(void)
 {
+	imx1_soc_init();
+
 	mxc_gpio_setup_multiple_pins(apf9328_pins,
 			ARRAY_SIZE(apf9328_pins),
 			"APF9328");
diff --git a/arch/arm/mach-imx/mach-armadillo5x0.c b/arch/arm/mach-imx/mach-armadillo5x0.c
index ffb40ff..ede2710 100644
--- a/arch/arm/mach-imx/mach-armadillo5x0.c
+++ b/arch/arm/mach-imx/mach-armadillo5x0.c
@@ -490,6 +490,8 @@ static struct platform_device *devices[] __initdata = {
  */
 static void __init armadillo5x0_init(void)
 {
+	imx31_soc_init();
+
 	mxc_iomux_setup_multiple_pins(armadillo5x0_pins,
 			ARRAY_SIZE(armadillo5x0_pins), "armadillo5x0");
 
diff --git a/arch/arm/mach-imx/mach-bug.c b/arch/arm/mach-imx/mach-bug.c
index 42e4f07..f494705 100644
--- a/arch/arm/mach-imx/mach-bug.c
+++ b/arch/arm/mach-imx/mach-bug.c
@@ -42,6 +42,8 @@ static const unsigned int bug_pins[] __initconst = {
 
 static void __init bug_board_init(void)
 {
+	imx31_soc_init();
+
 	mxc_iomux_setup_multiple_pins(bug_pins,
 				      ARRAY_SIZE(bug_pins), "uart-4");
 	imx31_add_imx_uart4(&uart_pdata);
diff --git a/arch/arm/mach-imx/mach-cpuimx27.c b/arch/arm/mach-imx/mach-cpuimx27.c
index 46a2e41..87887ac 100644
--- a/arch/arm/mach-imx/mach-cpuimx27.c
+++ b/arch/arm/mach-imx/mach-cpuimx27.c
@@ -250,6 +250,8 @@ __setup("otg_mode=", eukrea_cpuimx27_otg_mode);
 
 static void __init eukrea_cpuimx27_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(eukrea_cpuimx27_pins,
 		ARRAY_SIZE(eukrea_cpuimx27_pins), "CPUIMX27");
 
diff --git a/arch/arm/mach-imx/mach-cpuimx35.c b/arch/arm/mach-imx/mach-cpuimx35.c
index 3f8ef82..f39a478b 100644
--- a/arch/arm/mach-imx/mach-cpuimx35.c
+++ b/arch/arm/mach-imx/mach-cpuimx35.c
@@ -156,6 +156,8 @@ __setup("otg_mode=", eukrea_cpuimx35_otg_mode);
  */
 static void __init eukrea_cpuimx35_init(void)
 {
+	imx35_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(eukrea_cpuimx35_pads,
 			ARRAY_SIZE(eukrea_cpuimx35_pads));
 
diff --git a/arch/arm/mach-imx/mach-eukrea_cpuimx25.c b/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
index 148cff2..da36da5 100644
--- a/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
+++ b/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
@@ -125,6 +125,8 @@ __setup("otg_mode=", eukrea_cpuimx25_otg_mode);
 
 static void __init eukrea_cpuimx25_init(void)
 {
+	imx25_soc_init();
+
 	if (mxc_iomux_v3_setup_multiple_pads(eukrea_cpuimx25_pads,
 			ARRAY_SIZE(eukrea_cpuimx25_pads)))
 		printk(KERN_ERR "error setting cpuimx25 pads !\n");
diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index 7ae43b1..c6269d6 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -231,6 +231,8 @@ static void __init visstrim_m10_board_init(void)
 {
 	int ret;
 
+	imx27_soc_init();
+
 	ret = mxc_gpio_setup_multiple_pins(visstrim_m10_pins,
 			ARRAY_SIZE(visstrim_m10_pins), "VISSTRIM_M10");
 	if (ret)
diff --git a/arch/arm/mach-imx/mach-imx27ipcam.c b/arch/arm/mach-imx/mach-imx27ipcam.c
index 9be6cd6..272f793 100644
--- a/arch/arm/mach-imx/mach-imx27ipcam.c
+++ b/arch/arm/mach-imx/mach-imx27ipcam.c
@@ -50,6 +50,8 @@ static const int mx27ipcam_pins[] __initconst = {
 
 static void __init mx27ipcam_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx27ipcam_pins, ARRAY_SIZE(mx27ipcam_pins),
 		"mx27ipcam");
 
diff --git a/arch/arm/mach-imx/mach-imx27lite.c b/arch/arm/mach-imx/mach-imx27lite.c
index 8411405..d81a769 100644
--- a/arch/arm/mach-imx/mach-imx27lite.c
+++ b/arch/arm/mach-imx/mach-imx27lite.c
@@ -59,6 +59,8 @@ static const struct imxuart_platform_data uart_pdata __initconst = {
 
 static void __init mx27lite_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx27lite_pins, ARRAY_SIZE(mx27lite_pins),
 		"imx27lite");
 	imx27_add_imx_uart0(&uart_pdata);
diff --git a/arch/arm/mach-imx/mach-kzm_arm11_01.c b/arch/arm/mach-imx/mach-kzm_arm11_01.c
index 1ecae20..e472a1d 100644
--- a/arch/arm/mach-imx/mach-kzm_arm11_01.c
+++ b/arch/arm/mach-imx/mach-kzm_arm11_01.c
@@ -223,6 +223,8 @@ static int kzm_pins[] __initdata = {
  */
 static void __init kzm_board_init(void)
 {
+	imx31_soc_init();
+
 	mxc_iomux_setup_multiple_pins(kzm_pins,
 				      ARRAY_SIZE(kzm_pins), "kzm");
 	kzm_init_ext_uart();
diff --git a/arch/arm/mach-imx/mach-mx1ads.c b/arch/arm/mach-imx/mach-mx1ads.c
index 38ec5cb..5cd8bee 100644
--- a/arch/arm/mach-imx/mach-mx1ads.c
+++ b/arch/arm/mach-imx/mach-mx1ads.c
@@ -115,6 +115,8 @@ static struct i2c_board_info mx1ads_i2c_devices[] = {
  */
 static void __init mx1ads_init(void)
 {
+	imx1_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx1ads_pins,
 		ARRAY_SIZE(mx1ads_pins), "mx1ads");
 
diff --git a/arch/arm/mach-imx/mach-mx21ads.c b/arch/arm/mach-imx/mach-mx21ads.c
index 74ac889..d389ecf 100644
--- a/arch/arm/mach-imx/mach-mx21ads.c
+++ b/arch/arm/mach-imx/mach-mx21ads.c
@@ -279,6 +279,8 @@ static struct platform_device *platform_devices[] __initdata = {
 
 static void __init mx21ads_board_init(void)
 {
+	imx21_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx21ads_pins, ARRAY_SIZE(mx21ads_pins),
 			"mx21ads");
 
diff --git a/arch/arm/mach-imx/mach-mx25_3ds.c b/arch/arm/mach-imx/mach-mx25_3ds.c
index 58ea3fd..01534bb 100644
--- a/arch/arm/mach-imx/mach-mx25_3ds.c
+++ b/arch/arm/mach-imx/mach-mx25_3ds.c
@@ -219,6 +219,8 @@ static const struct esdhc_platform_data mx25pdk_esdhc_pdata __initconst = {
 
 static void __init mx25pdk_init(void)
 {
+	imx25_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx25pdk_pads,
 			ARRAY_SIZE(mx25pdk_pads));
 
diff --git a/arch/arm/mach-imx/mach-mx27_3ds.c b/arch/arm/mach-imx/mach-mx27_3ds.c
index 6e1accf..117ce0a 100644
--- a/arch/arm/mach-imx/mach-mx27_3ds.c
+++ b/arch/arm/mach-imx/mach-mx27_3ds.c
@@ -267,6 +267,8 @@ static const struct imxi2c_platform_data mx27_3ds_i2c0_data __initconst = {
 
 static void __init mx27pdk_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx27pdk_pins, ARRAY_SIZE(mx27pdk_pins),
 		"mx27pdk");
 	mx27_3ds_sdhc1_enable_level_translator();
diff --git a/arch/arm/mach-imx/mach-mx27ads.c b/arch/arm/mach-imx/mach-mx27ads.c
index 1db7950..fc26ed7 100644
--- a/arch/arm/mach-imx/mach-mx27ads.c
+++ b/arch/arm/mach-imx/mach-mx27ads.c
@@ -288,6 +288,8 @@ static const struct imxuart_platform_data uart_pdata __initconst = {
 
 static void __init mx27ads_board_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx27ads_pins, ARRAY_SIZE(mx27ads_pins),
 			"mx27ads");
 
diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
index 9b98244..ab2a626 100644
--- a/arch/arm/mach-imx/mach-mx31_3ds.c
+++ b/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -689,6 +689,8 @@ static void __init mx31_3ds_init(void)
 {
 	int ret;
 
+	imx31_soc_init();
+
 	mxc_iomux_setup_multiple_pins(mx31_3ds_pins, ARRAY_SIZE(mx31_3ds_pins),
 				      "mx31_3ds");
 
diff --git a/arch/arm/mach-imx/mach-mx31ads.c b/arch/arm/mach-imx/mach-mx31ads.c
index f4dee02..0ce4947 100644
--- a/arch/arm/mach-imx/mach-mx31ads.c
+++ b/arch/arm/mach-imx/mach-mx31ads.c
@@ -516,6 +516,8 @@ static void __init mx31ads_init_irq(void)
 
 static void __init mx31ads_init(void)
 {
+	imx31_soc_init();
+
 	mxc_init_extuart();
 	mxc_init_imx_uart();
 	mxc_init_i2c();
diff --git a/arch/arm/mach-imx/mach-mx31lilly.c b/arch/arm/mach-imx/mach-mx31lilly.c
index 410e676..750368d 100644
--- a/arch/arm/mach-imx/mach-mx31lilly.c
+++ b/arch/arm/mach-imx/mach-mx31lilly.c
@@ -243,6 +243,8 @@ core_param(mx31lilly_baseboard, mx31lilly_baseboard, int, 0444);
 
 static void __init mx31lilly_board_init(void)
 {
+	imx31_soc_init();
+
 	switch (mx31lilly_baseboard) {
 	case MX31LILLY_NOBOARD:
 		break;
diff --git a/arch/arm/mach-imx/mach-mx31lite.c b/arch/arm/mach-imx/mach-mx31lite.c
index ac9b4ca..4b47fd9 100644
--- a/arch/arm/mach-imx/mach-mx31lite.c
+++ b/arch/arm/mach-imx/mach-mx31lite.c
@@ -230,6 +230,8 @@ static void __init mx31lite_init(void)
 {
 	int ret;
 
+	imx31_soc_init();
+
 	switch (mx31lite_baseboard) {
 	case MX31LITE_NOBOARD:
 		break;
diff --git a/arch/arm/mach-imx/mach-mx31moboard.c b/arch/arm/mach-imx/mach-mx31moboard.c
index eaa51e4..a52fd36 100644
--- a/arch/arm/mach-imx/mach-mx31moboard.c
+++ b/arch/arm/mach-imx/mach-mx31moboard.c
@@ -507,6 +507,8 @@ core_param(mx31moboard_baseboard, mx31moboard_baseboard, int, 0444);
  */
 static void __init mx31moboard_init(void)
 {
+	imx31_soc_init();
+
 	mxc_iomux_setup_multiple_pins(moboard_pins, ARRAY_SIZE(moboard_pins),
 		"moboard");
 
diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index 882880a..48b3c6f 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -179,6 +179,8 @@ static const struct imxi2c_platform_data mx35_3ds_i2c0_data __initconst = {
  */
 static void __init mx35_3ds_init(void)
 {
+	imx35_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx35pdk_pads, ARRAY_SIZE(mx35pdk_pads));
 
 	imx35_add_fec(NULL);
diff --git a/arch/arm/mach-imx/mach-mxt_td60.c b/arch/arm/mach-imx/mach-mxt_td60.c
index 2774541..c85876f 100644
--- a/arch/arm/mach-imx/mach-mxt_td60.c
+++ b/arch/arm/mach-imx/mach-mxt_td60.c
@@ -233,6 +233,8 @@ static const struct imxuart_platform_data uart_pdata __initconst = {
 
 static void __init mxt_td60_board_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mxt_td60_pins, ARRAY_SIZE(mxt_td60_pins),
 			"MXT_TD60");
 
diff --git a/arch/arm/mach-imx/mach-pca100.c b/arch/arm/mach-imx/mach-pca100.c
index bbddc5a..71083aa 100644
--- a/arch/arm/mach-imx/mach-pca100.c
+++ b/arch/arm/mach-imx/mach-pca100.c
@@ -357,6 +357,8 @@ static void __init pca100_init(void)
 {
 	int ret;
 
+	imx27_soc_init();
+
 	/* SSI unit */
 	mxc_audmux_v1_configure_port(MX27_AUDMUX_HPCR1_SSI0,
 				  MXC_AUDMUX_V1_PCR_SYN | /* 4wire mode */
diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index 89c213b..f45b7cd 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -576,6 +576,8 @@ static void __init pcm037_init(void)
 {
 	int ret;
 
+	imx31_soc_init();
+
 	mxc_iomux_set_gpr(MUX_PGP_UH2, 1);
 
 	mxc_iomux_setup_multiple_pins(pcm037_pins, ARRAY_SIZE(pcm037_pins),
diff --git a/arch/arm/mach-imx/mach-pcm038.c b/arch/arm/mach-imx/mach-pcm038.c
index 853bb87..2d6a64b 100644
--- a/arch/arm/mach-imx/mach-pcm038.c
+++ b/arch/arm/mach-imx/mach-pcm038.c
@@ -295,6 +295,8 @@ static const struct mxc_usbh_platform_data usbh2_pdata __initconst = {
 
 static void __init pcm038_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(pcm038_pins, ARRAY_SIZE(pcm038_pins),
 			"PCM038");
 
diff --git a/arch/arm/mach-imx/mach-pcm043.c b/arch/arm/mach-imx/mach-pcm043.c
index 0264416..163cc31 100644
--- a/arch/arm/mach-imx/mach-pcm043.c
+++ b/arch/arm/mach-imx/mach-pcm043.c
@@ -356,6 +356,8 @@ static struct esdhc_platform_data sd1_pdata = {
  */
 static void __init pcm043_init(void)
 {
+	imx35_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(pcm043_pads, ARRAY_SIZE(pcm043_pads));
 
 	mxc_audmux_v2_configure_port(3,
diff --git a/arch/arm/mach-imx/mach-qong.c b/arch/arm/mach-imx/mach-qong.c
index c163287..3626f48 100644
--- a/arch/arm/mach-imx/mach-qong.c
+++ b/arch/arm/mach-imx/mach-qong.c
@@ -244,6 +244,8 @@ static void __init qong_init_fpga(void)
  */
 static void __init qong_init(void)
 {
+	imx31_soc_init();
+
 	mxc_init_imx_uart();
 	qong_init_nor_mtd();
 	qong_init_fpga();
diff --git a/arch/arm/mach-imx/mach-scb9328.c b/arch/arm/mach-imx/mach-scb9328.c
index dcaee04..8280526 100644
--- a/arch/arm/mach-imx/mach-scb9328.c
+++ b/arch/arm/mach-imx/mach-scb9328.c
@@ -129,6 +129,8 @@ static struct platform_device *devices[] __initdata = {
  */
 static void __init scb9328_init(void)
 {
+	imx1_soc_init();
+
 	imx1_add_imx_uart0(&uart_pdata);
 
 	printk(KERN_INFO"Scb9328: Adding devices\n");
diff --git a/arch/arm/mach-imx/mach-vpr200.c b/arch/arm/mach-imx/mach-vpr200.c
index d74e347..7d8e012 100644
--- a/arch/arm/mach-imx/mach-vpr200.c
+++ b/arch/arm/mach-imx/mach-vpr200.c
@@ -267,6 +267,8 @@ static struct platform_device *devices[] __initdata = {
  */
 static void __init vpr200_board_init(void)
 {
+	imx35_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(vpr200_pads, ARRAY_SIZE(vpr200_pads));
 
 	imx35_add_fec(NULL);
diff --git a/arch/arm/mach-imx/mm-imx1.c b/arch/arm/mach-imx/mm-imx1.c
index 2e482ba..b486595 100644
--- a/arch/arm/mach-imx/mm-imx1.c
+++ b/arch/arm/mach-imx/mm-imx1.c
@@ -23,7 +23,6 @@
 
 #include <mach/common.h>
 #include <mach/hardware.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 #include <mach/iomux-v1.h>
 
@@ -44,15 +43,15 @@ void __init imx1_init_early(void)
 			MX1_NUM_GPIO_PORT);
 }
 
-static struct mxc_gpio_port imx1_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 0, 1, MX1_GPIO_INT_PORTA),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 1, 2, MX1_GPIO_INT_PORTB),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 2, 3, MX1_GPIO_INT_PORTC),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 3, 4, MX1_GPIO_INT_PORTD),
-};
-
 void __init mx1_init_irq(void)
 {
 	mxc_init_irq(MX1_IO_ADDRESS(MX1_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx1_gpio_ports,	ARRAY_SIZE(imx1_gpio_ports));
+}
+
+void __init imx1_soc_init(void)
+{
+	mxc_register_gpio(0, MX1_GPIO1_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTA, 0);
+	mxc_register_gpio(1, MX1_GPIO2_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTB, 0);
+	mxc_register_gpio(2, MX1_GPIO3_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTC, 0);
+	mxc_register_gpio(3, MX1_GPIO4_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTD, 0);
 }
diff --git a/arch/arm/mach-imx/mm-imx21.c b/arch/arm/mach-imx/mm-imx21.c
index 7a0c500..f0fb8bc 100644
--- a/arch/arm/mach-imx/mm-imx21.c
+++ b/arch/arm/mach-imx/mm-imx21.c
@@ -24,7 +24,6 @@
 #include <mach/common.h>
 #include <asm/pgtable.h>
 #include <asm/mach/map.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 #include <mach/iomux-v1.h>
 
@@ -70,17 +69,17 @@ void __init imx21_init_early(void)
 			MX21_NUM_GPIO_PORT);
 }
 
-static struct mxc_gpio_port imx21_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX21, 0, 1, MX21_INT_GPIO),
-	DEFINE_IMX_GPIO_PORT(MX21, 1, 2),
-	DEFINE_IMX_GPIO_PORT(MX21, 2, 3),
-	DEFINE_IMX_GPIO_PORT(MX21, 3, 4),
-	DEFINE_IMX_GPIO_PORT(MX21, 4, 5),
-	DEFINE_IMX_GPIO_PORT(MX21, 5, 6),
-};
-
 void __init mx21_init_irq(void)
 {
 	mxc_init_irq(MX21_IO_ADDRESS(MX21_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx21_gpio_ports,	ARRAY_SIZE(imx21_gpio_ports));
+}
+
+void __init imx21_soc_init(void)
+{
+	mxc_register_gpio(0, MX21_GPIO1_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+	mxc_register_gpio(1, MX21_GPIO2_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+	mxc_register_gpio(2, MX21_GPIO3_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+	mxc_register_gpio(3, MX21_GPIO4_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+	mxc_register_gpio(4, MX21_GPIO5_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+	mxc_register_gpio(5, MX21_GPIO6_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
 }
diff --git a/arch/arm/mach-imx/mm-imx25.c b/arch/arm/mach-imx/mm-imx25.c
index 02f7b5c..1b6d583 100644
--- a/arch/arm/mach-imx/mm-imx25.c
+++ b/arch/arm/mach-imx/mm-imx25.c
@@ -27,7 +27,6 @@
 #include <mach/hardware.h>
 #include <mach/mx25.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 /*
@@ -57,16 +56,15 @@ void __init imx25_init_early(void)
 	mxc_arch_reset_init(MX25_IO_ADDRESS(MX25_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx25_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 0, 1, MX25_INT_GPIO1),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 1, 2, MX25_INT_GPIO2),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 2, 3, MX25_INT_GPIO3),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 3, 4, MX25_INT_GPIO4),
-};
-
 void __init mx25_init_irq(void)
 {
 	mxc_init_irq(MX25_IO_ADDRESS(MX25_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx25_gpio_ports,	ARRAY_SIZE(imx25_gpio_ports));
 }
 
+void __init imx25_soc_init(void)
+{
+	mxc_register_gpio(0, MX25_GPIO1_BASE_ADDR, SZ_16K, MX25_INT_GPIO1, 0);
+	mxc_register_gpio(1, MX25_GPIO2_BASE_ADDR, SZ_16K, MX25_INT_GPIO2, 0);
+	mxc_register_gpio(2, MX25_GPIO3_BASE_ADDR, SZ_16K, MX25_INT_GPIO3, 0);
+	mxc_register_gpio(3, MX25_GPIO4_BASE_ADDR, SZ_16K, MX25_INT_GPIO4, 0);
+}
diff --git a/arch/arm/mach-imx/mm-imx27.c b/arch/arm/mach-imx/mm-imx27.c
index a6761a3..d3700ce 100644
--- a/arch/arm/mach-imx/mm-imx27.c
+++ b/arch/arm/mach-imx/mm-imx27.c
@@ -24,7 +24,6 @@
 #include <mach/common.h>
 #include <asm/pgtable.h>
 #include <asm/mach/map.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 #include <mach/iomux-v1.h>
 
@@ -70,17 +69,17 @@ void __init imx27_init_early(void)
 			MX27_NUM_GPIO_PORT);
 }
 
-static struct mxc_gpio_port imx27_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX27, 0, 1, MX27_INT_GPIO),
-	DEFINE_IMX_GPIO_PORT(MX27, 1, 2),
-	DEFINE_IMX_GPIO_PORT(MX27, 2, 3),
-	DEFINE_IMX_GPIO_PORT(MX27, 3, 4),
-	DEFINE_IMX_GPIO_PORT(MX27, 4, 5),
-	DEFINE_IMX_GPIO_PORT(MX27, 5, 6),
-};
-
 void __init mx27_init_irq(void)
 {
 	mxc_init_irq(MX27_IO_ADDRESS(MX27_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx27_gpio_ports,	ARRAY_SIZE(imx27_gpio_ports));
+}
+
+void __init imx27_soc_init(void)
+{
+	mxc_register_gpio(0, MX27_GPIO1_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+	mxc_register_gpio(1, MX27_GPIO2_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+	mxc_register_gpio(2, MX27_GPIO3_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+	mxc_register_gpio(3, MX27_GPIO4_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+	mxc_register_gpio(4, MX27_GPIO5_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+	mxc_register_gpio(5, MX27_GPIO6_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
 }
diff --git a/arch/arm/mach-imx/mm-imx31.c b/arch/arm/mach-imx/mm-imx31.c
index 86b9b45..cb16ac6 100644
--- a/arch/arm/mach-imx/mm-imx31.c
+++ b/arch/arm/mach-imx/mm-imx31.c
@@ -26,7 +26,6 @@
 #include <mach/common.h>
 #include <mach/hardware.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 static struct map_desc mx31_io_desc[] __initdata = {
@@ -53,14 +52,14 @@ void __init imx31_init_early(void)
 	mxc_arch_reset_init(MX31_IO_ADDRESS(MX31_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx31_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX31, 0, 1, MX31_INT_GPIO1),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX31, 1, 2, MX31_INT_GPIO2),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX31, 2, 3, MX31_INT_GPIO3),
-};
-
 void __init mx31_init_irq(void)
 {
 	mxc_init_irq(MX31_IO_ADDRESS(MX31_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx31_gpio_ports,	ARRAY_SIZE(imx31_gpio_ports));
+}
+
+void __init imx31_soc_init(void)
+{
+	mxc_register_gpio(0, MX31_GPIO1_BASE_ADDR, SZ_16K, MX31_INT_GPIO1, 0);
+	mxc_register_gpio(1, MX31_GPIO2_BASE_ADDR, SZ_16K, MX31_INT_GPIO2, 0);
+	mxc_register_gpio(2, MX31_GPIO3_BASE_ADDR, SZ_16K, MX31_INT_GPIO3, 0);
 }
diff --git a/arch/arm/mach-imx/mm-imx35.c b/arch/arm/mach-imx/mm-imx35.c
index c880e6d..648bfca 100644
--- a/arch/arm/mach-imx/mm-imx35.c
+++ b/arch/arm/mach-imx/mm-imx35.c
@@ -27,7 +27,6 @@
 #include <mach/common.h>
 #include <mach/hardware.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 static struct map_desc mx35_io_desc[] __initdata = {
@@ -50,14 +49,14 @@ void __init imx35_init_early(void)
 	mxc_arch_reset_init(MX35_IO_ADDRESS(MX35_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx35_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX35, 0, 1, MX35_INT_GPIO1),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX35, 1, 2, MX35_INT_GPIO2),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX35, 2, 3, MX35_INT_GPIO3),
-};
-
 void __init mx35_init_irq(void)
 {
 	mxc_init_irq(MX35_IO_ADDRESS(MX35_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx35_gpio_ports,	ARRAY_SIZE(imx35_gpio_ports));
+}
+
+void __init imx35_soc_init(void)
+{
+	mxc_register_gpio(0, MX35_GPIO1_BASE_ADDR, SZ_16K, MX35_INT_GPIO1, 0);
+	mxc_register_gpio(1, MX35_GPIO2_BASE_ADDR, SZ_16K, MX35_INT_GPIO2, 0);
+	mxc_register_gpio(2, MX35_GPIO3_BASE_ADDR, SZ_16K, MX35_INT_GPIO3, 0);
 }
diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
index 1e1d476..91fa263 100644
--- a/arch/arm/plat-mxc/include/mach/common.h
+++ b/arch/arm/plat-mxc/include/mach/common.h
@@ -43,6 +43,12 @@ extern void mx35_init_irq(void);
 extern void mx50_init_irq(void);
 extern void mx51_init_irq(void);
 extern void mx53_init_irq(void);
+extern void imx1_soc_init(void);
+extern void imx21_soc_init(void);
+extern void imx25_soc_init(void);
+extern void imx27_soc_init(void);
+extern void imx31_soc_init(void);
+extern void imx35_soc_init(void);
 extern void imx50_soc_init(void);
 extern void imx51_soc_init(void);
 extern void imx53_soc_init(void);
-- 
1.7.4.1


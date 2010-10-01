Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab0JAL6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:58:35 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:33576 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932144Ab0JAL62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:58:28 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Vipin Kumar <vipin.kumar@st.com>, shiraz.hashim@st.com,
        deepak.sikri@st.com, armando.visconti@st.com, vipulkumar.samar@st.com,
        rajeev-dlh.kumar@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 53/69] SPEAr13xx : Fixed part devices in SPEAr13xx addded to the generic implementation
Date: Fri,  1 Oct 2010 17:26:13 +0530
Message-Id: <ea6cc9406acfaee026388797df7ab272ec828189.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vipin Kumar <vipin.kumar@st.com>

Signed-off-by: Vipin Kumar <vipin.kumar@st.com>
Signed-off-by: shiraz hashim <shiraz.hashim@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear13xx/include/mach/generic.h |  164 ++++++++
 arch/arm/mach-spear13xx/include/mach/spear.h   |    3 +
 arch/arm/mach-spear13xx/spear1300.c            |   15 +
 arch/arm/mach-spear13xx/spear1300_evb.c        |   25 ++
 arch/arm/mach-spear13xx/spear1310.c            |   15 +
 arch/arm/mach-spear13xx/spear1310_evb.c        |   25 ++
 arch/arm/mach-spear13xx/spear13xx.c            |  528 ++++++++++++++++++++++++
 arch/arm/plat-spear/Makefile                   |    1 +
 8 files changed, 776 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-spear13xx/include/mach/generic.h b/arch/arm/mach-spear13xx/include/mach/generic.h
index 56ed7a7..8a0dc8c 100644
--- a/arch/arm/mach-spear13xx/include/mach/generic.h
+++ b/arch/arm/mach-spear13xx/include/mach/generic.h
@@ -19,6 +19,168 @@
 #include <linux/amba/bus.h>
 #include <asm/mach/time.h>
 #include <asm/mach/map.h>
+#include <plat/padmux.h>
+
+/*
+ * Function enable (Pad multiplexing register) offsets
+ */
+#define PAD_MUX_CONFIG_REG_0	0x0
+#define PAD_MUX_CONFIG_REG_1	0x4
+#define PAD_MUX_CONFIG_REG_2	0x8
+#define PAD_MUX_CONFIG_REG_3	0xC
+
+/* pad mux declarations */
+#define PMX_I2S1_MASK		(1 << 3)
+#define PMX_I2S2_MASK		(1 << 16)	/* Offset 4 */
+#define PMX_CLCD1_MASK		(1 << 5)
+#define PMX_CLCD2_MASK		(1 << 3)	/* Offset 4 */
+#define PMX_EGPIO00_MASK	(1 << 6)
+#define PMX_EGPIO01_MASK	(1 << 7)
+#define PMX_EGPIO02_MASK	(1 << 8)
+#define PMX_EGPIO03_MASK	(1 << 9)
+#define PMX_EGPIO04_MASK	(1 << 10)
+#define PMX_EGPIO05_MASK	(1 << 11)
+#define PMX_EGPIO06_MASK	(1 << 12)
+#define PMX_EGPIO07_MASK	(1 << 13)
+#define PMX_EGPIO08_MASK	(1 << 14)
+#define PMX_EGPIO09_MASK	(1 << 15)
+#define PMX_EGPIO10_MASK	(1 << 5)	/* Offset 4 */
+#define PMX_EGPIO11_MASK	(1 << 6)	/* Offset 4 */
+#define PMX_EGPIO12_MASK	(1 << 7)	/* Offset 4 */
+#define PMX_EGPIO13_MASK	(1 << 8)	/* Offset 4 */
+#define PMX_EGPIO14_MASK	(1 << 9)	/* Offset 4 */
+#define PMX_EGPIO15_MASK	(1 << 10)	/* Offset 4 */
+#define PMX_EGPIO_0_GRP_MASK	(PMX_EGPIO00_MASK | PMX_EGPIO01_MASK | \
+		PMX_EGPIO02_MASK | PMX_EGPIO03_MASK | PMX_EGPIO04_MASK | \
+		PMX_EGPIO05_MASK | PMX_EGPIO06_MASK | PMX_EGPIO07_MASK | \
+		PMX_EGPIO08_MASK | PMX_EGPIO09_MASK)
+#define PMX_EGPIO_1_GRP_MASK	(PMX_EGPIO10_MASK | PMX_EGPIO11_MASK | \
+		PMX_EGPIO12_MASK | PMX_EGPIO13_MASK | PMX_EGPIO14_MASK | \
+		PMX_EGPIO15_MASK)
+
+#define PMX_SMI_MASK		(1 << 16)
+#define PMX_SMINCS2_MASK	(1 << 1)	/* Offset 4 */
+#define PMX_SMINCS3_MASK	(1 << 2)	/* Offset 4 */
+
+#define PMX_GMIICLK_MASK			(1 << 18)
+#define PMX_GMIICOL_CRS_XFERER_MIITXCLK_MASK	(1 << 19)
+#define PMX_RXCLK_RDV_TXEN_D03_MASK		(1 << 20)
+#define PMX_GMIID47_MASK			(1 << 21)
+#define PMX_MDC_MDIO_MASK			(1 << 22)
+
+#define PMX_GMII_MASK		(PMX_GMIICLK_MASK | \
+		PMX_GMIICOL_CRS_XFERER_MIITXCLK_MASK | \
+		PMX_RXCLK_RDV_TXEN_D03_MASK | PMX_GMIID47_MASK | \
+		PMX_MDC_MDIO_MASK)
+
+#define PMX_NAND8_MASK		(1 << 17)
+#define PMX_NFAD023_MASK	(1 << 24)
+#define PMX_NFAD24_MASK		(1 << 25)
+#define PMX_NFAD25_MASK		(1 << 26)
+#define PMX_NFWPRT1_MASK	(1 << 24)	/* Offset 4 */
+#define PMX_NFWPRT2_MASK	(1 << 26)	/* Offset 4 */
+#define PMX_NFWPRT3_MASK	(1 << 28)
+#define PMX_NFRSTPWDWN0_MASK	(1 << 29)
+#define PMX_NFRSTPWDWN1_MASK	(1 << 30)
+#define PMX_NFRSTPWDWN2_MASK	(1 << 31)
+#define PMX_NFRSTPWDWN3_MASK	(1 << 0)	/* Offset 4 */
+#define PMX_NFCE1_MASK		(1 << 20)	/* Offset 4 */
+#define PMX_NFCE2_MASK		(1 << 22)	/* Offset 4 */
+#define PMX_NFCE3_MASK		(1 << 27)
+#define PMX_NFIO815_MASK	(1 << 18)	/* Offset 4 */
+
+#define PMX_NAND8BIT_0_MASK	(PMX_NAND8_MASK | PMX_NFAD023_MASK | \
+		PMX_NFAD24_MASK | PMX_NFAD25_MASK | PMX_NFWPRT3_MASK | \
+		PMX_NFRSTPWDWN0_MASK | PMX_NFRSTPWDWN1_MASK | \
+		PMX_NFRSTPWDWN2_MASK | PMX_NFCE3_MASK)
+#define PMX_NAND8BIT_1_MASK	(PMX_NFRSTPWDWN3_MASK)
+
+#define PMX_NAND8BIT4DEV_0_MASK	(PMX_NAND8BIT_0_MASK)
+#define PMX_NAND8BIT4DEV_1_MASK	(PMX_NAND8BIT_1_MASK | PMX_NFCE1_MASK | \
+		PMX_NFCE2_MASK | PMX_NFWPRT1_MASK | PMX_NFWPRT2_MASK)
+
+#define PMX_NAND16BIT_0_MASK	(PMX_NAND8BIT_0_MASK)
+#define PMX_NAND16BIT_1_MASK	(PMX_NAND8BIT_1_MASK | PMX_NFIO815_MASK)
+#define PMX_NAND16BIT4DEV_0_MASK	(PMX_NAND8BIT4DEV_0_MASK)
+#define PMX_NAND16BIT4DEV_1_MASK	(PMX_NAND8BIT4DEV_1_MASK | \
+					PMX_NFIO815_MASK)
+
+#define PMX_KBD_ROW0_MASK	(1 << 25)	/* Offset 4 */
+#define PMX_KBD_ROW1_MASK	(1 << 23)	/* Offset 4 */
+#define PMX_KBD_ROWCOL25_MASK	(1 << 17)	/* Offset 4 */
+#define PMX_KBD_ROWCOL68_MASK	(1 << 4)	/* Offset 4 */
+#define PMX_KBD_COL0_MASK	(1 << 21)	/* Offset 4 */
+#define PMX_KBD_COL1_MASK	(1 << 19)	/* Offset 4 */
+#define PMX_KEYBOARD_MASK	(PMX_KBD_ROW0_MASK | PMX_KBD_ROW1_MASK | \
+		PMX_KBD_ROWCOL25_MASK | PMX_KBD_ROWCOL68_MASK | \
+		PMX_KBD_COL0_MASK | PMX_KBD_COL1_MASK)
+
+#define PMX_UART0_MASK		(1 << 1)
+#define PMX_I2C_MASK		(1 << 2)
+#define PMX_SSP_MASK		(1 << 4)
+#define PMX_UART0_MODEM_MASK	(1 << 11)	/* Offset 4 */
+#define PMX_GPT0_TMR1_MASK	(1 << 12)	/* Offset 4 */
+#define PMX_GPT0_TMR2_MASK	(1 << 13)	/* Offset 4 */
+#define PMX_GPT1_TMR1_MASK	(1 << 14)	/* Offset 4 */
+#define PMX_GPT1_TMR2_MASK	(1 << 15)	/* Offset 4 */
+
+#define PMX_MCIDATA0_MASK	(1 << 27)	/* Offset 4 */
+#define PMX_MCIDATA1_MASK	(1 << 28)	/* Offset 4 */
+#define PMX_MCIDATA2_MASK	(1 << 29)	/* Offset 4 */
+#define PMX_MCIDATA3_MASK	(1 << 30)	/* Offset 4 */
+#define PMX_MCIDATA4_MASK	(1 << 31)	/* Offset 4 */
+#define PMX_MCIDATA5_MASK	(1 << 0)	/* Offset 8 */
+#define PMX_MCIDATA6_MASK	(1 << 1)	/* Offset 8 */
+#define PMX_MCIDATA7_MASK	(1 << 2)	/* Offset 8 */
+#define PMX_MCIDATA1SD_MASK	(1 << 3)	/* Offset 8 */
+#define PMX_MCIDATA2SD_MASK	(1 << 4)	/* Offset 8 */
+#define PMX_MCIDATA3SD_MASK	(1 << 5)	/* Offset 8 */
+#define PMX_MCIADDR0ALE_MASK	(1 << 6)	/* Offset 8 */
+#define PMX_MCIADDR1CLECLK_MASK	(1 << 7)	/* Offset 8 */
+#define PMX_MCIADDR2_MASK	(1 << 8)	/* Offset 8 */
+#define PMX_MCICECF_MASK	(1 << 9)	/* Offset 8 */
+#define PMX_MCICEXD_MASK	(1 << 10)	/* Offset 8 */
+#define PMX_MCICESDMMC_MASK	(1 << 11)	/* Offset 8 */
+#define PMX_MCICDCF1_MASK	(1 << 12)	/* Offset 8 */
+#define PMX_MCICDCF2_MASK	(1 << 13)	/* Offset 8 */
+#define PMX_MCICDXD_MASK	(1 << 14)	/* Offset 8 */
+#define PMX_MCICDSDMMC_MASK	(1 << 15)	/* Offset 8 */
+#define PMX_MCIDATADIR_MASK	(1 << 16)	/* Offset 8 */
+#define PMX_MCIDMARQWP_MASK	(1 << 17)	/* Offset 8 */
+#define PMX_MCIIORDRE_MASK	(1 << 18)	/* Offset 8 */
+#define PMX_MCIIOWRWE_MASK	(1 << 19)	/* Offset 8 */
+#define PMX_MCIRESETCF_MASK	(1 << 20)	/* Offset 8 */
+#define PMX_MCICS0CE_MASK	(1 << 21)	/* Offset 8 */
+#define PMX_MCICFINTR_MASK	(1 << 22)	/* Offset 8 */
+#define PMX_MCIIORDY_MASK	(1 << 23)	/* Offset 8 */
+#define PMX_MCICS1_MASK		(1 << 24)	/* Offset 8 */
+#define PMX_MCIDMAACK_MASK	(1 << 25)	/* Offset 8 */
+#define PMX_MCISDCMD_MASK	(1 << 26)	/* Offset 8 */
+#define PMX_MCILEDS_MASK	(1 << 27)	/* Offset 8 */
+
+#define PMX_MCIFALL_1_MASK	(0xF8000000)
+#define PMX_MCIFALL_2_MASK	(0x0FFFFFFF)
+
+/* pad mux devices */
+extern struct pmx_dev pmx_i2c;
+extern struct pmx_dev pmx_ssp;
+extern struct pmx_dev pmx_i2s2;
+extern struct pmx_dev pmx_clcd1;
+extern struct pmx_dev pmx_clcd2;
+extern struct pmx_dev pmx_egpio_grp;
+extern struct pmx_dev pmx_smi_2_chips;
+extern struct pmx_dev pmx_smi_4_chips;
+extern struct pmx_dev pmx_gmii;
+extern struct pmx_dev pmx_nand_8bit;
+extern struct pmx_dev pmx_nand_16bit;
+extern struct pmx_dev pmx_keyboard;
+extern struct pmx_dev pmx_uart0;
+extern struct pmx_dev pmx_uart0_modem;
+extern struct pmx_dev pmx_gpt_0_1;
+extern struct pmx_dev pmx_gpt_0_2;
+extern struct pmx_dev pmx_gpt_1_1;
+extern struct pmx_dev pmx_gpt_1_2;
+extern struct pmx_dev pmx_mcif;
 
 /*
  * Each GPT has 2 timer channels
@@ -28,6 +190,8 @@
 #define SPEAR_GPT0_CHAN0_IRQ	IRQ_GPT0_TMR0
 #define SPEAR_GPT0_CHAN1_IRQ	IRQ_GPT0_TMR1
 
+extern struct pmx_driver pmx_driver;
+
 /* Add spear13xx family device structure declarations here */
 extern struct amba_device spear13xx_gpio_device[];
 extern struct amba_device spear13xx_ssp_device;
diff --git a/arch/arm/mach-spear13xx/include/mach/spear.h b/arch/arm/mach-spear13xx/include/mach/spear.h
index d043280..03f9616 100644
--- a/arch/arm/mach-spear13xx/include/mach/spear.h
+++ b/arch/arm/mach-spear13xx/include/mach/spear.h
@@ -88,6 +88,9 @@
 #define SPEAR13XX_MCIF_CF_BASE		UL(0xB2800000)
 #define SPEAR13XX_MCIF_SDHCI_BASE	UL(0xB3000000)
 
+/* Pad multiplexing base */
+#define SPEAR13XX_FUNC_ENB_BASE		UL(0xE0700650)
+
 /* Debug uart for linux, will be used for debug and uncompress messages */
 #define SPEAR_DBG_UART_BASE		SPEAR13XX_UART_BASE
 #define VA_SPEAR_DBG_UART_BASE		VA_SPEAR13XX_UART_BASE
diff --git a/arch/arm/mach-spear13xx/spear1300.c b/arch/arm/mach-spear13xx/spear1300.c
index c1b82f1..4569cb5 100644
--- a/arch/arm/mach-spear13xx/spear1300.c
+++ b/arch/arm/mach-spear13xx/spear1300.c
@@ -14,10 +14,25 @@
 #include <mach/generic.h>
 #include <mach/spear.h>
 
+/* pmx driver structure */
+struct pmx_driver pmx_driver;
+
 /* Add spear1300 specific devices here */
 
 void __init spear1300_init(void)
 {
+	int ret;
+
 	/* call spear13xx family common init function */
 	spear13xx_init();
+
+	/* pmx initialization */
+	pmx_driver.base = ioremap(SPEAR13XX_FUNC_ENB_BASE, SZ_4K);
+	if (pmx_driver.base) {
+		ret = pmx_register(&pmx_driver);
+		if (ret)
+			pr_err("padmux: registeration failed. err no: %d\n",
+					ret);
+		iounmap(pmx_driver.base);
+	}
 }
diff --git a/arch/arm/mach-spear13xx/spear1300_evb.c b/arch/arm/mach-spear13xx/spear1300_evb.c
index 34e2647..e35a496 100644
--- a/arch/arm/mach-spear13xx/spear1300_evb.c
+++ b/arch/arm/mach-spear13xx/spear1300_evb.c
@@ -37,6 +37,26 @@ static struct mtd_partition partition_info[] = {
 	PARTITION("Root File System", 0x380000, 84 * 0x20000),
 };
 
+/* padmux devices to enable */
+static struct pmx_dev *pmx_devs[] = {
+	/* spear13xx specific devices */
+	&pmx_i2c,
+	&pmx_i2s1,
+	&pmx_i2s2,
+	&pmx_clcd1,
+	&pmx_clcd2,
+	&pmx_egpio_grp,
+	&pmx_gmii,
+	&pmx_keyboard,
+	&pmx_mcif,
+	&pmx_nand_8bit,
+	&pmx_smi_4_chips,
+	&pmx_ssp,
+	&pmx_uart0,
+
+	/* spear1300 specific devices */
+};
+
 static struct amba_device *amba_devs[] __initdata = {
 	&spear13xx_gpio_device[0],
 	&spear13xx_gpio_device[1],
@@ -103,6 +123,11 @@ static void __init spear1300_evb_init(void)
 {
 	unsigned int i;
 
+	/* padmux initialization, must be done before spear1300_init */
+	pmx_driver.mode = NULL;
+	pmx_driver.devs = pmx_devs;
+	pmx_driver.devs_count = ARRAY_SIZE(pmx_devs);
+
 	/* set keyboard plat data */
 	kbd_set_plat_data(&spear13xx_kbd_device, &kbd_data);
 
diff --git a/arch/arm/mach-spear13xx/spear1310.c b/arch/arm/mach-spear13xx/spear1310.c
index 648dabc..cd0878e 100644
--- a/arch/arm/mach-spear13xx/spear1310.c
+++ b/arch/arm/mach-spear13xx/spear1310.c
@@ -16,6 +16,9 @@
 #include <mach/generic.h>
 #include <mach/hardware.h>
 
+/* pmx driver structure */
+struct pmx_driver pmx_driver;
+
 /* Add spear1310 specific devices here */
 
 /* CAN device registeration */
@@ -57,6 +60,18 @@ struct platform_device spear1310_can1_device = {
 
 void __init spear1310_init(void)
 {
+	int ret;
+
 	/* call spear13xx family common init function */
 	spear13xx_init();
+
+	/* pmx initialization */
+	pmx_driver.base = ioremap(SPEAR13XX_FUNC_ENB_BASE, SZ_4K);
+	if (pmx_driver.base) {
+		ret = pmx_register(&pmx_driver);
+		if (ret)
+			pr_err("padmux: registeration failed. err no: %d\n",
+					ret);
+		iounmap(pmx_driver.base);
+	}
 }
diff --git a/arch/arm/mach-spear13xx/spear1310_evb.c b/arch/arm/mach-spear13xx/spear1310_evb.c
index 1af152f..87f27cf 100644
--- a/arch/arm/mach-spear13xx/spear1310_evb.c
+++ b/arch/arm/mach-spear13xx/spear1310_evb.c
@@ -36,6 +36,26 @@ static struct mtd_partition partition_info[] = {
 	PARTITION("Root File System", 0x380000, 84 * 0x20000),
 };
 
+/* padmux devices to enable */
+static struct pmx_dev *pmx_devs[] = {
+	/* spear13xx specific devices */
+	&pmx_i2c,
+	&pmx_i2s1,
+	&pmx_i2s2,
+	&pmx_clcd1,
+	&pmx_clcd2,
+	&pmx_egpio_grp,
+	&pmx_gmii,
+	&pmx_keyboard,
+	&pmx_mcif,
+	&pmx_nand_8bit,
+	&pmx_smi_4_chips,
+	&pmx_ssp,
+	&pmx_uart0,
+
+	/* spear1310 specific devices */
+};
+
 static struct amba_device *amba_devs[] __initdata = {
 	/* spear13xx specific devices */
 	&spear13xx_gpio_device[0],
@@ -108,6 +128,11 @@ static void __init spear1310_evb_init(void)
 {
 	unsigned int i;
 
+	/* padmux initialization, must be done before spear1300_init */
+	pmx_driver.mode = NULL;
+	pmx_driver.devs = pmx_devs;
+	pmx_driver.devs_count = ARRAY_SIZE(pmx_devs);
+
 	/* set keyboard plat data */
 	kbd_set_plat_data(&spear13xx_kbd_device, &kbd_data);
 
diff --git a/arch/arm/mach-spear13xx/spear13xx.c b/arch/arm/mach-spear13xx/spear13xx.c
index d6a6dc0..623dffd 100644
--- a/arch/arm/mach-spear13xx/spear13xx.c
+++ b/arch/arm/mach-spear13xx/spear13xx.c
@@ -637,3 +637,531 @@ static void __init spear13xx_timer_init(void)
 struct sys_timer spear13xx_timer = {
 	.init = spear13xx_timer_init,
 };
+
+/* pad multiplexing support */
+/* devices */
+
+/* Pad multiplexing for i2c device */
+static struct pmx_mux_reg pmx_i2c_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_I2C_MASK,
+		.value = PMX_I2C_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_i2c_modes[] = {
+	{
+		.mux_regs = pmx_i2c_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_i2c_mux),
+	},
+};
+
+struct pmx_dev pmx_i2c = {
+	.name = "i2c",
+	.modes = pmx_i2c_modes,
+	.mode_count = ARRAY_SIZE(pmx_i2c_modes),
+};
+
+/* Pad multiplexing for ssp device */
+static struct pmx_mux_reg pmx_ssp_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_SSP_MASK,
+		.value = PMX_SSP_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_ssp_modes[] = {
+	{
+		.mux_regs = pmx_ssp_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_ssp_mux),
+	},
+};
+
+struct pmx_dev pmx_ssp = {
+	.name = "ssp",
+	.modes = pmx_ssp_modes,
+	.mode_count = ARRAY_SIZE(pmx_ssp_modes),
+};
+
+/* Pad multiplexing for i2s1 device */
+static struct pmx_mux_reg pmx_i2s1_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_I2S1_MASK,
+		.value = PMX_I2S1_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_i2s1_modes[] = {
+	{
+		.mux_regs = pmx_i2s1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_i2s1_mux),
+	},
+};
+
+struct pmx_dev pmx_i2s1 = {
+	.name = "i2s1",
+	.modes = pmx_i2s1_modes,
+	.mode_count = ARRAY_SIZE(pmx_i2s1_modes),
+};
+
+/* Pad multiplexing for i2s2 device */
+static struct pmx_mux_reg pmx_i2s2_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_I2S2_MASK,
+		.value = PMX_I2S2_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_i2s2_modes[] = {
+	{
+		.mux_regs = pmx_i2s2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_i2s2_mux),
+	},
+};
+
+struct pmx_dev pmx_i2s2 = {
+	.name = "i2s2",
+	.modes = pmx_i2s2_modes,
+	.mode_count = ARRAY_SIZE(pmx_i2s2_modes),
+};
+
+/* Pad multiplexing for clcd1 device */
+static struct pmx_mux_reg pmx_clcd1_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_CLCD1_MASK,
+		.value = PMX_CLCD1_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_clcd1_modes[] = {
+	{
+		.mux_regs = pmx_clcd1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_clcd1_mux),
+	},
+};
+
+struct pmx_dev pmx_clcd1 = {
+	.name = "clcd1",
+	.modes = pmx_clcd1_modes,
+	.mode_count = ARRAY_SIZE(pmx_clcd1_modes),
+};
+
+/* Pad multiplexing for clcd2 device */
+static struct pmx_mux_reg pmx_clcd2_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_CLCD2_MASK,
+		.value = PMX_CLCD2_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_clcd2_modes[] = {
+	{
+		.mux_regs = pmx_clcd2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_clcd2_mux),
+	},
+};
+
+struct pmx_dev pmx_clcd2 = {
+	.name = "clcd2",
+	.modes = pmx_clcd2_modes,
+	.mode_count = ARRAY_SIZE(pmx_clcd2_modes),
+};
+
+/*
+ * By default, all EGPIOs are enabled.
+ * TBD : Board specific enabling of specific GPIOs only
+ */
+static struct pmx_mux_reg pmx_egpio_grp_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_EGPIO_0_GRP_MASK,
+		.value = PMX_EGPIO_0_GRP_MASK,
+	}, {
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_EGPIO_1_GRP_MASK,
+		.value = PMX_EGPIO_1_GRP_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_egpio_grp_modes[] = {
+	{
+		.mux_regs = pmx_egpio_grp_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_egpio_grp_mux),
+	},
+};
+
+struct pmx_dev pmx_egpio_grp = {
+	.name = "egpios",
+	.modes = pmx_egpio_grp_modes,
+	.mode_count = ARRAY_SIZE(pmx_egpio_grp_modes),
+};
+
+/* Pad multiplexing for smi 2 chips device */
+static struct pmx_mux_reg pmx_smi_2_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_SMI_MASK,
+		.value = PMX_SMI_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_smi_2_modes[] = {
+	{
+		.mux_regs = pmx_smi_2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_smi_2_mux),
+	},
+};
+
+struct pmx_dev pmx_smi_2_chips = {
+	.name = "smi_2_chips",
+	.modes = pmx_smi_2_modes,
+	.mode_count = ARRAY_SIZE(pmx_smi_2_modes),
+};
+
+/* Pad multiplexing for smi 4 chips device */
+static struct pmx_mux_reg pmx_smi_4_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_SMI_MASK,
+		.value = PMX_SMI_MASK,
+	}, {
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_SMINCS2_MASK | PMX_SMINCS3_MASK,
+		.value = PMX_SMINCS2_MASK | PMX_SMINCS3_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_smi_4_modes[] = {
+	{
+		.mux_regs = pmx_smi_4_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_smi_4_mux),
+	},
+};
+
+struct pmx_dev pmx_smi_4_chips = {
+	.name = "smi_4_chips",
+	.modes = pmx_smi_4_modes,
+	.mode_count = ARRAY_SIZE(pmx_smi_4_modes),
+};
+
+/* Pad multiplexing for gmii device */
+static struct pmx_mux_reg pmx_gmii_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_GMII_MASK,
+		.value = PMX_GMII_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_gmii_modes[] = {
+	{
+		.mux_regs = pmx_gmii_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gmii_mux),
+	},
+};
+
+struct pmx_dev pmx_gmii = {
+	.name = "gmii",
+	.modes = pmx_gmii_modes,
+	.mode_count = ARRAY_SIZE(pmx_gmii_modes),
+};
+
+/* Pad multiplexing for nand 8bit (4 chips) */
+static struct pmx_mux_reg pmx_nand8_4_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_NAND8BIT4DEV_0_MASK,
+		.value = PMX_NAND8BIT4DEV_0_MASK,
+	}, {
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_NAND8BIT4DEV_1_MASK,
+		.value = PMX_NAND8BIT4DEV_1_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_nand8_4_modes[] = {
+	{
+		.mux_regs = pmx_nand8_4_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_nand8_4_mux),
+	},
+};
+
+struct pmx_dev pmx_nand_8bit_4_chips = {
+	.name = "nand-8bit_4_chips",
+	.modes = pmx_nand8_4_modes,
+	.mode_count = ARRAY_SIZE(pmx_nand8_4_modes),
+};
+
+/* Pad multiplexing for nand 8bit device */
+static struct pmx_mux_reg pmx_nand8_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_NAND8BIT_0_MASK,
+		.value = PMX_NAND8BIT_0_MASK,
+	}, {
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_NAND8BIT_1_MASK,
+		.value = PMX_NAND8BIT_1_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_nand8_modes[] = {
+	{
+		.mux_regs = pmx_nand8_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_nand8_mux),
+	},
+};
+
+struct pmx_dev pmx_nand_8bit = {
+	.name = "nand-8bit",
+	.modes = pmx_nand8_modes,
+	.mode_count = ARRAY_SIZE(pmx_nand8_modes),
+};
+
+/*
+ * Pad multiplexing for nand 16bit device
+ * Note : Enabling pmx_nand_16bit means that all the required pads for
+ *   16bit nand device operations are enabled. These also include pads
+ *   for 8bit devices
+ */
+static struct pmx_mux_reg pmx_nand16_4_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_NAND16BIT4DEV_0_MASK,
+		.value = PMX_NAND16BIT4DEV_0_MASK,
+	}, {
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_NAND16BIT4DEV_1_MASK,
+		.value = PMX_NAND16BIT4DEV_1_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_nand16_4_modes[] = {
+	{
+		.mux_regs = pmx_nand16_4_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_nand16_4_mux),
+	},
+};
+
+struct pmx_dev pmx_nand_16bit_4_chips = {
+	.name = "nand-16bit_4_chips",
+	.modes = pmx_nand16_4_modes,
+	.mode_count = ARRAY_SIZE(pmx_nand16_4_modes),
+};
+
+/* Pad multiplexing for nand 16bit device */
+static struct pmx_mux_reg pmx_nand16_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_NAND16BIT_0_MASK,
+		.value = PMX_NAND16BIT_0_MASK,
+	}, {
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_NAND16BIT_1_MASK,
+		.value = PMX_NAND16BIT_1_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_nand16_modes[] = {
+	{
+		.mux_regs = pmx_nand16_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_nand16_mux),
+	},
+};
+
+struct pmx_dev pmx_nand_16bit = {
+	.name = "nand-16bit",
+	.modes = pmx_nand16_modes,
+	.mode_count = ARRAY_SIZE(pmx_nand16_modes),
+};
+
+/* Pad multiplexing for keyboard device */
+static struct pmx_mux_reg pmx_keyboard_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_KEYBOARD_MASK,
+		.value = PMX_KEYBOARD_MASK,
+	}, {
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_NFIO815_MASK | PMX_NFCE1_MASK | \
+			PMX_NFCE2_MASK | PMX_NFWPRT1_MASK | PMX_NFWPRT2_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_keyboard_modes[] = {
+	{
+		.mux_regs = pmx_keyboard_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_keyboard_mux),
+	},
+};
+
+struct pmx_dev pmx_keyboard = {
+	.name = "keyboard",
+	.modes = pmx_keyboard_modes,
+	.mode_count = ARRAY_SIZE(pmx_keyboard_modes),
+};
+
+/* Pad multiplexing for uart0 device */
+static struct pmx_mux_reg pmx_uart0_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_UART0_MASK,
+		.value = PMX_UART0_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart0_modes[] = {
+	{
+		.mux_regs = pmx_uart0_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart0_mux),
+	},
+};
+
+struct pmx_dev pmx_uart0 = {
+	.name = "uart0",
+	.modes = pmx_uart0_modes,
+	.mode_count = ARRAY_SIZE(pmx_uart0_modes),
+};
+
+/* Pad multiplexing for uart0_modem device */
+static struct pmx_mux_reg pmx_uart0_modem_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_UART0_MODEM_MASK,
+		.value = PMX_UART0_MODEM_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart0_modem_modes[] = {
+	{
+		.mux_regs = pmx_uart0_modem_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart0_modem_mux),
+	},
+};
+
+struct pmx_dev pmx_uart0_modem = {
+	.name = "uart0_modem",
+	.modes = pmx_uart0_modem_modes,
+	.mode_count = ARRAY_SIZE(pmx_uart0_modem_modes),
+};
+
+/* Pad multiplexing for gpt_0_1 device */
+static struct pmx_mux_reg pmx_gpt_0_1_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_GPT0_TMR1_MASK,
+		.value = PMX_GPT0_TMR1_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_gpt_0_1_modes[] = {
+	{
+		.mux_regs = pmx_gpt_0_1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpt_0_1_mux),
+	},
+};
+
+struct pmx_dev pmx_gpt_0_1 = {
+	.name = "gpt_0_1",
+	.modes = pmx_gpt_0_1_modes,
+	.mode_count = ARRAY_SIZE(pmx_gpt_0_1_modes),
+};
+
+/* Pad multiplexing for gpt_0_2 device */
+static struct pmx_mux_reg pmx_gpt_0_2_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_GPT0_TMR2_MASK,
+		.value = PMX_GPT0_TMR2_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_gpt_0_2_modes[] = {
+	{
+		.mux_regs = pmx_gpt_0_2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpt_0_2_mux),
+	},
+};
+
+struct pmx_dev pmx_gpt_0_2 = {
+	.name = "gpt_0_2",
+	.modes = pmx_gpt_0_2_modes,
+	.mode_count = ARRAY_SIZE(pmx_gpt_0_2_modes),
+};
+
+/* Pad multiplexing for gpt_1_1 device */
+static struct pmx_mux_reg pmx_gpt_1_1_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_GPT1_TMR1_MASK,
+		.value = PMX_GPT1_TMR1_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_gpt_1_1_modes[] = {
+	{
+		.mux_regs = pmx_gpt_1_1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpt_1_1_mux),
+	},
+};
+
+struct pmx_dev pmx_gpt_1_1 = {
+	.name = "gpt_1_1",
+	.modes = pmx_gpt_1_1_modes,
+	.mode_count = ARRAY_SIZE(pmx_gpt_1_1_modes),
+};
+
+/* Pad multiplexing for gpt_1_2 device */
+static struct pmx_mux_reg pmx_gpt_1_2_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_GPT1_TMR2_MASK,
+		.value = PMX_GPT1_TMR2_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_gpt_1_2_modes[] = {
+	{
+		.mux_regs = pmx_gpt_1_2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gpt_1_2_mux),
+	},
+};
+
+struct pmx_dev pmx_gpt_1_2 = {
+	.name = "gpt_1_2",
+	.modes = pmx_gpt_1_2_modes,
+	.mode_count = ARRAY_SIZE(pmx_gpt_1_2_modes),
+};
+
+/* Pad multiplexing for mcif device */
+static struct pmx_mux_reg pmx_mcif_mux[] = {
+	{
+		.offset = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_MCIFALL_1_MASK,
+		.value = PMX_MCIFALL_1_MASK,
+	}, {
+		.offset = PAD_MUX_CONFIG_REG_2,
+		.mask = PMX_MCIFALL_2_MASK,
+		.value = PMX_MCIFALL_2_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_mcif_modes[] = {
+	{
+		.mux_regs = pmx_mcif_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_mcif_mux),
+	},
+};
+
+struct pmx_dev pmx_mcif = {
+	.name = "mcif",
+	.modes = pmx_mcif_modes,
+	.mode_count = ARRAY_SIZE(pmx_mcif_modes),
+};
diff --git a/arch/arm/plat-spear/Makefile b/arch/arm/plat-spear/Makefile
index c25e5b8..79503dd 100644
--- a/arch/arm/plat-spear/Makefile
+++ b/arch/arm/plat-spear/Makefile
@@ -5,6 +5,7 @@
 # Common support
 obj-y	:= clcd.o clock.o pll_clk.o smi.o time.o
 
+obj-$(CONFIG_ARCH_SPEAR13XX)	+= padmux.o
 obj-$(CONFIG_ARCH_SPEAR3XX)	+= shirq.o padmux.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
 obj-$(CONFIG_MACH_SPEAR310)	+= plgpio.o
-- 
1.7.2.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0JAL7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:59:10 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:56506 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932178Ab0JAL6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:58:33 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Viresh Kumar <viresh.kumar@st.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com
Subject: [PATCH V2 62/69] ST SPEAr: Appending spear3** with global structures
Date: Fri,  1 Oct 2010 17:26:22 +0530
Message-Id: <f4787f6021bf3a8c009595749894332c05e656df.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear3xx/include/mach/generic.h |  140 ++++++++++++------------
 arch/arm/mach-spear3xx/spear300.c             |   42 ++++----
 arch/arm/mach-spear3xx/spear300_evb.c         |   43 ++++----
 arch/arm/mach-spear3xx/spear310.c             |   16 ++--
 arch/arm/mach-spear3xx/spear310_evb.c         |   37 ++++---
 arch/arm/mach-spear3xx/spear320.c             |   32 +++---
 arch/arm/mach-spear3xx/spear320_evb.c         |   50 +++++----
 arch/arm/mach-spear3xx/spear3xx.c             |   20 ++--
 arch/arm/plat-spear/include/plat/spi.h        |    2 +-
 9 files changed, 193 insertions(+), 189 deletions(-)

diff --git a/arch/arm/mach-spear3xx/include/mach/generic.h b/arch/arm/mach-spear3xx/include/mach/generic.h
index 3138137..e0de7c7 100644
--- a/arch/arm/mach-spear3xx/include/mach/generic.h
+++ b/arch/arm/mach-spear3xx/include/mach/generic.h
@@ -31,16 +31,16 @@
 #define SPEAR_GPT0_CHAN1_IRQ	SPEAR3XX_IRQ_CPU_GPT1_2
 
 /* Add spear3xx family device structure declarations here */
-extern struct amba_device gpio_device;
-extern struct amba_device ssp0_device;
-extern struct amba_device uart_device;
-extern struct amba_device wdt_device;
-extern struct platform_device ehci_device;
-extern struct platform_device i2c_device;
-extern struct platform_device ohci0_device;
-extern struct platform_device ohci1_device;
-extern struct platform_device rtc_device;
-extern struct platform_device smi_device;
+extern struct amba_device spear3xx_gpio_device;
+extern struct amba_device spear3xx_ssp0_device;
+extern struct amba_device spear3xx_uart_device;
+extern struct amba_device spear3xx_wdt_device;
+extern struct platform_device spear3xx_ehci_device;
+extern struct platform_device spear3xx_i2c_device;
+extern struct platform_device spear3xx_ohci0_device;
+extern struct platform_device spear3xx_ohci1_device;
+extern struct platform_device spear3xx_rtc_device;
+extern struct platform_device spear3xx_smi_device;
 extern struct sys_timer spear3xx_timer;
 
 /* Add spear3xx family function declarations here */
@@ -88,49 +88,49 @@ extern struct pmx_dev spear3xx_pmx_timer_1_2;
 
 #if defined(CONFIG_MACH_SPEAR310) || defined(CONFIG_MACH_SPEAR320)
 /* padmux plgpio devices */
-extern struct pmx_dev pmx_plgpio_0_1;
-extern struct pmx_dev pmx_plgpio_2_3;
-extern struct pmx_dev pmx_plgpio_4_5;
-extern struct pmx_dev pmx_plgpio_6_9;
-extern struct pmx_dev pmx_plgpio_10_27;
-extern struct pmx_dev pmx_plgpio_28;
-extern struct pmx_dev pmx_plgpio_29;
-extern struct pmx_dev pmx_plgpio_30;
-extern struct pmx_dev pmx_plgpio_31;
-extern struct pmx_dev pmx_plgpio_32;
-extern struct pmx_dev pmx_plgpio_33;
-extern struct pmx_dev pmx_plgpio_34_36;
-extern struct pmx_dev pmx_plgpio_37_42;
-extern struct pmx_dev pmx_plgpio_43_44_47_48;
-extern struct pmx_dev pmx_plgpio_45_46_49_50;
+extern struct pmx_dev spear3xx_pmx_plgpio_0_1;
+extern struct pmx_dev spear3xx_pmx_plgpio_2_3;
+extern struct pmx_dev spear3xx_pmx_plgpio_4_5;
+extern struct pmx_dev spear3xx_pmx_plgpio_6_9;
+extern struct pmx_dev spear3xx_pmx_plgpio_10_27;
+extern struct pmx_dev spear3xx_pmx_plgpio_28;
+extern struct pmx_dev spear3xx_pmx_plgpio_29;
+extern struct pmx_dev spear3xx_pmx_plgpio_30;
+extern struct pmx_dev spear3xx_pmx_plgpio_31;
+extern struct pmx_dev spear3xx_pmx_plgpio_32;
+extern struct pmx_dev spear3xx_pmx_plgpio_33;
+extern struct pmx_dev spear3xx_pmx_plgpio_34_36;
+extern struct pmx_dev spear3xx_pmx_plgpio_37_42;
+extern struct pmx_dev spear3xx_pmx_plgpio_43_44_47_48;
+extern struct pmx_dev spear3xx_pmx_plgpio_45_46_49_50;
 #endif
 
 /* spear300 declarations */
 #ifdef CONFIG_MACH_SPEAR300
 /* Add spear300 machine device structure declarations here */
-extern struct amba_device clcd_device;
-extern struct amba_device gpio1_device;
-extern struct platform_device kbd_device;
-extern struct platform_device nand0_device;
-extern struct platform_device nand1_device;
-extern struct platform_device nand2_device;
-extern struct platform_device nand3_device;
-extern struct platform_device sdhci_device;
+extern struct amba_device spear300_clcd_device;
+extern struct amba_device spear300_gpio1_device;
+extern struct platform_device spear300_kbd_device;
+extern struct platform_device spear300_nand0_device;
+extern struct platform_device spear300_nand1_device;
+extern struct platform_device spear300_nand2_device;
+extern struct platform_device spear300_nand3_device;
+extern struct platform_device spear300_sdhci_device;
 
 /* pad mux modes */
-extern struct pmx_mode nand_mode;
-extern struct pmx_mode nor_mode;
-extern struct pmx_mode photo_frame_mode;
-extern struct pmx_mode lend_ip_phone_mode;
-extern struct pmx_mode hend_ip_phone_mode;
-extern struct pmx_mode lend_wifi_phone_mode;
-extern struct pmx_mode hend_wifi_phone_mode;
-extern struct pmx_mode ata_pabx_wi2s_mode;
-extern struct pmx_mode ata_pabx_i2s_mode;
-extern struct pmx_mode caml_lcdw_mode;
-extern struct pmx_mode camu_lcd_mode;
-extern struct pmx_mode camu_wlcd_mode;
-extern struct pmx_mode caml_lcd_mode;
+extern struct pmx_mode spear300_nand_mode;
+extern struct pmx_mode spear300_nor_mode;
+extern struct pmx_mode spear300_photo_frame_mode;
+extern struct pmx_mode spear300_lend_ip_phone_mode;
+extern struct pmx_mode spear300_hend_ip_phone_mode;
+extern struct pmx_mode spear300_lend_wifi_phone_mode;
+extern struct pmx_mode spear300_hend_wifi_phone_mode;
+extern struct pmx_mode spear300_ata_pabx_wi2s_mode;
+extern struct pmx_mode spear300_ata_pabx_i2s_mode;
+extern struct pmx_mode spear300_caml_lcdw_mode;
+extern struct pmx_mode spear300_camu_lcd_mode;
+extern struct pmx_mode spear300_camu_wlcd_mode;
+extern struct pmx_mode spear300_caml_lcd_mode;
 
 /* pad mux devices */
 extern struct pmx_dev spear300_pmx_fsmc_2_chips;
@@ -166,14 +166,14 @@ extern struct clcd_board clcd_plat_data;
 /* spear310 declarations */
 #if defined(CONFIG_MACH_SPEAR310)
 /* Add spear310 machine device structure declarations here */
-extern struct amba_device uart1_device;
-extern struct amba_device uart2_device;
-extern struct amba_device uart3_device;
-extern struct amba_device uart4_device;
-extern struct amba_device uart5_device;
-extern struct platform_device emi_nor_device;
-extern struct platform_device plgpio_device;
-extern struct platform_device nand_device;
+extern struct amba_device spear310_uart1_device;
+extern struct amba_device spear310_uart2_device;
+extern struct amba_device spear310_uart3_device;
+extern struct amba_device spear310_uart4_device;
+extern struct amba_device spear310_uart5_device;
+extern struct platform_device spear310_emi_nor_device;
+extern struct platform_device spear310_plgpio_device;
+extern struct platform_device spear310_nand_device;
 
 /* pad mux devices */
 extern struct pmx_dev spear310_pmx_emi_cs_0_1_4_5;
@@ -194,24 +194,24 @@ void __init spear310_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
 /* spear320 declarations */
 #if defined(CONFIG_MACH_SPEAR320)
 /* Add spear320 machine device structure declarations here */
-extern struct amba_device clcd_device;
-extern struct amba_device ssp_device[];
-extern struct amba_device uart1_device;
-extern struct amba_device uart2_device;
-extern struct platform_device can0_device;
-extern struct platform_device can1_device;
-extern struct platform_device emi_nor_device;
-extern struct platform_device i2c1_device;
-extern struct platform_device nand_device;
-extern struct platform_device plgpio_device;
-extern struct platform_device pwm_device;
-extern struct platform_device sdhci_device;
+extern struct amba_device spear320_clcd_device;
+extern struct amba_device spear320_ssp_device[];
+extern struct amba_device spear320_uart1_device;
+extern struct amba_device spear320_uart2_device;
+extern struct platform_device spear320_can0_device;
+extern struct platform_device spear320_can1_device;
+extern struct platform_device spear320_emi_nor_device;
+extern struct platform_device spear320_i2c1_device;
+extern struct platform_device spear320_nand_device;
+extern struct platform_device spear320_plgpio_device;
+extern struct platform_device spear320_pwm_device;
+extern struct platform_device spear320_sdhci_device;
 
 /* pad mux modes */
-extern struct pmx_mode auto_net_smii_mode;
-extern struct pmx_mode auto_net_mii_mode;
-extern struct pmx_mode auto_exp_mode;
-extern struct pmx_mode small_printers_mode;
+extern struct pmx_mode spear320_auto_net_smii_mode;
+extern struct pmx_mode spear320_auto_net_mii_mode;
+extern struct pmx_mode spear320_auto_exp_mode;
+extern struct pmx_mode spear320_small_printers_mode;
 
 /* pad mux devices */
 extern struct pmx_dev spear320_pmx_clcd;
diff --git a/arch/arm/mach-spear3xx/spear300.c b/arch/arm/mach-spear3xx/spear300.c
index 3c040f0..b661e9a 100644
--- a/arch/arm/mach-spear3xx/spear300.c
+++ b/arch/arm/mach-spear3xx/spear300.c
@@ -36,79 +36,79 @@
 #define CAML_LCD_MODE			(1 << 12)
 #define ALL_MODES			0x1FFF
 
-struct pmx_mode nand_mode = {
+struct pmx_mode spear300_nand_mode = {
 	.id = NAND_MODE,
 	.name = "nand mode",
 	.value = 0x00,
 };
 
-struct pmx_mode nor_mode = {
+struct pmx_mode spear300_nor_mode = {
 	.id = NOR_MODE,
 	.name = "nor mode",
 	.value = 0x01,
 };
 
-struct pmx_mode photo_frame_mode = {
+struct pmx_mode spear300_photo_frame_mode = {
 	.id = PHOTO_FRAME_MODE,
 	.name = "photo frame mode",
 	.value = 0x02,
 };
 
-struct pmx_mode lend_ip_phone_mode = {
+struct pmx_mode spear300_lend_ip_phone_mode = {
 	.id = LEND_IP_PHONE_MODE,
 	.name = "lend ip phone mode",
 	.value = 0x03,
 };
 
-struct pmx_mode hend_ip_phone_mode = {
+struct pmx_mode spear300_hend_ip_phone_mode = {
 	.id = HEND_IP_PHONE_MODE,
 	.name = "hend ip phone mode",
 	.value = 0x04,
 };
 
-struct pmx_mode lend_wifi_phone_mode = {
+struct pmx_mode spear300_lend_wifi_phone_mode = {
 	.id = LEND_WIFI_PHONE_MODE,
 	.name = "lend wifi phone mode",
 	.value = 0x05,
 };
 
-struct pmx_mode hend_wifi_phone_mode = {
+struct pmx_mode spear300_hend_wifi_phone_mode = {
 	.id = HEND_WIFI_PHONE_MODE,
 	.name = "hend wifi phone mode",
 	.value = 0x06,
 };
 
-struct pmx_mode ata_pabx_wi2s_mode = {
+struct pmx_mode spear300_ata_pabx_wi2s_mode = {
 	.id = ATA_PABX_WI2S_MODE,
 	.name = "ata pabx wi2s mode",
 	.value = 0x07,
 };
 
-struct pmx_mode ata_pabx_i2s_mode = {
+struct pmx_mode spear300_ata_pabx_i2s_mode = {
 	.id = ATA_PABX_I2S_MODE,
 	.name = "ata pabx i2s mode",
 	.value = 0x08,
 };
 
-struct pmx_mode caml_lcdw_mode = {
+struct pmx_mode spear300_caml_lcdw_mode = {
 	.id = CAML_LCDW_MODE,
 	.name = "caml lcdw mode",
 	.value = 0x0C,
 };
 
-struct pmx_mode camu_lcd_mode = {
+struct pmx_mode spear300_camu_lcd_mode = {
 	.id = CAMU_LCD_MODE,
 	.name = "camu lcd mode",
 	.value = 0x0D,
 };
 
-struct pmx_mode camu_wlcd_mode = {
+struct pmx_mode spear300_camu_wlcd_mode = {
 	.id = CAMU_WLCD_MODE,
 	.name = "camu wlcd mode",
 	.value = 0x0E,
 };
 
-struct pmx_mode caml_lcd_mode = {
+struct pmx_mode spear300_caml_lcd_mode = {
 	.id = CAML_LCD_MODE,
 	.name = "caml lcd mode",
 	.value = 0x0F,
@@ -526,7 +526,7 @@ static struct pmx_driver pmx_driver = {
 /* Add spear300 specific devices here */
 
 /* CLCD device registration */
-struct amba_device clcd_device = {
+struct amba_device spear300_clcd_device = {
 	.dev = {
 		.init_name = "clcd",
 		.coherent_dma_mask = ~0,
@@ -547,7 +547,7 @@ static struct pl061_platform_data gpio1_plat_data = {
 	.irq_base	= SPEAR300_GPIO1_INT_BASE,
 };
 
-struct amba_device gpio1_device = {
+struct amba_device spear300_gpio1_device = {
 	.dev = {
 		.init_name = "gpio1",
 		.platform_data = &gpio1_plat_data,
@@ -572,7 +572,7 @@ static struct resource kbd_resources[] = {
 	},
 };
 
-struct platform_device kbd_device = {
+struct platform_device spear300_kbd_device = {
 	.name = "keyboard",
 	.id = -1,
 	.num_resources = ARRAY_SIZE(kbd_resources),
@@ -596,7 +596,7 @@ static struct resource nand0_resources[] = {
 	},
 };
 
-struct platform_device nand0_device = {
+struct platform_device spear300_nand0_device = {
 	.name = "nand",
 	.id = 0,
 	.resource = nand0_resources,
@@ -620,7 +620,7 @@ static struct resource nand1_resources[] = {
 	},
 };
 
-struct platform_device nand1_device = {
+struct platform_device spear300_nand1_device = {
 	.name = "nand",
 	.id = 1,
 	.resource = nand1_resources,
@@ -644,7 +644,7 @@ static struct resource nand2_resources[] = {
 	},
 };
 
-struct platform_device nand2_device = {
+struct platform_device spear300_nand2_device = {
 	.name = "nand",
 	.id = 2,
 	.resource = nand2_resources,
@@ -668,7 +668,7 @@ static struct resource nand3_resources[] = {
 	},
 };
 
-struct platform_device nand3_device = {
+struct platform_device spear300_nand3_device = {
 	.name = "nand",
 	.id = 3,
 	.resource = nand3_resources,
@@ -688,7 +688,7 @@ static struct resource sdhci_resources[] = {
 	}
 };
 
-struct platform_device sdhci_device = {
+struct platform_device spear300_sdhci_device = {
 	.dev = {
 		.coherent_dma_mask = ~0,
 	},
diff --git a/arch/arm/mach-spear3xx/spear300_evb.c b/arch/arm/mach-spear3xx/spear300_evb.c
index 0adf9f7..7514115 100644
--- a/arch/arm/mach-spear3xx/spear300_evb.c
+++ b/arch/arm/mach-spear3xx/spear300_evb.c
@@ -44,29 +44,29 @@ static struct pmx_dev *pmx_devs[] = {
 
 static struct amba_device *amba_devs[] __initdata = {
 	/* spear3xx specific devices */
-	&gpio_device,
-	&ssp0_device,
-	&uart_device,
-	&wdt_device,
+	&spear3xx_gpio_device,
+	&spear3xx_ssp0_device,
+	&spear3xx_uart_device,
+	&spear3xx_wdt_device,
 
 	/* spear300 specific devices */
-	&clcd_device,
-	&gpio1_device,
+	&spear300_clcd_device,
+	&spear300_gpio1_device,
 };
 
 static struct platform_device *plat_devs[] __initdata = {
 	/* spear3xx specific devices */
-	&ehci_device,
-	&i2c_device,
-	&nand0_device,
-	&ohci0_device,
-	&ohci1_device,
-	&rtc_device,
-	&smi_device,
+	&spear3xx_ehci_device,
+	&spear3xx_i2c_device,
+	&spear3xx_ohci0_device,
+	&spear3xx_ohci1_device,
+	&spear3xx_rtc_device,
+	&spear3xx_smi_device,
 
 	/* spear300 specific devices */
-	&kbd_device,
-	&sdhci_device,
+	&spear300_kbd_device,
+	&spear300_nand0_device,
+	&spear300_sdhci_device,
 };
 
 /* sdhci board specific information */
@@ -114,26 +114,27 @@ static void __init spear300_evb_init(void)
 	unsigned int i;
 
 	/* set keyboard plat data */
-	kbd_set_plat_data(&kbd_device, &kbd_data);
+	kbd_set_plat_data(&spear300_kbd_device, &kbd_data);
 
 	/* set nand0 device's plat data */
-	fsmc_nand_set_plat_data(&nand0_device, NULL, 0, NAND_SKIP_BBTSCAN,
-			FSMC_NAND_BW8);
+	fsmc_nand_set_plat_data(&spear300_nand0_device, NULL, 0,
+			NAND_SKIP_BBTSCAN, FSMC_NAND_BW8);
 
 	/* set sdhci device platform data */
-	sdhci_set_plat_data(&sdhci_device, &sdhci_plat_data);
+	sdhci_set_plat_data(&spear300_sdhci_device, &sdhci_plat_data);
 
 	/* Enable sdhci memory */
 	sdhci_i2s_mem_enable(SDHCI_MEM_ENB);
 
 	/* call spear300 machine init function */
-	spear300_init(&photo_frame_mode, pmx_devs, ARRAY_SIZE(pmx_devs));
+	spear300_init(&spear300_photo_frame_mode, pmx_devs,
+			ARRAY_SIZE(pmx_devs));
 
 	/* Register slave devices on the I2C buses */
 	i2c_register_board_devices();
 
 	/* initialize serial nor related data in smi plat data */
-	smi_init_board_info(&smi_device);
+	smi_init_board_info(&spear3xx_smi_device);
 
 	/* Add Platform Devices */
 	platform_add_devices(plat_devs, ARRAY_SIZE(plat_devs));
diff --git a/arch/arm/mach-spear3xx/spear310.c b/arch/arm/mach-spear3xx/spear310.c
index f25d2b4..4737182 100644
--- a/arch/arm/mach-spear3xx/spear310.c
+++ b/arch/arm/mach-spear3xx/spear310.c
@@ -196,7 +196,7 @@ static struct pmx_driver pmx_driver;
 
 /* Add spear310 specific devices here */
 /* uart1 device registeration */
-struct amba_device uart1_device = {
+struct amba_device spear310_uart1_device = {
 	.dev = {
 		.init_name = "uart1",
 	},
@@ -209,7 +209,7 @@ struct amba_device uart1_device = {
 };
 
 /* uart2 device registeration */
-struct amba_device uart2_device = {
+struct amba_device spear310_uart2_device = {
 	.dev = {
 		.init_name = "uart2",
 	},
@@ -222,7 +222,7 @@ struct amba_device uart2_device = {
 };
 
 /* uart3 device registeration */
-struct amba_device uart3_device = {
+struct amba_device spear310_uart3_device = {
 	.dev = {
 		.init_name = "uart3",
 	},
@@ -235,7 +235,7 @@ struct amba_device uart3_device = {
 };
 
 /* uart4 device registeration */
-struct amba_device uart4_device = {
+struct amba_device spear310_uart4_device = {
 	.dev = {
 		.init_name = "uart4",
 	},
@@ -248,7 +248,7 @@ struct amba_device uart4_device = {
 };
 
 /* uart5 device registeration */
-struct amba_device uart5_device = {
+struct amba_device spear310_uart5_device = {
 	.dev = {
 		.init_name = "uart5",
 	},
@@ -277,7 +277,7 @@ static struct resource nand_resources[] = {
 	},
 };
 
-struct platform_device nand_device = {
+struct platform_device spear310_nand_device = {
 	.name = "nand",
 	.id = -1,
 	.resource = nand_resources,
@@ -323,7 +323,7 @@ int spear300_o2p(int offset)
 
 /* emi nor flash device registeration */
 static struct physmap_flash_data emi_norflash_data;
-struct platform_device emi_nor_device = {
+struct platform_device spear310_emi_nor_device = {
 	.name	= "physmap-flash",
 	.id	= -1,
 	.dev.platform_data = &emi_norflash_data,
@@ -351,7 +351,7 @@ static struct resource plgpio_resources[] = {
 	},
 };
 
-struct platform_device plgpio_device = {
+struct platform_device spear310_plgpio_device = {
 	.name = "plgpio",
 	.id = -1,
 	.dev = {
diff --git a/arch/arm/mach-spear3xx/spear310_evb.c b/arch/arm/mach-spear3xx/spear310_evb.c
index 953a9ea..2c1044d 100644
--- a/arch/arm/mach-spear3xx/spear310_evb.c
+++ b/arch/arm/mach-spear3xx/spear310_evb.c
@@ -69,27 +69,27 @@ static struct pmx_dev *pmx_devs[] = {
 
 static struct amba_device *amba_devs[] __initdata = {
 	/* spear3xx specific devices */
-	&gpio_device,
-	&ssp0_device,
-	&uart_device,
-	&wdt_device,
+	&spear3xx_gpio_device,
+	&spear3xx_ssp0_device,
+	&spear3xx_uart_device,
+	&spear3xx_wdt_device,
 
 	/* spear310 specific devices */
 };
 
 static struct platform_device *plat_devs[] __initdata = {
 	/* spear3xx specific devices */
-	&ehci_device,
-	&emi_nor_device,
-	&i2c_device,
-	&nand_device,
-	&ohci0_device,
-	&ohci1_device,
-	&rtc_device,
-	&smi_device,
+	&spear3xx_ehci_device,
+	&spear3xx_i2c_device,
+	&spear3xx_ohci0_device,
+	&spear3xx_ohci1_device,
+	&spear3xx_rtc_device,
+	&spear3xx_smi_device,
 
 	/* spear310 specific devices */
-	&plgpio_device,
+	&spear310_emi_nor_device,
+	&spear310_nand_device,
+	&spear310_plgpio_device,
 };
 
 /* spi board information */
@@ -132,8 +132,8 @@ static void __init spear310_evb_init(void)
 	unsigned int i;
 
 	/* set nand device's plat data */
-	fsmc_nand_set_plat_data(&nand_device, NULL, 0, NAND_SKIP_BBTSCAN,
-			FSMC_NAND_BW8);
+	fsmc_nand_set_plat_data(&spear310_nand_device, NULL, 0,
+			NAND_SKIP_BBTSCAN, FSMC_NAND_BW8);
 
 	/* call spear310 machine init function */
 	spear310_init(NULL, pmx_devs, ARRAY_SIZE(pmx_devs));
@@ -142,10 +142,10 @@ static void __init spear310_evb_init(void)
 	i2c_register_board_devices();
 
 	/* initialize serial nor related data in smi plat data */
-	smi_init_board_info(&smi_device);
+	smi_init_board_info(&spear3xx_smi_device);
 
 	/* initialize emi related data in emi plat data */
-	emi_init_board_info(&emi_nor_device, emi_nor_resources,
+	emi_init_board_info(&spear310_emi_nor_device, emi_nor_resources,
 			ARRAY_SIZE(emi_nor_resources), partition_info,
 			ARRAY_SIZE(partition_info), EMI_FLASH_WIDTH32);
 
@@ -157,7 +157,8 @@ static void __init spear310_evb_init(void)
 		amba_device_register(amba_devs[i], &iomem_resource);
 
 	/* Initialize emi regiters */
-	emi_init(&emi_nor_device, SPEAR310_EMI_REG_BASE, 0, EMI_FLASH_WIDTH32);
+	emi_init(&spear310_emi_nor_device, SPEAR310_EMI_REG_BASE, 0,
+			EMI_FLASH_WIDTH32);
 
 	spi_init();
 }
diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
index bcd76e4..73b8b10 100644
--- a/arch/arm/mach-spear3xx/spear320.c
+++ b/arch/arm/mach-spear3xx/spear320.c
@@ -30,25 +30,25 @@
 #define SMALL_PRINTERS_MODE	(1 << 3)
 #define ALL_MODES		0xF
 
-struct pmx_mode auto_net_smii_mode = {
+struct pmx_mode spear320_auto_net_smii_mode = {
 	.id = AUTO_NET_SMII_MODE,
 	.name = "Automation Networking SMII Mode",
 	.value = 0x00,
 };
 
-struct pmx_mode auto_net_mii_mode = {
+struct pmx_mode spear320_auto_net_mii_mode = {
 	.id = AUTO_NET_MII_MODE,
 	.name = "Automation Networking MII Mode",
 	.value = 0x01,
 };
 
-struct pmx_mode auto_exp_mode = {
+struct pmx_mode spear320_auto_exp_mode = {
 	.id = AUTO_EXP_MODE,
 	.name = "Automation Expanded Mode",
 	.value = 0x02,
 };
 
-struct pmx_mode small_printers_mode = {
+struct pmx_mode spear320_small_printers_mode = {
 	.id = SMALL_PRINTERS_MODE,
 	.name = "Small Printers Mode",
 	.value = 0x03,
@@ -594,7 +594,7 @@ static struct pmx_driver pmx_driver = {
 
 /* Add spear320 specific devices here */
 /* CLCD device registration */
-struct amba_device clcd_device = {
+struct amba_device spear320_clcd_device = {
 	.dev = {
 		.init_name = "clcd",
 		.coherent_dma_mask = ~0,
@@ -622,7 +622,7 @@ static struct pl022_ssp_controller ssp_platform_data[] = {
 	}
 };
 
-struct amba_device ssp_device[] = {
+struct amba_device spear320_ssp_device[] = {
 	{
 		.dev = {
 			.coherent_dma_mask = ~0,
@@ -651,7 +651,7 @@ struct amba_device ssp_device[] = {
 };
 
 /* uart1 device registeration */
-struct amba_device uart1_device = {
+struct amba_device spear320_uart1_device = {
 	.dev = {
 		.init_name = "uart1",
 	},
@@ -664,7 +664,7 @@ struct amba_device uart1_device = {
 };
 
 /* uart2 device registeration */
-struct amba_device uart2_device = {
+struct amba_device spear320_uart2_device = {
 	.dev = {
 		.init_name = "uart2",
 	},
@@ -678,7 +678,7 @@ struct amba_device uart2_device = {
 
 /* emi nor flash device registeration */
 static struct physmap_flash_data emi_norflash_data;
-struct platform_device emi_nor_device = {
+struct platform_device spear320_emi_nor_device = {
 	.name	= "physmap-flash",
 	.id	= -1,
 	.dev.platform_data = &emi_norflash_data,
@@ -703,7 +703,7 @@ static struct resource can0_resources[] = {
 	},
 };
 
-struct platform_device can0_device = {
+struct platform_device spear320_can0_device = {
 	.name = "spear_can",
 	.id = 0,
 	.num_resources = ARRAY_SIZE(can0_resources),
@@ -721,7 +721,7 @@ static struct resource can1_resources[] = {
 	},
 };
 
-struct platform_device can1_device = {
+struct platform_device spear320_can1_device = {
 	.name = "spear_can",
 	.id = 1,
 	.num_resources = ARRAY_SIZE(can1_resources),
@@ -740,7 +740,7 @@ static struct resource i2c1_resources[] = {
 	},
 };
 
-struct platform_device i2c1_device = {
+struct platform_device spear320_i2c1_device = {
 	.name = "i2c_designware",
 	.id = 1,
 	.dev = {
@@ -767,7 +767,7 @@ static struct resource nand_resources[] = {
 	},
 };
 
-struct platform_device nand_device = {
+struct platform_device spear320_nand_device = {
 	.name = "nand",
 	.id = -1,
 	.resource = nand_resources,
@@ -786,7 +786,7 @@ static struct resource plgpio_resources[] = {
 	},
 };
 
-struct platform_device plgpio_device = {
+struct platform_device spear320_plgpio_device = {
 	.name = "plgpio",
 	.id = -1,
 	.dev = {
@@ -805,7 +805,7 @@ static struct resource pwm_resources[] = {
 	},
 };
 
-struct platform_device pwm_device = {
+struct platform_device spear320_pwm_device = {
 	.name = "pwm",
 	.id = -1,
 	.num_resources = ARRAY_SIZE(pwm_resources),
@@ -824,7 +824,7 @@ static struct resource sdhci_resources[] = {
 	}
 };
 
-struct platform_device sdhci_device = {
+struct platform_device spear320_sdhci_device = {
 	.dev = {
 		.coherent_dma_mask = ~0,
 	},
diff --git a/arch/arm/mach-spear3xx/spear320_evb.c b/arch/arm/mach-spear3xx/spear320_evb.c
index eff4fb3..116dd1b 100644
--- a/arch/arm/mach-spear3xx/spear320_evb.c
+++ b/arch/arm/mach-spear3xx/spear320_evb.c
@@ -67,31 +67,31 @@ static struct pmx_dev *pmx_devs[] = {
 
 static struct amba_device *amba_devs[] __initdata = {
 	/* spear3xx specific devices */
-	&gpio_device,
-	&uart_device,
-	&wdt_device,
+	&spear3xx_gpio_device,
+	&spear3xx_uart_device,
+	&spear3xx_wdt_device,
 
 	/* spear320 specific devices */
-	&clcd_device,
+	&spear320_clcd_device,
 };
 
 static struct platform_device *plat_devs[] __initdata = {
 	/* spear3xx specific devices */
-	&ehci_device,
-	&i2c_device,
-	&nand_device,
-	&ohci0_device,
-	&ohci1_device,
-	&rtc_device,
-	&smi_device,
+	&spear3xx_ehci_device,
+	&spear3xx_i2c_device,
+	&spear3xx_ohci0_device,
+	&spear3xx_ohci1_device,
+	&spear3xx_rtc_device,
+	&spear3xx_smi_device,
 
 	/* spear320 specific devices */
-	&can0_device,
-	&can1_device,
-	&i2c1_device,
-	&plgpio_device,
-	&pwm_device,
-	&sdhci_device,
+	&spear320_can0_device,
+	&spear320_can1_device,
+	&spear320_i2c1_device,
+	&spear320_nand_device,
+	&spear320_plgpio_device,
+	&spear320_pwm_device,
+	&spear320_sdhci_device,
 };
 
 /* sdhci board specific information */
@@ -115,23 +115,24 @@ static void __init spear320_evb_init(void)
 	unsigned int i;
 
 	/* set sdhci device platform data */
-	sdhci_set_plat_data(&sdhci_device, &sdhci_plat_data);
+	sdhci_set_plat_data(&spear320_sdhci_device, &sdhci_plat_data);
 
 	/* set nand device's plat data */
-	fsmc_nand_set_plat_data(&nand_device, NULL, 0, NAND_SKIP_BBTSCAN,
-			FSMC_NAND_BW8);
+	fsmc_nand_set_plat_data(&spear320_nand_device, NULL, 0,
+			NAND_SKIP_BBTSCAN, FSMC_NAND_BW8);
 
 	/* call spear320 machine init function */
-	spear320_init(&auto_net_mii_mode, pmx_devs, ARRAY_SIZE(pmx_devs));
+	spear320_init(&spear320_auto_net_mii_mode, pmx_devs,
+			ARRAY_SIZE(pmx_devs));
 
 	/* initialize serial nor related data in smi plat data */
-	smi_init_board_info(&smi_device);
+	smi_init_board_info(&spear3xx_smi_device);
 
 	/* Register slave devices on the I2C buses */
 	i2c_register_board_devices();
 
 	/* initialize emi related data in emi plat data */
-	emi_init_board_info(&emi_nor_device, emi_nor_resources,
+	emi_init_board_info(&spear320_emi_nor_device, emi_nor_resources,
 			ARRAY_SIZE(emi_nor_resources), partition_info,
 			ARRAY_SIZE(partition_info), EMI_FLASH_WIDTH16);
 
@@ -143,7 +144,8 @@ static void __init spear320_evb_init(void)
 		amba_device_register(amba_devs[i], &iomem_resource);
 
 	/* Initialize emi regiters */
-	emi_init(&emi_nor_device, SPEAR320_EMI_CTRL_BASE, 0, EMI_FLASH_WIDTH16);
+	emi_init(&spear320_emi_nor_device, SPEAR320_EMI_CTRL_BASE, 0,
+			EMI_FLASH_WIDTH16);
 
 	spi_init();
 }
diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index 8c00c2b..15dea9e 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -32,7 +32,7 @@ static struct pl061_platform_data gpio_plat_data = {
 	.irq_base	= SPEAR3XX_GPIO_INT_BASE,
 };
 
-struct amba_device gpio_device = {
+struct amba_device spear3xx_gpio_device = {
 	.dev = {
 		.init_name = "gpio",
 		.platform_data = &gpio_plat_data,
@@ -61,7 +61,7 @@ static struct pl022_ssp_controller ssp_platform_data = {
 	.num_chipselect = 2,
 };
 
-struct amba_device ssp0_device = {
+struct amba_device spear3xx_ssp0_device = {
 	.dev = {
 		.coherent_dma_mask = ~0,
 		.init_name = "ssp-pl022.0",
@@ -76,7 +76,7 @@ struct amba_device ssp0_device = {
 };
 
 /* uart device registeration */
-struct amba_device uart_device = {
+struct amba_device spear3xx_uart_device = {
 	.dev = {
 		.init_name = "uart",
 	},
@@ -89,7 +89,7 @@ struct amba_device uart_device = {
 };
 
 /* watchdog device registeration */
-struct amba_device wdt_device = {
+struct amba_device spear3xx_wdt_device = {
 	.dev = {
 		.init_name = "wdt",
 	},
@@ -112,7 +112,7 @@ static struct resource i2c_resources[] = {
 	},
 };
 
-struct platform_device i2c_device = {
+struct platform_device spear3xx_i2c_device = {
 	.name = "i2c_designware",
 	.id = 0,
 	.dev = {
@@ -162,7 +162,7 @@ static struct resource ohci1_resources[] = {
 static u64 ehci_dmamask = ~0;
 static int usbh_id = -1;
 
-struct platform_device ehci_device = {
+struct platform_device spear3xx_ehci_device = {
 	.name = "spear-ehci",
 	.id = -1,
 	.dev = {
@@ -176,7 +176,7 @@ struct platform_device ehci_device = {
 
 static u64 ohci0_dmamask = ~0;
 
-struct platform_device ohci0_device = {
+struct platform_device spear3xx_ohci0_device = {
 	.name = "spear-ohci",
 	.id = 0,
 	.dev = {
@@ -190,7 +190,7 @@ struct platform_device ohci0_device = {
 
 static u64 ohci1_dmamask = ~0;
 
-struct platform_device ohci1_device = {
+struct platform_device spear3xx_ohci1_device = {
 	.name = "spear-ohci",
 	.id = 1,
 	.dev = {
@@ -214,7 +214,7 @@ static struct resource rtc_resources[] = {
 	},
 };
 
-struct platform_device rtc_device = {
+struct platform_device spear3xx_rtc_device = {
 	.name = "rtc-spear",
 	.id = -1,
 	.num_resources = ARRAY_SIZE(rtc_resources),
@@ -233,7 +233,7 @@ static struct resource smi_resources[] = {
 	},
 };
 
-struct platform_device smi_device = {
+struct platform_device spear3xx_smi_device = {
 	.name = "smi",
 	.id = -1,
 	.num_resources = ARRAY_SIZE(smi_resources),
diff --git a/arch/arm/plat-spear/include/plat/spi.h b/arch/arm/plat-spear/include/plat/spi.h
index a2c53f3..c53410a 100644
--- a/arch/arm/plat-spear/include/plat/spi.h
+++ b/arch/arm/plat-spear/include/plat/spi.h
@@ -55,7 +55,7 @@ static void spi##id##_##type##_cs_control(u32 control)	\
 
 /* This will define CHIP_INFO structure for a specific spi slave */
 #define DECLARE_SPI_CHIP_INFO(id, type, chip_select_control)	\
-struct pl022_config_chip spi##id##_##type##_chip_info = {	\
+static struct pl022_config_chip spi##id##_##type##_chip_info = {\
 	.lbm = LOOPBACK_DISABLED,			\
 	.iface = SSP_INTERFACE_MOTOROLA_SPI,		\
 	.hierarchy = SSP_MASTER,			\
-- 
1.7.2.2


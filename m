Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab1AMXaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 18:30:01 -0500
Received: from web121609.mail.ne1.yahoo.com ([98.138.90.121]:47216 "HELO
	web121609.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757257Ab1AMX3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 18:29:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=ecEEMUcdcRXBiC3XGYY/FdCFAV9qAX71TvXZsBe/AbL5JOBfsSzOm/v5dkM7xW6pNMjKAJra5ecQrKpadCVqWT1ukUSiO2qmNfIzlrJT133XeQO/Uh+D0Fh2E5W6N935xnGfOnbquhczxoGwP8GZr2DScWJ9uWv3YfYJVhUOncw=;
Message-ID: <524702.86777.qm@web121609.mail.ne1.yahoo.com>
X-YMail-OSG: 4hPJeisVM1mAMEyUoSfNHOkyVAq62WG0vwpt3DuZWNm7Rrt
 B9QAFFlaN6XNZuUtDP_E13sO3w76694I4YFx35vzaVTnjGyp_wb9geKaSFiu
 09TTgZ0Dx.m0b.V9tkMmslI.6xK6JvMyKJG24kmqsElx27GuLrLuB2YOhO6a
 LoYsh0b0yBdlyuSvyg1qVuJoeu8gVFIzar1jh7sDmhKnpC2Oc1rpRwHIZpCT
 4tpxBf6AbibwR31d6BbzyvxBpaKiCNz5EC.rBnQyWkGW1dk1AvnlFujrqsYm
 Zol_0_oCbtyjW1b3gL.ZwhTgZzwB64eTNhb5aNSArpOoMfRwVb4IZ_bx0YNt
 F9F10gCzutYaQQ9VYGFg619delAPqTEWRLjJ7OndLSqV9n0Glkrq2l84IIo5
 XN2BHLxt7MQ81GiE1WgnWVEaz1KB0le8TMIwKzzCafpKif9zAjrcztLNZsaK
 sk2d_i596FsqBLHHSp_qPPdwrcfsRfNkmDI6WE2Fxt5wpPIrxWKxWiVCWCRV
 U3nDcGXuvCJTqK.2QQ4pBaf6qJu6O.hjDUam0wB8O.qFHWufTCqc-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Thu, 13 Jan 2011 15:23:14 -0800 (PST)
From: Sutharsan Ramamoorthy <sutharsan.ramamoorthy@yahoo.com>
Subject: [PATCH] adding gpmc configuration functions, west bridge related
To: greg@kroah.com
Cc: tony@atomide.com, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, david.cross@cypress.com, srmt@cypress.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements gpmc configuration functions needed by westbridge
device controller driver in staging tree. These functions currently 
implemented in staging tree. This patch is part of the effort to bring 
westbridge device controller driver out of staging tree.

Signed-off by: Sutharsan Ramamoorthy <sutharsan.ramamoorthy@yahoo.com>

---

diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/arch/arm/mach-omap2/board-zoom-peripherals.c linux-2.6.37-gpmc/arch/arm/mach-omap2/board-zoom-peripherals.c
--- linux-2.6.37_vanilla/arch/arm/mach-omap2/board-zoom-peripherals.c	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-gpmc/arch/arm/mach-omap2/board-zoom-peripherals.c	2011-01-11 13:33:20.750681000 -0800
@@ -19,6 +19,7 @@
 #include <linux/regulator/fixed.h>
 #include <linux/wl12xx.h>
 #include <linux/mmc/host.h>
+#include <linux/usb/cywb.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -348,6 +349,9 @@ void __init zoom_peripherals_init(void)
 	omap_i2c_init();
 	platform_device_register(&omap_vwlan_device);
 	usb_musb_init(&musb_board_data);
+#ifdef CONFIG_WESTBRIDGE_ASTORIA
+	usb_cywb_init();
+#endif
 	enable_board_wakeup_source();
 	omap_serial_init();
 }
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/arch/arm/mach-omap2/Makefile linux-2.6.37-gpmc/arch/arm/mach-omap2/Makefile
--- linux-2.6.37_vanilla/arch/arm/mach-omap2/Makefile	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-gpmc/arch/arm/mach-omap2/Makefile	2010-12-28 15:24:28.218691000 -0800
@@ -182,6 +182,7 @@ obj-y					+= $(usbfs-m) $(usbfs-y)
 obj-y					+= usb-musb.o
 obj-$(CONFIG_MACH_OMAP2_TUSB6010)	+= usb-tusb6010.o
 obj-y					+= usb-ehci.o
+obj-$(CONFIG_WESTBRIDGE_ASTORIA)        += usb-cywb-pnand.o
 
 onenand-$(CONFIG_MTD_ONENAND_OMAP2)	:= gpmc-onenand.o
 obj-y					+= $(onenand-m) $(onenand-y)
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/arch/arm/mach-omap2/usb-cywb-pnand.c linux-2.6.37-gpmc/arch/arm/mach-omap2/usb-cywb-pnand.c
--- linux-2.6.37_vanilla/arch/arm/mach-omap2/usb-cywb-pnand.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.37-gpmc/arch/arm/mach-omap2/usb-cywb-pnand.c	2011-01-12 12:37:23.154716913 -0800
@@ -0,0 +1,171 @@
+/*
+ * linux /arch/arm/mach-omap2/usb-cywb-pnand.c
+ *
+ * Copyright (C) 2010  Cypress Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/usb/cywb.h>
+#include <plat/gpmc.h>
+
+/*
+ * chip select number on GPMC ( 0..7 )
+ */
+#define AST_GPMC_CS 4
+
+/*
+ * for use by gpmc_set_timings api, measured in ns, not clocks
+ */
+#define WB_GPMC_BUSCYC_T    (7 * 6)
+#define WB_GPMC_CS_T_O_N    (0)
+#define WB_GPMC_ADV_T_O_N   (0)
+#define WB_GPMC_OE_T_O_N    (0)
+#define WB_GPMC_OE_T_O_F_F  (5 * 6)
+#define WB_GPMC_WE_T_O_N    (1 * 6)
+#define WB_GPMC_WE_T_O_F_F  (5 * 6)
+#define WB_GPMC_RDS_ADJ     (2 * 6)
+#define WB_GPMC_RD_T_A_C_C  (WB_GPMC_OE_T_O_F_F + WB_GPMC_RDS_ADJ)
+#define WB_GPMC_WR_T_A_C_C  (WB_GPMC_BUSCYC_T)
+
+#define AS_CS_MASK	(0X7 << 8)
+#define AS_CS_BADDR	 0x02
+#define CSVALID_B (1 << 6)
+
+#define BLKSZ_4K 0x1000
+
+/*
+ * switch GPMC DATA bus mode
+ */
+void cywb_gpmc_enable_16bit_bus(bool dbus16_enabled)
+{
+	u32 tmp32;
+
+	/*
+	 * disable gpmc CS4 operation 1st
+	 */
+	tmp32 = gpmc_cs_read_reg(AST_GPMC_CS,
+				GPMC_CS_CONFIG7) & ~GPMC_CONFIG7_CSVALID;
+	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7, tmp32);
+
+	/*
+	 * GPMC NAND data bus can be 8 or 16 bit wide
+	 */
+	if (dbus16_enabled) {
+		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
+				(GPMC_CONFIG1_DEVICETYPE(2) |
+				GPMC_CONFIG1_WAIT_PIN_SEL(2) |
+				GPMC_CONFIG1_DEVICESIZE_16));
+	} else {
+		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
+				(GPMC_CONFIG1_DEVICETYPE(2) |
+				GPMC_CONFIG1_WAIT_PIN_SEL(2)));
+	}
+
+	/*
+	 * re-enable astoria CS operation on GPMC
+	 */
+	 gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
+			(tmp32 | GPMC_CONFIG7_CSVALID));
+}
+
+int cywb_pnand_platform_retime()
+{
+	u32 tmp32;
+	struct gpmc_timings timings;
+	int retval = 0;
+
+
+	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
+					(GPMC_CONFIG1_DEVICETYPE(2) |
+					GPMC_CONFIG1_WAIT_PIN_SEL(2)));
+
+	memset(&timings, 0, sizeof(timings));
+
+	/* cs timing */
+	timings.cs_on = WB_GPMC_CS_T_O_N;
+	timings.cs_wr_off = WB_GPMC_BUSCYC_T;
+	timings.cs_rd_off = WB_GPMC_BUSCYC_T;
+
+	/* adv timing */
+	timings.adv_on = WB_GPMC_ADV_T_O_N;
+	timings.adv_rd_off = WB_GPMC_BUSCYC_T;
+	timings.adv_wr_off = WB_GPMC_BUSCYC_T;
+
+	/* oe timing */
+	timings.oe_on = WB_GPMC_OE_T_O_N;
+	timings.oe_off = WB_GPMC_OE_T_O_F_F;
+	timings.access = WB_GPMC_RD_T_A_C_C;
+	timings.rd_cycle = WB_GPMC_BUSCYC_T;
+
+	/* we timing */
+	timings.we_on = WB_GPMC_WE_T_O_N;
+	timings.we_off = WB_GPMC_WE_T_O_F_F;
+	timings.wr_access = WB_GPMC_WR_T_A_C_C;
+	timings.wr_cycle = WB_GPMC_BUSCYC_T;
+
+	timings.page_burst_access = WB_GPMC_BUSCYC_T;
+	timings.wr_data_mux_bus = WB_GPMC_BUSCYC_T;
+	gpmc_cs_set_timings(AST_GPMC_CS, &timings);
+
+	/*
+	 * DISABLE cs4, NOTE GPMC REG7 is already configured
+	 * at this point by gpmc_cs_request
+	 */
+	tmp32 = gpmc_cs_read_reg(AST_GPMC_CS, GPMC_CS_CONFIG7) &
+					~GPMC_CONFIG7_CSVALID;
+	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7, tmp32);
+
+	/*
+	 * PROGRAM chip select Region, (see OMAP3430 TRM PAGE 1088)
+	 */
+	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
+				(AS_CS_MASK | AS_CS_BADDR));
+
+	/*
+	 * by default configure GPMC into 8 bit mode
+	 * (to match astoria default mode)
+	 */
+	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
+				(GPMC_CONFIG1_DEVICETYPE(2) |
+				GPMC_CONFIG1_WAIT_PIN_SEL(2)));
+
+	/*
+	 * ENABLE astoria cs operation on GPMC
+	 */
+	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
+					(tmp32 | GPMC_CONFIG7_CSVALID));
+
+	return retval;
+
+}
+
+static struct cywb_platform_data cywb_plat = {
+	.retime			= cywb_pnand_platform_retime,
+	.config_bus_width	= cywb_gpmc_enable_16bit_bus,
+};
+
+static struct platform_device cywb_device = {
+	.name		= "west_bridge_dev",
+	.id		= -1,
+	.dev = {
+		.platform_data		= &cywb_plat,
+	}
+};
+
+#ifdef CONFIG_WESTBRIDGE_ASTORIA
+void __init usb_cywb_init()
+{
+	if (platform_device_register(&cywb_device) < 0)
+		dev_err(&cywb_device.dev, "Unable to register cywb-astoria device\n");
+}
+#else
+void __init usb_cywb_init()
+{
+}
+#endif /* CONFIG_WESTBRIDGE_ASTORIA */
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c linux-2.6.37-gpmc/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-gpmc/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c	2011-01-11 17:57:48.766357001 -0800
@@ -298,60 +298,17 @@ static u16 omap_cfg_reg_L(u32 pad_func_i
 
 #define BLKSZ_4K 0x1000
 
-/*
- * switch GPMC DATA bus mode
- */
-void cy_as_hal_gpmc_enable_16bit_bus(bool dbus16_enabled)
-{
-	uint32_t tmp32;
-
-	/*
-	 * disable gpmc CS4 operation 1st
-	 */
-	tmp32 = gpmc_cs_read_reg(AST_GPMC_CS,
-				GPMC_CS_CONFIG7) & ~GPMC_CONFIG7_CSVALID;
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7, tmp32);
-
-	/*
-	 * GPMC NAND data bus can be 8 or 16 bit wide
-	 */
-	if (dbus16_enabled) {
-		DBGPRN("enabling 16 bit bus\n");
-		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
-				(GPMC_CONFIG1_DEVICETYPE(2) |
-				GPMC_CONFIG1_WAIT_PIN_SEL(2) |
-				GPMC_CONFIG1_DEVICESIZE_16)
-				);
-	} else {
-		DBGPRN(KERN_INFO "enabling 8 bit bus\n");
-		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
-				(GPMC_CONFIG1_DEVICETYPE(2) |
-				GPMC_CONFIG1_WAIT_PIN_SEL(2))
-				);
-	}
-
-	/*
-	 * re-enable astoria CS operation on GPMC
-	 */
-	 gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
-			(tmp32 | GPMC_CONFIG7_CSVALID));
-
-	/*
-	 *remember the state
-	 */
-	pnand_16bit = dbus16_enabled;
-}
-
-static int cy_as_hal_gpmc_init(void)
+static int cy_as_hal_gpmc_init(struct cywb_platform_data *cywb_pd)
 {
 	u32 tmp32;
 	int err;
 	struct gpmc_timings	timings;
+
 	/*
 	 * get GPMC i/o registers base(already been i/o mapped
 	 * in kernel, no need for separate i/o remap)
 	 */
-	gpmc_base = phys_to_virt(OMAP34XX_GPMC_BASE);
+	gpmc_base = (u32)ioremap_nocache(OMAP34XX_GPMC_BASE, BLKSZ_4K);
 	DBGPRN(KERN_INFO "kernel has gpmc_base=%x , val@ the base=%x",
 		gpmc_base, __raw_readl(gpmc_base)
 	);
@@ -404,68 +361,7 @@ static int cy_as_hal_gpmc_init(void)
 	cy_as_hal_print_message(KERN_INFO "ioremap(%x) returned vma=%x\n",
 							csa_phy, gpmc_data_vma);
 
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
-						(GPMC_CONFIG1_DEVICETYPE(2) |
-						GPMC_CONFIG1_WAIT_PIN_SEL(2)));
-
-	memset(&timings, 0, sizeof(timings));
-
-	/* cs timing */
-	timings.cs_on = WB_GPMC_CS_t_o_n;
-	timings.cs_wr_off = WB_GPMC_BUSCYC_t;
-	timings.cs_rd_off = WB_GPMC_BUSCYC_t;
-
-	/* adv timing */
-	timings.adv_on = WB_GPMC_ADV_t_o_n;
-	timings.adv_rd_off = WB_GPMC_BUSCYC_t;
-	timings.adv_wr_off = WB_GPMC_BUSCYC_t;
-
-	/* oe timing */
-	timings.oe_on = WB_GPMC_OE_t_o_n;
-	timings.oe_off = WB_GPMC_OE_t_o_f_f;
-	timings.access = WB_GPMC_RD_t_a_c_c;
-	timings.rd_cycle = WB_GPMC_BUSCYC_t;
-
-	/* we timing */
-	timings.we_on = WB_GPMC_WE_t_o_n;
-	timings.we_off = WB_GPMC_WE_t_o_f_f;
-	timings.wr_access = WB_GPMC_WR_t_a_c_c;
-	timings.wr_cycle = WB_GPMC_BUSCYC_t;
-
-	timings.page_burst_access = WB_GPMC_BUSCYC_t;
-	timings.wr_data_mux_bus = WB_GPMC_BUSCYC_t;
-	gpmc_cs_set_timings(AST_GPMC_CS, &timings);
-
-	cy_as_hal_print_omap_regs("GPMC_CONFIG", 1,
-			GPMC_VMA(GPMC_CFG_REG(1, AST_GPMC_CS)), 7);
-
-	/*
-	 * DISABLE cs4, NOTE GPMC REG7 is already configured
-	 * at this point by gpmc_cs_request
-	 */
-	tmp32 = gpmc_cs_read_reg(AST_GPMC_CS, GPMC_CS_CONFIG7) &
-						~GPMC_CONFIG7_CSVALID;
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7, tmp32);
-
-	/*
-	 * PROGRAM chip select Region, (see OMAP3430 TRM PAGE 1088)
-	 */
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
-					(AS_CS_MASK | AS_CS_BADDR));
-
-	/*
-	 * by default configure GPMC into 8 bit mode
-	 * (to match astoria default mode)
-	 */
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
-					(GPMC_CONFIG1_DEVICETYPE(2) |
-					GPMC_CONFIG1_WAIT_PIN_SEL(2)));
-
-	/*
-	 * ENABLE astoria cs operation on GPMC
-	 */
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
-					(tmp32 | GPMC_CONFIG7_CSVALID));
+	cywb_pd->retime();
 
 	/*
 	 * No method currently exists to write this register through GPMC APIs
@@ -749,7 +645,7 @@ EXPORT_SYMBOL(cy_as_hal_config_c_s_mux);
 /*
  * inits all omap h/w
  */
-uint32_t cy_as_hal_processor_hw_init(void)
+uint32_t cy_as_hal_processor_hw_init(struct cywb_platform_data *cywb_pd)
 {
 	int i, err;
 
@@ -789,7 +685,7 @@ uint32_t cy_as_hal_processor_hw_init(voi
 	 */
 	cy_as_hal_init_user_pads(user_pad_cfg);
 
-	err = cy_as_hal_gpmc_init();
+	err = cy_as_hal_gpmc_init(cywb_pd);
 	if (err < 0)
 		cy_as_hal_print_message(KERN_INFO"gpmc init failed:%d", err);
 
@@ -2285,7 +2181,9 @@ cy_bool cy_as_hal_sync_device_clocks(cy_
  * init OMAP h/w resources
  */
 int start_o_m_a_p_kernel(const char *pgm,
-				cy_as_hal_device_tag *tag, cy_bool debug)
+				cy_as_hal_device_tag *tag,
+				struct cywb_platform_data *cywb_pd,
+				cy_bool debug)
 {
 	cy_as_omap_dev_kernel *dev_p;
 	int i;
@@ -2333,7 +2231,7 @@ int start_o_m_a_p_kernel(const char *pgm
 	/*
 	 * initialize OMAP hardware and StartOMAPKernelall gpio pins
 	 */
-	dev_p->m_addr_base = (void *)cy_as_hal_processor_hw_init();
+	dev_p->m_addr_base = (void *)cy_as_hal_processor_hw_init(cywb_pd);
 
 	/*
 	 * Now perform a hard reset of the device to have
@@ -2361,7 +2259,6 @@ int start_o_m_a_p_kernel(const char *pgm
 	pncfg_reg = ast_p_nand_casdo_read(CY_AS_MEM_PNAND_CFG);
 
 #ifdef PNAND_16BIT_MODE
-
 	/*
 	 * switch to 16 bit mode, force NON-LNA LBD mode, 3 RA addr bytes
 	 */
@@ -2370,8 +2267,12 @@ int start_o_m_a_p_kernel(const char *pgm
 	/*
 	 * now in order to continue to talk to astoria
 	 * sw OMAP GPMC into 16 bit mode as well
+	 *
+	 * remember bus width state
+	 * pnand_16bit = cy_true  - bus width is 16-bit
 	 */
-	cy_as_hal_gpmc_enable_16bit_bus(cy_true);
+	pnand_16bit = cy_true;
+	cywb_pd->config_bus_width(pnand_16bit);
 #else
    /* Astoria and GPMC are already in 8 bit mode, jsut initialize PNAND_CFG */
 	ast_p_nand_casdi_write(CY_AS_MEM_PNAND_CFG, 0x0000);
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h linux-2.6.37-gpmc/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-gpmc/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h	2011-01-11 17:58:50.862357870 -0800
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/string.h>
+#include <linux/usb/cywb.h>
 /* include does not seem to work
  * moving for patch submission
 #include <mach/gpmc.h>
@@ -307,7 +308,9 @@ void cyashal_prn_buf(void  *buf, uint16_
  * but are required to be called for this HAL.
  */
 int start_o_m_a_p_kernel(const char *pgm,
-	cy_as_hal_device_tag *tag, cy_bool debug);
+	cy_as_hal_device_tag *tag,
+	struct cywb_platform_data *cywb_pd,
+	cy_bool debug);
 int stop_o_m_a_p_kernel(const char *pgm, cy_as_hal_device_tag tag);
 int omap_start_intr(cy_as_hal_device_tag tag);
 void cy_as_hal_set_ep_dma_mode(uint8_t ep, bool sg_xfer_enabled);
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c linux-2.6.37-gpmc/drivers/staging/westbridge/astoria/device/cyasdevice.c
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-gpmc/drivers/staging/westbridge/astoria/device/cyasdevice.c	2011-01-12 11:57:02.671217929 -0800
@@ -28,6 +28,7 @@
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/usb/cywb.h>
 
 /* moved for staging location
  * update/patch submission
@@ -57,6 +58,7 @@ static cyasdevice *cy_as_device_controll
 int cy_as_device_init_done;
 const char *dev_handle_name = "cy_astoria_dev_handle";
 
+static int cyasdevice_initialize(void);
 #ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL
 extern void cy_as_hal_config_c_s_mux(void);
 #endif
@@ -172,6 +174,10 @@ static struct platform_device *westbridg
 static int __devinit wb_probe(struct platform_device *devptr)
 {
 	cy_as_hal_print_message("%s called\n", __func__);
+	westbridge_pd = devptr;
+	if (cyasdevice_initialize() != 0)
+		return -ENODEV;
+
 	return 0;
 }
 
@@ -229,8 +235,9 @@ static int cyasdevice_initialize(void)
  /* start OMAP HAL init instsnce */
 
 	if (!start_o_m_a_p_kernel(dev_handle_name,
-		&(cy_as_dev->hal_tag), cy_false)) {
-
+		&(cy_as_dev->hal_tag),
+		westbridge_pd ? westbridge_pd->dev.platform_data : NULL,
+		cy_false)) {
 		cy_as_hal_print_message(
 			"<1>_cy_as_device: start OMAP34xx HAL failed\n");
 		goto done;
@@ -267,16 +274,6 @@ static int cyasdevice_initialize(void)
 		goto done;
 	}
 
-	ret = platform_driver_register(&west_bridge_driver);
-	if (unlikely(ret < 0))
-		return ret;
-	westbridge_pd = platform_device_register_simple(
-		"west_bridge_dev", -1, NULL, 0);
-
-	if (IS_ERR(westbridge_pd)) {
-		platform_driver_unregister(&west_bridge_driver);
-		return PTR_ERR(westbridge_pd);
-	}
 	/* Load the firmware */
 	ret = request_firmware(&fw_entry,
 		"west bridge fw", &westbridge_pd->dev);
@@ -384,17 +381,12 @@ cy_as_hal_device_tag cyasdevice_gethalta
 }
 EXPORT_SYMBOL(cyasdevice_gethaltag);
 
-
 /*init Westbridge device driver **/
 static int __init cyasdevice_init(void)
 {
-	if (cyasdevice_initialize() != 0)
-		return ENODEV;
-
-	return 0;
+	return platform_driver_register(&west_bridge_driver);
 }
 
-
 static void __exit cyasdevice_cleanup(void)
 {
 
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/include/linux/usb/cywb.h linux-2.6.37-gpmc/include/linux/usb/cywb.h
--- linux-2.6.37_vanilla/include/linux/usb/cywb.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.37-gpmc/include/linux/usb/cywb.h	2011-01-12 12:35:40.054775557 -0800
@@ -0,0 +1,21 @@
+/*
+ * data structure declaration for passing gpmc configuration
+ * functions to westbridge device controller driver.
+ * usb-cywb-pnand.c defines the configuration functions
+ */
+
+#ifndef __LINUX_USB_CYWB_H
+#define __LINUX_USB_CYWB_H
+
+
+struct cywb_platform_data {
+	/* PNAND retime function */
+	int		(*retime)(void);
+
+	/* PNAND bus width configuration */
+	void		(*config_bus_width)(bool dbus16_enabled);
+};
+
+extern void usb_cywb_init(void);
+
+#endif /* __LINUX_USB_CYWB_H */


      

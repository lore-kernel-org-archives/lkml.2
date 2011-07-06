Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1GFHdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:33:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35291 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1GFHdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:33:54 -0400
Date: Wed, 6 Jul 2011 13:19:34 +0530
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pshah.mumbai@gmail.com
Subject: [PATCH] Staging: msm: fixed style issues found by checkpatch.pl
Message-ID: <20110706074934.GA935@mail.fossee.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the msm drivers that fixes many style issues
found by the checkpatch.pl tool
- extra spaces
- invalid code indent
- extra braces
- invalid comment style

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/msm/ebi2_lcd.c             |    7 +-
 drivers/staging/msm/ebi2_tmd20.c           |  133 ++++++++++++++--------------
 drivers/staging/msm/hdmi_sii9022.c         |    2 +-
 drivers/staging/msm/lcdc.c                 |   14 ++--
 drivers/staging/msm/lcdc_gordon.c          |    2 +-
 drivers/staging/msm/lcdc_st15.c            |    2 +-
 drivers/staging/msm/lcdc_toshiba_wvga_pt.c |    2 +-
 drivers/staging/msm/mddi.c                 |    2 +-
 drivers/staging/msm/mddi_sharp.c           |    4 +-
 drivers/staging/msm/mddi_toshiba.c         |    4 +-
 drivers/staging/msm/mddihost.c             |   19 +++--
 drivers/staging/msm/mddihosti.c            |   23 +++---
 drivers/staging/msm/mdp.c                  |   26 +++---
 drivers/staging/msm/mdp4_overlay.c         |    6 +-
 drivers/staging/msm/mdp4_util.c            |   18 ++--
 drivers/staging/msm/mdp_cursor.c           |    2 +-
 drivers/staging/msm/mdp_dma.c              |    7 +-
 drivers/staging/msm/mdp_hw_init.c          |    2 +-
 drivers/staging/msm/mdp_ppp.c              |   11 +--
 drivers/staging/msm/mdp_ppp_dq.c           |   10 +-
 drivers/staging/msm/mdp_ppp_v20.c          |   69 +++++----------
 drivers/staging/msm/msm_fb.c               |   54 ++++++------
 drivers/staging/msm/staging-devices.c      |   31 ++++---
 drivers/staging/msm/tv_ntsc.c              |    2 +-
 drivers/staging/msm/tvenc.c                |   18 ++--
 25 files changed, 222 insertions(+), 248 deletions(-)

diff --git a/drivers/staging/msm/ebi2_lcd.c b/drivers/staging/msm/ebi2_lcd.c
index b41e123..604ed9f 100644
--- a/drivers/staging/msm/ebi2_lcd.c
+++ b/drivers/staging/msm/ebi2_lcd.c
@@ -208,14 +208,13 @@ static int ebi2_lcd_probe(struct platform_device *pdev)
 	 * register in mdp driver
 	 */
 	rc = platform_device_add(mdp_dev);
-	if (rc) {
+	if (rc)
 		goto ebi2_lcd_probe_err;
-	}
 
 	pdev_list[pdev_list_cnt++] = pdev;
 	return 0;
 
-      ebi2_lcd_probe_err:
+ebi2_lcd_probe_err:
 	platform_device_put(mdp_dev);
 	return rc;
 }
@@ -247,4 +246,4 @@ static int __init ebi2_lcd_driver_init(void)
 	return ebi2_lcd_register_driver();
 }
 
-module_init(ebi2_lcd_driver_init);
\ No newline at end of file
+module_init(ebi2_lcd_driver_init);
diff --git a/drivers/staging/msm/ebi2_tmd20.c b/drivers/staging/msm/ebi2_tmd20.c
index d7d667a..07083bf 100644
--- a/drivers/staging/msm/ebi2_tmd20.c
+++ b/drivers/staging/msm/ebi2_tmd20.c
@@ -38,7 +38,7 @@
 #define QVGA_HEIGHT       320
 
 #ifdef TMD20QVGA_LCD_18BPP
-#define DISP_QVGA_18BPP(x)  ((((x)<<2) & 0x3FC00)|(( (x)<<1)& 0x1FE))
+#define DISP_QVGA_18BPP(x)  ((((x)<<2) & 0x3FC00)|(((x)<<1) & 0x1FE))
 #define DISP_REG(name)  uint32 register_##name;
 #define OUTPORT(x, y)  outpdw(x, y)
 #define INPORT(x)   inpdw(x)
@@ -69,28 +69,28 @@ static void *DISP_DATA_PORT;
 #endif
 
 #define DISP_WRITE_OUT(addr, data) \
-   register_##addr = DISP_QVGA_18BPP(data); \
-   DISP_CMD_OUT(addr); \
-   DISP_DATA_OUT(register_##addr);
+	register_##addr = DISP_QVGA_18BPP(data); \
+	DISP_CMD_OUT(addr); \
+	DISP_DATA_OUT(register_##addr);
 
 #define DISP_UPDATE_VALUE(addr, bitmask, data) \
-   DISP_WRITE_OUT(##addr, (register_##addr & ~(bitmask)) | (data));
+	DISP_WRITE_OUT(##addr, (register_##addr & ~(bitmask)) | (data));
 
 #define DISP_VAL_IF(bitvalue, bitmask) \
-   ((bitvalue) ? (bitmask) : 0)
+	((bitvalue) ? (bitmask) : 0)
 
 /* QVGA = 256 x 320 */
 /* actual display is 240 x 320...offset by 0x10 */
 #define DISP_ROW_COL_TO_ADDR(row, col) ((row) * 0x100 + col)
 #define DISP_SET_RECT(ulhc_row, lrhc_row, ulhc_col, lrhc_col) \
-   { \
-   DISP_WRITE_OUT(DISP_HORZ_RAM_ADDR_POS_1_ADDR, (ulhc_col) + tmd20qvga_panel_offset); \
-   DISP_WRITE_OUT(DISP_HORZ_RAM_ADDR_POS_2_ADDR, (lrhc_col) + tmd20qvga_panel_offset); \
-   DISP_WRITE_OUT(DISP_VERT_RAM_ADDR_POS_1_ADDR, (ulhc_row)); \
-   DISP_WRITE_OUT(DISP_VERT_RAM_ADDR_POS_2_ADDR, (lrhc_row)); \
-   DISP_WRITE_OUT(DISP_RAM_ADDR_SET_1_ADDR, (ulhc_col) + tmd20qvga_panel_offset); \
-   DISP_WRITE_OUT(DISP_RAM_ADDR_SET_2_ADDR, (ulhc_row)); \
-   }
+	{ \
+	DISP_WRITE_OUT(DISP_HORZ_RAM_ADDR_POS_1_ADDR, (ulhc_col) + tmd20qvga_panel_offset); \
+	DISP_WRITE_OUT(DISP_HORZ_RAM_ADDR_POS_2_ADDR, (lrhc_col) + tmd20qvga_panel_offset); \
+	DISP_WRITE_OUT(DISP_VERT_RAM_ADDR_POS_1_ADDR, (ulhc_row)); \
+	DISP_WRITE_OUT(DISP_VERT_RAM_ADDR_POS_2_ADDR, (lrhc_row)); \
+	DISP_WRITE_OUT(DISP_RAM_ADDR_SET_1_ADDR, (ulhc_col) + tmd20qvga_panel_offset); \
+	DISP_WRITE_OUT(DISP_RAM_ADDR_SET_2_ADDR, (ulhc_row)); \
+	}
 
 #define WAIT_MSEC(msec) mdelay(msec)
 
@@ -99,118 +99,118 @@ static void *DISP_DATA_PORT;
  */
 /* Display Control */
 #define DISP_START_OSCILLATION_ADDR     0x000
-DISP_REG(DISP_START_OSCILLATION_ADDR)
+	DISP_REG(DISP_START_OSCILLATION_ADDR)
 #define DISP_DRIVER_OUTPUT_CTL_ADDR     0x001
-    DISP_REG(DISP_DRIVER_OUTPUT_CTL_ADDR)
+	DISP_REG(DISP_DRIVER_OUTPUT_CTL_ADDR)
 #define DISP_LCD_DRIVING_SIG_ADDR     0x002
-    DISP_REG(DISP_LCD_DRIVING_SIG_ADDR)
+	DISP_REG(DISP_LCD_DRIVING_SIG_ADDR)
 #define DISP_ENTRY_MODE_ADDR            0x003
-    DISP_REG(DISP_ENTRY_MODE_ADDR)
+	DISP_REG(DISP_ENTRY_MODE_ADDR)
 #define DISP_DISPLAY_CTL_1_ADDR         0x007
-    DISP_REG(DISP_DISPLAY_CTL_1_ADDR)
+	DISP_REG(DISP_DISPLAY_CTL_1_ADDR)
 #define DISP_DISPLAY_CTL_2_ADDR         0x008
-    DISP_REG(DISP_DISPLAY_CTL_2_ADDR)
+	DISP_REG(DISP_DISPLAY_CTL_2_ADDR)
 
 /* DISPLAY MODE 0x009 partial display not supported */
 #define DISP_POWER_SUPPLY_INTF_ADDR     0x00A
-    DISP_REG(DISP_POWER_SUPPLY_INTF_ADDR)
+	DISP_REG(DISP_POWER_SUPPLY_INTF_ADDR)
 
 /* DISPLAY MODE 0x00B xZoom feature is not supported */
 #define DISP_EXT_DISPLAY_CTL_1_ADDR     0x00C
-    DISP_REG(DISP_EXT_DISPLAY_CTL_1_ADDR)
+	DISP_REG(DISP_EXT_DISPLAY_CTL_1_ADDR)
 
 #define DISP_FRAME_CYCLE_CTL_ADDR       0x00D
-    DISP_REG(DISP_FRAME_CYCLE_CTL_ADDR)
+	DISP_REG(DISP_FRAME_CYCLE_CTL_ADDR)
 
 #define DISP_EXT_DISPLAY_CTL_2_ADDR     0x00E
-    DISP_REG(DISP_EXT_DISPLAY_CTL_2_ADDR)
+	DISP_REG(DISP_EXT_DISPLAY_CTL_2_ADDR)
 
 #define DISP_EXT_DISPLAY_CTL_3_ADDR     0x00F
-    DISP_REG(DISP_EXT_DISPLAY_CTL_3_ADDR)
+	DISP_REG(DISP_EXT_DISPLAY_CTL_3_ADDR)
 
 #define DISP_LTPS_CTL_1_ADDR            0x012
-    DISP_REG(DISP_LTPS_CTL_1_ADDR)
+	DISP_REG(DISP_LTPS_CTL_1_ADDR)
 #define DISP_LTPS_CTL_2_ADDR            0x013
-    DISP_REG(DISP_LTPS_CTL_2_ADDR)
+	DISP_REG(DISP_LTPS_CTL_2_ADDR)
 #define DISP_LTPS_CTL_3_ADDR            0x014
-    DISP_REG(DISP_LTPS_CTL_3_ADDR)
+	DISP_REG(DISP_LTPS_CTL_3_ADDR)
 #define DISP_LTPS_CTL_4_ADDR            0x018
-    DISP_REG(DISP_LTPS_CTL_4_ADDR)
+	DISP_REG(DISP_LTPS_CTL_4_ADDR)
 #define DISP_LTPS_CTL_5_ADDR            0x019
-    DISP_REG(DISP_LTPS_CTL_5_ADDR)
+	DISP_REG(DISP_LTPS_CTL_5_ADDR)
 #define DISP_LTPS_CTL_6_ADDR            0x01A
-    DISP_REG(DISP_LTPS_CTL_6_ADDR)
+	DISP_REG(DISP_LTPS_CTL_6_ADDR)
 #define DISP_AMP_SETTING_ADDR           0x01C
-    DISP_REG(DISP_AMP_SETTING_ADDR)
+	DISP_REG(DISP_AMP_SETTING_ADDR)
 #define DISP_MODE_SETTING_ADDR          0x01D
-    DISP_REG(DISP_MODE_SETTING_ADDR)
+	DISP_REG(DISP_MODE_SETTING_ADDR)
 #define DISP_POFF_LN_SETTING_ADDR       0x01E
-    DISP_REG(DISP_POFF_LN_SETTING_ADDR)
+	DISP_REG(DISP_POFF_LN_SETTING_ADDR)
 /* Power Contol */
 #define DISP_POWER_CTL_1_ADDR           0x100
-    DISP_REG(DISP_POWER_CTL_1_ADDR)
+	DISP_REG(DISP_POWER_CTL_1_ADDR)
 #define DISP_POWER_CTL_2_ADDR           0x101
-    DISP_REG(DISP_POWER_CTL_2_ADDR)
+	DISP_REG(DISP_POWER_CTL_2_ADDR)
 #define DISP_POWER_CTL_3_ADDR           0x102
-    DISP_REG(DISP_POWER_CTL_3_ADDR)
+	DISP_REG(DISP_POWER_CTL_3_ADDR)
 #define DISP_POWER_CTL_4_ADDR           0x103
-    DISP_REG(DISP_POWER_CTL_4_ADDR)
+	DISP_REG(DISP_POWER_CTL_4_ADDR)
 #define DISP_POWER_CTL_5_ADDR           0x104
-    DISP_REG(DISP_POWER_CTL_5_ADDR)
+	DISP_REG(DISP_POWER_CTL_5_ADDR)
 #define DISP_POWER_CTL_6_ADDR           0x105
-    DISP_REG(DISP_POWER_CTL_6_ADDR)
+	DISP_REG(DISP_POWER_CTL_6_ADDR)
 #define DISP_POWER_CTL_7_ADDR           0x106
-    DISP_REG(DISP_POWER_CTL_7_ADDR)
+	DISP_REG(DISP_POWER_CTL_7_ADDR)
 /* RAM Access */
 #define DISP_RAM_ADDR_SET_1_ADDR        0x200
-    DISP_REG(DISP_RAM_ADDR_SET_1_ADDR)
+	DISP_REG(DISP_RAM_ADDR_SET_1_ADDR)
 #define DISP_RAM_ADDR_SET_2_ADDR        0x201
-    DISP_REG(DISP_RAM_ADDR_SET_2_ADDR)
+	DISP_REG(DISP_RAM_ADDR_SET_2_ADDR)
 #define DISP_CMD_RAMRD                  DISP_CMD_RAMWR
 #define DISP_CMD_RAMWR                  0x202
-    DISP_REG(DISP_CMD_RAMWR)
+	DISP_REG(DISP_CMD_RAMWR)
 #define DISP_RAM_DATA_MASK_1_ADDR       0x203
-    DISP_REG(DISP_RAM_DATA_MASK_1_ADDR)
+	DISP_REG(DISP_RAM_DATA_MASK_1_ADDR)
 #define DISP_RAM_DATA_MASK_2_ADDR       0x204
-    DISP_REG(DISP_RAM_DATA_MASK_2_ADDR)
+	DISP_REG(DISP_RAM_DATA_MASK_2_ADDR)
 /* Gamma Control, Contrast, Gray Scale Setting */
 #define DISP_GAMMA_CONTROL_1_ADDR       0x300
-    DISP_REG(DISP_GAMMA_CONTROL_1_ADDR)
+	DISP_REG(DISP_GAMMA_CONTROL_1_ADDR)
 #define DISP_GAMMA_CONTROL_2_ADDR       0x301
-    DISP_REG(DISP_GAMMA_CONTROL_2_ADDR)
+	DISP_REG(DISP_GAMMA_CONTROL_2_ADDR)
 #define DISP_GAMMA_CONTROL_3_ADDR       0x302
-    DISP_REG(DISP_GAMMA_CONTROL_3_ADDR)
+	DISP_REG(DISP_GAMMA_CONTROL_3_ADDR)
 #define DISP_GAMMA_CONTROL_4_ADDR       0x303
-    DISP_REG(DISP_GAMMA_CONTROL_4_ADDR)
+	DISP_REG(DISP_GAMMA_CONTROL_4_ADDR)
 #define DISP_GAMMA_CONTROL_5_ADDR       0x304
-    DISP_REG(DISP_GAMMA_CONTROL_5_ADDR)
+	DISP_REG(DISP_GAMMA_CONTROL_5_ADDR)
 /* Coordinate Control */
 #define DISP_VERT_SCROLL_CTL_1_ADDR     0x400
-    DISP_REG(DISP_VERT_SCROLL_CTL_1_ADDR)
+	DISP_REG(DISP_VERT_SCROLL_CTL_1_ADDR)
 #define DISP_VERT_SCROLL_CTL_2_ADDR     0x401
-    DISP_REG(DISP_VERT_SCROLL_CTL_2_ADDR)
+	DISP_REG(DISP_VERT_SCROLL_CTL_2_ADDR)
 #define DISP_SCREEN_1_DRV_POS_1_ADDR    0x402
-    DISP_REG(DISP_SCREEN_1_DRV_POS_1_ADDR)
+	DISP_REG(DISP_SCREEN_1_DRV_POS_1_ADDR)
 #define DISP_SCREEN_1_DRV_POS_2_ADDR    0x403
-    DISP_REG(DISP_SCREEN_1_DRV_POS_2_ADDR)
+	DISP_REG(DISP_SCREEN_1_DRV_POS_2_ADDR)
 #define DISP_SCREEN_2_DRV_POS_1_ADDR    0x404
-    DISP_REG(DISP_SCREEN_2_DRV_POS_1_ADDR)
+	DISP_REG(DISP_SCREEN_2_DRV_POS_1_ADDR)
 #define DISP_SCREEN_2_DRV_POS_2_ADDR    0x405
-    DISP_REG(DISP_SCREEN_2_DRV_POS_2_ADDR)
+	DISP_REG(DISP_SCREEN_2_DRV_POS_2_ADDR)
 #define DISP_HORZ_RAM_ADDR_POS_1_ADDR   0x406
-    DISP_REG(DISP_HORZ_RAM_ADDR_POS_1_ADDR)
+	DISP_REG(DISP_HORZ_RAM_ADDR_POS_1_ADDR)
 #define DISP_HORZ_RAM_ADDR_POS_2_ADDR   0x407
-    DISP_REG(DISP_HORZ_RAM_ADDR_POS_2_ADDR)
+	DISP_REG(DISP_HORZ_RAM_ADDR_POS_2_ADDR)
 #define DISP_VERT_RAM_ADDR_POS_1_ADDR   0x408
-    DISP_REG(DISP_VERT_RAM_ADDR_POS_1_ADDR)
+	DISP_REG(DISP_VERT_RAM_ADDR_POS_1_ADDR)
 #define DISP_VERT_RAM_ADDR_POS_2_ADDR   0x409
-    DISP_REG(DISP_VERT_RAM_ADDR_POS_2_ADDR)
+	DISP_REG(DISP_VERT_RAM_ADDR_POS_2_ADDR)
 #define DISP_TMD_700_ADDR               0x700	/*  0x700 */
-    DISP_REG(DISP_TMD_700_ADDR)
+	DISP_REG(DISP_TMD_700_ADDR)
 #define DISP_TMD_015_ADDR               0x015	/*  0x700 */
-    DISP_REG(DISP_TMD_015_ADDR)
+	DISP_REG(DISP_TMD_015_ADDR)
 #define DISP_TMD_305_ADDR               0x305	/*  0x700 */
-    DISP_REG(DISP_TMD_305_ADDR)
+	DISP_REG(DISP_TMD_305_ADDR)
 
 /*
  * TMD QVGA Bit Definations
@@ -1044,8 +1044,9 @@ static void tmd20qvga_disp_set_contrast(void)
 
 }	/* End disp_set_contrast */
 
-void tmd20qvga_disp_clear_screen_area
-    (word start_row, word end_row, word start_column, word end_column) {
+void tmd20qvga_disp_clear_screen_area(word start_row, word end_row,
+				      word start_column, word end_column)
+{
 	int32 i;
 
 	/* Clear the display screen */
diff --git a/drivers/staging/msm/hdmi_sii9022.c b/drivers/staging/msm/hdmi_sii9022.c
index 6b82b56..c76a3e1 100644
--- a/drivers/staging/msm/hdmi_sii9022.c
+++ b/drivers/staging/msm/hdmi_sii9022.c
@@ -22,7 +22,7 @@
 #define DEVICE_NAME "sii9022"
 #define SII9022_DEVICE_ID   0xB0
 
-struct sii9022_i2c_addr_data{
+struct sii9022_i2c_addr_data {
 	u8 addr;
 	u8 data;
 };
diff --git a/drivers/staging/msm/lcdc.c b/drivers/staging/msm/lcdc.c
index 8183394..5db5a9c 100644
--- a/drivers/staging/msm/lcdc.c
+++ b/drivers/staging/msm/lcdc.c
@@ -79,8 +79,8 @@ static int lcdc_off(struct platform_device *pdev)
 	if (lcdc_pdata && lcdc_pdata->lcdc_gpio_config)
 		ret = lcdc_pdata->lcdc_gpio_config(0);
 
-//	pm_qos_update_requirement(PM_QOS_SYSTEM_BUS_FREQ , "lcdc",
-//					PM_QOS_DEFAULT_VALUE);
+	/* pm_qos_update_requirement(PM_QOS_SYSTEM_BUS_FREQ , "lcdc",
+					PM_QOS_DEFAULT_VALUE); */
 
 	return ret;
 }
@@ -100,8 +100,8 @@ static int lcdc_on(struct platform_device *pdev)
 	else
 		pm_qos_freq = 58000;
 
-//	pm_qos_update_requirement(PM_QOS_SYSTEM_BUS_FREQ , "lcdc",
-//						pm_qos_freq);
+	/* pm_qos_update_requirement(PM_QOS_SYSTEM_BUS_FREQ , "lcdc",
+						pm_qos_freq); */
 	mfd = platform_get_drvdata(pdev);
 
 	clk_enable(mdp_lcdc_pclk_clk);
@@ -210,7 +210,7 @@ lcdc_probe_err:
 
 static int lcdc_remove(struct platform_device *pdev)
 {
-//	pm_qos_remove_requirement(PM_QOS_SYSTEM_BUS_FREQ , "lcdc");
+	/* pm_qos_remove_requirement(PM_QOS_SYSTEM_BUS_FREQ , "lcdc"); */
 	return 0;
 }
 
@@ -231,8 +231,8 @@ static int __init lcdc_driver_init(void)
 		printk(KERN_ERR "error: can't get mdp_lcdc_pad_pclk_clk!\n");
 		return PTR_ERR(mdp_lcdc_pad_pclk_clk);
 	}
-//	pm_qos_add_requirement(PM_QOS_SYSTEM_BUS_FREQ , "lcdc",
-//				PM_QOS_DEFAULT_VALUE);
+	/* pm_qos_add_requirement(PM_QOS_SYSTEM_BUS_FREQ , "lcdc",
+				PM_QOS_DEFAULT_VALUE); */
 	return lcdc_register_driver();
 }
 
diff --git a/drivers/staging/msm/lcdc_gordon.c b/drivers/staging/msm/lcdc_gordon.c
index 399ec8c..0c122c3 100644
--- a/drivers/staging/msm/lcdc_gordon.c
+++ b/drivers/staging/msm/lcdc_gordon.c
@@ -98,7 +98,7 @@ static unsigned char bit_shift[8] = { (1 << 7),	/* MSB */
 	(1 << 0)		               /* LSB */
 };
 
-struct gordon_state_type{
+struct gordon_state_type {
 	boolean disp_initialized;
 	boolean display_on;
 	boolean disp_powered_up;
diff --git a/drivers/staging/msm/lcdc_st15.c b/drivers/staging/msm/lcdc_st15.c
index fed8278..cce7e08 100644
--- a/drivers/staging/msm/lcdc_st15.c
+++ b/drivers/staging/msm/lcdc_st15.c
@@ -22,7 +22,7 @@
 #define DEVICE_NAME "sii9022"
 #define SII9022_DEVICE_ID   0xB0
 
-struct sii9022_i2c_addr_data{
+struct sii9022_i2c_addr_data {
 	u8 addr;
 	u8 data;
 };
diff --git a/drivers/staging/msm/lcdc_toshiba_wvga_pt.c b/drivers/staging/msm/lcdc_toshiba_wvga_pt.c
index edba78a..6bbbec0 100644
--- a/drivers/staging/msm/lcdc_toshiba_wvga_pt.c
+++ b/drivers/staging/msm/lcdc_toshiba_wvga_pt.c
@@ -30,7 +30,7 @@ static int spi_sclk;
 static int spi_mosi;
 static int spi_miso;
 
-struct toshiba_state_type{
+struct toshiba_state_type {
 	boolean disp_initialized;
 	boolean display_on;
 	boolean disp_powered_up;
diff --git a/drivers/staging/msm/mddi.c b/drivers/staging/msm/mddi.c
index 132eb1a..049d603 100644
--- a/drivers/staging/msm/mddi.c
+++ b/drivers/staging/msm/mddi.c
@@ -344,7 +344,7 @@ static int __init mddi_driver_init(void)
 
 	mddi_clk = clk_get(NULL, "mddi_clk");
 	if (IS_ERR(mddi_clk)) {
-		printk(KERN_ERR "can't find mddi_clk \n");
+		printk(KERN_ERR "can't find mddi_clk\n");
 		return PTR_ERR(mddi_clk);
 	}
 	clk_enable(mddi_clk);
diff --git a/drivers/staging/msm/mddi_sharp.c b/drivers/staging/msm/mddi_sharp.c
index 1da1be4..0b6e517 100644
--- a/drivers/staging/msm/mddi_sharp.c
+++ b/drivers/staging/msm/mddi_sharp.c
@@ -667,9 +667,9 @@ void mddi_sharp_lcd_vsync_detected(boolean detected)
 		mddi_vsync_detect_enabled = FALSE;
 		mddi_sharp_vsync_attempts = 0;
 		/* need to clear this vsync wakeup */
-		if (!mddi_queue_register_write_int(REG_INTR, 0x0000)) {
+		if (!mddi_queue_register_write_int(REG_INTR, 0x0000))
 			MDDI_MSG_ERR("Vsync interrupt clear failed!\n");
-		}
+
 		if (!detected) {
 			/* give up after 5 failed attempts but show error */
 			MDDI_MSG_NOTICE("Vsync detection failed!\n");
diff --git a/drivers/staging/msm/mddi_toshiba.c b/drivers/staging/msm/mddi_toshiba.c
index e96342d..2b801d7 100644
--- a/drivers/staging/msm/mddi_toshiba.c
+++ b/drivers/staging/msm/mddi_toshiba.c
@@ -1668,8 +1668,8 @@ static struct platform_driver this_driver = {
 };
 
 static struct msm_fb_panel_data toshiba_panel_data = {
-	.on 		= mddi_toshiba_lcd_on,
-	.off 		= mddi_toshiba_lcd_off,
+	.on	= mddi_toshiba_lcd_on,
+	.off	= mddi_toshiba_lcd_off,
 };
 
 static int ch_used[3];
diff --git a/drivers/staging/msm/mddihost.c b/drivers/staging/msm/mddihost.c
index 58a86d5..4bd747e 100644
--- a/drivers/staging/msm/mddihost.c
+++ b/drivers/staging/msm/mddihost.c
@@ -79,7 +79,8 @@ void mddi_init(void)
 }
 
 int mddi_host_register_read(uint32 reg_addr,
-     uint32 *reg_value_ptr, boolean wait, mddi_host_type host) {
+	uint32 *reg_value_ptr, boolean wait, mddi_host_type host)
+{
 	mddi_linked_list_type *curr_llist_ptr;
 	mddi_register_access_packet_type *regacc_pkt_ptr;
 	uint16 curr_llist_idx;
@@ -153,8 +154,9 @@ int mddi_host_register_read(uint32 reg_addr,
 }				/* mddi_host_register_read */
 
 int mddi_host_register_write(uint32 reg_addr,
-     uint32 reg_val, enum mddi_data_packet_size_type packet_size,
-     boolean wait, mddi_llist_done_cb_type done_cb, mddi_host_type host) {
+	uint32 reg_val, enum mddi_data_packet_size_type packet_size,
+	boolean wait, mddi_llist_done_cb_type done_cb, mddi_host_type host)
+{
 	mddi_linked_list_type *curr_llist_ptr;
 	mddi_linked_list_type *curr_llist_dma_ptr;
 	mddi_register_access_packet_type *regacc_pkt_ptr;
@@ -227,8 +229,9 @@ int mddi_host_register_write(uint32 reg_addr,
 	return ret;
 }				/* mddi_host_register_write */
 
-boolean mddi_host_register_read_int
-    (uint32 reg_addr, uint32 *reg_value_ptr, mddi_host_type host) {
+boolean mddi_host_register_read_int(uint32 reg_addr,
+	uint32 *reg_value_ptr, mddi_host_type host)
+{
 	mddi_linked_list_type *curr_llist_ptr;
 	mddi_register_access_packet_type *regacc_pkt_ptr;
 	uint16 curr_llist_idx;
@@ -279,9 +282,9 @@ boolean mddi_host_register_read_int
 
 }				/* mddi_host_register_read */
 
-boolean mddi_host_register_write_int
-    (uint32 reg_addr,
-     uint32 reg_val, mddi_llist_done_cb_type done_cb, mddi_host_type host) {
+boolean mddi_host_register_write_int(uint32 reg_addr,
+	uint32 reg_val, mddi_llist_done_cb_type done_cb, mddi_host_type host)
+{
 	mddi_linked_list_type *curr_llist_ptr;
 	mddi_linked_list_type *curr_llist_dma_ptr;
 	mddi_register_access_packet_type *regacc_pkt_ptr;
diff --git a/drivers/staging/msm/mddihosti.c b/drivers/staging/msm/mddihosti.c
index f9d6e91..5165a62 100644
--- a/drivers/staging/msm/mddihosti.c
+++ b/drivers/staging/msm/mddihosti.c
@@ -89,8 +89,10 @@ typedef struct {
 	mddi_rev_handler_type handler;	/* ISR to be executed */
 	uint16 pkt_type;
 } mddi_rev_pkt_handler_type;
-static mddi_rev_pkt_handler_type mddi_rev_pkt_handler[MAX_MDDI_REV_HANDLERS] =
-    { {NULL, INVALID_PKT_TYPE}, {NULL, INVALID_PKT_TYPE} };
+
+static mddi_rev_pkt_handler_type mddi_rev_pkt_handler[MAX_MDDI_REV_HANDLERS] = {
+	{NULL, INVALID_PKT_TYPE}, {NULL, INVALID_PKT_TYPE}
+};
 
 static boolean mddi_rev_encap_user_request = FALSE;
 static mddi_linked_list_notify_type mddi_rev_user;
@@ -415,15 +417,13 @@ static void mddi_report_state_change(uint32 int_reg)
 #endif
 
 		/* vote on sleep */
-		if (pmhctl->link_state == MDDI_LINK_HIBERNATING) {
+		if (pmhctl->link_state == MDDI_LINK_HIBERNATING)
 			mddi_vote_to_sleep(host_idx, TRUE);
-		}
 
 #ifdef DEBUG_MDDIHOSTI
 		/* need to stop polling timer */
-		if (mddi_gpio.polling_enabled) {
+		if (mddi_gpio.polling_enabled)
 			(void) timer_clr(&mddi_gpio_poll_timer, T_NONE);
-		}
 #endif
 	}
 }
@@ -954,7 +954,7 @@ static void mddi_process_rev_packets(void)
 		case 146:	/* register access packet */
 			{
 				mddi_register_access_packet_type
-				    * regacc_pkt_ptr;
+				    *regacc_pkt_ptr;
 
 				regacc_pkt_ptr =
 				    (mddi_register_access_packet_type *)
@@ -1860,9 +1860,8 @@ void mddi_host_powerdown(mddi_host_type host_idx)
 		return;
 	}
 
-	if (pmhctl->driver_state == MDDI_DRIVER_RESET) {
+	if (pmhctl->driver_state == MDDI_DRIVER_RESET)
 		return;
-	}
 
 	if (host_idx == MDDI_HOST_PRIM) {
 		/* disable timer */
@@ -2118,9 +2117,9 @@ void mddi_queue_reverse_encapsulation(boolean wait)
 	}
 	spin_unlock_irqrestore(&mddi_host_spin_lock, flags);
 
-	if (error) {
+	if (error)
 		MDDI_MSG_ERR("Reverse Encap request already in progress\n");
-	} else if (wait)
+	else if (wait)
 		wait_for_completion_killable(&(mddi_rev_user.done_comp));
 #endif
 }
@@ -2132,7 +2131,7 @@ boolean mddi_set_rev_handler(mddi_rev_handler_type handler, uint16 pkt_type)
 	MDDI_MSG_CRIT("No reverse link available\n");
 	(void)handler;
 	(void)pkt_type;
-	return (FALSE);
+	return FALSE;
 #else
 	unsigned long flags;
 	uint16 hdlr;
diff --git a/drivers/staging/msm/mdp.c b/drivers/staging/msm/mdp.c
index 58cb404..66c2fc7 100644
--- a/drivers/staging/msm/mdp.c
+++ b/drivers/staging/msm/mdp.c
@@ -441,8 +441,8 @@ void mdp_pipe_ctrl(MDP_BLOCK_TYPE block, MDP_BLOCK_POWER_STATE state,
 			* other blocks
 			*/
 			if (block != MDP_MASTER_BLOCK) {
-				MSM_FB_INFO("mdp_block_power_cnt[block=%d] \
-				multiple power-off request\n", block);
+				MSM_FB_INFO("mdp_block_power_cnt[block=%d] "
+				"multiple power-off request\n", block);
 			}
 			mdp_block_power_cnt[block] = 0;
 		}
@@ -578,9 +578,9 @@ irqreturn_t mdp_isr(int irq, void *ptr)
 		}
 
 		/* LCDC UnderFlow */
-		if (mdp_interrupt & LCDC_UNDERFLOW) {
+		if (mdp_interrupt & LCDC_UNDERFLOW)
 			mdp_lcdc_underflow_cnt++;
-		}
+
 		/* LCDC Frame Start */
 		if (mdp_interrupt & LCDC_FRAME_START) {
 			/* let's disable LCDC interrupt */
@@ -652,9 +652,8 @@ static void mdp_drv_init(void)
 {
 	int i;
 
-	for (i = 0; i < MDP_MAX_BLOCK; i++) {
+	for (i = 0; i < MDP_MAX_BLOCK; i++)
 		mdp_debug[i] = 0;
-	}
 
 	/* initialize spin lock and workqueue */
 	spin_lock_init(&mdp_spin_lock);
@@ -697,9 +696,8 @@ static void mdp_drv_init(void)
 #endif
 
 	/* initializing mdp power block counter to 0 */
-	for (i = 0; i < MDP_MAX_BLOCK; i++) {
+	for (i = 0; i < MDP_MAX_BLOCK; i++)
 		mdp_block_power_cnt[i] = 0;
-	}
 
 #ifdef MSM_FB_ENABLE_DBGFS
 	{
@@ -871,9 +869,9 @@ static int mdp_probe(struct platform_device *pdev)
 		if (unlikely(!msm_mdp_base))
 			return -ENOMEM;
 
-		printk("irq clk setup\n");
+		printk(KERN_INFO "irq clk setup\n");
 		rc = mdp_irq_clk_setup();
-		printk("irq clk setup done\n");
+		printk(KERN_INFO "irq clk setup done\n");
 		if (rc)
 			return rc;
 
@@ -1031,14 +1029,13 @@ static int mdp_probe(struct platform_device *pdev)
 	platform_set_drvdata(msm_fb_dev, mfd);
 
 	rc = platform_device_add(msm_fb_dev);
-	if (rc) {
+	if (rc)
 		goto mdp_probe_err;
-	}
 
 	pdev_list[pdev_list_cnt++] = pdev;
 	return 0;
 
-      mdp_probe_err:
+mdp_probe_err:
 	platform_device_put(msm_fb_dev);
 	return rc;
 }
@@ -1052,7 +1049,8 @@ static void mdp_suspend_sub(void)
 	flush_workqueue(mdp_pipe_ctrl_wq);
 
 	/* let's wait for PPP completion */
-	while (mdp_block_power_cnt[MDP_PPP_BLOCK] > 0) ;
+	while (mdp_block_power_cnt[MDP_PPP_BLOCK] > 0)
+		;
 
 	/* try to power down */
 	mdp_pipe_ctrl(MDP_MASTER_BLOCK, MDP_BLOCK_POWER_OFF, FALSE);
diff --git a/drivers/staging/msm/mdp4_overlay.c b/drivers/staging/msm/mdp4_overlay.c
index b9acf52..837693b 100644
--- a/drivers/staging/msm/mdp4_overlay.c
+++ b/drivers/staging/msm/mdp4_overlay.c
@@ -730,7 +730,7 @@ void mdp4_mixer_blend_setup(struct mdp4_overlay_pipe *pipe)
 	uint32 c0, c1, c2, blend_op;
 	int off;
 
-	if (pipe->mixer_num) 	/* mixer number, /dev/fb0, /dev/fb1 */
+	if (pipe->mixer_num)	/* mixer number, /dev/fb0, /dev/fb1 */
 		overlay_base = MDP_BASE + MDP4_OVERLAYPROC1_BASE;/* 0x18000 */
 	else
 		overlay_base = MDP_BASE + MDP4_OVERLAYPROC0_BASE;/* 0x10000 */
@@ -739,7 +739,7 @@ void mdp4_mixer_blend_setup(struct mdp4_overlay_pipe *pipe)
 	off = 0x20 * (pipe->mixer_stage - MDP4_MIXER_STAGE0);
 
 	blend_op = 0;
-	if (pipe->alpha_enable) 	/* ARGB */
+	if (pipe->alpha_enable)	/* ARGB */
 		blend_op = MDP4_BLEND_FG_ALPHA_FG_PIXEL |
 				MDP4_BLEND_BG_ALPHA_FG_PIXEL;
 	else
@@ -747,7 +747,7 @@ void mdp4_mixer_blend_setup(struct mdp4_overlay_pipe *pipe)
 				MDP4_BLEND_FG_ALPHA_FG_CONST);
 
 
-	if (pipe->alpha_enable == 0) { 	/* not ARGB */
+	if (pipe->alpha_enable == 0) {	/* not ARGB */
 		if (pipe->is_fg) {
 			outpdw(overlay_base + off + 0x108, pipe->alpha);
 			outpdw(overlay_base + off + 0x10c, 0xff - pipe->alpha);
diff --git a/drivers/staging/msm/mdp4_util.c b/drivers/staging/msm/mdp4_util.c
index fd97f52..fa84df3 100644
--- a/drivers/staging/msm/mdp4_util.c
+++ b/drivers/staging/msm/mdp4_util.c
@@ -95,7 +95,7 @@ void mdp4_display_intf_sel(int output, ulong intf)
 
 	outpdw(MDP_BASE + 0x0038, bits);	/* MDP_DISP_INTF_SEL */
 
-  MSM_FB_INFO("mdp4_display_intf_sel: 0x%x\n", (int)inpdw(MDP_BASE + 0x0038));
+	MSM_FB_INFO("mdp4_display_intf_sel: 0x%x\n", (int)inpdw(MDP_BASE + 0x0038));
 }
 
 unsigned long mdp4_display_status(void)
@@ -118,7 +118,7 @@ void mdp4_ebi2_lcd_setup(int lcd, ulong base, int ystride)
 
 void mdp4_mddi_setup(int mddi, unsigned long id)
 {
-	ulong 	bits;
+	ulong bits;
 
 	if (mddi == MDDI_EXTERNAL_SET)
 		bits = 0x02;
@@ -926,7 +926,7 @@ void mdp4_mixer_blend_init(mixer_num)
 	unsigned char *overlay_base;
 	int off;
 
-	if (mixer_num) 	/* mixer number, /dev/fb0, /dev/fb1 */
+	if (mixer_num)	/* mixer number, /dev/fb0, /dev/fb1 */
 		overlay_base = MDP_BASE + MDP4_OVERLAYPROC1_BASE;/* 0x18000 */
 	else
 		overlay_base = MDP_BASE + MDP4_OVERLAYPROC0_BASE;/* 0x10000 */
@@ -961,11 +961,11 @@ static uint32 csc_post_bv_tab[3] = {0, 0, 0 };
 static  uint32 csc_pre_lv_tab[6] =  {0, 0xff, 0, 0xff, 0, 0xff };
 static  uint32 csc_post_lv_tab[6] = {0, 0xff, 0, 0xff, 0, 0xff };
 
-#define MDP4_CSC_MV_OFF 	0x4400
-#define MDP4_CSC_PRE_BV_OFF 	0x4500
-#define MDP4_CSC_POST_BV_OFF 	0x4580
-#define MDP4_CSC_PRE_LV_OFF 	0x4600
-#define MDP4_CSC_POST_LV_OFF 	0x4680
+#define MDP4_CSC_MV_OFF		0x4400
+#define MDP4_CSC_PRE_BV_OFF	0x4500
+#define MDP4_CSC_POST_BV_OFF	0x4580
+#define MDP4_CSC_PRE_LV_OFF	0x4600
+#define MDP4_CSC_POST_LV_OFF	0x4680
 
 void mdp4_vg_csc_mv_setup(int vp_num)
 {
@@ -1561,7 +1561,7 @@ void mdp4_mixer_gc_lut_setup(int mixer_num)
 	char val;
 	int i, off;
 
-	if (mixer_num) 	/* mixer number, /dev/fb0, /dev/fb1 */
+	if (mixer_num)	/* mixer number, /dev/fb0, /dev/fb1 */
 		base = MDP_BASE + MDP4_OVERLAYPROC1_BASE;/* 0x18000 */
 	else
 		base = MDP_BASE + MDP4_OVERLAYPROC0_BASE;/* 0x10000 */
diff --git a/drivers/staging/msm/mdp_cursor.c b/drivers/staging/msm/mdp_cursor.c
index 7d28f30..af09b9a 100644
--- a/drivers/staging/msm/mdp_cursor.c
+++ b/drivers/staging/msm/mdp_cursor.c
@@ -76,7 +76,7 @@ int mdp_hw_cursor_update(struct fb_info *info, struct fb_cursor *cursor)
 		MDP_OUTP(MDP_BASE + 0x90048, mfd->cursor_buf_phys);
 		/* order the writes the cursor_buf before updating the
 		 * hardware */
-//		dma_coherent_pre_ops();
+		/* dma_coherent_pre_ops(); */
 		MDP_OUTP(MDP_BASE + 0x90060,
 			 (transp_en << 3) | (calpha_en << 1) |
 			 (inp32(MDP_BASE + 0x90060) & 0x1));
diff --git a/drivers/staging/msm/mdp_dma.c b/drivers/staging/msm/mdp_dma.c
index 639918b..e5c0dd7 100644
--- a/drivers/staging/msm/mdp_dma.c
+++ b/drivers/staging/msm/mdp_dma.c
@@ -520,9 +520,8 @@ void mdp_dma_pan_update(struct fb_info *info)
 	if (mfd->sw_currently_refreshing) {
 		/* we need to wait for the pending update */
 		mfd->pan_waiting = TRUE;
-		if (!mfd->ibuf_flushed) {
+		if (!mfd->ibuf_flushed)
 			wait_for_completion_killable(&mfd->pan_comp);
-		}
 		/* waiting for this update to complete */
 		mfd->pan_waiting = TRUE;
 		wait_for_completion_killable(&mfd->pan_comp);
@@ -550,8 +549,8 @@ void mdp_refresh_screen(unsigned long data)
 
 		if (!mfd->dma->busy) {
 			if (!queue_work(mdp_dma_wq, &mfd->dma_update_worker)) {
-				MSM_FB_DEBUG("mdp_dma: can't queue_work! -> \
-			MDP/MDDI/LCD clock speed needs to be increased\n");
+				MSM_FB_DEBUG("mdp_dma: can't queue_work! -> "
+			"MDP/MDDI/LCD clock speed needs to be increased\n");
 			}
 		}
 	} else {
diff --git a/drivers/staging/msm/mdp_hw_init.c b/drivers/staging/msm/mdp_hw_init.c
index 807362a..4fa677d 100644
--- a/drivers/staging/msm/mdp_hw_init.c
+++ b/drivers/staging/msm/mdp_hw_init.c
@@ -717,4 +717,4 @@ void mdp_hw_init(void)
 
 	/* MDP cmd block disable */
 	mdp_pipe_ctrl(MDP_CMD_BLOCK, MDP_BLOCK_POWER_OFF, FALSE);
-}
\ No newline at end of file
+}
diff --git a/drivers/staging/msm/mdp_ppp.c b/drivers/staging/msm/mdp_ppp.c
index 01b372f..2278b0a 100644
--- a/drivers/staging/msm/mdp_ppp.c
+++ b/drivers/staging/msm/mdp_ppp.c
@@ -1023,15 +1023,12 @@ struct mdp_blit_req *req, struct file *p_src_file, struct file *p_dst_file)
 	if (iBuf->mdpImg.mdpOp & MDPOP_ROTATION) {
 		ppp_operation_reg |= PPP_OP_ROT_ON;
 
-		if (iBuf->mdpImg.mdpOp & MDPOP_ROT90) {
+		if (iBuf->mdpImg.mdpOp & MDPOP_ROT90)
 			ppp_operation_reg |= PPP_OP_ROT_90;
-		}
-		if (iBuf->mdpImg.mdpOp & MDPOP_LR) {
+		if (iBuf->mdpImg.mdpOp & MDPOP_LR)
 			ppp_operation_reg |= PPP_OP_FLIP_LR;
-		}
-		if (iBuf->mdpImg.mdpOp & MDPOP_UD) {
+		if (iBuf->mdpImg.mdpOp & MDPOP_UD)
 			ppp_operation_reg |= PPP_OP_FLIP_UD;
-		}
 	}
 
 	src0_ystride = src_width * inpBpp;
@@ -1218,7 +1215,7 @@ static int mdp_ppp_verify_req(struct mdp_blit_req *req)
 int get_gem_img(struct mdp_img *img, unsigned long *start, unsigned long *len)
 {
 	panic("waaaaaaaah");
-	//return kgsl_gem_obj_addr(img->memory_id, (int)img->priv, start, len);
+	/* return kgsl_gem_obj_addr(img->memory_id, (int)img->priv, start, len); */
 }
 
 int get_img(struct mdp_img *img, struct fb_info *info, unsigned long *start,
diff --git a/drivers/staging/msm/mdp_ppp_dq.c b/drivers/staging/msm/mdp_ppp_dq.c
index 3a687c7..4671a64 100644
--- a/drivers/staging/msm/mdp_ppp_dq.c
+++ b/drivers/staging/msm/mdp_ppp_dq.c
@@ -111,7 +111,7 @@ static void mdp_ppp_djob_cleaner(struct work_struct *work)
 {
 	struct mdp_ppp_djob *job;
 
-	MDP_PPP_DEBUG_MSG("mdp ppp display job cleaner started \n");
+	MDP_PPP_DEBUG_MSG("mdp ppp display job cleaner started\n");
 
 	/* cleanup display job */
 	job = container_of(work, struct mdp_ppp_djob, cleaner.work);
@@ -188,7 +188,7 @@ static void mdp_ppp_flush_dirty_djobs(void *cond)
 			break;
 		}
 
-		MDP_PPP_DEBUG_MSG("flushing djobs ... loop \n");
+		MDP_PPP_DEBUG_MSG("flushing djobs ... loop\n");
 
 		/* Retrieve the job that needs to be cleaned */
 		job = list_entry(mdp_ppp_djob_clnrq.next,
@@ -225,7 +225,7 @@ void mdp_ppp_wait(void)
 		spin_unlock_irqrestore(&mdp_ppp_dq_lock, flags);
 
 		/* block uninterruptibly until available */
-		MDP_PPP_DEBUG_MSG("waiting for mdp... \n");
+		MDP_PPP_DEBUG_MSG("waiting for mdp...\n");
 		wait_for_completion_killable(&mdp_ppp_comp);
 
 		/* if MDP PPP engine is still free,
@@ -251,14 +251,14 @@ static void mdp_ppp_process_roi(struct list_head *roi_cmd_list)
 	list_for_each_entry(node, roi_cmd_list, node) {
 		int i = 0;
 		for (; i < node->ncmds; i++) {
-			MDP_PPP_DEBUG_MSG("%d: reg: 0x%x val: 0x%x \n",
+			MDP_PPP_DEBUG_MSG("%d: reg: 0x%x val: 0x%x\n",
 					i, node->cmd[i].reg, node->cmd[i].val);
 			outpdw(node->cmd[i].reg, node->cmd[i].val);
 		}
 	}
 
 	/* kickoff MDP PPP engine */
-	MDP_PPP_DEBUG_MSG("kicking off mdp \n");
+	MDP_PPP_DEBUG_MSG("kicking off mdp\n");
 	outpdw(MDP_BASE + 0x30, 0x1000);
 }
 
diff --git a/drivers/staging/msm/mdp_ppp_v20.c b/drivers/staging/msm/mdp_ppp_v20.c
index 3bc02a1..62c93bd 100644
--- a/drivers/staging/msm/mdp_ppp_v20.c
+++ b/drivers/staging/msm/mdp_ppp_v20.c
@@ -1809,9 +1809,8 @@ static int mdp_get_edge_cond(MDPIBUF *iBuf, uint32 *dup, uint32 *dup2)
 		 * left, so reg 101b8 should be 0x0209. For 420 offsite,
 		 * 1 chroma replicated all sides.
 		 */
-		if (iBuf->roi.lcd_y == 0) {
+		if (iBuf->roi.lcd_y == 0)
 			reg |= BIT(MDP_TOP_CHROMA);
-		}
 
 		if ((iBuf->roi.lcd_y + iBuf->roi.dst_height) ==
 		    iBuf->ibuf_height) {
@@ -2249,15 +2248,13 @@ void mdp_set_scale(MDPIBUF *iBuf,
 					if ((use_pr)
 					    && (mdp_curr_down_scale_x !=
 						MDP_PR_SCALE_POINT8_1)) {
-						mdp_load_pr_downscale_table_x_point8TO1
-						    ();
+						mdp_load_pr_downscale_table_x_point8TO1();
 						mdp_curr_down_scale_x =
 						    MDP_PR_SCALE_POINT8_1;
 					} else if ((!use_pr)
 						   && (mdp_curr_down_scale_x !=
 						       MDP_BC_SCALE_POINT8_1)) {
-						mdp_load_bc_downscale_table_x_point8TO1
-						    ();
+						mdp_load_bc_downscale_table_x_point8TO1();
 						mdp_curr_down_scale_x =
 						    MDP_BC_SCALE_POINT8_1;
 					}
@@ -2267,16 +2264,13 @@ void mdp_set_scale(MDPIBUF *iBuf,
 					if ((use_pr)
 					    && (mdp_curr_down_scale_x !=
 						MDP_PR_SCALE_POINT6_POINT8)) {
-						mdp_load_pr_downscale_table_x_point6TOpoint8
-						    ();
+						mdp_load_pr_downscale_table_x_point6TOpoint8();
 						mdp_curr_down_scale_x =
 						    MDP_PR_SCALE_POINT6_POINT8;
 					} else if ((!use_pr)
 						   && (mdp_curr_down_scale_x !=
-						       MDP_BC_SCALE_POINT6_POINT8))
-					{
-						mdp_load_bc_downscale_table_x_point6TOpoint8
-						    ();
+						       MDP_BC_SCALE_POINT6_POINT8)) {
+						mdp_load_bc_downscale_table_x_point6TOpoint8();
 						mdp_curr_down_scale_x =
 						    MDP_BC_SCALE_POINT6_POINT8;
 					}
@@ -2286,16 +2280,13 @@ void mdp_set_scale(MDPIBUF *iBuf,
 					if ((use_pr)
 					    && (mdp_curr_down_scale_x !=
 						MDP_PR_SCALE_POINT4_POINT6)) {
-						mdp_load_pr_downscale_table_x_point4TOpoint6
-						    ();
+						mdp_load_pr_downscale_table_x_point4TOpoint6();
 						mdp_curr_down_scale_x =
 						    MDP_PR_SCALE_POINT4_POINT6;
 					} else if ((!use_pr)
 						   && (mdp_curr_down_scale_x !=
-						       MDP_BC_SCALE_POINT4_POINT6))
-					{
-						mdp_load_bc_downscale_table_x_point4TOpoint6
-						    ();
+						       MDP_BC_SCALE_POINT4_POINT6)) {
+						mdp_load_bc_downscale_table_x_point4TOpoint6();
 						mdp_curr_down_scale_x =
 						    MDP_BC_SCALE_POINT4_POINT6;
 					}
@@ -2303,16 +2294,13 @@ void mdp_set_scale(MDPIBUF *iBuf,
 					if ((use_pr)
 					    && (mdp_curr_down_scale_x !=
 						MDP_PR_SCALE_POINT2_POINT4)) {
-						mdp_load_pr_downscale_table_x_point2TOpoint4
-						    ();
+						mdp_load_pr_downscale_table_x_point2TOpoint4();
 						mdp_curr_down_scale_x =
 						    MDP_PR_SCALE_POINT2_POINT4;
 					} else if ((!use_pr)
 						   && (mdp_curr_down_scale_x !=
-						       MDP_BC_SCALE_POINT2_POINT4))
-					{
-						mdp_load_bc_downscale_table_x_point2TOpoint4
-						    ();
+						       MDP_BC_SCALE_POINT2_POINT4)) {
+						mdp_load_bc_downscale_table_x_point2TOpoint4();
 						mdp_curr_down_scale_x =
 						    MDP_BC_SCALE_POINT2_POINT4;
 					}
@@ -2326,15 +2314,13 @@ void mdp_set_scale(MDPIBUF *iBuf,
 					if ((use_pr)
 					    && (mdp_curr_down_scale_y !=
 						MDP_PR_SCALE_POINT8_1)) {
-						mdp_load_pr_downscale_table_y_point8TO1
-						    ();
+						mdp_load_pr_downscale_table_y_point8TO1();
 						mdp_curr_down_scale_y =
 						    MDP_PR_SCALE_POINT8_1;
 					} else if ((!use_pr)
 						   && (mdp_curr_down_scale_y !=
 						       MDP_BC_SCALE_POINT8_1)) {
-						mdp_load_bc_downscale_table_y_point8TO1
-						    ();
+						mdp_load_bc_downscale_table_y_point8TO1();
 						mdp_curr_down_scale_y =
 						    MDP_BC_SCALE_POINT8_1;
 					}
@@ -2344,16 +2330,13 @@ void mdp_set_scale(MDPIBUF *iBuf,
 					if ((use_pr)
 					    && (mdp_curr_down_scale_y !=
 						MDP_PR_SCALE_POINT6_POINT8)) {
-						mdp_load_pr_downscale_table_y_point6TOpoint8
-						    ();
+						mdp_load_pr_downscale_table_y_point6TOpoint8();
 						mdp_curr_down_scale_y =
 						    MDP_PR_SCALE_POINT6_POINT8;
 					} else if ((!use_pr)
 						   && (mdp_curr_down_scale_y !=
-						       MDP_BC_SCALE_POINT6_POINT8))
-					{
-						mdp_load_bc_downscale_table_y_point6TOpoint8
-						    ();
+						       MDP_BC_SCALE_POINT6_POINT8)) {
+						mdp_load_bc_downscale_table_y_point6TOpoint8();
 						mdp_curr_down_scale_y =
 						    MDP_BC_SCALE_POINT6_POINT8;
 					}
@@ -2363,16 +2346,13 @@ void mdp_set_scale(MDPIBUF *iBuf,
 					if ((use_pr)
 					    && (mdp_curr_down_scale_y !=
 						MDP_PR_SCALE_POINT4_POINT6)) {
-						mdp_load_pr_downscale_table_y_point4TOpoint6
-						    ();
+						mdp_load_pr_downscale_table_y_point4TOpoint6();
 						mdp_curr_down_scale_y =
 						    MDP_PR_SCALE_POINT4_POINT6;
 					} else if ((!use_pr)
 						   && (mdp_curr_down_scale_y !=
-						       MDP_BC_SCALE_POINT4_POINT6))
-					{
-						mdp_load_bc_downscale_table_y_point4TOpoint6
-						    ();
+						       MDP_BC_SCALE_POINT4_POINT6)) {
+						mdp_load_bc_downscale_table_y_point4TOpoint6();
 						mdp_curr_down_scale_y =
 						    MDP_BC_SCALE_POINT4_POINT6;
 					}
@@ -2380,16 +2360,13 @@ void mdp_set_scale(MDPIBUF *iBuf,
 					if ((use_pr)
 					    && (mdp_curr_down_scale_y !=
 						MDP_PR_SCALE_POINT2_POINT4)) {
-						mdp_load_pr_downscale_table_y_point2TOpoint4
-						    ();
+						mdp_load_pr_downscale_table_y_point2TOpoint4();
 						mdp_curr_down_scale_y =
 						    MDP_PR_SCALE_POINT2_POINT4;
 					} else if ((!use_pr)
 						   && (mdp_curr_down_scale_y !=
-						       MDP_BC_SCALE_POINT2_POINT4))
-					{
-						mdp_load_bc_downscale_table_y_point2TOpoint4
-						    ();
+						       MDP_BC_SCALE_POINT2_POINT4)) {
+						mdp_load_bc_downscale_table_y_point2TOpoint4();
 						mdp_curr_down_scale_y =
 						    MDP_BC_SCALE_POINT2_POINT4;
 					}
diff --git a/drivers/staging/msm/msm_fb.c b/drivers/staging/msm/msm_fb.c
index e7ef836..2071c5c 100644
--- a/drivers/staging/msm/msm_fb.c
+++ b/drivers/staging/msm/msm_fb.c
@@ -55,17 +55,17 @@ extern int load_565rle_image(char *filename);
 
 
 #define pgprot_noncached(prot) \
-       __pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_UNCACHED)
+	__pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_UNCACHED)
 #define pgprot_writecombine(prot) \
-       __pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_BUFFERABLE)
+	__pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_BUFFERABLE)
 #define pgprot_device(prot) \
-       __pgprot_modify(prot, L_PTE_MT_MASK|L_PTE_EXEC, L_PTE_MT_DEV_NONSHARED)
+	__pgprot_modify(prot, L_PTE_MT_MASK|L_PTE_EXEC, L_PTE_MT_DEV_NONSHARED)
 #define pgprot_writethroughcache(prot) \
-       __pgprot((pgprot_val(prot) & ~L_PTE_MT_MASK) | L_PTE_MT_WRITETHROUGH)
+	__pgprot((pgprot_val(prot) & ~L_PTE_MT_MASK) | L_PTE_MT_WRITETHROUGH)
 #define pgprot_writebackcache(prot) \
-       __pgprot((pgprot_val(prot) & ~L_PTE_MT_MASK) | L_PTE_MT_WRITEBACK)
+	__pgprot((pgprot_val(prot) & ~L_PTE_MT_MASK) | L_PTE_MT_WRITEBACK)
 #define pgprot_writebackwacache(prot) \
-       __pgprot((pgprot_val(prot) & ~L_PTE_MT_MASK) | L_PTE_MT_WRITEALLOC)
+	__pgprot((pgprot_val(prot) & ~L_PTE_MT_MASK) | L_PTE_MT_WRITEALLOC)
 
 static unsigned char *fbram;
 static unsigned char *fbram_phys;
@@ -975,7 +975,8 @@ static int msm_fb_register(struct msm_fb_data_type *mfd)
 	     mfd->index, fbi->var.xres, fbi->var.yres, fbi->fix.smem_len);
 
 #ifdef CONFIG_FB_MSM_LOGO
-	if (!load_565rle_image(INIT_IMAGE_FILE)) ;	/* Flip buffer */
+	if (!load_565rle_image(INIT_IMAGE_FILE))	/* Flip buffer */
+		;
 #endif
 	ret = 0;
 
@@ -1147,9 +1148,8 @@ static int msm_fb_release(struct fb_info *info, int user)
 	mfd->ref_cnt--;
 
 	if (!mfd->ref_cnt) {
-		if ((ret =
-		     msm_fb_blank_sub(FB_BLANK_POWERDOWN, info,
-				      mfd->op_enable)) != 0) {
+		ret = msm_fb_blank_sub(FB_BLANK_POWERDOWN, info, mfd->op_enable);
+		if (ret != 0) {
 			printk(KERN_ERR "msm_fb_release: can't turn off display!\n");
 			return ret;
 		}
@@ -1236,7 +1236,7 @@ static int msm_fb_pan_display(struct fb_var_screeninfo *var,
 			if (var->reserved[1]) {
 				if (var->reserved[4] == MDP_BLIT_SRC_GEM) {
 					panic("waaaaaaaaaaaaaah");
-					if ( /*get_gem_img(&imgdata,
+					if (/*get_gem_img(&imgdata,
 						(unsigned long *) &address,
 						 &length)*/ -1 < 0) {
 						return -1;
@@ -1499,13 +1499,13 @@ static inline void msm_dma_wt_pre(void)
 static inline void msm_dma_todevice_wb_pre(void *start, size_t size)
 {
 	#warning this
-//	dma_cache_pre_ops(start, size, DMA_TO_DEVICE);
+	/* dma_cache_pre_ops(start, size, DMA_TO_DEVICE); */
 }
 
 static inline void msm_dma_fromdevice_wb_pre(void *start, size_t size)
 {
 	#warning this
-//	dma_cache_pre_ops(start, size, DMA_FROM_DEVICE);
+	/* dma_cache_pre_ops(start, size, DMA_FROM_DEVICE); */
 }
 
 static inline void msm_dma_nc_post(void)
@@ -1516,19 +1516,19 @@ static inline void msm_dma_nc_post(void)
 static inline void msm_dma_fromdevice_wt_post(void *start, size_t size)
 {
 	#warning this
-//	dma_cache_post_ops(start, size, DMA_FROM_DEVICE);
+	/* dma_cache_post_ops(start, size, DMA_FROM_DEVICE); */
 }
 
 static inline void msm_dma_todevice_wb_post(void *start, size_t size)
 {
 	#warning this
-//	dma_cache_post_ops(start, size, DMA_TO_DEVICE);
+	/* dma_cache_post_ops(start, size, DMA_TO_DEVICE); */
 }
 
 static inline void msm_dma_fromdevice_wb_post(void *start, size_t size)
 {
 	#warning this
-//	dma_cache_post_ops(start, size, DMA_FROM_DEVICE);
+	/* dma_cache_post_ops(start, size, DMA_FROM_DEVICE); */
 }
 
 /*
@@ -1888,12 +1888,12 @@ static int msmfb_overlay_get(struct fb_info *info, void __user *p)
 
 	ret = mdp4_overlay_get(info, &req);
 	if (ret) {
-		printk(KERN_ERR "%s: ioctl failed \n",
+		printk(KERN_ERR "%s: ioctl failed\n",
 			__func__);
 		return ret;
 	}
 	if (copy_to_user(p, &req, sizeof(req))) {
-		printk(KERN_ERR "%s: copy2user failed \n",
+		printk(KERN_ERR "%s: copy2user failed\n",
 			__func__);
 		return -EFAULT;
 	}
@@ -1911,13 +1911,13 @@ static int msmfb_overlay_set(struct fb_info *info, void __user *p)
 
 	ret = mdp4_overlay_set(info, &req);
 	if (ret) {
-		printk(KERN_ERR "%s:ioctl failed \n",
+		printk(KERN_ERR "%s:ioctl failed\n",
 			__func__);
 		return ret;
 	}
 
 	if (copy_to_user(p, &req, sizeof(req))) {
-		printk(KERN_ERR "%s: copy2user failed \n",
+		printk(KERN_ERR "%s: copy2user failed\n",
 			__func__);
 		return -EFAULT;
 	}
@@ -1931,7 +1931,7 @@ static int msmfb_overlay_unset(struct fb_info *info, unsigned long *argp)
 
 	ret = copy_from_user(&ndx, argp, sizeof(ndx));
 	if (ret) {
-		printk(KERN_ERR "%s:msmfb_overlay_unset ioctl failed \n",
+		printk(KERN_ERR "%s:msmfb_overlay_unset ioctl failed\n",
 			__func__);
 		return ret;
 	}
@@ -1947,7 +1947,7 @@ static int msmfb_overlay_play(struct fb_info *info, unsigned long *argp)
 
 	ret = copy_from_user(&req, argp, sizeof(req));
 	if (ret) {
-		printk(KERN_ERR "%s:msmfb_overlay_play ioctl failed \n",
+		printk(KERN_ERR "%s:msmfb_overlay_play ioctl failed\n",
 			__func__);
 		return ret;
 	}
@@ -2063,7 +2063,7 @@ static int msm_fb_ioctl(struct fb_info *info, unsigned int cmd,
 		ret = copy_from_user(&ccs_matrix, argp, sizeof(ccs_matrix));
 		if (ret) {
 			printk(KERN_ERR
-				"%s:MSMFB_SET_CCS_MATRIX ioctl failed \n",
+				"%s:MSMFB_SET_CCS_MATRIX ioctl failed\n",
 				__func__);
 			return ret;
 		}
@@ -2088,7 +2088,7 @@ static int msm_fb_ioctl(struct fb_info *info, unsigned int cmd,
 		ret = copy_from_user(&ccs_matrix, argp, sizeof(ccs_matrix)) ;
 		if (ret) {
 			printk(KERN_ERR
-				"%s:MSMFB_GET_CCS_MATRIX ioctl failed \n",
+				"%s:MSMFB_GET_CCS_MATRIX ioctl failed\n",
 				 __func__);
 			return ret;
 		}
@@ -2103,7 +2103,7 @@ static int msm_fb_ioctl(struct fb_info *info, unsigned int cmd,
 
 		if (ret)	{
 			printk(KERN_ERR
-				"%s:MSMFB_GET_CCS_MATRIX ioctl failed \n",
+				"%s:MSMFB_GET_CCS_MATRIX ioctl failed\n",
 				 __func__);
 			return ret ;
 		}
@@ -2334,8 +2334,8 @@ int __init msm_fb_init(void)
 #ifdef MSM_FB_ENABLE_DBGFS
 	{
 		struct dentry *root;
-
-		if ((root = msm_fb_get_debugfs_root()) != NULL) {
+		root = msm_fb_get_debugfs_root();
+		if (root != NULL) {
 			msm_fb_debugfs_file_create(root,
 						   "msm_fb_msg_printing_level",
 						   (u32 *) &msm_fb_msg_level);
diff --git a/drivers/staging/msm/staging-devices.c b/drivers/staging/msm/staging-devices.c
index d6cd919..452009a 100644
--- a/drivers/staging/msm/staging-devices.c
+++ b/drivers/staging/msm/staging-devices.c
@@ -17,7 +17,7 @@
 
 #include "msm_mdp.h"
 #include "memory_ll.h"
-//#include "android_pmem.h"
+/* #include "android_pmem.h" */
 
 #ifdef CONFIG_MSM_SOC_REV_A
 #define MSM_SMI_BASE 0xE0000000
@@ -26,8 +26,8 @@
 #endif
 
 
-#define TOUCHPAD_SUSPEND 	34
-#define TOUCHPAD_IRQ 		38
+#define TOUCHPAD_SUSPEND	34
+#define TOUCHPAD_IRQ		38
 
 #define MSM_PMEM_MDP_SIZE	0x1591000
 
@@ -42,7 +42,7 @@
 #define MSM_FB_SIZE             0x500000
 #define MSM_FB_SIZE_ST15	0x800000
 #define MSM_AUDIO_SIZE		0x80000
-#define MSM_GPU_PHYS_SIZE 	SZ_2M
+#define MSM_GPU_PHYS_SIZE	SZ_2M
 
 #ifdef CONFIG_MSM_SOC_REV_A
 #define MSM_SMI_BASE		0xE0000000
@@ -56,7 +56,7 @@
 #define MSM_PMEM_SMI_SIZE	0x01500000
 
 #define MSM_FB_BASE		MSM_PMEM_SMI_BASE
-#define MSM_GPU_PHYS_BASE 	(MSM_FB_BASE + MSM_FB_SIZE)
+#define MSM_GPU_PHYS_BASE	(MSM_FB_BASE + MSM_FB_SIZE)
 #define MSM_PMEM_SMIPOOL_BASE	(MSM_GPU_PHYS_BASE + MSM_GPU_PHYS_SIZE)
 #define MSM_PMEM_SMIPOOL_SIZE	(MSM_PMEM_SMI_SIZE - MSM_FB_SIZE \
 					- MSM_GPU_PHYS_SIZE)
@@ -159,9 +159,9 @@ static void __init qsd8x50_allocate_memory_regions(void)
 	else
 		size = MSM_FB_SIZE;
 
-	addr = alloc_bootmem(size); // (void *)MSM_FB_BASE;
+	addr = alloc_bootmem(size); /* (void *)MSM_FB_BASE; */
 	if (!addr)
-		printk("Failed to allocate bootmem for framebuffer\n");
+		printk(KERN_ERR "Failed to allocate bootmem for framebuffer\n");
 
 
 	msm_fb_resources[0].start = __pa(addr);
@@ -172,7 +172,7 @@ static void __init qsd8x50_allocate_memory_regions(void)
 
 static int msm_fb_lcdc_gpio_config(int on)
 {
-//	return 0;
+	/* return 0; */
 	if (machine_is_qsd8x50_st1()) {
 		if (on) {
 			gpio_set_value(32, 1);
@@ -195,7 +195,7 @@ static int msm_fb_lcdc_gpio_config(int on)
 			gpio_set_value(22, 0);
 			gpio_set_value(32, 1);
 			gpio_set_value(155, 1);
-			//st15_hdmi_power(1);
+			/* st15_hdmi_power(1); */
 			gpio_set_value(22, 1);
 
 		} else {
@@ -204,7 +204,7 @@ static int msm_fb_lcdc_gpio_config(int on)
 			gpio_set_value(22, 0);
 			gpio_set_value(32, 0);
 			gpio_set_value(155, 0);
-		//	st15_hdmi_power(0);
+			/* st15_hdmi_power(0); */
 		}
 	}
 	return 0;
@@ -273,15 +273,16 @@ static void __init msm_fb_add_devices(void)
 {
 	int rc;
 	msm_fb_register_device("mdp", &mdp_pdata);
-//	msm_fb_register_device("pmdh", &mddi_pdata);
-//	msm_fb_register_device("emdh", &mddi_pdata);
-//	msm_fb_register_device("tvenc", 0);
+	/* msm_fb_register_device("pmdh", &mddi_pdata); */
+	/* msm_fb_register_device("emdh", &mddi_pdata); */
+	/* msm_fb_register_device("tvenc", 0); */
 
 	if (machine_is_qsd8x50a_st1_5()) {
-/*		rc = st15_hdmi_vreg_init();
+		/*
+		rc = st15_hdmi_vreg_init();
 		if (rc)
 			return;
-*/
+		*/
 		rc = msm_gpios_request_enable(
 			msm_fb_st15_gpio_config_data,
 			ARRAY_SIZE(msm_fb_st15_gpio_config_data));
diff --git a/drivers/staging/msm/tv_ntsc.c b/drivers/staging/msm/tv_ntsc.c
index 5eb6761..6b814ab 100644
--- a/drivers/staging/msm/tv_ntsc.c
+++ b/drivers/staging/msm/tv_ntsc.c
@@ -160,4 +160,4 @@ static int __init ntsc_init(void)
 	return ret;
 }
 
-module_init(ntsc_init);
\ No newline at end of file
+module_init(ntsc_init);
diff --git a/drivers/staging/msm/tvenc.c b/drivers/staging/msm/tvenc.c
index 4fbb77b..01b7d5f 100644
--- a/drivers/staging/msm/tvenc.c
+++ b/drivers/staging/msm/tvenc.c
@@ -54,8 +54,8 @@ static struct platform_driver tvenc_driver = {
 	.probe = tvenc_probe,
 	.remove = tvenc_remove,
 	.suspend = NULL,
-//	.suspend_late = NULL,
-//	.resume_early = NULL,
+	/* .suspend_late = NULL, */
+	/* .resume_early = NULL, */
 	.resume = NULL,
 	.shutdown = NULL,
 	.driver = {
@@ -77,8 +77,8 @@ static int tvenc_off(struct platform_device *pdev)
 	if (tvenc_pdata && tvenc_pdata->pm_vid_en)
 		ret = tvenc_pdata->pm_vid_en(0);
 
-	//pm_qos_update_requirement(PM_QOS_SYSTEM_BUS_FREQ , "tvenc",
-	//				PM_QOS_DEFAULT_VALUE);
+	/* pm_qos_update_requirement(PM_QOS_SYSTEM_BUS_FREQ , "tvenc",
+					PM_QOS_DEFAULT_VALUE); */
 
 	if (ret)
 		printk(KERN_ERR "%s: pm_vid_en(off) failed! %d\n",
@@ -91,8 +91,8 @@ static int tvenc_on(struct platform_device *pdev)
 {
 	int ret = 0;
 
-//	pm_qos_update_requirement(PM_QOS_SYSTEM_BUS_FREQ , "tvenc",
-//				128000);
+	/* pm_qos_update_requirement(PM_QOS_SYSTEM_BUS_FREQ , "tvenc",
+				128000); */
 	if (tvenc_pdata && tvenc_pdata->pm_vid_en)
 		ret = tvenc_pdata->pm_vid_en(1);
 
@@ -263,7 +263,7 @@ tvenc_probe_err:
 
 static int tvenc_remove(struct platform_device *pdev)
 {
-//	pm_qos_remove_requirement(PM_QOS_SYSTEM_BUS_FREQ , "tvenc");
+	/* pm_qos_remove_requirement(PM_QOS_SYSTEM_BUS_FREQ , "tvenc"); */
 	return 0;
 }
 
@@ -288,8 +288,8 @@ static int __init tvenc_driver_init(void)
 		return PTR_ERR(tvdac_clk);
 	}
 
-//	pm_qos_add_requirement(PM_QOS_SYSTEM_BUS_FREQ , "tvenc",
-//				PM_QOS_DEFAULT_VALUE);
+	/* pm_qos_add_requirement(PM_QOS_SYSTEM_BUS_FREQ , "tvenc",
+				PM_QOS_DEFAULT_VALUE); */
 	return tvenc_register_driver();
 }
 
-- 
1.7.1


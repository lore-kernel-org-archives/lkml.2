Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab0HKX5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:57:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:59829 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758114Ab0HKX5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:17 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/bYUVfti7byQOXUwvM/rOdKUaiphkUaJGaAyQD9L
	MKPciBWpgzMgae
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [[PATCH 07/11]] viafb: propagate __init and __devinit
Date: Thu, 12 Aug 2010 00:07:53 +0000
Message-Id: <1281571673-8903-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: propagate __init and __devinit

There are a lot of init functions which are not marked as such.
Fix this.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/dvi.c      |   24 ++++++++++++++----------
 drivers/video/via/dvi.h      |    4 ++--
 drivers/video/via/hw.c       |   16 ++++++++--------
 drivers/video/via/hw.h       |    4 ++--
 drivers/video/via/lcd.c      |   10 +++++-----
 drivers/video/via/lcd.h      |    6 +++---
 drivers/video/via/viafbdev.c |    8 ++++----
 7 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index 92a2027..ab6145d 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -25,10 +25,12 @@
 static void tmds_register_write(int index, u8 data);
 static int tmds_register_read(int index);
 static int tmds_register_read_bytes(int index, u8 *buff, int buff_len);
-static void dvi_get_panel_size_from_DDCv1(struct tmds_chip_information
-	*tmds_chip, struct tmds_setting_information *tmds_setting);
-static void dvi_get_panel_size_from_DDCv2(struct tmds_chip_information
-	*tmds_chip, struct tmds_setting_information *tmds_setting);
+static void __devinit dvi_get_panel_size_from_DDCv1(
+	struct tmds_chip_information *tmds_chip,
+	struct tmds_setting_information *tmds_setting);
+static void __devinit dvi_get_panel_size_from_DDCv2(
+	struct tmds_chip_information *tmds_chip,
+	struct tmds_setting_information *tmds_setting);
 static int viafb_dvi_query_EDID(void);
 
 static int check_tmds_chip(int device_id_subaddr, int device_id)
@@ -39,7 +41,7 @@ static int check_tmds_chip(int device_id_subaddr, int device_id)
 		return FAIL;
 }
 
-void viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
+void __devinit viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
 	struct tmds_setting_information *tmds_setting)
 {
 	DEBUG_MSG(KERN_INFO "viafb_init_dvi_size()\n");
@@ -60,7 +62,7 @@ void viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
 	return;
 }
 
-int viafb_tmds_trasmitter_identify(void)
+int __devinit viafb_tmds_trasmitter_identify(void)
 {
 	unsigned char sr2a = 0, sr1e = 0, sr3e = 0;
 
@@ -311,8 +313,9 @@ static int viafb_dvi_query_EDID(void)
 }
 
 /* Get Panel Size Using EDID1 Table */
-static void dvi_get_panel_size_from_DDCv1(struct tmds_chip_information
-	*tmds_chip, struct tmds_setting_information *tmds_setting)
+static void __devinit dvi_get_panel_size_from_DDCv1(
+	struct tmds_chip_information *tmds_chip,
+	struct tmds_setting_information *tmds_setting)
 {
 	int i, max_h = 0, tmp, restore;
 	unsigned char rData;
@@ -416,8 +419,9 @@ static void dvi_get_panel_size_from_DDCv1(struct tmds_chip_information
 }
 
 /* Get Panel Size Using EDID2 Table */
-static void dvi_get_panel_size_from_DDCv2(struct tmds_chip_information
-	*tmds_chip, struct tmds_setting_information *tmds_setting)
+static void __devinit dvi_get_panel_size_from_DDCv2(
+	struct tmds_chip_information *tmds_chip,
+	struct tmds_setting_information *tmds_setting)
 {
 	int restore;
 	unsigned char R_Buffer[2];
diff --git a/drivers/video/via/dvi.h b/drivers/video/via/dvi.h
index 0dffcfd..2c525c0 100644
--- a/drivers/video/via/dvi.h
+++ b/drivers/video/via/dvi.h
@@ -56,8 +56,8 @@
 int viafb_dvi_sense(void);
 void viafb_dvi_disable(void);
 void viafb_dvi_enable(void);
-int viafb_tmds_trasmitter_identify(void);
-void viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
+int __devinit viafb_tmds_trasmitter_identify(void);
+void __devinit viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
 	struct tmds_setting_information *tmds_setting);
 void viafb_dvi_set_mode(struct VideoModeTable *videoMode, int mode_bpp,
 	int set_iga);
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 2f7f640..4407943 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -724,9 +724,9 @@ static void dvi_patch_skew_dvp_low(void);
 static void set_dvi_output_path(int set_iga, int output_interface);
 static void set_lcd_output_path(int set_iga, int output_interface);
 static void load_fix_bit_crtc_reg(void);
-static void init_gfx_chip_info(int chip_type);
-static void init_tmds_chip_info(void);
-static void init_lvds_chip_info(void);
+static void __devinit init_gfx_chip_info(int chip_type);
+static void __devinit init_tmds_chip_info(void);
+static void __devinit init_lvds_chip_info(void);
 static void device_screen_off(void);
 static void device_screen_on(void);
 static void set_display_channel(void);
@@ -1980,7 +1980,7 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 
 }
 
-void viafb_init_chip_info(int chip_type)
+void __devinit viafb_init_chip_info(int chip_type)
 {
 	init_gfx_chip_info(chip_type);
 	init_tmds_chip_info();
@@ -2047,7 +2047,7 @@ void viafb_update_device_setting(int hres, int vres,
 	}
 }
 
-static void init_gfx_chip_info(int chip_type)
+static void __devinit init_gfx_chip_info(int chip_type)
 {
 	u8 tmp;
 
@@ -2099,7 +2099,7 @@ static void init_gfx_chip_info(int chip_type)
 	}
 }
 
-static void init_tmds_chip_info(void)
+static void __devinit init_tmds_chip_info(void)
 {
 	viafb_tmds_trasmitter_identify();
 
@@ -2144,7 +2144,7 @@ static void init_tmds_chip_info(void)
 		&viaparinfo->shared->tmds_setting_info);
 }
 
-static void init_lvds_chip_info(void)
+static void __devinit init_lvds_chip_info(void)
 {
 	viafb_lvds_trasmitter_identify();
 	viafb_init_lcd_size();
@@ -2178,7 +2178,7 @@ static void init_lvds_chip_info(void)
 		  viaparinfo->chip_info->lvds_chip_info.output_interface);
 }
 
-void viafb_init_dac(int set_iga)
+void __devinit viafb_init_dac(int set_iga)
 {
 	int i;
 	u8 tmp;
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index c443998..39f3a69 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -908,8 +908,8 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	struct VideoModeTable *vmode_tbl1, int video_bpp1);
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
 	struct VideoModeTable *vmode_tbl);
-void viafb_init_chip_info(int chip_type);
-void viafb_init_dac(int set_iga);
+void __devinit viafb_init_chip_info(int chip_type);
+void __devinit viafb_init_dac(int set_iga);
 int viafb_get_pixclock(int hres, int vres, int vmode_refresh);
 int viafb_get_refresh(int hres, int vres, u32 float_refresh);
 void viafb_update_device_setting(int hres, int vres, int bpp,
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index e48117e..c7de164 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -48,7 +48,7 @@ static struct _lcd_scaling_factor lcd_scaling_factor_CLE = {
 
 static int check_lvds_chip(int device_id_subaddr, int device_id);
 static bool lvds_identify_integratedlvds(void);
-static void fp_id_to_vindex(int panel_id);
+static void __devinit fp_id_to_vindex(int panel_id);
 static int lvds_register_read(int index);
 static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 		      int panel_vres);
@@ -90,7 +90,7 @@ static int check_lvds_chip(int device_id_subaddr, int device_id)
 		return FAIL;
 }
 
-void viafb_init_lcd_size(void)
+void __devinit viafb_init_lcd_size(void)
 {
 	DEBUG_MSG(KERN_INFO "viafb_init_lcd_size()\n");
 
@@ -150,7 +150,7 @@ static bool lvds_identify_integratedlvds(void)
 	return true;
 }
 
-int viafb_lvds_trasmitter_identify(void)
+int __devinit viafb_lvds_trasmitter_identify(void)
 {
 	if (viafb_lvds_identify_vt1636(VIA_PORT_31)) {
 		viaparinfo->chip_info->lvds_chip_info.i2c_port = VIA_PORT_31;
@@ -191,7 +191,7 @@ int viafb_lvds_trasmitter_identify(void)
 	return FAIL;
 }
 
-static void fp_id_to_vindex(int panel_id)
+static void __devinit fp_id_to_vindex(int panel_id)
 {
 	DEBUG_MSG(KERN_INFO "fp_get_panel_id()\n");
 
@@ -996,7 +996,7 @@ static void check_diport_of_integrated_lvds(
 		  plvds_chip_info->output_interface);
 }
 
-void viafb_init_lvds_output_interface(struct lvds_chip_information
+void __devinit viafb_init_lvds_output_interface(struct lvds_chip_information
 				*plvds_chip_info,
 				struct lvds_setting_information
 				*plvds_setting_info)
diff --git a/drivers/video/via/lcd.h b/drivers/video/via/lcd.h
index b348efc..c7909fe 100644
--- a/drivers/video/via/lcd.h
+++ b/drivers/video/via/lcd.h
@@ -71,15 +71,15 @@ void viafb_enable_lvds_vt1636(struct lvds_setting_information
 			struct lvds_chip_information *plvds_chip_info);
 void viafb_lcd_disable(void);
 void viafb_lcd_enable(void);
-void viafb_init_lcd_size(void);
-void viafb_init_lvds_output_interface(struct lvds_chip_information
+void __devinit viafb_init_lcd_size(void);
+void __devinit viafb_init_lvds_output_interface(struct lvds_chip_information
 				*plvds_chip_info,
 				struct lvds_setting_information
 				*plvds_setting_info);
 void viafb_lcd_set_mode(struct crt_mode_table *mode_crt_table,
 		  struct lvds_setting_information *plvds_setting_info,
 		  struct lvds_chip_information *plvds_chip_info);
-int viafb_lvds_trasmitter_identify(void);
+int __devinit viafb_lvds_trasmitter_identify(void);
 void viafb_init_lvds_output_interface(struct lvds_chip_information
 				*plvds_chip_info,
 				struct lvds_setting_information
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index bdd0e41..5a947b0 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -961,7 +961,7 @@ static void retrieve_device_setting(struct viafb_ioctl_setting
 	setting_info->lcd_attributes.lcd_mode = viafb_lcd_mode;
 }
 
-static int parse_active_dev(void)
+static int __init parse_active_dev(void)
 {
 	viafb_CRT_ON = STATE_OFF;
 	viafb_DVI_ON = STATE_OFF;
@@ -1031,7 +1031,7 @@ static int parse_active_dev(void)
 	return 0;
 }
 
-static int parse_port(char *opt_str, int *output_interface)
+static int __devinit parse_port(char *opt_str, int *output_interface)
 {
 	if (!strncmp(opt_str, "DVP0", 4))
 		*output_interface = INTERFACE_DVP0;
@@ -1048,7 +1048,7 @@ static int parse_port(char *opt_str, int *output_interface)
 	return 0;
 }
 
-static void parse_lcd_port(void)
+static void __devinit parse_lcd_port(void)
 {
 	parse_port(viafb_lcd_port, &viaparinfo->chip_info->lvds_chip_info.
 		output_interface);
@@ -1061,7 +1061,7 @@ static void parse_lcd_port(void)
 		  output_interface);
 }
 
-static void parse_dvi_port(void)
+static void __devinit parse_dvi_port(void)
 {
 	parse_port(viafb_dvi_port, &viaparinfo->chip_info->tmds_chip_info.
 		output_interface);
-- 
1.6.3.2


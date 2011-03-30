Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1C3JUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:20:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51209 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932249Ab1C3JUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:20:10 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 15/18] gma500: pull mrst firmware stuff into its own header
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 10:01:22 +0100
Message-ID: <20110330090118.5897.137.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst.h    |  217 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/gma500/psb_drv.h |  197 ----------------------------------
 2 files changed, 218 insertions(+), 196 deletions(-)
 create mode 100644 drivers/staging/gma500/mrst.h

diff --git a/drivers/staging/gma500/mrst.h b/drivers/staging/gma500/mrst.h
new file mode 100644
index 0000000..5e4aaeb
--- /dev/null
+++ b/drivers/staging/gma500/mrst.h
@@ -0,0 +1,217 @@
+/**************************************************************************
+ * Copyright (c) 2007-2011, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+/* MID device specific descriptors */
+
+struct mrst_vbt {
+	s8 signature[4];	/*4 bytes,"$GCT" */
+	u8 revision;
+	u8 size;
+	u8 checksum;
+	void *mrst_gct;
+} __attribute__ ((packed));
+
+struct mrst_timing_info {
+	u16 pixel_clock;
+	u8 hactive_lo;
+	u8 hblank_lo;
+	u8 hblank_hi:4;
+	u8 hactive_hi:4;
+	u8 vactive_lo;
+	u8 vblank_lo;
+	u8 vblank_hi:4;
+	u8 vactive_hi:4;
+	u8 hsync_offset_lo;
+	u8 hsync_pulse_width_lo;
+	u8 vsync_pulse_width_lo:4;
+	u8 vsync_offset_lo:4;
+	u8 vsync_pulse_width_hi:2;
+	u8 vsync_offset_hi:2;
+	u8 hsync_pulse_width_hi:2;
+	u8 hsync_offset_hi:2;
+	u8 width_mm_lo;
+	u8 height_mm_lo;
+	u8 height_mm_hi:4;
+	u8 width_mm_hi:4;
+	u8 hborder;
+	u8 vborder;
+	u8 unknown0:1;
+	u8 hsync_positive:1;
+	u8 vsync_positive:1;
+	u8 separate_sync:2;
+	u8 stereo:1;
+	u8 unknown6:1;
+	u8 interlaced:1;
+} __attribute__((packed));
+
+struct gct_r10_timing_info {
+	u16 pixel_clock;
+	u32 hactive_lo:8;
+	u32 hactive_hi:4;
+	u32 hblank_lo:8;
+	u32 hblank_hi:4;
+	u32 hsync_offset_lo:8;
+	u16 hsync_offset_hi:2;
+	u16 hsync_pulse_width_lo:8;
+	u16 hsync_pulse_width_hi:2;
+	u16 hsync_positive:1;
+	u16 rsvd_1:3;
+	u8  vactive_lo:8;
+	u16 vactive_hi:4;
+	u16 vblank_lo:8;
+	u16 vblank_hi:4;
+	u16 vsync_offset_lo:4;
+	u16 vsync_offset_hi:2;
+	u16 vsync_pulse_width_lo:4;
+	u16 vsync_pulse_width_hi:2;
+	u16 vsync_positive:1;
+	u16 rsvd_2:3;
+} __attribute__((packed));
+
+struct mrst_panel_descriptor_v1 {
+	u32 Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */
+				/* 0x61190 if MIPI */
+	u32 Panel_Power_On_Sequencing;/*1 dword,Register 0x61208,*/
+	u32 Panel_Power_Off_Sequencing;/*1 dword,Register 0x6120C,*/
+	u32 Panel_Power_Cycle_Delay_and_Reference_Divisor;/* 1 dword */
+						/* Register 0x61210 */
+	struct mrst_timing_info DTD;/*18 bytes, Standard definition */
+	u16 Panel_Backlight_Inverter_Descriptor;/* 16 bits, as follows */
+				/* Bit 0, Frequency, 15 bits,0 - 32767Hz */
+			/* Bit 15, Polarity, 1 bit, 0: Normal, 1: Inverted */
+	u16 Panel_MIPI_Display_Descriptor;
+			/*16 bits, Defined as follows: */
+			/* if MIPI, 0x0000 if LVDS */
+			/* Bit 0, Type, 2 bits, */
+			/* 0: Type-1, */
+			/* 1: Type-2, */
+			/* 2: Type-3, */
+			/* 3: Type-4 */
+			/* Bit 2, Pixel Format, 4 bits */
+			/* Bit0: 16bpp (not supported in LNC), */
+			/* Bit1: 18bpp loosely packed, */
+			/* Bit2: 18bpp packed, */
+			/* Bit3: 24bpp */
+			/* Bit 6, Reserved, 2 bits, 00b */
+			/* Bit 8, Minimum Supported Frame Rate, 6 bits, 0 - 63Hz */
+			/* Bit 14, Reserved, 2 bits, 00b */
+} __attribute__ ((packed));
+
+struct mrst_panel_descriptor_v2 {
+	u32 Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */
+				/* 0x61190 if MIPI */
+	u32 Panel_Power_On_Sequencing;/*1 dword,Register 0x61208,*/
+	u32 Panel_Power_Off_Sequencing;/*1 dword,Register 0x6120C,*/
+	u8 Panel_Power_Cycle_Delay_and_Reference_Divisor;/* 1 byte */
+						/* Register 0x61210 */
+	struct mrst_timing_info DTD;/*18 bytes, Standard definition */
+	u16 Panel_Backlight_Inverter_Descriptor;/*16 bits, as follows*/
+				/*Bit 0, Frequency, 16 bits, 0 - 32767Hz*/
+	u8 Panel_Initial_Brightness;/* [7:0] 0 - 100% */
+			/*Bit 7, Polarity, 1 bit,0: Normal, 1: Inverted*/
+	u16 Panel_MIPI_Display_Descriptor;
+			/*16 bits, Defined as follows: */
+			/* if MIPI, 0x0000 if LVDS */
+			/* Bit 0, Type, 2 bits, */
+			/* 0: Type-1, */
+			/* 1: Type-2, */
+			/* 2: Type-3, */
+			/* 3: Type-4 */
+			/* Bit 2, Pixel Format, 4 bits */
+			/* Bit0: 16bpp (not supported in LNC), */
+			/* Bit1: 18bpp loosely packed, */
+			/* Bit2: 18bpp packed, */
+			/* Bit3: 24bpp */
+			/* Bit 6, Reserved, 2 bits, 00b */
+			/* Bit 8, Minimum Supported Frame Rate, 6 bits, 0 - 63Hz */
+			/* Bit 14, Reserved, 2 bits, 00b */
+} __attribute__ ((packed));
+
+union mrst_panel_rx {
+	struct{
+		u16 NumberOfLanes:2; /*Num of Lanes, 2 bits,0 = 1 lane,*/
+			/* 1 = 2 lanes, 2 = 3 lanes, 3 = 4 lanes. */
+		u16 MaxLaneFreq:3; /* 0: 100MHz, 1: 200MHz, 2: 300MHz, */
+		/*3: 400MHz, 4: 500MHz, 5: 600MHz, 6: 700MHz, 7: 800MHz.*/
+		u16 SupportedVideoTransferMode:2; /*0: Non-burst only */
+					/* 1: Burst and non-burst */
+					/* 2/3: Reserved */
+		u16 HSClkBehavior:1; /*0: Continuous, 1: Non-continuous*/
+		u16 DuoDisplaySupport:1; /*1 bit,0: No, 1: Yes*/
+		u16 ECC_ChecksumCapabilities:1;/*1 bit,0: No, 1: Yes*/
+		u16 BidirectionalCommunication:1;/*1 bit,0: No, 1: Yes */
+		u16 Rsvd:5;/*5 bits,00000b */
+	} panelrx;
+	u16 panel_receiver;
+} __attribute__ ((packed));
+
+struct mrst_gct_v1 {
+	union{ /*8 bits,Defined as follows: */
+		struct {
+			u8 PanelType:4; /*4 bits, Bit field for panels*/
+					/* 0 - 3: 0 = LVDS, 1 = MIPI*/
+					/*2 bits,Specifies which of the*/
+			u8 BootPanelIndex:2;
+					/* 4 panels to use by default*/
+			u8 BootMIPI_DSI_RxIndex:2;/*Specifies which of*/
+					/* the 4 MIPI DSI receivers to use*/
+		} PD;
+		u8 PanelDescriptor;
+	};
+	struct mrst_panel_descriptor_v1 panel[4];/*panel descrs,38 bytes each*/
+	union mrst_panel_rx panelrx[4]; /* panel receivers*/
+} __attribute__ ((packed));
+
+struct mrst_gct_v2 {
+	union{ /*8 bits,Defined as follows: */
+		struct {
+			u8 PanelType:4; /*4 bits, Bit field for panels*/
+					/* 0 - 3: 0 = LVDS, 1 = MIPI*/
+					/*2 bits,Specifies which of the*/
+			u8 BootPanelIndex:2;
+					/* 4 panels to use by default*/
+			u8 BootMIPI_DSI_RxIndex:2;/*Specifies which of*/
+					/* the 4 MIPI DSI receivers to use*/
+		} PD;
+		u8 PanelDescriptor;
+	};
+	struct mrst_panel_descriptor_v2 panel[4];/*panel descrs,38 bytes each*/
+	union mrst_panel_rx panelrx[4]; /* panel receivers*/
+} __attribute__ ((packed));
+
+struct mrst_gct_data {
+	u8 bpi; /* boot panel index, number of panel used during boot */
+	u8 pt; /* panel type, 4 bit field, 0=lvds, 1=mipi */
+	struct mrst_timing_info DTD; /* timing info for the selected panel */
+	u32 Panel_Port_Control;
+	u32 PP_On_Sequencing;/*1 dword,Register 0x61208,*/
+	u32 PP_Off_Sequencing;/*1 dword,Register 0x6120C,*/
+	u32 PP_Cycle_Delay;
+	u16 Panel_Backlight_Inverter_Descriptor;
+	u16 Panel_MIPI_Display_Descriptor;
+} __attribute__ ((packed));
+
+#define MODE_SETTING_IN_CRTC 	0x1
+#define MODE_SETTING_IN_ENCODER 0x2
+#define MODE_SETTING_ON_GOING 	0x3
+#define MODE_SETTING_IN_DSR 	0x4
+#define MODE_SETTING_ENCODER_DONE 0x8
+#define GCT_R10_HEADER_SIZE	16
+#define GCT_R10_DISPLAY_DESC_SIZE	28
+
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 014035f..c2fd475 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -29,6 +29,7 @@
 #include "psb_intel_drv.h"
 #include "psb_gtt.h"
 #include "psb_powermgmt.h"
+#include "mrst.h"
 #include "ttm/ttm_object.h"
 #include "psb_ttm_fence_driver.h"
 #include "psb_ttm_userobj_api.h"
@@ -243,202 +244,6 @@ struct drm_psb_uopt {
 	int pad; /*keep it here in case we use it in future*/
 };
 
-struct mrst_vbt {
-	s8 signature[4];	/*4 bytes,"$GCT" */
-	u8 revision;
-	u8 size;
-	u8 checksum;
-	void *mrst_gct;
-} __attribute__ ((packed));
-
-struct mrst_timing_info {
-	u16 pixel_clock;
-	u8 hactive_lo;
-	u8 hblank_lo;
-	u8 hblank_hi:4;
-	u8 hactive_hi:4;
-	u8 vactive_lo;
-	u8 vblank_lo;
-	u8 vblank_hi:4;
-	u8 vactive_hi:4;
-	u8 hsync_offset_lo;
-	u8 hsync_pulse_width_lo;
-	u8 vsync_pulse_width_lo:4;
-	u8 vsync_offset_lo:4;
-	u8 vsync_pulse_width_hi:2;
-	u8 vsync_offset_hi:2;
-	u8 hsync_pulse_width_hi:2;
-	u8 hsync_offset_hi:2;
-	u8 width_mm_lo;
-	u8 height_mm_lo;
-	u8 height_mm_hi:4;
-	u8 width_mm_hi:4;
-	u8 hborder;
-	u8 vborder;
-	u8 unknown0:1;
-	u8 hsync_positive:1;
-	u8 vsync_positive:1;
-	u8 separate_sync:2;
-	u8 stereo:1;
-	u8 unknown6:1;
-	u8 interlaced:1;
-} __attribute__((packed));
-
-struct gct_r10_timing_info {
-	u16 pixel_clock;
-	u32 hactive_lo:8;
-	u32 hactive_hi:4;
-	u32 hblank_lo:8;
-	u32 hblank_hi:4;
-	u32 hsync_offset_lo:8;
-	u16 hsync_offset_hi:2;
-	u16 hsync_pulse_width_lo:8;
-	u16 hsync_pulse_width_hi:2;
-	u16 hsync_positive:1;
-	u16 rsvd_1:3;
-	u8  vactive_lo:8;
-	u16 vactive_hi:4;
-	u16 vblank_lo:8;
-	u16 vblank_hi:4;
-	u16 vsync_offset_lo:4;
-	u16 vsync_offset_hi:2;
-	u16 vsync_pulse_width_lo:4;
-	u16 vsync_pulse_width_hi:2;
-	u16 vsync_positive:1;
-	u16 rsvd_2:3;
-} __attribute__((packed));
-
-struct mrst_panel_descriptor_v1 {
-	u32 Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */
-				/* 0x61190 if MIPI */
-	u32 Panel_Power_On_Sequencing;/*1 dword,Register 0x61208,*/
-	u32 Panel_Power_Off_Sequencing;/*1 dword,Register 0x6120C,*/
-	u32 Panel_Power_Cycle_Delay_and_Reference_Divisor;/* 1 dword */
-						/* Register 0x61210 */
-	struct mrst_timing_info DTD;/*18 bytes, Standard definition */
-	u16 Panel_Backlight_Inverter_Descriptor;/* 16 bits, as follows */
-				/* Bit 0, Frequency, 15 bits,0 - 32767Hz */
-			/* Bit 15, Polarity, 1 bit, 0: Normal, 1: Inverted */
-	u16 Panel_MIPI_Display_Descriptor;
-			/*16 bits, Defined as follows: */
-			/* if MIPI, 0x0000 if LVDS */
-			/* Bit 0, Type, 2 bits, */
-			/* 0: Type-1, */
-			/* 1: Type-2, */
-			/* 2: Type-3, */
-			/* 3: Type-4 */
-			/* Bit 2, Pixel Format, 4 bits */
-			/* Bit0: 16bpp (not supported in LNC), */
-			/* Bit1: 18bpp loosely packed, */
-			/* Bit2: 18bpp packed, */
-			/* Bit3: 24bpp */
-			/* Bit 6, Reserved, 2 bits, 00b */
-			/* Bit 8, Minimum Supported Frame Rate, 6 bits, 0 - 63Hz */
-			/* Bit 14, Reserved, 2 bits, 00b */
-} __attribute__ ((packed));
-
-struct mrst_panel_descriptor_v2 {
-	u32 Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */
-				/* 0x61190 if MIPI */
-	u32 Panel_Power_On_Sequencing;/*1 dword,Register 0x61208,*/
-	u32 Panel_Power_Off_Sequencing;/*1 dword,Register 0x6120C,*/
-	u8 Panel_Power_Cycle_Delay_and_Reference_Divisor;/* 1 byte */
-						/* Register 0x61210 */
-	struct mrst_timing_info DTD;/*18 bytes, Standard definition */
-	u16 Panel_Backlight_Inverter_Descriptor;/*16 bits, as follows*/
-				/*Bit 0, Frequency, 16 bits, 0 - 32767Hz*/
-	u8 Panel_Initial_Brightness;/* [7:0] 0 - 100% */
-			/*Bit 7, Polarity, 1 bit,0: Normal, 1: Inverted*/
-	u16 Panel_MIPI_Display_Descriptor;
-			/*16 bits, Defined as follows: */
-			/* if MIPI, 0x0000 if LVDS */
-			/* Bit 0, Type, 2 bits, */
-			/* 0: Type-1, */
-			/* 1: Type-2, */
-			/* 2: Type-3, */
-			/* 3: Type-4 */
-			/* Bit 2, Pixel Format, 4 bits */
-			/* Bit0: 16bpp (not supported in LNC), */
-			/* Bit1: 18bpp loosely packed, */
-			/* Bit2: 18bpp packed, */
-			/* Bit3: 24bpp */
-			/* Bit 6, Reserved, 2 bits, 00b */
-			/* Bit 8, Minimum Supported Frame Rate, 6 bits, 0 - 63Hz */
-			/* Bit 14, Reserved, 2 bits, 00b */
-} __attribute__ ((packed));
-
-union mrst_panel_rx {
-	struct{
-		u16 NumberOfLanes:2; /*Num of Lanes, 2 bits,0 = 1 lane,*/
-			/* 1 = 2 lanes, 2 = 3 lanes, 3 = 4 lanes. */
-		u16 MaxLaneFreq:3; /* 0: 100MHz, 1: 200MHz, 2: 300MHz, */
-		/*3: 400MHz, 4: 500MHz, 5: 600MHz, 6: 700MHz, 7: 800MHz.*/
-		u16 SupportedVideoTransferMode:2; /*0: Non-burst only */
-					/* 1: Burst and non-burst */
-					/* 2/3: Reserved */
-		u16 HSClkBehavior:1; /*0: Continuous, 1: Non-continuous*/
-		u16 DuoDisplaySupport:1; /*1 bit,0: No, 1: Yes*/
-		u16 ECC_ChecksumCapabilities:1;/*1 bit,0: No, 1: Yes*/
-		u16 BidirectionalCommunication:1;/*1 bit,0: No, 1: Yes */
-		u16 Rsvd:5;/*5 bits,00000b */
-	} panelrx;
-	u16 panel_receiver;
-} __attribute__ ((packed));
-
-struct mrst_gct_v1 {
-	union{ /*8 bits,Defined as follows: */
-		struct {
-			u8 PanelType:4; /*4 bits, Bit field for panels*/
-					/* 0 - 3: 0 = LVDS, 1 = MIPI*/
-					/*2 bits,Specifies which of the*/
-			u8 BootPanelIndex:2;
-					/* 4 panels to use by default*/
-			u8 BootMIPI_DSI_RxIndex:2;/*Specifies which of*/
-					/* the 4 MIPI DSI receivers to use*/
-		} PD;
-		u8 PanelDescriptor;
-	};
-	struct mrst_panel_descriptor_v1 panel[4];/*panel descrs,38 bytes each*/
-	union mrst_panel_rx panelrx[4]; /* panel receivers*/
-} __attribute__ ((packed));
-
-struct mrst_gct_v2 {
-	union{ /*8 bits,Defined as follows: */
-		struct {
-			u8 PanelType:4; /*4 bits, Bit field for panels*/
-					/* 0 - 3: 0 = LVDS, 1 = MIPI*/
-					/*2 bits,Specifies which of the*/
-			u8 BootPanelIndex:2;
-					/* 4 panels to use by default*/
-			u8 BootMIPI_DSI_RxIndex:2;/*Specifies which of*/
-					/* the 4 MIPI DSI receivers to use*/
-		} PD;
-		u8 PanelDescriptor;
-	};
-	struct mrst_panel_descriptor_v2 panel[4];/*panel descrs,38 bytes each*/
-	union mrst_panel_rx panelrx[4]; /* panel receivers*/
-} __attribute__ ((packed));
-
-struct mrst_gct_data {
-	u8 bpi; /* boot panel index, number of panel used during boot */
-	u8 pt; /* panel type, 4 bit field, 0=lvds, 1=mipi */
-	struct mrst_timing_info DTD; /* timing info for the selected panel */
-	u32 Panel_Port_Control;
-	u32 PP_On_Sequencing;/*1 dword,Register 0x61208,*/
-	u32 PP_Off_Sequencing;/*1 dword,Register 0x6120C,*/
-	u32 PP_Cycle_Delay;
-	u16 Panel_Backlight_Inverter_Descriptor;
-	u16 Panel_MIPI_Display_Descriptor;
-} __attribute__ ((packed));
-
-#define MODE_SETTING_IN_CRTC 	0x1
-#define MODE_SETTING_IN_ENCODER 0x2
-#define MODE_SETTING_ON_GOING 	0x3
-#define MODE_SETTING_IN_DSR 	0x4
-#define MODE_SETTING_ENCODER_DONE 0x8
-#define GCT_R10_HEADER_SIZE	16
-#define GCT_R10_DISPLAY_DESC_SIZE	28
-
 struct drm_psb_private {
 	/*
 	 * DSI info.


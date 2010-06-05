Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab0FEXdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:33:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48449 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815Ab0FEXdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=komyi2UezAIaMkvtcqtR5WLkSCCswP85kojTBrO2R5nEuzT9xFJolcN6E1unGHQ7pd
         XJlDBq+f2aAgK0YmCFH2TD5RGTuxqVwOd+1s30in6KZW54KCQ5vaD/L41AIHjiPggJPg
         WEGkEdrzT0aEXq9EXn08qmXa/e2EOI0wdTUi4=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 6/6] Use standard types instead of typedefs.
Date: Sun,  6 Jun 2010 01:33:16 +0200
Message-Id: <1275780796-17751-7-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/XGI_main.h    |   38 +-
 drivers/staging/xgifb/XGI_main_26.c |   34 +-
 drivers/staging/xgifb/vb_ext.c      |  122 ++--
 drivers/staging/xgifb/vb_ext.h      |   12 +-
 drivers/staging/xgifb/vb_init.c     |  310 ++++++------
 drivers/staging/xgifb/vb_init.h     |    2 +-
 drivers/staging/xgifb/vb_setmode.c  | 1032 +++++++++++++++++-----------------
 drivers/staging/xgifb/vb_setmode.h  |   38 +-
 drivers/staging/xgifb/vb_struct.h   |  600 ++++++++++----------
 drivers/staging/xgifb/vb_table.h    |  236 ++++----
 drivers/staging/xgifb/vb_util.c     |   58 +-
 drivers/staging/xgifb/vb_util.h     |   20 +-
 drivers/staging/xgifb/vgatypes.h    |  110 +---
 13 files changed, 1279 insertions(+), 1333 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index c05bade..741b463 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -500,13 +500,13 @@ u8  XGIfb_mode_no  = 0;
 u8  XGIfb_rate_idx = 0;
 
 /* TW: CR36 evaluation */
-const USHORT XGI300paneltype[] =
+const unsigned short XGI300paneltype[] =
     { LCD_UNKNOWN,   LCD_800x600,  LCD_1024x768,  LCD_1280x1024,
       LCD_1280x960,  LCD_640x480,  LCD_1024x600,  LCD_1152x768,
        LCD_1024x768, LCD_1024x768,  LCD_1024x768,
       LCD_1024x768,  LCD_1024x768, LCD_1024x768,  LCD_1024x768 };
 
-const USHORT XGI310paneltype[] =
+const unsigned short XGI310paneltype[] =
     { LCD_UNKNOWN,   LCD_800x600,  LCD_1024x768,  LCD_1280x1024,
       LCD_640x480,   LCD_1024x600, LCD_1152x864,  LCD_1280x960,
       LCD_1152x768,  LCD_1400x1050,LCD_1280x768,  LCD_1600x1200,
@@ -826,7 +826,7 @@ extern int      XGIfb_mode_rate_to_ddata(VB_DEVICE_INFO *XGI_Pr, PXGI_HW_DEVICE_
 			 unsigned int *sync, unsigned int *vmode);
 */
 
-			extern   BOOLEAN  XGI_SearchModeID( USHORT ModeNo,USHORT  *ModeIdIndex, PVB_DEVICE_INFO );
+			extern   bool  XGI_SearchModeID( unsigned short ModeNo,unsigned short  *ModeIdIndex, PVB_DEVICE_INFO );
 static int      XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 			      struct fb_info *info);
 
@@ -846,10 +846,10 @@ static int      XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 static void     XGIfb_pre_setmode(void);
 static void     XGIfb_post_setmode(void);
 
-static BOOLEAN  XGIfb_CheckVBRetrace(void);
-static BOOLEAN  XGIfbcheckvretracecrt2(void);
-static BOOLEAN  XGIfbcheckvretracecrt1(void);
-static BOOLEAN  XGIfb_bridgeisslave(void);
+static bool  XGIfb_CheckVBRetrace(void);
+static bool  XGIfbcheckvretracecrt2(void);
+static bool  XGIfbcheckvretracecrt1(void);
+static bool  XGIfb_bridgeisslave(void);
 
 struct XGI_memreq {
 	unsigned long offset;
@@ -884,26 +884,26 @@ static XGI_OH   *XGIfb_poh_free(unsigned long base);
 static void     XGIfb_free_node(XGI_OH *poh);
 
 /* Internal routines to access PCI configuration space */
-BOOLEAN         XGIfb_query_VGA_config_space(PXGI_HW_DEVICE_INFO pXGIhw_ext,
+bool         XGIfb_query_VGA_config_space(PXGI_HW_DEVICE_INFO pXGIhw_ext,
 	          	unsigned long offset, unsigned long set, unsigned long *value);
-//BOOLEAN         XGIfb_query_north_bridge_space(PXGI_HW_DEVICE_INFO pXGIhw_ext,
+//bool         XGIfb_query_north_bridge_space(PXGI_HW_DEVICE_INFO pXGIhw_ext,
 //	         	unsigned long offset, unsigned long set, unsigned long *value);
 
 
 /* Routines from init.c/init301.c */
-extern void     InitTo330Pointer(UCHAR,PVB_DEVICE_INFO pVBInfo);
-extern BOOLEAN  XGIInitNew(PXGI_HW_DEVICE_INFO HwDeviceExtension);
-extern BOOLEAN  XGISetModeNew(PXGI_HW_DEVICE_INFO HwDeviceExtension, USHORT ModeNo);
+extern void     InitTo330Pointer(unsigned char,PVB_DEVICE_INFO pVBInfo);
+extern bool  XGIInitNew(PXGI_HW_DEVICE_INFO HwDeviceExtension);
+extern bool  XGISetModeNew(PXGI_HW_DEVICE_INFO HwDeviceExtension, unsigned short ModeNo);
 //extern void     XGI_SetEnableDstn(VB_DEVICE_INFO *XGI_Pr);
 extern void     XGI_LongWait(VB_DEVICE_INFO *XGI_Pr);
-extern USHORT   XGI_GetRatePtrCRT2( PXGI_HW_DEVICE_INFO pXGIHWDE, USHORT ModeNo,USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo );
+extern unsigned short   XGI_GetRatePtrCRT2( PXGI_HW_DEVICE_INFO pXGIHWDE, unsigned short ModeNo,unsigned short ModeIdIndex,PVB_DEVICE_INFO pVBInfo );
 /* TW: Chrontel TV functions */
-extern USHORT 	XGI_GetCH700x(VB_DEVICE_INFO *XGI_Pr, USHORT tempbx);
-extern void 	XGI_SetCH700x(VB_DEVICE_INFO *XGI_Pr, USHORT tempbx);
-extern USHORT 	XGI_GetCH701x(VB_DEVICE_INFO *XGI_Pr, USHORT tempbx);
-extern void 	XGI_SetCH701x(VB_DEVICE_INFO *XGI_Pr, USHORT tempbx);
-extern void     XGI_SetCH70xxANDOR(VB_DEVICE_INFO *XGI_Pr, USHORT tempax,USHORT tempbh);
-extern void     XGI_DDC2Delay(VB_DEVICE_INFO *XGI_Pr, USHORT delaytime);
+extern unsigned short 	XGI_GetCH700x(VB_DEVICE_INFO *XGI_Pr, unsigned short tempbx);
+extern void 	XGI_SetCH700x(VB_DEVICE_INFO *XGI_Pr, unsigned short tempbx);
+extern unsigned short 	XGI_GetCH701x(VB_DEVICE_INFO *XGI_Pr, unsigned short tempbx);
+extern void 	XGI_SetCH701x(VB_DEVICE_INFO *XGI_Pr, unsigned short tempbx);
+extern void     XGI_SetCH70xxANDOR(VB_DEVICE_INFO *XGI_Pr, unsigned short tempax,unsigned short tempbh);
+extern void     XGI_DDC2Delay(VB_DEVICE_INFO *XGI_Pr, unsigned short delaytime);
 
 /* TW: Sensing routines */
 void            XGI_Sense30x(void);
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 05e4603..96bbb2e 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -165,11 +165,11 @@ int
 XGIfb_mode_rate_to_dclock(VB_DEVICE_INFO *XGI_Pr, PXGI_HW_DEVICE_INFO HwDeviceExtension,
 			  unsigned char modeno, unsigned char rateindex)
 {
-    USHORT ModeNo = modeno;
-    USHORT ModeIdIndex = 0, ClockIndex = 0;
-    USHORT RefreshRateTableIndex = 0;
+    unsigned short ModeNo = modeno;
+    unsigned short ModeIdIndex = 0, ClockIndex = 0;
+    unsigned short RefreshRateTableIndex = 0;
 
-    /*ULONG  temp = 0;*/
+    /*unsigned long  temp = 0;*/
     int    Clock;
     XGI_Pr->ROMAddr  = HwDeviceExtension->pjVirtualRomBase;
     InitTo330Pointer( HwDeviceExtension->jChipType, XGI_Pr ) ;
@@ -204,9 +204,9 @@ XGIfb_mode_rate_to_ddata(VB_DEVICE_INFO *XGI_Pr, PXGI_HW_DEVICE_INFO HwDeviceExt
 			 u32 *hsync_len, u32 *vsync_len,
 			 u32 *sync, u32 *vmode)
 {
-    USHORT ModeNo = modeno;
-    USHORT ModeIdIndex = 0, index = 0;
-    USHORT RefreshRateTableIndex = 0;
+    unsigned short ModeNo = modeno;
+    unsigned short ModeIdIndex = 0, index = 0;
+    unsigned short RefreshRateTableIndex = 0;
 
     unsigned short VRE, VBE, VRS, VBS, VDE, VT;
     unsigned short HRE, HBE, HRS, HBS, HDE, HT;
@@ -388,7 +388,7 @@ XGIfb_mode_rate_to_ddata(VB_DEVICE_INFO *XGI_Pr, PXGI_HW_DEVICE_INFO HwDeviceExt
 
 
 
-void XGIRegInit(VB_DEVICE_INFO *XGI_Pr, ULONG BaseAddr)
+void XGIRegInit(VB_DEVICE_INFO *XGI_Pr, unsigned long BaseAddr)
 {
    XGI_Pr->RelIO = BaseAddr;
    XGI_Pr->P3c4 = BaseAddr + 0x14;
@@ -426,7 +426,7 @@ u32 XGIfb_get_reg3(u16 port)
 
 /* ------------ Interface for init & mode switching code ------------- */
 
-BOOLEAN
+bool
 XGIfb_query_VGA_config_space(PXGI_HW_DEVICE_INFO pXGIhw_ext,
 	unsigned long offset, unsigned long set, unsigned long *value)
 {
@@ -461,7 +461,7 @@ XGIfb_query_VGA_config_space(PXGI_HW_DEVICE_INFO pXGIhw_ext,
 	return TRUE;
 }
 
-/*BOOLEAN XGIfb_query_north_bridge_space(PXGI_HW_DEVICE_INFO pXGIhw_ext,
+/*bool XGIfb_query_north_bridge_space(PXGI_HW_DEVICE_INFO pXGIhw_ext,
 	unsigned long offset, unsigned long set, unsigned long *value)
 {
 	static struct pci_dev *pdev = NULL;
@@ -952,7 +952,7 @@ static void XGIfb_search_tvstd(const char *name)
 }
 #endif
 
-static BOOLEAN XGIfb_bridgeisslave(void)
+static bool XGIfb_bridgeisslave(void)
 {
    unsigned char usScratchP1_00;
 
@@ -966,7 +966,7 @@ static BOOLEAN XGIfb_bridgeisslave(void)
    }
 }
 
-static BOOLEAN XGIfbcheckvretracecrt1(void)
+static bool XGIfbcheckvretracecrt1(void)
 {
    unsigned char temp;
 
@@ -982,7 +982,7 @@ static BOOLEAN XGIfbcheckvretracecrt1(void)
    else 			   return FALSE;
 }
 
-static BOOLEAN XGIfbcheckvretracecrt2(void)
+static bool XGIfbcheckvretracecrt2(void)
 {
    unsigned char temp;
    if(xgi_video_info.hasVB == HASVB_NONE) return FALSE;
@@ -991,7 +991,7 @@ static BOOLEAN XGIfbcheckvretracecrt2(void)
    else 	   return TRUE;
 }
 
-static BOOLEAN XGIfb_CheckVBRetrace(void)
+static bool XGIfb_CheckVBRetrace(void)
 {
    if(xgi_video_info.disp_state & DISPTYPE_DISP2) {
       if(XGIfb_bridgeisslave()) {
@@ -2648,7 +2648,7 @@ static void XGIfb_pre_setmode(void)
 static void XGIfb_post_setmode(void)
 {
 	u8 reg;
-	BOOLEAN doit = TRUE;
+	bool doit = TRUE;
 #if 0	/* TW: Wrong: Is not in MMIO space, but in RAM */
 	/* Backup mode number to MMIO space */
 	if(xgi_video_info.mmio_vbase) {
@@ -2966,14 +2966,14 @@ int __devinit xgifb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	  xgi_video_info.mmio_base = pci_resource_start(pdev, 1);
 	  XGIfb_mmio_size =  pci_resource_len(pdev, 1);
 	  xgi_video_info.vga_base = pci_resource_start(pdev, 2) + 0x30;
-	  XGIhw_ext.pjIOAddress = (PUCHAR)xgi_video_info.vga_base;
+	  XGIhw_ext.pjIOAddress = (unsigned char *)xgi_video_info.vga_base;
 	  //XGI_Pr.RelIO  = ioremap(pci_resource_start(pdev, 2), 128) + 0x30;
 	  printk("XGIfb: Relocate IO address: %lx [%08lx] \n", (unsigned long)pci_resource_start(pdev, 2), XGI_Pr.RelIO);
 
 	  if (pci_enable_device(pdev))
 	          return -EIO;
 
-    XGIRegInit(&XGI_Pr, (ULONG)XGIhw_ext.pjIOAddress);
+    XGIRegInit(&XGI_Pr, (unsigned long)XGIhw_ext.pjIOAddress);
 
     outXGIIDXREG(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
     inXGIIDXREG(XGISR, IND_XGI_PASSWORD, reg1);
diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index 3304101..3d3c66b 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -9,27 +9,27 @@
 #include "vb_util.h"
 #include "vb_setmode.h"
 #include "vb_ext.h"
-extern   UCHAR XGI330_SoftSetting;
-extern   UCHAR XGI330_OutputSelect;
-extern   USHORT XGI330_RGBSenseData2;
-extern   USHORT XGI330_YCSenseData2;
-extern   USHORT XGI330_VideoSenseData2;
+extern   unsigned char XGI330_SoftSetting;
+extern   unsigned char XGI330_OutputSelect;
+extern   unsigned short XGI330_RGBSenseData2;
+extern   unsigned short XGI330_YCSenseData2;
+extern   unsigned short XGI330_VideoSenseData2;
 void     XGI_GetSenseStatus( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo );
-BOOLEAN  XGINew_GetPanelID(PVB_DEVICE_INFO pVBInfo);
-USHORT   XGINew_SenseLCD(PXGI_HW_DEVICE_INFO,PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGINew_GetLCDDDCInfo(PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo);
-void XGISetDPMS( PXGI_HW_DEVICE_INFO pXGIHWDE , ULONG VESA_POWER_STATE ) ;
-BOOLEAN  XGINew_BridgeIsEnable(PXGI_HW_DEVICE_INFO,PVB_DEVICE_INFO pVBInfo );
-BOOLEAN  XGINew_Sense(USHORT tempbx,USHORT tempcx, PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGINew_SenseHiTV( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo ) ;
+bool  XGINew_GetPanelID(PVB_DEVICE_INFO pVBInfo);
+unsigned short   XGINew_SenseLCD(PXGI_HW_DEVICE_INFO,PVB_DEVICE_INFO pVBInfo);
+bool  XGINew_GetLCDDDCInfo(PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo);
+void XGISetDPMS( PXGI_HW_DEVICE_INFO pXGIHWDE , unsigned long VESA_POWER_STATE ) ;
+bool  XGINew_BridgeIsEnable(PXGI_HW_DEVICE_INFO,PVB_DEVICE_INFO pVBInfo );
+bool  XGINew_Sense(unsigned short tempbx,unsigned short tempcx, PVB_DEVICE_INFO pVBInfo);
+bool  XGINew_SenseHiTV( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo ) ;
 
 /**************************************************************
 	Dynamic Sense
 *************************************************************/
 
 void XGI_WaitDisplay(void);
-BOOLEAN XGI_Is301C(PVB_DEVICE_INFO);
-BOOLEAN XGI_Is301LV(PVB_DEVICE_INFO);
+bool XGI_Is301C(PVB_DEVICE_INFO);
+bool XGI_Is301LV(PVB_DEVICE_INFO);
 
 /* --------------------------------------------------------------------- */
 /* Function : XGINew_Is301B */
@@ -37,9 +37,9 @@ BOOLEAN XGI_Is301LV(PVB_DEVICE_INFO);
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGINew_Is301B( PVB_DEVICE_INFO pVBInfo )
+bool XGINew_Is301B( PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT flag ;
+    unsigned short flag ;
 
     flag = XGINew_GetReg1( pVBInfo->Part4Port , 0x01 ) ;
 
@@ -55,7 +55,7 @@ BOOLEAN XGINew_Is301B( PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_Is301C( PVB_DEVICE_INFO pVBInfo )
+bool XGI_Is301C( PVB_DEVICE_INFO pVBInfo )
 {
     if ( ( XGINew_GetReg1( pVBInfo->Part4Port , 0x01 ) & 0xF0 ) == 0xC0 )
         return( 1 ) ;
@@ -76,7 +76,7 @@ BOOLEAN XGI_Is301C( PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_Is301LV( PVB_DEVICE_INFO pVBInfo )
+bool XGI_Is301LV( PVB_DEVICE_INFO pVBInfo )
 {
     if ( XGINew_GetReg1( pVBInfo->Part4Port , 0x01 ) >= 0xD0 )
     {
@@ -95,9 +95,9 @@ BOOLEAN XGI_Is301LV( PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGINew_Sense(  USHORT tempbx , USHORT tempcx, PVB_DEVICE_INFO pVBInfo )
+bool XGINew_Sense(  unsigned short tempbx , unsigned short tempcx, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT temp , i , tempch ;
+    unsigned short temp , i , tempch ;
 
     temp = tempbx & 0xFF ;
     XGINew_SetReg1( pVBInfo->Part4Port , 0x11 , temp ) ;
@@ -125,13 +125,13 @@ BOOLEAN XGINew_Sense(  USHORT tempbx , USHORT tempcx, PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-VOID XGISetDPMS( PXGI_HW_DEVICE_INFO pXGIHWDE , ULONG VESA_POWER_STATE )
+void XGISetDPMS( PXGI_HW_DEVICE_INFO pXGIHWDE , unsigned long VESA_POWER_STATE )
 {
-    USHORT ModeNo, ModeIdIndex ;
-    UCHAR  temp ;
+    unsigned short ModeNo, ModeIdIndex ;
+    unsigned char  temp ;
     VB_DEVICE_INFO VBINF;
     PVB_DEVICE_INFO pVBInfo = &VBINF;
-    pVBInfo->BaseAddr = (ULONG)pXGIHWDE->pjIOAddress ;
+    pVBInfo->BaseAddr = (unsigned long)pXGIHWDE->pjIOAddress ;
     pVBInfo->ROMAddr  = pXGIHWDE->pjVirtualRomBase ;
 
 
@@ -198,18 +198,18 @@ VOID XGISetDPMS( PXGI_HW_DEVICE_INFO pXGIHWDE , ULONG VESA_POWER_STATE )
     }
 
     if ( VESA_POWER_STATE == 0x00000400 )
-      XGINew_SetReg1( pVBInfo->Part4Port , 0x31 , ( UCHAR )( XGINew_GetReg1( pVBInfo->Part4Port , 0x31 ) & 0xFE ) ) ;
+      XGINew_SetReg1( pVBInfo->Part4Port , 0x31 , ( unsigned char )( XGINew_GetReg1( pVBInfo->Part4Port , 0x31 ) & 0xFE ) ) ;
     else
-      XGINew_SetReg1( pVBInfo->Part4Port , 0x31 , ( UCHAR )( XGINew_GetReg1( pVBInfo->Part4Port , 0x31 ) | 0x01 ) ) ;
+      XGINew_SetReg1( pVBInfo->Part4Port , 0x31 , ( unsigned char )( XGINew_GetReg1( pVBInfo->Part4Port , 0x31 ) | 0x01 ) ) ;
 
-    temp = ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x1f ) ;
+    temp = ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x1f ) ;
     temp &= 0x3f ;
     switch ( VESA_POWER_STATE )
     {
         case 0x00000000: /* on */
             if ( ( pXGIHWDE->ujVBChipID == VB_CHIP_301 ) || ( pXGIHWDE->ujVBChipID == VB_CHIP_302 ) )
             {
-                XGINew_SetReg1( pVBInfo->P3c4 , 0x1f , ( UCHAR )( temp | 0x00 ) ) ;
+                XGINew_SetReg1( pVBInfo->P3c4 , 0x1f , ( unsigned char )( temp | 0x00 ) ) ;
                 XGI_EnableBridge( pXGIHWDE, pVBInfo ) ;
             }
             else
@@ -267,7 +267,7 @@ VOID XGISetDPMS( PXGI_HW_DEVICE_INFO pXGIHWDE , ULONG VESA_POWER_STATE )
                 XGI_DisplayOff( pXGIHWDE, pVBInfo );
             }
 
-            XGINew_SetReg1( pVBInfo->P3c4 , 0x1f , ( UCHAR )( temp | 0x40 ) ) ;
+            XGINew_SetReg1( pVBInfo->P3c4 , 0x1f , ( unsigned char )( temp | 0x40 ) ) ;
             break ;
         case 0x00000200: /* suspend */
             if ( pXGIHWDE->jChipType == XG21 )
@@ -280,12 +280,12 @@ VOID XGISetDPMS( PXGI_HW_DEVICE_INFO pXGIHWDE , ULONG VESA_POWER_STATE )
                 XGI_DisplayOff( pXGIHWDE, pVBInfo );
                 XGI_XG27BLSignalVDD( 0x20 , 0x00, pVBInfo ) ; /* LVDS signal off */
             }
-            XGINew_SetReg1( pVBInfo->P3c4 , 0x1f , ( UCHAR )( temp | 0x80 ) ) ;
+            XGINew_SetReg1( pVBInfo->P3c4 , 0x1f , ( unsigned char )( temp | 0x80 ) ) ;
             break ;
         case 0x00000400: /* off */
             if ( (pXGIHWDE->ujVBChipID == VB_CHIP_301 ) || ( pXGIHWDE->ujVBChipID == VB_CHIP_302 ) )
             {
-                XGINew_SetReg1( pVBInfo->P3c4 , 0x1f , ( UCHAR )( temp | 0xc0 ) ) ;
+                XGINew_SetReg1( pVBInfo->P3c4 , 0x1f , ( unsigned char )( temp | 0xc0 ) ) ;
                 XGI_DisableBridge( pXGIHWDE, pVBInfo ) ;
             }
             else
@@ -350,10 +350,10 @@ VOID XGISetDPMS( PXGI_HW_DEVICE_INFO pXGIHWDE , ULONG VESA_POWER_STATE )
 /* --------------------------------------------------------------------- */
 void XGI_GetSenseStatus( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempax = 0 , tempbx , tempcx , temp ,
+    unsigned short tempax = 0 , tempbx , tempcx , temp ,
            P2reg0 = 0 , SenseModeNo = 0 , OutputSelect = *pVBInfo->pOutputSelect ,
            ModeIdIndex , i ;
-    pVBInfo->BaseAddr = (ULONG)HwDeviceExtension->pjIOAddress ;
+    pVBInfo->BaseAddr = (unsigned long)HwDeviceExtension->pjIOAddress ;
 
     if ( pVBInfo->IF_DEF_LVDS == 1 )
     {
@@ -547,10 +547,10 @@ void XGI_GetSenseStatus( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-USHORT XGINew_SenseLCD( PXGI_HW_DEVICE_INFO HwDeviceExtension ,PVB_DEVICE_INFO pVBInfo)
+unsigned short XGINew_SenseLCD( PXGI_HW_DEVICE_INFO HwDeviceExtension ,PVB_DEVICE_INFO pVBInfo)
 {
-    /* USHORT SoftSetting ; */
-    USHORT temp ;
+    /* unsigned short SoftSetting ; */
+    unsigned short temp ;
 
     if ( ( HwDeviceExtension->jChipType >= XG20 ) || ( HwDeviceExtension->jChipType >= XG40 ) )
         temp = 0 ;
@@ -570,9 +570,9 @@ USHORT XGINew_SenseLCD( PXGI_HW_DEVICE_INFO HwDeviceExtension ,PVB_DEVICE_INFO p
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGINew_GetLCDDDCInfo( PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo)
+bool XGINew_GetLCDDDCInfo( PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT temp ;
+    unsigned short temp ;
 
     /* add lcd sense */
     if ( HwDeviceExtension->ulCRT2LCDType == LCD_UNKNOWN )
@@ -581,7 +581,7 @@ BOOLEAN XGINew_GetLCDDDCInfo( PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_I
     }
     else
     {
-        temp = ( USHORT )HwDeviceExtension->ulCRT2LCDType ;
+        temp = ( unsigned short )HwDeviceExtension->ulCRT2LCDType ;
         switch( HwDeviceExtension->ulCRT2LCDType )
         {
             case LCD_INVALID:
@@ -623,9 +623,9 @@ BOOLEAN XGINew_GetLCDDDCInfo( PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_I
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGINew_GetPanelID(PVB_DEVICE_INFO pVBInfo )
+bool XGINew_GetPanelID(PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT PanelTypeTable[ 16 ] = { SyncNN | PanelRGB18Bit | Panel800x600  | _PanelType00 ,
+    unsigned short PanelTypeTable[ 16 ] = { SyncNN | PanelRGB18Bit | Panel800x600  | _PanelType00 ,
                                     SyncNN | PanelRGB18Bit | Panel1024x768 | _PanelType01 ,
                                     SyncNN | PanelRGB18Bit | Panel800x600  | _PanelType02 ,
                                     SyncNN | PanelRGB18Bit | Panel640x480  | _PanelType03 ,
@@ -641,8 +641,8 @@ BOOLEAN XGINew_GetPanelID(PVB_DEVICE_INFO pVBInfo )
                                     SyncNN | PanelRGB24Bit | Panel1024x768 | _PanelType0D ,
                                     SyncNN | PanelRGB18Bit | Panel1024x768 | _PanelType0E ,
                                     SyncNN | PanelRGB18Bit | Panel1024x768 | _PanelType0F } ;
-    USHORT tempax , tempbx , temp ;
-    /* USHORT return_flag ; */
+    unsigned short tempax , tempbx , temp ;
+    /* unsigned short return_flag ; */
 
     tempax = XGINew_GetReg1( pVBInfo->P3c4 , 0x1A ) ;
     tempbx = tempax & 0x1E ;
@@ -695,9 +695,9 @@ BOOLEAN XGINew_GetPanelID(PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGINew_BridgeIsEnable( PXGI_HW_DEVICE_INFO HwDeviceExtension ,PVB_DEVICE_INFO pVBInfo)
+bool XGINew_BridgeIsEnable( PXGI_HW_DEVICE_INFO HwDeviceExtension ,PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT flag ;
+    unsigned short flag ;
 
     if ( XGI_BridgeIsOn( pVBInfo ) == 0 )
     {
@@ -722,9 +722,9 @@ BOOLEAN XGINew_BridgeIsEnable( PXGI_HW_DEVICE_INFO HwDeviceExtension ,PVB_DEVICE
 /* Output : */
 /* Description : */
 /* ------------------------------------------------------ */
-BOOLEAN XGINew_SenseHiTV( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo )
+bool XGINew_SenseHiTV( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempbx , tempcx , temp , i , tempch;
+    unsigned short tempbx , tempcx , temp , i , tempch;
 
     tempbx = *pVBInfo->pYCSenseData2 ;
 
@@ -806,11 +806,11 @@ BOOLEAN XGINew_SenseHiTV( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INF
 void XGI_XG21Fun14Sub70( PVB_DEVICE_INFO pVBInfo , PX86_REGS pBiosArguments )
 {
 
-    USHORT ModeIdIndex;
-    USHORT ModeNo;
+    unsigned short ModeIdIndex;
+    unsigned short ModeNo;
 
-    USHORT EModeCount;
-    USHORT lvdstableindex;
+    unsigned short EModeCount;
+    unsigned short lvdstableindex;
 
     lvdstableindex = XGI_GetLVDSOEMTableIndex( pVBInfo );
     pBiosArguments->h.bl = 0x81;
@@ -824,7 +824,7 @@ void XGI_XG21Fun14Sub70( PVB_DEVICE_INFO pVBInfo , PX86_REGS pBiosArguments )
         ModeNo = pVBInfo->EModeIDTable[ ModeIdIndex ].Ext_ModeID;
         if ( pVBInfo->EModeIDTable[ ModeIdIndex ].Ext_ModeID == 0xFF )
         {
-            pBiosArguments->h.bh = (UCHAR) EModeCount;
+            pBiosArguments->h.bh = (unsigned char) EModeCount;
             return;
         }
         if ( !XGI_XG21CheckLVDSMode( ModeNo , ModeIdIndex, pVBInfo) )
@@ -849,10 +849,10 @@ void XGI_XG21Fun14Sub70( PVB_DEVICE_INFO pVBInfo , PX86_REGS pBiosArguments )
 void XGI_XG21Fun14Sub71( PVB_DEVICE_INFO pVBInfo , PX86_REGS pBiosArguments )
 {
 
-    USHORT EModeCount;
-    USHORT ModeIdIndex,resindex;
-    USHORT ModeNo;
-    USHORT EModeIndex = pBiosArguments->h.bh;
+    unsigned short EModeCount;
+    unsigned short ModeIdIndex,resindex;
+    unsigned short ModeNo;
+    unsigned short EModeIndex = pBiosArguments->h.bh;
 
     EModeCount = 0;
     for( ModeIdIndex = 0 ; ;  ModeIdIndex ++ )
@@ -870,7 +870,7 @@ void XGI_XG21Fun14Sub71( PVB_DEVICE_INFO pVBInfo , PX86_REGS pBiosArguments )
         if (EModeCount == EModeIndex)
         {
             resindex = XGI_GetResInfo( ModeNo , ModeIdIndex, pVBInfo ) ;
-            pBiosArguments->h.bl = (UCHAR) ModeNo;
+            pBiosArguments->h.bl = (unsigned char) ModeNo;
             pBiosArguments->x.cx = pVBInfo->ModeResInfo[ resindex ].HTotal ;			  /* xres->ax */
             pBiosArguments->x.dx = pVBInfo->ModeResInfo[ resindex ].VTotal ;			  /* yres->bx */
             pBiosArguments->x.ax = 0x0014;
@@ -894,8 +894,8 @@ void XGI_XG21Fun14Sub71( PVB_DEVICE_INFO pVBInfo , PX86_REGS pBiosArguments )
 */
 void XGI_XG21Fun14Sub72( PVB_DEVICE_INFO pVBInfo , PX86_REGS pBiosArguments )
 {
-    USHORT ModeIdIndex,resindex;
-    USHORT ModeNo;
+    unsigned short ModeIdIndex,resindex;
+    unsigned short ModeNo;
 
 
     ModeNo = pBiosArguments->h.bl ;
@@ -953,9 +953,9 @@ void XGI_XG21Fun14Sub72( PVB_DEVICE_INFO pVBInfo , PX86_REGS pBiosArguments )
 */
 void XGI_XG21Fun14Sub73( PVB_DEVICE_INFO pVBInfo , PX86_REGS pBiosArguments )
 {
-    UCHAR Select;
+    unsigned char Select;
 
-    USHORT lvdstableindex;
+    unsigned short lvdstableindex;
 
     lvdstableindex = XGI_GetLVDSOEMTableIndex( pVBInfo );
     Select = pBiosArguments->h.bl;
diff --git a/drivers/staging/xgifb/vb_ext.h b/drivers/staging/xgifb/vb_ext.h
index 3a52a6a..d775f8b 100644
--- a/drivers/staging/xgifb/vb_ext.h
+++ b/drivers/staging/xgifb/vb_ext.h
@@ -2,15 +2,15 @@
 #define  _VBEXT_
 
 struct DWORDREGS {
-    ULONG    Eax, Ebx, Ecx, Edx, Esi, Edi, Ebp;
+    unsigned long    Eax, Ebx, Ecx, Edx, Esi, Edi, Ebp;
 };
 
 struct WORDREGS {
-    USHORT    ax, hi_ax, bx, hi_bx, cx, hi_cx, dx, hi_dx, si, hi_si, di ,hi_di, bp, hi_bp;
+    unsigned short    ax, hi_ax, bx, hi_bx, cx, hi_cx, dx, hi_dx, si, hi_si, di ,hi_di, bp, hi_bp;
 };
 
 struct BYTEREGS {
-    UCHAR   al, ah, hi_al, hi_ah, bl, bh, hi_bl, hi_bh, cl, ch, hi_cl, hi_ch, dl, dh, hi_dl, hi_dh;
+    unsigned char   al, ah, hi_al, hi_ah, bl, bh, hi_bl, hi_bh, cl, ch, hi_cl, hi_ch, dl, dh, hi_dl, hi_dh;
 };
 
 typedef union   _X86_REGS    {
@@ -20,10 +20,10 @@ typedef union   _X86_REGS    {
 } X86_REGS, *PX86_REGS;
 
 extern   void     XGI_XG21Fun14( PXGI_HW_DEVICE_INFO pXGIHWDE, PX86_REGS pBiosArguments);
-extern   void     XGISetDPMS( PXGI_HW_DEVICE_INFO pXGIHWDE , ULONG VESA_POWER_STATE ) ;
+extern   void     XGISetDPMS( PXGI_HW_DEVICE_INFO pXGIHWDE , unsigned long VESA_POWER_STATE ) ;
 extern   void     XGI_GetSenseStatus( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo );
 extern   void     XGINew_SetModeScratch ( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo ) ;
-extern   void 	  ReadVBIOSTablData( UCHAR ChipType , PVB_DEVICE_INFO pVBInfo);
-extern   USHORT   XGINew_SenseLCD(PXGI_HW_DEVICE_INFO,PVB_DEVICE_INFO pVBInfo);
+extern   void 	  ReadVBIOSTablData( unsigned char ChipType , PVB_DEVICE_INFO pVBInfo);
+extern   unsigned short   XGINew_SenseLCD(PXGI_HW_DEVICE_INFO,PVB_DEVICE_INFO pVBInfo);
 
 #endif
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 1b1ef8b..f2631f0 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -19,9 +19,9 @@
 
 
 
-UCHAR    XGINew_ChannelAB,XGINew_DataBusWidth;
+unsigned char    XGINew_ChannelAB,XGINew_DataBusWidth;
 
-USHORT XGINew_DRAMType[17][5]={{0x0C,0x0A,0x02,0x40,0x39},{0x0D,0x0A,0x01,0x40,0x48},
+unsigned short XGINew_DRAMType[17][5]={{0x0C,0x0A,0x02,0x40,0x39},{0x0D,0x0A,0x01,0x40,0x48},
                      {0x0C,0x09,0x02,0x20,0x35},{0x0D,0x09,0x01,0x20,0x44},
                      {0x0C,0x08,0x02,0x10,0x31},{0x0D,0x08,0x01,0x10,0x40},
                      {0x0C,0x0A,0x01,0x20,0x34},{0x0C,0x09,0x01,0x08,0x32},
@@ -31,7 +31,7 @@ USHORT XGINew_DRAMType[17][5]={{0x0C,0x0A,0x02,0x40,0x39},{0x0D,0x0A,0x01,0x40,0
                      {0x0B,0x08,0x01,0x04,0x20},{0x0A,0x08,0x01,0x02,0x10},
                      {0x09,0x08,0x01,0x01,0x00}};
 
-USHORT XGINew_SDRDRAM_TYPE[13][5]=
+unsigned short XGINew_SDRDRAM_TYPE[13][5]=
 {
 { 2,12, 9,64,0x35},
 { 1,13, 9,64,0x44},
@@ -48,21 +48,21 @@ USHORT XGINew_SDRDRAM_TYPE[13][5]=
 { 1, 9, 8, 2,0x00}
 };
 
-USHORT XGINew_DDRDRAM_TYPE[4][5]=
+unsigned short XGINew_DDRDRAM_TYPE[4][5]=
 {
 { 2,12, 9,64,0x35},
 { 2,12, 8,32,0x31},
 { 2,11, 8,16,0x21},
 { 2, 9, 8, 4,0x01}
 };
-USHORT XGINew_DDRDRAM_TYPE340[4][5]=
+unsigned short XGINew_DDRDRAM_TYPE340[4][5]=
 {
 { 2,13, 9,64,0x45},
 { 2,12, 9,32,0x35},
 { 2,12, 8,16,0x31},
 { 2,11, 8, 8,0x21}
 };
-USHORT XGINew_DDRDRAM_TYPE20[12][5]=
+unsigned short XGINew_DDRDRAM_TYPE20[12][5]=
 {
 { 2,14,11,128,0x5D},
 { 2,14,10,64,0x59},
@@ -83,9 +83,9 @@ void     XGINew_SetDRAMSize_310(PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO);
 void     XGINew_SetMemoryClock(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
 void     XGINew_SetDRAMModeRegister(PVB_DEVICE_INFO );
 void     XGINew_SetDRAMModeRegister340( PXGI_HW_DEVICE_INFO HwDeviceExtension );
-void 	 XGINew_SetDRAMDefaultRegister340(PXGI_HW_DEVICE_INFO HwDeviceExtension, ULONG, PVB_DEVICE_INFO );
-UCHAR    XGINew_GetXG20DRAMType( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGIInitNew( PXGI_HW_DEVICE_INFO HwDeviceExtension) ;
+void 	 XGINew_SetDRAMDefaultRegister340(PXGI_HW_DEVICE_INFO HwDeviceExtension, unsigned long, PVB_DEVICE_INFO );
+unsigned char    XGINew_GetXG20DRAMType( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo);
+bool  XGIInitNew( PXGI_HW_DEVICE_INFO HwDeviceExtension) ;
 
 int      XGINew_DDRSizing340( PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO );
 void     XGINew_DisableRefresh( PXGI_HW_DEVICE_INFO ,PVB_DEVICE_INFO) ;
@@ -94,20 +94,20 @@ int      XGINew_SDRSizing(PVB_DEVICE_INFO);
 int      XGINew_DDRSizing( PVB_DEVICE_INFO );
 void     XGINew_EnableRefresh( PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO);
 int      XGINew_RAMType;                  /*int      ModeIDOffset,StandTable,CRT1Table,ScreenOffset,REFIndex;*/
-ULONG	 UNIROM;			  /* UNIROM */
-BOOLEAN  ChkLFB( PVB_DEVICE_INFO );
-void     XGINew_Delay15us(ULONG);
-void     SetPowerConsume (PXGI_HW_DEVICE_INFO HwDeviceExtension,ULONG XGI_P3d4Port);
-void 	 ReadVBIOSTablData( UCHAR ChipType , PVB_DEVICE_INFO pVBInfo);
-void 	 XGINew_DDR1x_MRS_XG20( ULONG P3c4 , PVB_DEVICE_INFO pVBInfo);
+unsigned long	 UNIROM;			  /* UNIROM */
+bool  ChkLFB( PVB_DEVICE_INFO );
+void     XGINew_Delay15us(unsigned long);
+void     SetPowerConsume (PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned long XGI_P3d4Port);
+void 	 ReadVBIOSTablData( unsigned char ChipType , PVB_DEVICE_INFO pVBInfo);
+void 	 XGINew_DDR1x_MRS_XG20( unsigned long P3c4 , PVB_DEVICE_INFO pVBInfo);
 void     XGINew_SetDRAMModeRegister_XG20( PXGI_HW_DEVICE_INFO HwDeviceExtension );
 void     XGINew_SetDRAMModeRegister_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension );
 void 	 XGINew_ChkSenseStatus ( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo ) ;
 void     XGINew_SetModeScratch ( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo ) ;
 void     XGINew_GetXG21Sense(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo) ;
-UCHAR    GetXG21FPBits(PVB_DEVICE_INFO pVBInfo);
+unsigned char    GetXG21FPBits(PVB_DEVICE_INFO pVBInfo);
 void     XGINew_GetXG27Sense(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo) ;
-UCHAR    GetXG27FPBits(PVB_DEVICE_INFO pVBInfo);
+unsigned char    GetXG27FPBits(PVB_DEVICE_INFO pVBInfo);
 
 /* --------------------------------------------------------------------- */
 /* Function : XGIInitNew */
@@ -115,28 +115,28 @@ UCHAR    GetXG27FPBits(PVB_DEVICE_INFO pVBInfo);
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGIInitNew( PXGI_HW_DEVICE_INFO HwDeviceExtension )
+bool XGIInitNew( PXGI_HW_DEVICE_INFO HwDeviceExtension )
 {
 
     VB_DEVICE_INFO VBINF;
     PVB_DEVICE_INFO pVBInfo = &VBINF;
-    UCHAR   i , temp = 0 , temp1 ;
+    unsigned char   i , temp = 0 , temp1 ;
      //       VBIOSVersion[ 5 ] ;
-    PUCHAR  volatile pVideoMemory;
+    unsigned char * volatile pVideoMemory;
 
-    /* ULONG j, k ; */
+    /* unsigned long j, k ; */
 
     PXGI_DSReg pSR ;
 
-    ULONG Temp ;
+    unsigned long Temp ;
 
     pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase ;
 
     pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress ;
 
-    pVBInfo->BaseAddr = (ULONG)HwDeviceExtension->pjIOAddress ;
+    pVBInfo->BaseAddr = (unsigned long)HwDeviceExtension->pjIOAddress ;
 
-    pVideoMemory = ( PUCHAR )pVBInfo->ROMAddr;
+    pVideoMemory = ( unsigned char * )pVBInfo->ROMAddr;
 
 
 //    Newdebugcode( 0x99 ) ;
@@ -366,8 +366,8 @@ printk("15");
     XGI_UnLockCRT2( HwDeviceExtension, pVBInfo) ;
     XGINew_SetRegANDOR( pVBInfo->Part0Port , 0x3F , 0xEF , 0x00 ) ;	/* alan, disable VideoCapture */
     XGINew_SetReg1( pVBInfo->Part1Port , 0x00 , 0x00 ) ;
-    temp1 = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x7B ) ;		/* chk if BCLK>=100MHz */
-    temp = ( UCHAR )( ( temp1 >> 4 ) & 0x0F ) ;
+    temp1 = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x7B ) ;		/* chk if BCLK>=100MHz */
+    temp = ( unsigned char )( ( temp1 >> 4 ) & 0x0F ) ;
 
 
         XGINew_SetReg1( pVBInfo->Part1Port , 0x02 , ( *pVBInfo->pCRT2Data_1_2 ) ) ;
@@ -503,7 +503,7 @@ printk("22");
     /* SetDefExt2Regs begin */
 /*
     AGP = 1 ;
-    temp =( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x3A ) ;
+    temp =( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x3A ) ;
     temp &= 0x30 ;
     if ( temp == 0x30 )
         AGP = 0 ;
@@ -522,7 +522,7 @@ printk("22");
 //    Temp = ( inl( 0xcfc ) & 0xFFFF ) ;
 //    if ( Temp == 0x1039 )
 //    {
-        XGINew_SetReg1( pVBInfo->P3c4 , 0x22 , ( UCHAR )( ( *pVBInfo->pSR22 ) & 0xFE ) ) ;
+        XGINew_SetReg1( pVBInfo->P3c4 , 0x22 , ( unsigned char )( ( *pVBInfo->pSR22 ) & 0xFE ) ) ;
 //    }
 //    else
 //    {
@@ -559,9 +559,9 @@ printk("25");
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-UCHAR XGINew_GetXG20DRAMType( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo)
+unsigned char XGINew_GetXG20DRAMType( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR data, temp ;
+    unsigned char data, temp ;
 
     if ( HwDeviceExtension->jChipType < XG20 )
     {
@@ -629,9 +629,9 @@ UCHAR XGINew_GetXG20DRAMType( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-UCHAR XGINew_Get310DRAMType(PVB_DEVICE_INFO pVBInfo)
+unsigned char XGINew_Get310DRAMType(PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR data ;
+    unsigned char data ;
 
   /* index = XGINew_GetReg1( pVBInfo->P3c4 , 0x1A ) ; */
   /* index &= 07 ; */
@@ -653,7 +653,7 @@ UCHAR XGINew_Get310DRAMType(PVB_DEVICE_INFO pVBInfo)
 /* Description : */
 /* --------------------------------------------------------------------- */
 /*
-void XGINew_Delay15us(ULONG ulMicrsoSec)
+void XGINew_Delay15us(unsigned long ulMicrsoSec)
 {
 }
 */
@@ -667,7 +667,7 @@ void XGINew_Delay15us(ULONG ulMicrsoSec)
 /* --------------------------------------------------------------------- */
 void XGINew_SDR_MRS(  PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT data ;
+    unsigned short data ;
 
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x16 ) ;
     data &= 0x3F ;          /* SR16 D7=0,D6=0 */
@@ -685,7 +685,7 @@ void XGINew_SDR_MRS(  PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_DDR1x_MRS_340( ULONG P3c4 , PVB_DEVICE_INFO pVBInfo)
+void XGINew_DDR1x_MRS_340( unsigned long P3c4 , PVB_DEVICE_INFO pVBInfo)
 {
     XGINew_SetReg1( P3c4 , 0x18 , 0x01 ) ;
     XGINew_SetReg1( P3c4 , 0x19 , 0x20 ) ;
@@ -723,7 +723,7 @@ void XGINew_DDR1x_MRS_340( ULONG P3c4 , PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_DDR2x_MRS_340( ULONG P3c4 , PVB_DEVICE_INFO pVBInfo)
+void XGINew_DDR2x_MRS_340( unsigned long P3c4 , PVB_DEVICE_INFO pVBInfo)
 {
     XGINew_SetReg1( P3c4 , 0x18 , 0x00 ) ;
     XGINew_SetReg1( P3c4 , 0x19 , 0x20 ) ;
@@ -752,9 +752,9 @@ void XGINew_DDR2x_MRS_340( ULONG P3c4 , PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_DDRII_Bootup_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3c4 , PVB_DEVICE_INFO pVBInfo)
+void XGINew_DDRII_Bootup_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  unsigned long P3c4 , PVB_DEVICE_INFO pVBInfo)
 {
-    ULONG P3d4 = P3c4 + 0x10 ;
+    unsigned long P3d4 = P3c4 + 0x10 ;
     XGINew_RAMType = ( int )XGINew_GetXG20DRAMType( HwDeviceExtension , pVBInfo ) ;
     XGINew_SetMemoryClock( HwDeviceExtension , pVBInfo ) ;
 
@@ -830,9 +830,9 @@ void XGINew_DDRII_Bootup_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_DDR2_MRS_XG20( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3c4 , PVB_DEVICE_INFO pVBInfo)
+void XGINew_DDR2_MRS_XG20( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  unsigned long P3c4 , PVB_DEVICE_INFO pVBInfo)
 {
-    ULONG P3d4 = P3c4 + 0x10 ;
+    unsigned long P3d4 = P3c4 + 0x10 ;
 
     XGINew_RAMType = ( int )XGINew_GetXG20DRAMType( HwDeviceExtension , pVBInfo ) ;
     XGINew_SetMemoryClock( HwDeviceExtension , pVBInfo ) ;
@@ -882,9 +882,9 @@ void XGINew_DDR2_MRS_XG20( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3c4 ,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_DDR2_MRS_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3c4 , PVB_DEVICE_INFO pVBInfo)
+void XGINew_DDR2_MRS_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  unsigned long P3c4 , PVB_DEVICE_INFO pVBInfo)
 {
-    ULONG P3d4 = P3c4 + 0x10 ;
+    unsigned long P3d4 = P3c4 + 0x10 ;
 
      XGINew_RAMType = ( int )XGINew_GetXG20DRAMType( HwDeviceExtension , pVBInfo ) ;
      XGINew_SetMemoryClock( HwDeviceExtension , pVBInfo ) ;
@@ -960,9 +960,9 @@ void XGINew_DDR2_MRS_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3c4 ,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_DDR1x_DefaultRegister( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG Port , PVB_DEVICE_INFO pVBInfo)
+void XGINew_DDR1x_DefaultRegister( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  unsigned long Port , PVB_DEVICE_INFO pVBInfo)
 {
-    ULONG P3d4 = Port ,
+    unsigned long P3d4 = Port ,
            P3c4 = Port - 0x10 ;
 
     if ( HwDeviceExtension->jChipType >= XG20 )
@@ -1020,9 +1020,9 @@ void XGINew_DDR1x_DefaultRegister( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULON
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_DDR2x_DefaultRegister( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG Port ,PVB_DEVICE_INFO pVBInfo)
+void XGINew_DDR2x_DefaultRegister( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  unsigned long Port ,PVB_DEVICE_INFO pVBInfo)
 {
-    ULONG P3d4 = Port ,
+    unsigned long P3d4 = Port ,
            P3c4 = Port - 0x10 ;
 
     XGINew_SetMemoryClock( HwDeviceExtension , pVBInfo ) ;
@@ -1071,9 +1071,9 @@ void XGINew_DDR2x_DefaultRegister( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULON
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_DDR2_DefaultRegister( PXGI_HW_DEVICE_INFO HwDeviceExtension, ULONG Port , PVB_DEVICE_INFO pVBInfo)
+void XGINew_DDR2_DefaultRegister( PXGI_HW_DEVICE_INFO HwDeviceExtension, unsigned long Port , PVB_DEVICE_INFO pVBInfo)
 {
-    ULONG P3d4 = Port ,
+    unsigned long P3d4 = Port ,
            P3c4 = Port - 0x10 ;
 
     /* keep following setting sequence, each setting in the same reg insert idle */
@@ -1109,12 +1109,12 @@ void XGINew_DDR2_DefaultRegister( PXGI_HW_DEVICE_INFO HwDeviceExtension, ULONG P
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_SetDRAMDefaultRegister340( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG Port , PVB_DEVICE_INFO pVBInfo)
+void XGINew_SetDRAMDefaultRegister340( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  unsigned long Port , PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR temp , temp1 , temp2 , temp3 ,
+    unsigned char temp , temp1 , temp2 , temp3 ,
           i , j , k ;
 
-    ULONG P3d4 = Port ,
+    unsigned long P3d4 = Port ,
            P3c4 = Port - 0x10 ;
 
     XGINew_SetReg1( P3d4 , 0x6D , pVBInfo->CR40[ 8 ][ XGINew_RAMType ] ) ;
@@ -1254,9 +1254,9 @@ void XGINew_SetDRAMDefaultRegister340( PXGI_HW_DEVICE_INFO HwDeviceExtension ,
 /* --------------------------------------------------------------------- */
 void XGINew_DDR_MRS(PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT data ;
+    unsigned short data ;
 
-    PUCHAR volatile pVideoMemory = ( PUCHAR )pVBInfo->ROMAddr ;
+    unsigned char * volatile pVideoMemory = ( unsigned char * )pVBInfo->ROMAddr ;
 
     /* SR16 <- 1F,DF,2F,AF */
     /* yriver modified SR16 <- 0F,DF,0F,AF */
@@ -1322,9 +1322,9 @@ void XGINew_DDR_MRS(PVB_DEVICE_INFO pVBInfo)
 /* --------------------------------------------------------------------- */
 void XGINew_VerifyMclk( PXGI_HW_DEVICE_INFO  HwDeviceExtension , PVB_DEVICE_INFO pVBInfo)
 {
-    PUCHAR pVideoMemory = pVBInfo->FBAddr ;
-    UCHAR i , j ;
-    USHORT Temp , SR21 ;
+    unsigned char * pVideoMemory = pVBInfo->FBAddr ;
+    unsigned char i , j ;
+    unsigned short Temp , SR21 ;
 
     pVideoMemory[ 0 ] = 0xaa ; 		/* alan */
     pVideoMemory[ 16 ] = 0x55 ; 	/* note: PCI read cache is off */
@@ -1368,7 +1368,7 @@ void XGINew_VerifyMclk( PXGI_HW_DEVICE_INFO  HwDeviceExtension , PVB_DEVICE_INFO
 /* --------------------------------------------------------------------- */
 void XGINew_SetDRAMSize_340( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT  data ;
+    unsigned short  data ;
 
     pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase ;
     pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress ;
@@ -1377,7 +1377,7 @@ void XGINew_SetDRAMSize_340( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_
 
 
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x21 ) ;
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x21 , ( USHORT )( data & 0xDF ) ) ;	/* disable read cache */
+    XGINew_SetReg1( pVBInfo->P3c4 , 0x21 , ( unsigned short )( data & 0xDF ) ) ;	/* disable read cache */
     XGI_DisplayOff( HwDeviceExtension, pVBInfo );
 
     /*data = XGINew_GetReg1( pVBInfo->P3c4 , 0x1 ) ;*/
@@ -1385,7 +1385,7 @@ void XGINew_SetDRAMSize_340( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_
     /*XGINew_SetReg1( pVBInfo->P3c4 , 0x01 , data ) ;*/			/* Turn OFF Display */
     XGINew_DDRSizing340( HwDeviceExtension, pVBInfo ) ;
     data=XGINew_GetReg1( pVBInfo->P3c4 , 0x21 ) ;
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x21 , ( USHORT )( data | 0x20 ) ) ;	/* enable read cache */
+    XGINew_SetReg1( pVBInfo->P3c4 , 0x21 , ( unsigned short )( data | 0x20 ) ) ;	/* enable read cache */
 
 }
 
@@ -1398,7 +1398,7 @@ void XGINew_SetDRAMSize_340( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_
 /* --------------------------------------------------------------------- */
 void XGINew_SetDRAMSize_310( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT data ;
+    unsigned short data ;
     pVBInfo->ROMAddr  = HwDeviceExtension->pjVirtualRomBase ,
     pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress ;
 #ifdef XGI301
@@ -1414,7 +1414,7 @@ void XGINew_SetDRAMSize_310( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_
     XGISetModeNew( HwDeviceExtension , 0x2e ) ;
 
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x21 ) ;
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x21 , ( USHORT )( data & 0xDF ) ) ;	/* disable read cache */
+    XGINew_SetReg1( pVBInfo->P3c4 , 0x21 , ( unsigned short )( data & 0xDF ) ) ;	/* disable read cache */
 
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x1 ) ;
     data |= 0x20 ;
@@ -1423,7 +1423,7 @@ void XGINew_SetDRAMSize_310( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x16 ) ;
 
 
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x16 , ( USHORT )( data | 0x0F ) ) ;		/* assume lowest speed DRAM */
+    XGINew_SetReg1( pVBInfo->P3c4 , 0x16 , ( unsigned short )( data | 0x0F ) ) ;		/* assume lowest speed DRAM */
 
     XGINew_SetDRAMModeRegister( pVBInfo ) ;
     XGINew_DisableRefresh( HwDeviceExtension, pVBInfo ) ;
@@ -1448,7 +1448,7 @@ void XGINew_SetDRAMSize_310( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_
 
     XGINew_EnableRefresh(  HwDeviceExtension, pVBInfo ) ;
     data=XGINew_GetReg1( pVBInfo->P3c4 ,0x21 ) ;
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x21 , ( USHORT )( data | 0x20 ) ) ;	/* enable read cache */
+    XGINew_SetReg1( pVBInfo->P3c4 , 0x21 , ( unsigned short )( data | 0x20 ) ) ;	/* enable read cache */
 }
 
 
@@ -1462,12 +1462,12 @@ void XGINew_SetDRAMSize_310( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_
 
 void XGINew_SetDRAMModeRegister340( PXGI_HW_DEVICE_INFO HwDeviceExtension )
 {
-    UCHAR data ;
+    unsigned char data ;
     VB_DEVICE_INFO VBINF;
     PVB_DEVICE_INFO pVBInfo = &VBINF;
     pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase ;
     pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress ;
-    pVBInfo->BaseAddr = (ULONG)HwDeviceExtension->pjIOAddress ;
+    pVBInfo->BaseAddr = (unsigned long)HwDeviceExtension->pjIOAddress ;
     pVBInfo->ISXPDOS = 0 ;
 
     pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14 ;
@@ -1536,7 +1536,7 @@ void XGINew_SetDRAMModeRegister( PVB_DEVICE_INFO pVBInfo)
 /* --------------------------------------------------------------------- */
 void XGINew_DisableRefresh( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT  data ;
+    unsigned short  data ;
 
 
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x1B ) ;
@@ -1567,9 +1567,9 @@ void XGINew_EnableRefresh( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_IN
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_DisableChannelInterleaving( int index , USHORT XGINew_DDRDRAM_TYPE[][ 5 ] , PVB_DEVICE_INFO pVBInfo)
+void XGINew_DisableChannelInterleaving( int index , unsigned short XGINew_DDRDRAM_TYPE[][ 5 ] , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT data ;
+    unsigned short data ;
 
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x15 ) ;
     data &= 0x1F ;
@@ -1601,9 +1601,9 @@ void XGINew_DisableChannelInterleaving( int index , USHORT XGINew_DDRDRAM_TYPE[]
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_SetDRAMSizingType( int index , USHORT DRAMTYPE_TABLE[][ 5 ] ,PVB_DEVICE_INFO pVBInfo)
+void XGINew_SetDRAMSizingType( int index , unsigned short DRAMTYPE_TABLE[][ 5 ] ,PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT data ;
+    unsigned short data ;
 
     data = DRAMTYPE_TABLE[ index ][ 4 ] ;
     XGINew_SetRegANDOR( pVBInfo->P3c4 , 0x13 , 0x80 , data ) ;
@@ -1620,10 +1620,10 @@ void XGINew_SetDRAMSizingType( int index , USHORT DRAMTYPE_TABLE[][ 5 ] ,PVB_DEV
 /* --------------------------------------------------------------------- */
 void XGINew_CheckBusWidth_310(  PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT data ;
-    PULONG volatile pVideoMemory ;
+    unsigned short data ;
+    unsigned long * volatile pVideoMemory ;
 
-    pVideoMemory = (PULONG) pVBInfo->FBAddr;
+    pVideoMemory = (unsigned long *) pVBInfo->FBAddr;
 
     if ( XGINew_Get310DRAMType( pVBInfo ) < 2 )
     {
@@ -1649,7 +1649,7 @@ void XGINew_CheckBusWidth_310(  PVB_DEVICE_INFO pVBInfo)
             XGINew_DataBusWidth = 64 ;
             XGINew_ChannelAB = 0 ;
             data=XGINew_GetReg1( pVBInfo->P3c4 , 0x14 ) ;
-            XGINew_SetReg1( pVBInfo->P3c4 , 0x14 , ( USHORT )( data & 0xFD ) ) ;
+            XGINew_SetReg1( pVBInfo->P3c4 , 0x14 , ( unsigned short )( data & 0xFD ) ) ;
         }
 
         if ( ( pVideoMemory[ 1 ] != 0x456789ABL ) || ( pVideoMemory[ 0 ] != 0x01234567L ) )
@@ -1658,7 +1658,7 @@ void XGINew_CheckBusWidth_310(  PVB_DEVICE_INFO pVBInfo)
             XGINew_DataBusWidth = 64 ;
             XGINew_ChannelAB = 1 ;
             data=XGINew_GetReg1( pVBInfo->P3c4 , 0x14 ) ;
-            XGINew_SetReg1( pVBInfo->P3c4 , 0x14 , ( USHORT )( ( data & 0xFD ) | 0x01 ) ) ;
+            XGINew_SetReg1( pVBInfo->P3c4 , 0x14 , ( unsigned short )( ( data & 0xFD ) | 0x01 ) ) ;
         }
 
         return ;
@@ -1751,9 +1751,9 @@ void XGINew_CheckBusWidth_310(  PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-int XGINew_SetRank( int index , UCHAR RankNo , UCHAR XGINew_ChannelAB , USHORT DRAMTYPE_TABLE[][ 5 ] , PVB_DEVICE_INFO pVBInfo)
+int XGINew_SetRank( int index , unsigned char RankNo , unsigned char XGINew_ChannelAB , unsigned short DRAMTYPE_TABLE[][ 5 ] , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT data ;
+    unsigned short data ;
     int RankSize ;
 
     if ( ( RankNo == 2 ) && ( DRAMTYPE_TABLE[ index ][ 0 ] == 2 ) )
@@ -1788,9 +1788,9 @@ int XGINew_SetRank( int index , UCHAR RankNo , UCHAR XGINew_ChannelAB , USHORT D
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-int XGINew_SetDDRChannel( int index , UCHAR ChannelNo , UCHAR XGINew_ChannelAB , USHORT DRAMTYPE_TABLE[][ 5 ] , PVB_DEVICE_INFO pVBInfo)
+int XGINew_SetDDRChannel( int index , unsigned char ChannelNo , unsigned char XGINew_ChannelAB , unsigned short DRAMTYPE_TABLE[][ 5 ] , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT  data ;
+    unsigned short  data ;
     int RankSize ;
 
     RankSize = DRAMTYPE_TABLE[index][3]/2 * XGINew_DataBusWidth/32;
@@ -1824,24 +1824,24 @@ int XGINew_SetDDRChannel( int index , UCHAR ChannelNo , UCHAR XGINew_ChannelAB ,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-int XGINew_CheckColumn( int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
+int XGINew_CheckColumn( int index , unsigned short DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
 {
     int i ;
-    ULONG Increment , Position ;
+    unsigned long Increment , Position ;
 
     /* Increment = 1 << ( DRAMTYPE_TABLE[ index ][ 2 ] + XGINew_DataBusWidth / 64 + 1 ) ; */
     Increment = 1 << ( 10 + XGINew_DataBusWidth / 64 ) ;
 
     for( i = 0 , Position = 0 ; i < 2 ; i++ )
     {
-        *( ( PULONG )( pVBInfo->FBAddr + Position ) ) = Position ;
+        *( ( unsigned long * )( pVBInfo->FBAddr + Position ) ) = Position ;
         Position += Increment ;
     }
 
     for( i = 0 , Position = 0 ; i < 2 ; i++ )
     {
         /* if ( pVBInfo->FBAddr[ Position ] != Position ) */
-        if ( ( *( PULONG )( pVBInfo->FBAddr + Position ) ) != Position )
+        if ( ( *( unsigned long * )( pVBInfo->FBAddr + Position ) ) != Position )
             return( 0 ) ;
         Position += Increment ;
     }
@@ -1855,24 +1855,24 @@ int XGINew_CheckColumn( int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INF
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-int XGINew_CheckBanks( int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
+int XGINew_CheckBanks( int index , unsigned short DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
 {
     int i ;
-    ULONG Increment , Position ;
+    unsigned long Increment , Position ;
 
     Increment = 1 << ( DRAMTYPE_TABLE[ index ][ 2 ] + XGINew_DataBusWidth / 64 + 2 ) ;
 
     for( i = 0 , Position = 0 ; i < 4 ; i++ )
     {
         /* pVBInfo->FBAddr[ Position ] = Position ; */
-        *( ( PULONG )( pVBInfo->FBAddr + Position ) ) = Position ;
+        *( ( unsigned long * )( pVBInfo->FBAddr + Position ) ) = Position ;
         Position += Increment ;
     }
 
     for( i = 0 , Position = 0 ; i < 4 ; i++ )
     {
         /* if (pVBInfo->FBAddr[ Position ] != Position ) */
-        if ( ( *( PULONG )( pVBInfo->FBAddr + Position ) ) != Position )
+        if ( ( *( unsigned long * )( pVBInfo->FBAddr + Position ) ) != Position )
             return( 0 ) ;
         Position += Increment ;
     }
@@ -1886,10 +1886,10 @@ int XGINew_CheckBanks( int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-int XGINew_CheckRank( int RankNo , int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
+int XGINew_CheckRank( int RankNo , int index , unsigned short DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
 {
     int i ;
-    ULONG Increment , Position ;
+    unsigned long Increment , Position ;
 
     Increment = 1 << ( DRAMTYPE_TABLE[ index ][ 2 ] + DRAMTYPE_TABLE[ index ][ 1 ] +
                   DRAMTYPE_TABLE[ index ][ 0 ] + XGINew_DataBusWidth / 64 + RankNo ) ;
@@ -1897,16 +1897,16 @@ int XGINew_CheckRank( int RankNo , int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB
     for( i = 0 , Position = 0 ; i < 2 ; i++ )
     {
         /* pVBInfo->FBAddr[ Position ] = Position ; */
-        /* *( ( PULONG )( pVBInfo->FBAddr ) ) = Position ; */
-        *( ( PULONG )( pVBInfo->FBAddr + Position ) ) = Position ;
+        /* *( ( unsigned long * )( pVBInfo->FBAddr ) ) = Position ; */
+        *( ( unsigned long * )( pVBInfo->FBAddr + Position ) ) = Position ;
         Position += Increment ;
     }
 
     for( i = 0 , Position = 0 ; i < 2 ; i++ )
     {
         /* if ( pVBInfo->FBAddr[ Position ] != Position ) */
-        /* if ( ( *( PULONG )( pVBInfo->FBAddr ) ) != Position ) */
-        if ( ( *( PULONG )( pVBInfo->FBAddr + Position ) ) != Position )
+        /* if ( ( *( unsigned long * )( pVBInfo->FBAddr ) ) != Position ) */
+        if ( ( *( unsigned long * )( pVBInfo->FBAddr + Position ) ) != Position )
             return( 0 ) ;
         Position += Increment ;
     }
@@ -1920,10 +1920,10 @@ int XGINew_CheckRank( int RankNo , int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-int XGINew_CheckDDRRank( int RankNo , int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
+int XGINew_CheckDDRRank( int RankNo , int index , unsigned short DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
 {
-    ULONG Increment , Position ;
-    USHORT data ;
+    unsigned long Increment , Position ;
+    unsigned short data ;
 
     Increment = 1 << ( DRAMTYPE_TABLE[ index ][ 2 ] + DRAMTYPE_TABLE[ index ][ 1 ] +
                        DRAMTYPE_TABLE[ index ][ 0 ] + XGINew_DataBusWidth / 64 + RankNo ) ;
@@ -1931,17 +1931,17 @@ int XGINew_CheckDDRRank( int RankNo , int index , USHORT DRAMTYPE_TABLE[][ 5 ],
     Increment += Increment / 2 ;
 
     Position = 0;
-    *( ( PULONG )( pVBInfo->FBAddr + Position + 0 ) ) = 0x01234567 ;
-    *( ( PULONG )( pVBInfo->FBAddr + Position + 1 ) ) = 0x456789AB ;
-    *( ( PULONG )( pVBInfo->FBAddr + Position + 2 ) ) = 0x55555555 ;
-    *( ( PULONG )( pVBInfo->FBAddr + Position + 3 ) ) = 0x55555555 ;
-    *( ( PULONG )( pVBInfo->FBAddr + Position + 4 ) ) = 0xAAAAAAAA ;
-    *( ( PULONG )( pVBInfo->FBAddr + Position + 5 ) ) = 0xAAAAAAAA ;
-
-    if ( ( *( PULONG )( pVBInfo->FBAddr + 1 ) ) == 0x456789AB )
+    *( ( unsigned long * )( pVBInfo->FBAddr + Position + 0 ) ) = 0x01234567 ;
+    *( ( unsigned long * )( pVBInfo->FBAddr + Position + 1 ) ) = 0x456789AB ;
+    *( ( unsigned long * )( pVBInfo->FBAddr + Position + 2 ) ) = 0x55555555 ;
+    *( ( unsigned long * )( pVBInfo->FBAddr + Position + 3 ) ) = 0x55555555 ;
+    *( ( unsigned long * )( pVBInfo->FBAddr + Position + 4 ) ) = 0xAAAAAAAA ;
+    *( ( unsigned long * )( pVBInfo->FBAddr + Position + 5 ) ) = 0xAAAAAAAA ;
+
+    if ( ( *( unsigned long * )( pVBInfo->FBAddr + 1 ) ) == 0x456789AB )
         return( 1 ) ;
 
-    if ( ( *( PULONG )( pVBInfo->FBAddr + 0 ) ) == 0x01234567 )
+    if ( ( *( unsigned long * )( pVBInfo->FBAddr + 0 ) ) == 0x01234567 )
         return( 0 ) ;
 
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x14 ) ;
@@ -1962,7 +1962,7 @@ int XGINew_CheckDDRRank( int RankNo , int index , USHORT DRAMTYPE_TABLE[][ 5 ],
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-int XGINew_CheckRanks( int RankNo , int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
+int XGINew_CheckRanks( int RankNo , int index , unsigned short DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
 {
     int r ;
 
@@ -1988,7 +1988,7 @@ int XGINew_CheckRanks( int RankNo , int index , USHORT DRAMTYPE_TABLE[][ 5 ], PV
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-int XGINew_CheckDDRRanks( int RankNo , int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
+int XGINew_CheckDDRRanks( int RankNo , int index , unsigned short DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
 {
     int r ;
 
@@ -2017,7 +2017,7 @@ int XGINew_CheckDDRRanks( int RankNo , int index , USHORT DRAMTYPE_TABLE[][ 5 ],
 int XGINew_SDRSizing(PVB_DEVICE_INFO pVBInfo)
 {
     int    i ;
-    UCHAR  j ;
+    unsigned char  j ;
 
     for( i = 0 ; i < 13 ; i++ )
     {
@@ -2025,7 +2025,7 @@ int XGINew_SDRSizing(PVB_DEVICE_INFO pVBInfo)
 
         for( j = 2 ; j > 0 ; j-- )
         {
-            if ( !XGINew_SetRank( i , ( UCHAR )j , XGINew_ChannelAB , XGINew_SDRDRAM_TYPE , pVBInfo) )
+            if ( !XGINew_SetRank( i , ( unsigned char )j , XGINew_ChannelAB , XGINew_SDRDRAM_TYPE , pVBInfo) )
                 continue ;
             else
             {
@@ -2044,11 +2044,11 @@ int XGINew_SDRSizing(PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-USHORT XGINew_SetDRAMSizeReg( int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
+unsigned short XGINew_SetDRAMSizeReg( int index , unsigned short DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT data = 0 , memsize = 0 ;
+    unsigned short data = 0 , memsize = 0 ;
     int RankSize ;
-    UCHAR ChannelNo ;
+    unsigned char ChannelNo ;
 
     RankSize = DRAMTYPE_TABLE[ index ][ 3 ] * XGINew_DataBusWidth / 32 ;
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x13 ) ;
@@ -2093,11 +2093,11 @@ USHORT XGINew_SetDRAMSizeReg( int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVI
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-USHORT XGINew_SetDRAMSize20Reg( int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
+unsigned short XGINew_SetDRAMSize20Reg( int index , unsigned short DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT data = 0 , memsize = 0 ;
+    unsigned short data = 0 , memsize = 0 ;
     int RankSize ;
-    UCHAR ChannelNo ;
+    unsigned char ChannelNo ;
 
     RankSize = DRAMTYPE_TABLE[ index ][ 3 ] * XGINew_DataBusWidth / 8 ;
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x13 ) ;
@@ -2143,30 +2143,30 @@ USHORT XGINew_SetDRAMSize20Reg( int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DE
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-int XGINew_ReadWriteRest( USHORT StopAddr , USHORT StartAddr, PVB_DEVICE_INFO pVBInfo)
+int XGINew_ReadWriteRest( unsigned short StopAddr , unsigned short StartAddr, PVB_DEVICE_INFO pVBInfo)
 {
     int i ;
-    ULONG Position = 0 ;
+    unsigned long Position = 0 ;
 
-   *( ( PULONG )( pVBInfo->FBAddr + Position ) ) = Position ;
+   *( ( unsigned long * )( pVBInfo->FBAddr + Position ) ) = Position ;
 
     for( i = StartAddr ; i <= StopAddr ; i++ )
     {
         Position = 1 << i ;
-        *( ( PULONG )( pVBInfo->FBAddr + Position ) ) = Position ;
+        *( ( unsigned long * )( pVBInfo->FBAddr + Position ) ) = Position ;
     }
 
     udelay( 500 ) ;	/* [Vicent] 2004/04/16. Fix #1759 Memory Size error in Multi-Adapter. */
 
     Position = 0 ;
 
-   if ( ( *( PULONG )( pVBInfo->FBAddr + Position ) ) != Position )
+   if ( ( *( unsigned long * )( pVBInfo->FBAddr + Position ) ) != Position )
         return( 0 ) ;
 
     for( i = StartAddr ; i <= StopAddr ; i++ )
     {
         Position = 1 << i ;
-        if ( ( *( PULONG )( pVBInfo->FBAddr + Position ) ) != Position )
+        if ( ( *( unsigned long * )( pVBInfo->FBAddr + Position ) ) != Position )
             return( 0 ) ;
     }
     return( 1 ) ;
@@ -2179,9 +2179,9 @@ int XGINew_ReadWriteRest( USHORT StopAddr , USHORT StartAddr, PVB_DEVICE_INFO pV
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-UCHAR XGINew_CheckFrequence( PVB_DEVICE_INFO pVBInfo )
+unsigned char XGINew_CheckFrequence( PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR data ;
+    unsigned char data ;
 
     data = XGINew_GetReg1( pVBInfo->P3d4 , 0x97 ) ;
 
@@ -2204,7 +2204,7 @@ UCHAR XGINew_CheckFrequence( PVB_DEVICE_INFO pVBInfo )
 /* --------------------------------------------------------------------- */
 void XGINew_CheckChannel( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR data;
+    unsigned char data;
 
     switch( HwDeviceExtension->jChipType )
     {
@@ -2486,7 +2486,7 @@ void XGINew_CheckChannel( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 int XGINew_DDRSizing340( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
 {
     int i ;
-    USHORT memsize , addr ;
+    unsigned short memsize , addr ;
 
     XGINew_SetReg1( pVBInfo->P3c4 , 0x15 , 0x00 ) ;	/* noninterleaving */
     XGINew_SetReg1( pVBInfo->P3c4 , 0x1C , 0x00 ) ;	/* nontiling */
@@ -2503,7 +2503,7 @@ int XGINew_DDRSizing340( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
             continue ;
 
         addr = memsize + ( XGINew_ChannelAB - 2 ) + 20 ;
-        if ( ( HwDeviceExtension->ulVideoMemorySize - 1 ) < ( ULONG )( 1 << addr ) )
+        if ( ( HwDeviceExtension->ulVideoMemorySize - 1 ) < ( unsigned long )( 1 << addr ) )
             continue ;
 
         if ( XGINew_ReadWriteRest( addr , 5, pVBInfo ) == 1 )
@@ -2521,7 +2521,7 @@ int XGINew_DDRSizing340( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
             continue ;
 
         addr = memsize + ( XGINew_ChannelAB - 2 ) + 20 ;
-        if ( ( HwDeviceExtension->ulVideoMemorySize - 1 ) < ( ULONG )( 1 << addr ) )
+        if ( ( HwDeviceExtension->ulVideoMemorySize - 1 ) < ( unsigned long )( 1 << addr ) )
             continue ;
 
         if ( XGINew_ReadWriteRest( addr , 9, pVBInfo ) == 1 )
@@ -2541,7 +2541,7 @@ int XGINew_DDRSizing340( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 int XGINew_DDRSizing(PVB_DEVICE_INFO pVBInfo)
 {
     int    i ;
-    UCHAR  j ;
+    unsigned char  j ;
 
     for( i = 0 ; i < 4 ; i++ )
     {
@@ -2550,7 +2550,7 @@ int XGINew_DDRSizing(PVB_DEVICE_INFO pVBInfo)
         for( j = 2 ; j > 0 ; j-- )
         {
             XGINew_SetDDRChannel( i , j , XGINew_ChannelAB , XGINew_DDRDRAM_TYPE , pVBInfo ) ;
-            if ( !XGINew_SetRank( i , ( UCHAR )j , XGINew_ChannelAB , XGINew_DDRDRAM_TYPE, pVBInfo ) )
+            if ( !XGINew_SetRank( i , ( unsigned char )j , XGINew_ChannelAB , XGINew_DDRDRAM_TYPE, pVBInfo ) )
                 continue ;
             else
             {
@@ -2590,7 +2590,7 @@ void XGINew_SetMemoryClock( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_IN
         && ( ( ( pVBInfo->ECLKData[ XGINew_RAMType ].SR2E == 0x1C ) && ( pVBInfo->ECLKData[ XGINew_RAMType ].SR2F == 0x01 ) )
         || ( ( pVBInfo->ECLKData[ XGINew_RAMType ].SR2E == 0x22 ) && ( pVBInfo->ECLKData[ XGINew_RAMType ].SR2F == 0x01 ) ) ) )
       {
-      	XGINew_SetReg1( pVBInfo->P3c4 , 0x32 , ( ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x32 ) & 0xFC ) | 0x02 ) ;
+      	XGINew_SetReg1( pVBInfo->P3c4 , 0x32 , ( ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x32 ) & 0xFC ) | 0x02 ) ;
       }
     }
 }
@@ -2602,7 +2602,7 @@ void XGINew_SetMemoryClock( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_IN
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN ChkLFB( PVB_DEVICE_INFO pVBInfo )
+bool ChkLFB( PVB_DEVICE_INFO pVBInfo )
 {
     if ( LFBDRAMTrap & XGINew_GetReg1( pVBInfo->P3d4 , 0x78 ) )
         return( TRUE ) ;
@@ -2619,17 +2619,17 @@ BOOLEAN ChkLFB( PVB_DEVICE_INFO pVBInfo )
 /* in second chip, assume CR A1 D[6]="1" in this case */
 /* output : none */
 /* --------------------------------------------------------------------- */
-void SetPowerConsume ( PXGI_HW_DEVICE_INFO HwDeviceExtension , ULONG XGI_P3d4Port )
+void SetPowerConsume ( PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned long XGI_P3d4Port )
 {
-    ULONG   lTemp ;
-    UCHAR   bTemp;
+    unsigned long   lTemp ;
+    unsigned char   bTemp;
 
     HwDeviceExtension->pQueryVGAConfigSpace( HwDeviceExtension , 0x08 , 0 , &lTemp ) ; /* Get */
     if ((lTemp&0xFF)==0)
     {
         /* set CR58 D[5]=0 D[3]=0 */
         XGINew_SetRegAND( XGI_P3d4Port , 0x58 , 0xD7 ) ;
-        bTemp = (UCHAR) XGINew_GetReg1( XGI_P3d4Port , 0xCB ) ;
+        bTemp = (unsigned char) XGINew_GetReg1( XGI_P3d4Port , 0xCB ) ;
     	if (bTemp&0x20)
     	{
             if (!(bTemp&0x10))
@@ -2651,10 +2651,10 @@ void SetPowerConsume ( PXGI_HW_DEVICE_INFO HwDeviceExtension , ULONG XGI_P3d4Por
 void XGINew_InitVBIOSData(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
 {
 
-	/* ULONG ROMAddr = (ULONG)HwDeviceExtension->pjVirtualRomBase; */
+	/* unsigned long ROMAddr = (unsigned long)HwDeviceExtension->pjVirtualRomBase; */
     pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase ;
     pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress ;
-    pVBInfo->BaseAddr = (ULONG)HwDeviceExtension->pjIOAddress ;
+    pVBInfo->BaseAddr = (unsigned long)HwDeviceExtension->pjIOAddress ;
     pVBInfo->ISXPDOS = 0 ;
 
     pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14 ;
@@ -2697,13 +2697,13 @@ void XGINew_InitVBIOSData(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void ReadVBIOSTablData( UCHAR ChipType , PVB_DEVICE_INFO pVBInfo)
+void ReadVBIOSTablData( unsigned char ChipType , PVB_DEVICE_INFO pVBInfo)
 {
-    PUCHAR  volatile pVideoMemory = ( PUCHAR )pVBInfo->ROMAddr ;
-    ULONG   i ;
-    UCHAR   j , k ;
+    unsigned char *  volatile pVideoMemory = ( unsigned char * )pVBInfo->ROMAddr ;
+    unsigned long   i ;
+    unsigned char   j , k ;
 #if 0
-    ULONG   ii , jj ;
+    unsigned long   ii , jj ;
     i = pVideoMemory[ 0x1CF ] | ( pVideoMemory[ 0x1D0 ] << 8 ) ;		/* UniROM */
     if ( i != 0 )
         UNIROM = 1 ;
@@ -2956,7 +2956,7 @@ void ReadVBIOSTablData( UCHAR ChipType , PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_DDR1x_MRS_XG20( ULONG P3c4 , PVB_DEVICE_INFO pVBInfo)
+void XGINew_DDR1x_MRS_XG20( unsigned long P3c4 , PVB_DEVICE_INFO pVBInfo)
 {
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x01 ) ;
@@ -2998,7 +2998,7 @@ void XGINew_SetDRAMModeRegister_XG20( PXGI_HW_DEVICE_INFO HwDeviceExtension )
     PVB_DEVICE_INFO pVBInfo = &VBINF;
     pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase ;
     pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress ;
-    pVBInfo->BaseAddr = (ULONG)HwDeviceExtension->pjIOAddress ;
+    pVBInfo->BaseAddr = (unsigned long)HwDeviceExtension->pjIOAddress ;
     pVBInfo->ISXPDOS = 0 ;
 
     pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14 ;
@@ -3037,7 +3037,7 @@ void XGINew_SetDRAMModeRegister_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension )
     PVB_DEVICE_INFO pVBInfo = &VBINF;
     pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase ;
     pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress ;
-    pVBInfo->BaseAddr = (ULONG)HwDeviceExtension->pjIOAddress ;
+    pVBInfo->BaseAddr = (unsigned long)HwDeviceExtension->pjIOAddress ;
     pVBInfo->ISXPDOS = 0 ;
 
     pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14 ;
@@ -3075,7 +3075,7 @@ void XGINew_SetDRAMModeRegister_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension )
 /*
 void XGINew_SetDRAMModeRegister_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension )
 {
-    UCHAR data ;
+    unsigned char data ;
     VB_DEVICE_INFO VBINF;
     PVB_DEVICE_INFO pVBInfo = &VBINF;
     pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase ;
@@ -3121,7 +3121,7 @@ void XGINew_SetDRAMModeRegister_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension )
 /* -------------------------------------------------------- */
 void XGINew_ChkSenseStatus ( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempbx=0 , temp , tempcx , CR3CData;
+    unsigned short tempbx=0 , temp , tempcx , CR3CData;
 
     temp = XGINew_GetReg1( pVBInfo->P3d4 , 0x32 ) ;
 
@@ -3182,7 +3182,7 @@ void XGINew_ChkSenseStatus ( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_
 /* -------------------------------------------------------- */
 void XGINew_SetModeScratch ( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT temp , tempcl = 0 , tempch = 0 , CR31Data , CR38Data;
+    unsigned short temp , tempcl = 0 , tempch = 0 , CR31Data , CR38Data;
 
     temp = XGINew_GetReg1( pVBInfo->P3d4 , 0x3d ) ;
     temp |= XGINew_GetReg1( pVBInfo->P3d4 , 0x3e ) << 8 ;
@@ -3279,8 +3279,8 @@ void XGINew_SetModeScratch ( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_
 /* -------------------------------------------------------- */
 void XGINew_GetXG21Sense(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR Temp;
-    PUCHAR  volatile pVideoMemory = ( PUCHAR )pVBInfo->ROMAddr ;
+    unsigned char Temp;
+    unsigned char *  volatile pVideoMemory = ( unsigned char * )pVBInfo->ROMAddr ;
 
     pVBInfo->IF_DEF_LVDS = 0 ;
 
@@ -3321,7 +3321,7 @@ void XGINew_GetXG21Sense(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 /* -------------------------------------------------------- */
 void XGINew_GetXG27Sense(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR Temp,bCR4A;
+    unsigned char Temp,bCR4A;
 
      pVBInfo->IF_DEF_LVDS = 0 ;
      bCR4A = XGINew_GetReg1( pVBInfo->P3d4 , 0x4A ) ;
@@ -3343,9 +3343,9 @@ void XGINew_GetXG27Sense(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 
 }
 
-UCHAR GetXG21FPBits(PVB_DEVICE_INFO pVBInfo)
+unsigned char GetXG21FPBits(PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR CR38,CR4A,temp;
+    unsigned char CR38,CR4A,temp;
 
     CR4A = XGINew_GetReg1( pVBInfo->P3d4 , 0x4A ) ;
     XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x4A , ~0x10 , 0x10 ) ; /* enable GPIOE read */
@@ -3363,9 +3363,9 @@ UCHAR GetXG21FPBits(PVB_DEVICE_INFO pVBInfo)
     return temp;
 }
 
-UCHAR GetXG27FPBits(PVB_DEVICE_INFO pVBInfo)
+unsigned char GetXG27FPBits(PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR CR4A,temp;
+    unsigned char CR4A,temp;
 
     CR4A = XGINew_GetReg1( pVBInfo->P3d4 , 0x4A ) ;
     XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x4A , ~0x03 , 0x03 ) ; /* enable GPIOA/B/C read */
diff --git a/drivers/staging/xgifb/vb_init.h b/drivers/staging/xgifb/vb_init.h
index 1f39d9c..1eee154 100644
--- a/drivers/staging/xgifb/vb_init.h
+++ b/drivers/staging/xgifb/vb_init.h
@@ -1,6 +1,6 @@
 #ifndef  _VBINIT_
 #define  _VBINIT_
-extern   BOOLEAN    XGIInitNew( PXGI_HW_DEVICE_INFO HwDeviceExtension ) ;
+extern   bool    XGIInitNew( PXGI_HW_DEVICE_INFO HwDeviceExtension ) ;
 extern XGI21_LVDSCapStruct  XGI21_LCDCapList[13];
 
 #endif
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 9535aa8..6097752 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -17,44 +17,44 @@
 
 
 
-BOOLEAN  XGI_IsLCDDualLink(PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGI_SetCRT2Group301(USHORT ModeNo, PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGI_BacklightByDrv(PVB_DEVICE_INFO pVBInfo);
-
-BOOLEAN  XGI_IsLCDON(PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGI_DisableChISLCD(PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGI_EnableChISLCD(PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGI_AjustCRT2Rate(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,USHORT *i, PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGI_SearchModeID( USHORT ModeNo,USHORT  *ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGI_GetLCDInfo(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGISetModeNew( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo ) ;
-BOOLEAN  XGI_BridgeIsOn(PVB_DEVICE_INFO pVBInfo);
-UCHAR    XGI_GetModePtr( USHORT ModeNo,USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo);
-USHORT   XGI_GetOffset(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo);
-USHORT   XGI_GetRatePtrCRT2( PXGI_HW_DEVICE_INFO pXGIHWDE, USHORT ModeNo,USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo );
-USHORT   XGI_GetResInfo(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
-USHORT   XGI_GetColorDepth(USHORT ModeNo,USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo);
-USHORT   XGI_GetVGAHT2(PVB_DEVICE_INFO pVBInfo);
-USHORT   XGI_GetVCLK2Ptr(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo);
+bool  XGI_IsLCDDualLink(PVB_DEVICE_INFO pVBInfo);
+bool  XGI_SetCRT2Group301(unsigned short ModeNo, PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo);
+bool  XGI_BacklightByDrv(PVB_DEVICE_INFO pVBInfo);
+
+bool  XGI_IsLCDON(PVB_DEVICE_INFO pVBInfo);
+bool  XGI_DisableChISLCD(PVB_DEVICE_INFO pVBInfo);
+bool  XGI_EnableChISLCD(PVB_DEVICE_INFO pVBInfo);
+bool  XGI_AjustCRT2Rate(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,unsigned short *i, PVB_DEVICE_INFO pVBInfo);
+bool  XGI_SearchModeID( unsigned short ModeNo,unsigned short  *ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+bool  XGI_GetLCDInfo(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+bool  XGISetModeNew( PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned short ModeNo ) ;
+bool  XGI_BridgeIsOn(PVB_DEVICE_INFO pVBInfo);
+unsigned char    XGI_GetModePtr( unsigned short ModeNo,unsigned short ModeIdIndex,PVB_DEVICE_INFO pVBInfo);
+unsigned short   XGI_GetOffset(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo);
+unsigned short   XGI_GetRatePtrCRT2( PXGI_HW_DEVICE_INFO pXGIHWDE, unsigned short ModeNo,unsigned short ModeIdIndex,PVB_DEVICE_INFO pVBInfo );
+unsigned short   XGI_GetResInfo(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+unsigned short   XGI_GetColorDepth(unsigned short ModeNo,unsigned short ModeIdIndex,PVB_DEVICE_INFO pVBInfo);
+unsigned short   XGI_GetVGAHT2(PVB_DEVICE_INFO pVBInfo);
+unsigned short   XGI_GetVCLK2Ptr(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo);
 void     XGI_VBLongWait(PVB_DEVICE_INFO pVBInfo);
-void     XGI_SaveCRT2Info(USHORT ModeNo, PVB_DEVICE_INFO pVBInfo);
-void     XGI_GetCRT2Data(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_GetCRT2ResInfo(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_PreSetGroup1(USHORT ModeNo,USHORT ModeIdIndex, PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetGroup1(USHORT ModeNo,USHORT ModeIdIndex, PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetLockRegs(USHORT ModeNo,USHORT ModeIdIndex, PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetLCDRegs(USHORT ModeNo,USHORT ModeIdIndex, PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetGroup2(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetGroup3(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetGroup4(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetGroup5(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
-void*    XGI_GetLcdPtr(USHORT BX,  USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
-void*    XGI_GetTVPtr(USHORT BX, USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SaveCRT2Info(unsigned short ModeNo, PVB_DEVICE_INFO pVBInfo);
+void     XGI_GetCRT2Data(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_GetCRT2ResInfo(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_PreSetGroup1(unsigned short ModeNo,unsigned short ModeIdIndex, PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetGroup1(unsigned short ModeNo,unsigned short ModeIdIndex, PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetLockRegs(unsigned short ModeNo,unsigned short ModeIdIndex, PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetLCDRegs(unsigned short ModeNo,unsigned short ModeIdIndex, PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetGroup2(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetGroup3(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetGroup4(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetGroup5(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+void*    XGI_GetLcdPtr(unsigned short BX,  unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void*    XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
 void 	 XGI_FirePWDEnable(PVB_DEVICE_INFO pVBInfo);
 void 	 XGI_EnableGatingCRT(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo);
 void 	 XGI_DisableGatingCRT(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo);
-void 	 XGI_SetPanelDelay(USHORT tempbl, PVB_DEVICE_INFO pVBInfo);
-void 	 XGI_SetPanelPower(USHORT tempah,USHORT tempbl, PVB_DEVICE_INFO pVBInfo);
+void 	 XGI_SetPanelDelay(unsigned short tempbl, PVB_DEVICE_INFO pVBInfo);
+void 	 XGI_SetPanelPower(unsigned short tempah,unsigned short tempbl, PVB_DEVICE_INFO pVBInfo);
 void 	 XGI_EnablePWD( PVB_DEVICE_INFO pVBInfo);
 void 	 XGI_DisablePWD( PVB_DEVICE_INFO pVBInfo);
 void     XGI_AutoThreshold( PVB_DEVICE_INFO pVBInfo);
@@ -62,99 +62,99 @@ void     XGI_SetTap4Regs( PVB_DEVICE_INFO pVBInfo);
 
 void     XGI_DisplayOn(PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO pVBInfo);
 void     XGI_DisplayOff( PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO pVBInfo );
-void     XGI_SetCRT1Group(PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT ModeNo,USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetXG21CRTC(USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetXG21LCD(PVB_DEVICE_INFO pVBInfo,USHORT RefreshRateTableIndex,USHORT ModeNo);
-void     XGI_SetXG27CRTC(USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetXG27LCD(PVB_DEVICE_INFO pVBInfo,USHORT RefreshRateTableIndex,USHORT ModeNo);
-void	 XGI_UpdateXG21CRTC(USHORT ModeNo, PVB_DEVICE_INFO pVBInfo, USHORT RefreshRateTableIndex);
+void     XGI_SetCRT1Group(PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short ModeNo,unsigned short ModeIdIndex,PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetXG21LCD(PVB_DEVICE_INFO pVBInfo,unsigned short RefreshRateTableIndex,unsigned short ModeNo);
+void     XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetXG27LCD(PVB_DEVICE_INFO pVBInfo,unsigned short RefreshRateTableIndex,unsigned short ModeNo);
+void	 XGI_UpdateXG21CRTC(unsigned short ModeNo, PVB_DEVICE_INFO pVBInfo, unsigned short RefreshRateTableIndex);
 void     XGI_WaitDisply(PVB_DEVICE_INFO pVBInfo);
 void     XGI_SenseCRT1(PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetSeqRegs(USHORT ModeNo,USHORT StandTableIndex,USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetMiscRegs(USHORT StandTableIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetCRTCRegs(PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT StandTableIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetATTRegs(USHORT ModeNo,USHORT StandTableIndex,USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo );
-void     XGI_SetGRCRegs(USHORT StandTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetSeqRegs(unsigned short ModeNo,unsigned short StandTableIndex,unsigned short ModeIdIndex,PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetMiscRegs(unsigned short StandTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetCRTCRegs(PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short StandTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetATTRegs(unsigned short ModeNo,unsigned short StandTableIndex,unsigned short ModeIdIndex,PVB_DEVICE_INFO pVBInfo );
+void     XGI_SetGRCRegs(unsigned short StandTableIndex, PVB_DEVICE_INFO pVBInfo);
 void     XGI_ClearExt1Regs(PVB_DEVICE_INFO pVBInfo);
 
-void     XGI_SetSync(USHORT RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetCRT1CRTC(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo,PXGI_HW_DEVICE_INFO HwDeviceExtension);
+void     XGI_SetSync(unsigned short RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetCRT1CRTC(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo,PXGI_HW_DEVICE_INFO HwDeviceExtension);
 void     XGI_SetCRT1Timing_H(PVB_DEVICE_INFO pVBInfo,PXGI_HW_DEVICE_INFO HwDeviceExtension);
-void     XGI_SetCRT1Timing_V(USHORT ModeIdIndex,USHORT ModeNo,PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetCRT1DE(PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetCRT1VCLK(USHORT ModeNo,USHORT ModeIdIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetCRT1FIFO(USHORT ModeNo,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetCRT1ModeRegs(PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetVCLKState(PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT ModeNo,USHORT RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo);
-
-void     XGI_LoadDAC(USHORT ModeNo,USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo);
-void     XGI_WriteDAC(USHORT dl, USHORT ah, USHORT al, USHORT dh, PVB_DEVICE_INFO pVBInfo);
-/*void     XGI_ClearBuffer(PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT ModeNo,PVB_DEVICE_INFO pVBInfo);*/
-void     XGI_SetLCDAGroup(USHORT ModeNo,USHORT ModeIdIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO  pVBInfo);
-void     XGI_GetLVDSResInfo( USHORT ModeNo,USHORT ModeIdIndex,PVB_DEVICE_INFO  pVBInfo);
-void     XGI_GetLVDSData(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PVB_DEVICE_INFO  pVBInfo);
-void     XGI_ModCRT1Regs(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO  pVBInfo);
-void     XGI_SetLVDSRegs(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PVB_DEVICE_INFO  pVBInfo);
+void     XGI_SetCRT1Timing_V(unsigned short ModeIdIndex,unsigned short ModeNo,PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetCRT1DE(PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetCRT1VCLK(unsigned short ModeNo,unsigned short ModeIdIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetCRT1FIFO(unsigned short ModeNo,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetCRT1ModeRegs(PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetVCLKState(PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short ModeNo,unsigned short RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo);
+
+void     XGI_LoadDAC(unsigned short ModeNo,unsigned short ModeIdIndex,PVB_DEVICE_INFO pVBInfo);
+void     XGI_WriteDAC(unsigned short dl, unsigned short ah, unsigned short al, unsigned short dh, PVB_DEVICE_INFO pVBInfo);
+/*void     XGI_ClearBuffer(PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short ModeNo,PVB_DEVICE_INFO pVBInfo);*/
+void     XGI_SetLCDAGroup(unsigned short ModeNo,unsigned short ModeIdIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO  pVBInfo);
+void     XGI_GetLVDSResInfo( unsigned short ModeNo,unsigned short ModeIdIndex,PVB_DEVICE_INFO  pVBInfo);
+void     XGI_GetLVDSData(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PVB_DEVICE_INFO  pVBInfo);
+void     XGI_ModCRT1Regs(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO  pVBInfo);
+void     XGI_SetLVDSRegs(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PVB_DEVICE_INFO  pVBInfo);
 void     XGI_UpdateModeInfo(PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO  pVBInfo);
 void     XGI_GetVGAType(PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO  pVBInfo);
 void     XGI_GetVBType(PVB_DEVICE_INFO  pVBInfo);
-void     XGI_GetVBInfo(USHORT ModeNo,USHORT ModeIdIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO  pVBInfo);
-void     XGI_GetTVInfo(USHORT ModeNo,USHORT ModeIdIndex,PVB_DEVICE_INFO  pVBInfo);
-void     XGI_SetCRT2ECLK( USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PVB_DEVICE_INFO  pVBInfo);
-void     InitTo330Pointer(UCHAR,PVB_DEVICE_INFO pVBInfo);
-void     XGI_GetLCDSync(USHORT* HSyncWidth, USHORT* VSyncWidth, PVB_DEVICE_INFO pVBInfo);
+void     XGI_GetVBInfo(unsigned short ModeNo,unsigned short ModeIdIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO  pVBInfo);
+void     XGI_GetTVInfo(unsigned short ModeNo,unsigned short ModeIdIndex,PVB_DEVICE_INFO  pVBInfo);
+void     XGI_SetCRT2ECLK( unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PVB_DEVICE_INFO  pVBInfo);
+void     InitTo330Pointer(unsigned char,PVB_DEVICE_INFO pVBInfo);
+void     XGI_GetLCDSync(unsigned short* HSyncWidth, unsigned short* VSyncWidth, PVB_DEVICE_INFO pVBInfo);
 void 	 XGI_DisableBridge(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo);
 void  	 XGI_EnableBridge(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetCRT2VCLK(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_OEM310Setting(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetCRT2VCLK(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_OEM310Setting(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
 void     XGI_SetDelayComp(PVB_DEVICE_INFO pVBInfo);
 void     XGI_SetLCDCap(PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetLCDCap_A(USHORT tempcx,PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetLCDCap_B(USHORT tempcx,PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetLCDCap_A(unsigned short tempcx,PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetLCDCap_B(unsigned short tempcx,PVB_DEVICE_INFO pVBInfo);
 void     SetSpectrum(PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetAntiFlicker(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetEdgeEnhance(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetAntiFlicker(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetEdgeEnhance(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
 void     XGI_SetPhaseIncr(PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetYFilter(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_GetTVPtrIndex2(USHORT* tempbx,UCHAR* tempcl,UCHAR* tempch, PVB_DEVICE_INFO pVBInfo);
-USHORT   XGI_GetTVPtrIndex(  PVB_DEVICE_INFO pVBInfo );
-void     XGI_SetCRT2ModeRegs(USHORT ModeNo,PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO pVBInfo );
+void     XGI_SetYFilter(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_GetTVPtrIndex2(unsigned short* tempbx,unsigned char* tempcl,unsigned char* tempch, PVB_DEVICE_INFO pVBInfo);
+unsigned short   XGI_GetTVPtrIndex(  PVB_DEVICE_INFO pVBInfo );
+void     XGI_SetCRT2ModeRegs(unsigned short ModeNo,PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO pVBInfo );
 void     XGI_CloseCRTC(PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO pVBInfo);
 void     XGI_OpenCRTC(PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO pVBInfo);
-void     XGI_GetRAMDAC2DATA(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_GetRAMDAC2DATA(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo);
 void     XGI_UnLockCRT2(PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO pVBInfo);
 void     XGI_LockCRT2(PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO pVBInfo);
 void     XGINew_EnableCRT2(PVB_DEVICE_INFO pVBInfo);
-void     XGINew_LCD_Wait_Time(UCHAR DelayTime, PVB_DEVICE_INFO pVBInfo);
+void     XGINew_LCD_Wait_Time(unsigned char DelayTime, PVB_DEVICE_INFO pVBInfo);
 void     XGI_LongWait(PVB_DEVICE_INFO pVBInfo);
-void     XGI_SetCRT1Offset( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo );
-void     XGI_GetLCDVCLKPtr(UCHAR* di_0,UCHAR *di_1, PVB_DEVICE_INFO pVBInfo);
-UCHAR    XGI_GetVCLKPtr(USHORT RefreshRateTableIndex,USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
-void     XGI_GetVCLKLen(UCHAR tempal,UCHAR* di_0,UCHAR* di_1, PVB_DEVICE_INFO pVBInfo);
-USHORT   XGI_GetLCDCapPtr(PVB_DEVICE_INFO pVBInfo);
-USHORT   XGI_GetLCDCapPtr1(PVB_DEVICE_INFO pVBInfo);
-XGI301C_Tap4TimingStruct* XGI_GetTap4Ptr(USHORT tempcx, PVB_DEVICE_INFO pVBInfo);
+void     XGI_SetCRT1Offset( unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo );
+void     XGI_GetLCDVCLKPtr(unsigned char* di_0,unsigned char *di_1, PVB_DEVICE_INFO pVBInfo);
+unsigned char    XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+void     XGI_GetVCLKLen(unsigned char tempal,unsigned char* di_0,unsigned char* di_1, PVB_DEVICE_INFO pVBInfo);
+unsigned short   XGI_GetLCDCapPtr(PVB_DEVICE_INFO pVBInfo);
+unsigned short   XGI_GetLCDCapPtr1(PVB_DEVICE_INFO pVBInfo);
+XGI301C_Tap4TimingStruct* XGI_GetTap4Ptr(unsigned short tempcx, PVB_DEVICE_INFO pVBInfo);
 void     XGI_SetXG21FPBits(PVB_DEVICE_INFO pVBInfo);
 void     XGI_SetXG27FPBits(PVB_DEVICE_INFO pVBInfo);
-UCHAR    XGI_XG21GetPSCValue(PVB_DEVICE_INFO pVBInfo);
-UCHAR    XGI_XG27GetPSCValue(PVB_DEVICE_INFO pVBInfo);
-void     XGI_XG21BLSignalVDD(USHORT tempbh,USHORT tempbl, PVB_DEVICE_INFO pVBInfo);
-void     XGI_XG27BLSignalVDD(USHORT tempbh,USHORT tempbl, PVB_DEVICE_INFO pVBInfo);
-void     XGI_XG21SetPanelDelay(USHORT tempbl, PVB_DEVICE_INFO pVBInfo);
-BOOLEAN  XGI_XG21CheckLVDSMode(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo );
-void     XGI_SetXG21LVDSPara(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo );
-void     XGI_SetXG27LVDSPara(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo );
-UCHAR    XGI_SetDefaultVCLK( PVB_DEVICE_INFO pVBInfo );
+unsigned char    XGI_XG21GetPSCValue(PVB_DEVICE_INFO pVBInfo);
+unsigned char    XGI_XG27GetPSCValue(PVB_DEVICE_INFO pVBInfo);
+void     XGI_XG21BLSignalVDD(unsigned short tempbh,unsigned short tempbl, PVB_DEVICE_INFO pVBInfo);
+void     XGI_XG27BLSignalVDD(unsigned short tempbh,unsigned short tempbl, PVB_DEVICE_INFO pVBInfo);
+void     XGI_XG21SetPanelDelay(unsigned short tempbl, PVB_DEVICE_INFO pVBInfo);
+bool  XGI_XG21CheckLVDSMode(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo );
+void     XGI_SetXG21LVDSPara(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo );
+void     XGI_SetXG27LVDSPara(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo );
+unsigned char    XGI_SetDefaultVCLK( PVB_DEVICE_INFO pVBInfo );
 
-extern   void 	  ReadVBIOSTablData( UCHAR ChipType , PVB_DEVICE_INFO pVBInfo);
+extern   void 	  ReadVBIOSTablData( unsigned char ChipType , PVB_DEVICE_INFO pVBInfo);
 
-/* USHORT XGINew_flag_clearbuffer; 0: no clear frame buffer 1:clear frame buffer */
+/* unsigned short XGINew_flag_clearbuffer; 0: no clear frame buffer 1:clear frame buffer */
 
 
 
 
 
-USHORT XGINew_MDA_DAC[]={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+unsigned short XGINew_MDA_DAC[]={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                0x15,0x15,0x15,0x15,0x15,0x15,0x15,0x15,
                0x15,0x15,0x15,0x15,0x15,0x15,0x15,0x15,
                0x3F,0x3F,0x3F,0x3F,0x3F,0x3F,0x3F,0x3F,
@@ -163,7 +163,7 @@ USHORT XGINew_MDA_DAC[]={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                0x15,0x15,0x15,0x15,0x15,0x15,0x15,0x15,
                0x3F,0x3F,0x3F,0x3F,0x3F,0x3F,0x3F,0x3F};
 
-USHORT XGINew_CGA_DAC[]={0x00,0x10,0x04,0x14,0x01,0x11,0x09,0x15,
+unsigned short XGINew_CGA_DAC[]={0x00,0x10,0x04,0x14,0x01,0x11,0x09,0x15,
                0x00,0x10,0x04,0x14,0x01,0x11,0x09,0x15,
                0x2A,0x3A,0x2E,0x3E,0x2B,0x3B,0x2F,0x3F,
                0x2A,0x3A,0x2E,0x3E,0x2B,0x3B,0x2F,0x3F,
@@ -172,7 +172,7 @@ USHORT XGINew_CGA_DAC[]={0x00,0x10,0x04,0x14,0x01,0x11,0x09,0x15,
                0x2A,0x3A,0x2E,0x3E,0x2B,0x3B,0x2F,0x3F,
                0x2A,0x3A,0x2E,0x3E,0x2B,0x3B,0x2F,0x3F};
 
-USHORT XGINew_EGA_DAC[]={0x00,0x10,0x04,0x14,0x01,0x11,0x05,0x15,
+unsigned short XGINew_EGA_DAC[]={0x00,0x10,0x04,0x14,0x01,0x11,0x05,0x15,
                0x20,0x30,0x24,0x34,0x21,0x31,0x25,0x35,
                0x08,0x18,0x0C,0x1C,0x09,0x19,0x0D,0x1D,
                0x28,0x38,0x2C,0x3C,0x29,0x39,0x2D,0x3D,
@@ -181,7 +181,7 @@ USHORT XGINew_EGA_DAC[]={0x00,0x10,0x04,0x14,0x01,0x11,0x05,0x15,
                0x0A,0x1A,0x0E,0x1E,0x0B,0x1B,0x0F,0x1F,
                0x2A,0x3A,0x2E,0x3E,0x2B,0x3B,0x2F,0x3F};
 
-USHORT XGINew_VGA_DAC[]={0x00,0x10,0x04,0x14,0x01,0x11,0x09,0x15,
+unsigned short XGINew_VGA_DAC[]={0x00,0x10,0x04,0x14,0x01,0x11,0x09,0x15,
                0x2A,0x3A,0x2E,0x3E,0x2B,0x3B,0x2F,0x3F,
                0x00,0x05,0x08,0x0B,0x0E,0x11,0x14,0x18,
                0x1C,0x20,0x24,0x28,0x2D,0x32,0x38,0x3F,
@@ -200,7 +200,7 @@ USHORT XGINew_VGA_DAC[]={0x00,0x10,0x04,0x14,0x01,0x11,0x09,0x15,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void InitTo330Pointer( UCHAR ChipType ,PVB_DEVICE_INFO pVBInfo)
+void InitTo330Pointer( unsigned char ChipType ,PVB_DEVICE_INFO pVBInfo)
 {
     pVBInfo->SModeIDTable = (XGI_StStruct *) XGI330_SModeIDTable ;
     pVBInfo->StandTable = (XGI_StandTableStruct *) XGI330_StandTable ;
@@ -355,14 +355,14 @@ void InitTo330Pointer( UCHAR ChipType ,PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGISetModeNew( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo )
+bool XGISetModeNew( PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned short ModeNo )
 {
-    USHORT ModeIdIndex ;
-        /* PUCHAR pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress ; */
+    unsigned short ModeIdIndex ;
+        /* unsigned char * pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress ; */
     VB_DEVICE_INFO VBINF;
     PVB_DEVICE_INFO pVBInfo = &VBINF;
     pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase ;
-    pVBInfo->BaseAddr = (ULONG)HwDeviceExtension->pjIOAddress ;
+    pVBInfo->BaseAddr = (unsigned long)HwDeviceExtension->pjIOAddress ;
     pVBInfo->IF_DEF_LVDS = 0 ;
     pVBInfo->IF_DEF_CH7005 = 0 ;
     pVBInfo->IF_DEF_LCDA = 1 ;
@@ -582,14 +582,14 @@ BOOLEAN XGISetModeNew( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRT1Group( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetCRT1Group( PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned short ModeNo , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT StandTableIndex ,
+    unsigned short StandTableIndex ,
            RefreshRateTableIndex ,
            b3CC ,
            temp ;
 
-    USHORT XGINew_P3cc =  pVBInfo->P3cc;
+    unsigned short XGINew_P3cc =  pVBInfo->P3cc;
 
     /* XGINew_CRT1Mode = ModeNo ; // SaveModeID */
     StandTableIndex = XGI_GetModePtr( ModeNo , ModeIdIndex, pVBInfo ) ;
@@ -640,14 +640,14 @@ void XGI_SetCRT1Group( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo , U
     	{
     	    XGINew_SetReg1( pVBInfo->P3c4 , 0x2B , 0x4E) ;
     	    XGINew_SetReg1( pVBInfo->P3c4 , 0x2C , 0xE9) ;
-    	    b3CC =(UCHAR) XGINew_GetReg2(XGINew_P3cc) ;
+    	    b3CC =(unsigned char) XGINew_GetReg2(XGINew_P3cc) ;
     	    XGINew_SetReg3(XGINew_P3cc ,  (b3CC |= 0x0C) ) ;
     	}
     	else if ( ( ModeNo == 0x04) | ( ModeNo == 0x05) | ( ModeNo == 0x0D) )
     	{
     	    XGINew_SetReg1( pVBInfo->P3c4 , 0x2B , 0x1B) ;
     	    XGINew_SetReg1( pVBInfo->P3c4 , 0x2C , 0xE3) ;
-    	    b3CC = (UCHAR)XGINew_GetReg2(XGINew_P3cc) ;
+    	    b3CC = (unsigned char)XGINew_GetReg2(XGINew_P3cc) ;
     	    XGINew_SetReg3(XGINew_P3cc ,  (b3CC |= 0x0C) ) ;
     	}
     }
@@ -702,9 +702,9 @@ void XGI_SetCRT1Group( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo , U
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-UCHAR XGI_GetModePtr( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+unsigned char XGI_GetModePtr( unsigned short ModeNo , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR index ;
+    unsigned char index ;
 
     if ( ModeNo <= 0x13 )
         index = pVBInfo->SModeIDTable[ ModeIdIndex ].St_StTableIndex ;
@@ -725,7 +725,7 @@ UCHAR XGI_GetModePtr( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInf
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-/*UCHAR XGI_SetBIOSData( USHORT ModeNo , USHORT ModeIdIndex )
+/*unsigned char XGI_SetBIOSData( unsigned short ModeNo , unsigned short ModeIdIndex )
 {
     return( 0 ) ;
 }
@@ -737,7 +737,7 @@ UCHAR XGI_GetModePtr( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInf
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-/*UCHAR XGI_ClearBankRegs( USHORT ModeNo , USHORT ModeIdIndex )
+/*unsigned char XGI_ClearBankRegs( unsigned short ModeNo , unsigned short ModeIdIndex )
 {
     return( 0 ) ;
 }
@@ -749,12 +749,12 @@ UCHAR XGI_GetModePtr( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInf
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetSeqRegs(  USHORT ModeNo , USHORT StandTableIndex , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetSeqRegs(  unsigned short ModeNo , unsigned short StandTableIndex , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR tempah ,
+    unsigned char tempah ,
           SRdata ;
 
-    USHORT i ,
+    unsigned short i ,
            modeflag ;
 
     if ( ModeNo <= 0x13 )
@@ -796,9 +796,9 @@ void XGI_SetSeqRegs(  USHORT ModeNo , USHORT StandTableIndex , USHORT ModeIdInde
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetMiscRegs( USHORT StandTableIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetMiscRegs( unsigned short StandTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR Miscdata ;
+    unsigned char Miscdata ;
 
     Miscdata = pVBInfo->StandTable[ StandTableIndex ].MISC ;	/* Get Misc from file */
 /*
@@ -821,12 +821,12 @@ void XGI_SetMiscRegs( USHORT StandTableIndex, PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRTCRegs( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT StandTableIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetCRTCRegs( PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned short StandTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR CRTCdata ;
-    USHORT i ;
+    unsigned char CRTCdata ;
+    unsigned short i ;
 
-    CRTCdata = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
+    CRTCdata = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
     CRTCdata &= 0x7f ;
     XGINew_SetReg1( pVBInfo->P3d4 , 0x11 , CRTCdata ) ;		/* Unlock CRTC */
 
@@ -856,10 +856,10 @@ void XGI_SetCRTCRegs( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT StandTableI
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetATTRegs( USHORT ModeNo , USHORT StandTableIndex , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetATTRegs( unsigned short ModeNo , unsigned short StandTableIndex , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR ARdata ;
-    USHORT i ,
+    unsigned char ARdata ;
+    unsigned short i ,
            modeflag ;
 
     if ( ModeNo <= 0x13 )
@@ -906,10 +906,10 @@ void XGI_SetATTRegs( USHORT ModeNo , USHORT StandTableIndex , USHORT ModeIdIndex
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetGRCRegs( USHORT StandTableIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetGRCRegs( unsigned short StandTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR GRdata ;
-    USHORT i ;
+    unsigned char GRdata ;
+    unsigned short i ;
 
     for( i = 0 ; i <= 0x08 ; i++ )
     {
@@ -919,7 +919,7 @@ void XGI_SetGRCRegs( USHORT StandTableIndex, PVB_DEVICE_INFO pVBInfo )
 
     if ( pVBInfo->ModeType > ModeVGA )
     {
-        GRdata = ( UCHAR )XGINew_GetReg1( pVBInfo->P3ce , 0x05 ) ;
+        GRdata = ( unsigned char )XGINew_GetReg1( pVBInfo->P3ce , 0x05 ) ;
         GRdata &= 0xBF ;						/* 256 color disable */
         XGINew_SetReg1( pVBInfo->P3ce , 0x05 , GRdata ) ;
     }
@@ -934,7 +934,7 @@ void XGI_SetGRCRegs( USHORT StandTableIndex, PVB_DEVICE_INFO pVBInfo )
 /* --------------------------------------------------------------------- */
 void XGI_ClearExt1Regs(PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT i ;
+    unsigned short i ;
 
     for( i = 0x0A ; i <= 0x0E ; i++ )
         XGINew_SetReg1( pVBInfo->P3c4 , i , 0x00 ) ;	/* Clear SR0A-SR0E */
@@ -947,7 +947,7 @@ void XGI_ClearExt1Regs(PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-UCHAR XGI_SetDefaultVCLK( PVB_DEVICE_INFO pVBInfo )
+unsigned char XGI_SetDefaultVCLK( PVB_DEVICE_INFO pVBInfo )
 {
 
     XGINew_SetRegANDOR( pVBInfo->P3c4 , 0x31 , ~0x30 , 0x20 ) ;
@@ -969,12 +969,12 @@ UCHAR XGI_SetDefaultVCLK( PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-USHORT XGI_GetRatePtrCRT2( PXGI_HW_DEVICE_INFO pXGIHWDE, USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+unsigned short XGI_GetRatePtrCRT2( PXGI_HW_DEVICE_INFO pXGIHWDE, unsigned short ModeNo , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    SHORT  LCDRefreshIndex[] = { 0x00 , 0x00 , 0x03 , 0x01 } ,
+    short  LCDRefreshIndex[] = { 0x00 , 0x00 , 0x03 , 0x01 } ,
            LCDARefreshIndex[] = { 0x00 , 0x00 , 0x03 , 0x01 , 0x01 , 0x01 , 0x01 } ;
 
-    USHORT RefreshRateTableIndex , i ,
+    unsigned short RefreshRateTableIndex , i ,
          modeflag , index , temp ;
 
     if ( ModeNo <= 0x13 )
@@ -1106,9 +1106,9 @@ USHORT XGI_GetRatePtrCRT2( PXGI_HW_DEVICE_INFO pXGIHWDE, USHORT ModeNo , USHORT
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_AjustCRT2Rate( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex , USHORT *i, PVB_DEVICE_INFO pVBInfo )
+bool XGI_AjustCRT2Rate( unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex , unsigned short *i, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempax ,
+    unsigned short tempax ,
            tempbx ,
            resinfo ,
            modeflag ,
@@ -1282,9 +1282,9 @@ BOOLEAN XGI_AjustCRT2Rate( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRa
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetSync(USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetSync(unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT sync ,
+    unsigned short sync ,
            temp ;
 
     sync = pVBInfo->RefIndex[ RefreshRateTableIndex ].Ext_InfoFlag >> 8 ;	/* di+0x00 */
@@ -1301,17 +1301,17 @@ void XGI_SetSync(USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRT1CRTC( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo, PXGI_HW_DEVICE_INFO HwDeviceExtension )
+void XGI_SetCRT1CRTC( unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo, PXGI_HW_DEVICE_INFO HwDeviceExtension )
 {
-    UCHAR  index ,
+    unsigned char  index ,
            data ;
 
-    USHORT i ;
+    unsigned short i ;
 
     index = pVBInfo->RefIndex[ RefreshRateTableIndex ].Ext_CRT1CRTC ;	/* Get index */
     index = index&IndexMask ;
 
-    data =( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
+    data =( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
     data &= 0x7F ;
     XGINew_SetReg1(pVBInfo->P3d4,0x11,data);				/* Unlock CRTC */
 
@@ -1341,14 +1341,14 @@ void XGI_SetCRT1CRTC( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
 /* --------------------------------------------------------------------- */
 void XGI_SetCRT1Timing_H( PVB_DEVICE_INFO pVBInfo, PXGI_HW_DEVICE_INFO HwDeviceExtension )
 {
-    UCHAR data , data1, pushax;
-    USHORT i , j ;
+    unsigned char data , data1, pushax;
+    unsigned short i , j ;
 
     /* XGINew_SetReg1( pVBInfo->P3d4 , 0x51 , 0 ) ; */
     /* XGINew_SetReg1( pVBInfo->P3d4 , 0x56 , 0 ) ; */
     /* XGINew_SetRegANDOR( pVBInfo->P3d4 ,0x11 , 0x7f , 0x00 ) ; */
 
-    data = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;		/* unlock cr0-7 */
+    data = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;		/* unlock cr0-7 */
     data &= 0x7F ;
     XGINew_SetReg1( pVBInfo->P3d4 , 0x11 , data ) ;
 
@@ -1358,16 +1358,16 @@ void XGI_SetCRT1Timing_H( PVB_DEVICE_INFO pVBInfo, PXGI_HW_DEVICE_INFO HwDeviceE
     for( i = 0x01 ; i <= 0x04 ; i++ )
     {
         data = pVBInfo->TimingH[ 0 ].data[ i ] ;
-        XGINew_SetReg1( pVBInfo->P3d4 , ( USHORT )( i + 1 ) , data ) ;
+        XGINew_SetReg1( pVBInfo->P3d4 , ( unsigned short )( i + 1 ) , data ) ;
     }
 
     for( i = 0x05 ; i <= 0x06 ; i++ )
     {
         data = pVBInfo->TimingH[ 0 ].data[ i ];
-        XGINew_SetReg1( pVBInfo->P3c4 ,( USHORT )( i + 6 ) , data ) ;
+        XGINew_SetReg1( pVBInfo->P3c4 ,( unsigned short )( i + 6 ) , data ) ;
     }
 
-    j = ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x0e ) ;
+    j = ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x0e ) ;
     j &= 0x1F ;
     data = pVBInfo->TimingH[ 0 ].data[ 7 ] ;
     data &= 0xE0 ;
@@ -1376,17 +1376,17 @@ void XGI_SetCRT1Timing_H( PVB_DEVICE_INFO pVBInfo, PXGI_HW_DEVICE_INFO HwDeviceE
 
     if ( HwDeviceExtension->jChipType >= XG20 )
     {
-    	data = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x04 ) ;
+    	data = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x04 ) ;
     	data = data - 1 ;
     	XGINew_SetReg1( pVBInfo->P3d4 , 0x04 , data ) ;
-    	data = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x05 ) ;
+    	data = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x05 ) ;
     	data1 = data ;
     	data1 &= 0xE0 ;
     	data &= 0x1F ;
     	if ( data == 0 )
     	{
     	    pushax = data ;
-    	    data = ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x0c ) ;
+    	    data = ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x0c ) ;
     	    data &= 0xFB ;
     	    XGINew_SetReg1( pVBInfo->P3c4 , 0x0c , data ) ;
     	    data = pushax ;
@@ -1394,7 +1394,7 @@ void XGI_SetCRT1Timing_H( PVB_DEVICE_INFO pVBInfo, PXGI_HW_DEVICE_INFO HwDeviceE
     	data = data - 1 ;
     	data |= data1 ;
     	XGINew_SetReg1( pVBInfo->P3d4 , 0x05 , data ) ;
-    	data = ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x0e ) ;
+    	data = ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x0e ) ;
     	data = data >> 5 ;
     	data = data + 3 ;
     	if ( data > 7 )
@@ -1411,10 +1411,10 @@ void XGI_SetCRT1Timing_H( PVB_DEVICE_INFO pVBInfo, PXGI_HW_DEVICE_INFO HwDeviceE
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRT1Timing_V( USHORT ModeIdIndex , USHORT ModeNo,PVB_DEVICE_INFO pVBInfo )
+void XGI_SetCRT1Timing_V( unsigned short ModeIdIndex , unsigned short ModeNo,PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR data ;
-    USHORT i , j ;
+    unsigned char data ;
+    unsigned short i , j ;
 
     /* XGINew_SetReg1( pVBInfo->P3d4 , 0x51 , 0 ) ; */
     /* XGINew_SetReg1( pVBInfo->P3d4 , 0x56 , 0 ) ; */
@@ -1423,22 +1423,22 @@ void XGI_SetCRT1Timing_V( USHORT ModeIdIndex , USHORT ModeNo,PVB_DEVICE_INFO pVB
     for( i = 0x00 ; i <= 0x01 ; i++ )
     {
         data = pVBInfo->TimingV[ 0 ].data[ i ] ;
-        XGINew_SetReg1( pVBInfo->P3d4 , ( USHORT )( i + 6 ) , data ) ;
+        XGINew_SetReg1( pVBInfo->P3d4 , ( unsigned short )( i + 6 ) , data ) ;
     }
 
     for( i = 0x02 ; i <= 0x03 ; i++ )
     {
         data = pVBInfo->TimingV[ 0 ].data[ i ] ;
-        XGINew_SetReg1( pVBInfo->P3d4 , ( USHORT )( i + 0x0e ) , data ) ;
+        XGINew_SetReg1( pVBInfo->P3d4 , ( unsigned short )( i + 0x0e ) , data ) ;
     }
 
     for( i = 0x04 ; i <= 0x05 ; i++ )
     {
         data = pVBInfo->TimingV[ 0 ].data[ i ] ;
-        XGINew_SetReg1( pVBInfo->P3d4 , ( USHORT )( i + 0x11 ) , data ) ;
+        XGINew_SetReg1( pVBInfo->P3d4 , ( unsigned short )( i + 0x11 ) , data ) ;
     }
 
-    j = ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x0a ) ;
+    j = ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x0a ) ;
     j &= 0xC0 ;
     data = pVBInfo->TimingV[ 0 ].data[ 6 ] ;
     data &= 0x3F ;
@@ -1458,7 +1458,7 @@ void XGI_SetCRT1Timing_V( USHORT ModeIdIndex , USHORT ModeNo,PVB_DEVICE_INFO pVB
     if ( i )
         data |= 0x80 ;
 
-    j = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x09 ) ;
+    j = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x09 ) ;
     j &= 0x5F ;
     data |= j ;
     XGINew_SetReg1( pVBInfo->P3d4 , 0x09 , data ) ;
@@ -1471,10 +1471,10 @@ void XGI_SetCRT1Timing_V( USHORT ModeIdIndex , USHORT ModeNo,PVB_DEVICE_INFO pVB
 /* Output : Fill CRT Hsync/Vsync to SR2E/SR2F/SR30/SR33/SR34/SR3F */
 /* Description : Set LCD timing */
 /* --------------------------------------------------------------------- */
-void XGI_SetXG21CRTC(USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo)
+void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo)
 {
-  UCHAR StandTableIndex, index, Tempax, Tempbx, Tempcx, Tempdx ;
-  USHORT Temp1, Temp2, Temp3 ;
+  unsigned char StandTableIndex, index, Tempax, Tempbx, Tempcx, Tempdx ;
+  unsigned short Temp1, Temp2, Temp3 ;
 
   if ( ModeNo <= 0x13 )
   {
@@ -1503,7 +1503,7 @@ void XGI_SetXG21CRTC(USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableI
     Tempdx |= Tempcx ;							/* Tempdx: VRS[8:1] */
     XGINew_SetReg1( pVBInfo->P3c4 , 0x34 , Tempdx ) ;    		/* SR34[7:0]: VRS[8:1] */
 
-    Temp1 = Tempcx << 1 ;						/* Temp1[8]: VRS[8] UCHAR -> USHORT */
+    Temp1 = Tempcx << 1 ;						/* Temp1[8]: VRS[8] unsigned char -> unsigned short */
     Temp1 |= Tempbx ;							/* Temp1[8:0]: VRS[8:0] */
     Tempax &= 0x80 ;							/* Tempax[7]: CR7[7] */
     Temp2 = Tempax << 2 ;						/* Temp2[9]: VRS[9] */
@@ -1517,11 +1517,11 @@ void XGI_SetXG21CRTC(USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableI
     if ( Tempax < Temp3 )						/* VRE[3:0]<VRS[3:0] */
       Temp2 |= 0x10 ;							/* Temp2: VRE + 0x10 */
     Temp2 &= 0xFF ;							/* Temp2[7:0]: VRE[7:0] */
-    Tempax = (UCHAR)Temp2 ;						/* Tempax[7:0]: VRE[7:0] */
+    Tempax = (unsigned char)Temp2 ;						/* Tempax[7:0]: VRE[7:0] */
     Tempax <<= 2 ;							/* Tempax << 2: VRE[5:0] */
     Temp1 &= 0x600 ;							/* Temp1[10:9]: VRS[10:9] */
     Temp1 >>= 9 ;							/* [10:9]->[1:0] */
-    Tempbx = (UCHAR)Temp1 ;						/* Tempbx[1:0]: VRS[10:9] */
+    Tempbx = (unsigned char)Temp1 ;						/* Tempbx[1:0]: VRS[10:9] */
     Tempax |= Tempbx ;							/* VRE[5:0]VRS[10:9] */
     Tempax &= 0x7F ;
     XGINew_SetReg1( pVBInfo->P3c4 , 0x3F , Tempax ) ;   		/* SR3F D[7:2]->VRE D[1:0]->VRS */
@@ -1555,7 +1555,7 @@ void XGI_SetXG21CRTC(USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableI
       Temp2 |= 0x40 ;                                                   /* Temp2 + 0x40 */
 
     Temp2 &= 0xFF ;
-    Tempax = (UCHAR)Temp2 ;						/* Tempax: HRE[7:0] */
+    Tempax = (unsigned char)Temp2 ;						/* Tempax: HRE[7:0] */
     Tempax <<= 2 ;							/* Tempax[7:2]: HRE[5:0] */
     Tempdx >>= 6 ;							/* Tempdx[7:6]->[1:0] HRS[9:8] */
     Tempax |= Tempdx ;							/* HRE[5:0]HRS[9:8] */
@@ -1599,20 +1599,20 @@ void XGI_SetXG21CRTC(USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableI
       Temp2 |= 0x20 ;							/* VRE + 0x20 */
 
     Temp2 &= 0xFF ;
-    Tempax = (UCHAR)Temp2 ;						/* Tempax: VRE[7:0] */
+    Tempax = (unsigned char)Temp2 ;						/* Tempax: VRE[7:0] */
     Tempax <<= 2 ;							/* Tempax[7:0]; VRE[5:0]00 */
     Temp1 &= 0x600 ;							/* Temp1[10:9]: VRS[10:9] */
     Temp1 >>= 9 ;  							/* Temp1[1:0]: VRS[10:9] */
-    Tempbx = (UCHAR)Temp1 ;
+    Tempbx = (unsigned char)Temp1 ;
     Tempax |= Tempbx ;							/* Tempax[7:0]: VRE[5:0]VRS[10:9] */
     Tempax &= 0x7F ;
     XGINew_SetReg1( pVBInfo->P3c4 , 0x3F , Tempax ) ;   		/* SR3F D[7:2]->VRE D[1:0]->VRS */
   }
 }
 
-void XGI_SetXG27CRTC(USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo)
+void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo)
 {
-  USHORT StandTableIndex, index, Tempax, Tempbx, Tempcx, Tempdx ;
+  unsigned short StandTableIndex, index, Tempax, Tempbx, Tempcx, Tempdx ;
 
   if ( ModeNo <= 0x13 )
   {
@@ -1649,7 +1649,7 @@ void XGI_SetXG27CRTC(USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableI
     Tempbx |= Tempax ;							/* Tempbx[9:0]: VRE[9:0] */
     if ( Tempax <= (Tempcx & 0x0F) )					/* VRE[3:0]<=VRS[3:0] */
       Tempbx |= 0x10 ;							/* Tempbx: VRE + 0x10 */
-    Tempax = (UCHAR)Tempbx & 0xFF;					/* Tempax[7:0]: VRE[7:0] */
+    Tempax = (unsigned char)Tempbx & 0xFF;					/* Tempax[7:0]: VRE[7:0] */
     Tempax <<= 2 ;							/* Tempax << 2: VRE[5:0] */
     Tempcx = (Tempcx&0x600)>>8;                                         /* Tempcx VRS[10:9] */
     XGINew_SetRegANDOR( pVBInfo->P3c4 , 0x3F , ~0xFC, Tempax ) ;        /* SR3F D[7:2]->VRE D[5:0] */
@@ -1733,10 +1733,10 @@ void XGI_SetXG27CRTC(USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableI
 /* Output : FCLK duty cycle, FCLK delay compensation */
 /* Description : All values set zero */
 /* --------------------------------------------------------------------- */
-void XGI_SetXG21LCD(PVB_DEVICE_INFO pVBInfo,USHORT RefreshRateTableIndex,USHORT ModeNo)
+void XGI_SetXG21LCD(PVB_DEVICE_INFO pVBInfo,unsigned short RefreshRateTableIndex,unsigned short ModeNo)
 {
-  USHORT Data , Temp , b3CC ;
-  USHORT XGI_P3cc ;
+  unsigned short Data , Temp , b3CC ;
+  unsigned short XGI_P3cc ;
 
   XGI_P3cc = pVBInfo->P3cc ;
 
@@ -1767,7 +1767,7 @@ void XGI_SetXG21LCD(PVB_DEVICE_INFO pVBInfo,USHORT RefreshRateTableIndex,USHORT
 
   if ( ModeNo <= 0x13 )
   {
-    b3CC = (UCHAR) XGINew_GetReg2( XGI_P3cc ) ;
+    b3CC = (unsigned char) XGINew_GetReg2( XGI_P3cc ) ;
     if ( b3CC & 0x40 )
       XGINew_SetRegOR( pVBInfo->P3c4 , 0x30 , 0x20 ) ; /* Hsync polarity */
     if ( b3CC & 0x80 )
@@ -1783,10 +1783,10 @@ void XGI_SetXG21LCD(PVB_DEVICE_INFO pVBInfo,USHORT RefreshRateTableIndex,USHORT
   }
 }
 
-void XGI_SetXG27LCD(PVB_DEVICE_INFO pVBInfo,USHORT RefreshRateTableIndex,USHORT ModeNo)
+void XGI_SetXG27LCD(PVB_DEVICE_INFO pVBInfo,unsigned short RefreshRateTableIndex,unsigned short ModeNo)
 {
-  USHORT Data , Temp , b3CC ;
-  USHORT XGI_P3cc ;
+  unsigned short Data , Temp , b3CC ;
+  unsigned short XGI_P3cc ;
 
   XGI_P3cc = pVBInfo->P3cc ;
 
@@ -1819,7 +1819,7 @@ void XGI_SetXG27LCD(PVB_DEVICE_INFO pVBInfo,USHORT RefreshRateTableIndex,USHORT
 
   if ( ModeNo <= 0x13 )
   {
-    b3CC = (UCHAR) XGINew_GetReg2( XGI_P3cc ) ;
+    b3CC = (unsigned char) XGINew_GetReg2( XGI_P3cc ) ;
     if ( b3CC & 0x40 )
       XGINew_SetRegOR( pVBInfo->P3c4 , 0x30 , 0x20 ) ; /* Hsync polarity */
     if ( b3CC & 0x80 )
@@ -1841,7 +1841,7 @@ void XGI_SetXG27LCD(PVB_DEVICE_INFO pVBInfo,USHORT RefreshRateTableIndex,USHORT
 /* Output : CRT1 CRTC */
 /* Description : Modify CRT1 Hsync/Vsync to fix LCD mode timing */
 /* --------------------------------------------------------------------- */
-void XGI_UpdateXG21CRTC( USHORT ModeNo , PVB_DEVICE_INFO pVBInfo , USHORT RefreshRateTableIndex )
+void XGI_UpdateXG21CRTC( unsigned short ModeNo , PVB_DEVICE_INFO pVBInfo , unsigned short RefreshRateTableIndex )
 {
   int i , index = -1;
 
@@ -1884,16 +1884,16 @@ void XGI_UpdateXG21CRTC( USHORT ModeNo , PVB_DEVICE_INFO pVBInfo , USHORT Refres
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRT1DE( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo,USHORT ModeIdIndex , USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetCRT1DE( PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned short ModeNo,unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT resindex ,
+    unsigned short resindex ,
            tempax ,
            tempbx ,
            tempcx ,
            temp ,
            modeflag ;
 
-    UCHAR data ;
+    unsigned char data ;
 
     resindex = XGI_GetResInfo( ModeNo , ModeIdIndex, pVBInfo ) ;
 
@@ -1936,13 +1936,13 @@ void XGI_SetCRT1DE( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo,USHORT
     tempax -= 1 ;
     tempbx -= 1 ;
     tempcx = tempax ;
-    temp = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
-    data = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
+    temp = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
+    data = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
     data &= 0x7F ;
     XGINew_SetReg1( pVBInfo->P3d4 , 0x11 , data ) ;		/* Unlock CRTC */
-    XGINew_SetReg1( pVBInfo->P3d4 , 0x01 , ( USHORT )( tempcx & 0xff ) ) ;
-    XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x0b , ~0x0c , ( USHORT )( ( tempcx & 0x0ff00 ) >> 10 ) ) ;
-    XGINew_SetReg1( pVBInfo->P3d4 , 0x12 , ( USHORT )( tempbx & 0xff ) ) ;
+    XGINew_SetReg1( pVBInfo->P3d4 , 0x01 , ( unsigned short )( tempcx & 0xff ) ) ;
+    XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x0b , ~0x0c , ( unsigned short )( ( tempcx & 0x0ff00 ) >> 10 ) ) ;
+    XGINew_SetReg1( pVBInfo->P3d4 , 0x12 , ( unsigned short )( tempbx & 0xff ) ) ;
     tempax = 0 ;
     tempbx = tempbx >> 8 ;
 
@@ -1953,7 +1953,7 @@ void XGI_SetCRT1DE( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo,USHORT
         tempax |= 0x40 ;
 
     XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x07 , ~0x42 , tempax ) ;
-    data =( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x07 ) ;
+    data =( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x07 ) ;
     data &= 0xFF ;
     tempax = 0 ;
 
@@ -1971,9 +1971,9 @@ void XGI_SetCRT1DE( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo,USHORT
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-USHORT 	XGI_GetResInfo(USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+unsigned short 	XGI_GetResInfo(unsigned short ModeNo , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT resindex ;
+    unsigned short resindex ;
 
     if ( ModeNo <= 0x13 )
     {
@@ -1993,9 +1993,9 @@ USHORT 	XGI_GetResInfo(USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBIn
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRT1Offset(  USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetCRT1Offset(  unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT temp ,
+    unsigned short temp ,
            ah ,
            al ,
            temp2 ,
@@ -2054,7 +2054,7 @@ void XGI_SetCRT1Offset(  USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRate
     i |= temp ;
     XGINew_SetReg1( pVBInfo->P3c4 , 0x0E , i ) ;
 
-    temp =( UCHAR )temp2 ;
+    temp =( unsigned char )temp2 ;
     temp &= 0xFF ;		/* al */
     XGINew_SetReg1( pVBInfo->P3d4 , 0x13 , temp ) ;
 
@@ -2086,11 +2086,11 @@ void XGI_SetCRT1Offset(  USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRate
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRT1VCLK( USHORT ModeNo , USHORT ModeIdIndex ,
-                        PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetCRT1VCLK( unsigned short ModeNo , unsigned short ModeIdIndex ,
+                        PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR index , data ;
-    USHORT vclkindex ;
+    unsigned char index , data ;
+    unsigned short vclkindex ;
 
     if ( pVBInfo->IF_DEF_LVDS == 1 )
     {
@@ -2147,9 +2147,9 @@ void XGI_SetCRT1VCLK( USHORT ModeNo , USHORT ModeIdIndex ,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRT1FIFO( USHORT ModeNo , PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo )
+void XGI_SetCRT1FIFO( unsigned short ModeNo , PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT data ;
+    unsigned short data ;
 
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x3D ) ;
     data &= 0xfe ;
@@ -2197,9 +2197,9 @@ void XGI_SetCRT1FIFO( USHORT ModeNo , PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_
 /* Description : */
 /* --------------------------------------------------------------------- */
 void XGI_SetCRT1ModeRegs( PXGI_HW_DEVICE_INFO HwDeviceExtension ,
-                            USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo )
+                            unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT data ,
+    unsigned short data ,
            data2 ,
            data3 ,
            infoflag = 0 ,
@@ -2334,13 +2334,13 @@ void XGI_SetCRT1ModeRegs( PXGI_HW_DEVICE_INFO HwDeviceExtension ,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetVCLKState(  PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo , USHORT RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo )
+void XGI_SetVCLKState(  PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned short ModeNo , unsigned short RefreshRateTableIndex,PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT data ,
+    unsigned short data ,
            data2 = 0 ;
-    SHORT  VCLK ;
+    short  VCLK ;
 
-    UCHAR  index ;
+    unsigned char  index ;
 
     if ( ModeNo <= 0x13 )
         VCLK = 0 ;
@@ -2398,9 +2398,9 @@ void XGI_SetVCLKState(  PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo ,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-/*void XGI_VesaLowResolution( USHORT ModeNo , USHORT ModeIdIndex ,PVB_DEVICE_INFO pVBInfo)
+/*void XGI_VesaLowResolution( unsigned short ModeNo , unsigned short ModeIdIndex ,PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT modeflag;
+    unsigned short modeflag;
 
     if ( ModeNo > 0x13 )
         modeflag = pVBInfo->EModeIDTable[ ModeIdIndex ].Ext_ModeFlag ;
@@ -2441,9 +2441,9 @@ void XGI_SetVCLKState(  PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo ,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_LoadDAC( USHORT ModeNo , USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo )
+void XGI_LoadDAC( unsigned short ModeNo , unsigned short ModeIdIndex,PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT data , data2 , time ,
+    unsigned short data , data2 , time ,
            i  , j , k , m , n , o ,
            si , di , bx , dl , al , ah , dh ,
            *table = NULL ;
@@ -2550,9 +2550,9 @@ void XGI_LoadDAC( USHORT ModeNo , USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_WriteDAC( USHORT dl , USHORT ah , USHORT al , USHORT dh,PVB_DEVICE_INFO pVBInfo )
+void XGI_WriteDAC( unsigned short dl , unsigned short ah , unsigned short al , unsigned short dh,PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT temp , bh , bl ;
+    unsigned short temp , bh , bl ;
 
     bh = ah ;
     bl = al ;
@@ -2575,9 +2575,9 @@ void XGI_WriteDAC( USHORT dl , USHORT ah , USHORT al , USHORT dh,PVB_DEVICE_INFO
             bh = temp ;
         }
     }
-    XGINew_SetReg3( pVBInfo->P3c9 , ( USHORT )dh ) ;
-    XGINew_SetReg3( pVBInfo->P3c9 , ( USHORT )bh ) ;
-    XGINew_SetReg3( pVBInfo->P3c9 , ( USHORT )bl ) ;
+    XGINew_SetReg3( pVBInfo->P3c9 , ( unsigned short )dh ) ;
+    XGINew_SetReg3( pVBInfo->P3c9 , ( unsigned short )bh ) ;
+    XGINew_SetReg3( pVBInfo->P3c9 , ( unsigned short )bl ) ;
 }
 
 #if 0
@@ -2587,11 +2587,11 @@ void XGI_WriteDAC( USHORT dl , USHORT ah , USHORT al , USHORT dh,PVB_DEVICE_INFO
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_ClearBuffer( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo, PVB_DEVICE_INFO  pVBInfo)
+void XGI_ClearBuffer( PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned short ModeNo, PVB_DEVICE_INFO  pVBInfo)
 {
-    PVOID VideoMemoryAddress = ( PVOID )HwDeviceExtension->pjVideoMemoryAddress ;
-    ULONG AdapterMemorySize  = ( ULONG )HwDeviceExtension->ulVideoMemorySize ;
-    PUSHORT pBuffer ;
+    void * VideoMemoryAddress = ( void * )HwDeviceExtension->pjVideoMemoryAddress ;
+    unsigned long AdapterMemorySize  = ( unsigned long )HwDeviceExtension->ulVideoMemorySize ;
+    unsigned short * pBuffer ;
     int i ;
 
     if ( pVBInfo->ModeType >= ModeEGA )
@@ -2633,10 +2633,10 @@ void XGI_ClearBuffer( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo, PVB
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetLCDAGroup( USHORT ModeNo , USHORT ModeIdIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO  pVBInfo )
+void XGI_SetLCDAGroup( unsigned short ModeNo , unsigned short ModeIdIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO  pVBInfo )
 {
-    USHORT RefreshRateTableIndex ;
-    /* USHORT temp ; */
+    unsigned short RefreshRateTableIndex ;
+    /* unsigned short temp ; */
 
     /* pVBInfo->SelectCRT2Rate = 0 ; */
 
@@ -2656,9 +2656,9 @@ void XGI_SetLCDAGroup( USHORT ModeNo , USHORT ModeIdIndex , PXGI_HW_DEVICE_INFO
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetLVDSResInfo( USHORT ModeNo , USHORT ModeIdIndex,PVB_DEVICE_INFO  pVBInfo )
+void XGI_GetLVDSResInfo( unsigned short ModeNo , unsigned short ModeIdIndex,PVB_DEVICE_INFO  pVBInfo )
 {
-    USHORT resindex , xres , yres , modeflag ;
+    unsigned short resindex , xres , yres , modeflag ;
 
     if ( ModeNo <= 0x13 )
     {
@@ -2724,9 +2724,9 @@ void XGI_GetLVDSResInfo( USHORT ModeNo , USHORT ModeIdIndex,PVB_DEVICE_INFO  pVB
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetLVDSData(  USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex, PVB_DEVICE_INFO  pVBInfo )
+void XGI_GetLVDSData(  unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO  pVBInfo )
 {
-    USHORT tempbx ;
+    unsigned short tempbx ;
     XGI330_LVDSDataStruct *LCDPtr = NULL ;
     XGI330_CHTVDataStruct  *TVPtr = NULL ;
 
@@ -2787,11 +2787,11 @@ void XGI_GetLVDSData(  USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTa
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_ModCRT1Regs( USHORT ModeNo , USHORT ModeIdIndex ,
-                        USHORT RefreshRateTableIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO  pVBInfo )
+void XGI_ModCRT1Regs( unsigned short ModeNo , unsigned short ModeIdIndex ,
+                        unsigned short RefreshRateTableIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO  pVBInfo )
 {
-    UCHAR index ;
-    USHORT tempbx , i ;
+    unsigned char index ;
+    unsigned short tempbx , i ;
     XGI_LVDSCRT1HDataStruct  *LCDPtr = NULL ;
     XGI_LVDSCRT1VDataStruct  *LCDPtr1 =NULL ;
     /* XGI330_CHTVDataStruct *TVPtr = NULL ; */
@@ -2887,9 +2887,9 @@ void XGI_ModCRT1Regs( USHORT ModeNo , USHORT ModeIdIndex ,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetLVDSRegs( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex, PVB_DEVICE_INFO  pVBInfo )
+void XGI_SetLVDSRegs( unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO  pVBInfo )
 {
-    USHORT tempbx , tempax , tempcx , tempdx , push1 , push2 , modeflag ;
+    unsigned short tempbx , tempax , tempcx , tempdx , push1 , push2 , modeflag ;
     unsigned long temp , temp1 , temp2 , temp3 , push3 ;
     XGI330_LCDDataDesStruct  *LCDPtr = NULL ;
     XGI330_LCDDataDesStruct2  *LCDPtr1 = NULL ;
@@ -2977,8 +2977,8 @@ void XGI_SetLVDSRegs( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
             tempcx = tempcx >> 3 ;
             tempbx = tempbx >> 3 ;
 
-            XGINew_SetReg1( pVBInfo->Part1Port , 0x16 , ( USHORT )( tempbx & 0xff ) ) ;
-            XGINew_SetReg1( pVBInfo->Part1Port , 0x17 , ( USHORT )( tempcx & 0xff ) ) ;
+            XGINew_SetReg1( pVBInfo->Part1Port , 0x16 , ( unsigned short )( tempbx & 0xff ) ) ;
+            XGINew_SetReg1( pVBInfo->Part1Port , 0x17 , ( unsigned short )( tempcx & 0xff ) ) ;
 
             tempax = pVBInfo->HT ;
 
@@ -3006,7 +3006,7 @@ void XGI_SetLVDSRegs( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
             tempax |= tempcx ;
 
             XGINew_SetReg1( pVBInfo->Part1Port , 0x15 , tempax ) ;
-            XGINew_SetReg1( pVBInfo->Part1Port , 0x14 , ( USHORT )( tempbx & 0xff ) ) ;
+            XGINew_SetReg1( pVBInfo->Part1Port , 0x14 , ( unsigned short )( tempbx & 0xff ) ) ;
 
             tempax = pVBInfo->VT ;
             if ( pVBInfo->LCDInfo & EnableScalingLCD )
@@ -3020,13 +3020,13 @@ void XGI_SetLVDSRegs( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
             if ( tempcx >= tempax )
                 tempcx -= tempax ;
 
-            XGINew_SetReg1( pVBInfo->Part1Port , 0x1b , ( USHORT )( tempbx & 0xff ) ) ;
-            XGINew_SetReg1( pVBInfo->Part1Port , 0x1c , ( USHORT )( tempcx & 0xff ) ) ;
+            XGINew_SetReg1( pVBInfo->Part1Port , 0x1b , ( unsigned short )( tempbx & 0xff ) ) ;
+            XGINew_SetReg1( pVBInfo->Part1Port , 0x1c , ( unsigned short )( tempcx & 0xff ) ) ;
 
             tempbx = ( tempbx >> 8 ) & 0x07 ;
             tempcx = ( tempcx >> 8 ) & 0x07 ;
 
-            XGINew_SetReg1( pVBInfo->Part1Port , 0x1d , ( USHORT )( ( tempcx << 3 ) | tempbx ) ) ;
+            XGINew_SetReg1( pVBInfo->Part1Port , 0x1d , ( unsigned short )( ( tempcx << 3 ) | tempbx ) ) ;
 
             tempax = pVBInfo->VT ;
             if ( pVBInfo->LCDInfo & EnableScalingLCD )
@@ -3044,8 +3044,8 @@ void XGI_SetLVDSRegs( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
             if ( tempcx >= tempax )
                 tempcx -= tempax ;
 
-            XGINew_SetReg1( pVBInfo->Part1Port , 0x18 , ( USHORT )( tempbx & 0xff ) ) ;
-            XGINew_SetRegANDOR( pVBInfo->Part1Port , 0x19 , ~0x0f , ( USHORT )( tempcx & 0x0f ) ) ;
+            XGINew_SetReg1( pVBInfo->Part1Port , 0x18 , ( unsigned short )( tempbx & 0xff ) ) ;
+            XGINew_SetRegANDOR( pVBInfo->Part1Port , 0x19 , ~0x0f , ( unsigned short )( tempcx & 0x0f ) ) ;
 
             tempax = ( ( tempbx >> 8 ) & 0x07 ) << 3 ;
 
@@ -3066,7 +3066,7 @@ void XGI_SetLVDSRegs( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
             temp = tempax ;            /* 0430 ylshieh */
             temp1 = ( temp << 18 ) / tempbx ;
 
-            tempdx = ( USHORT )( ( temp << 18 ) % tempbx ) ;
+            tempdx = ( unsigned short )( ( temp << 18 ) % tempbx ) ;
 
             if ( tempdx != 0 )
             temp1 += 1 ;
@@ -3074,10 +3074,10 @@ void XGI_SetLVDSRegs( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
             temp2 = temp1 ;
             push3 = temp2 ;
 
-            XGINew_SetReg1( pVBInfo->Part1Port , 0x37 , ( USHORT )( temp2 & 0xff ) ) ;
-            XGINew_SetReg1( pVBInfo->Part1Port , 0x36 , ( USHORT )( ( temp2 >> 8 ) & 0xff ) ) ;
+            XGINew_SetReg1( pVBInfo->Part1Port , 0x37 , ( unsigned short )( temp2 & 0xff ) ) ;
+            XGINew_SetReg1( pVBInfo->Part1Port , 0x36 , ( unsigned short )( ( temp2 >> 8 ) & 0xff ) ) ;
 
-            tempbx = ( USHORT )( temp2 >> 16 ) ;
+            tempbx = ( unsigned short )( temp2 >> 16 ) ;
             tempax = tempbx & 0x03 ;
 
             tempbx = pVBInfo->VGAVDE ;
@@ -3089,10 +3089,10 @@ void XGI_SetLVDSRegs( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
             if ( pVBInfo->VBType & VB_XGI301C )
             {
                 temp2 = push3 ;
-      	        XGINew_SetReg1( pVBInfo->Part4Port , 0x3c , ( USHORT )( temp2 & 0xff ) ) ;
-      	        XGINew_SetReg1( pVBInfo->Part4Port , 0x3b , ( USHORT )( ( temp2 >> 8 ) & 0xff ) ) ;
-      	        tempbx = ( USHORT )( temp2 >> 16 ) ;
-      	        XGINew_SetRegANDOR( pVBInfo->Part4Port , 0x3a , ~0xc0 , ( USHORT )( ( tempbx & 0xff ) << 6 ) ) ;
+      	        XGINew_SetReg1( pVBInfo->Part4Port , 0x3c , ( unsigned short )( temp2 & 0xff ) ) ;
+      	        XGINew_SetReg1( pVBInfo->Part4Port , 0x3b , ( unsigned short )( ( temp2 >> 8 ) & 0xff ) ) ;
+      	        tempbx = ( unsigned short )( temp2 >> 16 ) ;
+      	        XGINew_SetRegANDOR( pVBInfo->Part4Port , 0x3a , ~0xc0 , ( unsigned short )( ( tempbx & 0xff ) << 6 ) ) ;
 
                 tempcx = pVBInfo->VGAVDE ;
                 if ( tempcx == pVBInfo->VDE )
@@ -3106,7 +3106,7 @@ void XGI_SetLVDSRegs( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
 
             temp1 = tempcx << 16 ;
 
-            tempax = ( USHORT )( temp1 / tempbx ) ;
+            tempax = ( unsigned short )( temp1 / tempbx ) ;
 
             if ( ( tempbx & 0xffff ) == ( tempcx & 0xffff ) )
                 tempax = 65535 ;
@@ -3120,28 +3120,28 @@ void XGI_SetLVDSRegs( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
 
             temp3 = ( temp3 & 0xffff0000 ) + ( temp1 & 0xffff ) ;
 
-            tempax = ( USHORT )( temp3 & 0xff ) ;
+            tempax = ( unsigned short )( temp3 & 0xff ) ;
             XGINew_SetReg1( pVBInfo->Part1Port , 0x1f , tempax ) ;
 
             temp1 = pVBInfo->VGAVDE << 18 ;
             temp1 = temp1 / push3 ;
-            tempbx = ( USHORT )( temp1 & 0xffff ) ;
+            tempbx = ( unsigned short )( temp1 & 0xffff ) ;
 
             if ( pVBInfo->LCDResInfo == Panel1024x768 )
                 tempbx -= 1 ;
 
             tempax = ( ( tempbx >> 8 ) & 0xff ) << 3 ;
-            tempax |= ( USHORT )( ( temp3 >> 8 ) & 0x07 ) ;
-            XGINew_SetReg1( pVBInfo->Part1Port , 0x20 , ( USHORT )( tempax & 0xff ) ) ;
-            XGINew_SetReg1( pVBInfo->Part1Port , 0x21 , ( USHORT )( tempbx & 0xff ) ) ;
+            tempax |= ( unsigned short )( ( temp3 >> 8 ) & 0x07 ) ;
+            XGINew_SetReg1( pVBInfo->Part1Port , 0x20 , ( unsigned short )( tempax & 0xff ) ) ;
+            XGINew_SetReg1( pVBInfo->Part1Port , 0x21 , ( unsigned short )( tempbx & 0xff ) ) ;
 
             temp3 = temp3 >> 16 ;
 
             if ( modeflag & HalfDCLK )
                 temp3 = temp3 >> 1 ;
 
-            XGINew_SetReg1(pVBInfo->Part1Port , 0x22 , ( USHORT )( ( temp3 >> 8 ) & 0xff ) ) ;
-            XGINew_SetReg1(pVBInfo->Part1Port , 0x23 , ( USHORT )( temp3 & 0xff ) ) ;
+            XGINew_SetReg1(pVBInfo->Part1Port , 0x22 , ( unsigned short )( ( temp3 >> 8 ) & 0xff ) ) ;
+            XGINew_SetReg1(pVBInfo->Part1Port , 0x23 , ( unsigned short )( temp3 & 0xff ) ) ;
         }
     }
 }
@@ -3153,9 +3153,9 @@ void XGI_SetLVDSRegs( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRT2ECLK( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex, PVB_DEVICE_INFO  pVBInfo )
+void XGI_SetCRT2ECLK( unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO  pVBInfo )
 {
-    UCHAR di_0 , di_1 , tempal ;
+    unsigned char di_0 , di_1 , tempal ;
     int i ;
 
     tempal = XGI_GetVCLKPtr( RefreshRateTableIndex , ModeNo , ModeIdIndex, pVBInfo ) ;
@@ -3164,7 +3164,7 @@ void XGI_SetCRT2ECLK( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
 
     for( i = 0 ; i < 4 ; i++ )
     {
-        XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x31 , ~0x30 , ( USHORT )( 0x10 * i ) ) ;
+        XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x31 , ~0x30 , ( unsigned short )( 0x10 * i ) ) ;
         if ( pVBInfo->IF_DEF_CH7007 == 1 )
         {
             XGINew_SetReg1( pVBInfo->P3c4 , 0x2b , di_0 ) ;
@@ -3192,7 +3192,7 @@ void XGI_SetCRT2ECLK( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
 /* --------------------------------------------------------------------- */
 void XGI_UpdateModeInfo( PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO  pVBInfo )
 {
-    USHORT tempcl ,
+    unsigned short tempcl ,
            tempch ,
            temp ,
            tempbl ,
@@ -3322,7 +3322,7 @@ void XGI_GetVGAType( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO  pVB
 /* --------------------------------------------------------------------- */
 void XGI_GetVBType(PVB_DEVICE_INFO  pVBInfo)
 {
-    USHORT flag , tempbx , tempah ;
+    unsigned short flag , tempbx , tempah ;
 
     if ( pVBInfo->IF_DEF_CH7007 == 1 )
     {
@@ -3383,9 +3383,9 @@ void XGI_GetVBType(PVB_DEVICE_INFO  pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetVBInfo( USHORT ModeNo , USHORT ModeIdIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO  pVBInfo )
+void XGI_GetVBInfo( unsigned short ModeNo , unsigned short ModeIdIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO  pVBInfo )
 {
-    USHORT tempax ,
+    unsigned short tempax ,
            push ,
            tempbx ,
            temp ,
@@ -3624,9 +3624,9 @@ void XGI_GetVBInfo( USHORT ModeNo , USHORT ModeIdIndex , PXGI_HW_DEVICE_INFO HwD
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetTVInfo( USHORT ModeNo , USHORT ModeIdIndex ,PVB_DEVICE_INFO  pVBInfo )
+void XGI_GetTVInfo( unsigned short ModeNo , unsigned short ModeIdIndex ,PVB_DEVICE_INFO  pVBInfo )
 {
-    USHORT temp ,
+    unsigned short temp ,
            tempbx = 0 ,
            resinfo = 0 ,
            modeflag ,
@@ -3759,9 +3759,9 @@ void XGI_GetTVInfo( USHORT ModeNo , USHORT ModeIdIndex ,PVB_DEVICE_INFO  pVBInfo
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_GetLCDInfo( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
+bool XGI_GetLCDInfo( unsigned short ModeNo , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT temp ,
+    unsigned short temp ,
            tempax ,
            tempbx ,
            modeflag ,
@@ -3968,7 +3968,7 @@ BOOLEAN XGI_GetLCDInfo( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBI
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_SearchModeID( USHORT ModeNo , USHORT *ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+bool XGI_SearchModeID( unsigned short ModeNo , unsigned short *ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
 
     if ( ModeNo <= 5 )
@@ -4017,9 +4017,9 @@ BOOLEAN XGI_SearchModeID( USHORT ModeNo , USHORT *ModeIdIndex, PVB_DEVICE_INFO p
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGINew_CheckMemorySize(PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT ModeNo,USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo)
+bool XGINew_CheckMemorySize(PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short ModeNo,unsigned short ModeIdIndex,PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT memorysize ,
+    unsigned short memorysize ,
            modeflag ,
            temp ,
            temp1 ,
@@ -4099,10 +4099,10 @@ BOOLEAN XGINew_CheckMemorySize(PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT Mode
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-/*void XGINew_IsLowResolution( USHORT ModeNo , USHORT ModeIdIndex, BOOLEAN XGINew_CheckMemorySize(PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT ModeNo,USHORT ModeIdIndex,PVB_DEVICE_INFO pVBInfo)
+/*void XGINew_IsLowResolution( unsigned short ModeNo , unsigned short ModeIdIndex, bool XGINew_CheckMemorySize(PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short ModeNo,unsigned short ModeIdIndex,PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT data ;
-    USHORT ModeFlag ;
+    unsigned short data ;
+    unsigned short ModeFlag ;
 
     data = XGINew_GetReg1( pVBInfo->P3c4 , 0x0F ) ;
     data &= 0x7F ;
@@ -4261,56 +4261,56 @@ void XGI_WaitDisply( PVB_DEVICE_INFO pVBInfo )
 
 void XGI_SenseCRT1( PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR CRTCData[ 17 ] = { 0x5F , 0x4F , 0x50 , 0x82 , 0x55 , 0x81 ,
+    unsigned char CRTCData[ 17 ] = { 0x5F , 0x4F , 0x50 , 0x82 , 0x55 , 0x81 ,
                              0x0B , 0x3E , 0xE9 , 0x0B , 0xDF , 0xE7 ,
                              0x04 , 0x00 , 0x00 , 0x05 , 0x00 } ;
 
-    UCHAR SR01 = 0 , SR1F = 0 , SR07 = 0 , SR06 = 0 ;
+    unsigned char SR01 = 0 , SR1F = 0 , SR07 = 0 , SR06 = 0 ;
 
-    UCHAR CR17 , CR63 , SR31 ;
-    USHORT temp ;
-    UCHAR DAC_TEST_PARMS[ 3 ] = { 0x0F , 0x0F , 0x0F } ;
+    unsigned char CR17 , CR63 , SR31 ;
+    unsigned short temp ;
+    unsigned char DAC_TEST_PARMS[ 3 ] = { 0x0F , 0x0F , 0x0F } ;
 
     int i ;
     XGINew_SetReg1( pVBInfo->P3c4 , 0x05 , 0x86 ) ;
 
     /* [2004/05/06] Vicent to fix XG42 single LCD sense to CRT+LCD */
     XGINew_SetReg1( pVBInfo->P3d4 , 0x57 , 0x4A ) ;
-    XGINew_SetReg1( pVBInfo->P3d4 , 0x53 , ( UCHAR )( XGINew_GetReg1( pVBInfo->P3d4 , 0x53 ) | 0x02 ) ) ;
+    XGINew_SetReg1( pVBInfo->P3d4 , 0x53 , ( unsigned char )( XGINew_GetReg1( pVBInfo->P3d4 , 0x53 ) | 0x02 ) ) ;
 
-    SR31 = ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x31 ) ;
-    CR63 = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x63 ) ;
-    SR01 = ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x01 ) ;
+    SR31 = ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x31 ) ;
+    CR63 = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x63 ) ;
+    SR01 = ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x01 ) ;
 
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x01 , ( UCHAR )( SR01 & 0xDF ) ) ;
-    XGINew_SetReg1( pVBInfo->P3d4 , 0x63 , ( UCHAR )( CR63 & 0xBF ) ) ;
+    XGINew_SetReg1( pVBInfo->P3c4 , 0x01 , ( unsigned char )( SR01 & 0xDF ) ) ;
+    XGINew_SetReg1( pVBInfo->P3d4 , 0x63 , ( unsigned char )( CR63 & 0xBF ) ) ;
 
-    CR17 = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x17 ) ;
-    XGINew_SetReg1( pVBInfo->P3d4 , 0x17 , ( UCHAR )( CR17 | 0x80 ) ) ;
+    CR17 = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x17 ) ;
+    XGINew_SetReg1( pVBInfo->P3d4 , 0x17 , ( unsigned char )( CR17 | 0x80 ) ) ;
 
-    SR1F = ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x1F ) ;
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x1F , ( UCHAR )( SR1F | 0x04 ) ) ;
+    SR1F = ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x1F ) ;
+    XGINew_SetReg1( pVBInfo->P3c4 , 0x1F , ( unsigned char )( SR1F | 0x04 ) ) ;
 
-    SR07 = ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x07 ) ;
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x07 , ( UCHAR )( SR07 & 0xFB ) ) ;
-    SR06 = ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x06 ) ;
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x06 , ( UCHAR )( SR06 & 0xC3 ) ) ;
+    SR07 = ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x07 ) ;
+    XGINew_SetReg1( pVBInfo->P3c4 , 0x07 , ( unsigned char )( SR07 & 0xFB ) ) ;
+    SR06 = ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x06 ) ;
+    XGINew_SetReg1( pVBInfo->P3c4 , 0x06 , ( unsigned char )( SR06 & 0xC3 ) ) ;
 
     XGINew_SetReg1( pVBInfo->P3d4 , 0x11 , 0x00 ) ;
 
     for( i = 0 ; i < 8 ; i++ )
-        XGINew_SetReg1( pVBInfo->P3d4 , ( USHORT )i , CRTCData[ i ] ) ;
+        XGINew_SetReg1( pVBInfo->P3d4 , ( unsigned short )i , CRTCData[ i ] ) ;
 
     for( i = 8 ; i < 11 ; i++ )
-        XGINew_SetReg1( pVBInfo->P3d4 , ( USHORT )( i + 8 ) , CRTCData[ i ] ) ;
+        XGINew_SetReg1( pVBInfo->P3d4 , ( unsigned short )( i + 8 ) , CRTCData[ i ] ) ;
 
     for( i = 11 ; i < 13 ; i++ )
-        XGINew_SetReg1( pVBInfo->P3d4 , ( USHORT )( i + 4 ) , CRTCData[ i ] ) ;
+        XGINew_SetReg1( pVBInfo->P3d4 , ( unsigned short )( i + 4 ) , CRTCData[ i ] ) ;
 
     for( i = 13 ; i < 16 ; i++ )
-        XGINew_SetReg1( pVBInfo->P3c4 , ( USHORT )( i - 3 ) , CRTCData[ i ] ) ;
+        XGINew_SetReg1( pVBInfo->P3c4 , ( unsigned short )( i - 3 ) , CRTCData[ i ] ) ;
 
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x0E , ( UCHAR )( CRTCData[ 16 ] & 0xE0 ) ) ;
+    XGINew_SetReg1( pVBInfo->P3c4 , 0x0E , ( unsigned char )( CRTCData[ 16 ] & 0xE0 ) ) ;
 
     XGINew_SetReg1( pVBInfo->P3c4 , 0x31 , 0x00 ) ;
     XGINew_SetReg1( pVBInfo->P3c4 , 0x2B , 0x1B ) ;
@@ -4320,9 +4320,9 @@ void XGI_SenseCRT1( PVB_DEVICE_INFO pVBInfo )
 
     for( i = 0 ; i < 256 ; i++ )
     {
-        XGINew_SetReg3( ( pVBInfo->P3c8 + 1 ) , ( UCHAR )DAC_TEST_PARMS[ 0 ] ) ;
-        XGINew_SetReg3( ( pVBInfo->P3c8 + 1 ) , ( UCHAR )DAC_TEST_PARMS[ 1 ] ) ;
-        XGINew_SetReg3( ( pVBInfo->P3c8 + 1 ) , ( UCHAR )DAC_TEST_PARMS[ 2 ] ) ;
+        XGINew_SetReg3( ( pVBInfo->P3c8 + 1 ) , ( unsigned char )DAC_TEST_PARMS[ 0 ] ) ;
+        XGINew_SetReg3( ( pVBInfo->P3c8 + 1 ) , ( unsigned char )DAC_TEST_PARMS[ 1 ] ) ;
+        XGINew_SetReg3( ( pVBInfo->P3c8 + 1 ) , ( unsigned char )DAC_TEST_PARMS[ 2 ] ) ;
     }
 
     XGI_VBLongWait( pVBInfo ) ;
@@ -4358,8 +4358,8 @@ void XGI_SenseCRT1( PVB_DEVICE_INFO pVBInfo )
     XGINew_SetReg1( pVBInfo->P3c4 , 0x31 , SR31 ) ;
 
     /* [2004/05/11] Vicent */
-    XGINew_SetReg1( pVBInfo->P3d4 , 0x53 , ( UCHAR )( XGINew_GetReg1( pVBInfo->P3d4 , 0x53 ) & 0xFD ) ) ;
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x1F , ( UCHAR ) SR1F ) ;
+    XGINew_SetReg1( pVBInfo->P3d4 , 0x53 , ( unsigned char )( XGINew_GetReg1( pVBInfo->P3d4 , 0x53 ) & 0xFD ) ) ;
+    XGINew_SetReg1( pVBInfo->P3c4 , 0x1F , ( unsigned char ) SR1F ) ;
 }
 
 
@@ -4388,9 +4388,9 @@ void XGI_WaitDisplay( PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_SetCRT2Group301( USHORT ModeNo , PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo )
+bool XGI_SetCRT2Group301( unsigned short ModeNo , PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempbx ,
+    unsigned short tempbx ,
            ModeIdIndex ,
            RefreshRateTableIndex ;
 
@@ -4436,9 +4436,9 @@ void XGI_AutoThreshold(  PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SaveCRT2Info( USHORT ModeNo , PVB_DEVICE_INFO pVBInfo)
+void XGI_SaveCRT2Info( unsigned short ModeNo , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT temp1 ,
+    unsigned short temp1 ,
            temp2 ;
 
     XGINew_SetReg1( pVBInfo->P3d4 , 0x34 , ModeNo ) ;  /* reserve CR34 for CRT1 Mode No */
@@ -4454,9 +4454,9 @@ void XGI_SaveCRT2Info( USHORT ModeNo , PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetCRT2ResInfo( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_GetCRT2ResInfo( unsigned short ModeNo , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT xres ,
+    unsigned short xres ,
            yres ,
            modeflag ,
            resindex ;
@@ -4551,7 +4551,7 @@ void XGI_GetCRT2ResInfo( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVB
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_IsLCDDualLink( PVB_DEVICE_INFO pVBInfo )
+bool XGI_IsLCDDualLink( PVB_DEVICE_INFO pVBInfo )
 {
 
     if ( ( ( ( pVBInfo->VBInfo & SetCRT2ToLCD ) | SetCRT2ToLCDA ) ) && ( pVBInfo->LCDInfo & SetLCDDualLink ) ) /* shampoo0129 */
@@ -4567,9 +4567,9 @@ BOOLEAN XGI_IsLCDDualLink( PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetCRT2Data(  USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_GetCRT2Data(  unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempax = 0,
+    unsigned short tempax = 0,
            tempbx ,
            modeflag ,
            resinfo ;
@@ -4793,9 +4793,9 @@ void XGI_GetCRT2Data(  USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTa
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRT2VCLK( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetCRT2VCLK( unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR di_0 ,
+    unsigned char di_0 ,
           di_1 ,
           tempal ;
 
@@ -4830,9 +4830,9 @@ void XGI_SetCRT2VCLK( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTab
 /* Output : al -> VCLK Index */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetLCDVCLKPtr( UCHAR* di_0 , UCHAR *di_1, PVB_DEVICE_INFO pVBInfo )
+void XGI_GetLCDVCLKPtr( unsigned char* di_0 , unsigned char *di_1, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT index ;
+    unsigned short index ;
 
     if ( pVBInfo->VBInfo & ( SetCRT2ToLCD | SetCRT2ToLCDA ) )
     {
@@ -4866,15 +4866,15 @@ void XGI_GetLCDVCLKPtr( UCHAR* di_0 , UCHAR *di_1, PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-UCHAR XGI_GetVCLKPtr(USHORT RefreshRateTableIndex,USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
+unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
 {
 
-    USHORT index ,
+    unsigned short index ,
            modeflag ;
-    USHORT tempbx ;
+    unsigned short tempbx ;
 
-    UCHAR tempal ;
-    UCHAR *CHTVVCLKPtr = NULL ;
+    unsigned char tempal ;
+    unsigned char *CHTVVCLKPtr = NULL ;
 
     if ( ModeNo <= 0x13 )
         modeflag = pVBInfo->SModeIDTable[ ModeIdIndex ].St_ModeFlag ;      /* si+St_ResInfo */
@@ -5026,7 +5026,7 @@ UCHAR XGI_GetVCLKPtr(USHORT RefreshRateTableIndex,USHORT ModeNo,USHORT ModeIdInd
 
     }
 
-    tempal = ( UCHAR )XGINew_GetReg2( ( pVBInfo->P3ca + 0x02 ) ) ;
+    tempal = ( unsigned char )XGINew_GetReg2( ( pVBInfo->P3ca + 0x02 ) ) ;
     tempal = tempal >> 2 ;
     tempal &= 0x03 ;
 
@@ -5047,19 +5047,19 @@ UCHAR XGI_GetVCLKPtr(USHORT RefreshRateTableIndex,USHORT ModeNo,USHORT ModeIdInd
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetVCLKLen(UCHAR tempal,UCHAR* di_0,UCHAR* di_1, PVB_DEVICE_INFO pVBInfo)
+void XGI_GetVCLKLen(unsigned char tempal,unsigned char* di_0,unsigned char* di_1, PVB_DEVICE_INFO pVBInfo)
 {
     if ( pVBInfo->IF_DEF_CH7007 == 1 ) /* [Billy] 2007/05/16 */
     {
        /* VideoDebugPrint((0, "XGI_GetVCLKLen: pVBInfo->IF_DEF_CH7007==1\n")); */
-        *di_0 = ( UCHAR )XGI_CH7007VCLKData[ tempal ].SR2B ;
-        *di_1 = ( UCHAR )XGI_CH7007VCLKData[ tempal ].SR2C ;
+        *di_0 = ( unsigned char )XGI_CH7007VCLKData[ tempal ].SR2B ;
+        *di_1 = ( unsigned char )XGI_CH7007VCLKData[ tempal ].SR2C ;
     }
     else if ( pVBInfo->VBType & ( VB_XGI301 | VB_XGI301B | VB_XGI302B | VB_XGI301LV | VB_XGI302LV | VB_XGI301C ) )
     {
         if ( ( !( pVBInfo->VBInfo & SetCRT2ToLCDA ) ) && ( pVBInfo->SetFlag & ProgrammingCRT2 ) )
         {
-            *di_0 = ( UCHAR )XGI_VBVCLKData[ tempal ].SR2B ;
+            *di_0 = ( unsigned char )XGI_VBVCLKData[ tempal ].SR2B ;
             *di_1 = XGI_VBVCLKData[ tempal ].SR2C ;
         }
     }
@@ -5077,11 +5077,11 @@ void XGI_GetVCLKLen(UCHAR tempal,UCHAR* di_0,UCHAR* di_1, PVB_DEVICE_INFO pVBInf
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRT2Offset( USHORT ModeNo ,
-				   USHORT ModeIdIndex , USHORT RefreshRateTableIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetCRT2Offset( unsigned short ModeNo ,
+				   unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT offset ;
-    UCHAR temp ;
+    unsigned short offset ;
+    unsigned char temp ;
 
     if ( pVBInfo->VBInfo & SetInSlaveMode )
     {
@@ -5089,11 +5089,11 @@ void XGI_SetCRT2Offset( USHORT ModeNo ,
     }
 
     offset = XGI_GetOffset(  ModeNo , ModeIdIndex , RefreshRateTableIndex , HwDeviceExtension, pVBInfo ) ;
-    temp = ( UCHAR )( offset & 0xFF ) ;
+    temp = ( unsigned char )( offset & 0xFF ) ;
     XGINew_SetReg1( pVBInfo->Part1Port , 0x07 , temp ) ;
-    temp =( UCHAR)( ( offset & 0xFF00 ) >> 8 ) ;
+    temp =( unsigned char)( ( offset & 0xFF00 ) >> 8 ) ;
     XGINew_SetReg1( pVBInfo->Part1Port , 0x09 , temp ) ;
-    temp =( UCHAR )( ( ( offset >> 3 ) & 0xFF ) + 1 ) ;
+    temp =( unsigned char )( ( ( offset >> 3 ) & 0xFF ) + 1 ) ;
     XGINew_SetReg1( pVBInfo->Part1Port , 0x03 , temp ) ;
 }
 
@@ -5104,9 +5104,9 @@ void XGI_SetCRT2Offset( USHORT ModeNo ,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-USHORT XGI_GetOffset(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo)
+unsigned short XGI_GetOffset(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension,PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT temp ,
+    unsigned short temp ,
            colordepth ,
            modeinfo ,
            index ,
@@ -5166,10 +5166,10 @@ void XGI_SetCRT2FIFO( PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_PreSetGroup1(USHORT ModeNo , USHORT ModeIdIndex ,PXGI_HW_DEVICE_INFO HwDeviceExtension,
-                       USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_PreSetGroup1(unsigned short ModeNo , unsigned short ModeIdIndex ,PXGI_HW_DEVICE_INFO HwDeviceExtension,
+                       unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempcx = 0 ,
+    unsigned short tempcx = 0 ,
            CRT1Index = 0 ,
            resinfo = 0 ;
 
@@ -5200,10 +5200,10 @@ void XGI_PreSetGroup1(USHORT ModeNo , USHORT ModeIdIndex ,PXGI_HW_DEVICE_INFO Hw
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetGroup1( USHORT ModeNo , USHORT ModeIdIndex ,
-                            PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetGroup1( unsigned short ModeNo , unsigned short ModeIdIndex ,
+                            PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT temp = 0 ,
+    unsigned short temp = 0 ,
            tempax = 0 ,
            tempbx = 0 ,
            tempcx = 0 ,
@@ -5376,10 +5376,10 @@ void XGI_SetGroup1( USHORT ModeNo , USHORT ModeIdIndex ,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void  XGI_SetLockRegs( USHORT ModeNo , USHORT ModeIdIndex ,
-                                PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
+void  XGI_SetLockRegs( unsigned short ModeNo , unsigned short ModeIdIndex ,
+                                PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT push1 ,
+    unsigned short push1 ,
            push2 ,
            tempax ,
            tempbx = 0 ,
@@ -5823,10 +5823,10 @@ void  XGI_SetLockRegs( USHORT ModeNo , USHORT ModeIdIndex ,
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetGroup2( USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIndex,
+void XGI_SetGroup2( unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex,
                     PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT i ,
+    unsigned short i ,
            j ,
            tempax ,
            tempbx ,
@@ -5837,9 +5837,9 @@ void XGI_SetGroup2( USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIn
            modeflag ,
            resinfo ,
            crt2crtc ;
-    UCHAR *TimingPoint ;
+    unsigned char *TimingPoint ;
 
-    ULONG longtemp ,
+    unsigned long longtemp ,
           tempeax ,
           tempebx ,
           temp2 ,
@@ -5948,7 +5948,7 @@ void XGI_SetGroup2( USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIn
         tempax = ( tempax & 0x00FF ) | ( ( tempax & 0x00FF ) << 8 ) ;
         push1 = tempax ;
         temp = ( tempax & 0xFF00 ) >> 8 ;
-        temp += ( USHORT )TimingPoint[ 0 ] ;
+        temp += ( unsigned short )TimingPoint[ 0 ] ;
 
         if ( pVBInfo->VBType & ( VB_XGI301B | VB_XGI302B | VB_XGI301LV | VB_XGI302LV | VB_XGI301C ) )
         {
@@ -6225,7 +6225,7 @@ void XGI_SetGroup2( USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIn
             tempeax += 1 ;
         }
 
-        tempax = ( USHORT )tempeax ;
+        tempax = ( unsigned short )tempeax ;
 
 	/* 301b */
         if ( pVBInfo->VBType & ( VB_XGI301B | VB_XGI302B | VB_XGI301LV | VB_XGI302LV | VB_XGI301C ) )
@@ -6235,8 +6235,8 @@ void XGI_SetGroup2( USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIn
         /* end 301b */
 
         tempbx = push1 ;
-        tempbx =( USHORT )( ( ( tempeax & 0x0000FF00 ) & 0x1F00 ) | ( tempbx & 0x00FF ) ) ;
-        tempax =( USHORT )( ( ( tempeax & 0x000000FF ) << 8 ) | ( tempax & 0x00FF ) ) ;
+        tempbx =( unsigned short )( ( ( tempeax & 0x0000FF00 ) & 0x1F00 ) | ( tempbx & 0x00FF ) ) ;
+        tempax =( unsigned short )( ( ( tempeax & 0x000000FF ) << 8 ) | ( tempax & 0x00FF ) ) ;
         temp = ( tempax & 0xFF00 ) >> 8 ;
     }
     else
@@ -6289,7 +6289,7 @@ void XGI_SetGroup2( USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIn
 
     XGINew_SetReg1( pVBInfo->Part2Port , 0x4d , temp ) ;
     temp=XGINew_GetReg1( pVBInfo->Part2Port , 0x43 ) ;		/* 301b change */
-    XGINew_SetReg1( pVBInfo->Part2Port , 0x43 , ( USHORT )( temp - 3 ) ) ;
+    XGINew_SetReg1( pVBInfo->Part2Port , 0x43 , ( unsigned short )( temp - 3 ) ) ;
 
     if ( !( pVBInfo->TVInfo & ( SetYPbPrMode525p | SetYPbPrMode750p ) ) )
     {
@@ -6313,7 +6313,7 @@ void XGI_SetGroup2( USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIn
 
     if ( pVBInfo->TVInfo & SetPALMTV )
     {
-        tempax = ( UCHAR )XGINew_GetReg1( pVBInfo->Part2Port , 0x01 ) ;
+        tempax = ( unsigned char )XGINew_GetReg1( pVBInfo->Part2Port , 0x01 ) ;
         tempax-- ;
         XGINew_SetRegAND( pVBInfo->Part2Port , 0x01 , tempax ) ;
 
@@ -6342,9 +6342,9 @@ void XGI_SetGroup2( USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIn
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void  XGI_SetLCDRegs(USHORT ModeNo,USHORT ModeIdIndex, PXGI_HW_DEVICE_INFO HwDeviceExtension,USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo)
+void  XGI_SetLCDRegs(unsigned short ModeNo,unsigned short ModeIdIndex, PXGI_HW_DEVICE_INFO HwDeviceExtension,unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT push1 ,
+    unsigned short push1 ,
            push2 ,
            pushbx ,
            tempax ,
@@ -6596,9 +6596,9 @@ void  XGI_SetLCDRegs(USHORT ModeNo,USHORT ModeIdIndex, PXGI_HW_DEVICE_INFO HwDev
 /* Output : di -> Tap4 Reg. Setting Pointer */
 /* Description : */
 /* --------------------------------------------------------------------- */
-XGI301C_Tap4TimingStruct* XGI_GetTap4Ptr(USHORT tempcx, PVB_DEVICE_INFO pVBInfo)
+XGI301C_Tap4TimingStruct* XGI_GetTap4Ptr(unsigned short tempcx, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempax ,
+    unsigned short tempax ,
            tempbx ,
            i ;
 
@@ -6658,7 +6658,7 @@ XGI301C_Tap4TimingStruct* XGI_GetTap4Ptr(USHORT tempcx, PVB_DEVICE_INFO pVBInfo)
 /* --------------------------------------------------------------------- */
 void XGI_SetTap4Regs( PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT i ,
+    unsigned short i ,
            j ;
 
     XGI301C_Tap4TimingStruct *Tap4TimingPtr ;
@@ -6694,11 +6694,11 @@ void XGI_SetTap4Regs( PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetGroup3(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
+void XGI_SetGroup3(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT i;
-    UCHAR *tempdi;
-    USHORT  modeflag;
+    unsigned short i;
+    unsigned char *tempdi;
+    unsigned short  modeflag;
 
     if(ModeNo<=0x13)
     {
@@ -6781,16 +6781,16 @@ void XGI_SetGroup3(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetGroup4(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
+void XGI_SetGroup4(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempax ,
+    unsigned short tempax ,
            tempcx ,
            tempbx ,
            modeflag ,
            temp ,
            temp2 ;
 
-    ULONG tempebx ,
+    unsigned long tempebx ,
           tempeax ,
           templong ;
 
@@ -6912,12 +6912,12 @@ void XGI_SetGroup4(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex
     }
 
 
-    temp = ( USHORT )( tempebx & 0x000000FF ) ;
+    temp = ( unsigned short )( tempebx & 0x000000FF ) ;
     XGINew_SetReg1( pVBInfo->Part4Port , 0x1B , temp ) ;
 
-    temp = ( USHORT )( ( tempebx & 0x0000FF00 ) >> 8 ) ;
+    temp = ( unsigned short )( ( tempebx & 0x0000FF00 ) >> 8 ) ;
     XGINew_SetReg1( pVBInfo->Part4Port , 0x1A , temp ) ;
-    tempbx = ( USHORT )( tempebx >> 16 ) ;
+    tempbx = ( unsigned short )( tempebx >> 16 ) ;
     temp = tempbx & 0x00FF ;
     temp = temp << 4 ;
     temp |= ( ( tempcx & 0xFF00 ) >> 8 ) ;
@@ -7032,9 +7032,9 @@ void XGI_SetGroup4(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetGroup5( USHORT ModeNo , USHORT ModeIdIndex , PVB_DEVICE_INFO pVBInfo)
+void XGI_SetGroup5( unsigned short ModeNo , unsigned short ModeIdIndex , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT Pindex ,
+    unsigned short Pindex ,
            Pdata ;
 
     Pindex = pVBInfo->Part5Port ;
@@ -7057,9 +7057,9 @@ void XGI_SetGroup5( USHORT ModeNo , USHORT ModeIdIndex , PVB_DEVICE_INFO pVBInfo
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void* XGI_GetLcdPtr( USHORT BX , USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
+void* XGI_GetLcdPtr( unsigned short BX , unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT i ,
+    unsigned short i ,
            tempdx ,
            tempcx ,
            tempbx ,
@@ -7559,9 +7559,9 @@ void* XGI_GetLcdPtr( USHORT BX , USHORT ModeNo , USHORT ModeIdIndex , USHORT Ref
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void* XGI_GetTVPtr (USHORT BX,USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
+void* XGI_GetTVPtr (unsigned short BX,unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT i , tempdx , tempbx , tempal , modeflag , table ;
+    unsigned short i , tempdx , tempbx , tempal , modeflag , table ;
     XGI330_TVDataTablStruct *tempdi = 0 ;
 
     tempbx = BX ;
@@ -7724,11 +7724,11 @@ void* XGI_GetTVPtr (USHORT BX,USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRat
 /* Output : TRUE -> Skip backlight control */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_BacklightByDrv( PVB_DEVICE_INFO pVBInfo )
+bool XGI_BacklightByDrv( PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR tempah ;
+    unsigned char tempah ;
 
-    tempah = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x3A ) ;
+    tempah = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x3A ) ;
     if ( tempah & BacklightControlBit )
         return TRUE ;
     else
@@ -7796,9 +7796,9 @@ void XGI_DisableGatingCRT(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 /* : bl : 3 ; T3 : the duration between CPL off and signal off */
 /* : bl : 4 ; T4 : the duration signal off and Vdd off */
 /* --------------------------------------------------------------------- */
-void XGI_SetPanelDelay(USHORT tempbl, PVB_DEVICE_INFO pVBInfo)
+void XGI_SetPanelDelay(unsigned short tempbl, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT index ;
+    unsigned short index ;
 
     index = XGI_GetLCDCapPtr(pVBInfo) ;
 
@@ -7826,7 +7826,7 @@ void XGI_SetPanelDelay(USHORT tempbl, PVB_DEVICE_INFO pVBInfo)
 /* = 1011b = 0Bh ; Backlight off, Power on */
 /* = 1111b = 0Fh ; Backlight off, Power off */
 /* --------------------------------------------------------------------- */
-void XGI_SetPanelPower(USHORT tempah,USHORT tempbl, PVB_DEVICE_INFO pVBInfo)
+void XGI_SetPanelPower(unsigned short tempah,unsigned short tempbl, PVB_DEVICE_INFO pVBInfo)
 {
     if ( pVBInfo->VBType & ( VB_XGI301LV | VB_XGI302LV | VB_XGI301C ) )
         XGINew_SetRegANDOR( pVBInfo->Part4Port , 0x26 , tempbl , tempah ) ;
@@ -7834,10 +7834,10 @@ void XGI_SetPanelPower(USHORT tempah,USHORT tempbl, PVB_DEVICE_INFO pVBInfo)
         XGINew_SetRegANDOR( pVBInfo->P3c4 , 0x11 , tempbl , tempah ) ;
 }
 
-UCHAR XG21GPIODataTransfer(UCHAR ujDate)
+unsigned char XG21GPIODataTransfer(unsigned char ujDate)
 {
-    UCHAR  ujRet = 0;
-    UCHAR  i = 0;
+    unsigned char  ujRet = 0;
+    unsigned char  i = 0;
 
     for (i=0; i<8; i++)
 	{
@@ -7855,9 +7855,9 @@ UCHAR XG21GPIODataTransfer(UCHAR ujDate)
 /*      bl[1] : LVDS backlight                                                */
 /*      bl[0] : LVDS VDD                                                      */
 /*----------------------------------------------------------------------------*/
-UCHAR XGI_XG21GetPSCValue(PVB_DEVICE_INFO pVBInfo)
+unsigned char XGI_XG21GetPSCValue(PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR CR4A,temp;
+    unsigned char CR4A,temp;
 
     CR4A = XGINew_GetReg1( pVBInfo->P3d4 , 0x4A ) ;
     XGINew_SetRegAND( pVBInfo->P3d4 , 0x4A , ~0x23 ) ; /* enable GPIO write */
@@ -7876,9 +7876,9 @@ UCHAR XGI_XG21GetPSCValue(PVB_DEVICE_INFO pVBInfo)
 /*      bl[1] : LVDS backlight                                                */
 /*      bl[0] : LVDS VDD                                                      */
 /*----------------------------------------------------------------------------*/
-UCHAR XGI_XG27GetPSCValue(PVB_DEVICE_INFO pVBInfo)
+unsigned char XGI_XG27GetPSCValue(PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR CR4A,CRB4,temp;
+    unsigned char CR4A,CRB4,temp;
 
     CR4A = XGINew_GetReg1( pVBInfo->P3d4 , 0x4A ) ;
     XGINew_SetRegAND( pVBInfo->P3d4 , 0x4A , ~0x0C ) ; /* enable GPIO write */
@@ -7901,9 +7901,9 @@ UCHAR XGI_XG27GetPSCValue(PVB_DEVICE_INFO pVBInfo)
 /*          000010b : clear bit 1, to set bit1                                */
 /*          000001b : clear bit 0, to set bit0                                */
 /*----------------------------------------------------------------------------*/
-void XGI_XG21BLSignalVDD(USHORT tempbh,USHORT tempbl, PVB_DEVICE_INFO pVBInfo)
+void XGI_XG21BLSignalVDD(unsigned short tempbh,unsigned short tempbl, PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR CR4A,temp;
+    unsigned char CR4A,temp;
 
     CR4A = XGINew_GetReg1( pVBInfo->P3d4 , 0x4A ) ;
     tempbh &= 0x23;
@@ -7926,10 +7926,10 @@ void XGI_XG21BLSignalVDD(USHORT tempbh,USHORT tempbl, PVB_DEVICE_INFO pVBInfo)
     XGINew_SetReg1( pVBInfo->P3d4 , 0x48 , temp ) ;
 }
 
-void XGI_XG27BLSignalVDD(USHORT tempbh,USHORT tempbl, PVB_DEVICE_INFO pVBInfo)
+void XGI_XG27BLSignalVDD(unsigned short tempbh,unsigned short tempbl, PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR CR4A,temp;
-    USHORT tempbh0,tempbl0;
+    unsigned char CR4A,temp;
+    unsigned short tempbh0,tempbl0;
 
     tempbh0 = tempbh;
     tempbl0 = tempbl;
@@ -7957,9 +7957,9 @@ void XGI_XG27BLSignalVDD(USHORT tempbh,USHORT tempbl, PVB_DEVICE_INFO pVBInfo)
 }
 
 /* --------------------------------------------------------------------- */
-USHORT XGI_GetLVDSOEMTableIndex(PVB_DEVICE_INFO pVBInfo)
+unsigned short XGI_GetLVDSOEMTableIndex(PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT index ;
+    unsigned short index ;
 
     index = XGINew_GetReg1( pVBInfo->P3d4 , 0x36 ) ;
     if (index<sizeof(XGI21_LCDCapList)/sizeof(XGI21_LVDSCapStruct))
@@ -7979,9 +7979,9 @@ USHORT XGI_GetLVDSOEMTableIndex(PVB_DEVICE_INFO pVBInfo)
 /* : bl : 3 ; T3 : the duration between CPL off and signal off */
 /* : bl : 4 ; T4 : the duration signal off and Vdd off */
 /* --------------------------------------------------------------------- */
-void XGI_XG21SetPanelDelay(USHORT tempbl, PVB_DEVICE_INFO pVBInfo)
+void XGI_XG21SetPanelDelay(unsigned short tempbl, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT index ;
+    unsigned short index ;
 
     index = XGI_GetLVDSOEMTableIndex( pVBInfo );
     if ( tempbl == 1 )
@@ -7997,9 +7997,9 @@ void XGI_XG21SetPanelDelay(USHORT tempbl, PVB_DEVICE_INFO pVBInfo)
         XGINew_LCD_Wait_Time( pVBInfo->XG21_LVDSCapList[ index ].PSC_S4, pVBInfo ) ;
 }
 
-BOOLEAN XGI_XG21CheckLVDSMode(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+bool XGI_XG21CheckLVDSMode(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT xres ,
+    unsigned short xres ,
            yres ,
            colordepth ,
            modeflag ,
@@ -8062,7 +8062,7 @@ BOOLEAN XGI_XG21CheckLVDSMode(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO
 
 void XGI_SetXG21FPBits(PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR temp;
+    unsigned char temp;
 
     temp = XGINew_GetReg1( pVBInfo->P3d4  , 0x37 ) ;  /* D[0] 1: 18bit */
     temp = ( temp & 1 ) << 6;
@@ -8073,7 +8073,7 @@ void XGI_SetXG21FPBits(PVB_DEVICE_INFO pVBInfo)
 
 void XGI_SetXG27FPBits(PVB_DEVICE_INFO pVBInfo)
 {
-    UCHAR temp;
+    unsigned char temp;
 
     temp = XGINew_GetReg1( pVBInfo->P3d4  , 0x37 ) ;  /* D[1:0] 01: 18bit, 00: dual 12, 10: single 24 */
     temp = ( temp & 3 ) << 6;
@@ -8082,27 +8082,27 @@ void XGI_SetXG27FPBits(PVB_DEVICE_INFO pVBInfo)
 
 }
 
-void XGI_SetXG21LVDSPara(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetXG21LVDSPara(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR temp,Miscdata;
-    USHORT xres ,
+    unsigned char temp,Miscdata;
+    unsigned short xres ,
            yres ,
            modeflag ,
            resindex ,
            lvdstableindex ;
-    USHORT LVDSHT,LVDSHBS,LVDSHRS,LVDSHRE,LVDSHBE;
-    USHORT LVDSVT,LVDSVBS,LVDSVRS,LVDSVRE,LVDSVBE;
-    USHORT value;
+    unsigned short LVDSHT,LVDSHBS,LVDSHRS,LVDSHRE,LVDSHBE;
+    unsigned short LVDSVT,LVDSVBS,LVDSVRS,LVDSVRE,LVDSVBE;
+    unsigned short value;
 
     lvdstableindex = XGI_GetLVDSOEMTableIndex( pVBInfo );
 
-    temp = (UCHAR) ( ( pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability & (LCDPolarity << 8 ) ) >> 8 );
+    temp = (unsigned char) ( ( pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability & (LCDPolarity << 8 ) ) >> 8 );
     temp &= LCDPolarity;
-    Miscdata =(UCHAR) XGINew_GetReg2(pVBInfo->P3cc) ;
+    Miscdata =(unsigned char) XGINew_GetReg2(pVBInfo->P3cc) ;
 
     XGINew_SetReg3( pVBInfo->P3c2 , (Miscdata & 0x3F) | temp ) ;
 
-    temp = (UCHAR) ( pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability & LCDPolarity ) ;
+    temp = (unsigned char) ( pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability & LCDPolarity ) ;
     XGINew_SetRegANDOR( pVBInfo->P3c4 , 0x35 , ~0x80 , temp&0x80 ) ;      /* SR35[7] FP VSync polarity */
     XGINew_SetRegANDOR( pVBInfo->P3c4 , 0x30 , ~0x20 , (temp&0x40)>>1 ) ;   /* SR30[5] FP HSync polarity */
 
@@ -8158,7 +8158,7 @@ void XGI_SetXG21LVDSPara(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBIn
 
     LVDSVBE = LVDSVBS + LVDSVT - pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVDE ;
 
-    temp = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
+    temp = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
     XGINew_SetReg1( pVBInfo->P3d4 , 0x11 , temp & 0x7f ) ;		/* Unlock CRTC */
 
     if (!( modeflag & Charx8Dot ))
@@ -8265,26 +8265,26 @@ void XGI_SetXG21LVDSPara(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBIn
 }
 
 /* no shadow case */
-void XGI_SetXG27LVDSPara(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetXG27LVDSPara(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR temp,Miscdata;
-    USHORT xres ,
+    unsigned char temp,Miscdata;
+    unsigned short xres ,
            yres ,
            modeflag ,
            resindex ,
            lvdstableindex ;
-    USHORT LVDSHT,LVDSHBS,LVDSHRS,LVDSHRE,LVDSHBE;
-    USHORT LVDSVT,LVDSVBS,LVDSVRS,LVDSVRE,LVDSVBE;
-    USHORT value;
+    unsigned short LVDSHT,LVDSHBS,LVDSHRS,LVDSHRE,LVDSHBE;
+    unsigned short LVDSVT,LVDSVBS,LVDSVRS,LVDSVRE,LVDSVBE;
+    unsigned short value;
 
     lvdstableindex = XGI_GetLVDSOEMTableIndex( pVBInfo );
-    temp = (UCHAR) ( ( pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability & (LCDPolarity << 8 ) ) >> 8 );
+    temp = (unsigned char) ( ( pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability & (LCDPolarity << 8 ) ) >> 8 );
     temp &= LCDPolarity;
-    Miscdata =(UCHAR) XGINew_GetReg2(pVBInfo->P3cc) ;
+    Miscdata =(unsigned char) XGINew_GetReg2(pVBInfo->P3cc) ;
 
     XGINew_SetReg3( pVBInfo->P3c2 , (Miscdata & 0x3F) | temp ) ;
 
-    temp = (UCHAR) ( pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability & LCDPolarity ) ;
+    temp = (unsigned char) ( pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability & LCDPolarity ) ;
     XGINew_SetRegANDOR( pVBInfo->P3c4 , 0x35 , ~0x80 , temp&0x80 ) ;      /* SR35[7] FP VSync polarity */
     XGINew_SetRegANDOR( pVBInfo->P3c4 , 0x30 , ~0x20 , (temp&0x40)>>1 ) ;   /* SR30[5] FP HSync polarity */
 
@@ -8340,7 +8340,7 @@ void XGI_SetXG27LVDSPara(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBIn
 
     LVDSVBE = LVDSVBS + LVDSVT - pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVDE ;
 
-    temp = ( UCHAR )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
+    temp = ( unsigned char )XGINew_GetReg1( pVBInfo->P3d4 , 0x11 ) ;
     XGINew_SetReg1( pVBInfo->P3d4 , 0x11 , temp & 0x7f ) ;		/* Unlock CRTC */
 
     if (!( modeflag & Charx8Dot ))
@@ -8452,9 +8452,9 @@ void XGI_SetXG27LVDSPara(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBIn
 /* TRUE: Disable PSC */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_IsLCDON(PVB_DEVICE_INFO pVBInfo)
+bool XGI_IsLCDON(PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempax ;
+    unsigned short tempax ;
 
     tempax = pVBInfo->VBInfo ;
     if ( tempax & SetCRT2ToDualEdge )
@@ -8474,7 +8474,7 @@ BOOLEAN XGI_IsLCDON(PVB_DEVICE_INFO pVBInfo)
 /* --------------------------------------------------------------------- */
 void XGI_EnablePWD(  PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT index ,
+    unsigned short index ,
            temp ;
 
     index = XGI_GetLCDCapPtr(pVBInfo) ;
@@ -8506,13 +8506,13 @@ void XGI_DisablePWD( PVB_DEVICE_INFO pVBInfo )
 /* Output : FALSE -> Not LCD Mode */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_DisableChISLCD(PVB_DEVICE_INFO pVBInfo)
+bool XGI_DisableChISLCD(PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempbx ,
+    unsigned short tempbx ,
            tempah ;
 
     tempbx = pVBInfo->SetFlag & ( DisableChA | DisableChB ) ;
-    tempah = ~( ( USHORT )XGINew_GetReg1( pVBInfo->Part1Port  , 0x2E ) ) ;
+    tempah = ~( ( unsigned short )XGINew_GetReg1( pVBInfo->Part1Port  , 0x2E ) ) ;
 
     if ( tempbx & ( EnableChA | DisableChA ) )
     {
@@ -8536,14 +8536,14 @@ BOOLEAN XGI_DisableChISLCD(PVB_DEVICE_INFO pVBInfo)
 /* Output : 0 -> Not LCD mode */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_EnableChISLCD(PVB_DEVICE_INFO pVBInfo)
+bool XGI_EnableChISLCD(PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempbx ,
+    unsigned short tempbx ,
            tempah ;
 
 
     tempbx = pVBInfo->SetFlag & ( EnableChA | EnableChB ) ;
-    tempah = ~( ( USHORT )XGINew_GetReg1( pVBInfo->Part1Port , 0x2E ) ) ;
+    tempah = ~( ( unsigned short )XGINew_GetReg1( pVBInfo->Part1Port , 0x2E ) ) ;
 
     if ( tempbx & ( EnableChA | DisableChA ) )
     {
@@ -8567,9 +8567,9 @@ BOOLEAN XGI_EnableChISLCD(PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-USHORT XGI_GetLCDCapPtr(  PVB_DEVICE_INFO pVBInfo )
+unsigned short XGI_GetLCDCapPtr(  PVB_DEVICE_INFO pVBInfo )
 {
-    UCHAR tempal ,
+    unsigned char tempal ,
           tempah ,
           tempbl ,
           i ;
@@ -8606,9 +8606,9 @@ USHORT XGI_GetLCDCapPtr(  PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-USHORT XGI_GetLCDCapPtr1( PVB_DEVICE_INFO pVBInfo )
+unsigned short XGI_GetLCDCapPtr1( PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempah ,
+    unsigned short tempah ,
            tempal ,
            tempbl ,
            i ;
@@ -8651,9 +8651,9 @@ USHORT XGI_GetLCDCapPtr1( PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetLCDSync( USHORT* HSyncWidth , USHORT* VSyncWidth, PVB_DEVICE_INFO pVBInfo )
+void XGI_GetLCDSync( unsigned short* HSyncWidth , unsigned short* VSyncWidth, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT Index ;
+    unsigned short Index ;
 
     Index = XGI_GetLCDCapPtr(pVBInfo) ;
     *HSyncWidth = pVBInfo->LCDCapList[ Index ].LCD_HSyncWidth ;
@@ -8672,7 +8672,7 @@ void XGI_GetLCDSync( USHORT* HSyncWidth , USHORT* VSyncWidth, PVB_DEVICE_INFO pV
 /* --------------------------------------------------------------------- */
 void XGI_EnableBridge( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempbl ,
+    unsigned short tempbl ,
            tempah ;
 
     if ( pVBInfo->SetFlag == Win9xDOSMode )
@@ -8741,7 +8741,7 @@ void XGI_EnableBridge( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO p
         {
             if ( ( pVBInfo->SetFlag & EnableChB ) || ( pVBInfo->VBInfo & ( SetCRT2ToLCD | SetCRT2ToTV | SetCRT2ToRAMDAC ) ) )
             {
-                tempah = ( UCHAR )XGINew_GetReg1( pVBInfo->P3c4 , 0x32 ) ;
+                tempah = ( unsigned char )XGINew_GetReg1( pVBInfo->P3c4 , 0x32 ) ;
                 tempah &= 0xDF;
                 if ( pVBInfo->VBInfo & SetInSlaveMode )
                 {
@@ -8752,7 +8752,7 @@ void XGI_EnableBridge( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO p
                 XGINew_SetRegOR( pVBInfo->P3c4 , 0x1E , 0x20 ) ;
 
 
-                tempah = ( UCHAR )XGINew_GetReg1( pVBInfo->Part1Port , 0x2E ) ;
+                tempah = ( unsigned char )XGINew_GetReg1( pVBInfo->Part1Port , 0x2E ) ;
 
                 if ( !( tempah & 0x80 ) )
                     XGINew_SetRegOR( pVBInfo->Part1Port , 0x2E , 0x80 ) ;   	/* BVBDOENABLE = 1 */
@@ -8833,7 +8833,7 @@ void XGI_EnableBridge( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO p
 
 
 
-        tempah = ( UCHAR )XGINew_GetReg1( pVBInfo->Part1Port , 0x2E ) ;
+        tempah = ( unsigned char )XGINew_GetReg1( pVBInfo->Part1Port , 0x2E ) ;
         if ( !( tempah & 0x80 ) )
             XGINew_SetRegOR( pVBInfo->Part1Port , 0x2E , 0x80 ) ;	/* BVBDOENABLE = 1 */
 
@@ -8886,7 +8886,7 @@ void XGI_EnableBridge( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO p
 /* --------------------------------------------------------------------- */
 void XGI_DisableBridge(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempax ,
+    unsigned short tempax ,
            tempbx ,
            tempah = 0 ,
            tempbl = 0 ;
@@ -9065,9 +9065,9 @@ void XGI_DisableBridge(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pV
 /* A : Ext750p */
 /* B : St750p */
 /* --------------------------------------------------------------------- */
-USHORT XGI_GetTVPtrIndex(  PVB_DEVICE_INFO pVBInfo )
+unsigned short XGI_GetTVPtrIndex(  PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempbx = 0 ;
+    unsigned short tempbx = 0 ;
 
     if ( pVBInfo->TVInfo & SetPALTV )
         tempbx = 2 ;
@@ -9092,7 +9092,7 @@ USHORT XGI_GetTVPtrIndex(  PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : Customized Param. for 301 */
 /* --------------------------------------------------------------------- */
-void XGI_OEM310Setting( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
+void XGI_OEM310Setting( unsigned short ModeNo , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
 {
     if ( pVBInfo->SetFlag & Win9xDOSMode )
         return ;
@@ -9124,9 +9124,9 @@ void XGI_OEM310Setting( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBI
 /* --------------------------------------------------------------------- */
 void XGI_SetDelayComp( PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT index ;
+    unsigned short index ;
 
-    UCHAR  tempah ,
+    unsigned char  tempah ,
            tempbl ,
            tempbh ;
 
@@ -9202,7 +9202,7 @@ void XGI_SetDelayComp( PVB_DEVICE_INFO pVBInfo )
 /* --------------------------------------------------------------------- */
 void XGI_SetLCDCap( PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempcx ;
+    unsigned short tempcx ;
 
     tempcx = pVBInfo->LCDCapList[ XGI_GetLCDCapPtr(pVBInfo) ].LCD_Capability ;
 
@@ -9211,10 +9211,10 @@ void XGI_SetLCDCap( PVB_DEVICE_INFO pVBInfo )
         if ( pVBInfo->VBType & ( VB_XGI301LV | VB_XGI302LV | VB_XGI301C ) )
         {        				/* 301LV/302LV only */
             /* Set 301LV Capability */
-            XGINew_SetReg1( pVBInfo->Part4Port , 0x24 , ( UCHAR )( tempcx & 0x1F ) ) ;
+            XGINew_SetReg1( pVBInfo->Part4Port , 0x24 , ( unsigned char )( tempcx & 0x1F ) ) ;
 	}
         /* VB Driving */
-        XGINew_SetRegANDOR( pVBInfo->Part4Port , 0x0D , ~( ( EnableVBCLKDRVLOW | EnablePLLSPLOW ) >> 8 ) , ( USHORT )( ( tempcx & ( EnableVBCLKDRVLOW | EnablePLLSPLOW ) ) >> 8 ) ) ;
+        XGINew_SetRegANDOR( pVBInfo->Part4Port , 0x0D , ~( ( EnableVBCLKDRVLOW | EnablePLLSPLOW ) >> 8 ) , ( unsigned short )( ( tempcx & ( EnableVBCLKDRVLOW | EnablePLLSPLOW ) ) >> 8 ) ) ;
     }
 
     if ( pVBInfo->VBType & ( VB_XGI301B | VB_XGI302B | VB_XGI301LV | VB_XGI302LV | VB_XGI301C ) )
@@ -9241,32 +9241,32 @@ void XGI_SetLCDCap( PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetLCDCap_A(USHORT tempcx,PVB_DEVICE_INFO pVBInfo)
+void XGI_SetLCDCap_A(unsigned short tempcx,PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT temp ;
+    unsigned short temp ;
 
     temp = XGINew_GetReg1( pVBInfo->P3d4 , 0x37 ) ;
 
     if ( temp & LCDRGB18Bit )
     {
-        XGINew_SetRegANDOR( pVBInfo->Part1Port , 0x19 , 0x0F , ( USHORT )( 0x20 | ( tempcx & 0x00C0 ) ) ) ; /* Enable Dither */
+        XGINew_SetRegANDOR( pVBInfo->Part1Port , 0x19 , 0x0F , ( unsigned short )( 0x20 | ( tempcx & 0x00C0 ) ) ) ; /* Enable Dither */
         XGINew_SetRegANDOR( pVBInfo->Part1Port , 0x1A , 0x7F , 0x80 ) ;
     }
     else
     {
-        XGINew_SetRegANDOR( pVBInfo->Part1Port , 0x19 , 0x0F , ( USHORT )( 0x30 | ( tempcx & 0x00C0 ) ) ) ;
+        XGINew_SetRegANDOR( pVBInfo->Part1Port , 0x19 , 0x0F , ( unsigned short )( 0x30 | ( tempcx & 0x00C0 ) ) ) ;
         XGINew_SetRegANDOR( pVBInfo->Part1Port , 0x1A , 0x7F , 0x00 ) ;
     }
 
 /*
     if ( tempcx & EnableLCD24bpp )	// 24bits
     {
-        XGINew_SetRegANDOR(pVBInfo->Part1Port,0x19, 0x0F,(USHORT)(0x30|(tempcx&0x00C0)) );
+        XGINew_SetRegANDOR(pVBInfo->Part1Port,0x19, 0x0F,(unsigned short)(0x30|(tempcx&0x00C0)) );
         XGINew_SetRegANDOR(pVBInfo->Part1Port,0x1A,0x7F,0x00);
     }
     else
     {
-        XGINew_SetRegANDOR(pVBInfo->Part1Port,0x19, 0x0F,(USHORT)(0x20|(tempcx&0x00C0)) );//Enable Dither
+        XGINew_SetRegANDOR(pVBInfo->Part1Port,0x19, 0x0F,(unsigned short)(0x20|(tempcx&0x00C0)) );//Enable Dither
         XGINew_SetRegANDOR(pVBInfo->Part1Port,0x1A,0x7F,0x80);
     }
 */
@@ -9279,12 +9279,12 @@ void XGI_SetLCDCap_A(USHORT tempcx,PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetLCDCap_B(USHORT tempcx,PVB_DEVICE_INFO pVBInfo)
+void XGI_SetLCDCap_B(unsigned short tempcx,PVB_DEVICE_INFO pVBInfo)
 {
     if ( tempcx & EnableLCD24bpp )	/* 24bits */
-        XGINew_SetRegANDOR( pVBInfo->Part2Port , 0x1A , 0xE0 , ( USHORT )( ( ( tempcx & 0x00ff ) >> 6 ) | 0x0c ) ) ;
+        XGINew_SetRegANDOR( pVBInfo->Part2Port , 0x1A , 0xE0 , ( unsigned short )( ( ( tempcx & 0x00ff ) >> 6 ) | 0x0c ) ) ;
     else
-        XGINew_SetRegANDOR( pVBInfo->Part2Port , 0x1A , 0xE0 , ( USHORT )( ( ( tempcx & 0x00ff ) >> 6 ) | 0x18 ) ) ; /* Enable Dither */
+        XGINew_SetRegANDOR( pVBInfo->Part2Port , 0x1A , 0xE0 , ( unsigned short )( ( ( tempcx & 0x00ff ) >> 6 ) | 0x18 ) ) ; /* Enable Dither */
 }
 
 
@@ -9296,7 +9296,7 @@ void XGI_SetLCDCap_B(USHORT tempcx,PVB_DEVICE_INFO pVBInfo)
 /* --------------------------------------------------------------------- */
 void SetSpectrum( PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT index ;
+    unsigned short index ;
 
     index = XGI_GetLCDCapPtr(pVBInfo) ;
 
@@ -9320,12 +9320,12 @@ void SetSpectrum( PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : Set TV Customized Param. */
 /* --------------------------------------------------------------------- */
-void XGI_SetAntiFlicker( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_SetAntiFlicker( unsigned short ModeNo , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempbx ,
+    unsigned short tempbx ,
            index ;
 
-    UCHAR tempah ;
+    unsigned char tempah ;
 
     if (pVBInfo->TVInfo & ( SetYPbPrMode525p | SetYPbPrMode750p ) )
         return ;
@@ -9356,12 +9356,12 @@ void XGI_SetAntiFlicker( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVB
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetEdgeEnhance( USHORT ModeNo , USHORT ModeIdIndex , PVB_DEVICE_INFO pVBInfo)
+void XGI_SetEdgeEnhance( unsigned short ModeNo , unsigned short ModeIdIndex , PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempbx ,
+    unsigned short tempbx ,
            index ;
 
-    UCHAR tempah ;
+    unsigned char tempah ;
 
 
     tempbx = XGI_GetTVPtrIndex(pVBInfo ) ;
@@ -9392,20 +9392,20 @@ void XGI_SetEdgeEnhance( USHORT ModeNo , USHORT ModeIdIndex , PVB_DEVICE_INFO pV
 /* --------------------------------------------------------------------- */
 void XGI_SetPhaseIncr( PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempbx ;
+    unsigned short tempbx ;
 
-    UCHAR tempcl ,
+    unsigned char tempcl ,
           tempch ;
 
-    ULONG tempData ;
+    unsigned long tempData ;
 
     XGI_GetTVPtrIndex2( &tempbx , &tempcl , &tempch, pVBInfo ) ; /* bx, cl, ch */
     tempData = TVPhaseList[ tempbx ] ;
 
-    XGINew_SetReg1( pVBInfo->Part2Port , 0x31 , ( USHORT )( tempData & 0x000000FF ) ) ;
-    XGINew_SetReg1( pVBInfo->Part2Port , 0x32 , ( USHORT )( ( tempData & 0x0000FF00 ) >> 8 ) ) ;
-    XGINew_SetReg1( pVBInfo->Part2Port , 0x33 , ( USHORT )( ( tempData & 0x00FF0000 ) >> 16 ) ) ;
-    XGINew_SetReg1( pVBInfo->Part2Port , 0x34 , ( USHORT )( ( tempData & 0xFF000000 ) >> 24 ) ) ;
+    XGINew_SetReg1( pVBInfo->Part2Port , 0x31 , ( unsigned short )( tempData & 0x000000FF ) ) ;
+    XGINew_SetReg1( pVBInfo->Part2Port , 0x32 , ( unsigned short )( ( tempData & 0x0000FF00 ) >> 8 ) ) ;
+    XGINew_SetReg1( pVBInfo->Part2Port , 0x33 , ( unsigned short )( ( tempData & 0x00FF0000 ) >> 16 ) ) ;
+    XGINew_SetReg1( pVBInfo->Part2Port , 0x34 , ( unsigned short )( ( tempData & 0xFF000000 ) >> 24 ) ) ;
 }
 
 
@@ -9415,12 +9415,12 @@ void XGI_SetPhaseIncr( PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetYFilter( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
+void XGI_SetYFilter( unsigned short ModeNo , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempbx ,
+    unsigned short tempbx ,
            index ;
 
-    UCHAR tempcl ,
+    unsigned char tempcl ,
           tempch ,
           tempal ,
           *filterPtr ;
@@ -9519,7 +9519,7 @@ void XGI_SetYFilter( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo
 /* 1 : 301B/302B/301LV/302LV */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetTVPtrIndex2(USHORT* tempbx,UCHAR* tempcl,UCHAR* tempch, PVB_DEVICE_INFO pVBInfo)
+void XGI_GetTVPtrIndex2(unsigned short* tempbx,unsigned char* tempcl,unsigned char* tempch, PVB_DEVICE_INFO pVBInfo)
 {
     *tempbx = 0 ;
     *tempcl = 0 ;
@@ -9561,12 +9561,12 @@ void XGI_GetTVPtrIndex2(USHORT* tempbx,UCHAR* tempcl,UCHAR* tempch, PVB_DEVICE_I
 /* Output : */
 /* Description : Origin code for crt2group */
 /* --------------------------------------------------------------------- */
-void XGI_SetCRT2ModeRegs(USHORT ModeNo,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
+void XGI_SetCRT2ModeRegs(unsigned short ModeNo,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempbl ;
-    SHORT  tempcl ;
+    unsigned short tempbl ;
+    short  tempcl ;
 
-    UCHAR  tempah ;
+    unsigned char  tempah ;
 
     /* XGINew_SetReg1( pVBInfo->Part1Port , 0x03 , 0x00 ) ; // fix write part1 index 0 BTDRAM bit Bug */
     tempah=0;
@@ -9792,7 +9792,7 @@ void XGI_SetCRT2ModeRegs(USHORT ModeNo,PXGI_HW_DEVICE_INFO HwDeviceExtension, PV
 /* --------------------------------------------------------------------- */
 void XGI_CloseCRTC( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempbx ;
+    unsigned short tempbx ;
 
     tempbx = 0 ;
 
@@ -9811,7 +9811,7 @@ void XGI_CloseCRTC( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBIn
 /* --------------------------------------------------------------------- */
 void XGI_OpenCRTC( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempbx ;
+    unsigned short tempbx ;
 
     tempbx = 0 ;
 
@@ -9825,9 +9825,9 @@ void XGI_OpenCRTC( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInf
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetRAMDAC2DATA(USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
+void XGI_GetRAMDAC2DATA(unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex, PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempax ,
+    unsigned short tempax ,
            tempbx ,
            temp1 ,
            temp2 ,
@@ -9852,15 +9852,15 @@ void XGI_GetRAMDAC2DATA(USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateT
         modeflag = pVBInfo->EModeIDTable[ ModeIdIndex ].Ext_ModeFlag ;
         CRT1Index = pVBInfo->RefIndex[ RefreshRateTableIndex ].Ext_CRT1CRTC ;
         CRT1Index &= IndexMask ;
-        temp1 = ( USHORT )pVBInfo->XGINEWUB_CRT1Table[ CRT1Index ].CR[ 0 ] ;
-        temp2 = ( USHORT )pVBInfo->XGINEWUB_CRT1Table[ CRT1Index ].CR[ 5 ] ;
+        temp1 = ( unsigned short )pVBInfo->XGINEWUB_CRT1Table[ CRT1Index ].CR[ 0 ] ;
+        temp2 = ( unsigned short )pVBInfo->XGINEWUB_CRT1Table[ CRT1Index ].CR[ 5 ] ;
 	tempax = ( temp1 & 0xFF ) | ( ( temp2 & 0x03 ) << 8 ) ;
-        tempbx = ( USHORT )pVBInfo->XGINEWUB_CRT1Table[ CRT1Index ].CR[ 8 ] ;
-        tempcx = ( USHORT )pVBInfo->XGINEWUB_CRT1Table[ CRT1Index ].CR[ 14 ] << 8 ;
+        tempbx = ( unsigned short )pVBInfo->XGINEWUB_CRT1Table[ CRT1Index ].CR[ 8 ] ;
+        tempcx = ( unsigned short )pVBInfo->XGINEWUB_CRT1Table[ CRT1Index ].CR[ 14 ] << 8 ;
 	tempcx &= 0x0100 ;
 	tempcx = tempcx << 2 ;
 	tempbx |= tempcx;
-        temp1 = ( USHORT )pVBInfo->XGINEWUB_CRT1Table[ CRT1Index ].CR[ 9 ] ;
+        temp1 = ( unsigned short )pVBInfo->XGINEWUB_CRT1Table[ CRT1Index ].CR[ 9 ] ;
     }
 
     if ( temp1 & 0x01 )
@@ -9890,11 +9890,11 @@ void XGI_GetRAMDAC2DATA(USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateT
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-USHORT XGI_GetColorDepth(USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
+unsigned short XGI_GetColorDepth(unsigned short ModeNo , unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT ColorDepth[ 6 ] = { 1 , 2 , 4 , 4 , 6 , 8 } ;
-    SHORT  index ;
-    USHORT modeflag ;
+    unsigned short ColorDepth[ 6 ] = { 1 , 2 , 4 , 4 , 6 , 8 } ;
+    short  index ;
+    unsigned short modeflag ;
 
     if ( ModeNo <= 0x13 )
     {
@@ -9963,12 +9963,12 @@ void XGINew_EnableCRT2( PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_LCD_Wait_Time(UCHAR DelayTime, PVB_DEVICE_INFO pVBInfo)
+void XGINew_LCD_Wait_Time(unsigned char DelayTime, PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT i ,
+    unsigned short i ,
            j ;
 
-    ULONG temp ,
+    unsigned long temp ,
           flag ;
 
     flag = 0 ;
@@ -10000,9 +10000,9 @@ void XGINew_LCD_Wait_Time(UCHAR DelayTime, PVB_DEVICE_INFO pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-BOOLEAN XGI_BridgeIsOn( PVB_DEVICE_INFO pVBInfo )
+bool XGI_BridgeIsOn( PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT flag ;
+    unsigned short flag ;
 
     if ( pVBInfo->IF_DEF_LVDS == 1 )
     {
@@ -10028,7 +10028,7 @@ BOOLEAN XGI_BridgeIsOn( PVB_DEVICE_INFO pVBInfo )
 /* --------------------------------------------------------------------- */
 void XGI_LongWait(PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT i ;
+    unsigned short i ;
 
     i = XGINew_GetReg1( pVBInfo->P3c4 , 0x1F ) ;
 
@@ -10057,7 +10057,7 @@ void XGI_LongWait(PVB_DEVICE_INFO pVBInfo)
 /* --------------------------------------------------------------------- */
 void XGI_VBLongWait( PVB_DEVICE_INFO pVBInfo )
 {
-    USHORT tempal ,
+    unsigned short tempal ,
            temp ,
            i ,
            j ;
@@ -10114,16 +10114,16 @@ return ;
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-USHORT XGI_GetVGAHT2( PVB_DEVICE_INFO pVBInfo )
+unsigned short XGI_GetVGAHT2( PVB_DEVICE_INFO pVBInfo )
 {
-    ULONG tempax ,
+    unsigned long tempax ,
           tempbx ;
 
     tempbx = ( ( pVBInfo->VGAVT - pVBInfo->VGAVDE ) * pVBInfo->RVBHCMAX ) & 0xFFFF ;
     tempax = ( pVBInfo->VT - pVBInfo->VDE ) * pVBInfo->RVBHCFACT ;
     tempax = ( tempax * pVBInfo->HT ) /tempbx ;
 
-    return( ( USHORT )tempax ) ;
+    return( ( unsigned short )tempax ) ;
 }
 
 
@@ -10133,19 +10133,19 @@ USHORT XGI_GetVGAHT2( PVB_DEVICE_INFO pVBInfo )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-USHORT XGI_GetVCLK2Ptr( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateTableIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension ,PVB_DEVICE_INFO pVBInfo)
+unsigned short XGI_GetVCLK2Ptr( unsigned short ModeNo , unsigned short ModeIdIndex , unsigned short RefreshRateTableIndex , PXGI_HW_DEVICE_INFO HwDeviceExtension ,PVB_DEVICE_INFO pVBInfo)
 {
-    USHORT tempbx ;
+    unsigned short tempbx ;
 
-    USHORT LCDXlat1VCLK[ 4 ] = { VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 } ;
-    USHORT LCDXlat2VCLK[ 4 ] = { VCLK108_2 + 5 , VCLK108_2 + 5 , VCLK108_2 + 5 , VCLK108_2 + 5 } ;
-    USHORT LVDSXlat1VCLK[ 4 ] = { VCLK40 , VCLK40 , VCLK40 , VCLK40 } ;
-    USHORT LVDSXlat2VCLK[ 4 ] = { VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 } ;
-    USHORT LVDSXlat3VCLK[ 4 ] = { VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 } ;
+    unsigned short LCDXlat1VCLK[ 4 ] = { VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 } ;
+    unsigned short LCDXlat2VCLK[ 4 ] = { VCLK108_2 + 5 , VCLK108_2 + 5 , VCLK108_2 + 5 , VCLK108_2 + 5 } ;
+    unsigned short LVDSXlat1VCLK[ 4 ] = { VCLK40 , VCLK40 , VCLK40 , VCLK40 } ;
+    unsigned short LVDSXlat2VCLK[ 4 ] = { VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 } ;
+    unsigned short LVDSXlat3VCLK[ 4 ] = { VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 , VCLK65 + 2 } ;
 
-    USHORT CRT2Index , VCLKIndex ;
-    USHORT modeflag , resinfo ;
-    UCHAR *CHTVVCLKPtr = NULL ;
+    unsigned short CRT2Index , VCLKIndex ;
+    unsigned short modeflag , resinfo ;
+    unsigned char *CHTVVCLKPtr = NULL ;
 
     if ( ModeNo <= 0x13 )
     {
@@ -10260,7 +10260,7 @@ USHORT XGI_GetVCLK2Ptr( USHORT ModeNo , USHORT ModeIdIndex , USHORT RefreshRateT
             }
             else
             {	/* for CRT2 */
-                VCLKIndex = ( UCHAR )XGINew_GetReg2( ( pVBInfo->P3ca + 0x02 ) ) ;	/* Port 3cch */
+                VCLKIndex = ( unsigned char )XGINew_GetReg2( ( pVBInfo->P3ca + 0x02 ) ) ;	/* Port 3cch */
 		VCLKIndex = ( ( VCLKIndex >> 2 ) & 0x03 ) ;
                 if ( ModeNo > 0x13 )
                 {
diff --git a/drivers/staging/xgifb/vb_setmode.h b/drivers/staging/xgifb/vb_setmode.h
index 09753d7..008cd9f 100644
--- a/drivers/staging/xgifb/vb_setmode.h
+++ b/drivers/staging/xgifb/vb_setmode.h
@@ -1,11 +1,11 @@
 #ifndef  _VBSETMODE_
 #define  _VBSETMODE_
 
-extern   void     InitTo330Pointer(UCHAR,PVB_DEVICE_INFO);
+extern   void     InitTo330Pointer(unsigned char,PVB_DEVICE_INFO);
 extern   void     XGI_UnLockCRT2(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
 extern   void     XGI_LockCRT2(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
 extern   void     XGI_LongWait( PVB_DEVICE_INFO );
-extern   void     XGI_SetCRT2ModeRegs(USHORT ModeNo,PXGI_HW_DEVICE_INFO,  PVB_DEVICE_INFO  );
+extern   void     XGI_SetCRT2ModeRegs(unsigned short ModeNo,PXGI_HW_DEVICE_INFO,  PVB_DEVICE_INFO  );
 extern   void     XGI_DisableBridge(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
 extern   void  	  XGI_EnableBridge(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
 extern   void     XGI_DisplayOff( PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO );
@@ -13,28 +13,28 @@ extern   void     XGI_DisplayOn( PXGI_HW_DEVICE_INFO, PVB_DEVICE_INFO );
 extern   void     XGI_GetVBType(PVB_DEVICE_INFO);
 extern   void     XGI_SenseCRT1(PVB_DEVICE_INFO );
 extern   void     XGI_GetVGAType(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
-extern   void     XGI_GetVBInfo(USHORT ModeNo,USHORT ModeIdIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
-extern   void     XGI_GetTVInfo(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO );
-extern   void     XGI_SetCRT1Offset(USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
-extern   void     XGI_SetLCDAGroup(USHORT ModeNo,USHORT ModeIdIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
+extern   void     XGI_GetVBInfo(unsigned short ModeNo,unsigned short ModeIdIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
+extern   void     XGI_GetTVInfo(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO );
+extern   void     XGI_SetCRT1Offset(unsigned short ModeNo,unsigned short ModeIdIndex,unsigned short RefreshRateTableIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
+extern   void     XGI_SetLCDAGroup(unsigned short ModeNo,unsigned short ModeIdIndex,PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO );
 extern   void     XGI_WaitDisply( PVB_DEVICE_INFO );
-extern   USHORT   XGI_GetResInfo(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
+extern   unsigned short   XGI_GetResInfo(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo);
 
-extern   BOOLEAN  XGISetModeNew( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo ) ;
+extern   bool  XGISetModeNew( PXGI_HW_DEVICE_INFO HwDeviceExtension , unsigned short ModeNo ) ;
 
-extern   BOOLEAN  XGI_SearchModeID( USHORT ModeNo,USHORT  *ModeIdIndex, PVB_DEVICE_INFO );
-extern   BOOLEAN  XGI_GetLCDInfo(USHORT ModeNo,USHORT ModeIdIndex,PVB_DEVICE_INFO );
-extern   BOOLEAN  XGI_BridgeIsOn( PVB_DEVICE_INFO );
-extern   BOOLEAN  XGI_SetCRT2Group301(USHORT ModeNo, PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO);
-extern   USHORT   XGI_GetRatePtrCRT2( PXGI_HW_DEVICE_INFO pXGIHWDE, USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO );
+extern   bool  XGI_SearchModeID( unsigned short ModeNo,unsigned short  *ModeIdIndex, PVB_DEVICE_INFO );
+extern   bool  XGI_GetLCDInfo(unsigned short ModeNo,unsigned short ModeIdIndex,PVB_DEVICE_INFO );
+extern   bool  XGI_BridgeIsOn( PVB_DEVICE_INFO );
+extern   bool  XGI_SetCRT2Group301(unsigned short ModeNo, PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO);
+extern   unsigned short   XGI_GetRatePtrCRT2( PXGI_HW_DEVICE_INFO pXGIHWDE, unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO );
 
 extern   void     XGI_SetXG21FPBits(PVB_DEVICE_INFO pVBInfo);
 extern   void     XGI_SetXG27FPBits(PVB_DEVICE_INFO pVBInfo);
-extern   void     XGI_XG21BLSignalVDD(USHORT tempbh,USHORT tempbl, PVB_DEVICE_INFO pVBInfo);
-extern   void     XGI_XG27BLSignalVDD(USHORT tempbh,USHORT tempbl, PVB_DEVICE_INFO pVBInfo);
-extern   void     XGI_XG21SetPanelDelay(USHORT tempbl, PVB_DEVICE_INFO pVBInfo);
-extern   BOOLEAN  XGI_XG21CheckLVDSMode(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo );
-extern   void     XGI_SetXG21LVDSPara(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo );
-extern   USHORT XGI_GetLVDSOEMTableIndex(PVB_DEVICE_INFO pVBInfo);
+extern   void     XGI_XG21BLSignalVDD(unsigned short tempbh,unsigned short tempbl, PVB_DEVICE_INFO pVBInfo);
+extern   void     XGI_XG27BLSignalVDD(unsigned short tempbh,unsigned short tempbl, PVB_DEVICE_INFO pVBInfo);
+extern   void     XGI_XG21SetPanelDelay(unsigned short tempbl, PVB_DEVICE_INFO pVBInfo);
+extern   bool  XGI_XG21CheckLVDSMode(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo );
+extern   void     XGI_SetXG21LVDSPara(unsigned short ModeNo,unsigned short ModeIdIndex, PVB_DEVICE_INFO pVBInfo );
+extern   unsigned short XGI_GetLVDSOEMTableIndex(PVB_DEVICE_INFO pVBInfo);
 
 #endif
diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index 1302d8f..eb9ef24 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -3,64 +3,64 @@
 
 typedef struct _XGI_PanelDelayTblStruct
 {
- UCHAR timer[2];
+ unsigned char timer[2];
 } XGI_PanelDelayTblStruct;
 
 typedef struct _XGI_LCDDataStruct
 {
- USHORT RVBHCMAX;
- USHORT RVBHCFACT;
- USHORT VGAHT;
- USHORT VGAVT;
- USHORT LCDHT;
- USHORT LCDVT;
+ unsigned short RVBHCMAX;
+ unsigned short RVBHCFACT;
+ unsigned short VGAHT;
+ unsigned short VGAVT;
+ unsigned short LCDHT;
+ unsigned short LCDVT;
 } XGI_LCDDataStruct;
 
 
 typedef struct _XGI_LVDSCRT1HDataStruct
 {
- UCHAR Reg[8];
+ unsigned char Reg[8];
 } XGI_LVDSCRT1HDataStruct;
 typedef struct _XGI_LVDSCRT1VDataStruct
 {
- UCHAR Reg[7];
+ unsigned char Reg[7];
 } XGI_LVDSCRT1VDataStruct;
 
 
 typedef struct _XGI_TVDataStruct
 {
- USHORT RVBHCMAX;
- USHORT RVBHCFACT;
- USHORT VGAHT;
- USHORT VGAVT;
- USHORT TVHDE;
- USHORT TVVDE;
- USHORT RVBHRS;
- UCHAR FlickerMode;
- USHORT HALFRVBHRS;
- UCHAR RY1COE;
- UCHAR RY2COE;
- UCHAR RY3COE;
- UCHAR RY4COE;
+ unsigned short RVBHCMAX;
+ unsigned short RVBHCFACT;
+ unsigned short VGAHT;
+ unsigned short VGAVT;
+ unsigned short TVHDE;
+ unsigned short TVVDE;
+ unsigned short RVBHRS;
+ unsigned char FlickerMode;
+ unsigned short HALFRVBHRS;
+ unsigned char RY1COE;
+ unsigned char RY2COE;
+ unsigned char RY3COE;
+ unsigned char RY4COE;
 } XGI_TVDataStruct;
 
 typedef struct _XGI_LVDSDataStruct
 {
- USHORT VGAHT;
- USHORT VGAVT;
- USHORT LCDHT;
- USHORT LCDVT;
+ unsigned short VGAHT;
+ unsigned short VGAVT;
+ unsigned short LCDHT;
+ unsigned short LCDVT;
 } XGI_LVDSDataStruct;
 
 typedef struct _XGI_LVDSDesStruct
 {
- USHORT LCDHDES;
- USHORT LCDVDES;
+ unsigned short LCDHDES;
+ unsigned short LCDVDES;
 } XGI_LVDSDesStruct;
 
 typedef struct _XGI_LVDSCRT1DataStruct
 {
- UCHAR CR[15];
+ unsigned char CR[15];
 } XGI_LVDSCRT1DataStruct;
 
 /*add for LCDA*/
@@ -68,348 +68,348 @@ typedef struct _XGI_LVDSCRT1DataStruct
 
 typedef struct _XGI_StStruct
 {
- UCHAR St_ModeID;
- USHORT St_ModeFlag;
- UCHAR St_StTableIndex;
- UCHAR St_CRT2CRTC;
- UCHAR St_CRT2CRTC2;
- UCHAR St_ResInfo;
- UCHAR VB_StTVFlickerIndex;
- UCHAR VB_StTVEdgeIndex;
- UCHAR VB_StTVYFilterIndex;
+ unsigned char St_ModeID;
+ unsigned short St_ModeFlag;
+ unsigned char St_StTableIndex;
+ unsigned char St_CRT2CRTC;
+ unsigned char St_CRT2CRTC2;
+ unsigned char St_ResInfo;
+ unsigned char VB_StTVFlickerIndex;
+ unsigned char VB_StTVEdgeIndex;
+ unsigned char VB_StTVYFilterIndex;
 } XGI_StStruct;
 
 typedef struct _XGI_StandTableStruct
 {
- UCHAR CRT_COLS;
- UCHAR ROWS;
- UCHAR CHAR_HEIGHT;
- USHORT CRT_LEN;
- UCHAR SR[4];
- UCHAR MISC;
- UCHAR CRTC[0x19];
- UCHAR ATTR[0x14];
- UCHAR GRC[9];
+ unsigned char CRT_COLS;
+ unsigned char ROWS;
+ unsigned char CHAR_HEIGHT;
+ unsigned short CRT_LEN;
+ unsigned char SR[4];
+ unsigned char MISC;
+ unsigned char CRTC[0x19];
+ unsigned char ATTR[0x14];
+ unsigned char GRC[9];
 } XGI_StandTableStruct;
 
 typedef struct _XGI_ExtStruct
 {
- UCHAR Ext_ModeID;
- USHORT Ext_ModeFlag;
- USHORT Ext_ModeInfo;
- USHORT Ext_Point;
- USHORT Ext_VESAID;
- UCHAR Ext_VESAMEMSize;
- UCHAR Ext_RESINFO;
- UCHAR VB_ExtTVFlickerIndex;
- UCHAR VB_ExtTVEdgeIndex;
- UCHAR VB_ExtTVYFilterIndex;
- UCHAR REFindex;
+ unsigned char Ext_ModeID;
+ unsigned short Ext_ModeFlag;
+ unsigned short Ext_ModeInfo;
+ unsigned short Ext_Point;
+ unsigned short Ext_VESAID;
+ unsigned char Ext_VESAMEMSize;
+ unsigned char Ext_RESINFO;
+ unsigned char VB_ExtTVFlickerIndex;
+ unsigned char VB_ExtTVEdgeIndex;
+ unsigned char VB_ExtTVYFilterIndex;
+ unsigned char REFindex;
 } XGI_ExtStruct;
 
 typedef struct _XGI_Ext2Struct
 {
- USHORT Ext_InfoFlag;
- UCHAR Ext_CRT1CRTC;
- UCHAR Ext_CRTVCLK;
- UCHAR Ext_CRT2CRTC;
- UCHAR Ext_CRT2CRTC2;
- UCHAR  ModeID;
- USHORT XRes;
- USHORT YRes;
- /* USHORT ROM_OFFSET; */
+ unsigned short Ext_InfoFlag;
+ unsigned char Ext_CRT1CRTC;
+ unsigned char Ext_CRTVCLK;
+ unsigned char Ext_CRT2CRTC;
+ unsigned char Ext_CRT2CRTC2;
+ unsigned char  ModeID;
+ unsigned short XRes;
+ unsigned short YRes;
+ /* unsigned short ROM_OFFSET; */
 } XGI_Ext2Struct;
 
 
 typedef struct _XGI_MCLKDataStruct
 {
- UCHAR SR28,SR29,SR2A;
- USHORT CLOCK;
+ unsigned char SR28,SR29,SR2A;
+ unsigned short CLOCK;
 } XGI_MCLKDataStruct;
 
 typedef struct _XGI_ECLKDataStruct
 {
- UCHAR SR2E,SR2F,SR30;
- USHORT CLOCK;
+ unsigned char SR2E,SR2F,SR30;
+ unsigned short CLOCK;
 } XGI_ECLKDataStruct;
 
 typedef struct _XGI_VCLKDataStruct
 {
- UCHAR SR2B,SR2C;
- USHORT CLOCK;
+ unsigned char SR2B,SR2C;
+ unsigned short CLOCK;
 } XGI_VCLKDataStruct;
 
 typedef struct _XGI_VBVCLKDataStruct
 {
- UCHAR Part4_A,Part4_B;
- USHORT CLOCK;
+ unsigned char Part4_A,Part4_B;
+ unsigned short CLOCK;
 } XGI_VBVCLKDataStruct;
 
 typedef struct _XGI_StResInfoStruct
 {
- USHORT HTotal;
- USHORT VTotal;
+ unsigned short HTotal;
+ unsigned short VTotal;
 } XGI_StResInfoStruct;
 
 typedef struct _XGI_ModeResInfoStruct
 {
- USHORT HTotal;
- USHORT VTotal;
- UCHAR  XChar;
- UCHAR  YChar;
+ unsigned short HTotal;
+ unsigned short VTotal;
+ unsigned char  XChar;
+ unsigned char  YChar;
 } XGI_ModeResInfoStruct;
 
 typedef struct _XGI_LCDNBDesStruct
 {
-  UCHAR NB[12];
+  unsigned char NB[12];
 } XGI_LCDNBDesStruct;
  /*add for new UNIVGABIOS*/
 typedef struct _XGI_LCDDesStruct
 {
- USHORT LCDHDES;
- USHORT LCDHRS;
- USHORT LCDVDES;
- USHORT LCDVRS;
+ unsigned short LCDHDES;
+ unsigned short LCDHRS;
+ unsigned short LCDVDES;
+ unsigned short LCDVRS;
 } XGI_LCDDesStruct;
 
 typedef struct _XGI_LCDDataTablStruct
 {
- UCHAR  PANELID;
- USHORT MASK;
- USHORT CAP;
- USHORT DATAPTR;
+ unsigned char  PANELID;
+ unsigned short MASK;
+ unsigned short CAP;
+ unsigned short DATAPTR;
 } XGI_LCDDataTablStruct;
 
 typedef struct _XGI_TVTablDataStruct
 {
- USHORT MASK;
- USHORT CAP;
- USHORT DATAPTR;
+ unsigned short MASK;
+ unsigned short CAP;
+ unsigned short DATAPTR;
 } XGI_TVDataTablStruct;
 
 typedef struct _XGI330_LCDDesDataStruct
 {
- USHORT LCDHDES;
- USHORT LCDHRS;
- USHORT LCDVDES;
- USHORT LCDVRS;
+ unsigned short LCDHDES;
+ unsigned short LCDHRS;
+ unsigned short LCDVDES;
+ unsigned short LCDVRS;
 } XGI330_LCDDataDesStruct;
 
 
 typedef struct _XGI330_LVDSDataStruct
 {
- USHORT VGAHT;
- USHORT VGAVT;
- USHORT LCDHT;
- USHORT LCDVT;
+ unsigned short VGAHT;
+ unsigned short VGAVT;
+ unsigned short LCDHT;
+ unsigned short LCDVT;
 } XGI330_LVDSDataStruct;
 
 typedef struct _XGI330_LCDDesDataStruct2
 {
- USHORT LCDHDES;
- USHORT LCDHRS;
- USHORT LCDVDES;
- USHORT LCDVRS;
- USHORT LCDHSync;
- USHORT LCDVSync;
+ unsigned short LCDHDES;
+ unsigned short LCDHRS;
+ unsigned short LCDVDES;
+ unsigned short LCDVRS;
+ unsigned short LCDHSync;
+ unsigned short LCDVSync;
 } XGI330_LCDDataDesStruct2;
 
 typedef struct _XGI330_LCDDataStruct
 {
- USHORT RVBHCMAX;
- USHORT RVBHCFACT;
- USHORT VGAHT;
- USHORT VGAVT;
- USHORT LCDHT;
- USHORT LCDVT;
+ unsigned short RVBHCMAX;
+ unsigned short RVBHCFACT;
+ unsigned short VGAHT;
+ unsigned short VGAVT;
+ unsigned short LCDHT;
+ unsigned short LCDVT;
 } XGI330_LCDDataStruct;
 
 
 typedef struct _XGI330_TVDataStruct
 {
- USHORT RVBHCMAX;
- USHORT RVBHCFACT;
- USHORT VGAHT;
- USHORT VGAVT;
- USHORT TVHDE;
- USHORT TVVDE;
- USHORT RVBHRS;
- UCHAR FlickerMode;
- USHORT HALFRVBHRS;
+ unsigned short RVBHCMAX;
+ unsigned short RVBHCFACT;
+ unsigned short VGAHT;
+ unsigned short VGAVT;
+ unsigned short TVHDE;
+ unsigned short TVVDE;
+ unsigned short RVBHRS;
+ unsigned char FlickerMode;
+ unsigned short HALFRVBHRS;
 } XGI330_TVDataStruct;
 
 typedef struct _XGI330_LCDDataTablStruct
 {
- UCHAR  PANELID;
- USHORT MASK;
- USHORT CAP;
- USHORT DATAPTR;
+ unsigned char  PANELID;
+ unsigned short MASK;
+ unsigned short CAP;
+ unsigned short DATAPTR;
 } XGI330_LCDDataTablStruct;
 
 typedef struct _XGI330_TVDataTablStruct
 {
- USHORT MASK;
- USHORT CAP;
- USHORT DATAPTR;
+ unsigned short MASK;
+ unsigned short CAP;
+ unsigned short DATAPTR;
 } XGI330_TVDataTablStruct;
 
 
 typedef struct _XGI330_CHTVDataStruct
 {
- USHORT VGAHT;
- USHORT VGAVT;
- USHORT LCDHT;
- USHORT LCDVT;
+ unsigned short VGAHT;
+ unsigned short VGAVT;
+ unsigned short LCDHT;
+ unsigned short LCDVT;
 } XGI330_CHTVDataStruct;
 
 typedef struct _XGI_TimingHStruct
 {
-  UCHAR data[8];
+  unsigned char data[8];
 } XGI_TimingHStruct;
 
 typedef struct _XGI_TimingVStruct
 {
-  UCHAR data[7];
+  unsigned char data[7];
 } XGI_TimingVStruct;
 
 typedef struct _XGI_CH7007TV_TimingHStruct
 {
-  UCHAR data[10];
+  unsigned char data[10];
 } XGI_CH7007TV_TimingHStruct;
 
 typedef struct _XGI_CH7007TV_TimingVStruct
 {
-  UCHAR data[10];
+  unsigned char data[10];
 } XGI_CH7007TV_TimingVStruct;
 
 typedef struct _XGI_XG21CRT1Struct
 {
- UCHAR ModeID,CR02,CR03,CR15,CR16;
+ unsigned char ModeID,CR02,CR03,CR15,CR16;
 } XGI_XG21CRT1Struct;
 
 typedef struct _XGI330_CHTVRegDataStruct
 {
- UCHAR Reg[16];
+ unsigned char Reg[16];
 } XGI330_CHTVRegDataStruct;
 
 typedef struct _XGI330_LCDCapStruct
 {
- 		UCHAR      LCD_ID;
-                USHORT     LCD_Capability;
-                UCHAR      LCD_SetFlag;
-                UCHAR      LCD_DelayCompensation;
-                UCHAR      LCD_HSyncWidth;
-                UCHAR      LCD_VSyncWidth;
-                UCHAR      LCD_VCLK;
-                UCHAR      LCDA_VCLKData1;
-                UCHAR      LCDA_VCLKData2;
-                UCHAR      LCUCHAR_VCLKData1;
-                UCHAR      LCUCHAR_VCLKData2;
-                UCHAR      PSC_S1;
-                UCHAR      PSC_S2;
-                UCHAR      PSC_S3;
-                UCHAR      PSC_S4;
-                UCHAR      PSC_S5;
-                UCHAR      PWD_2B;
-                UCHAR      PWD_2C;
-                UCHAR      PWD_2D;
-                UCHAR      PWD_2E;
-                UCHAR      PWD_2F;
-                UCHAR      Spectrum_31;
-                UCHAR      Spectrum_32;
-                UCHAR      Spectrum_33;
-                UCHAR      Spectrum_34;
+ 		unsigned char      LCD_ID;
+                unsigned short     LCD_Capability;
+                unsigned char      LCD_SetFlag;
+                unsigned char      LCD_DelayCompensation;
+                unsigned char      LCD_HSyncWidth;
+                unsigned char      LCD_VSyncWidth;
+                unsigned char      LCD_VCLK;
+                unsigned char      LCDA_VCLKData1;
+                unsigned char      LCDA_VCLKData2;
+                unsigned char      LCUCHAR_VCLKData1;
+                unsigned char      LCUCHAR_VCLKData2;
+                unsigned char      PSC_S1;
+                unsigned char      PSC_S2;
+                unsigned char      PSC_S3;
+                unsigned char      PSC_S4;
+                unsigned char      PSC_S5;
+                unsigned char      PWD_2B;
+                unsigned char      PWD_2C;
+                unsigned char      PWD_2D;
+                unsigned char      PWD_2E;
+                unsigned char      PWD_2F;
+                unsigned char      Spectrum_31;
+                unsigned char      Spectrum_32;
+                unsigned char      Spectrum_33;
+                unsigned char      Spectrum_34;
 } XGI330_LCDCapStruct;
 
 typedef struct _XGI21_LVDSCapStruct
 {
-                USHORT     LVDS_Capability;
-                USHORT     LVDSHT;
-                USHORT     LVDSVT;
-                USHORT     LVDSHDE;
-                USHORT     LVDSVDE;
-                USHORT     LVDSHFP;
-                USHORT     LVDSVFP;
-                USHORT     LVDSHSYNC;
-                USHORT     LVDSVSYNC;
-                UCHAR      VCLKData1;
-                UCHAR      VCLKData2;
-                UCHAR      PSC_S1;
-                UCHAR      PSC_S2;
-                UCHAR      PSC_S3;
-                UCHAR      PSC_S4;
-                UCHAR      PSC_S5;
+                unsigned short     LVDS_Capability;
+                unsigned short     LVDSHT;
+                unsigned short     LVDSVT;
+                unsigned short     LVDSHDE;
+                unsigned short     LVDSVDE;
+                unsigned short     LVDSHFP;
+                unsigned short     LVDSVFP;
+                unsigned short     LVDSHSYNC;
+                unsigned short     LVDSVSYNC;
+                unsigned char      VCLKData1;
+                unsigned char      VCLKData2;
+                unsigned char      PSC_S1;
+                unsigned char      PSC_S2;
+                unsigned char      PSC_S3;
+                unsigned char      PSC_S4;
+                unsigned char      PSC_S5;
 } XGI21_LVDSCapStruct;
 
 typedef struct _XGI_CRT1TableStruct
 {
-  UCHAR CR[16];
+  unsigned char CR[16];
 } XGI_CRT1TableStruct;
 
 
 typedef struct _XGI330_VCLKDataStruct
 {
-    UCHAR SR2B,SR2C;
-    USHORT CLOCK;
+    unsigned char SR2B,SR2C;
+    unsigned short CLOCK;
 } XGI330_VCLKDataStruct;
 
 typedef struct _XGI301C_Tap4TimingStruct
 {
-    USHORT DE;
-    UCHAR  Reg[64];   /* C0-FF */
+    unsigned short DE;
+    unsigned char  Reg[64];   /* C0-FF */
 } XGI301C_Tap4TimingStruct;
 
 typedef struct _XGI_New_StandTableStruct
 {
-	UCHAR  CRT_COLS;
-	UCHAR  ROWS;
-	UCHAR  CHAR_HEIGHT;
-	USHORT CRT_LEN;
-	UCHAR  SR[4];
-	UCHAR  MISC;
-	UCHAR  CRTC[0x19];
-	UCHAR  ATTR[0x14];
-	UCHAR  GRC[9];
+	unsigned char  CRT_COLS;
+	unsigned char  ROWS;
+	unsigned char  CHAR_HEIGHT;
+	unsigned short CRT_LEN;
+	unsigned char  SR[4];
+	unsigned char  MISC;
+	unsigned char  CRTC[0x19];
+	unsigned char  ATTR[0x14];
+	unsigned char  GRC[9];
 } XGI_New_StandTableStruct;
 
-typedef UCHAR DRAM8Type[8];
-typedef UCHAR DRAM4Type[4];
-typedef UCHAR DRAM32Type[32];
-typedef UCHAR DRAM2Type[2];
+typedef unsigned char DRAM8Type[8];
+typedef unsigned char DRAM4Type[4];
+typedef unsigned char DRAM32Type[32];
+typedef unsigned char DRAM2Type[2];
 
 typedef struct _VB_DEVICE_INFO  VB_DEVICE_INFO;
 typedef VB_DEVICE_INFO *	PVB_DEVICE_INFO;
 
 struct _VB_DEVICE_INFO
 {
-    BOOLEAN  ISXPDOS;
-    ULONG   P3c4,P3d4,P3c0,P3ce,P3c2,P3cc;
-    ULONG   P3ca,P3c6,P3c7,P3c8,P3c9,P3da;
-    ULONG   Part0Port,Part1Port,Part2Port;
-    ULONG   Part3Port,Part4Port,Part5Port;
-    USHORT   RVBHCFACT,RVBHCMAX,RVBHRS;
-    USHORT   VGAVT,VGAHT,VGAVDE,VGAHDE;
-    USHORT   VT,HT,VDE,HDE;
-    USHORT   LCDHRS,LCDVRS,LCDHDES,LCDVDES;
-
-    USHORT   ModeType;
-    USHORT   IF_DEF_LVDS,IF_DEF_TRUMPION,IF_DEF_DSTN;/* ,IF_DEF_FSTN; add for dstn */
-    USHORT   IF_DEF_CRT2Monitor,IF_DEF_VideoCapture;
-    USHORT   IF_DEF_LCDA,IF_DEF_CH7017,IF_DEF_YPbPr,IF_DEF_ScaleLCD,IF_DEF_OEMUtil,IF_DEF_PWD;
-    USHORT   IF_DEF_ExpLink;
-    USHORT   IF_DEF_CH7005,IF_DEF_HiVision;
-    USHORT   IF_DEF_CH7007; /* Billy 2007/05/03 */
-    USHORT   LCDResInfo,LCDTypeInfo, VBType;/*301b*/
-    USHORT   VBInfo,TVInfo,LCDInfo, Set_VGAType;
-    USHORT   VBExtInfo;/*301lv*/
-    USHORT   SetFlag;
-    USHORT   NewFlickerMode;
-    USHORT   SelectCRT2Rate;
-
-    PUCHAR ROMAddr;
-    PUCHAR FBAddr;
-    ULONG BaseAddr;
-    ULONG RelIO;
+    bool  ISXPDOS;
+    unsigned long   P3c4,P3d4,P3c0,P3ce,P3c2,P3cc;
+    unsigned long   P3ca,P3c6,P3c7,P3c8,P3c9,P3da;
+    unsigned long   Part0Port,Part1Port,Part2Port;
+    unsigned long   Part3Port,Part4Port,Part5Port;
+    unsigned short   RVBHCFACT,RVBHCMAX,RVBHRS;
+    unsigned short   VGAVT,VGAHT,VGAVDE,VGAHDE;
+    unsigned short   VT,HT,VDE,HDE;
+    unsigned short   LCDHRS,LCDVRS,LCDHDES,LCDVDES;
+
+    unsigned short   ModeType;
+    unsigned short   IF_DEF_LVDS,IF_DEF_TRUMPION,IF_DEF_DSTN;/* ,IF_DEF_FSTN; add for dstn */
+    unsigned short   IF_DEF_CRT2Monitor,IF_DEF_VideoCapture;
+    unsigned short   IF_DEF_LCDA,IF_DEF_CH7017,IF_DEF_YPbPr,IF_DEF_ScaleLCD,IF_DEF_OEMUtil,IF_DEF_PWD;
+    unsigned short   IF_DEF_ExpLink;
+    unsigned short   IF_DEF_CH7005,IF_DEF_HiVision;
+    unsigned short   IF_DEF_CH7007; /* Billy 2007/05/03 */
+    unsigned short   LCDResInfo,LCDTypeInfo, VBType;/*301b*/
+    unsigned short   VBInfo,TVInfo,LCDInfo, Set_VGAType;
+    unsigned short   VBExtInfo;/*301lv*/
+    unsigned short   SetFlag;
+    unsigned short   NewFlickerMode;
+    unsigned short   SelectCRT2Rate;
+
+    unsigned char * ROMAddr;
+    unsigned char * FBAddr;
+    unsigned long BaseAddr;
+    unsigned long RelIO;
 
     DRAM4Type  *CR6B;
     DRAM4Type  *CR6E;
@@ -418,72 +418,72 @@ struct _VB_DEVICE_INFO
 
     DRAM8Type  *SR15; /* pointer : point to array */
     DRAM8Type  *CR40;
-    UCHAR  *pSoftSetting;
-    UCHAR  *pOutputSelect;
-
-    USHORT *pRGBSenseData;
-    USHORT *pRGBSenseData2; /*301b*/
-    USHORT *pVideoSenseData;
-    USHORT *pVideoSenseData2;
-    USHORT *pYCSenseData;
-    USHORT *pYCSenseData2;
-
-    UCHAR  *pSR07;
-    UCHAR  *CR49;
-    UCHAR  *pSR1F;
-    UCHAR  *AGPReg;
-    UCHAR  *SR16;
-    UCHAR  *pSR21;
-    UCHAR  *pSR22;
-    UCHAR  *pSR23;
-    UCHAR  *pSR24;
-    UCHAR  *SR25;
-    UCHAR  *pSR31;
-    UCHAR  *pSR32;
-    UCHAR  *pSR33;
-    UCHAR  *pSR36;      /* alan 12/07/2006 */
-    UCHAR  *pCRCF;
-    UCHAR  *pCRD0;      /* alan 12/07/2006 */
-    UCHAR  *pCRDE;      /* alan 12/07/2006 */
-    UCHAR  *pCR8F;      /* alan 12/07/2006 */
-    UCHAR  *pSR40;      /* alan 12/07/2006 */
-    UCHAR  *pSR41;      /* alan 12/07/2006 */
-    UCHAR  *pDVOSetting;
-    UCHAR  *pCR2E;
-    UCHAR  *pCR2F;
-    UCHAR  *pCR46;
-    UCHAR  *pCR47;
-    UCHAR  *pCRT2Data_1_2;
-    UCHAR  *pCRT2Data_4_D;
-    UCHAR  *pCRT2Data_4_E;
-    UCHAR  *pCRT2Data_4_10;
+    unsigned char  *pSoftSetting;
+    unsigned char  *pOutputSelect;
+
+    unsigned short *pRGBSenseData;
+    unsigned short *pRGBSenseData2; /*301b*/
+    unsigned short *pVideoSenseData;
+    unsigned short *pVideoSenseData2;
+    unsigned short *pYCSenseData;
+    unsigned short *pYCSenseData2;
+
+    unsigned char  *pSR07;
+    unsigned char  *CR49;
+    unsigned char  *pSR1F;
+    unsigned char  *AGPReg;
+    unsigned char  *SR16;
+    unsigned char  *pSR21;
+    unsigned char  *pSR22;
+    unsigned char  *pSR23;
+    unsigned char  *pSR24;
+    unsigned char  *SR25;
+    unsigned char  *pSR31;
+    unsigned char  *pSR32;
+    unsigned char  *pSR33;
+    unsigned char  *pSR36;      /* alan 12/07/2006 */
+    unsigned char  *pCRCF;
+    unsigned char  *pCRD0;      /* alan 12/07/2006 */
+    unsigned char  *pCRDE;      /* alan 12/07/2006 */
+    unsigned char  *pCR8F;      /* alan 12/07/2006 */
+    unsigned char  *pSR40;      /* alan 12/07/2006 */
+    unsigned char  *pSR41;      /* alan 12/07/2006 */
+    unsigned char  *pDVOSetting;
+    unsigned char  *pCR2E;
+    unsigned char  *pCR2F;
+    unsigned char  *pCR46;
+    unsigned char  *pCR47;
+    unsigned char  *pCRT2Data_1_2;
+    unsigned char  *pCRT2Data_4_D;
+    unsigned char  *pCRT2Data_4_E;
+    unsigned char  *pCRT2Data_4_10;
     XGI_MCLKDataStruct  *MCLKData;
     XGI_ECLKDataStruct  *ECLKData;
 
-    UCHAR   *XGI_TVDelayList;
-    UCHAR   *XGI_TVDelayList2;
-    UCHAR   *CHTVVCLKUNTSC;
-    UCHAR   *CHTVVCLKONTSC;
-    UCHAR   *CHTVVCLKUPAL;
-    UCHAR   *CHTVVCLKOPAL;
-    UCHAR   *NTSCTiming;
-    UCHAR   *PALTiming;
-    UCHAR   *HiTVExtTiming;
-    UCHAR   *HiTVSt1Timing;
-    UCHAR   *HiTVSt2Timing;
-    UCHAR   *HiTVTextTiming;
-    UCHAR   *YPbPr750pTiming;
-    UCHAR   *YPbPr525pTiming;
-    UCHAR   *YPbPr525iTiming;
-    UCHAR   *HiTVGroup3Data;
-    UCHAR   *HiTVGroup3Simu;
-    UCHAR   *HiTVGroup3Text;
-    UCHAR   *Ren525pGroup3;
-    UCHAR   *Ren750pGroup3;
-    UCHAR   *ScreenOffset;
-    UCHAR   *pXGINew_DRAMTypeDefinition;
-    UCHAR   *pXGINew_I2CDefinition ;
-    UCHAR   *pXGINew_CR97 ;
+    unsigned char   *XGI_TVDelayList;
+    unsigned char   *XGI_TVDelayList2;
+    unsigned char   *CHTVVCLKUNTSC;
+    unsigned char   *CHTVVCLKONTSC;
+    unsigned char   *CHTVVCLKUPAL;
+    unsigned char   *CHTVVCLKOPAL;
+    unsigned char   *NTSCTiming;
+    unsigned char   *PALTiming;
+    unsigned char   *HiTVExtTiming;
+    unsigned char   *HiTVSt1Timing;
+    unsigned char   *HiTVSt2Timing;
+    unsigned char   *HiTVTextTiming;
+    unsigned char   *YPbPr750pTiming;
+    unsigned char   *YPbPr525pTiming;
+    unsigned char   *YPbPr525iTiming;
+    unsigned char   *HiTVGroup3Data;
+    unsigned char   *HiTVGroup3Simu;
+    unsigned char   *HiTVGroup3Text;
+    unsigned char   *Ren525pGroup3;
+    unsigned char   *Ren750pGroup3;
+    unsigned char   *ScreenOffset;
+    unsigned char   *pXGINew_DRAMTypeDefinition;
+    unsigned char   *pXGINew_I2CDefinition ;
+    unsigned char   *pXGINew_CR97 ;
 
     XGI330_LCDCapStruct  *LCDCapList;
     XGI21_LVDSCapStruct  *XG21_LVDSCapList;
@@ -507,18 +507,18 @@ struct _VB_DEVICE_INFO
 
 typedef struct
 {
-    USHORT    Horizontal_ACTIVE;
-    USHORT    Horizontal_FP;
-    USHORT    Horizontal_SYNC;
-    USHORT    Horizontal_BP;
-    USHORT    Vertical_ACTIVE;
-    USHORT    Vertical_FP;
-    USHORT    Vertical_SYNC;
-    USHORT    Vertical_BP;
+    unsigned short    Horizontal_ACTIVE;
+    unsigned short    Horizontal_FP;
+    unsigned short    Horizontal_SYNC;
+    unsigned short    Horizontal_BP;
+    unsigned short    Vertical_ACTIVE;
+    unsigned short    Vertical_FP;
+    unsigned short    Vertical_SYNC;
+    unsigned short    Vertical_BP;
     double    DCLK;
-    UCHAR     FrameRate;
-    UCHAR     Interlace;
-    USHORT    Margin;
+    unsigned char     FrameRate;
+    unsigned char     Interlace;
+    unsigned short    Margin;
 } TimingInfo;
 
 #define _VB_STRUCT_
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index 781caef..ea8fd2d 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -63,14 +63,14 @@ XGI_ECLKDataStruct XGI340_ECLKData[]=
 
 
 
-UCHAR XGI340_SR13[4][8]={
+unsigned char XGI340_SR13[4][8]={
 {0x35,0x45,0xb1,0x00,0x00,0x00,0x00,0x00},/* SR13 */
 {0x41,0x51,0x5c,0x00,0x00,0x00,0x00,0x00},/* SR14 */
 {0x31,0x42,0x42,0x00,0x00,0x00,0x00,0x00},/* SR18 */
 {0x03,0x03,0x03,0x00,0x00,0x00,0x00,0x00}/* SR1B */
 };
 
-UCHAR XGI340_cr41[24][8]=
+unsigned char XGI340_cr41[24][8]=
 {{0x20,0x50,0x60,0x00,0x00,0x00,0x00,0x00},/* 0 CR41 */
 {0xc4,0x40,0x84,0x00,0x00,0x00,0x00,0x00},/* 1 CR8A */
 {0xc4,0x40,0x84,0x00,0x00,0x00,0x00,0x00},/* 2 CR8B */
@@ -98,7 +98,7 @@ UCHAR XGI340_cr41[24][8]=
 };
 
 
-UCHAR XGI27_cr41[24][8]=
+unsigned char XGI27_cr41[24][8]=
 {
 {0x20,0x40,0x60,0x00,0x00,0x00,0x00,0x00},/* 0 CR41 */
 {0xC4,0x40,0x84,0x00,0x00,0x00,0x00,0x00},/* 1 CR8A */
@@ -128,7 +128,7 @@ UCHAR XGI27_cr41[24][8]=
 
 
 #if 0
-UCHAR XGI27_cr41[24][8]=
+unsigned char XGI27_cr41[24][8]=
 {
 {0x20,0x60,0x60,0x00,0x00,0x00,0x00,0x00},/* 0 CR41 */
 {0x04,0x44,0x84,0x00,0x00,0x00,0x00,0x00},/* 1 CR8A */
@@ -156,7 +156,7 @@ UCHAR XGI27_cr41[24][8]=
 {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}/* 23 CRC5 */
 };
 #endif
-UCHAR XGI340_CR6B[8][4]={
+unsigned char XGI340_CR6B[8][4]={
 {0xaa,0xaa,0xaa,0xaa},
 {0xaa,0xaa,0xaa,0xaa},
 {0xaa,0xaa,0xaa,0xaa},
@@ -167,7 +167,7 @@ UCHAR XGI340_CR6B[8][4]={
 {0x00,0x00,0x00,0x00}
 };
 
-UCHAR XGI340_CR6E[8][4]={
+unsigned char XGI340_CR6E[8][4]={
 {0x00,0x00,0x00,0x00},
 {0x00,0x00,0x00,0x00},
 {0x00,0x00,0x00,0x00},
@@ -178,7 +178,7 @@ UCHAR XGI340_CR6E[8][4]={
 {0x00,0x00,0x00,0x00}
 };
 
-UCHAR XGI340_CR6F[8][32]={
+unsigned char XGI340_CR6F[8][32]={
 {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00},
 {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00},
 {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00},
@@ -189,7 +189,7 @@ UCHAR XGI340_CR6F[8][32]={
 {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}
 };
 
-UCHAR XGI340_CR89[8][2]={
+unsigned char XGI340_CR89[8][2]={
 {0x00,0x00},
 {0x00,0x00},
 {0x00,0x00},
@@ -200,11 +200,11 @@ UCHAR XGI340_CR89[8][2]={
 {0x00,0x00}
 };
 			 /* CR47,CR48,CR49,CR4A,CR4B,CR4C,CR70,CR71,CR74,CR75,CR76,CR77 */
-UCHAR XGI340_AGPReg[12]={0x28,0x23,0x00,0x20,0x00,0x20,0x00,0x05,0xd0,0x10,0x10,0x00};
+unsigned char XGI340_AGPReg[12]={0x28,0x23,0x00,0x20,0x00,0x20,0x00,0x05,0xd0,0x10,0x10,0x00};
 
-UCHAR XGI340_SR16[4]={0x03,0x83,0x03,0x83};
+unsigned char XGI340_SR16[4]={0x03,0x83,0x03,0x83};
 
-UCHAR XGI330_SR15_1[8][8]={
+unsigned char XGI330_SR15_1[8][8]={
 {0x0,0x0,0x00,0x00,0x20,0x20,0x00,0x00},
 {0x5,0x15,0x15,0x15,0x15,0x15,0x00,0x00},
 {0xba,0xba,0xba,0xba,0xBA,0xBA,0x00,0x00},
@@ -215,7 +215,7 @@ UCHAR XGI330_SR15_1[8][8]={
 {0x0,0xa5,0xfb,0xf6,0xF6,0xF6,0x00,0x00}
 };
 
-UCHAR XGI330_cr40_1[15][8]={
+unsigned char XGI330_cr40_1[15][8]={
 {0x66,0x40,0x40,0x28,0x24,0x24,0x00,0x00},
 {0x66,0x00,0x00,0x00,0x00,0x00,0x00,0x00},
 {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00},
@@ -233,12 +233,12 @@ UCHAR XGI330_cr40_1[15][8]={
 {0x00,0xA2,0x00,0x00,0xA2,0xA2,0x00,0x00},
 };
 
-UCHAR XGI330_sr25[]={0x00,0x0};
-UCHAR XGI330_sr31=0xc0;
-UCHAR XGI330_sr32=0x11;
-UCHAR XGI330_SR33=0x00;
-UCHAR XG40_CRCF=0x13;
-UCHAR XG40_DRAMTypeDefinition=0xFF ;
+unsigned char XGI330_sr25[]={0x00,0x0};
+unsigned char XGI330_sr31=0xc0;
+unsigned char XGI330_sr32=0x11;
+unsigned char XGI330_SR33=0x00;
+unsigned char XG40_CRCF=0x13;
+unsigned char XG40_DRAMTypeDefinition=0xFF ;
 
 XGI_StStruct XGI330_SModeIDTable[]=
 {
@@ -994,9 +994,9 @@ XGI330_CHTVRegDataStruct XGI_CHTVRegOPAL[]={
                 {{      0xE4,0x7F,0xB7,0x1E,0xAF,0x29,0x37,0x5A,0x05,0x00,0x80,0x25,0x8C,0xB2,0x2A,0x00 }}/* 06 (1024x768) ;;1/12/02 */
 	     };
 
-UCHAR XGI_CH7017LV1024x768[]={0x60,0x02,0x00,0x07,0x40,0xED,0xA3,
+unsigned char XGI_CH7017LV1024x768[]={0x60,0x02,0x00,0x07,0x40,0xED,0xA3,
                    			0xC8,0xC7,0xAC,0xE0,0x02};
-UCHAR XGI_CH7017LV1400x1050[]={0x60,0x03,0x11,0x00,0x40,0xE3,0xAD,
+unsigned char XGI_CH7017LV1400x1050[]={0x60,0x03,0x11,0x00,0x40,0xE3,0xAD,
                    			0xDB,0xF6,0xAC,0xE0,0x02};
 
 
@@ -1784,7 +1784,7 @@ XGI330_TVDataStruct  XGI_StYPbPr750pData[]=
  {    1,   1,1650, 750,1280, 480,   0,   0, 760},
 };
 
-UCHAR XGI330_NTSCTiming[] = {
+unsigned char XGI330_NTSCTiming[] = {
   0x17,0x1d,0x03,0x09,0x05,0x06,0x0c,0x0c,
   0x94,0x49,0x01,0x0a,0x06,0x0d,0x04,0x0a,
   0x06,0x14,0x0d,0x04,0x0a,0x00,0x85,0x1b,
@@ -1794,7 +1794,7 @@ UCHAR XGI330_NTSCTiming[] = {
   0x60,0x80,0x14,0x90,0x8c,0x60,0x14,0x50,
   0x00,0x40,0x44,0x00,0xdb,0x02,0x3b,0x00};
 
-UCHAR XGI330_PALTiming[] = {
+unsigned char XGI330_PALTiming[] = {
   0x21,0x5A,0x35,0x6e,0x04,0x38,0x3d,0x70,
   0x94,0x49,0x01,0x12,0x06,0x3e,0x35,0x6d,
   0x06,0x14,0x3e,0x35,0x6d,0x00,0x45,0x2b,
@@ -1804,7 +1804,7 @@ UCHAR XGI330_PALTiming[] = {
   0x60,0x80,0x14,0x90,0x8c,0x60,0x14,0x63,
   0x00,0x40,0x3e,0x00,0xe1,0x02,0x28,0x00};
 
-UCHAR XGI330_HiTVExtTiming[] =
+unsigned char XGI330_HiTVExtTiming[] =
 {
       0x2D,0x60,0x2C,0x5F,0x08,0x31,0x3A,0x64,
       0x28,0x02,0x01,0x3D,0x06,0x3E,0x35,0x6D,
@@ -1818,7 +1818,7 @@ UCHAR XGI330_HiTVExtTiming[] =
 
 };
 
-UCHAR XGI330_HiTVSt1Timing[] =
+unsigned char XGI330_HiTVSt1Timing[] =
 {
       0x32,0x65,0x2C,0x5F,0x08,0x31,0x3A,0x65,
       0x28,0x02,0x01,0x3D,0x06,0x3E,0x35,0x6D,
@@ -1831,7 +1831,7 @@ UCHAR XGI330_HiTVSt1Timing[] =
       0x0E,0x00,0xfc,0xff,0x2d,0x00
 };
 
-UCHAR XGI330_HiTVSt2Timing[] =
+unsigned char XGI330_HiTVSt2Timing[] =
 {
       0x32,0x65,0x2C,0x5F,0x08,0x31,0x3A,0x64,
       0x28,0x02,0x01,0x3D,0x06,0x3E,0x35,0x6D,
@@ -1844,7 +1844,7 @@ UCHAR XGI330_HiTVSt2Timing[] =
       0x27,0x00,0xFC,0xff,0x6a,0x00
 };
 
-UCHAR XGI330_HiTVTextTiming[] =
+unsigned char XGI330_HiTVTextTiming[] =
 {
       0x32,0x65,0x2C,0x5F,0x08,0x31,0x3A,0x65,
       0x28,0x02,0x01,0x3D,0x06,0x3E,0x35,0x6D,
@@ -1857,7 +1857,7 @@ UCHAR XGI330_HiTVTextTiming[] =
       0x11,0x00,0xFC,0xFF,0x32,0x00
 };
 
-UCHAR XGI330_YPbPr750pTiming[] =
+unsigned char XGI330_YPbPr750pTiming[] =
 {
       0x30,0x1d,0xe8,0x09,0x09,0xed,0x0c,0x0c,
       0x98,0x0a,0x01,0x0c,0x06,0x0d,0x04,0x0a,
@@ -1870,7 +1870,7 @@ UCHAR XGI330_YPbPr750pTiming[] =
       0x11,0x00,0xfc,0xff,0x32,0x00
 };
 
-UCHAR XGI330_YPbPr525pTiming[] =
+unsigned char XGI330_YPbPr525pTiming[] =
 {
       0x3E,0x11,0x06,0x09,0x0b,0x0c,0x0c,0x0c,
       0x98,0x0a,0x01,0x0d,0x06,0x0d,0x04,0x0a,
@@ -1883,7 +1883,7 @@ UCHAR XGI330_YPbPr525pTiming[] =
       0x11,0x00,0xFC,0xFF,0x32,0x00
 };
 
-UCHAR XGI330_YPbPr525iTiming[] =
+unsigned char XGI330_YPbPr525iTiming[] =
 {
       0x1B,0x21,0x03,0x09,0x05,0x06,0x0C,0x0C,
       0x94,0x49,0x01,0x0A,0x06,0x0D,0x04,0x0A,
@@ -1897,7 +1897,7 @@ UCHAR XGI330_YPbPr525iTiming[] =
 
 };
 
-UCHAR XGI330_HiTVGroup3Data[] =
+unsigned char XGI330_HiTVGroup3Data[] =
 {
       0x00,0x1A,0x22,0x63,0x62,0x22,0x08,0x5F,
       0x05,0x21,0xB2,0xB2,0x55,0x77,0x2A,0xA6,
@@ -1909,7 +1909,7 @@ UCHAR XGI330_HiTVGroup3Data[] =
       0x18,0x05,0x18,0x05,0x4C,0xA8,0x01
 };
 
-UCHAR XGI330_HiTVGroup3Simu[] =
+unsigned char XGI330_HiTVGroup3Simu[] =
 {
       0x00,0x1A,0x22,0x63,0x62,0x22,0x08,0x95,
       0xDB,0x20,0xB8,0xB8,0x55,0x47,0x2A,0xA6,
@@ -1921,7 +1921,7 @@ UCHAR XGI330_HiTVGroup3Simu[] =
       0x18,0x05,0x18,0x05,0x4C,0xA8,0x01
 };
 
-UCHAR XGI330_HiTVGroup3Text[] =
+unsigned char XGI330_HiTVGroup3Text[] =
 {
       0x00,0x1A,0x22,0x63,0x62,0x22,0x08,0xA7,
       0xF5,0x20,0xCE,0xCE,0x55,0x47,0x2A,0xA6,
@@ -1933,7 +1933,7 @@ UCHAR XGI330_HiTVGroup3Text[] =
       0x18,0x05,0x18,0x05,0x4C,0xA8,0x01
 };
 
-UCHAR XGI330_Ren525pGroup3[] =
+unsigned char XGI330_Ren525pGroup3[] =
 {
   0x00,0x14,0x15,0x25,0x55,0x15,0x0b,0x13,
   0xB1,0x41,0x62,0x62,0xFF,0xF4,0x45,0xa6,
@@ -1945,7 +1945,7 @@ UCHAR XGI330_Ren525pGroup3[] =
   0x1a,0x1F,0x25,0x2a,0x4C,0xAA,0x01
 };
 
-UCHAR XGI330_Ren750pGroup3[] =
+unsigned char XGI330_Ren750pGroup3[] =
 {
   0x00,0x14,0x15,0x25,0x55,0x15,0x0b,0x7a,
   0x54,0x41,0xE7,0xE7,0xFF,0xF4,0x45,0xa6,
@@ -2968,7 +2968,7 @@ XGI330_TVDataTablStruct XGI_TVDataTable[]=
  {0xffff,0x0000,12}  	/* END */
 };
 
-USHORT TVLenList[]=
+unsigned short TVLenList[]=
 {
    LVDSCRT1Len_H,
    LVDSCRT1Len_V,
@@ -3010,7 +3010,7 @@ XGI330_TVDataTablStruct XGI_EPLCHTVRegPtr[]=
   {0xFFFF,0x0000,4}
 };
 
-USHORT LCDLenList[]=
+unsigned short LCDLenList[]=
 {
    LVDSCRT1Len_H,
    LVDSCRT1Len_V,
@@ -3422,7 +3422,7 @@ XGI_VBVCLKDataStruct XGI330_VBVCLKData[]=
  { 0x70,0x44,108}, /* 0x49 chiawen for 1400x1050*/
 };
 
-UCHAR XGI330_ScreenOffset[]={ 0x14,0x19,0x20,0x28,0x32,0x40,0x50,0x64,0x78,0x80,0x2d,0x35,0x57,0x48 };
+unsigned char XGI330_ScreenOffset[]={ 0x14,0x19,0x20,0x28,0x32,0x40,0x50,0x64,0x78,0x80,0x2d,0x35,0x57,0x48 };
 
 XGI_StResInfoStruct XGI330_StResInfo[]=
 {
@@ -3460,10 +3460,10 @@ XGI_ModeResInfoStruct XGI330_ModeResInfo[]=
  { 1152, 864, 8,16}
 };
 
-UCHAR XGI330_OutputSelect =0x40;
-UCHAR XGI330_SoftSetting = 0x30;
-UCHAR XGI330_SR07=0x18;
-UCHAR XGI330New_SR15[8][8]={
+unsigned char XGI330_OutputSelect =0x40;
+unsigned char XGI330_SoftSetting = 0x30;
+unsigned char XGI330_SR07=0x18;
+unsigned char XGI330New_SR15[8][8]={
 {0x0,0x4,0x60,0x60},
 {0xf,0xf,0xf,0xf},
 {0xba,0xba,0xba,0xba},
@@ -3474,7 +3474,7 @@ UCHAR XGI330New_SR15[8][8]={
 {0x0,0xa5,0xfb,0xf6}
 };
 
-UCHAR XGI330New_CR40[5][8]={
+unsigned char XGI330New_CR40[5][8]={
 {0x77,0x77,0x44,0x44},
 {0x77,0x77,0x44,0x44},
 {0x0,0x0,0x0,0x0},
@@ -3482,63 +3482,63 @@ UCHAR XGI330New_CR40[5][8]={
 {0x0,0x0,0xf0,0xf8}
 };
 
-UCHAR XGI330_CR49[]={0xaa,0x88};
-UCHAR XGI330_SR1F=0x0;
-UCHAR XGI330_SR21=0xa3;
-UCHAR XGI330_650_SR21=0xa7;
-UCHAR XGI330_SR22=0xfb;
-UCHAR XGI330_SR23=0xf6;
-UCHAR XGI330_SR24=0xd;
-
-UCHAR XGI660_SR21=0xa3;/* 2003.0312 */
-UCHAR XGI660_SR22=0xf3;/* 2003.0312 */
-
-UCHAR XGI330_LVDS_SR32=0x00;   /* ynlai for 650 LVDS */
-UCHAR XGI330_LVDS_SR33=0x00;	/* chiawen for 650 LVDS */
-UCHAR XGI330_650_SR31=0x40;
-UCHAR XGI330_650_SR33=0x04;
-UCHAR XGI330_CRT2Data_1_2 = 0x0;
-UCHAR XGI330_CRT2Data_4_D = 0x0;
-UCHAR XGI330_CRT2Data_4_E = 0x0;
-UCHAR XGI330_CRT2Data_4_10 = 0x80;
-USHORT XGI330_RGBSenseData = 0xd1;
-USHORT XGI330_VideoSenseData = 0xb9;
-USHORT XGI330_YCSenseData = 0xb3;
-USHORT XGI330_RGBSenseData2 = 0x0190;     /*301b*/
-USHORT XGI330_VideoSenseData2 = 0x0110;
-USHORT XGI330_YCSenseData2 = 0x016B;
-UCHAR XGI330_NTSCPhase[] = {0x21,0xed,0x8a,0x8};
-UCHAR XGI330_PALPhase[] = {0x2a,0x5,0xd3,0x0};
-UCHAR XGI330_NTSCPhase2[] = {0x21,0xF0,0x7B,0xD6};/*301b*/
-UCHAR XGI330_PALPhase2[] = {0x2a,0x09,0x86,0xe9};
-UCHAR XGI330_PALMPhase[] = {0x21,0xE4,0x2E,0x9B};   /*palmn*/
-UCHAR XGI330_PALNPhase[] = {0x21,0xF4,0x3E,0xBA};
-UCHAR XG40_I2CDefinition = 0x00 ;
-UCHAR XG20_CR97 = 0x10 ;
-
-UCHAR XG21_DVOSetting = 0x00 ;
-UCHAR XG21_CR2E = 0x00 ;
-UCHAR XG21_CR2F = 0x00 ;
-UCHAR XG21_CR46 = 0x00 ;
-UCHAR XG21_CR47 = 0x00 ;
-
-UCHAR XG27_CR97 = 0xC1 ;
-UCHAR XG27_SR36 = 0x30 ;
-UCHAR XG27_CR8F = 0x0C ;
-UCHAR XG27_CRD0[] = {0,0,0,0,0,0,0,0x82,0x00,0x66,0x01,0x00} ;
-UCHAR XG27_CRDE[] = {0,0} ;
-UCHAR XG27_SR40 = 0x04 ;
-UCHAR XG27_SR41 = 0x00 ;
-
-UCHAR XGI330_CHTVVCLKUNTSC[]={0x00 };
-
-UCHAR XGI330_CHTVVCLKONTSC[]={0x00 };
-
-UCHAR XGI330_CHTVVCLKUPAL[]={0x00 };
-
-UCHAR XGI330_CHTVVCLKOPAL[]={0x00 };
-
-UCHAR XGI7007_CHTVVCLKUNTSC[]={CH7007TVVCLK30_2,
+unsigned char XGI330_CR49[]={0xaa,0x88};
+unsigned char XGI330_SR1F=0x0;
+unsigned char XGI330_SR21=0xa3;
+unsigned char XGI330_650_SR21=0xa7;
+unsigned char XGI330_SR22=0xfb;
+unsigned char XGI330_SR23=0xf6;
+unsigned char XGI330_SR24=0xd;
+
+unsigned char XGI660_SR21=0xa3;/* 2003.0312 */
+unsigned char XGI660_SR22=0xf3;/* 2003.0312 */
+
+unsigned char XGI330_LVDS_SR32=0x00;   /* ynlai for 650 LVDS */
+unsigned char XGI330_LVDS_SR33=0x00;	/* chiawen for 650 LVDS */
+unsigned char XGI330_650_SR31=0x40;
+unsigned char XGI330_650_SR33=0x04;
+unsigned char XGI330_CRT2Data_1_2 = 0x0;
+unsigned char XGI330_CRT2Data_4_D = 0x0;
+unsigned char XGI330_CRT2Data_4_E = 0x0;
+unsigned char XGI330_CRT2Data_4_10 = 0x80;
+unsigned short XGI330_RGBSenseData = 0xd1;
+unsigned short XGI330_VideoSenseData = 0xb9;
+unsigned short XGI330_YCSenseData = 0xb3;
+unsigned short XGI330_RGBSenseData2 = 0x0190;     /*301b*/
+unsigned short XGI330_VideoSenseData2 = 0x0110;
+unsigned short XGI330_YCSenseData2 = 0x016B;
+unsigned char XGI330_NTSCPhase[] = {0x21,0xed,0x8a,0x8};
+unsigned char XGI330_PALPhase[] = {0x2a,0x5,0xd3,0x0};
+unsigned char XGI330_NTSCPhase2[] = {0x21,0xF0,0x7B,0xD6};/*301b*/
+unsigned char XGI330_PALPhase2[] = {0x2a,0x09,0x86,0xe9};
+unsigned char XGI330_PALMPhase[] = {0x21,0xE4,0x2E,0x9B};   /*palmn*/
+unsigned char XGI330_PALNPhase[] = {0x21,0xF4,0x3E,0xBA};
+unsigned char XG40_I2CDefinition = 0x00 ;
+unsigned char XG20_CR97 = 0x10 ;
+
+unsigned char XG21_DVOSetting = 0x00 ;
+unsigned char XG21_CR2E = 0x00 ;
+unsigned char XG21_CR2F = 0x00 ;
+unsigned char XG21_CR46 = 0x00 ;
+unsigned char XG21_CR47 = 0x00 ;
+
+unsigned char XG27_CR97 = 0xC1 ;
+unsigned char XG27_SR36 = 0x30 ;
+unsigned char XG27_CR8F = 0x0C ;
+unsigned char XG27_CRD0[] = {0,0,0,0,0,0,0,0x82,0x00,0x66,0x01,0x00} ;
+unsigned char XG27_CRDE[] = {0,0} ;
+unsigned char XG27_SR40 = 0x04 ;
+unsigned char XG27_SR41 = 0x00 ;
+
+unsigned char XGI330_CHTVVCLKUNTSC[]={0x00 };
+
+unsigned char XGI330_CHTVVCLKONTSC[]={0x00 };
+
+unsigned char XGI330_CHTVVCLKUPAL[]={0x00 };
+
+unsigned char XGI330_CHTVVCLKOPAL[]={0x00 };
+
+unsigned char XGI7007_CHTVVCLKUNTSC[]={CH7007TVVCLK30_2,
                                CH7007TVVCLK30_2,
                                CH7007TVVCLK30_2,
                                CH7007TVVCLK30_2,
@@ -3546,7 +3546,7 @@ UCHAR XGI7007_CHTVVCLKUNTSC[]={CH7007TVVCLK30_2,
                                CH7007TVVCLK47_8
                               };
 
-UCHAR XGI7007_CHTVVCLKONTSC[]={CH7007TVVCLK26_4,
+unsigned char XGI7007_CHTVVCLKONTSC[]={CH7007TVVCLK26_4,
                                CH7007TVVCLK26_4,
                                CH7007TVVCLK26_4,
                                CH7007TVVCLK26_4,
@@ -3554,7 +3554,7 @@ UCHAR XGI7007_CHTVVCLKONTSC[]={CH7007TVVCLK26_4,
                                CH7007TVVCLK43_6
                               };
 
-UCHAR XGI7007_CHTVVCLKUPAL[]={CH7007TVVCLK31_5,
+unsigned char XGI7007_CHTVVCLKUPAL[]={CH7007TVVCLK31_5,
                               CH7007TVVCLK31_5,
                               CH7007TVVCLK31_5,
                               CH7007TVVCLK31_5,
@@ -3562,7 +3562,7 @@ UCHAR XGI7007_CHTVVCLKUPAL[]={CH7007TVVCLK31_5,
                               CH7007TVVCLK39
                              };
 
-UCHAR XGI7007_CHTVVCLKOPAL[]={CH7007TVVCLK31_5,
+unsigned char XGI7007_CHTVVCLKOPAL[]={CH7007TVVCLK31_5,
                               CH7007TVVCLK31_5,
                               CH7007TVVCLK31_5,
                               CH7007TVVCLK31_5,
@@ -3987,7 +3987,7 @@ XGI330_VCLKDataStruct XGI_VBVCLKData[]=
                 {      0xFF,0x00,0                }      /* End mark */
 };
 
-UCHAR XGI660_TVDelayList[]=
+unsigned char XGI660_TVDelayList[]=
 {
           0x44,            /* ; 0 ExtNTSCDelay */
           0x44,            /* ; 1 StNTSCDelay */
@@ -4003,7 +4003,7 @@ UCHAR XGI660_TVDelayList[]=
           0x44             /* ; B StYPbPrDealy(750p) */
 };
 
-UCHAR XGI660_TVDelayList2[]=
+unsigned char XGI660_TVDelayList2[]=
 {
           0x44,           /* ; 0 ExtNTSCDelay */
           0x44,           /* ; 1 StNTSCDelay */
@@ -4019,7 +4019,7 @@ UCHAR XGI660_TVDelayList2[]=
           0x44            /* ; B StYPbPrDealy(750p) */
 };
 
-UCHAR XGI301TVDelayList[]=
+unsigned char XGI301TVDelayList[]=
 {
 	0x22,            /* ; 0 ExtNTSCDelay */
 	0x22,            /* ; 1 StNTSCDelay */
@@ -4035,7 +4035,7 @@ UCHAR XGI301TVDelayList[]=
 	0x22            /* B StYPbPrDealy(750p) */
 };
 
-UCHAR XGI301TVDelayList2[]=
+unsigned char XGI301TVDelayList2[]=
 {
 	0x22,           /* ; 0 ExtNTSCDelay */
 	0x22,           /* ; 1 StNTSCDelay */
@@ -4052,7 +4052,7 @@ UCHAR XGI301TVDelayList2[]=
 };
 
 
-UCHAR TVAntiFlickList[]=
+unsigned char TVAntiFlickList[]=
 {/* NTSCAntiFlicker */
                       0x04,           /* ; 0 Adaptive */
                       0x00,           /* ; 1 new anti-flicker ? */
@@ -4065,7 +4065,7 @@ UCHAR TVAntiFlickList[]=
 };
 
 
-UCHAR TVEdgeList[]=
+unsigned char TVEdgeList[]=
 {
       0x00,            /* ; 0 NTSC No Edge enhance */
       0x04,            /* ; 1 NTSC Adaptive Edge enhance */
@@ -4075,7 +4075,7 @@ UCHAR TVEdgeList[]=
       0x00             /* ; 1 HiTV */
 };
 
-ULONG TVPhaseList[]=
+unsigned long TVPhaseList[]=
 {      0x08BAED21, /* ; 0 NTSC phase */
        0x00E3052A, /* ; 1 PAL phase */
        0x9B2EE421, /* ; 2 PAL-M phase */
@@ -4092,7 +4092,7 @@ ULONG TVPhaseList[]=
        0xE00A831E  /* ; D PAL-M 1024x768 */
 };
 
-UCHAR NTSCYFilter1[]=
+unsigned char NTSCYFilter1[]=
 {
 		      0x00,0xF4,0x10,0x38     ,/* 0 : 320x text mode */
                       0x00,0xF4,0x10,0x38     ,/* 1 : 360x text mode */
@@ -4103,7 +4103,7 @@ UCHAR NTSCYFilter1[]=
                       0xEB,0x15,0x25,0xF6     /* 6 : 800x gra. mode */
 };
 
-UCHAR PALYFilter1[]=
+unsigned char PALYFilter1[]=
 {
 		      0x00,0xF4,0x10,0x38, /* 0 : 320x text mode */
                       0x00,0xF4,0x10,0x38     ,/* 1 : 360x text mode */
@@ -4114,7 +4114,7 @@ UCHAR PALYFilter1[]=
                       0xFC,0xFB,0x14,0x2A     /* 6 : 800x gra. mode */
 };
 
-UCHAR PALMYFilter1[]=
+unsigned char PALMYFilter1[]=
 {
 		      0x00,0xF4,0x10,0x38, /* 0 : 320x text mode */
                       0x00,0xF4,0x10,0x38, /* 1 : 360x text mode */
@@ -4126,7 +4126,7 @@ UCHAR PALMYFilter1[]=
                       0xFF,0xFF,0xFF,0xFF  /* End of Table */
 };
 
-UCHAR PALNYFilter1[]=
+unsigned char PALNYFilter1[]=
 {
 		      0x00,0xF4,0x10,0x38, /* 0 : 320x text mode */
                       0x00,0xF4,0x10,0x38, /* 1 : 360x text mode */
@@ -4138,7 +4138,7 @@ UCHAR PALNYFilter1[]=
                       0xFF,0xFF,0xFF,0xFF  /* End of Table */
 };
 
-UCHAR NTSCYFilter2[]=
+unsigned char NTSCYFilter2[]=
 {
 		      0xFF,0x03,0x02,0xF6,0xFC,0x27,0x46, /* 0 : 320x text mode */
                       0x01,0x02,0xFE,0xF7,0x03,0x27,0x3C, /* 1 : 360x text mode */
@@ -4150,7 +4150,7 @@ UCHAR NTSCYFilter2[]=
                       0xFF,0xFF,0xFC,0x00,0x0F,0x22,0x28  /* 7 : 1024xgra. mode */
 };
 
-UCHAR PALYFilter2[]=
+unsigned char PALYFilter2[]=
 {
 		      0xFF,0x03,0x02,0xF6,0xFC,0x27,0x46, /* 0 : 320x text mode */
                       0x01,0x02,0xFE,0xF7,0x03,0x27,0x3C, /* 1 : 360x text mode */
@@ -4162,7 +4162,7 @@ UCHAR PALYFilter2[]=
                       0xFF,0xFF,0xFC,0x00,0x0F,0x22,0x28  /* 7 : 1024xgra. mode */
 };
 
-UCHAR PALMYFilter2[]=
+unsigned char PALMYFilter2[]=
 {
 		      0xFF,0x03,0x02,0xF6,0xFC,0x27,0x46, /* 0 : 320x text mode */
                       0x01,0x02,0xFE,0xF7,0x03,0x27,0x3C, /* 1 : 360x text mode */
@@ -4174,7 +4174,7 @@ UCHAR PALMYFilter2[]=
                       0xFF,0xFF,0xFC,0x00,0x0F,0x22,0x28  /* 7 : 1024xgra. mode */
 };
 
-UCHAR PALNYFilter2[]=
+unsigned char PALNYFilter2[]=
 {
 		      0xFF,0x03,0x02,0xF6,0xFC,0x27,0x46, /* 0 : 320x text mode */
                       0x01,0x02,0xFE,0xF7,0x03,0x27,0x3C, /* 1 : 360x text mode */
@@ -4186,7 +4186,7 @@ UCHAR PALNYFilter2[]=
                       0xFF,0xFF,0xFC,0x00,0x0F,0x22,0x28  /* 7 : 1024xgra. mode */
 };
 
-UCHAR XGI_NTSC1024AdjTime[]=
+unsigned char XGI_NTSC1024AdjTime[]=
 {
       0xa7,0x07,0xf2,0x6e,0x17,0x8b,0x73,0x53,
       0x13,0x40,0x34,0xF4,0x63,0xBB,0xCC,0x7A,
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 3419341..5a27338 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -6,17 +6,17 @@
 #include <asm/io.h>
 #include <linux/types.h>
 
-void XGINew_SetReg1( ULONG , USHORT , USHORT ) ;
-void XGINew_SetReg2( ULONG , USHORT , USHORT ) ;
-void XGINew_SetReg3( ULONG , USHORT ) ;
-void XGINew_SetReg4( ULONG , ULONG ) ;
-UCHAR XGINew_GetReg1( ULONG , USHORT) ;
-UCHAR XGINew_GetReg2( ULONG ) ;
-ULONG XGINew_GetReg3( ULONG ) ;
-void XGINew_ClearDAC( PUCHAR ) ;
-void     XGINew_SetRegANDOR(ULONG Port,USHORT Index,USHORT DataAND,USHORT DataOR);
-void     XGINew_SetRegOR(ULONG Port,USHORT Index,USHORT DataOR);
-void     XGINew_SetRegAND(ULONG Port,USHORT Index,USHORT DataAND);
+void XGINew_SetReg1( unsigned long , unsigned short , unsigned short ) ;
+void XGINew_SetReg2( unsigned long , unsigned short , unsigned short ) ;
+void XGINew_SetReg3( unsigned long , unsigned short ) ;
+void XGINew_SetReg4( unsigned long , unsigned long ) ;
+unsigned char XGINew_GetReg1( unsigned long , unsigned short) ;
+unsigned char XGINew_GetReg2( unsigned long ) ;
+unsigned long XGINew_GetReg3( unsigned long ) ;
+void XGINew_ClearDAC( unsigned char * ) ;
+void     XGINew_SetRegANDOR(unsigned long Port,unsigned short Index,unsigned short DataAND,unsigned short DataOR);
+void     XGINew_SetRegOR(unsigned long Port,unsigned short Index,unsigned short DataOR);
+void     XGINew_SetRegAND(unsigned long Port,unsigned short Index,unsigned short DataAND);
 
 
 /* --------------------------------------------------------------------- */
@@ -25,7 +25,7 @@ void     XGINew_SetRegAND(ULONG Port,USHORT Index,USHORT DataAND);
 /* Output : */
 /* Description : SR CRTC GR */
 /* --------------------------------------------------------------------- */
-void XGINew_SetReg1( ULONG port , USHORT index , USHORT data )
+void XGINew_SetReg1( unsigned long port , unsigned short index , unsigned short data )
 {
     outb( (u8)index , port ) ;
     outb( (u8)data , port + 1 ) ;
@@ -38,9 +38,9 @@ void XGINew_SetReg1( ULONG port , USHORT index , USHORT data )
 /* Output : */
 /* Description : AR( 3C0 ) */
 /* --------------------------------------------------------------------- */
-/*void XGINew_SetReg2( ULONG port , USHORT index , USHORT data )
+/*void XGINew_SetReg2( unsigned long port , unsigned short index , unsigned short data )
 {
-    inb( ( PUCHAR )port + 0x3da - 0x3c0 ) ;
+    inb( ( unsigned char * )port + 0x3da - 0x3c0 ) ;
     outb( (u8)index , XGINew_P3c0 ) ;
     outb( (u8)data , XGINew_P3c0 ) ;
     outb( (u8)0x20 , XGINew_P3c0 ) ;
@@ -53,7 +53,7 @@ void XGINew_SetReg1( ULONG port , USHORT index , USHORT data )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_SetReg3( ULONG port , USHORT data )
+void XGINew_SetReg3( unsigned long port , unsigned short data )
 {
     outb( (u8)data , port ) ;
 }
@@ -65,7 +65,7 @@ void XGINew_SetReg3( ULONG port , USHORT data )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_SetReg4( ULONG port , ULONG data )
+void XGINew_SetReg4( unsigned long port , unsigned long data )
 {
     outl( (u32)data , port ) ;
 }
@@ -77,9 +77,9 @@ void XGINew_SetReg4( ULONG port , ULONG data )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-UCHAR XGINew_GetReg1( ULONG port , USHORT index )
+unsigned char XGINew_GetReg1( unsigned long port , unsigned short index )
 {
-    UCHAR data ;
+    unsigned char data ;
 
     outb( (u8)index , port ) ;
     data = inb( port + 1 ) ;
@@ -94,9 +94,9 @@ UCHAR XGINew_GetReg1( ULONG port , USHORT index )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-UCHAR XGINew_GetReg2( ULONG port )
+unsigned char XGINew_GetReg2( unsigned long port )
 {
-    UCHAR data ;
+    unsigned char data ;
 
     data = inb( port ) ;
 
@@ -110,9 +110,9 @@ UCHAR XGINew_GetReg2( ULONG port )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-ULONG XGINew_GetReg3( ULONG port )
+unsigned long XGINew_GetReg3( unsigned long port )
 {
-    ULONG data ;
+    unsigned long data ;
 
     data = inl( port ) ;
 
@@ -127,9 +127,9 @@ ULONG XGINew_GetReg3( ULONG port )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_SetRegANDOR( ULONG Port , USHORT Index , USHORT DataAND , USHORT DataOR )
+void XGINew_SetRegANDOR( unsigned long Port , unsigned short Index , unsigned short DataAND , unsigned short DataOR )
 {
-    USHORT temp ;
+    unsigned short temp ;
 
     temp = XGINew_GetReg1( Port , Index ) ;		/* XGINew_Part1Port index 02 */
     temp = ( temp & ( DataAND ) ) | DataOR ;
@@ -143,9 +143,9 @@ void XGINew_SetRegANDOR( ULONG Port , USHORT Index , USHORT DataAND , USHORT Dat
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_SetRegAND(ULONG Port,USHORT Index,USHORT DataAND)
+void XGINew_SetRegAND(unsigned long Port,unsigned short Index,unsigned short DataAND)
 {
-    USHORT temp ;
+    unsigned short temp ;
 
     temp = XGINew_GetReg1( Port , Index ) ;	/* XGINew_Part1Port index 02 */
     temp &= DataAND ;
@@ -159,9 +159,9 @@ void XGINew_SetRegAND(ULONG Port,USHORT Index,USHORT DataAND)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGINew_SetRegOR( ULONG Port , USHORT Index , USHORT DataOR )
+void XGINew_SetRegOR( unsigned long Port , unsigned short Index , unsigned short DataOR )
 {
-    USHORT temp ;
+    unsigned short temp ;
 
     temp = XGINew_GetReg1( Port , Index ) ;	/* XGINew_Part1Port index 02 */
     temp |= DataOR ;
@@ -175,7 +175,7 @@ void XGINew_SetRegOR( ULONG Port , USHORT Index , USHORT DataOR )
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void Newdebugcode( UCHAR code )
+void Newdebugcode( unsigned char code )
 {
 //    outb ( (u8)code , 0x80 ) ;
     /* outb ( (u8)code , 0x300 ) ; */
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index 4abe3a9..81e0c64 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -1,14 +1,14 @@
 #ifndef _VBUTIL_
 #define _VBUTIL_
-extern   void     Newdebugcode( UCHAR );
-extern   void     XGINew_SetReg1(ULONG, USHORT, USHORT);
-extern   void     XGINew_SetReg3(ULONG, USHORT);
-extern   UCHAR    XGINew_GetReg1(ULONG, USHORT);
-extern   UCHAR    XGINew_GetReg2(ULONG);
-extern   void     XGINew_SetReg4(ULONG, ULONG);
-extern   ULONG    XGINew_GetReg3(ULONG);
-extern   void     XGINew_SetRegOR(ULONG Port,USHORT Index,USHORT DataOR);
-extern   void     XGINew_SetRegAND(ULONG Port,USHORT Index,USHORT DataAND);
-extern   void     XGINew_SetRegANDOR(ULONG Port,USHORT Index,USHORT DataAND,USHORT DataOR);
+extern   void     Newdebugcode( unsigned char );
+extern   void     XGINew_SetReg1(unsigned long, unsigned short, unsigned short);
+extern   void     XGINew_SetReg3(unsigned long, unsigned short);
+extern   unsigned char    XGINew_GetReg1(unsigned long, unsigned short);
+extern   unsigned char    XGINew_GetReg2(unsigned long);
+extern   void     XGINew_SetReg4(unsigned long, unsigned long);
+extern   unsigned long    XGINew_GetReg3(unsigned long);
+extern   void     XGINew_SetRegOR(unsigned long Port,unsigned short Index,unsigned short DataOR);
+extern   void     XGINew_SetRegAND(unsigned long Port,unsigned short Index,unsigned short DataAND);
+extern   void     XGINew_SetRegANDOR(unsigned long Port,unsigned short Index,unsigned short DataAND,unsigned short DataOR);
 #endif
 
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 3df7a39..d871da7 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -3,6 +3,7 @@
 #define _VGATYPES_
 
 #include <linux/ioctl.h>
+#include <linux/types.h>
 
 #ifndef FALSE
 #define FALSE   0
@@ -16,60 +17,6 @@
 #define NULL    0
 #endif
 
-#ifndef CHAR
-typedef char CHAR;
-#endif
-
-#ifndef SHORT
-typedef short SHORT;
-#endif
-
-#ifndef LONG
-typedef long  LONG;
-#endif
-
-#ifndef UCHAR
-typedef unsigned char UCHAR;
-#endif
-
-#ifndef USHORT
-typedef unsigned short USHORT;
-#endif
-
-#ifndef ULONG
-typedef unsigned long ULONG;
-#endif
-
-#ifndef PUCHAR
-typedef UCHAR *PUCHAR;
-#endif
-
-#ifndef PUSHORT
-typedef USHORT *PUSHORT;
-#endif
-
-#ifndef PLONGU
-typedef ULONG *PULONG;
-#endif
-
-#ifndef VOID
-typedef void VOID;
-#endif
-
-#ifndef PVOID
-typedef void *PVOID;
-#endif
-
-#ifndef BOOLEAN
-typedef UCHAR BOOLEAN;
-#endif
-/*
-#ifndef bool
-typedef UCHAR bool;
-#endif
-*/
-typedef unsigned long XGIIOADDRESS;
-
 #ifndef VBIOS_VER_MAX_LENGTH
 #define VBIOS_VER_MAX_LENGTH    4
 #endif
@@ -116,65 +63,64 @@ typedef enum _XGI_LCD_TYPE {
 
 typedef struct _XGI_DSReg
 {
-  UCHAR  jIdx;
-  UCHAR  jVal;
+  unsigned char  jIdx;
+  unsigned char  jVal;
 } XGI_DSReg, *PXGI_DSReg;
 
 typedef struct _XGI_HW_DEVICE_INFO  XGI_HW_DEVICE_INFO, *PXGI_HW_DEVICE_INFO;
 
-typedef BOOLEAN (*PXGI_QUERYSPACE)   (PXGI_HW_DEVICE_INFO, ULONG, ULONG, ULONG *);
 
 struct _XGI_HW_DEVICE_INFO
 {
-    ULONG  ulExternalChip;       /* NO VB or other video bridge*/
+    unsigned long  ulExternalChip;       /* NO VB or other video bridge*/
                                  /* if ujVBChipID = VB_CHIP_UNKNOWN, */
 
-    PUCHAR  pjVirtualRomBase;    /* ROM image */
+    unsigned char * pjVirtualRomBase;    /* ROM image */
 
-    BOOLEAN UseROM;		 /* Use the ROM image if provided */
+    bool UseROM;		 /* Use the ROM image if provided */
 
-    PVOID   pDevice;
+    void * pDevice;
 
-    PUCHAR  pjVideoMemoryAddress;/* base virtual memory address */
+    unsigned char * pjVideoMemoryAddress;/* base virtual memory address */
                                  /* of Linear VGA memory */
 
-    ULONG  ulVideoMemorySize;    /* size, in bytes, of the memory on the board */
+    unsigned long  ulVideoMemorySize;    /* size, in bytes, of the memory on the board */
 
-    PUCHAR pjIOAddress;          /* base I/O address of VGA ports (0x3B0) */
+    unsigned char * pjIOAddress;          /* base I/O address of VGA ports (0x3B0) */
 
-    PUCHAR pjCustomizedROMImage;
+    unsigned char * pjCustomizedROMImage;
 
-    PUCHAR pj2ndVideoMemoryAddress;
-    ULONG  ul2ndVideoMemorySize;
+    unsigned char * pj2ndVideoMemoryAddress;
+    unsigned long  ul2ndVideoMemorySize;
 
-    PUCHAR pj2ndIOAddress;
+    unsigned char * pj2ndIOAddress;
 /*
-    XGIIOADDRESS pjIOAddress;   //  base I/O address of VGA ports (0x3B0)
+    unsigned long  pjIOAddress;   //  base I/O address of VGA ports (0x3B0)
 */
-    UCHAR  jChipType;            /* Used to Identify Graphics Chip */
+    unsigned char  jChipType;            /* Used to Identify Graphics Chip */
                                  /* defined in the data structure type  */
                                  /* "XGI_CHIP_TYPE" */
 
-    UCHAR  jChipRevision;        /* Used to Identify Graphics Chip Revision */
+    unsigned char  jChipRevision;        /* Used to Identify Graphics Chip Revision */
 
-    UCHAR  ujVBChipID;           /* the ID of video bridge */
+    unsigned char  ujVBChipID;           /* the ID of video bridge */
                                  /* defined in the data structure type */
                                  /* "XGI_VB_CHIP_TYPE" */
 
-    BOOLEAN    bNewScratch;
+    bool    bNewScratch;
 
-    ULONG  ulCRT2LCDType;        /* defined in the data structure type */
+    unsigned long  ulCRT2LCDType;        /* defined in the data structure type */
 
-    ULONG usExternalChip;       /* NO VB or other video bridge (other than  */
+    unsigned long usExternalChip;       /* NO VB or other video bridge (other than  */
                                  /*  video bridge) */
 
-    BOOLEAN bIntegratedMMEnabled;/* supporting integration MM enable */
+    bool bIntegratedMMEnabled;/* supporting integration MM enable */
 
-    BOOLEAN bSkipDramSizing;     /* True: Skip video memory sizing. */
+    bool bSkipDramSizing;     /* True: Skip video memory sizing. */
 
-    BOOLEAN bSkipSense;
+    bool bSkipSense;
 
-    BOOLEAN bIsPowerSaving;     /* True: XGIInit() is invoked by power management,
+    bool bIsPowerSaving;     /* True: XGIInit() is invoked by power management,
                                    otherwise by 2nd adapter's initialzation */
 
     PXGI_DSReg  pSR;             /* restore SR registers in initial function. */
@@ -187,11 +133,11 @@ struct _XGI_HW_DEVICE_INFO
                                  /* Note : restore cR registers if  */
                                  /* bSkipDramSizing = TRUE */
 
-    PXGI_QUERYSPACE  pQueryVGAConfigSpace;
+    bool (*pQueryVGAConfigSpace)(PXGI_HW_DEVICE_INFO, unsigned long, unsigned long, unsigned long *);
 
-    PXGI_QUERYSPACE  pQueryNorthBridgeSpace;
+    bool (*pQueryNorthBridgeSpace)(PXGI_HW_DEVICE_INFO, unsigned long, unsigned long, unsigned long *);
 
-    UCHAR  szVBIOSVer[VBIOS_VER_MAX_LENGTH];
+    unsigned char  szVBIOSVer[VBIOS_VER_MAX_LENGTH];
 
 };
 
-- 
1.7.1


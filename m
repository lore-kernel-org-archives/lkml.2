Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab0KSWUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:20:16 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39247 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab0KSV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:55 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, aaro.koskinen@iki.fi
Subject: [PATCH 5/9] sisfb: use CONFIG_FB_SIS_301/315 instead of SIS301/315H
Date: Fri, 19 Nov 2010 23:58:47 +0200
Message-Id: <1290203931-25188-6-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
References: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to alias CONFIG #defines.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/init.c       |   74 +++++-----
 drivers/video/sis/init.h       |    8 +-
 drivers/video/sis/init301.c    |  282 ++++++++++++++++++++--------------------
 drivers/video/sis/init301.h    |   14 +-
 drivers/video/sis/initextlfb.c |    6 +-
 drivers/video/sis/osdef.h      |   10 +--
 6 files changed, 193 insertions(+), 201 deletions(-)

diff --git a/drivers/video/sis/init.c b/drivers/video/sis/init.c
index 5634dfb..8351151 100644
--- a/drivers/video/sis/init.c
+++ b/drivers/video/sis/init.c
@@ -62,11 +62,11 @@
 
 #include "init.h"
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 #include "300vtbl.h"
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 #include "310vtbl.h"
 #endif
 
@@ -78,7 +78,7 @@
 /*         POINTER INITIALIZATION            */
 /*********************************************/
 
-#if defined(SIS300) || defined(SIS315H)
+#if defined(CONFIG_FB_SIS_300) || defined(CONFIG_FB_SIS_315)
 static void
 InitCommonPointer(struct SiS_Private *SiS_Pr)
 {
@@ -160,7 +160,7 @@ InitCommonPointer(struct SiS_Private *SiS_Pr)
 }
 #endif
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 static void
 InitTo300Pointer(struct SiS_Private *SiS_Pr)
 {
@@ -237,7 +237,7 @@ InitTo300Pointer(struct SiS_Private *SiS_Pr)
 }
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static void
 InitTo310Pointer(struct SiS_Private *SiS_Pr)
 {
@@ -321,13 +321,13 @@ bool
 SiSInitPtr(struct SiS_Private *SiS_Pr)
 {
    if(SiS_Pr->ChipType < SIS_315H) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
       InitTo300Pointer(SiS_Pr);
 #else
       return false;
 #endif
    } else {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
       InitTo310Pointer(SiS_Pr);
 #else
       return false;
@@ -1087,7 +1087,7 @@ static void
 SiSInitPCIetc(struct SiS_Private *SiS_Pr)
 {
    switch(SiS_Pr->ChipType) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
    case SIS_300:
    case SIS_540:
    case SIS_630:
@@ -1106,7 +1106,7 @@ SiSInitPCIetc(struct SiS_Private *SiS_Pr)
       SiS_SetRegOR(SiS_Pr->SiS_P3c4,0x1E,0x5A);
       break;
 #endif
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    case SIS_315H:
    case SIS_315:
    case SIS_315PRO:
@@ -1170,7 +1170,7 @@ SiSSetLVDSetc(struct SiS_Private *SiS_Pr)
    if((temp == 1) || (temp == 2)) return;
 
    switch(SiS_Pr->ChipType) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
    case SIS_540:
    case SIS_630:
    case SIS_730:
@@ -1184,7 +1184,7 @@ SiSSetLVDSetc(struct SiS_Private *SiS_Pr)
 	}
 	break;
 #endif
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    case SIS_550:
    case SIS_650:
    case SIS_740:
@@ -1499,7 +1499,7 @@ SiS_CheckMemorySize(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 /*           HELPER: Get DRAM type           */
 /*********************************************/
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static unsigned char
 SiS_Get310DRAMType(struct SiS_Private *SiS_Pr)
 {
@@ -2122,7 +2122,7 @@ SiS_SetCRT1CRTC(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
       SiS_SetReg(SiS_Pr->SiS_P3d4,0x14,0x4F);
    }
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    if(SiS_Pr->ChipType == XGI_20) {
       SiS_SetReg(SiS_Pr->SiS_P3d4,0x04,crt1data[4] - 1);
       if(!(temp = crt1data[5] & 0x1f)) {
@@ -2205,7 +2205,7 @@ SiS_SetCRT1VCLK(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
    SiS_SetReg(SiS_Pr->SiS_P3c4,0x2c,clkb);
 
    if(SiS_Pr->ChipType >= SIS_315H) {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
       SiS_SetReg(SiS_Pr->SiS_P3c4,0x2D,0x01);
       if(SiS_Pr->ChipType == XGI_20) {
          unsigned short mf = SiS_GetModeFlag(SiS_Pr, ModeNo, ModeIdIndex);
@@ -2226,7 +2226,7 @@ SiS_SetCRT1VCLK(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 /*                  FIFO                     */
 /*********************************************/
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 void
 SiS_GetFIFOThresholdIndex300(struct SiS_Private *SiS_Pr, unsigned short *idx1,
 		unsigned short *idx2)
@@ -2535,9 +2535,9 @@ SiS_SetCRT1FIFO_630(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 
    sisfb_write_nbridge_pci_dword(SiS_Pr, 0xA0, templ);
 }
-#endif /* SIS300 */
+#endif /* CONFIG_FB_SIS_300 */
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static void
 SiS_SetCRT1FIFO_310(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex)
 {
@@ -2589,7 +2589,7 @@ SiS_SetVCLKState(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
    }
 
    if(SiS_Pr->ChipType < SIS_315H) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
       if(VCLK > 150) data |= 0x80;
       SiS_SetRegANDOR(SiS_Pr->SiS_P3c4,0x07,0x7B,data);
 
@@ -2598,7 +2598,7 @@ SiS_SetVCLKState(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
       SiS_SetRegANDOR(SiS_Pr->SiS_P3c4,0x32,0xF7,data);
 #endif
    } else if(SiS_Pr->ChipType < XGI_20) {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
       if(VCLK >= 166) data |= 0x0c;
       SiS_SetRegANDOR(SiS_Pr->SiS_P3c4,0x32,0xf3,data);
 
@@ -2607,7 +2607,7 @@ SiS_SetVCLKState(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
       }
 #endif
    } else {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
       if(VCLK >= 200) data |= 0x0c;
       if(SiS_Pr->ChipType == XGI_20) data &= ~0x04;
       SiS_SetRegANDOR(SiS_Pr->SiS_P3c4,0x32,0xf3,data);
@@ -2652,7 +2652,7 @@ SiS_SetCRT1ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 		unsigned short ModeIdIndex, unsigned short RRTI)
 {
    unsigned short data, infoflag = 0, modeflag, resindex;
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    unsigned char  *ROMAddr  = SiS_Pr->VirtualRomBase;
    unsigned short data2, data3;
 #endif
@@ -2713,7 +2713,7 @@ SiS_SetCRT1ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
       SiS_SetRegANDOR(SiS_Pr->SiS_P3c4,0x0F,0xB7,data);
    }
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    if(SiS_Pr->ChipType >= SIS_315H) {
       SiS_SetRegAND(SiS_Pr->SiS_P3c4,0x31,0xfb);
    }
@@ -2803,7 +2803,7 @@ SiS_SetCRT1ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 
    SiS_SetVCLKState(SiS_Pr, ModeNo, RRTI, ModeIdIndex);
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    if(((SiS_Pr->ChipType >= SIS_315H) && (SiS_Pr->ChipType < SIS_661)) ||
        (SiS_Pr->ChipType == XGI_40)) {
       if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x31) & 0x40) {
@@ -2822,7 +2822,7 @@ SiS_SetCRT1ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 #endif
 }
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static void
 SiS_SetupDualChip(struct SiS_Private *SiS_Pr)
 {
@@ -3000,7 +3000,7 @@ SiS_SetCRT1Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sho
    }
 
    switch(SiS_Pr->ChipType) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
    case SIS_300:
       SiS_SetCRT1FIFO_300(SiS_Pr, ModeNo, RefreshRateTableIndex);
       break;
@@ -3011,7 +3011,7 @@ SiS_SetCRT1Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sho
       break;
 #endif
    default:
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
       if(SiS_Pr->ChipType == XGI_20) {
          unsigned char sr2b = 0, sr2c = 0;
          switch(ModeNo) {
@@ -3034,7 +3034,7 @@ SiS_SetCRT1Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sho
 
    SiS_SetCRT1ModeRegs(SiS_Pr, ModeNo, ModeIdIndex, RefreshRateTableIndex);
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    if(SiS_Pr->ChipType == XGI_40) {
       SiS_SetupDualChip(SiS_Pr);
    }
@@ -3074,7 +3074,7 @@ SiS_InitVB(struct SiS_Private *SiS_Pr)
 static void
 SiS_ResetVB(struct SiS_Private *SiS_Pr)
 {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    unsigned char  *ROMAddr = SiS_Pr->VirtualRomBase;
    unsigned short temp;
 
@@ -3109,7 +3109,7 @@ SiS_StrangeStuff(struct SiS_Private *SiS_Pr)
     * which locks CRT2 in some way to CRT1 timing. Disable
     * this here.
     */
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    if((IS_SIS651) || (IS_SISM650) ||
       SiS_Pr->ChipType == SIS_340 ||
       SiS_Pr->ChipType == XGI_40) {
@@ -3130,7 +3130,7 @@ SiS_StrangeStuff(struct SiS_Private *SiS_Pr)
 static void
 SiS_Handle760(struct SiS_Private *SiS_Pr)
 {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    unsigned int somebase;
    unsigned char temp1, temp2, temp3;
 
@@ -3272,7 +3272,7 @@ SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
    SiS_DisplayOn(SiS_Pr);
    SiS_SetRegByte(SiS_Pr->SiS_P3c6,0xFF);
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    if(SiS_Pr->ChipType >= SIS_315H) {
       if(SiS_Pr->SiS_IF_DEF_LVDS == 1) {
 	 if(!(SiS_IsDualEdge(SiS_Pr))) {
@@ -3284,7 +3284,7 @@ SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 
    if(SiS_Pr->SiS_VBType & VB_SIS30xBLV) {
       if(SiS_Pr->ChipType >= SIS_315H) {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	 if(!SiS_Pr->SiS_ROMNew) {
 	    if(SiS_IsVAMode(SiS_Pr)) {
 	       SiS_SetRegOR(SiS_Pr->SiS_P3d4,0x35,0x01);
@@ -3407,7 +3407,7 @@ SiS_CalcLCDACRT1Timing(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
    SiS_Pr->CVBlankStart = SiS_Pr->SiS_VGAVDE;
 
    if(SiS_Pr->ChipType < SIS_315H) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
       tempbx = SiS_Pr->SiS_VGAHT;
       if(SiS_Pr->SiS_LCDInfo & DontExpandLCD) {
          tempbx = SiS_Pr->PanelHT;
@@ -3416,7 +3416,7 @@ SiS_CalcLCDACRT1Timing(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
       remaining = tempbx % 8;
 #endif
    } else {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
       /* OK for LCDA, LVDS */
       tempbx = SiS_Pr->PanelHT - SiS_Pr->PanelXRes;
       tempax = SiS_Pr->SiS_VGAHDE;  /* not /2 ! */
@@ -3430,7 +3430,7 @@ SiS_CalcLCDACRT1Timing(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
    SiS_Pr->CHTotal = SiS_Pr->CHBlankEnd = tempbx;
 
    if(SiS_Pr->ChipType < SIS_315H) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
       if(SiS_Pr->SiS_VGAHDE == SiS_Pr->PanelXRes) {
 	 SiS_Pr->CHSyncStart = SiS_Pr->SiS_VGAHDE + ((SiS_Pr->PanelHRS + 1) & ~1);
 	 SiS_Pr->CHSyncEnd = SiS_Pr->CHSyncStart + SiS_Pr->PanelHRE;
@@ -3462,7 +3462,7 @@ SiS_CalcLCDACRT1Timing(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
       }
 #endif
    } else {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
       tempax = VGAHDE;
       if(SiS_Pr->SiS_LCDInfo & DontExpandLCD) {
 	 tempbx = SiS_Pr->PanelXRes;
@@ -3481,7 +3481,7 @@ SiS_CalcLCDACRT1Timing(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
    if(SiS_Pr->SiS_LCDInfo & DontExpandLCD) {
       tempax = SiS_Pr->PanelYRes;
    } else if(SiS_Pr->ChipType < SIS_315H) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
       /* Stupid hack for 640x400/320x200 */
       if(SiS_Pr->SiS_LCDResInfo == Panel_1024x768) {
 	 if((tempax + tempbx) == 438) tempbx += 16;
diff --git a/drivers/video/sis/init.h b/drivers/video/sis/init.h
index 1d54759..79aec28 100644
--- a/drivers/video/sis/init.h
+++ b/drivers/video/sis/init.h
@@ -273,7 +273,7 @@ static const struct SiS_ModeResInfo_S SiS_ModeResInfo[] =
 	{ 1280, 854, 8,16}    /* 0x22 */
 };
 
-#if defined(SIS300) || defined(SIS315H)
+#if defined(CONFIG_FB_SIS_300) || defined(CONFIG_FB_SIS_315)
 static const struct SiS_StandTable_S SiS_StandTable[]=
 {
 /* 0x00: MD_0_200 */
@@ -1549,7 +1549,7 @@ unsigned short	SiS_GetColorDepth(struct SiS_Private *SiS_Pr, unsigned short Mode
 				unsigned short ModeIdIndex);
 unsigned short	SiS_GetOffset(struct SiS_Private *SiS_Pr,unsigned short ModeNo,
 				unsigned short ModeIdIndex, unsigned short RRTI);
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 void		SiS_GetFIFOThresholdIndex300(struct SiS_Private *SiS_Pr, unsigned short *idx1,
 				unsigned short *idx2);
 unsigned short	SiS_GetFIFOThresholdB300(unsigned short idx1, unsigned short idx2);
@@ -1585,12 +1585,12 @@ extern unsigned short	SiS_GetVCLK2Ptr(struct SiS_Private *SiS_Pr, unsigned short
 extern bool		SiS_IsVAMode(struct SiS_Private *);
 extern bool		SiS_IsDualEdge(struct SiS_Private *);
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 extern unsigned int	sisfb_read_nbridge_pci_dword(struct SiS_Private *SiS_Pr, int reg);
 extern void		sisfb_write_nbridge_pci_dword(struct SiS_Private *SiS_Pr, int reg,
 				unsigned int val);
 #endif
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 extern void		sisfb_write_nbridge_pci_byte(struct SiS_Private *SiS_Pr, int reg,
 				unsigned char val);
 extern unsigned int	sisfb_read_mio_pci_word(struct SiS_Private *SiS_Pr, int reg);
diff --git a/drivers/video/sis/init301.c b/drivers/video/sis/init301.c
index 78055f6..9fa66fd 100644
--- a/drivers/video/sis/init301.c
+++ b/drivers/video/sis/init301.c
@@ -75,11 +75,11 @@
 
 #include "init301.h"
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 #include "oem300.h"
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 #include "oem310.h"
 #endif
 
@@ -134,7 +134,7 @@ SiS_SetRegSR11ANDOR(struct SiS_Private *SiS_Pr, unsigned short DataAND, unsigned
 /*    HELPER: Get Pointer to LCD structure   */
 /*********************************************/
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static unsigned char *
 GetLCDStructPtr661(struct SiS_Private *SiS_Pr)
 {
@@ -400,7 +400,7 @@ SiS_SaveCRT2Info(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 /*    HELPER: GET SOME DATA FROM BIOS ROM    */
 /*********************************************/
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 static bool
 SiS_CR36BIOSWord23b(struct SiS_Private *SiS_Pr)
 {
@@ -445,7 +445,7 @@ SiS_DDC2Delay(struct SiS_Private *SiS_Pr, unsigned int delaytime)
       SiS_GetReg(SiS_Pr->SiS_P3c4, 0x05);
 }
 
-#if defined(SIS300) || defined(SIS315H)
+#if defined(CONFIG_FB_SIS_300) || defined(CONFIG_FB_SIS_315)
 static void
 SiS_GenericDelay(struct SiS_Private *SiS_Pr, unsigned short delay)
 {
@@ -453,7 +453,7 @@ SiS_GenericDelay(struct SiS_Private *SiS_Pr, unsigned short delay)
 }
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static void
 SiS_LongDelay(struct SiS_Private *SiS_Pr, unsigned short delay)
 {
@@ -463,7 +463,7 @@ SiS_LongDelay(struct SiS_Private *SiS_Pr, unsigned short delay)
 }
 #endif
 
-#if defined(SIS300) || defined(SIS315H)
+#if defined(CONFIG_FB_SIS_300) || defined(CONFIG_FB_SIS_315)
 static void
 SiS_ShortDelay(struct SiS_Private *SiS_Pr, unsigned short delay)
 {
@@ -476,14 +476,14 @@ SiS_ShortDelay(struct SiS_Private *SiS_Pr, unsigned short delay)
 static void
 SiS_PanelDelay(struct SiS_Private *SiS_Pr, unsigned short DelayTime)
 {
-#if defined(SIS300) || defined(SIS315H)
+#if defined(CONFIG_FB_SIS_300) || defined(CONFIG_FB_SIS_315)
    unsigned char  *ROMAddr = SiS_Pr->VirtualRomBase;
    unsigned short PanelID, DelayIndex, Delay=0;
 #endif
 
    if(SiS_Pr->ChipType < SIS_315H) {
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 
       PanelID = SiS_GetReg(SiS_Pr->SiS_P3d4,0x36);
       if(SiS_Pr->SiS_VBType & VB_SISVB) {
@@ -509,11 +509,11 @@ SiS_PanelDelay(struct SiS_Private *SiS_Pr, unsigned short DelayTime)
       }
       SiS_ShortDelay(SiS_Pr, Delay);
 
-#endif  /* SIS300 */
+#endif  /* CONFIG_FB_SIS_300 */
 
    } else {
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 
       if((SiS_Pr->ChipType >= SIS_661)    ||
 	 (SiS_Pr->ChipType <= SIS_315PRO) ||
@@ -575,12 +575,12 @@ SiS_PanelDelay(struct SiS_Private *SiS_Pr, unsigned short DelayTime)
 
       }
 
-#endif /* SIS315H */
+#endif /* CONFIG_FB_SIS_315 */
 
    }
 }
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static void
 SiS_PanelDelayLoop(struct SiS_Private *SiS_Pr, unsigned short DelayTime, unsigned short DelayLoop)
 {
@@ -609,7 +609,7 @@ SiS_WaitRetrace1(struct SiS_Private *SiS_Pr)
    while((!(SiS_GetRegByte(SiS_Pr->SiS_P3da) & 0x08)) && --watchdog);
 }
 
-#if defined(SIS300) || defined(SIS315H)
+#if defined(CONFIG_FB_SIS_300) || defined(CONFIG_FB_SIS_315)
 static void
 SiS_WaitRetrace2(struct SiS_Private *SiS_Pr, unsigned short reg)
 {
@@ -626,7 +626,7 @@ static void
 SiS_WaitVBRetrace(struct SiS_Private *SiS_Pr)
 {
    if(SiS_Pr->ChipType < SIS_315H) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
       if(SiS_Pr->SiS_VBType & VB_SIS30xBLV) {
 	 if(!(SiS_GetReg(SiS_Pr->SiS_Part1Port,0x00) & 0x20)) return;
       }
@@ -637,7 +637,7 @@ SiS_WaitVBRetrace(struct SiS_Private *SiS_Pr)
       }
 #endif
    } else {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
       if(!(SiS_GetReg(SiS_Pr->SiS_Part1Port,0x00) & 0x40)) {
 	 SiS_WaitRetrace1(SiS_Pr);
       } else {
@@ -682,7 +682,7 @@ SiS_VBLongWait(struct SiS_Private *SiS_Pr)
 /*               HELPER: MISC                */
 /*********************************************/
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 static bool
 SiS_Is301B(struct SiS_Private *SiS_Pr)
 {
@@ -704,7 +704,7 @@ SiS_CRT2IsLCD(struct SiS_Private *SiS_Pr)
 bool
 SiS_IsDualEdge(struct SiS_Private *SiS_Pr)
 {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    if(SiS_Pr->ChipType >= SIS_315H) {
       if((SiS_Pr->ChipType != SIS_650) || (SiS_GetReg(SiS_Pr->SiS_P3d4,0x5f) & 0xf0)) {
 	 if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x38) & EnableDualEdge) return true;
@@ -717,7 +717,7 @@ SiS_IsDualEdge(struct SiS_Private *SiS_Pr)
 bool
 SiS_IsVAMode(struct SiS_Private *SiS_Pr)
 {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    unsigned short flag;
 
    if(SiS_Pr->ChipType >= SIS_315H) {
@@ -728,7 +728,7 @@ SiS_IsVAMode(struct SiS_Private *SiS_Pr)
    return false;
 }
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static bool
 SiS_IsVAorLCD(struct SiS_Private *SiS_Pr)
 {
@@ -741,7 +741,7 @@ SiS_IsVAorLCD(struct SiS_Private *SiS_Pr)
 static bool
 SiS_IsDualLink(struct SiS_Private *SiS_Pr)
 {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    if(SiS_Pr->ChipType >= SIS_315H) {
       if((SiS_CRT2IsLCD(SiS_Pr)) ||
          (SiS_IsVAMode(SiS_Pr))) {
@@ -752,7 +752,7 @@ SiS_IsDualLink(struct SiS_Private *SiS_Pr)
    return false;
 }
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static bool
 SiS_TVEnabled(struct SiS_Private *SiS_Pr)
 {
@@ -764,7 +764,7 @@ SiS_TVEnabled(struct SiS_Private *SiS_Pr)
 }
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static bool
 SiS_LCDAEnabled(struct SiS_Private *SiS_Pr)
 {
@@ -773,7 +773,7 @@ SiS_LCDAEnabled(struct SiS_Private *SiS_Pr)
 }
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static bool
 SiS_WeHaveBacklightCtrl(struct SiS_Private *SiS_Pr)
 {
@@ -784,7 +784,7 @@ SiS_WeHaveBacklightCtrl(struct SiS_Private *SiS_Pr)
 }
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static bool
 SiS_IsNotM650orLater(struct SiS_Private *SiS_Pr)
 {
@@ -800,7 +800,7 @@ SiS_IsNotM650orLater(struct SiS_Private *SiS_Pr)
 }
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static bool
 SiS_IsYPbPr(struct SiS_Private *SiS_Pr)
 {
@@ -812,7 +812,7 @@ SiS_IsYPbPr(struct SiS_Private *SiS_Pr)
 }
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static bool
 SiS_IsChScart(struct SiS_Private *SiS_Pr)
 {
@@ -824,7 +824,7 @@ SiS_IsChScart(struct SiS_Private *SiS_Pr)
 }
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static bool
 SiS_IsTVOrYPbPrOrScart(struct SiS_Private *SiS_Pr)
 {
@@ -844,7 +844,7 @@ SiS_IsTVOrYPbPrOrScart(struct SiS_Private *SiS_Pr)
 }
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static bool
 SiS_IsLCDOrLCDA(struct SiS_Private *SiS_Pr)
 {
@@ -910,7 +910,7 @@ SiS_BridgeInSlavemode(struct SiS_Private *SiS_Pr)
 /*********************************************/
 
 /* Setup general purpose IO for Chrontel communication */
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 void
 SiS_SetChrontelGPIO(struct SiS_Private *SiS_Pr, unsigned short myvbinfo)
 {
@@ -961,7 +961,7 @@ SiS_GetVBInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 	tempax &= (DriverMode | LoadDACFlag | SetNotSimuMode | SetPALTV);
 	tempbx |= tempax;
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	if(SiS_Pr->ChipType >= SIS_315H) {
 	   if(SiS_Pr->SiS_VBType & VB_SISLCDA) {
 	      if(ModeNo == 0x03) {
@@ -1011,7 +1011,7 @@ SiS_GetVBInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 	   }
 	}
 
-#endif  /* SIS315H */
+#endif  /* CONFIG_FB_SIS_315 */
 
         if(!(SiS_Pr->SiS_VBType & VB_SISVGA2)) {
 	   tempbx &= ~(SetCRT2ToRAMDAC);
@@ -1146,7 +1146,7 @@ SiS_GetVBInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 
    SiS_Pr->SiS_VBInfo = tempbx;
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
    if(SiS_Pr->ChipType == SIS_630) {
       SiS_SetChrontelGPIO(SiS_Pr, SiS_Pr->SiS_VBInfo);
    }
@@ -1421,7 +1421,7 @@ SiS_GetBIOSLCDResInfo(struct SiS_Private *SiS_Pr)
 static void
 SiS_GetLCDInfoBIOS(struct SiS_Private *SiS_Pr)
 {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    unsigned char  *ROMAddr;
    unsigned short temp;
 
@@ -1471,13 +1471,13 @@ SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sh
 {
   unsigned short temp,modeflag,resinfo=0,modexres=0,modeyres=0;
   bool panelcanscale = false;
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
   unsigned char *ROMAddr = SiS_Pr->VirtualRomBase;
   static const unsigned char SiS300SeriesLCDRes[] =
           { 0,  1,  2,  3,  7,  4,  5,  8,
 	    0,  0, 10,  0,  0,  0,  0, 15 };
 #endif
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   unsigned char   *myptr = NULL;
 #endif
 
@@ -1516,7 +1516,7 @@ SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sh
      SiS_Pr->SiS_LCDTypeInfo = (temp & 0x0F) - 1;
   }
   temp &= 0x0f;
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
   if(SiS_Pr->ChipType < SIS_315H) {
      /* Very old BIOSes only know 7 sizes (NetVista 2179, 1.01g) */
      if(SiS_Pr->SiS_VBType & VB_SIS301) {
@@ -1528,7 +1528,7 @@ SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sh
 #endif
 
   /* Translate to our internal types */
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   if(SiS_Pr->ChipType == SIS_550) {
      if     (temp == Panel310_1152x768)  temp = Panel_320x240_2; /* Verified working */
      else if(temp == Panel310_320x240_2) temp = Panel_320x240_2;
@@ -1551,7 +1551,7 @@ SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sh
 
   SiS_Pr->SiS_LCDResInfo = temp;
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
   if(SiS_Pr->SiS_IF_DEF_LVDS == 1) {
      if(SiS_Pr->SiS_CustomT == CUT_BARCO1366) {
 	SiS_Pr->SiS_LCDResInfo = Panel_Barco1366;
@@ -1593,7 +1593,7 @@ SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sh
   else if(SiS_Pr->UsePanelScaler == 1) SiS_Pr->SiS_LCDInfo |= DontExpandLCD;
 
   /* Dual link, Pass 1:1 BIOS default, etc. */
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   if(SiS_Pr->ChipType >= SIS_661) {
      if(SiS_Pr->SiS_LCDInfo & DontExpandLCD) {
 	if(temp & 0x08) SiS_Pr->SiS_LCDInfo |= LCDPass11;
@@ -2030,7 +2030,7 @@ SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sh
      }
   }
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
   if(SiS_Pr->SiS_IF_DEF_LVDS == 1) {
      if(SiS_Pr->SiS_CustomT == CUT_PANEL848 || SiS_Pr->SiS_CustomT == CUT_PANEL856) {
 	SiS_Pr->SiS_LCDInfo = 0x80 | 0x40 | 0x20;   /* neg h/v sync, RGB24(D0 = 0) */
@@ -2306,7 +2306,7 @@ SiS_GetVCLK2Ptr(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned shor
 	      VCLKIndex = SiS_Pr->PanelVCLKIdx315;
 	   }
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 	   /* Special Timing: Barco iQ Pro R series */
 	   if(SiS_Pr->SiS_CustomT == CUT_BARCO1366) VCLKIndex = 0x44;
 
@@ -2369,10 +2369,10 @@ SiS_SetCRT2ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 {
   unsigned short i, j, modeflag, tempah=0;
   short tempcl;
-#if defined(SIS300) || defined(SIS315H)
+#if defined(CONFIG_FB_SIS_300) || defined(CONFIG_FB_SIS_315)
   unsigned short tempbl;
 #endif
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   unsigned char  *ROMAddr = SiS_Pr->VirtualRomBase;
   unsigned short tempah2, tempbl2;
 #endif
@@ -2395,7 +2395,7 @@ SiS_SetCRT2ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 
      if(SiS_Pr->ChipType < SIS_315H) {
 
-#ifdef SIS300    /* ---- 300 series ---- */
+#ifdef CONFIG_FB_SIS_300    /* ---- 300 series ---- */
 
 	/* For 301BDH: (with LCD via LVDS) */
 	if(SiS_Pr->SiS_VBType & VB_NoLCD) {
@@ -2418,11 +2418,11 @@ SiS_SetCRT2ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 
 	if(SiS_Pr->SiS_VBInfo & SetInSlaveMode)  tempah ^= 0xA0;
 
-#endif  /* SIS300 */
+#endif  /* CONFIG_FB_SIS_300 */
 
      } else {
 
-#ifdef SIS315H    /* ------- 315/330 series ------ */
+#ifdef CONFIG_FB_SIS_315    /* ------- 315/330 series ------ */
 
 	if(ModeNo > 0x13) {
 	   tempcl -= ModeVGA;
@@ -2435,7 +2435,7 @@ SiS_SetCRT2ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 
 	if(SiS_Pr->SiS_VBInfo & SetInSlaveMode) tempah ^= 0x50;
 
-#endif  /* SIS315H */
+#endif  /* CONFIG_FB_SIS_315 */
 
      }
 
@@ -2444,7 +2444,7 @@ SiS_SetCRT2ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
      if(SiS_Pr->ChipType < SIS_315H) {
 	SiS_SetReg(SiS_Pr->SiS_Part1Port,0x00,tempah);
      } else {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	if(SiS_Pr->SiS_IF_DEF_LVDS == 1) {
 	   SiS_SetRegANDOR(SiS_Pr->SiS_Part1Port,0x00,0xa0,tempah);
 	} else if(SiS_Pr->SiS_VBType & VB_SISVB) {
@@ -2525,7 +2525,7 @@ SiS_SetCRT2ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 
 	if(SiS_Pr->ChipType >= SIS_315H) {
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	   /* LVDS can only be slave in 8bpp modes */
 	   tempah = 0x80;
 	   if((modeflag & CRT2Mode) && (SiS_Pr->SiS_ModeType > ModeVGA)) {
@@ -2545,7 +2545,7 @@ SiS_SetCRT2ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 
 	} else {
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 	   tempah = 0;
 	   if( (!(SiS_Pr->SiS_VBInfo & SetInSlaveMode)) && (SiS_Pr->SiS_ModeType > ModeVGA) ) {
 	      tempah |= 0x02;
@@ -2567,7 +2567,7 @@ SiS_SetCRT2ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 
      if(SiS_Pr->ChipType >= SIS_315H) {
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	/* unsigned char bridgerev = SiS_GetReg(SiS_Pr->SiS_Part4Port,0x01); */
 
 	/* The following is nearly unpreditable and varies from machine
@@ -2659,11 +2659,11 @@ SiS_SetCRT2ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 	   SiS_SetRegANDOR(SiS_Pr->SiS_Part4Port,0x23,tempbl,tempah);
 	}
 
-#endif /* SIS315H */
+#endif /* CONFIG_FB_SIS_315 */
 
      } else if(SiS_Pr->SiS_VBType & VB_SIS30xBLV) {
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 	SiS_SetRegAND(SiS_Pr->SiS_Part4Port,0x21,0x3f);
 
 	if((SiS_Pr->SiS_VBInfo & DisableCRT2Display) ||
@@ -2686,7 +2686,7 @@ SiS_SetCRT2ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 
   } else {  /* LVDS */
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
      if(SiS_Pr->ChipType >= SIS_315H) {
 
 	if(SiS_Pr->SiS_IF_DEF_CH70xx != 0) {
@@ -2872,7 +2872,7 @@ SiS_GetCRT2Ptr(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 	   }
 	}
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	if(SiS_Pr->SiS_CustomT == CUT_COMPAQ1280) {
 	   if(SiS_Pr->SiS_LCDResInfo == Panel_1280x1024) {
 	      if(!(SiS_Pr->SiS_LCDInfo & DontExpandLCD)) {
@@ -2977,7 +2977,7 @@ SiS_GetCRT2Ptr(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 	case Panel_1280x1024: tempbx = 24; break;
 	case Panel_1400x1050: tempbx = 26; break;
 	case Panel_1600x1200: tempbx = 28; break;
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 	case Panel_Barco1366: tempbx = 80; break;
 #endif
 	}
@@ -2994,7 +2994,7 @@ SiS_GetCRT2Ptr(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 
 	if(SiS_Pr->SiS_LCDInfo & LCDPass11) tempbx = 30;
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 	if(SiS_Pr->SiS_CustomT == CUT_BARCO1024) {
 	   tempbx = 82;
 	   if(SiS_Pr->SiS_LCDInfo & DontExpandLCD) tempbx++;
@@ -3130,7 +3130,7 @@ SiS_GetCRT2DataLVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 
    if((SiS_Pr->SiS_VBType & VB_SISVB) && (SiS_Pr->SiS_VBInfo & SetCRT2ToLCDA)) {
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
       SiS_CalcPanelLinkTiming(SiS_Pr, ModeNo, ModeIdIndex, RefreshRateTableIndex);
       SiS_CalcLCDACRT1Timing(SiS_Pr, ModeNo, ModeIdIndex);
 #endif
@@ -3155,7 +3155,7 @@ SiS_GetCRT2DataLVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 	 case 16: LVDSData = SiS_Pr->SiS_LVDS800x600Data_1;    break;
 	 case 18: LVDSData = SiS_Pr->SiS_LVDS1024x600Data_1;   break;
 	 case 20: LVDSData = SiS_Pr->SiS_LVDS1024x768Data_1;   break;
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 	 case 80: LVDSData = SiS_Pr->SiS_LVDSBARCO1366Data_1;  break;
 	 case 81: LVDSData = SiS_Pr->SiS_LVDSBARCO1366Data_2;  break;
 	 case 82: LVDSData = SiS_Pr->SiS_LVDSBARCO1024Data_1;  break;
@@ -3189,7 +3189,7 @@ SiS_GetCRT2DataLVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
 	     (SiS_Pr->SiS_SetFlag & SetDOSMode) ) {
 	    SiS_Pr->SiS_HDE = SiS_Pr->PanelXRes;
             SiS_Pr->SiS_VDE = SiS_Pr->PanelYRes;
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 	    if(SiS_Pr->SiS_CustomT == CUT_BARCO1366) {
 	       if(ResIndex < 0x08) {
 		  SiS_Pr->SiS_HDE = 1280;
@@ -3211,7 +3211,7 @@ SiS_GetCRT2Data301(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
   unsigned short resinfo, CRT2Index, ResIndex;
   const struct SiS_LCDData *LCDPtr = NULL;
   const struct SiS_TVData  *TVPtr  = NULL;
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   short resinfo661;
 #endif
 
@@ -3224,7 +3224,7 @@ SiS_GetCRT2Data301(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
   } else {
      modeflag = SiS_Pr->SiS_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
      resinfo = SiS_Pr->SiS_EModeIDTable[ModeIdIndex].Ext_RESINFO;
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
      resinfo661 = SiS_Pr->SiS_EModeIDTable[ModeIdIndex].ROMMODEIDX661;
      if( (SiS_Pr->SiS_VBInfo & SetCRT2ToLCD)   &&
 	 (SiS_Pr->SiS_SetFlag & LCDVESATiming) &&
@@ -3401,7 +3401,7 @@ SiS_GetCRT2Data301(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
 
 	} else if( (!(SiS_Pr->SiS_LCDInfo & DontExpandLCD)) && (romptr) && (ROMAddr) ) {
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	   SiS_Pr->SiS_RVBHCMAX  = ROMAddr[romptr];
 	   SiS_Pr->SiS_RVBHCFACT = ROMAddr[romptr+1];
 	   SiS_Pr->SiS_VGAHT     = ROMAddr[romptr+2] | ((ROMAddr[romptr+3] & 0x0f) << 8);
@@ -3461,7 +3461,7 @@ SiS_GetCRT2Data301(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
 	      case Panel_1680x1050     :
 	      case Panel_1680x1050 + 32: LCDPtr = SiS_Pr->SiS_LCD1680x1050Data;     break;
 	      case 100		       : LCDPtr = SiS_Pr->SiS_NoScaleData;	    break;
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	      case 200                 : LCDPtr = SiS310_ExtCompaq1280x1024Data;    break;
 	      case 201                 : LCDPtr = SiS_Pr->SiS_St2LCD1280x1024Data;  break;
 #endif
@@ -3559,7 +3559,7 @@ SiS_GetLVDSDesPtr(struct SiS_Private *SiS_Pr)
 {
    const struct SiS_LVDSDes *PanelDesPtr = NULL;
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
    if(SiS_Pr->SiS_VBInfo & SetCRT2ToLCD) {
 
       if(SiS_Pr->ChipType < SIS_315H) {
@@ -3631,7 +3631,7 @@ SiS_GetLVDSDesData(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
 
   if((SiS_Pr->SiS_VBType & VB_SIS30xBLV) && (SiS_Pr->SiS_VBInfo & SetCRT2ToLCDA)) {
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
      if(SiS_Pr->SiS_LCDInfo & DontExpandLCD) {
 	/* non-pass 1:1 only, see above */
 	if(SiS_Pr->SiS_VGAHDE != SiS_Pr->PanelXRes) {
@@ -3706,7 +3706,7 @@ SiS_GetLVDSDesData(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
      } else {
 
         if(SiS_Pr->ChipType < SIS_315H) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 	   switch(SiS_Pr->SiS_LCDResInfo) {
 	   case Panel_800x600:
 	      if(SiS_Pr->SiS_VGAVDE == SiS_Pr->PanelYRes) {
@@ -3751,7 +3751,7 @@ SiS_GetLVDSDesData(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
 	   }
 #endif
         } else {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	   switch(SiS_Pr->SiS_LCDResInfo) {
 	   case Panel_1024x768:
 	   case Panel_1280x1024:
@@ -3779,7 +3779,7 @@ SiS_GetLVDSDesData(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
 	         if(SiS_Pr->ChipType < SIS_315H) {
 	            if(!(modeflag & HalfDCLK)) SiS_Pr->SiS_LCDHDES = 320;
 	         } else {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 		    if(SiS_Pr->SiS_LCDResInfo == Panel_1024x768)  SiS_Pr->SiS_LCDHDES = 480;
 		    if(SiS_Pr->SiS_LCDResInfo == Panel_1400x1050) SiS_Pr->SiS_LCDHDES = 804;
 		    if(SiS_Pr->SiS_LCDResInfo == Panel_1600x1200) SiS_Pr->SiS_LCDHDES = 704;
@@ -3801,7 +3801,7 @@ SiS_GetLVDSDesData(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
 /*           DISABLE VIDEO BRIDGE            */
 /*********************************************/
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static int
 SiS_HandlePWD(struct SiS_Private *SiS_Pr)
 {
@@ -3839,7 +3839,7 @@ SiS_HandlePWD(struct SiS_Private *SiS_Pr)
 void
 SiS_DisableBridge(struct SiS_Private *SiS_Pr)
 {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   unsigned short tempah, pushax=0, modenum;
 #endif
   unsigned short temp=0;
@@ -3850,7 +3850,7 @@ SiS_DisableBridge(struct SiS_Private *SiS_Pr)
 
 	if(SiS_Pr->ChipType < SIS_315H) {
 
-#ifdef SIS300	   /* 300 series */
+#ifdef CONFIG_FB_SIS_300	   /* 300 series */
 
 	   if(!(SiS_CR36BIOSWord23b(SiS_Pr))) {
 	      if(SiS_Pr->SiS_VBType & VB_SISLVDS) {
@@ -3883,11 +3883,11 @@ SiS_DisableBridge(struct SiS_Private *SiS_Pr)
 	      }
 	   }
 
-#endif  /* SIS300 */
+#endif  /* CONFIG_FB_SIS_300 */
 
         } else {
 
-#ifdef SIS315H	   /* 315 series */
+#ifdef CONFIG_FB_SIS_315	   /* 315 series */
 
 	   int didpwd = 0;
 	   bool custom1 = (SiS_Pr->SiS_CustomT == CUT_COMPAQ1280) ||
@@ -4011,14 +4011,14 @@ SiS_DisableBridge(struct SiS_Private *SiS_Pr)
 
 	   }
 
-#endif /* SIS315H */
+#endif /* CONFIG_FB_SIS_315 */
 
 	}
 
      } else {     /* ============ For 301 ================ */
 
         if(SiS_Pr->ChipType < SIS_315H) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 	   if(!(SiS_CR36BIOSWord23b(SiS_Pr))) {
 	      SiS_SetRegSR11ANDOR(SiS_Pr,0xF7,0x08);
 	      SiS_PanelDelay(SiS_Pr, 3);
@@ -4041,7 +4041,7 @@ SiS_DisableBridge(struct SiS_Private *SiS_Pr)
 	    SiS_SetRegOR(SiS_Pr->SiS_P3c4,0x1E,0x20);
 	    SiS_SetReg(SiS_Pr->SiS_Part1Port,0x00,temp);
 	} else {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 	    SiS_SetRegAND(SiS_Pr->SiS_P3c4,0x1E,0xDF);            /* disable CRT2 */
 	    if( (!(SiS_CRT2IsLCD(SiS_Pr))) ||
 		(!(SiS_CR36BIOSWord23d(SiS_Pr))) ) {
@@ -4057,7 +4057,7 @@ SiS_DisableBridge(struct SiS_Private *SiS_Pr)
 
     if(SiS_Pr->ChipType < SIS_315H) {
 
-#ifdef SIS300	/* 300 series */
+#ifdef CONFIG_FB_SIS_300	/* 300 series */
 
 	if(SiS_Pr->SiS_IF_DEF_CH70xx == 1) {
 	   SiS_SetCH700x(SiS_Pr,0x0E,0x09);
@@ -4101,11 +4101,11 @@ SiS_DisableBridge(struct SiS_Private *SiS_Pr)
 	   SiS_SetRegSR11ANDOR(SiS_Pr,0xFB,0x04);
 	}
 
-#endif  /* SIS300 */
+#endif  /* CONFIG_FB_SIS_300 */
 
     } else {
 
-#ifdef SIS315H	/* 315 series */
+#ifdef CONFIG_FB_SIS_315	/* 315 series */
 
 	if(!(SiS_IsNotM650orLater(SiS_Pr))) {
 	   /*if(SiS_Pr->ChipType < SIS_340) { */ /* XGI needs this */
@@ -4218,7 +4218,7 @@ SiS_DisableBridge(struct SiS_Private *SiS_Pr)
 	   }
         }
 
-#endif  /* SIS315H */
+#endif  /* CONFIG_FB_SIS_315 */
 
     }  /* 315 series */
 
@@ -4239,7 +4239,7 @@ void
 SiS_EnableBridge(struct SiS_Private *SiS_Pr)
 {
   unsigned short temp=0, tempah;
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   unsigned short temp1, pushax=0;
   bool delaylong = false;
 #endif
@@ -4250,7 +4250,7 @@ SiS_EnableBridge(struct SiS_Private *SiS_Pr)
 
       if(SiS_Pr->ChipType < SIS_315H) {
 
-#ifdef SIS300     /* 300 series */
+#ifdef CONFIG_FB_SIS_300     /* 300 series */
 
 	 if(SiS_CRT2IsLCD(SiS_Pr)) {
 	    if(SiS_Pr->SiS_VBType & VB_SISLVDS) {
@@ -4313,11 +4313,11 @@ SiS_EnableBridge(struct SiS_Private *SiS_Pr)
 	 }
 
 
-#endif /* SIS300 */
+#endif /* CONFIG_FB_SIS_300 */
 
       } else {
 
-#ifdef SIS315H    /* 315 series */
+#ifdef CONFIG_FB_SIS_315    /* 315 series */
 
 #ifdef SET_EMI
 	 unsigned char   r30=0, r31=0, r32=0, r33=0, cr36=0;
@@ -4616,7 +4616,7 @@ SiS_EnableBridge(struct SiS_Private *SiS_Pr)
 	    SiS_SetRegAND(SiS_Pr->SiS_Part1Port,0x00,0x7f);
 	 }
 
-#endif /* SIS315H */
+#endif /* CONFIG_FB_SIS_315 */
 
       }
 
@@ -4667,7 +4667,7 @@ SiS_EnableBridge(struct SiS_Private *SiS_Pr)
 
     if(SiS_Pr->ChipType < SIS_315H) {
 
-#ifdef SIS300    /* 300 series */
+#ifdef CONFIG_FB_SIS_300    /* 300 series */
 
        if(SiS_CRT2IsLCD(SiS_Pr)) {
 	  if(SiS_Pr->ChipType == SIS_730) {
@@ -4711,11 +4711,11 @@ SiS_EnableBridge(struct SiS_Private *SiS_Pr)
 	  }
        }
 
-#endif  /* SIS300 */
+#endif  /* CONFIG_FB_SIS_300 */
 
     } else {
 
-#ifdef SIS315H    /* 315 series */
+#ifdef CONFIG_FB_SIS_315    /* 315 series */
 
        if(!(SiS_IsNotM650orLater(SiS_Pr))) {
 	  /*if(SiS_Pr->ChipType < SIS_340) {*/  /* XGI needs this */
@@ -4809,7 +4809,7 @@ SiS_EnableBridge(struct SiS_Private *SiS_Pr)
 	  }
        }
 
-#endif  /* SIS315H */
+#endif  /* CONFIG_FB_SIS_315 */
 
     } /* 310 series */
 
@@ -4899,7 +4899,7 @@ SiS_SetCRT2Sync(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned shor
 
       if(SiS_Pr->ChipType < SIS_315H) {
 
-#ifdef SIS300  /* ---- 300 series --- */
+#ifdef CONFIG_FB_SIS_300  /* ---- 300 series --- */
 
 	 if(SiS_Pr->SiS_VBType & VB_SIS30xBLV) {			/* 630 - 301B(-DH) */
 
@@ -4928,11 +4928,11 @@ SiS_SetCRT2Sync(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned shor
 
 	 }
 
-#endif /* SIS300 */
+#endif /* CONFIG_FB_SIS_300 */
 
       } else {
 
-#ifdef SIS315H  /* ------- 315 series ------ */
+#ifdef CONFIG_FB_SIS_315  /* ------- 315 series ------ */
 
 	 if(SiS_Pr->SiS_VBType & VB_SISLVDS) {	  		/* 315 - LVDS */
 
@@ -5004,13 +5004,13 @@ SiS_SetCRT2Sync(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned shor
 	    }
 
          }
-#endif  /* SIS315H */
+#endif  /* CONFIG_FB_SIS_315 */
       }
    }
 }
 
 /* Set CRT2 FIFO on 300/540/630/730 */
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 static void
 SiS_SetCRT2FIFO_300(struct SiS_Private *SiS_Pr,unsigned short ModeNo)
 {
@@ -5185,7 +5185,7 @@ SiS_SetCRT2FIFO_300(struct SiS_Private *SiS_Pr,unsigned short ModeNo)
 #endif
 
 /* Set CRT2 FIFO on 315/330 series */
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static void
 SiS_SetCRT2FIFO_310(struct SiS_Private *SiS_Pr)
 {
@@ -5357,17 +5357,17 @@ SiS_SetGroup1_LVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
   unsigned short push2, tempax, tempbx, tempcx, temp;
   unsigned int   tempeax = 0, tempebx, tempecx, tempvcfact = 0;
   bool islvds = false, issis  = false, chkdclkfirst = false;
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
   unsigned short crt2crtc = 0;
 #endif
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   unsigned short pushcx;
 #endif
 
   if(ModeNo <= 0x13) {
      modeflag = SiS_Pr->SiS_SModeIDTable[ModeIdIndex].St_ModeFlag;
      resinfo = SiS_Pr->SiS_SModeIDTable[ModeIdIndex].St_ResInfo;
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
      crt2crtc = SiS_Pr->SiS_SModeIDTable[ModeIdIndex].St_CRT2CRTC;
 #endif
   } else if(SiS_Pr->UseCustomMode) {
@@ -5375,7 +5375,7 @@ SiS_SetGroup1_LVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
   } else {
      modeflag = SiS_Pr->SiS_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
      resinfo = SiS_Pr->SiS_EModeIDTable[ModeIdIndex].Ext_RESINFO;
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
      crt2crtc = SiS_Pr->SiS_RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
 #endif
   }
@@ -5396,7 +5396,7 @@ SiS_SetGroup1_LVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
      }
   }
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   if((SiS_Pr->ChipType >= SIS_315H) && (SiS_Pr->SiS_VBInfo & SetCRT2ToLCDA)) {
      if(IS_SIS330) {
         SiS_SetRegOR(SiS_Pr->SiS_Part1Port,0x2D,0x10);
@@ -5646,7 +5646,7 @@ SiS_SetGroup1_LVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
 
   if(SiS_Pr->ChipType < SIS_315H) {
 
-#ifdef SIS300      /* 300 series */
+#ifdef CONFIG_FB_SIS_300      /* 300 series */
      tempeax = SiS_Pr->SiS_VGAVDE << 6;
      temp = (tempeax % (unsigned int)SiS_Pr->SiS_VDE);
      tempeax = tempeax / (unsigned int)SiS_Pr->SiS_VDE;
@@ -5657,11 +5657,11 @@ SiS_SetGroup1_LVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
      temp = (unsigned short)(tempeax & 0x00FF);
      SiS_SetReg(SiS_Pr->SiS_Part1Port,0x1E,temp);      	/* BPLVCFACT */
      tempvcfact = temp;
-#endif /* SIS300 */
+#endif /* CONFIG_FB_SIS_300 */
 
   } else {
 
-#ifdef SIS315H  /* 315 series */
+#ifdef CONFIG_FB_SIS_315  /* 315 series */
      tempeax = SiS_Pr->SiS_VGAVDE << 18;
      tempebx = SiS_Pr->SiS_VDE;
      temp = (tempeax % tempebx);
@@ -5747,7 +5747,7 @@ SiS_SetGroup1_LVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
   temp = (unsigned short)(tempecx & 0x00FF);
   SiS_SetReg(SiS_Pr->SiS_Part1Port,0x23,temp);
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   if(SiS_Pr->ChipType >= SIS_315H) {
      if(SiS_Pr->SiS_VBInfo & SetCRT2ToLCDA) {
         if((islvds) || (SiS_Pr->SiS_VBInfo & VB_SISLVDS)) {
@@ -5765,7 +5765,7 @@ SiS_SetGroup1_LVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
   }
 #endif
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
   if(SiS_Pr->SiS_IF_DEF_TRUMPION) {
      unsigned char *ROMAddr = SiS_Pr->VirtualRomBase;
      unsigned char *trumpdata;
@@ -5801,7 +5801,7 @@ SiS_SetGroup1_LVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
   }
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   if(SiS_Pr->SiS_IF_DEF_FSTN || SiS_Pr->SiS_IF_DEF_DSTN) {
      SiS_SetReg(SiS_Pr->SiS_Part1Port,0x25,0x00);
      SiS_SetReg(SiS_Pr->SiS_Part1Port,0x26,0x00);
@@ -5901,7 +5901,7 @@ SiS_SetGroup1_LVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
         SiS_SetReg(SiS_Pr->SiS_Part1Port,0x45,0x0a);
      }
   }
-#endif  /* SIS315H */
+#endif  /* CONFIG_FB_SIS_315 */
 }
 
 /* Set Part 1 */
@@ -5909,12 +5909,12 @@ static void
 SiS_SetGroup1(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex)
 {
-#if defined(SIS300) || defined(SIS315H)
+#if defined(CONFIG_FB_SIS_300) || defined(CONFIG_FB_SIS_315)
   unsigned char   *ROMAddr = SiS_Pr->VirtualRomBase;
 #endif
   unsigned short  temp=0, tempax=0, tempbx=0, tempcx=0, bridgeadd=0;
   unsigned short  pushbx=0, CRT1Index=0, modeflag, resinfo=0;
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   unsigned short  tempbl=0;
 #endif
 
@@ -5940,11 +5940,11 @@ SiS_SetGroup1(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
          (SiS_Pr->SiS_VBInfo & SetInSlaveMode)) ) {
 
      if(SiS_Pr->ChipType < SIS_315H ) {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 	SiS_SetCRT2FIFO_300(SiS_Pr, ModeNo);
 #endif
      } else {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	SiS_SetCRT2FIFO_310(SiS_Pr);
 #endif
      }
@@ -5953,7 +5953,7 @@ SiS_SetGroup1(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 
      if(SiS_Pr->ChipType < SIS_315H ) {
 
-#ifdef SIS300   /* ------------- 300 series --------------*/
+#ifdef CONFIG_FB_SIS_300   /* ------------- 300 series --------------*/
 
 	temp = (SiS_Pr->SiS_VGAHT - 1) & 0x0FF;   		  /* BTVGA2HT 0x08,0x09 */
 	SiS_SetReg(SiS_Pr->SiS_Part1Port,0x08,temp);              /* CRT2 Horizontal Total */
@@ -5972,11 +5972,11 @@ SiS_SetGroup1(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 
 	bridgeadd = 12;
 
-#endif /* SIS300 */
+#endif /* CONFIG_FB_SIS_300 */
 
      } else {
 
-#ifdef SIS315H  /* ------------------- 315/330 series --------------- */
+#ifdef CONFIG_FB_SIS_315  /* ------------------- 315/330 series --------------- */
 
 	tempcx = SiS_Pr->SiS_VGAHT;				  /* BTVGA2HT 0x08,0x09 */
 	if(modeflag & HalfDCLK) {
@@ -6027,7 +6027,7 @@ SiS_SetGroup1(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 	   }
         }
 
-#endif  /* SIS315H */
+#endif  /* CONFIG_FB_SIS_315 */
 
      }  /* 315/330 series */
 
@@ -6158,7 +6158,7 @@ SiS_SetGroup1(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 
      if(SiS_Pr->ChipType < SIS_315H) {
 
-#ifdef SIS300  /* ---------- 300 series -------------- */
+#ifdef CONFIG_FB_SIS_300  /* ---------- 300 series -------------- */
 
 	if(SiS_Pr->SiS_VBType & VB_SISVB) {
 	   temp = 0x20;
@@ -6212,11 +6212,11 @@ SiS_SetGroup1(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 
 	SiS_SetRegANDOR(SiS_Pr->SiS_Part1Port,0x13,~0x3C,temp);   /* Panel Link Delay Compensation; (Software Command Reset; Power Saving) */
 
-#endif  /* SIS300 */
+#endif  /* CONFIG_FB_SIS_300 */
 
      } else {
 
-#ifdef SIS315H   /* --------------- 315/330 series ---------------*/
+#ifdef CONFIG_FB_SIS_315   /* --------------- 315/330 series ---------------*/
 
 	if(SiS_Pr->ChipType < SIS_661) {
 
@@ -6251,7 +6251,7 @@ SiS_SetGroup1(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 	if(modeflag & HalfDCLK)       tempax |= 0x40;
 	SiS_SetRegANDOR(SiS_Pr->SiS_Part1Port,0x2C,0x3f,tempax);
 
-#endif  /* SIS315H */
+#endif  /* CONFIG_FB_SIS_315 */
 
      }
 
@@ -6283,7 +6283,7 @@ SiS_SetGroup1(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 /*         SET PART 2 REGISTER GROUP         */
 /*********************************************/
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static unsigned char *
 SiS_GetGroup2CLVXPtr(struct SiS_Private *SiS_Pr, int tabletype)
 {
@@ -6380,7 +6380,7 @@ SiS_GetCRT2Part2Ptr(struct SiS_Private *SiS_Pr,unsigned short ModeNo,unsigned sh
 }
 #endif
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 static void
 SiS_Group2LCDSpecial(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short crt2crtc)
 {
@@ -6592,7 +6592,7 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
   unsigned int   longtemp, PhaseIndex;
   bool           newtvphase;
   const unsigned char *TimingPoint;
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   unsigned short resindex, CRT2Index;
   const struct SiS_Part2PortTbl *CRT2Part2Ptr = NULL;
 
@@ -6971,7 +6971,7 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
   SiS_SetRegAND(SiS_Pr->SiS_Part2Port,0x17,0xFB);
   SiS_SetRegAND(SiS_Pr->SiS_Part2Port,0x18,0xDF);
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   if(SiS_GetCRT2Part2Ptr(SiS_Pr, ModeNo, ModeIdIndex, RefreshRateTableIndex,
                           			&CRT2Index, &resindex)) {
       switch(CRT2Index) {
@@ -7093,7 +7093,7 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 
     SiS_SetReg(SiS_Pr->SiS_Part2Port,0x01,temp);
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
     SiS_Group2LCDSpecial(SiS_Pr, ModeNo, crt2crtc);
 #endif
 
@@ -7176,10 +7176,10 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 
     SiS_SetGroup2_Tail(SiS_Pr, ModeNo);
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
     SiS_Set300Part2Regs(SiS_Pr, ModeIdIndex, RefreshRateTableIndex, ModeNo);
 #endif
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
   } /* CRT2-LCD from table */
 #endif
 }
@@ -7248,7 +7248,7 @@ SiS_SetGroup3(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 /*         SET PART 4 REGISTER GROUP         */
 /*********************************************/
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 #if 0
 static void
 SiS_ShiftXPos(struct SiS_Private *SiS_Pr, int shift)
@@ -7877,7 +7877,7 @@ SiS_SetCHTVReg(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 
    if(SiS_Pr->SiS_IF_DEF_CH70xx == 1) {
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 
       /* Chrontel 7005 - I assume that it does not come with a 315 series chip */
 
@@ -7990,7 +7990,7 @@ SiS_SetCHTVReg(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 
       /* Chrontel 7019 - assumed that it does not come with a 300 series chip */
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 
       unsigned short temp;
 
@@ -8041,7 +8041,7 @@ SiS_SetCHTVReg(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 
 }
 
-#ifdef SIS315H  /* ----------- 315 series only ---------- */
+#ifdef CONFIG_FB_SIS_315  /* ----------- 315 series only ---------- */
 
 void
 SiS_Chrontel701xBLOn(struct SiS_Private *SiS_Pr)
@@ -8523,7 +8523,7 @@ SiS_ChrontelDoSomething1(struct SiS_Private *SiS_Pr)
 bool
 SiS_SetCRT2Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 {
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
    unsigned char  *ROMAddr  = SiS_Pr->VirtualRomBase;
 #endif
    unsigned short ModeIdIndex, RefreshRateTableIndex;
@@ -8578,12 +8578,12 @@ SiS_SetCRT2Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
       if(SiS_Pr->SiS_SetFlag & LowModeTests) {
 
 	 SiS_SetGroup2(SiS_Pr, ModeNo, ModeIdIndex, RefreshRateTableIndex);
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	 SiS_SetGroup2_C_ELV(SiS_Pr, ModeNo, ModeIdIndex, RefreshRateTableIndex);
 #endif
 	 SiS_SetGroup3(SiS_Pr, ModeNo, ModeIdIndex);
 	 SiS_SetGroup4(SiS_Pr, ModeNo, ModeIdIndex, RefreshRateTableIndex);
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 	 SiS_SetGroup4_C_ELV(SiS_Pr, ModeNo, ModeIdIndex);
 #endif
 	 SiS_SetGroup5(SiS_Pr, ModeNo, ModeIdIndex);
@@ -8614,7 +8614,7 @@ SiS_SetCRT2Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 	 if(SiS_Pr->SiS_IF_DEF_CH70xx != 0) {
 	    if(SiS_Pr->SiS_VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
 	       if(SiS_Pr->SiS_IF_DEF_CH70xx == 2) {
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 		  SiS_SetCH701xForLCD(SiS_Pr);
 #endif
 	       }
@@ -8627,7 +8627,7 @@ SiS_SetCRT2Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 
    }
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
    if(SiS_Pr->ChipType < SIS_315H) {
       if(SiS_Pr->SiS_SetFlag & LowModeTests) {
 	 if(SiS_Pr->SiS_UseOEM) {
@@ -8650,7 +8650,7 @@ SiS_SetCRT2Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
    }
 #endif
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
    if(SiS_Pr->ChipType >= SIS_315H) {
       if(SiS_Pr->SiS_SetFlag & LowModeTests) {
 	 if(SiS_Pr->ChipType < SIS_661) {
@@ -8729,7 +8729,7 @@ SiS_SetupDDCN(struct SiS_Private *SiS_Pr)
   }
 }
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 static unsigned char *
 SiS_SetTrumpBlockLoop(struct SiS_Private *SiS_Pr, unsigned char *dataptr)
 {
@@ -9456,7 +9456,7 @@ SiS_CheckACK(struct SiS_Private *SiS_Pr)
 
 /* =============== SiS 315/330 O.E.M. ================= */
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 
 static unsigned short
 GetRAMDACromptr(struct SiS_Private *SiS_Pr)
@@ -10644,7 +10644,7 @@ SiS_FinalizeLCD(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned shor
 
 /*  =================  SiS 300 O.E.M. ================== */
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 
 static void
 SetOEMLCDData2(struct SiS_Private *SiS_Pr, unsigned short ModeNo,unsigned short ModeIdIndex,
diff --git a/drivers/video/sis/init301.h b/drivers/video/sis/init301.h
index 31e24ae..2677152 100644
--- a/drivers/video/sis/init301.h
+++ b/drivers/video/sis/init301.h
@@ -230,7 +230,7 @@ static const unsigned char SiS_Part2CLVX_6[] = {   /* 1080i */
     0xFF,0xFF,
 };
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 /* 661 et al LCD data structure (2.03.00) */
 static const unsigned char SiS_LCDStruct661[] = {
     /* 1024x768 */
@@ -272,7 +272,7 @@ static const unsigned char SiS_LCDStruct661[] = {
 };
 #endif
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 static unsigned char SiS300_TrumpionData[14][80] = {
   { 0x02,0x0A,0x0A,0x01,0x04,0x01,0x00,0x03,0x0D,0x00,0x0D,0x10,0x7F,0x00,0x80,0x02,
     0x20,0x03,0x0B,0x00,0x90,0x01,0xC1,0x01,0x60,0x0C,0x30,0x10,0x00,0x00,0x04,0x23,
@@ -375,7 +375,7 @@ void		SiS_SetCH701x(struct SiS_Private *SiS_Pr, unsigned short reg, unsigned cha
 unsigned short	SiS_GetCH701x(struct SiS_Private *SiS_Pr, unsigned short tempax);
 void		SiS_SetCH70xxANDOR(struct SiS_Private *SiS_Pr, unsigned short reg,
 			unsigned char orval,unsigned short andval);
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static void	SiS_Chrontel701xOn(struct SiS_Private *SiS_Pr);
 static void	SiS_Chrontel701xOff(struct SiS_Private *SiS_Pr);
 static void	SiS_ChrontelInitTVVSync(struct SiS_Private *SiS_Pr);
@@ -384,7 +384,7 @@ void		SiS_Chrontel701xBLOn(struct SiS_Private *SiS_Pr);
 void		SiS_Chrontel701xBLOff(struct SiS_Private *SiS_Pr);
 #endif /* 315 */
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 static  bool	SiS_SetTrumpionBlock(struct SiS_Private *SiS_Pr, unsigned char *dataptr);
 void		SiS_SetChrontelGPIO(struct SiS_Private *SiS_Pr, unsigned short myvbinfo);
 #endif
@@ -415,13 +415,13 @@ static unsigned short	SiS_PrepareDDC(struct SiS_Private *SiS_Pr);
 static void		SiS_SendACK(struct SiS_Private *SiS_Pr, unsigned short yesno);
 static unsigned short	SiS_DoProbeDDC(struct SiS_Private *SiS_Pr);
 
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 static void		SiS_OEM300Setting(struct SiS_Private *SiS_Pr,
 				unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefTabindex);
 static void		SetOEMLCDData2(struct SiS_Private *SiS_Pr,
 				unsigned short ModeNo, unsigned short ModeIdIndex,unsigned short RefTableIndex);
 #endif
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
 static void		SiS_OEM310Setting(struct SiS_Private *SiS_Pr,
 				unsigned short ModeNo,unsigned short ModeIdIndex, unsigned short RRTI);
 static void		SiS_OEM661Setting(struct SiS_Private *SiS_Pr,
@@ -456,7 +456,7 @@ extern void		SiS_CalcLCDACRT1Timing(struct SiS_Private *SiS_Pr, unsigned short M
 extern void		SiS_CalcCRRegisters(struct SiS_Private *SiS_Pr, int depth);
 extern unsigned short	SiS_GetRefCRTVCLK(struct SiS_Private *SiS_Pr, unsigned short Index, int UseWide);
 extern unsigned short	SiS_GetRefCRT1CRTC(struct SiS_Private *SiS_Pr, unsigned short Index, int UseWide);
-#ifdef SIS300
+#ifdef CONFIG_FB_SIS_300
 extern void		SiS_GetFIFOThresholdIndex300(struct SiS_Private *SiS_Pr, unsigned short *tempbx,
 				unsigned short *tempcl);
 extern unsigned short	SiS_GetFIFOThresholdB300(unsigned short tempbx, unsigned short tempcl);
diff --git a/drivers/video/sis/initextlfb.c b/drivers/video/sis/initextlfb.c
index 99c04a4..1975308 100644
--- a/drivers/video/sis/initextlfb.c
+++ b/drivers/video/sis/initextlfb.c
@@ -59,7 +59,7 @@ sisfb_mode_rate_to_dclock(struct SiS_Private *SiS_Pr, unsigned char modeno,
 
     if(rateindex > 0) rateindex--;
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
     switch(ModeNo) {
     case 0x5a: ModeNo = 0x50; break;
     case 0x5b: ModeNo = 0x56;
@@ -103,7 +103,7 @@ sisfb_mode_rate_to_ddata(struct SiS_Private *SiS_Pr, unsigned char modeno,
 
     if(rateindex > 0) rateindex--;
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
     switch(ModeNo) {
        case 0x5a: ModeNo = 0x50; break;
        case 0x5b: ModeNo = 0x56;
@@ -187,7 +187,7 @@ sisfb_gettotalfrommode(struct SiS_Private *SiS_Pr, unsigned char modeno, int *ht
 
     if(rateindex > 0) rateindex--;
 
-#ifdef SIS315H
+#ifdef CONFIG_FB_SIS_315
     switch(ModeNo) {
        case 0x5a: ModeNo = 0x50; break;
        case 0x5b: ModeNo = 0x56;
diff --git a/drivers/video/sis/osdef.h b/drivers/video/sis/osdef.h
index bc185a9..dae407c 100644
--- a/drivers/video/sis/osdef.h
+++ b/drivers/video/sis/osdef.h
@@ -82,15 +82,7 @@
 /*  LINUX KERNEL                                                      */
 /**********************************************************************/
 
-#ifdef CONFIG_FB_SIS_300
-#define SIS300
-#endif
-
-#ifdef CONFIG_FB_SIS_315
-#define SIS315H
-#endif
-
-#if !defined(SIS300) && !defined(SIS315H)
+#if !defined(CONFIG_FB_SIS_300) && !defined(CONFIG_FB_SIS_315)
 #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set
 #warning sisfb will not work!
 #endif
-- 
1.5.6.5


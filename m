Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0KSWWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:22:17 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:53626 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab0KSV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:54 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, aaro.koskinen@iki.fi
Subject: [PATCH 4/9] sisfb: delete redudant #define SIS_LINUX_KERNEL
Date: Fri, 19 Nov 2010 23:58:46 +0200
Message-Id: <1290203931-25188-5-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
References: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not needed anymore with SIS_XORG_XF86 gone.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/init.c     |   50 ------------------------------------------
 drivers/video/sis/init.h     |   14 -----------
 drivers/video/sis/init301.c  |   23 -------------------
 drivers/video/sis/init301.h  |   14 -----------
 drivers/video/sis/osdef.h    |    7 ------
 drivers/video/sis/vgatypes.h |    2 -
 drivers/video/sis/vstruct.h  |    6 -----
 7 files changed, 0 insertions(+), 116 deletions(-)

diff --git a/drivers/video/sis/init.c b/drivers/video/sis/init.c
index 53e30ea..5634dfb 100644
--- a/drivers/video/sis/init.c
+++ b/drivers/video/sis/init.c
@@ -1150,9 +1150,7 @@ SiSInitPCIetc(struct SiS_Private *SiS_Pr)
 /*             HELPER: SetLVDSetc            */
 /*********************************************/
 
-#ifdef SIS_LINUX_KERNEL
 static
-#endif
 void
 SiSSetLVDSetc(struct SiS_Private *SiS_Pr)
 {
@@ -1418,9 +1416,7 @@ SiS_ResetSegmentRegisters(struct SiS_Private *SiS_Pr)
 /*             HELPER: GetVBType             */
 /*********************************************/
 
-#ifdef SIS_LINUX_KERNEL
 static
-#endif
 void
 SiS_GetVBType(struct SiS_Private *SiS_Pr)
 {
@@ -1485,7 +1481,6 @@ SiS_GetVBType(struct SiS_Private *SiS_Pr)
 /*           HELPER: Check RAM size          */
 /*********************************************/
 
-#ifdef SIS_LINUX_KERNEL
 static bool
 SiS_CheckMemorySize(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 		unsigned short ModeIdIndex)
@@ -1499,7 +1494,6 @@ SiS_CheckMemorySize(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
    if(AdapterMemSize < memorysize) return false;
    return true;
 }
-#endif
 
 /*********************************************/
 /*           HELPER: Get DRAM type           */
@@ -1572,7 +1566,6 @@ SiS_GetMCLK(struct SiS_Private *SiS_Pr)
 /*           HELPER: ClearBuffer             */
 /*********************************************/
 
-#ifdef SIS_LINUX_KERNEL
 static void
 SiS_ClearBuffer(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 {
@@ -1597,7 +1590,6 @@ SiS_ClearBuffer(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
       SiS_SetMemory(memaddr, 0x8000, 0);
    }
 }
-#endif
 
 /*********************************************/
 /*           HELPER: SearchModeID            */
@@ -2504,11 +2496,7 @@ SiS_SetCRT1FIFO_630(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
    SiS_SetRegANDOR(SiS_Pr->SiS_P3c4,0x09,0x80,data);
 
   /* Write foreground and background queue */
-#ifdef SIS_LINUX_KERNEL
    templ = sisfb_read_nbridge_pci_dword(SiS_Pr, 0x50);
-#else
-   templ = pciReadLong(0x00000000, 0x50);
-#endif
 
    if(SiS_Pr->ChipType == SIS_730) {
 
@@ -2528,13 +2516,8 @@ SiS_SetCRT1FIFO_630(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 
    }
 
-#ifdef SIS_LINUX_KERNEL
    sisfb_write_nbridge_pci_dword(SiS_Pr, 0x50, templ);
    templ = sisfb_read_nbridge_pci_dword(SiS_Pr, 0xA0);
-#else
-   pciWriteLong(0x00000000, 0x50, templ);
-   templ = pciReadLong(0x00000000, 0xA0);
-#endif
 
    /* GUI grant timer (PCI config 0xA3) */
    if(SiS_Pr->ChipType == SIS_730) {
@@ -2550,11 +2533,7 @@ SiS_SetCRT1FIFO_630(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 
    }
 
-#ifdef SIS_LINUX_KERNEL
    sisfb_write_nbridge_pci_dword(SiS_Pr, 0xA0, templ);
-#else
-   pciWriteLong(0x00000000, 0xA0, templ);
-#endif
 }
 #endif /* SIS300 */
 
@@ -3063,11 +3042,9 @@ SiS_SetCRT1Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sho
 
    SiS_LoadDAC(SiS_Pr, ModeNo, ModeIdIndex);
 
-#ifdef SIS_LINUX_KERNEL
    if(SiS_Pr->SiS_flag_clearbuffer) {
       SiS_ClearBuffer(SiS_Pr, ModeNo);
    }
-#endif
 
    if(!(SiS_Pr->SiS_VBInfo & (SetSimuScanMode | SwitchCRT2 | SetCRT2ToLCDA))) {
       SiS_WaitRetrace1(SiS_Pr);
@@ -3163,11 +3140,7 @@ SiS_Handle760(struct SiS_Private *SiS_Pr)
        (!(SiS_Pr->SiS_SysFlags & SF_760UMA)) )
       return;
 
-#ifdef SIS_LINUX_KERNEL
    somebase = sisfb_read_mio_pci_word(SiS_Pr, 0x74);
-#else
-   somebase = pciReadWord(0x00001000, 0x74);
-#endif
    somebase &= 0xffff;
 
    if(somebase == 0) return;
@@ -3183,13 +3156,8 @@ SiS_Handle760(struct SiS_Private *SiS_Pr)
       temp2 = 0x0b;
    }
 
-#ifdef SIS_LINUX_KERNEL
    sisfb_write_nbridge_pci_byte(SiS_Pr, 0x7e, temp1);
    sisfb_write_nbridge_pci_byte(SiS_Pr, 0x8d, temp2);
-#else
-   pciWriteByte(0x00000000, 0x7e, temp1);
-   pciWriteByte(0x00000000, 0x8d, temp2);
-#endif
 
    SiS_SetRegByte((somebase + 0x85), temp3);
 #endif
@@ -3205,21 +3173,17 @@ SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
    SISIOADDRESS BaseAddr = SiS_Pr->IOAddress;
    unsigned short RealModeNo, ModeIdIndex;
    unsigned char  backupreg = 0;
-#ifdef SIS_LINUX_KERNEL
    unsigned short KeepLockReg;
 
    SiS_Pr->UseCustomMode = false;
    SiS_Pr->CRT1UsesCustomMode = false;
-#endif
 
    SiS_Pr->SiS_flag_clearbuffer = 0;
 
    if(SiS_Pr->UseCustomMode) {
       ModeNo = 0xfe;
    } else {
-#ifdef SIS_LINUX_KERNEL
       if(!(ModeNo & 0x80)) SiS_Pr->SiS_flag_clearbuffer = 1;
-#endif
       ModeNo &= 0x7f;
    }
 
@@ -3233,9 +3197,7 @@ SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 
    SiS_Pr->SiS_VGAINFO = 0x11;
 
-#ifdef SIS_LINUX_KERNEL
    KeepLockReg = SiS_GetReg(SiS_Pr->SiS_P3c4,0x05);
-#endif
    SiS_SetReg(SiS_Pr->SiS_P3c4,0x05,0x86);
 
    SiSInitPCIetc(SiS_Pr);
@@ -3272,12 +3234,10 @@ SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
    SiS_GetLCDResInfo(SiS_Pr, ModeNo, ModeIdIndex);
    SiS_SetLowModeTest(SiS_Pr, ModeNo);
 
-#ifdef SIS_LINUX_KERNEL
    /* Check memory size (kernel framebuffer driver only) */
    if(!SiS_CheckMemorySize(SiS_Pr, ModeNo, ModeIdIndex)) {
       return false;
    }
-#endif
 
    SiS_OpenCRTC(SiS_Pr);
 
@@ -3356,10 +3316,8 @@ SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 
    SiS_Handle760(SiS_Pr);
 
-#ifdef SIS_LINUX_KERNEL
    /* We never lock registers in XF86 */
    if(KeepLockReg != 0xA1) SiS_SetReg(SiS_Pr->SiS_P3c4,0x05,0x00);
-#endif
 
    return true;
 }
@@ -3581,9 +3539,7 @@ SiS_CalcLCDACRT1Timing(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 void
 SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
 			int xres, int yres,
-#ifdef SIS_LINUX_KERNEL
 			struct fb_var_screeninfo *var, bool writeres
-#endif
 )
 {
    unsigned short HRE, HBE, HRS, HBS, HDE, HT;
@@ -3627,12 +3583,10 @@ SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
 
    D = B - F - C;
 
-#ifdef SIS_LINUX_KERNEL
    if(writeres) var->xres = xres = E * 8;
    var->left_margin = D * 8;
    var->right_margin = F * 8;
    var->hsync_len = C * 8;
-#endif
 
    /* Vertical */
    sr_data = crdata[13];
@@ -3679,12 +3633,10 @@ SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
 
    D = B - F - C;
 
-#ifdef SIS_LINUX_KERNEL
    if(writeres) var->yres = yres = E;
    var->upper_margin = D;
    var->lower_margin = F;
    var->vsync_len = C;
-#endif
 
    if((xres == 320) && ((yres == 200) || (yres == 240))) {
 	/* Terrible hack, but correct CRTC data for
@@ -3693,11 +3645,9 @@ SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
 	 * a negative D. The CRT controller does not
 	 * seem to like correcting HRE to 50)
 	 */
-#ifdef SIS_LINUX_KERNEL
       var->left_margin = (400 - 376);
       var->right_margin = (328 - 320);
       var->hsync_len = (376 - 328);
-#endif
 
    }
 
diff --git a/drivers/video/sis/init.h b/drivers/video/sis/init.h
index 4a75c73..1d54759 100644
--- a/drivers/video/sis/init.h
+++ b/drivers/video/sis/init.h
@@ -56,7 +56,6 @@
 #include "osdef.h"
 #include "initdef.h"
 
-#ifdef SIS_LINUX_KERNEL
 #include "vgatypes.h"
 #include "vstruct.h"
 #ifdef SIS_CP
@@ -67,7 +66,6 @@
 #include <linux/fb.h>
 #include "sis.h"
 #include <video/sisfb.h>
-#endif
 
 /* Mode numbers */
 static const unsigned short ModeIndex_320x200[]      = {0x59, 0x41, 0x00, 0x4f};
@@ -1535,17 +1533,11 @@ void		SiS_SetRegOR(SISIOADDRESS Port,unsigned short Index, unsigned short DataOR
 void		SiS_DisplayOn(struct SiS_Private *SiS_Pr);
 void		SiS_DisplayOff(struct SiS_Private *SiS_Pr);
 void		SiSRegInit(struct SiS_Private *SiS_Pr, SISIOADDRESS BaseAddr);
-#ifndef SIS_LINUX_KERNEL
-void		SiSSetLVDSetc(struct SiS_Private *SiS_Pr);
-#endif
 void		SiS_SetEnableDstn(struct SiS_Private *SiS_Pr, int enable);
 void		SiS_SetEnableFstn(struct SiS_Private *SiS_Pr, int enable);
 unsigned short	SiS_GetModeFlag(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 				unsigned short ModeIdIndex);
 bool		SiSDetermineROMLayout661(struct SiS_Private *SiS_Pr);
-#ifndef SIS_LINUX_KERNEL
-void		SiS_GetVBType(struct SiS_Private *SiS_Pr);
-#endif
 
 bool		SiS_SearchModeID(struct SiS_Private *SiS_Pr, unsigned short *ModeNo,
 				unsigned short *ModeIdIndex);
@@ -1564,16 +1556,12 @@ unsigned short	SiS_GetFIFOThresholdB300(unsigned short idx1, unsigned short idx2
 unsigned short	SiS_GetLatencyFactor630(struct SiS_Private *SiS_Pr, unsigned short index);
 #endif
 void		SiS_LoadDAC(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex);
-#ifdef SIS_LINUX_KERNEL
 bool		SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo);
-#endif
 void		SiS_CalcCRRegisters(struct SiS_Private *SiS_Pr, int depth);
 void		SiS_CalcLCDACRT1Timing(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 				unsigned short ModeIdIndex);
-#ifdef SIS_LINUX_KERNEL
 void		SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata, int xres,
 				int yres, struct fb_var_screeninfo *var, bool writeres);
-#endif
 
 /* From init301.c: */
 extern void		SiS_GetVBInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
@@ -1597,7 +1585,6 @@ extern unsigned short	SiS_GetVCLK2Ptr(struct SiS_Private *SiS_Pr, unsigned short
 extern bool		SiS_IsVAMode(struct SiS_Private *);
 extern bool		SiS_IsDualEdge(struct SiS_Private *);
 
-#ifdef SIS_LINUX_KERNEL
 #ifdef SIS300
 extern unsigned int	sisfb_read_nbridge_pci_dword(struct SiS_Private *SiS_Pr, int reg);
 extern void		sisfb_write_nbridge_pci_dword(struct SiS_Private *SiS_Pr, int reg,
@@ -1608,7 +1595,6 @@ extern void		sisfb_write_nbridge_pci_byte(struct SiS_Private *SiS_Pr, int reg,
 				unsigned char val);
 extern unsigned int	sisfb_read_mio_pci_word(struct SiS_Private *SiS_Pr, int reg);
 #endif
-#endif
 
 #endif
 
diff --git a/drivers/video/sis/init301.c b/drivers/video/sis/init301.c
index a4b344e..78055f6 100644
--- a/drivers/video/sis/init301.c
+++ b/drivers/video/sis/init301.c
@@ -87,9 +87,7 @@
 #define SiS_I2CDELAYSHORT  150
 
 static unsigned short	SiS_GetBIOSLCDResInfo(struct SiS_Private *SiS_Pr);
-#ifdef SIS_LINUX_KERNEL
 static void		SiS_SetCH70xx(struct SiS_Private *SiS_Pr, unsigned short reg, unsigned char val);
-#endif
 
 /*********************************************/
 /*         HELPER: Lock/Unlock CRT2          */
@@ -106,9 +104,7 @@ SiS_UnLockCRT2(struct SiS_Private *SiS_Pr)
       SiS_SetRegOR(SiS_Pr->SiS_Part1Port,0x24,0x01);
 }
 
-#ifdef SIS_LINUX_KERNEL
 static
-#endif
 void
 SiS_LockCRT2(struct SiS_Private *SiS_Pr)
 {
@@ -923,11 +919,7 @@ SiS_SetChrontelGPIO(struct SiS_Private *SiS_Pr, unsigned short myvbinfo)
 
    if(!(SiS_Pr->SiS_ChSW)) return;
 
-#ifdef SIS_LINUX_KERNEL
    acpibase = sisfb_read_lpc_pci_dword(SiS_Pr, 0x74);
-#else
-   acpibase = pciReadLong(0x00000800, 0x74);
-#endif
    acpibase &= 0xFFFF;
    if(!acpibase) return;
    temp = SiS_GetRegShort((acpibase + 0x3c));	/* ACPI register 0x3c: GP Event 1 I/O mode select */
@@ -1160,12 +1152,10 @@ SiS_GetVBInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
    }
 #endif
 
-#ifdef SIS_LINUX_KERNEL
 #if 0
    printk(KERN_DEBUG "sisfb: (init301: VBInfo= 0x%04x, SetFlag=0x%04x)\n",
       SiS_Pr->SiS_VBInfo, SiS_Pr->SiS_SetFlag);
 #endif
-#endif
 }
 
 /*********************************************/
@@ -2150,12 +2140,10 @@ SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sh
      SiS_Pr->SiS_SetFlag |= LCDVESATiming;
   }
 
-#ifdef SIS_LINUX_KERNEL
 #if 0
   printk(KERN_DEBUG "sisfb: (LCDInfo=0x%04x LCDResInfo=0x%02x LCDTypeInfo=0x%02x)\n",
 	SiS_Pr->SiS_LCDInfo, SiS_Pr->SiS_LCDResInfo, SiS_Pr->SiS_LCDTypeInfo);
 #endif
-#endif
 }
 
 /*********************************************/
@@ -4246,9 +4234,7 @@ SiS_DisableBridge(struct SiS_Private *SiS_Pr)
  * from outside the context of a mode switch!
  * MUST call getVBType before calling this
  */
-#ifdef SIS_LINUX_KERNEL
 static
-#endif
 void
 SiS_EnableBridge(struct SiS_Private *SiS_Pr)
 {
@@ -5096,13 +5082,8 @@ SiS_SetCRT2FIFO_300(struct SiS_Private *SiS_Pr,unsigned short ModeNo)
 
      } else {
 
-#ifdef SIS_LINUX_KERNEL
 	pci50 = sisfb_read_nbridge_pci_dword(SiS_Pr, 0x50);
 	pciA0 = sisfb_read_nbridge_pci_dword(SiS_Pr, 0xa0);
-#else
-	pci50 = pciReadLong(0x00000000, 0x50);
-	pciA0 = pciReadLong(0x00000000, 0xA0);
-#endif
 
         if(SiS_Pr->ChipType == SIS_730) {
 
@@ -8872,9 +8853,7 @@ SiS_SetCH701x(struct SiS_Private *SiS_Pr, unsigned short reg, unsigned char val)
   SiS_SetChReg(SiS_Pr, reg, val, 0);
 }
 
-#ifdef SIS_LINUX_KERNEL
 static
-#endif
 void
 SiS_SetCH70xx(struct SiS_Private *SiS_Pr, unsigned short reg, unsigned char val)
 {
@@ -8961,9 +8940,7 @@ SiS_GetCH701x(struct SiS_Private *SiS_Pr, unsigned short tempbx)
 
 /* Read from Chrontel 70xx */
 /* Parameter is [Register no (S7-S0)] */
-#ifdef SIS_LINUX_KERNEL
 static
-#endif
 unsigned short
 SiS_GetCH70xx(struct SiS_Private *SiS_Pr, unsigned short tempbx)
 {
diff --git a/drivers/video/sis/init301.h b/drivers/video/sis/init301.h
index c379dc7..31e24ae 100644
--- a/drivers/video/sis/init301.h
+++ b/drivers/video/sis/init301.h
@@ -56,7 +56,6 @@
 #include "osdef.h"
 #include "initdef.h"
 
-#ifdef SIS_LINUX_KERNEL
 #include "vgatypes.h"
 #include "vstruct.h"
 #ifdef SIS_CP
@@ -67,7 +66,6 @@
 #include <linux/fb.h>
 #include "sis.h"
 #include <video/sisfb.h>
-#endif
 
 static const unsigned char SiS_YPbPrTable[3][64] = {
   {
@@ -351,9 +349,6 @@ static unsigned char SiS300_TrumpionData[14][80] = {
 #endif
 
 void		SiS_UnLockCRT2(struct SiS_Private *SiS_Pr);
-#ifndef SIS_LINUX_KERNEL
-void		SiS_LockCRT2(struct SiS_Private *SiS_Pr);
-#endif
 void		SiS_EnableCRT2(struct SiS_Private *SiS_Pr);
 unsigned short	SiS_GetRatePtr(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex);
 void		SiS_WaitRetrace1(struct SiS_Private *SiS_Pr);
@@ -370,9 +365,6 @@ unsigned short	SiS_GetVCLK2Ptr(struct SiS_Private *SiS_Pr, unsigned short ModeNo
 			unsigned short RefreshRateTableIndex);
 unsigned short	SiS_GetResInfo(struct SiS_Private *SiS_Pr,unsigned short ModeNo,unsigned short ModeIdIndex);
 void		SiS_DisableBridge(struct SiS_Private *SiS_Pr);
-#ifndef SIS_LINUX_KERNEL
-void		SiS_EnableBridge(struct SiS_Private *SiS_Pr);
-#endif
 bool		SiS_SetCRT2Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo);
 void		SiS_SiS30xBLOn(struct SiS_Private *SiS_Pr);
 void		SiS_SiS30xBLOff(struct SiS_Private *SiS_Pr);
@@ -381,10 +373,6 @@ void		SiS_SetCH700x(struct SiS_Private *SiS_Pr, unsigned short reg, unsigned cha
 unsigned short	SiS_GetCH700x(struct SiS_Private *SiS_Pr, unsigned short tempax);
 void		SiS_SetCH701x(struct SiS_Private *SiS_Pr, unsigned short reg, unsigned char val);
 unsigned short	SiS_GetCH701x(struct SiS_Private *SiS_Pr, unsigned short tempax);
-#ifndef SIS_LINUX_KERNEL
-void		SiS_SetCH70xx(struct SiS_Private *SiS_Pr, unsigned short reg, unsigned char val);
-unsigned short	SiS_GetCH70xx(struct SiS_Private *SiS_Pr, unsigned short tempax);
-#endif
 void		SiS_SetCH70xxANDOR(struct SiS_Private *SiS_Pr, unsigned short reg,
 			unsigned char orval,unsigned short andval);
 #ifdef SIS315H
@@ -473,10 +461,8 @@ extern void		SiS_GetFIFOThresholdIndex300(struct SiS_Private *SiS_Pr, unsigned s
 				unsigned short *tempcl);
 extern unsigned short	SiS_GetFIFOThresholdB300(unsigned short tempbx, unsigned short tempcl);
 extern unsigned short	SiS_GetLatencyFactor630(struct SiS_Private *SiS_Pr, unsigned short index);
-#ifdef SIS_LINUX_KERNEL
 extern unsigned int	sisfb_read_nbridge_pci_dword(struct SiS_Private *SiS_Pr, int reg);
 extern unsigned int	sisfb_read_lpc_pci_dword(struct SiS_Private *SiS_Pr, int reg);
 #endif
-#endif
 
 #endif
diff --git a/drivers/video/sis/osdef.h b/drivers/video/sis/osdef.h
index e24d21a..bc185a9 100644
--- a/drivers/video/sis/osdef.h
+++ b/drivers/video/sis/osdef.h
@@ -54,9 +54,6 @@
 #ifndef _SIS_OSDEF_H_
 #define _SIS_OSDEF_H_
 
-/* The choices are: */
-#define SIS_LINUX_KERNEL		/* Linux kernel framebuffer */
-
 #ifdef OutPortByte
 #undef OutPortByte
 #endif
@@ -85,8 +82,6 @@
 /*  LINUX KERNEL                                                      */
 /**********************************************************************/
 
-#ifdef SIS_LINUX_KERNEL
-
 #ifdef CONFIG_FB_SIS_300
 #define SIS300
 #endif
@@ -108,6 +103,4 @@
 #define InPortLong(p)    inl((SISIOADDRESS)(p))
 #define SiS_SetMemory(MemoryAddress,MemorySize,value) memset_io(MemoryAddress, value, MemorySize)
 
-#endif /* LINUX_KERNEL */
-
 #endif  /* _OSDEF_H_ */
diff --git a/drivers/video/sis/vgatypes.h b/drivers/video/sis/vgatypes.h
index f499062..12c0dfa 100644
--- a/drivers/video/sis/vgatypes.h
+++ b/drivers/video/sis/vgatypes.h
@@ -55,12 +55,10 @@
 
 #define SISIOMEMTYPE
 
-#ifdef SIS_LINUX_KERNEL
 typedef unsigned long SISIOADDRESS;
 #include <linux/types.h>  /* Need __iomem */
 #undef SISIOMEMTYPE
 #define SISIOMEMTYPE __iomem
-#endif
 
 typedef enum _SIS_CHIP_TYPE {
     SIS_VGALegacy = 0,
diff --git a/drivers/video/sis/vstruct.h b/drivers/video/sis/vstruct.h
index a860039..ea94d21 100644
--- a/drivers/video/sis/vstruct.h
+++ b/drivers/video/sis/vstruct.h
@@ -233,21 +233,15 @@ struct SiS_Private
 {
 	unsigned char			ChipType;
 	unsigned char			ChipRevision;
-#ifdef SIS_LINUX_KERNEL
 	void				*ivideo;
-#endif
 	unsigned char 			*VirtualRomBase;
 	bool				UseROM;
-#ifdef SIS_LINUX_KERNEL
 	unsigned char SISIOMEMTYPE	*VideoMemoryAddress;
 	unsigned int			VideoMemorySize;
-#endif
 	SISIOADDRESS			IOAddress;
 	SISIOADDRESS			IOAddress2;  /* For dual chip XGI volari */
 
-#ifdef SIS_LINUX_KERNEL
 	SISIOADDRESS			RelIO;
-#endif
 	SISIOADDRESS			SiS_P3c4;
 	SISIOADDRESS			SiS_P3d4;
 	SISIOADDRESS			SiS_P3c0;
-- 
1.5.6.5


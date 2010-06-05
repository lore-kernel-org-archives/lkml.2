Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab0FEQGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:06:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41727 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933638Ab0FEQFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=x9LH+z5psJNVZF2/w1rwORaePl6hHAiDGgA0pwwBtaBxjsgSZftGUh9fToV18dKwKZ
         jOJthh+FduUPF7M1hVX7oiCNG8A1BfGKGlAN8vLaaFpY5/VOvJUvBerCi7MvpUI1cwa0
         O1iO2onDeZ9DszLQttSp6Tg1dMgwNG0EeUyI0=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 2/7] Remove WIN* specific code.
Date: Sat,  5 Jun 2010 18:04:20 +0200
Message-Id: <1275753865-5435-3-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/osdef.h      |   45 -----
 drivers/staging/xgifb/vb_ext.c     |  311 ------------------------------------
 drivers/staging/xgifb/vb_ext.h     |    3 -
 drivers/staging/xgifb/vb_init.c    |   31 ----
 drivers/staging/xgifb/vb_setmode.c |  184 ---------------------
 drivers/staging/xgifb/vb_util.c    |   26 ---
 drivers/staging/xgifb/vgatypes.h   |    8 +-
 7 files changed, 2 insertions(+), 606 deletions(-)

diff --git a/drivers/staging/xgifb/osdef.h b/drivers/staging/xgifb/osdef.h
index 4bc7d3a..0d634f8 100644
--- a/drivers/staging/xgifb/osdef.h
+++ b/drivers/staging/xgifb/osdef.h
@@ -1,8 +1,6 @@
 #ifndef _OSDEF_H_
 #define _OSDEF_H_
 
-/* #define WINCE_HEADER*/
-/*#define WIN2000*/
 /* #define TC */
 #define LINUX_KERNEL
 /* #define LINUX_XF86 */
@@ -16,10 +14,6 @@
 /**********************************************************************/
 #ifdef TC
 #endif
-#ifdef WIN2000
-#endif
-#ifdef WINCE_HEADER
-#endif
 #ifdef LINUX_XF86
 #define LINUX
 #endif
@@ -31,12 +25,6 @@
 #ifdef TC
 #define XGI_SetMemory(MemoryAddress,MemorySize,value) memset(MemoryAddress, value, MemorySize);
 #endif
-#ifdef WIN2000
-#define XGI_SetMemory(MemoryAddress,MemorySize,value) MemFill((PVOID) MemoryAddress,(ULONG) MemorySize,(UCHAR) value);
-#endif
-#ifdef WINCE_HEADER
-#define XGI_SetMemory(MemoryAddress,MemorySize,value) memset(MemoryAddress, value, MemorySize);
-#endif
 #ifdef LINUX_XF86
 #define XGI_SetMemory(MemoryAddress,MemorySize,value) memset(MemoryAddress, value, MemorySize)
 #endif
@@ -50,12 +38,6 @@
 #ifdef TC
 #define XGI_MemoryCopy(Destination,Soruce,Length) memmove(Destination, Soruce, Length);
 #endif
-#ifdef WIN2000
-#define XGI_MemoryCopy(Destination,Soruce,Length)  /*VideoPortMoveMemory((PUCHAR)Destination , Soruce,length);*/
-#endif
-#ifdef WINCE_HEADER
-#define XGI_MemoryCopy(Destination,Soruce,Length) memmove(Destination, Soruce, Length);
-#endif
 #ifdef LINUX_XF86
 #define XGI_MemoryCopy(Destination,Soruce,Length) memcpy(Destination,Soruce,Length)
 #endif
@@ -123,31 +105,4 @@
 #define InPortWord(p)    inw(p)
 #define InPortLong(p)    inl(p)
 #endif
-
-/**********************************************************************/
-/*  WIN 2000                                                          */
-/**********************************************************************/
-
-#ifdef WIN2000
-#define OutPortByte(p,v) VideoPortWritePortUchar ((PUCHAR) (p), (UCHAR) (v))
-#define OutPortWord(p,v) VideoPortWritePortUshort((PUSHORT) (p), (USHORT) (v))
-#define OutPortLong(p,v) VideoPortWritePortUlong ((PULONG) (p), (ULONG) (v))
-#define InPortByte(p)    VideoPortReadPortUchar  ((PUCHAR) (p))
-#define InPortWord(p)    VideoPortReadPortUshort ((PUSHORT) (p))
-#define InPortLong(p)    VideoPortReadPortUlong  ((PULONG) (p))
-#endif
-
-
-/**********************************************************************/
-/*  WIN CE                                                          */
-/**********************************************************************/
-
-#ifdef WINCE_HEADER
-#define OutPortByte(p,v) WRITE_PORT_UCHAR ((PUCHAR) (p), (UCHAR) (v))
-#define OutPortWord(p,v) WRITE_PORT_USHORT((PUSHORT) (p), (USHORT) (v))
-#define OutPortLong(p,v) WRITE_PORT_ULONG ((PULONG) (p), (ULONG) (v))
-#define InPortByte(p)    READ_PORT_UCHAR  ((PUCHAR) (p))
-#define InPortWord(p)    READ_PORT_USHORT ((PUSHORT) (p))
-#define InPortLong(p)    READ_PORT_ULONG  ((PULONG) (p))
-#endif
 #endif // _OSDEF_H_
diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index 91568fa..35adffd 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -1,20 +1,5 @@
 #include "osdef.h"
 
-
-
-
-#ifdef WIN2000
-
-#include <dderror.h>
-#include <devioctl.h>
-#include <miniport.h>
-#include <ntddvdeo.h>
-#include <video.h>
-#include "xgiv.h"
-#include "dd_i2c.h"
-#include "tools.h"
-#endif /* WIN2000 */
-
 #ifdef LINUX_XF86
 #include "xf86.h"
 #include "xf86PciInfo.h"
@@ -42,9 +27,6 @@ extern   UCHAR XGI330_OutputSelect;
 extern   USHORT XGI330_RGBSenseData2;
 extern   USHORT XGI330_YCSenseData2;
 extern   USHORT XGI330_VideoSenseData2;
-#ifdef WIN2000
-extern   UCHAR SenseCHTV(PHW_DEVICE_EXTENSION pHWDE);       /* 2007/05/17 Billy */
-#endif
 void     XGI_GetSenseStatus( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo );
 BOOLEAN  XGINew_GetPanelID(PVB_DEVICE_INFO pVBInfo);
 USHORT   XGINew_SenseLCD(PXGI_HW_DEVICE_INFO,PVB_DEVICE_INFO pVBInfo);
@@ -62,20 +44,6 @@ void XGI_WaitDisplay(void);
 BOOLEAN XGI_Is301C(PVB_DEVICE_INFO);
 BOOLEAN XGI_Is301LV(PVB_DEVICE_INFO);
 
-#ifdef WIN2000
-UCHAR XGI_SenseLCD(PHW_DEVICE_EXTENSION, PVB_DEVICE_INFO);
-UCHAR XGI_GetLCDDDCInfo(PHW_DEVICE_EXTENSION,PVB_DEVICE_INFO);
-
-extern BOOL bGetDdcInfo(
-PHW_DEVICE_EXTENSION  pHWDE,
-ULONG                 ulWhichOne,
-PUCHAR                pjQueryBuffer,
-ULONG                 ulBufferSize
-   );
-
-#endif
-
-
 /* --------------------------------------------------------------------- */
 /* Function : XGINew_Is301B */
 /* Input : */
@@ -164,285 +132,6 @@ BOOLEAN XGINew_Sense(  USHORT tempbx , USHORT tempcx, PVB_DEVICE_INFO pVBInfo )
         return( 0 ) ;
 }
 
-#ifdef WIN2000
-/* --------------------------------------------------------------------- */
-/* Function : XGI_SenseLCD */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-UCHAR XGI_SenseLCD( PHW_DEVICE_EXTENSION pHWDE, PVB_DEVICE_INFO pVBInfo)
-{
-    USHORT tempax , tempbx , tempcx ;
-    UCHAR SoftSetting = XGI330_SoftSetting ;
-
-    if ( pVBInfo->VBType & ( VB_XGI301LV | VB_XGI302LV ) )
-        return( 1 ) ;
-
-
-    if ( SoftSetting & HotPlugFunction )	/* Hot Plug Detection */
-    {
-        XGINew_SetRegAND( pVBInfo->Part4Port , 0x0F , 0x3F ) ;
-        tempbx = 0 ;
-        tempcx = 0x9010 ;
-        if ( XGINew_Sense( tempbx , tempcx, pVBInfo ) )
-            return( 1 ) ;
-
-        return( 0 ) ;
-    }
-    else	/* Get LCD Info from EDID */
-        return(XGI_GetLCDDDCInfo(pHWDE, pVBInfo));
-}
-
-
-/* --------------------------------------------------------------------- */
-/* Function : XGI_GetLCDDDCInfo */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-UCHAR XGI_GetLCDDDCInfo( PHW_DEVICE_EXTENSION pHWDE , PVB_DEVICE_INFO pVBInfo)
-{
-    UCHAR tempah , tempbl , tempbh ;
-    USHORT tempbx , temp ;
-    UCHAR pjEDIDBuf[ 256 ] ;
-    ULONG ulBufferSize = 256 ;
-    UCHAR bMASK_OUTPUTSTATE_CRT2LCD = 2 ; /* 0423 shampoo */
-
-    bGetDdcInfo( pHWDE , MASK_OUTPUTSTATE_CRT2LCD , pjEDIDBuf , ulBufferSize ) ;
-    if ( ( *( ( PULONG )pjEDIDBuf ) == 0xFFFFFF00 ) && ( *( ( PULONG )( pjEDIDBuf + 4 ) ) == 0x00FFFFFF ) )
-    {
-        tempah = Panel1024x768 ;
-        tempbl=( *( pjEDIDBuf + 0x3A ) ) & 0xf0 ;
-
-        if ( tempbl != 0x40 )
-        {
-            tempah = Panel1600x1200 ;
-            if ( tempbl != 0x60 )
-            {
-                tempah = Panel1280x1024 ;
-                tempbh = ( *( pjEDIDBuf + 0x3B ) ) ;
-                if ( tempbh != 0x00 )
-                {
-                    tempah = Panel1280x960 ;
-                    if ( tempbh != 0x0C0 )
-                    {
-                        tempbx = ( ( *( pjEDIDBuf + 0x24 ) ) << 8 ) | ( *( pjEDIDBuf + 0x23 ) ) ;
-                        tempah = Panel1280x1024 ;
-                        if ( !( tempbx & 0x0100 ) )
-                        {
-                            tempah = Panel1024x768 ;
-                            if ( !( tempbx & 0x0E00 ) )
-                            {
-                                tempah = Panel1280x1024 ;
-                            }
-                        }
-                    }
-
-                    if ( tempbx & 0x00FF )
-                    {
-                        temp = ScalingLCD ;
-                        XGINew_SetRegOR( pVBInfo->P3d4 , 0x37 , temp ) ;
-                    }
-                }
-            }
-        }
-        XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x36 , ( ~0x07 ) , tempah ) ;
-        tempah = ( ( *( pjEDIDBuf + 0x47 ) ) & 0x06 ) ;		/* Polarity */
-        tempah = ( tempah ^ 0x06 ) << 4 ;
-        tempah |= LCDSync ;
-        XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x37 , ( ~LCDSyncBit ) , tempah ) ;
-        tempbh= XGINew_GetReg1( pVBInfo->P3d4 , 0x36 ) ;
-        tempbh &= 0x07 ;
-        if ( tempbh == Panel1280x960 )
-            XGINew_SetRegAND( pVBInfo->P3d4 , 0x37 , 0x0E ) ;
-    }
-    else if ( *pjEDIDBuf == 0x20 )
-    {
-        tempah = Panel1024x768 ;
-        XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x36 , ( ~0x07 ) , tempah ) ;
-    }
-    else
-    {
-        return( 0 ) ;
-    }
-
-    return( 1 ) ;
-}
-
-
-/* --------------------------------------------------------------------- */
-/* Function : XGI_DySense */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-BOOLEAN XGI_DySense( PHW_DEVICE_EXTENSION pHWDE , PUCHAR ujConnectStatus)
-{
-    UCHAR pre_CRD,pre_SR1E , pre_Part2_0 , pre_Part4_D ;
-    USHORT tempax , tempbx , tempcx , pushax , temp ;
-    VB_DEVICE_INFO VBINF;
-    PVB_DEVICE_INFO pVBInfo = &VBINF;
-    UCHAR OutputSelect = XGI330_OutputSelect ;
-    PXGI_HW_DEVICE_INFO HwDeviceExtension= pHWDE->pXGIHWDE ;
-    UCHAR   bConnectStatus = 0 ;
-    pVBInfo->BaseAddr = HwDeviceExtension->pjIOAddress ;
-    pVBInfo->ROMAddr  = pHWDE->pjVirtualRomBase ;
-
-    pVBInfo->P3c2 = pVBInfo->BaseAddr + 0x12 ;
-    pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14 ;
-    pVBInfo->P3d4 = pVBInfo->BaseAddr + 0x24 ;
-    pVBInfo->Part2Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_10 ;
-    pVBInfo->Part4Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14 ;
-    pushax = XGINew_GetReg1( pVBInfo->P3d4 , 0x17 ) ;	/* 0512 Fix Dysense hanged */
-    temp = ( pushax & 0x00FF ) | 0x80 ;
-    XGINew_SetRegOR( pVBInfo->P3d4 , 0x17 , temp ) ;
-    XGINew_SetReg1( pVBInfo->P3c4 , 0x05 , 0x86 ) ;
-    /* beginning of dynamic sense CRT1 */
-
-    pVBInfo->IF_DEF_CH7007 = 0;
-    if (pHWDE->bCH7007)
-    {
-    	InitTo330Pointer( pHWDE->pXGIHWDE->jChipType, pVBInfo ) ;
-        HwDeviceExtension->pDevice = (PVOID)pHWDE;
-        pVBInfo->IF_DEF_CH7007 = 1;
-        /* [Billy] 2007/05/14 For CH7007 */
-        if ( pVBInfo->IF_DEF_CH7007 == 1 )
-        {
-           bConnectStatus = SenseCHTV(HwDeviceExtension->pDevice) ; /* 07/05/28 */
-           XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x32 , ~0x03 , (UCHAR)bConnectStatus ) ;
-        }
-    }
-    if(( pHWDE->jChipID >= XG40 ) || ( pHWDE->jChipID >= XG20 ))
-    {
-
-        if ( pHWDE->jChipID >= XG40 )
-    	    XGINew_SetReg1( pVBInfo->P3d4 , 0x57 , 0x4A ) ;	/* write sense pattern 30->4a */
-    	else
-            XGINew_SetReg1( pVBInfo->P3d4 , 0x57 , 0x5F ) ;	/* write sense pattern */
-
-        XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x53 , 0xFF , 0x02 ) ;	/* enable sense DAC */
-        XGI_WaitDisply(pVBInfo) ;
-
-        if(XGINew_GetReg2( pVBInfo->P3c2 ) & 0x10 )
-            bConnectStatus |= Monitor1Sense ;
-
-        XGINew_SetRegAND( pVBInfo->P3d4 , 0x53 , 0xFD ) ;	/* disable sense DAC */
-        XGINew_SetRegAND( pVBInfo->P3d4 , 0x57 , 0x00 ) ;	/* clear sense pattern */
-
-
-        /* ---------- End of dynamic sense CRT1 ----------- */
-
-        /* ---------- beginning of dynamic sense VB ------------ */
-        pre_SR1E = XGINew_GetReg1( pVBInfo->P3c4 , 0x1E ) ;
-        XGINew_SetRegOR( pVBInfo->P3c4 , 0x1E , 0x20 ) ;	/* Enable CRT2,work-a-round for 301B/301LV/302LV */
-        pre_Part2_0 = XGINew_GetReg1( pVBInfo->Part2Port , 0x00 ) ;
-        pre_Part4_D = XGINew_GetReg1( pVBInfo->Part4Port , 0x0D ) ;
-
-        if ( XGI_Is301C( pVBInfo ) )	/* 301C only */
-            XGINew_SetRegANDOR( pVBInfo->Part4Port , 0x0D , ~0x07 , 0x01 ) ;	/* Set Part4 0x0D D[2:0] to 001b */
-
-        /* tempax = 0 ; */
-        if ( !XGI_Is301LV( pVBInfo ) )
-        {
-           tempbx = XGI330_RGBSenseData2 ;
-            tempcx = 0x0E08 ;
-            if(XGINew_Sense( tempbx , tempcx, pVBInfo ) )
-            {
-                bConnectStatus |= Monitor2Sense ;
-                if ( OutputSelect & SetSCARTOutput )
-                {
-                    bConnectStatus ^= ( Monitor2Sense | SCARTSense ) ;
-                }
-            }
-        }
-        if ( XGI_Is301C( pVBInfo ) )	/* 301C only */
-            XGINew_SetRegOR( pVBInfo->Part4Port , 0x0D , 0x04 ) ;	/* Set Part4 0x0D D[2]=1 for dynamic sense */
-
-        if ( ( XGINew_Is301B( pVBInfo ) ) )
-            XGINew_SetRegOR( pVBInfo->Part2Port , 0x00 , 0x0C ) ;    /* ????????? */
-
-	if ( XGINew_SenseHiTV( HwDeviceExtension , pVBInfo) )		/* add by kuku for Dysense HiTV //start */
-	{
-	    bConnectStatus|= YPbPrSense ;
-	}
-	else
-	{
-        tempbx = XGI330_YCSenseData2 ;	/* Y/C Sense Data Ptr */
-        tempcx = 0x0604 ;
-        if ( XGINew_Sense( tempbx , tempcx , pVBInfo) )
-            bConnectStatus |= SVIDEOSense ;
-
-        if ( OutputSelect & BoardTVType )
-        {
-            tempbx = XGI330_VideoSenseData2 ;
-            tempcx = 0x0804 ;
-            if ( XGINew_Sense(tempbx , tempcx, pVBInfo) )
-                bConnectStatus|= AVIDEOSense ;
-        }
-        else
-        {
-            if ( !( bConnectStatus & SVIDEOSense ) )
-            {
-                tempbx = XGI330_VideoSenseData2 ;
-                tempcx = 0x0804 ;
-                if ( XGINew_Sense( tempbx , tempcx, pVBInfo ) )
-                    bConnectStatus |= AVIDEOSense ;
-            }
-        }
-    	} /* end */
-        /* DySenseVBCnt */
-
-        tempbx = 0 ;
-        tempcx = 0 ;
-        XGINew_Sense(tempbx , tempcx, pVBInfo ) ;
-
-        if ( !( bConnectStatus & Monitor2Sense ) )
-        {
-            if ( XGI_SenseLCD( pHWDE , pVBInfo ) )
-                bConnectStatus |= LCDSense ;
-        }
-
-        XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x32 , ~( AVIDEOSense | SVIDEOSense | LCDSense | Monitor2Sense | Monitor1Sense ) , bConnectStatus ) ;
-
-        XGINew_SetReg1( pVBInfo->Part4Port , 0x0D , pre_Part4_D ) ;
-        XGINew_SetReg1( pVBInfo->Part2Port , 0x00 , pre_Part2_0 ) ;
-        XGINew_SetReg1( pVBInfo->P3c4 , 0x1E , pre_SR1E ) ;
-
-        if ( XGI_Is301C( pVBInfo ) )	/* 301C only */
-        {
-            tempax = XGINew_GetReg1( pVBInfo->Part2Port , 0x00 ) ;
-            if ( tempax & 0x20 )
-            {
-                /* Reset VBPro */
-                for( tempcx = 2 ; tempcx > 0 ; tempcx-- )
-                {
-                    tempax ^= 0x20 ;
-                    XGINew_SetReg1( pVBInfo->Part2Port , 0x00 , tempax ) ;
-                }
-            }
-        }
-        /* End of dynamic sense VB */
-    }
-    else
-    {
-        XGI_SenseCRT1(pVBInfo) ;
-        XGI_GetSenseStatus( HwDeviceExtension, pVBInfo ) ;	/* sense CRT2 */
-        bConnectStatus = XGINew_GetReg1( pVBInfo->P3d4 , 0x32 ) ;
-    }
-    temp = pushax & 0x00FF ;		/* 0512 Fix Dysense hanged */
-    XGINew_SetReg1( pVBInfo->P3d4 , 0x17 , temp ) ;
-    if ( bConnectStatus )
-    {
-        *ujConnectStatus = bConnectStatus ;
-        return( 1 ) ;
-    }
-    else
-        return( 0 ) ;
-}
-
-#endif /* WIN2000 */
-
 /* --------------------------------------------------------------------- */
 /* Function : XGISetDPMS */
 /* Input : */
diff --git a/drivers/staging/xgifb/vb_ext.h b/drivers/staging/xgifb/vb_ext.h
index 9a72f5e..3a52a6a 100644
--- a/drivers/staging/xgifb/vb_ext.h
+++ b/drivers/staging/xgifb/vb_ext.h
@@ -25,8 +25,5 @@ extern   void     XGI_GetSenseStatus( PXGI_HW_DEVICE_INFO HwDeviceExtension , PV
 extern   void     XGINew_SetModeScratch ( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE_INFO pVBInfo ) ;
 extern   void 	  ReadVBIOSTablData( UCHAR ChipType , PVB_DEVICE_INFO pVBInfo);
 extern   USHORT   XGINew_SenseLCD(PXGI_HW_DEVICE_INFO,PVB_DEVICE_INFO pVBInfo);
-#ifdef WIN2000
-extern   BOOLEAN  XGI_DySense( PHW_DEVICE_EXTENSION pHWDE , PUCHAR ujConnectStatus );
-#endif /* WIN2000 */
 
 #endif
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 66405f7..c7f3a45 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -9,17 +9,6 @@
 #include "XGIfb.h"
 #endif
 
-#ifdef WIN2000
-#include <dderror.h>
-#include <devioctl.h>
-#include <miniport.h>
-#include <ntddvdeo.h>
-#include <video.h>
-#include "xgiv.h"
-#include "dd_i2c.h"
-#include "tools.h"
-#endif
-
 #include "vb_def.h"
 #include "vb_struct.h"
 #include "vb_util.h"
@@ -132,12 +121,6 @@ UCHAR    GetXG21FPBits(PVB_DEVICE_INFO pVBInfo);
 void     XGINew_GetXG27Sense(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo) ;
 UCHAR    GetXG27FPBits(PVB_DEVICE_INFO pVBInfo);
 
-#ifdef WIN2000
-/* [Billy] 2007/05/20 For CH7007 */
-extern  UCHAR CH7007TVReg_UNTSC[][8],CH7007TVReg_ONTSC[][8],CH7007TVReg_UPAL[][8],CH7007TVReg_OPAL[][8];
-extern  UCHAR XGI7007_CHTVVCLKUNTSC[],XGI7007_CHTVVCLKONTSC[],XGI7007_CHTVVCLKUPAL[],XGI7007_CHTVVCLKOPAL[];
-#endif
-
 #ifdef LINUX_KERNEL
 void DelayUS(ULONG MicroSeconds)
 {
@@ -1874,10 +1857,6 @@ int XGINew_CheckColumn( int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DEVICE_INF
         Position += Increment ;
     }
 
-#ifdef WIN2000  /* chiawen for linux solution */
-    DelayUS( 100 ) ;
-#endif
-
     for( i = 0 , Position = 0 ; i < 2 ; i++ )
     {
         /* if ( pVBInfo->FBAddr[ Position ] != Position ) */
@@ -3328,16 +3307,6 @@ void XGINew_GetXG21Sense(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 
     pVBInfo->IF_DEF_LVDS = 0 ;
 
-#ifdef WIN2000
-   pVBInfo->IF_DEF_CH7007 = 0 ;
-    if ( ( pVideoMemory[ 0x65 ] & 0x02 ) )			/* For XG21 CH7007 */
-    {
-        /* VideoDebugPrint((0, "ReadVBIOSTablData: pVideoMemory[ 0x65 ] =%x\n",pVideoMemory[ 0x65 ])); */
-        pVBInfo->IF_DEF_CH7007 = 1 ;                            /* [Billy] 07/05/03 */
-        XGINew_SetRegANDOR( pVBInfo->P3d4 , 0x38 , ~0xE0 , 0x60 ) ; /* CH7007 on chip */
-    }
-    else
-#endif
 #if 1
     if (( pVideoMemory[ 0x65 ] & 0x01 ) )			/* For XG21 LVDS */
     {
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 1b5fecf..7041440 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -21,18 +21,6 @@
 #include "XGIfb.h"
 #endif
 
-#ifdef WIN2000
-#include <dderror.h>
-#include <devioctl.h>
-#include <miniport.h>
-#include <ntddvdeo.h>
-#include <video.h>
-
-#include "xgiv.h"
-#include "dd_i2c.h"
-#include "tools.h"
-#endif
-
 #include "vb_def.h"
 #include "vgatypes.h"
 #include "vb_struct.h"
@@ -178,19 +166,6 @@ void     XGI_SetXG27LVDSPara(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO p
 UCHAR    XGI_SetDefaultVCLK( PVB_DEVICE_INFO pVBInfo );
 
 extern   void 	  ReadVBIOSTablData( UCHAR ChipType , PVB_DEVICE_INFO pVBInfo);
-#ifdef WIN2000
-/* [Billy] 2007/05/17 For CH7007 */
-extern  UCHAR CH7007TVReg_UNTSC[][8],CH7007TVReg_ONTSC[][8],CH7007TVReg_UPAL[][8],CH7007TVReg_OPAL[][8];
-extern  UCHAR CH7007TVCRT1UNTSC_H[][10],CH7007TVCRT1ONTSC_H[][10],CH7007TVCRT1UPAL_H[][10],CH7007TVCRT1OPAL_H[][10] ;
-extern  UCHAR CH7007TVCRT1UNTSC_V[][10],CH7007TVCRT1ONTSC_V[][10],CH7007TVCRT1UPAL_V[][10],CH7007TVCRT1OPAL_V[][10] ;
-extern  UCHAR XGI7007_CHTVVCLKUNTSC[],XGI7007_CHTVVCLKONTSC[],XGI7007_CHTVVCLKUPAL[],XGI7007_CHTVVCLKOPAL[];
-
-extern  BOOLEAN XGI_XG21CheckCH7007TVMode(USHORT ModeNo,USHORT ModeIdIndex, PVB_DEVICE_INFO pVBInfo ) ;
-extern  void SetCH7007Regs(PXGI_HW_DEVICE_INFO HwDeviceExtension, USHORT ModeNo, USHORT ModeIdIndex, USHORT RefreshRateTableIndex, PVB_DEVICE_INFO  pVBInfo ) ;
-extern  VP_STATUS TurnOnCH7007(PHW_DEVICE_EXTENSION pHWDE) ;
-extern  VP_STATUS TurnOffCH7007(PHW_DEVICE_EXTENSION pHWDE) ;
-extern  BOOLEAN IsCH7007TVMode(PVB_DEVICE_INFO pVBInfo) ;
-#endif
 
 /* USHORT XGINew_flag_clearbuffer; 0: no clear frame buffer 1:clear frame buffer */
 
@@ -479,9 +454,6 @@ BOOLEAN XGISetModeNew( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo )
     XGI_GetVBType( pVBInfo ) ;
 
     InitTo330Pointer( HwDeviceExtension->jChipType, pVBInfo ) ;
-#ifdef WIN2000
-    ReadVBIOSTablData( HwDeviceExtension->jChipType , pVBInfo) ;
-#endif
     if ( ModeNo & 0x80 )
     {
         ModeNo = ModeNo & 0x7F ;
@@ -554,23 +526,6 @@ BOOLEAN XGISetModeNew( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo )
     }	/* !XG20 */
     else
     {
-#ifdef WIN2000
-        if ( pVBInfo->IF_DEF_CH7007 == 1 )
-        {
-
-            VideoDebugPrint((0, "XGISetModeNew: pVBIfo->IF_DEF_CH7007==1\n"));
-            pVBInfo->VBType = VB_CH7007 ;
-            XGI_GetVBInfo(ModeNo , ModeIdIndex , HwDeviceExtension, pVBInfo ) ;
-            XGI_GetTVInfo(ModeNo , ModeIdIndex, pVBInfo ) ;
-            XGI_GetLCDInfo(ModeNo , ModeIdIndex, pVBInfo ) ;
-            if( !(XGI_XG21CheckCH7007TVMode(ModeNo, ModeIdIndex, pVBInfo )) )
-            {
-              return FALSE;
-            }
-        }
-#endif
-
-
         if ( pVBInfo->IF_DEF_LVDS == 1 )
         {
             if ( !XGI_XG21CheckLVDSMode(ModeNo , ModeIdIndex, pVBInfo) )
@@ -757,13 +712,6 @@ void XGI_SetCRT1Group( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo , U
 
     XGI_LoadDAC( ModeNo , ModeIdIndex, pVBInfo ) ;
     /* XGI_ClearBuffer( HwDeviceExtension , ModeNo, pVBInfo ) ; */
-#ifdef WIN2000
-   if ( pVBInfo->IF_DEF_CH7007 == 1 )  /* [Billy]  2007/05/14  */
-   {
-       VideoDebugPrint((0, "XGI_SetCRT1Group: VBInfo->IF_DEF_CH7007==1\n"));
-       SetCH7007Regs(HwDeviceExtension, ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo ) ; /* 07/05/28 */
-   }
-#endif
 }
 
 
@@ -4096,42 +4044,6 @@ BOOLEAN XGI_SearchModeID( USHORT ModeNo , USHORT *ModeIdIndex, PVB_DEVICE_INFO p
 
 #endif
 
-#ifdef WIN2000
-
-    if ( ModeNo <= 5 )
-        ModeNo |= 1 ;
-    if ( ModeNo <= 0x13 )
-    {
-        /* for (*ModeIdIndex=0;*ModeIdIndex<sizeof(pVBInfo->SModeIDTable)/sizeof(XGI_StStruct);(*ModeIdIndex)++) */
-        for( *ModeIdIndex = 0 ; ; ( *ModeIdIndex )++ )
-        {
-            if ( pVBInfo->SModeIDTable[ *ModeIdIndex ].St_ModeID == ModeNo )
-                break ;
-            if ( pVBInfo->SModeIDTable[ *ModeIdIndex ].St_ModeID == 0xFF )
-                return( FALSE ) ;
-        }
-
-        if ( ModeNo == 0x07 )
-            ( *ModeIdIndex )++ ; /* 400 lines */
-
-        if ( ModeNo <=3 )
-            ( *ModeIdIndex ) += 2 ; /* 400 lines */
-        /* else 350 lines */
-    }
-    else
-    {
-        /* for (*ModeIdIndex=0;*ModeIdIndex<sizeof(pVBInfo->EModeIDTable)/sizeof(XGI_ExtStruct);(*ModeIdIndex)++) */
-        for( *ModeIdIndex = 0 ; ; ( *ModeIdIndex )++ )
-        {
-            if ( pVBInfo->EModeIDTable[ *ModeIdIndex ].Ext_ModeID == ModeNo )
-                break ;
-            if ( pVBInfo->EModeIDTable[ *ModeIdIndex ].Ext_ModeID == 0xFF )
-                return( FALSE ) ;
-        }
-    }
-
-#endif
-
 #ifdef LINUX /* chiawen for linux solution */
 
     if ( ModeNo <= 5 )
@@ -4325,12 +4237,6 @@ void XGI_DisplayOn( PXGI_HW_DEVICE_INFO pXGIHWDE , PVB_DEVICE_INFO pVBInfo )
 
     if (pVBInfo->IF_DEF_CH7007 == 1) /* [Billy] 07/05/23 For CH7007 */
     {
-#ifdef WIN2000
-       if ( IsCH7007TVMode( pVBInfo ) )
-       {
-           TurnOnCH7007(pXGIHWDE->pDevice) ; /* 07/05/28 */
-       }
-#endif
 
     }
 
@@ -4386,9 +4292,6 @@ void XGI_DisplayOff( PXGI_HW_DEVICE_INFO pXGIHWDE , PVB_DEVICE_INFO pVBInfo )
     {
        /* if( IsCH7007TVMode( pVBInfo ) == 0 ) */
        {
-#ifdef WIN2000
-         TurnOffCH7007(pXGIHWDE->pDevice) ;  /* 07/05/28 */
-#endif
        }
     }
 
@@ -7949,53 +7852,9 @@ void* XGI_GetTVPtr (USHORT BX,USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRat
 
     if ( table == 0x00 ) /* 07/05/22 */
     {
-#ifdef WIN2000
-        if ( pVBInfo->IF_DEF_CH7007 == 1 )
-        {
-          switch( tempdi[ i ].DATAPTR )
-          {
-            case 0:
-                return &CH7007TVCRT1UNTSC_H[ tempal ] ;
-                break ;
-            case 1:
-                return &CH7007TVCRT1ONTSC_H[ tempal ] ;
-                break ;
-            case 2:
-                return &CH7007TVCRT1UPAL_H[ tempal ] ;
-                break ;
-            case 3:
-                return &CH7007TVCRT1OPAL_H[ tempal ] ;
-                break ;
-            default:
-                break ;
-          }
-        }
-#endif
     }
     else if ( table == 0x01 )
     {
-#ifdef WIN2000
-        if ( pVBInfo->IF_DEF_CH7007 == 1 )
-        {
-          switch( tempdi[ i ].DATAPTR )
-          {
-            case 0:
-                return &CH7007TVCRT1UNTSC_V[ tempal ] ;
-                break ;
-            case 1:
-                return &CH7007TVCRT1ONTSC_V[ tempal ] ;
-                break ;
-            case 2:
-                return &CH7007TVCRT1UPAL_V[ tempal ] ;
-                break ;
-            case 3:
-                return &CH7007TVCRT1OPAL_V[ tempal ] ;
-                break ;
-            default:
-                break ;
-          }
-        }
-#endif
     }
     else if ( table == 0x04 )
     {
@@ -8069,49 +7928,6 @@ void* XGI_GetTVPtr (USHORT BX,USHORT ModeNo,USHORT ModeIdIndex,USHORT RefreshRat
     }
     else if( table == 0x06 )
     {
-#ifdef WIN2000
-        if ( pVBInfo->IF_DEF_CH7007 == 1 )
-        {
-          /* VideoDebugPrint((0, "XGI_GetTVPtr: pVBInfo->IF_DEF_CH7007==1\n")); */
-          switch( tempdi[ i ].DATAPTR )
-          {
-            case 0:
-                return &CH7007TVReg_UNTSC[ tempal ] ;
-                break ;
-            case 1:
-                return &CH7007TVReg_ONTSC[ tempal ] ;
-                break ;
-            case 2:
-                return &CH7007TVReg_UPAL[ tempal ] ;
-                break ;
-            case 3:
-                return &CH7007TVReg_OPAL[ tempal ] ;
-                break ;
-            default:
-                break ;
-          }
-        }
-        else
-        {
-            switch( tempdi[ i ].DATAPTR )
-            {
-              case 0:
-                return &XGI_CHTVRegUNTSC[ tempal ] ;
-                break ;
-              case 1:
-                return &XGI_CHTVRegONTSC[ tempal ] ;
-                break ;
-              case 2:
-                return &XGI_CHTVRegUPAL[ tempal ] ;
-                break ;
-              case 3:
-                return &XGI_CHTVRegOPAL[ tempal ] ;
-                break ;
-              default:
-                break ;
-            }
-        }
-#endif
     }
     return( 0 ) ;
 }
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 87531b4..96fa683 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -16,18 +16,6 @@
 #include <dos.h>
 #endif
 
-#ifdef WIN2000
-#include <dderror.h>
-#include <devioctl.h>
-#include <miniport.h>
-#include <ntddvdeo.h>
-#include <video.h>
-
-#include "xgiv.h"
-#include "dd_i2c.h"
-#include "tools.h"
-#endif
-
 #ifdef LINUX_XF86
 #include "xf86.h"
 #include "xf86PciInfo.h"
@@ -219,9 +207,6 @@ void XGINew_SetRegOR( ULONG Port , USHORT Index , USHORT DataOR )
 /* --------------------------------------------------------------------- */
 void NewDelaySeconds( int seconds )
 {
-#ifdef WIN2000
-    int j ;
-#endif
     int i ;
 
 
@@ -231,17 +216,6 @@ void NewDelaySeconds( int seconds )
         delay( 1000 ) ;
 #endif
 
-#ifdef WIN2000
-
-        for ( j = 0 ; j < 20000 ; j++ )
-            VideoPortStallExecution( 50 ) ;
-#endif
-
-#ifdef WINCE_HEADER
-#endif
-
-#ifdef LINUX_KERNEL
-#endif
     }
 }
 
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 295ea86..5c69710 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -94,8 +94,6 @@ typedef IOADDRESS XGIIOADDRESS;
 #define VBIOS_VER_MAX_LENGTH    4
 #endif
 
-#ifndef WIN2000
-
 #ifndef LINUX_KERNEL   /* For the linux kernel, this is defined in xgifb.h */
 #ifndef XGI_CHIP_TYPE
 typedef enum _XGI_CHIP_TYPE {
@@ -174,8 +172,6 @@ typedef enum _XGI_LCD_TYPE {
 } XGI_LCD_TYPE;
 #endif
 
-#endif   /* not WIN2000 */
-
 #ifndef PXGI_DSReg
 typedef struct _XGI_DSReg
 {
@@ -217,9 +213,9 @@ struct _XGI_HW_DEVICE_INFO
     ULONG  ul2ndVideoMemorySize;
 
     PUCHAR pj2ndIOAddress;
-/*#ifndef WIN2000
+/*
     XGIIOADDRESS pjIOAddress;   //  base I/O address of VGA ports (0x3B0)
-#endif */
+*/
     UCHAR  jChipType;            /* Used to Identify Graphics Chip */
                                  /* defined in the data structure type  */
                                  /* "XGI_CHIP_TYPE" */
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737Ab0FEQF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:05:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35602 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645Ab0FEQFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g0yEDr725nWNO6msX2zEj4z76uIU2PBj3+thzs+1huCbLBHaC4KnHmfOwLiQPNqL4G
         cWs+937vEbIykRWyxnDli0+BznxHEjFJFKC7tHY6/u+/cXE/OX2xTTRAAoEckNWhYI3Z
         zth04yzYjWrJuiAn4CjDS0MG4cVRlJlV2k5xc=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 4/7] Remove X specific code.
Date: Sat,  5 Jun 2010 18:04:22 +0200
Message-Id: <1275753865-5435-5-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/osdef.h      |   23 -----------
 drivers/staging/xgifb/vb_ext.c     |    7 ---
 drivers/staging/xgifb/vb_init.c    |   11 +-----
 drivers/staging/xgifb/vb_setmode.c |   11 -----
 drivers/staging/xgifb/vb_util.c    |   20 ----------
 drivers/staging/xgifb/vgatypes.h   |   74 ------------------------------------
 6 files changed, 1 insertions(+), 145 deletions(-)

diff --git a/drivers/staging/xgifb/osdef.h b/drivers/staging/xgifb/osdef.h
index ec1c32a..4904328 100644
--- a/drivers/staging/xgifb/osdef.h
+++ b/drivers/staging/xgifb/osdef.h
@@ -2,7 +2,6 @@
 #define _OSDEF_H_
 
 #define LINUX_KERNEL
-/* #define LINUX_XF86 */
 
 /**********************************************************************/
 #ifdef LINUX_KERNEL
@@ -11,17 +10,11 @@
 
 
 /**********************************************************************/
-#ifdef LINUX_XF86
-#define LINUX
-#endif
 #ifdef LINUX_KERNEL
 #define LINUX
 #endif
 
 /**********************************************************************/
-#ifdef LINUX_XF86
-#define XGI_SetMemory(MemoryAddress,MemorySize,value) memset(MemoryAddress, value, MemorySize)
-#endif
 #ifdef LINUX_KERNEL
 #define XGI_SetMemory(MemoryAddress,MemorySize,value) memset(MemoryAddress, value, MemorySize)
 #endif
@@ -29,9 +22,6 @@
 
 /**********************************************************************/
 
-#ifdef LINUX_XF86
-#define XGI_MemoryCopy(Destination,Soruce,Length) memcpy(Destination,Soruce,Length)
-#endif
 #ifdef LINUX_KERNEL
 #define XGI_MemoryCopy(Destination,Soruce,Length) memcpy(Destination,Soruce,Length)
 #endif
@@ -62,19 +52,6 @@
 #undef InPortLong
 #endif /* InPortLong */
 
-/**********************************************************************/
-/*  LINUX XF86                                                        */
-/**********************************************************************/
-
-#ifdef LINUX_XF86
-#define OutPortByte(p,v) outb((CARD16)(p),(CARD8)(v))
-#define OutPortWord(p,v) outw((CARD16)(p),(CARD16)(v))
-#define OutPortLong(p,v) outl((CARD16)(p),(CARD32)(v))
-#define InPortByte(p)    inb((CARD16)(p))
-#define InPortWord(p)    inw((CARD16)(p))
-#define InPortLong(p)    inl((CARD16)(p))
-#endif
-
 #ifdef LINUX_KERNEL
 #define OutPortByte(p,v) outb((u8)(v),(p))
 #define OutPortWord(p,v) outw((u16)(v),(p))
diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index 35adffd..c9feb3c 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -1,12 +1,5 @@
 #include "osdef.h"
 
-#ifdef LINUX_XF86
-#include "xf86.h"
-#include "xf86PciInfo.h"
-#include "xgi.h"
-#include "xgi_regs.h"
-#endif
-
 #ifdef LINUX_KERNEL
 #include <linux/version.h>
 #include <asm/io.h>
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index c7f3a45..0483699 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -16,13 +16,6 @@
 #include "vb_init.h"
 #include "vb_ext.h"
 
-#ifdef LINUX_XF86
-#include "xf86.h"
-#include "xf86PciInfo.h"
-#include "xgi.h"
-#include "xgi_regs.h"
-#endif
-
 #ifdef LINUX_KERNEL
 #include <asm/io.h>
 #include <linux/types.h>
@@ -2667,7 +2660,7 @@ void SetPowerConsume ( PXGI_HW_DEVICE_INFO HwDeviceExtension , ULONG XGI_P3d4Por
 
 
 
-#if defined(LINUX_XF86)||defined(LINUX_KERNEL)
+#if defined(LINUX_KERNEL)
 void XGINew_InitVBIOSData(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
 {
 
@@ -3096,9 +3089,7 @@ void XGINew_SetDRAMModeRegister_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension )
 /*
 void XGINew_SetDRAMModeRegister_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension )
 {
-#ifndef LINUX_XF86
     UCHAR data ;
-#endif
     VB_DEVICE_INFO VBINF;
     PVB_DEVICE_INFO pVBInfo = &VBINF;
     pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase ;
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index e7912ea..d7fbcf8 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1,12 +1,5 @@
 #include "osdef.h"
 
-#ifdef LINUX_XF86
-#include "xf86.h"
-#include "xf86PciInfo.h"
-#include "xgi.h"
-#include "xgi_regs.h"
-#endif
-
 #ifdef LINUX_KERNEL
 #include <asm/io.h>
 #include <linux/types.h>
@@ -2603,9 +2596,7 @@ void XGI_ClearBuffer( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo, PVB
     PVOID VideoMemoryAddress = ( PVOID )HwDeviceExtension->pjVideoMemoryAddress ;
     ULONG AdapterMemorySize  = ( ULONG )HwDeviceExtension->ulVideoMemorySize ;
     PUSHORT pBuffer ;
-#ifndef LINUX_XF86
     int i ;
-#endif
 
     if ( pVBInfo->ModeType >= ModeEGA )
     {
@@ -4888,9 +4879,7 @@ UCHAR XGI_GetVCLKPtr(USHORT RefreshRateTableIndex,USHORT ModeNo,USHORT ModeIdInd
 
     USHORT index ,
            modeflag ;
-#ifndef LINUX_XF86
     USHORT tempbx ;
-#endif
 
     UCHAR tempal ;
     UCHAR *CHTVVCLKPtr = NULL ;
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index e88426f..298da77 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -9,16 +9,6 @@
 #include <linux/types.h>
 #endif
 
-#ifdef LINUX_XF86
-#include "xf86.h"
-#include "xf86PciInfo.h"
-#include "xgi.h"
-#include "xgi_regs.h"
-#endif
-
-
-
-
 void XGINew_SetReg1( ULONG , USHORT , USHORT ) ;
 void XGINew_SetReg2( ULONG , USHORT , USHORT ) ;
 void XGINew_SetReg3( ULONG , USHORT ) ;
@@ -40,13 +30,8 @@ void     XGINew_SetRegAND(ULONG Port,USHORT Index,USHORT DataAND);
 /* --------------------------------------------------------------------- */
 void XGINew_SetReg1( ULONG port , USHORT index , USHORT data )
 {
-#ifdef LINUX_XF86
-    OutPortByte( ( PUCHAR )(ULONG)port , index ) ;
-    OutPortByte( ( PUCHAR )(ULONG)port + 1 , data ) ;
-#else
     OutPortByte( port , index ) ;
     OutPortByte( port + 1 , data ) ;
-#endif
 }
 
 
@@ -99,13 +84,8 @@ UCHAR XGINew_GetReg1( ULONG port , USHORT index )
 {
     UCHAR data ;
 
-#ifdef LINUX_XF86
-    OutPortByte( ( PUCHAR )(ULONG)port , index ) ;
-    data = InPortByte( ( PUCHAR )(ULONG)port + 1 ) ;
-#else
     OutPortByte( port , index ) ;
     data = InPortByte( port + 1 ) ;
-#endif
 
     return( data ) ;
 }
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 5c69710..7e95cb5 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -4,11 +4,6 @@
 
 #include "osdef.h"
 
-#ifdef LINUX_XF86
-#include "xf86Version.h"
-#include "xf86Pci.h"
-#endif
-
 #ifdef LINUX_KERNEL  /* We don't want the X driver to depend on kernel source */
 #include <linux/ioctl.h>
 #endif
@@ -81,15 +76,6 @@ typedef UCHAR bool;
 typedef unsigned long XGIIOADDRESS;
 #endif
 
-#ifdef LINUX_XF86
-#if XF86_VERSION_CURRENT < XF86_VERSION_NUMERIC(4,2,0,0,0)
-typedef unsigned char IOADDRESS;
-typedef unsigned char XGIIOADDRESS;
-#else
-typedef IOADDRESS XGIIOADDRESS;
-#endif
-#endif
-
 #ifndef VBIOS_VER_MAX_LENGTH
 #define VBIOS_VER_MAX_LENGTH    4
 #endif
@@ -98,10 +84,6 @@ typedef IOADDRESS XGIIOADDRESS;
 #ifndef XGI_CHIP_TYPE
 typedef enum _XGI_CHIP_TYPE {
     XGI_VGALegacy = 0,
-#ifdef LINUX_XF86
-    XGI_530,
-    XGI_OLD,
-#endif
     XGI_300,
     XGI_630,
     XGI_640,
@@ -190,9 +172,6 @@ struct _XGI_HW_DEVICE_INFO
 {
     ULONG  ulExternalChip;       /* NO VB or other video bridge*/
                                  /* if ujVBChipID = VB_CHIP_UNKNOWN, */
-#ifdef LINUX_XF86
-    PCITAG PciTag;		 /* PCI Tag */
-#endif
 
     PUCHAR  pjVirtualRomBase;    /* ROM image */
 
@@ -264,58 +243,5 @@ struct _XGI_HW_DEVICE_INFO
 };
 #endif
 
-/* Addtional IOCTL for communication xgifb <> X driver        */
-/* If changing this, xgifb.h must also be changed (for xgifb) */
-
-#ifdef LINUX_XF86  /* We don't want the X driver to depend on the kernel source */
-
-/* ioctl for identifying and giving some info (esp. memory heap start) */
-#define XGIFB_GET_INFO    0x80046ef8  /* Wow, what a terrible hack... */
-
-/* Structure argument for XGIFB_GET_INFO ioctl  */
-typedef struct _XGIFB_INFO xgifb_info, *pxgifb_info;
-
-struct _XGIFB_INFO {
-	CARD32 	xgifb_id;         	/* for identifying xgifb */
-#ifndef XGIFB_ID
-#define XGIFB_ID	  0x53495346    /* Identify myself with 'XGIF' */
-#endif
- 	CARD32 	chip_id;		/* PCI ID of detected chip */
-	CARD32	memory;			/* video memory in KB which xgifb manages */
-	CARD32	heapstart;             	/* heap start (= xgifb "mem" argument) in KB */
-	CARD8 	fbvidmode;		/* current xgifb mode */
-
-	CARD8 	xgifb_version;
-	CARD8	xgifb_revision;
-	CARD8 	xgifb_patchlevel;
-
-	CARD8 	xgifb_caps;		/* xgifb's capabilities */
-
-	CARD32 	xgifb_tqlen;		/* turbo queue length (in KB) */
-
-	CARD32 	xgifb_pcibus;      	/* The card's PCI ID */
-	CARD32 	xgifb_pcislot;
-	CARD32 	xgifb_pcifunc;
-
-	CARD8 	xgifb_lcdpdc;
-
-	CARD8	xgifb_lcda;
-
-	CARD32	xgifb_vbflags;
-	CARD32	xgifb_currentvbflags;
-
-	CARD32 	xgifb_scalelcd;
-	CARD32 	xgifb_specialtiming;
-
-	CARD8 	xgifb_haveemi;
-	CARD8 	xgifb_emi30,xgifb_emi31,xgifb_emi32,xgifb_emi33;
-	CARD8 	xgifb_haveemilcd;
-
-	CARD8 	xgifb_lcdpdca;
-
-	CARD8 reserved[212]; 		/* for future use */
-};
-#endif
-
 #endif
 
-- 
1.7.1


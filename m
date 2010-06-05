Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681Ab0FEQFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:05:15 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55125 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933655Ab0FEQFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CIn5nLlGeJd12tykKQcShR8x4l7Wy9JHioRCDlC82bZ1pDfFDaJth5FeUedoP6xqXD
         ayBp/wavToPtH5DMqimRmHSS7ezybgUOfIrj396aKYBd+vryAiLDflh00M6nS1MyZv0s
         NJ1N+lUYh6ZHtE+eIyqnT8zetE0D1yWd5mj3U=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 5/7] Remove linux kernel specific ifdefery since it is now the only platform supported.
Date: Sat,  5 Jun 2010 18:04:23 +0200
Message-Id: <1275753865-5435-6-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    3 ---
 drivers/staging/xgifb/osdef.h       |   25 -------------------------
 drivers/staging/xgifb/vb_def.h      |    2 --
 drivers/staging/xgifb/vb_ext.c      |    4 ----
 drivers/staging/xgifb/vb_init.c     |    8 --------
 drivers/staging/xgifb/vb_setmode.c  |    6 ------
 drivers/staging/xgifb/vb_util.c     |    2 --
 drivers/staging/xgifb/vgatypes.h    |   34 ----------------------------------
 8 files changed, 0 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 8681e0f..7cba7dc 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -164,7 +164,6 @@ struct video_info  xgi_video_info;
 
 /* --------------- Hardware Access Routines -------------------------- */
 
-#ifdef LINUX_KERNEL
 int
 XGIfb_mode_rate_to_dclock(VB_DEVICE_INFO *XGI_Pr, PXGI_HW_DEVICE_INFO HwDeviceExtension,
 			  unsigned char modeno, unsigned char rateindex)
@@ -390,8 +389,6 @@ XGIfb_mode_rate_to_ddata(VB_DEVICE_INFO *XGI_Pr, PXGI_HW_DEVICE_INFO HwDeviceExt
     return 1;
 }
 
-#endif
-
 
 
 void XGIRegInit(VB_DEVICE_INFO *XGI_Pr, ULONG BaseAddr)
diff --git a/drivers/staging/xgifb/osdef.h b/drivers/staging/xgifb/osdef.h
index 4904328..cecce9e 100644
--- a/drivers/staging/xgifb/osdef.h
+++ b/drivers/staging/xgifb/osdef.h
@@ -1,32 +1,9 @@
 #ifndef _OSDEF_H_
 #define _OSDEF_H_
 
-#define LINUX_KERNEL
-
-/**********************************************************************/
-#ifdef LINUX_KERNEL
-//#include <linux/config.h>
-#endif
-
-
-/**********************************************************************/
-#ifdef LINUX_KERNEL
-#define LINUX
-#endif
-
-/**********************************************************************/
-#ifdef LINUX_KERNEL
 #define XGI_SetMemory(MemoryAddress,MemorySize,value) memset(MemoryAddress, value, MemorySize)
-#endif
-/**********************************************************************/
-
-/**********************************************************************/
 
-#ifdef LINUX_KERNEL
 #define XGI_MemoryCopy(Destination,Soruce,Length) memcpy(Destination,Soruce,Length)
-#endif
-
-/**********************************************************************/
 
 #ifdef OutPortByte
 #undef OutPortByte
@@ -52,12 +29,10 @@
 #undef InPortLong
 #endif /* InPortLong */
 
-#ifdef LINUX_KERNEL
 #define OutPortByte(p,v) outb((u8)(v),(p))
 #define OutPortWord(p,v) outw((u16)(v),(p))
 #define OutPortLong(p,v) outl((u32)(v),(p))
 #define InPortByte(p)    inb(p)
 #define InPortWord(p)    inw(p)
 #define InPortLong(p)    inl(p)
-#endif
 #endif // _OSDEF_H_
diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index 17a7ada..e6dacfb 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -6,7 +6,6 @@
 #define NewScratch
 #endif
 /* shampoo */
-#ifdef LINUX_KERNEL
 #define SEQ_ADDRESS_PORT	  0x0014
 #define SEQ_DATA_PORT		  0x0015
 #define MISC_OUTPUT_REG_READ_PORT 0x001C
@@ -17,7 +16,6 @@
 #define CRTC_ADDRESS_PORT_COLOR   0x0024
 #define VIDEO_SUBSYSTEM_ENABLE_PORT 0x0013
 #define PCI_COMMAND		0x04
-#endif
 /* ~shampoo */
 
 
diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index c9feb3c..29ebfcd 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -1,13 +1,9 @@
 #include "osdef.h"
 
-#ifdef LINUX_KERNEL
 #include <linux/version.h>
 #include <asm/io.h>
 #include <linux/types.h>
 #include "XGIfb.h"
-#endif
-
-
 
 #include "vb_def.h"
 #include "vgatypes.h"
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 0483699..0bb3424 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -2,12 +2,10 @@
 #include "vgatypes.h"
 
 
-#ifdef LINUX_KERNEL
 #include <linux/version.h>
 #include <linux/types.h>
 #include <linux/delay.h> /* udelay */
 #include "XGIfb.h"
-#endif
 
 #include "vb_def.h"
 #include "vb_struct.h"
@@ -16,10 +14,8 @@
 #include "vb_init.h"
 #include "vb_ext.h"
 
-#ifdef LINUX_KERNEL
 #include <asm/io.h>
 #include <linux/types.h>
-#endif
 
 
 
@@ -114,12 +110,10 @@ UCHAR    GetXG21FPBits(PVB_DEVICE_INFO pVBInfo);
 void     XGINew_GetXG27Sense(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo) ;
 UCHAR    GetXG27FPBits(PVB_DEVICE_INFO pVBInfo);
 
-#ifdef LINUX_KERNEL
 void DelayUS(ULONG MicroSeconds)
 {
 	udelay(MicroSeconds);
 }
-#endif
 
 /* --------------------------------------------------------------------- */
 /* Function : XGIInitNew */
@@ -2660,7 +2654,6 @@ void SetPowerConsume ( PXGI_HW_DEVICE_INFO HwDeviceExtension , ULONG XGI_P3d4Por
 
 
 
-#if defined(LINUX_KERNEL)
 void XGINew_InitVBIOSData(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo)
 {
 
@@ -2703,7 +2696,6 @@ void XGINew_InitVBIOSData(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 	}
 
 }
-#endif /* For Linux */
 
 /* --------------------------------------------------------------------- */
 /* Function : ReadVBIOSTablData */
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index d7fbcf8..d5ba56d 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1,10 +1,8 @@
 #include "osdef.h"
 
-#ifdef LINUX_KERNEL
 #include <asm/io.h>
 #include <linux/types.h>
 #include "XGIfb.h"
-#endif
 
 #include "vb_def.h"
 #include "vgatypes.h"
@@ -3975,8 +3973,6 @@ BOOLEAN XGI_GetLCDInfo( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBI
 BOOLEAN XGI_SearchModeID( USHORT ModeNo , USHORT *ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
 
-#ifdef LINUX /* chiawen for linux solution */
-
     if ( ModeNo <= 5 )
         ModeNo |= 1 ;
     if ( ModeNo <= 0x13 )
@@ -4009,8 +4005,6 @@ BOOLEAN XGI_SearchModeID( USHORT ModeNo , USHORT *ModeIdIndex, PVB_DEVICE_INFO p
         }
     }
 
-#endif
-
     return( TRUE ) ;
 }
 
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 298da77..43c408e 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -3,11 +3,9 @@
 #include "vgatypes.h"
 #include "vb_struct.h"
 
-#ifdef LINUX_KERNEL
 #include "XGIfb.h"
 #include <asm/io.h>
 #include <linux/types.h>
-#endif
 
 void XGINew_SetReg1( ULONG , USHORT , USHORT ) ;
 void XGINew_SetReg2( ULONG , USHORT , USHORT ) ;
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 7e95cb5..c796121 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -4,9 +4,7 @@
 
 #include "osdef.h"
 
-#ifdef LINUX_KERNEL  /* We don't want the X driver to depend on kernel source */
 #include <linux/ioctl.h>
-#endif
 
 #ifndef FALSE
 #define FALSE   0
@@ -72,44 +70,12 @@ typedef UCHAR BOOLEAN;
 typedef UCHAR bool;
 #endif
 */
-#ifdef LINUX_KERNEL
 typedef unsigned long XGIIOADDRESS;
-#endif
 
 #ifndef VBIOS_VER_MAX_LENGTH
 #define VBIOS_VER_MAX_LENGTH    4
 #endif
 
-#ifndef LINUX_KERNEL   /* For the linux kernel, this is defined in xgifb.h */
-#ifndef XGI_CHIP_TYPE
-typedef enum _XGI_CHIP_TYPE {
-    XGI_VGALegacy = 0,
-    XGI_300,
-    XGI_630,
-    XGI_640,
-    XGI_315H,
-    XGI_315,
-    XGI_315PRO,
-    XGI_550,
-    XGI_650,
-    XGI_650M,
-    XGI_740,
-    XGI_330,
-    XGI_661,
-    XGI_660,
-    XGI_760,
-    XG40 = 32,
-    XG41,
-    XG42,
-    XG45,
-    XG20 = 48,
-    XG21,
-    XG27,
-    MAX_XGI_CHIP
-} XGI_CHIP_TYPE;
-#endif
-#endif
-
 #ifndef XGI_VB_CHIP_TYPE
 typedef enum _XGI_VB_CHIP_TYPE {
     VB_CHIP_Legacy = 0,
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab0FEQFX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:05:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48515 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933661Ab0FEQFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:05:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QG2FkXyBD4i5RHbEwXXM8HOUauvcxDvTkWaJpmnPxfoRA2HkthTBjrVZwmBOHeDJzZ
         qSnIQmn/B38cQsZ0ZHV6j77npOMRjszUoHY0DUtN/OFf2V95vJNklG0e+i8pptEjUGBC
         XjYgOEk5sL62eLKExzPoXfKw3AECNdUt+2aBI=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 6/7] More osdef.h cleanup
Date: Sat,  5 Jun 2010 18:04:24 +0200
Message-Id: <1275753865-5435-7-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/XGI_accel.c   |    1 -
 drivers/staging/xgifb/XGI_main_26.c |    3 ---
 drivers/staging/xgifb/osdef.h       |    4 ----
 drivers/staging/xgifb/vb_ext.c      |    2 --
 drivers/staging/xgifb/vb_init.c     |    2 +-
 drivers/staging/xgifb/vb_setmode.c  |    6 ++----
 drivers/staging/xgifb/vgatypes.h    |    2 --
 7 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_accel.c b/drivers/staging/xgifb/XGI_accel.c
index c42b00d..7b2fc81 100644
--- a/drivers/staging/xgifb/XGI_accel.c
+++ b/drivers/staging/xgifb/XGI_accel.c
@@ -42,7 +42,6 @@
 #include <asm/mtrr.h>
 #endif
 
-#include "osdef.h"
 #include "vgatypes.h"
 #include "vb_struct.h"
 #include "XGIfb.h"
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 7cba7dc..0487a1e 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -30,9 +30,6 @@
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
 
-#include "osdef.h"
-
-
 #ifndef XGIFB_PAN
 #define XGIFB_PAN
 #endif
diff --git a/drivers/staging/xgifb/osdef.h b/drivers/staging/xgifb/osdef.h
index cecce9e..5e4dec5 100644
--- a/drivers/staging/xgifb/osdef.h
+++ b/drivers/staging/xgifb/osdef.h
@@ -1,10 +1,6 @@
 #ifndef _OSDEF_H_
 #define _OSDEF_H_
 
-#define XGI_SetMemory(MemoryAddress,MemorySize,value) memset(MemoryAddress, value, MemorySize)
-
-#define XGI_MemoryCopy(Destination,Soruce,Length) memcpy(Destination,Soruce,Length)
-
 #ifdef OutPortByte
 #undef OutPortByte
 #endif /* OutPortByte */
diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index 29ebfcd..3304101 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -1,5 +1,3 @@
-#include "osdef.h"
-
 #include <linux/version.h>
 #include <asm/io.h>
 #include <linux/types.h>
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 0bb3424..2481bd6 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -175,7 +175,7 @@ if ( !HwDeviceExtension->bIntegratedMMEnabled )
 }
 printk("4");
 
-//    XGI_MemoryCopy( VBIOSVersion , HwDeviceExtension->szVBIOSVer , 4 ) ;
+//    memcpy( VBIOSVersion , HwDeviceExtension->szVBIOSVer , 4 ) ;
 
  //   VBIOSVersion[ 4 ] = 0x0 ;
 
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index d5ba56d..9535aa8 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1,5 +1,3 @@
-#include "osdef.h"
-
 #include <asm/io.h>
 #include <linux/types.h>
 #include "XGIfb.h"
@@ -2602,7 +2600,7 @@ void XGI_ClearBuffer( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo, PVB
         {
             AdapterMemorySize = 0x40000 ;	/* clear 256k */
             /* GetDRAMSize( HwDeviceExtension ) ; */
-            XGI_SetMemory( VideoMemoryAddress , AdapterMemorySize , 0 ) ;
+            memset( VideoMemoryAddress , 0 , AdapterMemorySize ) ;
         }
         else
         {
@@ -2624,7 +2622,7 @@ void XGI_ClearBuffer( PXGI_HW_DEVICE_INFO HwDeviceExtension , USHORT ModeNo, PVB
 */
         }
         else
-            XGI_SetMemory( VideoMemoryAddress , 0x8000 , 0 ) ;
+            memset( VideoMemoryAddress , 0 , 0x8000 ) ;
     }
 }
 
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index c796121..7ca84fe 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -2,8 +2,6 @@
 #ifndef _VGATYPES_
 #define _VGATYPES_
 
-#include "osdef.h"
-
 #include <linux/ioctl.h>
 
 #ifndef FALSE
-- 
1.7.1


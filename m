Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848Ab0FEXeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:34:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48449 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664Ab0FEXd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:33:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dM9qBz41FtgGIe/D4m4ZznAAxDEAo6mTy5NHrD+iaQTCS2ObnZEnfSve9YGJlYOUVy
         t5loBIpuaE9wJe0YHl8BCtlR1V7InSzd/TzA02W86t/my2KKzUSDKLeDRT/aIraNHXkq
         r2Mlm6qEQOdClXZTqDgljtJZkU7LaAUqe8OHQ=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 2/6] kill osdef.h
Date: Sun,  6 Jun 2010 01:33:12 +0200
Message-Id: <1275780796-17751-3-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/osdef.h   |   34 ----------------------------------
 drivers/staging/xgifb/vb_init.c |    5 ++---
 drivers/staging/xgifb/vb_util.c |   29 ++++++++++++++---------------
 3 files changed, 16 insertions(+), 52 deletions(-)
 delete mode 100644 drivers/staging/xgifb/osdef.h

diff --git a/drivers/staging/xgifb/osdef.h b/drivers/staging/xgifb/osdef.h
deleted file mode 100644
index 5e4dec5..0000000
--- a/drivers/staging/xgifb/osdef.h
+++ /dev/null
@@ -1,34 +0,0 @@
-#ifndef _OSDEF_H_
-#define _OSDEF_H_
-
-#ifdef OutPortByte
-#undef OutPortByte
-#endif /* OutPortByte */
-
-#ifdef OutPortWord
-#undef OutPortWord
-#endif /* OutPortWord */
-
-#ifdef OutPortLong
-#undef OutPortLong
-#endif /* OutPortLong */
-
-#ifdef InPortByte
-#undef InPortByte
-#endif /* InPortByte */
-
-#ifdef InPortWord
-#undef InPortWord
-#endif /* InPortWord */
-
-#ifdef InPortLong
-#undef InPortLong
-#endif /* InPortLong */
-
-#define OutPortByte(p,v) outb((u8)(v),(p))
-#define OutPortWord(p,v) outw((u16)(v),(p))
-#define OutPortLong(p,v) outl((u32)(v),(p))
-#define InPortByte(p)    inb(p)
-#define InPortWord(p)    inw(p)
-#define InPortLong(p)    inl(p)
-#endif // _OSDEF_H_
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 2481bd6..b1f3d35 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1,4 +1,3 @@
-#include "osdef.h"
 #include "vgatypes.h"
 
 
@@ -524,8 +523,8 @@ printk("22");
 */
 
 //    base = 0x80000000 ;
-//    OutPortLong( 0xcf8 , base ) ;
-//    Temp = ( InPortLong( 0xcfc ) & 0xFFFF ) ;
+//    outl( (u32)base , 0xcf8 ) ;
+//    Temp = ( inl( 0xcfc ) & 0xFFFF ) ;
 //    if ( Temp == 0x1039 )
 //    {
         XGINew_SetReg1( pVBInfo->P3c4 , 0x22 , ( UCHAR )( ( *pVBInfo->pSR22 ) & 0xFE ) ) ;
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 43c408e..39e55c9 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -1,4 +1,3 @@
-#include "osdef.h"
 #include "vb_def.h"
 #include "vgatypes.h"
 #include "vb_struct.h"
@@ -28,8 +27,8 @@ void     XGINew_SetRegAND(ULONG Port,USHORT Index,USHORT DataAND);
 /* --------------------------------------------------------------------- */
 void XGINew_SetReg1( ULONG port , USHORT index , USHORT data )
 {
-    OutPortByte( port , index ) ;
-    OutPortByte( port + 1 , data ) ;
+    outb( (u8)index , port ) ;
+    outb( (u8)data , port + 1 ) ;
 }
 
 
@@ -41,10 +40,10 @@ void XGINew_SetReg1( ULONG port , USHORT index , USHORT data )
 /* --------------------------------------------------------------------- */
 /*void XGINew_SetReg2( ULONG port , USHORT index , USHORT data )
 {
-    InPortByte( ( PUCHAR )port + 0x3da - 0x3c0 ) ;
-    OutPortByte( XGINew_P3c0 , index ) ;
-    OutPortByte( XGINew_P3c0 , data ) ;
-    OutPortByte( XGINew_P3c0 , 0x20 ) ;
+    inb( ( PUCHAR )port + 0x3da - 0x3c0 ) ;
+    outb( (u8)index , XGINew_P3c0 ) ;
+    outb( (u8)data , XGINew_P3c0 ) ;
+    outb( (u8)0x20 , XGINew_P3c0 ) ;
 }*/
 
 
@@ -56,7 +55,7 @@ void XGINew_SetReg1( ULONG port , USHORT index , USHORT data )
 /* --------------------------------------------------------------------- */
 void XGINew_SetReg3( ULONG port , USHORT data )
 {
-    OutPortByte( port , data ) ;
+    outb( (u8)data , port ) ;
 }
 
 
@@ -68,7 +67,7 @@ void XGINew_SetReg3( ULONG port , USHORT data )
 /* --------------------------------------------------------------------- */
 void XGINew_SetReg4( ULONG port , ULONG data )
 {
-    OutPortLong( port , data ) ;
+    outl( (u32)data , port ) ;
 }
 
 
@@ -82,8 +81,8 @@ UCHAR XGINew_GetReg1( ULONG port , USHORT index )
 {
     UCHAR data ;
 
-    OutPortByte( port , index ) ;
-    data = InPortByte( port + 1 ) ;
+    outb( (u8)index , port ) ;
+    data = inb( port + 1 ) ;
 
     return( data ) ;
 }
@@ -99,7 +98,7 @@ UCHAR XGINew_GetReg2( ULONG port )
 {
     UCHAR data ;
 
-    data = InPortByte( port ) ;
+    data = inb( port ) ;
 
     return( data ) ;
 }
@@ -115,7 +114,7 @@ ULONG XGINew_GetReg3( ULONG port )
 {
     ULONG data ;
 
-    data = InPortLong( port ) ;
+    data = inl( port ) ;
 
     return( data ) ;
 }
@@ -195,8 +194,8 @@ void NewDelaySeconds( int seconds )
 /* --------------------------------------------------------------------- */
 void Newdebugcode( UCHAR code )
 {
-//    OutPortByte ( 0x80 , code ) ;
-    /* OutPortByte ( 0x300 , code ) ; */
+//    outb ( (u8)code , 0x80 ) ;
+    /* outb ( (u8)code , 0x300 ) ; */
     /* NewDelaySeconds( 0x3 ) ; */
 }
 
-- 
1.7.1


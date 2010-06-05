Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab0FEXdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:33:43 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58348 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798Ab0FEXda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UNyuB9L9HoYkyVXWXw+PKvO4GJInD9ML+SVbBdiJORbajra+u8i5Txyay9JLNA6TJq
         ZejlKdv7bkisKSyZcIL8VX4CBNs0VsEVm2g3pVExix2pOzBRGTs16xmovEagZLLlNXr7
         jeQH+OYu98INO62drMtn7K4LRVqi9gtEHiWBE=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 5/6] Kill udelay wrapper
Date: Sun,  6 Jun 2010 01:33:15 +0200
Message-Id: <1275780796-17751-6-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/vb_init.c |  119 +++++++++++++++++++--------------------
 1 files changed, 57 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index b1f3d35..1b1ef8b 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -109,11 +109,6 @@ UCHAR    GetXG21FPBits(PVB_DEVICE_INFO pVBInfo);
 void     XGINew_GetXG27Sense(PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO pVBInfo) ;
 UCHAR    GetXG27FPBits(PVB_DEVICE_INFO pVBInfo);
 
-void DelayUS(ULONG MicroSeconds)
-{
-	udelay(MicroSeconds);
-}
-
 /* --------------------------------------------------------------------- */
 /* Function : XGIInitNew */
 /* Input : */
@@ -603,7 +598,7 @@ UCHAR XGINew_GetXG20DRAMType( PXGI_HW_DEVICE_INFO HwDeviceExtension , PVB_DEVICE
     else if ( HwDeviceExtension->jChipType == XG21 )
     {
         XGINew_SetRegAND( pVBInfo->P3d4 , 0xB4 , ~0x02 ) ;     		/* Independent GPIO control */
-     	DelayUS(800);
+     	udelay(800);
         XGINew_SetRegOR( pVBInfo->P3d4 , 0x4A , 0x80 ) ;		/* Enable GPIOH read */
         temp = XGINew_GetReg1( pVBInfo->P3d4 , 0x48 ) ;       		/* GPIOF 0:DVI 1:DVO */
 // HOTPLUG_SUPPORT
@@ -699,21 +694,21 @@ void XGINew_DDR1x_MRS_340( ULONG P3c4 , PVB_DEVICE_INFO pVBInfo)
 
     if ( *pVBInfo->pXGINew_DRAMTypeDefinition != 0x0C )	/* Samsung F Die */
     {
-        DelayUS( 3000 ) ;	/* Delay 67 x 3 Delay15us */
+        udelay( 3000 ) ;	/* Delay 67 x 3 Delay15us */
         XGINew_SetReg1( P3c4 , 0x18 , 0x00 ) ;
         XGINew_SetReg1( P3c4 , 0x19 , 0x20 ) ;
         XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;
         XGINew_SetReg1( P3c4 , 0x16 , 0x80 ) ;
     }
 
-    DelayUS( 60 ) ;
+    udelay( 60 ) ;
     XGINew_SetReg1( P3c4 , 0x18 , pVBInfo->SR15[ 2 ][ XGINew_RAMType ] ) ;	/* SR18 */
     XGINew_SetReg1( P3c4 , 0x19 , 0x01 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , pVBInfo->SR16[ 0 ] ) ;
     XGINew_SetReg1( P3c4 , 0x16 , pVBInfo->SR16[ 1 ] ) ;
-    DelayUS( 1000 ) ;
+    udelay( 1000 ) ;
     XGINew_SetReg1( P3c4 , 0x1B , 0x03 ) ;
-    DelayUS( 500 ) ;
+    udelay( 500 ) ;
     XGINew_SetReg1( P3c4 , 0x18 , pVBInfo->SR15[ 2 ][ XGINew_RAMType ] ) ;	/* SR18 */
     XGINew_SetReg1( P3c4 , 0x19 , 0x00 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , pVBInfo->SR16[ 2 ] ) ;
@@ -734,15 +729,15 @@ void XGINew_DDR2x_MRS_340( ULONG P3c4 , PVB_DEVICE_INFO pVBInfo)
     XGINew_SetReg1( P3c4 , 0x19 , 0x20 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x80 ) ;
-    DelayUS( 60 ) ;
+    udelay( 60 ) ;
     XGINew_SetReg1( P3c4 , 0x18 , pVBInfo->SR15[ 2 ][ XGINew_RAMType ] ) ;	/* SR18 */
     /* XGINew_SetReg1( P3c4 , 0x18 , 0x31 ) ; */
     XGINew_SetReg1( P3c4 , 0x19 , 0x01 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x05 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x85 ) ;
-    DelayUS( 1000 ) ;
+    udelay( 1000 ) ;
     XGINew_SetReg1( P3c4 , 0x1B , 0x03 ) ;
-    DelayUS( 500 ) ;
+    udelay( 500 ) ;
     /* XGINew_SetReg1( P3c4 , 0x18 , 0x31 ) ; */
     XGINew_SetReg1( P3c4 , 0x18 , pVBInfo->SR15[ 2 ][ XGINew_RAMType ] ) ;	/* SR18 */
     XGINew_SetReg1( P3c4 , 0x19 , 0x00 ) ;
@@ -767,65 +762,65 @@ void XGINew_DDRII_Bootup_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3
     /* XGINew_SetReg1( P3d4 , 0x97 , 0x11 ) ; */		/* CR97 */
     XGINew_SetReg1( P3d4 , 0x97 , *pVBInfo->pXGINew_CR97 ) ;    /* CR97 */
 
-    DelayUS( 200 ) ;
+    udelay( 200 ) ;
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x00 ) ;   /* Set SR18 */ //EMRS2
     XGINew_SetReg1( P3c4 , 0x19 , 0x80 ) ;   /* Set SR19 */
     XGINew_SetReg1( P3c4 , 0x16 , 0x20 ) ;   /* Set SR16 */
-    DelayUS( 15 ) ;
+    udelay( 15 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0xA0 ) ;   /* Set SR16 */
-    DelayUS( 15 ) ;
+    udelay( 15 ) ;
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x00 ) ;   /* Set SR18 */ //EMRS3
     XGINew_SetReg1( P3c4 , 0x19 , 0xC0 ) ;   /* Set SR19 */
     XGINew_SetReg1( P3c4 , 0x16 , 0x20 ) ;   /* Set SR16 */
-    DelayUS( 15 ) ;
+    udelay( 15 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0xA0 ) ;   /* Set SR16 */
-    DelayUS( 15) ;
+    udelay( 15) ;
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x00 ) ;   /* Set SR18 */ //EMRS1
     XGINew_SetReg1( P3c4 , 0x19 , 0x40 ) ;   /* Set SR19 */
     XGINew_SetReg1( P3c4 , 0x16 , 0x20 ) ;   /* Set SR16 */
-    DelayUS( 30 ) ;
+    udelay( 30 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0xA0 ) ;   /* Set SR16 */
-    DelayUS( 15 ) ;
+    udelay( 15 ) ;
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x42 ) ;   /* Set SR18 */ //MRS, DLL Enable
     XGINew_SetReg1( P3c4 , 0x19 , 0x0A ) ;   /* Set SR19 */
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;   /* Set SR16 */
-    DelayUS( 30 ) ;
+    udelay( 30 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;   /* Set SR16 */
     XGINew_SetReg1( P3c4 , 0x16 , 0x80 ) ;   /* Set SR16 */
-    /* DelayUS( 15 ) ; */
+    /* udelay( 15 ) ; */
 
     XGINew_SetReg1( P3c4 , 0x1B , 0x04 ) ;   /* Set SR1B */
-    DelayUS( 60 ) ;
+    udelay( 60 ) ;
     XGINew_SetReg1( P3c4 , 0x1B , 0x00 ) ;   /* Set SR1B */
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x42 ) ;   /* Set SR18 */ //MRS, DLL Reset
     XGINew_SetReg1( P3c4 , 0x19 , 0x08 ) ;   /* Set SR19 */
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;   /* Set SR16 */
 
-    DelayUS( 30 ) ;
+    udelay( 30 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x83 ) ;   /* Set SR16 */
-    DelayUS( 15 ) ;
+    udelay( 15 ) ;
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x80 ) ;   /* Set SR18 */ //MRS, ODT
     XGINew_SetReg1( P3c4 , 0x19 , 0x46 ) ;   /* Set SR19 */
     XGINew_SetReg1( P3c4 , 0x16 , 0x20 ) ;   /* Set SR16 */
-    DelayUS( 30 ) ;
+    udelay( 30 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0xA0 ) ;   /* Set SR16 */
-    DelayUS( 15 ) ;
+    udelay( 15 ) ;
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x00 ) ;   /* Set SR18 */ //EMRS
     XGINew_SetReg1( P3c4 , 0x19 , 0x40 ) ;   /* Set SR19 */
     XGINew_SetReg1( P3c4 , 0x16 , 0x20 ) ;   /* Set SR16 */
-    DelayUS( 30 ) ;
+    udelay( 30 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0xA0 ) ;   /* Set SR16 */
-    DelayUS( 15 ) ;
+    udelay( 15 ) ;
 
     XGINew_SetReg1( P3c4 , 0x1B , 0x04 ) ;   /* Set SR1B refresh control 000:close; 010:open */
-    DelayUS( 200 ) ;
+    udelay( 200 ) ;
 
 
 }
@@ -844,7 +839,7 @@ void XGINew_DDR2_MRS_XG20( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3c4 ,
 
     XGINew_SetReg1( P3d4 , 0x97 , 0x11 ) ;			/* CR97 */
 
-    DelayUS( 200 ) ;
+    udelay( 200 ) ;
     XGINew_SetReg1( P3c4 , 0x18 , 0x00 ) ;			/* EMRS2 */
     XGINew_SetReg1( P3c4 , 0x19 , 0x80 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x05 ) ;
@@ -866,11 +861,11 @@ void XGINew_DDR2_MRS_XG20( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3c4 ,
     XGINew_SetReg1( P3c4 , 0x16 , 0x05 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x85 ) ;
 
-    DelayUS( 15 ) ;
+    udelay( 15 ) ;
     XGINew_SetReg1( P3c4 , 0x1B , 0x04 ) ;			/* SR1B */
-    DelayUS( 30 ) ;
+    udelay( 30 ) ;
     XGINew_SetReg1( P3c4 , 0x1B , 0x00 ) ;			/* SR1B */
-    DelayUS( 100 ) ;
+    udelay( 100 ) ;
 
     //XGINew_SetReg1( P3c4 , 0x18 , 0x52 ) ;			/* MRS2 */
     XGINew_SetReg1( P3c4 , 0x18 , 0x42 ) ;			/* MRS1 */
@@ -878,7 +873,7 @@ void XGINew_DDR2_MRS_XG20( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3c4 ,
     XGINew_SetReg1( P3c4 , 0x16 , 0x05 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x85 ) ;
 
-    DelayUS( 200 ) ;
+    udelay( 200 ) ;
 }
 
 /* --------------------------------------------------------------------- */
@@ -895,19 +890,19 @@ void XGINew_DDR2_MRS_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3c4 ,
      XGINew_SetMemoryClock( HwDeviceExtension , pVBInfo ) ;
 
     XGINew_SetReg1( P3d4 , 0x97 , 0x11 ) ;			/* CR97 */
-    DelayUS( 200 ) ;
+    udelay( 200 ) ;
     XGINew_SetReg1( P3c4 , 0x18 , 0x00 ) ;			/* EMRS2 */
     XGINew_SetReg1( P3c4 , 0x19 , 0x80 ) ;
 
     XGINew_SetReg1( P3c4 , 0x16 , 0x10 ) ;
-    DelayUS( 15 ) ;                          ////06/11/23 XG27 A0 for CKE enable
+    udelay( 15 ) ;                          ////06/11/23 XG27 A0 for CKE enable
     XGINew_SetReg1( P3c4 , 0x16 , 0x90 ) ;
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x00 ) ;			/* EMRS3 */
     XGINew_SetReg1( P3c4 , 0x19 , 0xC0 ) ;
 
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;
-    DelayUS( 15 ) ;                          ////06/11/22 XG27 A0
+    udelay( 15 ) ;                          ////06/11/22 XG27 A0
     XGINew_SetReg1( P3c4 , 0x16 , 0x80 ) ;
 
 
@@ -915,19 +910,19 @@ void XGINew_DDR2_MRS_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3c4 ,
     XGINew_SetReg1( P3c4 , 0x19 , 0x40 ) ;
 
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;
-    DelayUS( 15 ) ;                          ////06/11/22 XG27 A0
+    udelay( 15 ) ;                          ////06/11/22 XG27 A0
     XGINew_SetReg1( P3c4 , 0x16 , 0x80 ) ;
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x42 ) ;			/* MRS1 */
     XGINew_SetReg1( P3c4 , 0x19 , 0x06 ) ;   ////[Billy]06/11/22 DLL Reset for XG27 Hynix DRAM
 
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;
-    DelayUS( 15 ) ;                          ////06/11/23 XG27 A0
+    udelay( 15 ) ;                          ////06/11/23 XG27 A0
     XGINew_SetReg1( P3c4 , 0x16 , 0x80 ) ;
 
-    DelayUS( 30 ) ;                          ////06/11/23 XG27 A0 Start Auto-PreCharge
+    udelay( 30 ) ;                          ////06/11/23 XG27 A0 Start Auto-PreCharge
     XGINew_SetReg1( P3c4 , 0x1B , 0x04 ) ;			/* SR1B */
-    DelayUS( 60 ) ;
+    udelay( 60 ) ;
     XGINew_SetReg1( P3c4 , 0x1B , 0x00 ) ;			/* SR1B */
 
 
@@ -935,26 +930,26 @@ void XGINew_DDR2_MRS_XG27( PXGI_HW_DEVICE_INFO HwDeviceExtension ,  ULONG P3c4 ,
     XGINew_SetReg1( P3c4 , 0x19 , 0x04 ) ;   //// DLL without Reset for XG27 Hynix DRAM
 
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;
-    DelayUS( 30 ) ;
+    udelay( 30 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x80 ) ;
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x80 );     ////XG27 OCD ON
     XGINew_SetReg1( P3c4 , 0x19 , 0x46 );
 
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;
-    DelayUS( 30 ) ;
+    udelay( 30 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x80 ) ;
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x00 );
     XGINew_SetReg1( P3c4 , 0x19 , 0x40 );
 
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;
-    DelayUS( 30 ) ;
+    udelay( 30 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x80 ) ;
 
-    DelayUS( 15 ) ;                         ////Start Auto-PreCharge
+    udelay( 15 ) ;                         ////Start Auto-PreCharge
     XGINew_SetReg1( P3c4 , 0x1B , 0x04 ) ;			/* SR1B */
-    DelayUS( 200 ) ;
+    udelay( 200 ) ;
     XGINew_SetReg1( P3c4 , 0x1B , 0x03 ) ;			/* SR1B */
 
 }
@@ -1612,7 +1607,7 @@ void XGINew_SetDRAMSizingType( int index , USHORT DRAMTYPE_TABLE[][ 5 ] ,PVB_DEV
 
     data = DRAMTYPE_TABLE[ index ][ 4 ] ;
     XGINew_SetRegANDOR( pVBInfo->P3c4 , 0x13 , 0x80 , data ) ;
-    DelayUS( 15 ) ;
+    udelay( 15 ) ;
    /* should delay 50 ns */
 }
 
@@ -2129,7 +2124,7 @@ USHORT XGINew_SetDRAMSize20Reg( int index , USHORT DRAMTYPE_TABLE[][ 5 ], PVB_DE
 
         /* [2004/03/25] Vicent, Fix DRAM Sizing Error */
         XGINew_SetReg1( pVBInfo->P3c4 , 0x14 , ( XGINew_GetReg1( pVBInfo->P3c4 , 0x14 ) & 0x0F ) | ( data & 0xF0 ) ) ;
-	DelayUS( 15 ) ;
+	udelay( 15 ) ;
 
        /* data |= XGINew_ChannelAB << 2 ; */
        /* data |= ( XGINew_DataBusWidth / 64 ) << 1 ; */
@@ -2161,7 +2156,7 @@ int XGINew_ReadWriteRest( USHORT StopAddr , USHORT StartAddr, PVB_DEVICE_INFO pV
         *( ( PULONG )( pVBInfo->FBAddr + Position ) ) = Position ;
     }
 
-    DelayUS( 500 ) ;	/* [Vicent] 2004/04/16. Fix #1759 Memory Size error in Multi-Adapter. */
+    udelay( 500 ) ;	/* [Vicent] 2004/04/16. Fix #1759 Memory Size error in Multi-Adapter. */
 
     Position = 0 ;
 
@@ -2228,7 +2223,7 @@ void XGINew_CheckChannel( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
                 XGINew_DataBusWidth = 32 ;	/* 32 bits */
                 XGINew_SetReg1( pVBInfo->P3c4 , 0x13 , 0xB1 ) ;  /* 22bit + 2 rank + 32bit */
                 XGINew_SetReg1( pVBInfo->P3c4 , 0x14 , 0x52 ) ;
-		DelayUS( 15 ) ;
+		udelay( 15 ) ;
 
                 if ( XGINew_ReadWriteRest( 24 , 23 , pVBInfo ) == 1 )
                     return ;
@@ -2237,7 +2232,7 @@ void XGINew_CheckChannel( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 		{
                   XGINew_SetReg1( pVBInfo->P3c4 , 0x13 , 0x31 ) ;  /* 22bit + 1 rank + 32bit */
                   XGINew_SetReg1( pVBInfo->P3c4 , 0x14 , 0x42 ) ;
-		  DelayUS( 15 ) ;
+		  udelay( 15 ) ;
 
                   if ( XGINew_ReadWriteRest( 23 , 23 , pVBInfo ) == 1 )
                       return ;
@@ -2249,13 +2244,13 @@ void XGINew_CheckChannel( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 	        XGINew_DataBusWidth = 16 ;	/* 16 bits */
                 XGINew_SetReg1( pVBInfo->P3c4 , 0x13 , 0xB1 ) ;  /* 22bit + 2 rank + 16bit */
                 XGINew_SetReg1( pVBInfo->P3c4 , 0x14 , 0x41 ) ;
-		DelayUS( 15 ) ;
+		udelay( 15 ) ;
 
                 if ( XGINew_ReadWriteRest( 23 , 22 , pVBInfo ) == 1 )
                     return ;
                 else
                     XGINew_SetReg1( pVBInfo->P3c4 , 0x13 , 0x31 ) ;
-                    DelayUS( 15 ) ;
+                    udelay( 15 ) ;
               }
 
           }
@@ -2267,7 +2262,7 @@ void XGINew_CheckChannel( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
                 XGINew_DataBusWidth = 16 ;	/* 16 bits */
                 XGINew_SetReg1( pVBInfo->P3c4 , 0x13 , 0xB1 ) ;  /* (0x31:12x8x2) 22bit + 2 rank */
                 XGINew_SetReg1( pVBInfo->P3c4 , 0x14 , 0x41 ) ;  /* 0x41:16Mx16 bit*/
-                DelayUS( 15 ) ;
+                udelay( 15 ) ;
 
                 if ( XGINew_ReadWriteRest( 23 , 22 , pVBInfo ) == 1 )
                     return ;
@@ -2276,7 +2271,7 @@ void XGINew_CheckChannel( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 		{
                   XGINew_SetReg1( pVBInfo->P3c4 , 0x13 , 0x31 ) ;  /* (0x31:12x8x2) 22bit + 1 rank */
                   XGINew_SetReg1( pVBInfo->P3c4 , 0x14 , 0x31 ) ;  /* 0x31:8Mx16 bit*/
-                  DelayUS( 15 ) ;
+                  udelay( 15 ) ;
 
                   if ( XGINew_ReadWriteRest( 22 , 22 , pVBInfo ) == 1 )
                       return ;
@@ -2289,13 +2284,13 @@ void XGINew_CheckChannel( PXGI_HW_DEVICE_INFO HwDeviceExtension, PVB_DEVICE_INFO
 	        XGINew_DataBusWidth = 8 ;	/* 8 bits */
                 XGINew_SetReg1( pVBInfo->P3c4 , 0x13 , 0xB1 ) ;  /* (0x31:12x8x2) 22bit + 2 rank */
                 XGINew_SetReg1( pVBInfo->P3c4 , 0x14 , 0x30 ) ;  /* 0x30:8Mx8 bit*/
-                DelayUS( 15 ) ;
+                udelay( 15 ) ;
 
                 if ( XGINew_ReadWriteRest( 22 , 21 , pVBInfo ) == 1 )
                     return ;
                 else
                     XGINew_SetReg1( pVBInfo->P3c4 , 0x13 , 0x31 ) ;  /* (0x31:12x8x2) 22bit + 1 rank */
-                    DelayUS( 15 ) ;
+                    udelay( 15 ) ;
               }
           }
           break ;
@@ -2968,21 +2963,21 @@ void XGINew_DDR1x_MRS_XG20( ULONG P3c4 , PVB_DEVICE_INFO pVBInfo)
     XGINew_SetReg1( P3c4 , 0x19 , 0x40 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x80 ) ;
-    DelayUS( 60 ) ;
+    udelay( 60 ) ;
 
     XGINew_SetReg1( P3c4 , 0x18 , 0x00 ) ;
     XGINew_SetReg1( P3c4 , 0x19 , 0x40 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x00 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x80 ) ;
-    DelayUS( 60 ) ;
+    udelay( 60 ) ;
     XGINew_SetReg1( P3c4 , 0x18 , pVBInfo->SR15[ 2 ][ XGINew_RAMType ] ) ;	/* SR18 */
     /* XGINew_SetReg1( P3c4 , 0x18 , 0x31 ) ; */
     XGINew_SetReg1( P3c4 , 0x19 , 0x01 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x03 ) ;
     XGINew_SetReg1( P3c4 , 0x16 , 0x83 ) ;
-    DelayUS( 1000 ) ;
+    udelay( 1000 ) ;
     XGINew_SetReg1( P3c4 , 0x1B , 0x03 ) ;
-    DelayUS( 500 ) ;
+    udelay( 500 ) ;
     /* XGINew_SetReg1( P3c4 , 0x18 , 0x31 ) ; */
     XGINew_SetReg1( P3c4 , 0x18 , pVBInfo->SR15[ 2 ][ XGINew_RAMType ] ) ;	/* SR18 */
     XGINew_SetReg1( P3c4 , 0x19 , 0x00 ) ;
-- 
1.7.1


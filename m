Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab0FEKgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 06:36:22 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:3094 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932649Ab0FEKgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 06:36:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJPAPbECUw6B9wNPGdsb2JhbACHb5ZlDAEBAQE1LbAkjUSFFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="77635021"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <kernel.online@gilksonline.com>
Subject: [PATCH 01/12] Fixed checkpatch.pl issues to Line 172
Date: Sat,  5 Jun 2010 18:36:16 +0800
Message-Id: <1275734187-26583-2-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275734187-26583-1-git-send-email-mike.kernel@gilksonline.com>
References: <1275734187-26583-1-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Gilks <kernel.online@gilksonline.com>

---
 drivers/staging/rtl8192u/r8192U_core.c |   95 ++++++++++++++++---------------
 1 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 2bede27..dd42a35 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -25,12 +25,12 @@
  */
 
 #ifndef CONFIG_FORCE_HARD_FLOAT
-double __floatsidf (int i) { return i; }
-unsigned int __fixunsdfsi (double d) { return d; }
-double __adddf3(double a, double b) { return a+b; }
-double __addsf3(float a, float b) { return a+b; }
-double __subdf3(double a, double b) { return a-b; }
-double __extendsfdf2(float a) {return a;}
+double __floatsidf(int i) {return i; }
+unsigned int __fixunsdfsi(double d) {return d; }
+double __adddf3(double a, double b) {return a+b; }
+double __addsf3(float a, float b) {return a+b; }
+double __subdf3(double a, double b) {return a-b; }
+double __extendsfdf2(float a) {return a; }
 #endif
 
 #undef LOOP_TEST
@@ -58,20 +58,20 @@ double __extendsfdf2(float a) {return a;}
 
 #define CONFIG_RTL8192_IO_MAP
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "r8192U_hw.h"
 #include "r8192U.h"
-#include "r8190_rtl8256.h" /* RTL8225 Radio frontend */
-#include "r8180_93cx6.h"   /* Card EEPROM */
+#include "r8190_rtl8256.h"	/* RTL8225 Radio frontend */
+#include "r8180_93cx6.h"	/* Card EEPROM */
 #include "r8192U_wx.h"
-#include "r819xU_phy.h" //added by WB 4.30.2008
+#include "r819xU_phy.h"		/* added by WB 4.30.2008 */
 #include "r819xU_phyreg.h"
 #include "r819xU_cmdpkt.h"
 #include "r8192U_dm.h"
-//#include "r8192xU_phyreg.h"
+/*#include "r8192xU_phyreg.h" */
 #include <linux/usb.h>
 #include <linux/slab.h>
-// FIXME: check if 2.6.7 is ok
+/* FIXME: check if 2.6.7 is ok */
 
 #ifdef CONFIG_RTL8192_PM
 #include "r8192_pm.h"
@@ -80,27 +80,30 @@ double __extendsfdf2(float a) {return a;}
 #ifdef ENABLE_DOT11D
 #include "dot11d.h"
 #endif
-//set here to open your trace code. //WB
-u32 rt_global_debug_component = \
-			//	COMP_INIT    	|
-//				COMP_DBG	|
-			//	COMP_EPROM   	|
-//				COMP_PHY	|
-			//	COMP_RF		|
-//				COMP_FIRMWARE	|
-//				COMP_CH		|
-			//	COMP_POWER_TRACKING |
-//				COMP_RATE	|
-			//	COMP_TXAGC	|
-		//		COMP_TRACE	|
-				COMP_DOWN	|
-		//		COMP_RECV	|
-		//              COMP_SWBW	|
-				COMP_SEC	|
-	//			COMP_RESET	|
-		//		COMP_SEND	|
-			//	COMP_EVENTS	|
-				COMP_ERR ; //always open err flags on
+/* set here to open your trace code. //WB */
+u32 rt_global_debug_component =
+				/*COMP_INIT		|
+				 *COMP_DBG		|
+				 *COMP_EPROM		|
+				 *COMP_PHY		|
+				 *COMP_RF		|
+				 *COMP_FIRMWARE		|
+				 *COMP_CH		|
+				 *COMP_POWER_TRACKING	|
+				 *COMP_RATE		|
+				 *COMP_TXAGC		|
+				 *COMP_TRACE		|
+				 */
+				COMP_DOWN		|
+				/*COMP_RECV		|
+				 *COMP_SWBW		|
+				 */
+				COMP_SEC		|
+				/*COMP_RESET		|
+				 *COMP_SEND		|
+				 *COMP_EVENTS		|
+				 */
+				COMP_ERR ;	/* always open err flags on */
 
 #define TOTAL_CAM_ENTRY 32
 #define CAM_CONTENT_COUNT 8
@@ -129,21 +132,21 @@ MODULE_VERSION("V 1.1");
 MODULE_DEVICE_TABLE(usb, rtl8192_usb_id_tbl);
 MODULE_DESCRIPTION("Linux driver for Realtek RTL8192 USB WiFi cards");
 
-static char* ifname = "wlan%d";
-static int hwwep = 1;  //default use hw. set 0 to use software security
+static char *ifname = "wlan%d";
+static int hwwep = 1;	/* default use hw. set 0 to use software security */
 static int channels = 0x3fff;
 
+module_param(ifname, charp, S_IRUGO|S_IWUSR);
+/*module_param(hwseqnum,int, S_IRUGO|S_IWUSR); */
+module_param(hwwep, int, S_IRUGO|S_IWUSR);
+module_param(channels, int, S_IRUGO|S_IWUSR);
 
-
-module_param(ifname, charp, S_IRUGO|S_IWUSR );
-//module_param(hwseqnum,int, S_IRUGO|S_IWUSR);
-module_param(hwwep,int, S_IRUGO|S_IWUSR);
-module_param(channels,int, S_IRUGO|S_IWUSR);
-
-MODULE_PARM_DESC(ifname," Net interface name, wlan%d=default");
-//MODULE_PARM_DESC(hwseqnum," Try to use hardware 802.11 header sequence numbers. Zero=default");
-MODULE_PARM_DESC(hwwep," Try to use hardware security support. ");
-MODULE_PARM_DESC(channels," Channel bitmask for specific locales. NYI");
+MODULE_PARM_DESC(ifname, " Net interface name, wlan%d=default");
+/*MODULE_PARM_DESC(hwseqnum, " Try to use hardware 802.11 header sequence
+ * numbers. Zero=default");
+ */
+MODULE_PARM_DESC(hwwep, " Try to use hardware security support. ");
+MODULE_PARM_DESC(channels, " Channel bitmask for specific locales. NYI");
 
 static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id);
@@ -160,7 +163,7 @@ static struct usb_driver rtl8192_usb_driver = {
 	.resume		= rtl8192_resume,                 /* PM resume fn  */
 #else
 	.suspend	= NULL,				  /* PM suspend fn */
-	.resume      	= NULL,				  /* PM resume fn  */
+	.resume		= NULL,				  /* PM resume fn  */
 #endif
 };
 
-- 
1.6.3.3


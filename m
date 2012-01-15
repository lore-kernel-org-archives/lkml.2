Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2AOSWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:22:43 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41656 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751927Ab2AOSWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:22:40 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/wPsRt0ffw/tDP88II9n1oI2KKjHNWJ5INk9LuYm
	9aeNv9D0eJXezR
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/4] staging/xgifb: Include sis headers
Date: Sun, 15 Jan 2012 19:22:11 +0100
Message-Id: <1326651733-9242-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1326651733-9242-1-git-send-email-peterhuewe@gmx.de>
References: <1326651733-9242-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes the headers of the sis driver and reorders some
includes.

Since the xgi driver used to redefine a lot of stuff from the sis
driver, we can simply include the headers of the sis driver itself, so
we can remove duplicated stuff later on.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main.h  |    1 +
 drivers/staging/xgifb/XGIfb.h     |    2 +-
 drivers/staging/xgifb/vb_init.c   |    2 +-
 drivers/staging/xgifb/vb_struct.h |    1 +
 drivers/staging/xgifb/vgatypes.h  |    9 +++++++++
 5 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 35f7b2a..fdee421 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -7,6 +7,7 @@
 
 #include "XGIfb.h"
 #include "vb_struct.h"
+#include "../../video/sis/sis.h"
 #include "vb_def.h"
 
 #define XGIFAIL(x) do { printk(x "\n"); return -EINVAL; } while (0)
diff --git a/drivers/staging/xgifb/XGIfb.h b/drivers/staging/xgifb/XGIfb.h
index 2c866bb..37bb730 100644
--- a/drivers/staging/xgifb/XGIfb.h
+++ b/drivers/staging/xgifb/XGIfb.h
@@ -3,8 +3,8 @@
 #include <linux/ioctl.h>
 #include <linux/types.h>
 
-#include "vb_struct.h"
 #include "vgatypes.h"
+#include "vb_struct.h"
 
 enum xgifb_display_type {
 	XGIFB_DISP_NONE = 0,
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 4ccd988..a53a097 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -3,8 +3,8 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 
-#include "vgatypes.h"
 #include "XGIfb.h"
+#include "vgatypes.h"
 
 #include "vb_def.h"
 #include "vb_struct.h"
diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index 6556a0d..d70df04 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -10,6 +10,7 @@ struct XGI_LCDDataStruct {
 	unsigned short LCDVT;
 };
 
+#include "../../video/sis/vstruct.h"
 
 struct XGI_LVDSCRT1HDataStruct {
 	unsigned char Reg[8];
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 9e166bb..a7208e3 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -2,6 +2,9 @@
 #define _VGATYPES_
 
 #include <linux/ioctl.h>
+#include <linux/fb.h>	/* for struct fb_var_screeninfo for sis.h */
+#include "../../video/sis/vgatypes.h"
+#include "../../video/sis/sis.h"		/* for LCD_TYPE */
 
 #ifndef XGI_VB_CHIP_TYPE
 enum XGI_VB_CHIP_TYPE {
@@ -19,6 +22,12 @@ enum XGI_VB_CHIP_TYPE {
 };
 #endif
 
+
+#define XGI_LCD_TYPE
+/* Since the merge with video/sis the LCD_TYPEs are used from
+ drivers/video/sis/sis.h . Nevertheless we keep this (for the moment) for
+ future reference until the code is merged completely and we are sure
+ nothing of this should be added to the sis.h header */
 #ifndef XGI_LCD_TYPE
 enum XGI_LCD_TYPE {
 	LCD_INVALID = 0,
-- 
1.7.3.4


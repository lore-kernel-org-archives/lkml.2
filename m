Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab2FMWYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:24:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43807 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754896Ab2FMWWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:03 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1//9YYgvN7/ER1ZhH7OVvmyTe3apdcOhpCGb239yG
	hPSdKLiALOyoZC
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] staging/xgifb: Remove superfluous header includes
Date: Thu, 14 Jun 2012 00:21:42 +0200
Message-Id: <1339626112-20671-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all unnecessary, redundant and superfluous header
includes from xgifb.

Tested on hp t5325 (XGI Z11)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main.h    |    6 ------
 drivers/staging/xgifb/XGI_main_26.c |   24 ------------------------
 drivers/staging/xgifb/XGIfb.h       |    3 ---
 drivers/staging/xgifb/vb_init.c     |    9 ---------
 drivers/staging/xgifb/vb_setmode.c  |    8 --------
 drivers/staging/xgifb/vb_util.c     |    9 ---------
 drivers/staging/xgifb/vgatypes.h    |    1 -
 7 files changed, 0 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 9c62aeb..ce18f8c 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -1,13 +1,7 @@
 #ifndef _XGIFB_MAIN
 #define _XGIFB_MAIN
-
-
 /* ------------------- Constant Definitions ------------------------- */
-
-
 #include "XGIfb.h"
-#include "vb_struct.h"
-#include "../../video/sis/sis.h"
 #include "vb_def.h"
 
 #define XGIFAIL(x) do { printk(x "\n"); return -EINVAL; } while (0)
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index f427b85..fe36ff430 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -6,36 +6,12 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-/* #include <linux/config.h> */
 #include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/kernel.h>
-#include <linux/spinlock.h>
-#include <linux/errno.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/tty.h>
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/fb.h>
-#include <linux/console.h>
-#include <linux/selection.h>
-#include <linux/ioport.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/vt_kern.h>
-#include <linux/capability.h>
-#include <linux/fs.h>
-#include <linux/types.h>
-#include <linux/proc_fs.h>
-
-#include <linux/io.h>
+
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
 #endif
 
-#include "XGIfb.h"
-#include "vgatypes.h"
 #include "XGI_main.h"
 #include "vb_init.h"
 #include "vb_util.h"
diff --git a/drivers/staging/xgifb/XGIfb.h b/drivers/staging/xgifb/XGIfb.h
index 9068c5a..741bba3 100644
--- a/drivers/staging/xgifb/XGIfb.h
+++ b/drivers/staging/xgifb/XGIfb.h
@@ -1,8 +1,5 @@
 #ifndef _LINUX_XGIFB
 #define _LINUX_XGIFB
-#include <linux/ioctl.h>
-#include <linux/types.h>
-
 #include "vgatypes.h"
 #include "vb_struct.h"
 
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index c222d61..dd6a519 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1,19 +1,10 @@
-#include <linux/types.h>
 #include <linux/delay.h> /* udelay */
-#include <linux/pci.h>
 #include <linux/vmalloc.h>
 
 #include "XGIfb.h"
-#include "vgatypes.h"
-
 #include "vb_def.h"
-#include "vb_struct.h"
 #include "vb_util.h"
 #include "vb_setmode.h"
-#include "vb_init.h"
-
-
-#include <linux/io.h>
 
 static const unsigned short XGINew_DDRDRAM_TYPE340[4][5] = {
 	{ 2, 13, 9, 64, 0x45},
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index b2f4338..ad1e23d 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1,17 +1,9 @@
-
-#include <linux/io.h>
 #include <linux/delay.h>
-#include <linux/types.h>
 #include "XGIfb.h"
 
-
 #include "vb_def.h"
-#include "vgatypes.h"
-#include "vb_struct.h"
-#include "vb_init.h"
 #include "vb_util.h"
 #include "vb_table.h"
-#include "vb_setmode.h"
 
 
 #define  IndexMask 0xff
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index b5c9989..5c93a22 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -1,13 +1,4 @@
-#include <linux/io.h>
-#include <linux/types.h>
-
-#include "vb_def.h"
 #include "vgatypes.h"
-#include "vb_struct.h"
-
-#include "XGIfb.h"
-
-#include "vb_util.h"
 
 void xgifb_reg_set(unsigned long port, u8 index, u8 data)
 {
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 30cdd1a..7fc0719 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -1,7 +1,6 @@
 #ifndef _VGATYPES_
 #define _VGATYPES_
 
-#include <linux/ioctl.h>
 #include <linux/fb.h>	/* for struct fb_var_screeninfo for sis.h */
 #include "../../video/sis/vgatypes.h"
 #include "../../video/sis/sis.h"		/* for LCD_TYPE */
-- 
1.7.3.4


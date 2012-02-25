Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab2BYX62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 18:58:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64465 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2BYX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 18:58:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jorgyano@gmail.com designates 10.101.18.12 as permitted sender) smtp.mail=jorgyano@gmail.com; dkim=pass header.i=jorgyano@gmail.com
Date: Sat, 25 Feb 2012 21:58:21 -0200
From: Jorgyano Vieira <jorgyano@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        jarod@wilsonet.com, nsankar@broadcom.com, dan.carpenter@oracle.com,
        joe@perches.com
Subject: [PATCH 2/2] Staging: crystalhd: Replace the local includes with
 global header
Message-ID: <20120225235821.GA22615@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the local includes with the global header.
So the the crystalhd.h will be the only header included by the other files.

Signed-off-by: Jorgyano Vieira <jorgyano@gmail.com>
---
 drivers/staging/crystalhd/bc_dts_glob_lnx.h |    3 +--
 drivers/staging/crystalhd/crystalhd_cmds.c  |    3 +--
 drivers/staging/crystalhd/crystalhd_cmds.h  |    4 ++--
 drivers/staging/crystalhd/crystalhd_hw.c    |    3 ++-
 drivers/staging/crystalhd/crystalhd_hw.h    |    3 +--
 drivers/staging/crystalhd/crystalhd_lnx.c   |    3 ++-
 drivers/staging/crystalhd/crystalhd_lnx.h   |    5 ++---
 drivers/staging/crystalhd/crystalhd_misc.c  |    5 ++---
 drivers/staging/crystalhd/crystalhd_misc.h  |    4 ++--
 9 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/crystalhd/bc_dts_glob_lnx.h b/drivers/staging/crystalhd/bc_dts_glob_lnx.h
index bbe5119..fd1a6e6 100644
--- a/drivers/staging/crystalhd/bc_dts_glob_lnx.h
+++ b/drivers/staging/crystalhd/bc_dts_glob_lnx.h
@@ -48,8 +48,7 @@
 
 #endif
 
-#include "bc_dts_defs.h"
-#include "bcm_70012_regs.h"	/* Link Register defs */
+#include "crystalhd.h"
 
 #define CRYSTALHD_API_NAME	"crystalhd"
 #define CRYSTALHD_API_DEV_NAME	"/dev/crystalhd"
diff --git a/drivers/staging/crystalhd/crystalhd_cmds.c b/drivers/staging/crystalhd/crystalhd_cmds.c
index 3735ed3..05fe787 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.c
+++ b/drivers/staging/crystalhd/crystalhd_cmds.c
@@ -24,8 +24,7 @@
  * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
  **********************************************************************/
 
-#include "crystalhd_cmds.h"
-#include "crystalhd_hw.h"
+#include "crystalhd.h"
 
 static struct crystalhd_user *bc_cproc_get_uid(struct crystalhd_cmd *ctx)
 {
diff --git a/drivers/staging/crystalhd/crystalhd_cmds.h b/drivers/staging/crystalhd/crystalhd_cmds.h
index f0a2796..4066ba3 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.h
+++ b/drivers/staging/crystalhd/crystalhd_cmds.h
@@ -33,8 +33,8 @@
  *        from _dts_glob and dts_defs etc.. which are defined for
  *        windows.
  */
-#include "crystalhd_misc.h"
-#include "crystalhd_hw.h"
+
+#include "crystalhd.h"
 
 enum crystalhd_state {
 	BC_LINK_INVALID		= 0x00,
diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 2d02ed2..88b538b 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -22,10 +22,11 @@
  * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
  **********************************************************************/
 
+#include "crystalhd.h"
+
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-#include "crystalhd_hw.h"
 
 /* Functions internal to this file */
 
diff --git a/drivers/staging/crystalhd/crystalhd_hw.h b/drivers/staging/crystalhd/crystalhd_hw.h
index 3efbf9d..2d0e6c6 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.h
+++ b/drivers/staging/crystalhd/crystalhd_hw.h
@@ -27,8 +27,7 @@
 #ifndef _CRYSTALHD_HW_H_
 #define _CRYSTALHD_HW_H_
 
-#include "crystalhd_misc.h"
-#include "crystalhd_fw_if.h"
+#include "crystalhd.h"
 
 /* HW constants..*/
 #define DMA_ENGINE_CNT		2
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 9dca92c..d9e3d61 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -15,10 +15,11 @@
   along with this driver.  If not, see <http://www.gnu.org/licenses/>.
 ***************************************************************************/
 
+#include "crystalhd.h"
+
 #include <linux/mutex.h>
 #include <linux/slab.h>
 
-#include "crystalhd_lnx.h"
 
 static DEFINE_MUTEX(chd_dec_mutex);
 static struct class *crystalhd_class;
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index a2b5a56..a81f929 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -1,7 +1,7 @@
 /***************************************************************************
  * Copyright (c) 2005-2009, Broadcom Corporation.
  *
- *  Name: crystalhd_lnx . c
+ *  Name: crystalhd_lnx . h
  *
  *  Description:
  *		BCM70012 Linux driver
@@ -48,11 +48,10 @@
 #include <asm/system.h>
 #include <linux/uaccess.h>
 
-#include "crystalhd_cmds.h"
+#include "crystalhd.h"
 
 #define CRYSTAL_HD_NAME		"Broadcom Crystal HD Decoder (BCM70012) Driver"
 
-
 /* OS specific PCI information structure and adapter information. */
 struct crystalhd_adp {
 	/* Hardware borad/PCI specifics */
diff --git a/drivers/staging/crystalhd/crystalhd_misc.c b/drivers/staging/crystalhd/crystalhd_misc.c
index 5fa0c6e..b3a6378 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.c
+++ b/drivers/staging/crystalhd/crystalhd_misc.c
@@ -24,10 +24,9 @@
  * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
  **********************************************************************/
 
-#include <linux/slab.h>
+#include "crystalhd.h"
 
-#include "crystalhd_misc.h"
-#include "crystalhd_lnx.h"
+#include <linux/slab.h>
 
 uint32_t g_linklog_level;
 
diff --git a/drivers/staging/crystalhd/crystalhd_misc.h b/drivers/staging/crystalhd/crystalhd_misc.h
index d2f7256..84c8793 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.h
+++ b/drivers/staging/crystalhd/crystalhd_misc.h
@@ -28,6 +28,8 @@
 #ifndef _CRYSTALHD_MISC_H_
 #define _CRYSTALHD_MISC_H_
 
+#include "crystalhd.h"
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -35,8 +37,6 @@
 #include <linux/ioctl.h>
 #include <linux/dma-mapping.h>
 #include <linux/sched.h>
-#include <asm/system.h>
-#include "bc_dts_glob_lnx.h"
 
 /* Global log level variable defined in crystal_misc.c file */
 extern uint32_t g_linklog_level;
-- 
1.7.2.5


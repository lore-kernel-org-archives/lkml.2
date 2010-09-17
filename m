Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0IPXik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:38:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34353 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab0IPXii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:38:38 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 3/3] drivers:staging:ti-st: use new ti_wilink_st header
Date: Thu, 16 Sep 2010 20:49:32 -0400
Message-Id: <1284684572-12508-4-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1284684572-12508-3-git-send-email-pavan_savoy@ti.com>
References: <1284684572-12508-1-git-send-email-pavan_savoy@ti.com>
 <1284684572-12508-2-git-send-email-pavan_savoy@ti.com>
 <1284684572-12508-3-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

modify the source files to include the new header ti_wilink_st.h,
also modify the sources to include dependent headers so that inclusion
of ti_wilink_st doesn't cause for compile errors/warnings.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/bt_drv.c  |    2 +-
 drivers/staging/ti-st/st_core.c |   10 +---------
 drivers/staging/ti-st/st_kim.c  |    5 +++--
 drivers/staging/ti-st/st_ll.c   |    4 +++-
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ti-st/bt_drv.c b/drivers/staging/ti-st/bt_drv.c
index 61ae988..50da66d 100644
--- a/drivers/staging/ti-st/bt_drv.c
+++ b/drivers/staging/ti-st/bt_drv.c
@@ -24,7 +24,7 @@
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 
-#include "st.h"
+#include "ti_wilink_st.h"
 #include "bt_drv.h"
 
 /* Define this macro to get debug msg */
diff --git a/drivers/staging/ti-st/st_core.c b/drivers/staging/ti-st/st_core.c
index fad97d7..03397be 100644
--- a/drivers/staging/ti-st/st_core.c
+++ b/drivers/staging/ti-st/st_core.c
@@ -28,15 +28,7 @@
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/hci.h>
-#include "fm.h"
-/*
- * packet formats for fm and gps
- * #include "gps.h"
- */
-#include "st_core.h"
-#include "st_kim.h"
-#include "st_ll.h"
-#include "st.h"
+#include "ti_wilink_st.h"
 
 /* strings to be used for rfkill entries and by
  * ST Core to be used for sysfs debug entry
diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index be18c7a..09e2c97 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -28,15 +28,16 @@
 #include <linux/gpio.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
-
 #include <linux/sched.h>
+#include <linux/rfkill.h>
 
-#include "st_kim.h"
 /* understand BT events for fw response */
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/hci.h>
 
+#include "ti_wilink_st.h"
+
 
 static int kim_probe(struct platform_device *pdev);
 static int kim_remove(struct platform_device *pdev);
diff --git a/drivers/staging/ti-st/st_ll.c b/drivers/staging/ti-st/st_ll.c
index 7a1fb6d..d08b58e 100644
--- a/drivers/staging/ti-st/st_ll.c
+++ b/drivers/staging/ti-st/st_ll.c
@@ -19,7 +19,9 @@
  */
 
 #define pr_fmt(fmt) "(stll) :" fmt
-#include "st_ll.h"
+#include <linux/skbuff.h>
+#include <linux/module.h>
+#include "ti_wilink_st.h"
 
 /**********************************************************************/
 /* internal functions */
-- 
1.6.5


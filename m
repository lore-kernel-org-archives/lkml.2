Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2LYRGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 12:06:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:16881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab2LYRGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 12:06:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,353,1355126400"; 
   d="scan'208";a="184664376"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 05/14] mei: include local headers after the system ones
Date: Tue, 25 Dec 2012 19:06:03 +0200
Message-Id: <1356455172-31959-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1356455172-31959-1-git-send-email-tomas.winkler@intel.com>
References: <1356455172-31959-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

first include linux/mei.h then only local headers
to avoid possible false dependencies

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |    3 +--
 drivers/misc/mei/init.c      |    4 ++--
 drivers/misc/mei/interface.c |    3 ++-
 drivers/misc/mei/interrupt.c |    4 ++--
 drivers/misc/mei/iorw.c      |    4 ++--
 drivers/misc/mei/main.c      |    3 ++-
 drivers/misc/mei/wd.c        |    4 ++--
 7 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 77acd23..bb613f7 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -31,10 +31,9 @@
 #include <linux/jiffies.h>
 #include <linux/uaccess.h>
 
+#include <linux/mei.h>
 
 #include "mei_dev.h"
-#include "hw.h"
-#include <linux/mei.h>
 #include "interface.h"
 
 const uuid_le mei_amthi_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d, 0xac,
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index c0c0b3e..08884ef 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -19,10 +19,10 @@
 #include <linux/wait.h>
 #include <linux/delay.h>
 
+#include <linux/mei.h>
+
 #include "mei_dev.h"
-#include "hw.h"
 #include "interface.h"
-#include <linux/mei.h>
 
 const char *mei_dev_state_str(int state)
 {
diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 17d93f7..810431e 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -15,8 +15,9 @@
  */
 
 #include <linux/pci.h>
-#include "mei_dev.h"
 #include <linux/mei.h>
+
+#include "mei_dev.h"
 #include "interface.h"
 
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index fe93d1c..0a020ad 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -21,9 +21,9 @@
 #include <linux/fs.h>
 #include <linux/jiffies.h>
 
-#include "mei_dev.h"
 #include <linux/mei.h>
-#include "hw.h"
+
+#include "mei_dev.h"
 #include "interface.h"
 
 
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index eb93a1b..7ccc3d8 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -33,9 +33,9 @@
 #include <linux/uaccess.h>
 
 
-#include "mei_dev.h"
-#include "hw.h"
 #include <linux/mei.h>
+
+#include "mei_dev.h"
 #include "interface.h"
 
 /**
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 7751b58..da94260 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -37,8 +37,9 @@
 #include <linux/interrupt.h>
 #include <linux/miscdevice.h>
 
-#include "mei_dev.h"
 #include <linux/mei.h>
+
+#include "mei_dev.h"
 #include "interface.h"
 
 /* AMT device is a singleton on the platform */
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 9d4d4aa..9c3738a 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -21,10 +21,10 @@
 #include <linux/sched.h>
 #include <linux/watchdog.h>
 
+#include <linux/mei.h>
+
 #include "mei_dev.h"
-#include "hw.h"
 #include "interface.h"
-#include <linux/mei.h>
 
 static const u8 mei_start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
 static const u8 mei_stop_wd_params[] = { 0x02, 0x02, 0x14, 0x10 };
-- 
1.7.4.4


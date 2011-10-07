Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab1JGVzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 17:55:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41248 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1JGVzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 17:55:19 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=204/4=5D=20staging=3A=20et131x=3A=20Remove=20file=20et131x=5Fversion=2Eh?=
Date: Fri,  7 Oct 2011 22:53:56 +0100
Message-Id: <1318024436-10331-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed defines in et131x_version.h and replaced them by actual
strings where convinient, or moved them to et131x.h

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_eeprom.c  |    1 -
 drivers/staging/et131x/et1310_mac.c     |    1 -
 drivers/staging/et131x/et1310_phy.c     |    1 -
 drivers/staging/et131x/et1310_pm.c      |    1 -
 drivers/staging/et131x/et1310_rx.c      |    1 -
 drivers/staging/et131x/et1310_tx.c      |    1 -
 drivers/staging/et131x/et131x.h         |    3 +
 drivers/staging/et131x/et131x_ethtool.c |    4 +-
 drivers/staging/et131x/et131x_initpci.c |   11 ++---
 drivers/staging/et131x/et131x_isr.c     |    1 -
 drivers/staging/et131x/et131x_netdev.c  |    1 -
 drivers/staging/et131x/et131x_version.h |   75 -------------------------------
 12 files changed, 10 insertions(+), 91 deletions(-)
 delete mode 100644 drivers/staging/et131x/et131x_version.h

diff --git a/drivers/staging/et131x/et1310_eeprom.c b/drivers/staging/et131x/et1310_eeprom.c
index 747b1dc..20b9660 100644
--- a/drivers/staging/et131x/et1310_eeprom.c
+++ b/drivers/staging/et131x/et1310_eeprom.c
@@ -57,7 +57,6 @@
  *
  */
 
-#include "et131x_version.h"
 #include "et131x_defs.h"
 
 #include <linux/pci.h>
diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index b4c9df1..017ece7 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -57,7 +57,6 @@
  *
  */
 
-#include "et131x_version.h"
 #include "et131x_defs.h"
 
 #include <linux/init.h>
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 145ec76..b809dd4 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -57,7 +57,6 @@
  *
  */
 
-#include "et131x_version.h"
 #include "et131x_defs.h"
 
 #include <linux/pci.h>
diff --git a/drivers/staging/et131x/et1310_pm.c b/drivers/staging/et131x/et1310_pm.c
index a1b72bf..91d47dc 100644
--- a/drivers/staging/et131x/et1310_pm.c
+++ b/drivers/staging/et131x/et1310_pm.c
@@ -57,7 +57,6 @@
  *
  */
 
-#include "et131x_version.h"
 #include "et131x_defs.h"
 
 #include <linux/init.h>
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 600a8f1..814922b 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -57,7 +57,6 @@
  *
  */
 
-#include "et131x_version.h"
 #include "et131x_defs.h"
 
 #include <linux/pci.h>
diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index 2ecb934..cd12500 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -57,7 +57,6 @@
  *
  */
 
-#include "et131x_version.h"
 #include "et131x_defs.h"
 
 #include <linux/pci.h>
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index e832234..24570ca 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -48,6 +48,9 @@
  *
  */
 
+#define DRIVER_NAME "et131x"
+#define DRIVER_VERSION "v2.0"
+
 /* et131x_eeprom.c */
 int et131x_init_eeprom(struct et131x_adapter *adapter);
 
diff --git a/drivers/staging/et131x/et131x_ethtool.c b/drivers/staging/et131x/et131x_ethtool.c
index 903b5a0..ff95a3e 100644
--- a/drivers/staging/et131x/et131x_ethtool.c
+++ b/drivers/staging/et131x/et131x_ethtool.c
@@ -15,7 +15,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-#include "et131x_version.h"
+
 #include "et131x_defs.h"
 
 #include <linux/types.h>
@@ -181,7 +181,7 @@ static void et131x_get_drvinfo(struct net_device *netdev,
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
 	strncpy(info->driver, DRIVER_NAME, ET131X_DRVINFO_LEN);
-	strncpy(info->version, DRIVER_VERSION_STRING, ET131X_DRVINFO_LEN);
+	strncpy(info->version, DRIVER_VERSION, ET131X_DRVINFO_LEN);
 	strncpy(info->bus_info, pci_name(adapter->pdev), ET131X_DRVINFO_LEN);
 }
 
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 2f03ba0..33e50e9 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -59,7 +59,6 @@
  *
  */
 
-#include "et131x_version.h"
 #include "et131x_defs.h"
 
 #include <linux/pci.h>
@@ -944,8 +943,8 @@ static void __exit et131x_cleanup_module(void)
 module_init(et131x_init_module);
 module_exit(et131x_cleanup_module);
 
-/* Modinfo parameters (filled out using defines from et131x_version.h) */
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_AUTHOR(DRIVER_AUTHOR2);
-MODULE_DESCRIPTION(DRIVER_INFO);
-MODULE_LICENSE(DRIVER_LICENSE);
+MODULE_AUTHOR("Victor Soriano <vjsoriano@agere.com>");
+MODULE_AUTHOR("Mark Einon <mark.einon@gmail.com>");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
+		   "for the ET1310 by Agere Systems");
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index bccd0e5..cf8665b 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -58,7 +58,6 @@
  *
  */
 
-#include "et131x_version.h"
 #include "et131x_defs.h"
 
 #include <linux/init.h>
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 16373bb..bcb4756 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -57,7 +57,6 @@
  *
  */
 
-#include "et131x_version.h"
 #include "et131x_defs.h"
 
 #include <linux/init.h>
diff --git a/drivers/staging/et131x/et131x_version.h b/drivers/staging/et131x/et131x_version.h
deleted file mode 100644
index c08b5e5..0000000
--- a/drivers/staging/et131x/et131x_version.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * Agere Systems Inc.
- * 10/100/1000 Base-T Ethernet Driver for the ET1301 and ET131x series MACs
- *
- * Copyright © 2005 Agere Systems Inc.
- * All rights reserved.
- *   http://www.agere.com
- *
- *------------------------------------------------------------------------------
- *
- * et131x_version.h - This file provides system and device version information.
- *
- *------------------------------------------------------------------------------
- *
- * SOFTWARE LICENSE
- *
- * This software is provided subject to the following terms and conditions,
- * which you should read carefully before using the software.  Using this
- * software indicates your acceptance of these terms and conditions.  If you do
- * not agree with these terms and conditions, do not use the software.
- *
- * Copyright © 2005 Agere Systems Inc.
- * All rights reserved.
- *
- * Redistribution and use in source or binary forms, with or without
- * modifications, are permitted provided that the following conditions are met:
- *
- * . Redistributions of source code must retain the above copyright notice, this
- *    list of conditions and the following Disclaimer as comments in the code as
- *    well as in the documentation and/or other materials provided with the
- *    distribution.
- *
- * . Redistributions in binary form must reproduce the above copyright notice,
- *    this list of conditions and the following Disclaimer in the documentation
- *    and/or other materials provided with the distribution.
- *
- * . Neither the name of Agere Systems Inc. nor the names of the contributors
- *    may be used to endorse or promote products derived from this software
- *    without specific prior written permission.
- *
- * Disclaimer
- *
- * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
- * INCLUDING, BUT NOT LIMITED TO, INFRINGEMENT AND THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ANY
- * USE, MODIFICATION OR DISTRIBUTION OF THIS SOFTWARE IS SOLELY AT THE USERS OWN
- * RISK. IN NO EVENT SHALL AGERE SYSTEMS INC. OR CONTRIBUTORS BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, INCLUDING, BUT NOT LIMITED TO, CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
- * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
- *
- */
-
-#ifndef __ET131X_VERSION_H__
-#define __ET131X_VERSION_H__
-
-#define DRIVER_AUTHOR		"Victor Soriano (vjsoriano@agere.com)"
-#define DRIVER_AUTHOR2		"Mark Einon (mark.einon@gmail.com)"
-#define DRIVER_LICENSE		"Dual BSD/GPL"
-#define DRIVER_DEVICE_STRING	"ET1310"
-#define DRIVER_NAME		"et131x"
-#define DRIVER_VERSION_STRING	"1.2.3-lk"
-#define DRIVER_VENDOR		"Agere Systems, http://www.agere.com"
-#define DRIVER_DESC		"10/100/1000 Base-T Ethernet Driver"
-
-#define DRIVER_INFO		DRIVER_DESC " for the "\
-				DRIVER_DEVICE_STRING ", v" \
-				DRIVER_VERSION_STRING " by " \
-				DRIVER_VENDOR
-
-#endif /* __ET131X_VERSION_H__ */
-- 
1.7.6.4


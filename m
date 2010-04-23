Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab0DWIhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:37:36 -0400
Received: from mga06.intel.com ([134.134.136.21]:63135 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750876Ab0DWIhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:37:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,261,1270450800"; 
   d="scan'208";a="511751341"
Date: Fri, 23 Apr 2010 16:26:42 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8192e: Use the standard config option for PM
	functions
Message-ID: <20100423082642.GB14656@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard config option CONFIG_PM to enable rtl8192e PM
functions. Tested on Samsung N140 and it works fine. Without enabling
the PM functions, the box always fails to resume.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
---
 drivers/staging/rtl8192eMakefile      |    1 +
 drivers/staging/rtl8192er8192E_core.c |    4 ++--
 drivers/staging/rtl8192er8192_pm.c    |    6 ++----
 drivers/staging/rtl8192er8192_pm.h    |    4 ----
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8192e/Makefile b/drivers/staging/rtl8192e/Makefile
index e032c3e..41cb4d3 100644
--- a/drivers/staging/rtl8192e/Makefile
+++ b/drivers/staging/rtl8192e/Makefile
@@ -18,6 +18,7 @@ r8192e_pci-objs :=		\
 	r819xE_firmware.o	\
 	r819xE_cmdpkt.o		\
 	r8192E_dm.o		\
+	r8192_pm.o		\
 	ieee80211/ieee80211_rx.o		\
 	ieee80211/ieee80211_softmac.o		\
 	ieee80211/ieee80211_tx.o		\
diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index bb7e1ef..aef820b 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -62,7 +62,7 @@
 //#include <linux/usb.h>
 // FIXME: check if 2.6.7 is ok
 
-#ifdef CONFIG_PM_RTL
+#ifdef CONFIG_PM
 #include "r8192_pm.h"
 #endif
 
@@ -146,7 +146,7 @@ static struct pci_driver rtl8192_pci_driver = {
 	.id_table	= rtl8192_pci_id_tbl,	          /* PCI_ID table  */
 	.probe		= rtl8192_pci_probe,	          /* probe fn      */
 	.remove		= __devexit_p(rtl8192_pci_disconnect),	  /* remove fn     */
-#ifdef CONFIG_PM_RTL
+#ifdef CONFIG_PM
 	.suspend	= rtl8192E_suspend,	          /* PM suspend fn */
 	.resume		= rtl8192E_resume,                 /* PM resume fn  */
 #else
diff --git a/drivers/staging/rtl8192e/r8192_pm.c b/drivers/staging/rtl8192e/r8192_pm.c
index feef29b..521d49f 100644
--- a/drivers/staging/rtl8192e/r8192_pm.c
+++ b/drivers/staging/rtl8192e/r8192_pm.c
@@ -9,8 +9,6 @@
    Released under the terms of GPL (General Public Licence)
 */
 
-#ifdef CONFIG_PM_RTL
-
 #include "r8192E.h"
 #include "r8192E_hw.h"
 #include "r8192_pm.h"
@@ -27,7 +25,9 @@ int rtl8192E_suspend (struct pci_dev *pdev, pm_message_t state)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct r8192_priv *priv = ieee80211_priv(dev);
+#ifdef RTL8190P
 	u8	ucRegRead;
+#endif
 	u32	ulRegRead;
 
         RT_TRACE(COMP_POWER, "============> r8192E suspend call.\n");
@@ -168,5 +168,3 @@ int rtl8192E_enable_wake (struct pci_dev *dev, pm_message_t state, int enable)
 	       state.event, enable);
 	return(-EAGAIN);
 }
-
-#endif //CONFIG_PM_RTL
diff --git a/drivers/staging/rtl8192e/r8192_pm.h b/drivers/staging/rtl8192e/r8192_pm.h
index 68d292b..4da9b46 100644
--- a/drivers/staging/rtl8192e/r8192_pm.h
+++ b/drivers/staging/rtl8192e/r8192_pm.h
@@ -10,8 +10,6 @@
 
 */
 
-#ifdef CONFIG_PM_RTL
-
 #ifndef R8192E_PM_H
 #define R8192E_PM_H
 
@@ -24,5 +22,3 @@ int rtl8192E_resume (struct pci_dev *dev);
 int rtl8192E_enable_wake (struct pci_dev *dev, pm_message_t state, int enable);
 
 #endif //R8192E_PM_H
-
-#endif // CONFIG_PM_RTL

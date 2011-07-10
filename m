Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1GJPg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 11:36:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33989 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab1GJPgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 11:36:22 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 03/10] staging: et131x: Converting et1310_pm.c function and local names from CamelCase
Date: Sun, 10 Jul 2011 16:35:28 +0100
Message-Id: <1310312135-28407-4-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
References: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |    2 +-
 drivers/staging/et131x/et1310_pm.c      |    8 ++++----
 drivers/staging/et131x/et131x.h         |    8 ++++----
 drivers/staging/et131x/et131x_initpci.c |    2 +-
 drivers/staging/et131x/et131x_isr.c     |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index d53656b..72892e0 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -811,7 +811,7 @@ void et131x_mii_check(struct et131x_adapter *etdev,
 			 * plugged back in
 			 */
 			if (etdev->RegistryPhyComa == 1)
-				EnablePhyComa(etdev);
+				et1310_enable_phy_coma(etdev);
 		}
 	}
 
diff --git a/drivers/staging/et131x/et1310_pm.c b/drivers/staging/et131x/et1310_pm.c
index 29d4d66..1bfcc67 100644
--- a/drivers/staging/et131x/et1310_pm.c
+++ b/drivers/staging/et131x/et1310_pm.c
@@ -87,7 +87,7 @@
 #include "et131x.h"
 
 /**
- * EnablePhyComa - called when network cable is unplugged
+ * et1310_enable_phy_coma - called when network cable is unplugged
  * @etdev: pointer to our adapter structure
  *
  * driver receive an phy status change interrupt while in D0 and check that
@@ -106,7 +106,7 @@
  *       indicating linkup status, call the MPDisablePhyComa routine to
  *             restore JAGCore and gigE PHY
  */
-void EnablePhyComa(struct et131x_adapter *etdev)
+void et1310_enable_phy_coma(struct et131x_adapter *etdev)
 {
 	unsigned long flags;
 	u32 pmcsr;
@@ -136,10 +136,10 @@ void EnablePhyComa(struct et131x_adapter *etdev)
 }
 
 /**
- * DisablePhyComa - Disable the Phy Coma Mode
+ * et1310_disable_phy_coma - Disable the Phy Coma Mode
  * @etdev: pointer to our adapter structure
  */
-void DisablePhyComa(struct et131x_adapter *etdev)
+void et1310_disable_phy_coma(struct et131x_adapter *etdev)
 {
 	u32 pmcsr;
 
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index c4f9032..240305e 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -85,11 +85,11 @@ void setup_device_for_unicast(struct et131x_adapter *adapter);
 /* et131x_netdev.c */
 struct net_device *et131x_device_alloc(void);
 
-/* et131x_pm.c */
-void EnablePhyComa(struct et131x_adapter *adapter);
-void DisablePhyComa(struct et131x_adapter *adapter);
+/* et1310_pm.c */
+void et1310_enable_phy_coma(struct et131x_adapter *adapter);
+void et1310_disable_phy_coma(struct et131x_adapter *adapter);
 
-/* et131x_phy.c */
+/* et1310_phy.c */
 void et1310_phy_init(struct et131x_adapter *adapter);
 void et1310_phy_reset(struct et131x_adapter *adapter);
 void et1310_phy_power_down(struct et131x_adapter *adapter, bool down);
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 9b01f22..c39f5f0 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -288,7 +288,7 @@ void et131x_error_timer_handler(unsigned long data)
 				 *  interrupt'. How to do that under Linux?
 				 */
 				et131x_enable_interrupts(etdev);
-				EnablePhyComa(etdev);
+				et1310_enable_phy_coma(etdev);
 			}
 		}
 	}
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 0a810cc..dd952f0 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -379,7 +379,7 @@ void et131x_isr_handler(struct work_struct *work)
 				 * so, disable it because we will not be able
 				 * to read PHY values until we are out.
 				 */
-				DisablePhyComa(etdev);
+				et1310_disable_phy_coma(etdev);
 			}
 
 			/* Read the PHY ISR to clear the reason for the
-- 
1.7.4.4


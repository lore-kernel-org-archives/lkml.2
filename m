Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab0LRSl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 13:41:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52807 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab0LRSlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 13:41:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jxVgiWefk6wr8csdIQ/ukkgfECPWjOPEefaTyp4SVr2N0DLFXwekc5Y95oiYGAD1mr
         w8y+WtNRytiSeSPc8on71RrZ7+vTKptxlKgj9EtUrqd+sp5T5tE5rolWC54a5fDr+4Cc
         IFuqkDxUqM+NgZIlHBOfkm8vLdxqOMXWFFWBg=
From: Jean-Michel Hautbois <jhautbois@gmail.com>
To: davem@davemloft.net
Cc: richard.cochran@omicron.at, shemminger@vyatta.com, tj@kernel.org,
        randy.dunlap@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Michel Hautbois <jhautbois@gmail.com>
Subject: [PATCH 2/2] net: phy: Fixed some checkpatch errors
Date: Sat, 18 Dec 2010 19:41:44 +0100
Message-Id: <1292697704-2886-2-git-send-email-jhautbois@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1292697704-2886-1-git-send-email-jhautbois@gmail.com>
References: <1292697704-2886-1-git-send-email-jhautbois@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes some coding style issues (errors and warnings).

Signed-off-by: Jean-Michel Hautbois <jhautbois@gmail.com>
---
 drivers/net/phy/phy.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 5f23e8e..d6a9b29 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -33,10 +33,10 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 
-#include <asm/atomic.h>
-#include <asm/io.h>
+#include <linux/atomic.h>
+#include <linux/io.h>
 #include <asm/irq.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /**
  * phy_print_status - Convenience function to print out the current phy status
@@ -47,11 +47,11 @@ void phy_print_status(struct phy_device *phydev)
 	pr_info("PHY: %s - Link is %s", dev_name(&phydev->dev),
 			phydev->link ? "Up" : "Down");
 	if (phydev->link)
-		printk(" - %d/%s", phydev->speed,
+		pr_info(" - %d/%s", phydev->speed,
 				DUPLEX_FULL == phydev->duplex ?
 				"Full" : "Half");
 
-	printk("\n");
+	pr_info("\n");
 }
 EXPORT_SYMBOL(phy_print_status);
 
@@ -325,7 +325,7 @@ int phy_mii_ioctl(struct phy_device *phydev,
 
 	case SIOCSMIIREG:
 		if (mii_data->phy_id == phydev->addr) {
-			switch(mii_data->reg_num) {
+			switch (mii_data->reg_num) {
 			case MII_BMCR:
 				if ((val & (BMCR_RESET|BMCR_ANENABLE)) == 0)
 					phydev->autoneg = AUTONEG_DISABLE;
@@ -352,7 +352,7 @@ int phy_mii_ioctl(struct phy_device *phydev,
 		}
 
 		phy_write(phydev, mii_data->reg_num, val);
-		
+
 		if (mii_data->reg_num == MII_BMCR &&
 		    val & BMCR_RESET &&
 		    phydev->drv->config_init) {
@@ -471,7 +471,7 @@ static void phy_force_reduction(struct phy_device *phydev)
 	int idx;
 
 	idx = phy_find_setting(phydev->speed, phydev->duplex);
-	
+
 	idx++;
 
 	idx = phy_find_valid(idx, phydev->supported);
@@ -732,6 +732,7 @@ out_unlock:
 	 * will not reenable interrupts.
 	 */
 }
+EXPORT_SYMBOL(phy_stop);
 
 
 /**
@@ -762,7 +763,6 @@ void phy_start(struct phy_device *phydev)
 	}
 	mutex_unlock(&phydev->lock);
 }
-EXPORT_SYMBOL(phy_stop);
 EXPORT_SYMBOL(phy_start);
 
 /**
@@ -782,7 +782,7 @@ void phy_state_machine(struct work_struct *work)
 	if (phydev->adjust_state)
 		phydev->adjust_state(phydev->attached_dev);
 
-	switch(phydev->state) {
+	switch (phydev->state) {
 		case PHY_DOWN:
 		case PHY_STARTING:
 		case PHY_READY:
-- 
1.7.0.4


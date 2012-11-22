Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab2KVS7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:59:23 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34019 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2KVS7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:59:19 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 4/4] staging/rtl8187se: Use dev_ or pr_ printks in r8180_core.c
Date: Thu, 22 Nov 2012 09:07:04 +0900
Message-Id: <1353542824-21093-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353542753-20986-1-git-send-email-yamanetoshi@gmail.com>
References: <1353542753-20986-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed. 
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ... 
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ... 
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 3119fe6..0aa2a78 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -27,6 +27,8 @@
    Written by Mariusz Matuszek.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #undef RX_DONT_PASS_UL
 #undef DUMMY_RX
 
@@ -116,8 +118,7 @@ static int rtl8180_resume(struct pci_dev *pdev)
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
-				dev->name);
+		dev_err(&pdev->dev, "pci_enable_device failed on resume\n");
 
 		return err;
 	}
@@ -2154,7 +2155,8 @@ void rtl8180_wmm_param_update(struct work_struct *work)
 					write_nic_dword(dev, AC_VO_PARAM, u4bAcParam);
 					break;
 				default:
-					printk(KERN_WARNING "SetHwReg8185():invalid ACI: %d!\n", eACI);
+					pr_warn("SetHwReg8185():invalid ACI: %d!\n",
+						eACI);
 					break;
 				}
 			}
@@ -2193,7 +2195,8 @@ void rtl8180_wmm_param_update(struct work_struct *work)
 				write_nic_dword(dev, AC_VO_PARAM, u4bAcParam);
 				break;
 			default:
-				printk(KERN_WARNING "SetHwReg8185(): invalid ACI: %d !\n", eACI);
+				pr_warn("SetHwReg8185(): invalid ACI: %d !\n",
+					eACI);
 				break;
 			}
 		}
@@ -3339,27 +3342,27 @@ static int __init rtl8180_pci_module_init(void)
 
 	ret = ieee80211_crypto_init();
 	if (ret) {
-		printk(KERN_ERR "ieee80211_crypto_init() failed %d\n", ret);
+		pr_err("ieee80211_crypto_init() failed %d\n", ret);
 		return ret;
 	}
 	ret = ieee80211_crypto_tkip_init();
 	if (ret) {
-		printk(KERN_ERR "ieee80211_crypto_tkip_init() failed %d\n", ret);
+		pr_err("ieee80211_crypto_tkip_init() failed %d\n", ret);
 		return ret;
 	}
 	ret = ieee80211_crypto_ccmp_init();
 	if (ret) {
-		printk(KERN_ERR "ieee80211_crypto_ccmp_init() failed %d\n", ret);
+		pr_err("ieee80211_crypto_ccmp_init() failed %d\n", ret);
 		return ret;
 	}
 	ret = ieee80211_crypto_wep_init();
 	if (ret) {
-		printk(KERN_ERR "ieee80211_crypto_wep_init() failed %d\n", ret);
+		pr_err("ieee80211_crypto_wep_init() failed %d\n", ret);
 		return ret;
 	}
 
-	printk(KERN_INFO "\nLinux kernel driver for RTL8180 / RTL8185 based WLAN cards\n");
-	printk(KERN_INFO "Copyright (c) 2004-2005, Andrea Merello\n");
+	pr_info("\nLinux kernel driver for RTL8180 / RTL8185 based WLAN cards\n");
+	pr_info("Copyright (c) 2004-2005, Andrea Merello\n");
 	DMESG("Initializing module");
 	DMESG("Wireless extensions version %d", WIRELESS_EXT);
 	rtl8180_proc_module_init();
-- 
1.7.9.5


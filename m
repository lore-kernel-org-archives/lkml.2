Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2KTMLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:11:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33589 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab2KTMLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:11:02 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 03/16] staging/rtl8187se: Use pr_ printks in ieee80211/ieee80211_crypt.c
Date: Tue, 20 Nov 2012 21:10:57 +0900
Message-Id: <1353413457-24512-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
References: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
index 934b915..623245c 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
@@ -11,6 +11,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 //#include <linux/config.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -66,8 +68,7 @@ void ieee80211_crypt_deinit_handler(unsigned long data)
 	spin_lock_irqsave(&ieee->lock, flags);
 	ieee80211_crypt_deinit_entries(ieee, 0);
 	if (!list_empty(&ieee->crypt_deinit_list)) {
-		printk(KERN_DEBUG "%s: entries remaining in delayed crypt "
-		       "deletion list\n", ieee->dev->name);
+		pr_debug("entries remaining in delayed crypt deletion list\n");
 		ieee->crypt_deinit_timer.expires = jiffies + HZ;
 		add_timer(&ieee->crypt_deinit_timer);
 	}
@@ -118,8 +119,7 @@ int ieee80211_register_crypto_ops(struct ieee80211_crypto_ops *ops)
 	list_add(&alg->list, &hcrypt->algs);
 	spin_unlock_irqrestore(&hcrypt->lock, flags);
 
-	printk(KERN_DEBUG "ieee80211_crypt: registered algorithm '%s'\n",
-	       ops->name);
+	pr_debug("registered algorithm '%s'\n", ops->name);
 
 	return 0;
 }
@@ -146,8 +146,7 @@ int ieee80211_unregister_crypto_ops(struct ieee80211_crypto_ops *ops)
 	spin_unlock_irqrestore(&hcrypt->lock, flags);
 
 	if (del_alg) {
-		printk(KERN_DEBUG "ieee80211_crypt: unregistered algorithm "
-		       "'%s'\n", ops->name);
+		pr_debug("unregistered algorithm '%s'\n", ops->name);
 		kfree(del_alg);
 	}
 
@@ -234,9 +233,8 @@ void ieee80211_crypto_deinit(void)
 		alg = list_entry(ptr, struct ieee80211_crypto_alg, list);
 		if (alg) {
 			list_del(ptr);
-			printk(KERN_DEBUG
-			       "ieee80211_crypt: unregistered algorithm '%s' (deinit)\n",
-			       alg->ops->name);
+			pr_debug("unregistered algorithm '%s' (deinit)\n",
+				 alg->ops->name);
 			kfree(alg);
 		}
 	}
-- 
1.7.9.5


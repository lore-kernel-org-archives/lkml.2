Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0HRUEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:04:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36878 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab0HRUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NWzVFVl1Xjd0jBWSdFsQjDqnx0yIKtviTSw6zESZiTJvP7x/fcIoAc4LiusSLt7BTh
         XXUM/31cM7eShRCQ+QPvZiHjNr8904Wg7UuMbejFjoBDvWeYwo38Xrw6E6fMbTMwRtW3
         /x9B+YGYEh/7swPf8awFjjSFloRs6wHgZDgps=
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
        Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
        =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, devel@driverdev.osuosl.org
Subject: [PATCH] IEEE 80211 driver: Cleanup style and whitespace
Date: Thu, 19 Aug 2010 01:32:04 +0530
Message-Id: <1282161724-14445-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace C99-style comments with C89-style comments, fix some typos,
and fix whitespace to use only tabs.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |   71 ++++++++++----------
 1 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
index 7edf5c8..08bfdb1 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
@@ -69,7 +69,7 @@ static inline int ieee80211_networks_allocate(struct ieee80211_device *ieee)
 		GFP_KERNEL);
 	if (!ieee->networks) {
 		printk(KERN_WARNING "%s: Out of memory allocating beacons\n",
-		       ieee->dev->name);
+			ieee->dev->name);
 		return -ENOMEM;
 	}
 
@@ -99,7 +99,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 {
 	struct ieee80211_device *ieee;
 	struct net_device *dev;
-	int i,err;
+	int i, err;
 
 	IEEE80211_DEBUG_INFO("Initializing...\n");
 
@@ -111,7 +111,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 
 	ieee = netdev_priv(dev);
 
-	memset(ieee, 0, sizeof(struct ieee80211_device)+sizeof_priv);
+	memset(ieee, 0, sizeof(struct ieee80211_device) + sizeof_priv);
 	ieee->dev = dev;
 
 	err = ieee80211_networks_allocate(ieee);
@@ -142,7 +142,8 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 	spin_lock_init(&ieee->wpax_suitlist_lock);
 	spin_lock_init(&ieee->bw_spinlock);
 	spin_lock_init(&ieee->reorder_spinlock);
-	//added by WB
+
+	/* added by WB */
 	atomic_set(&(ieee->atm_chnlop), 0);
 	atomic_set(&(ieee->atm_swbw), 0);
 
@@ -153,8 +154,8 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
  	ieee->privacy_invoked = 0;
  	ieee->ieee802_1x = 1;
 	ieee->raw_tx = 0;
-	//ieee->hwsec_support = 1; //default support hw security. //use module_param instead.
-	ieee->hwsec_active = 0; //disable hwsec, switch it on when necessary.
+	/* ieee->hwsec_support = 1; default support hw security: use module_param instead */
+	ieee->hwsec_active = 0; /* disable hwsec, switch it on when necessary */
 
 	ieee80211_softmac_init(ieee);
 
@@ -165,25 +166,25 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 		return NULL;
 	}
 	HTUpdateDefaultSetting(ieee);
-	HTInitializeHTInfo(ieee); //may move to other place.
+	HTInitializeHTInfo(ieee); /* may move to other place */
 	TSInitialize(ieee);
 	for (i = 0; i < IEEE_IBSS_MAC_HASH_SIZE; i++)
 		INIT_LIST_HEAD(&ieee->ibss_mac_hash[i]);
 
 	for (i = 0; i < 17; i++) {
-	  ieee->last_rxseq_num[i] = -1;
-	  ieee->last_rxfrag_num[i] = -1;
-	  ieee->last_packet_time[i] = 0;
+		ieee->last_rxseq_num[i] = -1;
+		ieee->last_rxfrag_num[i] = -1;
+		ieee->last_packet_time[i] = 0;
 	}
 
-//These function were added to load crypte module autoly
+	/* Functions to load crypt module automatically */
 	ieee80211_tkip_null();
 	ieee80211_wep_null();
 	ieee80211_ccmp_null();
 
 	return dev;
 
- failed:
+failed:
 	if (dev)
 		free_netdev(dev);
 	return NULL;
@@ -222,35 +223,35 @@ void free_ieee80211(struct net_device *dev)
 
 u32 ieee80211_debug_level = 0;
 static int debug = \
-	//		    IEEE80211_DL_INFO	|
-	//		    IEEE80211_DL_WX	|
-	//		    IEEE80211_DL_SCAN	|
-	//		    IEEE80211_DL_STATE	|
-	//		    IEEE80211_DL_MGMT	|
-	//		    IEEE80211_DL_FRAG	|
-	//		    IEEE80211_DL_EAP	|
-	//		    IEEE80211_DL_DROP	|
-	//		    IEEE80211_DL_TX	|
-	//		    IEEE80211_DL_RX	|
-			    //IEEE80211_DL_QOS    |
-	//		    IEEE80211_DL_HT 	|
-	//		    IEEE80211_DL_TS	|
-//			    IEEE80211_DL_BA 	|
-	//		    IEEE80211_DL_REORDER|
-//			    IEEE80211_DL_TRACE  |
-			    //IEEE80211_DL_DATA	|
-			    IEEE80211_DL_ERR	  //awayls open this flags to show error out
-			    ;
+	/* IEEE80211_DL_INFO	| */
+	/* IEEE80211_DL_WX	| */
+	/* IEEE80211_DL_SCAN	| */
+	/* IEEE80211_DL_STATE	| */
+	/* IEEE80211_DL_MGMT	| */
+	/* IEEE80211_DL_FRAG	| */
+	/* IEEE80211_DL_EAP	| */
+	/* IEEE80211_DL_DROP	| */
+	/* IEEE80211_DL_TX	| */
+	/* IEEE80211_DL_RX	| */
+	/* IEEE80211_DL_QOS     | */
+	/* IEEE80211_DL_HT 	| */
+	/* IEEE80211_DL_TS	| */
+	/* IEEE80211_DL_BA 	| */
+	/* IEEE80211_DL_REORDER | */
+	/* IEEE80211_DL_TRACE   | */
+	/* IEEE80211_DL_DATA	| */
+	IEEE80211_DL_ERR	/* always open this flag to show error out */
+	;
 struct proc_dir_entry *ieee80211_proc = NULL;
 
 static int show_debug_level(char *page, char **start, off_t offset,
-			    int count, int *eof, void *data)
+			int count, int *eof, void *data)
 {
 	return snprintf(page, count, "0x%08X\n", ieee80211_debug_level);
 }
 
 static int store_debug_level(struct file *file, const char *buffer,
-			     unsigned long count, void *data)
+			unsigned long count, void *data)
 {
 	char buf[] = "0x00000000";
 	unsigned long len = min(sizeof(buf) - 1, (u32)count);
@@ -269,7 +270,7 @@ static int store_debug_level(struct file *file, const char *buffer,
 		val = simple_strtoul(p, &p, 10);
 	if (p == buf)
 		printk(KERN_INFO DRV_NAME
-		       ": %s is not in hex or decimal form.\n", buf);
+			": %s is not in hex or decimal form.\n", buf);
 	else
 		ieee80211_debug_level = val;
 
@@ -320,7 +321,7 @@ int __init ieee80211_rtl_init(void)
 		return -EIO;
 	}
 	e = create_proc_entry("debug_level", S_IFREG | S_IRUGO | S_IWUSR,
-			      ieee80211_proc);
+			ieee80211_proc);
 	if (!e) {
 		remove_proc_entry(DRV_NAME, init_net.proc_net);
 		ieee80211_proc = NULL;
-- 
1.7.1


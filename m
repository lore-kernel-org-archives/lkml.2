Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab2FETlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:41:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36152 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2FETlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:41:00 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/2] staging/wlan-ng: cfg80211.c coding style cleanup
Date: Wed,  6 Jun 2012 01:10:50 +0530
Message-Id: <1338925250-23528-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there are warnings that are reported by checkpatch.pl
fixed the following problems

drivers/staging/wlan-ng/cfg80211.c:130: WARNING: line over 80 characters
drivers/staging/wlan-ng/cfg80211.c:366: WARNING: line over 80 characters
drivers/staging/wlan-ng/cfg80211.c:543: WARNING: line over 80 characters
drivers/staging/wlan-ng/cfg80211.c:665: WARNING: line over 80 characters
drivers/staging/wlan-ng/cfg80211.c:692: WARNING: line over 80 characters
drivers/staging/wlan-ng/cfg80211.c:735: WARNING: line over 80 characters

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/wlan-ng/cfg80211.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 8bc562b..fabff4d 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -127,7 +127,9 @@ int prism2_change_virtual_intf(struct wiphy *wiphy,
 	}
 
 	/* Set Operation mode to the PORT TYPE RID */
-	result = prism2_domibset_uint32(wlandev, DIDmib_p2_p2Static_p2CnfPortType, data);
+	result = prism2_domibset_uint32(wlandev,
+					DIDmib_p2_p2Static_p2CnfPortType,
+					data);
 
 	if (result)
 		err = -EFAULT;
@@ -363,7 +365,8 @@ int prism2_scan(struct wiphy *wiphy, struct net_device *dev,
 	if (request->n_ssids > 0) {
 		msg1.scantype.data = P80211ENUM_scantype_active;
 		msg1.ssid.data.len = request->ssids->ssid_len;
-		memcpy(msg1.ssid.data.data, request->ssids->ssid, request->ssids->ssid_len);
+		memcpy(msg1.ssid.data.data,
+			request->ssids->ssid, request->ssids->ssid_len);
 	} else {
 		msg1.scantype.data = 0;
 	}
@@ -540,7 +543,9 @@ int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
 				goto exit;
 			}
 
-			result = prism2_domibset_pstr32(wlandev, did, sme->key_len, (u8 *) sme->key);
+			result = prism2_domibset_pstr32(wlandev,
+							did, sme->key_len,
+							(u8 *)sme->key);
 			if (result)
 				goto exit;
 
@@ -662,10 +667,11 @@ int prism2_get_tx_power(struct wiphy *wiphy, int *dbm)
 	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
 	wlandevice_t *wlandev = priv->wlandev;
 	struct p80211msg_dot11req_mibget msg;
-	p80211item_uint32_t *mibitem = (p80211item_uint32_t *) &msg.mibattribute.data;
+	p80211item_uint32_t *mibitem;
 	int result;
 	int err = 0;
 
+	mibitem = (p80211item_uint32_t *) &msg.mibattribute.data;
 	msg.msgcode = DIDmsg_dot11req_mibget;
 	mibitem->did =
 	    DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel;
@@ -689,7 +695,8 @@ exit:
 /* Interface callback functions, passing data back up to the cfg80211 layer */
 void prism2_connect_result(wlandevice_t *wlandev, u8 failed)
 {
-	u16 status = failed ? WLAN_STATUS_UNSPECIFIED_FAILURE : WLAN_STATUS_SUCCESS;
+	u16 status = failed ?
+		     WLAN_STATUS_UNSPECIFIED_FAILURE : WLAN_STATUS_SUCCESS;
 
 	cfg80211_connect_result(wlandev->netdev, wlandev->bssid,
 				NULL, 0, NULL, 0, status, GFP_KERNEL);
@@ -732,7 +739,8 @@ struct wiphy *wlan_create_wiphy(struct device *dev, wlandevice_t *wlandev)
 {
 	struct wiphy *wiphy;
 	struct prism2_wiphy_private *priv;
-	wiphy = wiphy_new(&prism2_usb_cfg_ops, sizeof(struct prism2_wiphy_private));
+
+	wiphy = wiphy_new(&prism2_usb_cfg_ops, sizeof(*priv));
 	if (!wiphy)
 		return NULL;
 
-- 
1.7.9.5


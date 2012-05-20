Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2ETNbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:31:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38298 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2ETNbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:31:49 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/wlan-ng: Fix the checkpatch warnings
Date: Sun, 20 May 2012 19:01:42 +0530
Message-Id: <1337520702-22961-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/wlan-ng/cfg80211.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 4cd3ba5..999ebfe 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -73,7 +73,9 @@ static int prism2_result2err(int prism2_result)
 static int prism2_domibset_uint32(wlandevice_t *wlandev, u32 did, u32 data)
 {
 	struct p80211msg_dot11req_mibset msg;
-	p80211item_uint32_t *mibitem = (p80211item_uint32_t *) &msg.mibattribute.data;
+	p80211item_uint32_t *mibitem;
+
+	mibitem = (p80211item_uint32_t *) &msg.mibattribute.data;
 
 	msg.msgcode = DIDmsg_dot11req_mibset;
 	mibitem->did = did;
@@ -86,7 +88,9 @@ static int prism2_domibset_pstr32(wlandevice_t *wlandev,
 				  u32 did, u8 len, u8 *data)
 {
 	struct p80211msg_dot11req_mibset msg;
-	p80211item_pstr32_t *mibitem = (p80211item_pstr32_t *) &msg.mibattribute.data;
+	p80211item_pstr32_t *mibitem;
+
+	mibitem = (p80211item_pstr32_t *) &msg.mibattribute.data;
 
 	msg.msgcode = DIDmsg_dot11req_mibset;
 	mibitem->did = did;
@@ -127,7 +131,9 @@ int prism2_change_virtual_intf(struct wiphy *wiphy,
 	}
 
 	/* Set Operation mode to the PORT TYPE RID */
-	result = prism2_domibset_uint32(wlandev, DIDmib_p2_p2Static_p2CnfPortType, data);
+	result = prism2_domibset_uint32(wlandev,
+					DIDmib_p2_p2Static_p2CnfPortType,
+					data);
 
 	if (result)
 		err = -EFAULT;
@@ -180,7 +186,8 @@ int prism2_add_key(struct wiphy *wiphy, struct net_device *dev,
 			goto exit;
 		}
 
-		result = prism2_domibset_pstr32(wlandev, did, params->key_len, params->key);
+		result = prism2_domibset_pstr32(wlandev, did,
+						params->key_len, params->key);
 		if (result)
 			goto exit;
 		break;
@@ -362,7 +369,9 @@ int prism2_scan(struct wiphy *wiphy, struct net_device *dev,
 	if (request->n_ssids > 0) {
 		msg1.scantype.data = P80211ENUM_scantype_active;
 		msg1.ssid.data.len = request->ssids->ssid_len;
-		memcpy(msg1.ssid.data.data, request->ssids->ssid, request->ssids->ssid_len);
+		memcpy(msg1.ssid.data.data,
+		       request->ssids->ssid,
+		       request->ssids->ssid_len);
 	} else {
 		msg1.scantype.data = 0;
 	}
@@ -532,7 +541,8 @@ int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
 				goto exit;
 			}
 
-			result = prism2_domibset_pstr32(wlandev, did, sme->key_len, (u8 *) sme->key);
+			result = prism2_domibset_pstr32(wlandev, did,
+							sme->key_len, (u8 *) sme->key);
 			if (result)
 				goto exit;
 
@@ -681,7 +691,8 @@ exit:
 /* Interface callback functions, passing data back up to the cfg80211 layer */
 void prism2_connect_result(wlandevice_t *wlandev, u8 failed)
 {
-	u16 status = failed ? WLAN_STATUS_UNSPECIFIED_FAILURE : WLAN_STATUS_SUCCESS;
+	u16 status = failed ? WLAN_STATUS_UNSPECIFIED_FAILURE
+			    : WLAN_STATUS_SUCCESS;
 
 	cfg80211_connect_result(wlandev->netdev, wlandev->bssid,
 				NULL, 0, NULL, 0, status, GFP_KERNEL);
@@ -724,7 +735,7 @@ struct wiphy *wlan_create_wiphy(struct device *dev, wlandevice_t *wlandev)
 {
 	struct wiphy *wiphy;
 	struct prism2_wiphy_private *priv;
-	wiphy = wiphy_new(&prism2_usb_cfg_ops, sizeof(struct prism2_wiphy_private));
+	wiphy = wiphy_new(&prism2_usb_cfg_ops, sizeof(*priv));
 	if (!wiphy)
 		return NULL;
 
-- 
1.7.9.5


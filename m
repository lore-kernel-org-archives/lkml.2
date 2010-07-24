Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0GXPyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 11:54:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46639 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0GXPyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 11:54:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mQ8S2I/igc/Vd3C4dlMPAlYLz0AH047Y5JPJq/mY4ZtVLP7SWwdg2QEEfgBOs6H+bA
         qEFTeNKcoPDfgwuoFUrMi3LsN4WxYWfZyoStI2alW9pV7RSDVgPnvSkr9ZPXQcBDJyrq
         urVkymbwr0/Xh6gYexMJvOzxVyaHouSwxQjwc=
From: Edgardo Hames <ehames@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, ehames@gmail.com
Subject: [PATCH] Staging: wlan-ng: fix style in cfg80211.c
Date: Sat, 24 Jul 2010 12:50:15 -0300
Message-Id: <1279986615-7719-1-git-send-email-ehames@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed several errors reported by checkpatch.

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/cfg80211.c |  219 ++++++++++++++++++++----------------
 1 files changed, 122 insertions(+), 97 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index b0792f7..9488c52 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -79,7 +79,7 @@ static int prism2_domibset_uint32(wlandevice_t *wlandev, u32 did, u32 data)
 	mibitem->did = did;
 	mibitem->data = data;
 
-	return p80211req_dorequest(wlandev, (u8 *) & msg);
+	return p80211req_dorequest(wlandev, (u8 *) &msg);
 }
 
 static int prism2_domibset_pstr32(wlandevice_t *wlandev,
@@ -93,7 +93,7 @@ static int prism2_domibset_pstr32(wlandevice_t *wlandev,
 	mibitem->data.len = len;
 	memcpy(mibitem->data.data, data, len);
 
-	return p80211req_dorequest(wlandev, (u8 *) & msg);
+	return p80211req_dorequest(wlandev, (u8 *) &msg);
 }
 
 
@@ -110,12 +110,14 @@ int prism2_change_virtual_intf(struct wiphy *wiphy,
 
 	switch (type) {
 	case NL80211_IFTYPE_ADHOC:
-		if (wlandev->macmode == WLAN_MACMODE_IBSS_STA) goto exit;
+		if (wlandev->macmode == WLAN_MACMODE_IBSS_STA)
+			goto exit;
 		wlandev->macmode = WLAN_MACMODE_IBSS_STA;
 		data = 0;
 		break;
 	case NL80211_IFTYPE_STATION:
-		if (wlandev->macmode == WLAN_MACMODE_ESS_STA) goto exit;
+		if (wlandev->macmode == WLAN_MACMODE_ESS_STA)
+			goto exit;
 		wlandev->macmode = WLAN_MACMODE_ESS_STA;
 		data = 1;
 		break;
@@ -129,7 +131,7 @@ int prism2_change_virtual_intf(struct wiphy *wiphy,
 
 	if (result)
 		err = -EFAULT;
-    
+
 	dev->ieee80211_ptr->iftype = type;
 
 exit:
@@ -138,7 +140,8 @@ exit:
 
 int prism2_add_key(struct wiphy *wiphy, struct net_device *dev,
 		   u8 key_index, const u8 *mac_addr,
-		   struct key_params *params) {
+		   struct key_params *params)
+{
 	wlandevice_t *wlandev = dev->ml_priv;
 	u32 did;
 
@@ -149,30 +152,27 @@ int prism2_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		result = prism2_domibset_uint32(wlandev,
-			DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
-			key_index);
-		if (result) goto exit;
+						DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
+						key_index);
+		if (result)
+			goto exit;
 
 		/* send key to driver */
 		switch (key_index) {
 		case 0:
-			did =
-			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey0;
+			did = DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey0;
 			break;
 
 		case 1:
-			did =
-			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey1;
+			did = DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey1;
 			break;
 
 		case 2:
-			did =
-			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey2;
+			did = DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey2;
 			break;
 
 		case 3:
-			did =
-			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey3;
+			did = DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey3;
 			break;
 
 		default:
@@ -181,7 +181,8 @@ int prism2_add_key(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		result = prism2_domibset_pstr32(wlandev, did, params->key_len, params->key);
-		if (result) goto exit;
+		if (result)
+			goto exit;
 		break;
 
 	default:
@@ -190,37 +191,43 @@ int prism2_add_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 exit:
-	if (result) err = -EFAULT;
+	if (result)
+		err = -EFAULT;
 
 	return err;
 }
 
 int prism2_get_key(struct wiphy *wiphy, struct net_device *dev,
 		   u8 key_index, const u8 *mac_addr, void *cookie,
-		   void (*callback)(void *cookie, struct key_params*)) {
+		   void (*callback)(void *cookie, struct key_params*))
+{
 	wlandevice_t *wlandev = dev->ml_priv;
 	struct key_params params;
 	int len;
 
-	if(key_index >= NUM_WEPKEYS) return -EINVAL;
+	if (key_index >= NUM_WEPKEYS)
+		return -EINVAL;
 
 	len = wlandev->wep_keylens[key_index];
 	memset(&params, 0, sizeof(params));
 
-	if (len == 13) {
+	if (len == 13)
 		params.cipher = WLAN_CIPHER_SUITE_WEP104;
-	} else if (len == 5) {
+	else if (len == 5)
 		params.cipher = WLAN_CIPHER_SUITE_WEP104;
-	} else return -ENOENT;
+	else
+		return -ENOENT;
 	params.key_len = len;
 	params.key = wlandev->wep_keys[key_index];
 
 	callback(cookie, &params);
+
 	return 0;
 }
 
 int prism2_del_key(struct wiphy *wiphy, struct net_device *dev,
-		   u8 key_index, const u8 *mac_addr) {
+		   u8 key_index, const u8 *mac_addr)
+{
 	wlandevice_t *wlandev = dev->ml_priv;
 	u32 did;
 	int err = 0;
@@ -258,13 +265,15 @@ int prism2_del_key(struct wiphy *wiphy, struct net_device *dev,
 	result = prism2_domibset_pstr32(wlandev, did, 13, "0000000000000");
 
 exit:
-	if (result) err = -EFAULT;
+	if (result)
+		err = -EFAULT;
 
 	return err;
 }
 
 int prism2_set_default_key(struct wiphy *wiphy, struct net_device *dev,
-			   u8 key_index) {
+			   u8 key_index)
+{
 	wlandevice_t *wlandev = dev->ml_priv;
 
 	int err = 0;
@@ -274,14 +283,16 @@ int prism2_set_default_key(struct wiphy *wiphy, struct net_device *dev,
 		DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
 		key_index);
 
-	if (result) err = -EFAULT;
+	if (result)
+		err = -EFAULT;
 
 	return err;
 }
 
 
 int prism2_get_station(struct wiphy *wiphy, struct net_device *dev,
-		       u8 *mac, struct station_info *sinfo) {
+		       u8 *mac, struct station_info *sinfo)
+{
 	wlandevice_t *wlandev = dev->ml_priv;
 	p80211msg_lnxreq_commsquality_t quality;
 	int result;
@@ -300,7 +311,7 @@ int prism2_get_station(struct wiphy *wiphy, struct net_device *dev,
 	if (wlandev->mlmerequest == NULL)
 		return -EOPNOTSUPP;
 
-	result = wlandev->mlmerequest(wlandev, (p80211msg_t *) & quality);
+	result = wlandev->mlmerequest(wlandev, (p80211msg_t *) &quality);
 
 
 	if (result == 0) {
@@ -314,7 +325,7 @@ int prism2_get_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 int prism2_scan(struct wiphy *wiphy, struct net_device *dev,
-	       struct cfg80211_scan_request *request)
+		struct cfg80211_scan_request *request)
 {
 	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
 	wlandevice_t *wlandev = dev->ml_priv;
@@ -401,9 +412,8 @@ int prism2_scan(struct wiphy *wiphy, struct net_device *dev,
 		);
 	}
 
-	if (result) {
+	if (result)
 		err = prism2_result2err(msg2.resultcode.data);
-	}
 
 exit:
 	cfg80211_scan_done(request, err ? 1 : 0);
@@ -411,7 +421,8 @@ exit:
 	return err;
 }
 
-int prism2_set_wiphy_params(struct wiphy *wiphy, u32 changed) {
+int prism2_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
 	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
 	wlandevice_t *wlandev = priv->wlandev;
 	u32 data;
@@ -424,10 +435,9 @@ int prism2_set_wiphy_params(struct wiphy *wiphy, u32 changed) {
 		else
 			data = wiphy->rts_threshold;
 
-		result =
-			prism2_domibset_uint32(wlandev,
-				DIDmib_dot11mac_dot11OperationTable_dot11RTSThreshold,
-				data);
+		result = prism2_domibset_uint32(wlandev,
+						DIDmib_dot11mac_dot11OperationTable_dot11RTSThreshold,
+						data);
 		if (result) {
 			err = -EFAULT;
 			goto exit;
@@ -435,16 +445,14 @@ int prism2_set_wiphy_params(struct wiphy *wiphy, u32 changed) {
 	}
 
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
-			
 		if (wiphy->frag_threshold == -1)
 			data = 2346;
 		else
 			data = wiphy->frag_threshold;
 
-		result =
-			prism2_domibset_uint32(wlandev,
-				DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold,
-				data);
+		result = prism2_domibset_uint32(wlandev,
+						DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold,
+						data);
 		if (result) {
 			err = -EFAULT;
 			goto exit;
@@ -456,7 +464,8 @@ exit:
 }
 
 int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
-		   struct cfg80211_connect_params *sme) {
+		   struct cfg80211_connect_params *sme)
+{
 	wlandevice_t *wlandev = dev->ml_priv;
 	struct ieee80211_channel *channel = sme->channel;
 	p80211msg_lnxreq_autojoin_t msg_join;
@@ -471,13 +480,11 @@ int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
 	/* Set the channel */
 	if (channel) {
 		chan = ieee80211_frequency_to_channel(channel->center_freq);
-		
-		result =
-			prism2_domibset_uint32(wlandev,
-				DIDmib_dot11phy_dot11PhyDSSSTable_dot11CurrentChannel,
-				chan);
-
-		if (result) goto exit;
+		result = prism2_domibset_uint32(wlandev,
+						DIDmib_dot11phy_dot11PhyDSSSTable_dot11CurrentChannel,
+						chan);
+		if (result)
+			goto exit;
 	}
 
 	/* Set the authorisation */
@@ -487,37 +494,36 @@ int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
 	else if ((sme->auth_type == NL80211_AUTHTYPE_SHARED_KEY) ||
 		((sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC) && is_wep))
 			msg_join.authtype.data = P80211ENUM_authalg_sharedkey;
-	else printk(KERN_WARNING "Unhandled authorisation type for connect (%d)\n", sme->auth_type);
+	else
+		printk(KERN_WARNING
+			"Unhandled authorisation type for connect (%d)\n",
+			sme->auth_type);
 
 	/* Set the encryption - we only support wep */
 	if (is_wep) {
-
 		if (sme->key) {
 			result = prism2_domibset_uint32(wlandev,
 				DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
 				sme->key_idx);
-			if (result) goto exit;
+			if (result)
+				goto exit;
 
 			/* send key to driver */
 			switch (sme->key_idx) {
 			case 0:
-				did =
-				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey0;
+				did = DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey0;
 				break;
 
 			case 1:
-				did =
-				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey1;
+				did = DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey1;
 				break;
 
 			case 2:
-				did =
-				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey2;
+				did = DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey2;
 				break;
 
 			case 3:
-				did =
-				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey3;
+				did = DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey3;
 				break;
 
 			default:
@@ -526,28 +532,40 @@ int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
 			}
 
 			result = prism2_domibset_pstr32(wlandev, did, sme->key_len, (u8 *) sme->key);
-			if (result) goto exit;
+			if (result)
+				goto exit;
 
 		}
 
 		/* Assume we should set privacy invoked and exclude unencrypted
 		   We could possibly use sme->privacy here, but the assumption
 		   seems reasonable anyway */
-		result = prism2_domibset_uint32(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
-			 P80211ENUM_truth_true);
-		if (result) goto exit;
-		result = prism2_domibset_uint32(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
-			 P80211ENUM_truth_true);
-		if (result) goto exit;
+		result = prism2_domibset_uint32(wlandev,
+						DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
+						P80211ENUM_truth_true);
+		if (result)
+			goto exit;
+
+		result = prism2_domibset_uint32(wlandev,
+						DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
+						P80211ENUM_truth_true);
+		if (result)
+			goto exit;
 
 	} else {
-		/* Assume we should unset privacy invoked and exclude unencrypted */
-		result = prism2_domibset_uint32(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
-			 P80211ENUM_truth_false);
-		if (result) goto exit;
-		result = prism2_domibset_uint32(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
-			 P80211ENUM_truth_false);
-		if (result) goto exit;
+		/* Assume we should unset privacy invoked
+		   and exclude unencrypted */
+		result = prism2_domibset_uint32(wlandev,
+						DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
+						P80211ENUM_truth_false);
+		if (result)
+			goto exit;
+
+		result = prism2_domibset_uint32(wlandev,
+						DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
+						P80211ENUM_truth_false);
+		if (result)
+			goto exit;
 
 	}
 
@@ -558,16 +576,18 @@ int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(msg_join.ssid.data.data, sme->ssid, length);
 	msg_join.ssid.data.len = length;
 
-	result = p80211req_dorequest(wlandev, (u8 *) & msg_join);
+	result = p80211req_dorequest(wlandev, (u8 *) &msg_join);
 
 exit:
-	if (result) err = -EFAULT;
+	if (result)
+		err = -EFAULT;
 
 	return err;
 }
 
 int prism2_disconnect(struct wiphy *wiphy, struct net_device *dev,
-		      u16 reason_code) {
+		      u16 reason_code)
+{
 	wlandevice_t *wlandev = dev->ml_priv;
 	p80211msg_lnxreq_autojoin_t msg_join;
 	int result;
@@ -580,26 +600,30 @@ int prism2_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(msg_join.ssid.data.data, "---", 3);
 	msg_join.ssid.data.len = 3;
 
-	result = p80211req_dorequest(wlandev, (u8 *) & msg_join);
+	result = p80211req_dorequest(wlandev, (u8 *) &msg_join);
 
-	if (result) err = -EFAULT;
+	if (result)
+		err = -EFAULT;
 
 	return err;
 }
 
 
 int prism2_join_ibss(struct wiphy *wiphy, struct net_device *dev,
-		     struct cfg80211_ibss_params *params) {
+		     struct cfg80211_ibss_params *params)
+{
 	return -EOPNOTSUPP;
 }
 
-int prism2_leave_ibss(struct wiphy *wiphy, struct net_device *dev) {
+int prism2_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
+{
 	return -EOPNOTSUPP;
 }
 
 
-int prism2_set_tx_power(struct wiphy *wiphy,
-			enum tx_power_setting type, int dbm) {
+int prism2_set_tx_power(struct wiphy *wiphy, enum tx_power_setting type,
+			int dbm)
+{
 	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
 	wlandevice_t *wlandev = priv->wlandev;
 	u32 data;
@@ -624,7 +648,8 @@ exit:
 	return err;
 }
 
-int prism2_get_tx_power(struct wiphy *wiphy, int *dbm) {
+int prism2_get_tx_power(struct wiphy *wiphy, int *dbm)
+{
 	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
 	wlandevice_t *wlandev = priv->wlandev;
 	p80211msg_dot11req_mibget_t msg;
@@ -636,7 +661,7 @@ int prism2_get_tx_power(struct wiphy *wiphy, int *dbm) {
 	mibitem->did =
 	    DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel;
 
-	result = p80211req_dorequest(wlandev, (u8 *) & msg);
+	result = p80211req_dorequest(wlandev, (u8 *) &msg);
 
 	if (result) {
 		err = -EFAULT;
@@ -653,21 +678,22 @@ exit:
 
 
 /* Interface callback functions, passing data back up to the cfg80211 layer */
-void	prism2_connect_result(wlandevice_t *wlandev, u8 failed) {
+void prism2_connect_result(wlandevice_t *wlandev, u8 failed)
+{
+	u16 status = failed ? WLAN_STATUS_UNSPECIFIED_FAILURE : WLAN_STATUS_SUCCESS;
 
 	cfg80211_connect_result(wlandev->netdev, wlandev->bssid,
-		NULL, 0, NULL, 0,
-		failed ? WLAN_STATUS_UNSPECIFIED_FAILURE : WLAN_STATUS_SUCCESS, GFP_KERNEL);
+				NULL, 0, NULL, 0, status, GFP_KERNEL);
 }
 
-void	prism2_disconnected(wlandevice_t *wlandev) {
-
+void prism2_disconnected(wlandevice_t *wlandev)
+{
 	cfg80211_disconnected(wlandev->netdev, 0, NULL,
 		0, GFP_KERNEL);
 }
 
-void	prism2_roamed(wlandevice_t *wlandev) {
-
+void prism2_roamed(wlandevice_t *wlandev)
+{
 	cfg80211_roamed(wlandev->netdev, wlandev->bssid,
 		NULL, 0, NULL, 0, GFP_KERNEL);
 }
@@ -714,9 +740,8 @@ struct wiphy *wlan_create_wiphy(struct device *dev, wlandevice_t *wlandev)
 	set_wiphy_dev(wiphy, dev);
 	wiphy->privid = prism2_wiphy_privid;
 	wiphy->max_scan_ssids = 1;
-	wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION)
+				 | BIT(NL80211_IFTYPE_ADHOC);
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->n_cipher_suites = PRISM2_NUM_CIPHER_SUITES;
 	wiphy->cipher_suites = prism2_cipher_suites;
-- 
1.6.3.3


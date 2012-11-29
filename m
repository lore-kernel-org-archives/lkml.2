Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2K2Nes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:34:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41290 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab2K2Ner (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:34:47 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/4] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_wx.c
Date: Thu, 29 Nov 2012 22:34:39 +0900
Message-Id: <1354196079-11726-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors and warnings fixed.
- ERROR: code indent should use tabs where possible
- WARNING: please, no spaces at the start of a line
- WARNING: please, no space before tabs

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |  372 ++++++++++----------
 1 file changed, 186 insertions(+), 186 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
index c7917b2..9185a21 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -41,9 +41,9 @@ static const char *ieee80211_modes[] = {
 
 #define MAX_CUSTOM_LEN 64
 static inline char *rtl818x_translate_scan(struct ieee80211_device *ieee,
-		                           char *start, char *stop,
-                                           struct ieee80211_network *network,
-                                           struct iw_request_info *info)
+					   char *start, char *stop,
+					   struct ieee80211_network *network,
+					   struct iw_request_info *info)
 {
 	char custom[MAX_CUSTOM_LEN];
 	char *p;
@@ -78,9 +78,9 @@ static inline char *rtl818x_translate_scan(struct ieee80211_device *ieee,
 	snprintf(iwe.u.name, IFNAMSIZ, "IEEE 802.11%s", ieee80211_modes[network->mode]);
 	start = iwe_stream_add_event(info, start, stop, &iwe, IW_EV_CHAR_LEN);
 
-        /* Add mode */
-        iwe.cmd = SIOCGIWMODE;
-        if (network->capability &
+	/* Add mode */
+	iwe.cmd = SIOCGIWMODE;
+	if (network->capability &
 	    (WLAN_CAPABILITY_BSS | WLAN_CAPABILITY_IBSS)) {
 		if (network->capability & WLAN_CAPABILITY_BSS)
 			iwe.u.mode = IW_MODE_MASTER;
@@ -90,7 +90,7 @@ static inline char *rtl818x_translate_scan(struct ieee80211_device *ieee,
 		start = iwe_stream_add_event(info, start, stop, &iwe, IW_EV_UINT_LEN);
 	}
 
-        /* Add frequency/channel */
+	/* Add frequency/channel */
 	iwe.cmd = SIOCGIWFREQ;
 /*	iwe.u.freq.m = ieee80211_frequency(network->channel, network->mode);
 	iwe.u.freq.e = 3; */
@@ -168,23 +168,23 @@ static inline char *rtl818x_translate_scan(struct ieee80211_device *ieee,
 	if (iwe.u.data.length)
 		start = iwe_stream_add_point(info, start, stop, &iwe, custom);
 
-		memset(&iwe, 0, sizeof(iwe));
-        if (network->wpa_ie_len) {
+	memset(&iwe, 0, sizeof(iwe));
+	if (network->wpa_ie_len) {
 	//	printk("wpa_ie_len:%d\n", network->wpa_ie_len);
-                char buf[MAX_WPA_IE_LEN];
-                memcpy(buf, network->wpa_ie, network->wpa_ie_len);
-                iwe.cmd = IWEVGENIE;
-                iwe.u.data.length = network->wpa_ie_len;
-                start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-        }
-
-        memset(&iwe, 0, sizeof(iwe));
-        if (network->rsn_ie_len) {
+		char buf[MAX_WPA_IE_LEN];
+		memcpy(buf, network->wpa_ie, network->wpa_ie_len);
+		iwe.cmd = IWEVGENIE;
+		iwe.u.data.length = network->wpa_ie_len;
+		start = iwe_stream_add_point(info, start, stop, &iwe, buf);
+	}
+
+	memset(&iwe, 0, sizeof(iwe));
+	if (network->rsn_ie_len) {
 	//	printk("=====>rsn_ie_len:\n", network->rsn_ie_len);
-                char buf[MAX_WPA_IE_LEN];
-                memcpy(buf, network->rsn_ie, network->rsn_ie_len);
-                iwe.cmd = IWEVGENIE;
-                iwe.u.data.length = network->rsn_ie_len;
+		char buf[MAX_WPA_IE_LEN];
+		memcpy(buf, network->rsn_ie, network->rsn_ie_len);
+		iwe.cmd = IWEVGENIE;
+		iwe.u.data.length = network->rsn_ie_len;
 		start = iwe_stream_add_point(info, start, stop, &iwe, buf);
 	}
 
@@ -359,7 +359,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 				   key, escape_essid(sec.keys[key], len),
 				   erq->length, len);
 		sec.key_sizes[key] = len;
- 		(*crypt)->ops->set_key(sec.keys[key], len, NULL,
+		(*crypt)->ops->set_key(sec.keys[key], len, NULL,
 				       (*crypt)->priv);
 		sec.flags |= (1 << key);
 		/* This ensures a key will be activated if no key is
@@ -472,218 +472,218 @@ int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
 }
 
 int ieee80211_wx_set_encode_ext(struct ieee80211_device *ieee,
-                               struct iw_request_info *info,
-                               union iwreq_data *wrqu, char *extra)
+				struct iw_request_info *info,
+				union iwreq_data *wrqu, char *extra)
 {
 	struct net_device *dev = ieee->dev;
-        struct iw_point *encoding = &wrqu->encoding;
-        struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-        int i, idx, ret = 0;
-        int group_key = 0;
-        const char *alg;
-        struct ieee80211_crypto_ops *ops;
-        struct ieee80211_crypt_data **crypt;
-
-        struct ieee80211_security sec = {
-                .flags = 0,
-        };
+	struct iw_point *encoding = &wrqu->encoding;
+	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
+	int i, idx, ret = 0;
+	int group_key = 0;
+	const char *alg;
+	struct ieee80211_crypto_ops *ops;
+	struct ieee80211_crypt_data **crypt;
+
+	struct ieee80211_security sec = {
+		.flags = 0,
+	};
 	//printk("======>encoding flag:%x,ext flag:%x, ext alg:%d\n", encoding->flags,ext->ext_flags, ext->alg);
-        idx = encoding->flags & IW_ENCODE_INDEX;
-        if (idx) {
-                if (idx < 1 || idx > WEP_KEYS)
-                        return -EINVAL;
-                idx--;
-        } else
-                idx = ieee->tx_keyidx;
-
-        if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
-                crypt = &ieee->crypt[idx];
-                group_key = 1;
-        } else {
-                /* some Cisco APs use idx>0 for unicast in dynamic WEP */
+	idx = encoding->flags & IW_ENCODE_INDEX;
+	if (idx) {
+		if (idx < 1 || idx > WEP_KEYS)
+			return -EINVAL;
+		idx--;
+	} else
+		idx = ieee->tx_keyidx;
+
+	if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
+		crypt = &ieee->crypt[idx];
+		group_key = 1;
+	} else {
+		/* some Cisco APs use idx>0 for unicast in dynamic WEP */
 		//printk("not group key, flags:%x, ext->alg:%d\n", ext->ext_flags, ext->alg);
-                if (idx != 0 && ext->alg != IW_ENCODE_ALG_WEP)
-                        return -EINVAL;
-                if (ieee->iw_mode == IW_MODE_INFRA)
-                        crypt = &ieee->crypt[idx];
-                else
-                        return -EINVAL;
-        }
-
-        sec.flags |= SEC_ENABLED;// | SEC_ENCRYPT;
-        if ((encoding->flags & IW_ENCODE_DISABLED) ||
-            ext->alg == IW_ENCODE_ALG_NONE) {
-                if (*crypt)
-                        ieee80211_crypt_delayed_deinit(ieee, crypt);
-
-                for (i = 0; i < WEP_KEYS; i++)
-                        if (ieee->crypt[i] != NULL)
-                                break;
-
-                if (i == WEP_KEYS) {
-                        sec.enabled = 0;
-                      //  sec.encrypt = 0;
-                        sec.level = SEC_LEVEL_0;
-                        sec.flags |= SEC_LEVEL;
-                }
+		if (idx != 0 && ext->alg != IW_ENCODE_ALG_WEP)
+			return -EINVAL;
+		if (ieee->iw_mode == IW_MODE_INFRA)
+			crypt = &ieee->crypt[idx];
+		else
+			return -EINVAL;
+	}
+
+	sec.flags |= SEC_ENABLED;// | SEC_ENCRYPT;
+	if ((encoding->flags & IW_ENCODE_DISABLED) ||
+	    ext->alg == IW_ENCODE_ALG_NONE) {
+		if (*crypt)
+			ieee80211_crypt_delayed_deinit(ieee, crypt);
+
+		for (i = 0; i < WEP_KEYS; i++)
+			if (ieee->crypt[i] != NULL)
+				break;
+
+		if (i == WEP_KEYS) {
+			sec.enabled = 0;
+			// sec.encrypt = 0;
+			sec.level = SEC_LEVEL_0;
+			sec.flags |= SEC_LEVEL;
+		}
 		//printk("disabled: flag:%x\n", encoding->flags);
-                goto done;
-        }
+		goto done;
+	}
 
 	sec.enabled = 1;
     //    sec.encrypt = 1;
 
-        switch (ext->alg) {
-        case IW_ENCODE_ALG_WEP:
-                alg = "WEP";
-                break;
-        case IW_ENCODE_ALG_TKIP:
-                alg = "TKIP";
-                break;
-        case IW_ENCODE_ALG_CCMP:
-                alg = "CCMP";
-                break;
-        default:
-                IEEE80211_DEBUG_WX("%s: unknown crypto alg %d\n",
-                                   dev->name, ext->alg);
-                ret = -EINVAL;
-                goto done;
-        }
+	switch (ext->alg) {
+	case IW_ENCODE_ALG_WEP:
+		alg = "WEP";
+		break;
+	case IW_ENCODE_ALG_TKIP:
+		alg = "TKIP";
+		break;
+	case IW_ENCODE_ALG_CCMP:
+		alg = "CCMP";
+		break;
+	default:
+		IEEE80211_DEBUG_WX("%s: unknown crypto alg %d\n",
+				   dev->name, ext->alg);
+		ret = -EINVAL;
+		goto done;
+	}
 //	printk("8-09-08-9=====>%s, alg name:%s\n",__func__, alg);
 
-	 ops = ieee80211_get_crypto_ops(alg);
-        if (ops == NULL)
-                ops = ieee80211_get_crypto_ops(alg);
-        if (ops == NULL) {
-                IEEE80211_DEBUG_WX("%s: unknown crypto alg %d\n",
-                                   dev->name, ext->alg);
+	ops = ieee80211_get_crypto_ops(alg);
+	if (ops == NULL)
+		ops = ieee80211_get_crypto_ops(alg);
+	if (ops == NULL) {
+		IEEE80211_DEBUG_WX("%s: unknown crypto alg %d\n",
+				   dev->name, ext->alg);
 		printk("========>unknown crypto alg %d\n", ext->alg);
-                ret = -EINVAL;
-                goto done;
-        }
-
-        if (*crypt == NULL || (*crypt)->ops != ops) {
-                struct ieee80211_crypt_data *new_crypt;
-
-                ieee80211_crypt_delayed_deinit(ieee, crypt);
-
-                new_crypt = kzalloc(sizeof(*new_crypt), GFP_KERNEL);
-                if (new_crypt == NULL) {
-                        ret = -ENOMEM;
-                        goto done;
-                }
-                new_crypt->ops = ops;
-                if (new_crypt->ops)
-                        new_crypt->priv = new_crypt->ops->init(idx);
-                if (new_crypt->priv == NULL) {
-                        kfree(new_crypt);
-                        ret = -EINVAL;
-                        goto done;
-                }
-                *crypt = new_crypt;
-
- 	}
-
-        if (ext->key_len > 0 && (*crypt)->ops->set_key &&
-            (*crypt)->ops->set_key(ext->key, ext->key_len, ext->rx_seq,
-                                   (*crypt)->priv) < 0) {
-                IEEE80211_DEBUG_WX("%s: key setting failed\n", dev->name);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	if (*crypt == NULL || (*crypt)->ops != ops) {
+		struct ieee80211_crypt_data *new_crypt;
+
+		ieee80211_crypt_delayed_deinit(ieee, crypt);
+
+		new_crypt = kzalloc(sizeof(*new_crypt), GFP_KERNEL);
+		if (new_crypt == NULL) {
+			ret = -ENOMEM;
+			goto done;
+		}
+		new_crypt->ops = ops;
+		if (new_crypt->ops)
+			new_crypt->priv = new_crypt->ops->init(idx);
+		if (new_crypt->priv == NULL) {
+			kfree(new_crypt);
+			ret = -EINVAL;
+			goto done;
+		}
+		*crypt = new_crypt;
+
+	}
+
+	if (ext->key_len > 0 && (*crypt)->ops->set_key &&
+	    (*crypt)->ops->set_key(ext->key, ext->key_len, ext->rx_seq,
+				   (*crypt)->priv) < 0) {
+		IEEE80211_DEBUG_WX("%s: key setting failed\n", dev->name);
 		printk("key setting failed\n");
-                ret = -EINVAL;
-                goto done;
-        }
+		ret = -EINVAL;
+		goto done;
+	}
 #if 1
  //skip_host_crypt:
 	//printk("skip_host_crypt:ext_flags:%x\n", ext->ext_flags);
-        if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
-                ieee->tx_keyidx = idx;
-                sec.active_key = idx;
-                sec.flags |= SEC_ACTIVE_KEY;
-        }
-
-        if (ext->alg != IW_ENCODE_ALG_NONE) {
-                memcpy(sec.keys[idx], ext->key, ext->key_len);
-                sec.key_sizes[idx] = ext->key_len;
-                sec.flags |= (1 << idx);
-                if (ext->alg == IW_ENCODE_ALG_WEP) {
-                      //  sec.encode_alg[idx] = SEC_ALG_WEP;
-                        sec.flags |= SEC_LEVEL;
-                        sec.level = SEC_LEVEL_1;
-                } else if (ext->alg == IW_ENCODE_ALG_TKIP) {
-                      //  sec.encode_alg[idx] = SEC_ALG_TKIP;
-                        sec.flags |= SEC_LEVEL;
-                        sec.level = SEC_LEVEL_2;
-                } else if (ext->alg == IW_ENCODE_ALG_CCMP) {
-                       // sec.encode_alg[idx] = SEC_ALG_CCMP;
-                        sec.flags |= SEC_LEVEL;
-                        sec.level = SEC_LEVEL_3;
-                }
-                /* Don't set sec level for group keys. */
-                if (group_key)
-                        sec.flags &= ~SEC_LEVEL;
-        }
+	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
+		ieee->tx_keyidx = idx;
+		sec.active_key = idx;
+		sec.flags |= SEC_ACTIVE_KEY;
+	}
+
+	if (ext->alg != IW_ENCODE_ALG_NONE) {
+		memcpy(sec.keys[idx], ext->key, ext->key_len);
+		sec.key_sizes[idx] = ext->key_len;
+		sec.flags |= (1 << idx);
+		if (ext->alg == IW_ENCODE_ALG_WEP) {
+		      //  sec.encode_alg[idx] = SEC_ALG_WEP;
+			sec.flags |= SEC_LEVEL;
+			sec.level = SEC_LEVEL_1;
+		} else if (ext->alg == IW_ENCODE_ALG_TKIP) {
+		      //  sec.encode_alg[idx] = SEC_ALG_TKIP;
+			sec.flags |= SEC_LEVEL;
+			sec.level = SEC_LEVEL_2;
+		} else if (ext->alg == IW_ENCODE_ALG_CCMP) {
+		       // sec.encode_alg[idx] = SEC_ALG_CCMP;
+			sec.flags |= SEC_LEVEL;
+			sec.level = SEC_LEVEL_3;
+		}
+		/* Don't set sec level for group keys. */
+		if (group_key)
+			sec.flags &= ~SEC_LEVEL;
+	}
 #endif
 done:
-        if (ieee->set_security)
-                ieee->set_security(ieee->dev, &sec);
+	if (ieee->set_security)
+		ieee->set_security(ieee->dev, &sec);
 
 	 if (ieee->reset_on_keychange &&
-            ieee->iw_mode != IW_MODE_INFRA &&
-            ieee->reset_port && ieee->reset_port(dev)) {
-                IEEE80211_DEBUG_WX("%s: reset_port failed\n", dev->name);
-                return -EINVAL;
-        }
+	    ieee->iw_mode != IW_MODE_INFRA &&
+	    ieee->reset_port && ieee->reset_port(dev)) {
+		IEEE80211_DEBUG_WX("%s: reset_port failed\n", dev->name);
+		return -EINVAL;
+	}
 
-        return ret;
+	return ret;
 }
 int ieee80211_wx_set_mlme(struct ieee80211_device *ieee,
-                               struct iw_request_info *info,
-                               union iwreq_data *wrqu, char *extra)
+			       struct iw_request_info *info,
+			       union iwreq_data *wrqu, char *extra)
 {
 	struct iw_mlme *mlme = (struct iw_mlme *) extra;
 //	printk("\ndkgadfslkdjgalskdf===============>%s(), cmd:%x\n", __func__, mlme->cmd);
 #if 1
 	switch (mlme->cmd) {
-        case IW_MLME_DEAUTH:
+	case IW_MLME_DEAUTH:
 	case IW_MLME_DISASSOC:
 	//	printk("disassoc now\n");
 		ieee80211_disassociate(ieee);
 		break;
 	 default:
-                return -EOPNOTSUPP;
-        }
+		return -EOPNOTSUPP;
+	}
 #endif
 	return 0;
 }
 
 int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
-                               struct iw_request_info *info,
-                               struct iw_param *data, char *extra)
+			       struct iw_request_info *info,
+			       struct iw_param *data, char *extra)
 {
 /*
 	 struct ieee80211_security sec = {
-                .flags = SEC_AUTH_MODE,
+		.flags = SEC_AUTH_MODE,
 	}
 */
 	//printk("set auth:flag:%x, data value:%x\n", data->flags, data->value);
 	switch (data->flags & IW_AUTH_INDEX) {
-        case IW_AUTH_WPA_VERSION:
+	case IW_AUTH_WPA_VERSION:
 	     /*need to support wpa2 here*/
 		//printk("wpa version:%x\n", data->value);
 		break;
-        case IW_AUTH_CIPHER_PAIRWISE:
-        case IW_AUTH_CIPHER_GROUP:
-        case IW_AUTH_KEY_MGMT:
-                /*
+	case IW_AUTH_CIPHER_PAIRWISE:
+	case IW_AUTH_CIPHER_GROUP:
+	case IW_AUTH_KEY_MGMT:
+		/*
  *                  * Host AP driver does not use these parameters and allows
  *                                   * wpa_supplicant to control them internally.
  *                                                    */
-                break;
-        case IW_AUTH_TKIP_COUNTERMEASURES:
-                ieee->tkip_countermeasures = data->value;
-                break;
-        case IW_AUTH_DROP_UNENCRYPTED:
-                ieee->drop_unencrypted = data->value;
+		break;
+	case IW_AUTH_TKIP_COUNTERMEASURES:
+		ieee->tkip_countermeasures = data->value;
+		break;
+	case IW_AUTH_DROP_UNENCRYPTED:
+		ieee->drop_unencrypted = data->value;
 		break;
 
 	case IW_AUTH_80211_AUTH_ALG:
@@ -699,13 +699,13 @@ int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
 
 #endif
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
-                ieee->ieee802_1x = data->value;
+		ieee->ieee802_1x = data->value;
 		break;
 	case IW_AUTH_PRIVACY_INVOKED:
 		ieee->privacy_invoked = data->value;
 		break;
 	default:
-                return -EOPNOTSUPP;
+		return -EOPNOTSUPP;
 	}
 	return 0;
 }
-- 
1.7.9.5


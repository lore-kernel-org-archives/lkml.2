Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2LEUvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:51:41 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37438 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436Ab2LEUvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:51:32 -0500
From: Sebastian Hahn <snsehahn@cip.cs.fau.de>
To: gregkh@linuxfoundation.org
Cc: Jennifer.Naumann@informatik.stud.uni-erlangen.de, dan.carpenter@oracle.com,
        standby24x7@gmail.com, Julia.Lawall@lip6.fr, jkosina@suse.cz,
        joe@perches.com, yongjun_wei@trendmicro.com.cn,
        adam.buchbinder@gmail.com, amwang@redhat.com, justinmattock@gmail.com,
        wfp5p@virginia.edu, jim.cromie@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Sebastian Hahn <snsehahn@cip.cs.fau.de>
Subject: [PATCH 5/6] staging/rtl8192u: use same indent for switch and case
Date: Wed,  5 Dec 2012 21:40:22 +0100
Message-Id: <1354740023-30849-6-git-send-email-snsehahn@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
References: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the checkpatch error "switch and case should be at the same indent"

Signed-off-by: Sebastian Hahn <snsehahn@cip.cs.fau.de>
---
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |  272 ++++++++--------
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |   32 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |  338 ++++++++++----------
 drivers/staging/rtl8192u/r8192U_wx.c               |   12 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |   96 +++---
 drivers/staging/rtl8192u/r819xU_phy.c              |   78 ++---
 7 files changed, 415 insertions(+), 415 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index e83c310..7062f9d 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -1948,166 +1948,166 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 	switch (WLAN_FC_GET_STYPE(header->frame_ctl)) {
 
-		case IEEE80211_STYPE_ASSOC_RESP:
-		case IEEE80211_STYPE_REASSOC_RESP:
-
-			IEEE80211_DEBUG_MGMT("received [RE]ASSOCIATION RESPONSE (%d)\n",
-					WLAN_FC_GET_STYPE(header->frame_ctl));
-			if ((ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE) &&
-				ieee->state == IEEE80211_ASSOCIATING_AUTHENTICATED &&
-				ieee->iw_mode == IW_MODE_INFRA){
-				struct ieee80211_network network_resp;
-				struct ieee80211_network *network = &network_resp;
-
-				if (0 == (errcode=assoc_parse(ieee,skb, &aid))){
-					ieee->state=IEEE80211_LINKED;
-					ieee->assoc_id = aid;
-					ieee->softmac_stats.rx_ass_ok++;
-					/* station support qos */
-					/* Let the register setting defaultly with Legacy station */
-					if(ieee->qos_support) {
-						assoc_resp = (struct ieee80211_assoc_response_frame*)skb->data;
-						memset(network, 0, sizeof(*network));
-						if (ieee80211_parse_info_param(ieee,assoc_resp->info_element,\
-									rx_stats->len - sizeof(*assoc_resp),\
-									network,rx_stats)){
-							return 1;
-						}
-						else
-						{	//filling the PeerHTCap. //maybe not necessary as we can get its info from current_network.
-							memcpy(ieee->pHTInfo->PeerHTCapBuf, network->bssht.bdHTCapBuf, network->bssht.bdHTCapLen);
-							memcpy(ieee->pHTInfo->PeerHTInfoBuf, network->bssht.bdHTInfoBuf, network->bssht.bdHTInfoLen);
-						}
-						if (ieee->handle_assoc_response != NULL)
-							ieee->handle_assoc_response(ieee->dev, (struct ieee80211_assoc_response_frame*)header, network);
+	case IEEE80211_STYPE_ASSOC_RESP:
+	case IEEE80211_STYPE_REASSOC_RESP:
+
+		IEEE80211_DEBUG_MGMT("received [RE]ASSOCIATION RESPONSE (%d)\n",
+				WLAN_FC_GET_STYPE(header->frame_ctl));
+		if ((ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE) &&
+			ieee->state == IEEE80211_ASSOCIATING_AUTHENTICATED &&
+			ieee->iw_mode == IW_MODE_INFRA){
+			struct ieee80211_network network_resp;
+			struct ieee80211_network *network = &network_resp;
+
+			if (0 == (errcode=assoc_parse(ieee,skb, &aid))){
+				ieee->state=IEEE80211_LINKED;
+				ieee->assoc_id = aid;
+				ieee->softmac_stats.rx_ass_ok++;
+				/* station support qos */
+				/* Let the register setting defaultly with Legacy station */
+				if(ieee->qos_support) {
+					assoc_resp = (struct ieee80211_assoc_response_frame*)skb->data;
+					memset(network, 0, sizeof(*network));
+					if (ieee80211_parse_info_param(ieee,assoc_resp->info_element,\
+								rx_stats->len - sizeof(*assoc_resp),\
+								network,rx_stats)){
+						return 1;
 					}
-					ieee80211_associate_complete(ieee);
-				} else {
-					/* aid could not been allocated */
-					ieee->softmac_stats.rx_ass_err++;
-					printk(
-						"Association response status code 0x%x\n",
-						errcode);
-					IEEE80211_DEBUG_MGMT(
-						"Association response status code 0x%x\n",
-						errcode);
-					if(ieee->AsocRetryCount < RT_ASOC_RETRY_LIMIT) {
-						queue_work(ieee->wq, &ieee->associate_procedure_wq);
-					} else {
-						ieee80211_associate_abort(ieee);
+					else
+					{	//filling the PeerHTCap. //maybe not necessary as we can get its info from current_network.
+						memcpy(ieee->pHTInfo->PeerHTCapBuf, network->bssht.bdHTCapBuf, network->bssht.bdHTCapLen);
+						memcpy(ieee->pHTInfo->PeerHTInfoBuf, network->bssht.bdHTInfoBuf, network->bssht.bdHTInfoLen);
 					}
+					if (ieee->handle_assoc_response != NULL)
+						ieee->handle_assoc_response(ieee->dev, (struct ieee80211_assoc_response_frame*)header, network);
+				}
+				ieee80211_associate_complete(ieee);
+			} else {
+				/* aid could not been allocated */
+				ieee->softmac_stats.rx_ass_err++;
+				printk(
+					"Association response status code 0x%x\n",
+					errcode);
+				IEEE80211_DEBUG_MGMT(
+					"Association response status code 0x%x\n",
+					errcode);
+				if(ieee->AsocRetryCount < RT_ASOC_RETRY_LIMIT) {
+					queue_work(ieee->wq, &ieee->associate_procedure_wq);
+				} else {
+					ieee80211_associate_abort(ieee);
 				}
 			}
-			break;
+		}
+		break;
 
-		case IEEE80211_STYPE_ASSOC_REQ:
-		case IEEE80211_STYPE_REASSOC_REQ:
+	case IEEE80211_STYPE_ASSOC_REQ:
+	case IEEE80211_STYPE_REASSOC_REQ:
 
-			if ((ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE) &&
-				ieee->iw_mode == IW_MODE_MASTER)
+		if ((ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE) &&
+			ieee->iw_mode == IW_MODE_MASTER)
 
-				ieee80211_rx_assoc_rq(ieee, skb);
-			break;
+			ieee80211_rx_assoc_rq(ieee, skb);
+		break;
 
-		case IEEE80211_STYPE_AUTH:
+	case IEEE80211_STYPE_AUTH:
 
-			if (ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE){
-				if (ieee->state == IEEE80211_ASSOCIATING_AUTHENTICATING &&
-				ieee->iw_mode == IW_MODE_INFRA){
+		if (ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE){
+			if (ieee->state == IEEE80211_ASSOCIATING_AUTHENTICATING &&
+			ieee->iw_mode == IW_MODE_INFRA){
 
-						IEEE80211_DEBUG_MGMT("Received authentication response");
+					IEEE80211_DEBUG_MGMT("Received authentication response");
 
-						if (0 == (errcode=auth_parse(skb, &challenge, &chlen))){
-							if(ieee->open_wep || !challenge){
-								ieee->state = IEEE80211_ASSOCIATING_AUTHENTICATED;
-								ieee->softmac_stats.rx_auth_rs_ok++;
-								if(!(ieee->pHTInfo->IOTAction&HT_IOT_ACT_PURE_N_MODE))
+					if (0 == (errcode=auth_parse(skb, &challenge, &chlen))){
+						if(ieee->open_wep || !challenge){
+							ieee->state = IEEE80211_ASSOCIATING_AUTHENTICATED;
+							ieee->softmac_stats.rx_auth_rs_ok++;
+							if(!(ieee->pHTInfo->IOTAction&HT_IOT_ACT_PURE_N_MODE))
+							{
+								if (!ieee->GetNmodeSupportBySecCfg(ieee->dev))
 								{
-									if (!ieee->GetNmodeSupportBySecCfg(ieee->dev))
+											// WEP or TKIP encryption
+									if(IsHTHalfNmodeAPs(ieee))
 									{
-												// WEP or TKIP encryption
-										if(IsHTHalfNmodeAPs(ieee))
-										{
-											bSupportNmode = true;
-											bHalfSupportNmode = true;
-										}
-										else
-										{
-											bSupportNmode = false;
-											bHalfSupportNmode = false;
-										}
-									printk("==========>to link with AP using SEC(%d, %d)", bSupportNmode, bHalfSupportNmode);
+										bSupportNmode = true;
+										bHalfSupportNmode = true;
 									}
+									else
+									{
+										bSupportNmode = false;
+										bHalfSupportNmode = false;
+									}
+								printk("==========>to link with AP using SEC(%d, %d)", bSupportNmode, bHalfSupportNmode);
 								}
-								/* Dummy wirless mode setting to avoid encryption issue */
-								if(bSupportNmode) {
-									//N mode setting
-									ieee->SetWirelessMode(ieee->dev, \
-											ieee->current_network.mode);
-								}else{
-									//b/g mode setting
-									/*TODO*/
-									ieee->SetWirelessMode(ieee->dev, IEEE_G);
-								}
-
-								if (ieee->current_network.mode == IEEE_N_24G && bHalfSupportNmode == true)
-								{
-									printk("===============>entern half N mode\n");
-									ieee->bHalfWirelessN24GMode = true;
-								}
-								else
-									ieee->bHalfWirelessN24GMode = false;
-
-								ieee80211_associate_step2(ieee);
+							}
+							/* Dummy wirless mode setting to avoid encryption issue */
+							if(bSupportNmode) {
+								//N mode setting
+								ieee->SetWirelessMode(ieee->dev, \
+										ieee->current_network.mode);
 							}else{
-								ieee80211_auth_challenge(ieee, challenge, chlen);
+								//b/g mode setting
+								/*TODO*/
+								ieee->SetWirelessMode(ieee->dev, IEEE_G);
+							}
+
+							if (ieee->current_network.mode == IEEE_N_24G && bHalfSupportNmode == true)
+							{
+								printk("===============>entern half N mode\n");
+								ieee->bHalfWirelessN24GMode = true;
 							}
+							else
+								ieee->bHalfWirelessN24GMode = false;
+
+							ieee80211_associate_step2(ieee);
 						}else{
-							ieee->softmac_stats.rx_auth_rs_err++;
-							IEEE80211_DEBUG_MGMT("Authentication response status code 0x%x",errcode);
-							ieee80211_associate_abort(ieee);
+							ieee80211_auth_challenge(ieee, challenge, chlen);
 						}
-
-					}else if (ieee->iw_mode == IW_MODE_MASTER){
-						ieee80211_rx_auth_rq(ieee, skb);
+					}else{
+						ieee->softmac_stats.rx_auth_rs_err++;
+						IEEE80211_DEBUG_MGMT("Authentication response status code 0x%x",errcode);
+						ieee80211_associate_abort(ieee);
 					}
+
+				}else if (ieee->iw_mode == IW_MODE_MASTER){
+					ieee80211_rx_auth_rq(ieee, skb);
 				}
-			break;
+			}
+		break;
 
-		case IEEE80211_STYPE_PROBE_REQ:
+	case IEEE80211_STYPE_PROBE_REQ:
 
-			if ((ieee->softmac_features & IEEE_SOFTMAC_PROBERS) &&
-				((ieee->iw_mode == IW_MODE_ADHOC ||
-				ieee->iw_mode == IW_MODE_MASTER) &&
-				ieee->state == IEEE80211_LINKED)){
-				ieee80211_rx_probe_rq(ieee, skb);
-			}
-			break;
+		if ((ieee->softmac_features & IEEE_SOFTMAC_PROBERS) &&
+			((ieee->iw_mode == IW_MODE_ADHOC ||
+			ieee->iw_mode == IW_MODE_MASTER) &&
+			ieee->state == IEEE80211_LINKED)){
+			ieee80211_rx_probe_rq(ieee, skb);
+		}
+		break;
 
-		case IEEE80211_STYPE_DISASSOC:
-		case IEEE80211_STYPE_DEAUTH:
-			/* FIXME for now repeat all the association procedure
-			* both for disassociation and deauthentication
-			*/
-			if ((ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE) &&
-				ieee->state == IEEE80211_LINKED &&
-				ieee->iw_mode == IW_MODE_INFRA){
-
-				ieee->state = IEEE80211_ASSOCIATING;
-				ieee->softmac_stats.reassoc++;
-
-				notify_wx_assoc_event(ieee);
-				//HTSetConnectBwMode(ieee, HT_CHANNEL_WIDTH_20, HT_EXTCHNL_OFFSET_NO_EXT);
-				RemovePeerTS(ieee, header->addr2);
-				queue_work(ieee->wq, &ieee->associate_procedure_wq);
-			}
-			break;
-		case IEEE80211_STYPE_MANAGE_ACT:
-			ieee80211_process_action(ieee,skb);
-			break;
-		default:
-			return -1;
-			break;
+	case IEEE80211_STYPE_DISASSOC:
+	case IEEE80211_STYPE_DEAUTH:
+		/* FIXME for now repeat all the association procedure
+		* both for disassociation and deauthentication
+		*/
+		if ((ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE) &&
+			ieee->state == IEEE80211_LINKED &&
+			ieee->iw_mode == IW_MODE_INFRA){
+
+			ieee->state = IEEE80211_ASSOCIATING;
+			ieee->softmac_stats.reassoc++;
+
+			notify_wx_assoc_event(ieee);
+			//HTSetConnectBwMode(ieee, HT_CHANNEL_WIDTH_20, HT_EXTCHNL_OFFSET_NO_EXT);
+			RemovePeerTS(ieee, header->addr2);
+			queue_work(ieee->wq, &ieee->associate_procedure_wq);
+		}
+		break;
+	case IEEE80211_STYPE_MANAGE_ACT:
+		ieee80211_process_action(ieee,skb);
+		break;
+	default:
+		return -1;
+		break;
 	}
 
 	//dev_kfree_skb_any(skb);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 7214361..c39e680 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -283,22 +283,22 @@ ieee80211_classify(struct sk_buff *skb, struct ieee80211_network *network)
 //	IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, skb->data, skb->len);
 	ip = ip_hdr(skb);
 	switch (ip->tos & 0xfc) {
-		case 0x20:
-			return 2;
-		case 0x40:
-			return 1;
-		case 0x60:
-			return 3;
-		case 0x80:
-			return 4;
-		case 0xa0:
-			return 5;
-		case 0xc0:
-			return 6;
-		case 0xe0:
-			return 7;
-		default:
-			return 0;
+	case 0x20:
+		return 2;
+	case 0x40:
+		return 1;
+	case 0x60:
+		return 3;
+	case 0x80:
+		return 4;
+	case 0xa0:
+		return 5;
+	case 0xc0:
+		return 6;
+	case 0xe0:
+		return 7;
+	default:
+		return 0;
 	}
 }
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
index f0ba7f4..e1fe54a 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -761,7 +761,7 @@ int ieee80211_wx_set_mlme(struct ieee80211_device *ieee,
 	case IW_MLME_DISASSOC:
 		ieee80211_disassociate(ieee);
 		break;
-	 default:
+	default:
 		return -EOPNOTSUPP;
 	}
 	return 0;
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 93fffea..f59bd92 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1875,43 +1875,43 @@ u8 MapHwQueueToFirmwareQueue(u8 QueueID)
 	u8 QueueSelect = 0x0;       //defualt set to
 
 	switch(QueueID) {
-		case BE_QUEUE:
-			QueueSelect = QSLT_BE;  //or QSelect = pTcb->priority;
-			break;
+	case BE_QUEUE:
+		QueueSelect = QSLT_BE;  //or QSelect = pTcb->priority;
+		break;
 
-		case BK_QUEUE:
-			QueueSelect = QSLT_BK;  //or QSelect = pTcb->priority;
-			break;
+	case BK_QUEUE:
+		QueueSelect = QSLT_BK;  //or QSelect = pTcb->priority;
+		break;
 
-		case VO_QUEUE:
-			QueueSelect = QSLT_VO;  //or QSelect = pTcb->priority;
-			break;
+	case VO_QUEUE:
+		QueueSelect = QSLT_VO;  //or QSelect = pTcb->priority;
+		break;
 
-		case VI_QUEUE:
-			QueueSelect = QSLT_VI;  //or QSelect = pTcb->priority;
-			break;
-		case MGNT_QUEUE:
-			QueueSelect = QSLT_MGNT;
-			break;
+	case VI_QUEUE:
+		QueueSelect = QSLT_VI;  //or QSelect = pTcb->priority;
+		break;
+	case MGNT_QUEUE:
+		QueueSelect = QSLT_MGNT;
+		break;
 
-		case BEACON_QUEUE:
-			QueueSelect = QSLT_BEACON;
-			break;
+	case BEACON_QUEUE:
+		QueueSelect = QSLT_BEACON;
+		break;
 
-			// TODO: 2006.10.30 mark other queue selection until we verify it is OK
-			// TODO: Remove Assertions
+		// TODO: 2006.10.30 mark other queue selection until we verify it is OK
+		// TODO: Remove Assertions
 //#if (RTL819X_FPGA_VER & RTL819X_FPGA_GUANGAN_070502)
-		case TXCMD_QUEUE:
-			QueueSelect = QSLT_CMD;
-			break;
+	case TXCMD_QUEUE:
+		QueueSelect = QSLT_CMD;
+		break;
 //#endif
-		case HIGH_QUEUE:
-			QueueSelect = QSLT_HIGH;
-			break;
+	case HIGH_QUEUE:
+		QueueSelect = QSLT_HIGH;
+		break;
 
-		default:
-			RT_TRACE(COMP_ERR, "TransmitTCB(): Impossible Queue Selection: %d \n", QueueID);
-			break;
+	default:
+		RT_TRACE(COMP_ERR, "TransmitTCB(): Impossible Queue Selection: %d \n", QueueID);
+		break;
 	}
 	return QueueSelect;
 }
@@ -1921,39 +1921,39 @@ u8 MRateToHwRate8190Pci(u8 rate)
 	u8  ret = DESC90_RATE1M;
 
 	switch(rate) {
-		case MGN_1M:    ret = DESC90_RATE1M;    break;
-		case MGN_2M:    ret = DESC90_RATE2M;    break;
-		case MGN_5_5M:  ret = DESC90_RATE5_5M;  break;
-		case MGN_11M:   ret = DESC90_RATE11M;   break;
-		case MGN_6M:    ret = DESC90_RATE6M;    break;
-		case MGN_9M:    ret = DESC90_RATE9M;    break;
-		case MGN_12M:   ret = DESC90_RATE12M;   break;
-		case MGN_18M:   ret = DESC90_RATE18M;   break;
-		case MGN_24M:   ret = DESC90_RATE24M;   break;
-		case MGN_36M:   ret = DESC90_RATE36M;   break;
-		case MGN_48M:   ret = DESC90_RATE48M;   break;
-		case MGN_54M:   ret = DESC90_RATE54M;   break;
-
-		// HT rate since here
-		case MGN_MCS0:  ret = DESC90_RATEMCS0;  break;
-		case MGN_MCS1:  ret = DESC90_RATEMCS1;  break;
-		case MGN_MCS2:  ret = DESC90_RATEMCS2;  break;
-		case MGN_MCS3:  ret = DESC90_RATEMCS3;  break;
-		case MGN_MCS4:  ret = DESC90_RATEMCS4;  break;
-		case MGN_MCS5:  ret = DESC90_RATEMCS5;  break;
-		case MGN_MCS6:  ret = DESC90_RATEMCS6;  break;
-		case MGN_MCS7:  ret = DESC90_RATEMCS7;  break;
-		case MGN_MCS8:  ret = DESC90_RATEMCS8;  break;
-		case MGN_MCS9:  ret = DESC90_RATEMCS9;  break;
-		case MGN_MCS10: ret = DESC90_RATEMCS10; break;
-		case MGN_MCS11: ret = DESC90_RATEMCS11; break;
-		case MGN_MCS12: ret = DESC90_RATEMCS12; break;
-		case MGN_MCS13: ret = DESC90_RATEMCS13; break;
-		case MGN_MCS14: ret = DESC90_RATEMCS14; break;
-		case MGN_MCS15: ret = DESC90_RATEMCS15; break;
-		case (0x80|0x20): ret = DESC90_RATEMCS32; break;
-
-		default:       break;
+	case MGN_1M:    ret = DESC90_RATE1M;    break;
+	case MGN_2M:    ret = DESC90_RATE2M;    break;
+	case MGN_5_5M:  ret = DESC90_RATE5_5M;  break;
+	case MGN_11M:   ret = DESC90_RATE11M;   break;
+	case MGN_6M:    ret = DESC90_RATE6M;    break;
+	case MGN_9M:    ret = DESC90_RATE9M;    break;
+	case MGN_12M:   ret = DESC90_RATE12M;   break;
+	case MGN_18M:   ret = DESC90_RATE18M;   break;
+	case MGN_24M:   ret = DESC90_RATE24M;   break;
+	case MGN_36M:   ret = DESC90_RATE36M;   break;
+	case MGN_48M:   ret = DESC90_RATE48M;   break;
+	case MGN_54M:   ret = DESC90_RATE54M;   break;
+
+	// HT rate since here
+	case MGN_MCS0:  ret = DESC90_RATEMCS0;  break;
+	case MGN_MCS1:  ret = DESC90_RATEMCS1;  break;
+	case MGN_MCS2:  ret = DESC90_RATEMCS2;  break;
+	case MGN_MCS3:  ret = DESC90_RATEMCS3;  break;
+	case MGN_MCS4:  ret = DESC90_RATEMCS4;  break;
+	case MGN_MCS5:  ret = DESC90_RATEMCS5;  break;
+	case MGN_MCS6:  ret = DESC90_RATEMCS6;  break;
+	case MGN_MCS7:  ret = DESC90_RATEMCS7;  break;
+	case MGN_MCS8:  ret = DESC90_RATEMCS8;  break;
+	case MGN_MCS9:  ret = DESC90_RATEMCS9;  break;
+	case MGN_MCS10: ret = DESC90_RATEMCS10; break;
+	case MGN_MCS11: ret = DESC90_RATEMCS11; break;
+	case MGN_MCS12: ret = DESC90_RATEMCS12; break;
+	case MGN_MCS13: ret = DESC90_RATEMCS13; break;
+	case MGN_MCS14: ret = DESC90_RATEMCS14; break;
+	case MGN_MCS15: ret = DESC90_RATEMCS15; break;
+	case (0x80|0x20): ret = DESC90_RATEMCS32; break;
+
+	default:       break;
 	}
 	return ret;
 }
@@ -4364,66 +4364,66 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	}
 
 	switch (cmd) {
-	    case RTL_IOCTL_WPA_SUPPLICANT:
+	case RTL_IOCTL_WPA_SUPPLICANT:
 	//parse here for HW security
-			if (ipw->cmd == IEEE_CMD_SET_ENCRYPTION)
+		if (ipw->cmd == IEEE_CMD_SET_ENCRYPTION)
+		{
+			if (ipw->u.crypt.set_tx)
 			{
-				if (ipw->u.crypt.set_tx)
+				if (strcmp(ipw->u.crypt.alg, "CCMP") == 0)
+					ieee->pairwise_key_type = KEY_TYPE_CCMP;
+				else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0)
+					ieee->pairwise_key_type = KEY_TYPE_TKIP;
+				else if (strcmp(ipw->u.crypt.alg, "WEP") == 0)
 				{
-					if (strcmp(ipw->u.crypt.alg, "CCMP") == 0)
-						ieee->pairwise_key_type = KEY_TYPE_CCMP;
-					else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0)
-						ieee->pairwise_key_type = KEY_TYPE_TKIP;
-					else if (strcmp(ipw->u.crypt.alg, "WEP") == 0)
-					{
-						if (ipw->u.crypt.key_len == 13)
-							ieee->pairwise_key_type = KEY_TYPE_WEP104;
-						else if (ipw->u.crypt.key_len == 5)
-							ieee->pairwise_key_type = KEY_TYPE_WEP40;
-					}
-					else
-						ieee->pairwise_key_type = KEY_TYPE_NA;
-
-					if (ieee->pairwise_key_type)
-					{
-						memcpy((u8*)key, ipw->u.crypt.key, 16);
-						EnableHWSecurityConfig8192(dev);
-					//we fill both index entry and 4th entry for pairwise key as in IPW interface, adhoc will only get here, so we need index entry for its default key serching!
-					//added by WB.
-						setKey(dev, 4, ipw->u.crypt.idx, ieee->pairwise_key_type, (u8*)ieee->ap_mac_addr, 0, key);
-						if (ieee->auth_mode != 2)
-						setKey(dev, ipw->u.crypt.idx, ipw->u.crypt.idx, ieee->pairwise_key_type, (u8*)ieee->ap_mac_addr, 0, key);
-					}
+					if (ipw->u.crypt.key_len == 13)
+						ieee->pairwise_key_type = KEY_TYPE_WEP104;
+					else if (ipw->u.crypt.key_len == 5)
+						ieee->pairwise_key_type = KEY_TYPE_WEP40;
 				}
-				else //if (ipw->u.crypt.idx) //group key use idx > 0
+				else
+					ieee->pairwise_key_type = KEY_TYPE_NA;
+
+				if (ieee->pairwise_key_type)
 				{
 					memcpy((u8*)key, ipw->u.crypt.key, 16);
-					if (strcmp(ipw->u.crypt.alg, "CCMP") == 0)
-						ieee->group_key_type= KEY_TYPE_CCMP;
-					else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0)
-						ieee->group_key_type = KEY_TYPE_TKIP;
-					else if (strcmp(ipw->u.crypt.alg, "WEP") == 0)
-					{
-						if (ipw->u.crypt.key_len == 13)
-							ieee->group_key_type = KEY_TYPE_WEP104;
-						else if (ipw->u.crypt.key_len == 5)
-							ieee->group_key_type = KEY_TYPE_WEP40;
-					}
-					else
-						ieee->group_key_type = KEY_TYPE_NA;
+					EnableHWSecurityConfig8192(dev);
+				//we fill both index entry and 4th entry for pairwise key as in IPW interface, adhoc will only get here, so we need index entry for its default key serching!
+				//added by WB.
+					setKey(dev, 4, ipw->u.crypt.idx, ieee->pairwise_key_type, (u8*)ieee->ap_mac_addr, 0, key);
+					if (ieee->auth_mode != 2)
+					setKey(dev, ipw->u.crypt.idx, ipw->u.crypt.idx, ieee->pairwise_key_type, (u8*)ieee->ap_mac_addr, 0, key);
+				}
+			}
+			else //if (ipw->u.crypt.idx) //group key use idx > 0
+			{
+				memcpy((u8*)key, ipw->u.crypt.key, 16);
+				if (strcmp(ipw->u.crypt.alg, "CCMP") == 0)
+					ieee->group_key_type= KEY_TYPE_CCMP;
+				else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0)
+					ieee->group_key_type = KEY_TYPE_TKIP;
+				else if (strcmp(ipw->u.crypt.alg, "WEP") == 0)
+				{
+					if (ipw->u.crypt.key_len == 13)
+						ieee->group_key_type = KEY_TYPE_WEP104;
+					else if (ipw->u.crypt.key_len == 5)
+						ieee->group_key_type = KEY_TYPE_WEP40;
+				}
+				else
+					ieee->group_key_type = KEY_TYPE_NA;
 
-					if (ieee->group_key_type)
-					{
-							setKey(	dev,
-								ipw->u.crypt.idx,
-								ipw->u.crypt.idx,		//KeyIndex
-								ieee->group_key_type,	//KeyType
-								broadcast_addr,	//MacAddr
-								0,		//DefaultKey
-								key);		//KeyContent
-					}
+				if (ieee->group_key_type)
+				{
+						setKey(	dev,
+							ipw->u.crypt.idx,
+							ipw->u.crypt.idx,		//KeyIndex
+							ieee->group_key_type,	//KeyType
+							broadcast_addr,	//MacAddr
+							0,		//DefaultKey
+							key);		//KeyContent
 				}
 			}
+		}
 #ifdef JOHN_HWSEC_DEBUG
 		//john's test 0711
 		printk("@@ wrq->u pointer = ");
@@ -4436,7 +4436,7 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		ret = ieee80211_wpa_supplicant_ioctl(priv->ieee80211, &wrq->u.data);
 		break;
 
-	    default:
+	default:
 		ret = -EOPNOTSUPP;
 		break;
 	}
@@ -4453,49 +4453,49 @@ u8 HwRateToMRate90(bool bIsHT, u8 rate)
 
 	if(!bIsHT) {
 		switch(rate) {
-			case DESC90_RATE1M:   ret_rate = MGN_1M;         break;
-			case DESC90_RATE2M:   ret_rate = MGN_2M;         break;
-			case DESC90_RATE5_5M: ret_rate = MGN_5_5M;       break;
-			case DESC90_RATE11M:  ret_rate = MGN_11M;        break;
-			case DESC90_RATE6M:   ret_rate = MGN_6M;         break;
-			case DESC90_RATE9M:   ret_rate = MGN_9M;         break;
-			case DESC90_RATE12M:  ret_rate = MGN_12M;        break;
-			case DESC90_RATE18M:  ret_rate = MGN_18M;        break;
-			case DESC90_RATE24M:  ret_rate = MGN_24M;        break;
-			case DESC90_RATE36M:  ret_rate = MGN_36M;        break;
-			case DESC90_RATE48M:  ret_rate = MGN_48M;        break;
-			case DESC90_RATE54M:  ret_rate = MGN_54M;        break;
-
-			default:
-				ret_rate = 0xff;
-				RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported Rate [%x], bIsHT = %d!!!\n", rate, bIsHT);
-				break;
+		case DESC90_RATE1M:   ret_rate = MGN_1M;         break;
+		case DESC90_RATE2M:   ret_rate = MGN_2M;         break;
+		case DESC90_RATE5_5M: ret_rate = MGN_5_5M;       break;
+		case DESC90_RATE11M:  ret_rate = MGN_11M;        break;
+		case DESC90_RATE6M:   ret_rate = MGN_6M;         break;
+		case DESC90_RATE9M:   ret_rate = MGN_9M;         break;
+		case DESC90_RATE12M:  ret_rate = MGN_12M;        break;
+		case DESC90_RATE18M:  ret_rate = MGN_18M;        break;
+		case DESC90_RATE24M:  ret_rate = MGN_24M;        break;
+		case DESC90_RATE36M:  ret_rate = MGN_36M;        break;
+		case DESC90_RATE48M:  ret_rate = MGN_48M;        break;
+		case DESC90_RATE54M:  ret_rate = MGN_54M;        break;
+
+		default:
+			ret_rate = 0xff;
+			RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported Rate [%x], bIsHT = %d!!!\n", rate, bIsHT);
+			break;
 		}
 
 	} else {
 		switch(rate) {
-			case DESC90_RATEMCS0:   ret_rate = MGN_MCS0;    break;
-			case DESC90_RATEMCS1:   ret_rate = MGN_MCS1;    break;
-			case DESC90_RATEMCS2:   ret_rate = MGN_MCS2;    break;
-			case DESC90_RATEMCS3:   ret_rate = MGN_MCS3;    break;
-			case DESC90_RATEMCS4:   ret_rate = MGN_MCS4;    break;
-			case DESC90_RATEMCS5:   ret_rate = MGN_MCS5;    break;
-			case DESC90_RATEMCS6:   ret_rate = MGN_MCS6;    break;
-			case DESC90_RATEMCS7:   ret_rate = MGN_MCS7;    break;
-			case DESC90_RATEMCS8:   ret_rate = MGN_MCS8;    break;
-			case DESC90_RATEMCS9:   ret_rate = MGN_MCS9;    break;
-			case DESC90_RATEMCS10:  ret_rate = MGN_MCS10;   break;
-			case DESC90_RATEMCS11:  ret_rate = MGN_MCS11;   break;
-			case DESC90_RATEMCS12:  ret_rate = MGN_MCS12;   break;
-			case DESC90_RATEMCS13:  ret_rate = MGN_MCS13;   break;
-			case DESC90_RATEMCS14:  ret_rate = MGN_MCS14;   break;
-			case DESC90_RATEMCS15:  ret_rate = MGN_MCS15;   break;
-			case DESC90_RATEMCS32:  ret_rate = (0x80|0x20); break;
-
-			default:
-				ret_rate = 0xff;
-				RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported Rate [%x], bIsHT = %d!!!\n",rate, bIsHT);
-				break;
+		case DESC90_RATEMCS0:   ret_rate = MGN_MCS0;    break;
+		case DESC90_RATEMCS1:   ret_rate = MGN_MCS1;    break;
+		case DESC90_RATEMCS2:   ret_rate = MGN_MCS2;    break;
+		case DESC90_RATEMCS3:   ret_rate = MGN_MCS3;    break;
+		case DESC90_RATEMCS4:   ret_rate = MGN_MCS4;    break;
+		case DESC90_RATEMCS5:   ret_rate = MGN_MCS5;    break;
+		case DESC90_RATEMCS6:   ret_rate = MGN_MCS6;    break;
+		case DESC90_RATEMCS7:   ret_rate = MGN_MCS7;    break;
+		case DESC90_RATEMCS8:   ret_rate = MGN_MCS8;    break;
+		case DESC90_RATEMCS9:   ret_rate = MGN_MCS9;    break;
+		case DESC90_RATEMCS10:  ret_rate = MGN_MCS10;   break;
+		case DESC90_RATEMCS11:  ret_rate = MGN_MCS11;   break;
+		case DESC90_RATEMCS12:  ret_rate = MGN_MCS12;   break;
+		case DESC90_RATEMCS13:  ret_rate = MGN_MCS13;   break;
+		case DESC90_RATEMCS14:  ret_rate = MGN_MCS14;   break;
+		case DESC90_RATEMCS15:  ret_rate = MGN_MCS15;   break;
+		case DESC90_RATEMCS32:  ret_rate = (0x80|0x20); break;
+
+		default:
+			ret_rate = 0xff;
+			RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported Rate [%x], bIsHT = %d!!!\n",rate, bIsHT);
+			break;
 		}
 	}
 
@@ -5696,25 +5696,25 @@ void rtl8192_irq_rx_tasklet(struct r8192_priv *priv)
 		info = (struct rtl8192_rx_info *)skb->cb;
 		switch (info->out_pipe) {
 		/* Nomal packet pipe */
-			case 3:
-				//RT_TRACE(COMP_RECV, "normal in-pipe index(%d)\n",info->out_pipe);
-				priv->IrpPendingCount--;
-				rtl8192_rx_nomal(skb);
-				break;
+		case 3:
+			//RT_TRACE(COMP_RECV, "normal in-pipe index(%d)\n",info->out_pipe);
+			priv->IrpPendingCount--;
+			rtl8192_rx_nomal(skb);
+			break;
 
-				/* Command packet pipe */
-			case 9:
-				RT_TRACE(COMP_RECV, "command in-pipe index(%d)\n",\
-						info->out_pipe);
+			/* Command packet pipe */
+		case 9:
+			RT_TRACE(COMP_RECV, "command in-pipe index(%d)\n",\
+					info->out_pipe);
 
-				rtl8192_rx_cmd(skb);
-				break;
+			rtl8192_rx_cmd(skb);
+			break;
 
-			default: /* should never get here! */
-				RT_TRACE(COMP_ERR, "Unknown in-pipe index(%d)\n",\
-						info->out_pipe);
-				dev_kfree_skb(skb);
-				break;
+		default: /* should never get here! */
+			RT_TRACE(COMP_ERR, "Unknown in-pipe index(%d)\n",\
+					info->out_pipe);
+			dev_kfree_skb(skb);
+			break;
 
 		}
 	}
diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index c1ab5cf..c904aa8 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -710,12 +710,12 @@ static int r8192_wx_set_enc(struct net_device *dev,
 		#define CONF_WEP104 0x14
 
 		switch(wrqu->encoding.flags & IW_ENCODE_INDEX){
-			case 0: key_idx = ieee->tx_keyidx; break;
-			case 1:	key_idx = 0; break;
-			case 2:	key_idx = 1; break;
-			case 3:	key_idx = 2; break;
-			case 4:	key_idx	= 3; break;
-			default: break;
+		case 0: key_idx = ieee->tx_keyidx; break;
+		case 1:	key_idx = 0; break;
+		case 2:	key_idx = 1; break;
+		case 3:	key_idx = 2; break;
+		case 4:	key_idx	= 3; break;
+		default: break;
 		}
 
 		if(wrqu->encoding.length==0x5){
diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
index 46b8043..573e9cd 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -334,56 +334,56 @@ bool init_firmware(struct net_device *dev)
 		}
 
 		switch(init_step) {
-			case FW_INIT_STEP0_BOOT:
-				/* Download boot
-				 * initialize command descriptor.
-				 * will set polling bit when firmware code is also configured
-				 */
-				pfirmware->firmware_status = FW_STATUS_1_MOVE_BOOT_CODE;
+		case FW_INIT_STEP0_BOOT:
+			/* Download boot
+			 * initialize command descriptor.
+			 * will set polling bit when firmware code is also configured
+			 */
+			pfirmware->firmware_status = FW_STATUS_1_MOVE_BOOT_CODE;
 #ifdef RTL8190P
-				// To initialize IMEM, CPU move code  from 0x80000080, hence, we send 0x80 byte packet
-				rt_status = fwSendNullPacket(dev, RTL8190_CPU_START_OFFSET);
-				if(rt_status != true)
-				{
-					RT_TRACE(COMP_INIT, "fwSendNullPacket() fail ! \n");
-					goto  download_firmware_fail;
-				}
+			// To initialize IMEM, CPU move code  from 0x80000080, hence, we send 0x80 byte packet
+			rt_status = fwSendNullPacket(dev, RTL8190_CPU_START_OFFSET);
+			if(rt_status != true)
+			{
+				RT_TRACE(COMP_INIT, "fwSendNullPacket() fail ! \n");
+				goto  download_firmware_fail;
+			}
 #endif
-				//mdelay(1000);
-				/*
-				 * To initialize IMEM, CPU move code  from 0x80000080,
-				 * hence, we send 0x80 byte packet
-				 */
-				break;
-
-			case FW_INIT_STEP1_MAIN:
-				/* Download firmware code. Wait until Boot Ready and Turn on CPU */
-				pfirmware->firmware_status = FW_STATUS_2_MOVE_MAIN_CODE;
-
-				/* Check Put Code OK and Turn On CPU */
-				rt_status = CPUcheck_maincodeok_turnonCPU(dev);
-				if(rt_status != TRUE) {
-					RT_TRACE(COMP_ERR, "CPUcheck_maincodeok_turnonCPU fail!\n");
-					goto download_firmware_fail;
-				}
-
-				pfirmware->firmware_status = FW_STATUS_3_TURNON_CPU;
-				break;
-
-			case FW_INIT_STEP2_DATA:
-				/* download initial data code */
-				pfirmware->firmware_status = FW_STATUS_4_MOVE_DATA_CODE;
-				mdelay(1);
-
-				rt_status = CPUcheck_firmware_ready(dev);
-				if(rt_status != TRUE) {
-					RT_TRACE(COMP_ERR, "CPUcheck_firmware_ready fail(%d)!\n",rt_status);
-					goto download_firmware_fail;
-				}
-
-				/* wait until data code is initialized ready.*/
-				pfirmware->firmware_status = FW_STATUS_5_READY;
-				break;
+			//mdelay(1000);
+			/*
+			 * To initialize IMEM, CPU move code  from 0x80000080,
+			 * hence, we send 0x80 byte packet
+			 */
+			break;
+
+		case FW_INIT_STEP1_MAIN:
+			/* Download firmware code. Wait until Boot Ready and Turn on CPU */
+			pfirmware->firmware_status = FW_STATUS_2_MOVE_MAIN_CODE;
+
+			/* Check Put Code OK and Turn On CPU */
+			rt_status = CPUcheck_maincodeok_turnonCPU(dev);
+			if(rt_status != TRUE) {
+				RT_TRACE(COMP_ERR, "CPUcheck_maincodeok_turnonCPU fail!\n");
+				goto download_firmware_fail;
+			}
+
+			pfirmware->firmware_status = FW_STATUS_3_TURNON_CPU;
+			break;
+
+		case FW_INIT_STEP2_DATA:
+			/* download initial data code */
+			pfirmware->firmware_status = FW_STATUS_4_MOVE_DATA_CODE;
+			mdelay(1);
+
+			rt_status = CPUcheck_firmware_ready(dev);
+			if(rt_status != TRUE) {
+				RT_TRACE(COMP_ERR, "CPUcheck_firmware_ready fail(%d)!\n",rt_status);
+				goto download_firmware_fail;
+			}
+
+			/* wait until data code is initialized ready.*/
+			pfirmware->firmware_status = FW_STATUS_5_READY;
+			break;
 		}
 	}
 
diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
index 2ff851f..17fac41 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -957,56 +957,56 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device* dev, RF90_RADIO_PATH_E
 	u8 ret = 0;
 
 	switch(eRFPath){
-		case RF90_PATH_A:
-			for(i = 0;i<RadioA_ArrayLength; i=i+2){
-
-				if(rtl819XRadioA_Array[i] == 0xfe){
-						mdelay(100);
-						continue;
-				}
-				rtl8192_phy_SetRFReg(dev, eRFPath, rtl819XRadioA_Array[i], bMask12Bits, rtl819XRadioA_Array[i+1]);
-				mdelay(1);
+	case RF90_PATH_A:
+		for(i = 0;i<RadioA_ArrayLength; i=i+2){
 
+			if(rtl819XRadioA_Array[i] == 0xfe){
+					mdelay(100);
+					continue;
 			}
-			break;
-		case RF90_PATH_B:
-			for(i = 0;i<RadioB_ArrayLength; i=i+2){
+			rtl8192_phy_SetRFReg(dev, eRFPath, rtl819XRadioA_Array[i], bMask12Bits, rtl819XRadioA_Array[i+1]);
+			mdelay(1);
 
-				if(rtl819XRadioB_Array[i] == 0xfe){
-						mdelay(100);
-						continue;
-				}
-				rtl8192_phy_SetRFReg(dev, eRFPath, rtl819XRadioB_Array[i], bMask12Bits, rtl819XRadioB_Array[i+1]);
-				mdelay(1);
+		}
+		break;
+	case RF90_PATH_B:
+		for(i = 0;i<RadioB_ArrayLength; i=i+2){
 
+			if(rtl819XRadioB_Array[i] == 0xfe){
+					mdelay(100);
+					continue;
 			}
-			break;
-		case RF90_PATH_C:
-			for(i = 0;i<RadioC_ArrayLength; i=i+2){
+			rtl8192_phy_SetRFReg(dev, eRFPath, rtl819XRadioB_Array[i], bMask12Bits, rtl819XRadioB_Array[i+1]);
+			mdelay(1);
 
-				if(rtl819XRadioC_Array[i] == 0xfe){
-						mdelay(100);
-						continue;
-				}
-				rtl8192_phy_SetRFReg(dev, eRFPath, rtl819XRadioC_Array[i], bMask12Bits, rtl819XRadioC_Array[i+1]);
-				mdelay(1);
+		}
+		break;
+	case RF90_PATH_C:
+		for(i = 0;i<RadioC_ArrayLength; i=i+2){
 
+			if(rtl819XRadioC_Array[i] == 0xfe){
+					mdelay(100);
+					continue;
 			}
-			break;
-		case RF90_PATH_D:
-			for(i = 0;i<RadioD_ArrayLength; i=i+2){
+			rtl8192_phy_SetRFReg(dev, eRFPath, rtl819XRadioC_Array[i], bMask12Bits, rtl819XRadioC_Array[i+1]);
+			mdelay(1);
 
-				if(rtl819XRadioD_Array[i] == 0xfe){
-						mdelay(100);
-						continue;
-				}
-				rtl8192_phy_SetRFReg(dev, eRFPath, rtl819XRadioD_Array[i], bMask12Bits, rtl819XRadioD_Array[i+1]);
-				mdelay(1);
+		}
+		break;
+	case RF90_PATH_D:
+		for(i = 0;i<RadioD_ArrayLength; i=i+2){
 
+			if(rtl819XRadioD_Array[i] == 0xfe){
+					mdelay(100);
+					continue;
 			}
-			break;
-		default:
-			break;
+			rtl8192_phy_SetRFReg(dev, eRFPath, rtl819XRadioD_Array[i], bMask12Bits, rtl819XRadioD_Array[i+1]);
+			mdelay(1);
+
+		}
+		break;
+	default:
+		break;
 	}
 
 	return ret;
-- 
1.7.10.4


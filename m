Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2LEUvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:51:47 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37429 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412Ab2LEUva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:51:30 -0500
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
Subject: [PATCH 3/6] staging/rtl8192u: indent with tabs, not spaces
Date: Wed,  5 Dec 2012 21:40:20 +0100
Message-Id: <1354740023-30849-4-git-send-email-snsehahn@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
References: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted staging/rtl8187se to use tabs instead of spaces for
indentation to fix the checkpatch error "code indent should use tabs
where possible".

Signed-off-by: Sebastian Hahn <snsehahn@cip.cs.fau.de>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |   14 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |  370 ++++++++++----------
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    4 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |   14 +-
 drivers/staging/rtl8192u/ieee80211/rtl_crypto.h    |   84 ++---
 drivers/staging/rtl8192u/r8180_93cx6.c             |    2 +-
 drivers/staging/rtl8192u/r8180_93cx6.c.bak         |  146 ++++++++
 drivers/staging/rtl8192u/r8180_pm.h                |    2 +-
 drivers/staging/rtl8192u/r8192U.h                  |  198 +++++------
 drivers/staging/rtl8192u/r8192U_core.c             |   42 +--
 10 files changed, 511 insertions(+), 365 deletions(-)
 create mode 100644 drivers/staging/rtl8192u/r8180_93cx6.c.bak

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index b85e3e3..210898c 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -2088,10 +2088,10 @@ struct ieee80211_device {
 	 struct delayed_work start_ibss_wq;
 	struct work_struct wx_sync_scan_wq;
 	struct workqueue_struct *wq;
-        // Qos related. Added by Annie, 2005-11-01.
-        //STA_QOS  StaQos;
+	// Qos related. Added by Annie, 2005-11-01.
+	//STA_QOS  StaQos;
 
-        //u32 STA_EDCA_PARAM[4];
+	//u32 STA_EDCA_PARAM[4];
 	//CHANNEL_ACCESS_SETTING ChannelAccessSetting;
 
 
@@ -2107,11 +2107,11 @@ struct ieee80211_device {
 			       struct net_device *dev);
 
 	int (*reset_port)(struct net_device *dev);
-        int (*is_queue_full) (struct net_device * dev, int pri);
+	int (*is_queue_full) (struct net_device * dev, int pri);
 
-        int (*handle_management) (struct net_device * dev,
-                                  struct ieee80211_network * network, u16 type);
-        int (*is_qos_active) (struct net_device *dev, struct sk_buff *skb);
+	int (*handle_management) (struct net_device * dev,
+				  struct ieee80211_network * network, u16 type);
+	int (*is_qos_active) (struct net_device *dev, struct sk_buff *skb);
 
 	/* Softmac-generated frames (management) are TXed via this
 	 * callback if the flag IEEE_SOFTMAC_SINGLE_QUEUE is
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 8e58647..ee7ce5f 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -52,7 +52,7 @@ static inline void ieee80211_monitor_rx(struct ieee80211_device *ieee,
 	u16 fc = le16_to_cpu(hdr->frame_ctl);
 
 	skb->dev = ieee->dev;
-        skb_reset_mac_header(skb);
+	skb_reset_mac_header(skb);
 
 	skb_pull(skb, ieee80211_get_hdrlen(fc));
 	skb->pkt_type = PACKET_OTHERHOST;
@@ -218,16 +218,16 @@ ieee80211_rx_frame_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb,
 	 * this is not mandatory.... but seems that the probe
 	 * response parser uses it
 	 */
-        struct ieee80211_hdr_3addr * hdr = (struct ieee80211_hdr_3addr *)skb->data;
+	struct ieee80211_hdr_3addr * hdr = (struct ieee80211_hdr_3addr *)skb->data;
 
 	rx_stats->len = skb->len;
 	ieee80211_rx_mgt(ieee,(struct ieee80211_hdr_4addr *)skb->data,rx_stats);
-        //if ((ieee->state == IEEE80211_LINKED) && (memcmp(hdr->addr3, ieee->current_network.bssid, ETH_ALEN)))
-        if ((memcmp(hdr->addr1, ieee->dev->dev_addr, ETH_ALEN)))//use ADDR1 to perform address matching for Management frames
-        {
-                dev_kfree_skb_any(skb);
-                return 0;
-        }
+	//if ((ieee->state == IEEE80211_LINKED) && (memcmp(hdr->addr3, ieee->current_network.bssid, ETH_ALEN)))
+	if ((memcmp(hdr->addr1, ieee->dev->dev_addr, ETH_ALEN)))//use ADDR1 to perform address matching for Management frames
+	{
+		dev_kfree_skb_any(skb);
+		return 0;
+	}
 
 	ieee80211_rx_frame_softmac(ieee, skb, rx_stats, type, stype);
 
@@ -773,7 +773,7 @@ void RxReorderIndicatePacket( struct ieee80211_device *ieee,
 }
 
 u8 parse_subframe(struct sk_buff *skb,
-                  struct ieee80211_rx_stats *rx_stats,
+		  struct ieee80211_rx_stats *rx_stats,
 		  struct ieee80211_rxb *rxb,u8* src,u8* dst)
 {
 	struct ieee80211_hdr_3addr  *hdr = (struct ieee80211_hdr_3addr* )skb->data;
@@ -1154,8 +1154,8 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 				type, stype, skb->len);
 		goto rx_dropped;
 	}
-        if (memcmp(bssid, ieee->current_network.bssid, ETH_ALEN))
-                goto rx_dropped;
+	if (memcmp(bssid, ieee->current_network.bssid, ETH_ALEN))
+		goto rx_dropped;
 
 	/* skb: hdr + (possibly fragmented, possibly encrypted) payload */
 
@@ -1402,19 +1402,19 @@ static u8 qos_oui[QOS_OUI_LEN] = { 0x00, 0x50, 0xF2 };
 * the right values
 */
 static int ieee80211_verify_qos_info(struct ieee80211_qos_information_element
-                                     *info_element, int sub_type)
+				     *info_element, int sub_type)
 {
 
-        if (info_element->qui_subtype != sub_type)
-                return -1;
-        if (memcmp(info_element->qui, qos_oui, QOS_OUI_LEN))
-                return -1;
-        if (info_element->qui_type != QOS_OUI_TYPE)
-                return -1;
-        if (info_element->version != QOS_VERSION_1)
-                return -1;
+	if (info_element->qui_subtype != sub_type)
+		return -1;
+	if (memcmp(info_element->qui, qos_oui, QOS_OUI_LEN))
+		return -1;
+	if (info_element->qui_type != QOS_OUI_TYPE)
+		return -1;
+	if (info_element->version != QOS_VERSION_1)
+		return -1;
 
-        return 0;
+	return 0;
 }
 
 
@@ -1422,56 +1422,56 @@ static int ieee80211_verify_qos_info(struct ieee80211_qos_information_element
  * Parse a QoS parameter element
  */
 static int ieee80211_read_qos_param_element(struct ieee80211_qos_parameter_info
-                                            *element_param, struct ieee80211_info_element
-                                            *info_element)
+					    *element_param, struct ieee80211_info_element
+					    *info_element)
 {
-        int ret = 0;
-        u16 size = sizeof(struct ieee80211_qos_parameter_info) - 2;
-
-        if ((info_element == NULL) || (element_param == NULL))
-                return -1;
-
-        if (info_element->id == QOS_ELEMENT_ID && info_element->len == size) {
-                memcpy(element_param->info_element.qui, info_element->data,
-                       info_element->len);
-                element_param->info_element.elementID = info_element->id;
-                element_param->info_element.length = info_element->len;
-        } else
-                ret = -1;
-        if (ret == 0)
-                ret = ieee80211_verify_qos_info(&element_param->info_element,
-                                                QOS_OUI_PARAM_SUB_TYPE);
-        return ret;
+	int ret = 0;
+	u16 size = sizeof(struct ieee80211_qos_parameter_info) - 2;
+
+	if ((info_element == NULL) || (element_param == NULL))
+		return -1;
+
+	if (info_element->id == QOS_ELEMENT_ID && info_element->len == size) {
+		memcpy(element_param->info_element.qui, info_element->data,
+		       info_element->len);
+		element_param->info_element.elementID = info_element->id;
+		element_param->info_element.length = info_element->len;
+	} else
+		ret = -1;
+	if (ret == 0)
+		ret = ieee80211_verify_qos_info(&element_param->info_element,
+						QOS_OUI_PARAM_SUB_TYPE);
+	return ret;
 }
 
 /*
  * Parse a QoS information element
  */
 static int ieee80211_read_qos_info_element(struct
-                                           ieee80211_qos_information_element
-                                           *element_info, struct ieee80211_info_element
-                                           *info_element)
+					   ieee80211_qos_information_element
+					   *element_info, struct ieee80211_info_element
+					   *info_element)
 {
-        int ret = 0;
-        u16 size = sizeof(struct ieee80211_qos_information_element) - 2;
-
-        if (element_info == NULL)
-                return -1;
-        if (info_element == NULL)
-                return -1;
-
-        if ((info_element->id == QOS_ELEMENT_ID) && (info_element->len == size)) {
-                memcpy(element_info->qui, info_element->data,
-                       info_element->len);
-                element_info->elementID = info_element->id;
-                element_info->length = info_element->len;
-        } else
-                ret = -1;
-
-        if (ret == 0)
-                ret = ieee80211_verify_qos_info(element_info,
-                                                QOS_OUI_INFO_SUB_TYPE);
-        return ret;
+	int ret = 0;
+	u16 size = sizeof(struct ieee80211_qos_information_element) - 2;
+
+	if (element_info == NULL)
+		return -1;
+	if (info_element == NULL)
+		return -1;
+
+	if ((info_element->id == QOS_ELEMENT_ID) && (info_element->len == size)) {
+		memcpy(element_info->qui, info_element->data,
+		       info_element->len);
+		element_info->elementID = info_element->id;
+		element_info->length = info_element->len;
+	} else
+		ret = -1;
+
+	if (ret == 0)
+		ret = ieee80211_verify_qos_info(element_info,
+						QOS_OUI_INFO_SUB_TYPE);
+	return ret;
 }
 
 
@@ -1479,39 +1479,39 @@ static int ieee80211_read_qos_info_element(struct
  * Write QoS parameters from the ac parameters.
  */
 static int ieee80211_qos_convert_ac_to_parameters(struct
-                                                  ieee80211_qos_parameter_info
-                                                  *param_elm, struct
-                                                  ieee80211_qos_parameters
-                                                  *qos_param)
+						  ieee80211_qos_parameter_info
+						  *param_elm, struct
+						  ieee80211_qos_parameters
+						  *qos_param)
 {
-        int rc = 0;
-        int i;
-        struct ieee80211_qos_ac_parameter *ac_params;
+	int rc = 0;
+	int i;
+	struct ieee80211_qos_ac_parameter *ac_params;
 	u8 aci;
-        //u8 cw_min;
-        //u8 cw_max;
+	//u8 cw_min;
+	//u8 cw_max;
 
-        for (i = 0; i < QOS_QUEUE_NUM; i++) {
-                ac_params = &(param_elm->ac_params_record[i]);
+	for (i = 0; i < QOS_QUEUE_NUM; i++) {
+		ac_params = &(param_elm->ac_params_record[i]);
 
 		aci = (ac_params->aci_aifsn & 0x60) >> 5;
 
 		if(aci >= QOS_QUEUE_NUM)
 			continue;
-                qos_param->aifs[aci] = (ac_params->aci_aifsn) & 0x0f;
+		qos_param->aifs[aci] = (ac_params->aci_aifsn) & 0x0f;
 
 		/* WMM spec P.11: The minimum value for AIFSN shall be 2 */
-                qos_param->aifs[aci] = (qos_param->aifs[aci] < 2) ? 2:qos_param->aifs[aci];
+		qos_param->aifs[aci] = (qos_param->aifs[aci] < 2) ? 2:qos_param->aifs[aci];
 
-                qos_param->cw_min[aci] = ac_params->ecw_min_max & 0x0F;
+		qos_param->cw_min[aci] = ac_params->ecw_min_max & 0x0F;
 
-                qos_param->cw_max[aci] = (ac_params->ecw_min_max & 0xF0) >> 4;
+		qos_param->cw_max[aci] = (ac_params->ecw_min_max & 0xF0) >> 4;
 
-                qos_param->flag[aci] =
-                    (ac_params->aci_aifsn & 0x10) ? 0x01 : 0x00;
-                qos_param->tx_op_limit[aci] = le16_to_cpu(ac_params->tx_op_limit);
-        }
-        return rc;
+		qos_param->flag[aci] =
+		    (ac_params->aci_aifsn & 0x10) ? 0x01 : 0x00;
+		qos_param->tx_op_limit[aci] = le16_to_cpu(ac_params->tx_op_limit);
+	}
+	return rc;
 }
 
 /*
@@ -1520,38 +1520,38 @@ static int ieee80211_qos_convert_ac_to_parameters(struct
  * which type to read
  */
 static int ieee80211_parse_qos_info_param_IE(struct ieee80211_info_element
-                                             *info_element,
-                                             struct ieee80211_network *network)
+					     *info_element,
+					     struct ieee80211_network *network)
 {
-        int rc = 0;
-        struct ieee80211_qos_parameters *qos_param = NULL;
-        struct ieee80211_qos_information_element qos_info_element;
-
-        rc = ieee80211_read_qos_info_element(&qos_info_element, info_element);
-
-        if (rc == 0) {
-                network->qos_data.param_count = qos_info_element.ac_info & 0x0F;
-                network->flags |= NETWORK_HAS_QOS_INFORMATION;
-        } else {
-                struct ieee80211_qos_parameter_info param_element;
-
-                rc = ieee80211_read_qos_param_element(&param_element,
-                                                      info_element);
-                if (rc == 0) {
-                        qos_param = &(network->qos_data.parameters);
-                        ieee80211_qos_convert_ac_to_parameters(&param_element,
-                                                               qos_param);
-                        network->flags |= NETWORK_HAS_QOS_PARAMETERS;
-                        network->qos_data.param_count =
-                            param_element.info_element.ac_info & 0x0F;
-                }
-        }
-
-        if (rc == 0) {
-                IEEE80211_DEBUG_QOS("QoS is supported\n");
-                network->qos_data.supported = 1;
-        }
-        return rc;
+	int rc = 0;
+	struct ieee80211_qos_parameters *qos_param = NULL;
+	struct ieee80211_qos_information_element qos_info_element;
+
+	rc = ieee80211_read_qos_info_element(&qos_info_element, info_element);
+
+	if (rc == 0) {
+		network->qos_data.param_count = qos_info_element.ac_info & 0x0F;
+		network->flags |= NETWORK_HAS_QOS_INFORMATION;
+	} else {
+		struct ieee80211_qos_parameter_info param_element;
+
+		rc = ieee80211_read_qos_param_element(&param_element,
+						      info_element);
+		if (rc == 0) {
+			qos_param = &(network->qos_data.parameters);
+			ieee80211_qos_convert_ac_to_parameters(&param_element,
+							       qos_param);
+			network->flags |= NETWORK_HAS_QOS_PARAMETERS;
+			network->qos_data.param_count =
+			    param_element.info_element.ac_info & 0x0F;
+		}
+	}
+
+	if (rc == 0) {
+		IEEE80211_DEBUG_QOS("QoS is supported\n");
+		network->qos_data.supported = 1;
+	}
+	return rc;
 }
 
 #ifdef CONFIG_IEEE80211_DEBUG
@@ -1559,37 +1559,37 @@ static int ieee80211_parse_qos_info_param_IE(struct ieee80211_info_element
 
 static const char *get_info_element_string(u16 id)
 {
-        switch (id) {
-                MFIE_STRING(SSID);
-                MFIE_STRING(RATES);
-                MFIE_STRING(FH_SET);
-                MFIE_STRING(DS_SET);
-                MFIE_STRING(CF_SET);
-                MFIE_STRING(TIM);
-                MFIE_STRING(IBSS_SET);
-                MFIE_STRING(COUNTRY);
-                MFIE_STRING(HOP_PARAMS);
-                MFIE_STRING(HOP_TABLE);
-                MFIE_STRING(REQUEST);
-                MFIE_STRING(CHALLENGE);
-                MFIE_STRING(POWER_CONSTRAINT);
-                MFIE_STRING(POWER_CAPABILITY);
-                MFIE_STRING(TPC_REQUEST);
-                MFIE_STRING(TPC_REPORT);
-                MFIE_STRING(SUPP_CHANNELS);
-                MFIE_STRING(CSA);
-                MFIE_STRING(MEASURE_REQUEST);
-                MFIE_STRING(MEASURE_REPORT);
-                MFIE_STRING(QUIET);
-                MFIE_STRING(IBSS_DFS);
-               // MFIE_STRING(ERP_INFO);
-                MFIE_STRING(RSN);
-                MFIE_STRING(RATES_EX);
-                MFIE_STRING(GENERIC);
-                MFIE_STRING(QOS_PARAMETER);
-        default:
-                return "UNKNOWN";
-        }
+	switch (id) {
+		MFIE_STRING(SSID);
+		MFIE_STRING(RATES);
+		MFIE_STRING(FH_SET);
+		MFIE_STRING(DS_SET);
+		MFIE_STRING(CF_SET);
+		MFIE_STRING(TIM);
+		MFIE_STRING(IBSS_SET);
+		MFIE_STRING(COUNTRY);
+		MFIE_STRING(HOP_PARAMS);
+		MFIE_STRING(HOP_TABLE);
+		MFIE_STRING(REQUEST);
+		MFIE_STRING(CHALLENGE);
+		MFIE_STRING(POWER_CONSTRAINT);
+		MFIE_STRING(POWER_CAPABILITY);
+		MFIE_STRING(TPC_REQUEST);
+		MFIE_STRING(TPC_REPORT);
+		MFIE_STRING(SUPP_CHANNELS);
+		MFIE_STRING(CSA);
+		MFIE_STRING(MEASURE_REQUEST);
+		MFIE_STRING(MEASURE_REPORT);
+		MFIE_STRING(QUIET);
+		MFIE_STRING(IBSS_DFS);
+	       // MFIE_STRING(ERP_INFO);
+		MFIE_STRING(RSN);
+		MFIE_STRING(RATES_EX);
+		MFIE_STRING(GENERIC);
+		MFIE_STRING(QOS_PARAMETER);
+	default:
+		return "UNKNOWN";
+	}
 }
 #endif
 
@@ -1634,7 +1634,7 @@ int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 {
 	u8 i;
 	short offset;
-        u16	tmp_htcap_len=0;
+	u16	tmp_htcap_len=0;
 	u16	tmp_htinfo_len=0;
 	u16 ht_realtek_agg_len=0;
 	u8  ht_realtek_agg_buf[MAX_IE_LEN];
@@ -1752,34 +1752,34 @@ int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 			network->tim.tim_count = info_element->data[0];
 			network->tim.tim_period = info_element->data[1];
 
-                        network->dtim_period = info_element->data[1];
-                        if(ieee->state != IEEE80211_LINKED)
-                                break;
+			network->dtim_period = info_element->data[1];
+			if(ieee->state != IEEE80211_LINKED)
+				break;
 
-                        network->last_dtim_sta_time[0] = stats->mac_time[0];
-                        network->last_dtim_sta_time[1] = stats->mac_time[1];
+			network->last_dtim_sta_time[0] = stats->mac_time[0];
+			network->last_dtim_sta_time[1] = stats->mac_time[1];
 
-                        network->dtim_data = IEEE80211_DTIM_VALID;
+			network->dtim_data = IEEE80211_DTIM_VALID;
 
-                        if(info_element->data[0] != 0)
-                                break;
+			if(info_element->data[0] != 0)
+				break;
 
-                        if(info_element->data[2] & 1)
-                                network->dtim_data |= IEEE80211_DTIM_MBCAST;
+			if(info_element->data[2] & 1)
+				network->dtim_data |= IEEE80211_DTIM_MBCAST;
 
-                        offset = (info_element->data[2] >> 1)*2;
+			offset = (info_element->data[2] >> 1)*2;
 
-                        //printk("offset1:%x aid:%x\n",offset, ieee->assoc_id);
+			//printk("offset1:%x aid:%x\n",offset, ieee->assoc_id);
 
-                        if(ieee->assoc_id < 8*offset ||
-                                ieee->assoc_id > 8*(offset + info_element->len -3))
+			if(ieee->assoc_id < 8*offset ||
+				ieee->assoc_id > 8*(offset + info_element->len -3))
 
-                                break;
+				break;
 
-                        offset = (ieee->assoc_id / 8) - offset;// + ((aid % 8)? 0 : 1) ;
+			offset = (ieee->assoc_id / 8) - offset;// + ((aid % 8)? 0 : 1) ;
 
-                        if(info_element->data[3+offset] & (1<<(ieee->assoc_id%8)))
-                                network->dtim_data |= IEEE80211_DTIM_UCAST;
+			if(info_element->data[3+offset] & (1<<(ieee->assoc_id%8)))
+				network->dtim_data |= IEEE80211_DTIM_UCAST;
 
 			//IEEE80211_DEBUG_MGMT("MFIE_TYPE_TIM: partially ignored\n");
 			break;
@@ -1820,17 +1820,17 @@ int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 			}
 
 #ifdef THOMAS_TURBO
-                        if (info_element->len == 7 &&
-                            info_element->data[0] == 0x00 &&
-                            info_element->data[1] == 0xe0 &&
-                            info_element->data[2] == 0x4c &&
-                            info_element->data[3] == 0x01 &&
-                            info_element->data[4] == 0x02) {
-                                network->Turbo_Enable = 1;
-                        }
+			if (info_element->len == 7 &&
+			    info_element->data[0] == 0x00 &&
+			    info_element->data[1] == 0xe0 &&
+			    info_element->data[2] == 0x4c &&
+			    info_element->data[3] == 0x01 &&
+			    info_element->data[4] == 0x02) {
+				network->Turbo_Enable = 1;
+			}
 #endif
 
-                        //for HTcap and HTinfo parameters
+			//for HTcap and HTinfo parameters
 			if(tmp_htcap_len == 0){
 				if(info_element->len >= 4 &&
 				   info_element->data[0] == 0x00 &&
@@ -2014,7 +2014,7 @@ int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 			       network->rsn_ie_len);
 			break;
 
-                        //HT related element.
+			//HT related element.
 		case MFIE_TYPE_HT_CAP:
 			IEEE80211_DEBUG_SCAN("MFIE_TYPE_HT_CAP: %d bytes\n",
 					     info_element->len);
@@ -2027,7 +2027,7 @@ int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 
 				//If peer is HT, but not WMM, call QosSetLegacyWMMParamWithHT()
 				// windows driver will update WMM parameters each beacon received once connected
-                                // Linux driver is a bit different.
+				// Linux driver is a bit different.
 				network->bssht.bdSupportHT = true;
 			}
 			else
@@ -2189,10 +2189,10 @@ static inline int ieee80211_network_init(
 	//char *p;
 #endif
 
-        network->qos_data.active = 0;
-        network->qos_data.supported = 0;
-        network->qos_data.param_count = 0;
-        network->qos_data.old_param_count = 0;
+	network->qos_data.active = 0;
+	network->qos_data.supported = 0;
+	network->qos_data.param_count = 0;
+	network->qos_data.old_param_count = 0;
 
 	/* Pull out fixed field data */
 	memcpy(network->bssid, beacon->header.addr3, ETH_ALEN);
@@ -2209,9 +2209,9 @@ static inline int ieee80211_network_init(
 	network->flags = 0;
 	network->atim_window = 0;
 	network->erp_value = (network->capability & WLAN_CAPABILITY_IBSS) ?
-            0x3 : 0x0;
+	    0x3 : 0x0;
 	network->berp_info_valid = false;
-        network->broadcom_cap_exist = false;
+	network->broadcom_cap_exist = false;
 	network->ralink_cap_exist = false;
 	network->atheros_cap_exist = false;
 	network->cisco_cap_exist = false;
@@ -2233,9 +2233,9 @@ static inline int ieee80211_network_init(
 	network->wpa_ie_len = 0;
 	network->rsn_ie_len = 0;
 
-        if (ieee80211_parse_info_param
-            (ieee,beacon->info_element, stats->len - sizeof(*beacon), network, stats))
-                return 1;
+	if (ieee80211_parse_info_param
+	    (ieee,beacon->info_element, stats->len - sizeof(*beacon), network, stats))
+		return 1;
 
 	network->mode = 0;
 	if (stats->freq == IEEE80211_52GHZ_BAND)
@@ -2329,7 +2329,7 @@ static inline void update_network(struct ieee80211_network *dst,
 	dst->last_dtim_sta_time[1] = src->last_dtim_sta_time[1];
 	memcpy(&dst->tim, &src->tim, sizeof(struct ieee80211_tim_parameters));
 
-        dst->bssht.bdSupportHT = src->bssht.bdSupportHT;
+	dst->bssht.bdSupportHT = src->bssht.bdSupportHT;
 	dst->bssht.bdRT2RTAggregation = src->bssht.bdRT2RTAggregation;
 	dst->bssht.bdHTCapLen= src->bssht.bdHTCapLen;
 	memcpy(dst->bssht.bdHTCapBuf,src->bssht.bdHTCapBuf,src->bssht.bdHTCapLen);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 2c2bd00..e83c310 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -2503,8 +2503,8 @@ void ieee80211_disassociate(struct ieee80211_device *ieee)
 }
 void ieee80211_associate_retry_wq(struct work_struct *work)
 {
-        struct delayed_work *dwork = container_of(work, struct delayed_work, work);
-        struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, associate_retry_wq);
+	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, associate_retry_wq);
 	unsigned long flags;
 
 	down(&ieee->wx_sem);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 918dee7..7214361 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -70,7 +70,7 @@ val  | 0  |  0  |  0  |  1  |  x  |  0  |  0  |  0  |  1  |  0  |  x  |  x  |  x
 desc | ^-ver-^  |  ^type-^  |  ^-----subtype-----^  | to  |from |more |retry| pwr |more |wep   |
      |          |           | x=0 data,x=1 data+ack | DS  | DS  |frag |     | mgm |data |      |
      '-----------------------------------------------------------------------------------------'
-		                                    /\
+                                                    /\
                                                     |
 802.11 Data Frame                                   |
            ,--------- 'ctrl' expands to >-----------'
@@ -656,17 +656,17 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		memcpy(&dest, skb->data, ETH_ALEN);
 		memcpy(&src, skb->data+ETH_ALEN, ETH_ALEN);
 
-                /* Advance the SKB to the start of the payload */
-                skb_pull(skb, sizeof(struct ethhdr));
+		/* Advance the SKB to the start of the payload */
+		skb_pull(skb, sizeof(struct ethhdr));
 
-                /* Determine total amount of storage required for TXB packets */
-                bytes = skb->len + SNAP_SIZE + sizeof(u16);
+		/* Determine total amount of storage required for TXB packets */
+		bytes = skb->len + SNAP_SIZE + sizeof(u16);
 
 		if (encrypt)
 			fc = IEEE80211_FTYPE_DATA | IEEE80211_FCTL_WEP;
 		else
 
-                        fc = IEEE80211_FTYPE_DATA;
+			fc = IEEE80211_FTYPE_DATA;
 
 		//if(ieee->current_network.QoS_Enable)
 		if(qos_actived)
@@ -689,7 +689,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 			memcpy(&header.addr3, ieee->current_network.bssid, ETH_ALEN);
 		}
 
-                header.frame_ctl = cpu_to_le16(fc);
+		header.frame_ctl = cpu_to_le16(fc);
 
 		/* Determine fragmentation size based on destination (multicast
 		* and broadcast are not fragmented) */
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl_crypto.h b/drivers/staging/rtl8192u/ieee80211/rtl_crypto.h
index a8df410..c3c8710 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl_crypto.h
+++ b/drivers/staging/rtl8192u/ieee80211/rtl_crypto.h
@@ -73,7 +73,7 @@ struct cipher_alg {
 	unsigned int cia_min_keysize;
 	unsigned int cia_max_keysize;
 	int (*cia_setkey)(void *ctx, const u8 *key,
-	                  unsigned int keylen, u32 *flags);
+			  unsigned int keylen, u32 *flags);
 	void (*cia_encrypt)(void *ctx, u8 *dst, const u8 *src);
 	void (*cia_decrypt)(void *ctx, u8 *dst, const u8 *src);
 };
@@ -84,16 +84,16 @@ struct digest_alg {
 	void (*dia_update)(void *ctx, const u8 *data, unsigned int len);
 	void (*dia_final)(void *ctx, u8 *out);
 	int (*dia_setkey)(void *ctx, const u8 *key,
-	                  unsigned int keylen, u32 *flags);
+			  unsigned int keylen, u32 *flags);
 };
 
 struct compress_alg {
 	int (*coa_init)(void *ctx);
 	void (*coa_exit)(void *ctx);
 	int (*coa_compress)(void *ctx, const u8 *src, unsigned int slen,
-	                    u8 *dst, unsigned int *dlen);
+			    u8 *dst, unsigned int *dlen);
 	int (*coa_decompress)(void *ctx, const u8 *src, unsigned int slen,
-	                      u8 *dst, unsigned int *dlen);
+			      u8 *dst, unsigned int *dlen);
 };
 
 #define cra_cipher	cra_u.cipher
@@ -139,15 +139,15 @@ struct cipher_tfm {
 	unsigned int cit_ivsize;
 	u32 cit_mode;
 	int (*cit_setkey)(struct crypto_tfm *tfm,
-	                  const u8 *key, unsigned int keylen);
+			  const u8 *key, unsigned int keylen);
 	int (*cit_encrypt)(struct crypto_tfm *tfm,
 			   struct scatterlist *dst,
 			   struct scatterlist *src,
 			   unsigned int nbytes);
 	int (*cit_encrypt_iv)(struct crypto_tfm *tfm,
-	                      struct scatterlist *dst,
-	                      struct scatterlist *src,
-	                      unsigned int nbytes, u8 *iv);
+			      struct scatterlist *dst,
+			      struct scatterlist *src,
+			      unsigned int nbytes, u8 *iv);
 	int (*cit_decrypt)(struct crypto_tfm *tfm,
 			   struct scatterlist *dst,
 			   struct scatterlist *src,
@@ -162,12 +162,12 @@ struct cipher_tfm {
 struct digest_tfm {
 	void (*dit_init)(struct crypto_tfm *tfm);
 	void (*dit_update)(struct crypto_tfm *tfm,
-	                   struct scatterlist *sg, unsigned int nsg);
+			   struct scatterlist *sg, unsigned int nsg);
 	void (*dit_final)(struct crypto_tfm *tfm, u8 *out);
 	void (*dit_digest)(struct crypto_tfm *tfm, struct scatterlist *sg,
-	                   unsigned int nsg, u8 *out);
+			   unsigned int nsg, u8 *out);
 	int (*dit_setkey)(struct crypto_tfm *tfm,
-	                  const u8 *key, unsigned int keylen);
+			  const u8 *key, unsigned int keylen);
 #ifdef CONFIG_CRYPTO_HMAC
 	void *dit_hmac_block;
 #endif
@@ -175,11 +175,11 @@ struct digest_tfm {
 
 struct compress_tfm {
 	int (*cot_compress)(struct crypto_tfm *tfm,
-	                    const u8 *src, unsigned int slen,
-	                    u8 *dst, unsigned int *dlen);
+			    const u8 *src, unsigned int slen,
+			    u8 *dst, unsigned int *dlen);
 	int (*cot_decompress)(struct crypto_tfm *tfm,
-	                      const u8 *src, unsigned int slen,
-	                      u8 *dst, unsigned int *dlen);
+			      const u8 *src, unsigned int slen,
+			      u8 *dst, unsigned int *dlen);
 };
 
 #define crt_cipher	crt_u.cipher
@@ -277,8 +277,8 @@ static inline void crypto_digest_init(struct crypto_tfm *tfm)
 }
 
 static inline void crypto_digest_update(struct crypto_tfm *tfm,
-                                        struct scatterlist *sg,
-                                        unsigned int nsg)
+					struct scatterlist *sg,
+					unsigned int nsg)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_DIGEST);
 	tfm->crt_digest.dit_update(tfm, sg, nsg);
@@ -291,15 +291,15 @@ static inline void crypto_digest_final(struct crypto_tfm *tfm, u8 *out)
 }
 
 static inline void crypto_digest_digest(struct crypto_tfm *tfm,
-                                        struct scatterlist *sg,
-                                        unsigned int nsg, u8 *out)
+					struct scatterlist *sg,
+					unsigned int nsg, u8 *out)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_DIGEST);
 	tfm->crt_digest.dit_digest(tfm, sg, nsg, out);
 }
 
 static inline int crypto_digest_setkey(struct crypto_tfm *tfm,
-                                       const u8 *key, unsigned int keylen)
+				       const u8 *key, unsigned int keylen)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_DIGEST);
 	if (tfm->crt_digest.dit_setkey == NULL)
@@ -308,25 +308,25 @@ static inline int crypto_digest_setkey(struct crypto_tfm *tfm,
 }
 
 static inline int crypto_cipher_setkey(struct crypto_tfm *tfm,
-                                       const u8 *key, unsigned int keylen)
+				       const u8 *key, unsigned int keylen)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
 	return tfm->crt_cipher.cit_setkey(tfm, key, keylen);
 }
 
 static inline int crypto_cipher_encrypt(struct crypto_tfm *tfm,
-                                        struct scatterlist *dst,
-                                        struct scatterlist *src,
-                                        unsigned int nbytes)
+					struct scatterlist *dst,
+					struct scatterlist *src,
+					unsigned int nbytes)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
 	return tfm->crt_cipher.cit_encrypt(tfm, dst, src, nbytes);
 }
 
 static inline int crypto_cipher_encrypt_iv(struct crypto_tfm *tfm,
-                                           struct scatterlist *dst,
-                                           struct scatterlist *src,
-                                           unsigned int nbytes, u8 *iv)
+					   struct scatterlist *dst,
+					   struct scatterlist *src,
+					   unsigned int nbytes, u8 *iv)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
 	BUG_ON(tfm->crt_cipher.cit_mode == CRYPTO_TFM_MODE_ECB);
@@ -334,18 +334,18 @@ static inline int crypto_cipher_encrypt_iv(struct crypto_tfm *tfm,
 }
 
 static inline int crypto_cipher_decrypt(struct crypto_tfm *tfm,
-                                        struct scatterlist *dst,
-                                        struct scatterlist *src,
-                                        unsigned int nbytes)
+					struct scatterlist *dst,
+					struct scatterlist *src,
+					unsigned int nbytes)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
 	return tfm->crt_cipher.cit_decrypt(tfm, dst, src, nbytes);
 }
 
 static inline int crypto_cipher_decrypt_iv(struct crypto_tfm *tfm,
-                                           struct scatterlist *dst,
-                                           struct scatterlist *src,
-                                           unsigned int nbytes, u8 *iv)
+					   struct scatterlist *dst,
+					   struct scatterlist *src,
+					   unsigned int nbytes, u8 *iv)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
 	BUG_ON(tfm->crt_cipher.cit_mode == CRYPTO_TFM_MODE_ECB);
@@ -353,30 +353,30 @@ static inline int crypto_cipher_decrypt_iv(struct crypto_tfm *tfm,
 }
 
 static inline void crypto_cipher_set_iv(struct crypto_tfm *tfm,
-                                        const u8 *src, unsigned int len)
+					const u8 *src, unsigned int len)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
 	memcpy(tfm->crt_cipher.cit_iv, src, len);
 }
 
 static inline void crypto_cipher_get_iv(struct crypto_tfm *tfm,
-                                        u8 *dst, unsigned int len)
+					u8 *dst, unsigned int len)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
 	memcpy(dst, tfm->crt_cipher.cit_iv, len);
 }
 
 static inline int crypto_comp_compress(struct crypto_tfm *tfm,
-                                       const u8 *src, unsigned int slen,
-                                       u8 *dst, unsigned int *dlen)
+				       const u8 *src, unsigned int slen,
+				       u8 *dst, unsigned int *dlen)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_COMPRESS);
 	return tfm->crt_compress.cot_compress(tfm, src, slen, dst, dlen);
 }
 
 static inline int crypto_comp_decompress(struct crypto_tfm *tfm,
-                                         const u8 *src, unsigned int slen,
-                                         u8 *dst, unsigned int *dlen)
+					 const u8 *src, unsigned int slen,
+					 u8 *dst, unsigned int *dlen)
 {
 	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_COMPRESS);
 	return tfm->crt_compress.cot_decompress(tfm, src, slen, dst, dlen);
@@ -388,11 +388,11 @@ static inline int crypto_comp_decompress(struct crypto_tfm *tfm,
 #ifdef CONFIG_CRYPTO_HMAC
 void crypto_hmac_init(struct crypto_tfm *tfm, u8 *key, unsigned int *keylen);
 void crypto_hmac_update(struct crypto_tfm *tfm,
-                        struct scatterlist *sg, unsigned int nsg);
+			struct scatterlist *sg, unsigned int nsg);
 void crypto_hmac_final(struct crypto_tfm *tfm, u8 *key,
-                       unsigned int *keylen, u8 *out);
+		       unsigned int *keylen, u8 *out);
 void crypto_hmac(struct crypto_tfm *tfm, u8 *key, unsigned int *keylen,
-                 struct scatterlist *sg, unsigned int nsg, u8 *out);
+		 struct scatterlist *sg, unsigned int nsg, u8 *out);
 #endif	/* CONFIG_CRYPTO_HMAC */
 
 #endif	/* _LINUX_CRYPTO_H */
diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
index 3c515b7..7e49ad8 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.c
+++ b/drivers/staging/rtl8192u/r8180_93cx6.c
@@ -95,7 +95,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	u32 ret;
 
 	ret=0;
-        //enable EPROM programming
+	//enable EPROM programming
 	write_nic_byte_E(dev, EPROM_CMD,
 		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	force_pci_posting(dev);
diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c.bak b/drivers/staging/rtl8192u/r8180_93cx6.c.bak
new file mode 100644
index 0000000..7e49ad8
--- /dev/null
+++ b/drivers/staging/rtl8192u/r8180_93cx6.c.bak
@@ -0,0 +1,146 @@
+/*
+   This files contains card eeprom (93c46 or 93c56) programming routines,
+   memory is addressed by 16 bits words.
+
+   This is part of rtl8180 OpenSource driver.
+   Copyright (C) Andrea Merello 2004  <andreamrl@tiscali.it>
+   Released under the terms of GPL (General Public Licence)
+
+   Parts of this driver are based on the GPL part of the
+   official realtek driver.
+
+   Parts of this driver are based on the rtl8180 driver skeleton
+   from Patric Schenke & Andres Salomon.
+
+   Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver.
+
+   We want to thank the Authors of those projects and the Ndiswrapper
+   project Authors.
+*/
+
+#include "r8180_93cx6.h"
+
+void eprom_cs(struct net_device *dev, short bit)
+{
+	if(bit)
+		write_nic_byte_E(dev, EPROM_CMD,
+			       (1<<EPROM_CS_SHIFT) | \
+			       read_nic_byte_E(dev, EPROM_CMD)); //enable EPROM
+	else
+		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev, EPROM_CMD)\
+			       &~(1<<EPROM_CS_SHIFT)); //disable EPROM
+
+	force_pci_posting(dev);
+	udelay(EPROM_DELAY);
+}
+
+
+void eprom_ck_cycle(struct net_device *dev)
+{
+	write_nic_byte_E(dev, EPROM_CMD,
+		       (1<<EPROM_CK_SHIFT) | read_nic_byte_E(dev,EPROM_CMD));
+	force_pci_posting(dev);
+	udelay(EPROM_DELAY);
+	write_nic_byte_E(dev, EPROM_CMD,
+		       read_nic_byte_E(dev, EPROM_CMD) &~ (1<<EPROM_CK_SHIFT));
+	force_pci_posting(dev);
+	udelay(EPROM_DELAY);
+}
+
+
+void eprom_w(struct net_device *dev,short bit)
+{
+	if(bit)
+		write_nic_byte_E(dev, EPROM_CMD, (1<<EPROM_W_SHIFT) | \
+			       read_nic_byte_E(dev,EPROM_CMD));
+	else
+		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev,EPROM_CMD)\
+			       &~(1<<EPROM_W_SHIFT));
+
+	force_pci_posting(dev);
+	udelay(EPROM_DELAY);
+}
+
+
+short eprom_r(struct net_device *dev)
+{
+	short bit;
+
+	bit=(read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
+	udelay(EPROM_DELAY);
+
+	if(bit) return 1;
+	return 0;
+}
+
+
+void eprom_send_bits_string(struct net_device *dev, short b[], int len)
+{
+	int i;
+
+	for(i=0; i<len; i++){
+		eprom_w(dev, b[i]);
+		eprom_ck_cycle(dev);
+	}
+}
+
+
+u32 eprom_read(struct net_device *dev, u32 addr)
+{
+	struct r8192_priv *priv = ieee80211_priv(dev);
+	short read_cmd[]={1,1,0};
+	short addr_str[8];
+	int i;
+	int addr_len;
+	u32 ret;
+
+	ret=0;
+	//enable EPROM programming
+	write_nic_byte_E(dev, EPROM_CMD,
+		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
+	force_pci_posting(dev);
+	udelay(EPROM_DELAY);
+
+	if (priv->epromtype==EPROM_93c56){
+		addr_str[7]=addr & 1;
+		addr_str[6]=addr & (1<<1);
+		addr_str[5]=addr & (1<<2);
+		addr_str[4]=addr & (1<<3);
+		addr_str[3]=addr & (1<<4);
+		addr_str[2]=addr & (1<<5);
+		addr_str[1]=addr & (1<<6);
+		addr_str[0]=addr & (1<<7);
+		addr_len=8;
+	}else{
+		addr_str[5]=addr & 1;
+		addr_str[4]=addr & (1<<1);
+		addr_str[3]=addr & (1<<2);
+		addr_str[2]=addr & (1<<3);
+		addr_str[1]=addr & (1<<4);
+		addr_str[0]=addr & (1<<5);
+		addr_len=6;
+	}
+	eprom_cs(dev, 1);
+	eprom_ck_cycle(dev);
+	eprom_send_bits_string(dev, read_cmd, 3);
+	eprom_send_bits_string(dev, addr_str, addr_len);
+
+	//keep chip pin D to low state while reading.
+	//I'm unsure if it is necessary, but anyway shouldn't hurt
+	eprom_w(dev, 0);
+
+	for(i=0;i<16;i++){
+		//eeprom needs a clk cycle between writing opcode&adr
+		//and reading data. (eeprom outs a dummy 0)
+		eprom_ck_cycle(dev);
+		ret |= (eprom_r(dev)<<(15-i));
+	}
+
+	eprom_cs(dev, 0);
+	eprom_ck_cycle(dev);
+
+	//disable EPROM programming
+	write_nic_byte_E(dev, EPROM_CMD,
+		       (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
+	return ret;
+}
diff --git a/drivers/staging/rtl8192u/r8180_pm.h b/drivers/staging/rtl8192u/r8180_pm.h
index c7d18a8..52d6fba 100644
--- a/drivers/staging/rtl8192u/r8180_pm.h
+++ b/drivers/staging/rtl8192u/r8180_pm.h
@@ -1,5 +1,5 @@
 /*
-        Power management interface routines.
+	Power management interface routines.
 	Written by Mariusz Matuszek.
 	This code is currently just a placeholder for later work and
 	does not do anything useful.
diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index 837edb6..e538e02 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -136,26 +136,26 @@ do { if(rt_global_debug_component & component) \
 #define RTL819x_DEBUG
 #ifdef RTL819x_DEBUG
 #define assert(expr) \
-        if (!(expr)) {                                  \
-                printk( "Assertion failed! %s,%s,%s,line=%d\n", \
-                #expr,__FILE__,__FUNCTION__,__LINE__);          \
-        }
+	if (!(expr)) {                                  \
+		printk( "Assertion failed! %s,%s,%s,line=%d\n", \
+		#expr,__FILE__,__FUNCTION__,__LINE__);          \
+	}
 //wb added to debug out data buf
 //if you want print DATA buffer related BA, please set ieee80211_debug_level to DATA|BA
 #define RT_DEBUG_DATA(level, data, datalen)      \
-        do{ if ((rt_global_debug_component & (level)) == (level))   \
-                {       \
-                        int i;                                  \
-                        u8* pdata = (u8*) data;                 \
-                        printk(KERN_DEBUG RTL819xU_MODULE_NAME ": %s()\n", __FUNCTION__);   \
-                        for(i=0; i<(int)(datalen); i++)                 \
-                        {                                               \
-                                printk("%2x ", pdata[i]);               \
-                                if ((i+1)%16 == 0) printk("\n");        \
-                        }                               \
-                        printk("\n");                   \
-                }                                       \
-        } while (0)
+	do{ if ((rt_global_debug_component & (level)) == (level))   \
+		{       \
+			int i;                                  \
+			u8* pdata = (u8*) data;                 \
+			printk(KERN_DEBUG RTL819xU_MODULE_NAME ": %s()\n", __FUNCTION__);   \
+			for(i=0; i<(int)(datalen); i++)                 \
+			{                                               \
+				printk("%2x ", pdata[i]);               \
+				if ((i+1)%16 == 0) printk("\n");        \
+			}                               \
+			printk("\n");                   \
+		}                                       \
+	} while (0)
 #else
 #define assert(expr) do {} while (0)
 #define RT_DEBUG_DATA(level, data, datalen) do {} while(0)
@@ -214,42 +214,42 @@ do { if(rt_global_debug_component & component) \
 
 /* for rtl819x */
 typedef struct _tx_desc_819x_usb {
-        //DWORD 0
-        u16	PktSize;
-        u8	Offset;
-        u8	Reserved0:3;
-        u8	CmdInit:1;
-        u8	LastSeg:1;
-        u8	FirstSeg:1;
-        u8	LINIP:1;
-        u8	OWN:1;
-
-        //DWORD 1
-        u8	TxFWInfoSize;
-        u8	RATid:3;
-        u8	DISFB:1;
-        u8	USERATE:1;
-        u8	MOREFRAG:1;
-        u8	NoEnc:1;
-        u8	PIFS:1;
-        u8	QueueSelect:5;
-        u8	NoACM:1;
-        u8	Reserved1:2;
-        u8	SecCAMID:5;
-        u8	SecDescAssign:1;
-        u8	SecType:2;
-
-        //DWORD 2
-        u16	TxBufferSize;
-        //u16 Reserved2;
-        u8	ResvForPaddingLen:7;
-        u8	Reserved3:1;
-        u8	Reserved4;
-
-        //DWORD 3, 4, 5
-        u32	Reserved5;
-        u32	Reserved6;
-        u32	Reserved7;
+	//DWORD 0
+	u16	PktSize;
+	u8	Offset;
+	u8	Reserved0:3;
+	u8	CmdInit:1;
+	u8	LastSeg:1;
+	u8	FirstSeg:1;
+	u8	LINIP:1;
+	u8	OWN:1;
+
+	//DWORD 1
+	u8	TxFWInfoSize;
+	u8	RATid:3;
+	u8	DISFB:1;
+	u8	USERATE:1;
+	u8	MOREFRAG:1;
+	u8	NoEnc:1;
+	u8	PIFS:1;
+	u8	QueueSelect:5;
+	u8	NoACM:1;
+	u8	Reserved1:2;
+	u8	SecCAMID:5;
+	u8	SecDescAssign:1;
+	u8	SecType:2;
+
+	//DWORD 2
+	u16	TxBufferSize;
+	//u16 Reserved2;
+	u8	ResvForPaddingLen:7;
+	u8	Reserved3:1;
+	u8	Reserved4;
+
+	//DWORD 3, 4, 5
+	u32	Reserved5;
+	u32	Reserved6;
+	u32	Reserved7;
 }tx_desc_819x_usb, *ptx_desc_819x_usb;
 
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
@@ -280,7 +280,7 @@ typedef struct _tx_desc_819x_usb_aggr_subframe {
 
 
 typedef struct _tx_desc_cmd_819x_usb {
-        //DWORD 0
+	//DWORD 0
 	u16	Reserved0;
 	u8	Reserved1;
 	u8	Reserved2:3;
@@ -290,14 +290,14 @@ typedef struct _tx_desc_cmd_819x_usb {
 	u8	LINIP:1;
 	u8	OWN:1;
 
-        //DOWRD 1
+	//DOWRD 1
 	//u32	Reserved3;
 	u8	TxFWInfoSize;
 	u8	Reserved3;
 	u8	QueueSelect;
 	u8	Reserved4;
 
-        //DOWRD 2
+	//DOWRD 2
 	u16	TxBufferSize;
 	u16	Reserved5;
 
@@ -311,34 +311,34 @@ typedef struct _tx_desc_cmd_819x_usb {
 
 
 typedef struct _tx_fwinfo_819x_usb {
-        //DOWRD 0
-        u8		TxRate:7;
-        u8		CtsEnable:1;
-        u8		RtsRate:7;
-        u8		RtsEnable:1;
-        u8		TxHT:1;
-        u8		Short:1;                //Short PLCP for CCK, or short GI for 11n MCS
-        u8		TxBandwidth:1;          // This is used for HT MCS rate only.
-        u8		TxSubCarrier:2;         // This is used for legacy OFDM rate only.
-        u8		STBC:2;
-        u8		AllowAggregation:1;
-        u8		RtsHT:1;                //Interpret RtsRate field as high throughput data rate
-        u8		RtsShort:1;             //Short PLCP for CCK, or short GI for 11n MCS
-        u8		RtsBandwidth:1;         // This is used for HT MCS rate only.
-        u8		RtsSubcarrier:2;        // This is used for legacy OFDM rate only.
-        u8		RtsSTBC:2;
-        u8		EnableCPUDur:1;         //Enable firmware to recalculate and assign packet duration
-
-        //DWORD 1
-        u32		RxMF:2;
-        u32		RxAMD:3;
-        u32		TxPerPktInfoFeedback:1;//1 indicate Tx info gathtered by firmware and returned by Rx Cmd
-        u32		Reserved1:2;
-        u32		TxAGCOffSet:4;
-        u32		TxAGCSign:1;
-        u32		Tx_INFO_RSVD:6;
+	//DOWRD 0
+	u8		TxRate:7;
+	u8		CtsEnable:1;
+	u8		RtsRate:7;
+	u8		RtsEnable:1;
+	u8		TxHT:1;
+	u8		Short:1;                //Short PLCP for CCK, or short GI for 11n MCS
+	u8		TxBandwidth:1;          // This is used for HT MCS rate only.
+	u8		TxSubCarrier:2;         // This is used for legacy OFDM rate only.
+	u8		STBC:2;
+	u8		AllowAggregation:1;
+	u8		RtsHT:1;                //Interpret RtsRate field as high throughput data rate
+	u8		RtsShort:1;             //Short PLCP for CCK, or short GI for 11n MCS
+	u8		RtsBandwidth:1;         // This is used for HT MCS rate only.
+	u8		RtsSubcarrier:2;        // This is used for legacy OFDM rate only.
+	u8		RtsSTBC:2;
+	u8		EnableCPUDur:1;         //Enable firmware to recalculate and assign packet duration
+
+	//DWORD 1
+	u32		RxMF:2;
+	u32		RxAMD:3;
+	u32		TxPerPktInfoFeedback:1;//1 indicate Tx info gathtered by firmware and returned by Rx Cmd
+	u32		Reserved1:2;
+	u32		TxAGCOffSet:4;
+	u32		TxAGCSign:1;
+	u32		Tx_INFO_RSVD:6;
 	u32		PacketID:13;
-        //u32                Reserved;
+	//u32                Reserved;
 }tx_fwinfo_819x_usb, *ptx_fwinfo_819x_usb;
 
 typedef struct rtl8192_rx_info {
@@ -566,14 +566,14 @@ typedef struct buffer {
 } buffer;
 
 typedef struct rtl_reg_debug{
-        unsigned int  cmd;
-        struct {
-                unsigned char type;
-                unsigned char addr;
-                unsigned char page;
-                unsigned char length;
-        } head;
-        unsigned char buf[0xff];
+	unsigned int  cmd;
+	struct {
+		unsigned char type;
+		unsigned char addr;
+		unsigned char page;
+		unsigned char length;
+	} head;
+	unsigned char buf[0xff];
 }rtl_reg_debug;
 
 
@@ -739,11 +739,11 @@ typedef struct _BB_REGISTER_DEFINITION{
 }BB_REGISTER_DEFINITION_T, *PBB_REGISTER_DEFINITION_T;
 
 typedef enum _RT_RF_TYPE_819xU{
-        RF_TYPE_MIN = 0,
-        RF_8225,
-        RF_8256,
-        RF_8258,
-        RF_PSEUDO_11N = 4,
+	RF_TYPE_MIN = 0,
+	RF_8225,
+	RF_8256,
+	RF_8258,
+	RF_PSEUDO_11N = 4,
 }RT_RF_TYPE_819xU, *PRT_RF_TYPE_819xU;
 
 typedef struct _rate_adaptive {
@@ -898,7 +898,7 @@ typedef struct r8192_priv {
 	spinlock_t irq_lock;
 //	spinlock_t irq_th_lock;
 	spinlock_t tx_lock;
-        struct mutex mutex;
+	struct mutex mutex;
 	//spinlock_t rf_lock; //used to lock rf write operation added by wb
 
 	u16 irq_mask;
@@ -961,8 +961,8 @@ typedef struct r8192_priv {
 	atomic_t irt_counter;//count for irq_rx_tasklet
 #endif
 #ifdef JACKSON_NEW_RX
-        struct sk_buff **pp_rxskb;
-        int     rx_inx;
+	struct sk_buff **pp_rxskb;
+	int     rx_inx;
 #endif
 
 /* modified by davad for Rx process */
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index abedae7..93fffea 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2319,32 +2319,32 @@ void rtl8192_link_change(struct net_device *dev)
 //	RT_TRACE(COMP_CH, "========>%s(), chan:%d\n", __FUNCTION__, priv->chan);
 //	rtl8192_set_chan(dev, priv->chan);
 	 if (ieee->iw_mode == IW_MODE_INFRA || ieee->iw_mode == IW_MODE_ADHOC)
-        {
-                u32 reg = 0;
-                reg = read_nic_dword(dev, RCR);
-                if (priv->ieee80211->state == IEEE80211_LINKED)
-                        priv->ReceiveConfig = reg |= RCR_CBSSID;
-                else
-                        priv->ReceiveConfig = reg &= ~RCR_CBSSID;
-                write_nic_dword(dev, RCR, reg);
-        }
+	{
+		u32 reg = 0;
+		reg = read_nic_dword(dev, RCR);
+		if (priv->ieee80211->state == IEEE80211_LINKED)
+			priv->ReceiveConfig = reg |= RCR_CBSSID;
+		else
+			priv->ReceiveConfig = reg &= ~RCR_CBSSID;
+		write_nic_dword(dev, RCR, reg);
+	}
 
 //	rtl8192_set_rxconf(dev);
 }
 
 static struct ieee80211_qos_parameters def_qos_parameters = {
-        {3,3,3,3},/* cw_min */
-        {7,7,7,7},/* cw_max */
-        {2,2,2,2},/* aifs */
-        {0,0,0,0},/* flags */
-        {0,0,0,0} /* tx_op_limit */
+	{3,3,3,3},/* cw_min */
+	{7,7,7,7},/* cw_max */
+	{2,2,2,2},/* aifs */
+	{0,0,0,0},/* flags */
+	{0,0,0,0} /* tx_op_limit */
 };
 
 
 void rtl8192_update_beacon(struct work_struct * work)
 {
-        struct r8192_priv *priv = container_of(work, struct r8192_priv, update_beacon_wq.work);
-        struct net_device *dev = priv->ieee80211->dev;
+	struct r8192_priv *priv = container_of(work, struct r8192_priv, update_beacon_wq.work);
+	struct net_device *dev = priv->ieee80211->dev;
 	struct ieee80211_device* ieee = priv->ieee80211;
 	struct ieee80211_network* net = &ieee->current_network;
 
@@ -3583,7 +3583,7 @@ TxCheckStuck(struct net_device *dev)
 	     for (QueueID = 0; QueueID<=BEACON_QUEUE;QueueID ++)
 	     {
 			if(QueueID == TXCMD_QUEUE)
-		         continue;
+			 continue;
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
 			if((skb_queue_len(&priv->ieee80211->skb_waitQ[QueueID]) == 0) && (skb_queue_len(&priv->ieee80211->skb_aggQ[QueueID]) == 0) && (skb_queue_len(&priv->ieee80211->skb_drv_aggQ[QueueID]) == 0))
 #else
@@ -3591,7 +3591,7 @@ TxCheckStuck(struct net_device *dev)
 #endif
 				continue;
 
-	             bCheckFwTxCnt = true;
+		     bCheckFwTxCnt = true;
 	     }
 //	     PlatformReleaseSpinLock(Adapter, RT_TX_SPINLOCK);
 //	spin_unlock_irqrestore(&priv->ieee80211->lock,flags);
@@ -4110,7 +4110,7 @@ extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
 				notify_wx_assoc_event(priv->ieee80211);
 				RemovePeerTS(priv->ieee80211,priv->ieee80211->current_network.bssid);
 				priv->ieee80211->link_change(dev);
-                                queue_work(priv->ieee80211->wq, &priv->ieee80211->associate_procedure_wq);
+				queue_work(priv->ieee80211->wq, &priv->ieee80211->associate_procedure_wq);
 
 			}
 		}
@@ -4807,9 +4807,9 @@ rtl819x_evm_dbtopercentage(
     ret_val = value;
 
     if(ret_val >= 0)
-        ret_val = 0;
+	ret_val = 0;
     if(ret_val <= -33)
-        ret_val = -33;
+	ret_val = -33;
     ret_val = 0 - ret_val;
     ret_val*=3;
 	if(ret_val == 99)
-- 
1.7.10.4


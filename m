Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0LNA5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:57:30 -0500
Received: from mail.perches.com ([173.55.12.10]:2618 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758825Ab0LNA5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:57:24 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 5/8] staging: brcm80211: Convert ETHER_ADDR_LEN to ETH_ALEN
Date: Mon, 13 Dec 2010 16:57:01 -0800
Message-Id: <b77cea5da72c8925a05b25d4f03dc9b4856f37a8.1292287724.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292287720.git.joe@perches.com>
References: <cover.1292287720.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an #include of <linux/if_ether.h> to include/proto/ethernet.h
Convert ETHER_ADDR_LEN, remove the #define for ETHER_ADDR_LEN.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    8 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   26 +++++-----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   36 ++++++------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   58 ++++++++++----------
 drivers/staging/brcm80211/include/proto/ethernet.h |   17 +++---
 drivers/staging/brcm80211/sys/wl_mac80211.c        |    2 +-
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |    2 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |    4 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |   18 +++---
 drivers/staging/brcm80211/util/bcmsrom.c           |    2 +-
 12 files changed, 89 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index b3fc2a3..b7b527f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -477,7 +477,7 @@ int dhd_prot_init(dhd_pub_t *dhd)
 		dhd_os_proto_unblock(dhd);
 		return ret;
 	}
-	memcpy(dhd->mac.octet, buf, ETHER_ADDR_LEN);
+	memcpy(dhd->mac.octet, buf, ETH_ALEN);
 
 	dhd_os_proto_unblock(dhd);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 324d020..3dbf72e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -1256,7 +1256,7 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 	 */
 	ret = dhd_custom_get_mac_address(ea_addr.octet);
 	if (!ret) {
-		bcm_mkiovar("cur_etheraddr", (void *)&ea_addr, ETHER_ADDR_LEN,
+		bcm_mkiovar("cur_etheraddr", (void *)&ea_addr, ETH_ALEN,
 			    buf, sizeof(buf));
 		ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, sizeof(buf));
 		if (ret < 0) {
@@ -1264,7 +1264,7 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 				   __func__, ret));
 		} else
 			memcpy(dhd->mac.octet, (void *)&ea_addr,
-			       ETHER_ADDR_LEN);
+			       ETH_ALEN);
 	}
 #endif				/* GET_CUSTOM_MAC_ENABLE */
 
@@ -1534,7 +1534,7 @@ int dhd_iscan_delete_bss(void *dhdp, void *addr, iscan_buf_t *iscan_skip)
 					break;
 
 				if (!memcmp
-				    (bi->BSSID.octet, addr, ETHER_ADDR_LEN)) {
+				    (bi->BSSID.octet, addr, ETH_ALEN)) {
 					DHD_ISCAN(("%s: Del BSS[%2.2d:%2.2d] "
 					"%X:%X:%X:%X:%X:%X\n",
 					__func__, l, i, bi->BSSID.octet[0],
@@ -1672,7 +1672,7 @@ int dhd_iscan_request(void *dhdp, u16 action)
 	char buf[WLC_IOCTL_SMLEN];
 
 	memset(&params, 0, sizeof(wl_iscan_params_t));
-	memcpy(&params.params.bssid, &ether_bcast, ETHER_ADDR_LEN);
+	memcpy(&params.params.bssid, &ether_bcast, ETH_ALEN);
 
 	params.params.bss_type = DOT11_BSSTYPE_ANY;
 	params.params.scan_type = DOT11_SCANTYPE_ACTIVE;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index b37539c..ec6202b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -210,7 +210,7 @@ typedef struct dhd_if {
 	int idx;		/* iface idx in dongle */
 	int state;		/* interface state */
 	uint subunit;		/* subunit */
-	u8 mac_addr[ETHER_ADDR_LEN];	/* assigned MAC address */
+	u8 mac_addr[ETH_ALEN];	/* assigned MAC address */
 	bool attached;		/* Delayed attachment when unset */
 	bool txflowcontrol;	/* Per interface flow control indicator */
 	char name[IFNAMSIZ];	/* linux interface name */
@@ -708,7 +708,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 
 	/* Send down the multicast list first. */
 
-	buflen = sizeof("mcast_list") + sizeof(cnt) + (cnt * ETHER_ADDR_LEN);
+	buflen = sizeof("mcast_list") + sizeof(cnt) + (cnt * ETH_ALEN);
 	bufp = buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!bufp) {
 		DHD_ERROR(("%s: out of memory for mcast_list, cnt %d\n",
@@ -726,8 +726,8 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	netdev_for_each_mc_addr(ha, dev) {
 		if (!cnt)
 			break;
-		memcpy(bufp, ha->addr, ETHER_ADDR_LEN);
-		bufp += ETHER_ADDR_LEN;
+		memcpy(bufp, ha->addr, ETH_ALEN);
+		bufp += ETH_ALEN;
 		cnt--;
 	}
 
@@ -811,7 +811,7 @@ _dhd_set_mac_address(dhd_info_t *dhd, int ifidx, struct ether_addr *addr)
 
 	DHD_TRACE(("%s enter\n", __func__));
 	if (!bcm_mkiovar
-	    ("cur_etheraddr", (char *)addr, ETHER_ADDR_LEN, buf, 32)) {
+	    ("cur_etheraddr", (char *)addr, ETH_ALEN, buf, 32)) {
 		DHD_ERROR(("%s: mkiovar failed for cur_etheraddr\n",
 			   dhd_ifname(&dhd->pub, ifidx)));
 		return -1;
@@ -827,7 +827,7 @@ _dhd_set_mac_address(dhd_info_t *dhd, int ifidx, struct ether_addr *addr)
 		DHD_ERROR(("%s: set cur_etheraddr failed\n",
 			   dhd_ifname(&dhd->pub, ifidx)));
 	} else {
-		memcpy(dhd->iflist[ifidx]->net->dev_addr, addr, ETHER_ADDR_LEN);
+		memcpy(dhd->iflist[ifidx]->net->dev_addr, addr, ETH_ALEN);
 	}
 
 	return ret;
@@ -997,7 +997,7 @@ static int dhd_set_mac_address(struct net_device *dev, void *addr)
 		return -1;
 
 	ASSERT(dhd->sysioc_tsk);
-	memcpy(&dhd->macvalue, sa->sa_data, ETHER_ADDR_LEN);
+	memcpy(&dhd->macvalue, sa->sa_data, ETH_ALEN);
 	dhd->set_macaddress = true;
 	up(&dhd->sysioc_sem);
 
@@ -1028,7 +1028,7 @@ int dhd_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 		return -ENODEV;
 
 	/* Update multicast statistic */
-	if (pktbuf->len >= ETHER_ADDR_LEN) {
+	if (pktbuf->len >= ETH_ALEN) {
 		u8 *pktdata = (u8 *) (pktbuf->data);
 		struct ether_header *eh = (struct ether_header *)pktdata;
 
@@ -1866,7 +1866,7 @@ static int dhd_open(struct net_device *net)
 		}
 		atomic_set(&dhd->pend_8021x_cnt, 0);
 
-		memcpy(net->dev_addr, dhd->pub.mac.octet, ETHER_ADDR_LEN);
+		memcpy(net->dev_addr, dhd->pub.mac.octet, ETH_ALEN);
 
 #ifdef TOE
 		/* Get current TOE mode from dongle */
@@ -1922,7 +1922,7 @@ dhd_add_if(dhd_info_t *dhd, int ifidx, void *handle, char *name,
 	dhd->iflist[ifidx] = ifp;
 	strlcpy(ifp->name, name, IFNAMSIZ);
 	if (mac_addr != NULL)
-		memcpy(&ifp->mac_addr, mac_addr, ETHER_ADDR_LEN);
+		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
 	if (handle == NULL) {
 		ifp->state = WLC_E_IF_ADD;
@@ -2281,7 +2281,7 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 {
 	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
 	struct net_device *net;
-	u8 temp_addr[ETHER_ADDR_LEN] = {
+	u8 temp_addr[ETH_ALEN] = {
 		0x00, 0x90, 0x4c, 0x11, 0x22, 0x33};
 
 	DHD_TRACE(("%s: ifidx %d\n", __func__, ifidx));
@@ -2299,7 +2299,7 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 	 */
 	if (ifidx != 0) {
 		/* for virtual interfaces use the primary MAC  */
-		memcpy(temp_addr, dhd->pub.mac.octet, ETHER_ADDR_LEN);
+		memcpy(temp_addr, dhd->pub.mac.octet, ETH_ALEN);
 
 	}
 
@@ -2327,7 +2327,7 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 
 	dhd->pub.rxsz = net->mtu + net->hard_header_len + dhd->pub.hdrlen;
 
-	memcpy(net->dev_addr, temp_addr, ETHER_ADDR_LEN);
+	memcpy(net->dev_addr, temp_addr, ETH_ALEN);
 
 	if (register_netdev(net) != 0) {
 		DHD_ERROR(("%s: couldn't register the net device\n",
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 59f7ca5..1e92f2e 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -648,7 +648,7 @@ wl_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 
 static void wl_iscan_prep(struct wl_scan_params *params, struct wlc_ssid *ssid)
 {
-	memcpy(&params->bssid, &ether_bcast, ETHER_ADDR_LEN);
+	memcpy(&params->bssid, &ether_bcast, ETH_ALEN);
 	params->bss_type = DOT11_BSSTYPE_ANY;
 	params->scan_type = 0;
 	params->nprobes = -1;
@@ -1044,9 +1044,9 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	join_params.ssid.SSID_len = htod32(params->ssid_len);
 	if (params->bssid)
 		memcpy(&join_params.params.bssid, params->bssid,
-		       ETHER_ADDR_LEN);
+		       ETH_ALEN);
 	else
-		memset(&join_params.params.bssid, 0, ETHER_ADDR_LEN);
+		memset(&join_params.params.bssid, 0, ETH_ALEN);
 
 	err = wl_dev_ioctl(dev, WLC_SET_SSID, &join_params,
 			sizeof(join_params));
@@ -1373,7 +1373,7 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(&join_params.ssid.SSID, sme->ssid, join_params.ssid.SSID_len);
 	join_params.ssid.SSID_len = htod32(join_params.ssid.SSID_len);
 	wl_update_prof(wl, NULL, &join_params.ssid, WL_PROF_SSID);
-	memcpy(&join_params.params.bssid, &ether_bcast, ETHER_ADDR_LEN);
+	memcpy(&join_params.params.bssid, &ether_bcast, ETH_ALEN);
 
 	wl_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
 	WL_DBG(("join_param_size %d\n", join_params_size));
@@ -1406,7 +1406,7 @@ wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	act = *(bool *) wl_read_prof(wl, WL_PROF_ACT);
 	if (likely(act)) {
 		scbval.val = reason_code;
-		memcpy(&scbval.ea, &wl->bssid, ETHER_ADDR_LEN);
+		memcpy(&scbval.ea, &wl->bssid, ETH_ALEN);
 		scbval.val = htod32(scbval.val);
 		err = wl_dev_ioctl(dev, WLC_DISASSOC, &scbval,
 				sizeof(scb_val_t));
@@ -1533,7 +1533,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	/* Instead of bcast for ea address for default wep keys,
 		 driver needs it to be Null */
 	if (!is_multicast_ether_addr(mac_addr))
-		memcpy((char *)&key.ea, (void *)mac_addr, ETHER_ADDR_LEN);
+		memcpy((char *)&key.ea, (void *)mac_addr, ETH_ALEN);
 	key.len = (u32) params->key_len;
 	/* check for key index change */
 	if (key.len == 0) {
@@ -1826,7 +1826,7 @@ wl_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	CHECK_SYS_UP();
 	if (unlikely
-	    (memcmp(mac, wl_read_prof(wl, WL_PROF_BSSID), ETHER_ADDR_LEN))) {
+	    (memcmp(mac, wl_read_prof(wl, WL_PROF_BSSID), ETH_ALEN))) {
 		WL_ERR(("Wrong Mac address\n"));
 		return -ENOENT;
 	}
@@ -2029,11 +2029,11 @@ wl_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	CHECK_SYS_UP();
 	for (i = 0; i < wl->pmk_list->pmkids.npmkid; i++)
 		if (!memcmp(pmksa->bssid, &wl->pmk_list->pmkids.pmkid[i].BSSID,
-			    ETHER_ADDR_LEN))
+			    ETH_ALEN))
 			break;
 	if (i < WL_NUM_PMKIDS_MAX) {
 		memcpy(&wl->pmk_list->pmkids.pmkid[i].BSSID, pmksa->bssid,
-		       ETHER_ADDR_LEN);
+		       ETH_ALEN);
 		memcpy(&wl->pmk_list->pmkids.pmkid[i].PMKID, pmksa->pmkid,
 		       WPA2_PMKID_LEN);
 		if (i == wl->pmk_list->pmkids.npmkid)
@@ -2064,7 +2064,7 @@ wl_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	int i;
 
 	CHECK_SYS_UP();
-	memcpy(&pmkid.pmkid[0].BSSID, pmksa->bssid, ETHER_ADDR_LEN);
+	memcpy(&pmkid.pmkid[0].BSSID, pmksa->bssid, ETH_ALEN);
 	memcpy(&pmkid.pmkid[0].PMKID, pmksa->pmkid, WPA2_PMKID_LEN);
 
 	WL_DBG(("del_pmksa,IW_PMKSA_REMOVE - PMKID: %pM =\n",
@@ -2076,7 +2076,7 @@ wl_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	for (i = 0; i < wl->pmk_list->pmkids.npmkid; i++)
 		if (!memcmp
 		    (pmksa->bssid, &wl->pmk_list->pmkids.pmkid[i].BSSID,
-		     ETHER_ADDR_LEN))
+		     ETH_ALEN))
 			break;
 
 	if ((wl->pmk_list->pmkids.npmkid > 0)
@@ -2085,7 +2085,7 @@ wl_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 		for (; i < (wl->pmk_list->pmkids.npmkid - 1); i++) {
 			memcpy(&wl->pmk_list->pmkids.pmkid[i].BSSID,
 			       &wl->pmk_list->pmkids.pmkid[i + 1].BSSID,
-			       ETHER_ADDR_LEN);
+			       ETH_ALEN);
 			memcpy(&wl->pmk_list->pmkids.pmkid[i].PMKID,
 			       &wl->pmk_list->pmkids.pmkid[i + 1].PMKID,
 			       WPA2_PMKID_LEN);
@@ -2284,7 +2284,7 @@ static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi)
 	else
 		band = wiphy->bands[IEEE80211_BAND_5GHZ];
 	notif_bss_info->rssi = bi->RSSI;
-	memcpy(mgmt->bssid, &bi->BSSID, ETHER_ADDR_LEN);
+	memcpy(mgmt->bssid, &bi->BSSID, ETH_ALEN);
 	mgmt_type = wl->active_scan ?
 		IEEE80211_STYPE_PROBE_RESP : IEEE80211_STYPE_BEACON;
 	if (!memcmp(bi->SSID, sr->ssid.SSID, bi->SSID_len)) {
@@ -2579,7 +2579,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 			goto update_bss_info_out;
 		}
 		bi = (struct wl_bss_info *)(wl->extra_buf + 4);
-		if (unlikely(memcmp(&bi->BSSID, &wl->bssid, ETHER_ADDR_LEN))) {
+		if (unlikely(memcmp(&bi->BSSID, &wl->bssid, ETH_ALEN))) {
 			err = -EIO;
 			goto update_bss_info_out;
 		}
@@ -2631,7 +2631,7 @@ wl_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
 	s32 err = 0;
 
 	wl_get_assoc_ies(wl);
-	memcpy(&wl->bssid, &e->addr, ETHER_ADDR_LEN);
+	memcpy(&wl->bssid, &e->addr, ETH_ALEN);
 	wl_update_bss_info(wl);
 	cfg80211_roamed(ndev,
 			(u8 *)&wl->bssid,
@@ -2652,7 +2652,7 @@ wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 	s32 err = 0;
 
 	wl_get_assoc_ies(wl);
-	memcpy(&wl->bssid, &e->addr, ETHER_ADDR_LEN);
+	memcpy(&wl->bssid, &e->addr, ETH_ALEN);
 	wl_update_bss_info(wl);
 	if (test_and_clear_bit(WL_STATUS_CONNECTING, &wl->status)) {
 		cfg80211_connect_result(ndev,
@@ -3926,9 +3926,9 @@ wl_update_prof(struct wl_priv *wl, const wl_event_msg_t *e, void *data,
 		break;
 	case WL_PROF_BSSID:
 		if (data)
-			memcpy(wl->profile->bssid, data, ETHER_ADDR_LEN);
+			memcpy(wl->profile->bssid, data, ETH_ALEN);
 		else
-			memset(wl->profile->bssid, 0, ETHER_ADDR_LEN);
+			memset(wl->profile->bssid, 0, ETH_ALEN);
 		break;
 	case WL_PROF_SEC:
 		memcpy(&wl->profile->sec, data, sizeof(wl->profile->sec));
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 770e63f..1069e65 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -237,7 +237,7 @@ struct wl_ibss {
 struct wl_profile {
 	u32 mode;
 	struct wlc_ssid ssid;
-	u8 bssid[ETHER_ADDR_LEN];
+	u8 bssid[ETH_ALEN];
 	u16 beacon_interval;
 	u8 dtim_period;
 	struct wl_security sec;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index abf5d743..14580b2 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -347,7 +347,7 @@ wl_iw_config_commit(struct net_device *dev,
 		return 0;
 
 	memset(&bssid, 0, sizeof(struct sockaddr));
-	error = dev_wlc_ioctl(dev, WLC_REASSOC, &bssid, ETHER_ADDR_LEN);
+	error = dev_wlc_ioctl(dev, WLC_REASSOC, &bssid, ETH_ALEN);
 	if (error) {
 		WL_ERROR(("%s: WLC_REASSOC to %s failed\n", __func__,
 			  ssid.SSID));
@@ -691,7 +691,7 @@ wl_iw_set_spy(struct net_device *dev,
 
 	iw->spy_num = min_t(int, ARRAY_SIZE(iw->spy_addr), dwrq->length);
 	for (i = 0; i < iw->spy_num; i++)
-		memcpy(&iw->spy_addr[i], addr[i].sa_data, ETHER_ADDR_LEN);
+		memcpy(&iw->spy_addr[i], addr[i].sa_data, ETH_ALEN);
 	memset(iw->spy_qual, 0, sizeof(iw->spy_qual));
 
 	return 0;
@@ -713,7 +713,7 @@ wl_iw_get_spy(struct net_device *dev,
 
 	dwrq->length = iw->spy_num;
 	for (i = 0; i < iw->spy_num; i++) {
-		memcpy(addr[i].sa_data, &iw->spy_addr[i], ETHER_ADDR_LEN);
+		memcpy(addr[i].sa_data, &iw->spy_addr[i], ETH_ALEN);
 		addr[i].sa_family = AF_UNIX;
 		memcpy(&qual[i], &iw->spy_qual[i], sizeof(struct iw_quality));
 		iw->spy_qual[i].updated = 0;
@@ -786,7 +786,7 @@ wl_iw_set_wap(struct net_device *dev,
 
 	memcpy(join_params.ssid.SSID, g_ssid.SSID, g_ssid.SSID_len);
 	join_params.ssid.SSID_len = htod32(g_ssid.SSID_len);
-	memcpy(&join_params.params.bssid, awrq->sa_data, ETHER_ADDR_LEN);
+	memcpy(&join_params.params.bssid, awrq->sa_data, ETH_ALEN);
 
 	WL_TRACE(("%s  target_channel=%d\n", __func__,
 		  g_wl_iw_params.target_channel));
@@ -816,9 +816,9 @@ wl_iw_get_wap(struct net_device *dev,
 	WL_TRACE(("%s: SIOCGIWAP\n", dev->name));
 
 	awrq->sa_family = ARPHRD_ETHER;
-	memset(awrq->sa_data, 0, ETHER_ADDR_LEN);
+	memset(awrq->sa_data, 0, ETH_ALEN);
 
-	(void)dev_wlc_ioctl(dev, WLC_GET_BSSID, awrq->sa_data, ETHER_ADDR_LEN);
+	(void)dev_wlc_ioctl(dev, WLC_GET_BSSID, awrq->sa_data, ETH_ALEN);
 
 	return 0;
 }
@@ -841,7 +841,7 @@ wl_iw_mlme(struct net_device *dev,
 	}
 
 	scbval.val = mlme->reason_code;
-	bcopy(&mlme->addr.sa_data, &scbval.ea, ETHER_ADDR_LEN);
+	bcopy(&mlme->addr.sa_data, &scbval.ea, ETH_ALEN);
 
 	if (mlme->cmd == IW_MLME_DISASSOC) {
 		scbval.val = htod32(scbval.val);
@@ -912,7 +912,7 @@ wl_iw_get_aplist(struct net_device *dev,
 		if (!(dtoh16(bi->capability) & DOT11_CAP_ESS))
 			continue;
 
-		memcpy(addr[dwrq->length].sa_data, &bi->BSSID, ETHER_ADDR_LEN);
+		memcpy(addr[dwrq->length].sa_data, &bi->BSSID, ETH_ALEN);
 		addr[dwrq->length].sa_family = ARPHRD_ETHER;
 		qual[dwrq->length].qual = rssi_to_qual(dtoh16(bi->RSSI));
 		qual[dwrq->length].level = 0x100 + dtoh16(bi->RSSI);
@@ -986,7 +986,7 @@ wl_iw_iscan_get_aplist(struct net_device *dev,
 				continue;
 
 			memcpy(addr[dwrq->length].sa_data, &bi->BSSID,
-			       ETHER_ADDR_LEN);
+			       ETH_ALEN);
 			addr[dwrq->length].sa_family = ARPHRD_ETHER;
 			qual[dwrq->length].qual =
 			    rssi_to_qual(dtoh16(bi->RSSI));
@@ -1017,7 +1017,7 @@ static int wl_iw_iscan_prep(wl_scan_params_t *params, wlc_ssid_t *ssid)
 {
 	int err = 0;
 
-	memcpy(&params->bssid, &ether_bcast, ETHER_ADDR_LEN);
+	memcpy(&params->bssid, &ether_bcast, ETH_ALEN);
 	params->bss_type = DOT11_BSSTYPE_ANY;
 	params->scan_type = 0;
 	params->nprobes = -1;
@@ -1516,7 +1516,7 @@ wl_iw_get_scan_prep(wl_scan_results_t *list,
 
 		iwe.cmd = SIOCGIWAP;
 		iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-		memcpy(iwe.u.ap_addr.sa_data, &bi->BSSID, ETHER_ADDR_LEN);
+		memcpy(iwe.u.ap_addr.sa_data, &bi->BSSID, ETH_ALEN);
 		event =
 		    IWE_STREAM_ADD_EVENT(info, event, end, &iwe,
 					 IW_EV_ADDR_LEN);
@@ -1780,14 +1780,14 @@ wl_iw_iscan_get_scan(struct net_device *dev,
 			ASSERT(((unsigned long)bi + dtoh32(bi->length)) <=
 			       ((unsigned long)list + WLC_IW_ISCAN_MAXLEN));
 
-			if (event + ETHER_ADDR_LEN + bi->SSID_len +
+			if (event + ETH_ALEN + bi->SSID_len +
 			    IW_EV_UINT_LEN + IW_EV_FREQ_LEN + IW_EV_QUAL_LEN >=
 			    end)
 				return -E2BIG;
 			iwe.cmd = SIOCGIWAP;
 			iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
 			memcpy(iwe.u.ap_addr.sa_data, &bi->BSSID,
-			       ETHER_ADDR_LEN);
+			       ETH_ALEN);
 			event =
 			    IWE_STREAM_ADD_EVENT(info, event, end, &iwe,
 						 IW_EV_ADDR_LEN);
@@ -1924,7 +1924,7 @@ wl_iw_set_essid(struct net_device *dev,
 
 	memcpy(&join_params.ssid.SSID, g_ssid.SSID, g_ssid.SSID_len);
 	join_params.ssid.SSID_len = htod32(g_ssid.SSID_len);
-	memcpy(&join_params.params.bssid, &ether_bcast, ETHER_ADDR_LEN);
+	memcpy(&join_params.params.bssid, &ether_bcast, ETH_ALEN);
 
 	wl_iw_ch_to_chanspec(g_wl_iw_params.target_channel, &join_params,
 			     &join_params_size);
@@ -2551,7 +2551,7 @@ wl_iw_set_encodeext(struct net_device *dev,
 
 	if (!is_multicast_ether_addr(iwe->addr.sa_data))
 		bcopy((void *)&iwe->addr.sa_data, (char *)&key.ea,
-		      ETHER_ADDR_LEN);
+		      ETH_ALEN);
 
 	if (key.len == 0) {
 		if (iwe->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
@@ -2657,7 +2657,7 @@ wl_iw_set_pmksa(struct net_device *dev,
 			pmkidptr = &pmkid;
 
 			bcopy(&iwpmksa->bssid.sa_data[0],
-			      &pmkidptr->pmkid[0].BSSID, ETHER_ADDR_LEN);
+			      &pmkidptr->pmkid[0].BSSID, ETH_ALEN);
 			bcopy(&iwpmksa->pmkid[0], &pmkidptr->pmkid[0].PMKID,
 			      WPA2_PMKID_LEN);
 
@@ -2671,7 +2671,7 @@ wl_iw_set_pmksa(struct net_device *dev,
 		for (i = 0; i < pmkid_list.pmkids.npmkid; i++)
 			if (!memcmp
 			    (&iwpmksa->bssid.sa_data[0],
-			     &pmkid_list.pmkids.pmkid[i].BSSID, ETHER_ADDR_LEN))
+			     &pmkid_list.pmkids.pmkid[i].BSSID, ETH_ALEN))
 				break;
 
 		if ((pmkid_list.pmkids.npmkid > 0)
@@ -2680,7 +2680,7 @@ wl_iw_set_pmksa(struct net_device *dev,
 			for (; i < (pmkid_list.pmkids.npmkid - 1); i++) {
 				bcopy(&pmkid_list.pmkids.pmkid[i + 1].BSSID,
 				      &pmkid_list.pmkids.pmkid[i].BSSID,
-				      ETHER_ADDR_LEN);
+				      ETH_ALEN);
 				bcopy(&pmkid_list.pmkids.pmkid[i + 1].PMKID,
 				      &pmkid_list.pmkids.pmkid[i].PMKID,
 				      WPA2_PMKID_LEN);
@@ -2694,12 +2694,12 @@ wl_iw_set_pmksa(struct net_device *dev,
 		for (i = 0; i < pmkid_list.pmkids.npmkid; i++)
 			if (!memcmp
 			    (&iwpmksa->bssid.sa_data[0],
-			     &pmkid_list.pmkids.pmkid[i].BSSID, ETHER_ADDR_LEN))
+			     &pmkid_list.pmkids.pmkid[i].BSSID, ETH_ALEN))
 				break;
 		if (i < MAXPMKID) {
 			bcopy(&iwpmksa->bssid.sa_data[0],
 			      &pmkid_list.pmkids.pmkid[i].BSSID,
-			      ETHER_ADDR_LEN);
+			      ETH_ALEN);
 			bcopy(&iwpmksa->pmkid[0],
 			      &pmkid_list.pmkids.pmkid[i].PMKID,
 			      WPA2_PMKID_LEN);
@@ -3395,34 +3395,34 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 	switch (event_type) {
 	case WLC_E_TXFAIL:
 		cmd = IWEVTXDROP;
-		memcpy(wrqu.addr.sa_data, &e->addr, ETHER_ADDR_LEN);
+		memcpy(wrqu.addr.sa_data, &e->addr, ETH_ALEN);
 		wrqu.addr.sa_family = ARPHRD_ETHER;
 		break;
 #if WIRELESS_EXT > 14
 	case WLC_E_JOIN:
 	case WLC_E_ASSOC_IND:
 	case WLC_E_REASSOC_IND:
-		memcpy(wrqu.addr.sa_data, &e->addr, ETHER_ADDR_LEN);
+		memcpy(wrqu.addr.sa_data, &e->addr, ETH_ALEN);
 		wrqu.addr.sa_family = ARPHRD_ETHER;
 		cmd = IWEVREGISTERED;
 		break;
 	case WLC_E_DEAUTH_IND:
 	case WLC_E_DISASSOC_IND:
 		cmd = SIOCGIWAP;
-		memset(wrqu.addr.sa_data, 0, ETHER_ADDR_LEN);
+		memset(wrqu.addr.sa_data, 0, ETH_ALEN);
 		wrqu.addr.sa_family = ARPHRD_ETHER;
-		memset(&extra, 0, ETHER_ADDR_LEN);
+		memset(&extra, 0, ETH_ALEN);
 		break;
 	case WLC_E_LINK:
 	case WLC_E_NDIS_LINK:
 		cmd = SIOCGIWAP;
 		if (!(flags & WLC_EVENT_MSG_LINK)) {
-			memset(wrqu.addr.sa_data, 0, ETHER_ADDR_LEN);
-			memset(&extra, 0, ETHER_ADDR_LEN);
+			memset(wrqu.addr.sa_data, 0, ETH_ALEN);
+			memset(&extra, 0, ETH_ALEN);
 			WAKE_LOCK_TIMEOUT(iw->pub, WAKE_LOCK_LINK_DOWN_TMOUT,
 					  20 * HZ);
 		} else {
-			memcpy(wrqu.addr.sa_data, &e->addr, ETHER_ADDR_LEN);
+			memcpy(wrqu.addr.sa_data, &e->addr, ETH_ALEN);
 			WL_TRACE(("Link UP\n"));
 
 		}
@@ -3465,7 +3465,7 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 			else
 				micerrevt->flags |= IW_MICFAILURE_PAIRWISE;
 			memcpy(micerrevt->src_addr.sa_data, &e->addr,
-			       ETHER_ADDR_LEN);
+			       ETH_ALEN);
 			micerrevt->src_addr.sa_family = ARPHRD_ETHER;
 
 			break;
@@ -3495,7 +3495,7 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 						    IW_PMKID_CAND_PREAUTH;
 					bcopy(&pmkidcand->BSSID,
 					      &iwpmkidcand->bssid.sa_data,
-					      ETHER_ADDR_LEN);
+					      ETH_ALEN);
 #ifndef SANDGATE2G
 					wireless_send_event(dev, cmd, &wrqu,
 							    extra);
diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index 086b9b9..a8638db 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -17,12 +17,13 @@
 #ifndef _NET_ETHERNET_H_
 #define _NET_ETHERNET_H_
 
+#include <linux/if_ether.h>
+
 #include <packed_section_start.h>
 
-#define	ETHER_ADDR_LEN		6
 #define	ETHER_TYPE_LEN		2
 #define	ETHER_CRC_LEN		4
-#define	ETHER_HDR_LEN		(ETHER_ADDR_LEN * 2 + ETHER_TYPE_LEN)
+#define	ETHER_HDR_LEN		(ETH_ALEN * 2 + ETHER_TYPE_LEN)
 #define	ETHER_MIN_LEN		64
 #define	ETHER_MIN_DATA		46
 #define	ETHER_MAX_LEN		1518
@@ -36,9 +37,9 @@
 #define	ETHER_TYPE_802_1X	0x888e
 #define	ETHER_TYPE_802_1X_PREAUTH 0x88c7
 
-#define ETHER_DEST_OFFSET	(0 * ETHER_ADDR_LEN)
-#define ETHER_SRC_OFFSET	(1 * ETHER_ADDR_LEN)
-#define ETHER_TYPE_OFFSET	(2 * ETHER_ADDR_LEN)
+#define ETHER_DEST_OFFSET	(0 * ETH_ALEN)
+#define ETHER_SRC_OFFSET	(1 * ETH_ALEN)
+#define ETHER_TYPE_OFFSET	(2 * ETH_ALEN)
 
 #define	ETHER_IS_VALID_LEN(foo)	\
 	((foo) >= ETHER_MIN_LEN && (foo) <= ETHER_MAX_LEN)
@@ -53,13 +54,13 @@
 }
 
 BWL_PRE_PACKED_STRUCT struct ether_header {
-	u8 ether_dhost[ETHER_ADDR_LEN];
-	u8 ether_shost[ETHER_ADDR_LEN];
+	u8 ether_dhost[ETH_ALEN];
+	u8 ether_shost[ETH_ALEN];
 	u16 ether_type;
 } BWL_POST_PACKED_STRUCT;
 
 BWL_PRE_PACKED_STRUCT struct ether_addr {
-	u8 octet[ETHER_ADDR_LEN];
+	u8 octet[ETH_ALEN];
 } BWL_POST_PACKED_STRUCT;
 
 #define ETHER_SET_UNICAST(ea)	(((u8 *)(ea))[0] = (((u8 *)(ea))[0] & ~1))
diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index 1e7a29d..4ae9974 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -749,7 +749,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 		goto fail;
 	}
 
-	bcopy(&wl->pub->cur_etheraddr, perm, ETHER_ADDR_LEN);
+	bcopy(&wl->pub->cur_etheraddr, perm, ETH_ALEN);
 	ASSERT(is_valid_ether_addr(perm));
 	SET_IEEE80211_PERM_ADDR(hw, perm);
 
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index c0883d0..0419c52 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -1318,7 +1318,7 @@ void wlc_ampdu_macaddr_upd(struct wlc_info *wlc)
 
 	/* driver needs to write the ta in the template; ta is at offset 16 */
 	memset(template, 0, sizeof(template));
-	bcopy((char *)wlc->pub->cur_etheraddr.octet, template, ETHER_ADDR_LEN);
+	bcopy((char *)wlc->pub->cur_etheraddr.octet, template, ETH_ALEN);
 	wlc_write_template_ram(wlc, (T_BA_TPL_BASE + 16), (T_RAM_ACCESS_SZ * 2),
 			       template);
 }
diff --git a/drivers/staging/brcm80211/sys/wlc_bmac.c b/drivers/staging/brcm80211/sys/wlc_bmac.c
index 2baacfd..0c2625d 100644
--- a/drivers/staging/brcm80211/sys/wlc_bmac.c
+++ b/drivers/staging/brcm80211/sys/wlc_bmac.c
@@ -1340,13 +1340,13 @@ void wlc_bmac_wait_for_wake(struct wlc_hw_info *wlc_hw)
 
 void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw, struct ether_addr *ea)
 {
-	bcopy(&wlc_hw->etheraddr, ea, ETHER_ADDR_LEN);
+	bcopy(&wlc_hw->etheraddr, ea, ETH_ALEN);
 }
 
 void wlc_bmac_set_hw_etheraddr(struct wlc_hw_info *wlc_hw,
 			       struct ether_addr *ea)
 {
-	bcopy(ea, &wlc_hw->etheraddr, ETHER_ADDR_LEN);
+	bcopy(ea, &wlc_hw->etheraddr, ETH_ALEN);
 }
 
 int wlc_bmac_bandtype(struct wlc_hw_info *wlc_hw)
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index daa67c9..407f5ec 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -1726,7 +1726,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	ASSERT(WSEC_MAX_DEFAULT_KEYS == WLC_DEFAULT_KEYS);
 
 	/* some code depends on packed structures */
-	ASSERT(sizeof(struct ether_addr) == ETHER_ADDR_LEN);
+	ASSERT(sizeof(struct ether_addr) == ETH_ALEN);
 	ASSERT(sizeof(struct ether_header) == ETHER_HDR_LEN);
 	ASSERT(sizeof(d11regs_t) == SI_CORE_SIZE);
 	ASSERT(sizeof(ofdm_phy_hdr_t) == D11_PHY_HDR_LEN);
@@ -1839,7 +1839,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	wlc_bmac_hw_etheraddr(wlc->hw, &wlc->perm_etheraddr);
 
 	bcopy((char *)&wlc->perm_etheraddr, (char *)&pub->cur_etheraddr,
-	      ETHER_ADDR_LEN);
+	      ETH_ALEN);
 
 	for (j = 0; j < NBANDS(wlc); j++) {
 		/* Use band 1 for single band 11a */
@@ -3598,7 +3598,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 					key.flags |= WL_PRIMARY_KEY;
 
 				bcopy(src_key->ea.octet, key.ea.octet,
-				      ETHER_ADDR_LEN);
+				      ETH_ALEN);
 			}
 
 			bcopy((char *)&key, arg, sizeof(key));
@@ -6031,7 +6031,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	txh->TxFesTimeFallback = htol16(0);
 
 	/* TxFrameRA */
-	bcopy((char *)&h->a1, (char *)&txh->TxFrameRA, ETHER_ADDR_LEN);
+	bcopy((char *)&h->a1, (char *)&txh->TxFrameRA, ETH_ALEN);
 
 	/* TxFrameID */
 	txh->TxFrameID = htol16(frameid);
@@ -6118,11 +6118,11 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 
 		if (use_cts) {
 			rts->fc = htol16(FC_CTS);
-			bcopy((char *)&h->a2, (char *)&rts->ra, ETHER_ADDR_LEN);
+			bcopy((char *)&h->a2, (char *)&rts->ra, ETH_ALEN);
 		} else {
 			rts->fc = htol16((u16) FC_RTS);
 			bcopy((char *)&h->a1, (char *)&rts->ra,
-			      2 * ETHER_ADDR_LEN);
+			      2 * ETH_ALEN);
 		}
 
 		/* mainrate
@@ -7639,9 +7639,9 @@ wlc_bcn_prb_template(struct wlc_info *wlc, uint type, ratespec_t bcn_rspec,
 	/* A1 filled in by MAC for prb resp, broadcast for bcn */
 	if (type == FC_BEACON)
 		bcopy((const char *)&ether_bcast, (char *)&h->da,
-		      ETHER_ADDR_LEN);
-	bcopy((char *)&cfg->cur_etheraddr, (char *)&h->sa, ETHER_ADDR_LEN);
-	bcopy((char *)&cfg->BSSID, (char *)&h->bssid, ETHER_ADDR_LEN);
+		      ETH_ALEN);
+	bcopy((char *)&cfg->cur_etheraddr, (char *)&h->sa, ETH_ALEN);
+	bcopy((char *)&cfg->BSSID, (char *)&h->bssid, ETH_ALEN);
 
 	/* SEQ filled in by MAC */
 
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 668dac6..19d4502 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -505,7 +505,7 @@ int srom_parsecis(struct osl_info *osh, u8 *pcis[], uint ciscnt, char **vars,
 					    !is_zero_ether_addr(&cis[i + 2]) &&
 					    !is_multicast_ether_addr(&cis[i + 2])) {
 						ASSERT(cis[i + 1] ==
-						       ETHER_ADDR_LEN);
+						       ETH_ALEN);
 						snprintf(eabuf, sizeof(eabuf),
 							"%pM", &cis[i + 2]);
 
-- 
1.7.3.3.398.g0b0cd.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0HBTTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:19:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45053 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab0HBTTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UXWXp54ePp/eJfT8EFzyjsJ5Tjpx8L4Pg55Oxg3pQGCoArRmXaP6lknM953PRHmcAC
         kVWhH22YVnUrFvbho5xbKmpw0BqgdSLT3VkKdrs8tj2SBC5i0LSkCffD4LmTTEIfMQ37
         yVCATMdED5HUvOWimaFQMmVQ0Yoxyy57rzTfk=
From: Edgardo Hames <ehames@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, ehames@gmail.com
Subject: [PATCH] Staging: wlan-ng: fix checkpatch issues in headers.
Date: Mon,  2 Aug 2010 16:20:39 -0300
Message-Id: <1280776839-637-1-git-send-email-ehames@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix errors and warnings reported by checkpatch
in p80211meta.h and p80211metstruct.h.

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/cfg80211.c         |   18 +++---
 drivers/staging/wlan-ng/p80211meta.h       |   16 +++---
 drivers/staging/wlan-ng/p80211metastruct.h |   60 +++++++++++-----------
 drivers/staging/wlan-ng/p80211netdev.c     |    9 ++--
 drivers/staging/wlan-ng/p80211req.c        |   12 ++--
 drivers/staging/wlan-ng/prism2fw.c         |    8 ++--
 drivers/staging/wlan-ng/prism2mgmt.c       |   22 ++++----
 drivers/staging/wlan-ng/prism2mib.c        |   76 ++++++++++++++--------------
 drivers/staging/wlan-ng/prism2sta.c        |   15 +++---
 9 files changed, 119 insertions(+), 117 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 9488c52..53ca0ba 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -72,7 +72,7 @@ static int prism2_result2err(int prism2_result)
 
 static int prism2_domibset_uint32(wlandevice_t *wlandev, u32 did, u32 data)
 {
-	p80211msg_dot11req_mibset_t msg;
+	struct p80211msg_dot11req_mibset msg;
 	p80211item_uint32_t *mibitem = (p80211item_uint32_t *) &msg.mibattribute.data;
 
 	msg.msgcode = DIDmsg_dot11req_mibset;
@@ -85,7 +85,7 @@ static int prism2_domibset_uint32(wlandevice_t *wlandev, u32 did, u32 data)
 static int prism2_domibset_pstr32(wlandevice_t *wlandev,
 				  u32 did, u8 len, u8 *data)
 {
-	p80211msg_dot11req_mibset_t msg;
+	struct p80211msg_dot11req_mibset msg;
 	p80211item_pstr32_t *mibitem = (p80211item_pstr32_t *) &msg.mibattribute.data;
 
 	msg.msgcode = DIDmsg_dot11req_mibset;
@@ -294,7 +294,7 @@ int prism2_get_station(struct wiphy *wiphy, struct net_device *dev,
 		       u8 *mac, struct station_info *sinfo)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211msg_lnxreq_commsquality_t quality;
+	struct p80211msg_lnxreq_commsquality quality;
 	int result;
 
 	memset(sinfo, 0, sizeof(*sinfo));
@@ -329,8 +329,8 @@ int prism2_scan(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211msg_dot11req_scan_t msg1;
-	p80211msg_dot11req_scan_results_t msg2;
+	struct p80211msg_dot11req_scan msg1;
+	struct p80211msg_dot11req_scan_results msg2;
 	int result;
 	int err = 0;
 	int numbss = 0;
@@ -351,7 +351,7 @@ int prism2_scan(struct wiphy *wiphy, struct net_device *dev,
 
 	priv->scan_request = request;
 
-	memset(&msg1, 0x00, sizeof(p80211msg_dot11req_scan_t));
+	memset(&msg1, 0x00, sizeof(struct p80211msg_dot11req_scan));
 	msg1.msgcode = DIDmsg_dot11req_scan;
 	msg1.bsstype.data = P80211ENUM_bsstype_any;
 
@@ -468,7 +468,7 @@ int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
 {
 	wlandevice_t *wlandev = dev->ml_priv;
 	struct ieee80211_channel *channel = sme->channel;
-	p80211msg_lnxreq_autojoin_t msg_join;
+	struct p80211msg_lnxreq_autojoin msg_join;
 	u32 did;
 	int length = sme->ssid_len;
 	int chan = -1;
@@ -589,7 +589,7 @@ int prism2_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		      u16 reason_code)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211msg_lnxreq_autojoin_t msg_join;
+	struct p80211msg_lnxreq_autojoin msg_join;
 	int result;
 	int err = 0;
 
@@ -652,7 +652,7 @@ int prism2_get_tx_power(struct wiphy *wiphy, int *dbm)
 {
 	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
 	wlandevice_t *wlandev = priv->wlandev;
-	p80211msg_dot11req_mibget_t msg;
+	struct p80211msg_dot11req_mibget msg;
 	p80211item_uint32_t *mibitem = (p80211item_uint32_t *) &msg.mibattribute.data;
 	int result;
 	int err = 0;
diff --git a/drivers/staging/wlan-ng/p80211meta.h b/drivers/staging/wlan-ng/p80211meta.h
index b9badcf..c5f1a63 100644
--- a/drivers/staging/wlan-ng/p80211meta.h
+++ b/drivers/staging/wlan-ng/p80211meta.h
@@ -62,7 +62,7 @@
 /* representation of category list metadata, group list metadata, */
 /* and data item metadata for both Mib and Messages. */
 
-typedef struct p80211meta {
+struct p80211meta {
 	char *name;		/* data item name */
 	u32 did;		/* partial did */
 	u32 flags;		/* set of various flag bits */
@@ -75,16 +75,16 @@ typedef struct p80211meta {
 	p80211_totext_t totextptr;	/* ptr to totext conversion function */
 	p80211_fromtext_t fromtextptr;	/* ptr to totext conversion function */
 	p80211_valid_t validfunptr;	/* ptr to totext conversion function */
-} p80211meta_t;
+};
 
-typedef struct grplistitem {
+struct grplistitem {
 	char *name;
-	p80211meta_t *itemlist;
-} grplistitem_t;
+	struct p80211meta *itemlist;
+};
 
-typedef struct catlistitem {
+struct catlistitem {
 	char *name;
-	grplistitem_t *grplist;
-} catlistitem_t;
+	struct grplistitem *grplist;
+};
 
 #endif /* _P80211META_H */
diff --git a/drivers/staging/wlan-ng/p80211metastruct.h b/drivers/staging/wlan-ng/p80211metastruct.h
index e2e344c..a8a4e3b 100644
--- a/drivers/staging/wlan-ng/p80211metastruct.h
+++ b/drivers/staging/wlan-ng/p80211metastruct.h
@@ -47,23 +47,23 @@
 #ifndef _P80211MKMETASTRUCT_H
 #define _P80211MKMETASTRUCT_H
 
-typedef struct p80211msg_dot11req_mibget {
+struct p80211msg_dot11req_mibget {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
 	p80211item_unk392_t mibattribute;
 	p80211item_uint32_t resultcode;
-} __attribute__ ((packed)) p80211msg_dot11req_mibget_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_dot11req_mibset {
+struct p80211msg_dot11req_mibset {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
 	p80211item_unk392_t mibattribute;
 	p80211item_uint32_t resultcode;
-} __attribute__ ((packed)) p80211msg_dot11req_mibset_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_dot11req_scan {
+struct p80211msg_dot11req_scan {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
@@ -81,9 +81,9 @@ typedef struct p80211msg_dot11req_scan {
 	p80211item_uint32_t resultcode;
 	p80211item_uint32_t numbss;
 	p80211item_uint32_t append;
-} __attribute__ ((packed)) p80211msg_dot11req_scan_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_dot11req_scan_results {
+struct p80211msg_dot11req_scan_results {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
@@ -130,9 +130,9 @@ typedef struct p80211msg_dot11req_scan_results {
 	p80211item_uint32_t supprate6;
 	p80211item_uint32_t supprate7;
 	p80211item_uint32_t supprate8;
-} __attribute__ ((packed)) p80211msg_dot11req_scan_results_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_dot11req_start {
+struct p80211msg_dot11req_start {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
@@ -168,17 +168,17 @@ typedef struct p80211msg_dot11req_start {
 	p80211item_uint32_t operationalrate7;
 	p80211item_uint32_t operationalrate8;
 	p80211item_uint32_t resultcode;
-} __attribute__ ((packed)) p80211msg_dot11req_start_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_lnxreq_ifstate {
+struct p80211msg_lnxreq_ifstate {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
 	p80211item_uint32_t ifstate;
 	p80211item_uint32_t resultcode;
-} __attribute__ ((packed)) p80211msg_lnxreq_ifstate_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_lnxreq_wlansniff {
+struct p80211msg_lnxreq_wlansniff {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
@@ -190,18 +190,18 @@ typedef struct p80211msg_lnxreq_wlansniff {
 	p80211item_uint32_t stripfcs;
 	p80211item_uint32_t packet_trunc;
 	p80211item_uint32_t resultcode;
-} __attribute__ ((packed)) p80211msg_lnxreq_wlansniff_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_lnxreq_hostwep {
+struct p80211msg_lnxreq_hostwep {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
 	p80211item_uint32_t resultcode;
 	p80211item_uint32_t decrypt;
 	p80211item_uint32_t encrypt;
-} __attribute__ ((packed)) p80211msg_lnxreq_hostwep_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_lnxreq_commsquality {
+struct p80211msg_lnxreq_commsquality {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
@@ -211,9 +211,9 @@ typedef struct p80211msg_lnxreq_commsquality {
 	p80211item_uint32_t level;
 	p80211item_uint32_t noise;
 	p80211item_uint32_t txrate;
-} __attribute__ ((packed)) p80211msg_lnxreq_commsquality_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_lnxreq_autojoin {
+struct p80211msg_lnxreq_autojoin {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
@@ -221,26 +221,26 @@ typedef struct p80211msg_lnxreq_autojoin {
 	u8 pad_19D[3];
 	p80211item_uint32_t authtype;
 	p80211item_uint32_t resultcode;
-} __attribute__ ((packed)) p80211msg_lnxreq_autojoin_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_p2req_readpda {
+struct p80211msg_p2req_readpda {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
 	p80211item_unk1024_t pda;
 	p80211item_uint32_t resultcode;
-} __attribute__ ((packed)) p80211msg_p2req_readpda_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_p2req_ramdl_state {
+struct p80211msg_p2req_ramdl_state {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
 	p80211item_uint32_t enable;
 	p80211item_uint32_t exeaddr;
 	p80211item_uint32_t resultcode;
-} __attribute__ ((packed)) p80211msg_p2req_ramdl_state_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_p2req_ramdl_write {
+struct p80211msg_p2req_ramdl_write {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
@@ -248,17 +248,17 @@ typedef struct p80211msg_p2req_ramdl_write {
 	p80211item_uint32_t len;
 	p80211item_unk4096_t data;
 	p80211item_uint32_t resultcode;
-} __attribute__ ((packed)) p80211msg_p2req_ramdl_write_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_p2req_flashdl_state {
+struct p80211msg_p2req_flashdl_state {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
 	p80211item_uint32_t enable;
 	p80211item_uint32_t resultcode;
-} __attribute__ ((packed)) p80211msg_p2req_flashdl_state_t;
+} __attribute__ ((packed));
 
-typedef struct p80211msg_p2req_flashdl_write {
+struct p80211msg_p2req_flashdl_write {
 	u32 msgcode;
 	u32 msglen;
 	u8 devname[WLAN_DEVNAMELEN_MAX];
@@ -266,6 +266,6 @@ typedef struct p80211msg_p2req_flashdl_write {
 	p80211item_uint32_t len;
 	p80211item_unk4096_t data;
 	p80211item_uint32_t resultcode;
-} __attribute__ ((packed)) p80211msg_p2req_flashdl_write_t;
+} __attribute__ ((packed));
 
 #endif
diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index a57ac52..aa1792c 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -607,7 +607,8 @@ static int p80211knetdev_do_ioctl(netdevice_t *dev, struct ifreq *ifr, int cmd)
 		result = -ENOMEM;
 	}
 bail:
-	return result;		/* If allocate,copyfrom or copyto fails, return errno */
+	/* If allocate,copyfrom or copyto fails, return errno */
+	return result;
 }
 
 /*----------------------------------------------------------------
@@ -638,7 +639,7 @@ bail:
 static int p80211knetdev_set_mac_address(netdevice_t *dev, void *addr)
 {
 	struct sockaddr *new_addr = addr;
-	p80211msg_dot11req_mibset_t dot11req;
+	struct p80211msg_dot11req_mibset dot11req;
 	p80211item_unk392_t *mibattr;
 	p80211item_pstr6_t *macaddr;
 	p80211item_uint32_t *resultcode;
@@ -654,9 +655,9 @@ static int p80211knetdev_set_mac_address(netdevice_t *dev, void *addr)
 	resultcode = &dot11req.resultcode;
 
 	/* Set up a dot11req_mibset */
-	memset(&dot11req, 0, sizeof(p80211msg_dot11req_mibset_t));
+	memset(&dot11req, 0, sizeof(struct p80211msg_dot11req_mibset));
 	dot11req.msgcode = DIDmsg_dot11req_mibset;
-	dot11req.msglen = sizeof(p80211msg_dot11req_mibset_t);
+	dot11req.msglen = sizeof(struct p80211msg_dot11req_mibset);
 	memcpy(dot11req.devname,
 	       ((wlandevice_t *) dev->ml_priv)->name, WLAN_DEVNAMELEN_MAX - 1);
 
diff --git a/drivers/staging/wlan-ng/p80211req.c b/drivers/staging/wlan-ng/p80211req.c
index 207f080..83ae126 100644
--- a/drivers/staging/wlan-ng/p80211req.c
+++ b/drivers/staging/wlan-ng/p80211req.c
@@ -74,7 +74,7 @@
 
 static void p80211req_handlemsg(wlandevice_t *wlandev, p80211msg_t *msg);
 static int p80211req_mibset_mibget(wlandevice_t *wlandev,
-				   p80211msg_dot11req_mibget_t *mib_msg,
+				   struct p80211msg_dot11req_mibget *mib_msg,
 				   int isget);
 
 /*----------------------------------------------------------------
@@ -155,8 +155,8 @@ static void p80211req_handlemsg(wlandevice_t *wlandev, p80211msg_t *msg)
 	switch (msg->msgcode) {
 
 	case DIDmsg_lnxreq_hostwep:{
-			p80211msg_lnxreq_hostwep_t *req =
-			    (p80211msg_lnxreq_hostwep_t *) msg;
+			struct p80211msg_lnxreq_hostwep *req =
+			    (struct p80211msg_lnxreq_hostwep *) msg;
 			wlandev->hostwep &=
 			    ~(HOSTWEP_DECRYPT | HOSTWEP_ENCRYPT);
 			if (req->decrypt.data == P80211ENUM_truth_true)
@@ -169,8 +169,8 @@ static void p80211req_handlemsg(wlandevice_t *wlandev, p80211msg_t *msg)
 	case DIDmsg_dot11req_mibget:
 	case DIDmsg_dot11req_mibset:{
 			int isget = (msg->msgcode == DIDmsg_dot11req_mibget);
-			p80211msg_dot11req_mibget_t *mib_msg =
-			    (p80211msg_dot11req_mibget_t *) msg;
+			struct p80211msg_dot11req_mibget *mib_msg =
+			    (struct p80211msg_dot11req_mibget *) msg;
 			p80211req_mibset_mibget(wlandev, mib_msg, isget);
 		}
 	default:
@@ -181,7 +181,7 @@ static void p80211req_handlemsg(wlandevice_t *wlandev, p80211msg_t *msg)
 }
 
 static int p80211req_mibset_mibget(wlandevice_t *wlandev,
-				   p80211msg_dot11req_mibget_t *mib_msg,
+				   struct p80211msg_dot11req_mibget *mib_msg,
 				   int isget)
 {
 	p80211itemd_t *mibitem = (p80211itemd_t *) mib_msg->mibattribute.data;
diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index f8fe17f..5b97c4a 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -239,7 +239,7 @@ int prism2_fwtry(struct usb_device *udev, wlandevice_t *wlandev)
 int prism2_fwapply(const struct ihex_binrec *rfptr, wlandevice_t *wlandev)
 {
 	signed int result = 0;
-	p80211msg_dot11req_mibget_t getmsg;
+	struct p80211msg_dot11req_mibget getmsg;
 	p80211itemd_t *item;
 	u32 *data;
 
@@ -766,7 +766,7 @@ int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
 int read_cardpda(struct pda *pda, wlandevice_t *wlandev)
 {
 	int result = 0;
-	p80211msg_p2req_readpda_t msg;
+	struct p80211msg_p2req_readpda msg;
 
 	/* set up the msg */
 	msg.msgcode = DIDmsg_p2req_readpda;
@@ -981,8 +981,8 @@ int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 	       unsigned int nfchunks)
 {
 	int result = 0;
-	p80211msg_p2req_ramdl_state_t rstatemsg;
-	p80211msg_p2req_ramdl_write_t rwritemsg;
+	struct p80211msg_p2req_ramdl_state rstatemsg;
+	struct p80211msg_p2req_ramdl_write rwritemsg;
 	p80211msg_t *msgp;
 	u32 resultcode;
 	int i;
diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index ef23f8b..04514a8 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -117,7 +117,7 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 {
 	int result = 0;
 	hfa384x_t *hw = wlandev->priv;
-	p80211msg_dot11req_scan_t *msg = msgp;
+	struct p80211msg_dot11req_scan *msg = msgp;
 	u16 roamingmode, word;
 	int i, timeout;
 	int istmpenable = 0;
@@ -361,13 +361,13 @@ exit:
 int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
 {
 	int result = 0;
-	p80211msg_dot11req_scan_results_t *req;
+	struct p80211msg_dot11req_scan_results *req;
 	hfa384x_t *hw = wlandev->priv;
 	hfa384x_HScanResultSub_t *item = NULL;
 
 	int count;
 
-	req = (p80211msg_dot11req_scan_results_t *) msgp;
+	req = (struct p80211msg_dot11req_scan_results *) msgp;
 
 	req->resultcode.status = P80211ENUM_msgitem_status_data_ok;
 
@@ -513,7 +513,7 @@ int prism2mgmt_start(wlandevice_t *wlandev, void *msgp)
 {
 	int result = 0;
 	hfa384x_t *hw = wlandev->priv;
-	p80211msg_dot11req_start_t *msg = msgp;
+	struct p80211msg_dot11req_start *msg = msgp;
 
 	p80211pstrd_t *pstr;
 	u8 bytebuf[80];
@@ -689,7 +689,7 @@ done:
 int prism2mgmt_readpda(wlandevice_t *wlandev, void *msgp)
 {
 	hfa384x_t *hw = wlandev->priv;
-	p80211msg_p2req_readpda_t *msg = msgp;
+	struct p80211msg_p2req_readpda *msg = msgp;
 	int result;
 
 	/* We only support collecting the PDA when in the FWLOAD
@@ -755,7 +755,7 @@ int prism2mgmt_readpda(wlandevice_t *wlandev, void *msgp)
 int prism2mgmt_ramdl_state(wlandevice_t *wlandev, void *msgp)
 {
 	hfa384x_t *hw = wlandev->priv;
-	p80211msg_p2req_ramdl_state_t *msg = msgp;
+	struct p80211msg_p2req_ramdl_state *msg = msgp;
 
 	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
 		printk(KERN_ERR
@@ -811,7 +811,7 @@ int prism2mgmt_ramdl_state(wlandevice_t *wlandev, void *msgp)
 int prism2mgmt_ramdl_write(wlandevice_t *wlandev, void *msgp)
 {
 	hfa384x_t *hw = wlandev->priv;
-	p80211msg_p2req_ramdl_write_t *msg = msgp;
+	struct p80211msg_p2req_ramdl_write *msg = msgp;
 	u32 addr;
 	u32 len;
 	u8 *buf;
@@ -874,7 +874,7 @@ int prism2mgmt_flashdl_state(wlandevice_t *wlandev, void *msgp)
 {
 	int result = 0;
 	hfa384x_t *hw = wlandev->priv;
-	p80211msg_p2req_flashdl_state_t *msg = msgp;
+	struct p80211msg_p2req_flashdl_state *msg = msgp;
 
 	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
 		printk(KERN_ERR
@@ -944,7 +944,7 @@ int prism2mgmt_flashdl_state(wlandevice_t *wlandev, void *msgp)
 int prism2mgmt_flashdl_write(wlandevice_t *wlandev, void *msgp)
 {
 	hfa384x_t *hw = wlandev->priv;
-	p80211msg_p2req_flashdl_write_t *msg = msgp;
+	struct p80211msg_p2req_flashdl_write *msg = msgp;
 	u32 addr;
 	u32 len;
 	u8 *buf;
@@ -1008,7 +1008,7 @@ int prism2mgmt_autojoin(wlandevice_t *wlandev, void *msgp)
 	int result = 0;
 	u16 reg;
 	u16 port_type;
-	p80211msg_lnxreq_autojoin_t *msg = msgp;
+	struct p80211msg_lnxreq_autojoin *msg = msgp;
 	p80211pstrd_t *pstr;
 	u8 bytebuf[256];
 	hfa384x_bytestr_t *p2bytestr = (hfa384x_bytestr_t *) bytebuf;
@@ -1076,7 +1076,7 @@ int prism2mgmt_autojoin(wlandevice_t *wlandev, void *msgp)
 int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 {
 	int result = 0;
-	p80211msg_lnxreq_wlansniff_t *msg = msgp;
+	struct p80211msg_lnxreq_wlansniff *msg = msgp;
 
 	hfa384x_t *hw = wlandev->priv;
 	u16 word;
diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
index 0b0ec9c..d3a06fa 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -79,7 +79,7 @@
 #define  F_READ       0x2	/* MIB may be read. */
 #define  F_WRITE      0x4	/* MIB may be written. */
 
-typedef struct mibrec {
+struct mibrec {
 	u32 did;
 	u16 flag;
 	u16 parm1;
@@ -89,63 +89,63 @@ typedef struct mibrec {
 		     int isget,
 		     wlandevice_t *wlandev,
 		     hfa384x_t *hw,
-		     p80211msg_dot11req_mibset_t *msg, void *data);
-} mibrec_t;
+		     struct p80211msg_dot11req_mibset *msg, void *data);
+};
 
-static int prism2mib_bytearea2pstr(mibrec_t *mib,
+static int prism2mib_bytearea2pstr(struct mibrec *mib,
 				   int isget,
 				   wlandevice_t *wlandev,
 				   hfa384x_t *hw,
-				   p80211msg_dot11req_mibset_t *msg,
+				   struct p80211msg_dot11req_mibset *msg,
 				   void *data);
 
-static int prism2mib_uint32(mibrec_t *mib,
+static int prism2mib_uint32(struct mibrec *mib,
 			    int isget,
 			    wlandevice_t *wlandev,
 			    hfa384x_t *hw,
-			    p80211msg_dot11req_mibset_t *msg, void *data);
+			    struct p80211msg_dot11req_mibset *msg, void *data);
 
-static int prism2mib_flag(mibrec_t *mib,
+static int prism2mib_flag(struct mibrec *mib,
 			  int isget,
 			  wlandevice_t *wlandev,
 			  hfa384x_t *hw,
-			  p80211msg_dot11req_mibset_t *msg, void *data);
+			  struct p80211msg_dot11req_mibset *msg, void *data);
 
-static int prism2mib_wepdefaultkey(mibrec_t *mib,
+static int prism2mib_wepdefaultkey(struct mibrec *mib,
 				   int isget,
 				   wlandevice_t *wlandev,
 				   hfa384x_t *hw,
-				   p80211msg_dot11req_mibset_t *msg,
+				   struct p80211msg_dot11req_mibset *msg,
 				   void *data);
 
-static int prism2mib_privacyinvoked(mibrec_t *mib,
+static int prism2mib_privacyinvoked(struct mibrec *mib,
 				    int isget,
 				    wlandevice_t *wlandev,
 				    hfa384x_t *hw,
-				    p80211msg_dot11req_mibset_t *msg,
+				    struct p80211msg_dot11req_mibset *msg,
 				    void *data);
 
-static int prism2mib_excludeunencrypted(mibrec_t *mib,
+static int prism2mib_excludeunencrypted(struct mibrec *mib,
 					int isget,
 					wlandevice_t *wlandev,
 					hfa384x_t *hw,
-					p80211msg_dot11req_mibset_t *msg,
+					struct p80211msg_dot11req_mibset *msg,
 					void *data);
 
-static int prism2mib_fragmentationthreshold(mibrec_t *mib,
+static int prism2mib_fragmentationthreshold(struct mibrec *mib,
 					    int isget,
 					    wlandevice_t *wlandev,
 					    hfa384x_t *hw,
-					    p80211msg_dot11req_mibset_t *msg,
+					    struct p80211msg_dot11req_mibset *msg,
 					    void *data);
 
-static int prism2mib_priv(mibrec_t *mib,
+static int prism2mib_priv(struct mibrec *mib,
 			  int isget,
 			  wlandevice_t *wlandev,
 			  hfa384x_t *hw,
-			  p80211msg_dot11req_mibset_t *msg, void *data);
+			  struct p80211msg_dot11req_mibset *msg, void *data);
 
-static mibrec_t mibtab[] = {
+static struct mibrec mibtab[] = {
 
 	/* dot11smt MIB's */
 	{DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey0,
@@ -261,11 +261,11 @@ int prism2mgmt_mibset_mibget(wlandevice_t *wlandev, void *msgp)
 {
 	hfa384x_t *hw = wlandev->priv;
 	int result, isget;
-	mibrec_t *mib;
+	struct mibrec *mib;
 
 	u16 which;
 
-	p80211msg_dot11req_mibset_t *msg = msgp;
+	struct p80211msg_dot11req_mibset *msg = msgp;
 	p80211itemd_t *mibitem;
 
 	msg->resultcode.status = P80211ENUM_msgitem_status_data_ok;
@@ -371,11 +371,11 @@ done:
 *
 ----------------------------------------------------------------*/
 
-static int prism2mib_bytearea2pstr(mibrec_t *mib,
+static int prism2mib_bytearea2pstr(struct mibrec *mib,
 				   int isget,
 				   wlandevice_t *wlandev,
 				   hfa384x_t *hw,
-				   p80211msg_dot11req_mibset_t *msg,
+				   struct p80211msg_dot11req_mibset *msg,
 				   void *data)
 {
 	int result;
@@ -421,11 +421,11 @@ static int prism2mib_bytearea2pstr(mibrec_t *mib,
 *
 ----------------------------------------------------------------*/
 
-static int prism2mib_uint32(mibrec_t *mib,
+static int prism2mib_uint32(struct mibrec *mib,
 			    int isget,
 			    wlandevice_t *wlandev,
 			    hfa384x_t *hw,
-			    p80211msg_dot11req_mibset_t *msg, void *data)
+			    struct p80211msg_dot11req_mibset *msg, void *data)
 {
 	int result;
 	u32 *uint32 = (u32 *) data;
@@ -468,11 +468,11 @@ static int prism2mib_uint32(mibrec_t *mib,
 *
 ----------------------------------------------------------------*/
 
-static int prism2mib_flag(mibrec_t *mib,
+static int prism2mib_flag(struct mibrec *mib,
 			  int isget,
 			  wlandevice_t *wlandev,
 			  hfa384x_t *hw,
-			  p80211msg_dot11req_mibset_t *msg, void *data)
+			  struct p80211msg_dot11req_mibset *msg, void *data)
 {
 	int result;
 	u32 *uint32 = (u32 *) data;
@@ -525,11 +525,11 @@ static int prism2mib_flag(mibrec_t *mib,
 *
 ----------------------------------------------------------------*/
 
-static int prism2mib_wepdefaultkey(mibrec_t *mib,
+static int prism2mib_wepdefaultkey(struct mibrec *mib,
 				   int isget,
 				   wlandevice_t *wlandev,
 				   hfa384x_t *hw,
-				   p80211msg_dot11req_mibset_t *msg,
+				   struct p80211msg_dot11req_mibset *msg,
 				   void *data)
 {
 	int result;
@@ -575,11 +575,11 @@ static int prism2mib_wepdefaultkey(mibrec_t *mib,
 *
 ----------------------------------------------------------------*/
 
-static int prism2mib_privacyinvoked(mibrec_t *mib,
+static int prism2mib_privacyinvoked(struct mibrec *mib,
 				    int isget,
 				    wlandevice_t *wlandev,
 				    hfa384x_t *hw,
-				    p80211msg_dot11req_mibset_t *msg,
+				    struct p80211msg_dot11req_mibset *msg,
 				    void *data)
 {
 	int result;
@@ -621,11 +621,11 @@ static int prism2mib_privacyinvoked(mibrec_t *mib,
 *
 ----------------------------------------------------------------*/
 
-static int prism2mib_excludeunencrypted(mibrec_t *mib,
+static int prism2mib_excludeunencrypted(struct mibrec *mib,
 					int isget,
 					wlandevice_t *wlandev,
 					hfa384x_t *hw,
-					p80211msg_dot11req_mibset_t *msg,
+					struct p80211msg_dot11req_mibset *msg,
 					void *data)
 {
 	int result;
@@ -660,11 +660,11 @@ static int prism2mib_excludeunencrypted(mibrec_t *mib,
 *
 ----------------------------------------------------------------*/
 
-static int prism2mib_fragmentationthreshold(mibrec_t *mib,
+static int prism2mib_fragmentationthreshold(struct mibrec *mib,
 					    int isget,
 					    wlandevice_t *wlandev,
 					    hfa384x_t *hw,
-					    p80211msg_dot11req_mibset_t *msg,
+					    struct p80211msg_dot11req_mibset *msg,
 					    void *data)
 {
 	int result;
@@ -709,11 +709,11 @@ static int prism2mib_fragmentationthreshold(mibrec_t *mib,
 *
 ----------------------------------------------------------------*/
 
-static int prism2mib_priv(mibrec_t *mib,
+static int prism2mib_priv(struct mibrec *mib,
 			  int isget,
 			  wlandevice_t *wlandev,
 			  hfa384x_t *hw,
-			  p80211msg_dot11req_mibset_t *msg, void *data)
+			  struct p80211msg_dot11req_mibset *msg, void *data)
 {
 	p80211pstrd_t *pstr = (p80211pstrd_t *) data;
 
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 5ac6aa6..e5c5768 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -366,9 +366,9 @@ static int prism2sta_mlmerequest(wlandevice_t *wlandev, p80211msg_t *msg)
 		break;		/* ignore me. */
 	case DIDmsg_lnxreq_ifstate:
 		{
-			p80211msg_lnxreq_ifstate_t *ifstatemsg;
+			struct p80211msg_lnxreq_ifstate *ifstatemsg;
 			pr_debug("Received mlme ifstate request\n");
-			ifstatemsg = (p80211msg_lnxreq_ifstate_t *) msg;
+			ifstatemsg = (struct p80211msg_lnxreq_ifstate *) msg;
 			result =
 			    prism2sta_ifstate(wlandev,
 					      ifstatemsg->ifstate.data);
@@ -387,11 +387,11 @@ static int prism2sta_mlmerequest(wlandevice_t *wlandev, p80211msg_t *msg)
 		result = prism2mgmt_autojoin(wlandev, msg);
 		break;
 	case DIDmsg_lnxreq_commsquality:{
-			p80211msg_lnxreq_commsquality_t *qualmsg;
+			struct p80211msg_lnxreq_commsquality *qualmsg;
 
 			pr_debug("Received commsquality request\n");
 
-			qualmsg = (p80211msg_lnxreq_commsquality_t *) msg;
+			qualmsg = (struct p80211msg_lnxreq_commsquality *) msg;
 
 			qualmsg->link.status =
 			    P80211ENUM_msgitem_status_data_ok;
@@ -1987,8 +1987,9 @@ void prism2sta_commsqual_defer(struct work_struct *data)
 	hfa384x_t *hw = container_of(data, struct hfa384x, commsqual_bh);
 	wlandevice_t *wlandev = hw->wlandev;
 	hfa384x_bytestr32_t ssid;
-	p80211msg_dot11req_mibget_t msg;
-	p80211item_uint32_t *mibitem = (p80211item_uint32_t *) &msg.mibattribute.data;
+	struct p80211msg_dot11req_mibget msg;
+	p80211item_uint32_t *mibitem = (p80211item_uint32_t *)
+						&msg.mibattribute.data;
 	int result = 0;
 
 	if (hw->wlandev->hwremoved)
@@ -2020,7 +2021,7 @@ void prism2sta_commsqual_defer(struct work_struct *data)
 	/* Get the signal rate */
 	msg.msgcode = DIDmsg_dot11req_mibget;
 	mibitem->did = DIDmib_p2_p2MAC_p2CurrentTxRate;
-	result = p80211req_dorequest(wlandev, (u8 *) & msg);
+	result = p80211req_dorequest(wlandev, (u8 *) &msg);
 
 	if (result) {
 		pr_debug("get signal rate failed, result = %d\n",
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab0GaBug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 21:50:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32809 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab0GaBuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 21:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bGyHb3VQc4acAu5aOItbKzF72JggyoATdwlsy5BEZWyf7TWjyA6193fFf9rRIxFRJs
         VXgMyWfF7OCTOVy2tS9xit+CzIbDbl+2jsQWb49smDTvepDUE/fzX2Xd7AvJVsWjDt/H
         PwAL1RfThzPW/64djWRb1oFYW6wrECiOGUO74=
From: Edgardo Hames <ehames@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, ehames@gmail.com
Subject: [PATCH] Staging: wlan-ng: fix style issues for p80211hdr.h
Date: Fri, 30 Jul 2010 22:51:55 -0300
Message-Id: <1280541115-16429-1-git-send-email-ehames@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed typedef and other style issues.

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x.h      |    2 +-
 drivers/staging/wlan-ng/hfa384x_usb.c  |    4 ++--
 drivers/staging/wlan-ng/p80211conv.c   |    6 +++---
 drivers/staging/wlan-ng/p80211conv.h   |    2 +-
 drivers/staging/wlan-ng/p80211hdr.h    |   24 ++++++++++++------------
 drivers/staging/wlan-ng/p80211mgmt.h   |   24 ++++++++++++------------
 drivers/staging/wlan-ng/p80211netdev.c |   12 ++++++------
 drivers/staging/wlan-ng/p80211netdev.h |    2 +-
 drivers/staging/wlan-ng/prism2sta.c    |    4 ++--
 9 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index ab9bfaa..e3269f4 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -1409,7 +1409,7 @@ int hfa384x_drvr_start(hfa384x_t *hw);
 int hfa384x_drvr_stop(hfa384x_t *hw);
 int
 hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
-		     p80211_hdr_t *p80211_hdr, p80211_metawep_t *p80211_wep);
+		     union p80211_hdr *p80211_hdr, p80211_metawep_t *p80211_wep);
 void hfa384x_tx_timeout(wlandevice_t *wlandev);
 
 int hfa384x_cmd_initialize(hfa384x_t *hw);
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 563017a..925a7c5 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -2706,7 +2706,7 @@ int hfa384x_drvr_stop(hfa384x_t *hw)
 *	interrupt
 ----------------------------------------------------------------*/
 int hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
-			 p80211_hdr_t *p80211_hdr,
+			 union p80211_hdr *p80211_hdr,
 			 p80211_metawep_t *p80211_wep)
 {
 	int usbpktlen = sizeof(hfa384x_tx_frame_t);
@@ -2752,7 +2752,7 @@ int hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
 
 	/* copy the header over to the txdesc */
 	memcpy(&(hw->txbuff.txfrm.desc.frame_control), p80211_hdr,
-	       sizeof(p80211_hdr_t));
+	       sizeof(union p80211_hdr));
 
 	/* if we're using host WEP, increase size by IV+ICV */
 	if (p80211_wep->data) {
diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index 059e150..409a7c8 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -103,7 +103,7 @@ static u8 oui_8021h[] = { 0x00, 0x00, 0xf8 };
 *	May be called in interrupt or non-interrupt context
 ----------------------------------------------------------------*/
 int skb_ether_to_p80211(wlandevice_t *wlandev, u32 ethconv,
-			struct sk_buff *skb, p80211_hdr_t *p80211_hdr,
+			struct sk_buff *skb, union p80211_hdr *p80211_hdr,
 			p80211_metawep_t *p80211_wep)
 {
 
@@ -280,7 +280,7 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 	unsigned int payload_offset;
 	u8 daddr[WLAN_ETHADDR_LEN];
 	u8 saddr[WLAN_ETHADDR_LEN];
-	p80211_hdr_t *w_hdr;
+	union p80211_hdr *w_hdr;
 	wlan_ethhdr_t *e_hdr;
 	wlan_llc_t *e_llc;
 	wlan_snap_t *e_snap;
@@ -290,7 +290,7 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 	payload_length = skb->len - WLAN_HDR_A3_LEN - WLAN_CRC_LEN;
 	payload_offset = WLAN_HDR_A3_LEN;
 
-	w_hdr = (p80211_hdr_t *) skb->data;
+	w_hdr = (union p80211_hdr *) skb->data;
 
 	/* setup some vars for convenience */
 	fc = le16_to_cpu(w_hdr->a3.fc);
diff --git a/drivers/staging/wlan-ng/p80211conv.h b/drivers/staging/wlan-ng/p80211conv.h
index 6fe163b..65ab211 100644
--- a/drivers/staging/wlan-ng/p80211conv.h
+++ b/drivers/staging/wlan-ng/p80211conv.h
@@ -153,7 +153,7 @@ struct wlandevice;
 int skb_p80211_to_ether(struct wlandevice *wlandev, u32 ethconv,
 			struct sk_buff *skb);
 int skb_ether_to_p80211(struct wlandevice *wlandev, u32 ethconv,
-			struct sk_buff *skb, p80211_hdr_t *p80211_hdr,
+			struct sk_buff *skb, union p80211_hdr *p80211_hdr,
 			p80211_metawep_t *p80211_wep);
 
 int p80211_stt_findproto(u16 proto);
diff --git a/drivers/staging/wlan-ng/p80211hdr.h b/drivers/staging/wlan-ng/p80211hdr.h
index 419de4d..1f6e4eb 100644
--- a/drivers/staging/wlan-ng/p80211hdr.h
+++ b/drivers/staging/wlan-ng/p80211hdr.h
@@ -94,7 +94,7 @@
 
 /* Control */
 #define WLAN_FSTYPE_BLOCKACKREQ		0x8
-#define WLAN_FSTYPE_BLOCKACK  		0x9
+#define WLAN_FSTYPE_BLOCKACK		0x9
 #define WLAN_FSTYPE_PSPOLL		0x0a
 #define WLAN_FSTYPE_RTS			0x0b
 #define WLAN_FSTYPE_CTS			0x0c
@@ -133,13 +133,13 @@
 
 #define WLAN_GET_FC_FTYPE(n)	((((u16)(n)) & (BIT(2) | BIT(3))) >> 2)
 #define WLAN_GET_FC_FSTYPE(n)	((((u16)(n)) & (BIT(4)|BIT(5)|BIT(6)|BIT(7))) >> 4)
-#define WLAN_GET_FC_TODS(n) 	((((u16)(n)) & (BIT(8))) >> 8)
+#define WLAN_GET_FC_TODS(n)	((((u16)(n)) & (BIT(8))) >> 8)
 #define WLAN_GET_FC_FROMDS(n)	((((u16)(n)) & (BIT(9))) >> 9)
 #define WLAN_GET_FC_ISWEP(n)	((((u16)(n)) & (BIT(14))) >> 14)
 
 #define WLAN_SET_FC_FTYPE(n)	(((u16)(n)) << 2)
 #define WLAN_SET_FC_FSTYPE(n)	(((u16)(n)) << 4)
-#define WLAN_SET_FC_TODS(n) 	(((u16)(n)) << 8)
+#define WLAN_SET_FC_TODS(n)	(((u16)(n)) << 8)
 #define WLAN_SET_FC_FROMDS(n)	(((u16)(n)) << 9)
 #define WLAN_SET_FC_ISWEP(n)	(((u16)(n)) << 14)
 
@@ -147,16 +147,16 @@
 
 /* Generic 802.11 Header types */
 
-typedef struct p80211_hdr_a3 {
+struct p80211_hdr_a3 {
 	u16 fc;
 	u16 dur;
 	u8 a1[ETH_ALEN];
 	u8 a2[ETH_ALEN];
 	u8 a3[ETH_ALEN];
 	u16 seq;
-} __attribute__ ((packed)) p80211_hdr_a3_t;
+} __attribute__ ((packed));
 
-typedef struct p80211_hdr_a4 {
+struct p80211_hdr_a4 {
 	u16 fc;
 	u16 dur;
 	u8 a1[ETH_ALEN];
@@ -164,18 +164,18 @@ typedef struct p80211_hdr_a4 {
 	u8 a3[ETH_ALEN];
 	u16 seq;
 	u8 a4[ETH_ALEN];
-} __attribute__ ((packed)) p80211_hdr_a4_t;
+} __attribute__ ((packed));
 
-typedef union p80211_hdr {
-	p80211_hdr_a3_t a3;
-	p80211_hdr_a4_t a4;
-} __attribute__ ((packed)) p80211_hdr_t;
+union p80211_hdr {
+	struct p80211_hdr_a3 a3;
+	struct p80211_hdr_a4 a4;
+} __attribute__ ((packed));
 
 /* Frame and header length macros */
 
 #define WLAN_CTL_FRAMELEN(fstype) (\
 	(fstype) == WLAN_FSTYPE_BLOCKACKREQ	? 24 : \
-	(fstype) == WLAN_FSTYPE_BLOCKACK   	? 152 : \
+	(fstype) == WLAN_FSTYPE_BLOCKACK	? 152 : \
 	(fstype) == WLAN_FSTYPE_PSPOLL		? 20 : \
 	(fstype) == WLAN_FSTYPE_RTS		? 20 : \
 	(fstype) == WLAN_FSTYPE_CTS		? 14 : \
diff --git a/drivers/staging/wlan-ng/p80211mgmt.h b/drivers/staging/wlan-ng/p80211mgmt.h
index deb52f5..3b5e811 100644
--- a/drivers/staging/wlan-ng/p80211mgmt.h
+++ b/drivers/staging/wlan-ng/p80211mgmt.h
@@ -298,7 +298,7 @@ typedef struct wlan_fr_mgmt {
 	u16 type;
 	u16 len;		/* DOES NOT include CRC !!!! */
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 	/*-- fixed fields -----------*/
@@ -310,7 +310,7 @@ typedef struct wlan_fr_beacon {
 	u16 type;
 	u16 len;
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 	/*-- fixed fields -----------*/
@@ -333,7 +333,7 @@ typedef struct wlan_fr_ibssatim {
 	u16 type;
 	u16 len;
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 
@@ -349,7 +349,7 @@ typedef struct wlan_fr_disassoc {
 	u16 type;
 	u16 len;
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 	/*-- fixed fields -----------*/
@@ -364,7 +364,7 @@ typedef struct wlan_fr_assocreq {
 	u16 type;
 	u16 len;
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 	/*-- fixed fields -----------*/
@@ -381,7 +381,7 @@ typedef struct wlan_fr_assocresp {
 	u16 type;
 	u16 len;
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 	/*-- fixed fields -----------*/
@@ -398,7 +398,7 @@ typedef struct wlan_fr_reassocreq {
 	u16 type;
 	u16 len;
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 	/*-- fixed fields -----------*/
@@ -416,7 +416,7 @@ typedef struct wlan_fr_reassocresp {
 	u16 type;
 	u16 len;
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 	/*-- fixed fields -----------*/
@@ -433,7 +433,7 @@ typedef struct wlan_fr_probereq {
 	u16 type;
 	u16 len;
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 	/*-- fixed fields -----------*/
@@ -448,7 +448,7 @@ typedef struct wlan_fr_proberesp {
 	u16 type;
 	u16 len;
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 	/*-- fixed fields -----------*/
@@ -469,7 +469,7 @@ typedef struct wlan_fr_authen {
 	u16 type;
 	u16 len;
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 	/*-- fixed fields -----------*/
@@ -486,7 +486,7 @@ typedef struct wlan_fr_deauthen {
 	u16 type;
 	u16 len;
 	u8 *buf;
-	p80211_hdr_t *hdr;
+	union p80211_hdr *hdr;
 	/* used for target specific data, skb in Linux */
 	void *priv;
 	/*-- fixed fields -----------*/
diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index ead8a35..c299ace 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -264,7 +264,7 @@ static void p80211netdev_rx_bh(unsigned long arg)
 	wlandevice_t *wlandev = (wlandevice_t *) arg;
 	struct sk_buff *skb = NULL;
 	netdevice_t *dev = wlandev->netdev;
-	p80211_hdr_a3_t *hdr;
+	struct p80211_hdr_a3 *hdr;
 	u16 fc;
 
 	/* Let's empty our our queue */
@@ -288,7 +288,7 @@ static void p80211netdev_rx_bh(unsigned long arg)
 				netif_rx_ni(skb);
 				continue;
 			} else {
-				hdr = (p80211_hdr_a3_t *) skb->data;
+				hdr = (struct p80211_hdr_a3 *) skb->data;
 				fc = le16_to_cpu(hdr->fc);
 				if (p80211_rx_typedrop(wlandev, fc)) {
 					dev_kfree_skb(skb);
@@ -350,7 +350,7 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 	int result = 0;
 	int txresult = -1;
 	wlandevice_t *wlandev = netdev->ml_priv;
-	p80211_hdr_t p80211_hdr;
+	union p80211_hdr p80211_hdr;
 	p80211_metawep_t p80211_wep;
 
 	if (skb == NULL)
@@ -361,7 +361,7 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 		goto failed;
 	}
 
-	memset(&p80211_hdr, 0, sizeof(p80211_hdr_t));
+	memset(&p80211_hdr, 0, sizeof(union p80211_hdr));
 	memset(&p80211_wep, 0, sizeof(p80211_metawep_t));
 
 	if (netif_queue_stopped(netdev)) {
@@ -401,8 +401,8 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 			goto failed;
 		}
 		/* move the header over */
-		memcpy(&p80211_hdr, skb->data, sizeof(p80211_hdr_t));
-		skb_pull(skb, sizeof(p80211_hdr_t));
+		memcpy(&p80211_hdr, skb->data, sizeof(union p80211_hdr));
+		skb_pull(skb, sizeof(union p80211_hdr));
 	} else {
 		if (skb_ether_to_p80211
 		    (wlandev, wlandev->ethconv, skb, &p80211_hdr,
diff --git a/drivers/staging/wlan-ng/p80211netdev.h b/drivers/staging/wlan-ng/p80211netdev.h
index 098ccf7..3e19dad 100644
--- a/drivers/staging/wlan-ng/p80211netdev.h
+++ b/drivers/staging/wlan-ng/p80211netdev.h
@@ -184,7 +184,7 @@ typedef struct wlandevice {
 	int (*close) (struct wlandevice *wlandev);
 	void (*reset) (struct wlandevice *wlandev);
 	int (*txframe) (struct wlandevice *wlandev, struct sk_buff *skb,
-			p80211_hdr_t *p80211_hdr,
+			union p80211_hdr *p80211_hdr,
 			p80211_metawep_t *p80211_wep);
 	int (*mlmerequest) (struct wlandevice *wlandev, p80211msg_t *msg);
 	int (*set_multicast_list) (struct wlandevice *wlandev,
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 1a502bc..6f5fc01 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -130,7 +130,7 @@ static int prism2sta_open(wlandevice_t *wlandev);
 static int prism2sta_close(wlandevice_t *wlandev);
 static void prism2sta_reset(wlandevice_t *wlandev);
 static int prism2sta_txframe(wlandevice_t *wlandev, struct sk_buff *skb,
-			     p80211_hdr_t *p80211_hdr,
+			     union p80211_hdr *p80211_hdr,
 			     p80211_metawep_t *p80211_wep);
 static int prism2sta_mlmerequest(wlandevice_t *wlandev, p80211msg_t *msg);
 static int prism2sta_getcardinfo(wlandevice_t *wlandev);
@@ -268,7 +268,7 @@ static void prism2sta_reset(wlandevice_t *wlandev)
 *	process thread
 ----------------------------------------------------------------*/
 static int prism2sta_txframe(wlandevice_t *wlandev, struct sk_buff *skb,
-			     p80211_hdr_t *p80211_hdr,
+			     union p80211_hdr *p80211_hdr,
 			     p80211_metawep_t *p80211_wep)
 {
 	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
-- 
1.7.0.4


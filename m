Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0GaQF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 12:05:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57470 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab0GaQFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 12:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DE0ifl+xwYv9Caye1ePJuysy0NIheopD9A6oEKt5G5uA8WjZAqAZ4jBaAfFVe90Bk0
         j+E3k+e9pcHgNLCl+Pp8Rz942XqIOxjcZwUrzDAcaURK3DdpEcIeNrSPKOHKSrsRubJ/
         yG/OrBOAN5RDi6LQq48s9D2xE5oKfhTRIlw7g=
From: Edgardo Hames <ehames@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, ehames@gmail.com
Subject: [PATCH] Staging: wlan-ng: fix style issues in p80211conv.h
Date: Sat, 31 Jul 2010 13:06:52 -0300
Message-Id: <1280592412-22334-1-git-send-email-ehames@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes typedefs in p80211conv.h.

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x.h      |    2 +-
 drivers/staging/wlan-ng/hfa384x_usb.c  |   18 ++++----
 drivers/staging/wlan-ng/p80211conv.c   |   64 ++++++++++++++++----------------
 drivers/staging/wlan-ng/p80211conv.h   |   40 ++++++++++----------
 drivers/staging/wlan-ng/p80211netdev.c |    4 +-
 drivers/staging/wlan-ng/p80211netdev.h |    2 +-
 drivers/staging/wlan-ng/prism2sta.c    |    4 +-
 7 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index e3269f4..fa94a7c 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -1409,7 +1409,7 @@ int hfa384x_drvr_start(hfa384x_t *hw);
 int hfa384x_drvr_stop(hfa384x_t *hw);
 int
 hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
-		     union p80211_hdr *p80211_hdr, p80211_metawep_t *p80211_wep);
+		     union p80211_hdr *p80211_hdr, struct p80211_metawep *p80211_wep);
 void hfa384x_tx_timeout(wlandevice_t *wlandev);
 
 int hfa384x_cmd_initialize(hfa384x_t *hw);
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 925a7c5..ea81cb5 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -2707,7 +2707,7 @@ int hfa384x_drvr_stop(hfa384x_t *hw)
 ----------------------------------------------------------------*/
 int hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
 			 union p80211_hdr *p80211_hdr,
-			 p80211_metawep_t *p80211_wep)
+			 struct p80211_metawep *p80211_wep)
 {
 	int usbpktlen = sizeof(hfa384x_tx_frame_t);
 	int result;
@@ -3473,7 +3473,7 @@ static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 	hfa384x_usbin_t *usbin = (hfa384x_usbin_t *) skb->data;
 	hfa384x_t *hw = wlandev->priv;
 	int hdrlen;
-	p80211_rxmeta_t *rxmeta;
+	struct p80211_rxmeta *rxmeta;
 	u16 data_len;
 	u16 fc;
 
@@ -3590,14 +3590,14 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 	datalen = le16_to_cpu(rxdesc->data_len);
 
 	/* Allocate an ind message+framesize skb */
-	skblen = sizeof(p80211_caphdr_t) + hdrlen + datalen + WLAN_CRC_LEN;
+	skblen = sizeof(struct p80211_caphdr) + hdrlen + datalen + WLAN_CRC_LEN;
 
 	/* sanity check the length */
 	if (skblen >
-	    (sizeof(p80211_caphdr_t) +
+	    (sizeof(struct p80211_caphdr) +
 	     WLAN_HDR_A4_LEN + WLAN_DATA_MAXLEN + WLAN_CRC_LEN)) {
 		pr_debug("overlen frm: len=%zd\n",
-			 skblen - sizeof(p80211_caphdr_t));
+			 skblen - sizeof(struct p80211_caphdr));
 	}
 
 	skb = dev_alloc_skb(skblen);
@@ -3611,13 +3611,13 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 	/* only prepend the prism header if in the right mode */
 	if ((wlandev->netdev->type == ARPHRD_IEEE80211_PRISM) &&
 	    (hw->sniffhdr != 0)) {
-		p80211_caphdr_t *caphdr;
+		struct p80211_caphdr *caphdr;
 		/* The NEW header format! */
-		datap = skb_put(skb, sizeof(p80211_caphdr_t));
-		caphdr = (p80211_caphdr_t *) datap;
+		datap = skb_put(skb, sizeof(struct p80211_caphdr));
+		caphdr = (struct p80211_caphdr *) datap;
 
 		caphdr->version = htonl(P80211CAPTURE_VERSION);
-		caphdr->length = htonl(sizeof(p80211_caphdr_t));
+		caphdr->length = htonl(sizeof(struct p80211_caphdr));
 		caphdr->mactime = __cpu_to_be64(rxdesc->time) * 1000;
 		caphdr->hosttime = __cpu_to_be64(jiffies);
 		caphdr->phytype = htonl(4);	/* dss_dot11_b */
diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index 409a7c8..83879f9 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -104,14 +104,14 @@ static u8 oui_8021h[] = { 0x00, 0x00, 0xf8 };
 ----------------------------------------------------------------*/
 int skb_ether_to_p80211(wlandevice_t *wlandev, u32 ethconv,
 			struct sk_buff *skb, union p80211_hdr *p80211_hdr,
-			p80211_metawep_t *p80211_wep)
+			struct p80211_metawep *p80211_wep)
 {
 
 	u16 fc;
 	u16 proto;
-	wlan_ethhdr_t e_hdr;
-	wlan_llc_t *e_llc;
-	wlan_snap_t *e_snap;
+	struct wlan_ethhdr e_hdr;
+	struct wlan_llc *e_llc;
+	struct wlan_snap *e_snap;
 	int foo;
 
 	memcpy(&e_hdr, skb->data, sizeof(e_hdr));
@@ -148,7 +148,7 @@ int skb_ether_to_p80211(wlandevice_t *wlandev, u32 ethconv,
 
 			/* tack on SNAP */
 			e_snap =
-			    (wlan_snap_t *) skb_push(skb, sizeof(wlan_snap_t));
+			    (struct wlan_snap *) skb_push(skb, sizeof(struct wlan_snap));
 			e_snap->type = htons(proto);
 			if (ethconv == WLAN_ETHCONV_8021h
 			    && p80211_stt_findproto(proto)) {
@@ -161,7 +161,7 @@ int skb_ether_to_p80211(wlandevice_t *wlandev, u32 ethconv,
 
 			/* tack on llc */
 			e_llc =
-			    (wlan_llc_t *) skb_push(skb, sizeof(wlan_llc_t));
+			    (struct wlan_llc *) skb_push(skb, sizeof(struct wlan_llc));
 			e_llc->dsap = 0xAA;	/* SNAP, see IEEE 802 */
 			e_llc->ssap = 0xAA;
 			e_llc->ctl = 0x03;
@@ -230,7 +230,7 @@ int skb_ether_to_p80211(wlandevice_t *wlandev, u32 ethconv,
 
 /* jkriegl: from orinoco, modified */
 static void orinoco_spy_gather(wlandevice_t *wlandev, char *mac,
-			       p80211_rxmeta_t *rxmeta)
+			       struct p80211_rxmeta *rxmeta)
 {
 	int i;
 
@@ -281,9 +281,9 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 	u8 daddr[WLAN_ETHADDR_LEN];
 	u8 saddr[WLAN_ETHADDR_LEN];
 	union p80211_hdr *w_hdr;
-	wlan_ethhdr_t *e_hdr;
-	wlan_llc_t *e_llc;
-	wlan_snap_t *e_snap;
+	struct wlan_ethhdr *e_hdr;
+	struct wlan_llc *e_llc;
+	struct wlan_snap *e_snap;
 
 	int foo;
 
@@ -345,14 +345,14 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 		wlandev->rx.decrypt++;
 	}
 
-	e_hdr = (wlan_ethhdr_t *) (skb->data + payload_offset);
+	e_hdr = (struct wlan_ethhdr *) (skb->data + payload_offset);
 
-	e_llc = (wlan_llc_t *) (skb->data + payload_offset);
+	e_llc = (struct wlan_llc *) (skb->data + payload_offset);
 	e_snap =
-	    (wlan_snap_t *) (skb->data + payload_offset + sizeof(wlan_llc_t));
+	    (struct wlan_snap *) (skb->data + payload_offset + sizeof(struct wlan_llc));
 
 	/* Test for the various encodings */
-	if ((payload_length >= sizeof(wlan_ethhdr_t)) &&
+	if ((payload_length >= sizeof(struct wlan_ethhdr)) &&
 	    (e_llc->dsap != 0xaa || e_llc->ssap != 0xaa) &&
 	    ((memcmp(daddr, e_hdr->daddr, WLAN_ETHADDR_LEN) == 0) ||
 	     (memcmp(saddr, e_hdr->saddr, WLAN_ETHADDR_LEN) == 0))) {
@@ -372,7 +372,7 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 		/* chop off the 802.11 CRC */
 		skb_trim(skb, skb->len - WLAN_CRC_LEN);
 
-	} else if ((payload_length >= sizeof(wlan_llc_t) + sizeof(wlan_snap_t))
+	} else if ((payload_length >= sizeof(struct wlan_llc) + sizeof(struct wlan_snap))
 		   && (e_llc->dsap == 0xaa) && (e_llc->ssap == 0xaa)
 		   && (e_llc->ctl == 0x03)
 		   &&
@@ -398,7 +398,7 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 		skb_pull(skb, payload_offset);
 
 		/* create 802.3 header at beginning of skb. */
-		e_hdr = (wlan_ethhdr_t *) skb_push(skb, WLAN_ETHHDR_LEN);
+		e_hdr = (struct wlan_ethhdr *) skb_push(skb, WLAN_ETHHDR_LEN);
 		memcpy(e_hdr->daddr, daddr, WLAN_ETHADDR_LEN);
 		memcpy(e_hdr->saddr, saddr, WLAN_ETHADDR_LEN);
 		e_hdr->type = htons(payload_length);
@@ -406,7 +406,7 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 		/* chop off the 802.11 CRC */
 		skb_trim(skb, skb->len - WLAN_CRC_LEN);
 
-	} else if ((payload_length >= sizeof(wlan_llc_t) + sizeof(wlan_snap_t))
+	} else if ((payload_length >= sizeof(struct wlan_llc) + sizeof(struct wlan_snap))
 		   && (e_llc->dsap == 0xaa) && (e_llc->ssap == 0xaa)
 		   && (e_llc->ctl == 0x03)) {
 		pr_debug("802.1h/RFC1042 len: %d\n", payload_length);
@@ -414,13 +414,13 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 		/* build a DIXII + RFC894 */
 
 		/* Test for an overlength frame */
-		if ((payload_length - sizeof(wlan_llc_t) - sizeof(wlan_snap_t))
+		if ((payload_length - sizeof(struct wlan_llc) - sizeof(struct wlan_snap))
 		    > netdev->mtu) {
 			/* A bogus length ethfrm has been sent. */
 			/* Is someone trying an oflow attack? */
 			printk(KERN_ERR "DIXII frame too large (%ld > %d)\n",
-			       (long int)(payload_length - sizeof(wlan_llc_t) -
-					  sizeof(wlan_snap_t)), netdev->mtu);
+			       (long int)(payload_length - sizeof(struct wlan_llc) -
+					  sizeof(struct wlan_snap)), netdev->mtu);
 			return 1;
 		}
 
@@ -428,13 +428,13 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 		skb_pull(skb, payload_offset);
 
 		/* chop llc header from skb. */
-		skb_pull(skb, sizeof(wlan_llc_t));
+		skb_pull(skb, sizeof(struct wlan_llc));
 
 		/* chop snap header from skb. */
-		skb_pull(skb, sizeof(wlan_snap_t));
+		skb_pull(skb, sizeof(struct wlan_snap));
 
 		/* create 802.3 header at beginning of skb. */
-		e_hdr = (wlan_ethhdr_t *) skb_push(skb, WLAN_ETHHDR_LEN);
+		e_hdr = (struct wlan_ethhdr *) skb_push(skb, WLAN_ETHHDR_LEN);
 		e_hdr->type = e_snap->type;
 		memcpy(e_hdr->daddr, daddr, WLAN_ETHADDR_LEN);
 		memcpy(e_hdr->saddr, saddr, WLAN_ETHADDR_LEN);
@@ -461,7 +461,7 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 		skb_pull(skb, payload_offset);
 
 		/* create 802.3 header at beginning of skb. */
-		e_hdr = (wlan_ethhdr_t *) skb_push(skb, WLAN_ETHHDR_LEN);
+		e_hdr = (struct wlan_ethhdr *) skb_push(skb, WLAN_ETHHDR_LEN);
 		memcpy(e_hdr->daddr, daddr, WLAN_ETHADDR_LEN);
 		memcpy(e_hdr->saddr, saddr, WLAN_ETHADDR_LEN);
 		e_hdr->type = htons(payload_length);
@@ -542,8 +542,8 @@ int p80211_stt_findproto(u16 proto)
 ----------------------------------------------------------------*/
 void p80211skb_rxmeta_detach(struct sk_buff *skb)
 {
-	p80211_rxmeta_t *rxmeta;
-	p80211_frmmeta_t *frmmeta;
+	struct p80211_rxmeta *rxmeta;
+	struct p80211_frmmeta *frmmeta;
 
 	/* Sanity checks */
 	if (skb == NULL) {	/* bad skb */
@@ -589,8 +589,8 @@ exit:
 int p80211skb_rxmeta_attach(struct wlandevice *wlandev, struct sk_buff *skb)
 {
 	int result = 0;
-	p80211_rxmeta_t *rxmeta;
-	p80211_frmmeta_t *frmmeta;
+	struct p80211_rxmeta *rxmeta;
+	struct p80211_frmmeta *frmmeta;
 
 	/* If these already have metadata, we error out! */
 	if (P80211SKB_RXMETA(skb) != NULL) {
@@ -601,7 +601,7 @@ int p80211skb_rxmeta_attach(struct wlandevice *wlandev, struct sk_buff *skb)
 	}
 
 	/* Allocate the rxmeta */
-	rxmeta = kzalloc(sizeof(p80211_rxmeta_t), GFP_ATOMIC);
+	rxmeta = kzalloc(sizeof(struct p80211_rxmeta), GFP_ATOMIC);
 
 	if (rxmeta == NULL) {
 		printk(KERN_ERR "%s: Failed to allocate rxmeta.\n",
@@ -615,8 +615,8 @@ int p80211skb_rxmeta_attach(struct wlandevice *wlandev, struct sk_buff *skb)
 	rxmeta->hosttime = jiffies;
 
 	/* Overlay a frmmeta_t onto skb->cb */
-	memset(skb->cb, 0, sizeof(p80211_frmmeta_t));
-	frmmeta = (p80211_frmmeta_t *) (skb->cb);
+	memset(skb->cb, 0, sizeof(struct p80211_frmmeta));
+	frmmeta = (struct p80211_frmmeta *) (skb->cb);
 	frmmeta->magic = P80211_FRMMETA_MAGIC;
 	frmmeta->rx = rxmeta;
 exit:
@@ -641,7 +641,7 @@ exit:
 ----------------------------------------------------------------*/
 void p80211skb_free(struct wlandevice *wlandev, struct sk_buff *skb)
 {
-	p80211_frmmeta_t *meta;
+	struct p80211_frmmeta *meta;
 
 	meta = P80211SKB_FRMMETA(skb);
 	if (meta && meta->rx)
diff --git a/drivers/staging/wlan-ng/p80211conv.h b/drivers/staging/wlan-ng/p80211conv.h
index 65ab211..eca0391 100644
--- a/drivers/staging/wlan-ng/p80211conv.h
+++ b/drivers/staging/wlan-ng/p80211conv.h
@@ -63,17 +63,17 @@
 
 #define P80211CAPTURE_VERSION	0x80211001
 
-#define	P80211_FRMMETA_MAGIC		0x802110
+#define	P80211_FRMMETA_MAGIC	0x802110
 
 #define P80211SKB_FRMMETA(s) \
-	(((((p80211_frmmeta_t *)((s)->cb))->magic) == P80211_FRMMETA_MAGIC) ? \
-		((p80211_frmmeta_t *)((s)->cb)) : \
+	(((((struct p80211_frmmeta *)((s)->cb))->magic) == P80211_FRMMETA_MAGIC) ? \
+		((struct p80211_frmmeta *)((s)->cb)) : \
 		(NULL))
 
 #define P80211SKB_RXMETA(s) \
-	(P80211SKB_FRMMETA((s)) ?  P80211SKB_FRMMETA((s))->rx : ((p80211_rxmeta_t *)(NULL)))
+	(P80211SKB_FRMMETA((s)) ?  P80211SKB_FRMMETA((s))->rx : ((struct p80211_rxmeta *)(NULL)))
 
-typedef struct p80211_rxmeta {
+struct p80211_rxmeta {
 	struct wlandevice *wlandev;
 
 	u64 mactime;		/* Hi-rez MAC-supplied time value */
@@ -87,12 +87,12 @@ typedef struct p80211_rxmeta {
 	unsigned int preamble;	/* P80211ENUM_preambletype_* */
 	unsigned int encoding;	/* P80211ENUM_encoding_* */
 
-} p80211_rxmeta_t;
+};
 
-typedef struct p80211_frmmeta {
+struct p80211_frmmeta {
 	unsigned int magic;
-	p80211_rxmeta_t *rx;
-} p80211_frmmeta_t;
+	struct p80211_rxmeta *rx;
+};
 
 void p80211skb_free(struct wlandevice *wlandev, struct sk_buff *skb);
 int p80211skb_rxmeta_attach(struct wlandevice *wlandev, struct sk_buff *skb);
@@ -101,7 +101,7 @@ void p80211skb_rxmeta_detach(struct sk_buff *skb);
 /*
  * Frame capture header.  (See doc/capturefrm.txt)
  */
-typedef struct p80211_caphdr {
+struct p80211_caphdr {
 	u32 version;
 	u32 length;
 	u64 mactime;
@@ -116,36 +116,36 @@ typedef struct p80211_caphdr {
 	s32 ssi_noise;
 	u32 preamble;
 	u32 encoding;
-} p80211_caphdr_t;
+};
 
 /* buffer free method pointer type */
 typedef void (*freebuf_method_t) (void *buf, int size);
 
-typedef struct p80211_metawep {
+struct p80211_metawep {
 	void *data;
 	u8 iv[4];
 	u8 icv[4];
-} p80211_metawep_t;
+};
 
 /* local ether header type */
-typedef struct wlan_ethhdr {
+struct wlan_ethhdr {
 	u8 daddr[WLAN_ETHADDR_LEN];
 	u8 saddr[WLAN_ETHADDR_LEN];
 	u16 type;
-} __attribute__ ((packed)) wlan_ethhdr_t;
+} __attribute__ ((packed));
 
 /* local llc header type */
-typedef struct wlan_llc {
+struct wlan_llc {
 	u8 dsap;
 	u8 ssap;
 	u8 ctl;
-} __attribute__ ((packed)) wlan_llc_t;
+} __attribute__ ((packed));
 
 /* local snap header type */
-typedef struct wlan_snap {
+struct wlan_snap {
 	u8 oui[WLAN_IEEE_OUI_LEN];
 	u16 type;
-} __attribute__ ((packed)) wlan_snap_t;
+} __attribute__ ((packed));
 
 /* Circular include trick */
 struct wlandevice;
@@ -154,7 +154,7 @@ int skb_p80211_to_ether(struct wlandevice *wlandev, u32 ethconv,
 			struct sk_buff *skb);
 int skb_ether_to_p80211(struct wlandevice *wlandev, u32 ethconv,
 			struct sk_buff *skb, union p80211_hdr *p80211_hdr,
-			p80211_metawep_t *p80211_wep);
+			struct p80211_metawep *p80211_wep);
 
 int p80211_stt_findproto(u16 proto);
 
diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index c299ace..5b68af0 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -351,7 +351,7 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 	int txresult = -1;
 	wlandevice_t *wlandev = netdev->ml_priv;
 	union p80211_hdr p80211_hdr;
-	p80211_metawep_t p80211_wep;
+	struct p80211_metawep p80211_wep;
 
 	if (skb == NULL)
 		return NETDEV_TX_OK;
@@ -362,7 +362,7 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 	}
 
 	memset(&p80211_hdr, 0, sizeof(union p80211_hdr));
-	memset(&p80211_wep, 0, sizeof(p80211_metawep_t));
+	memset(&p80211_wep, 0, sizeof(struct p80211_metawep));
 
 	if (netif_queue_stopped(netdev)) {
 		pr_debug("called when queue stopped.\n");
diff --git a/drivers/staging/wlan-ng/p80211netdev.h b/drivers/staging/wlan-ng/p80211netdev.h
index 3e19dad..3c72162 100644
--- a/drivers/staging/wlan-ng/p80211netdev.h
+++ b/drivers/staging/wlan-ng/p80211netdev.h
@@ -185,7 +185,7 @@ typedef struct wlandevice {
 	void (*reset) (struct wlandevice *wlandev);
 	int (*txframe) (struct wlandevice *wlandev, struct sk_buff *skb,
 			union p80211_hdr *p80211_hdr,
-			p80211_metawep_t *p80211_wep);
+			struct p80211_metawep *p80211_wep);
 	int (*mlmerequest) (struct wlandevice *wlandev, p80211msg_t *msg);
 	int (*set_multicast_list) (struct wlandevice *wlandev,
 				   netdevice_t *dev);
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 6f5fc01..5ac6aa6 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -131,7 +131,7 @@ static int prism2sta_close(wlandevice_t *wlandev);
 static void prism2sta_reset(wlandevice_t *wlandev);
 static int prism2sta_txframe(wlandevice_t *wlandev, struct sk_buff *skb,
 			     union p80211_hdr *p80211_hdr,
-			     p80211_metawep_t *p80211_wep);
+			     struct p80211_metawep *p80211_wep);
 static int prism2sta_mlmerequest(wlandevice_t *wlandev, p80211msg_t *msg);
 static int prism2sta_getcardinfo(wlandevice_t *wlandev);
 static int prism2sta_globalsetup(wlandevice_t *wlandev);
@@ -269,7 +269,7 @@ static void prism2sta_reset(wlandevice_t *wlandev)
 ----------------------------------------------------------------*/
 static int prism2sta_txframe(wlandevice_t *wlandev, struct sk_buff *skb,
 			     union p80211_hdr *p80211_hdr,
-			     p80211_metawep_t *p80211_wep)
+			     struct p80211_metawep *p80211_wep)
 {
 	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
 	int result;
-- 
1.7.0.4


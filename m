Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0KFNrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 09:47:41 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42231 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab0KFNrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 09:47:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uBl6FOtUvHUAN+zMz9o0/ypsL8emyZs9GI45TbH7J1IIWfSt5lIhLEOD+a9u/BhPbK
         Tgnzp+//YdFlzqJCUi/skYKe6+zqRzVBwqRGfKImQgnX8Z5Q8mvcFvVNKk1sjSAEnf3D
         Ccdc89He4DefJqy0WvCoDVXOhhpsE1vEqRkOg=
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@suse.de, johanmeiring@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: wlan-ng: fixed coding style issues in p80211conv.c
Date: Sat,  6 Nov 2010 15:46:54 +0200
Message-Id: <1289051214-7960-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the p80211conv.c file that fixes a couple of coding style issues found by the checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlan-ng/p80211conv.c |   45 +++++++++++++++++++++-------------
 1 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index 83879f9..146f365 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -148,7 +148,8 @@ int skb_ether_to_p80211(wlandevice_t *wlandev, u32 ethconv,
 
 			/* tack on SNAP */
 			e_snap =
-			    (struct wlan_snap *) skb_push(skb, sizeof(struct wlan_snap));
+			    (struct wlan_snap *) skb_push(skb,
+				sizeof(struct wlan_snap));
 			e_snap->type = htons(proto);
 			if (ethconv == WLAN_ETHCONV_8021h
 			    && p80211_stt_findproto(proto)) {
@@ -161,7 +162,8 @@ int skb_ether_to_p80211(wlandevice_t *wlandev, u32 ethconv,
 
 			/* tack on llc */
 			e_llc =
-			    (struct wlan_llc *) skb_push(skb, sizeof(struct wlan_llc));
+			    (struct wlan_llc *) skb_push(skb,
+				sizeof(struct wlan_llc));
 			e_llc->dsap = 0xAA;	/* SNAP, see IEEE 802 */
 			e_llc->ssap = 0xAA;
 			e_llc->ctl = 0x03;
@@ -297,10 +299,12 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 	if ((WLAN_GET_FC_TODS(fc) == 0) && (WLAN_GET_FC_FROMDS(fc) == 0)) {
 		memcpy(daddr, w_hdr->a3.a1, WLAN_ETHADDR_LEN);
 		memcpy(saddr, w_hdr->a3.a2, WLAN_ETHADDR_LEN);
-	} else if ((WLAN_GET_FC_TODS(fc) == 0) && (WLAN_GET_FC_FROMDS(fc) == 1)) {
+	} else if ((WLAN_GET_FC_TODS(fc) == 0)
+			&& (WLAN_GET_FC_FROMDS(fc) == 1)) {
 		memcpy(daddr, w_hdr->a3.a1, WLAN_ETHADDR_LEN);
 		memcpy(saddr, w_hdr->a3.a3, WLAN_ETHADDR_LEN);
-	} else if ((WLAN_GET_FC_TODS(fc) == 1) && (WLAN_GET_FC_FROMDS(fc) == 0)) {
+	} else if ((WLAN_GET_FC_TODS(fc) == 1)
+			&& (WLAN_GET_FC_FROMDS(fc) == 0)) {
 		memcpy(daddr, w_hdr->a3.a3, WLAN_ETHADDR_LEN);
 		memcpy(saddr, w_hdr->a3.a2, WLAN_ETHADDR_LEN);
 	} else {
@@ -349,7 +353,8 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 
 	e_llc = (struct wlan_llc *) (skb->data + payload_offset);
 	e_snap =
-	    (struct wlan_snap *) (skb->data + payload_offset + sizeof(struct wlan_llc));
+	    (struct wlan_snap *) (skb->data + payload_offset +
+		sizeof(struct wlan_llc));
 
 	/* Test for the various encodings */
 	if ((payload_length >= sizeof(struct wlan_ethhdr)) &&
@@ -372,9 +377,11 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 		/* chop off the 802.11 CRC */
 		skb_trim(skb, skb->len - WLAN_CRC_LEN);
 
-	} else if ((payload_length >= sizeof(struct wlan_llc) + sizeof(struct wlan_snap))
-		   && (e_llc->dsap == 0xaa) && (e_llc->ssap == 0xaa)
-		   && (e_llc->ctl == 0x03)
+	} else if ((payload_length >= sizeof(struct wlan_llc) +
+		sizeof(struct wlan_snap))
+		&&(e_llc->dsap == 0xaa)
+		&& (e_llc->ssap == 0xaa)
+		&& (e_llc->ctl == 0x03)
 		   &&
 		   (((memcmp(e_snap->oui, oui_rfc1042, WLAN_IEEE_OUI_LEN) == 0)
 		     && (ethconv == WLAN_ETHCONV_8021h)
@@ -406,21 +413,25 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 		/* chop off the 802.11 CRC */
 		skb_trim(skb, skb->len - WLAN_CRC_LEN);
 
-	} else if ((payload_length >= sizeof(struct wlan_llc) + sizeof(struct wlan_snap))
-		   && (e_llc->dsap == 0xaa) && (e_llc->ssap == 0xaa)
-		   && (e_llc->ctl == 0x03)) {
+	} else if ((payload_length >= sizeof(struct wlan_llc) +
+		sizeof(struct wlan_snap))
+		&&(e_llc->dsap == 0xaa)
+		&& (e_llc->ssap == 0xaa)
+		&& (e_llc->ctl == 0x03)) {
 		pr_debug("802.1h/RFC1042 len: %d\n", payload_length);
-		/* it's an 802.1h frame || (an RFC1042 && protocol is not in STT) */
-		/* build a DIXII + RFC894 */
+		/* it's an 802.1h frame || (an RFC1042 && protocol not in STT)
+		   build a DIXII + RFC894 */
 
 		/* Test for an overlength frame */
-		if ((payload_length - sizeof(struct wlan_llc) - sizeof(struct wlan_snap))
-		    > netdev->mtu) {
+		if ((payload_length - sizeof(struct wlan_llc) -
+			sizeof(struct wlan_snap))
+			> netdev->mtu) {
 			/* A bogus length ethfrm has been sent. */
 			/* Is someone trying an oflow attack? */
 			printk(KERN_ERR "DIXII frame too large (%ld > %d)\n",
-			       (long int)(payload_length - sizeof(struct wlan_llc) -
-					  sizeof(struct wlan_snap)), netdev->mtu);
+			       (long int)(payload_length -
+					sizeof(struct wlan_llc) -
+					sizeof(struct wlan_snap)), netdev->mtu);
 			return 1;
 		}
 
-- 
1.7.1


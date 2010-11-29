Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab0K2MhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:37:16 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:35058 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0K2MhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:37:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:mime-version:content-type:content-transfer-encoding:message-id
         :date:to:cc:subject:in-reply-to:references:x-mailer;
        b=jLc1qbmVDpSWzsaIl+tHBgSVGzg1A+SgGatQlRn7TvVjgIoQtxhtoRgjHoNcsYiZKz
         eHjm1nnBVdqqcki82lplscMo2KJEileU7NvLS9ipSeh0bIjhV8EIyS0NuPNco3dlAmmE
         3mv6oHE3nVjRU2/Ag/8hdloFrSltjfaf/cV28=
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19699.40557.302196.832862@gargle.gargle.HOWL>
Date: Mon, 29 Nov 2010 18:07:01 +0530
To: Pavel Machek <pma@sysgo.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rudolf.marek@sysgo.com" <rudolf.marek@sysgo.com>,
        "cko@sysgo.com" <cko@sysgo.com>, "mfa@sysgo.com" <mfa@sysgo.com>,
        "anl@sysgo.com" <anl@sysgo.com>
Subject: Re: ath9k_htc vs. powerpc (was Re: working usb wifi card, that is still possible to buy)
In-Reply-To: <20101129100159.GC28833@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
	<20101124081616.GA30595@pma.sysgo.com>
	<20101124131320.GA2611@pma.sysgo.com>
	<4CED33E0.5040000@lwfinger.net>
	<20101126083125.GA28982@pma.sysgo.com>
	<20101126102026.GA11857@pma.sysgo.com>
	<20101126112737.GB11857@pma.sysgo.com>
	<19695.40541.335361.81396@gargle.gargle.HOWL>
	<20101126123706.GA19755@pma.sysgo.com>
	<20101129100159.GC28833@pma.sysgo.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> ...so I indentified two endianness problems in eeprom, but even with
> both fixed, it still will not associate. Is there some way to dump USB
> packets, then compare them between PC and PowerPC versions? Should I
> expect them to match?

Does this patch help ?

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index afe39a9..b04a25a 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -78,7 +78,7 @@ struct tx_frame_hdr {
 	u8 node_idx;
 	u8 vif_idx;
 	u8 tidno;
-	u32 flags; /* ATH9K_HTC_TX_* */
+	__be32 flags; /* ATH9K_HTC_TX_* */
 	u8 key_type;
 	u8 keyix;
 	u8 reserved[26];
@@ -91,30 +91,19 @@ struct tx_mgmt_hdr {
 	u8 flags;
 	u8 key_type;
 	u8 keyix;
-	u16 reserved;
+	__be16 reserved;
 } __packed;
 
 struct tx_beacon_header {
 	u8 len_changed;
 	u8 vif_index;
-	u16 rev;
-} __packed;
-
-struct ath9k_htc_target_hw {
-	u32 flags;
-	u32 flags_ext;
-	u32 ampdu_limit;
-	u8 ampdu_subframes;
-	u8 tx_chainmask;
-	u8 tx_chainmask_legacy;
-	u8 rtscts_ratecode;
-	u8 protmode;
+	__be16 rev;
 } __packed;
 
 struct ath9k_htc_cap_target {
-	u32 flags;
-	u32 flags_ext;
-	u32 ampdu_limit;
+	__be32 flags;
+	__be32 flags_ext;
+	__be32 ampdu_limit;
 	u8 ampdu_subframes;
 	u8 tx_chainmask;
 	u8 tx_chainmask_legacy;
@@ -128,9 +117,9 @@ struct ath9k_htc_target_vif {
 	__be32 opmode;
 	u8 myaddr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
-	u32 flags;
-	u32 flags_ext;
-	u16 ps_sta;
+	__be32 flags;
+	__be32 flags_ext;
+	__be16 ps_sta;
 	__be16 rtsthreshold;
 	u8 ath_cap;
 	u8 node;
@@ -144,25 +133,25 @@ struct ath9k_htc_target_vif {
 
 /* FIXME: UAPSD variables */
 struct ath9k_htc_target_sta {
-	u16 associd;
-	u16 txpower;
-	u32 ucastkey;
+	__be16 associd;
+	__be16 txpower;
+	__be32 ucastkey;
 	u8 macaddr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
 	u8 sta_index;
 	u8 vif_index;
 	u8 vif_sta;
 	__be16 flags; /* ATH_HTC_STA_* */
-	u16 htcap;
+	__be16 htcap;
 	u8 valid;
-	u16 capinfo;
-	struct ath9k_htc_target_hw *hw;
+	__be16 capinfo;
+	struct ath9k_htc_cap_target *hw;
 	struct ath9k_htc_target_vif *vif;
-	u16 txseqmgmt;
+	__be16 txseqmgmt;
 	u8 is_vif_sta;
-	u16 maxampdu;
-	u16 iv16;
-	u32 iv32;
+	__be16 maxampdu;
+	__be16 iv16;
+	__be32 iv32;
 } __packed;
 
 struct ath9k_htc_target_aggr {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index e9761c2..1b435d4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -204,7 +204,7 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 		ista = (struct ath9k_htc_sta *) sta->drv_priv;
 		memcpy(&tsta.macaddr, sta->addr, ETH_ALEN);
 		memcpy(&tsta.bssid, common->curbssid, ETH_ALEN);
-		tsta.associd = common->curaid;
+		tsta.associd = cpu_to_be16(common->curaid);
 		tsta.is_vif_sta = 0;
 		tsta.valid = true;
 		ista->index = priv->nstations;
@@ -215,7 +215,7 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 
 	tsta.sta_index = priv->nstations;
 	tsta.vif_index = avp->index;
-	tsta.maxampdu = 0xffff;
+	tsta.maxampdu = cpu_to_be16(0xffff);
 	if (sta && sta->ht_cap.ht_supported)
 		tsta.flags = cpu_to_be16(ATH_HTC_STA_HT);
 
@@ -279,9 +279,9 @@ static int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv)
 	memset(&tcap, 0, sizeof(struct ath9k_htc_cap_target));
 
 	/* FIXME: Values are hardcoded */
-	tcap.flags = 0x240c40;
-	tcap.flags_ext = 0x80601000;
-	tcap.ampdu_limit = 0xffff0000;
+	tcap.flags = cpu_to_be32(0x240c40);
+	tcap.flags_ext = cpu_to_be32(0x80601000);
+	tcap.ampdu_limit = cpu_to_be32(0xffff0000);
 	tcap.ampdu_subframes = 20;
 	tcap.tx_chainmask_legacy = priv->ah->caps.tx_chainmask;
 	tcap.protmode = 1;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 7795867..9902ec7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -136,12 +136,12 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 		/* Check for RTS protection */
 		if (priv->hw->wiphy->rts_threshold != (u32) -1)
 			if (skb->len > priv->hw->wiphy->rts_threshold)
-				tx_hdr.flags |= ATH9K_HTC_TX_RTSCTS;
+				tx_hdr.flags |= cpu_to_be32(ATH9K_HTC_TX_RTSCTS);
 
 		/* CTS-to-self */
-		if (!(tx_hdr.flags & ATH9K_HTC_TX_RTSCTS) &&
+		if (!(tx_hdr.flags & cpu_to_be32(ATH9K_HTC_TX_RTSCTS)) &&
 		    (priv->op_flags & OP_PROTECT_ENABLE))
-			tx_hdr.flags |= ATH9K_HTC_TX_CTSONLY;
+			tx_hdr.flags |= cpu_to_be32(ATH9K_HTC_TX_CTSONLY);
 
 		tx_hdr.key_type = ath9k_cmn_get_hw_crypto_keytype(skb);
 		if (tx_hdr.key_type == ATH9K_KEY_TYPE_CLEAR)

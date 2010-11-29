Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0K2Liq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:38:46 -0500
Received: from mail.sysgo.com ([195.145.229.155]:45765 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab0K2Lin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:38:43 -0500
Date: Mon, 29 Nov 2010 12:34:53 +0100
From: Pavel Machek <pma@sysgo.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rudolf.marek@sysgo.com" <rudolf.marek@sysgo.com>,
        "cko@sysgo.com" <cko@sysgo.com>, "mfa@sysgo.com" <mfa@sysgo.com>,
        "anl@sysgo.com" <anl@sysgo.com>
Subject: [PATCH] ath9k_htc more cleanups
Message-ID: <20101129113453.GA29737@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
 <20101124081616.GA30595@pma.sysgo.com>
 <20101124131320.GA2611@pma.sysgo.com>
 <4CED33E0.5040000@lwfinger.net>
 <20101126083125.GA28982@pma.sysgo.com>
 <20101126102026.GA11857@pma.sysgo.com>
 <20101126112737.GB11857@pma.sysgo.com>
 <19695.40541.335361.81396@gargle.gargle.HOWL>
 <20101126123706.GA19755@pma.sysgo.com>
 <20101129095915.GB28833@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129095915.GB28833@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes whitespace and fixes strings.

Signed-off-by: Pavel Machek <pma@sysgo.com>

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index c41ab8c..ac4aed7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -16,7 +16,7 @@
 
 #include "htc.h"
 
-static int htc_issue_send(struct htc_target *target, struct sk_buff* skb,
+static int htc_issue_send(struct htc_target *target, struct sk_buff *skb,
 			  u16 len, u8 flags, u8 epid,
 			  struct ath9k_htc_tx_ctl *tx_ctl)
 {
@@ -239,7 +239,7 @@ int htc_connect_service(struct htc_target *target,
 	/* Find an available endpoint */
 	endpoint = get_next_avail_ep(target->endpoint);
 	if (!endpoint) {
-		dev_err(target->dev, "Endpoint is not available for"
+		dev_err(target->dev, "Endpoint is not available for "
 			"service %d\n", service_connreq->service_id);
 		return -EINVAL;
 	}
@@ -253,7 +253,7 @@ int htc_connect_service(struct htc_target *target,
 	skb = alloc_skb(sizeof(struct htc_conn_svc_msg) +
 			    sizeof(struct htc_frame_hdr), GFP_ATOMIC);
 	if (!skb) {
-		dev_err(target->dev, "Failed to allocate buf to send"
+		dev_err(target->dev, "Failed to allocate buf to send "
 			"service connect req\n");
 		return -ENOMEM;
 	}
@@ -274,6 +274,7 @@ int htc_connect_service(struct htc_target *target,
 
 	time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
 	if (!time_left) {
+		/* who frees skb */
 		dev_err(target->dev, "Service connection timeout for: %d\n",
 			service_connreq->service_id);
 		return -ETIMEDOUT;
@@ -434,7 +435,7 @@ struct htc_target *ath9k_htc_hw_alloc(void *hif_handle,
 
 	target = kzalloc(sizeof(struct htc_target), GFP_KERNEL);
 	if (!target) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		printk(KERN_ERR "Unable to allocate memory for "
 			"target device\n");
 		return NULL;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index 6fc1b21..02f4074 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -165,7 +165,7 @@ struct htc_service_connreq {
 
 /* Current service IDs */
 
-enum htc_service_group_ids{
+enum htc_service_group_ids {
 	RSVD_SERVICE_GROUP = 0,
 	WMI_SERVICE_GROUP = 1,
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 495432e..b309b68 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -287,7 +287,7 @@ static void ath_tx_return_buffer(struct ath_softc *sc, struct ath_buf *bf)
 	spin_unlock_bh(&sc->tx.txbuflock);
 }
 
-static struct ath_buf* ath_clone_txbuf(struct ath_softc *sc, struct ath_buf *bf)
+static struct ath_buf *ath_clone_txbuf(struct ath_softc *sc, struct ath_buf *bf)
 {
 	struct ath_buf *tbf;
 
@@ -666,7 +666,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 		ndelim += ATH_AGGR_ENCRYPTDELIM;
 
 	/*
-	 * Convert desired mpdu density from microeconds to bytes based
+	 * Convert desired mpdu density from microseconds to bytes based
 	 * on highest rate in rate series (i.e. first rate) to determine
 	 * required minimum length for subframe. Take into account
 	 * whether high rate is 20 or 40Mhz and half or full GI.


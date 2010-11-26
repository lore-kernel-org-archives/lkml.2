Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0KZLhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:37:05 -0500
Received: from mail.sysgo.com ([195.145.229.155]:36825 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab0KZLhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:37:03 -0500
Date: Fri, 26 Nov 2010 12:37:00 +0100
From: Pavel Machek <pma@sysgo.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, ath9k-devel@venema.h4ckr.net,
        Sujith.Manoharan@atheros.com
Cc: kernel list <linux-kernel@vger.kernel.org>, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org, rudolf.marek@sysgo.com, cko@sysgo.com,
        mfa@sysgo.com, anl@sysgo.com
Subject: [PATCH?] do structures need to be packed? [was Re: ath9k_htc vs.
 powerpc (was Re: working usb wifi card, that is still possible to buy)]
Message-ID: <20101126113700.GB28137@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
 <20101124081616.GA30595@pma.sysgo.com>
 <20101124131320.GA2611@pma.sysgo.com>
 <4CED33E0.5040000@lwfinger.net>
 <20101126083125.GA28982@pma.sysgo.com>
 <20101126102026.GA11857@pma.sysgo.com>
 <20101126112737.GB11857@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126112737.GB11857@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm not sure if all the structures shared with hardware are properly
marked as packed. In particular, htc_rx_status contains big endian
data, so it might need packing...? Not sure about others.

...you probably do not want to apply all of this...

Unfortunately, it does not solve the problem on powerpc...
								Pavel
Signed-off-by: Pavel Machek <pma@sysgo.com>

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index 07b6509..79ef4e7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -89,7 +89,7 @@ struct htc_packet {
 
 	void *context;
 	u32 reserved;
-};
+} __packed;
 
 struct htc_ep_callbacks {
 	void *priv;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 7c1a34d..2afbfc0 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -127,7 +127,7 @@ struct ath_tx_status {
 	u32 evm0;
 	u32 evm1;
 	u32 evm2;
-};
+} __packed;
 
 struct ath_rx_status {
 	u32 rs_tstamp;
@@ -154,7 +154,7 @@ struct ath_rx_status {
 	u32 evm2;
 	u32 evm3;
 	u32 evm4;
-};
+} __packed;
 
 struct ath_htc_rx_status {
 	__be64 rs_tstamp;
@@ -180,7 +180,7 @@ struct ath_htc_rx_status {
 	__be32 evm0;
 	__be32 evm1;
 	__be32 evm2;
-};
+} __packed;
 
 #define ATH9K_RXERR_CRC           0x01
 #define ATH9K_RXERR_PHY           0x02
@@ -297,7 +297,7 @@ struct ar5416_desc {
 			u32 status7;
 			u32 status8;
 			u32 status9;
-		} tx;
+		} __packed tx;
 		struct {
 			u32 status0;
 			u32 status1;
@@ -308,7 +308,7 @@ struct ar5416_desc {
 			u32 status6;
 			u32 status7;
 			u32 status8;
-		} rx;
+		} __packed rx;
 	} u;
 } __packed;
 
@@ -658,7 +658,7 @@ struct ath9k_11n_rate_series {
 	u32 PktDuration;
 	u32 ChSel;
 	u32 RateFlags;
-};
+} __packed;
 
 enum ath9k_key_type {
 	ATH9K_KEY_TYPE_CLEAR,

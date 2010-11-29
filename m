Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0K2J7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:59:08 -0500
Received: from mail.sysgo.com ([195.145.229.155]:43281 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab0K2J7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:59:07 -0500
Date: Mon, 29 Nov 2010 10:59:15 +0100
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
Subject: [PATCH] ath9k_htc cleanups
Message-ID: <20101129095915.GB28833@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
 <20101124081616.GA30595@pma.sysgo.com>
 <20101124131320.GA2611@pma.sysgo.com>
 <4CED33E0.5040000@lwfinger.net>
 <20101126083125.GA28982@pma.sysgo.com>
 <20101126102026.GA11857@pma.sysgo.com>
 <20101126112737.GB11857@pma.sysgo.com>
 <19695.40541.335361.81396@gargle.gargle.HOWL>
 <20101126123706.GA19755@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126123706.GA19755@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes whitespace and reduces ammount of ifdefed lines.

Signed-off-by: Pavel Machek <pma@sysgo.com>

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 3c99830..022589d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -23,11 +23,7 @@
 
 #define AH_USE_EEPROM   0x1
 
-#ifdef __BIG_ENDIAN
-#define AR5416_EEPROM_MAGIC 0x5aa5
-#else
-#define AR5416_EEPROM_MAGIC 0xa55a
-#endif
+#define AR5416_EEPROM_MAGIC cpu_to_be16(0x5aa5)
 
 #define CTRY_DEBUG   0x1ff
 #define	CTRY_DEFAULT 0
@@ -536,17 +537,14 @@ struct cal_target_power_ht {
 } __packed;
 
 
-#ifdef __BIG_ENDIAN_BITFIELD
 struct cal_ctl_edges {
 	u8 bChannel;
+#ifdef __BIG_ENDIAN_BITFIELD
 	u8 flag:2, tPower:6;
-} __packed;
 #else
-struct cal_ctl_edges {
-	u8 bChannel;
 	u8 tPower:6, flag:2;
-} __packed;
 #endif
+} __packed;
 
 struct cal_data_op_loop_ar9287 {
 	u8 pwrPdg[2][5];
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index c41ab8c..4d34446 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -16,7 +16,7 @@
 
 #include "htc.h"
 
-static int htc_issue_send(struct htc_target *target, struct sk_buff* skb,
+static int htc_issue_send(struct htc_target *target, struct sk_buff *skb,
 			  u16 len, u8 flags, u8 epid,
 			  struct ath9k_htc_tx_ctl *tx_ctl)
 {

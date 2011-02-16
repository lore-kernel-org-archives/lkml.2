Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1BPBQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:16:11 -0500
Received: from kroah.org ([198.145.64.141]:45495 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932783Ab1BPAsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:04 2011
Message-Id: <20110216002104.318842604@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 052/176] ath9k_hw: Fix XPABIAS level configuration for AR9003
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

commit 52a0e2477dac2106bc1688cbe9615cdafc9deb7d upstream.

Improper configuration of 0x16288 and 0x16290 would affect transmission.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -22,12 +22,14 @@
 #define COMP_CKSUM_LEN 2
 
 #define AR_CH0_TOP (0x00016288)
-#define AR_CH0_TOP_XPABIASLVL (0x3)
+#define AR_CH0_TOP_XPABIASLVL (0x300)
 #define AR_CH0_TOP_XPABIASLVL_S (8)
 
 #define AR_CH0_THERM (0x00016290)
-#define AR_CH0_THERM_SPARE (0x3f)
-#define AR_CH0_THERM_SPARE_S (0)
+#define AR_CH0_THERM_XPABIASLVL_MSB 0x3
+#define AR_CH0_THERM_XPABIASLVL_MSB_S 0
+#define AR_CH0_THERM_XPASHORT2GND 0x4
+#define AR_CH0_THERM_XPASHORT2GND_S 2
 
 #define AR_SWITCH_TABLE_COM_ALL (0xffff)
 #define AR_SWITCH_TABLE_COM_ALL_S (0)
@@ -995,9 +997,9 @@ static s32 ar9003_hw_xpa_bias_level_get(
 static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
 {
 	int bias = ar9003_hw_xpa_bias_level_get(ah, is2ghz);
-	REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, (bias & 0x3));
-	REG_RMW_FIELD(ah, AR_CH0_THERM, AR_CH0_THERM_SPARE,
-		      ((bias >> 2) & 0x3));
+	REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
+	REG_RMW_FIELD(ah, AR_CH0_THERM, AR_CH0_THERM_XPABIASLVL_MSB, bias >> 2);
+	REG_RMW_FIELD(ah, AR_CH0_THERM, AR_CH0_THERM_XPASHORT2GND, 1);
 }
 
 static u32 ar9003_hw_ant_ctrl_common_get(struct ath_hw *ah, bool is2ghz)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab1B0VQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 16:16:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64847 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab1B0VQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 16:16:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=pL1KNm22CnAYYVpoZJ/HwKe/FRaFfZ0MG/rN6C94IUEeYN6cro2NI6q+SzpI7aYoyq
         V/Nu6OJGgEZBfxLoDbhifJXDw3qK9tu+ySagWGCoGXG4+pog5OJZwjpz/4E63pK15u9+
         gmY47xi0RLFUWj2B467n8Z+HfdWuiGadF9RNg=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] rtlwifi: make gcc happy
Date: Sun, 27 Feb 2011 22:16:30 +0100
Message-Id: <1298841390-1194-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/wireless/rtlwifi/rtl8192ce/trx.c: In function ‘rtl92ce_rx_query_desc’:
drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:255:5: warning: ‘rf_rx_num’ may be used uninitialized in this function
drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:257:12: warning: ‘total_rssi’ may be used uninitialized in this function
drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:466:6: warning: ‘weighting’ may be used uninitialized in this function

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index bf5852f..593eb8e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -252,9 +252,9 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct phy_sts_cck_8192s_t *cck_buf;
 	s8 rx_pwr_all, rx_pwr[4];
-	u8 rf_rx_num, evm, pwdb_all;
+	u8 evm, pwdb_all, rf_rx_num = 0;
 	u8 i, max_spatial_stream;
-	u32 rssi, total_rssi;
+	u32 rssi, total_rssi = 0;
 	bool is_cck_rate;
 
 	is_cck_rate = RX_HAL_IS_CCK_RATE(pdesc);
@@ -463,7 +463,7 @@ static void _rtl92ce_update_rxsignalstatistics(struct ieee80211_hw *hw,
 					       struct rtl_stats *pstats)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	int weighting;
+	int weighting = 0;
 
 	if (rtlpriv->stats.recv_signal_power == 0)
 		rtlpriv->stats.recv_signal_power = pstats->recvsignalpower;
-- 
1.7.4.1


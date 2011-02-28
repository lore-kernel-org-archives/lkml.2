Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1B1JMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:12:18 -0500
Received: from mail1.elettra.trieste.it ([140.105.4.201]:63033 "EHLO
	elettra.trieste.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752655Ab1B1JMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:12:15 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Feb 2011 04:12:14 EST
From: Alessio Igor Bogani <abogani@kernel.org>
To: Dan Carpenter <error27@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] rtlwifi: fix places where uninitialized data is used
Date: Mon, 28 Feb 2011 09:11:55 +0100
Message-Id: <1298880715-4286-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20110228003734.GA9075@bicker>
References: <20110228003734.GA9075@bicker>
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

This work was supported by a hardware donation from the CE Linux Forum.

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
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1F1Xz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:55:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62434 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1F1Xzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:55:53 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=3rvgeqzMqd0A:10 a=gPdn3R3lTXwA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=rOUgymgbAAAA:8 a=yQdBAQUQAAAA:8 a=kAD0SmpHXdjxSDN87agA:9 a=gdGZDDZ_nJ7O1uFdsAMA:7 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=6Tb-2o9DQi0SOWaa:21 a=C6TCtYY5lW9WCKAO:21 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Tue, 28 Jun 2011 18:55:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, randy.dunlap@oracle.com,
        linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192de: Fix build errors when using allyes
 configuration
Message-ID: <4e0a6a06.Y78QUdJvxEiJ3SGd%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After adding rtl8192de to linux-next, making the rtlwifi drivers be built-in
results in the following warnings:

  LD      drivers/net/wireless/rtlwifi/built-in.o
drivers/net/wireless/rtlwifi/rtl8192de/built-in.o: In function `rtl92ce_sw_led_on':
(.text+0x11fb6): multiple definition of `rtl92ce_sw_led_on'
drivers/net/wireless/rtlwifi/rtl8192ce/built-in.o:(.text+0xa326): first defined here
drivers/net/wireless/rtlwifi/rtl8192de/built-in.o:(.bss+0x0): multiple definition of `dm_digtable'
drivers/net/wireless/rtlwifi/rtl8192c/built-in.o:(.bss+0x0): first defined here
ld: Warning: size of symbol `dm_digtable' changed from 40 in drivers/net/wireless/rtlwifi/rtl8192c/built-in.o to 48 in drivers/net/wireless/rtlwifi/rtl8192de/built-in.o
drivers/net/wireless/rtlwifi/rtl8192de/built-in.o: In function `rtl92ce_sw_led_off':
(.text+0x11cfe): multiple definition of `rtl92ce_sw_led_off'
drivers/net/wireless/rtlwifi/rtl8192ce/built-in.o:(.text+0xa06e): first defined here

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -37,7 +37,7 @@
 
 #define UNDEC_SM_PWDB	entry_min_undecoratedsmoothed_pwdb
 
-struct dig_t dm_digtable;
+struct dig_t de_digtable;
 
 static const u32 ofdmswing_table[OFDM_TABLE_SIZE_92D] = {
 	0x7f8001fe,		/* 0, +6.0dB */
@@ -159,27 +159,27 @@ static const u8 cckswing_table_ch14[CCK_
 
 static void rtl92d_dm_diginit(struct ieee80211_hw *hw)
 {
-	dm_digtable.dig_enable_flag = true;
-	dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
-	dm_digtable.cur_igvalue = 0x20;
-	dm_digtable.pre_igvalue = 0x0;
-	dm_digtable.cursta_connectctate = DIG_STA_DISCONNECT;
-	dm_digtable.presta_connectstate = DIG_STA_DISCONNECT;
-	dm_digtable.curmultista_connectstate = DIG_MULTISTA_DISCONNECT;
-	dm_digtable.rssi_lowthresh = DM_DIG_THRESH_LOW;
-	dm_digtable.rssi_highthresh = DM_DIG_THRESH_HIGH;
-	dm_digtable.fa_lowthresh = DM_FALSEALARM_THRESH_LOW;
-	dm_digtable.fa_highthresh = DM_FALSEALARM_THRESH_HIGH;
-	dm_digtable.rx_gain_range_max = DM_DIG_FA_UPPER;
-	dm_digtable.rx_gain_range_min = DM_DIG_FA_LOWER;
-	dm_digtable.backoff_val = DM_DIG_BACKOFF_DEFAULT;
-	dm_digtable.backoff_val_range_max = DM_DIG_BACKOFF_MAX;
-	dm_digtable.backoff_val_range_min = DM_DIG_BACKOFF_MIN;
-	dm_digtable.pre_cck_pd_state = CCK_PD_STAGE_LOWRSSI;
-	dm_digtable.cur_cck_pd_state = CCK_PD_STAGE_MAX;
-	dm_digtable.large_fa_hit = 0;
-	dm_digtable.recover_cnt = 0;
-	dm_digtable.forbidden_igi = DM_DIG_FA_LOWER;
+	de_digtable.dig_enable_flag = true;
+	de_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
+	de_digtable.cur_igvalue = 0x20;
+	de_digtable.pre_igvalue = 0x0;
+	de_digtable.cursta_connectctate = DIG_STA_DISCONNECT;
+	de_digtable.presta_connectstate = DIG_STA_DISCONNECT;
+	de_digtable.curmultista_connectstate = DIG_MULTISTA_DISCONNECT;
+	de_digtable.rssi_lowthresh = DM_DIG_THRESH_LOW;
+	de_digtable.rssi_highthresh = DM_DIG_THRESH_HIGH;
+	de_digtable.fa_lowthresh = DM_FALSEALARM_THRESH_LOW;
+	de_digtable.fa_highthresh = DM_FALSEALARM_THRESH_HIGH;
+	de_digtable.rx_gain_range_max = DM_DIG_FA_UPPER;
+	de_digtable.rx_gain_range_min = DM_DIG_FA_LOWER;
+	de_digtable.backoff_val = DM_DIG_BACKOFF_DEFAULT;
+	de_digtable.backoff_val_range_max = DM_DIG_BACKOFF_MAX;
+	de_digtable.backoff_val_range_min = DM_DIG_BACKOFF_MIN;
+	de_digtable.pre_cck_pd_state = CCK_PD_STAGE_LOWRSSI;
+	de_digtable.cur_cck_pd_state = CCK_PD_STAGE_MAX;
+	de_digtable.large_fa_hit = 0;
+	de_digtable.recover_cnt = 0;
+	de_digtable.forbidden_igi = DM_DIG_FA_LOWER;
 }
 
 static void rtl92d_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
@@ -273,35 +273,35 @@ static void rtl92d_dm_find_minimum_rssi(
 	/* Determine the minimum RSSI  */
 	if ((mac->link_state < MAC80211_LINKED) &&
 	    (rtlpriv->dm.UNDEC_SM_PWDB == 0)) {
-		dm_digtable.min_undecorated_pwdb_for_dm = 0;
+		de_digtable.min_undecorated_pwdb_for_dm = 0;
 		RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
 			 ("Not connected to any\n"));
 	}
 	if (mac->link_state >= MAC80211_LINKED) {
 		if (mac->opmode == NL80211_IFTYPE_AP ||
 		    mac->opmode == NL80211_IFTYPE_ADHOC) {
-			dm_digtable.min_undecorated_pwdb_for_dm =
+			de_digtable.min_undecorated_pwdb_for_dm =
 			    rtlpriv->dm.UNDEC_SM_PWDB;
 			RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
 				 ("AP Client PWDB = 0x%lx\n",
 				  rtlpriv->dm.UNDEC_SM_PWDB));
 		} else {
-			dm_digtable.min_undecorated_pwdb_for_dm =
+			de_digtable.min_undecorated_pwdb_for_dm =
 			    rtlpriv->dm.undecorated_smoothed_pwdb;
 			RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
 				 ("STA Default Port PWDB = 0x%x\n",
-				  dm_digtable.min_undecorated_pwdb_for_dm));
+				  de_digtable.min_undecorated_pwdb_for_dm));
 		}
 	} else {
-		dm_digtable.min_undecorated_pwdb_for_dm =
+		de_digtable.min_undecorated_pwdb_for_dm =
 		    rtlpriv->dm.UNDEC_SM_PWDB;
 		RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
 			 ("AP Ext Port or disconnet PWDB = 0x%x\n",
-			  dm_digtable.min_undecorated_pwdb_for_dm));
+			  de_digtable.min_undecorated_pwdb_for_dm));
 	}
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, ("MinUndecoratedPWDBForDM =%d\n",
-			dm_digtable.min_undecorated_pwdb_for_dm));
+			de_digtable.min_undecorated_pwdb_for_dm));
 }
 
 static void rtl92d_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
@@ -309,27 +309,27 @@ static void rtl92d_dm_cck_packet_detecti
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	unsigned long flag = 0;
 
-	if (dm_digtable.cursta_connectctate == DIG_STA_CONNECT) {
-		if (dm_digtable.pre_cck_pd_state == CCK_PD_STAGE_LOWRSSI) {
-			if (dm_digtable.min_undecorated_pwdb_for_dm <= 25)
-				dm_digtable.cur_cck_pd_state =
+	if (de_digtable.cursta_connectctate == DIG_STA_CONNECT) {
+		if (de_digtable.pre_cck_pd_state == CCK_PD_STAGE_LOWRSSI) {
+			if (de_digtable.min_undecorated_pwdb_for_dm <= 25)
+				de_digtable.cur_cck_pd_state =
 							 CCK_PD_STAGE_LOWRSSI;
 			else
-				dm_digtable.cur_cck_pd_state =
+				de_digtable.cur_cck_pd_state =
 							 CCK_PD_STAGE_HIGHRSSI;
 		} else {
-			if (dm_digtable.min_undecorated_pwdb_for_dm <= 20)
-				dm_digtable.cur_cck_pd_state =
+			if (de_digtable.min_undecorated_pwdb_for_dm <= 20)
+				de_digtable.cur_cck_pd_state =
 							 CCK_PD_STAGE_LOWRSSI;
 			else
-				dm_digtable.cur_cck_pd_state =
+				de_digtable.cur_cck_pd_state =
 							 CCK_PD_STAGE_HIGHRSSI;
 		}
 	} else {
-		dm_digtable.cur_cck_pd_state = CCK_PD_STAGE_LOWRSSI;
+		de_digtable.cur_cck_pd_state = CCK_PD_STAGE_LOWRSSI;
 	}
-	if (dm_digtable.pre_cck_pd_state != dm_digtable.cur_cck_pd_state) {
-		if (dm_digtable.cur_cck_pd_state == CCK_PD_STAGE_LOWRSSI) {
+	if (de_digtable.pre_cck_pd_state != de_digtable.cur_cck_pd_state) {
+		if (de_digtable.cur_cck_pd_state == CCK_PD_STAGE_LOWRSSI) {
 			rtl92d_acquire_cckandrw_pagea_ctl(hw, &flag);
 			rtl_set_bbreg(hw, RCCK0_CCA, BMASKBYTE2, 0x83);
 			rtl92d_release_cckandrw_pagea_ctl(hw, &flag);
@@ -338,13 +338,13 @@ static void rtl92d_dm_cck_packet_detecti
 			rtl_set_bbreg(hw, RCCK0_CCA, BMASKBYTE2, 0xcd);
 			rtl92d_release_cckandrw_pagea_ctl(hw, &flag);
 		}
-		dm_digtable.pre_cck_pd_state = dm_digtable.cur_cck_pd_state;
+		de_digtable.pre_cck_pd_state = de_digtable.cur_cck_pd_state;
 	}
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, ("CurSTAConnectState=%s\n",
-		 (dm_digtable.cursta_connectctate == DIG_STA_CONNECT ?
+		 (de_digtable.cursta_connectctate == DIG_STA_CONNECT ?
 		 "DIG_STA_CONNECT " : "DIG_STA_DISCONNECT")));
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, ("CCKPDStage=%s\n",
-		 (dm_digtable.cur_cck_pd_state == CCK_PD_STAGE_LOWRSSI ?
+		 (de_digtable.cur_cck_pd_state == CCK_PD_STAGE_LOWRSSI ?
 		 "Low RSSI " : "High RSSI ")));
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, ("is92d single phy =%x\n",
 		 IS_92D_SINGLEPHY(rtlpriv->rtlhal.version)));
@@ -357,19 +357,19 @@ void rtl92d_dm_write_dig(struct ieee8021
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, ("cur_igvalue = 0x%x, "
 		 "pre_igvalue = 0x%x, backoff_val = %d\n",
-		 dm_digtable.cur_igvalue, dm_digtable.pre_igvalue,
-		 dm_digtable.backoff_val));
-	if (dm_digtable.dig_enable_flag == false) {
+		 de_digtable.cur_igvalue, de_digtable.pre_igvalue,
+		 de_digtable.backoff_val));
+	if (de_digtable.dig_enable_flag == false) {
 		RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, ("DIG is disabled\n"));
-		dm_digtable.pre_igvalue = 0x17;
+		de_digtable.pre_igvalue = 0x17;
 		return;
 	}
-	if (dm_digtable.pre_igvalue != dm_digtable.cur_igvalue) {
+	if (de_digtable.pre_igvalue != de_digtable.cur_igvalue) {
 		rtl_set_bbreg(hw, ROFDM0_XAAGCCORE1, 0x7f,
-			      dm_digtable.cur_igvalue);
+			      de_digtable.cur_igvalue);
 		rtl_set_bbreg(hw, ROFDM0_XBAGCCORE1, 0x7f,
-			      dm_digtable.cur_igvalue);
-		dm_digtable.pre_igvalue = dm_digtable.cur_igvalue;
+			      de_digtable.cur_igvalue);
+		de_digtable.pre_igvalue = de_digtable.cur_igvalue;
 	}
 }
 
@@ -379,13 +379,13 @@ static void rtl92d_early_mode_enabled(st
 	    (rtlpriv->mac80211.vendor == PEER_CISCO)) {
 		RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 			 ("IOT_PEER = CISCO\n"));
-		if (dm_digtable.last_min_undecorated_pwdb_for_dm >= 50
-		    && dm_digtable.min_undecorated_pwdb_for_dm < 50) {
+		if (de_digtable.last_min_undecorated_pwdb_for_dm >= 50
+		    && de_digtable.min_undecorated_pwdb_for_dm < 50) {
 			rtl_write_byte(rtlpriv, REG_EARLY_MODE_CONTROL, 0x00);
 			RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 				 ("Early Mode Off\n"));
-		} else if (dm_digtable.last_min_undecorated_pwdb_for_dm <= 55 &&
-			   dm_digtable.min_undecorated_pwdb_for_dm > 55) {
+		} else if (de_digtable.last_min_undecorated_pwdb_for_dm <= 55 &&
+			   de_digtable.min_undecorated_pwdb_for_dm > 55) {
 			rtl_write_byte(rtlpriv, REG_EARLY_MODE_CONTROL, 0x0f);
 			RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 				 ("Early Mode On\n"));
@@ -399,14 +399,14 @@ static void rtl92d_early_mode_enabled(st
 static void rtl92d_dm_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 value_igi = dm_digtable.cur_igvalue;
+	u8 value_igi = de_digtable.cur_igvalue;
 	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, ("==>\n"));
 	if (rtlpriv->rtlhal.earlymode_enable) {
 		rtl92d_early_mode_enabled(rtlpriv);
-		dm_digtable.last_min_undecorated_pwdb_for_dm =
-				 dm_digtable.min_undecorated_pwdb_for_dm;
+		de_digtable.last_min_undecorated_pwdb_for_dm =
+				 de_digtable.min_undecorated_pwdb_for_dm;
 	}
 	if (rtlpriv->dm.dm_initialgain_enable == false)
 		return;
@@ -424,9 +424,9 @@ static void rtl92d_dm_dig(struct ieee802
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, ("progress\n"));
 	/* Decide the current status and if modify initial gain or not */
 	if (rtlpriv->mac80211.link_state >= MAC80211_LINKED)
-		dm_digtable.cursta_connectctate = DIG_STA_CONNECT;
+		de_digtable.cursta_connectctate = DIG_STA_CONNECT;
 	else
-		dm_digtable.cursta_connectctate = DIG_STA_DISCONNECT;
+		de_digtable.cursta_connectctate = DIG_STA_DISCONNECT;
 
 	/* adjust initial gain according to false alarm counter */
 	if (falsealm_cnt->cnt_all < DM_DIG_FA_TH0)
@@ -439,64 +439,64 @@ static void rtl92d_dm_dig(struct ieee802
 		value_igi += 2;
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 ("dm_DIG() Before: large_fa_hit=%d, forbidden_igi=%x\n",
-		 dm_digtable.large_fa_hit, dm_digtable.forbidden_igi));
+		 de_digtable.large_fa_hit, de_digtable.forbidden_igi));
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 ("dm_DIG() Before: Recover_cnt=%d, rx_gain_range_min=%x\n",
-		 dm_digtable.recover_cnt, dm_digtable.rx_gain_range_min));
+		 de_digtable.recover_cnt, de_digtable.rx_gain_range_min));
 
 	/* deal with abnorally large false alarm */
 	if (falsealm_cnt->cnt_all > 10000) {
 		RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 			 ("dm_DIG(): Abnornally false alarm case.\n"));
 
-		dm_digtable.large_fa_hit++;
-		if (dm_digtable.forbidden_igi < dm_digtable.cur_igvalue) {
-			dm_digtable.forbidden_igi = dm_digtable.cur_igvalue;
-			dm_digtable.large_fa_hit = 1;
+		de_digtable.large_fa_hit++;
+		if (de_digtable.forbidden_igi < de_digtable.cur_igvalue) {
+			de_digtable.forbidden_igi = de_digtable.cur_igvalue;
+			de_digtable.large_fa_hit = 1;
 		}
-		if (dm_digtable.large_fa_hit >= 3) {
-			if ((dm_digtable.forbidden_igi + 1) > DM_DIG_MAX)
-				dm_digtable.rx_gain_range_min = DM_DIG_MAX;
+		if (de_digtable.large_fa_hit >= 3) {
+			if ((de_digtable.forbidden_igi + 1) > DM_DIG_MAX)
+				de_digtable.rx_gain_range_min = DM_DIG_MAX;
 			else
-				dm_digtable.rx_gain_range_min =
-				    (dm_digtable.forbidden_igi + 1);
-			dm_digtable.recover_cnt = 3600;	/* 3600=2hr */
+				de_digtable.rx_gain_range_min =
+				    (de_digtable.forbidden_igi + 1);
+			de_digtable.recover_cnt = 3600;	/* 3600=2hr */
 		}
 	} else {
 		/* Recovery mechanism for IGI lower bound */
-		if (dm_digtable.recover_cnt != 0) {
-			dm_digtable.recover_cnt--;
+		if (de_digtable.recover_cnt != 0) {
+			de_digtable.recover_cnt--;
 		} else {
-			if (dm_digtable.large_fa_hit == 0) {
-				if ((dm_digtable.forbidden_igi - 1) <
+			if (de_digtable.large_fa_hit == 0) {
+				if ((de_digtable.forbidden_igi - 1) <
 				    DM_DIG_FA_LOWER) {
-					dm_digtable.forbidden_igi =
+					de_digtable.forbidden_igi =
 							 DM_DIG_FA_LOWER;
-					dm_digtable.rx_gain_range_min =
+					de_digtable.rx_gain_range_min =
 							 DM_DIG_FA_LOWER;
 
 				} else {
-					dm_digtable.forbidden_igi--;
-					dm_digtable.rx_gain_range_min =
-					    (dm_digtable.forbidden_igi + 1);
+					de_digtable.forbidden_igi--;
+					de_digtable.rx_gain_range_min =
+					    (de_digtable.forbidden_igi + 1);
 				}
-			} else if (dm_digtable.large_fa_hit == 3) {
-				dm_digtable.large_fa_hit = 0;
+			} else if (de_digtable.large_fa_hit == 3) {
+				de_digtable.large_fa_hit = 0;
 			}
 		}
 	}
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 ("dm_DIG() After: large_fa_hit=%d, forbidden_igi=%x\n",
-		  dm_digtable.large_fa_hit, dm_digtable.forbidden_igi));
+		  de_digtable.large_fa_hit, de_digtable.forbidden_igi));
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 ("dm_DIG() After: recover_cnt=%d, rx_gain_range_min=%x\n",
-		  dm_digtable.recover_cnt, dm_digtable.rx_gain_range_min));
+		  de_digtable.recover_cnt, de_digtable.rx_gain_range_min));
 
 	if (value_igi > DM_DIG_MAX)
 		value_igi = DM_DIG_MAX;
-	else if (value_igi < dm_digtable.rx_gain_range_min)
-		value_igi = dm_digtable.rx_gain_range_min;
-	dm_digtable.cur_igvalue = value_igi;
+	else if (value_igi < de_digtable.rx_gain_range_min)
+		value_igi = de_digtable.rx_gain_range_min;
+	de_digtable.cur_igvalue = value_igi;
 	rtl92d_dm_write_dig(hw);
 	if (rtlpriv->rtlhal.current_bandtype != BAND_ON_5G)
 		rtl92d_dm_cck_packet_detection_thresh(hw);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/dm.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/dm.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/dm.h
@@ -200,7 +200,7 @@ enum dm_dig_connect {
 	DIG_CONNECT_MAX
 };
 
-extern struct dig_t dm_digtable;
+extern struct dig_t de_digtable;
 
 void rtl92d_dm_init(struct ieee80211_hw *hw);
 void rtl92d_dm_watchdog(struct ieee80211_hw *hw);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -627,11 +627,11 @@ static void _rtl92de_gen_refresh_led_sta
 	if (rtlpci->up_first_time)
 		return;
 	if (ppsc->rfoff_reason == RF_CHANGE_BY_IPS)
-		rtl92ce_sw_led_on(hw, pLed0);
+		rtl92de_sw_led_on(hw, pLed0);
 	else if (ppsc->rfoff_reason == RF_CHANGE_BY_INIT)
-		rtl92ce_sw_led_on(hw, pLed0);
+		rtl92de_sw_led_on(hw, pLed0);
 	else
-		rtl92ce_sw_led_off(hw, pLed0);
+		rtl92de_sw_led_off(hw, pLed0);
 }
 
 static bool _rtl92de_init_mac(struct ieee80211_hw *hw)
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/led.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/led.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/led.c
@@ -40,7 +40,7 @@ static void _rtl92ce_init_led(struct iee
 	pled->ledon = false;
 }
 
-void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
+void rtl92de_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	u8 ledcfg;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -77,7 +77,7 @@ void rtl92ce_sw_led_on(struct ieee80211_
 	pled->ledon = true;
 }
 
-void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
+void rtl92de_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
@@ -128,10 +128,10 @@ static void _rtl92ce_sw_led_control(stru
 	case LED_CTL_POWER_ON:
 	case LED_CTL_LINK:
 	case LED_CTL_NO_LINK:
-		rtl92ce_sw_led_on(hw, pLed0);
+		rtl92de_sw_led_on(hw, pLed0);
 		break;
 	case LED_CTL_POWER_OFF:
-		rtl92ce_sw_led_off(hw, pLed0);
+		rtl92de_sw_led_off(hw, pLed0);
 		break;
 	default:
 		break;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/led.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/led.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/led.h
@@ -31,8 +31,8 @@
 #define __RTL92CE_LED_H__
 
 void rtl92de_init_sw_leds(struct ieee80211_hw *hw);
-void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled);
-void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled);
+void rtl92de_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled);
+void rtl92de_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled);
 void rtl92de_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction);
 
 #endif
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -3192,13 +3192,13 @@ static void rtl92d_phy_set_io(struct iee
 		 rtlphy->current_io_type, rtlphy->set_io_inprogress));
 	switch (rtlphy->current_io_type) {
 	case IO_CMD_RESUME_DM_BY_SCAN:
-		dm_digtable.cur_igvalue = rtlphy->initgain_backup.xaagccore1;
+		de_digtable.cur_igvalue = rtlphy->initgain_backup.xaagccore1;
 		rtl92d_dm_write_dig(hw);
 		rtl92d_phy_set_txpower_level(hw, rtlphy->current_channel);
 		break;
 	case IO_CMD_PAUSE_DM_BY_SCAN:
-		rtlphy->initgain_backup.xaagccore1 = dm_digtable.cur_igvalue;
-		dm_digtable.cur_igvalue = 0x17;
+		rtlphy->initgain_backup.xaagccore1 = de_digtable.cur_igvalue;
+		de_digtable.cur_igvalue = 0x17;
 		rtl92d_dm_write_dig(hw);
 		break;
 	default:

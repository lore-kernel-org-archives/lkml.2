Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806Ab2LEUxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:53:08 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37435 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754413Ab2LEUva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:51:30 -0500
From: Sebastian Hahn <snsehahn@cip.cs.fau.de>
To: gregkh@linuxfoundation.org
Cc: Jennifer.Naumann@informatik.stud.uni-erlangen.de, dan.carpenter@oracle.com,
        standby24x7@gmail.com, Julia.Lawall@lip6.fr, jkosina@suse.cz,
        joe@perches.com, yongjun_wei@trendmicro.com.cn,
        adam.buchbinder@gmail.com, amwang@redhat.com, justinmattock@gmail.com,
        wfp5p@virginia.edu, jim.cromie@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Sebastian Hahn <snsehahn@cip.cs.fau.de>
Subject: [PATCH 6/6] staging/rtl8192u: do not init statics to 0
Date: Wed,  5 Dec 2012 21:40:23 +0100
Message-Id: <1354740023-30849-7-git-send-email-snsehahn@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
References: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the checkpatch error "do not initialize statics to 0 or NULL"

Signed-off-by: Sebastian Hahn <snsehahn@cip.cs.fau.de>
---
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 +-
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   14 +++----
 drivers/staging/rtl8192u/r8192U_dm.c               |   40 ++++++++++----------
 4 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 7062f9d..454f889 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -498,7 +498,7 @@ void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, softmac_scan_wq);
-	static short watchdog = 0;
+	static short watchdog;
 	u8 channel_map[MAX_CHANNEL_NUMBER+1];
 	memcpy(channel_map, GET_DOT11D_INFO(ieee)->channel_map, MAX_CHANNEL_NUMBER+1);
 	if(!ieee->ieee_up)
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index 421da8a..45422db 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -302,7 +302,7 @@ void ieee80211_wx_sync_scan_wq(struct work_struct *work)
 	HT_EXTCHNL_OFFSET chan_offset=0;
 	HT_CHANNEL_WIDTH bandwidth=0;
 	int b40M = 0;
-	static int count = 0;
+	static int count;
 	chan = ieee->current_network.channel;
 	netif_carrier_off(ieee->dev);
 
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index f59bd92..01f82d3 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3613,7 +3613,7 @@ HalRxCheckStuck819xUsb(struct net_device *dev)
 	u16	RegRxCounter = read_nic_word(dev, 0x130);
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	bool bStuck = FALSE;
-	static u8	rx_chk_cnt = 0;
+	static u8	rx_chk_cnt;
 	RT_TRACE(COMP_RESET,"%s(): RegRxCounter is %d,RxCounter is %d\n",__FUNCTION__,RegRxCounter,priv->RxCounter);
 	// If rssi is small, we should check rx for long time because of bad rx.
 	// or maybe it will continuous silent reset every 2 seconds.
@@ -4071,7 +4071,7 @@ extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
        struct net_device *dev = priv->ieee80211->dev;
 	struct ieee80211_device* ieee = priv->ieee80211;
 	RESET_TYPE	ResetType = RESET_TYPE_NORESET;
-	static u8	check_reset_cnt=0;
+	static u8	check_reset_cnt;
 	bool bBusyTraffic = false;
 
 	if(!priv->up)
@@ -4554,12 +4554,12 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 	u8	rfpath;
 	u32	nspatial_stream, tmp_val;
 	//u8	i;
-	static u32 slide_rssi_index=0, slide_rssi_statistics=0;
-	static u32 slide_evm_index=0, slide_evm_statistics=0;
-	static u32 last_rssi=0, last_evm=0;
+	static u32 slide_rssi_index, slide_rssi_statistics;
+	static u32 slide_evm_index, slide_evm_statistics;
+	static u32 last_rssi, last_evm;
 
-	static u32 slide_beacon_adc_pwdb_index=0, slide_beacon_adc_pwdb_statistics=0;
-	static u32 last_beacon_adc_pwdb=0;
+	static u32 slide_beacon_adc_pwdb_index, slide_beacon_adc_pwdb_statistics;
+	static u32 last_beacon_adc_pwdb;
 
 	struct ieee80211_hdr_3addr *hdr;
 	u16 sc ;
diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
index 7e2918f..ea46717 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.c
+++ b/drivers/staging/rtl8192u/r8192U_dm.c
@@ -201,8 +201,8 @@ extern void deinit_hal_dm(struct net_device *dev)
 void dm_CheckRxAggregation(struct net_device *dev) {
 	struct r8192_priv *priv = ieee80211_priv((struct net_device *)dev);
 	PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;
-	static unsigned long	lastTxOkCnt = 0;
-	static unsigned long	lastRxOkCnt = 0;
+	static unsigned long	lastTxOkCnt;
+	static unsigned long	lastRxOkCnt;
 	unsigned long		curTxOkCnt = 0;
 	unsigned long		curRxOkCnt = 0;
 
@@ -359,7 +359,7 @@ static void dm_check_rate_adaptive(struct net_device * dev)
 	u32						currentRATR, targetRATR = 0;
 	u32						LowRSSIThreshForRA = 0, HighRSSIThreshForRA = 0;
 	bool						bshort_gi_enabled = false;
-	static u8					ping_rssi_state=0;
+	static u8					ping_rssi_state;
 
 
 	if(!priv->up)
@@ -1486,7 +1486,7 @@ void dm_initialize_txpower_tracking(struct net_device *dev)
 static void dm_CheckTXPowerTracking_TSSI(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	static u32 tx_power_track_counter = 0;
+	static u32 tx_power_track_counter;
 
 	if(!priv->btxpower_tracking)
 		return;
@@ -1505,7 +1505,7 @@ static void dm_CheckTXPowerTracking_TSSI(struct net_device *dev)
 static void dm_CheckTXPowerTracking_ThermalMeter(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	static u8	TM_Trigger=0;
+	static u8	TM_Trigger;
 	//DbgPrint("dm_CheckTXPowerTracking() \n");
 	if(!priv->btxpower_tracking)
 		return;
@@ -2091,7 +2091,7 @@ static void dm_ctrl_initgain_byrssi_by_driverrssi(
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u8 i;
-	static u8	fw_dig=0;
+	static u8	fw_dig;
 
 	if (dm_digtable.dig_enable_flag == false)
 		return;
@@ -2131,7 +2131,7 @@ static void dm_ctrl_initgain_byrssi_by_fwfalse_alarm(
 	struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	static u32 reset_cnt = 0;
+	static u32 reset_cnt;
 	u8 i;
 
 	if (dm_digtable.dig_enable_flag == false)
@@ -2319,7 +2319,7 @@ static void dm_ctrl_initgain_byrssi_highpwr(
 	struct net_device * dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	static u32 reset_cnt_highpwr = 0;
+	static u32 reset_cnt_highpwr;
 
 	// For smooth, we can not change high power DIG state in the range.
 	if ((priv->undecorated_smoothed_pwdb > dm_digtable.rssi_high_power_lowthresh) &&
@@ -2395,8 +2395,8 @@ static void dm_initial_gain(
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u8					initial_gain=0;
-	static u8				initialized=0, force_write=0;
-	static u32			reset_cnt=0;
+	static u8				initialized, force_write;
+	static u32			reset_cnt;
 
 	if(dm_digtable.dig_algorithm_switch)
 	{
@@ -2462,8 +2462,8 @@ static void dm_pd_th(
 	struct net_device * dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	static u8				initialized=0, force_write=0;
-	static u32			reset_cnt = 0;
+	static u8				initialized, force_write;
+	static u32			reset_cnt;
 
 	if(dm_digtable.dig_algorithm_switch)
 	{
@@ -2574,8 +2574,8 @@ static	void dm_cs_ratio(
 	struct net_device * dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	static u8				initialized=0,force_write=0;
-	static u32			reset_cnt = 0;
+	static u8				initialized,force_write;
+	static u32			reset_cnt;
 
 	if(dm_digtable.dig_algorithm_switch)
 	{
@@ -2651,8 +2651,8 @@ static void dm_check_edca_turbo(
 	//PSTA_QOS			pStaQos = pMgntInfo->pStaQos;
 
 	// Keep past Tx/Rx packet count for RT-to-RT EDCA turbo.
-	static unsigned long			lastTxOkCnt = 0;
-	static unsigned long			lastRxOkCnt = 0;
+	static unsigned long			lastTxOkCnt;
+	static unsigned long			lastRxOkCnt;
 	unsigned long				curTxOkCnt = 0;
 	unsigned long				curRxOkCnt = 0;
 
@@ -2785,8 +2785,8 @@ static void dm_ctstoself(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv((struct net_device *)dev);
 	PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;
-	static unsigned long				lastTxOkCnt = 0;
-	static unsigned long				lastRxOkCnt = 0;
+	static unsigned long				lastTxOkCnt;
+	static unsigned long				lastRxOkCnt;
 	unsigned long						curTxOkCnt = 0;
 	unsigned long						curRxOkCnt = 0;
 
@@ -3044,7 +3044,7 @@ static void dm_rxpath_sel_byrssi(struct net_device * dev)
 	u8				cck_rx_ver2_max_index=0, cck_rx_ver2_min_index=0, cck_rx_ver2_sec_index=0;
 	u8				cur_rf_rssi;
 	long				cur_cck_pwdb;
-	static u8			disabled_rf_cnt=0, cck_Rx_Path_initialized=0;
+	static u8			disabled_rf_cnt, cck_Rx_Path_initialized;
 	u8				update_cck_rx_path;
 
 	if(priv->rf_type != RF_2T4R)
@@ -3571,7 +3571,7 @@ void dm_check_fsync(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	//u32			framesyncC34;
 	static u8		reg_c38_State=RegC38_Default;
-	static u32	reset_cnt=0;
+	static u32	reset_cnt;
 
 	RT_TRACE(COMP_HALDM, "RSSI %d TimeInterval %d MultipleTimeInterval %d\n", priv->ieee80211->fsync_rssi_threshold, priv->ieee80211->fsync_time_interval, priv->ieee80211->fsync_multiple_timeinterval);
 	RT_TRACE(COMP_HALDM, "RateBitmap 0x%x FirstDiffRateThreshold %d SecondDiffRateThreshold %d\n", priv->ieee80211->fsync_rate_bitmap, priv->ieee80211->fsync_firstdiff_ratethreshold, priv->ieee80211->fsync_seconddiff_ratethreshold);
-- 
1.7.10.4


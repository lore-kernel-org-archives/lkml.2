Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab2D3Vjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:39:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51946 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab2D3Vjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:39:41 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jj@chaosbits.net, dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH NEXT]staging:rtl8192u Fix typos and comments
Date: Mon, 30 Apr 2012 14:39:21 -0700
Message-Id: <1335821961-11057-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes some comments after being revised by jesper juhl.

 drivers/staging/rtl8192u/r8192U.h          |    4 ++--
 drivers/staging/rtl8192u/r8192U_core.c     |   24 ++++++++++++------------
 drivers/staging/rtl8192u/r8192U_dm.c       |   16 ++++++++--------
 drivers/staging/rtl8192u/r819xU_cmdpkt.c   |    2 +-
 drivers/staging/rtl8192u/r819xU_firmware.c |    2 +-
 drivers/staging/rtl8192u/r819xU_phy.c      |    4 ++--
 6 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index ebcb5b0..b4e99f4 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -98,7 +98,7 @@ do { if(rt_global_debug_component & component) \
 #define COMP_INIT				BIT2		// during driver initialization / halt / reset.
 
 
-#define COMP_RECV				BIT3		// Revive part data path.
+#define COMP_RECV				BIT3		// Receive data path.
 #define COMP_SEND				BIT4		// Send part path.
 #define COMP_IO					BIT5		// I/O Related. Added by Annie, 2006-03-02.
 #define COMP_POWER				BIT6		// 802.11 Power Save mode or System/Device Power state related.
@@ -322,7 +322,7 @@ typedef struct _tx_fwinfo_819x_usb {
         u8		TxSubCarrier:2;         // This is used for legacy OFDM rate only.
         u8		STBC:2;
         u8		AllowAggregation:1;
-        u8		RtsHT:1;                //Interprete RtsRate field as high throughput data rate
+        u8		RtsHT:1;                //Interpret RtsRate field as high throughput data rate
         u8		RtsShort:1;             //Short PLCP for CCK, or short GI for 11n MCS
         u8		RtsBandwidth:1;         // This is used for HT MCS rate only.
         u8		RtsSubcarrier:2;        // This is used for legacy OFDM rate only.
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index be86045..5981d66 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -203,7 +203,7 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv* priv)
 		{
 			Dot11d_Init(ieee);
 			ieee->bGlobalDomain = false;
-			//actually 8225 & 8256 rf chip only support B,G,24N mode
+			//actually 8225 & 8256 rf chips only support B,G,24N mode
 			if ((priv->rf_chip == RF_8225) || (priv->rf_chip == RF_8256))
 			{
 				min_chan = 1;
@@ -1476,7 +1476,7 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 	if(tcb_desc->queue_index != TXCMD_QUEUE) {
 		if(tx_urb->status == 0) {
 			dev->trans_start = jiffies;
-			// As act as station mode, destination shall be unicast address.
+			// Act as station mode, destination shall be unicast address.
 			//priv->ieee80211->stats.tx_bytes+=(skb->len - priv->ieee80211->tx_headroom);
 			//priv->ieee80211->stats.tx_packets++;
 			priv->stats.txoktotal++;
@@ -1527,8 +1527,8 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 				 *    function, it should contain enough tx irq;
 				 * 2. check packet type;
 				 * 3. initialize sendlist, check whether the to-be send packet no greater than 1
-				 * 4. aggregates the packets, and fill firmware info and tx desc to it, etc.
-				 * 5. check whether the packet could be sent, otherwise just insert to wait head
+				 * 4. aggregates the packets, and fill firmware info and tx desc into it, etc.
+				 * 5. check whether the packet could be sent, otherwise just insert into wait head
 				 * */
 				skb = skb_dequeue(&priv->ieee80211->skb_drv_aggQ[queue_index]);
 				if(!check_nic_enough_desc(dev, queue_index)) {
@@ -2783,7 +2783,7 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 		(TCR_MXDMA_2048<<TCR_MXDMA_OFFSET)|  // Max DMA Burst Size per Tx DMA Burst, 7: reserved.
 		(priv->ShortRetryLimit<<TCR_SRL_OFFSET)|	// Short retry limit
 		(priv->LongRetryLimit<<TCR_LRL_OFFSET) |	// Long retry limit
-		(false ? TCR_SAT: 0);	// FALSE: HW provides PLCP length and LENGEXT, TURE: SW provides them
+		(false ? TCR_SAT: 0);	// FALSE: HW provides PLCP length and LENGEXT, TRUE: SW provides them
 #ifdef TO_DO_LIST
 	if(Adapter->bInHctTest)
 		pHalData->ReceiveConfig	=	pHalData->CSMethod |
@@ -3437,7 +3437,7 @@ if(Adapter->ResetProgress == RESET_TYPE_NORESET)
 		{ // User disable RF via registry.
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RegRfOff ----------\n"));
 			MgntActSet_RF_State(Adapter, eRfOff, RF_CHANGE_BY_SW);
-			// Those action will be discard in MgntActSet_RF_State because of the same state
+			// Those actions will be discard in MgntActSet_RF_State because of the same state
 			for(eRFPath = 0; eRFPath <pHalData->NumTotalRFPath; eRFPath++)
 				PHY_SetRFReg(Adapter, (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
 		}
@@ -3458,7 +3458,7 @@ if(Adapter->ResetProgress == RESET_TYPE_NORESET)
 		if(pHalData->eRFPowerState == eRfOff)
 		{
 			MgntActSet_RF_State(Adapter, eRfOff, pMgntInfo->RfOffReason);
-			// Those action will be discard in MgntActSet_RF_State because of the same state
+			// Those actions will be discard in MgntActSet_RF_State because of the same state
 			for(eRFPath = 0; eRFPath <pHalData->NumTotalRFPath; eRFPath++)
 				PHY_SetRFReg(Adapter, (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
 		}
@@ -4516,7 +4516,7 @@ u8 HwRateToMRate90(bool bIsHT, u8 rate)
 
 /**
  * Function:     UpdateRxPktTimeStamp
- * Overview:     Record down the TSF time stamp when receiving a packet
+ * Overview:     Record the TSF time stamp when receiving a packet
  *
  * Input:
  *       PADAPTER        Adapter
@@ -4558,8 +4558,8 @@ long rtl819x_translate_todbm(u8 signal_strength_index	)// 0-100 index.
 
 /* 2008/01/22 MH We can not declare RSSI/EVM total value of sliding window to
     be a local static. Otherwise, it may increase when we return from S3/S4. The
-    value will be kept in memory or disk. We must declare the value in adapter
-    and it will be reinitialized when return from S3/S4. */
+    value will be kept in memory or disk. Declare the value in the adaptor
+    and it will be reinitialized when returned from S3/S4. */
 void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee80211_rx_stats * pprevious_stats, struct ieee80211_rx_stats * pcurrent_stats)
 {
 	bool bcheck = false;
@@ -5092,7 +5092,7 @@ static void rtl8192_query_rxphystatus(
 			rx_evmX = (char)(tmp_rxevm);
 
 			// Do not use shift operation like "rx_evmX >>= 1" because the compiler of free build environment
-			// fill most significant bit to "zero" when doing shifting operation which may change a negative
+			// will set the most significant bit to "zero" when doing shifting operation which may change a negative
 			// value to positive one, then the dbm value (which is supposed to be negative)  is not correct anymore.
 			rx_evmX /= 2;	//dbm
 
@@ -5211,7 +5211,7 @@ void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
 
 /**
 * Function:	UpdateReceivedRateHistogramStatistics
-* Overview:	Record down the received data rate
+* Overview:	Record the received data rate
 *
 * Input:
 * 	struct net_device *dev
diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
index 3f79e61..996e658 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.c
+++ b/drivers/staging/rtl8192u/r8192U_dm.c
@@ -1457,7 +1457,7 @@ static void dm_InitializeTXPowerTracking_ThermalMeter(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	// Tx Power tracking by Thermal Meter require Firmware R/W 3-wire. This mechanism
+	// Tx Power tracking by Thermal Meter requires Firmware R/W 3-wire. This mechanism
 	// can be enabled only when Firmware R/W 3-wire is enabled. Otherwise, frequent r/w
 	// 3-wire by driver causes RF to go into a wrong state.
 	if(priv->ieee80211->FwRWRF)
@@ -1520,7 +1520,7 @@ static void dm_CheckTXPowerTracking_ThermalMeter(struct net_device *dev)
 
 	if(!TM_Trigger)
 	{
-		//Attention!! You have to write all 12bits data to RF, or it may cause RF to crash
+		//Attention!! You have to write all 12bits of data to RF, or it may cause RF to crash
 		//actually write reg0x02 bit1=0, then bit1=1.
 		//DbgPrint("Trigger ThermalMeter, write RF reg0x2 = 0x4d to 0x4f\n");
 		rtl8192_phy_SetRFReg(dev, RF90_PATH_A, 0x02, bMask12Bits, 0x4d);
@@ -2161,7 +2161,7 @@ static void dm_ctrl_initgain_byrssi_by_fwfalse_alarm(
 	pHalData->UndecoratedSmoothedPWDB, DM_DigTable.RssiLowThresh,
 	DM_DigTable.RssiHighThresh, DM_DigTable.Dig_State);*/
 	/* 1. When RSSI decrease, We have to judge if it is smaller than a threshold
-		  and then execute below step. */
+		  and then execute the step below. */
 	if ((priv->undecorated_smoothed_pwdb <= dm_digtable.rssi_low_thresh))
 	{
 		/* 2008/02/05 MH When we execute silent reset, the DIG PHY parameters
@@ -2221,7 +2221,7 @@ static void dm_ctrl_initgain_byrssi_by_fwfalse_alarm(
 	}
 
 	/* 2. When RSSI increase, We have to judge if it is larger than a threshold
-		  and then execute below step.  */
+		  and then execute the step below.  */
 	if ((priv->undecorated_smoothed_pwdb >= dm_digtable.rssi_high_thresh) )
 	{
 		u8 reset_flag = 0;
@@ -2329,7 +2329,7 @@ static void dm_ctrl_initgain_byrssi_highpwr(
 	}
 
 	/* 3. When RSSI >75% or <70%, it is a high power issue. We have to judge if
-		  it is larger than a threshold and then execute below step.  */
+		  it is larger than a threshold and then execute the step below.  */
 	// 2008/02/05 MH SD3-Jerry Modify PD_TH for high power issue.
 	if (priv->undecorated_smoothed_pwdb >= dm_digtable.rssi_high_power_highthresh)
 	{
@@ -2842,7 +2842,7 @@ static void dm_check_rfctrl_gpio(struct net_device * dev)
 	//struct r8192_priv *priv = ieee80211_priv(dev);
 
 	// Work around for DTM test, we will not enable HW - radio on/off because r/w
-	// page 1 register before extra bus is enabled causing system fails when resuming
+	// page 1 register before extra bus is enabled causing system failures when resuming
 	// from S4. 20080218, Emily
 
 	// Stop to execute workitem to prevent S3/S4 bug.
@@ -3392,7 +3392,7 @@ extern void dm_fsync_timer_callback(unsigned long data)
 		}
 		else
 		{
-			// Stop continue count
+			// Stop the continued count
 			priv->ContiuneDiffCount = 0;
 		}
 
@@ -3523,7 +3523,7 @@ static void dm_StartSWFsync(struct net_device *dev)
 	RT_TRACE(COMP_HALDM,"%s\n", __FUNCTION__);
 	// Initial rate record to zero, start to record.
 	priv->rate_record = 0;
-	// Initial continue diff count to zero, start to record.
+	// Initialize continue diff count to zero, start to record.
 	priv->ContiuneDiffCount = 0;
 	priv->rateCountDiffRecord = 0;
 	priv->bswitch_fsync  = false;
diff --git a/drivers/staging/rtl8192u/r819xU_cmdpkt.c b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
index ec1eeb7..a8a6dc2 100644
--- a/drivers/staging/rtl8192u/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
@@ -726,7 +726,7 @@ cmpk_message_handle_rx(
 	/* 4. Check every received command packet content according to different
 	      element type. Because FW may aggregate RX command packet to minimize
 	      transmit time between DRV and FW.*/
-	// Add a counter to prevent the lock in the loop to be to long
+	// Add a counter to prevent the lock in the loop from being held too long
 	while (total_length > 0 || exe_cnt++ >100)
 	{
 		/* 2007/01/17 MH We support aggregation of different cmd in the same packet. */
diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
index fe5776d..b12d190 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -279,7 +279,7 @@ bool init_firmware(struct net_device *dev)
 	 */
 	for(init_step = starting_state; init_step <= FW_INIT_STEP2_DATA; init_step++) {
 		/*
-		 * Open Image file, and map file to continuous memory if open file success.
+		 * Open image file, and map file to continuous memory if open file success.
 		 * or read image file from array. Default load from IMG file
 		 */
 		if(rst_opt == OPT_SYSTEM_RESET) {
diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
index 636d6fd..dd1954d 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -176,7 +176,7 @@ u32 rtl8192_phy_RFSerialRead(struct net_device* dev, RF90_RADIO_PATH_E eRFPath,
 	rtl8192_setBBreg(dev, pPhyReg->rfHSSIPara2,  bLSSIReadEdge, 0x1);
 
 
-	// TODO: we should not delay such a long time. Ask help from SD3
+	// TODO: we should not delay such a long time. Ask for help from SD3
 	msleep(1);
 
 	ret = rtl8192_QueryBBReg(dev, pPhyReg->rfLSSIReadBack, bLSSIReadBackData);
@@ -1425,7 +1425,7 @@ void rtl8192_SwChnl_WorkItem(struct net_device *dev)
 }
 
 /******************************************************************************
- *function:  This function scheduled actual workitem to set channel
+ *function:  This function scheduled actual work item to set channel
  *   input:  net_device dev
  *   	     u8		channel //channel to set
  *  output:  none
-- 
1.7.5.4


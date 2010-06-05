Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab0FEOMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:12:40 -0400
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:5147 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933400Ab0FEOMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:12:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJPAA74CUw6B9wNPGdsb2JhbACHb5ZlDAEBAQE1LbAXjTGCW4I8BINI
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="82293882"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <kernel.online@gilksonline.com>
Subject: [PATCH 04/13] Remove references to __FUNCTION__ Checkpatch.pl issues to line 250 removed
Date: Sat,  5 Jun 2010 22:12:28 +0800
Message-Id: <1275747158-31375-5-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275747158-31375-4-git-send-email-mike.kernel@gilksonline.com>
References: <1275747158-31375-1-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-2-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-3-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-4-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Gilks <kernel.online@gilksonline.com>

---
 drivers/staging/rtl8192u/r8192U_core.c |  175 ++++++++++++++++----------------
 1 files changed, 89 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 13c7baf..ba9df82 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -200,57 +200,60 @@ static CHANNEL_LIST ChannelPlan[] = {
 		 */
 };
 
-static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv* priv)
+static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
 {
-	int i, max_chan=-1, min_chan=-1;
-	struct ieee80211_device* ieee = priv->ieee80211;
-	switch (channel_plan)
-	{
-		case COUNTRY_CODE_FCC:
-		case COUNTRY_CODE_IC:
-		case COUNTRY_CODE_ETSI:
-		case COUNTRY_CODE_SPAIN:
-		case COUNTRY_CODE_FRANCE:
-		case COUNTRY_CODE_MKK:
-		case COUNTRY_CODE_MKK1:
-		case COUNTRY_CODE_ISRAEL:
-		case COUNTRY_CODE_TELEC:
-		case COUNTRY_CODE_MIC:
-		{
-			Dot11d_Init(ieee);
-			ieee->bGlobalDomain = false;
-			//acturally 8225 & 8256 rf chip only support B,G,24N mode
-			if ((priv->rf_chip == RF_8225) || (priv->rf_chip == RF_8256))
-			{
-				min_chan = 1;
-				max_chan = 14;
-			}
-			else
-			{
-				RT_TRACE(COMP_ERR, "unknown rf chip, can't set channel map in function:%s()\n", __FUNCTION__);
-			}
-			if (ChannelPlan[channel_plan].Len != 0){
-				// Clear old channel map
-				memset(GET_DOT11D_INFO(ieee)->channel_map, 0, sizeof(GET_DOT11D_INFO(ieee)->channel_map));
-				// Set new channel map
-				for (i=0;i<ChannelPlan[channel_plan].Len;i++)
-				{
-					if (ChannelPlan[channel_plan].Channel[i] < min_chan || ChannelPlan[channel_plan].Channel[i] > max_chan)
-					break;
-					GET_DOT11D_INFO(ieee)->channel_map[ChannelPlan[channel_plan].Channel[i]] = 1;
-				}
+	int i, max_chan =- 1, min_chan = -1;
+	struct ieee80211_device *ieee = priv->ieee80211;
+	switch (channel_plan) {
+	case COUNTRY_CODE_FCC:
+	case COUNTRY_CODE_IC:
+	case COUNTRY_CODE_ETSI:
+	case COUNTRY_CODE_SPAIN:
+	case COUNTRY_CODE_FRANCE:
+	case COUNTRY_CODE_MKK:
+	case COUNTRY_CODE_MKK1:
+	case COUNTRY_CODE_ISRAEL:
+	case COUNTRY_CODE_TELEC:
+	case COUNTRY_CODE_MIC: {
+		Dot11d_Init(ieee);
+		ieee->bGlobalDomain = false;
+		/* acturally 8225 & 8256 rf chip
+		 * only support B,G,24N mode
+		 */
+		if ((priv->rf_chip == RF_8225) || (priv->rf_chip == RF_8256)) {
+			min_chan = 1;
+			max_chan = 14;
+		} else {
+			RT_TRACE(COMP_ERR, "unknown rf chip, can't set channel"
+					" map in function:%s()\n", __func__);
+		}
+		if (ChannelPlan[channel_plan].Len != 0) {
+			/* Clear old channel map */
+			memset(GET_DOT11D_INFO(ieee)->channel_map, 0,
+				sizeof(GET_DOT11D_INFO(ieee)->channel_map));
+			/* Set new channel map */
+			for (i = 0;i<ChannelPlan[channel_plan].Len; i++) {
+				if (ChannelPlan[channel_plan].Channel[i] <
+					min_chan || ChannelPlan[channel_plan].
+							Channel[i] > max_chan)
+				break;
+				GET_DOT11D_INFO(ieee)->channel_map[ChannelPlan
+						[channel_plan].Channel[i]] = 1;
 			}
-			break;
 		}
-		case COUNTRY_CODE_GLOBAL_DOMAIN:
-		{
-			GET_DOT11D_INFO(ieee)->bEnabled = 0;//this flag enabled to follow 11d country IE setting, otherwise, it shall follow global domain settings.
-			Dot11d_Reset(ieee);
-			ieee->bGlobalDomain = true;
-			break;
+		break;
+	}
+	case COUNTRY_CODE_GLOBAL_DOMAIN: {
+		GET_DOT11D_INFO(ieee)->bEnabled = 0;
+		/* this flag enabled to follow 11d country IE setting,
+		 * otherwise, it shall follow global domain settings.
+		 */
+		Dot11d_Reset(ieee);
+		ieee->bGlobalDomain = true;
+		break;
 		}
-		default:
-			break;
+	default:
+		break;
 	}
 	return;
 }
@@ -901,7 +904,7 @@ void rtl8192_set_chan(struct net_device *dev,short ch)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 //	u32 tx;
-	RT_TRACE(COMP_CH, "=====>%s()====ch:%d\n", __FUNCTION__, ch);
+	RT_TRACE(COMP_CH, "=====>%s()====ch:%d\n", __func__, ch);
 	priv->chan=ch;
 
 	/* this hack should avoid frame TX during channel setting*/
@@ -1156,7 +1159,7 @@ static void rtl8192_rx_isr(struct urb *urb)
 		priv->stats.rxstaterr++;
 		priv->ieee80211->stats.rx_errors++;
 		usb_free_urb(urb);
-	//	printk("%s():rx status err\n",__FUNCTION__);
+	//	printk("%s():rx status err\n",__func__);
 		return;
 	}
 	skb_unlink(skb, &priv->rx_queue);
@@ -1168,7 +1171,7 @@ static void rtl8192_rx_isr(struct urb *urb)
 	skb = dev_alloc_skb(RX_URB_SIZE);
 	if (unlikely(!skb)) {
 		usb_free_urb(urb);
-		printk("%s():can,t alloc skb\n",__FUNCTION__);
+		printk("%s():can,t alloc skb\n",__func__);
 		/* TODO check rx queue length and refill *somewhere* */
 		return;
 	}
@@ -1836,7 +1839,7 @@ unsigned int txqueue2outpipe(struct r8192_priv* priv,unsigned int tx_queue) {
 
 	if(tx_queue >= 9)
 	{
-		RT_TRACE(COMP_ERR,"%s():Unknown queue ID!!!\n",__FUNCTION__);
+		RT_TRACE(COMP_ERR,"%s():Unknown queue ID!!!\n",__func__);
 		return 0x04;
 	}
 	return priv->txqueue_to_outpipemap[tx_queue];
@@ -1854,7 +1857,7 @@ short rtl819xU_tx_cmd(struct net_device *dev, struct sk_buff *skb)
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	u8 queue_index = tcb_desc->queue_index;
 
-	//printk("\n %s::queue_index = %d\n",__FUNCTION__, queue_index);
+	//printk("\n %s::queue_index = %d\n",__func__, queue_index);
 	atomic_inc(&priv->tx_pending[queue_index]);
 	tx_urb = usb_alloc_urb(0,GFP_ATOMIC);
 	if(!tx_urb){
@@ -2032,7 +2035,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff* skb)
 	//int urb_len;
 	unsigned int idx_pipe;
 //	RT_DEBUG_DATA(COMP_SEND, tcb_desc, sizeof(cb_desc));
-//	printk("=============> %s\n", __FUNCTION__);
+//	printk("=============> %s\n", __func__);
 	pend = atomic_read(&priv->tx_pending[tcb_desc->queue_index]);
 	/* we are locked here so the two atomic_read and inc are executed
 	 * without interleaves
@@ -2371,7 +2374,7 @@ void rtl8192_link_change(struct net_device *dev)
 		EnableHWSecurityConfig8192(dev);
 	}
 	/*update timing params*/
-//	RT_TRACE(COMP_CH, "========>%s(), chan:%d\n", __FUNCTION__, priv->chan);
+//	RT_TRACE(COMP_CH, "========>%s(), chan:%d\n", __func__, priv->chan);
 //	rtl8192_set_chan(dev, priv->chan);
 	 if (ieee->iw_mode == IW_MODE_INFRA || ieee->iw_mode == IW_MODE_ADHOC)
         {
@@ -2551,7 +2554,7 @@ static int rtl8192_qos_association_resp(struct r8192_priv *priv,
 
 	spin_unlock_irqrestore(&priv->ieee80211->lock, flags);
 
-	RT_TRACE(COMP_QOS, "%s: network->flags = %d,%d\n",__FUNCTION__,network->flags ,priv->ieee80211->current_network.qos_data.active);
+	RT_TRACE(COMP_QOS, "%s: network->flags = %d,%d\n",__func__,network->flags ,priv->ieee80211->current_network.qos_data.active);
 	if (set_qos_param == 1)
 		queue_work(priv->priv_wq, &priv->qos_activate);
 
@@ -2730,7 +2733,7 @@ void rtl8192_SetWirelessMode(struct net_device* dev, u8 wireless_mode)
 			wireless_mode = WIRELESS_MODE_B;
 		}
 		else{
-			RT_TRACE(COMP_ERR, "%s(), No valid wireless mode supported, SupportedWirelessMode(%x)!!!\n", __FUNCTION__,bSupportMode);
+			RT_TRACE(COMP_ERR, "%s(), No valid wireless mode supported, SupportedWirelessMode(%x)!!!\n", __func__,bSupportMode);
 			wireless_mode = WIRELESS_MODE_B;
 		}
 	}
@@ -2922,12 +2925,12 @@ static void rtl8192_get_eeprom_size(struct net_device* dev)
 {
 	u16 curCR = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	RT_TRACE(COMP_EPROM, "===========>%s()\n", __FUNCTION__);
+	RT_TRACE(COMP_EPROM, "===========>%s()\n", __func__);
 	curCR = read_nic_word_E(dev,EPROM_CMD);
 	RT_TRACE(COMP_EPROM, "read from Reg EPROM_CMD(%x):%x\n", EPROM_CMD, curCR);
 	//whether need I consider BIT5?
 	priv->epromtype = (curCR & Cmd9346CR_9356SEL) ? EPROM_93c56 : EPROM_93c46;
-	RT_TRACE(COMP_EPROM, "<===========%s(), epromtype:%d\n", __FUNCTION__, priv->epromtype);
+	RT_TRACE(COMP_EPROM, "<===========%s(), epromtype:%d\n", __func__, priv->epromtype);
 }
 
 //used to swap endian. as ntohl & htonl are not neccessary to swap endian, so use this instead.
@@ -2944,7 +2947,7 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 	u8 bLoad_From_EEPOM = false;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u16 tmpValue = 0;
-	RT_TRACE(COMP_EPROM, "===========>%s()\n", __FUNCTION__);
+	RT_TRACE(COMP_EPROM, "===========>%s()\n", __func__);
 	wEPROM_ID = eprom_read(dev, 0); //first read EEPROM ID out;
 	RT_TRACE(COMP_EPROM, "EEPROM ID is 0x%x\n", wEPROM_ID);
 
@@ -3177,7 +3180,7 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 	init_rate_adaptive(dev);
 	//we need init DIG RATR table here again.
 
-	RT_TRACE(COMP_EPROM, "<===========%s()\n", __FUNCTION__);
+	RT_TRACE(COMP_EPROM, "<===========%s()\n", __func__);
 	return;
 }
 
@@ -3359,7 +3362,7 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u32 dwRegRead = 0;
 	bool init_status = true;
-	RT_TRACE(COMP_INIT, "====>%s()\n", __FUNCTION__);
+	RT_TRACE(COMP_INIT, "====>%s()\n", __func__);
 	priv->Rf_Mode = RF_OP_By_SW_3wire;
 	//for ASIC power on sequence
 	write_nic_byte_E(dev, 0x5f, 0x80);
@@ -3379,7 +3382,7 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	else if (priv->pFirmware->firmware_status == FW_STATUS_5_READY)
 		dwRegRead |= CPU_GEN_FIRMWARE_RESET;
 	else
-		RT_TRACE(COMP_ERR, "ERROR in %s(): undefined firmware state(%d)\n", __FUNCTION__,   priv->pFirmware->firmware_status);
+		RT_TRACE(COMP_ERR, "ERROR in %s(): undefined firmware state(%d)\n", __func__,   priv->pFirmware->firmware_status);
 
 	write_nic_dword(dev, CPU_GEN, dwRegRead);
 	//mdelay(30);
@@ -3396,7 +3399,7 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	else if (priv->LoopbackMode == RTL819xU_MAC_LOOPBACK)
 		dwRegRead |= CPU_CCK_LOOPBACK;
 	else
-		RT_TRACE(COMP_ERR, "Serious error in %s(): wrong loopback mode setting(%d)\n", __FUNCTION__,  priv->LoopbackMode);
+		RT_TRACE(COMP_ERR, "Serious error in %s(): wrong loopback mode setting(%d)\n", __func__,  priv->LoopbackMode);
 
 	write_nic_dword(dev, CPU_GEN, dwRegRead);
 
@@ -3436,7 +3439,7 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	// TODO: (it value is only for FPGA version). need to be changed!!2006.12.18, by Emily
 	write_nic_byte(dev, ACK_TIMEOUT, 0x30);
 
-//	RT_TRACE(COMP_INIT, "%s():priv->ResetProgress is %d\n", __FUNCTION__,priv->ResetProgress);
+//	RT_TRACE(COMP_INIT, "%s():priv->ResetProgress is %d\n", __func__,priv->ResetProgress);
 	if(priv->ResetProgress == RESET_TYPE_NORESET)
 	rtl8192_SetWirelessMode(dev, priv->ieee80211->mode);
 	if(priv->ResetProgress == RESET_TYPE_NORESET){
@@ -3490,10 +3493,10 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	init_status = init_firmware(dev);
 	if(!init_status)
 	{
-		RT_TRACE(COMP_ERR,"ERR!!! %s(): Firmware download is failed\n", __FUNCTION__);
+		RT_TRACE(COMP_ERR,"ERR!!! %s(): Firmware download is failed\n", __func__);
 		return init_status;
 	}
-	RT_TRACE(COMP_INIT, "%s():after firmware download\n", __FUNCTION__);
+	RT_TRACE(COMP_INIT, "%s():after firmware download\n", __func__);
 	//
 #ifdef TO_DO_LIST
 if(Adapter->ResetProgress == RESET_TYPE_NORESET)
@@ -3532,7 +3535,7 @@ if(Adapter->ResetProgress == RESET_TYPE_NORESET)
 	//config RF.
 	if(priv->ResetProgress == RESET_TYPE_NORESET){
 	rtl8192_phy_RFConfig(dev);
-	RT_TRACE(COMP_INIT, "%s():after phy RF config\n", __FUNCTION__);
+	RT_TRACE(COMP_INIT, "%s():after phy RF config\n", __func__);
 	}
 
 
@@ -3627,7 +3630,7 @@ HalTxCheckStuck819xUsb(
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u16 		RegTxCounter = read_nic_word(dev, 0x128);
 	bool		bStuck = FALSE;
-	RT_TRACE(COMP_RESET,"%s():RegTxCounter is %d,TxCounter is %d\n",__FUNCTION__,RegTxCounter,priv->TxCounter);
+	RT_TRACE(COMP_RESET,"%s():RegTxCounter is %d,TxCounter is %d\n",__func__,RegTxCounter,priv->TxCounter);
 	if(priv->TxCounter==RegTxCounter)
 		bStuck = TRUE;
 
@@ -3691,7 +3694,7 @@ HalRxCheckStuck819xUsb(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	bool bStuck = FALSE;
 	static u8	rx_chk_cnt = 0;
-	RT_TRACE(COMP_RESET,"%s(): RegRxCounter is %d,RxCounter is %d\n",__FUNCTION__,RegRxCounter,priv->RxCounter);
+	RT_TRACE(COMP_RESET,"%s(): RegRxCounter is %d,RxCounter is %d\n",__func__,RegRxCounter,priv->RxCounter);
 	// If rssi is small, we should check rx for long time because of bad rx.
 	// or maybe it will continuous silent reset every 2 seconds.
 	rx_chk_cnt++;
@@ -3816,7 +3819,7 @@ rtl819x_ifcheck_resetornot(struct net_device *dev)
 	if(TxResetType==RESET_TYPE_NORMAL || RxResetType==RESET_TYPE_NORMAL)
 		return RESET_TYPE_NORMAL;
 	else if(TxResetType==RESET_TYPE_SILENT || RxResetType==RESET_TYPE_SILENT){
-		RT_TRACE(COMP_RESET,"%s():silent reset\n",__FUNCTION__);
+		RT_TRACE(COMP_RESET,"%s():silent reset\n",__func__);
 		return RESET_TYPE_SILENT;
 	}
 	else
@@ -3995,12 +3998,12 @@ RESET_START:
 		down(&priv->wx_sem);
 		if(priv->up == 0)
 		{
-			RT_TRACE(COMP_ERR,"%s():the driver is not up! return\n",__FUNCTION__);
+			RT_TRACE(COMP_ERR,"%s():the driver is not up! return\n",__func__);
 			up(&priv->wx_sem);
 			return ;
 		}
 		priv->up = 0;
-		RT_TRACE(COMP_RESET,"%s():======>start to down the driver\n",__FUNCTION__);
+		RT_TRACE(COMP_RESET,"%s():======>start to down the driver\n",__func__);
 //		if(!netif_queue_stopped(dev))
 //			netif_stop_queue(dev);
 
@@ -4025,12 +4028,12 @@ RESET_START:
 			printk("ieee->state is NOT LINKED\n");
 			ieee80211_softmac_stop_protocol(priv->ieee80211);			}
 		up(&priv->wx_sem);
-		RT_TRACE(COMP_RESET,"%s():<==========down process is finished\n",__FUNCTION__);
+		RT_TRACE(COMP_RESET,"%s():<==========down process is finished\n",__func__);
 	//rtl8192_irq_disable(dev);
-		RT_TRACE(COMP_RESET,"%s():===========>start to up the driver\n",__FUNCTION__);
+		RT_TRACE(COMP_RESET,"%s():===========>start to up the driver\n",__func__);
 		reset_status = _rtl8192_up(dev);
 
-		RT_TRACE(COMP_RESET,"%s():<===========up process is finished\n",__FUNCTION__);
+		RT_TRACE(COMP_RESET,"%s():<===========up process is finished\n",__func__);
 		if(reset_status == -EAGAIN)
 		{
 			if(reset_times < 3)
@@ -4040,7 +4043,7 @@ RESET_START:
 			}
 			else
 			{
-				RT_TRACE(COMP_ERR," ERR!!! %s():  Reset Failed!!\n", __FUNCTION__);
+				RT_TRACE(COMP_ERR," ERR!!! %s():  Reset Failed!!\n", __func__);
 			}
 		}
 		ieee->is_silent_reset = 1;
@@ -4179,9 +4182,9 @@ extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
 			{
 				#ifdef TODO
 				if(rfState == eRfOff)
-					RT_TRACE(COMP_ERR,"========>%s()\n",__FUNCTION__);
+					RT_TRACE(COMP_ERR,"========>%s()\n",__func__);
 				#endif
-				printk("===>%s(): AP is power off,connect another one\n",__FUNCTION__);
+				printk("===>%s(): AP is power off,connect another one\n",__func__);
 			//	Dot11d_Reset(dev);
 				priv->ieee80211->state = IEEE80211_ASSOCIATING;
 				notify_wx_assoc_event(priv->ieee80211);
@@ -4202,12 +4205,12 @@ extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
 		check_reset_cnt = 3;
 		//DbgPrint("Start to check silent reset\n");
 	}
-	//	RT_TRACE(COMP_RESET,"%s():priv->force_reset is %d,priv->ResetProgress is %d, priv->bForcedSilentReset is %d,priv->bDisableNormalResetCheck is %d,ResetType is %d\n",__FUNCTION__,priv->force_reset,priv->ResetProgress,priv->bForcedSilentReset,priv->bDisableNormalResetCheck,ResetType);
+	//	RT_TRACE(COMP_RESET,"%s():priv->force_reset is %d,priv->ResetProgress is %d, priv->bForcedSilentReset is %d,priv->bDisableNormalResetCheck is %d,ResetType is %d\n",__func__,priv->force_reset,priv->ResetProgress,priv->bForcedSilentReset,priv->bDisableNormalResetCheck,ResetType);
 	if( (priv->force_reset) || (priv->ResetProgress==RESET_TYPE_NORESET &&
 		(priv->bForcedSilentReset ||
 		(!priv->bDisableNormalResetCheck && ResetType==RESET_TYPE_SILENT)))) // This is control by OID set in Pomelo
 	{
-		RT_TRACE(COMP_RESET,"%s():priv->force_reset is %d,priv->ResetProgress is %d, priv->bForcedSilentReset is %d,priv->bDisableNormalResetCheck is %d,ResetType is %d\n",__FUNCTION__,priv->force_reset,priv->ResetProgress,priv->bForcedSilentReset,priv->bDisableNormalResetCheck,ResetType);
+		RT_TRACE(COMP_RESET,"%s():priv->force_reset is %d,priv->ResetProgress is %d, priv->bForcedSilentReset is %d,priv->bDisableNormalResetCheck is %d,ResetType is %d\n",__func__,priv->force_reset,priv->ResetProgress,priv->bForcedSilentReset,priv->bDisableNormalResetCheck,ResetType);
 		rtl819x_ifsilentreset(dev);
 	}
 	priv->force_reset = false;
@@ -4235,7 +4238,7 @@ int _rtl8192_up(struct net_device *dev)
 	init_status = rtl8192_adapter_start(dev);
 	if(!init_status)
 	{
-		RT_TRACE(COMP_ERR,"ERR!!! %s(): initialization is failed!\n", __FUNCTION__);
+		RT_TRACE(COMP_ERR,"ERR!!! %s(): initialization is failed!\n", __func__);
 		priv->up=priv->ieee80211->ieee_up = 0;
 		return -EAGAIN;
 	}
@@ -4301,7 +4304,7 @@ int rtl8192_down(struct net_device *dev)
 
 	priv->up=0;
 	priv->ieee80211->ieee_up = 0;
-	RT_TRACE(COMP_DOWN, "==========>%s()\n", __FUNCTION__);
+	RT_TRACE(COMP_DOWN, "==========>%s()\n", __func__);
 /* FIXME */
 	if (!netif_queue_stopped(dev))
 		netif_stop_queue(dev);
@@ -4330,7 +4333,7 @@ int rtl8192_down(struct net_device *dev)
 
 	ieee80211_softmac_stop_protocol(priv->ieee80211);
 	memset(&priv->ieee80211->current_network, 0 , offsetof(struct ieee80211_network, list));
-	RT_TRACE(COMP_DOWN, "<==========%s()\n", __FUNCTION__);
+	RT_TRACE(COMP_DOWN, "<==========%s()\n", __func__);
 
 		return 0;
 }
@@ -5536,7 +5539,7 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 			agg_skb = skb;
 			//TotalLength = agg_skb->len - 4; /*sCrcLng*/
 			TotalLength = stats.Length - 4; /*sCrcLng*/
-			//RT_TRACE(COMP_RECV, "%s:first aggregated packet!Length=%d\n",__FUNCTION__,TotalLength);
+			//RT_TRACE(COMP_RECV, "%s:first aggregated packet!Length=%d\n",__func__,TotalLength);
 			/* though the head pointer has passed this position  */
 			TempDWord = *(u32 *)(agg_skb->data - 4);
 			PacketLength = (u16)(TempDWord & 0x3FFF); /*sCrcLng*/
@@ -5584,7 +5587,7 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
 
 			while (agg_skb->len>=GetRxPacketShiftBytes819xUsb(&stats, true)) {
 				u8 tmpCRC = 0, tmpICV = 0;
-				//RT_TRACE(COMP_RECV,"%s:aggred pkt,total_len = %d\n",__FUNCTION__,agg_skb->len);
+				//RT_TRACE(COMP_RECV,"%s:aggred pkt,total_len = %d\n",__func__,agg_skb->len);
 				RxDescr = (rx_desc_819x_usb_aggr_subframe *)(agg_skb->data);
 				tmpCRC = RxDescr->CRC32;
 				tmpICV = RxDescr->ICV;
@@ -6029,7 +6032,7 @@ void EnableHWSecurityConfig8192(struct net_device *dev)
 		ieee->hwsec_active = 0;
 		SECR_value &= ~SCR_RxDecEnable;
 	}
-	RT_TRACE(COMP_SEC,"%s:, hwsec:%d, pairwise_key:%d, SECR_value:%x\n", __FUNCTION__, \
+	RT_TRACE(COMP_SEC,"%s:, hwsec:%d, pairwise_key:%d, SECR_value:%x\n", __func__, \
 			ieee->hwsec_active, ieee->pairwise_key_type, SECR_value);
 	{
 		write_nic_byte(dev, SECR,  SECR_value);//SECR_value |  SCR_UseDK );
-- 
1.6.3.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0FMHZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 03:25:52 -0400
Received: from outbound-mail01.westnet.com.au ([203.10.1.242]:15602 "EHLO
	outbound-mail01.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547Ab0FMHZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 03:25:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsBBAMYUFEw6B0zXPGdsb2JhbACHbpcRDAEBAQE1LbBrjE6FGgSDSw
X-IronPort-AV: E=Sophos;i="4.53,410,1272816000"; 
   d="scan'208";a="84157944"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 2/4] staging: rtl8192u: fix checkpatch.pl issues to line 5000 Fix most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 5000
Date: Sun, 13 Jun 2010 14:16:49 +0800
Message-Id: <1276409811-16682-3-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1276409811-16682-2-git-send-email-mike.kernel@gilksonline.com>
References: <1276409811-16682-1-git-send-email-mike.kernel@gilksonline.com>
 <1276409811-16682-2-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |  724 ++++++++++++++++----------------
 1 files changed, 360 insertions(+), 364 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 21e3ac3..1a89b20 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -4037,8 +4037,8 @@ rtl819x_ifcheck_resetornot(struct net_device *dev)
 	if (TxResetType == RESET_TYPE_NORMAL ||
 				RxResetType == RESET_TYPE_NORMAL)
 		return RESET_TYPE_NORMAL;
-	else if(TxResetType == RESET_TYPE_SILENT ||
-				RxResetType==RESET_TYPE_SILENT){
+	else if (TxResetType == RESET_TYPE_SILENT ||
+				RxResetType == RESET_TYPE_SILENT){
 		RT_TRACE(COMP_RESET, "%s():silent reset\n", __func__);
 		return RESET_TYPE_SILENT;
 	} else
@@ -4046,144 +4046,74 @@ rtl819x_ifcheck_resetornot(struct net_device *dev)
 
 }
 
-void rtl8192_cancel_deferred_work(struct r8192_priv* priv);
+void rtl8192_cancel_deferred_work(struct r8192_priv *priv);
 int _rtl8192_up(struct net_device *dev);
 int rtl8192_close(struct net_device *dev);
 
-
-
 void
-CamRestoreAllEntry(	struct net_device *dev)
+CamRestoreAllEntry(struct net_device *dev)
 {
 	u8 EntryId = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	u8*	MacAddr = priv->ieee80211->current_network.bssid;
+	u8 *MacAddr = priv->ieee80211->current_network.bssid;
 
 	static u8	CAM_CONST_ADDR[4][6] = {
 		{0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
 		{0x00, 0x00, 0x00, 0x00, 0x00, 0x01},
 		{0x00, 0x00, 0x00, 0x00, 0x00, 0x02},
-		{0x00, 0x00, 0x00, 0x00, 0x00, 0x03}};
-	static u8	CAM_CONST_BROAD[] =
-		{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+		{0x00, 0x00, 0x00, 0x00, 0x00, 0x03} };
+	static u8	CAM_CONST_BROAD[] = {
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
-	RT_TRACE(COMP_SEC, "CamRestoreAllEntry: \n");
+	RT_TRACE(COMP_SEC, "CamRestoreAllEntry:\n");
 
 
-	if ((priv->ieee80211->pairwise_key_type == KEY_TYPE_WEP40)||
-	    (priv->ieee80211->pairwise_key_type == KEY_TYPE_WEP104))
-	{
+	if ((priv->ieee80211->pairwise_key_type == KEY_TYPE_WEP40) ||
+		(priv->ieee80211->pairwise_key_type == KEY_TYPE_WEP104)) {
 
-		for(EntryId=0; EntryId<4; EntryId++)
-		{
-			{
-				MacAddr = CAM_CONST_ADDR[EntryId];
-				setKey(dev,
-						EntryId ,
-						EntryId,
-						priv->ieee80211->pairwise_key_type,
-						MacAddr,
-						0,
-						NULL);
-			}
+		for (EntryId = 0; EntryId < 4; EntryId++) {
+			MacAddr = CAM_CONST_ADDR[EntryId];
+			setKey(dev, EntryId, EntryId,
+				priv->ieee80211->pairwise_key_type,
+				MacAddr, 0, NULL);
 		}
-
-	}
-	else if(priv->ieee80211->pairwise_key_type == KEY_TYPE_TKIP)
-	{
-
-		{
-			if(priv->ieee80211->iw_mode == IW_MODE_ADHOC)
-				setKey(dev,
-						4,
-						0,
-						priv->ieee80211->pairwise_key_type,
-						(u8*)dev->dev_addr,
-						0,
-						NULL);
-			else
-				setKey(dev,
-						4,
-						0,
-						priv->ieee80211->pairwise_key_type,
-						MacAddr,
-						0,
-						NULL);
+	} else if (priv->ieee80211->pairwise_key_type == KEY_TYPE_TKIP) {
+		if (priv->ieee80211->iw_mode == IW_MODE_ADHOC)
+			setKey(dev, 4, 0, priv->ieee80211->pairwise_key_type,
+				(u8 *)dev->dev_addr, 0,	NULL);
+		else
+			setKey(dev, 4, 0, priv->ieee80211->pairwise_key_type,
+				MacAddr, 0, NULL);
+	} else if (priv->ieee80211->pairwise_key_type == KEY_TYPE_CCMP) {
+		if (priv->ieee80211->iw_mode == IW_MODE_ADHOC)
+			setKey(dev, 4, 0, priv->ieee80211->pairwise_key_type,
+				(u8 *)dev->dev_addr, 0, NULL);
+		else
+			setKey(dev, 4, 0, priv->ieee80211->pairwise_key_type,
+				MacAddr, 0, NULL);
 		}
-	}
-	else if(priv->ieee80211->pairwise_key_type == KEY_TYPE_CCMP)
-	{
 
-		{
-			if(priv->ieee80211->iw_mode == IW_MODE_ADHOC)
-				setKey(dev,
-						4,
-						0,
-						priv->ieee80211->pairwise_key_type,
-						(u8*)dev->dev_addr,
-						0,
-						NULL);
-			else
-				setKey(dev,
-						4,
-						0,
-						priv->ieee80211->pairwise_key_type,
-						MacAddr,
-						0,
-						NULL);
-		}
-	}
-
-
-
-	if(priv->ieee80211->group_key_type == KEY_TYPE_TKIP)
-	{
+	if (priv->ieee80211->group_key_type == KEY_TYPE_TKIP) {
 		MacAddr = CAM_CONST_BROAD;
-		for(EntryId=1 ; EntryId<4 ; EntryId++)
-		{
-			{
-				setKey(dev,
-						EntryId,
-						EntryId,
-						priv->ieee80211->group_key_type,
-						MacAddr,
-						0,
-						NULL);
-			}
+		for (EntryId = 1 ; EntryId < 4 ; EntryId++) {
+			setKey(dev, EntryId, EntryId,
+				priv->ieee80211->group_key_type,
+				MacAddr, 0, NULL);
 		}
-		if(priv->ieee80211->iw_mode == IW_MODE_ADHOC)
-				setKey(dev,
-						0,
-						0,
-						priv->ieee80211->group_key_type,
-						CAM_CONST_ADDR[0],
-						0,
-						NULL);
-	}
-	else if(priv->ieee80211->group_key_type == KEY_TYPE_CCMP)
-	{
+	}
+	if (priv->ieee80211->iw_mode == IW_MODE_ADHOC)
+		setKey(dev, 0, 0, priv->ieee80211->group_key_type,
+			CAM_CONST_ADDR[0], 0, NULL);
+	else if (priv->ieee80211->group_key_type == KEY_TYPE_CCMP) {
 		MacAddr = CAM_CONST_BROAD;
-		for(EntryId=1; EntryId<4 ; EntryId++)
-		{
-			{
-				setKey(dev,
-						EntryId ,
-						EntryId,
-						priv->ieee80211->group_key_type,
-						MacAddr,
-						0,
-						NULL);
-			}
+		for (EntryId = 1; EntryId < 4 ; EntryId++) {
+			setKey(dev, EntryId, EntryId,
+				priv->ieee80211->group_key_type,
+				MacAddr, 0, NULL);
 		}
-
-		if(priv->ieee80211->iw_mode == IW_MODE_ADHOC)
-				setKey(dev,
-						0 ,
-						0,
-						priv->ieee80211->group_key_type,
-						CAM_CONST_ADDR[0],
-						0,
-						NULL);
+	if (priv->ieee80211->iw_mode == IW_MODE_ADHOC)
+		setKey(dev, 0, 0, priv->ieee80211->group_key_type,
+		CAM_CONST_ADDR[0], 0, NULL);
 	}
 }
 
@@ -4205,24 +4135,24 @@ rtl819x_ifsilentreset(struct net_device *dev)
 	/* 2007.07.20. If we need to check CCK stop, uncomment this line. */
 	/* bStuck = Adapter->HalFunc.CheckHWStopHandler(Adapter); */
 
-	if(priv->ResetProgress==RESET_TYPE_NORESET)
-	{
-RESET_START:
+	if (priv->ResetProgress == RESET_TYPE_NORESET) {
+	RESET_START:
 
-		RT_TRACE(COMP_RESET,"=========>Reset progress!! \n");
+		RT_TRACE(COMP_RESET, "=========>Reset progress!!\n");
 
 		/* Set the variable for reset. */
 		priv->ResetProgress = RESET_TYPE_SILENT;
 		/* rtl8192_close(dev); */
 		down(&priv->wx_sem);
-		if(priv->up == 0)
-		{
-			RT_TRACE(COMP_ERR,"%s():the driver is not up! return\n",__func__);
+		if (priv->up == 0) {
+			RT_TRACE(COMP_ERR, "%s():the driver is not up!"
+				" return\n", __func__);
 			up(&priv->wx_sem);
 			return ;
 		}
 		priv->up = 0;
-		RT_TRACE(COMP_RESET,"%s():======>start to down the driver\n",__func__);
+		RT_TRACE(COMP_RESET, "%s():======>start to down the driver\n",
+				__func__);
 		/* if(!netif_queue_stopped(dev))
 		 *	netif_stop_queue(dev);
 		 */
@@ -4233,8 +4163,7 @@ RESET_START:
 		del_timer_sync(&priv->watch_dog_timer);
 
 		ieee->sync_scan_hurryup = 1;
-		if(ieee->state == IEEE80211_LINKED)
-		{
+		if (ieee->state == IEEE80211_LINKED) {
 			down(&ieee->wx_sem);
 			printk("ieee->state is IEEE80211_LINKED\n");
 			ieee80211_stop_send_beacons(priv->ieee80211);
@@ -4243,47 +4172,44 @@ RESET_START:
 			ieee80211_stop_scan(ieee);
 			netif_carrier_off(dev);
 			up(&ieee->wx_sem);
-		}
-		else{
+		} else {
 			printk("ieee->state is NOT LINKED\n");
-			ieee80211_softmac_stop_protocol(priv->ieee80211);			}
+			ieee80211_softmac_stop_protocol(priv->ieee80211);
+		}
 		up(&priv->wx_sem);
-		RT_TRACE(COMP_RESET,"%s():<==========down process is finished\n",__func__);
+		RT_TRACE(COMP_RESET, "%s():<==========down process is"
+				" finished\n", __func__);
 		/* rtl8192_irq_disable(dev); */
-		RT_TRACE(COMP_RESET,"%s():===========>start to up the driver\n",__func__);
+		RT_TRACE(COMP_RESET, "%s():===========>start to up the"
+				" driver\n", __func__);
 		reset_status = _rtl8192_up(dev);
 
-		RT_TRACE(COMP_RESET,"%s():<===========up process is finished\n",__func__);
-		if(reset_status == -EAGAIN)
-		{
-			if(reset_times < 3)
-			{
+		RT_TRACE(COMP_RESET, "%s():<===========up process is"
+				" finished\n", __func__);
+		if (reset_status == -EAGAIN) {
+			if (reset_times < 3) {
 				reset_times++;
 				goto RESET_START;
-			}
-			else
-			{
-				RT_TRACE(COMP_ERR," ERR!!! %s():  Reset Failed!!\n", __func__);
-			}
+			} else
+				RT_TRACE(COMP_ERR, " ERR!!! %s():  Reset"
+						" Failed!!\n", __func__);
 		}
 		ieee->is_silent_reset = 1;
 		EnableHWSecurityConfig8192(dev);
-		if(ieee->state == IEEE80211_LINKED && ieee->iw_mode == IW_MODE_INFRA)
-		{
-			ieee->set_chan(ieee->dev, ieee->current_network.channel);
+		if (ieee->state == IEEE80211_LINKED && ieee->iw_mode ==
+				IW_MODE_INFRA) {
+			ieee->set_chan(ieee->dev,
+					ieee->current_network.channel);
 
 			queue_work(ieee->wq, &ieee->associate_complete_wq);
-
-		}
-		else if(ieee->state == IEEE80211_LINKED && ieee->iw_mode == IW_MODE_ADHOC)
-		{
-			ieee->set_chan(ieee->dev, ieee->current_network.channel);
+		} else if (ieee->state == IEEE80211_LINKED && ieee->iw_mode ==
+				IW_MODE_ADHOC) {
+			ieee->set_chan(ieee->dev,
+					ieee->current_network.channel);
 			ieee->link_change(ieee->dev);
 
 			/* notify_wx_assoc_event(ieee); */
-
 			ieee80211_start_send_beacons(ieee);
-
 			if (ieee->data_hard_resume)
 				ieee->data_hard_resume(ieee->dev);
 			netif_carrier_on(ieee->dev);
@@ -4294,132 +4220,139 @@ RESET_START:
 		priv->ResetProgress = RESET_TYPE_NORESET;
 		priv->reset_count++;
 
-		priv->bForcedSilentReset =false;
+		priv->bForcedSilentReset = false;
 		priv->bResetInProgress = false;
 
 		/* For test --> force write UFWP. */
 		write_nic_byte(dev, UFWP, 1);
-		RT_TRACE(COMP_RESET, "Reset finished!! ====>[%d]\n", priv->reset_count);
+		RT_TRACE(COMP_RESET, "Reset finished!! ====>[%d]\n",
+				priv->reset_count);
 	}
 }
 
 void CAM_read_entry(
 	struct net_device *dev,
-	u32	 		iIndex
+	u32	iIndex
 )
 {
- 	u32 target_command=0;
-	 u32 target_content=0;
-	 u8 entry_i=0;
-	 u32 ulStatus;
-	s32 i=100;
+	u32 target_command = 0;
+	u32 target_content = 0;
+	u8 entry_i = 0;
+	u32 ulStatus;
+	s32 i = 100;
 	/* printk("=======>start read CAM\n"); */
- 	for(entry_i=0;entry_i<CAM_CONTENT_COUNT;entry_i++)
- 	{
-   	/* polling bit, and No Write enable, and address */
-		target_command= entry_i + CAM_CONTENT_COUNT * iIndex;
-		target_command= target_command | BIT31;
+	for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
+		/* polling bit, and No Write enable, and address */
+		target_command = entry_i + CAM_CONTENT_COUNT * iIndex;
+		target_command = target_command | BIT31;
 
 	/* Check polling bit is clear */
 	/* mdelay(1); */
-		while ((i--) >=0 ) {
+		while ((i--) >= 0) {
 			ulStatus = read_nic_dword(dev, RWCAM);
-			if(ulStatus & BIT31){
+			if (ulStatus & BIT31)
 				continue;
-			}
-			else{
+			else
 				break;
-			}
 		}
 		write_nic_dword(dev, RWCAM, target_command);
-		RT_TRACE(COMP_SEC,"CAM_read_entry(): WRITE A0: %x \n",target_command);
-		/* printk("CAM_read_entry(): WRITE A0: %lx \n",target_command); */
+		RT_TRACE(COMP_SEC, "CAM_read_entry(): WRITE A0: %x\n",
+				target_command);
+		/* printk("CAM_read_entry(): WRITE A0: %lx\n",
+		 * target_command);
+		 */
 		target_content = read_nic_dword(dev, RCAMO);
-		RT_TRACE(COMP_SEC, "CAM_read_entry(): WRITE A8: %x \n",target_content);
-	 	/* printk("CAM_read_entry(): WRITE A8: %lx \n",target_content); */
+		RT_TRACE(COMP_SEC, "CAM_read_entry(): WRITE A8: %x\n",
+				target_content);
+		/* printk("CAM_read_entry(): WRITE A8: %lx\n",
+		 *target_content);
+		 */
 	}
 	printk("\n");
 }
 
 void rtl819x_update_rxcounts(
 	struct r8192_priv *priv,
-	u32* TotalRxBcnNum,
-	u32* TotalRxDataNum
+	u32 *TotalRxBcnNum,
+	u32 *TotalRxDataNum
 )
 {
-	u16 			SlotIndex;
-	u8			i;
+	u16		SlotIndex;
+	u8		i;
 
 	*TotalRxBcnNum = 0;
 	*TotalRxDataNum = 0;
 
-	SlotIndex = (priv->ieee80211->LinkDetectInfo.SlotIndex++)%(priv->ieee80211->LinkDetectInfo.SlotNum);
-	priv->ieee80211->LinkDetectInfo.RxBcnNum[SlotIndex] = priv->ieee80211->LinkDetectInfo.NumRecvBcnInPeriod;
-	priv->ieee80211->LinkDetectInfo.RxDataNum[SlotIndex] = priv->ieee80211->LinkDetectInfo.NumRecvDataInPeriod;
-	for( i=0; i<priv->ieee80211->LinkDetectInfo.SlotNum; i++ ){
+	SlotIndex = (priv->ieee80211->LinkDetectInfo.SlotIndex++) %
+			(priv->ieee80211->LinkDetectInfo.SlotNum);
+	priv->ieee80211->LinkDetectInfo.RxBcnNum[SlotIndex] =
+			priv->ieee80211->LinkDetectInfo.NumRecvBcnInPeriod;
+	priv->ieee80211->LinkDetectInfo.RxDataNum[SlotIndex] =
+			priv->ieee80211->LinkDetectInfo.NumRecvDataInPeriod;
+	for (i = 0; i < priv->ieee80211->LinkDetectInfo.SlotNum; i++) {
 		*TotalRxBcnNum += priv->ieee80211->LinkDetectInfo.RxBcnNum[i];
-		*TotalRxDataNum += priv->ieee80211->LinkDetectInfo.RxDataNum[i];
+		*TotalRxDataNum +=
+			priv->ieee80211->LinkDetectInfo.RxDataNum[i];
 	}
 }
 
 
 extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
 {
-	struct delayed_work *dwork = container_of(work,struct delayed_work,work);
-       struct r8192_priv *priv = container_of(dwork,struct r8192_priv,watch_dog_wq);
-       struct net_device *dev = priv->ieee80211->dev;
-	struct ieee80211_device* ieee = priv->ieee80211;
+	struct delayed_work *dwork = container_of(work, struct delayed_work,
+							work);
+	struct r8192_priv *priv = container_of(dwork, struct r8192_priv,
+							watch_dog_wq);
+	struct net_device *dev = priv->ieee80211->dev;
+	struct ieee80211_device *ieee = priv->ieee80211;
 	RESET_TYPE	ResetType = RESET_TYPE_NORESET;
-	static u8	check_reset_cnt=0;
+	static u8	check_reset_cnt;
 	bool bBusyTraffic = false;
 
-	if(!priv->up)
+	if (!priv->up)
 		return;
 	hal_dm_watchdog(dev);
 
 	/* to get busy traffic condition */
-	{ if(ieee->state == IEEE80211_LINKED) {
-			if(	ieee->LinkDetectInfo.NumRxOkInPeriod> 666 ||
-				ieee->LinkDetectInfo.NumTxOkInPeriod> 666 ) {
-				bBusyTraffic = true;
-			}
-			ieee->LinkDetectInfo.NumRxOkInPeriod = 0;
-			ieee->LinkDetectInfo.NumTxOkInPeriod = 0;
-			ieee->LinkDetectInfo.bBusyTraffic = bBusyTraffic;
-		}
+	if (ieee->state == IEEE80211_LINKED) {
+		if (ieee->LinkDetectInfo.NumRxOkInPeriod > 666 ||
+				ieee->LinkDetectInfo.NumTxOkInPeriod > 666)
+			bBusyTraffic = true;
+
+		ieee->LinkDetectInfo.NumRxOkInPeriod = 0;
+		ieee->LinkDetectInfo.NumTxOkInPeriod = 0;
+		ieee->LinkDetectInfo.bBusyTraffic = bBusyTraffic;
 	}
 	/* added by amy for AP roaming */
-	{
-		if(priv->ieee80211->state == IEEE80211_LINKED && priv->ieee80211->iw_mode == IW_MODE_INFRA)
-		{
-			u32	TotalRxBcnNum = 0;
-			u32	TotalRxDataNum = 0;
-
-			rtl819x_update_rxcounts(priv, &TotalRxBcnNum, &TotalRxDataNum);
-			if((TotalRxBcnNum+TotalRxDataNum) == 0)
-			{
-				#ifdef TODO
-				if(rfState == eRfOff)
-					RT_TRACE(COMP_ERR,"========>%s()\n",__func__);
-				#endif
-				printk("===>%s(): AP is power off,connect another one\n",__func__);
-				/* Dot11d_Reset(dev); */
-				priv->ieee80211->state = IEEE80211_ASSOCIATING;
-				notify_wx_assoc_event(priv->ieee80211);
-				RemovePeerTS(priv->ieee80211,priv->ieee80211->current_network.bssid);
-				priv->ieee80211->link_change(dev);
-                                queue_work(priv->ieee80211->wq, &priv->ieee80211->associate_procedure_wq);
-
+	if (priv->ieee80211->state == IEEE80211_LINKED &&
+			priv->ieee80211->iw_mode == IW_MODE_INFRA) {
+		u32	TotalRxBcnNum = 0;
+		u32	TotalRxDataNum = 0;
+		rtl819x_update_rxcounts(priv, &TotalRxBcnNum, &TotalRxDataNum);
+		if ((TotalRxBcnNum + TotalRxDataNum) == 0) {
+			#ifdef TODO
+			if (rfState == eRfOff)
+				RT_TRACE(COMP_ERR, "========>%s()\n",
+						__func__);
+			#endif
+			printk("===>%s(): AP is power off,connect"
+					" another one\n", __func__);
+			/* Dot11d_Reset(dev); */
+			priv->ieee80211->state = IEEE80211_ASSOCIATING;
+			notify_wx_assoc_event(priv->ieee80211);
+			RemovePeerTS(priv->ieee80211,
+				priv->ieee80211->current_network.bssid);
+			priv->ieee80211->link_change(dev);
+			queue_work(priv->ieee80211->wq,
+				&priv->ieee80211->associate_procedure_wq);
 			}
-		}
-		priv->ieee80211->LinkDetectInfo.NumRecvBcnInPeriod=0;
-		priv->ieee80211->LinkDetectInfo.NumRecvDataInPeriod=0;
 	}
+		priv->ieee80211->LinkDetectInfo.NumRecvBcnInPeriod = 0;
+		priv->ieee80211->LinkDetectInfo.NumRecvDataInPeriod = 0;
 	/* CAM_read_entry(dev,4); */
 	/* check if reset the driver */
-	if(check_reset_cnt++ >= 3)
-	{
-    		ResetType = rtl819x_ifcheck_resetornot(dev);
+	if (check_reset_cnt++ >= 3) {
+		ResetType = rtl819x_ifcheck_resetornot(dev);
 		check_reset_cnt = 3;
 		/* DbgPrint("Start to check silent reset\n"); */
 	}
@@ -4429,12 +4362,18 @@ extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
 	 * priv->force_reset, priv->ResetProgress, priv->bForcedSilentReset,
 	 * priv->bDisableNormalResetCheck,ResetType);
 	 */
-	if( (priv->force_reset) || (priv->ResetProgress==RESET_TYPE_NORESET &&
-		(priv->bForcedSilentReset ||
-		(!priv->bDisableNormalResetCheck && ResetType==RESET_TYPE_SILENT))))
+	if ((priv->force_reset) || (priv->ResetProgress == RESET_TYPE_NORESET
+		&& (priv->bForcedSilentReset ||
+		(!priv->bDisableNormalResetCheck && ResetType ==
+		RESET_TYPE_SILENT))))
 		/*  This is control by OID set in Pomelo */
 	{
-		RT_TRACE(COMP_RESET,"%s():priv->force_reset is %d,priv->ResetProgress is %d, priv->bForcedSilentReset is %d,priv->bDisableNormalResetCheck is %d,ResetType is %d\n",__func__,priv->force_reset,priv->ResetProgress,priv->bForcedSilentReset,priv->bDisableNormalResetCheck,ResetType);
+		RT_TRACE(COMP_RESET, "%s():priv->force_reset is %d,"
+			"priv->ResetProgress is %d, priv->bForcedSilentReset"
+			" is %d,priv->bDisableNormalResetCheck is %d,ResetType"
+			" is %d\n", __func__, priv->force_reset,
+			priv->ResetProgress, priv->bForcedSilentReset,
+			priv->bDisableNormalResetCheck, ResetType);
 		rtl819x_ifsilentreset(dev);
 	}
 	priv->force_reset = false;
@@ -4448,32 +4387,33 @@ void watch_dog_timer_callback(unsigned long data)
 {
 	struct r8192_priv *priv = ieee80211_priv((struct net_device *) data);
 	/* printk("===============>watch_dog  timer\n"); */
-	queue_delayed_work(priv->priv_wq,&priv->watch_dog_wq, 0);
-	mod_timer(&priv->watch_dog_timer, jiffies + MSECS(IEEE80211_WATCH_DOG_TIME));
+	queue_delayed_work(priv->priv_wq, &priv->watch_dog_wq, 0);
+	mod_timer(&priv->watch_dog_timer, jiffies +
+			MSECS(IEEE80211_WATCH_DOG_TIME));
 }
 int _rtl8192_up(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	/* int i; */
 	int init_status = 0;
-	priv->up=1;
-	priv->ieee80211->ieee_up=1;
+	priv->up = 1;
+	priv->ieee80211->ieee_up = 1;
 	RT_TRACE(COMP_INIT, "Bringing up iface");
 	init_status = rtl8192_adapter_start(dev);
-	if(!init_status)
-	{
-		RT_TRACE(COMP_ERR,"ERR!!! %s(): initialization is failed!\n", __func__);
-		priv->up=priv->ieee80211->ieee_up = 0;
+	if (!init_status) {
+		RT_TRACE(COMP_ERR, "ERR!!! %s(): initialization is failed!\n",
+				__func__);
+		priv->up = priv->ieee80211->ieee_up = 0;
 		return -EAGAIN;
 	}
 	RT_TRACE(COMP_INIT, "start adapter finished\n");
 	rtl8192_rx_enable(dev);
 	/* rtl8192_tx_enable(dev); */
-	if(priv->ieee80211->state != IEEE80211_LINKED)
-	ieee80211_softmac_start_protocol(priv->ieee80211);
+	if (priv->ieee80211->state != IEEE80211_LINKED)
+		ieee80211_softmac_start_protocol(priv->ieee80211);
 	ieee80211_reset_queue(priv->ieee80211);
 	watch_dog_timer_callback((unsigned long) dev);
-	if(!netif_queue_stopped(dev))
+	if (!netif_queue_stopped(dev))
 		netif_start_queue(dev);
 	else
 		netif_wake_queue(dev);
@@ -4498,7 +4438,8 @@ int rtl8192_up(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	if (priv->up == 1) return -1;
+	if (priv->up == 1)
+		return -1;
 
 	return _rtl8192_up(dev);
 }
@@ -4524,9 +4465,10 @@ int rtl8192_down(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	int i;
 
-	if (priv->up == 0) return -1;
+	if (priv->up == 0)
+		return -1;
 
-	priv->up=0;
+	priv->up = 0;
 	priv->ieee80211->ieee_up = 0;
 	RT_TRACE(COMP_DOWN, "==========>%s()\n", __func__);
 	/* FIXME */
@@ -4537,16 +4479,12 @@ int rtl8192_down(struct net_device *dev)
 	/* rtl8192_irq_disable(dev); */
 
 	/* Tx related queue release */
-	for(i = 0; i < MAX_QUEUE_SIZE; i++) {
-		skb_queue_purge(&priv->ieee80211->skb_waitQ [i]);
-	}
-	for(i = 0; i < MAX_QUEUE_SIZE; i++) {
-		skb_queue_purge(&priv->ieee80211->skb_aggQ [i]);
-	}
-
-	for(i = 0; i < MAX_QUEUE_SIZE; i++) {
-		skb_queue_purge(&priv->ieee80211->skb_drv_aggQ [i]);
-	}
+	for (i = 0; i < MAX_QUEUE_SIZE; i++)
+		skb_queue_purge(&priv->ieee80211->skb_waitQ[i]);
+	for (i = 0; i < MAX_QUEUE_SIZE; i++)
+		skb_queue_purge(&priv->ieee80211->skb_aggQ[i]);
+	for (i = 0; i < MAX_QUEUE_SIZE; i++)
+		skb_queue_purge(&priv->ieee80211->skb_drv_aggQ[i]);
 
 	/* as cancel_delayed_work will del work->timer, so if work is not
 	 * defined as struct delayed_work, it will corrupt
@@ -4558,7 +4496,8 @@ int rtl8192_down(struct net_device *dev)
 
 
 	ieee80211_softmac_stop_protocol(priv->ieee80211);
-	memset(&priv->ieee80211->current_network, 0 , offsetof(struct ieee80211_network, list));
+	memset(&priv->ieee80211->current_network, 0,
+			offsetof(struct ieee80211_network, list));
 	RT_TRACE(COMP_DOWN, "<==========%s()\n", __func__);
 
 		return 0;
@@ -4570,7 +4509,8 @@ void rtl8192_commit(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	int reset_status = 0;
 	/* u8 reset_times = 0; */
-	if (priv->up == 0) return ;
+	if (priv->up == 0)
+		return ;
 	priv->up = 0;
 
 	rtl8192_cancel_deferred_work(priv);
@@ -4591,7 +4531,8 @@ void rtl8192_commit(struct net_device *dev)
  */
 void rtl8192_restart(struct work_struct *work)
 {
-	struct r8192_priv *priv = container_of(work, struct r8192_priv, reset_wq);
+	struct r8192_priv *priv = container_of(work, struct r8192_priv,
+						reset_wq);
 	struct net_device *dev = priv->ieee80211->dev;
 
 	down(&priv->wx_sem);
@@ -4610,7 +4551,7 @@ static void r8192_set_multicast(struct net_device *dev)
 
 	/* FIXME FIXME */
 
-	promisc = (dev->flags & IFF_PROMISC) ? 1:0;
+	promisc = (dev->flags & IFF_PROMISC) ? 1 : 0;
 
 	if (promisc != priv->promisc)
 		/* rtl8192_commit(dev); */
@@ -4642,10 +4583,10 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	struct iwreq *wrq = (struct iwreq *)rq;
-	int ret=-1;
+	int ret = -1;
 	struct ieee80211_device *ieee = priv->ieee80211;
 	u32 key[4];
-	u8 broadcast_addr[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
+	u8 broadcast_addr[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct iw_point *p = &wrq->u.data;
 	struct ieee_param *ipw = NULL;
 	/* (struct ieee_param *)wrq->u.data.pointer; */
@@ -4658,7 +4599,7 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	}
 
 	ipw = kmalloc(p->length, GFP_KERNEL);
-	if (ipw == NULL){
+	if (ipw == NULL) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4670,29 +4611,27 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 	switch (cmd) {
 	case RTL_IOCTL_WPA_SUPPLICANT:
-	/* parse here for HW security */
+		/* parse here for HW security */
 		if (ipw->cmd == IEEE_CMD_SET_ENCRYPTION) {
-			if (ipw->u.crypt.set_tx)
-			{
+			if (ipw->u.crypt.set_tx) {
 				if (strcmp(ipw->u.crypt.alg, "CCMP") == 0)
-						ieee->pairwise_key_type =
+					ieee->pairwise_key_type =
 								KEY_TYPE_CCMP;
 				else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0)
 					ieee->pairwise_key_type =
 								KEY_TYPE_TKIP;
-				else if (strcmp(ipw->u.crypt.alg, "WEP") == 0)
-					{
+				else if (strcmp(ipw->u.crypt.alg,
+							"WEP") == 0) {
 					if (ipw->u.crypt.key_len == 13)
 						ieee->pairwise_key_type =
 							KEY_TYPE_WEP104;
 					else if (ipw->u.crypt.key_len == 5)
 						ieee->pairwise_key_type =
 								KEY_TYPE_WEP40;
-				}
-				else
+				} else
 				ieee->pairwise_key_type = KEY_TYPE_NA;
 					if (ieee->pairwise_key_type) {
-						memcpy((u8*)key, ipw->
+						memcpy((u8 *)key, ipw->
 							u.crypt.key, 16);
 						EnableHWSecurityConfig8192
 									(dev);
@@ -4706,7 +4645,7 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 						setKey(dev, 4,
 							ipw->u.crypt.idx,
 							ieee->pairwise_key_type
-							, (u8*)ieee->
+							, (u8 *)ieee->
 							ap_mac_addr, 0, key);
 						if (ieee->auth_mode != 2)
 							setKey(dev, ipw->
@@ -4719,10 +4658,10 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 				} else {
 					/* if (ipw->u.crypt.idx) */
 					/* group key use idx > 0 */
-					memcpy((u8*)key, ipw->u.crypt.key, 16);
+					memcpy((u8 *)key, ipw->u.crypt.key, 16);
 					if (strcmp(ipw->u.crypt.alg, "CCMP")
 									== 0)
-						ieee->group_key_type=
+						ieee->group_key_type =
 								KEY_TYPE_CCMP;
 					else if (strcmp(ipw->u.crypt.alg,
 								"TKIP") == 0)
@@ -4767,7 +4706,7 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 								&wrq->u.data);
 		break;
 
-	    default:
+	default:
 		ret = -EOPNOTSUPP;
 		break;
 	}
@@ -4783,19 +4722,43 @@ u8 HwRateToMRate90(bool bIsHT, u8 rate)
 	u8  ret_rate = 0xff;
 
 	if (!bIsHT) {
-		switch(rate) {
-		case DESC90_RATE1M:   ret_rate = MGN_1M;         break;
-		case DESC90_RATE2M:   ret_rate = MGN_2M;         break;
-		case DESC90_RATE5_5M: ret_rate = MGN_5_5M;       break;
-		case DESC90_RATE11M:  ret_rate = MGN_11M;        break;
-		case DESC90_RATE6M:   ret_rate = MGN_6M;         break;
-		case DESC90_RATE9M:   ret_rate = MGN_9M;         break;
-		case DESC90_RATE12M:  ret_rate = MGN_12M;        break;
-		case DESC90_RATE18M:  ret_rate = MGN_18M;        break;
-		case DESC90_RATE24M:  ret_rate = MGN_24M;        break;
-		case DESC90_RATE36M:  ret_rate = MGN_36M;        break;
-		case DESC90_RATE48M:  ret_rate = MGN_48M;        break;
-		case DESC90_RATE54M:  ret_rate = MGN_54M;        break;
+		switch (rate) {
+		case DESC90_RATE1M:
+			ret_rate = MGN_1M;
+			break;
+		case DESC90_RATE2M:
+			ret_rate = MGN_2M;
+			break;
+		case DESC90_RATE5_5M:
+			ret_rate = MGN_5_5M;
+			break;
+		case DESC90_RATE11M:
+			ret_rate = MGN_11M;
+			break;
+		case DESC90_RATE6M:
+			ret_rate = MGN_6M;
+			break;
+		case DESC90_RATE9M:
+			ret_rate = MGN_9M;
+			break;
+		case DESC90_RATE12M:
+			ret_rate = MGN_12M;
+			break;
+		case DESC90_RATE18M:
+			ret_rate = MGN_18M;
+			break;
+		case DESC90_RATE24M:
+			ret_rate = MGN_24M;
+			break;
+		case DESC90_RATE36M:
+			ret_rate = MGN_36M;
+			break;
+		case DESC90_RATE48M:
+			ret_rate = MGN_48M;
+			break;
+		case DESC90_RATE54M:
+			ret_rate = MGN_54M;
+			break;
 		default:
 			ret_rate = 0xff;
 			RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported"
@@ -4803,28 +4766,62 @@ u8 HwRateToMRate90(bool bIsHT, u8 rate)
 			break;
 		}
 	} else {
-		switch(rate) {
-		case DESC90_RATEMCS0:   ret_rate = MGN_MCS0;    break;
-		case DESC90_RATEMCS1:   ret_rate = MGN_MCS1;    break;
-		case DESC90_RATEMCS2:   ret_rate = MGN_MCS2;    break;
-		case DESC90_RATEMCS3:   ret_rate = MGN_MCS3;    break;
-		case DESC90_RATEMCS4:   ret_rate = MGN_MCS4;    break;
-		case DESC90_RATEMCS5:   ret_rate = MGN_MCS5;    break;
-		case DESC90_RATEMCS6:   ret_rate = MGN_MCS6;    break;
-		case DESC90_RATEMCS7:   ret_rate = MGN_MCS7;    break;
-		case DESC90_RATEMCS8:   ret_rate = MGN_MCS8;    break;
-		case DESC90_RATEMCS9:   ret_rate = MGN_MCS9;    break;
-		case DESC90_RATEMCS10:  ret_rate = MGN_MCS10;   break;
-		case DESC90_RATEMCS11:  ret_rate = MGN_MCS11;   break;
-		case DESC90_RATEMCS12:  ret_rate = MGN_MCS12;   break;
-		case DESC90_RATEMCS13:  ret_rate = MGN_MCS13;   break;
-		case DESC90_RATEMCS14:  ret_rate = MGN_MCS14;   break;
-		case DESC90_RATEMCS15:  ret_rate = MGN_MCS15;   break;
-		case DESC90_RATEMCS32:  ret_rate = (0x80|0x20); break;
+		switch (rate) {
+		case DESC90_RATEMCS0:
+			ret_rate = MGN_MCS0;
+			break;
+		case DESC90_RATEMCS1:
+			ret_rate = MGN_MCS1;
+			break;
+		case DESC90_RATEMCS2:
+			ret_rate = MGN_MCS2;
+			break;
+		case DESC90_RATEMCS3:
+			ret_rate = MGN_MCS3;
+			break;
+		case DESC90_RATEMCS4:
+			ret_rate = MGN_MCS4;
+			break;
+		case DESC90_RATEMCS5:
+			ret_rate = MGN_MCS5;
+			break;
+		case DESC90_RATEMCS6:
+			ret_rate = MGN_MCS6;
+			break;
+		case DESC90_RATEMCS7:
+			ret_rate = MGN_MCS7;
+			break;
+		case DESC90_RATEMCS8:
+			ret_rate = MGN_MCS8;
+			break;
+		case DESC90_RATEMCS9:
+			ret_rate = MGN_MCS9;
+			break;
+		case DESC90_RATEMCS10:
+			ret_rate = MGN_MCS10;
+			break;
+		case DESC90_RATEMCS11:
+			ret_rate = MGN_MCS11;
+			break;
+		case DESC90_RATEMCS12:
+			ret_rate = MGN_MCS12;
+			break;
+		case DESC90_RATEMCS13:
+			ret_rate = MGN_MCS13;
+			break;
+		case DESC90_RATEMCS14:
+			ret_rate = MGN_MCS14;
+			break;
+		case DESC90_RATEMCS15:
+			ret_rate = MGN_MCS15;
+			break;
+		case DESC90_RATEMCS32:
+			ret_rate = (0x80|0x20);
+			break;
 		default:
 			ret_rate = 0xff;
 			RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported"
-				" Rate [%x], bIsHT = %d!!!\n",rate, bIsHT);
+				" Rate [%x], bIsHT = %d!!!\n", rate, bIsHT);
 			break;
 		}
 	}
@@ -4847,11 +4844,12 @@ u8 HwRateToMRate90(bool bIsHT, u8 rate)
  * Return:
  *               None
  */
-void UpdateRxPktTimeStamp8190 (struct net_device *dev, struct ieee80211_rx_stats *stats)
+void UpdateRxPktTimeStamp8190(struct net_device *dev,
+				struct ieee80211_rx_stats *stats)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 
-	if(stats->bIsAMPDU && !stats->bFirstMPDU) {
+	if (stats->bIsAMPDU && !stats->bFirstMPDU) {
 		stats->mac_time[0] = priv->LastRxDescTSFLow;
 		stats->mac_time[1] = priv->LastRxDescTSFHigh;
 	} else {
@@ -4862,7 +4860,7 @@ void UpdateRxPktTimeStamp8190 (struct net_device *dev, struct ieee80211_rx_stats
 
 /* by amy 080606 */
 
-long rtl819x_translate_todbm(u8 signal_strength_index	)/* 0-100 index. */
+long rtl819x_translate_todbm(u8 signal_strength_index)/* 0-100 index. */
 {
 	long	signal_power; /* in dBm. */
 
@@ -4879,22 +4877,25 @@ long rtl819x_translate_todbm(u8 signal_strength_index	)/* 0-100 index. */
  * value will be kept in memory or disk. We must delcare the value in adapter
  * and it will be reinitialized when return from S3/S4.
  */
-void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee80211_rx_stats * pprevious_stats, struct ieee80211_rx_stats * pcurrent_stats)
+void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
+				struct ieee80211_rx_stats *pprevious_stats,
+				struct ieee80211_rx_stats *pcurrent_stats)
 {
 	bool bcheck = false;
 	u8	rfpath;
 	u32	nspatial_stream, tmp_val;
 	/* u8	i; */
-	static u32 slide_rssi_index=0, slide_rssi_statistics=0;
-	static u32 slide_evm_index=0, slide_evm_statistics=0;
-	static u32 last_rssi=0, last_evm=0;
+	static u32 slide_rssi_index, slide_rssi_statistics;
+	static u32 slide_evm_index, slide_evm_statistics;
+	static u32 last_rssi, last_evm;
 
-	static u32 slide_beacon_adc_pwdb_index=0, slide_beacon_adc_pwdb_statistics=0;
-	static u32 last_beacon_adc_pwdb=0;
+	static u32 slide_beacon_adc_pwdb_index;
+	static u32 slide_beacon_adc_pwdb_statistics;
+	static u32 last_beacon_adc_pwdb;
 
 	struct ieee80211_hdr_3addr *hdr;
 	u16 sc ;
-	unsigned int frag,seq;
+	unsigned int frag, seq;
 	hdr = (struct ieee80211_hdr_3addr *)buffer;
 	sc = le16_to_cpu(hdr->seq_ctl);
 	frag = WLAN_GET_SEQ_FRAG(sc);
@@ -4904,25 +4905,20 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 
 	/* Check whether we should take the previous packet into accounting */
 
-	if(!pprevious_stats->bIsAMPDU)
-	{
+	if (!pprevious_stats->bIsAMPDU)
 		/* if previous packet is not aggregated packet */
 		bcheck = true;
-	}else
-	{
-	}
-
 
-	if(slide_rssi_statistics++ >= PHY_RSSI_SLID_WIN_MAX)
-	{
+	if (slide_rssi_statistics++ >= PHY_RSSI_SLID_WIN_MAX) {
 		slide_rssi_statistics = PHY_RSSI_SLID_WIN_MAX;
 		last_rssi = priv->stats.slide_signal_strength[slide_rssi_index];
 		priv->stats.slide_rssi_total -= last_rssi;
 	}
 	priv->stats.slide_rssi_total += pprevious_stats->SignalStrength;
 
-	priv->stats.slide_signal_strength[slide_rssi_index++] = pprevious_stats->SignalStrength;
-	if(slide_rssi_index >= PHY_RSSI_SLID_WIN_MAX)
+	priv->stats.slide_signal_strength[slide_rssi_index++] =
+					pprevious_stats->SignalStrength;
+	if (slide_rssi_index >= PHY_RSSI_SLID_WIN_MAX)
 		slide_rssi_index = 0;
 
 	/* <1> Showed on UI for user, in dbm */
@@ -4932,74 +4928,73 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 
 	/* If the previous packet does not match the criteria, neglect it */
 
-	if(!pprevious_stats->bPacketMatchBSSID)
-	{
-		if(!pprevious_stats->bToSelfBA)
+	if (!pprevious_stats->bPacketMatchBSSID) {
+		if (!pprevious_stats->bToSelfBA)
 			return;
 	}
-
-	if(!bcheck)
+	if (!bcheck)
 		return;
 
-
 	/* rtl8190_process_cck_rxpathsel(priv,pprevious_stats); */
 	/* only rtl8190 supported */
-
-
 	/* Check RSSI */
-
 	priv->stats.num_process_phyinfo++;
-
 	/* record the general signal strength to the sliding window. */
-
-
 	/* <2> Showed on UI for engineering */
 	/* hardware does not provide rssi information for each rf path
 	 *							 in CCK
 	 */
-	if(!pprevious_stats->bIsCCK && (pprevious_stats->bPacketToSelf || pprevious_stats->bToSelfBA))
-	{
-		for (rfpath = RF90_PATH_A; rfpath < priv->NumTotalRFPath; rfpath++)
-		{
-		     if (!rtl8192_phy_CheckIsLegalRFPath(priv->ieee80211->dev, rfpath))
-				 continue;
+	if (!pprevious_stats->bIsCCK && (pprevious_stats->bPacketToSelf ||
+					pprevious_stats->bToSelfBA)) {
+		for (rfpath = RF90_PATH_A; rfpath < priv->NumTotalRFPath;
+					rfpath++) {
+			if (!rtl8192_phy_CheckIsLegalRFPath(priv->ieee80211->dev,
+						rfpath))
+				continue;
 
 			/* Fixed by Jacken 2008-03-20 */
-			if(priv->stats.rx_rssi_percentage[rfpath] == 0)
-			{
-				priv->stats.rx_rssi_percentage[rfpath] = pprevious_stats->RxMIMOSignalStrength[rfpath];
-				/* DbgPrint("MIMO RSSI initialize \n"); */
-			}
-			if(pprevious_stats->RxMIMOSignalStrength[rfpath]  > priv->stats.rx_rssi_percentage[rfpath])
-			{
+			if (priv->stats.rx_rssi_percentage[rfpath] == 0) {
 				priv->stats.rx_rssi_percentage[rfpath] =
-					( (priv->stats.rx_rssi_percentage[rfpath]*(Rx_Smooth_Factor-1)) +
-					(pprevious_stats->RxMIMOSignalStrength[rfpath])) /(Rx_Smooth_Factor);
-				priv->stats.rx_rssi_percentage[rfpath] = priv->stats.rx_rssi_percentage[rfpath]  + 1;
+						pprevious_stats->
+						RxMIMOSignalStrength[rfpath];
+				/* DbgPrint("MIMO RSSI initialize\n"); */
 			}
-			else
-			{
+			if (pprevious_stats->RxMIMOSignalStrength[rfpath]  >
+					priv->stats.rx_rssi_percentage[rfpath]
+					) {
 				priv->stats.rx_rssi_percentage[rfpath] =
-					( (priv->stats.rx_rssi_percentage[rfpath]*(Rx_Smooth_Factor-1)) +
-					(pprevious_stats->RxMIMOSignalStrength[rfpath])) /(Rx_Smooth_Factor);
+					((priv->stats.rx_rssi_percentage[rfpath] *
+					(Rx_Smooth_Factor-1)) +	(pprevious_stats->
+					RxMIMOSignalStrength[rfpath])) /
+					(Rx_Smooth_Factor);
+				priv->stats.rx_rssi_percentage[rfpath] =
+					priv->stats.rx_rssi_percentage[rfpath]
+					+ 1;
+			} else {
+				priv->stats.rx_rssi_percentage[rfpath] =
+					((priv->stats.rx_rssi_percentage[rfpath] *
+						(Rx_Smooth_Factor-1)) +
+					(pprevious_stats->RxMIMOSignalStrength[rfpath]))
+						/(Rx_Smooth_Factor);
 			}
-			RT_TRACE(COMP_DBG,"priv->stats.rx_rssi_percentage[rfPath]  = %d \n" ,priv->stats.rx_rssi_percentage[rfpath] );
+			RT_TRACE(COMP_DBG, "priv->stats.rx_rssi_percentage[rfPath]"
+				"  = %d\n", priv->stats.rx_rssi_percentage[rfpath]);
 		}
 	}
 
 	/*  Check PWDB. */
 
 	RT_TRACE(COMP_RXDESC, "Smooth %s PWDB = %d\n",
-				pprevious_stats->bIsCCK? "CCK": "OFDM",
+				pprevious_stats->bIsCCK ? "CCK" : "OFDM",
 				pprevious_stats->RxPWDBAll);
 
-	if(pprevious_stats->bPacketBeacon)
-	{
+	if (pprevious_stats->bPacketBeacon) {
 		/* record the beacon pwdb to the sliding window. */
-		if(slide_beacon_adc_pwdb_statistics++ >= PHY_Beacon_RSSI_SLID_WIN_MAX)
-		{
+		if (slide_beacon_adc_pwdb_statistics++ >=
+					PHY_Beacon_RSSI_SLID_WIN_MAX) {
 			slide_beacon_adc_pwdb_statistics = PHY_Beacon_RSSI_SLID_WIN_MAX;
-			last_beacon_adc_pwdb = priv->stats.Slide_Beacon_pwdb[slide_beacon_adc_pwdb_index];
+			last_beacon_adc_pwdb =
+				priv->stats.Slide_Beacon_pwdb[slide_beacon_adc_pwdb_index];
 			priv->stats.Slide_Beacon_Total -= last_beacon_adc_pwdb;
 			/* DbgPrint("slide_beacon_adc_pwdb_index = %d, "
 			 *		"last_beacon_adc_pwdb = %d, Adapter->"
@@ -5010,7 +5005,8 @@ void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct ieee802
 			 */
 		}
 		priv->stats.Slide_Beacon_Total += pprevious_stats->RxPWDBAll;
-		priv->stats.Slide_Beacon_pwdb[slide_beacon_adc_pwdb_index] = pprevious_stats->RxPWDBAll;
+		priv->stats.Slide_Beacon_pwdb[slide_beacon_adc_pwdb_index] =
+					pprevious_stats->RxPWDBAll;
 		/* DbgPrint("slide_beacon_adc_pwdb_index = %d, pPreviousRfd->"
 		 *	"Status.RxPWDBAll = %d\n", slide_beacon_adc_pwdb_index,
 		 *			pPreviousRfd->Status.RxPWDBAll);
-- 
1.6.3.3


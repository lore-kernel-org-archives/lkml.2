Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab0D3Qxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:53:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47045 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab0D3Qxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:53:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CEaDUGeolqvfTWuhsDUMD/SpzM5+9fcrEVbHdQT9epra7PORI6/uZu/BA44JjsoQik
         axQrULUGri3fusuhT0/Hgo5DZgtYkpEwtZN2jmWZmW0V1+VPL32iPE0y2K0zv78LiLcT
         ofdFm5ZR5N2DyWRSr8oqV/fmAyCXZP9zzUnRY=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] Staging: arlan: fixed open brace style issue in arlan-main.c
Date: Fri, 30 Apr 2010 21:57:14 +0530
Message-Id: <1272644834-8093-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the arlan-main.c file that fixes up all the
open brace errors found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/arlan/arlan-main.c |  377 ++++++++++++------------------------
 1 files changed, 123 insertions(+), 254 deletions(-)

diff --git a/drivers/staging/arlan/arlan-main.c b/drivers/staging/arlan/arlan-main.c
index 6e8821d..943df89 100644
--- a/drivers/staging/arlan/arlan-main.c
+++ b/drivers/staging/arlan/arlan-main.c
@@ -126,12 +126,9 @@ static inline int arlan_drop_tx(struct net_device *dev)
 	struct arlan_private *priv = netdev_priv(dev);
 
 	dev->stats.tx_errors++;
-	if (priv->Conf->tx_delay_ms)
-	{
+	if (priv->Conf->tx_delay_ms) {
 		priv->tx_done_delayed = jiffies + priv->Conf->tx_delay_ms * HZ / 1000 + 1;
-	}
-	else
-	{
+	} else {
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_TX;
 		TXHEAD(dev).offset = 0;
 		TXTAIL(dev).offset = 0;
@@ -169,13 +166,11 @@ int arlan_command(struct net_device *dev, int command_p)
 		if (time_after(jiffies, priv->lastReset + 5 * HZ))
 			priv->waiting_command_mask &= ~ARLAN_COMMAND_RESET;
 
-	if (priv->waiting_command_mask & ARLAN_COMMAND_INT_ACK)
-	{
+	if (priv->waiting_command_mask & ARLAN_COMMAND_INT_ACK) {
 		arlan_interrupt_ack(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_INT_ACK;
 	}
-	if (priv->waiting_command_mask & ARLAN_COMMAND_INT_ENABLE)
-	{
+	if (priv->waiting_command_mask & ARLAN_COMMAND_INT_ENABLE) {
 		setInterruptEnable(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_INT_ENABLE;
 	}
@@ -185,10 +180,8 @@ int arlan_command(struct net_device *dev, int command_p)
 
 	/* Check cards status and waiting */
 
-	if (priv->waiting_command_mask & (ARLAN_COMMAND_LONG_WAIT_NOW | ARLAN_COMMAND_WAIT_NOW))
-	{
-		while (priv->waiting_command_mask & (ARLAN_COMMAND_LONG_WAIT_NOW | ARLAN_COMMAND_WAIT_NOW))
-		{
+	if (priv->waiting_command_mask & (ARLAN_COMMAND_LONG_WAIT_NOW | ARLAN_COMMAND_WAIT_NOW)) {
+		while (priv->waiting_command_mask & (ARLAN_COMMAND_LONG_WAIT_NOW | ARLAN_COMMAND_WAIT_NOW)) {
 			if (READSHMB(arlan->resetFlag) ||
 				READSHMB(arlan->commandByte))	/* ||
 								   (readControlRegister(dev) & ARLAN_ACCESS))
@@ -199,27 +192,20 @@ int arlan_command(struct net_device *dev, int command_p)
 
 			udelayed++;
 
-			if (priv->waiting_command_mask & ARLAN_COMMAND_LONG_WAIT_NOW)
-			{
-				if (udelayed * 40 > 1000000)
-				{
+			if (priv->waiting_command_mask & ARLAN_COMMAND_LONG_WAIT_NOW) {
+				if (udelayed * 40 > 1000000) {
 					printk(KERN_ERR "%s long wait too long \n", dev->name);
 					priv->waiting_command_mask |= ARLAN_COMMAND_RESET;
 					break;
 				}
-			}
-			else if (priv->waiting_command_mask & ARLAN_COMMAND_WAIT_NOW)
-			{
-				if (udelayed * 40 > 1000)
-				{
+			} else if (priv->waiting_command_mask & ARLAN_COMMAND_WAIT_NOW) {
+				if (udelayed * 40 > 1000) {
 					printk(KERN_ERR "%s short wait too long \n", dev->name);
 					goto bad_end;
 				}
 			}
 		}
-	}
-	else
-	{
+	} else {
 		i = 0;
 		while ((READSHMB(arlan->resetFlag) ||
 			READSHMB(arlan->commandByte)) &&
@@ -229,8 +215,7 @@ int arlan_command(struct net_device *dev, int command_p)
 
 		if ((READSHMB(arlan->resetFlag) ||
 			READSHMB(arlan->commandByte)) &&
-			!(priv->waiting_command_mask & ARLAN_COMMAND_RESET))
-		{
+			!(priv->waiting_command_mask & ARLAN_COMMAND_RESET)) {
 			goto card_busy_end;
 		}
 	}
@@ -241,52 +226,40 @@ int arlan_command(struct net_device *dev, int command_p)
 
 	/* Issuing command */
 	arlan_lock_card_access(dev);
-	if (priv->waiting_command_mask & ARLAN_COMMAND_POWERUP)
-	{
+	if (priv->waiting_command_mask & ARLAN_COMMAND_POWERUP) {
 	//     if (readControlRegister(dev) & (ARLAN_ACCESS && ARLAN_POWER))
 		setPowerOn(dev);
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_POWERUP;
 		priv->waiting_command_mask |= ARLAN_COMMAND_RESET;
 		priv->card_polling_interval = HZ / 10;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_ACTIVATE)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_ACTIVATE) {
 		WRITESHMB(arlan->commandByte, ARLAN_COM_ACTIVATE);
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_ACTIVATE;
 		priv->card_polling_interval = HZ / 10;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_RX_ABORT)
-	{
-		if (priv->rx_command_given)
-		{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_RX_ABORT) {
+		if (priv->rx_command_given) {
 			WRITESHMB(arlan->commandByte, ARLAN_COM_RX_ABORT);
 			arlan_interrupt_lancpu(dev);
 			priv->rx_command_given = 0;
 		}
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_RX_ABORT;
 		priv->card_polling_interval = 1;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_TX_ABORT)
-	{
-		if (priv->tx_command_given)
-		{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_TX_ABORT) {
+		if (priv->tx_command_given) {
 			WRITESHMB(arlan->commandByte, ARLAN_COM_TX_ABORT);
 			arlan_interrupt_lancpu(dev);
 			priv->tx_command_given = 0;
 		}
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_TX_ABORT;
 		priv->card_polling_interval = 1;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_RESET)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_RESET) {
 		priv->under_reset=1;
 		netif_stop_queue (dev);
 
 		arlan_drop_tx(dev);
-		if (priv->tx_command_given || priv->rx_command_given)
-		{
+		if (priv->tx_command_given || priv->rx_command_given) {
 			printk(KERN_ERR "%s: Reset under tx or rx command \n", dev->name);
 		}
 		netif_stop_queue (dev);
@@ -305,9 +278,7 @@ int arlan_command(struct net_device *dev, int command_p)
 		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RACK;
 //		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RENABLE;
 //		priv->waiting_command_mask |= ARLAN_COMMAND_RX;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_INT_RACK)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_INT_RACK) {
 		clearHardwareReset(dev);
 		clearClearInterrupt(dev);
 		setClearInterrupt(dev);
@@ -316,16 +287,11 @@ int arlan_command(struct net_device *dev, int command_p)
 		priv->waiting_command_mask |= ARLAN_COMMAND_CONF;
 		priv->under_config = 1;
 		priv->under_reset = 0;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_INT_RENABLE)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_INT_RENABLE) {
 		setInterruptEnable(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_INT_RENABLE;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF)
-	{
-		if (priv->tx_command_given || priv->rx_command_given)
-		{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF) {
+		if (priv->tx_command_given || priv->rx_command_given) {
 			printk(KERN_ERR "%s: Reset under tx or rx command \n", dev->name);
 		}
 		arlan_drop_tx(dev);
@@ -337,30 +303,22 @@ int arlan_command(struct net_device *dev, int command_p)
 //		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RACK;
 //		priv->waiting_command_mask |= ARLAN_COMMAND_INT_ENABLE;
 		priv->waiting_command_mask |= ARLAN_COMMAND_CONF_WAIT;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF_WAIT)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF_WAIT) {
 		if (READSHMB(arlan->configuredStatusFlag) != 0 &&
-			READSHMB(arlan->diagnosticInfo) == 0xff)
-		{
+			READSHMB(arlan->diagnosticInfo) == 0xff) {
 			priv->waiting_command_mask &= ~ARLAN_COMMAND_CONF_WAIT;
 			priv->waiting_command_mask |= ARLAN_COMMAND_RX;
 			priv->waiting_command_mask |= ARLAN_COMMAND_TBUSY_CLEAR;
 			priv->card_polling_interval = HZ / 10;
 			priv->tx_command_given = 0;
 			priv->under_config = 0;
-		}
-		else
-		{
+		} else {
 			priv->card_polling_interval = 1;
 			if (arlan_debug & ARLAN_DEBUG_TIMING)
 				printk(KERN_ERR "configure delayed \n");
 		}
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_RX)
-	{
-		if (!registrationBad(dev))
-		{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_RX) {
+		if (!registrationBad(dev)) {
 			setInterruptEnable(dev);
 			memset_io(arlan->commandParameter, 0, 0xf);
 			WRITESHMB(arlan->commandByte, ARLAN_COM_INT | ARLAN_COM_RX_ENABLE);
@@ -369,28 +327,20 @@ int arlan_command(struct net_device *dev, int command_p)
 			priv->rx_command_given = 0; // mnjah, bad
 			priv->waiting_command_mask &= ~ARLAN_COMMAND_RX;
 			priv->card_polling_interval = 1;
-		}
-		else
+		} else
 			priv->card_polling_interval = 2;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_TBUSY_CLEAR)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_TBUSY_CLEAR) {
 		if ( !registrationBad(dev) &&
-		     (netif_queue_stopped(dev) || !netif_running(dev)) )
-			{
+		     (netif_queue_stopped(dev) || !netif_running(dev)) ) {
 				priv->waiting_command_mask &= ~ARLAN_COMMAND_TBUSY_CLEAR;
 				netif_wake_queue (dev);
 			}
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_TX)
-	{
-		if (!test_and_set_bit(0, (void *) &priv->tx_command_given))
-		{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_TX) {
+		if (!test_and_set_bit(0, (void *) &priv->tx_command_given)) {
 			if (time_after(jiffies,
 				       priv->tx_last_sent + us2ticks(conf->rx_tweak1))
 			    || time_before(jiffies,
-					   priv->last_rx_int_ack_time + us2ticks(conf->rx_tweak2)))
-			{
+					   priv->last_rx_int_ack_time + us2ticks(conf->rx_tweak2))) {
 				setInterruptEnable(dev);
 				memset_io(arlan->commandParameter, 0, 0xf);
 				WRITESHMB(arlan->commandByte, ARLAN_COM_TX_ENABLE | ARLAN_COM_INT);
@@ -401,41 +351,30 @@ int arlan_command(struct net_device *dev, int command_p)
 				priv->tx_command_given = 1;
 				priv->waiting_command_mask &= ~ARLAN_COMMAND_TX;
 				priv->card_polling_interval = 1;
-			}
-			else
-			{
+			} else {
 				priv->tx_command_given = 0;
 				priv->card_polling_interval = 1;
 			}
-		}
-		else if (arlan_debug & ARLAN_DEBUG_CHAIN_LOCKS)
+		} else if (arlan_debug & ARLAN_DEBUG_CHAIN_LOCKS)
 			printk(KERN_ERR "tx command when tx chain locked \n");
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_NOOPINT)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_NOOPINT) {
 		{
 			WRITESHMB(arlan->commandByte, ARLAN_COM_NOP | ARLAN_COM_INT);
 		}
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_NOOPINT;
 		priv->card_polling_interval = HZ / 3;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_NOOP)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_NOOP) {
 		WRITESHMB(arlan->commandByte, ARLAN_COM_NOP);
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_NOOP;
 		priv->card_polling_interval = HZ / 3;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_SLOW_POLL)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_SLOW_POLL) {
 		WRITESHMB(arlan->commandByte, ARLAN_COM_GOTO_SLOW_POLL);
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_SLOW_POLL;
 		priv->card_polling_interval = HZ / 3;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_POWERDOWN)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_POWERDOWN) {
 		setPowerOff(dev);
 		if (arlan_debug & ARLAN_DEBUG_CARD_STATE)
 			printk(KERN_WARNING "%s: Arlan Going Standby\n", dev->name);
@@ -478,10 +417,8 @@ static inline void arlan_command_process(struct net_device *dev)
 	struct arlan_private *priv = netdev_priv(dev);
 
 	int times = 0;
-	while (priv->waiting_command_mask && times < 8)
-	{
-		if (priv->waiting_command_mask)
-		{
+	while (priv->waiting_command_mask && times < 8) {
+		if (priv->waiting_command_mask) {
 			if (arlan_command(dev, 0))
 				break;
 			times++;
@@ -500,20 +437,15 @@ static inline void arlan_retransmit_now(struct net_device *dev)
 
 
 	ARLAN_DEBUG_ENTRY("arlan_retransmit_now");
-	if (TXLAST(dev).offset == 0)
-	{
-		if (TXHEAD(dev).offset)
-		{
+	if (TXLAST(dev).offset == 0) {
+		if (TXHEAD(dev).offset) {
 			priv->txLast = 0;
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk(KERN_DEBUG "TX buff switch to head \n");
 
-		}
-		else if (TXTAIL(dev).offset)
-		{
+		} else if (TXTAIL(dev).offset) {
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk(KERN_DEBUG "TX buff switch to tail \n");
 			priv->txLast = 1;
-		}
-		else
+		} else
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk(KERN_ERR "ReTransmit buff empty");
 		netif_wake_queue (dev);
 		return;
@@ -540,11 +472,9 @@ static void arlan_registration_timer(unsigned long data)
 	long lostTime = ((long)jiffies - (long)priv->registrationLastSeen)
 			* (1000/HZ);
 
-	if (registrationBad(dev))
-	{
+	if (registrationBad(dev)) {
 		priv->registrationLostCount++;
-		if (lostTime > 7000 && lostTime < 7200)
-		{
+		if (lostTime > 7000 && lostTime < 7200) {
 			printk(KERN_NOTICE "%s registration Lost \n", dev->name);
 		}
 		if (lostTime / priv->reRegisterExp > 2000)
@@ -553,17 +483,13 @@ static void arlan_registration_timer(unsigned long data)
 			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);
 		if (priv->reRegisterExp < 400)
 			priv->reRegisterExp += 2;
-		if (lostTime > 7200)
-		{
+		if (lostTime > 7200) {
 			next_tick = HZ;
 			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);
 		}
-	}
-	else
-	{
+	} else {
 		if (priv->Conf->registrationMode && lostTime > 10000 &&
-			priv->registrationLostCount)
-		{
+			priv->registrationLostCount) {
 			printk(KERN_NOTICE "%s registration is back after %ld milliseconds\n",
 			       dev->name, lostTime);
 		}
@@ -573,15 +499,14 @@ static void arlan_registration_timer(unsigned long data)
 		if (!netif_running(dev) )
 			netif_wake_queue(dev);
 		if (time_after(priv->tx_last_sent,priv->tx_last_cleared) &&
-		    time_after(jiffies, priv->tx_last_sent * 5*HZ) ){
+		    time_after(jiffies, priv->tx_last_sent * 5*HZ) ) {
 			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);
 			priv->tx_last_cleared = jiffies;
 		}
 	}
 
 
-	if (!registrationBad(dev) && priv->ReTransmitRequested)
-	{
+	if (!registrationBad(dev) && priv->ReTransmitRequested) {
 		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 			printk(KERN_ERR "Retransmit from timer \n");
 		priv->ReTransmitRequested = 0;
@@ -589,27 +514,23 @@ static void arlan_registration_timer(unsigned long data)
 	}
 	if (!registrationBad(dev) &&
 		time_after(jiffies, priv->tx_done_delayed) &&
-		priv->tx_done_delayed != 0)
-	{
+		priv->tx_done_delayed != 0) {
 		TXLAST(dev).offset = 0;
 		if (priv->txLast)
 			priv->txLast = 0;
 		else if (TXTAIL(dev).offset)
 			priv->txLast = 1;
-		if (TXLAST(dev).offset)
-		{
+		if (TXLAST(dev).offset) {
 			arlan_retransmit_now(dev);
 			dev->trans_start = jiffies;
 		}
-		if (!(TXHEAD(dev).offset && TXTAIL(dev).offset))
-		{
+		if (!(TXHEAD(dev).offset && TXTAIL(dev).offset)) {
 			netif_wake_queue (dev);
 		}
 		priv->tx_done_delayed = 0;
 		bh_mark_needed = 1;
 	}
-	if (bh_mark_needed)
-	{
+	if (bh_mark_needed) {
 		netif_wake_queue (dev);
 	}
 	arlan_process_interrupt(dev);
@@ -672,8 +593,7 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 		tailStarts = 0x800 - (((TXTAIL(dev).offset - offsetof(struct arlan_shmem, txBuffer)) / 64) + 2) * 64;
 
 
-	if (!TXHEAD(dev).offset && length < tailStarts)
-	{
+	if (!TXHEAD(dev).offset && length < tailStarts) {
 		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 			printk(KERN_ERR "TXHEAD insert, tailStart %d\n", tailStarts);
 
@@ -687,9 +607,7 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 		TXHEAD(dev).routing = conf->txRouting;
 		TXHEAD(dev).scrambled = conf->txScrambled;
 		memcpy_toio((char __iomem *)arlan + TXHEAD(dev).offset, buf + ARLAN_FAKE_HDR_LEN, TXHEAD(dev).length);
-	}
-	else if (!TXTAIL(dev).offset && length < (0x800 - headEnds))
-	{
+	} else if (!TXTAIL(dev).offset && length < (0x800 - headEnds)) {
 		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 			printk(KERN_ERR "TXTAIL insert, headEnd %d\n", headEnds);
 
@@ -703,9 +621,7 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 		TXTAIL(dev).routing = conf->txRouting;
 		TXTAIL(dev).scrambled = conf->txScrambled;
 		memcpy_toio(((char __iomem *)arlan + TXTAIL(dev).offset), buf + ARLAN_FAKE_HDR_LEN, TXTAIL(dev).length);
-	}
-	else
-	{
+	} else {
 		netif_stop_queue (dev);
 		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 			printk(KERN_ERR "TX TAIL & HEAD full, return, tailStart %d headEnd %d\n", tailStarts, headEnds);
@@ -715,20 +631,17 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 	priv->out_bytes10 += length;
 	if (conf->measure_rate < 1)
 		conf->measure_rate = 1;
-	if (time_after(jiffies, priv->out_time + conf->measure_rate * HZ))
-	{
+	if (time_after(jiffies, priv->out_time + conf->measure_rate * HZ)) {
 		conf->out_speed = priv->out_bytes / conf->measure_rate;
 		priv->out_bytes = 0;
 		priv->out_time = jiffies;
 	}
-	if (time_after(jiffies, priv->out_time10 + conf->measure_rate * 10*HZ))
-	{
+	if (time_after(jiffies, priv->out_time10 + conf->measure_rate * 10*HZ)) {
 		conf->out_speed10 = priv->out_bytes10 / (10 * conf->measure_rate);
 		priv->out_bytes10 = 0;
 		priv->out_time10 = jiffies;
 	}
-	if (TXHEAD(dev).offset && TXTAIL(dev).offset)
-	{
+	if (TXHEAD(dev).offset && TXTAIL(dev).offset) {
 		netif_stop_queue (dev);
 		return 0;
 	}
@@ -817,8 +730,7 @@ static int arlan_hw_config(struct net_device *dev)
 	WRITESHMB(arlan->commandByte, ARLAN_COM_INT | ARLAN_COM_CONF);	/* do configure */
 	memset_io(arlan->commandParameter, 0, 0xf);	/* 0xf */
 	memset_io(arlan->commandParameter + 1, 0, 2);
-	if (conf->writeEEPROM)
-	{
+	if (conf->writeEEPROM) {
 		  memset_io(arlan->commandParameter, conf->writeEEPROM, 1);
 //		conf->writeEEPROM=0;
 	}
@@ -847,46 +759,39 @@ static int arlan_read_card_configuration(struct net_device *dev)
 
 	ARLAN_DEBUG_ENTRY("arlan_read_card_configuration");
 
-	if (radioNodeId == radioNodeIdUNKNOWN)
-	{
+	if (radioNodeId == radioNodeIdUNKNOWN) {
 		READSHM(conf->radioNodeId, arlan->radioNodeId, u_short);
 	}
 	else
 		conf->radioNodeId = radioNodeId;
 
-	if (SID == SIDUNKNOWN)
-	{
+	if (SID == SIDUNKNOWN) {
 		READSHM(conf->SID, arlan->SID, u_int);
-	}
-	else conf->SID = SID;
+	} else
+		conf->SID = SID;
 
-	if (spreadingCode == spreadingCodeUNKNOWN)
-	{
+	if (spreadingCode == spreadingCodeUNKNOWN) {
 		  READSHM(conf->spreadingCode, arlan->spreadingCode, u_char);
-	}
-	else
+	} else
 		conf->spreadingCode = spreadingCode;
 
-	if (channelSet == channelSetUNKNOWN)
-	{
+	if (channelSet == channelSetUNKNOWN) {
 		READSHM(conf->channelSet, arlan->channelSet, u_char);
-	}
-	else conf->channelSet = channelSet;
+	} else
+		conf->channelSet = channelSet;
 
-	if (channelNumber == channelNumberUNKNOWN)
-	{
+	if (channelNumber == channelNumberUNKNOWN) {
 		READSHM(conf->channelNumber, arlan->channelNumber, u_char);
-	}
-	else conf->channelNumber = channelNumber;
+	} else
+		conf->channelNumber = channelNumber;
 
 	READSHM(conf->scramblingDisable, arlan->scramblingDisable, u_char);
 	READSHM(conf->txAttenuation, arlan->txAttenuation, u_char);
 
-	if (systemId == systemIdUNKNOWN)
-	{
+	if (systemId == systemIdUNKNOWN) {
 		READSHM(conf->systemId, arlan->systemId, u_int);
-	}
-	else conf->systemId = systemId;
+	} else
+		conf->systemId = systemId;
 
 	READSHM(conf->maxDatagramSize, arlan->maxDatagramSize, u_short);
 	READSHM(conf->maxFrameSize, arlan->maxFrameSize, u_short);
@@ -895,17 +800,15 @@ static int arlan_read_card_configuration(struct net_device *dev)
 	READSHM(conf->priority, arlan->priority, u_char);
 	READSHM(conf->rootOrRepeater, arlan->rootOrRepeater, u_char);
 
-	if (SID == SIDUNKNOWN)
-	{
+	if (SID == SIDUNKNOWN) {
 		  READSHM(conf->SID, arlan->SID, u_int);
-	}
-	else conf->SID = SID;
+	} else
+		conf->SID = SID;
 
-	if (registrationMode == registrationModeUNKNOWN)
-	{
+	if (registrationMode == registrationModeUNKNOWN) {
 		  READSHM(conf->registrationMode, arlan->registrationMode, u_char);
-	}
-	else conf->registrationMode = registrationMode;
+	} else
+		conf->registrationMode = registrationMode;
 
 	READSHM(conf->registrationFill, arlan->registrationFill, u_char);
 	READSHM(conf->localTalkAddress, arlan->localTalkAddress, u_char);
@@ -981,7 +884,7 @@ static int __init arlan_check_fingerprint(unsigned long memaddr)
 	tempBuf[30] = 0;
 
 	/* check for card at this address */
-	if (0 != strncmp(tempBuf, probeText, 29)){
+	if (0 != strncmp(tempBuf, probeText, 29)) {
  		release_mem_region(paddr, ARLAN_SHMEM_SIZE);
 		return -ENODEV;
 	}
@@ -1092,8 +995,7 @@ static int __init arlan_probe_here(struct net_device *dev,
 	dev->mem_start = memaddr;
 	dev->mem_end = memaddr + ARLAN_SHMEM_SIZE-1;
 
-	if (dev->irq < 2)
-	{
+	if (dev->irq < 2) {
 		READSHM(dev->irq, ap->card->irqLevel, u_char);
 	} else if (dev->irq == 2)
 		dev->irq = 9;
@@ -1114,8 +1016,7 @@ static int arlan_open(struct net_device *dev)
 	ARLAN_DEBUG_ENTRY("arlan_open");
 
 	ret = request_irq(dev->irq, &arlan_interrupt, 0, dev->name, dev);
-	if (ret)
-	{
+	if (ret) {
 		printk(KERN_ERR "%s: unable to get IRQ %d .\n",
 			dev->name, dev->irq);
 		return ret;
@@ -1228,8 +1129,7 @@ static inline void arlan_queue_retransmit(struct net_device *dev)
 
 	ARLAN_DEBUG_ENTRY("arlan_queue_retransmit");
 
-	if (DoNotWaitReTransmitCrap(dev))
-	{
+	if (DoNotWaitReTransmitCrap(dev)) {
 		  arlan_drop_tx(dev);
 	} else
 		priv->ReTransmitRequested++;
@@ -1244,15 +1144,13 @@ static inline void RetryOrFail(struct net_device *dev)
 	ARLAN_DEBUG_ENTRY("RetryOrFail");
 
 	if (priv->retransmissions > priv->Conf->retries ||
-	    DoNotReTransmitCrap(dev))
-	{
+	    DoNotReTransmitCrap(dev)) {
 		arlan_drop_tx(dev);
 	}
-	else if (priv->bad <= priv->Conf->fastReTransCount)
-	{
+	else if (priv->bad <= priv->Conf->fastReTransCount) {
 		arlan_retransmit_now(dev);
-	}
-	else arlan_queue_retransmit(dev);
+	} else
+		arlan_queue_retransmit(dev);
 
 	ARLAN_DEBUG_EXIT("RetryOrFail");
 }
@@ -1266,8 +1164,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 
 	priv->tx_last_cleared = jiffies;
 	priv->tx_command_given = 0;
-	switch (status)
-	{
+	switch (status) {
 		case 1:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
@@ -1276,24 +1173,19 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 			priv->bad = 0;
 			priv->reset = 0;
 			priv->retransmissions = 0;
-			if (priv->Conf->tx_delay_ms)
-			{
+			if (priv->Conf->tx_delay_ms) {
 				priv->tx_done_delayed = jiffies + (priv->Conf->tx_delay_ms * HZ) / 1000 + 1;
-			}
-			else
-			{
+			} else {
 				TXLAST(dev).offset = 0;
 				if (priv->txLast)
 					priv->txLast = 0;
 				else if (TXTAIL(dev).offset)
 					priv->txLast = 1;
-				if (TXLAST(dev).offset)
-				{
+				if (TXLAST(dev).offset) {
 					arlan_retransmit_now(dev);
 					dev->trans_start = jiffies;
 				}
-				if (!TXHEAD(dev).offset || !TXTAIL(dev).offset)
-				{
+				if (!TXHEAD(dev).offset || !TXTAIL(dev).offset) {
 					netif_wake_queue (dev);
 				}
 			}
@@ -1411,13 +1303,11 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 	// by spec,   not                WRITESHMB(arlan->rxStatus,0x00);
 	// prohibited here              arlan_command(dev, ARLAN_COMMAND_RX);
 
-	if (pkt_len < 10 || pkt_len > 2048)
-	{
+	if (pkt_len < 10 || pkt_len > 2048) {
 		printk(KERN_WARNING "%s: got too short or long packet, len %d \n", dev->name, pkt_len);
 		return;
 	}
-	if (rxOffset + pkt_len > 0x2000)
-	{
+	if (rxOffset + pkt_len > 0x2000) {
 		printk("%s: got too long packet, len %d offset %x\n", dev->name, pkt_len, rxOffset);
 		return;
 	}
@@ -1425,21 +1315,18 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 	priv->in_bytes10 += pkt_len;
 	if (conf->measure_rate < 1)
 		conf->measure_rate = 1;
-	if (time_after(jiffies, priv->in_time + conf->measure_rate * HZ))
-	{
+	if (time_after(jiffies, priv->in_time + conf->measure_rate * HZ)) {
 		conf->in_speed = priv->in_bytes / conf->measure_rate;
 		priv->in_bytes = 0;
 		priv->in_time = jiffies;
 	}
-	if (time_after(jiffies, priv->in_time10 + conf->measure_rate * 10*HZ))
-	{
+	if (time_after(jiffies, priv->in_time10 + conf->measure_rate * 10*HZ)) {
 		conf->in_speed10 = priv->in_bytes10 / (10 * conf->measure_rate);
 		priv->in_bytes10 = 0;
 		priv->in_time10 = jiffies;
 	}
 	DEBUGSHM(1, "arlan rcv pkt rxStatus= %d ", arlan->rxStatus, u_char);
-	switch (rxStatus)
-	{
+	switch (rxStatus) {
 		case 1:
 		case 2:
 		case 3:
@@ -1455,15 +1342,13 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 #ifdef ARLAN_MULTICAST
 			if (!(dev->flags & IFF_ALLMULTI) &&
 				!(dev->flags & IFF_PROMISC) &&
-				!netdev_mc_empty(dev))
-			{
+				!netdev_mc_empty(dev)) {
 				char hw_dst_addr[6];
 				struct dev_mc_list *dmi;
 				int i;
 
 				memcpy_fromio(hw_dst_addr, arlan->ultimateDestAddress, 6);
-				if (hw_dst_addr[0] == 0x01)
-				{
+				if (hw_dst_addr[0] == 0x01) {
 					if (mdebug)
 						if (hw_dst_addr[1] == 0x00)
 							printk(KERN_ERR "%s mcast 0x0100 \n", dev->name);
@@ -1489,8 +1374,7 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 			pkt_len += ARLAN_FAKE_HDR_LEN;
 
 			skb = dev_alloc_skb(pkt_len + 4);
-			if (skb == NULL)
-			{
+			if (skb == NULL) {
 				printk(KERN_ERR "%s: Memory squeeze, dropping packet.\n", dev->name);
 				dev->stats.rx_dropped++;
 				break;
@@ -1519,8 +1403,7 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 			}
 			skb->protocol = eth_type_trans(skb, dev);
 			IFDEBUG(ARLAN_DEBUG_HEADER_DUMP)
-				if (skb->protocol != 0x608 && skb->protocol != 0x8)
-				{
+				if (skb->protocol != 0x608 && skb->protocol != 0x8) {
 					for (i = 0; i <= 22; i++)
 						printk("%02x:", (u_char) skbtmp[i + 12]);
 					printk(KERN_ERR "\n");
@@ -1552,15 +1435,13 @@ static void arlan_process_interrupt(struct net_device *dev)
 
 	ARLAN_DEBUG_ENTRY("arlan_process_interrupt");
 
-	if (test_and_set_bit(0, (void *) &priv->interrupt_processing_active))
-	{
+	if (test_and_set_bit(0, (void *) &priv->interrupt_processing_active)) {
 		if (arlan_debug & ARLAN_DEBUG_CHAIN_LOCKS)
 			printk(KERN_ERR "interrupt chain reentering \n");
 		goto end_int_process;
 	}
 	while ((rxStatus || txStatus || priv->interrupt_ack_requested)
-			&& (interrupt_count < 5))
-	{
+			&& (interrupt_count < 5)) {
 		if (rxStatus)
 			priv->last_rx_int_ack_time = jiffies;
 
@@ -1572,10 +1453,8 @@ static void arlan_process_interrupt(struct net_device *dev)
 					dev->name, rxStatus, txStatus, READSHMB(arlan->commandByte),
 					rxOffset, pkt_len);
 
-		if (rxStatus == 0 && txStatus == 0)
-		{
-			if (priv->irq_test_done)
-			{
+		if (rxStatus == 0 && txStatus == 0) {
+			if (priv->irq_test_done) {
 				if (!registrationBad(dev))
 					IFDEBUG(ARLAN_DEBUG_INTERRUPT) printk(KERN_ERR "%s unknown interrupt(nop? regLost ?) reason tx %d rx %d ",
 										    dev->name, txStatus, rxStatus);
@@ -1587,32 +1466,28 @@ static void arlan_process_interrupt(struct net_device *dev)
 			priv->interrupt_ack_requested = 0;
 			goto ends;
 		}
-		if (txStatus != 0)
-		{
+		if (txStatus != 0) {
 			WRITESHMB(arlan->txStatus, 0x00);
 			arlan_tx_done_interrupt(dev, txStatus);
 			goto ends;
 		}
-		if (rxStatus == 1 || rxStatus == 2)
-		{		/* a packet waiting */
+		if (rxStatus == 1 || rxStatus == 2) {
+			/* a packet waiting */
 			arlan_rx_interrupt(dev, rxStatus, rxOffset, pkt_len);
 			goto ends;
 		}
-		if (rxStatus > 2 && rxStatus < 0xff)
-		{
+		if (rxStatus > 2 && rxStatus < 0xff) {
 			WRITESHMB(arlan->rxStatus, 0x00);
 			printk(KERN_ERR "%s unknown rxStatus reason tx %d rx %d ",
 				dev->name, txStatus, rxStatus);
 			goto ends;
 		}
-		if (rxStatus == 0xff)
-		{
+		if (rxStatus == 0xff) {
 			WRITESHMB(arlan->rxStatus, 0x00);
 			arlan_command(dev, ARLAN_COMMAND_RX);
 			if (registrationBad(dev))
 				netif_device_detach(dev);
-			if (!registrationBad(dev))
-			{
+			if (!registrationBad(dev)) {
 				priv->registrationLastSeen = jiffies;
 				if (!netif_queue_stopped(dev) && !priv->under_reset && !priv->under_config)
 					netif_wake_queue (dev);
@@ -1740,16 +1615,13 @@ static void arlan_set_multicast(struct net_device *dev)
 
 	ARLAN_DEBUG_ENTRY("arlan_set_multicast");
 
-	if (dev->flags & IFF_PROMISC)
-	{
+	if (dev->flags & IFF_PROMISC) {
 		unsigned char recMode;
 		READSHM(recMode, arlan->receiveMode, u_char);
 		conf->receiveMode = (ARLAN_RCV_PROMISC | ARLAN_RCV_CONTROL);
 		if (conf->receiveMode != recMode)
 			board_conf_needed = 1;
-	}
-	else
-	{
+	} else {
 		/* turn off promiscuous mode  */
 		unsigned char recMode;
 		READSHM(recMode, arlan->receiveMode, u_char);
@@ -1799,10 +1671,8 @@ struct net_device * __init arlan_probe(int unit)
 
 	for (m = (int)phys_to_virt(lastFoundAt) + ARLAN_SHMEM_SIZE;
 	     m <= (int)phys_to_virt(0xDE000);
-	     m += ARLAN_SHMEM_SIZE)
-	{
-		if (arlan_probe_here(dev, m) == 0)
-		{
+	     m += ARLAN_SHMEM_SIZE) {
+		if (arlan_probe_here(dev, m) == 0) {
 			lastFoundAt = (int)virt_to_phys((void*)m);
 			goto found;
 		}
@@ -1860,8 +1730,7 @@ void __exit cleanup_module(void)
 
 	cleanup_arlan_proc();
 
-	for (i = 0; i < MAX_ARLANS; i++)
-	{
+	for (i = 0; i < MAX_ARLANS; i++) {
 		dev = arlan_device[i];
 		if (dev) {
 			arlan_command(dev, ARLAN_COMMAND_POWERDOWN );
-- 
1.6.0.4


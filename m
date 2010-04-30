Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab0D3TU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:20:57 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:39776 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab0D3QxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Jycl74K/sMYUFMRKWk/28V1yGcBesIp6WGlNlpYDgwOA2/GAO5BMDfZi+dCsJHcX2x
         7Pcwe0/4/Z55ZRPXCOjZx5B0r+Spk6Qr548I9Hyz0Tz8d/ig9QLrwS5U/hVUTxUSPx4P
         l7VMuovwfQTmRxuN2PLeGu2qj6jqTj3j0PZJY=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] Staging: arlan: fixed miscellaneous style issue in arlan-main.c
Date: Fri, 30 Apr 2010 21:59:07 +0530
Message-Id: <1272644947-8168-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the arlan-main.c file that fixes many miscellaneous
style issues found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/arlan/arlan-main.c |  131 +++++++++++++++++-------------------
 1 files changed, 61 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/arlan/arlan-main.c b/drivers/staging/arlan/arlan-main.c
index 2b39768..5174988 100644
--- a/drivers/staging/arlan/arlan-main.c
+++ b/drivers/staging/arlan/arlan-main.c
@@ -83,11 +83,11 @@ static int	arlan_close(struct net_device *dev);
 static struct net_device_stats *
 		arlan_statistics(struct net_device *dev);
 static void	arlan_set_multicast(struct net_device *dev);
-static int	arlan_hw_tx(struct net_device* dev, char *buf, int length);
-static int	arlan_hw_config(struct net_device * dev);
-static void	arlan_tx_done_interrupt(struct net_device * dev, int status);
-static void	arlan_rx_interrupt(struct net_device * dev, u_char rxStatus, u_short, u_short);
-static void	arlan_process_interrupt(struct net_device * dev);
+static int	arlan_hw_tx(struct net_device *dev, char *buf, int length);
+static int	arlan_hw_config(struct net_device *dev);
+static void	arlan_tx_done_interrupt(struct net_device *dev, int status);
+static void	arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short, u_short);
+static void	arlan_process_interrupt(struct net_device *dev);
 static void	arlan_tx_timeout(struct net_device *dev);
 
 static inline long us2ticks(int us)
@@ -102,14 +102,14 @@ static inline long us2ticks(int us)
 	struct timeval timev;\
 	do_gettimeofday(&timev);\
 		if (arlan_entry_debug || arlan_entry_and_exit_debug)\
-			printk("--->>>" name " %ld " "\n",((long int) timev.tv_sec * 1000000 + timev.tv_usec));\
+			printk("--->>>" name " %ld " "\n", ((long int) timev.tv_sec * 1000000 + timev.tv_usec));\
 	}
 #define ARLAN_DEBUG_EXIT(name) \
 	{\
 	struct timeval timev;\
 	do_gettimeofday(&timev);\
 		if (arlan_exit_debug || arlan_entry_and_exit_debug)\
-			printk("<<<---" name " %ld " "\n",((long int) timev.tv_sec * 1000000 + timev.tv_usec));\
+			printk("<<<---" name " %ld " "\n", ((long int) timev.tv_sec * 1000000 + timev.tv_usec));\
 	}
 #else
 #define ARLAN_DEBUG_ENTRY(name)
@@ -118,8 +118,8 @@ static inline long us2ticks(int us)
 
 
 #define arlan_interrupt_ack(dev)\
-        clearClearInterrupt(dev);\
-        setClearInterrupt(dev);
+	clearClearInterrupt(dev);\
+	setClearInterrupt(dev);
 
 static inline int arlan_drop_tx(struct net_device *dev)
 {
@@ -227,7 +227,7 @@ int arlan_command(struct net_device *dev, int command_p)
 	/* Issuing command */
 	arlan_lock_card_access(dev);
 	if (priv->waiting_command_mask & ARLAN_COMMAND_POWERUP) {
-	//     if (readControlRegister(dev) & (ARLAN_ACCESS && ARLAN_POWER))
+		//if (readControlRegister(dev) & (ARLAN_ACCESS && ARLAN_POWER))
 		setPowerOn(dev);
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_POWERUP;
@@ -259,9 +259,8 @@ int arlan_command(struct net_device *dev, int command_p)
 		netif_stop_queue(dev);
 
 		arlan_drop_tx(dev);
-		if (priv->tx_command_given || priv->rx_command_given) {
+		if (priv->tx_command_given || priv->rx_command_given)
 			printk(KERN_ERR "%s: Reset under tx or rx command\n", dev->name);
-		}
 		netif_stop_queue(dev);
 		if (arlan_debug & ARLAN_DEBUG_RESET)
 			printk(KERN_ERR "%s: Doing chip reset\n", dev->name);
@@ -291,9 +290,8 @@ int arlan_command(struct net_device *dev, int command_p)
 		setInterruptEnable(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_INT_RENABLE;
 	} else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF) {
-		if (priv->tx_command_given || priv->rx_command_given) {
+		if (priv->tx_command_given || priv->rx_command_given)
 			printk(KERN_ERR "%s: Reset under tx or rx command\n", dev->name);
-		}
 		arlan_drop_tx(dev);
 		setInterruptEnable(dev);
 		arlan_hw_config(dev);
@@ -330,7 +328,7 @@ int arlan_command(struct net_device *dev, int command_p)
 		} else
 			priv->card_polling_interval = 2;
 	} else if (priv->waiting_command_mask & ARLAN_COMMAND_TBUSY_CLEAR) {
-		if ( !registrationBad(dev) &&
+		if (!registrationBad(dev) &&
 		     (netif_queue_stopped(dev) || !netif_running(dev))) {
 				priv->waiting_command_mask &= ~ARLAN_COMMAND_TBUSY_CLEAR;
 				netif_wake_queue(dev);
@@ -474,9 +472,8 @@ static void arlan_registration_timer(unsigned long data)
 
 	if (registrationBad(dev)) {
 		priv->registrationLostCount++;
-		if (lostTime > 7000 && lostTime < 7200) {
+		if (lostTime > 7000 && lostTime < 7200)
 			printk(KERN_NOTICE "%s registration Lost\n", dev->name);
-		}
 		if (lostTime / priv->reRegisterExp > 2000)
 			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_CONF);
 		if (lostTime / (priv->reRegisterExp) > 3500)
@@ -498,7 +495,7 @@ static void arlan_registration_timer(unsigned long data)
 		priv->reRegisterExp = 1;
 		if (!netif_running(dev))
 			netif_wake_queue(dev);
-		if (time_after(priv->tx_last_sent,priv->tx_last_cleared) &&
+		if (time_after(priv->tx_last_sent, priv->tx_last_cleared) &&
 		    time_after(jiffies, priv->tx_last_sent * 5*HZ)) {
 			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);
 			priv->tx_last_cleared = jiffies;
@@ -524,15 +521,13 @@ static void arlan_registration_timer(unsigned long data)
 			arlan_retransmit_now(dev);
 			dev->trans_start = jiffies;
 		}
-		if (!(TXHEAD(dev).offset && TXTAIL(dev).offset)) {
+		if (!(TXHEAD(dev).offset && TXTAIL(dev).offset))
 			netif_wake_queue(dev);
-		}
 		priv->tx_done_delayed = 0;
 		bh_mark_needed = 1;
 	}
-	if (bh_mark_needed) {
+	if (bh_mark_needed)
 		netif_wake_queue(dev);
-	}
 	arlan_process_interrupt(dev);
 
 	if (next_tick < priv->card_polling_interval)
@@ -644,8 +639,7 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 	if (TXHEAD(dev).offset && TXTAIL(dev).offset) {
 		netif_stop_queue(dev);
 		return 0;
-	}
-	else
+	} else
 		netif_start_queue(dev);
 
 
@@ -731,8 +725,8 @@ static int arlan_hw_config(struct net_device *dev)
 	memset_io(arlan->commandParameter, 0, 0xf);	/* 0xf */
 	memset_io(arlan->commandParameter + 1, 0, 2);
 	if (conf->writeEEPROM) {
-		  memset_io(arlan->commandParameter, conf->writeEEPROM, 1);
-//		conf->writeEEPROM=0;
+		memset_io(arlan->commandParameter, conf->writeEEPROM, 1);
+		//conf->writeEEPROM=0;
 	}
 	if (conf->registrationMode && conf->registrationInterrupts)
 		memset_io(arlan->commandParameter + 3, 1, 1);
@@ -759,38 +753,37 @@ static int arlan_read_card_configuration(struct net_device *dev)
 
 	ARLAN_DEBUG_ENTRY("arlan_read_card_configuration");
 
-	if (radioNodeId == radioNodeIdUNKNOWN) {
+	if (radioNodeId == radioNodeIdUNKNOWN)
 		READSHM(conf->radioNodeId, arlan->radioNodeId, u_short);
-	}
 	else
 		conf->radioNodeId = radioNodeId;
 
-	if (SID == SIDUNKNOWN) {
+	if (SID == SIDUNKNOWN)
 		READSHM(conf->SID, arlan->SID, u_int);
-	} else
+	else
 		conf->SID = SID;
 
-	if (spreadingCode == spreadingCodeUNKNOWN) {
-		  READSHM(conf->spreadingCode, arlan->spreadingCode, u_char);
-	} else
+	if (spreadingCode == spreadingCodeUNKNOWN)
+		READSHM(conf->spreadingCode, arlan->spreadingCode, u_char);
+	else
 		conf->spreadingCode = spreadingCode;
 
-	if (channelSet == channelSetUNKNOWN) {
+	if (channelSet == channelSetUNKNOWN)
 		READSHM(conf->channelSet, arlan->channelSet, u_char);
-	} else
+	else
 		conf->channelSet = channelSet;
 
-	if (channelNumber == channelNumberUNKNOWN) {
+	if (channelNumber == channelNumberUNKNOWN)
 		READSHM(conf->channelNumber, arlan->channelNumber, u_char);
-	} else
+	else
 		conf->channelNumber = channelNumber;
 
 	READSHM(conf->scramblingDisable, arlan->scramblingDisable, u_char);
 	READSHM(conf->txAttenuation, arlan->txAttenuation, u_char);
 
-	if (systemId == systemIdUNKNOWN) {
+	if (systemId == systemIdUNKNOWN)
 		READSHM(conf->systemId, arlan->systemId, u_int);
-	} else
+	else
 		conf->systemId = systemId;
 
 	READSHM(conf->maxDatagramSize, arlan->maxDatagramSize, u_short);
@@ -800,14 +793,14 @@ static int arlan_read_card_configuration(struct net_device *dev)
 	READSHM(conf->priority, arlan->priority, u_char);
 	READSHM(conf->rootOrRepeater, arlan->rootOrRepeater, u_char);
 
-	if (SID == SIDUNKNOWN) {
-		  READSHM(conf->SID, arlan->SID, u_int);
-	} else
+	if (SID == SIDUNKNOWN)
+		READSHM(conf->SID, arlan->SID, u_int);
+	else
 		conf->SID = SID;
 
-	if (registrationMode == registrationModeUNKNOWN) {
-		  READSHM(conf->registrationMode, arlan->registrationMode, u_char);
-	} else
+	if (registrationMode == registrationModeUNKNOWN)
+		READSHM(conf->registrationMode, arlan->registrationMode, u_char);
+	else
 		conf->registrationMode = registrationMode;
 
 	READSHM(conf->registrationFill, arlan->registrationFill, u_char);
@@ -995,9 +988,9 @@ static int __init arlan_probe_here(struct net_device *dev,
 	dev->mem_start = memaddr;
 	dev->mem_end = memaddr + ARLAN_SHMEM_SIZE-1;
 
-	if (dev->irq < 2) {
+	if (dev->irq < 2)
 		READSHM(dev->irq, ap->card->irqLevel, u_char);
-	} else if (dev->irq == 2)
+	else if (dev->irq == 2)
 		dev->irq = 9;
 
 	arlan_read_card_configuration(dev);
@@ -1129,9 +1122,9 @@ static inline void arlan_queue_retransmit(struct net_device *dev)
 
 	ARLAN_DEBUG_ENTRY("arlan_queue_retransmit");
 
-	if (DoNotWaitReTransmitCrap(dev)) {
-		  arlan_drop_tx(dev);
-	} else
+	if (DoNotWaitReTransmitCrap(dev))
+		arlan_drop_tx(dev);
+	else
 		priv->ReTransmitRequested++;
 
 	ARLAN_DEBUG_EXIT("arlan_queue_retransmit");
@@ -1146,8 +1139,7 @@ static inline void RetryOrFail(struct net_device *dev)
 	if (priv->retransmissions > priv->Conf->retries ||
 	    DoNotReTransmitCrap(dev)) {
 		arlan_drop_tx(dev);
-	}
-	else if (priv->bad <= priv->Conf->fastReTransCount) {
+	} else if (priv->bad <= priv->Conf->fastReTransCount) {
 		arlan_retransmit_now(dev);
 	} else
 		arlan_queue_retransmit(dev);
@@ -1165,7 +1157,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 	priv->tx_last_cleared = jiffies;
 	priv->tx_command_given = 0;
 	switch (status) {
-		case 1:
+	case 1:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit OK\n");
@@ -1185,14 +1177,13 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 					arlan_retransmit_now(dev);
 					dev->trans_start = jiffies;
 				}
-				if (!TXHEAD(dev).offset || !TXTAIL(dev).offset) {
+				if (!TXHEAD(dev).offset || !TXTAIL(dev).offset)
 					netif_wake_queue(dev);
-				}
 			}
 		}
 		break;
 
-		case 2:
+	case 2:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit timed out\n");
@@ -1202,7 +1193,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 		}
 		break;
 
-		case 3:
+	case 3:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit max retries\n");
@@ -1213,7 +1204,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 		}
 		break;
 
-		case 4:
+	case 4:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit aborted\n");
@@ -1223,7 +1214,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 		}
 		break;
 
-		case 5:
+	case 5:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit not registered\n");
@@ -1233,7 +1224,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 		}
 		break;
 
-		case 6:
+	case 6:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit destination full\n");
@@ -1244,7 +1235,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 		}
 		break;
 
-		case 7:
+	case 7:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit unknown ack\n");
@@ -1254,7 +1245,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 		}
 		break;
 
-		case 8:
+	case 8:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit dest mail box full\n");
@@ -1265,7 +1256,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 		}
 		break;
 
-		case 9:
+	case 9:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit root dest not reg.\n");
@@ -1276,7 +1267,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 		}
 		break;
 
-		default:
+	default:
 		{
 			printk(KERN_ERR "arlan intr: transmit status unknown\n");
 			priv->bad += 1;
@@ -1327,9 +1318,9 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 	}
 	DEBUGSHM(1, "arlan rcv pkt rxStatus= %d ", arlan->rxStatus, u_char);
 	switch (rxStatus) {
-		case 1:
-		case 2:
-		case 3:
+	case 1:
+	case 2:
+	case 3:
 		{
 			/* Malloc up new buffer. */
 			struct sk_buff *skb;
@@ -1415,7 +1406,7 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 		}
 		break;
 
-		default:
+	default:
 			printk(KERN_ERR "arlan intr: received unknown status\n");
 			dev->stats.rx_crc_errors++;
 			break;
@@ -1562,7 +1553,7 @@ static int arlan_close(struct net_device *dev)
 }
 
 #ifdef ARLAN_DEBUGGING
-static long alignLong(volatile u_char * ptr)
+static long alignLong(volatile u_char *ptr)
 {
 	long ret;
 	memcpy_fromio(&ret, (void *) ptr, 4);
@@ -1695,7 +1686,7 @@ struct net_device * __init arlan_probe(int unit)
 	return dev;
 }
 
-#ifdef  MODULE
+#ifdef MODULE
 int __init init_module(void)
 {
 	int i = 0;
-- 
1.6.0.4


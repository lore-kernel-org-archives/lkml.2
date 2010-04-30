Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab0D3Qvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:51:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48004 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab0D3Qv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZbIWy5+kGJk7PtLQbVkktxsoaRBJo4xlXkdIRfgdZ77HMnZMBU859tIF2UiCHyF3I1
         xdCTGsvUrmSrvrj3/IQgIM1a78xf/+KS3AlD5iyO7y6kjq7CrDIvH8PZkkkL4V2ebYTR
         3qPs/ozzcnC89szRH7PZoGM8Z+9jugea/cncQ=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] Staging: arlan: fixed unnecessary whitespace issue in arlan-main.c
Date: Fri, 30 Apr 2010 21:58:00 +0530
Message-Id: <1272644880-8143-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the arlan-main.c file that fixes all the
unnecessary whitespace issues found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/arlan/arlan-main.c |  126 ++++++++++++++++++------------------
 1 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/arlan/arlan-main.c b/drivers/staging/arlan/arlan-main.c
index b0af8d3..2b39768 100644
--- a/drivers/staging/arlan/arlan-main.c
+++ b/drivers/staging/arlan/arlan-main.c
@@ -81,14 +81,14 @@ static netdev_tx_t arlan_tx(struct sk_buff *skb, struct net_device *dev);
 static irqreturn_t arlan_interrupt(int irq, void *dev_id);
 static int	arlan_close(struct net_device *dev);
 static struct net_device_stats *
-		arlan_statistics		(struct net_device *dev);
-static void	arlan_set_multicast		(struct net_device *dev);
-static int	arlan_hw_tx			(struct net_device* dev, char *buf, int length );
-static int	arlan_hw_config			(struct net_device * dev);
-static void	arlan_tx_done_interrupt		(struct net_device * dev, int status);
-static void	arlan_rx_interrupt		(struct net_device * dev, u_char rxStatus, u_short, u_short);
-static void	arlan_process_interrupt		(struct net_device * dev);
-static void	arlan_tx_timeout		(struct net_device *dev);
+		arlan_statistics(struct net_device *dev);
+static void	arlan_set_multicast(struct net_device *dev);
+static int	arlan_hw_tx(struct net_device* dev, char *buf, int length);
+static int	arlan_hw_config(struct net_device * dev);
+static void	arlan_tx_done_interrupt(struct net_device * dev, int status);
+static void	arlan_rx_interrupt(struct net_device * dev, u_char rxStatus, u_short, u_short);
+static void	arlan_process_interrupt(struct net_device * dev);
+static void	arlan_tx_timeout(struct net_device *dev);
 
 static inline long us2ticks(int us)
 {
@@ -109,7 +109,7 @@ static inline long us2ticks(int us)
 	struct timeval timev;\
 	do_gettimeofday(&timev);\
 		if (arlan_exit_debug || arlan_entry_and_exit_debug)\
-			printk("<<<---" name " %ld " "\n",((long int) timev.tv_sec * 1000000 + timev.tv_usec) );\
+			printk("<<<---" name " %ld " "\n",((long int) timev.tv_sec * 1000000 + timev.tv_usec));\
 	}
 #else
 #define ARLAN_DEBUG_ENTRY(name)
@@ -135,7 +135,7 @@ static inline int arlan_drop_tx(struct net_device *dev)
 		priv->txLast = 0;
 		priv->bad = 0;
 		if (!priv->under_reset && !priv->under_config)
-			netif_wake_queue (dev);
+			netif_wake_queue(dev);
 	}
 	return 1;
 }
@@ -156,7 +156,7 @@ int arlan_command(struct net_device *dev, int command_p)
 		priv->card_polling_interval = 1;
 
 	if (arlan_debug & ARLAN_DEBUG_CHAIN_LOCKS)
-		printk(KERN_DEBUG "arlan_command, %lx commandByte %x waiting %lx incoming %x \n",
+		printk(KERN_DEBUG "arlan_command, %lx commandByte %x waiting %lx incoming %x\n",
 		jiffies, READSHMB(arlan->commandByte),
 		       priv->waiting_command_mask, command_p);
 
@@ -194,13 +194,13 @@ int arlan_command(struct net_device *dev, int command_p)
 
 			if (priv->waiting_command_mask & ARLAN_COMMAND_LONG_WAIT_NOW) {
 				if (udelayed * 40 > 1000000) {
-					printk(KERN_ERR "%s long wait too long \n", dev->name);
+					printk(KERN_ERR "%s long wait too long\n", dev->name);
 					priv->waiting_command_mask |= ARLAN_COMMAND_RESET;
 					break;
 				}
 			} else if (priv->waiting_command_mask & ARLAN_COMMAND_WAIT_NOW) {
 				if (udelayed * 40 > 1000) {
-					printk(KERN_ERR "%s short wait too long \n", dev->name);
+					printk(KERN_ERR "%s short wait too long\n", dev->name);
 					goto bad_end;
 				}
 			}
@@ -256,13 +256,13 @@ int arlan_command(struct net_device *dev, int command_p)
 		priv->card_polling_interval = 1;
 	} else if (priv->waiting_command_mask & ARLAN_COMMAND_RESET) {
 		priv->under_reset=1;
-		netif_stop_queue (dev);
+		netif_stop_queue(dev);
 
 		arlan_drop_tx(dev);
 		if (priv->tx_command_given || priv->rx_command_given) {
-			printk(KERN_ERR "%s: Reset under tx or rx command \n", dev->name);
+			printk(KERN_ERR "%s: Reset under tx or rx command\n", dev->name);
 		}
-		netif_stop_queue (dev);
+		netif_stop_queue(dev);
 		if (arlan_debug & ARLAN_DEBUG_RESET)
 			printk(KERN_ERR "%s: Doing chip reset\n", dev->name);
 		priv->lastReset = jiffies;
@@ -292,7 +292,7 @@ int arlan_command(struct net_device *dev, int command_p)
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_INT_RENABLE;
 	} else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF) {
 		if (priv->tx_command_given || priv->rx_command_given) {
-			printk(KERN_ERR "%s: Reset under tx or rx command \n", dev->name);
+			printk(KERN_ERR "%s: Reset under tx or rx command\n", dev->name);
 		}
 		arlan_drop_tx(dev);
 		setInterruptEnable(dev);
@@ -315,7 +315,7 @@ int arlan_command(struct net_device *dev, int command_p)
 		} else {
 			priv->card_polling_interval = 1;
 			if (arlan_debug & ARLAN_DEBUG_TIMING)
-				printk(KERN_ERR "configure delayed \n");
+				printk(KERN_ERR "configure delayed\n");
 		}
 	} else if (priv->waiting_command_mask & ARLAN_COMMAND_RX) {
 		if (!registrationBad(dev)) {
@@ -331,9 +331,9 @@ int arlan_command(struct net_device *dev, int command_p)
 			priv->card_polling_interval = 2;
 	} else if (priv->waiting_command_mask & ARLAN_COMMAND_TBUSY_CLEAR) {
 		if ( !registrationBad(dev) &&
-		     (netif_queue_stopped(dev) || !netif_running(dev)) ) {
+		     (netif_queue_stopped(dev) || !netif_running(dev))) {
 				priv->waiting_command_mask &= ~ARLAN_COMMAND_TBUSY_CLEAR;
-				netif_wake_queue (dev);
+				netif_wake_queue(dev);
 			}
 	} else if (priv->waiting_command_mask & ARLAN_COMMAND_TX) {
 		if (!test_and_set_bit(0, (void *) &priv->tx_command_given)) {
@@ -356,7 +356,7 @@ int arlan_command(struct net_device *dev, int command_p)
 				priv->card_polling_interval = 1;
 			}
 		} else if (arlan_debug & ARLAN_DEBUG_CHAIN_LOCKS)
-			printk(KERN_ERR "tx command when tx chain locked \n");
+			printk(KERN_ERR "tx command when tx chain locked\n");
 	} else if (priv->waiting_command_mask & ARLAN_COMMAND_NOOPINT) {
 		{
 			WRITESHMB(arlan->commandByte, ARLAN_COM_NOP | ARLAN_COM_INT);
@@ -398,13 +398,13 @@ card_busy_end:
 		priv->waiting_command_mask |= ARLAN_COMMAND_CLEAN_AND_RESET;
 
 	if (arlan_debug & ARLAN_DEBUG_CARD_STATE)
-		printk(KERN_ERR "%s arlan_command card busy end \n", dev->name);
+		printk(KERN_ERR "%s arlan_command card busy end\n", dev->name);
 	spin_unlock_irqrestore(&priv->lock, flags);
 	ARLAN_DEBUG_EXIT("arlan_command");
 	return 1;
 
 bad_end:
-	printk(KERN_ERR "%s arlan_command bad end \n", dev->name);
+	printk(KERN_ERR "%s arlan_command bad end\n", dev->name);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 	ARLAN_DEBUG_EXIT("arlan_command");
@@ -440,14 +440,14 @@ static inline void arlan_retransmit_now(struct net_device *dev)
 	if (TXLAST(dev).offset == 0) {
 		if (TXHEAD(dev).offset) {
 			priv->txLast = 0;
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk(KERN_DEBUG "TX buff switch to head \n");
+			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk(KERN_DEBUG "TX buff switch to head\n");
 
 		} else if (TXTAIL(dev).offset) {
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk(KERN_DEBUG "TX buff switch to tail \n");
+			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk(KERN_DEBUG "TX buff switch to tail\n");
 			priv->txLast = 1;
 		} else
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk(KERN_ERR "ReTransmit buff empty");
-		netif_wake_queue (dev);
+		netif_wake_queue(dev);
 		return;
 
 	}
@@ -456,7 +456,7 @@ static inline void arlan_retransmit_now(struct net_device *dev)
 	priv->Conf->driverRetransmissions++;
 	priv->retransmissions++;
 
-	IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk("Retransmit %d bytes \n", TXLAST(dev).length);
+	IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk("Retransmit %d bytes\n", TXLAST(dev).length);
 
 	ARLAN_DEBUG_EXIT("arlan_retransmit_now");
 }
@@ -475,7 +475,7 @@ static void arlan_registration_timer(unsigned long data)
 	if (registrationBad(dev)) {
 		priv->registrationLostCount++;
 		if (lostTime > 7000 && lostTime < 7200) {
-			printk(KERN_NOTICE "%s registration Lost \n", dev->name);
+			printk(KERN_NOTICE "%s registration Lost\n", dev->name);
 		}
 		if (lostTime / priv->reRegisterExp > 2000)
 			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_CONF);
@@ -496,10 +496,10 @@ static void arlan_registration_timer(unsigned long data)
 		priv->registrationLastSeen = jiffies;
 		priv->registrationLostCount = 0;
 		priv->reRegisterExp = 1;
-		if (!netif_running(dev) )
+		if (!netif_running(dev))
 			netif_wake_queue(dev);
 		if (time_after(priv->tx_last_sent,priv->tx_last_cleared) &&
-		    time_after(jiffies, priv->tx_last_sent * 5*HZ) ) {
+		    time_after(jiffies, priv->tx_last_sent * 5*HZ)) {
 			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);
 			priv->tx_last_cleared = jiffies;
 		}
@@ -508,7 +508,7 @@ static void arlan_registration_timer(unsigned long data)
 
 	if (!registrationBad(dev) && priv->ReTransmitRequested) {
 		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
-			printk(KERN_ERR "Retransmit from timer \n");
+			printk(KERN_ERR "Retransmit from timer\n");
 		priv->ReTransmitRequested = 0;
 		arlan_retransmit_now(dev);
 	}
@@ -525,13 +525,13 @@ static void arlan_registration_timer(unsigned long data)
 			dev->trans_start = jiffies;
 		}
 		if (!(TXHEAD(dev).offset && TXTAIL(dev).offset)) {
-			netif_wake_queue (dev);
+			netif_wake_queue(dev);
 		}
 		priv->tx_done_delayed = 0;
 		bh_mark_needed = 1;
 	}
 	if (bh_mark_needed) {
-		netif_wake_queue (dev);
+		netif_wake_queue(dev);
 	}
 	arlan_process_interrupt(dev);
 
@@ -622,7 +622,7 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 		TXTAIL(dev).scrambled = conf->txScrambled;
 		memcpy_toio(((char __iomem *)arlan + TXTAIL(dev).offset), buf + ARLAN_FAKE_HDR_LEN, TXTAIL(dev).length);
 	} else {
-		netif_stop_queue (dev);
+		netif_stop_queue(dev);
 		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 			printk(KERN_ERR "TX TAIL & HEAD full, return, tailStart %d headEnd %d\n", tailStarts, headEnds);
 		return -1;
@@ -642,15 +642,15 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 		priv->out_time10 = jiffies;
 	}
 	if (TXHEAD(dev).offset && TXTAIL(dev).offset) {
-		netif_stop_queue (dev);
+		netif_stop_queue(dev);
 		return 0;
 	}
 	else
-		netif_start_queue (dev);
+		netif_start_queue(dev);
 
 
 	IFDEBUG(ARLAN_DEBUG_HEADER_DUMP)
-		printk(KERN_WARNING "%s Transmit t %2x:%2x:%2x:%2x:%2x:%2x f %2x:%2x:%2x:%2x:%2x:%2x \n", dev->name,
+		printk(KERN_WARNING "%s Transmit t %2x:%2x:%2x:%2x:%2x:%2x f %2x:%2x:%2x:%2x:%2x:%2x\n", dev->name,
 		   (unsigned char) buf[0], (unsigned char) buf[1], (unsigned char) buf[2], (unsigned char) buf[3],
 		   (unsigned char) buf[4], (unsigned char) buf[5], (unsigned char) buf[6], (unsigned char) buf[7],
 		   (unsigned char) buf[8], (unsigned char) buf[9], (unsigned char) buf[10], (unsigned char) buf[11]);
@@ -661,7 +661,7 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 
 	priv->tx_last_sent = jiffies;
 
-	IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk("%s TX Qued %d bytes \n", dev->name, length);
+	IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk("%s TX Qued %d bytes\n", dev->name, length);
 
 	ARLAN_DEBUG_EXIT("arlan_hw_tx");
 
@@ -677,9 +677,9 @@ static int arlan_hw_config(struct net_device *dev)
 
 	ARLAN_DEBUG_ENTRY("arlan_hw_config");
 
-	printk(KERN_NOTICE "%s arlan configure called \n", dev->name);
+	printk(KERN_NOTICE "%s arlan configure called\n", dev->name);
 	if (arlan_EEPROM_bad)
-		printk(KERN_NOTICE "arlan configure with eeprom bad option \n");
+		printk(KERN_NOTICE "arlan configure with eeprom bad option\n");
 
 
 	WRITESHM(arlan->spreadingCode, conf->spreadingCode, u_char);
@@ -832,7 +832,7 @@ static int arlan_read_card_configuration(struct net_device *dev)
 	READSHM(tlx415, arlan->configStatus, u_char);
 
 	if (tlx415 != 0xA5)
-		printk(KERN_INFO "%s tlx415 chip \n", dev->name);
+		printk(KERN_INFO "%s tlx415 chip\n", dev->name);
 
 	conf->txClear = 0;
 	conf->txRetries = 1;
@@ -876,7 +876,7 @@ static int __init arlan_check_fingerprint(unsigned long memaddr)
 	ARLAN_DEBUG_ENTRY("arlan_check_fingerprint");
 
 	if (!request_mem_region(paddr, ARLAN_SHMEM_SIZE, "arlan")) {
-		// printk(KERN_WARNING "arlan: memory region %lx excluded from probing \n",paddr);
+		// printk(KERN_WARNING "arlan: memory region %lx excluded from probing\n",paddr);
 		return -ENODEV;
 	}
 
@@ -889,7 +889,7 @@ static int __init arlan_check_fingerprint(unsigned long memaddr)
 		return -ENODEV;
 	}
 
-//   printk(KERN_INFO "arlan found at 0x%x \n",memaddr);
+//   printk(KERN_INFO "arlan found at 0x%x\n",memaddr);
 	ARLAN_DEBUG_EXIT("arlan_check_fingerprint");
 
 	return 0;
@@ -910,7 +910,7 @@ static int arlan_change_mtu(struct net_device *dev, int new_mtu)
 	conf->maxFrameSize = new_mtu + 48;
 
 	arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_CONF);
-	printk(KERN_NOTICE "%s mtu changed to %d \n", dev->name, new_mtu);
+	printk(KERN_NOTICE "%s mtu changed to %d\n", dev->name, new_mtu);
 
 	ARLAN_DEBUG_EXIT("arlan_change_mtu");
 
@@ -988,7 +988,7 @@ static int __init arlan_probe_here(struct net_device *dev,
 	if (arlan_check_fingerprint(memaddr))
 		return -ENODEV;
 
-	printk(KERN_NOTICE "%s: Arlan found at %llx, \n ", dev->name,
+	printk(KERN_NOTICE "%s: Arlan found at %llx,\n ", dev->name,
 	       (u64) virt_to_phys((void*)memaddr));
 
 	ap->card = (void *) memaddr;
@@ -1032,7 +1032,7 @@ static int arlan_open(struct net_device *dev)
 	priv->interrupt_processing_active = 0;
 	spin_lock_init(&priv->lock);
 
-	netif_start_queue (dev);
+	netif_start_queue(dev);
 
 	priv->registrationLostCount = 0;
 	priv->registrationLastSeen = jiffies;
@@ -1060,7 +1060,7 @@ static int arlan_open(struct net_device *dev)
 }
 
 
-static void arlan_tx_timeout (struct net_device *dev)
+static void arlan_tx_timeout(struct net_device *dev)
 {
 	printk(KERN_ERR "%s: arlan transmit timed out, kernel decided\n", dev->name);
 	/* Try to restart the adaptor. */
@@ -1081,8 +1081,8 @@ static netdev_tx_t arlan_tx(struct sk_buff *skb, struct net_device *dev)
 	buf = skb->data;
 
 	if (length + 0x12 > 0x800) {
-		printk(KERN_ERR "TX RING overflow \n");
-		netif_stop_queue (dev);
+		printk(KERN_ERR "TX RING overflow\n");
+		netif_stop_queue(dev);
 	}
 
 	if (arlan_hw_tx(dev, buf, length) == -1)
@@ -1098,7 +1098,7 @@ static netdev_tx_t arlan_tx(struct sk_buff *skb, struct net_device *dev)
 
 bad_end:
 	arlan_process_interrupt(dev);
-	netif_stop_queue (dev);
+	netif_stop_queue(dev);
 	ARLAN_DEBUG_EXIT("arlan_tx");
 	return NETDEV_TX_BUSY;
 }
@@ -1186,7 +1186,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 					dev->trans_start = jiffies;
 				}
 				if (!TXHEAD(dev).offset || !TXTAIL(dev).offset) {
-					netif_wake_queue (dev);
+					netif_wake_queue(dev);
 				}
 			}
 		}
@@ -1304,7 +1304,7 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 	// prohibited here              arlan_command(dev, ARLAN_COMMAND_RX);
 
 	if (pkt_len < 10 || pkt_len > 2048) {
-		printk(KERN_WARNING "%s: got too short or long packet, len %d \n", dev->name, pkt_len);
+		printk(KERN_WARNING "%s: got too short or long packet, len %d\n", dev->name, pkt_len);
 		return;
 	}
 	if (rxOffset + pkt_len > 0x2000) {
@@ -1335,8 +1335,8 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 			struct sk_buff *skb;
 
 			DEBUGSHM(50, "arlan recv pkt offs=%d\n", arlan->rxOffset, u_short);
-			DEBUGSHM(1, "arlan rxFrmType = %d \n", arlan->rxFrmType, u_char);
-			DEBUGSHM(1, KERN_INFO "arlan rx scrambled = %d \n", arlan->scrambled, u_char);
+			DEBUGSHM(1, "arlan rxFrmType = %d\n", arlan->rxFrmType, u_char);
+			DEBUGSHM(1, KERN_INFO "arlan rx scrambled = %d\n", arlan->scrambled, u_char);
 
 			/* here we do multicast filtering to avoid slow 8-bit memcopy */
 #ifdef ARLAN_MULTICAST
@@ -1351,9 +1351,9 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 				if (hw_dst_addr[0] == 0x01) {
 					if (mdebug)
 						if (hw_dst_addr[1] == 0x00)
-							printk(KERN_ERR "%s mcast 0x0100 \n", dev->name);
+							printk(KERN_ERR "%s mcast 0x0100\n", dev->name);
 						else if (hw_dst_addr[1] == 0x40)
-							printk(KERN_ERR "%s m/bcast 0x0140 \n", dev->name);
+							printk(KERN_ERR "%s m/bcast 0x0140\n", dev->name);
 					netdev_for_each_mc_entry(dmi, dev) {
 						if (arlan_debug & ARLAN_DEBUG_HEADER_DUMP)
 							printk(KERN_ERR "%s mcl %pM\n",
@@ -1407,7 +1407,7 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 					for (i = 0; i <= 22; i++)
 						printk("%02x:", (u_char) skbtmp[i + 12]);
 					printk(KERN_ERR "\n");
-					printk(KERN_WARNING "arlan kernel pkt type trans %x \n", skb->protocol);
+					printk(KERN_WARNING "arlan kernel pkt type trans %x\n", skb->protocol);
 				}
 			netif_rx(skb);
 			dev->stats.rx_packets++;
@@ -1437,7 +1437,7 @@ static void arlan_process_interrupt(struct net_device *dev)
 
 	if (test_and_set_bit(0, (void *) &priv->interrupt_processing_active)) {
 		if (arlan_debug & ARLAN_DEBUG_CHAIN_LOCKS)
-			printk(KERN_ERR "interrupt chain reentering \n");
+			printk(KERN_ERR "interrupt chain reentering\n");
 		goto end_int_process;
 	}
 	while ((rxStatus || txStatus || priv->interrupt_ack_requested)
@@ -1449,7 +1449,7 @@ static void arlan_process_interrupt(struct net_device *dev)
 		arlan_command(dev, ARLAN_COMMAND_INT_ENABLE);
 
 		IFDEBUG(ARLAN_DEBUG_INTERRUPT)
-			printk(KERN_ERR "%s:  got IRQ rx %x tx %x comm %x rxOff %x rxLen %x \n",
+			printk(KERN_ERR "%s:  got IRQ rx %x tx %x comm %x rxOff %x rxLen %x\n",
 					dev->name, rxStatus, txStatus, READSHMB(arlan->commandByte),
 					rxOffset, pkt_len);
 
@@ -1460,7 +1460,7 @@ static void arlan_process_interrupt(struct net_device *dev)
 										    dev->name, txStatus, rxStatus);
 			} else {
 				IFDEBUG(ARLAN_DEBUG_INTERRUPT)
-					printk(KERN_INFO "%s irq $%d test OK \n", dev->name, dev->irq);
+					printk(KERN_INFO "%s irq $%d test OK\n", dev->name, dev->irq);
 
 			}
 			priv->interrupt_ack_requested = 0;
@@ -1490,7 +1490,7 @@ static void arlan_process_interrupt(struct net_device *dev)
 			if (!registrationBad(dev)) {
 				priv->registrationLastSeen = jiffies;
 				if (!netif_queue_stopped(dev) && !priv->under_reset && !priv->under_config)
-					netif_wake_queue (dev);
+					netif_wake_queue(dev);
 			}
 			goto ends;
 		}
@@ -1679,7 +1679,7 @@ struct net_device * __init arlan_probe(int unit)
 	}
 
 	if (lastFoundAt == 0xbe000)
-		printk(KERN_ERR "arlan: No Arlan devices found \n");
+		printk(KERN_ERR "arlan: No Arlan devices found\n");
 
  not_found:
 	free_netdev(dev);
@@ -1733,7 +1733,7 @@ void __exit cleanup_module(void)
 	for (i = 0; i < MAX_ARLANS; i++) {
 		dev = arlan_device[i];
 		if (dev) {
-			arlan_command(dev, ARLAN_COMMAND_POWERDOWN );
+			arlan_command(dev, ARLAN_COMMAND_POWERDOWN);
 
 			unregister_netdev(dev);
 			release_mem_region(virt_to_phys((void *) dev->mem_start),
-- 
1.6.0.4


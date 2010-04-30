Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0D3RAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:00:55 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:46005 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab0D3RAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:00:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZUrLU08hAEbbD6isIgTonuvt8ppZ1XV9UChelwMzj2fK57Tc4XAspBPWGFv5YcxjVy
         eapOb3mHxrkZ2TvrWreNIwTI+7rZWjWZ9/FbFoNiCosqhqgBU8H5v/m3vHDMh5mfM3mL
         U5NlTWnLOLvV8qQeXkNDjOmUP1I6OsGsQwSJM=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] Staging: arlan: fixed the C99 comment style issue in arlan-main.c
Date: Fri, 30 Apr 2010 21:59:28 +0530
Message-Id: <1272644968-8193-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the arlan-main.c file that fixes the C99 comment style
issues found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/arlan/arlan-main.c |   44 ++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/arlan/arlan-main.c b/drivers/staging/arlan/arlan-main.c
index 5174988..dd29698 100644
--- a/drivers/staging/arlan/arlan-main.c
+++ b/drivers/staging/arlan/arlan-main.c
@@ -227,7 +227,7 @@ int arlan_command(struct net_device *dev, int command_p)
 	/* Issuing command */
 	arlan_lock_card_access(dev);
 	if (priv->waiting_command_mask & ARLAN_COMMAND_POWERUP) {
-		//if (readControlRegister(dev) & (ARLAN_ACCESS && ARLAN_POWER))
+		/* if (readControlRegister(dev) & (ARLAN_ACCESS && ARLAN_POWER)) */
 		setPowerOn(dev);
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_POWERUP;
@@ -275,8 +275,8 @@ int arlan_command(struct net_device *dev, int command_p)
 		priv->card_polling_interval = HZ / 4;
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_RESET;
 		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RACK;
-//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RENABLE;
-//		priv->waiting_command_mask |= ARLAN_COMMAND_RX;
+		/* priv->waiting_command_mask |= ARLAN_COMMAND_INT_RENABLE; */
+		/* priv->waiting_command_mask |= ARLAN_COMMAND_RX; */
 	} else if (priv->waiting_command_mask & ARLAN_COMMAND_INT_RACK) {
 		clearHardwareReset(dev);
 		clearClearInterrupt(dev);
@@ -298,8 +298,8 @@ int arlan_command(struct net_device *dev, int command_p)
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_CONF;
 		priv->card_polling_interval = HZ / 10;
-//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RACK;
-//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_ENABLE;
+		/* priv->waiting_command_mask |= ARLAN_COMMAND_INT_RACK; */
+		/* priv->waiting_command_mask |= ARLAN_COMMAND_INT_ENABLE; */
 		priv->waiting_command_mask |= ARLAN_COMMAND_CONF_WAIT;
 	} else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF_WAIT) {
 		if (READSHMB(arlan->configuredStatusFlag) != 0 &&
@@ -322,7 +322,7 @@ int arlan_command(struct net_device *dev, int command_p)
 			WRITESHMB(arlan->commandByte, ARLAN_COM_INT | ARLAN_COM_RX_ENABLE);
 			WRITESHMB(arlan->commandParameter[0], conf->rxParameter);
 			arlan_interrupt_lancpu(dev);
-			priv->rx_command_given = 0; // mnjah, bad
+			priv->rx_command_given = 0; /* mnjah, bad */
 			priv->waiting_command_mask &= ~ARLAN_COMMAND_RX;
 			priv->card_polling_interval = 1;
 		} else
@@ -343,7 +343,7 @@ int arlan_command(struct net_device *dev, int command_p)
 				memset_io(arlan->commandParameter, 0, 0xf);
 				WRITESHMB(arlan->commandByte, ARLAN_COM_TX_ENABLE | ARLAN_COM_INT);
 				memcpy_toio(arlan->commandParameter, &TXLAST(dev), 14);
-//				for ( i=1 ; i < 15 ; i++) printk("%02x:",READSHMB(arlan->commandParameter[i]));
+				/* for ( i=1 ; i < 15 ; i++) printk("%02x:",READSHMB(arlan->commandParameter[i])); */
 				priv->tx_last_sent = jiffies;
 				arlan_interrupt_lancpu(dev);
 				priv->tx_command_given = 1;
@@ -726,7 +726,7 @@ static int arlan_hw_config(struct net_device *dev)
 	memset_io(arlan->commandParameter + 1, 0, 2);
 	if (conf->writeEEPROM) {
 		memset_io(arlan->commandParameter, conf->writeEEPROM, 1);
-		//conf->writeEEPROM=0;
+		/* conf->writeEEPROM=0; */
 	}
 	if (conf->registrationMode && conf->registrationInterrupts)
 		memset_io(arlan->commandParameter + 3, 1, 1);
@@ -869,7 +869,7 @@ static int __init arlan_check_fingerprint(unsigned long memaddr)
 	ARLAN_DEBUG_ENTRY("arlan_check_fingerprint");
 
 	if (!request_mem_region(paddr, ARLAN_SHMEM_SIZE, "arlan")) {
-		// printk(KERN_WARNING "arlan: memory region %lx excluded from probing\n",paddr);
+		/* printk(KERN_WARNING "arlan: memory region %lx excluded from probing\n",paddr); */
 		return -ENODEV;
 	}
 
@@ -882,7 +882,7 @@ static int __init arlan_check_fingerprint(unsigned long memaddr)
 		return -ENODEV;
 	}
 
-//   printk(KERN_INFO "arlan found at 0x%x\n",memaddr);
+	/* printk(KERN_INFO "arlan found at 0x%x\n",memaddr); */
 	ARLAN_DEBUG_EXIT("arlan_check_fingerprint");
 
 	return 0;
@@ -1058,8 +1058,8 @@ static void arlan_tx_timeout(struct net_device *dev)
 	printk(KERN_ERR "%s: arlan transmit timed out, kernel decided\n", dev->name);
 	/* Try to restart the adaptor. */
 	arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);
-	// dev->trans_start = jiffies;
-	// netif_start_queue (dev);
+	/* dev->trans_start = jiffies; */
+	/* netif_start_queue (dev); */
 }
 
 
@@ -1188,7 +1188,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit timed out\n");
 			priv->bad += 1;
-			//arlan_queue_retransmit(dev);
+			/* arlan_queue_retransmit(dev); */
 			RetryOrFail(dev);
 		}
 		break;
@@ -1199,7 +1199,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 				printk("arlan intr: transmit max retries\n");
 			priv->bad += 1;
 			priv->reset = 0;
-			//arlan_queue_retransmit(dev);
+			/* arlan_queue_retransmit(dev); */
 			RetryOrFail(dev);
 		}
 		break;
@@ -1210,7 +1210,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 				printk("arlan intr: transmit aborted\n");
 			priv->bad += 1;
 			arlan_queue_retransmit(dev);
-			//RetryOrFail(dev);
+			/* RetryOrFail(dev); */
 		}
 		break;
 
@@ -1219,7 +1219,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit not registered\n");
 			priv->bad += 1;
-			//debug=101;
+			/* debug=101; */
 			arlan_queue_retransmit(dev);
 		}
 		break;
@@ -1230,7 +1230,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 				printk("arlan intr: transmit destination full\n");
 			priv->bad += 1;
 			priv->reset = 0;
-			//arlan_drop_tx(dev);
+			/* arlan_drop_tx(dev); */
 			arlan_queue_retransmit(dev);
 		}
 		break;
@@ -1251,7 +1251,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 				printk("arlan intr: transmit dest mail box full\n");
 			priv->bad += 1;
 			priv->reset = 0;
-			//arlan_drop_tx(dev);
+			/* arlan_drop_tx(dev); */
 			arlan_queue_retransmit(dev);
 		}
 		break;
@@ -1262,7 +1262,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 				printk("arlan intr: transmit root dest not reg.\n");
 			priv->bad += 1;
 			priv->reset = 1;
-			//arlan_drop_tx(dev);
+			/* arlan_drop_tx(dev); */
 			arlan_queue_retransmit(dev);
 		}
 		break;
@@ -1291,8 +1291,8 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 
 
 	ARLAN_DEBUG_ENTRY("arlan_rx_interrupt");
-	// by spec,   not                WRITESHMB(arlan->rxStatus,0x00);
-	// prohibited here              arlan_command(dev, ARLAN_COMMAND_RX);
+	/* by spec,   not                WRITESHMB(arlan->rxStatus,0x00); */
+	/* prohibited here              arlan_command(dev, ARLAN_COMMAND_RX); */
 
 	if (pkt_len < 10 || pkt_len > 2048) {
 		printk(KERN_WARNING "%s: got too short or long packet, len %d\n", dev->name, pkt_len);
@@ -1360,7 +1360,7 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 					goto end_of_interrupt;
 				}
 			}
-#endif				// ARLAN_MULTICAST
+#endif				/* ARLAN_MULTICAST */
 			/* multicast filtering ends here */
 			pkt_len += ARLAN_FAKE_HDR_LEN;
 
-- 
1.6.0.4


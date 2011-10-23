Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1JWJYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:24:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33009 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab1JWJYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:24:19 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 02/12] staging: et131x: Remove redundant et131x_reset_recv() call
Date: Sun, 23 Oct 2011 10:22:44 +0100
Message-Id: <1319361774-3148-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This call doesn't do anything useful - only warns on the receive list
being empty, so removed it.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 8c557cf..f521e33 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -605,7 +605,6 @@ int32_t et131x_mii_write(struct et131x_adapter *adapter,
 void et131x_rx_dma_memory_free(struct et131x_adapter *adapter);
 void et131x_rx_dma_disable(struct et131x_adapter *adapter);
 void et131x_rx_dma_enable(struct et131x_adapter *adapter);
-void et131x_reset_recv(struct et131x_adapter *adapter);
 void et131x_init_send(struct et131x_adapter *adapter);
 void et131x_tx_dma_enable(struct et131x_adapter *adapter);
 
@@ -1839,9 +1838,6 @@ void et1310_disable_phy_coma(struct et131x_adapter *adapter)
 	/* Re-initialize the send structures */
 	et131x_init_send(adapter);
 
-	/* Reset the RFD list and re-start RU  */
-	et131x_reset_recv(adapter);
-
 	/* Bring the device back to the state it was during init prior to
 	 * autonegotiation being complete.  This way, when we get the auto-neg
 	 * complete interrupt, we can complete init by calling ConfigMacREGS2.
@@ -2882,17 +2878,6 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 }
 
 /**
- * et131x_reset_recv - Reset the receive list
- * @adapter: pointer to our adapter
- *
- * Assumption, Rcv spinlock has been acquired.
- */
-void et131x_reset_recv(struct et131x_adapter *adapter)
-{
-	WARN_ON(list_empty(&adapter->rx_ring.recv_list));
-}
-
-/**
  * et131x_handle_recv_interrupt - Interrupt handler for receive processing
  * @adapter: pointer to our adapter
  *
@@ -4251,9 +4236,6 @@ static void et131x_adjust_link(struct net_device *netdev)
 			/* Re-initialize the send structures */
 			et131x_init_send(adapter);
 
-			/* Reset the RFD list and re-start RU */
-			et131x_reset_recv(adapter);
-
 			/*
 			 * Bring the device back to the state it was during
 			 * init prior to autonegotiation being complete. This
-- 
1.7.6.4


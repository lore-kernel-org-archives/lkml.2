Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1LCI2f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:28:35 -0500
Received: from www17.your-server.de ([213.133.104.17]:53240 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1LCI2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:28:32 -0500
Message-ID: <1322865373.1534.357.camel@localhost.localdomain>
Subject: [PATCH] sfc: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 23:36:13 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
--- a/drivers/net/ethernet/sfc/rx.c 2011-11-13 11:07:36.306977044 +0100
+++ b/drivers/net/ethernet/sfc/rx.c 2011-11-28 19:53:10.346917167 +0100
@@ -669,7 +669,7 @@ int efx_probe_rx_queue(struct efx_rx_que
 		  rx_queue->ptr_mask);
 
 	/* Allocate RX buffers */
-	rx_queue->buffer = kzalloc(entries * sizeof(*rx_queue->buffer),
+	rx_queue->buffer = kcalloc(entries, sizeof(*rx_queue->buffer),
 				   GFP_KERNEL);
 	if (!rx_queue->buffer)
 		return -ENOMEM;
diff -u -p a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
--- a/drivers/net/ethernet/sfc/selftest.c 2011-11-13 11:07:36.306977044 +0100
+++ b/drivers/net/ethernet/sfc/selftest.c 2011-11-28 19:53:09.640237232 +0100
@@ -503,8 +503,8 @@ efx_test_loopback(struct efx_tx_queue *t
 		/* Determine how many packets to send */
 		state->packet_count = efx->txq_entries / 3;
 		state->packet_count = min(1 << (i << 2), state->packet_count);
-		state->skbs = kzalloc(sizeof(state->skbs[0]) *
-				      state->packet_count, GFP_KERNEL);
+		state->skbs = kcalloc(state->packet_count,
+				      sizeof(state->skbs[0]), GFP_KERNEL);
 		if (!state->skbs)
 			return -ENOMEM;
 		state->flush = false;
diff -u -p a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
--- a/drivers/net/ethernet/sfc/tx.c 2011-11-13 11:07:36.313643816 +0100
+++ b/drivers/net/ethernet/sfc/tx.c 2011-11-28 19:53:08.056874176 +0100
@@ -468,7 +468,7 @@ int efx_probe_tx_queue(struct efx_tx_que
 		  tx_queue->queue, efx->txq_entries, tx_queue->ptr_mask);
 
 	/* Allocate software ring */
-	tx_queue->buffer = kzalloc(entries * sizeof(*tx_queue->buffer),
+	tx_queue->buffer = kcalloc(entries, sizeof(*tx_queue->buffer),
 				   GFP_KERNEL);
 	if (!tx_queue->buffer)
 		return -ENOMEM;



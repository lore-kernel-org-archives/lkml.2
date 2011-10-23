Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab1JWJYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:24:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33009 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab1JWJYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:24:18 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 01/12] staging: et131x: Remove unused rx_ring.recv_buffer_pool
Date: Sun, 23 Oct 2011 10:22:43 +0100
Message-Id: <1319361774-3148-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rx_ring.recv_buffer_pool is unused, even in the original driver code.
Remove from stuct, and also remove some comments regarding it.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 1efa27c..8c557cf 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -329,8 +329,6 @@ struct rx_ring {
 	struct rx_status_block *rx_status_block;
 	dma_addr_t rx_status_bus;
 
-	struct list_head recv_buff_pool;
-
 	/* RECV */
 	struct list_head recv_list;
 	u32 num_ready_recv;
@@ -2307,10 +2305,6 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 		rx_ring->rx_status_block = NULL;
 	}
 
-	/* Free receive buffer pool */
-
-	/* Free receive packet pool */
-
 	/* Destroy the lookaside (RFD) pool */
 	if (adapter->flags & fMP_ADAPTER_RECV_LOOKASIDE) {
 		kmem_cache_destroy(rx_ring->recv_lookaside);
-- 
1.7.6.4


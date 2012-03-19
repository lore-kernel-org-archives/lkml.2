Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab2CSN7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:59:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:43534 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab2CSN7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:59:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="79151820"
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] e1000: Silence sparse warnings by correcting type
Date: Mon, 19 Mar 2012 16:00:03 +0200
Message-Id: <1332165603-20322-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Silence sparse warnings shown below:
...
drivers/net/ethernet/intel/e1000/e1000_main.c:3435:17: warning:
	cast to restricted __le64
drivers/net/ethernet/intel/e1000/e1000_main.c:3435:17: warning:
	cast to restricted __le64
...

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 6419a88..1bf73cf 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -3377,7 +3377,7 @@ static void e1000_dump(struct e1000_adapter *adapter)
 	for (i = 0; tx_ring->desc && (i < tx_ring->count); i++) {
 		struct e1000_tx_desc *tx_desc = E1000_TX_DESC(*tx_ring, i);
 		struct e1000_buffer *buffer_info = &tx_ring->buffer_info[i];
-		struct my_u { u64 a; u64 b; };
+		struct my_u { __le64 a; __le64 b; };
 		struct my_u *u = (struct my_u *)tx_desc;
 		const char *type;
 
@@ -3421,7 +3421,7 @@ rx_ring_summary:
 	for (i = 0; rx_ring->desc && (i < rx_ring->count); i++) {
 		struct e1000_rx_desc *rx_desc = E1000_RX_DESC(*rx_ring, i);
 		struct e1000_buffer *buffer_info = &rx_ring->buffer_info[i];
-		struct my_u { u64 a; u64 b; };
+		struct my_u { __le64 a; __le64 b; };
 		struct my_u *u = (struct my_u *)rx_desc;
 		const char *type;
 
-- 
1.7.9.1


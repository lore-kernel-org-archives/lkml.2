Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0KUCof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:44:35 -0500
Received: from mail.perches.com ([173.55.12.10]:1715 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976Ab0KUCk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:27 -0500
From: Joe Perches <joe@perches.com>
To: Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 47/62] vmxnet3: Use static const
Date: Sat, 20 Nov 2010 18:38:48 -0800
Message-Id: <76d2bd45fbde30f47992b99cf5014dbab4079882.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
  38916	    437	   9160	  48513	   bd81	drivers/net/vmxnet3/vmxnet3_drv.o.new
  38916	    437	   9160	  48513	   bd81	drivers/net/vmxnet3/vmxnet3_drv.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 21314e0..31dc45a 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1082,7 +1082,9 @@ static int
 vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		       struct vmxnet3_adapter *adapter, int quota)
 {
-	static u32 rxprod_reg[2] = {VMXNET3_REG_RXPROD, VMXNET3_REG_RXPROD2};
+	static const u32 rxprod_reg[2] = {
+		VMXNET3_REG_RXPROD, VMXNET3_REG_RXPROD2
+	};
 	u32 num_rxd = 0;
 	struct Vmxnet3_RxCompDesc *rcd;
 	struct vmxnet3_rx_ctx *ctx = &rq->rx_ctx;
-- 
1.7.3.2.245.g03276.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2KHKHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:07:36 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13365 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2KHKHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:07:33 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-5d-509b8456b99c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] DMA: remove dma_async_memcpy_pending() macro
Date: Thu, 08 Nov 2012 10:59:54 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201211081059.54355.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t9jAd3wltkBBh0WFpd3zWFzYPT4vEku
	gDGKyyYlNSezLLVI3y6BK+P/3RWMBT8kK441tLA1MH4Q7WLk5JAQMJH4dO0wG4QtJnHh3nog
	m4tDSGARo8SeB3ehnKVMEo2PpjGCVLEJWElMbF8FZosIKEhs7n3G2sXIwSEs4CixZWUwSJhF
	QFVi9dOz7CC2qICDROfUCWBzmAUmMEr8WnuYBSTBKyAo8WPyPTCbWUBLovnNJkYIW15i85q3
	zBA1lhJv715jmcDINwtJyywkLbOQtCxgZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxQ
	z6R2MK5ssDjEKMDBqMTDqyE5O0CINbGsuDL3EKMEB7OSCO8yZ6AQb0piZVVqUX58UWlOavEh
	RmkOFiVx3maPlAAhgfTEktTs1NSC1CKYLBMHp1QDo23zx5m9N72/Sa9zF341Q3QL+w1WuVOp
	zrb7cqdX+v26IMJpcefTjQVKzhuyrNqyu7rDCzjsnq8xtV2/hHmG1vTl7a4bmJJW7Sl/eGXz
	Xeve+z5fQjcZ8Jze8lrhsu1UVe4iznLHNT9LPT9+/fvg3O99EXXbky1P22sbW20RZePP/LR6
	cbJ1mBJLcUaioRZzUXEiABnYEXMkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 1/2] DMA: remove dma_async_memcpy_pending() macro

Just use dma_async_issue_pending() directly.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/misc/carma/carma-fpga-program.c |    2 +-
 drivers/misc/carma/carma-fpga.c         |    2 +-
 include/linux/dmaengine.h               |    2 --
 net/ipv4/tcp.c                          |    6 +++---
 4 files changed, 5 insertions(+), 7 deletions(-)

Index: b/drivers/misc/carma/carma-fpga-program.c
===================================================================
--- a/drivers/misc/carma/carma-fpga-program.c	2012-11-07 16:00:59.680876184 +0100
+++ b/drivers/misc/carma/carma-fpga-program.c	2012-11-07 16:01:05.612876185 +0100
@@ -546,7 +546,7 @@ static noinline int fpga_program_dma(str
 		goto out_dma_unmap;
 	}
 
-	dma_async_memcpy_issue_pending(chan);
+	dma_async_issue_pending(chan);
 
 	/* Set the total byte count */
 	fpga_set_byte_count(priv->regs, priv->bytes);
Index: b/drivers/misc/carma/carma-fpga.c
===================================================================
--- a/drivers/misc/carma/carma-fpga.c	2012-11-07 16:01:17.304876183 +0100
+++ b/drivers/misc/carma/carma-fpga.c	2012-11-07 16:01:23.568876183 +0100
@@ -749,7 +749,7 @@ static irqreturn_t data_irq(int irq, voi
 	submitted = true;
 
 	/* Start the DMA Engine */
-	dma_async_memcpy_issue_pending(priv->chan);
+	dma_async_issue_pending(priv->chan);
 
 out:
 	/* If no DMA was submitted, re-enable interrupts */
Index: b/include/linux/dmaengine.h
===================================================================
--- a/include/linux/dmaengine.h	2012-11-07 16:01:31.720876180 +0100
+++ b/include/linux/dmaengine.h	2012-11-07 16:01:45.072876180 +0100
@@ -902,8 +902,6 @@ static inline void dma_async_issue_pendi
 	chan->device->device_issue_pending(chan);
 }
 
-#define dma_async_memcpy_issue_pending(chan) dma_async_issue_pending(chan)
-
 /**
  * dma_async_is_tx_complete - poll for transaction completion
  * @chan: DMA channel
Index: b/net/ipv4/tcp.c
===================================================================
--- a/net/ipv4/tcp.c	2012-11-07 16:01:52.496876179 +0100
+++ b/net/ipv4/tcp.c	2012-11-07 16:02:13.924876175 +0100
@@ -1410,7 +1410,7 @@ static void tcp_service_net_dma(struct s
 		return;
 
 	last_issued = tp->ucopy.dma_cookie;
-	dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+	dma_async_issue_pending(tp->ucopy.dma_chan);
 
 	do {
 		if (dma_async_memcpy_complete(tp->ucopy.dma_chan,
@@ -1744,7 +1744,7 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 				tcp_service_net_dma(sk, true);
 				tcp_cleanup_rbuf(sk, copied);
 			} else
-				dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+				dma_async_issue_pending(tp->ucopy.dma_chan);
 		}
 #endif
 		if (copied >= target) {
@@ -1837,7 +1837,7 @@ do_prequeue:
 					break;
 				}
 
-				dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+				dma_async_issue_pending(tp->ucopy.dma_chan);
 
 				if ((offset + used) == skb->len)
 					copied_early = true;

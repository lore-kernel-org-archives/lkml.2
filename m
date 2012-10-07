Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab2JGXsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:48:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38143 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706Ab2JGXVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:21:55 -0400
Message-Id: <20121007225837.352807517@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 019/108] dmaengine: at_hdmac: check that each sg data length is non-null
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit c456797681db814f4f5b36909e8e94047bf53d9c upstream.

Avoid the construction of a malformed DMA request sent to
the DMA controller.
Log message is for debug only because this condition is unlikely to
append and may only trigger at driver development time.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/dma/at_hdmac.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 6c09e18..7ab6e26 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -689,6 +689,11 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
+			if (unlikely(!len)) {
+				dev_dbg(chan2dev(chan),
+					"prep_slave_sg: sg(%d) data length is zero\n", i);
+				goto err;
+			}
 			mem_width = 2;
 			if (unlikely(mem & 3 || len & 3))
 				mem_width = 0;
@@ -724,6 +729,11 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
+			if (unlikely(!len)) {
+				dev_dbg(chan2dev(chan),
+					"prep_slave_sg: sg(%d) data length is zero\n", i);
+				goto err;
+			}
 			mem_width = 2;
 			if (unlikely(mem & 3 || len & 3))
 				mem_width = 0;
@@ -757,6 +767,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 err_desc_get:
 	dev_err(chan2dev(chan), "not enough descriptors available\n");
+err:
 	atc_desc_put(atchan, first);
 	return NULL;
 }



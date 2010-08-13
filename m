Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044Ab0HMScN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 14:32:13 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:36957 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761995Ab0HMScM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 14:32:12 -0400
Date: Fri, 13 Aug 2010 11:32:11 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] kfifo: fix DMA sample driver
Message-ID: <20100813183211.GB18691@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 13 Aug 2010 11:32:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kfifo DMA sample driver is broken. It does not properly initialize
the scatterlist, and therefore causes a kernel BUG with
CONFIG_DEBUG_SG=y.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 samples/kfifo/dma-example.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/samples/kfifo/dma-example.c b/samples/kfifo/dma-example.c
index b9482c2..baa5060 100644
--- a/samples/kfifo/dma-example.c
+++ b/samples/kfifo/dma-example.c
@@ -45,6 +45,9 @@ static int __init example_init(void)
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&fifo));
 
+	/* initialize scatterlist */
+	sg_init_table(sg, ARRAY_SIZE(sg));
+
 	ret = kfifo_dma_in_prepare(&fifo, sg, ARRAY_SIZE(sg), FIFO_SIZE);
 	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
 
-- 
1.7.1


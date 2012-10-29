Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456Ab2J2WAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:00:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:47978 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761369Ab2J2ViA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:38:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Barry Song <Baohua.Song@csr.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 086/101] dmaengine: sirf: fix a typo in dma_prep_interleaved
Date: Mon, 29 Oct 2012 14:35:39 -0700
Message-Id: <20121029213249.881034728@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barry Song <Baohua.Song@csr.com>

commit 5997e089e4c3a7f0958a8fb0a54ec2b5a6f06168 upstream.

either DEV_TO_MEM or MEM_TO_DEV is supported, so change
OR to AND.

Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/sirf-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -428,7 +428,7 @@ static struct dma_async_tx_descriptor *s
 	unsigned long iflags;
 	int ret;
 
-	if ((xt->dir != DMA_MEM_TO_DEV) || (xt->dir != DMA_DEV_TO_MEM)) {
+	if ((xt->dir != DMA_MEM_TO_DEV) && (xt->dir != DMA_DEV_TO_MEM)) {
 		ret = -EINVAL;
 		goto err_dir;
 	}



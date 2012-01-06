Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2AFMMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:12:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57558 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2AFMMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:12:39 -0500
Date: Fri, 6 Jan 2012 13:12:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH/RFC] dmaengine: shdma: clear channel buffers on TERMINATE_ALL
Message-ID: <Pine.LNX.4.64.1201061306550.16279@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:QR57NUAjp7nm/iwEI7/evjsKEBBDIk4xbE12iG7b3Mj
 Ltf4KJXilYICNqNAnK6Kj57OrwQktRsuoAdvNDUTkEy4UzL+WC
 Gz5gs8l70NPMnH5NxwMD5LRMrPXDhEE0IFyn2VHsoklaSdmwXB
 U53E47gfgQ3b/fFgAAvqadjecdDS8lUj75A3eHH6nTNv18isE+
 SKEFy8nH3SnIBOnQfCxSAGXPF2rmr/oWhg5us3akeuWQDONH2M
 O88bhvGEZkodVSRVEaCx9STte6W3K5dKQ/MVw8fbVTGQUFY5FH
 jJJWkPU1NNjOWlzNymGWCS4gLhiDFN47m3/cji+Lx1vDetmdoZ
 aKCMSpke4IBfZlGEXal9z0M1+W1TVb0uVxX7JSzhMjg3Oyte2l
 oYDNzgTrTfCWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

No, I don't have a bug for this fix:-) That's why I marked it an RFC and, 
actually, I wouldn't apply it. Clearing the buffers seems to be a good 
idea to me, but so far I haven't had a case, where it was needed. Let's 
just have this patch out there in archives in case we need it one day.

 drivers/dma/shdma.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index e1a2fa6..cabcfe8 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -707,6 +707,7 @@ static int sh_dmae_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 			   unsigned long arg)
 {
 	struct sh_dmae_chan *sh_chan = to_sh_chan(chan);
+	struct sh_dmae_device *shdev = to_sh_dev(sh_chan);
 	unsigned long flags;
 
 	/* Only supports DMA_TERMINATE_ALL */
@@ -719,6 +720,9 @@ static int sh_dmae_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	spin_lock_irqsave(&sh_chan->desc_lock, flags);
 	dmae_halt(sh_chan);
 
+	if (shdev->pdata->chclr_present)
+		chclr_write(sh_chan, 0);
+
 	if (!list_empty(&sh_chan->ld_queue)) {
 		/* Record partial transfer */
 		struct sh_desc *desc = list_entry(sh_chan->ld_queue.next,
-- 
1.7.2.5


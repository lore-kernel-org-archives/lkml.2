Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2DSKUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 06:20:44 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:64100 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab2DSKUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 06:20:40 -0400
From: ciminaghi@gnudd.com
To: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com, pgeninatti@soft-in.com, acolosimo@soft-in.com,
        alarosa@openintellect.eu, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH] dmaengine/amba-pl08x : reset phychan_hold on terminate all
Date: Thu, 19 Apr 2012 12:20:24 +0200
Message-Id: <1334830824-10908-1-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

When a client calls pl08x_control with DMA_TERMINATE_ALL, it is correct
to terminate and release the phy channel currently in use (if one is in use),
but the phychan_hold counter must also be reset (otherwise it could get
trapped in an unbalanced state).

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/dma/amba-pl08x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index c301a8e..3d704ab 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1429,6 +1429,7 @@ static int pl08x_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 			 * signal
 			 */
 			release_phy_channel(plchan);
+			plchan->phychan_hold = 0;
 		}
 		/* Dequeue jobs and free LLIs */
 		if (plchan->at) {
-- 
1.7.9.1


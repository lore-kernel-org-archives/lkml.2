Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2HFK4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:56:40 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:40378
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab2HFK4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:56:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: <qiang.liu@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@gmail.com>, <vinod.koul@intel.com>
CC: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
        <davem@davemloft.net>, <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Qiang Liu <qiang.liu@freescale.com>, Li Yang <leoli@freescale.com>
Subject: [PATCH v6 7/8] fsl-dma: fix a warning of unitialized cookie
Date: Mon, 6 Aug 2012 18:14:58 +0800
Message-ID: <1344248098-9360-1-git-send-email-qiang.liu@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qiang Liu <qiang.liu@freescale.com>

Fix a warning of unitialized value when compile with -Wuninitialized.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
Reported-by: Kim Phillips <kim.phillips@freescale.com>
Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 3f809df..6275bdf 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -405,7 +405,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
 	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
 	struct fsl_desc_sw *child;
-	dma_cookie_t cookie;
+	dma_cookie_t cookie = 0;

 	spin_lock_bh(&chan->desc_lock);

--
1.7.5.1



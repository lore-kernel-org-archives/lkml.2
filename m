Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab0HaMNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:13:23 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:39061 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932273Ab0HaMNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:13:20 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 06/12] DMAENGINE: free txd list if submission fails on PL08X
Date: Tue, 31 Aug 2010 14:12:08 +0200
Message-ID: <1283256734-3408-7-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1283256734-3408-6-git-send-email-linus.walleij@stericsson.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-2-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-3-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-4-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-5-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-6-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes oversubscribed channels fail to mux in a signal line for
the transmission, and we bail out. Make sure we also clean out any
pending txd lists when this happens.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/amba-pl08x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 65f595c..65892d5 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1270,6 +1270,7 @@ static dma_cookie_t pl08x_tx_submit(struct dma_async_tx_descriptor *tx)
 	ret = prep_phy_channel(plchan, txd);
 	if (ret) {
 		/* No physical channel available, cope with it */
+		pl08x_free_txd_list(pl08x, plchan);
 		spin_unlock_irqrestore(&plchan->lock, flags);
 		return -EBUSY;
 	}
-- 
1.6.3.3


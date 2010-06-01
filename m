Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0FAMW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:22:59 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:59598 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756678Ab0FAMW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:22:56 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 17/18] DMAENGINE: ste_dma40: support disabling physical channels
Date: Tue, 1 Jun 2010 14:22:44 +0200
Message-ID: <1275394964-26865-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

This makes it possible to disable physical channels.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 5cde3c3..0829ddb 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2236,6 +2236,14 @@ static int __init d40_phy_res_init(struct d40_base *base)
 		}
 		spin_lock_init(&base->phy_res[i].lock);
 	}
+
+	/* Mark disabled channels as occupied */
+	for (i = 0; base->plat_data->disabled_channels[i] != -1; i++) {
+			base->phy_res[i].allocated_src = D40_ALLOC_PHY;
+			base->phy_res[i].allocated_dst = D40_ALLOC_PHY;
+			num_phy_chans_avail--;
+	}
+
 	dev_info(base->dev, "%d of %d physical DMA channels available\n",
 		 num_phy_chans_avail, base->num_phy_chans);
 
-- 
1.6.3.3


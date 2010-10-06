Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab0JFIVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 04:21:11 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:53941 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106Ab0JFIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 04:21:05 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/4] DMAENGINE: ste_dma40: fix disabled channels list
Date: Wed, 6 Oct 2010 10:20:35 +0200
Message-ID: <1286353238-13742-2-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286353238-13742-1-git-send-email-linus.walleij@stericsson.com>
References: <1286353238-13742-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

The value in the array, not the index, specifies the channel to be
disabled.

Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 05d0a99..2f73e36 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2449,9 +2449,11 @@ static int __init d40_phy_res_init(struct d40_base *base)
 
 	/* Mark disabled channels as occupied */
 	for (i = 0; base->plat_data->disabled_channels[i] != -1; i++) {
-			base->phy_res[i].allocated_src = D40_ALLOC_PHY;
-			base->phy_res[i].allocated_dst = D40_ALLOC_PHY;
-			num_phy_chans_avail--;
+		int chan = base->plat_data->disabled_channels[i];
+
+		base->phy_res[chan].allocated_src = D40_ALLOC_PHY;
+		base->phy_res[chan].allocated_dst = D40_ALLOC_PHY;
+		num_phy_chans_avail--;
 	}
 
 	dev_info(base->dev, "%d of %d physical DMA channels available\n",
-- 
1.6.3.3


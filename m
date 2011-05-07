Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab1EGPKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 11:10:11 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:38565 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682Ab1EGPKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 11:10:08 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] dmaengine/ste_dma40: fix introduced warnings
Date: Sat, 7 May 2011 17:09:43 +0200
Message-ID: <1304780983-14492-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@linaro.org>

The compiler nowadays moans about possibly non-assigned variable.
Fix this by default-assigning 0.

Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 94ee15d..f3dcd25 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1829,7 +1829,7 @@ d40_get_dev_addr(struct d40_chan *chan, enum dma_data_direction direction)
 {
 	struct stedma40_platform_data *plat = chan->base->plat_data;
 	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
-	dma_addr_t addr;
+	dma_addr_t addr = 0;
 
 	if (chan->runtime_addr)
 		return chan->runtime_addr;
-- 
1.7.3.2


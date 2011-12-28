Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab1L1F6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 00:58:13 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:45298 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167Ab1L1F6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 00:58:11 -0500
From: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>
Cc: <linus.walleij@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Subject: [PATCH] dmaengine/ste_dma40: clear LNK on channel startup
Date: Wed, 28 Dec 2011 11:27:40 +0530
Message-ID: <1325051860-12372-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Otherwise if a previously physical channel is used as a logical channel, the
LNK may have old values which affect the operation of the logical channel since
the LNK register has different semantics between physical and logical channels.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
---
 drivers/dma/ste_dma40.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 972dc35..cc5ecbc
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1104,6 +1104,10 @@ static void d40_config_write(struct d40_chan *d40c)
 		/* Set LIDX for lcla */
 		writel(lidx, chanbase + D40_CHAN_REG_SSELT);
 		writel(lidx, chanbase + D40_CHAN_REG_SDELT);
+
+		/* Clear LNK which will be used by d40_chan_has_events() */
+		writel(0, chanbase + D40_CHAN_REG_SSLNK);
+		writel(0, chanbase + D40_CHAN_REG_SDLNK);
 	}
 }
 
-- 
1.7.4.3


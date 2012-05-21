Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab2EUVCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:02:18 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:12669
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758663Ab2EUVCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:02:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah)
From: Fabio Estevam <fabio.estevam@freescale.com>
CC: <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <g.liakhovetski@gmx.de>, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: dmaengine: Lower the priority of 'failed to get' dma channel message
Date: Mon, 21 May 2012 18:02:02 -0300
Message-ID: <1337634122-26712-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do the same as commit a03a202e9 (dmaengine: failure to get a specific DMA channel is not critical) 
and get rid of the following messages during kernel boot:

dmaengine_get: failed to get dma1chan0: (-22)
dmaengine_get: failed to get dma1chan1: (-22)
dmaengine_get: failed to get dma1chan2: (-22)
dmaengine_get: failed to get dma1chan3: (-22)
dmaengine_get: failed to get dma1chan4: (-22)
dmaengine_get: failed to get dma1chan5: (-22)
dmaengine_get: failed to get dma1chan6: (-22)
dmaengine_get: failed to get dma1chan7: (-22)
dmaengine_get: failed to get dma1chan8: (-22)
dmaengine_get: failed to get dma1chan9: (-22)
dmaengine_get: failed to get dma1chan10: (-22)
dmaengine_get: failed to get dma1chan11: (-22)
dmaengine_get: failed to get dma1chan12: (-22)
dmaengine_get: failed to get dma1chan13: (-22)
dmaengine_get: failed to get dma1chan14: (-22)
dmaengine_get: failed to get dma1chan15: (-22)
dmaengine_get: failed to get dma1chan16: (-22)
dmaengine_get: failed to get dma1chan17: (-22)
dmaengine_get: failed to get dma1chan18: (-22)
dmaengine_get: failed to get dma1chan19: (-22)
dmaengine_get: failed to get dma1chan20: (-22)
dmaengine_get: failed to get dma1chan21: (-22)
dmaengine_get: failed to get dma1chan22: (-22)
dmaengine_get: failed to get dma1chan23: (-22)
dmaengine_get: failed to get dma1chan24: (-22)
dmaengine_get: failed to get dma1chan25: (-22)
dmaengine_get: failed to get dma1chan26: (-22)
dmaengine_get: failed to get dma1chan27: (-22)
dmaengine_get: failed to get dma1chan28: (-22)
dmaengine_get: failed to get dma1chan29: (-22)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/dmaengine.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 2397f6f..6c87d67 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -578,7 +578,7 @@ void dmaengine_get(void)
 				list_del_rcu(&device->global_node);
 				break;
 			} else if (err)
-				pr_err("%s: failed to get %s: (%d)\n",
+				pr_debug("%s: failed to get %s: (%d)\n",
 					__func__, dma_chan_name(chan), err);
 		}
 	}
-- 
1.7.1



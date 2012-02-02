Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab2BBVdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:33:54 -0500
Received: from mxout1.idt.com ([157.165.5.25]:57382 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932766Ab2BBVdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:33:52 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 03/11] plat-samsung: add context parameter for DMA_SLAVE and DMA_CYCLIC
Date: Thu,  2 Feb 2012 16:32:13 -0500
Message-Id: <1328218341-31436-4-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup for added context parameter to DMA_SLAVE and DMA_CYCLIC interfaces.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/plat-samsung/dma-ops.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-samsung/dma-ops.c b/arch/arm/plat-samsung/dma-ops.c
index 0747c77..726dc30 100644
--- a/arch/arm/plat-samsung/dma-ops.c
+++ b/arch/arm/plat-samsung/dma-ops.c
@@ -80,11 +80,12 @@ static int samsung_dmadev_prepare(unsigned ch,
 		sg_dma_address(&sg) = info->buf;
 
 		desc = chan->device->device_prep_slave_sg(chan,
-			&sg, 1, info->direction, DMA_PREP_INTERRUPT);
+			&sg, 1, info->direction, DMA_PREP_INTERRUPT, NULL);
 		break;
 	case DMA_CYCLIC:
 		desc = chan->device->device_prep_dma_cyclic(chan,
-			info->buf, info->len, info->period, info->direction);
+			info->buf, info->len, info->period, info->direction,
+			NULL);
 		break;
 	default:
 		dev_err(&chan->dev->device, "unsupported format\n");
-- 
1.7.8.4


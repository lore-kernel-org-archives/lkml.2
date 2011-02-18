Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1BREaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:30:12 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:21088 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981Ab1BREaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:30:10 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 2/2] pch_dma: set the number of array correctly
Date: Fri, 18 Feb 2011 13:31:21 +0900
Message-Id: <1298003481-12845-2-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298003481-12845-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1298003481-12845-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set the number of array correctly.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/pch_dma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index bf2ddd6..b1dfba7 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -82,7 +82,7 @@ struct pch_dma_regs {
 	u32	dma_sts1;
 	u32	reserved2;
 	u32	reserved3;
-	struct pch_dma_desc_regs desc[0];
+	struct pch_dma_desc_regs desc[MAX_CHAN_NR];
 };
 
 struct pch_dma_desc {
@@ -124,7 +124,7 @@ struct pch_dma {
 	struct pci_pool		*pool;
 	struct pch_dma_regs	regs;
 	struct pch_dma_desc_regs ch_regs[MAX_CHAN_NR];
-	struct pch_dma_chan	channels[0];
+	struct pch_dma_chan	channels[MAX_CHAN_NR];
 };
 
 #define PCH_DMA_CTL0	0x00
-- 
1.7.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1ALN3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:29:16 -0500
Received: from mail.atmel.fr ([81.80.104.162]:36330 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398Ab1ALN3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:29:14 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hong.xu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/6] dmaengine: at_hdmac: no need set ACK in new descriptor
Date: Wed, 12 Jan 2011 15:39:07 +0100
Message-Id: <1294843150-6962-2-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
References: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following descriptor flow in at_hdmac driver, descriptor comming from
atc_desc_get() as already DMA_CTRL_ACK flag set. No need to set it again.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index a4dd4bc..4f83431 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -583,7 +583,6 @@ atc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		desc->lli.ctrlb = ctrlb;
 
 		desc->txd.cookie = 0;
-		async_tx_ack(&desc->txd);
 
 		if (!first) {
 			first = desc;
-- 
1.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab0LMLjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 06:39:48 -0500
Received: from mail.atmel.fr ([81.80.104.162]:62865 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab0LMLjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 06:39:47 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, avictor.za@gmail.com, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dmaengine: at_hdmac: fix buffer transfer size specification
Date: Mon, 13 Dec 2010 13:48:41 +0100
Message-Id: <1292244521-20756-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buffer transfer size is the number of transfers to be performed in
relation with the width of the _source_ interface.
So in the DMA_FROM_DEVICE case, it should be the register width that
should be taken into account.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index a0f3e6a..ea0ee81 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -722,7 +722,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			desc->lli.daddr = mem;
 			desc->lli.ctrla = ctrla
 					| ATC_DST_WIDTH(mem_width)
-					| len >> mem_width;
+					| len >> reg_width;
 			desc->lli.ctrlb = ctrlb;
 
 			if (!first) {
-- 
1.7.3


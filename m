Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab1ALN3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:29:17 -0500
Received: from mail.atmel.fr ([81.80.104.162]:36332 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab1ALN3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:29:14 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hong.xu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 5/6] dmaengine: at_hdmac: flags located in first descriptor
Date: Wed, 12 Jan 2011 15:39:09 +0100
Message-Id: <1294843150-6962-4-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
References: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Place flags on first descriptor of chain instead of last.
This is the one used by atc_chain_complete() function while unmapping.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index a1a0fc6..99942a5 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -603,7 +603,7 @@ atc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	/* set end-of-link to the last link descriptor of list*/
 	set_desc_eol(desc);
 
-	desc->txd.flags = flags; /* client is in control of this ack */
+	first->txd.flags = flags; /* client is in control of this ack */
 
 	return &first->txd;
 
@@ -748,8 +748,8 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	first->txd.cookie = -EBUSY;
 	first->len = total_len;
 
-	/* last link descriptor of list is responsible of flags */
-	prev->txd.flags = flags; /* client is in control of this ack */
+	/* first link descriptor of list is responsible of flags */
+	first->txd.flags = flags; /* client is in control of this ack */
 
 	return &first->txd;
 
-- 
1.7.3


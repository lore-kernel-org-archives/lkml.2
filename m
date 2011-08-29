Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1H2Lew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:34:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58436 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab1H2LeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:34:12 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linaro-dev@lists.linaro.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 2/4] dmaengine/ste_dma40: remove duplicate call to d40_pool_lli_free().
Date: Mon, 29 Aug 2011 13:33:33 +0200
Message-Id: <1314617615-2394-3-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
References: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d40_desc_free() already calls d40_pool_lli_free().

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/dma/ste_dma40.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 486b6c0..37388d1 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -478,7 +478,6 @@ static struct d40_desc *d40_desc_get(struct d40_chan *d40c)
 
 		list_for_each_entry_safe(d, _d, &d40c->client, node)
 			if (async_tx_test_ack(&d->txd)) {
-				d40_pool_lli_free(d40c, d);
 				d40_desc_remove(d);
 				desc = d;
 				memset(desc, 0, sizeof(*desc));
@@ -1209,7 +1208,6 @@ static void dma_tasklet(unsigned long data)
 
 	if (!d40d->cyclic) {
 		if (async_tx_test_ack(&d40d->txd)) {
-			d40_pool_lli_free(d40c, d40d);
 			d40_desc_remove(d40d);
 			d40_desc_free(d40c, d40d);
 		} else {
@@ -1606,7 +1604,6 @@ static int d40_free_dma(struct d40_chan *d40c)
 	/* Release client owned descriptors */
 	if (!list_empty(&d40c->client))
 		list_for_each_entry_safe(d, _d, &d40c->client, node) {
-			d40_pool_lli_free(d40c, d);
 			d40_desc_remove(d);
 			d40_desc_free(d40c, d);
 		}
-- 
1.7.4.1


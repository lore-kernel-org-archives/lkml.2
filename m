Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1AYKZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:25:44 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:33189 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab1AYKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:26 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 13/32] dma40: remove unnecessary casts
Date: Tue, 25 Jan 2011 11:18:16 +0100
Message-ID: <1295950715-22340-14-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index b585686..bd72269 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -357,14 +357,12 @@ static int d40_pool_lli_alloc(struct d40_chan *d40c, struct d40_desc *d40d,
 	}
 
 	if (is_log) {
-		d40d->lli_log.src = PTR_ALIGN((struct d40_log_lli *) base,
-					      align);
+		d40d->lli_log.src = PTR_ALIGN(base, align);
 		d40d->lli_log.dst = d40d->lli_log.src + lli_len;
 
 		d40d->lli_pool.dma_addr = 0;
 	} else {
-		d40d->lli_phy.src = PTR_ALIGN((struct d40_phy_lli *)base,
-					      align);
+		d40d->lli_phy.src = PTR_ALIGN(base, align);
 		d40d->lli_phy.dst = d40d->lli_phy.src + lli_len;
 
 		d40d->lli_pool.dma_addr = dma_map_single(d40c->base->dev,
-- 
1.7.3.2


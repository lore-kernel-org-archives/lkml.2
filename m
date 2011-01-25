Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1AYKTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:30 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:34083 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213Ab1AYKTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:15 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 09/32] dma40: remove unnecessary ALIGN()s
Date: Tue, 25 Jan 2011 11:18:12 +0100
Message-ID: <1295950715-22340-10-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

ALIGN(x * y, y) == x * y
ALIGN(aligned + x * y, y) == aligned + x * y

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ce55162..d32a9ac 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -344,7 +344,7 @@ static int d40_pool_lli_alloc(struct d40_desc *d40d,
 		d40d->lli_pool.size = sizeof(d40d->lli_pool.pre_alloc_lli);
 		d40d->lli_pool.base = NULL;
 	} else {
-		d40d->lli_pool.size = ALIGN(lli_len * 2 * align, align);
+		d40d->lli_pool.size = lli_len * 2 * align;
 
 		base = kmalloc(d40d->lli_pool.size + align, GFP_NOWAIT);
 		d40d->lli_pool.base = base;
@@ -356,13 +356,11 @@ static int d40_pool_lli_alloc(struct d40_desc *d40d,
 	if (is_log) {
 		d40d->lli_log.src = PTR_ALIGN((struct d40_log_lli *) base,
 					      align);
-		d40d->lli_log.dst = PTR_ALIGN(d40d->lli_log.src + lli_len,
-					      align);
+		d40d->lli_log.dst = d40d->lli_log.src + lli_len;
 	} else {
 		d40d->lli_phy.src = PTR_ALIGN((struct d40_phy_lli *)base,
 					      align);
-		d40d->lli_phy.dst = PTR_ALIGN(d40d->lli_phy.src + lli_len,
-					      align);
+		d40d->lli_phy.dst = d40d->lli_phy.src + lli_len;
 	}
 
 	return 0;
-- 
1.7.3.2


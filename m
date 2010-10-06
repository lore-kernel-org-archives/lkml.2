Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab0JFIVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 04:21:14 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:60929 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757265Ab0JFIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 04:21:05 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/4] DMAENGINE: ste_dma40: fix clk_get failure path
Date: Wed, 6 Oct 2010 10:20:36 +0200
Message-ID: <1286353238-13742-3-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286353238-13742-2-git-send-email-linus.walleij@stericsson.com>
References: <1286353238-13742-1-git-send-email-linus.walleij@stericsson.com>
 <1286353238-13742-2-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

clk_get returns an ERR_PTR.

Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 2f73e36..8596c31 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2636,7 +2636,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	return base;
 
 failure:
-	if (clk) {
+	if (!IS_ERR(clk)) {
 		clk_disable(clk);
 		clk_put(clk);
 	}
-- 
1.6.3.3


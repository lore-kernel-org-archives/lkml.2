Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0JJR2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:28:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38797 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab0JJR23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CmEwQHy1r46BWKhO0s+05L7Xtj8p9tNqftXFEvHf336p4Nzq5y8/46VqOzP9dDvs/S
         SPRvGh5BpyFTkqHORmxIldqyrnEIyaohA53MllIEESjuqICE5uQpexpnz3cj5zfoyPaP
         Jalz07zGW13rW2c9J4oMyc6DyEJrsLRIdJgy4=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm/imx: fix memory init in imx_dma_request()
Date: Sun, 10 Oct 2010 21:28:23 +0400
Message-Id: <1286731703-17775-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

imx_dma_request() didn't fill struct pointed by imxdma with zeroes
as it passed sizeof(pointer), not sizeof(struct) to memset().

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver, so it is not tested.

 arch/arm/mach-imx/dma-v1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-imx/dma-v1.c b/arch/arm/mach-imx/dma-v1.c
index 3e8c47c..b5cc027 100644
--- a/arch/arm/mach-imx/dma-v1.c
+++ b/arch/arm/mach-imx/dma-v1.c
@@ -699,7 +699,7 @@ int imx_dma_request(int channel, const char *name)
 		local_irq_restore(flags);
 		return -EBUSY;
 	}
-	memset(imxdma, 0, sizeof(imxdma));
+	memset(imxdma, 0, sizeof(*imxdma));
 	imxdma->name = name;
 	local_irq_restore(flags); /* request_irq() can block */
 
-- 
1.7.0.4


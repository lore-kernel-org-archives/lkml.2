Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0KZRGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:06:07 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42343 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0KZRGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=D/vSOP9yG5Y5RuCU7MYkYLez515smS4z44H8Hz8sSbcXevy9vJmYmgk9S912XfZf7B
         uXTLXZ43FVNzKyXvZBNxkeX0h8dUVTtY783Ez1xegrCH5r7dxq6DAlM6rzPgl5pu+E41
         Hl8+sQeDiXs40QpgSzjujeBB25MC4YPrdyXxs=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: dma: check clk_get() result
Date: Fri, 26 Nov 2010 20:05:55 +0300
Message-Id: <1290791157-21096-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() may return ERR_PTR(), if so propagate return code as
imx_dma_init() return code.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested at all.

 arch/arm/mach-imx/dma-v1.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/dma-v1.c b/arch/arm/mach-imx/dma-v1.c
index dcb24a9..e9f1769 100644
--- a/arch/arm/mach-imx/dma-v1.c
+++ b/arch/arm/mach-imx/dma-v1.c
@@ -821,6 +821,8 @@ static int __init imx_dma_init(void)
 		return 0;
 
 	dma_clk = clk_get(NULL, "dma");
+	if (IS_ERR(dma_clk))
+		return PTR_ERR(dma_clk);
 	clk_enable(dma_clk);
 
 	/* reset DMA module */
-- 
1.7.0.4


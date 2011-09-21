Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab1IUJdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:33:20 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:37829 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1IUJdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:33:17 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: [PATCH 29/57] crypto: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:30 +0800
Message-Id: <1316597339-29861-30-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/crypto/mv_cesa.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 5c6f56f..7a10360 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1041,8 +1041,7 @@ static int mv_probe(struct platform_device *pdev)
 		goto err_unmap_sram;
 	}
 
-	ret = request_irq(irq, crypto_int, IRQF_DISABLED, dev_name(&pdev->dev),
-			cp);
+	ret = request_irq(irq, crypto_int, 0, dev_name(&pdev->dev), cp);
 	if (ret)
 		goto err_thread;
 
-- 
1.7.4.1


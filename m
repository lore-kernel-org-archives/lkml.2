Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1IUJfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:35:30 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:37829 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab1IUJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:35:27 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Geoff Levand <geoff@infradead.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 45/57] powerpc/ps3: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:46 +0800
Message-Id: <1316597339-29861-46-git-send-email-yong.zhang0@gmail.com>
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
Acked-by: Geoff Levand <geoff@infradead.org>
---
 drivers/ps3/ps3-vuart.c   |    2 +-
 drivers/ps3/ps3stor_lib.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ps3/ps3-vuart.c b/drivers/ps3/ps3-vuart.c
index d9fb729..fb73008 100644
--- a/drivers/ps3/ps3-vuart.c
+++ b/drivers/ps3/ps3-vuart.c
@@ -952,7 +952,7 @@ static int ps3_vuart_bus_interrupt_get(void)
 	}
 
 	result = request_irq(vuart_bus_priv.virq, ps3_vuart_irq_handler,
-		IRQF_DISABLED, "vuart", &vuart_bus_priv);
+		0, "vuart", &vuart_bus_priv);
 
 	if (result) {
 		pr_debug("%s:%d: request_irq failed (%d)\n",
diff --git a/drivers/ps3/ps3stor_lib.c b/drivers/ps3/ps3stor_lib.c
index cc328de..8c3f5ad 100644
--- a/drivers/ps3/ps3stor_lib.c
+++ b/drivers/ps3/ps3stor_lib.c
@@ -167,7 +167,7 @@ int ps3stor_setup(struct ps3_storage_device *dev, irq_handler_t handler)
 		goto fail_close_device;
 	}
 
-	error = request_irq(dev->irq, handler, IRQF_DISABLED,
+	error = request_irq(dev->irq, handler, 0,
 			    dev->sbd.core.driver->name, dev);
 	if (error) {
 		dev_err(&dev->sbd.core, "%s:%u: request_irq failed %d\n",
-- 
1.7.4.1


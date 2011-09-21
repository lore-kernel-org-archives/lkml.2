Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1IUJfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:35:15 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:37829 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab1IUJfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:35:12 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com, Adam Belay <abelay@mit.edu>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 43/57] PNP: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:44 +0800
Message-Id: <1316597339-29861-44-git-send-email-yong.zhang0@gmail.com>
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
 drivers/pnp/resource.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index b0ecacb..3669821 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -385,7 +385,7 @@ int pnp_check_irq(struct pnp_dev *dev, struct resource *res)
 	 * device is active because it itself may be in use */
 	if (!dev->active) {
 		if (request_irq(*irq, pnp_test_handler,
-				IRQF_DISABLED | IRQF_PROBE_SHARED, "pnp", NULL))
+				IRQF_PROBE_SHARED, "pnp", NULL))
 			return 0;
 		free_irq(*irq, NULL);
 	}
-- 
1.7.4.1


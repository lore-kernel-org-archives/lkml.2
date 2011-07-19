Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1GSDWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 23:22:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61537 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1GSDWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 23:22:37 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] gpio/mxc/mxs: fix build error introduced by the reanming of irq_gc_ack()
Date: Tue, 19 Jul 2011 11:34:04 +0800
Message-Id: <1311046444-25423-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit renames irq_gc_ack() to irq_gc_ack_set_bit(),
and makes gpio-mxc and gpio-mxs fail to build.

  659fb32d1b67476f4ade25e9ea0e2642a5b9c4b5
  genirq: replace irq_gc_ack() with {set,clr}_bit variants (fwd)

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
The build error is being seen on linux-next.

 drivers/gpio/gpio-mxc.c |    2 +-
 drivers/gpio/gpio-mxs.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 89fda58..4a46fbe 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -297,7 +297,7 @@ static void __init mxc_gpio_init_gc(struct mxc_gpio_port *port)
 	gc->private = port;
 
 	ct = gc->chip_types;
-	ct->chip.irq_ack = irq_gc_ack,
+	ct->chip.irq_ack = irq_gc_ack_set_bit,
 	ct->chip.irq_mask = irq_gc_mask_clr_bit;
 	ct->chip.irq_unmask = irq_gc_mask_set_bit;
 	ct->chip.irq_set_type = gpio_set_irq_type;
diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index d8cafba..88f8506 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -156,7 +156,7 @@ static void __init mxs_gpio_init_gc(struct mxs_gpio_port *port)
 	gc->private = port;
 
 	ct = gc->chip_types;
-	ct->chip.irq_ack = irq_gc_ack,
+	ct->chip.irq_ack = irq_gc_ack_set_bit,
 	ct->chip.irq_mask = irq_gc_mask_clr_bit;
 	ct->chip.irq_unmask = irq_gc_mask_set_bit;
 	ct->chip.irq_set_type = mxs_gpio_set_irq_type;
-- 
1.7.4.1


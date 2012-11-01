Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547Ab2KAORN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:17:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46857 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2KAORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:17:12 -0400
Message-ID: <1351779418.11071.1.camel@phoenix>
Subject: [PATCH] irqchip: irq-bcm2835: Add terminating entry for
 of_device_id table
From: Axel Lin <axel.lin@ingics.com>
To: linux-kernel@vger.kernel.org
Cc: Stephen Warren <swarren@wwwdotorg.org>, Simon Arlott <simon@fire.lp0.eu>,
        Olof Johansson <olof@lixom.net>, linux-rpi-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Date: Thu, 01 Nov 2012 22:16:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/irqchip/irq-bcm2835.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-bcm2835.c b/drivers/irqchip/irq-bcm2835.c
index dc670cc..16c78f1 100644
--- a/drivers/irqchip/irq-bcm2835.c
+++ b/drivers/irqchip/irq-bcm2835.c
@@ -168,7 +168,8 @@ static int __init armctrl_of_init(struct device_node *node,
 }
 
 static struct of_device_id irq_of_match[] __initconst = {
-	{ .compatible = "brcm,bcm2835-armctrl-ic", .data = armctrl_of_init }
+	{ .compatible = "brcm,bcm2835-armctrl-ic", .data = armctrl_of_init },
+	{ }
 };
 
 void __init bcm2835_init_irq(void)
-- 
1.7.9.5




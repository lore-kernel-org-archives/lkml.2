Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab2I3IXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:23:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46710 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2I3IXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:23:43 -0400
Message-ID: <1348993407.20815.1.camel@phoenix>
Subject: [PATCH] gpio: mvebu: Add missing breaks in mvebu_gpio_irq_set_type
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Date: Sun, 30 Sep 2012 16:23:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/gpio-mvebu.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 902af43..7a874129 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -381,11 +381,13 @@ static int mvebu_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		u = readl_relaxed(mvebu_gpioreg_in_pol(mvchip));
 		u &= ~(1 << pin);
 		writel_relaxed(u, mvebu_gpioreg_in_pol(mvchip));
+		break;
 	case IRQ_TYPE_EDGE_FALLING:
 	case IRQ_TYPE_LEVEL_LOW:
 		u = readl_relaxed(mvebu_gpioreg_in_pol(mvchip));
 		u |= 1 << pin;
 		writel_relaxed(u, mvebu_gpioreg_in_pol(mvchip));
+		break;
 	case IRQ_TYPE_EDGE_BOTH: {
 		u32 v;
 
@@ -401,6 +403,7 @@ static int mvebu_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		else
 			u &= ~(1 << pin);	/* rising */
 		writel_relaxed(u, mvebu_gpioreg_in_pol(mvchip));
+		break;
 	}
 	}
 	return 0;
-- 
1.7.9.5




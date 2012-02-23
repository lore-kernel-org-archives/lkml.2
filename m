Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab2BWMKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:10:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46312 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab2BWMKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:10:41 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH 4/6] gpio/omap: get rid of retrigger variable in gpio_irq_handler
Date: Thu, 23 Feb 2012 17:40:29 +0530
Message-ID: <1329999031-6914-5-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This local variable is just assigned zero and then OR'ed
with isr. It does not appear to serve any purpose and so
removing it.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
---
 drivers/gpio/gpio-omap.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index b62e861..3dd4b3a 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -623,7 +623,6 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	u32 isr;
 	unsigned int gpio_irq, gpio_index;
 	struct gpio_bank *bank;
-	u32 retrigger = 0;
 	int unmasked = 0;
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 
@@ -660,8 +659,6 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 			chained_irq_exit(chip, desc);
 		}
 
-		isr |= retrigger;
-		retrigger = 0;
 		if (!isr)
 			break;
 
-- 
1.7.0.4


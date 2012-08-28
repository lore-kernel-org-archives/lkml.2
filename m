Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab2H1La6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:30:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50505 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2H1La5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:30:57 -0400
Message-ID: <1346153444.11862.1.camel@phoenix>
Subject: [PATCH] gpio: em: Fix checking return value of irq_alloc_descs
From: Axel Lin <axel.lin@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org
Date: Tue, 28 Aug 2012 19:30:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_alloc_descs() returns negative error code on failure.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-em.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
index ae37181..ec48ed5 100644
--- a/drivers/gpio/gpio-em.c
+++ b/drivers/gpio/gpio-em.c
@@ -247,9 +247,9 @@ static int __devinit em_gio_irq_domain_init(struct em_gio_priv *p)
 
 	p->irq_base = irq_alloc_descs(pdata->irq_base, 0,
 				      pdata->number_of_pins, numa_node_id());
-	if (IS_ERR_VALUE(p->irq_base)) {
+	if (p->irq_base < 0) {
 		dev_err(&pdev->dev, "cannot get irq_desc\n");
-		return -ENXIO;
+		return p->irq_base;
 	}
 	pr_debug("gio: hw base = %d, nr = %d, sw base = %d\n",
 		 pdata->gpio_base, pdata->number_of_pins, p->irq_base);
-- 
1.7.9.5




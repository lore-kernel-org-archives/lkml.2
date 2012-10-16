Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2JPTdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:33:11 -0400
Received: from mail.df.lth.se ([194.47.250.12]:44921 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935Ab2JPTdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:33:08 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 6/7] gpio/langwell: find the irq domain mapping
Date: Tue, 16 Oct 2012 21:23:23 +0200
Message-Id: <1350415403-3590-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from creating the IRQ domain mapping to finding it. In this
case we know very well that the driver has created the apropriate
mapping, we just need to locate it, no need to create any
on-the-fly mappings.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-langwell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 202a992..0c88fc6 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -177,7 +177,7 @@ static int lnw_gpio_direction_output(struct gpio_chip *chip,
 static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
 	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	return irq_create_mapping(lnw->domain, offset);
+	return irq_find_mapping(lnw->domain, offset);
 }
 
 static int lnw_irq_type(struct irq_data *d, unsigned type)
-- 
1.7.11.7


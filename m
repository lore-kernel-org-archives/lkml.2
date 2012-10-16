Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2JPTdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:33:13 -0400
Received: from mail.df.lth.se ([194.47.250.12]:44918 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab2JPTdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:33:08 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH 5/7] gpio/pcf857x: find the irq domain mapping
Date: Tue, 16 Oct 2012 21:23:12 +0200
Message-Id: <1350415392-3453-1-git-send-email-linus.walleij@linaro.org>
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
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-pcf857x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 16af35c..bf41cfc 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -164,7 +164,7 @@ static int pcf857x_to_irq(struct gpio_chip *chip, unsigned offset)
 {
 	struct pcf857x *gpio = container_of(chip, struct pcf857x, chip);
 
-	return irq_create_mapping(gpio->irq_domain, offset);
+	return irq_find_mapping(gpio->irq_domain, offset);
 }
 
 static void pcf857x_irq_demux_work(struct work_struct *work)
-- 
1.7.11.7


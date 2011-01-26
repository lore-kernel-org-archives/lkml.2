Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1AZG3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 01:29:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39158
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019Ab1AZG3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 01:29:13 -0500
Date: Tue, 25 Jan 2011 22:29:48 -0800 (PST)
Message-Id: <20110125.222948.112596409.davem@davemloft.net>
To: buytenh@secretlab.ca
CC: alek.du@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] langwell_gpio: Fix deprecated refs to irq_desc->chip and
 chip->eoi
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/gpio/langwell_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index d81cc74..a0d0c7b 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -206,7 +206,7 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 		/* clear the edge detect status bit */
 		writel(gedr_v, gedr);
 	}
-	desc->chip->eoi(irq);
+	desc->irq_data.chip->irq_eoi(&desc->irq_data);
 }
 
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
-- 
1.7.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab1DZM25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:28:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab1DZM2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:28:55 -0400
Subject: [PATCH] gpio: pca953x: Use handle_simple_irq instead of
 handle_edge_irq
From: Erik =?ISO-8859-1?Q?Bot=F6?= <erik.boto@pelagicore.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 14:28:49 +0200
Message-ID: <1303820929.12409.30.camel@erik-mbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pca953x driver use the simple irq handler since no hardware control 
is necessary and the driver lacks an irq_ack function. handle_edge_irq()
calls chip->irq_ack() which crashes since this function does not exist.

Signed-off-by: Erik Botö <erik.boto@pelagicore.com>
Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 7630ab7..78a8439 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -397,7 +397,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 
 			irq_set_chip_data(irq, chip);
 			irq_set_chip_and_handler(irq, &pca953x_irq_chip,
-						 handle_edge_irq);
+						 handle_simple_irq);
 #ifdef CONFIG_ARM
 			set_irq_flags(irq, IRQF_VALID);
 #else


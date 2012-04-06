Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab2DFMhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 08:37:50 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50816 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2DFMht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 08:37:49 -0400
Message-ID: <1333715863.17459.4.camel@phoenix>
Subject: [PATCH] gpio: Fix uninitialized variable bit in adp5588_irq_handler
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Date: Fri, 06 Apr 2012 20:37:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'bit' is uninitialized in the first iteration of for loop. Fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-adp5588.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-adp5588.c b/drivers/gpio/gpio-adp5588.c
index 9ad1703..ae5d7f1 100644
--- a/drivers/gpio/gpio-adp5588.c
+++ b/drivers/gpio/gpio-adp5588.c
@@ -252,7 +252,7 @@ static irqreturn_t adp5588_irq_handler(int irq, void *devid)
 		if (ret < 0)
 			memset(dev->irq_stat, 0, ARRAY_SIZE(dev->irq_stat));
 
-		for (bank = 0; bank <= ADP5588_BANK(ADP5588_MAXGPIO);
+		for (bank = 0, bit = 0; bank <= ADP5588_BANK(ADP5588_MAXGPIO);
 			bank++, bit = 0) {
 			pending = dev->irq_stat[bank] & dev->irq_mask[bank];
 
-- 
1.7.5.4




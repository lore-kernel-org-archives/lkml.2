Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2JKG4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 02:56:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49512 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2JKG4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 02:56:51 -0400
Date: Thu, 11 Oct 2012 09:56:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] gpio-timberdale: fix a potential wrapping issue
Message-ID: <20121011065635.GD31607@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->last_ier is an unsigned long but the high bits can't be used int the
original code because the shift wraps.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/gpio/gpio-timberdale.c b/drivers/gpio/gpio-timberdale.c
index 031c6ad..1a3e2b9 100644
--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -116,7 +116,7 @@ static void timbgpio_irq_disable(struct irq_data *d)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tgpio->lock, flags);
-	tgpio->last_ier &= ~(1 << offset);
+	tgpio->last_ier &= ~(1UL << offset);
 	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
 	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
@@ -128,7 +128,7 @@ static void timbgpio_irq_enable(struct irq_data *d)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tgpio->lock, flags);
-	tgpio->last_ier |= 1 << offset;
+	tgpio->last_ier |= 1UL << offset;
 	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
 	spin_unlock_irqrestore(&tgpio->lock, flags);
 }

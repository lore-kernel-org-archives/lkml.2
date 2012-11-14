Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2KNGHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:07:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54966 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864Ab2KNFuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:01 -0500
Message-Id: <20121114053936.245873596@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:50 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 17/82] gpio-timberdale: fix a potential wrapping issue
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d79550a7bc35c16476ebdc27c78378d8093390ec upstream.

->last_ier is an unsigned long but the high bits can't be used int the
original code because the shift wraps.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpio/gpio-timberdale.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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



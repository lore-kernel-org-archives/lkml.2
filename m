Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763173Ab2KBRN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:13:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:33287 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762363Ab2KBRHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 03/24] gpio-timberdale: fix a potential wrapping issue
Date: Fri,  2 Nov 2012 10:06:51 -0700
Message-Id: <20121102170247.673976782@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d79550a7bc35c16476ebdc27c78378d8093390ec upstream.

->last_ier is an unsigned long but the high bits can't be used int the
original code because the shift wraps.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-timberdale.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -116,7 +116,7 @@ static void timbgpio_irq_disable(struct
 	unsigned long flags;
 
 	spin_lock_irqsave(&tgpio->lock, flags);
-	tgpio->last_ier &= ~(1 << offset);
+	tgpio->last_ier &= ~(1UL << offset);
 	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
 	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
@@ -128,7 +128,7 @@ static void timbgpio_irq_enable(struct i
 	unsigned long flags;
 
 	spin_lock_irqsave(&tgpio->lock, flags);
-	tgpio->last_ier |= 1 << offset;
+	tgpio->last_ier |= 1UL << offset;
 	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
 	spin_unlock_irqrestore(&tgpio->lock, flags);
 }



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936265Ab2C3VlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:41:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53679 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936168Ab2C3Vbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:31:48 -0400
X-Sasl-enc: sf8CKixfpWT5YUcX3pCHzxpMMJmMrj0gLWJBvdNtlYbG 1333143108
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:55 2012
Message-Id: <20120330194855.097359331@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Kevin Hilman <khilman@ti.com>
Subject: [ 143/175] gpio/omap: fix _set_gpio_irqenable implementation
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tarun Kanti DebBarma <tarun.kanti@ti.com>

commit 8276536cec38bc6bde30d0aa67716f22b9b9705a upstream.

This function should be capable of both enabling and disabling interrupts
based upon the *enable* parameter. Right now the function only enables
the interrupt and *enable* is not used at all. So add the interrupt
disable capability also using the parameter.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-omap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -508,7 +508,10 @@ static void _disable_gpio_irqbank(struct
 
 static inline void _set_gpio_irqenable(struct gpio_bank *bank, int gpio, int enable)
 {
-	_enable_gpio_irqbank(bank, GPIO_BIT(bank, gpio));
+	if (enable)
+		_enable_gpio_irqbank(bank, GPIO_BIT(bank, gpio));
+	else
+		_disable_gpio_irqbank(bank, GPIO_BIT(bank, gpio));
 }
 
 /*



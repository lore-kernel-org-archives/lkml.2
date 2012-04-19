Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab2DSVLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:11:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab2DSVLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:11:40 -0400
Message-Id: <20120419210305.679571778@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yuriy Kozlov <ykozlov@ptcusa.com>,
        Tobias Klauser <tklauser@distanz.ch>
Subject: [ 30/75] tty: serial: altera_uart: Check for NULL platform_data in probe.
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuriy Kozlov <ykozlov@ptcusa.com>

commit acede70d6561f2d042d9dbb153d9a3469479c0ed upstream.

Follow altera_jtag_uart.  This fixes a crash if there is a mistake in the DTS.

Signed-off-by: Yuriy Kozlov <ykozlov@ptcusa.com>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/altera_uart.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -555,7 +555,7 @@ static int __devinit altera_uart_probe(s
 	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res_mem)
 		port->mapbase = res_mem->start;
-	else if (platp->mapbase)
+	else if (platp)
 		port->mapbase = platp->mapbase;
 	else
 		return -EINVAL;
@@ -563,7 +563,7 @@ static int __devinit altera_uart_probe(s
 	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res_irq)
 		port->irq = res_irq->start;
-	else if (platp->irq)
+	else if (platp)
 		port->irq = platp->irq;
 
 	/* Check platform data first so we can override device node data */



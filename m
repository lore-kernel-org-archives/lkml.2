Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2E0BBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:01:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab2E0BBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:01:32 -0400
Message-Id: <20120527002622.539491453@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:27:08 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [ 55/55] i2c: davinci: Free requested IRQ in remove
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

commit 9868a060ccf769c08ec378a9829137e272e9a92c upstream.

The freed IRQ is not necessary the one requested in probe.
Even if it was, with two or more i2c-controllers it will fails anyway.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-davinci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -755,7 +755,7 @@ static int davinci_i2c_remove(struct pla
 	dev->clk = NULL;
 
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, 0);
-	free_irq(IRQ_I2C, dev);
+	free_irq(dev->irq, dev);
 	iounmap(dev->base);
 	kfree(dev);
 



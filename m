Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2E1Dl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:41:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52185 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754120Ab2E1D3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:39 -0400
Message-Id: <20120528031218.170012094@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [ 111/117] i2c: davinci: Free requested IRQ in remove
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

commit 9868a060ccf769c08ec378a9829137e272e9a92c upstream.

The freed IRQ is not necessary the one requested in probe.
Even if it was, with two or more i2c-controllers it will fails anyway.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/i2c/busses/i2c-davinci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index a76d85f..79b4bcb 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -755,7 +755,7 @@ static int davinci_i2c_remove(struct platform_device *pdev)
 	dev->clk = NULL;
 
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, 0);
-	free_irq(IRQ_I2C, dev);
+	free_irq(dev->irq, dev);
 	iounmap(dev->base);
 	kfree(dev);
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab0LMA2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:28:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44726 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab0LLXp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:27 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: nobuhiro.iwamatsu.yj@renesas.com, w.sang@pengutronix.de,
        khali@linux-fr.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [30/223] i2c-pca-platform: Change device name of request_irq
Message-Id: <20101212234526.72F5DB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

commit 323584436db0cb05286425d4dfd9516fce88487f upstream.

i2c->adap.name shouldn't be used in request_irq.
Instead the driver name "i2c-pca-platform" should be used.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/i2c/busses/i2c-pca-platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/i2c/busses/i2c-pca-platform.c
===================================================================
--- linux.orig/drivers/i2c/busses/i2c-pca-platform.c
+++ linux/drivers/i2c/busses/i2c-pca-platform.c
@@ -224,7 +224,7 @@ static int __devinit i2c_pca_pf_probe(st
 
 	if (irq) {
 		ret = request_irq(irq, i2c_pca_pf_handler,
-			IRQF_TRIGGER_FALLING, i2c->adap.name, i2c);
+			IRQF_TRIGGER_FALLING, pdev->name, i2c);
 		if (ret)
 			goto e_reqirq;
 	}

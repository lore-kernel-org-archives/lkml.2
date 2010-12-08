Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab0LHAqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:46:36 -0500
Received: from kroah.org ([198.145.64.141]:45849 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab0LHAqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:34 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:25 2010
Message-Id: <20101208004425.184054304@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>
Subject: [008/127] i2c-pca-platform: Change device name of request_irq
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

commit 323584436db0cb05286425d4dfd9516fce88487f upstream.

i2c->adap.name shouldn't be used in request_irq.
Instead the driver name "i2c-pca-platform" should be used.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-pca-platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -224,7 +224,7 @@ static int __devinit i2c_pca_pf_probe(st
 
 	if (irq) {
 		ret = request_irq(irq, i2c_pca_pf_handler,
-			IRQF_TRIGGER_FALLING, i2c->adap.name, i2c);
+			IRQF_TRIGGER_FALLING, pdev->name, i2c);
 		if (ret)
 			goto e_reqirq;
 	}



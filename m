Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab2KSMSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 07:18:42 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:55668 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231Ab2KSMSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 07:18:40 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1de0h1202h1d1ah1d2ahzz8275ch8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <kernel@pengutronix.de>, <br@ioremap.net>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v3 1/3] w1: mxc_w1: Adapt the clock name to the new clock framework
Date: Mon, 19 Nov 2012 10:18:22 -0200
Message-ID: <1353327504-2740-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new i.mx clock framework the mxc_w1 clock is registered as:

clk_register_clkdev(clk[owire_gate], NULL, "mxc_w1.0");

So we do not need to pass "owire" string and can use NULL instead.

While at it, also fix the clock error handling code.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
-----
Changes since v2:
- Add Ack's
Changes since v1:
- Fix clock error handling
 drivers/w1/masters/mxc_w1.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 1cc61a7..960b362 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -117,11 +117,11 @@ static int __devinit mxc_w1_probe(struct platform_device *pdev)
 	if (!mdev)
 		return -ENOMEM;
 
-	mdev->clk = clk_get(&pdev->dev, "owire");
-	if (!mdev->clk) {
-		err = -ENODEV;
-		goto failed_clk;
-	}
+	mdev->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(mdev->clk)) {
+		err = PTR_ERR(mdev->clk);
+		goto failed_clk;
+	}
 
 	mdev->clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
 
-- 
1.7.9.5



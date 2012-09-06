Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163Ab2IFQtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:49:23 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:12458
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759086Ab2IFQtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:49:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <zbr@ioremap.net>
CC: <s.hauer@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 1/3] w1: mxc_w1: Adapt the clock name to the new clock framework
Date: Thu, 6 Sep 2012 13:48:59 -0300
Message-ID: <1346950139-17059-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new i.mx clock framework the mxc_w1 clock is registered as:

clk_register_clkdev(clk[owire_gate], NULL, "mxc_w1.0"

So we do not need to pass "owire" string and can use NULL instead.

While at it, also fix the clock error handling code.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
-----
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



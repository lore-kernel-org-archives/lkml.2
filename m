Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab2KSMSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 07:18:51 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:1945
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233Ab2KSMSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 07:18:42 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <kernel@pengutronix.de>, <br@ioremap.net>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v3 3/3] w1: mxc_w1: Convert to platform driver
Date: Mon, 19 Nov 2012 10:18:24 -0200
Message-ID: <1353327504-2740-3-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353327504-2740-1-git-send-email-fabio.estevam@freescale.com>
References: <1353327504-2740-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using module_platform_driver() makes the code smaller and cleaner.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v2:
- No changes
 drivers/w1/masters/mxc_w1.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 25b234c..a06514b 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -191,21 +191,9 @@ static struct platform_driver mxc_w1_driver = {
 		   .name = "mxc_w1",
 	},
 	.probe = mxc_w1_probe,
-	.remove = mxc_w1_remove,
+	.remove = __devexit_p(mxc_w1_remove),
 };
-
-static int __init mxc_w1_init(void)
-{
-	return platform_driver_register(&mxc_w1_driver);
-}
-
-static void mxc_w1_exit(void)
-{
-	platform_driver_unregister(&mxc_w1_driver);
-}
-
-module_init(mxc_w1_init);
-module_exit(mxc_w1_exit);
+module_platform_driver(mxc_w1_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Freescale Semiconductors Inc");
-- 
1.7.9.5



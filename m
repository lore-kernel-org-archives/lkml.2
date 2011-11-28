Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1K1BYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 20:24:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45542 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab1K1BYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 20:24:13 -0500
Message-ID: <1322443443.2408.0.camel@phoenix>
Subject: [PATCH v2] net/irda: convert drivers/net/irda/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Samuel Ortiz <samuel@sortiz.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date: Mon, 28 Nov 2011 09:24:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/net/irda/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
v2: re-generate the patch against net-next tree.

 drivers/net/irda/bfin_sir.c   |   13 +------------
 drivers/net/irda/pxaficp_ir.c |   13 +------------
 drivers/net/irda/sh_irda.c    |   13 +------------
 drivers/net/irda/sh_sir.c     |   13 +------------
 4 files changed, 4 insertions(+), 48 deletions(-)

diff --git a/drivers/net/irda/bfin_sir.c b/drivers/net/irda/bfin_sir.c
index 9d4ce1a..a561ae4 100644
--- a/drivers/net/irda/bfin_sir.c
+++ b/drivers/net/irda/bfin_sir.c
@@ -806,18 +806,7 @@ static struct platform_driver bfin_ir_driver = {
 	},
 };
 
-static int __init bfin_sir_init(void)
-{
-	return platform_driver_register(&bfin_ir_driver);
-}
-
-static void __exit bfin_sir_exit(void)
-{
-	platform_driver_unregister(&bfin_ir_driver);
-}
-
-module_init(bfin_sir_init);
-module_exit(bfin_sir_exit);
+module_platform_driver(bfin_ir_driver);
 
 module_param(max_rate, int, 0);
 MODULE_PARM_DESC(max_rate, "Maximum baud rate (115200, 57600, 38400, 19200, 9600)");
diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
index d0851df..81d5275 100644
--- a/drivers/net/irda/pxaficp_ir.c
+++ b/drivers/net/irda/pxaficp_ir.c
@@ -966,18 +966,7 @@ static struct platform_driver pxa_ir_driver = {
 	.resume		= pxa_irda_resume,
 };
 
-static int __init pxa_irda_init(void)
-{
-	return platform_driver_register(&pxa_ir_driver);
-}
-
-static void __exit pxa_irda_exit(void)
-{
-	platform_driver_unregister(&pxa_ir_driver);
-}
-
-module_init(pxa_irda_init);
-module_exit(pxa_irda_exit);
+module_platform_driver(pxa_ir_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:pxa2xx-ir");
diff --git a/drivers/net/irda/sh_irda.c b/drivers/net/irda/sh_irda.c
index d275e27..725d6b3 100644
--- a/drivers/net/irda/sh_irda.c
+++ b/drivers/net/irda/sh_irda.c
@@ -873,18 +873,7 @@ static struct platform_driver sh_irda_driver = {
 	},
 };
 
-static int __init sh_irda_init(void)
-{
-	return platform_driver_register(&sh_irda_driver);
-}
-
-static void __exit sh_irda_exit(void)
-{
-	platform_driver_unregister(&sh_irda_driver);
-}
-
-module_init(sh_irda_init);
-module_exit(sh_irda_exit);
+module_platform_driver(sh_irda_driver);
 
 MODULE_AUTHOR("Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>");
 MODULE_DESCRIPTION("SuperH IrDA driver");
diff --git a/drivers/net/irda/sh_sir.c b/drivers/net/irda/sh_sir.c
index ed7d7d6..e6661b5 100644
--- a/drivers/net/irda/sh_sir.c
+++ b/drivers/net/irda/sh_sir.c
@@ -808,18 +808,7 @@ static struct platform_driver sh_sir_driver = {
 	},
 };
 
-static int __init sh_sir_init(void)
-{
-	return platform_driver_register(&sh_sir_driver);
-}
-
-static void __exit sh_sir_exit(void)
-{
-	platform_driver_unregister(&sh_sir_driver);
-}
-
-module_init(sh_sir_init);
-module_exit(sh_sir_exit);
+module_platform_driver(sh_sir_driver);
 
 MODULE_AUTHOR("Kuninori Morimoto <morimoto.kuninori@renesas.com>");
 MODULE_DESCRIPTION("SuperH IrDA driver");
-- 
1.7.5.4




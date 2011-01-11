Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1AKMoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:44:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51682 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab1AKMom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:42 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 09/16] ARM: pxa: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:46 +0000
Message-Id: <1294749833-32019-10-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/pcmcia/pxa2xx_base.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
index 3755e7c..6e5b55e 100644
--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -16,6 +16,7 @@
 
   ======================================================================*/
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -297,8 +298,8 @@ static int pxa2xx_drv_pcmcia_probe(struct platform_device *dev)
 	}
 
 	clk = clk_get(&dev->dev, NULL);
-	if (!clk)
-		return -ENODEV;
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
 
 	pxa2xx_drv_pcmcia_ops(ops);
 
-- 
1.7.3.4


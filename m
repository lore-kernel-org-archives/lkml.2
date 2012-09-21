Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2IUHTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:19:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56785 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2IUHTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:19:10 -0400
MIME-Version: 1.0
Date: Fri, 21 Sep 2012 15:19:09 +0800
Message-ID: <CAPgLHd8ZQr2-1B2QcwO83gJNBrzw-WY1WWgWQJJCQYxirVAC2Q@mail.gmail.com>
Subject: [PATCH] ARM: pxa: fix return value check in pxa2xx_drv_pcmcia_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_get() returns ERR_PTR()
and never returns NULL pointer. The NULL test in the error
handling should be replaced with IS_ERR().

dpatch engine is used to auto generated this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pcmcia/pxa2xx_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
index 490bb82..cfec9dd 100644
--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -297,7 +297,7 @@ static int pxa2xx_drv_pcmcia_probe(struct platform_device *dev)
 	}
 
 	clk = clk_get(&dev->dev, NULL);
-	if (!clk)
+	if (IS_ERR(clk))
 		return -ENODEV;
 
 	pxa2xx_drv_pcmcia_ops(ops);



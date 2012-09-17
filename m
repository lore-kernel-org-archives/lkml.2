Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2IQR3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:29:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59482 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab2IQR24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:28:56 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: <herbert@gondor.hengli.com.au>
Cc: davem@davemloft.net, linus.walleij@linaro.org,
        andreas.westin@stericsson.com, rjw@sisk.pl, peter.senna@gmail.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] drivers/crypto/ux500/cryp/cryp_core.c: fix error return code
Date: Mon, 17 Sep 2012 19:28:25 +0200
Message-Id: <1347902908-19006-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 1c307e1..715c0fe 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1486,6 +1486,7 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 	if (!res_irq) {
 		dev_err(dev, "[%s]: IORESOURCE_IRQ unavailable",
 			__func__);
+		ret = -ENODEV;
 		goto out_power;
 	}
 
-- 
1.7.11.4


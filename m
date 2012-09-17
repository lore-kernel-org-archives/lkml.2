Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab2IQR32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:29:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65518 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2IQR3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:29:00 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: <herbert@gondor.hengli.com.au>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 4/4] drivers/crypto/tegra-aes.c: fix error return code
Date: Mon, 17 Sep 2012 19:28:28 +0200
Message-Id: <1347902908-19006-4-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347902908-19006-1-git-send-email-peter.senna@gmail.com>
References: <1347902908-19006-1-git-send-email-peter.senna@gmail.com>
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
 drivers/crypto/tegra-aes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 631149e5..37185e6 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -969,6 +969,7 @@ static int tegra_aes_probe(struct platform_device *pdev)
 	aes_wq = alloc_workqueue("tegra_aes_wq", WQ_HIGHPRI | WQ_UNBOUND, 1);
 	if (!aes_wq) {
 		dev_err(dev, "alloc_workqueue failed\n");
+		err = -ENOMEM;
 		goto out;
 	}
 
-- 
1.7.11.4

